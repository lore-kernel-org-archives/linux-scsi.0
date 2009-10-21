From: James Smart <James.Smart@Emulex.Com>
Subject: Re: fc_remote_port_delete and returning SCSI commands from LLD
Date: Wed, 21 Oct 2009 12:24:31 -0400
Message-ID: <4ADF35BF.8050100@emulex.com>
References: <20091020144027.GA17717@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:39169 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417AbZJUQYa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2009 12:24:30 -0400
In-Reply-To: <20091020144027.GA17717@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



Christof Schmitt wrote:
> I am looking again at how and when a FC LLD should call
> fc_remote_port_delete. Some help would be welcome to cover all
> requirements and to plug the holes...

It's pretty simple, as far as the FC transport is concerned.
Call fc_remote_port_add() once connectivity is established.
Call fc_remote_port_delete() once connectivity is lost.
It is expected that there is a clear add->delete->add->delete->... sequence.

Timing is considered "immediate", but there's always a window of delay.

In general, the Transport ignores what happens to outstanding i/o, letting the 
LLDD do something based on its policy, or let natural i/o timers or the fast 
fail timer to fire.  The transport, at the delete call, will start the fast 
fail timer if it is set.


> One scenario i am looking at: The connection to the HBA has been
> temporarily lost and the LLD has to return all pending I/O requests to
> the upper layers, so they can be retried later. Now with the SCSI
> device being part of a multipath device, the first failed I/O request
> triggers path failover:

You are now asking a different question - how to make the upper layers play
nice with the different responses from queuecommand, the LLDD's interaction 
with the transport and midlayer, etc.

> 
> multipath_end_io
> do_end_io
> fail_path
> queue_work(kmultipathd, &pgpath->deactivate_path);
> 
> which then marks the following returned requests as timed out:
> 
> deactivate_path
> blk_abort_queue
> blk_abort_request
> blk_rq_timed_out
> scsi_times_out
> fc_timed_out
> 
> If the remote_port status is not BLOCKED, this will trigger the SCSI
> midlayer error handling which cannot do much during the interruption
> to the hardware and will mark the SCSI devices 'offline'.

Well - this isn't absolute, but is pretty much true. We expect, when 
connectivity is lost, for the block state to be temporarily entered. The 
blocked state holds off further i/o and the eh handler as well, to postpone 
the normal i/o failure cases which do lead to offline conditions in most 
scenarios.

But - this process is a coordinated effort between the driver and the upper 
layers, and where the driver doesn't get helped by the transport (the blocked 
state) it had better mimic the return codes at the different points, and 
perhaps more, so that bad things don't happen.


> In order to
> prevent this, the rule would be: First call fc_remote_port_delete to
> set the remote port (or in the case of an HBA interruption all remote
> ports) to BLOCKED, and only after this step call scsi_done to pass the
> SCSI commands back to the upper layers.

True, although as mentioned, i/o termination is considered independent from 
the rport/transport. But, you're best off if the target is blocked due to the 
rport delete as we've prepped the upper layers to behave best with this behavior.

There will always be a few i/o's that sneak in or complete (timeout ?) in 
between when the LLDD detects connectivity loss and when the 
fc_remote_port_delete has been called. It's up to the LLDD to handle this window.

Completions, including i/o timeouts, are typically not a big deal and should 
just return via scsi_done as they normally would. The caveat is when those 
i/o's are from the eh thread.  Granted - if you are actively aborting/failing 
i/o at the connectivity loss, and doing so before the block is in place, 
you're causing more headaches for yourself in getting the upper layers to play 
right with the LLDD - with the recommendation being "don't do that".

New i/o needs to be caught in queuecommand with the LLDD emulating the 
transport status that would normally get returned.  E.g. the call to 
fc_remote_port_chkready() won't catch it as the fc_remote_port_delete() call 
hasn't completed yet - so the LLDD needs a 2nd check against it's own 
structures, and if it detects the state, it should fail the i/o with the same 
codes that chkready would. In reality, if you wanted to accept the command, 
but never issue it and just leave it outstanding - waiting for i/o timeout, or 
fast fail i/o timout, or devloss_tmo, I guess you could.


> This means, if the HBA problem is detected in interrupt context,
> fc_remote_port_delete has to be called before calling scsi_done.

Well - execution context is somewhat unrelated, as it depends on how the LLDD 
is implemented, and what else its doing when connectivity is lost.

> 
> But the description for fc_remote_port_delete states:
> 
>  * Called from normal process context only - cannot be called from
>  * interrupt.
>  *
>  * Notes:
>  *	This routine assumes no locks are held on entry.
>  */
> 
> Looking at the functions called from fc_remote_port_delete, i don't
> see a problem in calling fc_remote_port_delete from interrupt context
> or with locks held. Does this mean the description should be fixed or
> am i missing something?

That's probably true. underlying routines have changed a bit over time and it 
may be better now. I'd still hesitate with fc_tgt_it_nexus_destroy() (although 
it shouldn't be applicable to you), and scsi_target_block().  Creating 
additional lock hierachies between LLDD locks and the locks in these paths 
(which the LLDD rarely sees/knows about) isn't good.   Thus, we've mostly 
pushed LLDDs to use a pristine context when calling the transport (such as a 
workq context) so that we can disassociate low-level LLDD design from midlayer 
design.


> fc_remote_port_add on the other hand can wait during flushes and has
> to be called from process context. To summarize:
> - A LLD has to call fc_remote_port_delete before returning SCSI
>   commands from a failed port or failed HBA.

not true, but best behavior.

> - fc_remote_port_delete can be called from interrupt context before
>   calling scsi_done if necessary

part a (called from interrupt context) - do so at your own risk.  These other 
paths can change at any time and its not fair for those developers to know 
your driver dependencies.

part b (before calling scsi_done) - recommended approach.

> - fc_remote_port_add has to be called from process context

True.

> - The LLD has to serialize the fc_remote_port_add and
>   fc_remote_port_delete calls to guarantee the add->delete->...
>   sequence.

True.

-- james s


> 
> --
> Christof
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

