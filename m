From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Fri, 20 Sep 2013 13:41:29 -0700
Message-ID: <1379709689.31806.6.camel@haakon3.risingtidesystems.com>
References: <1374195825.7397.997.camel@haakon3.risingtidesystems.com>
	 <1374215660.7397.1041.camel@haakon3.risingtidesystems.com>
	 <1374248000.2266.20.camel@dabdike>
	 <1374267684.7397.1058.camel@haakon3.risingtidesystems.com>
	 <1374296162.7397.1098.camel@haakon3.risingtidesystems.com>
	 <51EAA33C.9010405@fusionio.com>
	 <20130809191542.GD25306@dhcp-26-207.brq.redhat.com>
	 <1376079457.5171.172.camel@haakon3.risingtidesystems.com>
	 <20130815162316.GA27882@dhcp-26-207.brq.redhat.com>
	 <1376619569.5171.217.camel@haakon3.risingtidesystems.com>
	 <20130920151915.GC10507@dhcp-26-207.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130920151915.GC10507@dhcp-26-207.brq.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Christie <mchristie@fusionio.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Alexander!

Apologies for the long delay on this follow-up..  Comments below.

On Fri, 2013-09-20 at 17:19 +0200, Alexander Gordeev wrote:
> On Thu, Aug 15, 2013 at 07:19:29PM -0700, Nicholas A. Bellinger wrote:
> > Ok, here's a bit better idea of what is going on now..
> > 
> > The problem is that blkdev_issue_flush() -> blk_mq_make_request() ->
> > __blk_mq_alloc_request() allocates the first tag, which calls
> > blk_insert_flush() -> blk_flush_complete_seq() -> blk_flush_kick() ->
> > mq_flush_work() -> blk_mq_alloc_request() to allocate a second tag for
> > the struct request that actually gets dispatched into scsi-mq as a
> > SYCHRONIZE_CACHE command..
> > 
> > I'm not exactly sure why this double tag usage of struct request is
> > occurring, but AFAICT it does happen for every flush, and is not
> > specific to the blkdev_issue_flush() codepath..  I'm sure that Jens can
> > fill us in on that bit.  ;)
> 
> I also played with the double tag using a reserved tag (below).
> 
> While it fixes 'fdisk /dev/sda' issue when trying to 'mount /dev/sda1 /mnt'
> what appears to be a call to bio->bi_end_io() from the free'd bio hits in.
> 
> Not sure if I should pursue the root cause until the whole double-tag
> thingy is confirmed.
> 
> Jens?
> 
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 6fc1df3..81794dc 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -874,14 +874,14 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
>  	hctx = q->mq_ops->map_queue(q, ctx->cpu);
>  
>  	trace_block_getrq(q, bio, rw);
> -	rq = __blk_mq_alloc_request(hctx, GFP_ATOMIC, false);
> +	rq = __blk_mq_alloc_request(hctx, GFP_ATOMIC, is_flush_fua);
>  	if (likely(rq))
>  		blk_mq_rq_ctx_init(ctx, rq, rw);
>  	else {
>  		blk_mq_put_ctx(ctx);
>  		trace_block_sleeprq(q, bio, rw);
>  		rq = blk_mq_alloc_request_pinned(q, rw, __GFP_WAIT|GFP_ATOMIC,
> -							false);
> +							is_flush_fua);
>  		ctx = rq->mq_ctx;
>  		hctx = q->mq_ops->map_queue(q, ctx->cpu);
>  	}

So this is what I ended up doing as well, and does address the specific
bug with queue_depth=1.

> @@ -1317,6 +1317,9 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_reg *reg,
>  		reg->queue_depth = BLK_MQ_MAX_DEPTH;
>  	}
>  
> +	reg->queue_depth++;
> +	reg->reserved_tags++;
> +
>  	ctx = alloc_percpu(struct blk_mq_ctx);
>  	if (!ctx)
>  		return ERR_PTR(-ENOMEM);
> 

I was actually setting this within scsi_mq_alloc_queue(), but given that
the queue_depth=1 issue is independent of scsi-mq, this does make more
sense.

Also, these extra increments should probably happen only when the passed
queue_depth == 1 && reserved_tags == 0.

Other than that minor nit.

Reviewed-by: Nicholas Bellinger <nab@linux-iscsi.org>
