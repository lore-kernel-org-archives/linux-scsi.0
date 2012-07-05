From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v4 3/4] block: implement runtime pm strategy
Date: Thu, 5 Jul 2012 09:54:09 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1207050951530.30876-100000@netrider.rowland.org>
References: <1341473199-3837-4-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1341473199-3837-4-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 5 Jul 2012, Lin Ming wrote:

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

These changes would look better if you didn't have "#ifdef
CONFIG_PM_RUNTIME" sprinkled throughout the block-layer routines.

Instead, define static helper functions to do your work, and put the 
definitions inside a #ifdef block.  If CONFIG_PM_RUNTIME isn't enabled,
the helper functions can be empty static inlines.
 
> --- a/block/elevator.c +++ b/block/elevator.c @@ -536,6 +537,11 @@

> void elv_requeue_request(struct request_queue *q, struct request *rq)
>  
>  	rq->cmd_flags &= ~REQ_STARTED;
>  
> +#ifdef CONFIG_PM_RUNTIME
> +	/* __elv_add_request will increment the count */
> +	if (!(rq->cmd_flags & REQ_PM))
> +		q->nr_pending--;
> +#endif

__elv_add_request increments nr_pending even when REQ_PM is set.  You 
need to be consistent with that behavior.

Alan Stern
