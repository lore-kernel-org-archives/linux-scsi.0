From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/8] block: introduce blk_flush_queue to drive flush
 machinery
Date: Tue, 9 Sep 2014 11:43:31 -0700
Message-ID: <20140909184331.GE16750@infradead.org>
References: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
 <1410267949-21904-6-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44307 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaIISnc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Sep 2014 14:43:32 -0400
Content-Disposition: inline
In-Reply-To: <1410267949-21904-6-git-send-email-ming.lei@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Tue, Sep 09, 2014 at 09:05:46PM +0800, Ming Lei wrote:
> This patch introduces 'struct blk_flush_queue' and puts all
> flush machinery related stuff into this strcuture, so that

s/stuff/fields/
s/strcuture/structure/

Looks good, but a few more nitpicks below.

Reviewed-by: Christoph Hellwig <hch@lst.de>

> +int blk_init_flush(struct request_queue *q)
> +{
> +	int ret;
> +	struct blk_flush_queue *fq = kzalloc(sizeof(*fq), GFP_KERNEL);
>  
> +	if (!fq)
>  		return -ENOMEM;
>  
> +	q->fq = fq;

I think it would be cleaner to return the flush data structure and
assign it in the caller.

> +	INIT_LIST_HEAD(&fq->flush_queue[0]);
> +	INIT_LIST_HEAD(&fq->flush_queue[1]);
> +	INIT_LIST_HEAD(&fq->flush_data_in_flight);
> +
> +	if (q->mq_ops) {
> +		ret = blk_mq_init_flush(q);

I think we can just remove blk_mq_init_flush now that it's only
called in blk-flush.c anyway.

>  void blk_exit_flush(struct request_queue *q)
>  {
> +	if (q->mq_ops)
> +		blk_mq_exit_flush(q);
> +	else {
> +		struct blk_flush_queue *fq = blk_get_flush_queue(q);
> +		kfree(fq->flush_rq);
> +		kfree(fq);
> +	}

Similarly I would pass the flush structure here.

> +struct blk_flush_queue {
> +	unsigned int		flush_queue_delayed:1;
> +	unsigned int		flush_pending_idx:1;
> +	unsigned int		flush_running_idx:1;
> +	unsigned long		flush_pending_since;
> +	struct list_head	flush_queue[2];
> +	struct list_head	flush_data_in_flight;
> +	struct request		*flush_rq;
> +	spinlock_t		mq_flush_lock;
> +};

As this isn't really a queue I would call it blk_flush_data.

> +static inline struct blk_flush_queue *blk_get_flush_queue(
> +		struct request_queue *q)
> +{
> +	return q->fq;
> +}

I don't think there is a need for this helper.

