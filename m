From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 07/25] scsi: cover up bugs^W^W^WFix up compiler
	warnings in megaraid driver
Date: Wed, 23 May 2007 17:52:40 -0500
Message-ID: <1179960760.5569.45.camel@mulgrave.il.steeleye.com>
References: <200705232141.l4NLfd1N001178@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:51781 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755293AbXEWWwm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2007 18:52:42 -0400
In-Reply-To: <200705232141.l4NLfd1N001178@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, megaraidlinux@lsi.com
Cc: linux-scsi@vger.kernel.org, mbligh@google.com

On Wed, 2007-05-23 at 14:41 -0700, akpm@linux-foundation.org wrote:
> From: Martin Bligh <mbligh@google.com>
> 
> Fix up compiler warnings in megaraid driver
> 
> [akpm@osdl.org: build fix]
> Signed-off-by: Martin J. Bligh <mbligh@google.com>
> Cc: James Bottomley <James.Bottomley@steeleye.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/scsi/megaraid.c |   22 +++++++++++++---------
>  1 files changed, 13 insertions(+), 9 deletions(-)
> 
> diff -puN drivers/scsi/megaraid.c~scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver drivers/scsi/megaraid.c
> --- a/drivers/scsi/megaraid.c~scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver
> +++ a/drivers/scsi/megaraid.c
> @@ -73,10 +73,14 @@ static unsigned short int max_mbox_busy_
>  module_param(max_mbox_busy_wait, ushort, 0);
>  MODULE_PARM_DESC(max_mbox_busy_wait, "Maximum wait for mailbox in microseconds if busy (default=MBOX_BUSY_WAIT=10)");
>  
> -#define RDINDOOR(adapter)	readl((adapter)->mmio_base + 0x20)
> -#define RDOUTDOOR(adapter)	readl((adapter)->mmio_base + 0x2C)
> -#define WRINDOOR(adapter,value)	 writel(value, (adapter)->mmio_base + 0x20)
> -#define WROUTDOOR(adapter,value) writel(value, (adapter)->mmio_base + 0x2C)
> +#define RDINDOOR(adapter)		readl((volatile void __iomem *) \
> +							(adapter)->base + 0x20)
> +#define RDOUTDOOR(adapter)		readl((volatile void __iomem *) \
> +							(adapter)->base + 0x2C)
> +#define WRINDOOR(adapter,value)		writel(value, (volatile void __iomem *)\
> +							(adapter)->base + 0x20)
> +#define WROUTDOOR(adapter,value)	writel(value, (volatile void __iomem *)\
> +							(adapter)->base + 0x2C)

This is both unnecessary and wrong ... it coerces the iomem value and
would squelch the useful warnings gcc would issue if base ever lost its
iomem annotation.

>  /*
>   * Global variables
> @@ -3571,7 +3575,7 @@ megadev_ioctl(struct inode *inode, struc
>  			/*
>  			 * The user passthru structure
>  			 */
> -			upthru = (mega_passthru __user *)MBOX(uioc)->xferaddr;
> +			upthru = (mega_passthru __user *)(unsigned long)MBOX(uioc)->xferaddr;
>  
>  			/*
>  			 * Copy in the user passthru here.
> @@ -3623,7 +3627,7 @@ megadev_ioctl(struct inode *inode, struc
>  				/*
>  				 * Get the user data
>  				 */
> -				if( copy_from_user(data, (char __user *)uxferaddr,
> +				if( copy_from_user(data, (char __user *)(unsigned long) uxferaddr,
>  							pthru->dataxferlen) ) {
>  					rval = (-EFAULT);
>  					goto freemem_and_return;
> @@ -3649,7 +3653,7 @@ megadev_ioctl(struct inode *inode, struc
>  			 * Is data going up-stream
>  			 */
>  			if( pthru->dataxferlen && (uioc.flags & UIOC_RD) ) {
> -				if( copy_to_user((char __user *)uxferaddr, data,
> +				if( copy_to_user((char __user *)(unsigned long) uxferaddr, data,
>  							pthru->dataxferlen) ) {
>  					rval = (-EFAULT);
>  				}
> @@ -3702,7 +3706,7 @@ freemem_and_return:
>  				/*
>  				 * Get the user data
>  				 */
> -				if( copy_from_user(data, (char __user *)uxferaddr,
> +				if( copy_from_user(data, (char __user *)(unsigned long) uxferaddr,
>  							uioc.xferlen) ) {
>  
>  					pci_free_consistent(pdev,
> @@ -3742,7 +3746,7 @@ freemem_and_return:
>  			 * Is data going up-stream
>  			 */
>  			if( uioc.xferlen && (uioc.flags & UIOC_RD) ) {
> -				if( copy_to_user((char __user *)uxferaddr, data,
> +				if( copy_to_user((char __user *)(unsigned long) uxferaddr, data,
>  							uioc.xferlen) ) {
>  
>  					rval = (-EFAULT);

This lot, I think are all OK.  The mbox descriptor can only handle 32
bits.  However, the mbox itself is in PCI consistent memory, which, by
definition on all platforms is in the first 4GB unless you raise the
consistent dma mask.  If that's true, it's not covering up anything
other than a spurious compiler error.

Would be nice to get an ack from the maintainer to this, though.

James


