From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/4] scsi: Stop accepting SCSI requests before removing
 a device
Date: Wed, 06 Jun 2012 08:43:07 -0500
Message-ID: <4FCF5E6B.40507@cs.wisc.edu>
References: <4FCE3D20.4000205@acm.org> <4FCE3E63.7000002@acm.org> <4FCE8349.2000908@cs.wisc.edu> <4FCF4C1E.1080300@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50196 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717Ab2FFNnc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Jun 2012 09:43:32 -0400
In-Reply-To: <4FCF4C1E.1080300@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Jens Axboe <axboe@kernel.dk>, Joe Lawrence <jdl1291@gmail.com>

On 06/06/2012 07:25 AM, Bart Van Assche wrote:
> On 06/05/12 22:08, Mike Christie wrote:
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
>>>  	spin_unlock_irqrestore(q->queue_lock, flags);
>>> -
>>> -	kblockd_schedule_work(q, &device->requeue_work);
>>
>> If we do not have the part of the patch above, but have your other
>> patches and the code below, will we be ok?
> 
> 
> I'm not sure. Without the above part the request could get killed after
> the blk_requeue_request() call finished but before the requeue_work is
> scheduled, e.g. because the request timer fired or due to a
> blk_abort_queue() call.
> 

You are right.

What if we moved the requeue work struct to the request queue, then have
blk_cleanup_queue or blk_drain_queue call cancel_work_sync before the
queue is freed. That way that code could make sure the queue and work is
flushed and drained, and it can make sure it is flushed and drained
before freeing the queue?
