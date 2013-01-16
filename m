From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v7 3/4] block: implement runtime pm strategy
Date: Wed, 16 Jan 2013 10:30:45 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1301161020190.1704-100000@iolanthe.rowland.org>
References: <1358326941-3725-4-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1358326941-3725-4-git-send-email-aaron.lu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 16 Jan 2013, Aaron Lu wrote:

> From: Lin Ming <ming.m.lin@intel.com>
> 
> When a request is added:
>     If device is suspended or is suspending and the request is not a
>     PM request, resume the device.
> 
> When the last request finishes:
>     Call pm_runtime_mark_last_busy().
> 
> When pick a request:
>     If device is resuming/suspending, then only PM request is allowed
>     to go.
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

Just a couple of minor problems remaining...

> --- a/block/blk-core.c
> +++ b/block/blk-core.c

> @@ -2051,6 +2063,28 @@ static void blk_account_io_done(struct request *req)
>  	}
>  }
>  
> +#ifdef CONFIG_PM_RUNTIME
> +/*
> + * Don't process normal requests when queue is suspended
> + * or in the process of suspending/resuming
> + */
> +static struct request *blk_pm_peek_request(struct request_queue *q,
> +					   struct request *rq)
> +{
> +	if (q->rpm_status == RPM_SUSPENDED ||
> +	    (q->rpm_status != RPM_ACTIVE && !(rq->cmd_flags & REQ_PM)))
> +		return NULL;
> +	else
> +		return rq;
> +}

You don't check q->dev here, so the result is indefinite for devices
that don't use runtime PM.  (Actually it will work out because
RPM_ACTIVE is defined as 0, but that's a pretty fragile approach.)

Either do check q->dev here, or else explicitly initialize
q->rpm_status when the queue is created.


> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -34,6 +34,7 @@
>  #include <linux/blktrace_api.h>
>  #include <linux/hash.h>
>  #include <linux/uaccess.h>
> +#include <linux/pm_runtime.h>
>  
>  #include <trace/events/block.h>
>  
> @@ -515,6 +516,27 @@ void elv_bio_merged(struct request_queue *q, struct request *rq,
>  		e->type->ops.elevator_bio_merged_fn(q, rq, bio);
>  }
>  
> +#ifdef CONFIG_PM_RUNTIME
> +static void blk_pm_requeue_request(struct request *rq)
> +{
> +	if (!(rq->cmd_flags & REQ_PM))
> +		rq->q->nr_pending--;
> +}

You don't check q->dev here.  That's okay, but it means that
q->nr_pending will be meaningless or wrong if any I/O takes place
before blk_pm_runtime_init is called.

Therefore the kerneldoc for blk_pm_runtime_init should mention that it
must not be called after any requests have been submitted.  Also
mention that blk_pm_runtime_init enables runtime PM for q->dev, so the 
caller shouldn't do it.

Alan Stern
