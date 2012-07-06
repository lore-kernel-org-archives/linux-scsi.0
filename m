From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v5 3/4] block: implement runtime pm strategy
Date: Fri, 6 Jul 2012 10:21:49 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1207061019170.28821-100000@netrider.rowland.org>
References: <1341547472-6863-4-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1341547472-6863-4-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 6 Jul 2012, Lin Ming wrote:

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
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>

Generally okay, but...

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
...

These new helper routines are private to the block layer, not intended
for use by clients.  Consequently they don't belong in include/linux;
they should go in block/blk.h.

Alan Stern
