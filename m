From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Questions about the midlevel scsi subsystem
Date: Fri, 7 Jun 2002 15:39:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020607153918.A8319@eng2.beaverton.ibm.com>
References: <Pine.LNX.4.33L2.0206061145520.857-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.33L2.0206061145520.857-100000@ida.rowland.org>; from stern@rowland.org on Thu, Jun 06, 2002 at 11:51:04AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.org>
Cc: linux-scsi@vger.kernel.org, Matthew Dharm <mdharm-usb@one-eyed-alien.net>

On Thu, Jun 06, 2002 at 11:51:04AM -0400, Alan Stern wrote:
> For all you Linux scsi experts:
> 
> I've been working on the usb-storage device driver.  It uses
> scsi-emulation mode, which means that the interface to the midlevel
> scsi subsystem has to work correctly.  Unfortunately, there are
> several aspects to this interface that I don't understand very well.
> I hope that some of you can answer a few questions.

> First of all, my host template has can_queue set to 1.  Doesn't this
> guarantee that there will never be more than one outstanding Scsi_Cmnd
> on the request queue?  Another person in the usb-storage group
> mentioned that there have been observed bugs where one command got
> queued on top of another.  I don't know whether this was the fault of
> the scsi subsystem or not, and I don't know whether the problem still
> exists.  However, do you agree that if it did happen again then it
> would definitely indicate a bug in the scsi subsystem?

The mid-layer should never send more than can_queue comands to
the low-level driver, that would be a bug.

> Second, how does the scsi subsystem know when a queued command has
> been completed and removed from the queue?  Is it when the done()
> function argument to the queuecommand() routine gets called?  What
> about an aborted command?  When a Scsi_Cmnd is aborted through the
> eh_abort_handler(), the done() routine never gets called.  Is that the
> right thing to do?  Does the scsi subsystem believe that a queued
> command has been removed from the queue at the time that the
> eh_abort_handler() returns a SUCCESS value?  What if the
> eh_abort_handler() returns a FAILURE value -- is it assumed that then
> the done() routine will be called?

Yes, done is normally scsi_done(), when it is called the low level driver
must be finished with the command.

You already noticed the race between done and the timeout; it appears that
the mid-layer calls the abort handler, and no matter the result of the abort,
continues. But, it should do some sort of locking of the Scsi_Cmnd, and if
the adapter cannot abort the command, take the adapter offline (if the
adapter cannot abort a Scsi_Cmnd owned by the adapter, something is very
wrong). Since there is no locking, and the result of the abort does not
affect a retry of the command (the IO is not immediately retried, but might
be retried after a bus reset), bad things could happen such as sending and
completing (one IO) twice.

The linux scsi error handling code is hard to follow, it looks like it
can do excessive bus device resets and other bad things, reading that
code is painful. James Bottomley was looking into cleaning it up for 2.5.x.

> Third, I am aware that the scsi error handler for each host adapter is
> single-threaded.  Does that mean that when any sort of error occurs,
> only one scsi transaction can be outstanding at a time?  For instance,
> will an outstanding queued command be aborted before any sort of reset
> is attempted?  What if the abort fails?  Is it possible to have more
> than one device-reset active for the same target/LUN at a time?  What
> about host-resets and bus-resets?  Is it possible to have a bus-reset
> and a device-reset active simultaneously?  Going by the code in
> scsi_error.c, there is no timeout associated with a reset request;
> does this mean it is impossible for the eh_abort_handler() to be
> called for a device-, bus-, or host-reset Scsi_Cmnd?

The error handler is supposed to run after *no* commands are outstanding
in the lower-level, but this includes timed out commands handled in the
mid-layer.

The abort handler is called before any resets (only for timed out commands,
but that is correct since only timed out commands could still be in the
lower-level).

Since there is only one error thread per Scsi_Host, and the error handler
is sending the resets out, there should never be more than one outstanding
reset per Scsi_Host, assuming that the lower-level driver does not allow
a reset handler to return until after the reset is complete. I think
the lower-level has to fail the reset on a time out, but then there is
probably a race there. Maybe the error handler should stop after a failed
reset, and mark the Scsi_Host offline, rather than churning on?

Since the lower-layer handles the actual resets via function calls,
eh_abort_handler() cannot be called for them, right? In scsi_error.c,
the SCpnt is only used as a handle to call the Scsi_Host reset functions.

> 
> Lastly, how does the error handler take account of the possible races
> when a command is aborted at nearly the same time that it completes?
> Is this the function of the io_request_lock spinlock in Linux 2.4 (and
> the finer-grained lock whose name I don't recall in 2.5)?  If yes, how
> are these locks supposed to be used in the low-level driver code?  If
> no, then how are races prevented?  And consider the following code
> excerpt from scsi_error.c:scsi_try_to_abort_command() from the 2.4
> source:
> 
>         /*
>          * scsi_done was called just after the command timed out and before
>          * we had a chance to process it. (DB)
>          */
>         if (SCpnt->serial_number == 0)
>                 return SUCCESS;
> 
>         SCpnt->owner = SCSI_OWNER_LOWLEVEL;
> 
>         spin_lock_irqsave(&io_request_lock, flags);
>         rtn = SCpnt->host->hostt->eh_abort_handler(SCpnt);
>         spin_unlock_irqrestore(&io_request_lock, flags);
>         return rtn;
> 
> Why is the test for serial_number == 0 (set by the done() routine, I
> presume) outside the region protected by the spinlock?  What if the
> request completes after the test but before the lock is grabbed?

Looks like an ugly race.

Worse, after the return SUCCESS, the IO is normally retried, when it
should be left as completed. The window for the race is small (but
does exist), since we just checked SCloop->state != SCSI_STATE_TIMEOUT.

Getting the lock doesn't help unless everyone gets the lock for all
Scsi_Cmnd references. Doug Ledford posted about protecting against
this race, read this:

http://marc.theaimsgroup.com/?l=linux-scsi&m=100707490831830&w=2

> Please copy any replies to me directly at <stern@rowland.org>, since I
> am not subscribed to the linux-scsi mailing list.  Thanks for your
> time and your help.
> 
> Alan Stern

-- Patrick Mansfield
