From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] aacraid 32/64 ioctl support (update)
Date: Wed, 16 Jun 2004 17:01:07 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040616160107.GA14144@infradead.org>
References: <1087401137.13488.61.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:44443 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S264088AbUFPQBL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 12:01:11 -0400
Content-Disposition: inline
In-Reply-To: <1087401137.13488.61.camel@markh1.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Wed, Jun 16, 2004 at 08:52:17AM -0700, Mark Haverkamp wrote:
> +		if (retval != 0) {

the != 0 is superflous.

> -	if( dev->pae_support ==1 ) {
> +	if(dev->pae_support == 1) {

if you're fixing up the strange style in the driver please go to the right
indentation directly (space before opening brace)

> +++ edited/drivers/scsi/aacraid/linit.c	2004-06-15 15:39:05 -07:00
> @@ -42,6 +42,7 @@
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
>  #include <asm/semaphore.h>
> +#include <linux/syscalls.h>

<linux/*.h> before <asm/*.h> please

>  #include <scsi/scsi_tcq.h>
>  #include <scsi/scsicam.h>
>  #include <scsi/scsi_eh.h>
> +#if (defined(CONFIG_COMPAT))
> +# include <linux/ioctl32.h>
> +#endif

ioctl32.h should be fine to include even without CONFIG_COMPAT

>  
>  #include "aacraid.h"
>  
> @@ -168,6 +172,30 @@
>  	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2025SA      ", 1 }, /* ASR-2025SA      (ZCR DIMM SATA) */
>  };
>  
> +#if (defined(CONFIG_COMPAT))

just ifdef instead of all those braces.

> +/* 
> + * Promote 32 bit apps that call get_next_adapter_fib_ioctl to 64 bit version 
> + */
> +int aac_get_next_adapter_fib_ioctl(unsigned int fd, unsigned int cmd, 
> +		unsigned long arg, struct file *file)
> +{
> +	struct fib_ioctl f;
> +	mm_segment_t fs;
> +	int retval;
> +
> +	memset (&f, 0, sizeof(f));
> +	if(copy_from_user((void *)&f, (void *)arg, 
> +				sizeof(struct fib_ioctl) - sizeof(u32)))
> +		return -EFAULT;
> +	fs = get_fs();
> +	set_fs(get_ds());
> +	retval = sys_ioctl(fd, cmd, (unsigned long)&f);
> +	set_fs(fs);
> +	return retval;

use compat_alloc_userspace here.

> @@ -643,12 +671,39 @@
>  		printk(KERN_WARNING
>  		       "aacraid: unable to register \"aac\" device.\n");
>  	}
> +#	if (defined(CONFIG_COMPAT))
> +		register_ioctl32_conversion(FSACTL_MINIPORT_REV_CHECK, NULL);
> +		register_ioctl32_conversion(FSACTL_SENDFIB, NULL);
> +		register_ioctl32_conversion(FSACTL_OPEN_GET_ADAPTER_FIB, NULL);
> +		register_ioctl32_conversion(FSACTL_GET_NEXT_ADAPTER_FIB, 
> +			aac_get_next_adapter_fib_ioctl);
> +		register_ioctl32_conversion(FSACTL_CLOSE_GET_ADAPTER_FIB, NULL);
> +		register_ioctl32_conversion(FSACTL_SEND_RAW_SRB, NULL);
> +		register_ioctl32_conversion(FSACTL_GET_PCI_INFO, NULL);
> +		register_ioctl32_conversion(FSACTL_QUERY_DISK, NULL);
> +		register_ioctl32_conversion(FSACTL_DELETE_DISK, NULL);
> +		register_ioctl32_conversion(FSACTL_FORCE_DELETE_DISK, NULL);
> +		register_ioctl32_conversion(2131, NULL);
> +#	endif

#ifdef please and no additional indentation inside the ifdef please.

>  static void __exit aac_exit(void)
>  {
> +#	if (defined(CONFIG_COMPAT))
> +		unregister_ioctl32_conversion(FSACTL_MINIPORT_REV_CHECK);
> +		unregister_ioctl32_conversion(FSACTL_SENDFIB);
> +		unregister_ioctl32_conversion(FSACTL_OPEN_GET_ADAPTER_FIB);
> +		unregister_ioctl32_conversion(FSACTL_GET_NEXT_ADAPTER_FIB);
> +		unregister_ioctl32_conversion(FSACTL_CLOSE_GET_ADAPTER_FIB);
> +		unregister_ioctl32_conversion(FSACTL_SEND_RAW_SRB);
> +		unregister_ioctl32_conversion(FSACTL_GET_PCI_INFO);
> +		unregister_ioctl32_conversion(FSACTL_QUERY_DISK);
> +		unregister_ioctl32_conversion(FSACTL_DELETE_DISK);
> +		unregister_ioctl32_conversion(FSACTL_FORCE_DELETE_DISK);
> +		unregister_ioctl32_conversion(2131);
> +#	endif

dito.

