From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: SCSI woes (followup)
Date: Tue, 24 Sep 2002 11:18:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020924111847.A4151@eng2.beaverton.ibm.com>
References: <rmk@arm.linux.org.uk> <200209241346.g8ODkER09516@localhost.localdomain> <20020924145852.A28042@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020924145852.A28042@flint.arm.linux.org.uk>; from rmk@arm.linux.org.uk on Tue, Sep 24, 2002 at 02:58:52PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk@arm.linux.org.uk>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Tue, Sep 24, 2002 at 02:58:52PM +0100, Russell King wrote:
> On Tue, Sep 24, 2002 at 09:46:14AM -0400, James Bottomley wrote:
> > I think it's method of operation is misplaced.
> 
> I think it is misplaced.  It locks the doors of devices that aren't even
> in use, which is just plain stupid.
> 
> > However, for your case does simply moving the queue empty check to the top 
> > cause the problems to go away? (That would be hiding the problem not fixing 
> > it, but still...)
> 
> I #if 0'd it out, and it makes the problem go away.

The scan will only send INQUIRY commands, and after all scanning is
done, the upper level drivers might send a TUR.

After a new Scsi_Device is added in scsi_scan.c it calls
scsi_release_commandblocks() and sets queue_depth = 0.

Any call to scsi_request_fn() for the device at this point will just
return (break statements) after scsi_allocate_device() returns NULL,
and if scsi_ioctl() was called from scsi_request_fn() it will hang
forever.

The problem is that we try to send a command via scsi_request_fn() to
a device that has no command blocks allocated - it's initializatin
is incomplete.

Moving the empty check up sounds like good and simple fix for 2.4, or
check if queue_depth == 0. Anything else would be difficult to get right.

Moving the the SCSI_IOCTL_DOORLOCK doesn't fix the problem if it is
still called on a incompletely initialized device.

And, perhaps do not allow the error handler to run during scanning, let
later IO (to any discovered device) kick off the error handler. It's
hard to say if this is good or not - for example, if this is your root
device, you want it online. But if it some other device, and we try hard
to scan and use it, it can cause more problems (if it keeps getting errors,
and we keeping running the error handler/reset cycle, blocking other IO).

The problem happens via:

1) device A is found that has removable media during scan

2) INQUIRY to another device B kicks off error handling before the
scan has completed, so device A has no command blocks.

3) Error handler completion calls scsi_request_fn() for A.

4) scsi_request_fn() for A sees the reset happened, and calls scsi_ioctl().

5) scsi_ioctl() calls scsi_request_fn(), it cannot get a Scsi_Cmnd, so
it just returns, incorrectly assuming that another request must be
outstanding.

6) The scsi_ioctl() never completes. The error handling thread should
be hung.

-- Patrick Mansfield
