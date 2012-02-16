From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/2] scsi: retrieve cache mode using ATA_16 cmd if
 normal routine fails
Date: Thu, 16 Feb 2012 08:28:01 -0500
Message-ID: <1329398881.2893.8.camel@dabdike>
References: <1329375141-6944-1-git-send-email-amit.sahrawat83@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1329375141-6944-1-git-send-email-amit.sahrawat83@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Nam-Jae Jeon <namjae.jeon@samsung.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Amit Sahrawat <a.sahrawat@samsung.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-02-16 at 12:22 +0530, Amit Sahrawat wrote:

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index c691fb5..3ca507a 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -50,6 +50,11 @@
>  #include <linux/string_helpers.h>
>  #include <linux/async.h>
>  #include <linux/slab.h>
> +
> +#ifdef CONFIG_ATA
> +#include <linux/libata.h>
> +#endif
> +
>  #include <linux/pm_runtime.h>
>  #include <asm/uaccess.h>
>  #include <asm/unaligned.h>
> @@ -2129,7 +2134,11 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
>  		if (modepage == 0x3F) {
>  			sd_printk(KERN_ERR, sdkp, "No Caching mode page "
>  				  "present\n");
> +#ifdef CONFIG_ATA
> +			goto WCE_USING_ATA;
> +#else
>  			goto defaults;
> +#endif
>  		} else if ((buffer[offset] & 0x3f) != modepage) {
>  			sd_printk(KERN_ERR, sdkp, "Got wrong page\n");
>  			goto defaults;
> @@ -2149,6 +2158,15 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
>  				  "Uses READ/WRITE(6), disabling FUA\n");
>  			sdkp->DPOFUA = 0;
>  		}
> +#ifdef CONFIG_ATA
> +WCE_USING_ATA:
> +		if (!sdp->removable && !sdkp->WCE) {
> +			sd_printk(KERN_NOTICE, sdkp, "Try to check write cache"
> +				" enable/disable using ATA command\n");
> +			sdkp->WCE = ata_get_cachestatus(sdp);
> +		}
> +#endif
> +

I already said before, this is a non starter: we can't randomly send
SCSI encapsulated ATA commands to disks from sd.  What we can do is give
you a WCE variable you can change on the fly in sysfs via whatever
mechanism is most appropriate (but this would have to be a mechanism
external to sd.c).

Alternatively, you can co-opt the USB quirks handling to set it for you.

James


