From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/4] scsi: Fix device removal NULL pointer dereference
Date: Tue, 26 Jun 2012 04:13:19 -0500
Message-ID: <4FE97D2F.9070705@cs.wisc.edu>
References: <4FE8A9FC.6040805@acm.org> <4FE8AAB9.9060602@acm.org> <1340658889.2980.51.camel@dabdike.int.hansenpartnership.com> <4FE95ADE.2080102@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55574 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928Ab2FZJNp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jun 2012 05:13:45 -0400
In-Reply-To: <4FE95ADE.2080102@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>

On 06/26/2012 01:46 AM, Bart Van Assche wrote:
>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>>> >> index 6dfb978..c26ef49 100644
>>> >> --- a/drivers/scsi/scsi_lib.c
>>> >> +++ b/drivers/scsi/scsi_lib.c
>>> >> @@ -406,10 +406,7 @@ static void scsi_run_queue(struct request_queue *q)
>>> >>  	LIST_HEAD(starved_list);
>>> >>  	unsigned long flags;
>>> >>  
>>> >> -	/* if the device is dead, sdev will be NULL, so no queue to run */
>>> >> -	if (!sdev)
>>> >> -		return;
>>> >> -
>>> >> +	BUG_ON(!sdev);
>> > 
>> > Needs to be a blk_queue_dead() check as well.
> 
> Callers of scsi_run_queue() don't hold the queue lock. Does it make
> sense to test whether the queue is dead without the queue lock being held ?
> 

I think there is still another bug in this path when it is called from
the requeue path. If scsi_requeue_command requeues a command and that
gets executed by some other thread before scsi_requeue_command calls
scsi_run_queue then we could end up accessing freed memory.

It looks possible some other thread is doing
blk_cleanup_queue->blk_drain_queue and that calls blk_run_queue and that
kills/fails the IO that scsi_requeue_command had queued. Then
blk_cleanup_queue could complete and we could end up doing the last put
on the device and freeing the queue and sdev before scsi_requeue_command
can call scsi_run_queue. scsi_run_queue could then be accessing freed
memory.

I think we need a get/put:

scsi_requeue_command....

get_device(&sdev->sdev_gendev);

spin_lock_irqsave(q->queue_lock, flags);
scsi_unprep_request(req);
blk_requeue_request(q, req);
spin_unlock_irqrestore(q->queue_lock, flags);

scsi_run_queue(q);

put_device(&sdev->sdev_gendev);

This will prevent some other path from freeing the queue/sdev from under us.
