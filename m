From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: SCSI woes (followup)
Date: Tue, 24 Sep 2002 20:01:17 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020924200117.A4409@flint.arm.linux.org.uk>
References: <rmk@arm.linux.org.uk> <200209241346.g8ODkER09516@localhost.localdomain> <20020924145852.A28042@flint.arm.linux.org.uk> <20020924111847.A4151@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020924111847.A4151@eng2.beaverton.ibm.com>; from patmans@us.ibm.com on Tue, Sep 24, 2002 at 11:18:47AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Tue, Sep 24, 2002 at 11:18:47AM -0700, Patrick Mansfield wrote:
> Moving the empty check up sounds like good and simple fix for 2.4, or
> check if queue_depth == 0. Anything else would be difficult to get right.

I disagree here.  Moving the empty check up means that we won't relock any
in-use but idle check.

As I said to James earlier today, Eric Young's comments in the code say
that it is in the wrong place.  Thinking about it for a while, I'd agree
with that statement for the reason above; any device that is in use by
user space (ie, mounted on a filesystem) could well be idle for many
hours before a request comes through for it.

This means that the door would be unlocked on an in-use device, and the
media can be (accidentally) unloaded.

> Moving the the SCSI_IOCTL_DOORLOCK doesn't fix the problem if it is
> still called on a incompletely initialized device.

There are _many_ problems here.  Let me sort out a patch later tonight
and put together the gory details of each problem.  Its basically layer
upon layer of crap and fixme's.

I have a set of fixes piling up, some trivial, that address many of these
problems.  Hell, I almost have a completely stable SCSI system here which
I almost can't bring down.  And I'm giving it all sorts of hellish
conditions to deal with.

> And, perhaps do not allow the error handler to run during scanning, let
> later IO (to any discovered device) kick off the error handler. It's
> hard to say if this is good or not - for example, if this is your root
> device, you want it online. But if it some other device, and we try hard
> to scan and use it, it can cause more problems (if it keeps getting errors,
> and we keeping running the error handler/reset cycle, blocking other IO).

No.  You need the error handler to produce bus resets.  Without bus resets,
if your SCSI bus hangs (eg, in my case due to a permanent parity error to
one device brought on by test code) you don't want to continue queueing
IDENTIFY messages to other targets.  They have no hope what so ever to get
onto the bus.

You need the error handler to time out the connection to the bad device
and perform a bus reset.  A bus reset is the only way that an initiator
can clear down a stuck bus.

> The problem happens via:
> 
> 1) device A is found that has removable media during scan
> 
> 2) INQUIRY to another device B kicks off error handling before the
> scan has completed, so device A has no command blocks.
> 
> 3) Error handler completion calls scsi_request_fn() for A.
> 
> 4) scsi_request_fn() for A sees the reset happened, and calls scsi_ioctl().
> 
> 5) scsi_ioctl() calls scsi_request_fn(), it cannot get a Scsi_Cmnd, so
> it just returns, incorrectly assuming that another request must be
> outstanding.

Not quite.  Its even more disgusting.  That code is fundamentally wrong, as
proven by my later hangs when the devices have been initialised, and passed
to the device drivers.

1) We queue up a command for device A _or_ step 3 above.

2) scsi_request_fn() gets called to start this device

3) scsi_request_fn() for A sees that a reset happened, and calls scsi_ioctl()

4) scsi_ioctl() calls scsi_request_fn().

5) the head of the request queue is _not_ the door lock, but the original
   request.

6) we kick off the original request and return from scsi_request_fn()

7) scsi_ioctl() waits for its door lock command to complete.

Ahem, well, it has _never_ been submitted to the host driver.  The done paths
for the original request don't kick the request function.  We deadlock.

Trying to lock the door in scsi_request_fn() in the way we do is
_fundamentally_ flawed.  Even Eric Young's comments agree!

Now, as I said above, I do have a whole raft of fixes accumulating here, and
if I can solve the last few problems, I'll get some patches out for you guys
to look at.

-- 
Russell King (rmk@arm.linux.org.uk)                The developer of ARM Linux
             http://www.arm.linux.org.uk/personal/aboutme.html

