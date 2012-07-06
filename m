From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v5 3/4] block: implement runtime pm strategy
Date: Fri, 06 Jul 2012 12:05:53 +0400
Message-ID: <1341561953.3023.31.camel@dabdike.hilton.com>
References: <1341547472-6863-1-git-send-email-ming.m.lin@intel.com>
	 <1341547472-6863-4-git-send-email-ming.m.lin@intel.com>
	 <1341550812.3023.3.camel@dabdike.hilton.com>
	 <1341554872.3628.30.camel@minggr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1341554872.3628.30.camel@minggr>
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-07-06 at 14:07 +0800, Lin Ming wrote:
> On Fri, 2012-07-06 at 09:00 +0400, James Bottomley wrote:
> > On Fri, 2012-07-06 at 12:04 +0800, Lin Ming wrote:
> > > When a request is added:
> > >     If device is suspended or is suspending and the request is not a
> > >     PM request, resume the device.
> > > 
> > > When a request finishes:
> > >     Call pm_runtime_mark_last_busy().
> > > 
> > > When pick a request:
> > >     If device is resuming/suspending, then only PM request is allowed to go.
> > >     Return NULL for other cases.
> > 
> > This is a complete reinvention of the quiesce state, just with new names
> > and moved up to block in part ... why do we have to have two separate
> > systems for stopping a device and sending special commands when the
> > device is suspended, why not just one?
> 
> Yes, there are some duplicates with scsi layer quiesce state.
> I'd like to do the cleanup.

The mechanism is pretty much identical:  For quiesce you set the sdev
state to SDEV_QUIESCE and then send in special requests with REQ_PREEMPT
to bypass the suspend.  In your additional scheme you set a queue flag
RPM_SUSPENDED by a pm specific set of callbacks and you only then accept
requests with REQ_PM.  I don't see any difference in actual effect
(well, except that quiesce can be done on a non-empty queue, but that's
a simple flag difference).

What I don't want to see is duplicated mechanisms.  If you want to make
a general quiesce mechanism in block instead of SCSI, I'm fine with
that, but I want to see our current quiesce mechanism moved to it first
since that demonstrates you got it right.  If you don't want to do that,
then just use the existing mechanism in SCSI.

Now that I look at it, your q->nr_pending is an inexact duplicate of
sdev->device_busy as well.  Again, no objection to moving this to block,
but if you then make SCSI use it for sdev->device_busy, you'll get a
very fast indication of whether you got this right or not, which is an
excellent reason for unifying.

In the new scheme, by the way, all this would be integrated directly
into block, so no duplication of blk_xx as blk_pm_xx

James


> Add runtime pm support to block layer, so other block device drivers may
> also add runtime pm support easily in future.
> 
> Some helper functions are provided on block layer which can be called by
> block device drivers.
> 
> void blk_pm_runtime_init(struct request_queue *q, struct device *dev)
> int blk_pre_runtime_suspend(struct request_queue *q)
> void blk_post_runtime_suspend(struct request_queue *q, int err)
> void blk_pre_runtime_resume(struct request_queue *q)
> void blk_post_runtime_resume(struct request_queue *q, int err)
> 
> Thanks,
> Lin Ming
> 
> > 
> > James
> > 
> > > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > > ---
> > >  block/blk-core.c       |    7 +++++++
> > >  block/elevator.c       |    4 ++++
> > >  include/linux/blkdev.h |   37 +++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 48 insertions(+)
> > > 
> > > diff --git a/block/blk-core.c b/block/blk-core.c
> > > index 1cc80ae..cb93501 100644
> > > --- a/block/blk-core.c
> > > +++ b/block/blk-core.c
> > > @@ -1224,6 +1224,8 @@ void __blk_put_request(struct request_queue *q, struct request *req)
> > >  	if (unlikely(--req->ref_count))
> > >  		return;
> > >  
> > > +	blk_pm_put_request(q);
> > > +
> > >  	elv_completed_request(q, req);
> > >  
> > >  	/* this is a bio leak */
> > > @@ -2012,6 +2014,11 @@ struct request *blk_peek_request(struct request_queue *q)
> > >  	int ret;
> > >  
> > >  	while ((rq = __elv_next_request(q)) != NULL) {
> > > +
> > > +		rq = blk_pm_peek_request(q, rq);
> > > +		if (!rq)
> > > +			break;
> > > +
> > >  		if (!(rq->cmd_flags & REQ_STARTED)) {
> > >  			/*
> > >  			 * This is the first time the device driver
> > > diff --git a/block/elevator.c b/block/elevator.c
> > > index 6a55d41..37c1a2b 100644
> > > --- a/block/elevator.c
> > > +++ b/block/elevator.c
> > > @@ -536,6 +536,8 @@ void elv_requeue_request(struct request_queue *q, struct request *rq)
> > >  
> > >  	rq->cmd_flags &= ~REQ_STARTED;
> > >  
> > > +	blk_pm_requeue_request(q);
> > > +
> > >  	__elv_add_request(q, rq, ELEVATOR_INSERT_REQUEUE);
> > >  }
> > >  
> > > @@ -558,6 +560,8 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
> > >  {
> > >  	trace_block_rq_insert(q, rq);
> > >  
> > > +	blk_pm_add_request(q, rq);
> > > +
> > >  	rq->q = q;
> > >  
> > >  	if (rq->cmd_flags & REQ_SOFTBARRIER) {
> > > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > > index 9395d39..c8c5951 100644
> > > --- a/include/linux/blkdev.h
> > > +++ b/include/linux/blkdev.h
> > > @@ -908,6 +908,36 @@ extern int blk_pre_runtime_suspend(struct request_queue *q);
> > >  extern void blk_post_runtime_suspend(struct request_queue *q, int err);
> > >  extern void blk_pre_runtime_resume(struct request_queue *q);
> > >  extern void blk_post_runtime_resume(struct request_queue *q, int err);
> > > +
> > > +static inline void blk_pm_put_request(struct request_queue *q)
> > > +{
> > > +	if (!(--q->nr_pending) && q->dev)
> > > +		 pm_runtime_mark_last_busy(q->dev);
> > > +}
> > > +
> > > +static inline struct request *blk_pm_peek_request(
> > > +	struct request_queue *q, struct request *rq)
> > > +{
> > > +	if (q->rpm_status == RPM_SUSPENDED ||
> > > +		  (q->rpm_status != RPM_ACTIVE && !(rq->cmd_flags & REQ_PM)))
> > > +		return NULL;
> > > +	else
> > > +		return rq;
> > > +}
> > > +
> > > +static inline void blk_pm_requeue_request(struct request_queue *q)
> > > +{
> > > +	q->nr_pending--;
> > > +}
> > > +
> > > +static inline void blk_pm_add_request(struct request_queue *q,
> > > +	struct request *rq)
> > > +{
> > > +	if (q->nr_pending++ == 0 && !(rq->cmd_flags & REQ_PM) &&
> > > +		    (q->rpm_status == RPM_SUSPENDED ||
> > > +		     q->rpm_status == RPM_SUSPENDING) && q->dev)
> > > +		pm_request_resume(q->dev);
> > > +}
> > >  #else
> > >  static inline void blk_pm_runtime_init(struct request_queue *q,
> > >  	struct device *dev) {}
> > > @@ -918,6 +948,13 @@ static inline int blk_pre_runtime_suspend(struct request_queue *q)
> > >  static inline void blk_post_runtime_suspend(struct request_queue *q, int err) {}
> > >  static inline void blk_pre_runtime_resume(struct request_queue *q) {}
> > >  static inline void blk_post_runtime_resume(struct request_queue *q, int err) {}
> > > +
> > > +static inline void blk_pm_put_request(struct request_queue *q) {}
> > > +static inline struct request *blk_pm_peek_request(
> > > +	struct request_queue *q, struct request *rq) { return rq; }
> > > +static inline void blk_pm_requeue_request(struct request_queue *q) {}
> > > +static inline void blk_pm_add_request(struct request_queue *q,
> > > +	struct request *req) {}
> > >  #endif
> > >  
> > >  /*
> > 
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
