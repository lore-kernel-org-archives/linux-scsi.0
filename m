From: Alan Stern <stern@rowland.org>
Subject: Questions about the midlevel scsi subsystem
Date: Thu, 6 Jun 2002 11:51:04 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33L2.0206061145520.857-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>

For all you Linux scsi experts:

I've been working on the usb-storage device driver.  It uses
scsi-emulation mode, which means that the interface to the midlevel
scsi subsystem has to work correctly.  Unfortunately, there are
several aspects to this interface that I don't understand very well.
I hope that some of you can answer a few questions.

First of all, my host template has can_queue set to 1.  Doesn't this
guarantee that there will never be more than one outstanding Scsi_Cmnd
on the request queue?  Another person in the usb-storage group
mentioned that there have been observed bugs where one command got
queued on top of another.  I don't know whether this was the fault of
the scsi subsystem or not, and I don't know whether the problem still
exists.  However, do you agree that if it did happen again then it
would definitely indicate a bug in the scsi subsystem?

Second, how does the scsi subsystem know when a queued command has
been completed and removed from the queue?  Is it when the done()
function argument to the queuecommand() routine gets called?  What
about an aborted command?  When a Scsi_Cmnd is aborted through the
eh_abort_handler(), the done() routine never gets called.  Is that the
right thing to do?  Does the scsi subsystem believe that a queued
command has been removed from the queue at the time that the
eh_abort_handler() returns a SUCCESS value?  What if the
eh_abort_handler() returns a FAILURE value -- is it assumed that then
the done() routine will be called?

Third, I am aware that the scsi error handler for each host adapter is
single-threaded.  Does that mean that when any sort of error occurs,
only one scsi transaction can be outstanding at a time?  For instance,
will an outstanding queued command be aborted before any sort of reset
is attempted?  What if the abort fails?  Is it possible to have more
than one device-reset active for the same target/LUN at a time?  What
about host-resets and bus-resets?  Is it possible to have a bus-reset
and a device-reset active simultaneously?  Going by the code in
scsi_error.c, there is no timeout associated with a reset request;
does this mean it is impossible for the eh_abort_handler() to be
called for a device-, bus-, or host-reset Scsi_Cmnd?

Lastly, how does the error handler take account of the possible races
when a command is aborted at nearly the same time that it completes?
Is this the function of the io_request_lock spinlock in Linux 2.4 (and
the finer-grained lock whose name I don't recall in 2.5)?  If yes, how
are these locks supposed to be used in the low-level driver code?  If
no, then how are races prevented?  And consider the following code
excerpt from scsi_error.c:scsi_try_to_abort_command() from the 2.4
source:

        /*
         * scsi_done was called just after the command timed out and before
         * we had a chance to process it. (DB)
         */
        if (SCpnt->serial_number == 0)
                return SUCCESS;

        SCpnt->owner = SCSI_OWNER_LOWLEVEL;

        spin_lock_irqsave(&io_request_lock, flags);
        rtn = SCpnt->host->hostt->eh_abort_handler(SCpnt);
        spin_unlock_irqrestore(&io_request_lock, flags);
        return rtn;

Why is the test for serial_number == 0 (set by the done() routine, I
presume) outside the region protected by the spinlock?  What if the
request completes after the test but before the lock is grabbed?

Please copy any replies to me directly at <stern@rowland.org>, since I
am not subscribed to the linux-scsi mailing list.  Thanks for your
time and your help.

Alan Stern

