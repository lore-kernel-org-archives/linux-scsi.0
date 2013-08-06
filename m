From: Peter Chang <dpf@google.com>
Subject: Re: [PATCH] [SCSI] sg: Fix user memory corruption when SG_IO is
 interrupted by a signal
Date: Mon, 5 Aug 2013 20:54:48 -0700
Message-ID: <CAF2xp_Fwav3ZZCiuQ5738r4p-TMVRBZzHdYgoNg4EfO3_0C+tg@mail.gmail.com>
References: <1375740121-23350-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1375740121-23350-1-git-send-email-roland@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Doug Gilbert <dgilbert@interlog.com>, James Bottomley <JBottomley@parallels.com>, Costa Sapuntzakis <costa@purestorage.com>, =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@purestorage.com>, linux-kernel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

2013/8/5 Roland Dreier <roland@kernel.org>:
> From: Roland Dreier <roland@purestorage.com>
>
> There is a nasty bug in the SCSI SG_IO ioctl that in some circumstances
> leads to one process writing data into the address space of some other
> random unrelated process if the ioctl is interrupted by a signal.
> What happens is the following:
>
>  - A process issues an SG_IO ioctl with direction DXFER_FROM_DEV (ie the
>    underlying SCSI command will transfer data from the SCSI device to
>    the buffer provided in the ioctl)
>
>  - Before the command finishes, a signal is sent to the process waiting
>    in the ioctl.  This will end up waking up the sg_ioctl() code:
>
>                 result = wait_event_interruptible(sfp->read_wait,
>                         (srp_done(sfp, srp) || sdp->detached));
>
>    but neither srp_done() nor sdp->detached is true, so we end up just
>    setting srp->orphan and returning to userspace:
>
>                 srp->orphan = 1;
>                 write_unlock_irq(&sfp->rq_list_lock);
>                 return result;  /* -ERESTARTSYS because signal hit process */
>
>    At this point the original process is done with the ioctl and
>    blithely goes ahead handling the signal, reissuing the ioctl, etc.

i think that an additional issue here is that part of reissuing the
ioctl is re-queueing the command. since the re-queue is at the front
of the block queue there are issues if the command is non-idempotent.

we have a local fix that gets rid of most of the orphan stuff and
re-waiting if a non-fatal signal was waiting. simpler than unmapping
but maybe we're missing some other interesting case?

\p
