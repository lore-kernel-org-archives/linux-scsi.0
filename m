From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 0/3] Fix USB deadlock caused by SCSI error handling
Date: Mon, 31 Mar 2014 18:29:25 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1403311816400.5031-100000@netrider.rowland.org>
References: <53397DAE.9010801@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:47168 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750987AbaCaW30 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Mar 2014 18:29:26 -0400
In-Reply-To: <53397DAE.9010801@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Mon, 31 Mar 2014, Hannes Reinecke wrote:

> >> Ah. Correct. But that's due to the first patch being incorrect.
> >> Cf my response to the original first patch.
> > 
> > See my response to your response.  :-)
> > 
> Okay, So I probably should refrain from issueing a response to
> your response to my response lest infinite recursion happens :-)

Indeed.

> >>> 	What should happen if some other pathway manages to call
> >>> 	scsi_try_to_abort_cmd() while scmd->abort_work is still
> >>> 	sitting on the work queue?  The command would be aborted
> >>> 	and the flag would be cleared, but the queued work would
> >>> 	remain.  Can this ever happen?
> >>>
> >> Not that I could see.
> >> A command abort is only ever triggered by the request timeout from
> >> the block layer. And the timer is _not_ rearmed once the timeout
> >> function (here: scsi_times_out()) is called.
> >> Hence I fail to see how it can be called concurrently.
> > 
> > scsi_try_to_abort_cmd() is also called (via a different pathway) when a 
> > command sent by the error handler itself times out.  I haven't traced 
> > through all the different paths to make sure none of them can run 
> > concurrently.  But I'm willing to take your word for it.
> > 
> Yes, but that's not calling scsi_abort_command(), but rather invokes
> scsi_abort_eh_cmnd().

Sure.  But either way, we end up in scsi_try_to_abort_cmd(), which
calls the LLDD's abort handler.  Thus leading to the possibility of
aborting the same command more than once.

> >> The original idea was this:
> >>
> >> SCSI_EH_ABORT_SCHEDULED is sticky _per command_.
> >> Point is, any command abort is only ever send for a timed-out
> >> command. And the main problem for a timed-out command is that we
> >> simply _do not_ know what happened for that command. So _if_ a
> >> command timed out, _and_ we've send an abort, _and_ the command
> >> times out _again_ we'll be running into an endless loop between
> >> timeout and aborting, and never returning the command at all.
> >>
> >> So to prevent this we should set a marker on that command telling it
> >> to _not_ try to abort the command again.
> > 
> > I disagree.  We _have_ to abort the command again -- how else can we
> > stop a running command?  To prevent the loop you described, we should
> > avoid _retrying_ the command after it is aborted the second time.
> > 
> The actual question is whether it's worth aborting the same command
> a second time.
> In principle any reset (like LUN reset etc) should clear the
> command, too.
> And the EH abort functionality is geared around this.
> If, for some reason, the transport layer / device driver
> requires a command abort to be send then sure, we need
> to accommodate for that.

As James mentioned, with USB a reset does not abort a running command.  
Instead it waits for the command to finish.  (However, this could be
changed in usb-storage, if required.)

> As said, yes, in principle you are right. We should be aborting the
> command a second time, _and then_ starting the escalation.
> 
> So if the above reasoning is okay then this patch should be doing
> the trick:
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 771c16b..0e72374 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -189,6 +189,7 @@ scsi_abort_command(struct scsi_cmnd *scmd)
>                 /*
>                  * Retry after abort failed, escalate to next level.
>                  */
> +               scmd->eh_eflags &= ~SCSI_EH_ABORT_SCHEDULED;
>                 SCSI_LOG_ERROR_RECOVERY(3,
>                         scmd_printk(KERN_INFO, scmd,
>                                     "scmd %p previous abort
> failed\n", scmd));
> 
> (Beware of line
> breaks)
> 
> Can you test with it?

I don't understand.  This doesn't solve the fundamental problem (namely 
that you escalate before aborting a running command).  All it does is 
clear the SCSI_EH_ABORT_SCHEDULED flag before escalating.

What's needed is something like a 2-bit abort counter.  
scsi_try_to_abort_cmd() should increment the counter each time it runs, 
and if scmd_eh_abort_handler() sees that the counter is too high, it 
should avoid its retry pathway.  _Then_ you can move on to something 
more drastic.

Alan Stern

