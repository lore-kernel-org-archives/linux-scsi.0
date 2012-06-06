From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/4] block: Fix race on request_queue.end_io invocations
Date: Wed, 06 Jun 2012 14:45:43 +0200
Message-ID: <4FCF50F7.2080008@kernel.dk>
References: <4FCE3D20.4000205@acm.org> <4FCE3D77.8040909@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:35326 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab2FFMqK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jun 2012 08:46:10 -0400
In-Reply-To: <4FCE3D77.8040909@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Tejun Heo <tj@kernel.org>

On 06/05/2012 07:10 PM, Bart Van Assche wrote:
> Some request_queue.end_io implementations can be called safely
> without the queue lock held while several other implementations
> assume that the queue lock is held. So let's play it safe and
> make sure that the queue lock is held around end_io invocations.
> Found this through source code review.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: <stable@kernel.org>
> ---
>  block/blk-exec.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/block/blk-exec.c b/block/blk-exec.c
> index fb2cbd5..6724fab 100644
> --- a/block/blk-exec.c
> +++ b/block/blk-exec.c
> @@ -54,10 +54,10 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
>  	spin_lock_irq(q->queue_lock);
>  
>  	if (unlikely(blk_queue_dead(q))) {
> -		spin_unlock_irq(q->queue_lock);
>  		rq->errors = -ENXIO;
>  		if (rq->end_io)
>  			rq->end_io(rq, rq->errors);
> +		spin_unlock_irq(q->queue_lock);
>  		return;
>  	}

I'm assuming you checked any in-kernel users of rq->end_io to ensure
that it is fine? If so, patch looks fine to me. And I agree, it's not
stable material.

-- 
Jens Axboe

