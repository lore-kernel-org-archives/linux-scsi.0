From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH v2] sd: Fix excessive capacity printing on devices with
 blocks bigger than 512 bytes
Date: Wed, 30 Mar 2016 12:34:42 -0400
Message-ID: <1459355682.30035.29.camel@localhost.localdomain>
References: <1458656217.17965.48.camel@localhost.localdomain>
	 <1459214336-12668-1-git-send-email-martin.petersen@oracle.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498AbcC3Qen (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2016 12:34:43 -0400
In-Reply-To: <1459214336-12668-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2016-03-28 at 21:18 -0400, Martin K. Petersen wrote:
> During revalidate we check whether device capacity has changed before we
> decide whether to output disk information or not.
> 
> The check for old capacity failed to take into account that we scaled
> sdkp->capacity based on the reported logical block size. And therefore
> the capacity test would always fail for devices with sectors bigger than
> 512 bytes and we would print several copies of the same discovery
> information.
> 
> Avoid scaling sdkp->capacity and instead adjust the value on the fly
> when setting the block device capacity and generating fake C/H/S
> geometry.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reported-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/sd.c | 28 ++++++++--------------------
>  drivers/scsi/sd.h |  7 ++++++-
>  2 files changed, 14 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 5a5457ac9cdb..8401697ff6aa 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1275,18 +1275,19 @@ static int sd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
>  	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
>  	struct scsi_device *sdp = sdkp->device;
>  	struct Scsi_Host *host = sdp->host;
> +	sector_t capacity = logical_to_sectors(sdp, sdkp->capacity);
>  	int diskinfo[4];
>  
>  	/* default to most commonly used values */
> -        diskinfo[0] = 0x40;	/* 1 << 6 */
> -       	diskinfo[1] = 0x20;	/* 1 << 5 */
> -       	diskinfo[2] = sdkp->capacity >> 11;
> -	
> +	diskinfo[0] = 0x40;	/* 1 << 6 */
> +	diskinfo[1] = 0x20;	/* 1 << 5 */
> +	diskinfo[2] = capacity >> 11;
> +
>  	/* override with calculated, extended default, or driver values */
>  	if (host->hostt->bios_param)
> -		host->hostt->bios_param(sdp, bdev, sdkp->capacity, diskinfo);
> +		host->hostt->bios_param(sdp, bdev, capacity, diskinfo);
>  	else
> -		scsicam_bios_param(bdev, sdkp->capacity, diskinfo);
> +		scsicam_bios_param(bdev, capacity, diskinfo);
>  
>  	geo->heads = diskinfo[0];
>  	geo->sectors = diskinfo[1];
> @@ -2337,14 +2338,6 @@ got_data:
>  	if (sdkp->capacity > 0xffffffff)
>  		sdp->use_16_for_rw = 1;
>  
> -	/* Rescale capacity to 512-byte units */
> -	if (sector_size == 4096)
> -		sdkp->capacity <<= 3;
> -	else if (sector_size == 2048)
> -		sdkp->capacity <<= 2;
> -	else if (sector_size == 1024)
> -		sdkp->capacity <<= 1;
> -
>  	blk_queue_physical_block_size(sdp->request_queue,
>  				      sdkp->physical_block_size);
>  	sdkp->device->sector_size = sector_size;
> @@ -2812,11 +2805,6 @@ static int sd_try_extended_inquiry(struct scsi_device *sdp)
>  	return 0;
>  }
>  
> -static inline u32 logical_to_sectors(struct scsi_device *sdev, u32 blocks)
> -{
> -	return blocks << (ilog2(sdev->sector_size) - 9);
> -}
> -
>  /**
>   *	sd_revalidate_disk - called the first time a new disk is seen,
>   *	performs disk spin up, read_capacity, etc.
> @@ -2900,7 +2888,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  	/* Combine with controller limits */
>  	q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));
>  
> -	set_capacity(disk, sdkp->capacity);
> +	set_capacity(disk, logical_to_sectors(sdp, sdkp->capacity));
>  	sd_config_write_same(sdkp);
>  	kfree(buffer);
>  
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index 5f2a84aff29f..654630bb7d0e 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -65,7 +65,7 @@ struct scsi_disk {
>  	struct device	dev;
>  	struct gendisk	*disk;
>  	atomic_t	openers;
> -	sector_t	capacity;	/* size in 512-byte sectors */
> +	sector_t	capacity;	/* size in logical blocks */
>  	u32		max_xfer_blocks;
>  	u32		opt_xfer_blocks;
>  	u32		max_ws_blocks;
> @@ -146,6 +146,11 @@ static inline int scsi_medium_access_command(struct scsi_cmnd *scmd)
>  	return 0;
>  }
>  
> +static inline sector_t logical_to_sectors(struct scsi_device *sdev, sector_t blocks)
> +{
> +	return blocks << (ilog2(sdev->sector_size) - 9);
> +}
> +
>  /*
>   * A DIF-capable target device can be formatted with different
>   * protection schemes.  Currently 0 through 3 are defined:

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


