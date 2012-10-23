From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/4] block: Avoid that request_fn is invoked on a dead
 queue
Date: Tue, 23 Oct 2012 14:11:29 +0200
Message-ID: <50868971.2060209@acm.org>
References: <50758EBE.7050202@acm.org> <50758F51.3020601@acm.org> <20121016233829.GK16166@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:42598 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab2JWMLd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Oct 2012 08:11:33 -0400
In-Reply-To: <20121016233829.GK16166@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>

On 10/17/12 01:38, Tejun Heo wrote:
>>   /**
>> + * __blk_run_queue_uncond - run a queue whether or not it has been stopped
>> + * @q:	The queue to run
>> + *
>> + * Description:
>> + *    Invoke request handling on a queue if there are any pending requests.
>> + *    May be used to restart request handling after a request has completed.
>> + *    This variant runs the queue whether or not the queue has been
>> + *    stopped. Must be called with the queue lock held and interrupts
>> + *    disabled. See also @blk_run_queue.
>> + */
>> +void __blk_run_queue_uncond(struct request_queue *q)
>> +{
>> +	if (unlikely(blk_queue_dead(q)))
>> +		return;
>> +
>> +	q->request_fn(q);
>> +}
>> +
>> +/**
>>    * __blk_run_queue - run a single device queue
>>    * @q:	The queue to run
>>    *
>> @@ -305,7 +324,7 @@ void __blk_run_queue(struct request_queue *q)
>>   	if (unlikely(blk_queue_stopped(q)))
>>   		return;
>>
>> -	q->request_fn(q);
>> +	__blk_run_queue_uncond(q);
>
> __blk_run_queue_uncond() is a cold path and I don't think adding a
> test there matters but I think it would be better if we avoid an extra
> branch if possible for __blk_run_queue().  Can't we merge
> blk_queue_stopped/dead() testing?

How about declaring the function __blk_run_queue_uncond() inline ? That 
should allow the compiler to combine the two tests into a single test.

Bart.

