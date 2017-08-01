From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 03/14] blk-mq: introduce blk_mq_dispatch_rq_from_ctxs()
Date: Tue, 1 Aug 2017 18:07:27 +0800
Message-ID: <20170801100725.GA31452@ming.t460p>
References: <20170731165111.11536-1-ming.lei@redhat.com>
 <20170731165111.11536-5-ming.lei@redhat.com>
 <1501542577.2466.26.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1501542577.2466.26.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 31, 2017 at 11:09:38PM +0000, Bart Van Assche wrote:
> On Tue, 2017-08-01 at 00:51 +0800, Ming Lei wrote:
> > @@ -810,7 +810,11 @@ static void blk_mq_timeout_work(struct work_struct *work)
> >  
> >  struct ctx_iter_data {
> >  	struct blk_mq_hw_ctx *hctx;
> > -	struct list_head *list;
> > +
> > +	union {
> > +		struct list_head *list;
> > +		struct request *rq;
> > +	};
> >  };
> 
> Hello Ming,
> 
> Please introduce a new data structure for dispatch_rq_from_ctx() /
> blk_mq_dispatch_rq_from_ctxs() instead of introducing a union in struct
> ctx_iter_data. That will avoid that .list can be used in a context where
> a struct request * pointer has been stored in the structure and vice versa.

Looks there isn't such usage now, or we can just both 'list' and 'rq' in
this data structure if there is.

>  
> >  static bool flush_busy_ctx(struct sbitmap *sb, unsigned int bitnr, void *data)
> > @@ -826,6 +830,26 @@ static bool flush_busy_ctx(struct sbitmap *sb, unsigned int bitnr, void *data)
> >  	return true;
> >  }
> >  
> > +static bool dispatch_rq_from_ctx(struct sbitmap *sb, unsigned int bitnr, void *data)
> > +{
> > +	struct ctx_iter_data *dispatch_data = data;
> > +	struct blk_mq_hw_ctx *hctx = dispatch_data->hctx;
> > +	struct blk_mq_ctx *ctx = hctx->ctxs[bitnr];
> > +	bool empty = true;
> > +
> > +	spin_lock(&ctx->lock);
> > +	if (unlikely(!list_empty(&ctx->rq_list))) {
> > +		dispatch_data->rq = list_entry_rq(ctx->rq_list.next);
> > +		list_del_init(&dispatch_data->rq->queuelist);
> > +		empty = list_empty(&ctx->rq_list);
> > +	}
> > +	spin_unlock(&ctx->lock);
> > +	if (empty)
> > +		sbitmap_clear_bit(sb, bitnr);
> 
> This sbitmap_clear_bit() occurs without holding blk_mq_ctx.lock. Sorry but
> I don't think this is safe. Please either remove this sbitmap_clear_bit() call
> or make sure that it happens with blk_mq_ctx.lock held.

Good catch, sbitmap_clear_bit() should have been done with holding
ctx->lock, otherwise a new pending bit may be cleared.

-- 
Ming
