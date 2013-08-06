From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] [SCSI] sg: Fix user memory corruption when SG_IO is interrupted
 by a signal
Date: Tue, 06 Aug 2013 10:56:02 -0400
Message-ID: <52010E82.9050801@interlog.com>
References: <1375740121-23350-1-git-send-email-roland@kernel.org> <CAF2xp_Fwav3ZZCiuQ5738r4p-TMVRBZzHdYgoNg4EfO3_0C+tg@mail.gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:36657 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847Ab3HFO4t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Aug 2013 10:56:49 -0400
In-Reply-To: <CAF2xp_Fwav3ZZCiuQ5738r4p-TMVRBZzHdYgoNg4EfO3_0C+tg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Chang <dpf@google.com>
Cc: Roland Dreier <roland@kernel.org>, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>, Costa Sapuntzakis <costa@purestorage.com>, =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@purestorage.com>, linux-kernel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 13-08-05 11:54 PM, Peter Chang wrote:
> 2013/8/5 Roland Dreier <roland@kernel.org>:
>> From: Roland Dreier <roland@purestorage.com>
>>
>> There is a nasty bug in the SCSI SG_IO ioctl that in some circumstances
>> leads to one process writing data into the address space of some other
>> random unrelated process if the ioctl is interrupted by a signal.
>> What happens is the following:
>>
>>   - A process issues an SG_IO ioctl with direction DXFER_FROM_DEV (ie the
>>     underlying SCSI command will transfer data from the SCSI device to
>>     the buffer provided in the ioctl)
>>
>>   - Before the command finishes, a signal is sent to the process waiting
>>     in the ioctl.  This will end up waking up the sg_ioctl() code:
>>
>>                  result = wait_event_interruptible(sfp->read_wait,
>>                          (srp_done(sfp, srp) || sdp->detached));
>>
>>     but neither srp_done() nor sdp->detached is true, so we end up just
>>     setting srp->orphan and returning to userspace:
>>
>>                  srp->orphan = 1;
>>                  write_unlock_irq(&sfp->rq_list_lock);
>>                  return result;  /* -ERESTARTSYS because signal hit process */
>>
>>     At this point the original process is done with the ioctl and
>>     blithely goes ahead handling the signal, reissuing the ioctl, etc.
>
> i think that an additional issue here is that part of reissuing the
> ioctl is re-queueing the command. since the re-queue is at the front
> of the block queue there are issues if the command is non-idempotent.

Re-issuing a SG_IO ioctl is wrong. More and more SCSI commands (even
in SBC-3) are non-idempotent (e.g. COMPARE AND WRITE). And the st
driver gets to use the block layer as well and many of its important
SCSI commands (SSC) are non-idempotent.

> we have a local fix that gets rid of most of the orphan stuff and
> re-waiting if a non-fatal signal was waiting. simpler than unmapping
> but maybe we're missing some other interesting case?

Like to share that fix with us?

Also I'm interested in how you know from within a kernel driver
whether a signal sent to the controlling process is fatal or
not? For example SIGIO's default action is terminate but sg
assumes if the controlling process requests SIGIO generation
then it will at least override that default action and
handle it sensibly. Is there a way to check that assumption?

Looked at bsg in the situation where a signal interrupts a
SG_IO ioctl. It seems broken; anyone like to comment on this
snippet from bsg if a signal hits the first call:
     blk_execute_rq(bd->queue, NULL, rq, at_head);
     ret = blk_complete_sgv4_hdr_rq(rq, &hdr, bio, bidi_bio);
     if (copy_to_user(uarg, &hdr, sizeof(hdr)))
         return -EFAULT;


As an aside, I got tired of handling signals during SCSI commands
in the ddpt utility, especially after adding tape support. So
it now masks all the usual suspects during the IO then checks
for signals in a small window between IOs. Non maskable signals
will still terminate but of course the user gets no guarantees,
but it would be still reasonable in the termination case that
the interrupted SCSI command was _not_ resubmitted.

Doug Gilbert

