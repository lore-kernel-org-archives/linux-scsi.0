From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: fc_remote_port_delete and returning SCSI commands from LLD
Date: Fri, 23 Oct 2009 09:47:47 +0200
Message-ID: <20091023074746.GB5930@schmichrtp.de.ibm.com>
References: <20091020144027.GA17717@schmichrtp.de.ibm.com> <4ADF35BF.8050100@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.17.165]:40209 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbZJWHro (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Oct 2009 03:47:44 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate5.de.ibm.com (8.13.1/8.13.1) with ESMTP id n9N7lm7B007471
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2009 07:47:48 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9N7lmU13309608
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2009 09:47:48 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n9N7lm2O008264
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2009 09:47:48 +0200
Content-Disposition: inline
In-Reply-To: <4ADF35BF.8050100@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Oct 21, 2009 at 12:24:31PM -0400, James Smart wrote:
> Christof Schmitt wrote:
>> I am looking again at how and when a FC LLD should call
>> fc_remote_port_delete. Some help would be welcome to cover all
>> requirements and to plug the holes...
>
> It's pretty simple, as far as the FC transport is concerned.
> Call fc_remote_port_add() once connectivity is established.
> Call fc_remote_port_delete() once connectivity is lost.
> It is expected that there is a clear add->delete->add->delete->... sequence.
>
> Timing is considered "immediate", but there's always a window of delay.
>
> In general, the Transport ignores what happens to outstanding i/o, 
> letting the LLDD do something based on its policy, or let natural i/o 
> timers or the fast fail timer to fire.  The transport, at the delete 
> call, will start the fast fail timer if it is set.

Understood.

>> One scenario i am looking at: The connection to the HBA has been
>> temporarily lost and the LLD has to return all pending I/O requests to
>> the upper layers, so they can be retried later. Now with the SCSI
>> device being part of a multipath device, the first failed I/O request
>> triggers path failover:
>
> You are now asking a different question - how to make the upper layers play
> nice with the different responses from queuecommand, the LLDD's 
> interaction with the transport and midlayer, etc.
>
>>
>> multipath_end_io
>> do_end_io
>> fail_path
>> queue_work(kmultipathd, &pgpath->deactivate_path);
>>
>> which then marks the following returned requests as timed out:
>>
>> deactivate_path
>> blk_abort_queue
>> blk_abort_request
>> blk_rq_timed_out
>> scsi_times_out
>> fc_timed_out
>>
>> If the remote_port status is not BLOCKED, this will trigger the SCSI
>> midlayer error handling which cannot do much during the interruption
>> to the hardware and will mark the SCSI devices 'offline'.
>
> Well - this isn't absolute, but is pretty much true. We expect, when  
> connectivity is lost, for the block state to be temporarily entered. The  
> blocked state holds off further i/o and the eh handler as well, to 
> postpone the normal i/o failure cases which do lead to offline conditions 
> in most scenarios.
>
> But - this process is a coordinated effort between the driver and the 
> upper layers, and where the driver doesn't get helped by the transport 
> (the blocked state) it had better mimic the return codes at the different 
> points, and perhaps more, so that bad things don't happen.

"mimic the return codes" refers to fc_remote_port_chkready? Like
returning DID_IMM_RETRY when the rport is going to be BLOCKED, but
fc_remote_port_delete did not run yet?

>> In order to
>> prevent this, the rule would be: First call fc_remote_port_delete to
>> set the remote port (or in the case of an HBA interruption all remote
>> ports) to BLOCKED, and only after this step call scsi_done to pass the
>> SCSI commands back to the upper layers.
>
> True, although as mentioned, i/o termination is considered independent 
> from the rport/transport. But, you're best off if the target is blocked 
> due to the rport delete as we've prepped the upper layers to behave best 
> with this behavior.
>
> There will always be a few i/o's that sneak in or complete (timeout ?) in 
> between when the LLDD detects connectivity loss and when the  
> fc_remote_port_delete has been called. It's up to the LLDD to handle this 
> window.
>
> Completions, including i/o timeouts, are typically not a big deal and 
> should just return via scsi_done as they normally would. The caveat is 
> when those i/o's are from the eh thread.  Granted - if you are actively 
> aborting/failing i/o at the connectivity loss, and doing so before the 
> block is in place, you're causing more headaches for yourself in getting 
> the upper layers to play right with the LLDD - with the recommendation 
> being "don't do that".
>
> New i/o needs to be caught in queuecommand with the LLDD emulating the  
> transport status that would normally get returned.  E.g. the call to  
> fc_remote_port_chkready() won't catch it as the fc_remote_port_delete() 
> call hasn't completed yet - so the LLDD needs a 2nd check against it's 
> own structures, and if it detects the state, it should fail the i/o with 
> the same codes that chkready would. In reality, if you wanted to accept 
> the command, but never issue it and just leave it outstanding - waiting 
> for i/o timeout, or fast fail i/o timout, or devloss_tmo, I guess you 
> could.
>
>
>> This means, if the HBA problem is detected in interrupt context,
>> fc_remote_port_delete has to be called before calling scsi_done.
>
> Well - execution context is somewhat unrelated, as it depends on how the 
> LLDD is implemented, and what else its doing when connectivity is lost.
>
>>
>> But the description for fc_remote_port_delete states:
>>
>>  * Called from normal process context only - cannot be called from
>>  * interrupt.
>>  *
>>  * Notes:
>>  *	This routine assumes no locks are held on entry.
>>  */
>>
>> Looking at the functions called from fc_remote_port_delete, i don't
>> see a problem in calling fc_remote_port_delete from interrupt context
>> or with locks held. Does this mean the description should be fixed or
>> am i missing something?
>
> That's probably true. underlying routines have changed a bit over time 
> and it may be better now. I'd still hesitate with 
> fc_tgt_it_nexus_destroy() (although it shouldn't be applicable to you), 
> and scsi_target_block().  Creating additional lock hierachies between 
> LLDD locks and the locks in these paths (which the LLDD rarely sees/knows 
> about) isn't good.   Thus, we've mostly pushed LLDDs to use a pristine 
> context when calling the transport (such as a workq context) so that we 
> can disassociate low-level LLDD design from midlayer design.
>
>
>> fc_remote_port_add on the other hand can wait during flushes and has
>> to be called from process context. To summarize:
>> - A LLD has to call fc_remote_port_delete before returning SCSI
>>   commands from a failed port or failed HBA.
>
> not true, but best behavior.
>
>> - fc_remote_port_delete can be called from interrupt context before
>>   calling scsi_done if necessary
>
> part a (called from interrupt context) - do so at your own risk.  These 
> other paths can change at any time and its not fair for those developers 
> to know your driver dependencies.
>
> part b (before calling scsi_done) - recommended approach.
>
>> - fc_remote_port_add has to be called from process context
>
> True.
>
>> - The LLD has to serialize the fc_remote_port_add and
>>   fc_remote_port_delete calls to guarantee the add->delete->...
>>   sequence.
>
> True.

And, at least in zfcp, the notification from the hardware about I/O
completion to the call to scsi_done runs in softirq context. Calling
fc_remote_port_delete from this context is no good thing as you
mentioned and i don't see a good way to synchronize the
fc_remote_port_add/delete calls when going this way.

So far i see two possible solutions:

1) When the error is detected in softirq context, do not call
   scsi_done. Defer this call to the error handling thread/workqueue
   that will first call fc_remote_port_delete and then return all
   affected SCSI commands.

2) Have an LLD internal flag indicating "transitioning to rport
   blocked state", check for this in queuecommand and return
   DID_IMM_RETRY as fc_remote_port_chkready does. As soon as
   fc_remote_port_delete has been called, fc_remote_port_chkready will
   do the right thing.

It looks to me that 2) might be a short-term solution while 1) looks
like a proper way of handling interruptions on the host level in the
long term.

Anyway, thanks for the input.

I am tempted to summarize this for scsi_fc_transport.txt to have the
important requirements in one place. But this depends on the available
time, so no promises.

Christof
