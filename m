From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [dm-devel] block_abort_queue (blk_abort_request) racing with
 scsi_request_fn
Date: Wed, 10 Nov 2010 15:16:26 -0600
Message-ID: <4CDB0BAA.8060801@cs.wisc.edu>
References: <20100512052336.GB15240@linux.vnet.ibm.com> <4CDA4524.4010204@cs.wisc.edu> <4CDA49F8.9050406@cs.wisc.edu> <20101110163047.GA26201@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42233 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756827Ab0KJVJZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2010 16:09:25 -0500
In-Reply-To: <20101110163047.GA26201@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

On 11/10/2010 10:30 AM, Mike Anderson wrote:
> Mike Christie<michaelc@cs.wisc.edu>  wrote:
>> On 11/10/2010 01:09 AM, Mike Christie wrote:
>>> On 05/12/2010 12:23 AM, Mike Anderson wrote:
>>>> I was looking at a dump from a weekend run and I believe I am seeing a
>>>> case where blk_abort_request through blk_abort_queue picked up a request
>>>> for timeout that scsi_request_fn decided not to start. This test was
>>>> under
>>>> error injection.
>>>>
>>>> I assume the case in scsi_request_fn this is hitting is that a request
>>>> has
>>>> been put on the timeout_list with blk_start_request and then one of the
>>>> not_ready checks is hit and the request is decided not to be started. I
>>>> believe the drop
>>>>
>>>> It appears that my usage of walking the timeout_list in block_abort_queue
>>>> and using blk_mark_rq_complete in block_abort_request will not work in
>>>> this case.
>>>>
>>>> While it would be good to have way to ensure a command is started, it is
>>>> unclear if even at a low timeout of 1 second that a user other than
>>>> blk_abort_queue would hit this race.
>>>>
>>>> The dropping / acquiring of host_lock and queue_lock in scsi_request_fn
>>>> and scsi_dispatch_cmd make it unclear to me if usage of
>>>> blk_mark_rq_complete will cover all cases.
>>>>
>>>> I looked at checking serial_number in scsi_times_out along with a couple
>>>> blk_mark_rq_complete additions, but unclear if this would be good and
>>>> / or
>>>> work in all cases.
>>>>
>>>> I looked at just accelerating deadline by some default value but unclear
>>>> if that would be acceptable.
>>>>
>>>> I also looked at just using just the mark interface I previously posted
>>>> and not calling blk_abort_request at all, but that would change current
>>>> behavior that has been in use for a while.
>>>>
>>>
>>> Did you ever solve this? I am hitting this with the dm-multipath
>>> blk_abort_queue case (the email I sent you a couple weeks ago).
>>>
>
> No. I am also not seeing it in my recent error injection testing.
>
> Is your test configuration / error injection testing able to reproduce
> fairly reliably. If so can you provide some general details on how you
> are generating this error.

In one test we just run dm-mutlipath over FC with the default timeouts, 
then disable the target controller. This leads to IO timing out and the 
scsi eh running. We then bring the controller back up and depending on 
timing that then can lead to either the scsi eh failing and IO being 
failed upwards or the scsi eh succeeding and IO retried.

Also a really easy way, but probably unrealistic, to hit something 
similar (more like what you hit in your 1 second timeout case in the 
other mail) is if you just set the queue timeout to 0, the queue_depth 
lower than the number of commands you are sending and let the IO test 
run on the scsi disk. This sort of replicates the problem because the 
request timesout while it is in the scsi_request_fn similar to how the 
blk_abort_queue can be called on the cmd while is in there.


>
>>> It seems we could fix this by just having blk_requeue_request do a check
>>> for if the request timedout similar to what scsi used to do. A hacky way
>>> might be to have 2 requeue functions.
>>>
>>> blk_requeue_completed_request - This is the blk_requeue_request we have
>>> today. It unconditionally requeues the request. It should only be used
>>> if the command has been completed either from blk_complete_request or
>> >from block layer timeout handling
>>> (blk_rq_timed_out_timer->blk_rq_timed_out->rq_timed_out_fn).
>>>
>>> blk_requeue_running_request - This checks if the timer is running before
>>> requeueing the request. If blk_rq_timed_out_timer/blk_rq_timed_out has
>>> taken over the request and is going to handle it then this function just
>>> returns and does not requeue. So for this we could just have it check if
>>> the queue has a rq_timed_out_fn and if rq->timeout_list is empty or not.
>>>
>>> I think this might be confusing to use, so I tried something slightly
>>> different below.
>>>
>>>
>>> I also tried a patch where we just add another req bit. We set it in
>>> blk_rq_timed_out_timer and clear it in a new function that clears it
>>> then calls blk_requeue_reqeust. The new function:
>>>
>>> blk_requeue_timedout_request - used when request is to be requeued if a
>>> LLD q->rq_timed_out_fn returned BLK_EH_NOT_HANDLED and has resolved the
>>> problem and wants the request to be requeued. This function clears
>>> REQ_ATOM_TIMEDOUT and then calls blk_requeue_request.
>>>
>>> blk_reqeuue_request would then check if REQ_ATOM_TIMEDOUT is set and if
>>> it was just drop the request assuming the rq_timed_out_fn was handling
>>> it. This still requires the caller to know how the command is supposed
>>> to be reqeueud. But I think it might be easier since the driver here has
>>> returned BLK_EH_NOT_HANDLED in the q timeout fn so they know that they
>>> are going to be handling the request in a special way.
>>>
>>> I attached the last idea here. Made over Linus's tree. Only compile tested.
>>>
>>
>> Oops, nevermind. I think this is trying to solve a slightly
>> different problem. I saw your other mail. My patch will not handle
>> the case where:
>>
>> 1. cmd is in scsi_reqeust_fn has run blk_start_request and dropped
>> the queue_lock. Has not yet taken the host lock and incremented host
>> busy counters.
>> 2. blk_abort_queue runs q->rq_timed_out_fn and adds cmd to host eh list.
>> 3. Somehow scsi eh runs and is finishing its stuff before #1 has
>> done anything, so the cmd was just processed by scsi eh *and* at the
>> same time is still lingering in scsi_request_fn (somehow #1 has
>> still not taken the host lock).
>>
>
> While #1 could also return with a busy from queuecommand which will call
> scsi_queue_insert with no check for complete. One could add a
> blk_mark_rq_complete check prior to calling scsi_queue_insert. This does
> not cover the not_ready label case in scsi_request_fn.
>

Yeah, I was trying to not to have to add blk_mark_rq_complete checks in 
the scsi layer and just have the block layer handle it. I think my patch 
in the previous mail covers both the scsi_request_fn and 
scsi_dispatch_cmd/queuecommand cases. The patch should work as long as 
the scsi eh has not already completed and run blk_requeue_request on it. 
The problem with my patch is only that case above where the cmd gets 
blk_abort_queued/timedout run on it and the scsi eh somehow is able to 
complete and run scsi_queue_insert while scsi_request_fn is still trying 
to process the request.

This could be solved by just having the scsi eh thread flush the queue 
before running. This would make sure the cmd is not running in 
scsi_request_fn while the scsi the scsi is also processing it. We sort 
of do this today with the host_busy checks in scsi_error_handler. The 
problem is that window from the time scsi_request_fn drops the 
queue_lock and grabs the host_lock to increment host_busy. In the 
window, blk_abort_request can run, the scsi_eh thread can see host_busy 
== host_failed, start the scsi eh, run to completion and hit the problem 
I described above.




> Another option might be to make blk_abort less aggressive if we cannot
> close all the paths and switch it to more of a drain model, but then we
> may be in the same boat in selecting how fast we can drain based what we
> perceive to be a safe time value. This option leaves the existing races
> open in the scsi_request_fn / scsi_dispatch_cmd.
>
> -andmike
> --
> Michael Anderson
> andmike@linux.vnet.ibm.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

