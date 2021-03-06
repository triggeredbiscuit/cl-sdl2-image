(in-package :sdl2-image)

(define-condition sdl-image-error (sdl2::sdl-rc-error) ())

(defmacro check-rc (form)
  (with-gensyms (rc)
    `(let ((,rc ,form))
       (when (< ,rc 0)
         (error 'sdl-image-error :rc ,rc :string (sdl-get-error)))
       ,rc)))

(defmacro check-non-zero (form)
  (with-gensyms (rc)
    `(let ((,rc ,form))
       (unless (/= ,rc 0)
         (error 'sdl-image-error :rc ,rc :string (sdl-get-error)))
       ,rc)))

(defmacro check-true (form)
  (with-gensyms (rc)
    `(let ((,rc ,form))
       (unless (sdl-true-p ,rc)
         (error 'sdl-image-error :rc ,rc :string (sdl-get-error)))
       ,rc)))

(defmacro check-null (form)
  (with-gensyms (wrapper)
    `(let ((,wrapper ,form))
       (if (cffi:null-pointer-p (autowrap:ptr ,wrapper))
           (error 'sdl-image-error :rc ,wrapper :string (sdl-get-error))
           ,wrapper))))

(defmacro check= (value-form check-form)
  (with-gensyms (rc)
    `(let ((,rc ,check-form))
       (unless (= ,rc ,value-form)
         (error 'sdl-image-error :rc ,rc :string (sdl-get-error)))
       t)))
