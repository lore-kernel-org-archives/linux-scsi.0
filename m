From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/8] blk-mq: support per-distpatch_queue flush machinery
Date: Tue, 9 Sep 2014 11:48:56 -0700
Message-ID: <20140909184856.GG16750@infradead.org>
References: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
 <1410267949-21904-9-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1410267949-21904-9-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

> +	if (hctx) {
> +		int cmd_sz = q->tag_set->cmd_size;
> +		int node = hctx->numa_node;
> +
> +		fq = kzalloc_node(sizeof(*fq), GFP_KERNEL, node);
> +		if (!fq)
> +			goto failed;
> +
> +		rq_sz = round_up(rq_sz + cmd_sz, cache_line_size());
> +		fq->flush_rq = kzalloc_node(rq_sz, GFP_KERNEL, node);
> +		if (!fq->flush_rq)
> +			goto rq_failed;
> +
> +		spin_lock_init(&fq->mq_flush_lock);
> +	} else {
> +		fq = kzalloc(sizeof(*fq), GFP_KERNEL);
> +		if (!fq)
> +			goto failed;
> +
> +		fq->flush_rq = kzalloc(rq_sz, GFP_KERNEL);
> +		if (!fq->flush_rq)
> +			goto rq_failed;
> +	}

Seems like this would be a lot cleaner by passing the cmd_size and
node_id explicitly.  The added benefit would be that we could also
pass the node for the blk_init_queue_node() case.

> +static void __blk_mq_exit_flush(struct request_queue *q,
> +		unsigned free_end, unsigned int exit_end)
> +{
> +	struct blk_mq_hw_ctx *hctx;
> +	unsigned int k;
> +	struct blk_flush_queue *fq;
> +	struct blk_mq_tag_set *set = q->tag_set;
> +	unsigned start_idx = set->queue_depth;
> +
> +	queue_for_each_hw_ctx(q, hctx, k) {
> +		if (k >= free_end)
> +			break;
> +
> +		fq = hctx->fq;
> +		if (k < exit_end && set->ops->exit_request)
> +			set->ops->exit_request(set->driver_data,
> +					fq->flush_rq, k,
> +					start_idx + k);
> +
> +		blk_free_flush_queue(fq);
> +	}

Can we merge the mq init/exit case into some existing for each hctx
loop in blk-mq?
