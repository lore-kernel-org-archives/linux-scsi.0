From: "Ju, Seokmann" <sju@lsil.com>
Subject: RE: [PATCH] Convert megaraid2 to compat_ioctl
Date: Thu, 3 Feb 2005 11:01:39 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570366266B@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:11240 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S263566AbVBCQCI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2005 11:02:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Andi Kleen' <ak@muc.de>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Tuesday, January 18, 2005 6:17 AM, Andi wrote:
> Convert megaraid2 driver to new compat_ioctl entry points.
> 
> I don't have easy access to hardware, so only compile tested.

Thanks for your feedback and appreciate changes you've made.
The changes look great to me.  
One question, though, any reason to have 'lock_kernel'?
Isn't it too huge to use, here?
It could lead system hung if ioctl goes to sleep for some reason.

Thanks,

Seokmann
LSI Logic Co.

> -----Original Message-----
> From: Andi Kleen [mailto:ak@muc.de]
> Sent: Tuesday, January 18, 2005 6:17 AM
> To: James.Bottomley@HansenPartnership.com; linux-scsi@vger.kernel.org
> Subject: [PATCH] Convert megaraid2 to compat_ioctl
> 
> Convert megaraid2 driver to new compat_ioctl entry points.
> 
> I don't have easy access to hardware, so only compile tested.
> 
> Signed-off-by: Andi Kleen <ak@muc.de>
> 
> diff -u linux-2.6.11-rc1-bk4/drivers/scsi/megaraid/megaraid_mm.c-o linux-
> 2.6.11-rc1-bk4/drivers/scsi/megaraid/megaraid_mm.c
> --- linux-2.6.11-rc1-bk4/drivers/scsi/megaraid/megaraid_mm.c-o
2005-01-
> 04 12:13:06.000000000 +0100
> +++ linux-2.6.11-rc1-bk4/drivers/scsi/megaraid/megaraid_mm.c	2005-01-
> 18 06:28:34.000000000 +0100
> @@ -16,6 +16,7 @@
>   */
> 
>  #include "megaraid_mm.h"
> +#include <linux/smp_lock.h>
> 
> 
>  // Entry points for char node driver
> @@ -43,8 +44,7 @@
>  static void mraid_mm_teardown_dma_pools(mraid_mmadp_t *);
> 
>  #ifdef CONFIG_COMPAT
> -static int mraid_mm_compat_ioctl(unsigned int, unsigned int, unsigned
> long,
> -		struct file *);
> +static long mraid_mm_compat_ioctl(struct file *, unsigned int, unsigned
> long);
>  #endif
> 
>  MODULE_AUTHOR("LSI Logic Corporation");
> @@ -70,6 +70,9 @@
>  static struct file_operations lsi_fops = {
>  	.open	= mraid_mm_open,
>  	.ioctl	= mraid_mm_ioctl,
> +#ifdef CONFIG_COMPAT
> +	.compat_ioctl = mraid_mm_compat_ioctl,
> +#endif
>  	.owner	= THIS_MODULE,
>  };
> 
> @@ -1180,8 +1183,6 @@
> 
>  	INIT_LIST_HEAD(&adapters_list_g);
> 
> -	register_ioctl32_conversion(MEGAIOCCMD, mraid_mm_compat_ioctl);
> -
>  	return 0;
>  }
> 
> @@ -1190,13 +1191,15 @@
>   * mraid_mm_compat_ioctl	: 32bit to 64bit ioctl conversion routine
>   */
>  #ifdef CONFIG_COMPAT
> -static int
> -mraid_mm_compat_ioctl(unsigned int fd, unsigned int cmd,
> -			unsigned long arg, struct file *filep)
> -{
> -	struct inode *inode = filep->f_dentry->d_inode;
> -
> -	return mraid_mm_ioctl(inode, filep, cmd, arg);
> +static long
> +mraid_mm_compat_ioctl(struct file *filep, unsigned int cmd,
> +		      unsigned long arg)
> +{
> +	int err;
> +	lock_kernel();
> +	err = mraid_mm_ioctl(NULL, filep, cmd, arg);
> +	unlock_kernel();
> +	return err;
>  }
>  #endif
> 
> @@ -1209,7 +1212,6 @@
>  	con_log(CL_DLEVEL1 , ("exiting common mod\n"));
> 
>  	unregister_chrdev(majorno, "megadev");
> -	unregister_ioctl32_conversion(MEGAIOCCMD);
>  }
> 
>  module_init(mraid_mm_init);
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
