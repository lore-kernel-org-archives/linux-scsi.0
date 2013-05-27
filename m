From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SCSI error handling -- one error blocks the whole SCSI host
Date: Mon, 27 May 2013 13:41:59 -0700
Message-ID: <1369687319.1950.11.camel@dabdike.int.hansenpartnership.com>
References: <CAL1RGDWuriBQQcTngjn5M3fUg0VC9XUKC_0iMQbf2p2DKfxJsQ@mail.gmail.com>
	 <1369608242.1904.7.camel@dabdike> <51A37019.3050604@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48953 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757261Ab3E0UmC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 May 2013 16:42:02 -0400
In-Reply-To: <51A37019.3050604@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Roland Dreier <roland@purestorage.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2013-05-27 at 16:39 +0200, Hannes Reinecke wrote:
> On 05/27/2013 12:44 AM, James Bottomley wrote:
> > 
> > On Thu, 2013-05-23 at 11:14 -0700, Roland Dreier wrote:
> >> At LSF this year, we had a discussion about error handling and in
> >> particular the problem that SCSI midlayer error handling waits for the
> >> entire SCSI host (HBA) to quiesce before it starts to abort commands
> >> etc.
> >>
> >> James made the suggestion that FC should handle things the way SAS
> >> does, because SAS has a strategy handler that does things the right
> >> way.  However, now that I finally sit down and look at the code, I
> >> don't see how this is the case.  It seems inherent in the way that
> >> scsi_eh_scmd_add() and the thread in scsi_error_handler() work (in
> >> particular the strategy handler can't even be called until host_failed
> >> == host_busy; we don't bump host_failed without SHOST_RECOVERY set,
> >> which stops queueing commands to any devices attached to the whole
> >> HBA).
> >>
> >> James, am I understanding your suggestion properly?  If so can you
> >> explain what you meant about the libsas code -- I see that it has its
> >> own strategy handler but as I said before we've already stopped every
> >> device attached to the HBA before we ever get there.
> > 
> > It is, but I checked: Apparently it's not implemented in the sas
> > transport class.  The original discussion when libsas was constructed,
> > as I remember it, was about using the scsi timeout handler to implement
> > a running abort.  The idea is fairly simple: you use the first fire of
> > eh_timed_out to trigger the abort (or LUN reset) while simultaneously
> > returning BLK_EH_RESET_TIMER.  If the timer fires again and the abort
> > hasn't returned, you escalate, otherwise you resend the command when the
> > abort returns.  This allows you to handle single command failures (up to
> > LUN reset) without stopping the host.  Obviously, if you have to
> > escalate to device reset, then you need to start the eh thread.
> > 
> There are some problems with that:
> 
> - Returning BLK_EH_RESET_TIMER will restart the timer with the
>   _default_ blk timeout. Whereas the _abort_ timeout might
>   (and, for some LLDDs, it definitely is) different from
>   that.

Right ... you don't reuse the command, you have to start a new one.
libsas actually has a task abstraction, which is what you use to send
TMFs.

> - Leaving the command running while abort is active will
>   inevitably risk a double completion on the original command;
>   the command abort might terminate the command at the
>   same time as the (real) completion comes in.
>   'Normal' command timeouts are protected against this via
>   REQ_ATOM_COMPLETE; commands aborted via scsi_finish_cmnd()
>   are not.

That's not a bug, it's a requirement.  The way you handle commands in a
running abort or LUN reset is only in the status return code from the
command, so you have to tie the success of the eh action to the base
command and return DID_ABORT (or DID_RESET) in the actual command ...
this is how retries get done without troubling the error handler.
Essentially, this requires a low level tie with the HBA machine
description of the command, which is what avoids double completion.

> - LLDDs typically won't return a command status even for a
>   command which has been aborted via ABORT TASK TMF.
>   So the midlayer probably will never get notified if
>   the command got aborted via ABORT TASK.

Well, that's true, but irrelevant.  If the HBA can't inform you of the
status of the abort, then abort is useless as a first step in the
traditional eh as well as in this method, so you just don't do that and
proceed to resets.

There's actually a school of thought that says even if the HBA *can*
give you all the status you need, aborts are still pointless because
it's sending in yet another state transition to an already failed state
machine (because the device is timing out).  Therefore, since the chance
of recovering the state machine with an abort is so tiny, you should
start with the lowest reset anyway because that takes the state machine
to a known state.

James

> Especially the last point made me abandon this idea for my EH
> rewrite. We would be having a real benefit if we somehow could get
> the command status _from the target_ for an aborted command.
> But as it appears we won't.
> So as any status is made up anyway I'd very much prefer to have it
> set by the midlayer. Which renders the whole operation quite
> pointless and we're better off using the existing syntax for command
> aborts.
> Plus it makes life _so much_ easier for the implementation ...
> 
> But to answer Roland: Have you checked my patchset?
> It should help for command timeouts ...
> 
> Cheers,
> 
> Hannes



