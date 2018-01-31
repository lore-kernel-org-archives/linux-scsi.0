From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [dm-devel] [PATCH v5] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Tue, 30 Jan 2018 20:17:32 -0700
Message-ID: <7baf8e0f-7a15-4529-c32b-4ce0ee172598@kernel.dk>
References: <20180130142459.52668-1-snitzer@redhat.com>
 <43ac2314-c98d-bb76-0dfb-171d15cc5fd8@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <43ac2314-c98d-bb76-0dfb-171d15cc5fd8@wdc.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 1/30/18 10:52 AM, Bart Van Assche wrote:
> On 01/30/18 06:24, Mike Snitzer wrote:
>> +		 *
>> +		 * If driver returns BLK_STS_RESOURCE and SCHED_RESTART
>> +		 * bit is set, run queue after a delay to avoid IO stalls
>> +		 * that could otherwise occur if the queue is idle.
>>   		 */
>> -		if (!blk_mq_sched_needs_restart(hctx) ||
>> +		needs_restart = blk_mq_sched_needs_restart(hctx);
>> +		if (!needs_restart ||
>>   		    (no_tag && list_empty_careful(&hctx->dispatch_wait.entry)))
>>   			blk_mq_run_hw_queue(hctx, true);
>> +		else if (needs_restart && (ret == BLK_STS_RESOURCE))
>> +			blk_mq_delay_run_hw_queue(hctx, BLK_MQ_QUEUE_DELAY);
>>   	}
> 
> If a request completes concurrently with execution of the above code 
> then the request completion will trigger a call of 
> blk_mq_sched_restart_hctx() and that call will clear the 
> BLK_MQ_S_SCHED_RESTART bit. If that bit is cleared before the above code 
> tests it then the above code will schedule an asynchronous call of 
> __blk_mq_run_hw_queue(). If the .queue_rq() call triggered by the new 
> queue run returns again BLK_STS_RESOURCE then the above code will be 
> executed again. In other words, a loop occurs. That loop will repeat as 
> long as the described race occurs. The current (kernel v4.15) block 
> layer behavior is simpler: only block drivers call 
> blk_mq_delay_run_hw_queue() and the block layer core never calls that 
> function. Hence that loop cannot occur with the v4.15 block layer core 
> and block drivers. A motivation of why that loop is preferred compared 
> to the current behavior (no loop) is missing. Does this mean that that 
> loop is a needless complication of the block layer core?

The dispatch, and later restart check, is within the hctx lock. The
completions should be as well.

> Sorry but I still prefer the v4.15 block layer approach because this 
> patch has in my view the following disadvantages:
> - It involves a blk-mq API change. API changes are always risky and need
>    some time to stabilize.
> - The delay after which to rerun the queue is moved from block layer
>    drivers into the block layer core. I think that's wrong because only
>    the block driver authors can make a good choice for this constant.

It's exactly the right place to put it, as drivers cannot make a good
decision for when to run the queue again. You get NULL on allocating
some piece of memory, when do you run it again? That's the last thing
I want driver writers to make a decision on, because a novice device
driver writer will just think that he should run the queue again asap.
In reality we are screwed. Decisions like that SHOULD be in shared
and generic code, not in driver private code.

> - This patch makes block drivers harder to understand. Anyone who sees
>    return BLK_STS_RESOURCE / return BLK_STS_DEV_RESOURCE for the first
>    time will have to look up the meaning of these constants. An explicit
>    blk_mq_delay_run_hw_queue() call is easier to understand.

BLK_STS_RESOURCE should always be safe to return, and it should work
the same as STS_DEV_RESOURCE, except it may cause an extra queue
run.

Well written drivers should use STS_DEV_RESOURCE where it makes
sense.

> - This patch does not fix any bugs nor makes block drivers easier to
>    read or to implement. So why is this patch considered useful?

It does fix the run bug on global resources, I'm assuming you mean
it doesn't fix any EXTRA bugs compared to just use the delayed
run?

-- 
Jens Axboe
