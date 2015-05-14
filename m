From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: blk_requeue_request BUG_ON
Date: Wed, 13 May 2015 17:34:50 -0700
Message-ID: <1431563690.2363.64.camel@HansenPartnership.com>
References: <5553D61A.9080502@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43245 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934478AbbENAex (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2015 20:34:53 -0400
In-Reply-To: <5553D61A.9080502@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, lnx1138@linux.vnet.ibm.com

On Wed, 2015-05-13 at 17:54 -0500, Brian King wrote:
> I've been chasing a BUG_ON in blk_requeue_request which seems to occur
> in scenarios where we are seeing lots of SCSI aborts. As I've been digging
> through the completion paths and abort paths, I've noticed if the following
> sequence occurs, we are likely to hit this issue:
> 
> 1. scsi_cmd times out, async abort issued
> 2. LLDD aborts command, LLDD calls scsi_done for the aborted command from interrupt handler
>    when aborted command comes back
> 3. If result of the aborted command is something like DID_ERROR and we allow retries,
>    then in scsi_done processing, we'll call scsi_queue_insert which then calls blk_requeue_request
> 4. Returning from the LLDD's eh_abort handler, scsi_error sees the abort was successful,
>    and then calls scsi_queue_insert for the aborted command, which also calls blk_requeue_request
>    where we hit the BUG_ON because the command has been queued again.
> 
> This is occurring for the non blk_rq_tagged case, for reference, so blk_requeue_request
> doesn't call blk_queue_end_tag which might cause this to not be hit...
> 
> Should a LLDD NOT call scsi_done for commands it aborts? We've seen the issue above on
> both ibmvfc and mpt2sas, but I know there are other LLDDs that call scsi_done in this case,
> but just do it before eh_abort returns. Or is it expected the LLDD will only ever return DID_ABORT
> on the aborted command, which looks like it might prevent this issue as well, however, that seems
> racy and then we'd also need to add some memory barriers around the checking / setting of scmd->eh_eflags
> I would think.
> 
> Or am I missing something and headed down the wrong path?

This is happening because the new abort handler isn't seen by the block
layer as complete (meaning it ignores duplicate completion).

The principle we've always operated under is that LLDs may if they wish
complete commands under error handling.  However, all we do is throw
away the completion because we don't care about the status (we believe
the command needs to be retried as a result of the eh).

There are two options that I can see for restoring the behaviour.  One
is to tell the block layer that it needs to treat this command as
completed (so export blk_mark_rq_complete).  The other would be to add a
check to scsi_done() for SCSI_EH_ABORT_SCHEDULED and simply return if it
is set.  I lean towards the former but don't like exporting the private
interface.

I think the real solution would be to move the actual queueing interface
for our running aborts up to block, so it could be aware of what's going
on (so block handles the internals without having to export any
interfaces).  Plus it makes the running abort available to anything else
which might want to use it.

James


