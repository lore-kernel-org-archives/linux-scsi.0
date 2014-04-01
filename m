From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH 0/3] Fix USB deadlock caused by SCSI error handling
Date: Tue, 1 Apr 2014 17:28:48 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1404011718350.7652-100000@netrider.rowland.org>
References: <533ADD26.1030300@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <533ADD26.1030300-l3A5Bk7waGM@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 1 Apr 2014, Hannes Reinecke wrote:

> >> So if the above reasoning is okay then this patch should be doing
> >> the trick:
> >>
> >> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> >> index 771c16b..0e72374 100644
> >> --- a/drivers/scsi/scsi_error.c
> >> +++ b/drivers/scsi/scsi_error.c
> >> @@ -189,6 +189,7 @@ scsi_abort_command(struct scsi_cmnd *scmd)
> >>                 /*
> >>                  * Retry after abort failed, escalate to next level.
> >>                  */
> >> +               scmd->eh_eflags &= ~SCSI_EH_ABORT_SCHEDULED;
> >>                 SCSI_LOG_ERROR_RECOVERY(3,
> >>                         scmd_printk(KERN_INFO, scmd,
> >>                                     "scmd %p previous abort
> >> failed\n", scmd));
> >>
> >> (Beware of line
> >> breaks)
> >>
> >> Can you test with it?
> > 
> > I don't understand.  This doesn't solve the fundamental problem (namely 
> > that you escalate before aborting a running command).  All it does is 
> > clear the SCSI_EH_ABORT_SCHEDULED flag before escalating.
> > 
> Which was precisely the point :-)
> 
> Hmm. The comment might've been clearer.
> 
> What this patch is _supposed_ to be doing is that it'll clear the
> SCSI_EH_ABORT_SCHEDULED flag it it has been set.
> Which means this will be the second time scsi_abort_command() has
> been called for the same command.
> IE the first abort went out, did its thing, but now the same command
> has timed out again.
> 
> So this flag gets cleared, and scsi_abort_command() returns FAILED,
> and _no_ asynchronous abort is being scheduled.
> scsi_times_out() will then proceed to call scsi_eh_scmd_add().
> But as we've cleared the SCSI_EH_ABORT_SCHEDULED flag
> the SCSI_EH_CANCEL_CMD flag will continue to be set,
> and the command will be aborted with the main SCSI EH routine.
> 
> It looks to me as if it should do what you desire, namely abort the
> command asynchronously the first time, and invoking the SCSI EH the
> second time.
> 
> Am I wrong?

I don't know -- I'll have to try it out.  Currently I'm busy with a 
bunch of other stuff, so it will take some time.

Looking through the code, I have to wonder why scsi_times_out()  
modifies scmd->result.  Won't this value get overwritten by the LLDD
when the command eventually terminates?

Even worse, what happens in the event of a race where the command 
terminates normally just before scsi_times_out() changes scmd->result?

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
