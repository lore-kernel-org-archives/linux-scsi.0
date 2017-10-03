From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V5 4/7] blk-mq: introduce blk_mq_dequeue_from_ctx()
Date: Tue, 3 Oct 2017 02:01:09 -0700
Message-ID: <20171003090109.GB21184@infradead.org>
References: <20170930102720.30219-1-ming.lei@redhat.com>
 <20170930102720.30219-5-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170930102720.30219-5-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Sep 30, 2017 at 06:27:17PM +0800, Ming Lei wrote:
> This function is introduced for dequeuing request
> from sw queue so that we can dispatch it in
> scheduler's way.
> 
> More importantly, some SCSI devices may set
> q->queue_depth, which is a per-request_queue limit,
> and applied on pending I/O from all hctxs. This
> function is introduced for avoiding to dequeue too
> many requests from sw queue when ->dispatch isn't
> flushed completely.

Weird commit log formatting, please use your 70+ chacters to format the
text.

> @@ -882,6 +882,44 @@ void blk_mq_flush_busy_ctxs(struct blk_mq_hw_ctx *hctx, struct list_head *list)
>  }
>  EXPORT_SYMBOL_GPL(blk_mq_flush_busy_ctxs);
>  
> +struct dispatch_rq_data {
> +	struct blk_mq_hw_ctx *hctx;
> +	struct request *rq;
> +};
> +
> +static bool dispatch_rq_from_ctx(struct sbitmap *sb, unsigned int bitnr, void *data)

Overly long line.

But except for that this looks ok to me except for the fact that you
just add an unused function.
