From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: blk-mq queue selection and queue_rq preemption
Date: Wed, 09 Apr 2014 15:10:12 +0300
Message-ID: <534538A4.6050103@dev.mellanox.co.il>
References: <53429DA2.4030708@dev.mellanox.co.il> <53430063.1020503@kernel.dk> <5343D93A.3070709@dev.mellanox.co.il> <53441879.3010909@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:65231 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542AbaDIMKS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Apr 2014 08:10:18 -0400
Received: by mail-we0-f178.google.com with SMTP id u56so2324939wes.23
        for <linux-scsi@vger.kernel.org>; Wed, 09 Apr 2014 05:10:16 -0700 (PDT)
In-Reply-To: <53441879.3010909@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>

On 4/8/2014 6:40 PM, Jens Axboe wrote:
> On 2014-04-08 05:10, Sagi Grimberg wrote:
>> On 4/7/2014 10:45 PM, Jens Axboe wrote:
>>> On 04/07/2014 06:44 AM, Sagi Grimberg wrote:
>>>> Hey Jens, Christoph & Co,
>>>>
>>>> I raised this question at LSF but didn't get a clear answer on this
>>>> matter.
>>>> So it seems to me that the hctx selection and the actual request
>>>> dispatch (queue_rq) are preemptive:
>>>> (1) blk_mq_get_ctx(q);
>>>> (2) map_queue(q, ctx->cpu);
>>>> ...
>>>> (3) blk_mq_put_ctx(ctx);
>>>> (4) blk_mq_run_hw_queue(hctx, async);
>>>>
>>>> It is possible that an MQ device driver may want to implement a 
>>>> lockless
>>>> scheme counting on (running) CPU <-> hctx attachment.
>>>> Generally speaking, I think that LLDs will be more comfortable knowing
>>>> that they are not preemptive in the dispatch flow.
>>>>
>>>> My question is, is this a must? if so can you please explain why?
>>>>
>>>> Is it possible to put the hctx (restoring preemption) after 
>>>> run_hw_queue
>>>> allowing to LLDs to be sure that the selected queue
>>>> match the running CPU?
>>>
>>> It's a good question, and one I have thought about before. As you
>>> note, in the existing code, the mappings are what I would refer to as
>>> "soft". Generally speaking, CPU X will always map to hardware queue Y,
>>> but there are no specific guarantees made to effect. It would be
>>> trivial to make this mapping hard, and I'd be very open to doing that.
>>> But so far I haven't seen cases where it would improve things. If you
>>> end up being preempted and moved to a different CPU, it doesn't really
>>> matter if this happens before or after you queued the IO - the
>>> completion will end up in the "wrong" location regardless.
>>>
>>> But if drivers can be simplified and improved through relying on hard
>>> mappings (and preempt hence disabled), then I would definitely provide
>>> that possibility as well. If it doesn't hurt by default, we can just
>>> switch to that model.
>>>
>>
>> Hey Jens, thanks for the quick response!
>>
>> So in my driver I would definitely want to rely on hard mappings.
>> The reason is that I maintain a context for IO completions (lets call it
>> "completer") and a submission queue percpu.
>> The completer handles IO completions and also peeks at the submission
>> queue to handle pending IOs.
>> I wish to keep mutual exclusion between the completer and the submission
>> context.
>> The driver is capable of setting the IO submission so that the
>> completion will end up on the same core.
>>
>> Hard mappings providing non-preemptive submission flows will guarantee
>> that the above scheme will work.
>> At the moment I do:
>> (1) queue = hctx->driver_data
>> process request...
>> (2) cpu = get_cpu()
>> (3) if (cpu != queue.id)
>>              queue = queues[cpu]
>> (4) submit_io(queue)
>> (5) put_cpu()
>>
>> So, adding hard_map indicator to blk_mq_reg will be great.
>>
>> As I mentioned in the general case, I think that LLDs will be more
>> comfortable with hard mappings in order to avoid/reduce
>> lock contention in the submission path and also possibly exploiting
>> cache/NUMA locality. Moreover I think that setting the device to 
>> generate
>> IO completion on the submission CPU is common practice for blk-mq
>> implementation. isn't it?
>>
>> I would definitely like to get more input from the driver folks on this.
>
> I've rolled up a set of changes to test this out, I have attached the 
> small series. As I originally stated, it was due to performance 
> concerns that I didn't do this originally. If this works better (or 
> the same) on cases where we don't necessarily care about the hard 
> mappings, then we should just do it. It's a cleaner model, and the 
> hardware that has as many queues as CPUs, it's definitely the right 
> (and obvious) thing to do.
>
> Note that the attached are TOTALLY untested.
>

Thanks Jens!

I'll give it a go...

Sagi.
