From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 0/3] Fix USB deadlock caused by SCSI error handling
Date: Mon, 7 Apr 2014 11:26:45 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1404071125220.20747-100000@netrider.rowland.org>
References: <533BA835.7050508@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:35682 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751946AbaDGP0q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2014 11:26:46 -0400
In-Reply-To: <533BA835.7050508@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Wed, 2 Apr 2014, Hannes Reinecke wrote:

> On 04/01/2014 11:28 PM, Alan Stern wrote:
> > On Tue, 1 Apr 2014, Hannes Reinecke wrote:
> > 
> >>>> So if the above reasoning is okay then this patch should be doing
> >>>> the trick:
> >>>>
> >>>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> >>>> index 771c16b..0e72374 100644
> >>>> --- a/drivers/scsi/scsi_error.c
> >>>> +++ b/drivers/scsi/scsi_error.c
> >>>> @@ -189,6 +189,7 @@ scsi_abort_command(struct scsi_cmnd *scmd)
> >>>>                 /*
> >>>>                  * Retry after abort failed, escalate to next level.
> >>>>                  */
> >>>> +               scmd->eh_eflags &= ~SCSI_EH_ABORT_SCHEDULED;
> >>>>                 SCSI_LOG_ERROR_RECOVERY(3,
> >>>>                         scmd_printk(KERN_INFO, scmd,
> >>>>                                     "scmd %p previous abort
> >>>> failed\n", scmd));
> >>>>
> >>>> (Beware of line
> >>>> breaks)
> >>>>
> >>>> Can you test with it?
> >>>
> >>> I don't understand.  This doesn't solve the fundamental problem (namely 
> >>> that you escalate before aborting a running command).  All it does is 
> >>> clear the SCSI_EH_ABORT_SCHEDULED flag before escalating.
> >>>
> >> Which was precisely the point :-)
> >>
> >> Hmm. The comment might've been clearer.
> >>
> >> What this patch is _supposed_ to be doing is that it'll clear the
> >> SCSI_EH_ABORT_SCHEDULED flag it it has been set.
> >> Which means this will be the second time scsi_abort_command() has
> >> been called for the same command.
> >> IE the first abort went out, did its thing, but now the same command
> >> has timed out again.
> >>
> >> So this flag gets cleared, and scsi_abort_command() returns FAILED,
> >> and _no_ asynchronous abort is being scheduled.
> >> scsi_times_out() will then proceed to call scsi_eh_scmd_add().
> >> But as we've cleared the SCSI_EH_ABORT_SCHEDULED flag
> >> the SCSI_EH_CANCEL_CMD flag will continue to be set,
> >> and the command will be aborted with the main SCSI EH routine.
> >>
> >> It looks to me as if it should do what you desire, namely abort the
> >> command asynchronously the first time, and invoking the SCSI EH the
> >> second time.
> >>
> >> Am I wrong?
> > 
> > I don't know -- I'll have to try it out.  Currently I'm busy with a 
> > bunch of other stuff, so it will take some time.

I finally got a chance to try it out.  It does seem to do what we want.  
I didn't track the flow of control in complete detail, but the command 
definitely got aborted both times it was issued.

Alan Stern

