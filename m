From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH/RFC] m68k: Uninline strchr()
Date: Sun, 09 Jan 2011 12:52:56 -0800
Message-ID: <1294606376.2895.176.camel@haakon2.linux-iscsi.org>
References: <alpine.DEB.2.00.1101091942230.26296@ayla.of.borg>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1101091942230.26296@ayla.of.borg>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux/m68k <linux-m68k@lists.linux-m68k.org>, Linux Kernel Development <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2011-01-09 at 19:42 +0100, Geert Uytterhoeven wrote:
> Some versions of gcc replace calls to strstr() with single-character
> "needle" string parameters by calls to strchr() behind our back.
> 
> If strchr() is defined as an inline function, this causes linking errors
> like
> 
> 	ERROR: "strchr" [drivers/target/target_core_mod.ko] undefined!
> 
> As m68k is the only architecture that has an inline strchr() and this
> inline version is not an optimized asm version, uninline strchr() and use
> the standard out-of-line C version in lib/string.c instead.
> 
> This also decreases the defconfig/allmodconfig kernel image sizes by a few
> hundred bytes.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Hi Geert,

Thanks for taking the time to fix this up in m68k code.  As m68k is one
of the last architectures that target code has yet to run on, I am
excited to see this finally happen.  ;)

Best Regards,

Reviewed-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

> 
> diff --git a/arch/m68k/include/asm/string.h b/arch/m68k/include/asm/string.h
> index 2936dda..65b1312 100644
> --- a/arch/m68k/include/asm/string.h
> +++ b/arch/m68k/include/asm/string.h
> @@ -81,18 +81,6 @@ static inline char *strncpy(char *dest, const char *src, size_t n)
>  	strcpy(__d + strlen(__d), (s));		\
>  })
>  
> -#define __HAVE_ARCH_STRCHR
> -static inline char *strchr(const char *s, int c)
> -{
> -	char sc, ch = c;
> -
> -	for (; (sc = *s++) != ch; ) {
> -		if (!sc)
> -			return NULL;
> -	}
> -	return (char *)s - 1;
> -}
> -
>  #ifndef CONFIG_COLDFIRE
>  #define __HAVE_ARCH_STRCMP
>  static inline int strcmp(const char *cs, const char *ct)
