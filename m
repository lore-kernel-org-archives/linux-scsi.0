From: scameron@beardog.cce.hp.com
Subject: Question about scsi error handling and LLD
Date: Tue, 19 Aug 2014 10:30:51 -0500
Message-ID: <20140819153051.GG19666@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:46580 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaHSPbp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Aug 2014 11:31:45 -0400
Received: from g9t2301.houston.hp.com (g9t2301.houston.hp.com [16.216.185.78])
	by g4t3426.houston.hp.com (Postfix) with ESMTP id 54243175
	for <linux-scsi@vger.kernel.org>; Tue, 19 Aug 2014 15:31:44 +0000 (UTC)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: scameron@beardog.cce.hp.com, elliott@hp.com



Is it permitted for a LLD to call scsi_done() for a command which
has been or is attempting to be aborted via the LLD abort error handler
function?

I am looking at the scsi mid layer code, and I'm a bit confused.

There seem to be a few ways the LLD abort handler function can
get called.

One path:

scsi_times_out() calls scsi_abort_command() which queues
cmd->abort_work in 10ms.  This will cause scmd_eh_abort_handler()
to be called, which can call scsi_try_to_abort_cmd() which
calls the LLD abort error handler function.  If the LLD abort
error handler function returns SUCCESS, then scmd_eh_abort_handler()
may requeue the command via scsi_queue_insert() re-using the same
scsi_cmnd pointer.  Or, it may call scsi_finish_cmnd() on that
scsi_cmnd.

Both of those actions, requeueing the same scsi command, or calling
scsi_finish_cmnd(), seem incompatible with the LLD also having
called scsi_done() on the command.

I think, scsi_done eventually frees the scsi_cmnd...

scsi_done() -> blk_complete_request -> __blk_complete_request ->
	-> raise_softirq_irqoff	-> ??? -> scsi_softirq_done() ->
	-> scsi_finish_cmnd() -> scsi_io_completion -> scsi_end_request()
	-> scsi_mq_uninit_cmd() ... etc.

It seems like either calling scsi_finish_cmnd() too many times (once via
LLD calling scsi_done, and once via scmd_eh_abort_handler calling
scsi_finish_cmnd()), or calling scsi_done() via LLD concurrently with
re-using that same scsi command (via scmd_eh_abort_handler calling
scsi_queue_insert()) would both be bad things.  Correct?

So, without completely understanding it, it seems like if the LLD
abort handler is going to return SUCCESS, it must be sure that it
hasn't already called scsi_done() on the command.  Or to put it
another way, the LLD must make sure there is not a race between
the abort handler and the interrupt handler, and the instant
the LLD abort handler is called for a command, calling scsi_done()
for that command is no longer an option for the LLD.  But, I do
not see how to synchronize that.

I hope I'm missing something here, because I am having a hard time
seeing how to eliminate the race between the LLD abort handler and
command completion in the LLD, esp. since now (due to my hardware's
specific weirdness) I may in the interrupt handler requeue the command
internally in a workqueue within the LLD for submission to HW a 2nd
time before completion back to the mid layer under some circumstances
(e.g. fast path failed, try slower but more robust RAID stack path.)

But, then there is this comment attached to scsi_times_out() which
makes me feel better:

 * Notes:
 *     We do not need to lock this.  There is the potential for a race
 *     only in that the normal completion handling might run, but if the
 *     normal completion function determines that the timer has already
 *     fired, then it mustn't do anything.
 */

So, perhaps that is the answer I'm looking for.  If the comment is
correct and my understanding of it is correct, then the LLD *is* free
to call scsi_done() even though it races with the LLD abort handler?

I'm not finding the code that implements what that comment claims though.
Is it in the block layer code?

-- steve


