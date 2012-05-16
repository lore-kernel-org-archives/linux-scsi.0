From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC PATCH 3/3] block: add queue idle timer
Date: Wed, 16 May 2012 15:53:18 +0200
Message-ID: <4FB3B14E.2040306@kernel.dk>
References: <1337071697-30920-1-git-send-email-ming.m.lin@intel.com> <1337071697-30920-4-git-send-email-ming.m.lin@intel.com> <x49mx59b6c0.fsf@segfault.boston.devel.redhat.com> <1337131643.22243.2.camel@minggr> <x49r4uke0p1.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <x49r4uke0p1.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/16/2012 03:04 PM, Jeff Moyer wrote:
> Lin Ming <ming.m.lin@intel.com> writes:
> 
>> On Tue, 2012-05-15 at 15:19 -0400, Jeff Moyer wrote:
>>> Lin Ming <ming.m.lin@intel.com> writes:
>>>
>>>> Add an idle timer that is set to some suitable timeout and would be
>>>> added when the queue first goes empty. If nothing has happened during
>>>> the timeout interval, then the queue is suspended.
>>>>
>>>> Queueing a new request could check the state and resume queue if it is
>>>> supended.
>>>>
>>>
>>> [snip]
>>>
>>>> @@ -1129,6 +1141,13 @@ void __blk_put_request(struct request_queue *q, struct request *req)
>>>>  	if (unlikely(--req->ref_count))
>>>>  		return;
>>>>  
>>>> +	/* PM request is not accounted */
>>>> +	if (!(req->cmd_flags & REQ_PM)) {
>>>> +		if (!(--q->nr_pending))
>>>> +			/* Hard code to 20secs, will move to sysfs */
>>>> +			mod_timer(&q->idle, jiffies + 20*HZ);
>>>> +	}
>>>> +
>>>
>>> I'm pretty sure Jens wanted to avoid doing a mod_timer, here, given that
>>> the queue can transition between empty and non-empty fairly rapidly for
>>> dependent I/O.
>>
>> I'll remove this idle timer and use runtime pm core's timer.
> 
> This issues isn't which timer to use, it's when to modify it.  Since the
> queue can cycle between empty and non-empty very quickly, you should try
> to avoid calling mod_timer for every non-empty to empty transition.
> Jens had described one way to do this in the thread you referenced in
> your 0/3 email.

That's exactly right, thanks Jeff.

Lin, you should have more slack timer handling. Look at the blk-timeout
handling of request timeouts for inspiration, and/or the thread that
Jeff also references. Doing a timer add/del for each request put is a no
go.

-- 
Jens Axboe
