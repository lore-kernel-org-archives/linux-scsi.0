From: Russell King <rmk@arm.linux.org.uk>
Subject: 2.4.19 SCSI error handing, door locking, etc
Date: Thu, 26 Sep 2002 01:23:57 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020926012357.B8733@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from flint.arm.linux.org.uk ([3ffe:8260:2002:1:201:2ff:fe14:8fad])
	by caramon.arm.linux.org.uk with asmtp (TLSv1:DES-CBC3-SHA:168)
	(Exim 4.04)
	id 17uMRi-0006Rh-00
	for linux-scsi@vger.kernel.org; Thu, 26 Sep 2002 01:23:58 +0100
Received: from rmk by flint.arm.linux.org.uk with local (Exim 4.04)
	id 17uMRh-0006iT-00
	for linux-scsi@vger.kernel.org; Thu, 26 Sep 2002 01:23:57 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Ok, I've uploaded the patches below to:

	ftp://ftp.linux.org.uk/pub/linux/rmk/scsi
	http://ftp.linux.org.uk/pub/linux/rmk/scsi

You'll find all the patches there, plus a tarball of all patches
and the text below (the README is a copy of the text below.)

Things outstanding:

- scsi-cmd-retry - brings in scsi_setup_cmd_retry without a
  prototype; expect some compiler warnings for now.

- scsi-door-lock - sd/st/sr (etc) door-locking callers don't
  themselves check the return value.  Problem noticed by
  Patrick Mansfield.

- scsi-unjam-clean - has only been _compile_ tested.  It is
  the result of a merge of my new error handling code.

Unfortunately, the earliest I'll be able to address anything arising
from this will be Saturday, I've got to context-switch onto other
stuff for the next couple of days.  This means the earliest I
can provide answers to feedback received is Saturday.

Thanks to Doug Ledford, James Bottomley, Patrick Mansfield and
Mike Anderson for comments thus far.


SCSI subsystem patches
----------------------

This is a set of patches created to make the SCSI error handling
more robust.  I have experienced a number of deadlocks and bad
behaviour by the SCSI subsystem in the presence of errors, such
as:

- locking device doors on devices that aren't in use.
- deadlocking trying to lock device doors
- deadlocking during scanning for devices with a faulty device
  (fault caused by test code in the HBA)

The filenames indicate the patch series, and other requirements.
The format of these names is:

	nn-desc-number.diff

nn	This is the series number, and series are expected to be
	applied in order.  Applying out of order may produce
	patch rejects that need to be fixed by hand, or fuzz.

desc	Brief description of what the patch does

number	Sub-series number, specifies the order the patches must
	be applied in.  If a series has 8 patches, and you want
	number 4, you need to apply patches 1 to 4 and you can
	ignore 5 to 8.

01-scsi-cmd-retry-1.diff

	Provide scsi_setup_cmd_retry function to setup a Scsi_Cmnd
	structure for a retry of the command.  Make the four places
	that re-setup the command for a retry use scsi_setup_cmd_retry

01-scsi-cmd-retry-2.diff

	Move the NEEDS_RETRY mechanism out of scsi_send_eh_cmnd
	into the caller of that function.  This corrects a
	serious error handling bug where we retry a command
	without re-initialising the Scsi_Cmnd structure.

01-scsi-cmd-retry-3.diff

	Bound the number of retries in the error handler.  Infinite
	command retries lock the host.  It is far better that we
	try to free up the host.  Problem noticed by Doug Ledford.
	Basic idea for solution from Mike Anderson.

02-scsi-cmd-report.diff

	When reporting scsi errors to the user, tell the user about
	the ultimate command we were trying to perform, not the
	current command which may be an error handing/driver invoked
	request sense command.

03-scsi-restart-ops.diff

	Don't stop kicking device queues because one device is
	blocked. This test is actually redundant; we check for a
	blocked device in scsi_request_fn() and exit virtually
	immediately.  We therefore just call the function and let
	it deal with the issues in one place.

04-scsi-door-lock-1.diff

	Introduce a new per-device flag - "locked".  When this flag
	is set, it means that user space wanted the door locked, and
	we have successfully locked it.  When clear, it means something
	user space wanted the door unlocked, and we have successfully
	unlocked it.

	Introduce "scsi_set_medium_removal()".  This handles all door
	locking and unlocking requests that essentially originate from
	user space. ie, when a device is opened or closed, or an ioctl
	is received.  This function takes care of issuing the
	ALLOW_MEDIUM_REMOVAL command via the ioctl layers.

	This function isn't really anything new; its existing code
	moved into a function.  It also removes code duplication.

	The new bit is what it does after the command has completed.
	If the command was successful, we update the device "locked"
	flag to indicate the new state.

	Rather than indirecting via scsi_ioctl() from the various
	drivers, we now call scsi_set_medium_removal direct

04-scsi-door-lock-2.diff

	The "new" error handling code.  Just before we attempt to
	restart operations on a host in scsi_restart_operations(), we
	loop through all devices on the host.  At this point, we don't
	have much idea which devices received a reset.

	Any device that is online (something the old code never checked
	for) and was locked, we try to re-lock the door.  Note how we
	handle this.  We create a request structure, and fill in all
	the relevant values, and insert this request at the _head_ of
	the queue.

	The requests done function merely frees the command.  If the
	command fails, we can't really do much to recover from it.
	We could retry, but the generic SCSI command handling will
	have done that for us already.

	The "old" code.  Yes, suggestion: read the comment.  Since we
	have the "new" error handling code in place, we must not to
	lock the door while processing requests.  If we do, we'll
	certainly deadlock.

	However, we do take note of the currently requested lock state,
	and only ask for the door to be locked if it was previously
	locked.

05-scsi-unjam-clean-1.diff

	Carve up the huge scsi_unjam_host() function into a number of
	functions that perform one and only one action.  Although
	we keep scsi_unjam_host(), it now iterates through an array
	of functions, which have the "knowledge" about unjamming a
	host.

	There are no functional changes in this patch.

05-scsi-unjam-clean-2.diff

	New function - scsi_eh_find_failed_command().  This finds the
	first failed command on a device.  Unfortunately, we need a
	Scsi_Cmnd structure to call the various HBA reset functions
	with, rather than a Scsi_Device/Scsi_Host+channel/Scsi_Host for
	bus_device_reset/bus_reset/host_reset respectively.

	However, in this patch there is only one user, the BDR code.

	There are no functional changes in this patch.

05-scsi-unjam-clean-3.diff

	There is a fair amount of duplication across all the reset
	handlers; after performing any type of reset, they send a test
	unit ready command, and if that succeeds, they retry the original
	command.

	This patch factors that functionality out into a new function -
	scsi_eh_test_and_retry().

	There are no functional changes in this patch.

05-scsi-unjam-clean-4.diff

	In a similar way, we factor out the code which takes devices off
	line; this ends up in scsi_eh_set_device_offline().

	Once we have taken a device off line, there is no point looking
	at any other commands on this device, since we've declared it
	dead.  We therefore finish all commands with the appropriate
	status.

	Note: this does mean that we guarantee that we won't call any
	reset handlers more than once for each device that has failed.

05-scsi-unjam-clean-5.diff

	Factor out code that loops through all commands on a device
	trying to restart failed or timed out commands.

	This allows us to fix an outstanding fixme in the bus device
	reset code:

		FIXME(eric) - make sure we handle the case
		where multiple commands to the same device
		have failed. They all must get properly
		restarted.

	Note: We also only attempt no more than one bus reset per device
	(we don't yet have the concept of a bus), and one host reset per
	host.

05-scsi-unjam-clean-6.diff

	This is probably the most yuckiest and difficult patch to read
	of the whole set.  This gives us a per-channel basis for
	performing bus resets.
        
	This also kills off the unnecessary loops within loops within
	loops within loops.  James Bottomley assures me that for any
	Scsi_Cmnd, it will be found in SCpnt->device->device_queue.

	The final point also applies to the host reset code.

05-scsi-unjam-clean-7.diff

	At last, we get to the patch that really makes the difference for
	me.  There are two distinct changes.

	Firstly, rather than taking a device off line because it reports
	that it is not ready shortly after a reset, we give it a total
	of 3 retries 5 seconds apart to report ready.  My tape drive
	regularly fails the original code here while its re-initialising
	after the reset.

	It may be better that we filter out the "medium not ready" sense
	codes and use the command's timeout/retry count for that.  However,
	this code seems to be adequate.

	Secondly, if we fail to restart all commands on a failed device,
	just before taking the device off line, we perform the same
	action we did to free the bus.	This means a host or bus reset
	as appropriate.

	Why is this necessary?	Scenario: a command is sent to a device,
	whose firmware crashes and holds the SCSI bus.	We perform all
	the necessary error handling, and find that a bus reset seems
	to get things moving again, and we re-issue the same command to
	the device.  The device fails in the same way.

	At this point, the existing code will attempt to abort the
	command.  Even if the HBA driver says that it is unable to abort
	the command, the SCSI mid-layer re-uses that command for its own
	purposes.  However, the HBA driver still contains a reference to
	that command.

	Since resets are supposed to clear the HBAs knowledge of commands
	and free the SCSI bus, we use the appropriate reset that fixed
	the problem the last time around immediately prior to taking
	an unrecoverable device off line.

05-scsi-unjam-clean-8.diff

	Final patch of the lot.  This one is rather boring, and is just
	cleanup and styling.  Make comments and most code in this area
	wrap before column 80.  Make sure we have scsi logging where
	appropriate, remove/rename unnecessary variables, and remove
	unnecessary braces.
	

-- 
Russell King (rmk@arm.linux.org.uk)                The developer of ARM Linux
             http://www.arm.linux.org.uk/personal/aboutme.html

