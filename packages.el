;;; packages.el --- Install and configure scimax packages -*- lexical-binding: t -*-
;;; Commentary:
;;
;; This is a starter kit for scimax. This package provides a
;; customized setup for emacs that we use daily for scientific
;; programming and publication.
;;
;; see https://github.com/jwiegley/use-package for details on use-package


;;; Code:

(setq use-package-always-ensure t)

;; * org-mode
;; To upgrade org, run this command in a shell, with no emacs open
;; emacs -Q -batch -eval "(progn (require 'package) (package-initialize) (package-refresh-contents) (package-upgrade 'org))"
;; Built-in org is removed in bootstrap.el, and we install from GNU ELPA
(use-package org
  :ensure t
  :init
  (setq
   ;; Use the current window for C-c ' source editing
   org-src-window-setup 'current-window
   org-support-shift-select t
   ;; I like to press enter to follow a link. mouse clicks also work.
   org-return-follows-link t)
  :bind
  (("C-c L" . org-insert-link-global)
   ("C-c l" . org-store-link)
   ("C-c o" . org-open-at-point-global)
   ("C-c c" . org-capture)
   ("M-<SPC>" . org-mark-ring-goto)
   ("H-." . org-time-stamp-inactive)))

;; * Other packages
;; Diminish minor modes that clutter the modeline
(use-package diminish)

;; Automatically keep code indented
(use-package aggressive-indent
  :config (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode))

;; Easy navigation to visible text using avy
(use-package avy)

;; May 24, 2017: this seems to be causing emacs 25.2 to be crashing on my linux box.
(unless (eq system-type 'gnu/linux)
  (use-package tex
    :ensure auctex))

;; Bookmark autosave every minute
(use-package bookmark
  :init
  (setq bookmark-save-flag 1))

;; Buttons in buffers
(use-package button-lock)

;; Potential for commandline scripts using emacs
(use-package commander
  :disabled t)

;; Enhanced minibuffer completion and narrowing framework
(use-package swiper
  :bind
  ("H-s" . swiper-all)
  :diminish ivy-mode
  :config
  (ivy-mode)
  (define-key global-map [remap isearch-forward]
	      (if (executable-find "grep")
		  'counsel-grep-or-swiper
		'swiper)))

;; Multiple cursors
;; (use-package multiple-cursors
;;   :config
;;   ;; mc/cmds-to-run-once is defined in `lispy'.
;;   (add-to-list 'mc/cmds-to-run-once 'swiper-mc))

;; Various ivy/counsel enhancements
(use-package counsel
  :init
  (require 'ivy)
  (setq projectile-completion-system 'ivy)
  (setq ivy-use-virtual-buffers t)
  (define-prefix-command 'counsel-prefix-map)
  (global-set-key (kbd "H-c") 'counsel-prefix-map)

  ;; default pattern ignores order.
  (setf (cdr (assoc t ivy-re-builders-alist))
	'ivy--regex-ignore-order)
  :bind
  (("M-x" . counsel-M-x)
   ("C-x b" . ivy-switch-buffer)
   ("C-x C-b" . counsel-ibuffer)
   ("C-x d" . counsel-dired)
   ("C-x C-f" . counsel-find-file)
   ("<f7>" . counsel-recentf)
   ("C-x f" . counsel-recentf)
   ("C-x l" . counsel-locate)
   ("C-x p" . counsel-projectile)
   ("C-h f" . counsel-describe-function)
   ("C-h v" . counsel-describe-variable)
   ("C-h i" . counsel-info-lookup-symbol)
   ("C-c r" . ivy-resume)
   ("H-c r" . ivy-resume)
   ("s-r" . ivy-resume)
   ("H-r" . ivy-resume)
   ("H-c l" . counsel-load-library)
   ("H-c f" . counsel-find-library)
   ("H-c g" . counsel-git-grep)
   ("H-c a" . counsel-ag)
   ("H-c p" . counsel-pt))
  :diminish ""
  :config
  (counsel-mode))

;; Ivy integration with avy
(use-package ivy-avy)

;; Projectile integration with counsel
(use-package counsel-projectile)

;; Provides functions for working on lists
(use-package dash)

;; Emacs Dashboard - a nice start screen for Emacs
(use-package dashboard)

;; Emacs RSS reader - I am not using this currently
;; (use-package elfeed)

;; Emacs Start Up Profiler - seems broken with emacs 28+
;; (use-package esup)

;; Provides functions for working with files
(use-package f)

;; https://github.com/amperser/proselint
;; pip install proselint
(use-package flycheck
  ;; Jun 28 - I like this idea, but sometimes this is too slow.
  :config
  (add-hook 'text-mode-hook #'flycheck-mode)
  (add-hook 'org-mode-hook #'flycheck-mode)
  (define-key flycheck-mode-map (kbd "s-;") 'flycheck-previous-error))

;; Fuzzy matching for Emacs
(use-package flx)

;; Git commit message editing enhancements
(use-package git-messenger
  :bind ("C-x v o" . git-messenger:popup-message))

;; google-this
(use-package google-this
  :config
  (google-this-mode 1))

;; Functions for working with hash tables
(use-package ht)

;; Exporting syntax highlighted code to HTML
(use-package htmlize)

;; Create and manage hydras - transient keymaps are slowly replacing these
(use-package hydra
  :init
  (setq hydra-is-helpful t)

  :config
  (require 'hydra-ox))

;; Ivy integration with hydra
(use-package ivy-hydra)

;; Superior lisp editing
(use-package lispy
  :config
  (dolist (hook '(emacs-lisp-mode-hook
		  hy-mode-hook))
    (add-hook hook
	      (lambda ()
		(lispy-mode)
		(eldoc-mode)))))

;; Git interface for Emacs
(use-package magit
  :init
  (setq magit-completing-read-function 'ivy-completing-read)
  :bind
  (("<f5>" . magit-status)
   ("C-c v t" . magit-status)
   :map magit-status-mode-map
   ("s" . magit-stage)
   ("u" . magit-unstage)
   ("k" . magit-discard)))

;; Move lines or regions up and down
(use-package move-text
  :init (move-text-default-bindings))

;; Templating system
;; https://github.com/Wilfred/mustache.el
(use-package mustache)

(when (executable-find "jupyter")
  (use-package jupyter)
  (use-package scimax-jupyter :load-path scimax-dir))


;; Overlay library
(use-package ov)

;; PDF viewer and annotator for Emacs - this probably gets loaded by org-ref
;; (use-package pdf-tools)

;; Packages for working with bibliographies
(use-package parsebib)

;; Ivy interface for managing and inserting bibtex citations
(use-package ivy-bibtex)

;; Citeproc for Emacs - CSL citation processor
(use-package citeproc)

;; Org-ref - citations, cross-references and bibliographies in org-mode
(use-package org-ref
  :init
  (require 'bibtex)
  (setq bibtex-autokey-year-length 4
	bibtex-autokey-name-year-separator "-"
	bibtex-autokey-year-title-separator "-"
	bibtex-autokey-titleword-separator "-"
	bibtex-autokey-titlewords 2
	bibtex-autokey-titlewords-stretch 1
	bibtex-autokey-titleword-length 5)
  (define-key bibtex-mode-map (kbd "H-b") 'org-ref-bibtex-hydra/body)
  (define-key org-mode-map (kbd "C-c ]") 'org-ref-insert-link)
  (define-key org-mode-map (kbd "s-[") 'org-ref-insert-link-hydra/body))

;; Ivy interface for org-ref
(use-package org-ref-ivy
  :load-path (lambda () (file-name-directory (locate-library "org-ref")))
  :init (setq org-ref-insert-link-function 'org-ref-insert-link-hydra/body
	      org-ref-insert-cite-function 'org-ref-cite-insert-ivy
	      org-ref-insert-label-function 'org-ref-insert-label-link
	      org-ref-insert-ref-function 'org-ref-insert-ref-link
	      org-ref-cite-onclick-function (lambda (_) (org-ref-citation-hydra/body))))

;; Pandoc exporter for org-mode
(use-package ox-pandoc)


;; https://github.com/bbatsov/projectile
;; Project interaction library for Emacs
(use-package projectile
  :bind
  ("C-c pp" . counsel-projectile-switch-project)
  ("C-c pb" . counsel-projectile-switch-to-buffer)
  ("C-c pf" . counsel-projectile-find-file)
  ("C-c pd" . counsel-projectile-find-dir)
  ("C-c pg" . counsel-projectile-grep)
  ("C-c ph" . ivy-org-jump-to-project-headline)
  ("C-c pG" . counsel-projectile-git-grep)
  ("C-c pa" . counsel-projectile-ag)
  ("C-c pr" . counsel-projectile-rg)
  ("C-c pk" . projectile-kill-buffers)
  ;; nothing good in the modeline to keep.
  :diminish ""
  :config
  (define-key projectile-mode-map (kbd "H-p") 'projectile-command-map)
  (projectile-global-mode))

;; Python documentation lookup
(use-package pydoc)

;; Colorize color names in buffers
(use-package rainbow-mode)

;; Recent files management
(use-package recentf
  :config
  (setq recentf-exclude
        '("COMMIT_MSG" "COMMIT_EDITMSG" "github.*txt$"
          ".*png$" "\\*message\\*" "auto-save-list\\*"))
  (setq recentf-max-saved-items 60))


;; Functions for working with strings
(use-package s)

;; Smart mode line - a better modeline for Emacs
(use-package smart-mode-line
  :config
  (setq sml/no-confirm-load-theme t)
  (setq sml/theme 'light)
  (sml/setup))

;; keep recent commands available in M-x
(use-package smex)

;; Undo tree - visualize undo history
(use-package undo-tree
  :diminish undo-tree-mode
  :config (global-undo-tree-mode))

;; Note ws-butler-global-mode causes some issue with org-ref ref links. If you
;; are right after one you cannot add a space without getting a new line.
(use-package ws-butler)

;; Snippet expansion
(use-package yasnippet)

;; Ivy integration with yasnippet
(use-package ivy-yasnippet
  :bind ("H-," . ivy-yasnippet))

;; * Treesitter

;; Tree-sitter for Emacs - incremental parsing system for programming tools
(use-package tree-sitter)

;; Tree-sitter language definitions
(use-package tree-sitter-langs
  :config
  ;;;  as of emacs 31, this should no longer be necessary, ansd the 
  ;; (setq treesit-language-source-alist
  ;; 	'((bash "https://github.com/tree-sitter/tree-sitter-bash")
  ;;         (python "https://github.com/tree-sitter/tree-sitter-python")
  ;;         (json "https://github.com/tree-sitter/tree-sitter-json")
  ;;         (html "https://github.com/tree-sitter/tree-sitter-html")
  ;; 	  (css "https://github.com/tree-sitter/tree-sitter-css"))
  ;; 	major-mode-remap-alist
  ;; 	'((python-mode . python-ts-mode)
  ;;         (json-mode . json-ts-mode)
  ;;         (css-mode . css-ts-mode)
  ;; 	  (html-mode . html-ts-mode)
  ;;         (bash-mode . bash-ts-mode))
  ;; 	)
  )
  

  ;; * Scimax packages
  ;; Scimax - an Emacs environment for scientific programming and writing
  (use-package scimax
    :ensure nil
    :load-path scimax-dir
    :init (require 'scimax))

;; Scimax major mode for enhanced org-mode experience
(use-package scimax-mode
  :ensure nil
  :load-path scimax-dir
  :init (require 'scimax-mode)
  :config (scimax-mode))

;; Scimax org-mode extensions
(use-package scimax-org
  :ensure nil
  :load-path scimax-dir
  :bind
  ("s--" . org-subscript-region-or-point)
  ("s-=" . org-superscript-region-or-point)
  ("s-i" . org-italics-region-or-point)
  ("s-b" . org-bold-region-or-point)
  ("s-v" . org-verbatim-region-or-point)
  ("s-c" . org-code-region-or-point)
  ("s-u" . org-underline-region-or-point)
  ("s-+" . org-strikethrough-region-or-point)
  ("s-4" . org-latex-math-region-or-point)
  ("s-e" . ivy-insert-org-entity)
  ("s-\"" . org-double-quote-region-or-point)
  ("s-'" . org-single-quote-region-or-point)
  :init
  (require 'scimax-org))

;; Org export to clipboard in various formats
(use-package ox-clip
  :ensure t
  :bind ("H-k" . ox-clip-formatted-copy))

;; Scimax email integration
(use-package scimax-email
  :ensure nil
  :load-path scimax-dir)

;; Scimax Projectile integration
(use-package scimax-projectile
  :ensure nil
  :load-path scimax-dir)

;; Choose between jinx (modern, faster) or traditional spellcheck
;; Set this to nil to use the traditional scimax-spellcheck with ispell/aspell
(defcustom scimax-use-jinx t
  "When non-nil, use jinx for spell checking. Otherwise use traditional ispell/aspell."
  :type 'boolean
  :group 'scimax)

(if scimax-use-jinx
    ;; scimax-jinx will check for enchant and conditionally load jinx
    (use-package scimax-jinx
      :ensure nil
      :load-path scimax-dir)
  (use-package scimax-spellcheck
    :ensure nil
    :load-path scimax-dir))

;; Load the scimax notebook system
(org-babel-load-file (expand-file-name "scimax-notebook.org" scimax-dir))

;; Various scimax utilities
(use-package scimax-utils
  :ensure nil
  :load-path scimax-dir
  :bind ( "<f9>" . hotspots))

;; Bibtex hotkeys for easier editing of bibtex files
(use-package bibtex-hotkeys
  :ensure nil
  :load-path scimax-dir)

;; Org export for manuscripts
(use-package ox-manuscript
  :ensure nil
  :load-path (lambda () (expand-file-name "ox-manuscript" scimax-dir)))

;; Org-show for displaying images and other content inline
(use-package org-show
  :ensure nil
  :load-path (lambda () (expand-file-name "org-show" scimax-dir)))

;; Word utilities and hydra
(use-package words
  :ensure nil
  :load-path scimax-dir
  :bind ("H-w" . words-hydra/body))

(use-package ore
  :ensure nil
  :load-path scimax-dir
  :bind ("H-o" . ore))

;; Scimax ivy enhancements
(use-package scimax-ivy
  :ensure nil
  :load-path scimax-dir)

;; Scimax yasnippet extensions
(use-package scimax-yas
  :ensure nil
  :load-path scimax-dir)

;; Autoformatting abbreviations
(use-package scimax-autoformat-abbrev
  :ensure nil
  :load-path scimax-dir)

;; Hydras for scimax
(use-package scimax-hydra
  :ensure nil
  :load-path scimax-dir
  :bind ("<f12>" . scimax/body))

;; Journal management in scimax
(use-package scimax-journal
  :ensure nil
  :load-path scimax-dir)

;; Scimax applications
(use-package scimax-apps
  :ensure nil
  :load-path scimax-dir)

;; Scimax org-babel extensions
(use-package scimax-ob
  :ensure nil
  :load-path scimax-dir)

;; Scimax editmarks
(let ((enable-local-variables nil))
  (org-babel-load-file (expand-file-name "scimax-editmarks.org" scimax-dir)))

;; Add scimax info files to the info path
(add-to-list 'Info-directory-list scimax-dir)

;; * The end
(provide 'packages)

;;; packages.el ends here
