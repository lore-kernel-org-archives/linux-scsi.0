Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6F313213E;
	Tue, 19 Nov 2024 02:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731984655; cv=none; b=Nrmz30cRmIOzMj8O1i/pSzS29NnzcTNTOzd3neyGngam/ZpOO4luEpRS8b7svyPIquWxaPH1TiYrvD2fsHzfs5+H6IOW1VUmGmNER0heNGj1UrpHwL281G7pzMpb7ghtw3VfETkWPXCybKTOCWuMY+Zcy8MFgzGwKADAn/Tvmyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731984655; c=relaxed/simple;
	bh=jA/50qQGcIZSyQtUnzDIVJOBDDrJZTSLP9jL6eXUCuE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aU6hs7+4QJpWUa6OV9tocgDwQ/dIqugdkPfLpic5uicXcVhU6a8j7smvRVNC2rRECbirkerUgopECpbWrxowR0dfwr6+iBLiKT9lpNjDt/3qtYjTtfPRHc0pZw3V+wfknVuO2pXg2tPoG8KcIbuPY6ENCGbUR/hsW/GPAgz5zqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ccu8bqzP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ccu8bqzP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF55CC4CECC;
	Tue, 19 Nov 2024 02:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731984655;
	bh=jA/50qQGcIZSyQtUnzDIVJOBDDrJZTSLP9jL6eXUCuE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ccu8bqzP2a9pCQDaRsD5aEps8ExBlAdLUv7CuD5l/5oIyVX/4iNZ2487PiSxflI13
	 ErtdAPigYjnxOkwIBoXztoLDWnNBs3ZGcft37KksBzO4Ube4VZli9mTO6fCdi32rHz
	 PauyTXPp5n8PzzZeXYRLL/c5tUDDPkMi9M0jHBfW7YFl1yYjagGUlEOvX5YKE217WD
	 etgZcxvOmBmh52FuiWw+eTHuEFplXoY0C+5fSrCzo3Cf+ucoetraSdzsYpTlW2s4ym
	 6gdeLwi0lMSsi9TUSC0N2w0MvShNIKYkuBa69dZpMaFe6poSdQ5od3FaHT04NhfTqn
	 40GB3KxkkCR9w==
Message-ID: <7f4058f9-df04-404c-b4f0-25bf0e8e4886@kernel.org>
Date: Tue, 19 Nov 2024 11:50:48 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 04/26] blk-zoned: Only handle errors after pending
 zoned writes have completed
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-5-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241119002815.600608-5-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/24 9:27 AM, Bart Van Assche wrote:
> Instead of handling write errors immediately, only handle these after all
> pending zoned write requests have completed or have been requeued. This
> patch prepares for changing the zone write pointer tracking approach.

A little more explanations about how this is achieved would be nice. I was
expecting a shorter change given the short commit message... Took some time to
understand the changes without details.

More comments below.

> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  block/blk-mq.c         |   9 +++
>  block/blk-zoned.c      | 154 +++++++++++++++++++++++++++++++++++++++--
>  block/blk.h            |  29 ++++++++
>  include/linux/blk-mq.h |  18 +++++
>  4 files changed, 203 insertions(+), 7 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 270cfd9fc6b0..a45077e187b5 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -793,6 +793,9 @@ void blk_mq_free_request(struct request *rq)
>  	rq_qos_done(q, rq);
>  
>  	WRITE_ONCE(rq->state, MQ_RQ_IDLE);
> +
> +	blk_zone_free_request(rq);
> +
>  	if (req_ref_put_and_test(rq))
>  		__blk_mq_free_request(rq);
>  }
> @@ -1189,6 +1192,9 @@ void blk_mq_end_request_batch(struct io_comp_batch *iob)
>  			continue;
>  
>  		WRITE_ONCE(rq->state, MQ_RQ_IDLE);
> +
> +		blk_zone_free_request(rq);
> +
>  		if (!req_ref_put_and_test(rq))
>  			continue;
>  
> @@ -1507,6 +1513,7 @@ static void __blk_mq_requeue_request(struct request *rq)
>  	if (blk_mq_request_started(rq)) {
>  		WRITE_ONCE(rq->state, MQ_RQ_IDLE);
>  		rq->rq_flags &= ~RQF_TIMED_OUT;
> +		blk_zone_requeue_work(q);
>  	}
>  }
>  
> @@ -1542,6 +1549,8 @@ static void blk_mq_requeue_work(struct work_struct *work)
>  	list_splice_init(&q->flush_list, &flush_list);
>  	spin_unlock_irq(&q->requeue_lock);
>  
> +	blk_zone_requeue_work(q);
> +
>  	while (!list_empty(&rq_list)) {
>  		rq = list_entry(rq_list.next, struct request, queuelist);
>  		/*
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 7e6e6ebb6235..b570b773e65f 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -608,6 +608,8 @@ static inline void disk_zone_wplug_set_error(struct gendisk *disk,
>  	if (zwplug->flags & BLK_ZONE_WPLUG_ERROR)
>  		return;
>  
> +	zwplug->flags |= BLK_ZONE_WPLUG_PLUGGED;
> +	zwplug->flags |= BLK_ZONE_WPLUG_ERROR;

Why move these before the comment ? Also, why set BLK_ZONE_WPLUG_PLUGGED ? It
should be set already since this is handling a failed write that was either
being prepared for submission or submitted (and completed) already. In both
cases, the wplug is plugged since we have a write in flight.

>  	/*
>  	 * At this point, we already have a reference on the zone write plug.
>  	 * However, since we are going to add the plug to the disk zone write
> @@ -616,7 +618,6 @@ static inline void disk_zone_wplug_set_error(struct gendisk *disk,
>  	 * handled, or in disk_zone_wplug_clear_error() if the zone is reset or
>  	 * finished.
>  	 */
> -	zwplug->flags |= BLK_ZONE_WPLUG_ERROR;
>  	refcount_inc(&zwplug->ref);
>  
>  	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
> @@ -642,6 +643,7 @@ static inline void disk_zone_wplug_clear_error(struct gendisk *disk,
>  	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
>  	if (!list_empty(&zwplug->link)) {
>  		list_del_init(&zwplug->link);
> +		zwplug->flags &= ~BLK_ZONE_WPLUG_PLUGGED;
>  		zwplug->flags &= ~BLK_ZONE_WPLUG_ERROR;
>  		disk_put_zone_wplug(zwplug);
>  	}
> @@ -746,6 +748,70 @@ static bool blk_zone_wplug_handle_reset_all(struct bio *bio)
>  	return false;
>  }
>  
> +struct all_zwr_inserted_data {
> +	struct blk_zone_wplug *zwplug;
> +	bool res;
> +};
> +
> +/*
> + * Changes @data->res to %false if and only if @rq is a zoned write for the
> + * given zone and if it is owned by the block driver.

It would be nice to have a request flag or a state indicating that instead of
needing all this code... Can't that be done ?

> + *
> + * @rq members may change while this function is in progress. Hence, use
> + * READ_ONCE() to read @rq members.
> + */
> +static bool blk_zwr_inserted(struct request *rq, void *data)
> +{
> +	struct all_zwr_inserted_data *d = data;
> +	struct blk_zone_wplug *zwplug = d->zwplug;
> +	struct request_queue *q = zwplug->disk->queue;
> +	struct bio *bio = READ_ONCE(rq->bio);
> +
> +	if (rq->q == q && READ_ONCE(rq->state) != MQ_RQ_IDLE &&
> +	    blk_rq_is_seq_zoned_write(rq) && bio &&
> +	    bio_zone_no(bio) == zwplug->zone_no) {
> +		d->res = false;
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +/*
> + * Report whether or not all zoned writes for a zone have been inserted into a
> + * software queue, elevator queue or hardware queue.
> + */
> +static bool blk_zone_all_zwr_inserted(struct blk_zone_wplug *zwplug)
> +{
> +	struct gendisk *disk = zwplug->disk;
> +	struct request_queue *q = disk->queue;
> +	struct all_zwr_inserted_data d = { .zwplug = zwplug, .res = true };
> +	struct blk_mq_hw_ctx *hctx;
> +	long unsigned int i;
> +	struct request *rq;
> +
> +	scoped_guard(spinlock_irqsave, &q->requeue_lock) {
> +		list_for_each_entry(rq, &q->requeue_list, queuelist)
> +			if (blk_rq_is_seq_zoned_write(rq) &&
> +			    bio_zone_no(rq->bio) == zwplug->zone_no)
> +				return false;
> +		list_for_each_entry(rq, &q->flush_list, queuelist)
> +			if (blk_rq_is_seq_zoned_write(rq) &&
> +			    bio_zone_no(rq->bio) == zwplug->zone_no)
> +				return false;
> +	}
> +
> +	queue_for_each_hw_ctx(q, hctx, i) {
> +		struct blk_mq_tags *tags = hctx->sched_tags ?: hctx->tags;
> +
> +		blk_mq_all_tag_iter(tags, blk_zwr_inserted, &d);
> +		if (!d.res || blk_mq_is_shared_tags(q->tag_set->flags))
> +			break;
> +	}
> +
> +	return d.res;
> +}
> +
>  static inline void blk_zone_wplug_add_bio(struct blk_zone_wplug *zwplug,
>  					  struct bio *bio, unsigned int nr_segs)
>  {
> @@ -1096,6 +1162,29 @@ static void disk_zone_wplug_schedule_bio_work(struct gendisk *disk,
>  	queue_work(disk->zone_wplugs_wq, &zwplug->bio_work);
>  }
>  
> +/*
> + * Change the zone state to "error" if a request is requeued to postpone
> + * processing of requeued requests until all pending requests have either
> + * completed or have been requeued.
> + */
> +void blk_zone_write_plug_requeue_request(struct request *rq)
> +{
> +	struct gendisk *disk = rq->q->disk;
> +	struct blk_zone_wplug *zwplug;
> +
> +	if (!disk->zone_wplugs_hash_bits || !blk_rq_is_seq_zoned_write(rq))
> +		return;

I think the disk->zone_wplugs_hash_bits check needs to go inside
disk_get_zone_wplug() as that will avoid a similar check in
blk_zone_write_plug_free_request() too. That said, I am not even convinced it
is needed at all since these functions should be called only for a zoned drive
which should have its zone wplug hash setup.

> +
> +	zwplug = disk_get_zone_wplug(disk, blk_rq_pos(rq));
> +	if (WARN_ON_ONCE(!zwplug))
> +		return;
> +
> +	scoped_guard(spinlock_irqsave, &zwplug->lock)
> +		disk_zone_wplug_set_error(disk, zwplug);
> +
> +	disk_put_zone_wplug(zwplug);
> +}
> +
>  static void disk_zone_wplug_unplug_bio(struct gendisk *disk,
>  				       struct blk_zone_wplug *zwplug)
>  {
> @@ -1202,6 +1291,33 @@ void blk_zone_write_plug_finish_request(struct request *req)
>  	disk_put_zone_wplug(zwplug);
>  }
>  
> +/*
> + * Schedule zone_plugs_work if a zone is in the error state and if no requests
> + * are in flight. Called from blk_mq_free_request().
> + */
> +void blk_zone_write_plug_free_request(struct request *rq)
> +{
> +	struct gendisk *disk = rq->q->disk;
> +	struct blk_zone_wplug *zwplug;
> +
> +	/*
> +	 * Do nothing if this function is called before the zone information
> +	 * has been initialized.
> +	 */
> +	if (!disk->zone_wplugs_hash_bits)
> +		return;
> +
> +	zwplug = disk_get_zone_wplug(disk, blk_rq_pos(rq));
> +

Useless blank line here.

> +	if (!zwplug)
> +		return;
> +
> +	if (zwplug->flags & BLK_ZONE_WPLUG_ERROR)
> +		kblockd_schedule_work(&disk->zone_wplugs_work);

I think this needs to be done under the zone wplug spinlock ?

> +> +	disk_put_zone_wplug(zwplug);
> +}
> +
>  static void blk_zone_wplug_bio_work(struct work_struct *work)
>  {
>  	struct blk_zone_wplug *zwplug =
> @@ -1343,14 +1459,15 @@ static void disk_zone_wplug_handle_error(struct gendisk *disk,
>  
>  static void disk_zone_process_err_list(struct gendisk *disk)
>  {
> -	struct blk_zone_wplug *zwplug;
> +	struct blk_zone_wplug *zwplug, *next;
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
>  
> -	while (!list_empty(&disk->zone_wplugs_err_list)) {
> -		zwplug = list_first_entry(&disk->zone_wplugs_err_list,
> -					  struct blk_zone_wplug, link);
> +	list_for_each_entry_safe(zwplug, next, &disk->zone_wplugs_err_list,
> +				 link) {

You are holding the disk zwplug spinlock, so why use the _safe() loop ? Not
needed, right ?

> +		if (!blk_zone_all_zwr_inserted(zwplug))
> +			continue;
>  		list_del_init(&zwplug->link);
>  		spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
>  
> @@ -1361,6 +1478,12 @@ static void disk_zone_process_err_list(struct gendisk *disk)
>  	}
>  
>  	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
> +
> +	/*
> +	 * If one or more zones have been skipped, this work will be requeued
> +	 * when a request is requeued (blk_zone_requeue_work()) or freed
> +	 * (blk_zone_write_plug_free_request()).
> +	 */
>  }
>  
>  static void disk_zone_wplugs_work(struct work_struct *work)
> @@ -1371,6 +1494,20 @@ static void disk_zone_wplugs_work(struct work_struct *work)
>  	disk_zone_process_err_list(disk);
>  }
>  
> +/* May be called from interrupt context and hence must not sleep. */
> +void blk_zone_requeue_work(struct request_queue *q)
> +{
> +	struct gendisk *disk = q->disk;
> +
> +	if (!disk)
> +		return;

Can this happen ?

> +
> +	if (in_interrupt())
> +		kblockd_schedule_work(&disk->zone_wplugs_work);
> +	else
> +		disk_zone_process_err_list(disk);
> +}
> +
>  static inline unsigned int disk_zone_wplugs_hash_size(struct gendisk *disk)
>  {
>  	return 1U << disk->zone_wplugs_hash_bits;
> @@ -1854,8 +1991,11 @@ static void queue_zone_wplug_show(struct blk_zone_wplug *zwplug,
>  	zwp_bio_list_size = bio_list_size(&zwplug->bio_list);
>  	spin_unlock_irqrestore(&zwplug->lock, flags);
>  
> -	seq_printf(m, "%u 0x%x %u %u %u\n", zwp_zone_no, zwp_flags, zwp_ref,
> -		   zwp_wp_offset, zwp_bio_list_size);
> +	bool all_zwr_inserted = blk_zone_all_zwr_inserted(zwplug);

Is this bool really needed ? If it is, shouldn't it be assigned while holding
the zwplug lock to have a "snapshot" of the plug with all printed values
consistent ?

> +
> +	seq_printf(m, "zone_no %u flags 0x%x ref %u wp_offset %u bio_list_size %u all_zwr_inserted %d\n",
> +		   zwp_zone_no, zwp_flags, zwp_ref, zwp_wp_offset,
> +		   zwp_bio_list_size, all_zwr_inserted);
>  }
>  
>  int queue_zone_wplugs_show(void *data, struct seq_file *m)
> diff --git a/block/blk.h b/block/blk.h
> index 2c26abf505b8..be945db6298d 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -473,6 +473,18 @@ static inline void blk_zone_update_request_bio(struct request *rq,
>  	if (req_op(rq) == REQ_OP_ZONE_APPEND || bio_zone_write_plugging(bio))
>  		bio->bi_iter.bi_sector = rq->__sector;
>  }
> +
> +void blk_zone_write_plug_requeue_request(struct request *rq);
> +static inline void blk_zone_requeue_request(struct request *rq)
> +{
> +	if (!blk_rq_is_seq_zoned_write(rq))
> +		return;
> +
> +	blk_zone_write_plug_requeue_request(rq);

May be:

	if (blk_rq_is_seq_zoned_write(rq))
		blk_zone_write_plug_requeue_request(rq);

?

> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index c596e0e4cb75..ac05974f08f9 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -1169,4 +1169,22 @@ static inline int blk_rq_map_sg(struct request_queue *q, struct request *rq,
>  }
>  void blk_dump_rq_flags(struct request *, char *);
>  
> +#ifdef CONFIG_BLK_DEV_ZONED
> +static inline bool blk_rq_is_seq_zoned_write(struct request *rq)

bdev_zone_is_seq() is already stubbed for the !CONFIG_BLK_DEV_ZONED case, so I
do not think this function needs the ifdef. It will compile either way and will
never be called from anywhere in the !CONFIG_BLK_DEV_ZONED case.

> +{
> +	switch (req_op(rq)) {
> +	case REQ_OP_WRITE:
> +	case REQ_OP_WRITE_ZEROES:
> +		return bdev_zone_is_seq(rq->q->disk->part0, blk_rq_pos(rq));
> +	default:
> +		return false;
> +	}
> +}
> +#else /* CONFIG_BLK_DEV_ZONED */
> +static inline bool blk_rq_is_seq_zoned_write(struct request *rq)
> +{
> +	return false;
> +}
> +#endif /* CONFIG_BLK_DEV_ZONED */
> +
>  #endif /* BLK_MQ_H */


-- 
Damien Le Moal
Western Digital Research
