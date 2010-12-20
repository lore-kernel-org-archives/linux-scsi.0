From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH scsi-misc-2.6] sd: implement sd_check_events()
Date: Mon, 20 Dec 2010 10:20:13 -0600
Message-ID: <1292862013.3034.7.camel@mulgrave.site>
References: <20101217122831.39300d94.sfr@canb.auug.org.au>
	 <1292597607.2820.17.camel@mulgrave.site>  <4D0CF27F.1080601@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D0CF27F.1080601@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Jens Axboe <axboe@kernel.dk>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Kay Sievers <kay.sievers@vrfy.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Added cc: linux-scsi

On Sat, 2010-12-18 at 18:42 +0100, Tejun Heo wrote:
> Replace sd_media_change() with sd_check_events().
> 
> * Move media removed logic into set_media_not_present() and
>   media_not_present() and set sdev->changed iff an existing media is
>   removed or the device indicates UNIT_ATTENTION.
> 
> * Make sd_check_events() sets sdev->changed if previously missing
>   media becomes present.
> 
> * Event is reported only if sdev->changed is set.
> 
> This makes media presence event reported if scsi_disk->media_present
> actually changed or the device indicated UNIT_ATTENTION.  For backward
> compatibility, SDEV_EVT_MEDIA_CHANGE is generated each time
> sd_check_events() detects media change event.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> ---
> Here it is.  The conflicts were due to Alan's recent patch, which was
> in the similar direction anyway.

This looks fine to me.  Jens can you strip the SCSI patches out of your
tree and I'll run them through a postmerge tree to get the fix up?

James


> Thanks.
> 
>  drivers/scsi/sd.c |   99 +++++++++++++++++++++++++++---------------------------
>  drivers/scsi/sd.h |    1
>  2 files changed, 50 insertions(+), 50 deletions(-)
> 
> Index: work/drivers/scsi/sd.c
> ===================================================================
> --- work.orig/drivers/scsi/sd.c
> +++ work/drivers/scsi/sd.c
> @@ -990,30 +990,50 @@ out:
> 
>  static void set_media_not_present(struct scsi_disk *sdkp)
>  {
> +	if (sdkp->media_present)
> +		sdkp->device->changed = 1;
>  	sdkp->media_present = 0;
>  	sdkp->capacity = 0;
> -	sdkp->device->changed = 1;
> +}
> +
> +static int media_not_present(struct scsi_disk *sdkp,
> +			     struct scsi_sense_hdr *sshdr)
> +{
> +	if (!scsi_sense_valid(sshdr))
> +		return 0;
> +
> +	/* not invoked for commands that could return deferred errors */
> +	switch (sshdr->sense_key) {
> +	case UNIT_ATTENTION:
> +		sdkp->device->changed = 1;
> +		/* fall through */
> +	case NOT_READY:
> +		/* medium not present */
> +		if (sshdr->asc == 0x3A) {
> +			set_media_not_present(sdkp);
> +			return 1;
> +		}
> +	}
> +	return 0;
>  }
> 
>  /**
> - *	sd_media_changed - check if our medium changed
> - *	@disk: kernel device descriptor
> + *	sd_check_events - check media events
> + *	@disk: kernel device descriptor
> + *	@clearing: disk events currently being cleared
>   *
> - *	Returns 0 if not applicable or no change; 1 if change
> + *	Returns mask of DISK_EVENT_*.
>   *
>   *	Note: this function is invoked from the block subsystem.
>   **/
> -static int sd_media_changed(struct gendisk *disk)
> +static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
>  {
>  	struct scsi_disk *sdkp = scsi_disk(disk);
>  	struct scsi_device *sdp = sdkp->device;
>  	struct scsi_sense_hdr *sshdr = NULL;
>  	int retval;
> 
> -	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_media_changed\n"));
> -
> -	if (!sdp->removable)
> -		return 0;
> +	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_check_events\n"));
> 
>  	/*
>  	 * If the device is offline, don't send any commands - just pretend as
> @@ -1043,40 +1063,37 @@ static int sd_media_changed(struct gendi
>  					      sshdr);
>  	}
> 
> -	if (retval) {
> +	/* failed to execute TUR, assume media not present */
> +	if (host_byte(retval)) {
>  		set_media_not_present(sdkp);
>  		goto out;
>  	}
> 
> +	if (media_not_present(sdkp, sshdr))
> +		goto out;
> +
>  	/*
>  	 * For removable scsi disk we have to recognise the presence
> -	 * of a disk in the drive. This is kept in the struct scsi_disk
> -	 * struct and tested at open !  Daniel Roche (dan@lectra.fr)
> +	 * of a disk in the drive.
>  	 */
> +	if (!sdkp->media_present)
> +		sdp->changed = 1;
>  	sdkp->media_present = 1;
> -
>  out:
>  	/*
> -	 * Report a media change under the following conditions:
> +	 * sdp->changed is set under the following conditions:
>  	 *
> -	 *	Medium is present now and wasn't present before.
> -	 *	Medium wasn't present before and is present now.
> -	 *	Medium was present at all times, but it changed while
> -	 *		we weren't looking (sdp->changed is set).
> +	 *	Medium present state has changed in either direction.
> +	 *	Device has indicated UNIT_ATTENTION.
>  	 *
> -	 * If there was no medium before and there is no medium now then
> -	 * don't report a change, even if a medium was inserted and removed
> -	 * while we weren't looking.
> +	 * Report SDEV_EVT_MEDIA_CHANGE too for backward compatibility.
>  	 */
> -	retval = (sdkp->media_present != sdkp->previous_state ||
> -			(sdkp->media_present && sdp->changed));
> -	if (retval)
> +	if (sdp->changed)
>  		sdev_evt_send_simple(sdp, SDEV_EVT_MEDIA_CHANGE, GFP_KERNEL);
> -	sdkp->previous_state = sdkp->media_present;
> -
> -	/* sdp->changed indicates medium was changed or is not present */
> -	sdp->changed = !sdkp->media_present;
>  	kfree(sshdr);
> +
> +	retval = sdp->changed ? DISK_EVENT_MEDIA_CHANGE : 0;
> +	sdp->changed = 0;
>  	return retval;
>  }
> 
> @@ -1169,7 +1186,7 @@ static const struct block_device_operati
>  #ifdef CONFIG_COMPAT
>  	.compat_ioctl		= sd_compat_ioctl,
>  #endif
> -	.media_changed		= sd_media_changed,
> +	.check_events		= sd_check_events,
>  	.revalidate_disk	= sd_revalidate_disk,
>  	.unlock_native_capacity	= sd_unlock_native_capacity,
>  };
> @@ -1305,23 +1322,6 @@ static int sd_done(struct scsi_cmnd *SCp
>  	return good_bytes;
>  }
> 
> -static int media_not_present(struct scsi_disk *sdkp,
> -			     struct scsi_sense_hdr *sshdr)
> -{
> -
> -	if (!scsi_sense_valid(sshdr))
> -		return 0;
> -	/* not invoked for commands that could return deferred errors */
> -	if (sshdr->sense_key != NOT_READY &&
> -	    sshdr->sense_key != UNIT_ATTENTION)
> -		return 0;
> -	if (sshdr->asc != 0x3A) /* medium not present */
> -		return 0;
> -
> -	set_media_not_present(sdkp);
> -	return 1;
> -}
> -
>  /*
>   * spinup disk - called only in sd_revalidate_disk()
>   */
> @@ -1496,7 +1496,7 @@ static void read_capacity_error(struct s
>  	 */
>  	if (sdp->removable &&
>  	    sense_valid && sshdr->sense_key == NOT_READY)
> -		sdp->changed = 1;
> +		set_media_not_present(sdkp);
> 
>  	/*
>  	 * We used to set media_present to 0 here to indicate no media
> @@ -2382,8 +2382,10 @@ static void sd_probe_async(void *data, a
> 
>  	gd->driverfs_dev = &sdp->sdev_gendev;
>  	gd->flags = GENHD_FL_EXT_DEVT;
> -	if (sdp->removable)
> +	if (sdp->removable) {
>  		gd->flags |= GENHD_FL_REMOVABLE;
> +		gd->events |= DISK_EVENT_MEDIA_CHANGE;
> +	}
> 
>  	add_disk(gd);
>  	sd_dif_config_host(sdkp);
> @@ -2465,7 +2467,6 @@ static int sd_probe(struct device *dev)
>  	sdkp->disk = gd;
>  	sdkp->index = index;
>  	atomic_set(&sdkp->openers, 0);
> -	sdkp->previous_state = 1;
> 
>  	if (!sdp->request_queue->rq_timeout) {
>  		if (sdp->type != TYPE_MOD)
> Index: work/drivers/scsi/sd.h
> ===================================================================
> --- work.orig/drivers/scsi/sd.h
> +++ work/drivers/scsi/sd.h
> @@ -55,7 +55,6 @@ struct scsi_disk {
>  	u8		media_present;
>  	u8		write_prot;
>  	u8		protection_type;/* Data Integrity Field */
> -	unsigned	previous_state : 1;
>  	unsigned	ATO : 1;	/* state of disk ATO bit */
>  	unsigned	WCE : 1;	/* state of disk WCE bit */
>  	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
