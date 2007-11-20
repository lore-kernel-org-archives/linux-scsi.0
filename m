From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] scsi: megaraid_sas - Fix random failure of DCDB cmds with sense info
Date: Tue, 20 Nov 2007 13:42:02 -0700
Message-ID: <20071120204202.GJ12494@parisc-linux.org>
References: <1195634456.5855.9.camel@dhcp-75-884.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:60087 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760246AbXKTUmE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Nov 2007 15:42:04 -0500
Content-Disposition: inline
In-Reply-To: <1195634456.5855.9.camel@dhcp-75-884.se.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bo yang <bo.yang@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, akpm@osdl.org, linux-kernel@vger.kernel.org, Sumant.patro@lsi.com, neela.kolli@lsi.com

On Wed, Nov 21, 2007 at 08:40:56AM +0000, bo yang wrote:
> Sense buffer ptr data type in the ioctl path is reverted back to u32 *
> for x86 and x86_64 as in previous versions of driver. For IA64 it will
> be unsigned long *. Compile time flag added for ia64 for this.

This changelog tells us what you're doing, but not why you're doing it.
Why is it that ia64 is different from x86 and x86_64?  What should other
architectures be doing?  This patch really doesn't make any sense to me at
all; it should be doing the exact same thing on all three architectures.

> Signed-off-by: Bo Yang <bo.yang@lsi.com>
> 
> ---
> Documentation/scsi/ChangeLog.megaraid_sas |   15 +++++++++++++++
> drivers/scsi/megaraid/megaraid_sas.c      |   14 ++++++++++----
> drivers/scsi/megaraid/megaraid_sas.h      |    6 +++---
>  3 files changed, 28 insertions(+), 7 deletions(-)
> 
> diff -rupN linux-2.6.22_orig/Documentation/scsi/ChangeLog.megaraid_sas linux-2.6.22_new/Documentation/scsi/ChangeLog.megaraid_sas
> --- linux-2.6.22_orig/Documentation/scsi/ChangeLog.megaraid_sas	2007-11-20 17:50:13.000000000 -0500
> +++ linux-2.6.22_new/Documentation/scsi/ChangeLog.megaraid_sas	2007-11-20 21:37:16.000000000 -0500
> @@ -1,3 +1,18 @@
> +1 Release Date    : Thur. Nov. 19 16:30:43 PST 2007 -
> +			(emaild-id:megaraidlinux@lsi.com)
> +			Sumant Patro
> +			Bo Yang
> +
> +2 Current Version : 00.00.03.17-RC1
> +3 Older Version   : 00.00.03.16
> +
> +1. Fix random failure of DCDB cmds with sense info.
> +
> +Fix: 	sense buffer ptr data type in the ioctl path is reverted back
> +	to u32 * for x86, x86_64 as in previous versions of driver.
> +	For IA64 it will be unsigned long *. Compile time flag added
> +	for ia64 for this.
> +
>  1 Release Date    : Thur. Nov. 07 16:30:43 PST 2007 -
>  			(emaild-id:megaraidlinux@lsi.com)
>  			Sumant Patro
> diff -rupN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c
> --- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c	2007-11-20 17:50:13.000000000 -0500
> +++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c	2007-11-20 17:50:13.000000000 -0500
> @@ -10,7 +10,7 @@
>   *	   2 of the License, or (at your option) any later version.
>   *
>   * FILE		: megaraid_sas.c
> - * Version	: v00.00.03.16-rc1
> + * Version	: v00.00.03.17-rc1
>   *
>   * Authors:
>   *	(email-id : megaraidlinux@lsi.com)
> @@ -3020,10 +3020,16 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
>  		 * sense buffer address
>  		 */
>  		sense_buff = (unsigned long *) ((unsigned long)ioc->frame.raw +
> -								ioc->sense_off);
> -
> -		if (copy_to_user((void __user *)(unsigned long)(*sense_buff),
> +					ioc->sense_off);
> +		sense_ptr = (u32 *) ((unsigned long)ioc->frame.raw +
> +					ioc->sense_off);
> +#if defined(__ia64__)
> +		if (copy_to_user((void __user *)((unsigned long)(*sense_buff)),
> +				sense, ioc->sense_len)) {
> +#else
> +		if (copy_to_user((void __user *)((unsigned long)(*sense_ptr)),
>  				sense, ioc->sense_len)) {
> +#endif
>  			printk(KERN_ERR "megasas: Failed to copy out to user "
>  					"sense data\n");
>  			error = -EFAULT;
> diff -rupN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.h
> --- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.h	2007-11-20 17:50:13.000000000 -0500
> +++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.h	2007-11-20 17:50:13.000000000 -0500
> @@ -18,9 +18,9 @@
>  /*
>   * MegaRAID SAS Driver meta data
>   */
> -#define MEGASAS_VERSION				"00.00.03.16-rc1"
> -#define MEGASAS_RELDATE				"Nov. 07, 2007"
> -#define MEGASAS_EXT_VERSION			"Thu. Nov. 07 10:09:32 PDT 2007"
> +#define MEGASAS_VERSION				"00.00.03.17-rc1"
> +#define MEGASAS_RELDATE				"Nov. 19, 2007"
> +#define MEGASAS_EXT_VERSION			"Mon. Nov. 19 10:09:32 PDT 2007"
>  
>  /*
>   * Device IDs
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
