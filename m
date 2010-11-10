From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [dm-devel] block_abort_queue (blk_abort_request) racing with
 scsi_request_fn
Date: Wed, 10 Nov 2010 01:30:00 -0600
Message-ID: <4CDA49F8.9050406@cs.wisc.edu>
References: <20100512052336.GB15240@linux.vnet.ibm.com> <4CDA4524.4010204@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49868 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224Ab0KJHWn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2010 02:22:43 -0500
In-Reply-To: <4CDA4524.4010204@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

On 11/10/2010 01:09 AM, Mike Christie wrote:
> On 05/12/2010 12:23 AM, Mike Anderson wrote:
>> I was looking at a dump from a weekend run and I believe I am seeing a
>> case where blk_abort_request through blk_abort_queue picked up a request
>> for timeout that scsi_request_fn decided not to start. This test was
>> under
>> error injection.
>>
>> I assume the case in scsi_request_fn this is hitting is that a request
>> has
>> been put on the timeout_list with blk_start_request and then one of the
>> not_ready checks is hit and the request is decided not to be started. I
>> believe the drop
>>
>> It appears that my usage of walking the timeout_list in block_abort_queue
>> and using blk_mark_rq_complete in block_abort_request will not work in
>> this case.
>>
>> While it would be good to have way to ensure a command is started, it is
>> unclear if even at a low timeout of 1 second that a user other than
>> blk_abort_queue would hit this race.
>>
>> The dropping / acquiring of host_lock and queue_lock in scsi_request_fn
>> and scsi_dispatch_cmd make it unclear to me if usage of
>> blk_mark_rq_complete will cover all cases.
>>
>> I looked at checking serial_number in scsi_times_out along with a couple
>> blk_mark_rq_complete additions, but unclear if this would be good and
>> / or
>> work in all cases.
>>
>> I looked at just accelerating deadline by some default value but unclear
>> if that would be acceptable.
>>
>> I also looked at just using just the mark interface I previously posted
>> and not calling blk_abort_request at all, but that would change current
>> behavior that has been in use for a while.
>>
>
> Did you ever solve this? I am hitting this with the dm-multipath
> blk_abort_queue case (the email I sent you a couple weeks ago).
>
> It seems we could fix this by just having blk_requeue_request do a check
> for if the request timedout similar to what scsi used to do. A hacky way
> might be to have 2 requeue functions.
>
> blk_requeue_completed_request - This is the blk_requeue_request we have
> today. It unconditionally requeues the request. It should only be used
> if the command has been completed either from blk_complete_request or
> from block layer timeout handling
> (blk_rq_timed_out_timer->blk_rq_timed_out->rq_timed_out_fn).
>
> blk_requeue_running_request - This checks if the timer is running before
> requeueing the request. If blk_rq_timed_out_timer/blk_rq_timed_out has
> taken over the request and is going to handle it then this function just
> returns and does not requeue. So for this we could just have it check if
> the queue has a rq_timed_out_fn and if rq->timeout_list is empty or not.
>
> I think this might be confusing to use, so I tried something slightly
> different below.
>
>
> I also tried a patch where we just add another req bit. We set it in
> blk_rq_timed_out_timer and clear it in a new function that clears it
> then calls blk_requeue_reqeust. The new function:
>
> blk_requeue_timedout_request - used when request is to be requeued if a
> LLD q->rq_timed_out_fn returned BLK_EH_NOT_HANDLED and has resolved the
> problem and wants the request to be requeued. This function clears
> REQ_ATOM_TIMEDOUT and then calls blk_requeue_request.
>
> blk_reqeuue_request would then check if REQ_ATOM_TIMEDOUT is set and if
> it was just drop the request assuming the rq_timed_out_fn was handling
> it. This still requires the caller to know how the command is supposed
> to be reqeueud. But I think it might be easier since the driver here has
> returned BLK_EH_NOT_HANDLED in the q timeout fn so they know that they
> are going to be handling the request in a special way.
>
> I attached the last idea here. Made over Linus's tree. Only compile tested.
>

Oops, nevermind. I think this is trying to solve a slightly different 
problem. I saw your other mail. My patch will not handle the case where:

1. cmd is in scsi_reqeust_fn has run blk_start_request and dropped the 
queue_lock. Has not yet taken the host lock and incremented host busy 
counters.
2. blk_abort_queue runs q->rq_timed_out_fn and adds cmd to host eh list.
3. Somehow scsi eh runs and is finishing its stuff before #1 has done 
anything, so the cmd was just processed by scsi eh *and* at the same 
time is still lingering in scsi_request_fn (somehow #1 has still not 
taken the host lock).

scsi eh is then does 
scsi_eh_flush_done_q->scsi_queue_insert->blk_requeue_request on the 
request while request is also in scsi_request_fn processing.

So now we hit some bug ons in the blk code. The cmd from #1 then finally 
grabs the host lock but it is too late.
