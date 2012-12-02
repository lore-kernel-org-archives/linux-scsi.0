From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 04/13] block: Avoid scheduling delayed work on a dead
 queue
Date: Sun, 2 Dec 2012 05:26:13 -0800
Message-ID: <20121202132613.GD15930@mtj.dyndns.org>
References: <50B60619.4080406@acm.org>
 <50B60784.1080604@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48770 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab2LBN0T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Dec 2012 08:26:19 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so1326530pad.19
        for <linux-scsi@vger.kernel.org>; Sun, 02 Dec 2012 05:26:18 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <50B60784.1080604@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

On Wed, Nov 28, 2012 at 01:45:56PM +0100, Bart Van Assche wrote:
> Running a queue must continue after it has been marked dying until
> it has been marked dead. So the function blk_run_queue_async() must
> not schedule delayed work after blk_cleanup_queue() has marked a queue
> dead. Hence add a test for that queue state in blk_run_queue_async()
> and make sure that queue_unplugged() invokes that function with the
> queue lock held. This avoids that the queue state can change after
> it has been tested and before mod_delayed_work() is invoked. Drop
> the queue dying test in queue_unplugged() since it is now
> superfluous: __blk_run_queue() already tests whether or not the
> queue is dead.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: Jens Axboe <axboe@kernel.dk>

Acked-by: Tejun Heo <tj@kernel.org>

But, some nits.

> @@ -219,12 +219,13 @@ static void blk_delay_work(struct work_struct *work)
>   * Description:
>   *   Sometimes queueing needs to be postponed for a little while, to allow
>   *   resources to come back. This function will make sure that queueing is
> - *   restarted around the specified time.
> + *   restarted around the specified time. Queue lock must be held.
>   */

Comment is fine but lockdep_assert_held() is way more effective.

>  void blk_delay_queue(struct request_queue *q, unsigned long msecs)
>  {
> -	queue_delayed_work(kblockd_workqueue, &q->delay_work,
> -				msecs_to_jiffies(msecs));
> +	if (likely(!blk_queue_dead(q)))
> +		queue_delayed_work(kblockd_workqueue, &q->delay_work,
> +				   msecs_to_jiffies(msecs));
>  }
>  EXPORT_SYMBOL(blk_delay_queue);
>  
> @@ -334,11 +335,11 @@ EXPORT_SYMBOL(__blk_run_queue);
>   *
>   * Description:
>   *    Tells kblockd to perform the equivalent of @blk_run_queue on behalf
> - *    of us.
> + *    of us. The caller must hold the queue lock.
>   */

Ditto.

>  void blk_run_queue_async(struct request_queue *q)
>  {
> -	if (likely(!blk_queue_stopped(q)))
> +	if (likely(!blk_queue_stopped(q) && !blk_queue_dead(q)))
>  		mod_delayed_work(kblockd_workqueue, &q->delay_work, 0);
>  }
>  EXPORT_SYMBOL(blk_run_queue_async);

Thanks.

-- 
tejun
