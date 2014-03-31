From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 0/3] Fix USB deadlock caused by SCSI error handling
Date: Mon, 31 Mar 2014 09:33:31 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1403310907150.11739-100000@netrider.rowland.org>
References: <533917B7.4010808@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:49860 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754541AbaCaNdc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Mar 2014 09:33:32 -0400
In-Reply-To: <533917B7.4010808@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Mon, 31 Mar 2014, Hannes Reinecke wrote:

> On 03/28/2014 08:29 PM, Alan Stern wrote:
> > On Fri, 28 Mar 2014, James Bottomley wrote:
> > 
> >> This is a set of three patches we agreed to a while ago to eliminate a
> >> USB deadlock.  I did rewrite the first patch, if it could be reviewed
> >> and tested.
> > 
> > I tested all three patches under the same conditions as before, and 
> > they all worked correctly.
> > 
> > In the revised patch 1, the meaning of SCSI_EH_ABORT_SCHEDULED isn't
> > entirely clear.  This boils down to two questions, which I don't 
> > know the answers to:
> > 
> > 	What should happen in scmd_eh_abort_handler() if
> > 	scsi_host_eh_past_deadline() returns true and thereby
> > 	prevents scsi_try_to_abort_cmd() from being called?
> > 	The flag wouldn't get cleared then.
> > 
> Ah. Correct. But that's due to the first patch being incorrect.
> Cf my response to the original first patch.

See my response to your response.  :-)

> > 	What should happen if some other pathway manages to call
> > 	scsi_try_to_abort_cmd() while scmd->abort_work is still
> > 	sitting on the work queue?  The command would be aborted
> > 	and the flag would be cleared, but the queued work would
> > 	remain.  Can this ever happen?
> > 
> Not that I could see.
> A command abort is only ever triggered by the request timeout from
> the block layer. And the timer is _not_ rearmed once the timeout
> function (here: scsi_times_out()) is called.
> Hence I fail to see how it can be called concurrently.

scsi_try_to_abort_cmd() is also called (via a different pathway) when a 
command sent by the error handler itself times out.  I haven't traced 
through all the different paths to make sure none of them can run 
concurrently.  But I'm willing to take your word for it.

> > Maybe scmd_eh_abort_handler() should check the flag before doing
> > anything.  Is there any sort of sychronization to prevent the same
> > incarnation of a command from being aborted twice (or by two different
> > threads at the same time)?  If there is, it isn't obvious.
> > 
> See above. scsi_times_out() will only ever called once.
> What can happen, though, is that _theoretically_ the LLDD might
> decide to call ->done() on a timed out command when
> scsi_eh_abort_handler() is still pending.

That's okay.  We can expect the LLDD to have sufficient locking to
handle that sort of thing without confusion (usb-storage does, for
example).

> > (Also, what's going on at the start of scsi_abort_command()?  Contrary
> > to what one might expect, the first part of the function _cancels_ a
> > scheduled abort.  And it does so without clearing the
> > SCSI_EH_ABORT_SCHEDULED flag.)
> > 
> The original idea was this:
> 
> SCSI_EH_ABORT_SCHEDULED is sticky _per command_.
> Point is, any command abort is only ever send for a timed-out
> command. And the main problem for a timed-out command is that we
> simply _do not_ know what happened for that command. So _if_ a
> command timed out, _and_ we've send an abort, _and_ the command
> times out _again_ we'll be running into an endless loop between
> timeout and aborting, and never returning the command at all.
> 
> So to prevent this we should set a marker on that command telling it
> to _not_ try to abort the command again.

I disagree.  We _have_ to abort the command again -- how else can we
stop a running command?  To prevent the loop you described, we should
avoid _retrying_ the command after it is aborted the second time.

> Which is what 'SCSI_EH_ABORT_SCHEDULED' was meant for:
> 
> - A command times out, sets 'SCSI_EH_ABORT_SCHEDULED'
> - abort _succeeds_
> - The same command times out a second time, notifies
>   that SCSI_EH_ABORT_SCHEDULED is set, and doesn't call
>   scsi_eh_abort_command() but rather escalates directly.

The proper time to escalate is after the command is aborted again, not
while the command is still running.  The only situation where you might
want to escalate while a command is still running would be if you were
unable to abort the command.

(Hmmm, maybe that's not true for SCSI devices in general.  It is true 
for USB mass-storage, however.  Perhaps the reset handlers in 
usb-storage should be changed so that they will automatically abort a 
running command before starting the reset.)

> _However_, I do feel that we've gotten the wrong track with all of
> this. In you original mail you stated:
> 
> > Basically, usb-storage deadlocks when the SCSI error handler
> > invokes the eh_device_reset_handler callback while a command
> > is running.  The command has timed out and will never complete
> > normally, because the device's firmware has crashed.  But
> > usb-storage's device-reset routine waits for the current command
> > to finish, which brings everything to a standstill.
> 
> Question now to you as the USB god:
> 
> A command abort is only _ever_ send after a command timeout.
> And the main idea of the command abort is to remove any context
> the LLDD or the target might have. So by the time the command
> abort returns SUCCESS we _expect_ the firmware to have cleared that
> command. If for some reason the firmware isn't capable of doing so,
> it should return FAILED.

You're asking about the error scenario in my original bug description, 
right?

> So:
> - Has the command timeout fired?

Yes.  In fact, the same command's timeout fired twice: Once when the 
command was first issued, and then later when the command was retried.

> - If so, why hasn't it returned FAILED?

The abort routine returned SUCCESS because it succeeded in aborting the
command.  All the state relevant to that command was removed from the
LLDD and the device.

> - If it had returned SUCCESS, why did the device_reset_handler
>   wait for the command to complete?

We are talking about two different things.

     1. The command is issued and it times out.

     2. The abort handler is called.  It successfully aborts the
	command and clears the state.  (This is what I meant above.)

     3. The command is retried, and again it times out.

     4. The abort handler is not called a second time (so it doesn't 
	return either SUCCESS or FAILED).  As you pointed out, the SCSI 
	core escalates instead.  The device reset handler is called
	while the retried command is still running, because the retry
	never got aborted.

I hope this clarifies the situation.

Alan Stern

