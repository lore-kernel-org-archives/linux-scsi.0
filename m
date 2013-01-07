From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v6 3/4] block: implement runtime pm strategy
Date: Mon, 7 Jan 2013 12:21:26 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1301071219540.1658-100000@iolanthe.rowland.org>
References: <1357461697-4219-4-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1357461697-4219-4-git-send-email-aaron.lu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, 6 Jan 2013, Aaron Lu wrote:

> From: Lin Ming <ming.m.lin@intel.com>
> 
> When a request is added:
>     If device is suspended or is suspending and the request is not a
>     PM request, resume the device.
> 
> When the last request finishes:
>     Call pm_runtime_mark_last_busy() and pm_runtime_autosuspend().
> 
> When pick a request:
>     If device is resuming/suspending, then only PM request is allowed to go.
>     Return NULL for other cases.
> 
> [aaron.lu@intel.com: PM request does not involve nr_pending counting]
> [aaron.lu@intel.com: No need to check q->dev]
> [aaron.lu@intel.com: Autosuspend when the last request finished]
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -974,6 +974,40 @@ extern int blk_pre_runtime_suspend(struct request_queue *q);
>  extern void blk_post_runtime_suspend(struct request_queue *q, int err);
>  extern void blk_pre_runtime_resume(struct request_queue *q);
>  extern void blk_post_runtime_resume(struct request_queue *q, int err);
> +
> +static inline void blk_pm_put_request(struct request *rq)
> +{
> +	if (!(rq->cmd_flags & REQ_PM) && !--rq->q->nr_pending) {
> +		pm_runtime_mark_last_busy(rq->q->dev);
> +		pm_runtime_autosuspend(rq->q->dev);
> +	}
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
> +static inline void blk_pm_requeue_request(struct request *rq)
> +{
> +	if (!(rq->cmd_flags & REQ_PM))
> +		rq->q->nr_pending--;
> +}
> +
> +static inline void blk_pm_add_request(struct request_queue *q,
> +	struct request *rq)
> +{
> +	if (!(rq->cmd_flags & REQ_PM) &&
> +	    q->nr_pending++ == 0 &&
> +	    (q->rpm_status == RPM_SUSPENDED ||
> +	     q->rpm_status == RPM_SUSPENDING))
> +		pm_request_resume(q->dev);
> +}

These routines also don't belong in include/linux.  And they don't need 
to be marked inline.

Alan Stern
