From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH, resend] Fix race between starved list processing and
 device removal
Date: Sun, 07 Oct 2012 20:24:27 +0200
Message-ID: <5071C8DB.50803@acm.org>
References: <5024088C.9060205@acm.org> <50605CBC.5080701@acm.org> <1349606837.2541.19.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:33570 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab2JGSYb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Oct 2012 14:24:31 -0400
In-Reply-To: <1349606837.2541.19.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

On 10/07/12 12:47, James Bottomley wrote:
> On Mon, 2012-09-24 at 15:14 +0200, Bart Van Assche wrote:
>> Avoid that the sdev reference count can drop to zero before
>> the queue is run by scsi_run_queue(). Also avoid that the sdev
>> reference count can drop to zero in the same function by invoking
>> __blk_run_queue().
> [...]		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
>> @@ -977,6 +978,10 @@ void __scsi_remove_device(struct scsi_device *sdev)
>>   	blk_cleanup_queue(sdev->request_queue);
>>   	cancel_work_sync(&sdev->requeue_work);
>>
>> +	spin_lock_irqsave(shost->host_lock, flags);
>> +	list_del(&sdev->starved_entry);
>> +	spin_unlock_irqrestore(shost->host_lock, flags);
>> +
>
> This hunk doesn't make much sense.  It seems to be orthogonal to the
> problem listed in the changelog and this action is done on last put
> anyway.

Removing an sdev from the starved list in __scsi_remove_device() has the 
advantage that it is guaranteed that the get_device() call added in 
scsi_run_queue() will succeed. A possible alternative is to leave the 
starved list removal code in scsi_device_dev_release_usercontext() and 
to invoke __blk_run_queue() in scsi_run_queue() only if the get_device() 
call in that function succeeded. Does this mean that you prefer the 
second option - something like the (untested) code below ?

		if (get_device(&sdev->sdev_gendev)) {
			spin_unlock(shost->host_lock);

			spin_lock(sdev->request_queue->queue_lock);
			__blk_run_queue(sdev->request_queue);
			spin_unlock(sdev->request_queue->queue_lock);

			put_device(&sdev->sdev_gendev);
			spin_lock(shost->host_lock);
		}

Bart.

