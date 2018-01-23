From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 1/5] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Tue, 23 Jan 2018 08:57:34 +0800
Message-ID: <20180123005728.GB4411@ming.t460p>
References: <20180122033550.27855-1-ming.lei@redhat.com>
 <20180122033550.27855-2-ming.lei@redhat.com>
 <1516639793.2545.14.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1516639793.2545.14.camel@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 22, 2018 at 04:49:54PM +0000, Bart Van Assche wrote:
> On Mon, 2018-01-22 at 11:35 +0800, Ming Lei wrote:
> > @@ -1280,10 +1282,18 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
> >  		 * - Some but not all block drivers stop a queue before
> >  		 *   returning BLK_STS_RESOURCE. Two exceptions are scsi-mq
> >  		 *   and dm-rq.
> > +		 *
> > +		 * If drivers return BLK_STS_RESOURCE and S_SCHED_RESTART
> > +		 * bit is set, run queue after 10ms for avoiding IO hang
> > +		 * because the queue may be idle and the RESTART mechanism
> > +		 * can't work any more.
> >  		 */
> > -		if (!blk_mq_sched_needs_restart(hctx) ||
> > +		needs_restart = blk_mq_sched_needs_restart(hctx);
> > +		if (!needs_restart ||
> >  		    (no_tag && list_empty_careful(&hctx->dispatch_wait.entry)))
> >  			blk_mq_run_hw_queue(hctx, true);
> > +		else if (needs_restart && (ret == BLK_STS_RESOURCE))
> > +			blk_mq_delay_run_hw_queue(hctx, 10);
> >  	}
> 
> In my opinion there are two problems with the above changes:
> * Only the block driver author can know what a good choice is for the time

The reality is that no one knew that before, if you look at the fact, most of
BLK_STS_RESOURCE need that, but no one dealt with it at all. Both Jens and I
concluded that it is a generic issue, which need generic solution.

On the contrary, it is much easier to evaluate if one STS_RESOURCE can be
converted to STS_DEV_RESOURCE, as you saw, there isn't many, because now we
call .queue_rq() after getting budget and driver tag.

>   after which to rerun the queue. So I think moving the rerun delay (10 ms)
>   constant from block drivers into the core is a step backwards instead of a
>   step forwards.

As I mentioned before, if running out of resource inside .queue_rq(),
this request is still out of control of blk-mq, and if run queue is
scheduled inside .queue_rq(), it isn't correct, because when __blk_mq_run_hw_queue()
is run, the request may not be visible for dispatch.

Even though RCU lock is held during dispatch, preemption or interrupt
can happen too, so it is simply wrong to depend on the timing to make
sure __blk_mq_run_hw_queue() can see the request in this situation.

Or driver reinserts the request into scheduler queue, but that way
involves much big change if we do this in driver, and introduce
unnecessary cost meantime.

> * The purpose of the BLK_MQ_S_SCHED_RESTART flag is to detect whether or not
>   any of the queue runs triggered by freeing a tag happened concurrently. I
>   don't think that there is any relationship between queue runs happening all
>   or not concurrently and the chance that driver resources become available.
>   So deciding whether or not a queue should be rerun based on the value of
>   the BLK_MQ_S_SCHED_RESTART flag seems wrong to me.

The fact is simple, that once BLK_MQ_S_SCHED_RESTART is set,
blk_mq_dispatch_rq_list() won't call blk_mq_run_hw_queue() any more, and depends
on request completion to rerun the queue. If driver can't make sure the queue will be
restarted in future by returning STS_RESOURCE, we have to call
blk_mq_delay_run_hw_queue(hctx, 10) for avoiding IO hang.

> 
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index d9ca1dfab154..55be2550c555 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -2030,9 +2030,9 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
> >  	case BLK_STS_OK:
> >  		break;
> >  	case BLK_STS_RESOURCE:
> > -		if (atomic_read(&sdev->device_busy) == 0 &&
> > -		    !scsi_device_blocked(sdev))
> > -			blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);
> > +		if (atomic_read(&sdev->device_busy) ||
> > +		    scsi_device_blocked(sdev))
> > +			ret = BLK_STS_DEV_RESOURCE;
> >  		break;
> >  	default:
> >  		/*
> 
> The above introduces two changes that have not been mentioned in the
> description of this patch:
> - The queue rerunning delay is changed from 3 ms into 10 ms. Where is the
>   explanation of this change? Does this change have a positive or negative
>   performance impact?

How can that be a issue for SCSI? The rerunning delay is only triggered
when there isn't any in-flight requests in SCSI queue.

> - The above modifies a guaranteed queue rerun into a queue rerun that
>   may or may not happen, depending on whether or not multiple tags get freed
>   concurrently (return BLK_STS_DEV_RESOURCE). Sorry but I think that's wrong.

This patch only moves the rerunning delay from SCSI .queue_rq into
blk-mq, I don't know what you mean above, please explained a bit.

I know there is a race here in SCSI, but nothing to do with this patch.


-- 
Ming
