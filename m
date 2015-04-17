From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH, RFC] scsi: use host wide tags by default
Date: Fri, 17 Apr 2015 16:07:55 -0600
Message-ID: <5531843B.4070608@kernel.dk>
References: <1429301471-5666-1-git-send-email-hch@lst.de>		 <1429306960.1079.25.camel@HansenPartnership.com>	 <55317EAE.10201@kernel.dk> <1429307160.1079.27.camel@HansenPartnership.com>	 <55317F86.7030509@kernel.dk> <1429307850.1079.35.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35689 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbbDQWH6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2015 18:07:58 -0400
Received: by pabtp1 with SMTP id tp1so138245255pab.2
        for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2015 15:07:57 -0700 (PDT)
In-Reply-To: <1429307850.1079.35.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 04/17/2015 03:57 PM, James Bottomley wrote:
> On Fri, 2015-04-17 at 15:47 -0600, Jens Axboe wrote:
>> On 04/17/2015 03:46 PM, James Bottomley wrote:
>>> On Fri, 2015-04-17 at 15:44 -0600, Jens Axboe wrote:
>>>> On 04/17/2015 03:42 PM, James Bottomley wrote:
>>>>>> @@ -662,32 +662,14 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
>>>>>>      */
>>>>>>     int scsi_change_queue_depth(struct scsi_device *sdev, int depth)
>>>>>>     {
>>>>>> -	unsigned long flags;
>>>>>> -
>>>>>> -	if (depth <= 0)
>>>>>> -		goto out;
>>>>>> -
>>>>>> -	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
>>>>>> +	if (depth > 0) {
>>>>>> +		unsigned long flags;
>>>>>>
>>>>>> -	/*
>>>>>> -	 * Check to see if the queue is managed by the block layer.
>>>>>> -	 * If it is, and we fail to adjust the depth, exit.
>>>>>> -	 *
>>>>>> -	 * Do not resize the tag map if it is a host wide share bqt,
>>>>>> -	 * because the size should be the hosts's can_queue. If there
>>>>>> -	 * is more IO than the LLD's can_queue (so there are not enuogh
>>>>>> -	 * tags) request_fn's host queue ready check will handle it.
>>>>>> -	 */
>>>>>> -	if (!shost_use_blk_mq(sdev->host) && !sdev->host->bqt) {
>>>>>> -		if (blk_queue_tagged(sdev->request_queue) &&
>>>>>> -		    blk_queue_resize_tags(sdev->request_queue, depth) != 0)
>>>>>> -			goto out_unlock;
>>>>>> +		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
>>>>>> +		sdev->queue_depth = depth;
>>>>>> +		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
>>>>>
>>>>> This lock/unlock is a nasty global sync point which can be eliminated:
>>>>> we can rely on the architectural atomicity of 32 bit writes (might need
>>>>> to make sdev->queue_depth a u32 because I seem to remember 16 bit writes
>>>>> had to be done as two byte stores on some architectures).
>>>>
>>>> It's not in a hot path (by any stretch), so doesn't really matter...
>>>
>>> Sure, but it's good practise not to do this, otherwise the pattern
>>> lock/u32 store/unlock gets duplicated into hot paths by people who are
>>> confused about whether locking is required.
>>
>> It's a lot saner default to lock/unlock and have people copy that, than
>> have them misguidedly think that no locking is require for whatever
>> reason.
>
> Moving to lockless coding is important for the small packet performance
> we're all chasing.  I'd rather train people to think about the problem
> than blindly introduce unnecessary locking and then have someone else
> remove it in the name of performance improvement.  If they get it wrong
> the other way (no locking where it was needed) our code review process
> should spot that.

We're chasing cycles for the hot path, not for the init path. I'd much 
rather keep it simple where we can, and keep the much harder problems 
for the cases that really matter. Locking and ordering is _hard_, most 
people get it wrong, most of the time. And spotting missing locking at 
review time is a much harder problem. I would generally recommend people 
get it right _first_, then later work on optimizing the crap out of it. 
That's much easier to do with a stable base anyway.

> In this case, it is a problem because in theory the language ('C') makes
> no such atomicity guarantees (which is why most people think you need a
> lock here).  The atomicity guarantees are extrapolated from the platform
> it's running on.
>
>>   The write itself might be atomic, but you still need to
>> guarantee visibility.
>
> The function barrier guarantees mean it's visible by the time the
> function returns.  However, I wouldn't object to a wmb here if you think
> it's necessary ... it certainly serves as a marker for "something clever
> is going on".

The sequence point means it's not reordered across it, it does not give 
you any guarantees on visibility. And we're getting into semantics of C 
here, but I believe or that even to be valid, you'd need to make 
->queue_depth volatile. And honestly, I'd hate to rely on that. Which 
means you need proper barriers.

>>   For something like this init style case, I would
>> not try and do anything clever...
>
> I don't really think it is that clever ... any time anyone sees a
> lock/unlock around a single operation, they should always ask themselves
> "do I really need this?".  The answer isn't always "no" but it sometimes
> is.

Maybe clever was the wrong word, but it's what I would generally call 
harmful optimization.

But I seriously don't want to spend the rest of my night responding in 
this thread. I just don't care that much about this (non) issue. If you 
want to remove the locks and add the barriers instead, then go for it.

-- 
Jens Axboe

