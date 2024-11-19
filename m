Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA82F14A609;
	Tue, 19 Nov 2024 07:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732002724; cv=none; b=hI1A0SZhm08KAaP4Pfn12xH9YX2EC71dyRBFOQsPZLDY1OedljWkAM39td/4B3AkUI7am5xZTZfLtfHQPCOxDEpqpj2xaq57Dm/JEc+56PsRV0Y/N96BOSXE6A4F9JDVYJyWck2+C9UkJWMLHwt8ax+5n/j4CYmdurHf69rfPoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732002724; c=relaxed/simple;
	bh=88Gcu1UIU4Gh3AvQEp8ILmjJwdxOWH7453hsPNKnP58=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=moWWlAG4XcU2IscrR1QwXDKdp2VAxumKW4Y+jpfxpGneyD7D/h+/3g1OXrVAWS9rS5eC3wcml8+2SopNt59cB9Iu0R2ZcM/miYfwjEwl2LxMSKbr/tnmNhBJSVQyjpG+lOfnarzP9hGSyJ1ecK29b2jlXmrdu+mXYuDMU5oP5pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DBFdJQI+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DBFdJQI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65AB2C4CECF;
	Tue, 19 Nov 2024 07:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732002724;
	bh=88Gcu1UIU4Gh3AvQEp8ILmjJwdxOWH7453hsPNKnP58=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DBFdJQI+yqrD8En6LDWcbqtMfuqcweFmNjH97IOR491GecEJlVgW1avIpVYMxqzgp
	 PY9kLHmkuuSw/jAaOHge68Ygvy9Y8CKvBRQGuYG4ykqzbxzquvkkVfcAHJ0Ci9mZM2
	 QCpjgoZh0ibRpjJfmh4ArnVVQ3orf77jGmYumm4fX0bLOLB4b8Hy81LohgszOFF3k5
	 ucrXyJevCmOWk0TaEIXGQ9d86FPRt11TuBFVmImOzJUF3Sce/MHxGe/9MNNdCE7yYL
	 9nPd5o80MCAS3MyXQ21VJTtBWEpp3VVpLxPN4VD4SctkUohZNF6QyhV69F8ZDFFMM7
	 OckEksa+p2Sdg==
Message-ID: <db6d72c5-5221-413f-a355-df8ab414f63e@kernel.org>
Date: Tue, 19 Nov 2024 16:52:02 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 14/26] blk-mq: Restore the zoned write order when
 requeuing
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-15-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241119002815.600608-15-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/24 09:28, Bart Van Assche wrote:
> Zoned writes may be requeued, e.g. if a block driver returns
> BLK_STS_RESOURCE. Requests may be requeued in another order than
> submitted. Restore the request order if requests are requeued.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  block/bfq-iosched.c    |  2 ++
>  block/blk-mq.c         | 20 +++++++++++++++++++-
>  block/blk-mq.h         |  2 ++
>  block/kyber-iosched.c  |  2 ++
>  block/mq-deadline.c    |  7 ++++++-
>  include/linux/blk-mq.h |  2 +-
>  6 files changed, 32 insertions(+), 3 deletions(-)
> 
> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
> index 0747d9d0e48c..13bedbf03bd2 100644
> --- a/block/bfq-iosched.c
> +++ b/block/bfq-iosched.c
> @@ -6265,6 +6265,8 @@ static void bfq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
>  
>  	if (flags & BLK_MQ_INSERT_AT_HEAD) {
>  		list_add(&rq->queuelist, &bfqd->dispatch);
> +	} else if (flags & BLK_MQ_INSERT_ORDERED) {
> +		blk_mq_insert_ordered(rq, &bfqd->dispatch);
>  	} else if (!bfqq) {
>  		list_add_tail(&rq->queuelist, &bfqd->dispatch);
>  	} else {
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index f134d5e1c4a1..1302ccbf2a7d 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1564,7 +1564,9 @@ static void blk_mq_requeue_work(struct work_struct *work)
>  		 * already.  Insert it into the hctx dispatch list to avoid
>  		 * block layer merges for the request.
>  		 */
> -		if (rq->rq_flags & RQF_DONTPREP)
> +		if (blk_rq_is_seq_zoned_write(rq))
> +			blk_mq_insert_request(rq, BLK_MQ_INSERT_ORDERED);

Is this OK to do without any starvation prevention ? A high LBA write that
constantly gets requeued behind low LBA writes could end up in a timeout
situation, no ?

> +		else if (rq->rq_flags & RQF_DONTPREP)
>  			blk_mq_request_bypass_insert(rq, 0);
>  		else
>  			blk_mq_insert_request(rq, BLK_MQ_INSERT_AT_HEAD);
> @@ -2599,6 +2601,20 @@ static void blk_mq_insert_requests(struct blk_mq_hw_ctx *hctx,
>  	blk_mq_run_hw_queue(hctx, run_queue_async);
>  }
>  
> +void blk_mq_insert_ordered(struct request *rq, struct list_head *list)
> +{
> +	struct request_queue *q = rq->q;
> +	struct request *rq2;
> +
> +	list_for_each_entry(rq2, list, queuelist)
> +		if (rq2->q == q && blk_rq_pos(rq2) > blk_rq_pos(rq))
> +			break;
> +
> +	/* Insert rq before rq2. If rq2 is the list head, append at the end. */
> +	list_add_tail(&rq->queuelist, &rq2->queuelist);
> +}
> +EXPORT_SYMBOL_GPL(blk_mq_insert_ordered);
> +
>  static void blk_mq_insert_request(struct request *rq, blk_insert_t flags)
>  {
>  	struct request_queue *q = rq->q;
> @@ -2653,6 +2669,8 @@ static void blk_mq_insert_request(struct request *rq, blk_insert_t flags)
>  		spin_lock(&ctx->lock);
>  		if (flags & BLK_MQ_INSERT_AT_HEAD)
>  			list_add(&rq->queuelist, &ctx->rq_lists[hctx->type]);
> +		else if (flags & BLK_MQ_INSERT_ORDERED)
> +			blk_mq_insert_ordered(rq, &ctx->rq_lists[hctx->type]);
>  		else
>  			list_add_tail(&rq->queuelist,
>  				      &ctx->rq_lists[hctx->type]);
> diff --git a/block/blk-mq.h b/block/blk-mq.h
> index 309db553aba6..10b9fb3ca762 100644
> --- a/block/blk-mq.h
> +++ b/block/blk-mq.h
> @@ -40,8 +40,10 @@ enum {
>  
>  typedef unsigned int __bitwise blk_insert_t;
>  #define BLK_MQ_INSERT_AT_HEAD		((__force blk_insert_t)0x01)
> +#define BLK_MQ_INSERT_ORDERED		((__force blk_insert_t)0x02)
>  
>  void blk_mq_submit_bio(struct bio *bio);
> +void blk_mq_insert_ordered(struct request *rq, struct list_head *list);
>  int blk_mq_poll(struct request_queue *q, blk_qc_t cookie, struct io_comp_batch *iob,
>  		unsigned int flags);
>  void blk_mq_exit_queue(struct request_queue *q);
> diff --git a/block/kyber-iosched.c b/block/kyber-iosched.c
> index 4155594aefc6..77bb41bab68d 100644
> --- a/block/kyber-iosched.c
> +++ b/block/kyber-iosched.c
> @@ -603,6 +603,8 @@ static void kyber_insert_requests(struct blk_mq_hw_ctx *hctx,
>  		trace_block_rq_insert(rq);
>  		if (flags & BLK_MQ_INSERT_AT_HEAD)
>  			list_move(&rq->queuelist, head);
> +		else if (flags & BLK_MQ_INSERT_ORDERED)
> +			blk_mq_insert_ordered(rq, head);
>  		else
>  			list_move_tail(&rq->queuelist, head);
>  		sbitmap_set_bit(&khd->kcq_map[sched_domain],
> diff --git a/block/mq-deadline.c b/block/mq-deadline.c
> index 2edf84b1bc2a..200e5a2928ce 100644
> --- a/block/mq-deadline.c
> +++ b/block/mq-deadline.c
> @@ -711,7 +711,12 @@ static void dd_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
>  		 * set expire time and add to fifo list
>  		 */
>  		rq->fifo_time = jiffies + dd->fifo_expire[data_dir];
> -		list_add_tail(&rq->queuelist, &per_prio->fifo_list[data_dir]);
> +		if (flags & BLK_MQ_INSERT_ORDERED)
> +			blk_mq_insert_ordered(rq,
> +					      &per_prio->fifo_list[data_dir]);
> +		else
> +			list_add_tail(&rq->queuelist,
> +				      &per_prio->fifo_list[data_dir]);
>  	}
>  }
>  
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index ac05974f08f9..f7514eefccfd 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -85,7 +85,7 @@ enum {
>  
>  /* flags that prevent us from merging requests: */
>  #define RQF_NOMERGE_FLAGS \
> -	(RQF_STARTED | RQF_FLUSH_SEQ | RQF_SPECIAL_PAYLOAD)
> +	(RQF_STARTED | RQF_FLUSH_SEQ | RQF_DONTPREP | RQF_SPECIAL_PAYLOAD)
>  
>  enum mq_rq_state {
>  	MQ_RQ_IDLE		= 0,


-- 
Damien Le Moal
Western Digital Research
