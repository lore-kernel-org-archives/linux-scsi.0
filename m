From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Wed, 8 Jan 2014 12:46:23 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401081220170.1659-100000@iolanthe.rowland.org>
References: <52CC922D.9070208@ubuntu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <52CC922D.9070208@ubuntu.com>
Sender: linux-ide-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>, todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-Id: linux-scsi@vger.kernel.org

On Tue, 7 Jan 2014, Phillip Susi wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> On 01/07/2014 02:18 PM, Alan Stern wrote:
> > I don't know how you manually spin down your disk, but one
> > reasonable way to do it is to set the autosuspend timeout to 0.  If
> > you use this approach and apply my patch, the disk should remain
> > spun down when the system resumes.
> 
> The traditional method before the recently added block pm feature was
> with hdparm -y.

A real problem here is that hdparm does not interact with the runtime 
PM part of the kernel.  They work independently and can interfere with 
each other.

> > Right.  If you hadn't put the whole system to sleep, the disk
> > would have gone into runtime suspend 2 minutes later (assuming you
> > didn't use it in the meantime).  Whereas since you did put the
> > whole system to sleep, the disk will go into runtime suspend 5
> > minutes after the system wakes up -- not 2 minutes later.  I.e.,
> > the timer has been reset from 2 minutes back to 5.
> 
> What resets the timer?  It should only be reset when IO is done.  And

I/O _was_ done.  To spin up the disk requires sending it a START 
command.  That's I/O.

Okay, you may not think that is a valid argument.  Still, the timer has
to be set to _something_, and during the resume we don't know how much
time was remaining as of the suspend.  (I suppose we could store this 
information when the suspend occurs, but currently we don't.)

> yes, it is exactly that wakeup and turn around and suspend again that
> I'm trying to avoid; it puts unnecessary wear and tear on the disk.

In essence, you want your disk's state to move directly from unpowered
(system asleep) to runtime-suspended with no intermediate active -- but
only if the disk doesn't spin up all by itself.

One problem: How can the kernel tell whether the disk has spun up by
itself?  I don't think it can be done at the SCSI level.  Can it be
done at the ATA level (and without using the SCSI stack, as that would
require the disk to go out of runtime suspend and spin up anyway)?


> > How is the kernel supposed to know that you finished using the
> > disk before suspending the system?  After all, by setting the
> > autosuspend timeout to 5 minutes, you have already told the kernel
> > to keep the disk spun up if it has been used any time in the last 5
> > minutes, and you used it only 3 minutes ago.  As far as the kernel
> > can tell, you still want the disk to be spun up and ready for use.
> > That remains true at the time of the system resume.
> 
> That's the whole point: it doesn't know.  What it does know is that
> the disk is spun down on resume, and it has no reason to believe that
> you will need it again soon.

Actually, it does have a reason.  Namely, you told it earlier to assume 
the disk will be needed again if it was used within the last 5 
minutes.  At the time of the system resume, the disk was last used 3 
minutes ago (not counting the time the system was asleep).

>  This is especially true given that your
> typical single ATA disk system will spin up the drive on its own
> anyhow, so on systems with multiple scsi or ATA disks that explicitly
> have been set to power up in standby, it is at least an even bet that
> you won't be touching them all soon.

Are you assuming these disks were all runtime-active before the system 
sleep?  If so, the kernel is justified in assuming that you will be 
touching them all soon.

> > You're forgetting that the same sd driver manages other types of 
> > devices than disk drives.  Card readers and USB flash drives have
> > no heads to retract and no spinning platters.  They don't need
> > START STOP commands (in fact, some of them probably would crash if
> > they received such a command).
> 
> They are irrelevant since they ignore the command anyhow.

Not the ones that crash when they receive it.  But this point is moot
since manage_start_stop doesn't do what you want anyway.

> > Now I'm really getting confused.  Here, you are saying that ATA
> > disks will always spin up, all by themselves, whenever the system
> > resumes, and there's nothing the kernel can do to prevent it.  But
> > earlier you wrote:
> 
> No, I'm saying some ( most in fact ) do, and some do not.  Both cases
> need to be handled.  Runtime pm must not indicate the disk is
> suspended when it spins up on its own after power on, which ATA disks
> do by default.  Oddly, the SCSI standard says that SCSI disks can be
> configured behave this way as well rather than requiring an explicit
> start command, though it doesn't say how and I've not heard of a way
> to do this.  I suppose this also applies to the USB flash drives and
> SD card readers you mentioned that are managed by sd.

No, it doesn't.  They don't spin, so they can't be configured either to 
spin up or not to spin up after power-on.

> > Isn't this a contradiction?  Or are you making a distinction
> > between ATA and non-ATA disks?
> 
> What?  I have some disk drives that I rarely access.  I simply don't
> want them starting up and spinning back down every time I resume.  In
> my case they are ATA with PuiS enabled, but it applies to SCSI the
> same way.

What is PuiS?


In the end, it sounds like what you want can be done fairly easily.  
But only if the kernel has a reliable way to tell whether or not a disk
is spinning (or is spinning up).

Alan Stern

