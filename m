From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v8 10/11] scsi: sr: support (un)block events
Date: Mon, 29 Oct 2012 22:11:35 +0400
Message-ID: <1351534295.3051.9.camel@dabdike>
References: <1351501298-3716-1-git-send-email-aaron.lu@intel.com>
	 <1351501298-3716-11-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55950 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760328Ab2J2SLt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Oct 2012 14:11:49 -0400
In-Reply-To: <1351501298-3716-11-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Oliver Neukum <oliver@neukum.org>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

On Mon, 2012-10-29 at 17:01 +0800, Aaron Lu wrote:
> 2 interfaces are added to block/unblock events for the disk sr manages.
> This is used by SATA ZPODD, when ODD is runtime powered off, the events
> poll is no longer needed so better be blocked. And once powered on,
> events poll will be unblocked.
> 
> These 2 interfaces are needed here because SATA layer does not have
> access to the gendisk structure sr manages.

I'm afraid this is a nasty layering violation.  You can't have a low
level driver have knowledge of a call back in an upper layer one (in
this case sr_block_events).

This is all done it looks like because of the problem of getting access
to the scsi_cd structure from libata, but it's not the right way to
solve it.

I also don't really think you need to do any blocking or unblocking.  As
I said in the previous thread, just fake the events the standard tells
you to, so userspace can probe to its heart's content and you can keep
the device powered off.

James


> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> ---
>  drivers/scsi/Makefile   |  1 +
>  drivers/scsi/sr_zpodd.c | 21 +++++++++++++++++++++
>  drivers/scsi/sr_zpodd.h |  9 +++++++++
>  3 files changed, 31 insertions(+)
>  create mode 100644 drivers/scsi/sr_zpodd.c
>  create mode 100644 drivers/scsi/sr_zpodd.h
> 
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index 888f73a..474efe2 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -177,6 +177,7 @@ sd_mod-objs	:= sd.o
>  sd_mod-$(CONFIG_BLK_DEV_INTEGRITY) += sd_dif.o
>  
>  sr_mod-objs	:= sr.o sr_ioctl.o sr_vendor.o
> +sr_mod-$(CONFIG_SATA_ZPODD) += sr_zpodd.o
>  ncr53c8xx-flags-$(CONFIG_SCSI_ZALON) \
>  		:= -DCONFIG_NCR53C8XX_PREFETCH -DSCSI_NCR_BIG_ENDIAN \
>  			-DCONFIG_SCSI_NCR53C8XX_NO_WORD_TRANSFERS
> diff --git a/drivers/scsi/sr_zpodd.c b/drivers/scsi/sr_zpodd.c
> new file mode 100644
> index 0000000..0686e8c
> --- /dev/null
> +++ b/drivers/scsi/sr_zpodd.c
> @@ -0,0 +1,21 @@
> +#include <linux/module.h>
> +#include <linux/genhd.h>
> +#include <linux/cdrom.h>
> +#include "sr.h"
> +
> +bool sr_block_events(struct device *dev)
> +{
> +	struct scsi_cd *cd = dev_get_drvdata(dev);
> +	if (cd)
> +		return disk_try_block_events(cd->disk);
> +	return false;
> +}
> +EXPORT_SYMBOL(sr_block_events);
> +
> +void sr_unblock_events(struct device *dev)
> +{
> +	struct scsi_cd *cd = dev_get_drvdata(dev);
> +	if (cd)
> +		disk_unblock_events(cd->disk);
> +}
> +EXPORT_SYMBOL(sr_unblock_events);
> diff --git a/drivers/scsi/sr_zpodd.h b/drivers/scsi/sr_zpodd.h
> new file mode 100644
> index 0000000..49c6a55
> --- /dev/null
> +++ b/drivers/scsi/sr_zpodd.h
> @@ -0,0 +1,9 @@
> +#ifndef __SR_ZPODD_H__
> +#define __SR_ZPODD_H__
> +
> +#include <linux/device.h>
> +
> +extern bool sr_block_events(struct device *dev);
> +extern void sr_unblock_events(struct device *dev);
> +
> +#endif


