From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2.1] sd: Micro-optimize READ / WRITE CDB encoding
Date: Wed, 25 Oct 2017 09:28:17 +0200
Message-ID: <4d9f3a73-6330-e48d-97f1-8b35bb3bb7be@suse.de>
References: <20171025035222.6272-1-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38487 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751591AbdJYH22 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Oct 2017 03:28:28 -0400
In-Reply-To: <20171025035222.6272-1-dgilbert@interlog.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc: Bart.VanAssche@wdc.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, hch@lst.de, jthumshirn@suse.de

On 10/25/2017 05:52 AM, Douglas Gilbert wrote:
> The sd_setup_read_write_cmnd() function is on the "fast path" for
> block system access to SCSI devices (logical units). Rewrite this
> function to improve speed and readability:
>  - use put_unaligned_be family of functions to save lots of shifts
>  - improve the scaling code when sector_size > 512 bytes
>  - use variable names containing "sect" for block system quantities
>    which have implicit 512 byte sector size. Use "lba" and
>    "num_blks" after optional scaling to match the logical block
>    address and number of logical blocks of the SCSI device being
>    accessed
>  - use local variables to hold values that were previously calculated
>    more than once
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>  drivers/scsi/sd.c | 216 ++++++++++++++++++++++++------------------------------
>  1 file changed, 94 insertions(+), 122 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index d175c5c5ccf8..618cb5d0f75a 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1004,11 +1004,18 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
>  	struct scsi_device *sdp = SCpnt->device;
>  	struct gendisk *disk = rq->rq_disk;
>  	struct scsi_disk *sdkp = scsi_disk(disk);
> -	sector_t block = blk_rq_pos(rq);
> -	sector_t threshold;
> -	unsigned int this_count = blk_rq_sectors(rq);
> +	unsigned int num_sects = blk_rq_sectors(rq);
> +	unsigned int num_blks;
>  	unsigned int dif, dix;
> -	bool zoned_write = sd_is_zoned(sdkp) && rq_data_dir(rq) == WRITE;
> +	unsigned int sect_sz;
> +	sector_t sect_addr = blk_rq_pos(rq);
> +	sector_t sect_after = sect_addr + num_sects;
> +	sector_t total_sects = get_capacity(disk);
> +	sector_t threshold_sect;
> +	sector_t lba;
> +	bool is_write = (rq_data_dir(rq) == WRITE);
> +	bool have_fua = !!(rq->cmd_flags & REQ_FUA);
> +	bool zoned_write = sd_is_zoned(sdkp) && is_write;
>  	int ret;
>  	unsigned char protect;
>  
> @@ -1029,20 +1036,23 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
>  
>  	SCSI_LOG_HLQUEUE(1,
>  		scmd_printk(KERN_INFO, SCpnt,
> -			"%s: block=%llu, count=%d\n",
> -			__func__, (unsigned long long)block, this_count));
> +			"%s: sector=%llu, num_sects=%d\n",
> +			__func__, (unsigned long long)sect_addr, num_sects));
>  
> -	if (!sdp || !scsi_device_online(sdp) ||
> -	    block + blk_rq_sectors(rq) > get_capacity(disk)) {
> +	if (likely(sdp && scsi_device_online(sdp) &&
> +		   (sect_after <= total_sects)))
> +		; /* ok: have device, its online and access fits on medium */
> +	else {
>  		SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
>  						"Finishing %u sectors\n",
> -						blk_rq_sectors(rq)));
> +						num_sects));
>  		SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
>  						"Retry with 0x%p\n", SCpnt));
>  		goto out;
>  	}
> +	sect_sz = sdp->sector_size;
>  
> -	if (sdp->changed) {
> +	if (unlikely(sdp->changed)) {
>  		/*
>  		 * quietly refuse to do anything to a changed disc until 
>  		 * the changed bit has been reset
Please invert the 'if' condition to avoid the empty branch.

> @@ -1055,21 +1065,22 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
>  	 * Some SD card readers can't handle multi-sector accesses which touch
>  	 * the last one or two hardware sectors.  Split accesses as needed.
>  	 */
> -	threshold = get_capacity(disk) - SD_LAST_BUGGY_SECTORS *
> -		(sdp->sector_size / 512);
> -
> -	if (unlikely(sdp->last_sector_bug && block + this_count > threshold)) {
> -		if (block < threshold) {
> -			/* Access up to the threshold but not beyond */
> -			this_count = threshold - block;
> -		} else {
> -			/* Access only a single hardware sector */
> -			this_count = sdp->sector_size / 512;
> -		}
> +	if (unlikely(sdp->last_sector_bug)) {
> +		threshold_sect = total_sects -
> +			    (SD_LAST_BUGGY_SECTORS * (sect_sz / 512));
> +
> +		if (unlikely(sect_after > threshold_sect))
> +			num_sects = (sect_addr < threshold_sect) ?
> +						(threshold_sect - sect_addr) :
> +						(sect_sz / 512);
> +			/* If LBA less than threshold then access up to the
> +			 * threshold but not beyond; otherwise access only
> +			 * a single hardware sector.
> +			 */
>  	}
>  
> -	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt, "block=%llu\n",
> -					(unsigned long long)block));
> +	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt, "num_sects=%llu\n",
> +					(unsigned long long)num_sects));
>  
>  	/*
>  	 * If we have a 1K hardware sectorsize, prevent access to single
Why did you change the log message?
I'd rather keep it as it were...

Cheers,

Hannes
-- 
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
