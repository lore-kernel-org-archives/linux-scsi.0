From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/4] scsi: Stop accepting SCSI requests before removing
 a device
Date: Wed, 06 Jun 2012 08:29:28 -0500
Message-ID: <4FCF5B38.7020707@cs.wisc.edu>
References: <4FCE3D20.4000205@acm.org> <4FCE3E63.7000002@acm.org> <4FCE7BC9.1010504@cs.wisc.edu> <4FCF4A52.20406@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50173 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304Ab2FFN3z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Jun 2012 09:29:55 -0400
In-Reply-To: <4FCF4A52.20406@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Jens Axboe <axboe@kernel.dk>, Joe Lawrence <jdl1291@gmail.com>

On 06/06/2012 07:17 AM, Bart Van Assche wrote:
> On 06/05/12 21:36, Mike Christie wrote:
> 
>> On 06/05/2012 12:14 PM, Bart Van Assche wrote:
>>> Avoid that the code for requeueing SCSI requests triggers a
>>> crash by making sure that that code isn't scheduled anymore
>>> after a device has been removed.
>>>
>>> Also, source code inspection of __scsi_remove_device() revealed
>>> a race condition in this function: no new SCSI requests must be
>>> accepted for a SCSI device after device removal started.
>>>
>>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>>> Cc: Mike Christie <michaelc@cs.wisc.edu>
>>> Cc: James Bottomley <JBottomley@parallels.com>
>>> Cc: Jens Axboe <axboe@kernel.dk>
>>> Cc: Joe Lawrence <jdl1291@gmail.com>
>>> Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
>>> Cc: <stable@kernel.org>
>>> ---
>>>  drivers/scsi/scsi_lib.c   |    7 ++++---
>>>  drivers/scsi/scsi_sysfs.c |   11 +++++++++--
>>>  2 files changed, 13 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>>> index 082c1e5..b722a8b 100644
>>> --- a/drivers/scsi/scsi_lib.c
>>> +++ b/drivers/scsi/scsi_lib.c
>>> @@ -158,10 +158,11 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
>>>  	 * that are already in the queue.
>>>  	 */
>>>  	spin_lock_irqsave(q->queue_lock, flags);
>>> -	blk_requeue_request(q, cmd->request);
>>> +	if (!blk_queue_dead(q)) {
>>> +		blk_requeue_request(q, cmd->request);
>>> +		kblockd_schedule_work(q, &device->requeue_work);
>>> +	}
>>
>> If we do not requeue what eventually frees the request?
> 
> As far as I can see any request passed to __scsi_queue_insert() has
> already been started. So if it isn't requeued it's timer remains active
> and hence will fire eventually.

This is true in the scsi_dispatch_cmd path, but not others.

If we were requeueing from the error handler scsi_eh_flush_done_q then
the timer would have been stopped because that is how we got into the eh.

If we are coming from the completion path then the timer will not be
running basically. For example if we requeue from scsi_softirq_done or
scsi_io_completion then we will have called blk_complete_request in
scsi_done already, so the blk_mark_rq_complete call in there would
prevent the timer code from running on the request.
