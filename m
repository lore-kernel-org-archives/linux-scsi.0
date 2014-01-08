From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Wed, 8 Jan 2014 16:21:37 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401081547490.1659-100000@iolanthe.rowland.org>
References: <52CDB32A.6000702@ubuntu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:59275 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756896AbaAHVVi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jan 2014 16:21:38 -0500
In-Reply-To: <52CDB32A.6000702@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>, todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>

On Wed, 8 Jan 2014, Phillip Susi wrote:

> > In essence, you want your disk's state to move directly from
> > unpowered (system asleep) to runtime-suspended with no intermediate
> > active -- but only if the disk doesn't spin up all by itself.
> > 
> > One problem: How can the kernel tell whether the disk has spun up
> > by itself?  I don't think it can be done at the SCSI level.  Can it
> > be done at the ATA level (and without using the SCSI stack, as that
> > would require the disk to go out of runtime suspend and spin up
> > anyway)?
> 
> You issue a REQUEST SENSE command and that returns status indicating
> whether the drive is stopped, or in standby.  See my patches.  One of

I never saw your patches.  Where were they posted?

If you issue the REQUEST SENSE command in the usual way (going through
the SCSI and block layers), and the disk is already in runtime suspend,
it won't do what you want.  The block layer won't deliver requests
until the device leaves the RPM_SUSPENDED state.  In addition, when it
receives the command the block layer will submit a deferred
runtime-resume request, which rather defeats the whole purpose.

(I guess you actually saw some of this happen, and that's what led to
this email thread in the first place.)

It's a knotty situation.  The only way to find out whether the disk is
spinning is to ask it, which requires doing I/O, which requires
spinning up the disk.  Maybe we need to add a mechanism to the block
layer's runtime PM implementation for addressing just this situation.

> them fixes the scsi-ata translation to issue the ATA CHECK power
> command to see if the drive is suspended, as SAT-3 calls for.

What happens with non-ATA disks?


> > Actually, it does have a reason.  Namely, you told it earlier to
> > assume the disk will be needed again if it was used within the last
> > 5 minutes.  At the time of the system resume, the disk was last
> > used 3 minutes ago (not counting the time the system was asleep).
> 
> You're looking at it backwards.  You aren't telling it to assume the
> disk will be needed again if it was used within the last 5 minutes;
> you are telling it that it can assume it *won't* be needed again soon
> if not used in the last 5 minutes, and therefore, it is ok to shut it
> down.

Okay, yes, the autosuspend timeout affects when devices should be
powered down, not when they should be powered back up.

> Also the act of suspending the system is a pretty clear breaking point
> in general activity.  You normally stop your work and quiesce the
> system before you suspend it.  If I finish my work and copy it to my
> backup drive, then suspend the system, and my wife comes by an hour
> later to browse the web, she's not going to be touching my backup disk.

While that's true, it's also true that any userspace processes running 
before the system suspend will continue running, with no perceptible 
break, after the system wakes up.  If they were accessing the disk 
before, they will most likely continue to access it afterward.

But never mind all this; it's a pointless discussion.  The real 
question is how to implement what you want.

Alan Stern

