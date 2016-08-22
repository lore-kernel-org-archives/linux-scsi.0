From: Damien Le Moal <damien.lemoal@hgst.com>
Subject: Re: [PATCH v2 2/4] On Discard either do Reset WP or Write Same
Date: Tue, 23 Aug 2016 08:57:15 +0900
Message-ID: <53c2949f-f8b9-463f-2adf-faf4603429bb@hgst.com>
References: <20160822043116.21168-1-shaun@tancheff.com>
 <20160822043116.21168-3-shaun@tancheff.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:58301 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752999AbcHVX51 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Aug 2016 19:57:27 -0400
In-Reply-To: <20160822043116.21168-3-shaun@tancheff.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shaun Tancheff <shaun@tancheff.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Josh Bingaman <josh.bingaman@seagate.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Christie <mchristi@redhat.com>, Toshi Kani <toshi.kani@hpe.com>, Ming Lei <ming.lei@canonical.com>, Shaun Tancheff <shaun.tancheff@seagate.com>


Shaun,

On 8/22/16 13:31, Shaun Tancheff wrote:
[...]
> -int sd_zbc_setup_discard(struct scsi_disk *sdkp, struct request *rq,
> -			 sector_t sector, unsigned int num_sectors)
> +int sd_zbc_setup_discard(struct scsi_cmnd *cmd)
>  {
> -	struct blk_zone *zone;
> +	struct request *rq = cmd->request;
> +	struct scsi_device *sdp = cmd->device;
> +	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
> +	sector_t sector = blk_rq_pos(rq);
> +	unsigned int nr_sectors = blk_rq_sectors(rq);
>  	int ret = BLKPREP_OK;
> +	struct blk_zone *zone;
>  	unsigned long flags;
> +	u32 wp_offset;
> +	bool use_write_same = false;
>  
>  	zone = blk_lookup_zone(rq->q, sector);
> -	if (!zone)
> +	if (!zone) {
> +		/* Test for a runt zone before giving up */
> +		if (sdp->type != TYPE_ZBC) {
> +			struct request_queue *q = rq->q;
> +			struct rb_node *node;
> +
> +			node = rb_last(&q->zones);
> +			if (node)
> +				zone = rb_entry(node, struct blk_zone, node);
> +			if (zone) {
> +				spin_lock_irqsave(&zone->lock, flags);
> +				if ((zone->start + zone->len) <= sector)
> +					goto out;
> +				spin_unlock_irqrestore(&zone->lock, flags);
> +				zone = NULL;
> +			}
> +		}
>  		return BLKPREP_KILL;
> +	}

I do not understand the point of this code here to test for the runt
zone. As long as sector is within the device maximum capacity (in 512B
unit), blk_lookup_zone will return the pointer to the zone structure
containing that sector (the RB-tree does not have any constraint
regarding zone size). The only case where NULL would be returned is if
discard is issued super early right after the disk is probed and before
the zone refresh work has completed. We can certainly protect against
that by delaying the discard.


>  
>  	spin_lock_irqsave(&zone->lock, flags);
> -
>  	if (zone->state == BLK_ZONE_UNKNOWN ||
>  	    zone->state == BLK_ZONE_BUSY) {
>  		sd_zbc_debug_ratelimit(sdkp,
> -				       "Discarding zone %zu state %x, deferring\n",
> +				       "Discarding zone %zx state %x, deferring\n",

Sector values are usually displayed in decimal. Why use Hex here ? At
least "0x" would be needed to avoid confusion I think.

>  				       zone->start, zone->state);
>  		ret = BLKPREP_DEFER;
>  		goto out;
> @@ -406,46 +428,80 @@ int sd_zbc_setup_discard(struct scsi_disk *sdkp, struct request *rq,
>  	if (zone->state == BLK_ZONE_OFFLINE) {
>  		/* let the drive fail the command */
>  		sd_zbc_debug_ratelimit(sdkp,
> -				       "Discarding offline zone %zu\n",
> +				       "Discarding offline zone %zx\n",
>  				       zone->start);
>  		goto out;
>  	}
> -
> -	if (!blk_zone_is_smr(zone)) {
> +	if (blk_zone_is_cmr(zone)) {
> +		use_write_same = true;
>  		sd_zbc_debug_ratelimit(sdkp,
> -				       "Discarding %s zone %zu\n",
> -				       blk_zone_is_cmr(zone) ? "CMR" : "unknown",
> +				       "Discarding CMR zone %zx\n",
>  				       zone->start);
> -		ret = BLKPREP_DONE;
>  		goto out;
>  	}

Some 10TB host managed disks out there have 1% conventional zone space,
that is 100GB of capacity. When issuing a "reset all", doing a write
same in these zones will take forever... If the user really wants zeroes
in those zones, let it issue a zeroout.

I think that it would a better choice to simply not report
discard_zeroes_data as true and do nothing for conventional zones reset.

> -	if (blk_zone_is_empty(zone)) {
> -		sd_zbc_debug_ratelimit(sdkp,
> -				       "Discarding empty zone %zu\n",
> -				       zone->start);
> -		ret = BLKPREP_DONE;
> +	if (zone->start != sector || zone->len < nr_sectors) {
> +		sd_printk(KERN_ERR, sdkp,
> +			  "Misaligned RESET WP %zx/%x on zone %zx/%zx\n",
> +			  sector, nr_sectors, zone->start, zone->len);
> +		ret = BLKPREP_KILL;
>  		goto out;
>  	}
> -
> -	if (zone->start != sector ||
> -	    zone->len < num_sectors) {
> +	/* Protect against Reset WP when more data had been written to the
> +	 * zone than is being discarded.
> +	 */
> +	wp_offset = zone->wp - zone->start;
> +	if (wp_offset > nr_sectors) {
>  		sd_printk(KERN_ERR, sdkp,
> -			  "Misaligned RESET WP, start %zu/%zu "
> -			  "len %zu/%u\n",
> -			  zone->start, sector, zone->len, num_sectors);
> +			  "Will Corrupt RESET WP %zx/%x/%x on zone %zx/%zx/%zx\n",
> +			  sector, wp_offset, nr_sectors,
> +			  zone->start, zone->wp, zone->len);
>  		ret = BLKPREP_KILL;
>  		goto out;
>  	}
> -
> -	/*
> -	 * Opportunistic setting, will be fixed up with
> -	 * zone update if RESET WRITE POINTER fails.
> -	 */
> -	zone->wp = zone->start;
> +	if (blk_zone_is_empty(zone)) {
> +		sd_zbc_debug_ratelimit(sdkp,
> +				       "Discarding empty zone %zx [WP: %zx]\n",
> +				       zone->start, zone->wp);
> +		ret = BLKPREP_DONE;
> +		goto out;
> +	}
>  
>  out:
>  	spin_unlock_irqrestore(&zone->lock, flags);
>  
> +	if (ret != BLKPREP_OK)
> +		goto done;
> +	/*
> +	 * blk_zone cache uses block layer sector units
> +	 * but commands use device units
> +	 */
> +	sector >>= ilog2(sdp->sector_size) - 9;
> +	nr_sectors >>= ilog2(sdp->sector_size) - 9;
> +
> +	if (use_write_same) {
> +		cmd->cmd_len = 16;
> +		cmd->cmnd[0] = WRITE_SAME_16;
> +		cmd->cmnd[1] = 0; /* UNMAP (not set) */
> +		put_unaligned_be64(sector, &cmd->cmnd[2]);
> +		put_unaligned_be32(nr_sectors, &cmd->cmnd[10]);
> +		cmd->transfersize = sdp->sector_size;
> +		rq->timeout = SD_WRITE_SAME_TIMEOUT;
> +	} else {
> +		cmd->cmd_len = 16;
> +		cmd->cmnd[0] = ZBC_OUT;
> +		cmd->cmnd[1] = ZO_RESET_WRITE_POINTER;
> +		put_unaligned_be64(sector, &cmd->cmnd[2]);
> +		/* Reset Write Pointer doesn't have a payload */
> +		cmd->transfersize = 0;
> +		cmd->sc_data_direction = DMA_NONE;
> +		/*
> +		 * Opportunistic setting, will be fixed up with
> +		 * zone update if RESET WRITE POINTER fails.
> +		 */
> +		zone->wp = zone->start;
> +	}
> +
> +done:
>  	return ret;
>  }
>  
> @@ -468,6 +524,9 @@ int sd_zbc_setup_read_write(struct scsi_disk *sdkp, struct request *rq,
>  
>  	spin_lock_irqsave(&zone->lock, flags);
>  
> +	if (blk_zone_is_cmr(zone))
> +		goto out;
> +
>  	if (zone->state == BLK_ZONE_UNKNOWN ||
>  	    zone->state == BLK_ZONE_BUSY) {
>  		sd_zbc_debug_ratelimit(sdkp,
> @@ -476,16 +535,6 @@ int sd_zbc_setup_read_write(struct scsi_disk *sdkp, struct request *rq,
>  		ret = BLKPREP_DEFER;
>  		goto out;
>  	}
> -	if (zone->state == BLK_ZONE_OFFLINE) {
> -		/* let the drive fail the command */
> -		sd_zbc_debug_ratelimit(sdkp,
> -				       "zone %zu offline\n",
> -				       zone->start);
> -		goto out;
> -	}
> -
> -	if (blk_zone_is_cmr(zone))
> -		goto out;
>  
>  	if (blk_zone_is_seq_pref(zone)) {
>  		if (op_is_write(req_op(rq))) {
> @@ -514,6 +563,14 @@ int sd_zbc_setup_read_write(struct scsi_disk *sdkp, struct request *rq,
>  		goto out;
>  	}
>  
> +	if (zone->state == BLK_ZONE_OFFLINE) {
> +		/* let the drive fail the command */
> +		sd_zbc_debug_ratelimit(sdkp,
> +				       "zone %zu offline\n",
> +				       zone->start);
> +		goto out;
> +	}
> +
>  	if (op_is_write(req_op(rq))) {
>  		if (zone->state == BLK_ZONE_READONLY)
>  			goto out;
> 

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Group, HGST Research,
HGST, a Western Digital brand
Damien.LeMoal@hgst.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa, 
Kanagawa, 252-0888 Japan
www.hgst.com
