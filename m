From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Tue, 7 Jan 2014 14:18:56 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401071352080.1296-100000@iolanthe.rowland.org>
References: <52CC4AD8.8080901@ubuntu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <52CC4AD8.8080901@ubuntu.com>
Sender: linux-ide-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>, todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-Id: linux-scsi@vger.kernel.org

On Tue, 7 Jan 2014, Phillip Susi wrote:

> On 1/7/2014 1:05 PM, Alan Stern wrote:
> > I disagree with your argument.  If you aren't using autosuspend at
> > all then you don't mind having your disks spin all the time.
> > Therefore you don't mind if the disks spin up during system
> > resume.
> 
> I prefer to manually spin the disk down when I don't plan on using it
> for a while instead of letting it auto suspend using a timeout since
> the timeout often either is too short and spins the disk down before
> I'm done with it, or too long, and doesn't let it sleep as much as it
> could.  Yet, I do mind that the disk must spin up whenever I resume,
> even though I don't plan on using it any time soon.

I don't know how you manually spin down your disk, but one reasonable
way to do it is to set the autosuspend timeout to 0.  If you use this
approach and apply my patch, the disk should remain spun down when the
system resumes.

> > If you're using a long timeout and you don't like the way the timer
> >  gets reset by a system sleep, then you have set the timeout too
> > long.
> 
> It isn't reset, it simply hasn't timed out at the time I suspend.

On the contrary, it is reset.  See below.

> This isn't very hard to do with even only a 5 minute auto suspend
> delay.  If I do something with the disk then suspend the whole system
> 3 minutes later, it would spin up again when I resume even though I
> finished my use of the disk before suspending the system.

Right.  If you hadn't put the whole system to sleep, the disk would
have gone into runtime suspend 2 minutes later (assuming you didn't use
it in the meantime).  Whereas since you did put the whole system to
sleep, the disk will go into runtime suspend 5 minutes after the system
wakes up -- not 2 minutes later.  I.e., the timer has been reset from 2 
minutes back to 5.

How is the kernel supposed to know that you finished using the disk
before suspending the system?  After all, by setting the autosuspend
timeout to 5 minutes, you have already told the kernel to keep the disk
spun up if it has been used any time in the last 5 minutes, and you
used it only 3 minutes ago.  As far as the kernel can tell, you still
want the disk to be spun up and ready for use.  That remains true at 
the time of the system resume.

> > Now, a more reasonable argument might be that for some disks, the 
> > kernel doesn't need to do an explicit spin-up or spin-down (for
> > runtime suspend) at all; instead we can rely on the drive's
> > internal power management.  In fact there already is a
> > "manage_start_stop" attribute to control this.  (Well, almost -- if
> > the attribute is set to 0 then the kernel won't issue a spin-down
> > command even for system suspend.)
> 
> This flag is broken and unusable and should be removed.

Not at all.

>  First, SCSI
> disks *require* the start command after a suspend, and secondly, not
> stopping the drive before suspend causes an emergency head retract,
> which damages the drive.

You're forgetting that the same sd driver manages other types of 
devices than disk drives.  Card readers and USB flash drives have no 
heads to retract and no spinning platters.  They don't need START STOP 
commands (in fact, some of them probably would crash if they received 
such a command).

> > I don't understand.  Under what circumstances would this happen?
> > Are you saying this would happen during system resume?  Why would
> > the disk spin up of its own accord at that time?
> 
> By default, ATA disks spin up on their own when they are powered on.

Irrelevant, unless you are also claiming that all ATA disks always get
powered on whenever the system resumes, something which is not at all
evident to me.  Particularly if the disk was in runtime suspend before
the system went to sleep.

> > And if it does spin up of its own accord, what makes you think the
> >  kernel can do anything to prevent it from spinning up?
> 
> It can't.  What it should do is notice when this has happened and not
> claim the device is runtime suspended when it is in fact, spinning.

Now I'm really getting confused.  Here, you are saying that ATA disks
will always spin up, all by themselves, whenever the system resumes,
and there's nothing the kernel can do to prevent it.  But earlier you
wrote:

> Sure, if that is your *only* goal.  I also want the disk to not spin
> up *at all* if possible.  There's no sense spinning up all of your
> disks every time you resume when you very rarely access some of them.

Isn't this a contradiction?  Or are you making a distinction between 
ATA and non-ATA disks?

Alan Stern

