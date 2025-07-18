Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFD1230D35;
	Fri, 18 Jul 2025 07:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752824289; cv=none; b=Mt0IK0N6xh3RGXOnDPypCECsRddXPN385wGCJNrd3U9Yv2qsQJpfxoHmz35kyuFNj5uCWpNNj600sojFhDHjZX+MJ9VYzRa4Gj2FWEhzj0mx+jJ6ZzYdhdx7jXvwyUA8rQ/+4sF/xr+jdy9/X/5WlcB/p8/PNqgOZR4OpB8faAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752824289; c=relaxed/simple;
	bh=mRD4HbThPQldbqe0CwnJllxMDU66FdAmyZqPajGkQis=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cEzbeVMDvuxowFl7wOkOAlJzAHkquk8MoYoyr5EssLctGbdJ9IOv/iXBwv/2CpL4pTO253nHEvPj3C2xc4YIIbi0OD6BF6NWiKAOTBa6aasAjy03rBjfDEgfALu0zIaWpmxa2DxruOsFfR3SgYlxw58HeOh7JpaXMsT1nzFwGSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mvr1xSIp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mvr1xSIp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4A4C4CEED;
	Fri, 18 Jul 2025 07:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752824289;
	bh=mRD4HbThPQldbqe0CwnJllxMDU66FdAmyZqPajGkQis=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mvr1xSIp5SR7GNnnYAVo6jbsyQzb4BrI2vJZBUxLL+7ZpFs6FY3rYhNy980V/+3rS
	 TP97M4vggV1xeJ1kBci3KZAudxRcyQTGgXyxLzsHk3Y+fmeKHD+WxpkG/jlkDT3lRI
	 Ip+uLLWGkyTNjoK5a4fDj0Si1tq2XxiaZ+UDgHof5BaVnsi/+lTSK+qxv1i5CsBfGt
	 4h2vgNPd+otSsj1ucW1JhjnVfgEW2UJTn+w99OjLLYZkS4Vz5dUfAstWw8pEZbI3Ri
	 J7gxxJ191wU8S0K7w2fmlpVVc4xXjj+Rq9GZDQW/vmJInOg1aYVJyeKgZT3Hr8SBZm
	 51PrRl2k0agBQ==
Message-ID: <bde0f755-eb69-4799-a9dd-35bf330f78ab@kernel.org>
Date: Fri, 18 Jul 2025 16:38:07 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 07/12] blk-zoned: Support pipelining of zoned writes
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250717205808.3292926-1-bvanassche@acm.org>
 <20250717205808.3292926-8-bvanassche@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250717205808.3292926-8-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/18/25 05:58, Bart Van Assche wrote:
> Support pipelining of zoned writes if the block driver preserves the write
> order per hardware queue. Track per zone to which software queue writes
> have been queued. If zoned writes are pipelined, submit new writes to the
> same software queue as the writes that are already in progress. This
> prevents reordering by submitting requests for the same zone to different
> software or hardware queues.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  block/blk-mq.c    |  4 +--
>  block/blk-zoned.c | 66 ++++++++++++++++++++++++++++++++++++++---------
>  2 files changed, 56 insertions(+), 14 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index c1035a2bbda8..56384b4aadd9 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -3145,8 +3145,8 @@ void blk_mq_submit_bio(struct bio *bio)
>  	/*
>  	 * A BIO that was released from a zone write plug has already been
>  	 * through the preparation in this function, already holds a reference
> -	 * on the queue usage counter, and is the only write BIO in-flight for
> -	 * the target zone. Go straight to preparing a request for it.
> +	 * on the queue usage counter. Go straight to preparing a request for
> +	 * it.
>  	 */
>  	if (bio_zone_write_plugging(bio)) {
>  		nr_segs = bio->__bi_nr_segments;
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 6ef53f78fa3b..3813e4bc8b0b 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -53,6 +53,8 @@ static const char *const zone_cond_name[] = {
>   * @zone_no: The number of the zone the plug is managing.
>   * @wp_offset: The zone write pointer location relative to the start of the zone
>   *             as a number of 512B sectors.
> + * @from_cpu: Software queue to submit writes from for drivers that preserve
> + *	the write order.
>   * @bio_list: The list of BIOs that are currently plugged.
>   * @bio_work: Work struct to handle issuing of plugged BIOs
>   * @rcu_head: RCU head to free zone write plugs with an RCU grace period.
> @@ -65,6 +67,7 @@ struct blk_zone_wplug {
>  	unsigned int		flags;
>  	unsigned int		zone_no;
>  	unsigned int		wp_offset;
> +	int			from_cpu;
>  	struct bio_list		bio_list;
>  	struct work_struct	bio_work;
>  	struct rcu_head		rcu_head;
> @@ -74,8 +77,7 @@ struct blk_zone_wplug {
>  /*
>   * Zone write plug flags bits:
>   *  - BLK_ZONE_WPLUG_PLUGGED: Indicates that the zone write plug is plugged,
> - *    that is, that write BIOs are being throttled due to a write BIO already
> - *    being executed or the zone write plug bio list is not empty.
> + *    that is, that write BIOs are being throttled.
>   *  - BLK_ZONE_WPLUG_NEED_WP_UPDATE: Indicates that we lost track of a zone
>   *    write pointer offset and need to update it.
>   *  - BLK_ZONE_WPLUG_UNHASHED: Indicates that the zone write plug was removed
> @@ -572,6 +574,7 @@ static struct blk_zone_wplug *disk_get_and_lock_zone_wplug(struct gendisk *disk,
>  	zwplug->flags = 0;
>  	zwplug->zone_no = zno;
>  	zwplug->wp_offset = bdev_offset_from_zone_start(disk->part0, sector);
> +	zwplug->from_cpu = -1;
>  	bio_list_init(&zwplug->bio_list);
>  	INIT_WORK(&zwplug->bio_work, blk_zone_wplug_bio_work);
>  	zwplug->disk = disk;
> @@ -768,14 +771,19 @@ static bool blk_zone_wplug_handle_reset_all(struct bio *bio)
>  static void disk_zone_wplug_schedule_bio_work(struct gendisk *disk,
>  					      struct blk_zone_wplug *zwplug)
>  {
> +	lockdep_assert_held(&zwplug->lock);

Unrelated change. Please move this to a prep patch.

> +
>  	/*
>  	 * Take a reference on the zone write plug and schedule the submission
>  	 * of the next plugged BIO. blk_zone_wplug_bio_work() will release the
>  	 * reference we take here.
>  	 */
> -	WARN_ON_ONCE(!(zwplug->flags & BLK_ZONE_WPLUG_PLUGGED));

Why do you remove this warning ?

>  	refcount_inc(&zwplug->ref);
> -	queue_work(disk->zone_wplugs_wq, &zwplug->bio_work);
> +	if (zwplug->from_cpu >= 0)
> +		queue_work_on(zwplug->from_cpu, disk->zone_wplugs_wq,
> +			      &zwplug->bio_work);
> +	else
> +		queue_work(disk->zone_wplugs_wq, &zwplug->bio_work);
>  }
>  
>  static inline void disk_zone_wplug_add_bio(struct gendisk *disk,
> @@ -972,9 +980,12 @@ static bool blk_zone_wplug_prepare_bio(struct blk_zone_wplug *zwplug,
>  	return true;
>  }
>  
> -static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs)
> +static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs,
> +					int from_cpu)
>  {
>  	struct gendisk *disk = bio->bi_bdev->bd_disk;
> +	const bool ordered_hwq = bio_op(bio) != REQ_OP_ZONE_APPEND &&
> +		disk->queue->limits.features & BLK_FEAT_ORDERED_HWQ;

This is not correct. If the BIO is a zone append and
blk_zone_wplug_handle_write() is called, it means that we need to handle the BIO
using zone append emulation, that is, the BIO will be a regular write. So you
must treat it as if it originally was a regular write.

>  	sector_t sector = bio->bi_iter.bi_sector;
>  	bool schedule_bio_work = false;
>  	struct blk_zone_wplug *zwplug;
> @@ -1034,15 +1045,38 @@ static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs)
>  	if (zwplug->flags & BLK_ZONE_WPLUG_PLUGGED)
>  		goto add_to_bio_list;
>  
> +	if (ordered_hwq && zwplug->from_cpu < 0) {
> +		/* No zoned writes are in progress. Select the current CPU. */
> +		zwplug->from_cpu = raw_smp_processor_id();
> +	}
> +
> +	if (ordered_hwq && zwplug->from_cpu == from_cpu) {
> +		/*
> +		 * The block driver preserves the write order, zoned writes have
> +		 * not been plugged and the zoned write will be submitted from
> +		 * zwplug->from_cpu. Let the caller submit the bio.
> +		 */
> +	} else if (ordered_hwq) {
> +		/*
> +		 * The block driver preserves the write order but the caller
> +		 * allocated a request from another CPU. Submit the bio from
> +		 * zwplug->from_cpu.
> +		 */
> +		goto plug;
> +	} else {
> +		/*
> +		 * The block driver does not preserve the write order. Plug and
> +		 * let the caller submit the BIO.
> +		 */
> +		zwplug->flags |= BLK_ZONE_WPLUG_PLUGGED;
> +	}

On the last round of comments, I already suggested a much nicer way of writing
this that does not repeat the if (oredered_hwq) and does not have an empty if
clause:

	if (ordered_hwq) {
		/*
		 * The block driver preserves the write order, zoned writes have
		 * not been plugged and the zoned write will be submitted from
		 * zwplug->from_cpu. Let the caller submit the bio.
		 */
		if (zwplug->from_cpu < 0) {
			/*
			 * No zoned writes are in progress: select the
			 * current CPU.
			 */
			zwplug->from_cpu = raw_smp_processor_id();
		} else if (zwplug->from_cpu != raw_smp_processor_id()) {
			/*
			 * The caller allocated a request from another CPU.
			 * Submit the bio from zwplug->from_cpu.
			 */
			goto plug;
		}
	} else {
		/*
		 * The block driver does not preserve the write order. Plug and
		 * let the caller submit the BIO.
		 */
		zwplug->flags |= BLK_ZONE_WPLUG_PLUGGED;
	}

>  	if (!blk_zone_wplug_prepare_bio(zwplug, bio)) {

You moved the BLK_ZONE_WPLUG_PLUGGED flag set above. So if this fails, you need
to clear this flag and also reset zwplug->from_cpu to -1.

>  		spin_unlock_irqrestore(&zwplug->lock, flags);
>  		bio_io_error(bio);
>  		return true;
>  	}
>  
> -	/* Otherwise, plug and submit the BIO. */
> -	zwplug->flags |= BLK_ZONE_WPLUG_PLUGGED;
> -
>  	spin_unlock_irqrestore(&zwplug->lock, flags);
>  
>  	return false;
> @@ -1150,7 +1184,7 @@ bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs, int rq_cpu)
>  		fallthrough;
>  	case REQ_OP_WRITE:
>  	case REQ_OP_WRITE_ZEROES:
> -		return blk_zone_wplug_handle_write(bio, nr_segs);
> +		return blk_zone_wplug_handle_write(bio, nr_segs, rq_cpu);
>  	case REQ_OP_ZONE_RESET:
>  		return blk_zone_wplug_handle_reset_or_finish(bio, 0);
>  	case REQ_OP_ZONE_FINISH:
> @@ -1182,6 +1216,9 @@ static void disk_zone_wplug_unplug_bio(struct gendisk *disk,
>  
>  	zwplug->flags &= ~BLK_ZONE_WPLUG_PLUGGED;
>  
> +	if (refcount_read(&zwplug->ref) == 2)

This needs a comment explaining why you use the plug ref count instead of
unconditionally clearing from_cpu.

> +		zwplug->from_cpu = -1;
> +
>  	/*
>  	 * If the zone is full (it was fully written or finished, or empty
>  	 * (it was reset), remove its zone write plug from the hash table.
> @@ -1283,6 +1320,8 @@ static void blk_zone_wplug_bio_work(struct work_struct *work)
>  	struct blk_zone_wplug *zwplug =
>  		container_of(work, struct blk_zone_wplug, bio_work);
>  	struct block_device *bdev;
> +	bool ordered_hwq = zwplug->disk->queue->limits.features &
> +				BLK_FEAT_ORDERED_HWQ;

Splitting the line after the "=" would be nicer.

>  	struct bio *bio;
>  
>  	do {
> @@ -1323,7 +1362,7 @@ static void blk_zone_wplug_bio_work(struct work_struct *work)
>  		} else {
>  			blk_mq_submit_bio(bio);
>  		}
> -	} while (0);
> +	} while (ordered_hwq);
>  
>  put_zwplug:
>  	/* Drop the reference we took in disk_zone_wplug_schedule_bio_work(). */
> @@ -1850,6 +1889,7 @@ static void queue_zone_wplug_show(struct blk_zone_wplug *zwplug,
>  	unsigned int zwp_zone_no, zwp_ref;
>  	unsigned int zwp_bio_list_size;
>  	unsigned long flags;
> +	int from_cpu;
>  
>  	spin_lock_irqsave(&zwplug->lock, flags);
>  	zwp_zone_no = zwplug->zone_no;
> @@ -1857,10 +1897,12 @@ static void queue_zone_wplug_show(struct blk_zone_wplug *zwplug,
>  	zwp_ref = refcount_read(&zwplug->ref);
>  	zwp_wp_offset = zwplug->wp_offset;
>  	zwp_bio_list_size = bio_list_size(&zwplug->bio_list);
> +	from_cpu = zwplug->from_cpu;
>  	spin_unlock_irqrestore(&zwplug->lock, flags);
>  
> -	seq_printf(m, "%u 0x%x %u %u %u\n", zwp_zone_no, zwp_flags, zwp_ref,
> -		   zwp_wp_offset, zwp_bio_list_size);
> +	seq_printf(m, "zone_no %u flags 0x%x ref %u wp_offset %u bio_list_size %u from_cpu %d\n",
> +		   zwp_zone_no, zwp_flags, zwp_ref, zwp_wp_offset,
> +		   zwp_bio_list_size, from_cpu);
>  }
>  
>  int queue_zone_wplugs_show(void *data, struct seq_file *m)


-- 
Damien Le Moal
Western Digital Research
