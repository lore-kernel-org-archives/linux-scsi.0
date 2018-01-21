From: Ming Lei <ming.lei@redhat.com>
Subject: Re: blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Sun, 21 Jan 2018 08:57:47 +0800
Message-ID: <20180121005741.GB9684@ming.t460p>
References: <20180120134813.4446-1-ming.lei@redhat.com>
 <20180120173001.GA3563@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55406 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756737AbeAUA6J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 20 Jan 2018 19:58:09 -0500
Content-Disposition: inline
In-Reply-To: <20180120173001.GA3563@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Laurence Oberman <loberman@redhat.com>, Bart Van Assche <bart.vanassche@sandisk.com>

On Sat, Jan 20, 2018 at 12:30:02PM -0500, Mike Snitzer wrote:
> On Sat, Jan 20 2018 at  8:48am -0500,
> Ming Lei <ming.lei@redhat.com> wrote:
> 
> > This status is returned from driver to block layer if device related
> > resource is run out of, but driver can guarantee that IO dispatch is
> > triggered in future when the resource is available.
> > 
> > This patch converts some drivers to use this return value. Meantime
> > if driver returns BLK_STS_RESOURCE and S_SCHED_RESTART is marked, run
> > queue after 10ms for avoiding IO hang.
> > 
> > Suggested-by: Jens Axboe <axboe@kernel.dk>
> > Cc: Mike Snitzer <snitzer@redhat.com>
> > Cc: Laurence Oberman <loberman@redhat.com>
> > Cc: Bart Van Assche <bart.vanassche@sandisk.com>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  block/blk-core.c             |  1 +
> >  block/blk-mq.c               | 20 ++++++++++++++++----
> >  drivers/block/null_blk.c     |  2 +-
> >  drivers/block/virtio_blk.c   |  2 +-
> >  drivers/block/xen-blkfront.c |  2 +-
> >  drivers/scsi/scsi_lib.c      |  6 +++---
> >  include/linux/blk_types.h    |  7 +++++++
> >  7 files changed, 30 insertions(+), 10 deletions(-)
> > 
> > diff --git a/block/blk-mq.c b/block/blk-mq.c
> > index 01f271d40825..6e97e0bf8178 100644
> > --- a/block/blk-mq.c
> > +++ b/block/blk-mq.c
> > @@ -1226,7 +1226,8 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
> >  		}
> >  
> >  		ret = q->mq_ops->queue_rq(hctx, &bd);
> > -		if (ret == BLK_STS_RESOURCE) {
> > +		if ((ret == BLK_STS_RESOURCE) ||
> > +				(ret == BLK_STS_DEV_RESOURCE)) {
> >  			/*
> >  			 * If an I/O scheduler has been configured and we got a
> >  			 * driver tag for the next request already, free it
> 
> Just a nit, but this should be on one line.

It is too long, and my editor starts to highlight/complain it, :-)

> 
> > @@ -1764,6 +1775,7 @@ static blk_status_t __blk_mq_issue_directly(struct blk_mq_hw_ctx *hctx,
> >  		*cookie = new_cookie;
> >  		break;
> >  	case BLK_STS_RESOURCE:
> > +	case BLK_STS_DEV_RESOURCE:
> >  		__blk_mq_requeue_request(rq);
> >  		break;
> >  	default:
> 
> It seems the strategy for BLK_STS_DEV_RESOURCE and BLK_STS_RESOURCE is
> too muddled: calling __blk_mq_requeue_request() for both will cause
> underlying blk-mq driver to retain the request, won't it?

blk_mq_request_issue_directly() is used by driver(dm-rq) on underlying
queue, and driver need to deal with underlying queue busy, now we simply
free the (underlying)request and feedback the busy status to blk-mq via
dm-rq.

Except for blk_mq_request_issue_directly(), this request need to be
requeued, and is retained by blk-mq in hctx->dispatch_list.

The difference is that if driver returns BLK_STS_DEV_RESOURCE, the queue
will be rerun when resource is available, so don't need to run queue after
a delay for avoiding IO hang explicitly.

> 
> > @@ -1826,7 +1838,7 @@ static void blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
> >  	hctx_lock(hctx, &srcu_idx);
> >  
> >  	ret = __blk_mq_try_issue_directly(hctx, rq, cookie, false);
> > -	if (ret == BLK_STS_RESOURCE)
> > +	if ((ret == BLK_STS_RESOURCE) || (ret == BLK_STS_DEV_RESOURCE))
> >  		blk_mq_sched_insert_request(rq, false, true, false);
> >  	else if (ret != BLK_STS_OK)
> >  		blk_mq_end_request(rq, ret);
> 
> For this normal (non dm-mpath) case the request gets re-inserted;
> dm-mpath must avoid that.
> 
> But with dm-mpath, which instead uses blk_mq_request_issue_directly(),
> we're driving IO with stacked blk-mq drivers.  If the underlying blk-mq 
> driver (e.g. scsi-mq or nvme) is made to retain the request, using
> __blk_mq_issue_directly()'s call to __blk_mq_requeue_request() above,
> then dm-mpath will not have the ability to requeue the request without
> conflicting with the underlying blk-mq driver, will it?

No, as I explained, the exception is blk_mq_request_issue_directly(),
and now dm-rq simply frees it(and in my original version, this request
is cached for underlying queue, and reused in next dispatch), for others,
the request is retained in hctx->dispatch_list, and owned by blk-mq.

> 
> Or am I'm misunderstanding what __blk_mq_requeue_request() is doing?
> 
> dm_mq_queue_rq
> -> multipath_clone_and_map
>    -> blk_get_request (scsi_mq)
>       -> if error, dm-mpath conditionally requeues (w/ or w/o delay)

Yes, with this patch, most of times blk-mq will run queue w/ delay
because SCHED_RESTART is set after the 1st STS_RESOURCE from dm-rq
.queue_rq()

>       -> if BLK_STS_OK then blk_mq_request_issue_directly() gets called
> -> dm_dispatch_clone_request
>    -> blk_mq_request_issue_directly
>       -> __blk_mq_try_issue_directly
>          -> __blk_mq_issue_directly
>             -> q->mq_ops->queue_rq (this is the underlying scsi_mq)
>                -> a BLK_STS_RESOURCE return here is how Bart was able to cause stalls

The stall only happens when SCHED_RESTART is set and the dm-rq queue is
idle(no any in-flight requests), that is exactly what this patch tries to
address as suggested by Jens.

>             -> __blk_mq_requeue_request, if BLK_STS_RESOURCE or BLK_STS_DEV_RESOURCE **1
>    -> (return from blk_mq_request_issue_directly)
>    -> if BLK_STS_RESOURCE, the dm-mpath request is released using blk_put_request();
>                            and DM_MAPIO_REQUEUE is returned to dm_mq_queue_rq **2

Right.

> -> if DM_MAPIO_REQUEUE return from map_request()'s call to dm_dispatch_clone_request:
>    BLK_STS_RESOURCE is returned from dm-mpath's dm_mq_queue_rq

Right.

> 
> The redundant queueing (both to underlying blk-mq at **1 above, and
> upper layer blk-mq at **2 above) is what I'm concerned about.
> 
> Hope this is clear.

Yeah, it is quite clear.

I also have other dm-mpath specific questions:

1) when any STS_RESOURCE is returned from underlying queue either
because of blk_get_request() or underlying .queue_rq() for a while,
will dm-mpath try to switch to other path?

2) what is the basic path switch policy of dm-mpath?

3) is it possible to move the check of 'ti->type->busy' into
.clone_and_map_rq()? if it is possible, this way might be more
effective to detect underlying queue busy.

Actually this patch may has another issue: if the default run queue
delay(in this patch, it is 10ms) is too short, the timer may expire
before any in-flight underlying request completes, then we may
dequeue too quick, and sequential IO performance can be hurt too.

But my previous patch in github doesn't have this issue.

	https://github.com/ming1/linux/commit/dfd672c998283a110247152237a9916b8264f3ec

Jens, what do you think of this issue? Or do we need to worry about
it?

-- 
Ming
