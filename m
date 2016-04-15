From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 9/9] sd: Implement support for ZBC devices
Date: Fri, 15 Apr 2016 11:31:09 -0700
Message-ID: <5711336D.80201@sandisk.com>
References: <1459764020-126038-1-git-send-email-hare@suse.de>
 <1459764020-126038-10-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0076.outbound.protection.outlook.com ([157.56.111.76]:23616
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750913AbcDOSbP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2016 14:31:15 -0400
In-Reply-To: <1459764020-126038-10-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>

On 04/04/2016 03:00 AM, Hannes Reinecke wrote:
> @@ -728,6 +729,10 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
>   	int ret = 0;
>   	char *buf;
>   	struct page *page = NULL;
> +#ifdef CONFIG_SCSI_ZBC
> +	struct blk_zone *zone;
> +	unsigned long flags;
> +#endif

There is a strong preference in the Linux kernel for avoiding #ifdefs 
and to move code that depends on the value of a CONFIG_* variable into 
a file for which the compilation depends on that CONFIG_* variable. 
Please consider to move the ZBC code from sd_setup_discard_cmnd() into a 
new function in sd_zbc.c.

> +#ifdef CONFIG_SCSI_ZBC
> +		zone = blk_lookup_zone(rq->q, sector);
> +		if (!zone) {
> +			ret = BLKPREP_KILL;
> +			goto out;
> +		}
> +		spin_lock_irqsave(&zone->lock, flags);
> +		if (zone->state == BLK_ZONE_BUSY) {
> +			sd_printk(KERN_INFO, sdkp,
> +				  "Discarding busy zone %zu/%zu\n",
> +				  zone->start, zone->len);
> +			spin_unlock_irqrestore(&zone->lock, flags);
> +			ret = BLKPREP_DEFER;
> +			goto out;
> +		}
> +		if (!blk_zone_is_smr(zone)) {
> +			sd_printk(KERN_INFO, sdkp,
> +				  "Discarding %s zone %zu/%zu\n",
> +				  blk_zone_is_cmr(zone) ? "CMR" : "unknown",
> +				  zone->start, zone->len);
> +			spin_unlock_irqrestore(&zone->lock, flags);
> +			ret = BLKPREP_DONE;
> +			goto out;
> +		}
> +		if (blk_zone_is_empty(zone)) {
> +			spin_unlock_irqrestore(&zone->lock, flags);
> +			ret = BLKPREP_DONE;
> +			goto out;
> +		}
> +		if (zone->start != sector ||
> +		    zone->len < nr_sectors) {
> +			sd_printk(KERN_INFO, sdkp,
> +				  "Misaligned RESET WP, start %zu/%zu "
> +				  "len %zu/%u\n",
> +				  zone->start, sector, zone->len, nr_sectors);
> +			spin_unlock_irqrestore(&zone->lock, flags);
> +			ret = BLKPREP_KILL;
> +			goto out;
> +		}
> +		/*
> +		 * Opportunistic setting, needs to be fixed up
> +		 * if RESET WRITE POINTER fails.
> +		 */
> +		zone->wp = zone->start;
> +		spin_unlock_irqrestore(&zone->lock, flags);
> +#endif
 >   		cmd->cmd_len = 16;
 >   		cmd->cmnd[0] = ZBC_OUT;
 >   		cmd->cmnd[1] = ZO_RESET_WRITE_POINTER;

Which mechanism prevents that zone->state is modified after it has been 
checked and before the RESET WRITE POINTER command has finished?

> @@ -990,6 +1041,13 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
>   	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt, "block=%llu\n",
>   					(unsigned long long)block));
>
> +	if (sdkp->zoned == 1 || sdp->type == TYPE_ZBC) {
> +		/* sd_zbc_lookup_zone lba is in block layer sector units */
> +		ret = sd_zbc_lookup_zone(sdkp, rq, block, this_count);
> +		if (ret != BLKPREP_OK)
> +			goto out;
> +	}
> +

Which mechanism guarantees that the above code won't run concurrently 
with zbc_parse_zones()?

> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index 5debd49..35c75fa 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -65,6 +65,12 @@ struct scsi_disk {
>   	struct scsi_device *device;
>   	struct device	dev;
>   	struct gendisk	*disk;
> +#ifdef CONFIG_SCSI_ZBC
> +	struct workqueue_struct *zone_work_q;
> +	unsigned long	zone_flags;
> +#define SD_ZBC_ZONE_RESET 1
> +#define SD_ZBC_ZONE_INIT  2
> +#endif

The above two constants are only used in source file sd_zbc.c. Have you 
considered to move the definition of these constants into sd_zbc.c?

> +#undef SD_ZBC_DEBUG

Please use the dynamic_debug facility instead of #ifdef SD_ZBC_DEBUG + 
sd_printk().

> +void sd_zbc_refresh_zone_work(struct work_struct *work)
> +{
> +	struct zbc_update_work *zbc_work =
> +		container_of(work, struct zbc_update_work, zone_work);
> +	struct scsi_disk *sdkp = zbc_work->sdkp;
> +	struct request_queue *q = sdkp->disk->queue;
> +	unsigned int zone_buflen;
> +	int ret;
> +	sector_t last_sector;
> +	sector_t capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
> +	sector_t zone_lba = sectors_to_logical(sdkp->device,
> +					       zbc_work->zone_sector);
> +
> +	zone_buflen = zbc_work->zone_buflen;
> +	ret = sd_zbc_report_zones(sdkp, zone_lba, zbc_work->zone_buf,
> +				  zone_buflen);
> +	if (ret)
> +		goto done_free;
> +
> +	last_sector = zbc_parse_zones(sdkp, zbc_work->zone_buf, zone_buflen);
> +	if (last_sector != -1 && last_sector < capacity) {
> +		if (test_bit(SD_ZBC_ZONE_RESET, &sdkp->zone_flags)) {
> +#ifdef SD_ZBC_DEBUG
> +			sd_printk(KERN_INFO, sdkp,
> +				  "zones in reset, cancelling refresh\n");
> +#endif
> +			ret = -EAGAIN;
> +			goto done_free;
> +		}
> +
> +		zbc_work->zone_sector = last_sector;
> +		queue_work(sdkp->zone_work_q, &zbc_work->zone_work);
> +		/* Kick request queue to be on the safe side */
> +		goto done_start_queue;
> +	}
> +done_free:
> +	kfree(zbc_work);
> +	if (test_and_clear_bit(SD_ZBC_ZONE_INIT, &sdkp->zone_flags) && ret) {
> +		sd_printk(KERN_INFO, sdkp,
> +			  "Cancelling zone initialisation\n");
> +	}
> +done_start_queue:
> +	if (q->mq_ops)
> +		blk_mq_start_hw_queues(q);
> +	else {
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(q->queue_lock, flags);
> +		blk_start_queue(q);
> +		spin_unlock_irqrestore(q->queue_lock, flags);
> +	}
> +}

Which mechanism prevents concurrent execution of 
sd_zbc_refresh_zone_work() and READ and WRITE commands?

Thanks,

Bart.
