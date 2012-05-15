From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC PATCH 3/3] block: add queue idle timer
Date: Tue, 15 May 2012 15:19:11 -0400
Message-ID: <x49mx59b6c0.fsf@segfault.boston.devel.redhat.com>
References: <1337071697-30920-1-git-send-email-ming.m.lin@intel.com>
	<1337071697-30920-4-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966416Ab2EOTTS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 May 2012 15:19:18 -0400
In-Reply-To: <1337071697-30920-4-git-send-email-ming.m.lin@intel.com> (Lin
	Ming's message of "Tue, 15 May 2012 16:48:17 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org

Lin Ming <ming.m.lin@intel.com> writes:

> Add an idle timer that is set to some suitable timeout and would be
> added when the queue first goes empty. If nothing has happened during
> the timeout interval, then the queue is suspended.
>
> Queueing a new request could check the state and resume queue if it is
> supended.
>

[snip]

> @@ -1129,6 +1141,13 @@ void __blk_put_request(struct request_queue *q, struct request *req)
>  	if (unlikely(--req->ref_count))
>  		return;
>  
> +	/* PM request is not accounted */
> +	if (!(req->cmd_flags & REQ_PM)) {
> +		if (!(--q->nr_pending))
> +			/* Hard code to 20secs, will move to sysfs */
> +			mod_timer(&q->idle, jiffies + 20*HZ);
> +	}
> +

I'm pretty sure Jens wanted to avoid doing a mod_timer, here, given that
the queue can transition between empty and non-empty fairly rapidly for
dependent I/O.

> @@ -587,6 +590,13 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
>  {
>  	trace_block_rq_insert(q, rq);
>  
> +	if (!(rq->cmd_flags & REQ_PM)) {
> +		if (!(q->pm_status != RPM_ACTIVE) &&

Uhh, re-read that line.  Not not equal?

Cheers,
Jeff
