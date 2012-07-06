From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v5 3/4] block: implement runtime pm strategy
Date: Fri, 06 Jul 2012 09:00:12 +0400
Message-ID: <1341550812.3023.3.camel@dabdike.hilton.com>
References: <1341547472-6863-1-git-send-email-ming.m.lin@intel.com>
	 <1341547472-6863-4-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1341547472-6863-4-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-07-06 at 12:04 +0800, Lin Ming wrote:
> When a request is added:
>     If device is suspended or is suspending and the request is not a
>     PM request, resume the device.
> 
> When a request finishes:
>     Call pm_runtime_mark_last_busy().
> 
> When pick a request:
>     If device is resuming/suspending, then only PM request is allowed to go.
>     Return NULL for other cases.

This is a complete reinvention of the quiesce state, just with new names
and moved up to block in part ... why do we have to have two separate
systems for stopping a device and sending special commands when the
device is suspended, why not just one?

James

> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  block/blk-core.c       |    7 +++++++
>  block/elevator.c       |    4 ++++
>  include/linux/blkdev.h |   37 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 48 insertions(+)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 1cc80ae..cb93501 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1224,6 +1224,8 @@ void __blk_put_request(struct request_queue *q, struct request *req)
>  	if (unlikely(--req->ref_count))
>  		return;
>  
> +	blk_pm_put_request(q);
> +
>  	elv_completed_request(q, req);
>  
>  	/* this is a bio leak */
> @@ -2012,6 +2014,11 @@ struct request *blk_peek_request(struct request_queue *q)
>  	int ret;
>  
>  	while ((rq = __elv_next_request(q)) != NULL) {
> +
> +		rq = blk_pm_peek_request(q, rq);
> +		if (!rq)
> +			break;
> +
>  		if (!(rq->cmd_flags & REQ_STARTED)) {
>  			/*
>  			 * This is the first time the device driver
> diff --git a/block/elevator.c b/block/elevator.c
> index 6a55d41..37c1a2b 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -536,6 +536,8 @@ void elv_requeue_request(struct request_queue *q, struct request *rq)
>  
>  	rq->cmd_flags &= ~REQ_STARTED;
>  
> +	blk_pm_requeue_request(q);
> +
>  	__elv_add_request(q, rq, ELEVATOR_INSERT_REQUEUE);
>  }
>  
> @@ -558,6 +560,8 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
>  {
>  	trace_block_rq_insert(q, rq);
>  
> +	blk_pm_add_request(q, rq);
> +
>  	rq->q = q;
>  
>  	if (rq->cmd_flags & REQ_SOFTBARRIER) {
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 9395d39..c8c5951 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -908,6 +908,36 @@ extern int blk_pre_runtime_suspend(struct request_queue *q);
>  extern void blk_post_runtime_suspend(struct request_queue *q, int err);
>  extern void blk_pre_runtime_resume(struct request_queue *q);
>  extern void blk_post_runtime_resume(struct request_queue *q, int err);
> +
> +static inline void blk_pm_put_request(struct request_queue *q)
> +{
> +	if (!(--q->nr_pending) && q->dev)
> +		 pm_runtime_mark_last_busy(q->dev);
> +}
> +
> +static inline struct request *blk_pm_peek_request(
> +	struct request_queue *q, struct request *rq)
> +{
> +	if (q->rpm_status == RPM_SUSPENDED ||
> +		  (q->rpm_status != RPM_ACTIVE && !(rq->cmd_flags & REQ_PM)))
> +		return NULL;
> +	else
> +		return rq;
> +}
> +
> +static inline void blk_pm_requeue_request(struct request_queue *q)
> +{
> +	q->nr_pending--;
> +}
> +
> +static inline void blk_pm_add_request(struct request_queue *q,
> +	struct request *rq)
> +{
> +	if (q->nr_pending++ == 0 && !(rq->cmd_flags & REQ_PM) &&
> +		    (q->rpm_status == RPM_SUSPENDED ||
> +		     q->rpm_status == RPM_SUSPENDING) && q->dev)
> +		pm_request_resume(q->dev);
> +}
>  #else
>  static inline void blk_pm_runtime_init(struct request_queue *q,
>  	struct device *dev) {}
> @@ -918,6 +948,13 @@ static inline int blk_pre_runtime_suspend(struct request_queue *q)
>  static inline void blk_post_runtime_suspend(struct request_queue *q, int err) {}
>  static inline void blk_pre_runtime_resume(struct request_queue *q) {}
>  static inline void blk_post_runtime_resume(struct request_queue *q, int err) {}
> +
> +static inline void blk_pm_put_request(struct request_queue *q) {}
> +static inline struct request *blk_pm_peek_request(
> +	struct request_queue *q, struct request *rq) { return rq; }
> +static inline void blk_pm_requeue_request(struct request_queue *q) {}
> +static inline void blk_pm_add_request(struct request_queue *q,
> +	struct request *req) {}
>  #endif
>  
>  /*
