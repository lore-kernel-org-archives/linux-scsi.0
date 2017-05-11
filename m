From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH v4] sd: Ignore sync cache failures when not supported
Date: Thu, 11 May 2017 12:44:29 -0400
Message-ID: <1494521069.32302.6.camel@localhost.localdomain>
References: <1494506064-19680-1-git-send-email-thierry.escande@collabora.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51406 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755804AbdEKQoc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 May 2017 12:44:32 -0400
In-Reply-To: <1494506064-19680-1-git-send-email-thierry.escande@collabora.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thierry Escande <thierry.escande@collabora.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2017-05-11 at 14:34 +0200, Thierry Escande wrote:
> From: Derek Basehore <dbasehore@chromium.org>
> 
> Some external hard drives don't support the sync command even though the
> hard drive has write cache enabled. In this case, upon suspend request,
> sync cache failures are ignored if the error code in the sense header is
> ILLEGAL_REQUEST. There's not much we can do for these drives, so we
> shouldn't fail to suspend for this error case. The drive may stay
> powered if that's the setup for the port it's plugged into.
> 
> Signed-off-by: Derek Basehore <dbasehore@chromium.org>
> Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
> ---
> 
> v4 changes:
> - Check sense header validity before checking the sense_key field
> - Get rid of both goto statements (the one in the previous patch and the
>   one in the existing code)
> 
> v3 changes:
> - Pass the sense_hdr structure to sd_sync_cache() instead of the
>   lonely sense_key field
> 
> v2 changes:
> - Change sense_key type to u8 in sd_sync_cache()
> 
>  drivers/scsi/sd.c | 40 ++++++++++++++++++++++++++++------------
>  1 file changed, 28 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index fcfeddc..823ab8b 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1489,17 +1489,21 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
>  	return retval;
>  }
>  
> -static int sd_sync_cache(struct scsi_disk *sdkp)
> +static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
>  {
>  	int retries, res;
>  	struct scsi_device *sdp = sdkp->device;
>  	const int timeout = sdp->request_queue->rq_timeout
>  		* SD_FLUSH_TIMEOUT_MULTIPLIER;
> -	struct scsi_sense_hdr sshdr;
> +	struct scsi_sense_hdr my_sshdr;
>  
>  	if (!scsi_device_online(sdp))
>  		return -ENODEV;
>  
> +	/* caller might not be interested in sense, but we need it */
> +	if (!sshdr)
> +		sshdr = &my_sshdr;
> +
>  	for (retries = 3; retries > 0; --retries) {
>  		unsigned char cmd[10] = { 0 };
>  
> @@ -1508,7 +1512,7 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
>  		 * Leave the rest of the command zero to indicate
>  		 * flush everything.
>  		 */
> -		res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
> +		res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, sshdr,
>  				timeout, SD_MAX_RETRIES, 0, RQF_PM, NULL);
>  		if (res == 0)
>  			break;
> @@ -1518,11 +1522,12 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
>  		sd_print_result(sdkp, "Synchronize Cache(10) failed", res);
>  
>  		if (driver_byte(res) & DRIVER_SENSE)
> -			sd_print_sense_hdr(sdkp, &sshdr);
> +			sd_print_sense_hdr(sdkp, sshdr);
> +
>  		/* we need to evaluate the error return  */
> -		if (scsi_sense_valid(&sshdr) &&
> -			(sshdr.asc == 0x3a ||	/* medium not present */
> -			 sshdr.asc == 0x20))	/* invalid command */
> +		if (scsi_sense_valid(sshdr) &&
> +			(sshdr->asc == 0x3a ||	/* medium not present */
> +			 sshdr->asc == 0x20))	/* invalid command */
>  				/* this is no error here */
>  				return 0;
>  
> @@ -3323,7 +3328,7 @@ static void sd_shutdown(struct device *dev)
>  
>  	if (sdkp->WCE && sdkp->media_present) {
>  		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
> -		sd_sync_cache(sdkp);
> +		sd_sync_cache(sdkp, NULL);
>  	}
>  
>  	if (system_state != SYSTEM_RESTART && sdkp->device->manage_start_stop) {
> @@ -3335,6 +3340,7 @@ static void sd_shutdown(struct device *dev)
>  static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
>  {
>  	struct scsi_disk *sdkp = dev_get_drvdata(dev);
> +	struct scsi_sense_hdr sshdr;
>  	int ret = 0;
>  
>  	if (!sdkp)	/* E.g.: runtime suspend following sd_remove() */
> @@ -3342,12 +3348,23 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
>  
>  	if (sdkp->WCE && sdkp->media_present) {
>  		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
> -		ret = sd_sync_cache(sdkp);
> +		ret = sd_sync_cache(sdkp, &sshdr);
> +
>  		if (ret) {
>  			/* ignore OFFLINE device */
>  			if (ret == -ENODEV)
> -				ret = 0;
> -			goto done;
> +				return 0;
> +
> +			if (!scsi_sense_valid(&sshdr) ||
> +			    sshdr.sense_key != ILLEGAL_REQUEST)
> +				return ret;
> +
> +			/*
> +			 * sshdr.sense_key == ILLEGAL_REQUEST means this drive
> +			 * doesn't support sync. There's not much to do and
> +			 * suspend shouldn't fail.
> +			 */
> +			 ret = 0;
>  		}
>  	}
>  
> @@ -3359,7 +3376,6 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
>  			ret = 0;
>  	}
>  
> -done:
>  	return ret;
>  }
>  

Reviewed-by: Ewan D. Milne <emilne@redhat.com>
