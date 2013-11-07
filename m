From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 1/3] sd: don't bother spinning up disks on resume
Date: Thu, 07 Nov 2013 13:21:05 -0500
Message-ID: <527BDA11.6060603@interlog.com>
References: <527AF287.7020700@ubuntu.com> <927e15641f27b46f206f8ae8110201c8fd77b7e1.1383789225.git.psusi@ubuntu.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:38293 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab3KGSVQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Nov 2013 13:21:16 -0500
In-Reply-To: <927e15641f27b46f206f8ae8110201c8fd77b7e1.1383789225.git.psusi@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>, todd.e.brandt@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: tj@kernel.org, JBottomley@parallels.com

On 13-11-06 08:57 PM, Phillip Susi wrote:
> Don't bother forcing disks to spin up on resume, as they
> will do so automatically when accessed, and forcing them
> to spin up slows down the resume.  Add a second bit to the
> manage_start_stop flag to restore the previous behavior.

SCSI disks when in STOP state do not spin up "automatically
when accessed".

If you haven't looked at the SAT-2 standard (SAT-3 drafts)
then perhaps you should as that gives insights into how SCSI
and ATA disks can play together in the same sandpit (and the
code you are patching is in the SCSI part of the sandpit).

And your choice of bits looks like it will favour fixing
broken SATA behaviour but as a by-product break working
SCSI disk behaviour.

Doug Gilbert

> ---
>   drivers/scsi/sd.c          | 6 +++---
>   include/scsi/scsi_device.h | 2 +-
>   2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index e62d17d..3143311 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3083,7 +3083,7 @@ static void sd_shutdown(struct device *dev)
>   		sd_sync_cache(sdkp);
>   	}
>
> -	if (system_state != SYSTEM_RESTART && sdkp->device->manage_start_stop) {
> +	if (system_state != SYSTEM_RESTART && (sdkp->device->manage_start_stop & 1)) {
>   		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
>   		sd_start_stop_device(sdkp, 0);
>   	}
> @@ -3107,7 +3107,7 @@ static int sd_suspend(struct device *dev)
>   			goto done;
>   	}
>
> -	if (sdkp->device->manage_start_stop) {
> +	if (sdkp->device->manage_start_stop & 1) {
>   		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
>   		ret = sd_start_stop_device(sdkp, 0);
>   	}
> @@ -3122,7 +3122,7 @@ static int sd_resume(struct device *dev)
>   	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
>   	int ret = 0;
>
> -	if (!sdkp->device->manage_start_stop)
> +	if (!(sdkp->device->manage_start_stop & 2))
>   		goto done;
>
>   	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index d65fbec..1c46d2d 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -152,7 +152,7 @@ struct scsi_device {
>   	unsigned use_192_bytes_for_3f:1; /* ask for 192 bytes from page 0x3f */
>   	unsigned no_start_on_add:1;	/* do not issue start on add */
>   	unsigned allow_restart:1; /* issue START_UNIT in error handler */
> -	unsigned manage_start_stop:1;	/* Let HLD (sd) manage start/stop */
> +	unsigned manage_start_stop:2;	/* Let HLD (sd) manage start/stop */
>   	unsigned start_stop_pwr_cond:1;	/* Set power cond. in START_STOP_UNIT */
>   	unsigned no_uld_attach:1; /* disable connecting to upper level drivers */
>   	unsigned select_no_atn:1;
>

