From: Rajat Jain <rajatja@google.com>
Subject: Re: blk_requeue_request BUG_ON
Date: Wed, 13 May 2015 17:07:14 -0700
Message-ID: <CACK8Z6GJoxp0JBaE+gTNtWs7uvQwd3iYRHZ3qQb-Edk5Ew3WUA@mail.gmail.com>
References: <5553D61A.9080502@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:35455 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbbENAHO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2015 20:07:14 -0400
Received: by igbyr2 with SMTP id yr2so153812618igb.0
        for <linux-scsi@vger.kernel.org>; Wed, 13 May 2015 17:07:14 -0700 (PDT)
In-Reply-To: <5553D61A.9080502@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, lnx1138@linux.vnet.ibm.com

Hello,

On Wed, May 13, 2015 at 3:54 PM, Brian King <brking@linux.vnet.ibm.com> wrote:
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
> Should a LLDD NOT call scsi_done for commands it aborts?

I think the right statement would be that the LLDD should not call
scsi_done() AFTER the eh_abort_handler() has returned SUCCESS, because
once SUCCESS is returned from the eh_abort_handler, the expectation is
that the LLDD and the HW has completely forgotten about that command
(and hence would not call scsi_done()). Also, from the time the
eh_abort_handler returns, the mid level is free to do what it pleases
with that scsi_cmnd (requeue it or free it or finish it) - thus LLDD
cannot be holding a pointer to scsi_cmnd anymore as it could be
pointing elsewhere than what LLD thinks.

Thanks,

Rajat

> We've seen the issue above on
> both ibmvfc and mpt2sas, but I know there are other LLDDs that call scsi_done in this case,
> but just do it before eh_abort returns. Or is it expected the LLDD will only ever return DID_ABORT
> on the aborted command, which looks like it might prevent this issue as well, however, that seems
> racy and then we'd also need to add some memory barriers around the checking / setting of scmd->eh_eflags
> I would think.
>
> Or am I missing something and headed down the wrong path?
>
> Thanks,
>
> Brian
>
> --
> Brian King
> Power Linux I/O
> IBM Linux Technology Center
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
