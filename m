Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E70136345;
	Tue, 19 Nov 2024 02:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731985074; cv=none; b=IX8XUbBD8RweoWpR4TxfNUdDAadztv9xCSCjrGOLacO6Jb6gCZi02Z2jkXEllRd/4RB5/qf0IdQbKd8SJRSUKDx1YyCf6vgTRezED1UyfTYpVbAwwh5kcoqvbjI7QYcU0aLTISI/+Lb7PNpnFcODhu6M656VBPOw4T5aZZcLACg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731985074; c=relaxed/simple;
	bh=W0KWLflqXi5QzE8+2M0dtDHA4+llTcyzcl92wC36B5Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pkJ5WoTqvWzn/+ngu/TTaT0j9/PcmT0k5zlV9NnV/QBlk5avB3DN1rSWZJeeQ+SB1x2qeZKbMKu3QANXPkAzLDxf+b5gIrxW46tvb54+9Xu2e1849MiV+iQ1BlnBufQUhkOw5MqrcOrhtKm4/eMyuwfA+by+9nWW41qplU2Zp4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jz+S4V9n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jz+S4V9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2A0C4CECC;
	Tue, 19 Nov 2024 02:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731985074;
	bh=W0KWLflqXi5QzE8+2M0dtDHA4+llTcyzcl92wC36B5Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jz+S4V9n2EPkWUF9c6FpIoGHs/Tjze7uEL+0pZE6pSmhhWRzU0yQvMIhXwnMt8U1J
	 SW/Ydcvrd4KSKkBBScWuNPso5EhZu+ueg27D4PePkd65zD7RJQyhb76HtNzZYNbmLB
	 lsuN/MMkuexryOi+Tr/hZC1C1n9IKbc2bjK4R/loHhyIjyr+BxIY0nSATzAwRYXNo4
	 qWZN1AfVzBmjk8FHKz2afPsTZlg2D+ZerbnHVn2TyZ9g2XIIVO5c98w6uUxC+RoBm0
	 RNHHS8HiC5iK9MztQ8t4R1s4ZQUyGqg16zQS3UiCrwgQFLFXZ150bdmWlB90VFUspP
	 HeRPi5UaJDJVw==
Message-ID: <6729e88d-5311-4b6e-a3da-0f144aab56c9@kernel.org>
Date: Tue, 19 Nov 2024 11:57:48 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 05/26] blk-zoned: Fix a deadlock triggered by
 unaligned writes
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-6-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241119002815.600608-6-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/24 9:27 AM, Bart Van Assche wrote:
> If the queue is filled with unaligned writes then the following
> deadlock occurs:
> 
> Call Trace:
>  <TASK>
>  __schedule+0x8cc/0x2190
>  schedule+0xdd/0x2b0
>  blk_queue_enter+0x2ce/0x4f0
>  blk_mq_alloc_request+0x303/0x810
>  scsi_execute_cmd+0x3f4/0x7b0
>  sd_zbc_do_report_zones+0x19e/0x4c0
>  sd_zbc_report_zones+0x304/0x920
>  disk_zone_wplug_handle_error+0x237/0x920
>  disk_zone_wplugs_work+0x17e/0x430
>  process_one_work+0xdd0/0x1490
>  worker_thread+0x5eb/0x1010
>  kthread+0x2e5/0x3b0
>  ret_from_fork+0x3a/0x80
>  </TASK>
> 
> Fix this deadlock by removing the disk->fops->report_zones() call and by
> deriving the write pointer information from successfully completed zoned
> writes.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Doesn't this need a Fixes tag and CC stable, and come earlier in the series (or
sent separately) ?

Overall, this patch seems wrong anyway as zone reset and zone finish may be
done between 2 writes, failing the next one but the recovery done here will use
the previous succeful write end position as the wp, which is NOT correct as
reset or finish changed that... And we also have the possibility of torn writes
(partial writes) with SAS SMR drives. So I really think that you cannot avoid
doing a report zone to recover errors.

> ---
>  block/blk-zoned.c | 69 +++++++++++++++++++----------------------------
>  block/blk.h       |  4 ++-
>  2 files changed, 31 insertions(+), 42 deletions(-)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index b570b773e65f..284820b29285 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -56,6 +56,8 @@ static const char *const zone_cond_name[] = {
>   * @zone_no: The number of the zone the plug is managing.
>   * @wp_offset: The zone write pointer location relative to the start of the zone
>   *             as a number of 512B sectors.
> + * @wp_offset_compl: End offset for completed zoned writes as a number of 512
> + *		     byte sectors.
>   * @bio_list: The list of BIOs that are currently plugged.
>   * @bio_work: Work struct to handle issuing of plugged BIOs
>   * @rcu_head: RCU head to free zone write plugs with an RCU grace period.
> @@ -69,6 +71,7 @@ struct blk_zone_wplug {
>  	unsigned int		flags;
>  	unsigned int		zone_no;
>  	unsigned int		wp_offset;
> +	unsigned int		wp_offset_compl;
>  	struct bio_list		bio_list;
>  	struct work_struct	bio_work;
>  	struct rcu_head		rcu_head;
> @@ -531,6 +534,7 @@ static struct blk_zone_wplug *disk_get_and_lock_zone_wplug(struct gendisk *disk,
>  	zwplug->flags = 0;
>  	zwplug->zone_no = zno;
>  	zwplug->wp_offset = sector & (disk->queue->limits.chunk_sectors - 1);
> +	zwplug->wp_offset_compl = 0;
>  	bio_list_init(&zwplug->bio_list);
>  	INIT_WORK(&zwplug->bio_work, blk_zone_wplug_bio_work);
>  	zwplug->disk = disk;
> @@ -1226,6 +1230,7 @@ void blk_zone_write_plug_bio_endio(struct bio *bio)
>  	struct gendisk *disk = bio->bi_bdev->bd_disk;
>  	struct blk_zone_wplug *zwplug =
>  		disk_get_zone_wplug(disk, bio->bi_iter.bi_sector);
> +	unsigned int end_sector;
>  	unsigned long flags;
>  
>  	if (WARN_ON_ONCE(!zwplug))
> @@ -1243,11 +1248,24 @@ void blk_zone_write_plug_bio_endio(struct bio *bio)
>  		bio->bi_opf |= REQ_OP_ZONE_APPEND;
>  	}
>  
> -	/*
> -	 * If the BIO failed, mark the plug as having an error to trigger
> -	 * recovery.
> -	 */
> -	if (bio->bi_status != BLK_STS_OK) {
> +	if (bio->bi_status == BLK_STS_OK) {
> +		switch (bio_op(bio)) {
> +		case REQ_OP_WRITE:
> +		case REQ_OP_ZONE_APPEND:
> +		case REQ_OP_WRITE_ZEROES:
> +			end_sector = bdev_offset_from_zone_start(disk->part0,
> +				     bio->bi_iter.bi_sector + bio_sectors(bio));
> +			if (end_sector > zwplug->wp_offset_compl)
> +				zwplug->wp_offset_compl = end_sector;
> +			break;
> +		default:
> +			break;
> +		}
> +	} else {
> +		/*
> +		 * If the BIO failed, mark the plug as having an error to
> +		 * trigger recovery.
> +		 */
>  		spin_lock_irqsave(&zwplug->lock, flags);
>  		disk_zone_wplug_set_error(disk, zwplug);
>  		spin_unlock_irqrestore(&zwplug->lock, flags);
> @@ -1388,30 +1406,10 @@ static unsigned int blk_zone_wp_offset(struct blk_zone *zone)
>  	}
>  }
>  
> -static int blk_zone_wplug_report_zone_cb(struct blk_zone *zone,
> -					 unsigned int idx, void *data)
> -{
> -	struct blk_zone *zonep = data;
> -
> -	*zonep = *zone;
> -	return 0;
> -}
> -
>  static void disk_zone_wplug_handle_error(struct gendisk *disk,
>  					 struct blk_zone_wplug *zwplug)
>  {
> -	sector_t zone_start_sector =
> -		bdev_zone_sectors(disk->part0) * zwplug->zone_no;
> -	unsigned int noio_flag;
> -	struct blk_zone zone;
>  	unsigned long flags;
> -	int ret;
> -
> -	/* Get the current zone information from the device. */
> -	noio_flag = memalloc_noio_save();
> -	ret = disk->fops->report_zones(disk, zone_start_sector, 1,
> -				       blk_zone_wplug_report_zone_cb, &zone);
> -	memalloc_noio_restore(noio_flag);
>  
>  	spin_lock_irqsave(&zwplug->lock, flags);
>  
> @@ -1425,19 +1423,8 @@ static void disk_zone_wplug_handle_error(struct gendisk *disk,
>  
>  	zwplug->flags &= ~BLK_ZONE_WPLUG_ERROR;
>  
> -	if (ret != 1) {
> -		/*
> -		 * We failed to get the zone information, meaning that something
> -		 * is likely really wrong with the device. Abort all remaining
> -		 * plugged BIOs as otherwise we could endup waiting forever on
> -		 * plugged BIOs to complete if there is a queue freeze on-going.
> -		 */
> -		disk_zone_wplug_abort(zwplug);
> -		goto unplug;
> -	}
> -
>  	/* Update the zone write pointer offset. */
> -	zwplug->wp_offset = blk_zone_wp_offset(&zone);
> +	zwplug->wp_offset = zwplug->wp_offset_compl;
>  	disk_zone_wplug_abort_unaligned(disk, zwplug);
>  
>  	/* Restart BIO submission if we still have any BIO left. */
> @@ -1446,7 +1433,6 @@ static void disk_zone_wplug_handle_error(struct gendisk *disk,
>  		goto unlock;
>  	}
>  
> -unplug:
>  	zwplug->flags &= ~BLK_ZONE_WPLUG_PLUGGED;
>  	if (disk_should_remove_zone_wplug(disk, zwplug))
>  		disk_remove_zone_wplug(disk, zwplug);
> @@ -1978,7 +1964,7 @@ EXPORT_SYMBOL_GPL(blk_revalidate_disk_zones);
>  static void queue_zone_wplug_show(struct blk_zone_wplug *zwplug,
>  				  struct seq_file *m)
>  {
> -	unsigned int zwp_wp_offset, zwp_flags;
> +	unsigned int zwp_wp_offset, zwp_wp_offset_compl, zwp_flags;
>  	unsigned int zwp_zone_no, zwp_ref;
>  	unsigned int zwp_bio_list_size;
>  	unsigned long flags;
> @@ -1988,14 +1974,15 @@ static void queue_zone_wplug_show(struct blk_zone_wplug *zwplug,
>  	zwp_flags = zwplug->flags;
>  	zwp_ref = refcount_read(&zwplug->ref);
>  	zwp_wp_offset = zwplug->wp_offset;
> +	zwp_wp_offset_compl = zwplug->wp_offset_compl;
>  	zwp_bio_list_size = bio_list_size(&zwplug->bio_list);
>  	spin_unlock_irqrestore(&zwplug->lock, flags);
>  
>  	bool all_zwr_inserted = blk_zone_all_zwr_inserted(zwplug);
>  
> -	seq_printf(m, "zone_no %u flags 0x%x ref %u wp_offset %u bio_list_size %u all_zwr_inserted %d\n",
> +	seq_printf(m, "zone_no %u flags 0x%x ref %u wp_offset %u wp_offset_compl %u bio_list_size %u all_zwr_inserted %d\n",
>  		   zwp_zone_no, zwp_flags, zwp_ref, zwp_wp_offset,
> -		   zwp_bio_list_size, all_zwr_inserted);
> +		   zwp_wp_offset_compl, zwp_bio_list_size, all_zwr_inserted);
>  }
>  
>  int queue_zone_wplugs_show(void *data, struct seq_file *m)
> diff --git a/block/blk.h b/block/blk.h
> index be945db6298d..88a6e258eafe 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -470,8 +470,10 @@ static inline void blk_zone_update_request_bio(struct request *rq,
>  	 * the original BIO sector so that blk_zone_write_plug_bio_endio() can
>  	 * lookup the zone write plug.
>  	 */
> -	if (req_op(rq) == REQ_OP_ZONE_APPEND || bio_zone_write_plugging(bio))
> +	if (req_op(rq) == REQ_OP_ZONE_APPEND || bio_zone_write_plugging(bio)) {
>  		bio->bi_iter.bi_sector = rq->__sector;
> +		bio->bi_iter.bi_size = rq->__data_len;
> +	}
>  }
>  
>  void blk_zone_write_plug_requeue_request(struct request *rq);


-- 
Damien Le Moal
Western Digital Research
