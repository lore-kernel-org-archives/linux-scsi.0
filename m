From: Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: Re: [PATCH v3 1/7] lib: string: add functions to case-convert strings
Date: Sat, 09 Jul 2016 13:04:54 +0100
Message-ID: <5780E866.8000001@osg.samsung.com>
References: <1468017794-4818-1-git-send-email-mmayer@broadcom.com> <1468017794-4818-2-git-send-email-mmayer@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1468017794-4818-2-git-send-email-mmayer@broadcom.com>
Sender: linux-pm-owner@vger.kernel.org
To: Markus Mayer <mmayer@broadcom.com>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Chris Metcalf <cmetcalf@ezchip.com>, Kees Cook <keescook@chromium.org>
Cc: devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, nouveau@lists.freedesktop.org, speakup@linux-speakup.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-acpi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/07/16 23:43, Markus Mayer wrote:
> Add a collection of generic functions to convert strings to lowercase
> or uppercase.
> 
> Changing the case of a string (with or without copying it first) seems
> to be a recurring requirement in the kernel that is currently being
> solved by several duplicated implementations doing the same thing. This
> change aims at reducing this code duplication.
> 
> The new functions are
>     void strlcpytoupper(char *dst, const char *src, size_t len);
>     void strlcpytolower(char *dst, const char *src, size_t len);
>     void strcpytoupper(char *dst, const char *src);
>     void strcpytolower(char *dst, const char *src);
>     void strtoupper(char *s);
>     void strtolower(char *s);
> 
> The "str[l]cpyto*" versions of the function take a destination string
> and a source string as arguments. The "strlcpyto*" versions additionally
> take a length argument like strlcpy() itself. Lastly, the strto*
> functions take a single string argument and modify the passed-in string.
> 
> Like strlcpy(), and unlike strncpy(), the functions guarantee NULL
> termination of the destination string.
> 
> Signed-off-by: Markus Mayer <mmayer@broadcom.com>
> ---
>  include/linux/string.h | 40 ++++++++++++++++++++++++++++++++++++++++
>  lib/string.c           | 38 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 78 insertions(+)
> 
> diff --git a/include/linux/string.h b/include/linux/string.h
> index 26b6f6a..36c9d14 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -116,6 +116,8 @@ extern void * memchr(const void *,int,__kernel_size_t);
>  #endif
>  void *memchr_inv(const void *s, int c, size_t n);
>  char *strreplace(char *s, char old, char new);
> +extern void strlcpytoupper(char *dst, const char *src, size_t len);
> +extern void strlcpytolower(char *dst, const char *src, size_t len);
>  
>  extern void kfree_const(const void *x);
>  
> @@ -169,4 +171,42 @@ static inline const char *kbasename(const char *path)
>  	return tail ? tail + 1 : path;
>  }
>  
> +/**
> + * strcpytoupper - Copy string and convert to uppercase.
> + * @dst: The buffer to store the result.
> + * @src: The string to convert to uppercase.
> + */
> +static inline void strcpytoupper(char *dst, const char *src)
> +{
> +	strlcpytoupper(dst, src, -1);
> +}
> +

Why not use SIZE_MAX instead of -1?

> +/**
> + * strcpytolower - Copy string and convert to lowercase.
> + * @dst: The buffer to store the result.
> + * @src: The string to convert to lowercase.
> + */
> +static inline void strcpytolower(char *dst, const char *src)
> +{
> +	strlcpytolower(dst, src, -1);
> +}
> +

Same here, and the 2 below :)

Thanks Markus,
Luis

> +/**
> + * strtoupper - Convert string to uppercase.
> + * @s: The string to operate on.
> + */
> +static inline void strtoupper(char *s)
> +{
> +	strlcpytoupper(s, s, -1);
> +}
> +
> +/**
> + * strtolower - Convert string to lowercase.
> + * @s: The string to operate on.
> + */
> +static inline void strtolower(char *s)
> +{
> +	strlcpytolower(s, s, -1);
> +}
> +
>  #endif /* _LINUX_STRING_H_ */
> diff --git a/lib/string.c b/lib/string.c
> index ed83562..fd8c427 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -952,3 +952,41 @@ char *strreplace(char *s, char old, char new)
>  	return s;
>  }
>  EXPORT_SYMBOL(strreplace);
> +
> +/**
> + * strlcpytoupper - Copy a length-limited string and convert to uppercase.
> + * @dst: The buffer to store the result.
> + * @src: The string to convert to uppercase.
> + * @len: Maximum string length. May be SIZE_MAX (-1) to set no limit.
> + */
> +void strlcpytoupper(char *dst, const char *src, size_t len)
> +{
> +	size_t i;
> +
> +	if (!len)
> +		return;
> +
> +	for (i = 0; i < len && src[i]; ++i)
> +		dst[i] = toupper(src[i]);
> +	dst[i < len ? i : i - 1] = '\0';
> +}
> +EXPORT_SYMBOL(strlcpytoupper);
> +
> +/**
> + * strlcpytolower - Copy a length-limited string and convert to lowercase.
> + * @dst: The buffer to store the result.
> + * @src: The string to convert to lowercase.
> + * @len: Maximum string length. May be SIZE_MAX (-1) to set no limit.
> + */
> +void strlcpytolower(char *dst, const char *src, size_t len)
> +{
> +	size_t i;
> +
> +	if (!len)
> +		return;
> +
> +	for (i = 0; i < len && src[i]; ++i)
> +		dst[i] = tolower(src[i]);
> +	dst[i < len ? i : i - 1] = '\0';
> +}
> +EXPORT_SYMBOL(strlcpytolower);
> 

