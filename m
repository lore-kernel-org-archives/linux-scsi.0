Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EBD2D8790;
	Wed, 15 Oct 2025 07:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760513485; cv=none; b=Xx7nyRuj5+27phZNjSeOl6c1k1kLb7Z4+HRqAD2M/cbxmH0fgHfDGqI7Uxh9q6tbGBDmqP7Ms1kN1azOmOfavV+JZmN+r137WJcKnNjLp2iDrt0dQvU+eii2dHMB/GgBli+8De8Xdt5kINEWDlYa8FnjJ1W5pa6A83WKoqfFQx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760513485; c=relaxed/simple;
	bh=4+GhEK4Bg6XPxFmajuRpCf43CYDaKzOYj9QORm5/Xok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rXALyeVYnrIVCm4c1dp8MEspeKk3xxMs0V/tYtazek8rm1hmm/YhIDMdmh4v4Lmg1vDxdf3KPwuhWOJlQ03L4sA1uL/GXL+k/VN0WvyBGieHAx5IXuaBNLLZnHsjlWJpphwubg5/b02YgzhRUQ1nISDaj22v6mf4rw4YIMBVoLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gNyeWfUt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gNyeWfUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2601BC4CEF8;
	Wed, 15 Oct 2025 07:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760513484;
	bh=4+GhEK4Bg6XPxFmajuRpCf43CYDaKzOYj9QORm5/Xok=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gNyeWfUt8lZ0/i2yoj9qx7UETiYpE3Lq5kxFAd556Jbt6uL0XdlI/TGmf8u9POhml
	 uKLWdWGIakU9BTzIXWpgZgCRE6v/WbzpKmyjY7ORmcha0OHzadvDN8Zi4i0arxrEkN
	 ZSsQ5+26ouBYGF6pDqvDCZ4ep1ZkR1lkH0YiGW/0ljiFp5QLFZrHTk0OZcGlWzEU8L
	 QOFMBWfG/3Uu3e4oXu7o1sekZDrJzuHjW2Yts25P9ExnplF+WzAyMq9bzEkDQTQMh6
	 4/x2XuF+jBD1C5K2Ns8jhkjoS/6O2UvGHxx+IlRd6vY2nDr71rmu9gaJfdSFdYjuYx
	 1PJn70xJSOH4g==
Message-ID: <08ce89bb-756a-4ce8-9980-ddea8baab1d1@kernel.org>
Date: Wed, 15 Oct 2025 16:31:23 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v25 07/20] block/mq-deadline: Enable zoned write
 pipelining
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20251014215428.3686084-1-bvanassche@acm.org>
 <20251014215428.3686084-8-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20251014215428.3686084-8-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025/10/15 6:54, Bart Van Assche wrote:
> The hwq selected by blk_mq_run_hw_queues() for single-queue I/O schedulers
> depends on the CPU core that function has been called from. This may lead
> to concurrent dispatching of I/O requests on different CPU cores and hence
> may cause I/O reordering. Prevent as follows that zoned writes are
> reordered:
> - Set the ELEVATOR_FLAG_SUPPORTS_ZONED_WRITE_PIPELINING flag. This disables
>   the single hwq optimization in the block layer core.
> - Modify dd_has_work() such that it only reports that any work is pending
>   for zoned writes if the zoned writes have been submitted to the hwq that
>   has been passed as argument to dd_has_work().
> - Modify dd_dispatch_request() such that it only dispatches zoned writes
>   if the hwq argument passed to this function matches the hwq of the
>   pending zoned writes.

One of the goals of zone write plugging was to remove the dependence on IO
schedulers to control the ordering of write commands to zoned block devices.
Such change are going backward and I do not like that. What if the user sets
Kyber or bfq with your zone write pipelining ? Does it break ?

From the very light explanation above, it seems to me that what you are trying
to do can be generic in the block layer and leave mq-deadline untouched.

> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  block/mq-deadline.c | 68 ++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 58 insertions(+), 10 deletions(-)
> 
> diff --git a/block/mq-deadline.c b/block/mq-deadline.c
> index 0a46d0f06f72..be6ed3d8fa36 100644
> --- a/block/mq-deadline.c
> +++ b/block/mq-deadline.c
> @@ -319,11 +319,25 @@ static struct request *dd_start_request(struct deadline_data *dd,
>  	return rq;
>  }
>  
> +/*
> + * If write pipelining is enabled, only dispatch sequential zoned writes if
> + * rq->mq_hctx == hctx.
> + */
> +static bool dd_dispatch_from_hctx(struct blk_mq_hw_ctx *hctx,
> +				  struct request *rq)
> +{
> +	struct request_queue *q = hctx->queue;
> +
> +	return !(q->limits.features & BLK_FEAT_ORDERED_HWQ) ||
> +		rq->mq_hctx == hctx || !blk_rq_is_seq_zoned_write(rq);
> +}
> +
>  /*
>   * deadline_dispatch_requests selects the best request according to
>   * read/write expire, fifo_batch, etc and with a start time <= @latest_start.
>   */
>  static struct request *__dd_dispatch_request(struct deadline_data *dd,
> +					     struct blk_mq_hw_ctx *hctx,
>  					     struct dd_per_prio *per_prio,
>  					     unsigned long latest_start)
>  {
> @@ -336,7 +350,8 @@ static struct request *__dd_dispatch_request(struct deadline_data *dd,
>  	 * batches are currently reads XOR writes
>  	 */
>  	rq = deadline_next_request(dd, per_prio, dd->last_dir);
> -	if (rq && dd->batching < dd->fifo_batch) {
> +	if (rq && dd->batching < dd->fifo_batch &&
> +	    dd_dispatch_from_hctx(hctx, rq)) {
>  		/* we have a next request and are still entitled to batch */
>  		data_dir = rq_data_dir(rq);
>  		goto dispatch_request;
> @@ -396,7 +411,7 @@ static struct request *__dd_dispatch_request(struct deadline_data *dd,
>  		rq = next_rq;
>  	}
>  
> -	if (!rq)
> +	if (!rq || !dd_dispatch_from_hctx(hctx, rq))
>  		return NULL;
>  
>  	dd->last_dir = data_dir;
> @@ -418,8 +433,9 @@ static struct request *__dd_dispatch_request(struct deadline_data *dd,
>   * Check whether there are any requests with priority other than DD_RT_PRIO
>   * that were inserted more than prio_aging_expire jiffies ago.
>   */
> -static struct request *dd_dispatch_prio_aged_requests(struct deadline_data *dd,
> -						      unsigned long now)
> +static struct request *
> +dd_dispatch_prio_aged_requests(struct deadline_data *dd,
> +			       struct blk_mq_hw_ctx *hctx, unsigned long now)
>  {
>  	struct request *rq;
>  	enum dd_prio prio;
> @@ -433,7 +449,7 @@ static struct request *dd_dispatch_prio_aged_requests(struct deadline_data *dd,
>  		return NULL;
>  
>  	for (prio = DD_BE_PRIO; prio <= DD_PRIO_MAX; prio++) {
> -		rq = __dd_dispatch_request(dd, &dd->per_prio[prio],
> +		rq = __dd_dispatch_request(dd, hctx, &dd->per_prio[prio],
>  					   now - dd->prio_aging_expire);
>  		if (rq)
>  			return rq;
> @@ -466,7 +482,7 @@ static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
>  		goto unlock;
>  	}
>  
> -	rq = dd_dispatch_prio_aged_requests(dd, now);
> +	rq = dd_dispatch_prio_aged_requests(dd, hctx, now);
>  	if (rq)
>  		goto unlock;
>  
> @@ -475,7 +491,7 @@ static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
>  	 * requests if any higher priority requests are pending.
>  	 */
>  	for (prio = 0; prio <= DD_PRIO_MAX; prio++) {
> -		rq = __dd_dispatch_request(dd, &dd->per_prio[prio], now);
> +		rq = __dd_dispatch_request(dd, hctx, &dd->per_prio[prio], now);
>  		if (rq || dd_queued(dd, prio))
>  			break;
>  	}
> @@ -575,6 +591,8 @@ static int dd_init_sched(struct request_queue *q, struct elevator_queue *eq)
>  	/* We dispatch from request queue wide instead of hw queue */
>  	blk_queue_flag_set(QUEUE_FLAG_SQ_SCHED, q);
>  
> +	set_bit(ELEVATOR_FLAG_SUPPORTS_ZONED_WRITE_PIPELINING, &eq->flags);
> +
>  	q->elevator = eq;
>  	dd_depth_updated(q);
>  	return 0;
> @@ -731,10 +749,40 @@ static void dd_finish_request(struct request *rq)
>  		atomic_inc(&per_prio->stats.completed);
>  }
>  
> -static bool dd_has_work_for_prio(struct dd_per_prio *per_prio)
> +/* May be called from interrupt context. */
> +static bool dd_has_write_work(struct deadline_data *dd,
> +			      struct blk_mq_hw_ctx *hctx,
> +			      struct list_head *list)
> +{
> +	struct request_queue *q = hctx->queue;
> +	unsigned long flags;
> +	struct request *rq;
> +	bool has_work = false;
> +
> +	if (list_empty_careful(list))
> +		return false;
> +
> +	if (!(q->limits.features & BLK_FEAT_ORDERED_HWQ))
> +		return true;
> +
> +	spin_lock_irqsave(&dd->lock, flags);
> +	list_for_each_entry(rq, list, queuelist) {
> +		if (rq->mq_hctx == hctx) {
> +			has_work = true;
> +			break;
> +		}
> +	}
> +	spin_unlock_irqrestore(&dd->lock, flags);
> +
> +	return has_work;
> +}
> +
> +static bool dd_has_work_for_prio(struct deadline_data *dd,
> +				 struct blk_mq_hw_ctx *hctx,
> +				 struct dd_per_prio *per_prio)
>  {
>  	return !list_empty_careful(&per_prio->fifo_list[DD_READ]) ||
> -		!list_empty_careful(&per_prio->fifo_list[DD_WRITE]);
> +		dd_has_write_work(dd, hctx, &per_prio->fifo_list[DD_WRITE]);
>  }
>  
>  static bool dd_has_work(struct blk_mq_hw_ctx *hctx)
> @@ -746,7 +794,7 @@ static bool dd_has_work(struct blk_mq_hw_ctx *hctx)
>  		return true;
>  
>  	for (prio = 0; prio <= DD_PRIO_MAX; prio++)
> -		if (dd_has_work_for_prio(&dd->per_prio[prio]))
> +		if (dd_has_work_for_prio(dd, hctx, &dd->per_prio[prio]))
>  			return true;
>  
>  	return false;


-- 
Damien Le Moal
Western Digital Research
