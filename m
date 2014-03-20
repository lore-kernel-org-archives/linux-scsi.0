From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Deadlock in usb-storage error handling
Date: Thu, 20 Mar 2014 09:09:24 -0700
Message-ID: <1395331764.2244.16.camel@dabdike.int.hansenpartnership.com>
References: <Pine.LNX.4.44L0.1403201036450.860-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40476 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756141AbaCTQJ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Mar 2014 12:09:29 -0400
In-Reply-To: <Pine.LNX.4.44L0.1403201036450.860-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andreas Reis <andreas.reis@gmail.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 2014-03-20 at 11:36 -0400, Alan Stern wrote:
> On Wed, 19 Mar 2014, James Bottomley wrote:
> 
> > > Basically, usb-storage deadlocks when the SCSI error handler invokes
> > > the eh_device_reset_handler callback while a command is running.  The
> > > command has timed out and will never complete normally, because the
> > > device's firmware has crashed.  But usb-storage's device-reset routine
> > > waits for the current command to finish, which brings everything to a
> > > standstill.
> > > 
> > > Is this design wrong?  That is, should the device-reset routine wait 
> > > for currently executing commands to finish, or should it abort them, or 
> > > what?
> > 
> > In some sense, yes, but not necessarily from the Point of View of USB.
> > What we assume in SCSI is that commands are forgettable, meaning there's
> > always some operation we can perform (be it abort or reset) that causes
> > the device to forget about all outstanding commands and reset its
> > internal state machine to a known good state.
> > 
> > The cardinal SCSI assumption is that after we've successfully done an
> > abort or reset on a command that it will never come back to us from the
> > device.
> 
> The same assumption is present in usb-storage.
> 
> The difference appears to be that SCSI assumes a reset can be issued at 
> any time, even while a command is running.  In usb-storage, that's true 
> for a _bus_ reset but it's not true for a _device_ reset.
> 
> Perhaps this restriction on device resets could be lifted, but in real
> life it probably won't make much difference.  The fact is, almost no
> USB mass-storage devices implement device reset correctly, whereas most
> of them do implement bus reset.  (Possibly related factoid: MS Windows
> uses bus resets but doesn't use device resets in its USB mass-storage
> driver.)

Actually, you don't have to lift the restriction.  Just fail the device
reset if you can't issue it (so if there's any outstanding commands).
SCSI will move on to a bus reset which you can accept.

> > > Or should the SCSI error handler abort the running command before 
> > > invoking the eh_device_reset_handler callback?
> > 
> > So this is rooted in the "Abort can be a Problem" issue:  Abort
> > sometimes works well (and it's not very disruptive) but sometimes if the
> > device is having a problem in its command state machine, adding another
> > command (which is what the abort is) doesn't actually do anything, so we
> > need error escalation to reset.  We can't wait for the abort or other
> > commands to complete because they never will.  The reset is expected to
> > clear everything from the device (including the pending aborts).
> 
> With usb-storage, aborts usually work pretty well.  But sometimes they 
> don't cure the underlying cause, so when the offending command is 
> retried, it hangs up again.  Something like that seems to be happening 
> here.
> 
> > > For the record, and in case anyone is curious, here's the detailed
> > > sequence of events during my test:
> > > 
> > > 	sd issues a READ(10) command.  For whatever reason, the device
> > > 	goes nuts and the command times out.
> > > 
> > > 	scsi_times_out() calls scsi_abort_command(), which queues an
> > > 	abort request.
> > > 
> > > 	scmd_eh_abort_handler() calls scsi_try_to_abort_cmd(), which
> > > 	succeeds in aborting the READ.
> > > 
> > > 	The READ command is retried (I didn't trace through the details
> > > 	of this).  The retry fails with a Unit Attention (SK=6, 
> > > 	ASC=0x29, Reset or Bus Device Reset Occurred).
> > > 
> > > 	The READ command is retried a second time, and it times out 
> > > 	again.
> > > 
> > > 	This time around, scsi_times_out() calls scsi_abort_command()
> > > 	unsuccessfully (because the SCSI_EH_ABORT_SCHEDULED flag is
> > > 	still set).
> > 
> > From the first time we sent the abort?
> 
> Yes.  As far as I can see, the only place where SCSI_EH_ABORT_SCHEDULED
> gets cleared is in scsi_eh_finish_cmd(), which never got called.  
> After the successful abort, scmd_eh_abort_handler() went directly into
> its "if (rtn == SUCCESS)" and "scmd %p retry aborted command" /
> scsi_queue_insert() code paths.

OK, that's a bug ... I'll see if I can find it.

> >  That sounds like a problem in
> > our state tracking.
> 
> Could well be.  How should I track it down further?  Or can you suggest
> a patch just from this much information?
> 
> > > 	As a result, scsi_error_handler() calls scsi_unjam_host(), 
> > > 	which calls scsi_eh_get_sense().
> > > 
> > > 	That routine calls scsi_request_sense(), which goes into
> > > 	scsi_send_eh_cmnd().
> > 
> > I thought USB was autosense, so when it reports check condition, we
> > should already have sense ... or are we calling request_sense without
> > being sent a check condition status?
> 
> usb-storage does autosense.  As far as I can tell, the REQUEST SENSE is
> issued because there is no sense data, which is because the READ
> command is still running.  Is this another state-tracking bug?

Yes ... we should only issue a request sense if we got a check condition
return.  If we're doing it without that, something is wrong somewhere.

> > > 	The calls to shost->hostt->queuecommand() all fail, because the
> > > 	READ command is still running and usb-storage has a queue
> > > 	depth of 1.  The error messages produced by these failures are
> > > 	disconcerting but not dangerous.
> > > 
> > > 	Since the REQUEST SENSE command was never issued, 
> > > 	scsi_eh_get_sense() returns 0.
> > > 
> > > 	scsi_unjam_host() goes on to call scsi_eh_abort_cmds(), which
> > > 	does essentially nothing because the SCSI_EH_CANCEL_CMD flag
> > > 	for the only command on work_q is clear.  
> > > 	scsi_eh_test_devices() returns 0 because check_list is empty
> > > 	and work_q isn't.
> > > 
> > > 	scsi_unjam_host() then calls scsi_eh_ready_devs().  This
> > > 	routine ends up calling scsi_eh_bus_device_reset(), at which 
> > > 	point usb-storage deadlocks as described above.
> > 
> > OK, so in the case where the command can never complete (because the fw
> > has crashed), what should be the process for resetting the device so it
> > can again function?
> 
> Simply abort the command.  usb-storage will automatically carry out a 
> bus reset under those conditions, and that's the best we can do.
> 
> As you can see, the sequence above started out doing exactly this.  
> The problems began when the command was retried.  That time it didn't 
> get aborted, thanks to the leftover SCSI_EH_ABORT_SCHEDULED flag.  
> Things got worse from there.

OK, so I think we have three things to do

     1. Investigate SCSI and fix it's abort state problem that's causing
        it not to send the abort second time around
     2. Fix usb-storage to fail a reset it can't do (i.e. device reset
        with outstanding commands)
     3. Find out why we're sending a spurious request sense.

I can look at 1 and 3 if you want to take 2.

James



