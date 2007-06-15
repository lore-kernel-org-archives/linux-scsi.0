From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch 1/6] ps3: Preallocate bootmem memory for the PS3 FLASH
	ROM storage driver
Date: Fri, 15 Jun 2007 23:27:19 +1000
Message-ID: <1181914039.26853.80.camel@localhost.localdomain>
References: <20070615113919.142332000@pademelon.sonytel.be>
	 <20070615120848.002575000@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:40288 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380AbXFON17 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jun 2007 09:27:59 -0400
In-Reply-To: <20070615120848.002575000@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 13:39 +0200, Geert Uytterhoeven wrote:
> plain text document attachment (ps3-stable)
> Preallocate 256 KiB of bootmem memory for the PS3 FLASH ROM storage driver.

I still very much dislike the #ifdef xxx_MODULE in main kernel code.

At the end of the day, is it realistic to ever use a PS3 without the
storage driver ? I would suggest just allocating those unconditionally.

Ben.

> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
> ---
>  arch/powerpc/platforms/ps3/setup.c |   19 ++++++++++++++++++-
>  include/asm-powerpc/ps3.h          |    1 +
>  2 files changed, 19 insertions(+), 1 deletion(-)
> 
> --- a/arch/powerpc/platforms/ps3/setup.c
> +++ b/arch/powerpc/platforms/ps3/setup.c
> @@ -107,7 +107,8 @@ static void ps3_panic(char *str)
>  	while(1);
>  }
>  
> -#if defined(CONFIG_FB_PS3) || defined(CONFIG_FB_PS3_MODULE)
> +#if defined(CONFIG_FB_PS3) || defined(CONFIG_FB_PS3_MODULE) || \
> +    defined(CONFIG_PS3_FLASH) || defined(CONFIG_PS3_FLASH_MODULE)
>  static void prealloc(struct ps3_prealloc *p)
>  {
>  	if (!p->size)
> @@ -123,7 +124,9 @@ static void prealloc(struct ps3_prealloc
>  	printk(KERN_INFO "%s: %lu bytes at %p\n", p->name, p->size,
>  	       p->address);
>  }
> +#endif
>  
> +#if defined(CONFIG_FB_PS3) || defined(CONFIG_FB_PS3_MODULE)
>  struct ps3_prealloc ps3fb_videomemory = {
>  	.name = "ps3fb videomemory",
>  	.size = CONFIG_FB_PS3_DEFAULT_SIZE_M*1024*1024,
> @@ -146,6 +149,18 @@ early_param("ps3fb", early_parse_ps3fb);
>  #define prealloc_ps3fb_videomemory()	do { } while (0)
>  #endif
>  
> +#if defined(CONFIG_PS3_FLASH) || defined(CONFIG_PS3_FLASH_MODULE)
> +struct ps3_prealloc ps3flash_bounce_buffer = {
> +	.name = "ps3flash bounce buffer",
> +	.size = 256*1024,
> +	.align = 256*1024
> +};
> +EXPORT_SYMBOL_GPL(ps3flash_bounce_buffer);
> +#define prealloc_ps3flash_bounce_buffer()	prealloc(&ps3flash_bounce_buffer)
> +#else
> +#define prealloc_ps3flash_bounce_buffer()	do { } while (0)
> +#endif
> +
>  static int ps3_set_dabr(u64 dabr)
>  {
>  	enum {DABR_USER = 1, DABR_KERNEL = 2,};
> @@ -175,6 +190,8 @@ static void __init ps3_setup_arch(void)
>  #endif
>  
>  	prealloc_ps3fb_videomemory();
> +	prealloc_ps3flash_bounce_buffer();
> +
>  	ppc_md.power_save = ps3_power_save;
>  
>  	DBG(" <- %s:%d\n", __func__, __LINE__);
> --- a/include/asm-powerpc/ps3.h
> +++ b/include/asm-powerpc/ps3.h
> @@ -427,6 +427,7 @@ struct ps3_prealloc {
>  };
>  
>  extern struct ps3_prealloc ps3fb_videomemory;
> +extern struct ps3_prealloc ps3flash_bounce_buffer;
>  
> 
>  #endif
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev

