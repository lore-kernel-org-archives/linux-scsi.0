From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v6 04/13] block: Avoid scheduling delayed work on a dead
 queue
Date: Sun, 02 Dec 2012 14:41:20 +0100
Message-ID: <50BB5A80.5010600@acm.org>
References: <50B60619.4080406@acm.org> <50B60784.1080604@acm.org> <20121202132613.GD15930@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:46862 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2LBNlX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Dec 2012 08:41:23 -0500
In-Reply-To: <20121202132613.GD15930@mtj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

On 12/02/12 14:26, Tejun Heo wrote:
> On Wed, Nov 28, 2012 at 01:45:56PM +0100, Bart Van Assche wrote:
>> Running a queue must continue after it has been marked dying until
>> it has been marked dead. So the function blk_run_queue_async() must
>> not schedule delayed work after blk_cleanup_queue() has marked a queue
>> dead. Hence add a test for that queue state in blk_run_queue_async()
>> and make sure that queue_unplugged() invokes that function with the
>> queue lock held. This avoids that the queue state can change after
>> it has been tested and before mod_delayed_work() is invoked. Drop
>> the queue dying test in queue_unplugged() since it is now
>> superfluous: __blk_run_queue() already tests whether or not the
>> queue is dead.
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Mike Christie <michaelc@cs.wisc.edu>
>> Cc: Jens Axboe <axboe@kernel.dk>
>
> Acked-by: Tejun Heo <tj@kernel.org>
>
> But, some nits.
>
>> @@ -219,12 +219,13 @@ static void blk_delay_work(struct work_struct *work)
>>    * Description:
>>    *   Sometimes queueing needs to be postponed for a little while, to allow
>>    *   resources to come back. This function will make sure that queueing is
>> - *   restarted around the specified time.
>> + *   restarted around the specified time. Queue lock must be held.
>>    */
>
> Comment is fine but lockdep_assert_held() is way more effective.
>
>>   void blk_delay_queue(struct request_queue *q, unsigned long msecs)
>>   {
>> -	queue_delayed_work(kblockd_workqueue, &q->delay_work,
>> -				msecs_to_jiffies(msecs));
>> +	if (likely(!blk_queue_dead(q)))
>> +		queue_delayed_work(kblockd_workqueue, &q->delay_work,
>> +				   msecs_to_jiffies(msecs));
>>   }
>>   EXPORT_SYMBOL(blk_delay_queue);
>>
>> @@ -334,11 +335,11 @@ EXPORT_SYMBOL(__blk_run_queue);
>>    *
>>    * Description:
>>    *    Tells kblockd to perform the equivalent of @blk_run_queue on behalf
>> - *    of us.
>> + *    of us. The caller must hold the queue lock.
>>    */
>
> Ditto.

I agree. There is a reason though I have not yet added a 
lockdep_assert_held() statement in these functions: there are still 
unprotected calls of blk_run_queue_async() in drivers/md/dm.c and 
drivers/scsi/scsi_transport_fc.c.

Bart.

