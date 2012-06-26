From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/4] scsi: Fix device removal NULL pointer dereference
Date: Tue, 26 Jun 2012 10:03:02 +0000
Message-ID: <4FE988D6.5040708@acm.org>
References: <4FE8A9FC.6040805@acm.org> <4FE8AAB9.9060602@acm.org> <1340658889.2980.51.camel@dabdike.int.hansenpartnership.com> <4FE95ADE.2080102@acm.org> <4FE97D2F.9070705@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02ant.iops.be ([212.53.4.35]:33451 "EHLO
	relay02ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab2FZKDG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jun 2012 06:03:06 -0400
In-Reply-To: <4FE97D2F.9070705@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>

On 06/26/12 09:13, Mike Christie wrote:

> I think there is still another bug in this path when it is called from
> the requeue path. If scsi_requeue_command requeues a command and that
> gets executed by some other thread before scsi_requeue_command calls
> scsi_run_queue then we could end up accessing freed memory.
> 
> It looks possible some other thread is doing
> blk_cleanup_queue->blk_drain_queue and that calls blk_run_queue and that
> kills/fails the IO that scsi_requeue_command had queued. Then
> blk_cleanup_queue could complete and we could end up doing the last put
> on the device and freeing the queue and sdev before scsi_requeue_command
> can call scsi_run_queue. scsi_run_queue could then be accessing freed
> memory.
> 
> I think we need a get/put:
> 
> scsi_requeue_command....
> 
> get_device(&sdev->sdev_gendev);
> 
> spin_lock_irqsave(q->queue_lock, flags);
> scsi_unprep_request(req);
> blk_requeue_request(q, req);
> spin_unlock_irqrestore(q->queue_lock, flags);
> 
> scsi_run_queue(q);
> 
> put_device(&sdev->sdev_gendev);
> 
> This will prevent some other path from freeing the queue/sdev from under us.


The above makes a lot of sense to me - I'll have a closer look at it.

However, it seems to me that we are paying a price for
scsi_dispatch_cmd() being called without the queue lock held, namely
increased complexity of the SCSI core.

Bart.

 


