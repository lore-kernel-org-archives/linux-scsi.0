From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/2] scsi: sd: set ready_to_power_off for scsi disk
Date: Thu, 13 Sep 2012 12:24:46 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1209131213450.21932-100000@netrider.rowland.org>
References: <1791163.r67kWVIx1R@linux-lqwf.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1791163.r67kWVIx1R@linux-lqwf.site>
Sender: linux-ide-owner@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Aaron Lu <aaron.lu@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lwe@gmail.com>, Jack Wang <jack_wang@usish.com>, Shane Huang <shane.huang@amd.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 13 Sep 2012, Oliver Neukum wrote:

> > > > Well, I don't like the way the interaction of the patches is going.
> > > > You're the one proposing powering down the device outside of the
> > > > standards defined transitions, so you need to be responsible for the
> > > > actions that necessitates, including synchronizing the cache.  The specs
> > > > (SPC-4) say that cache management is explicitly unnecessary for the
> > > > standard SCSI power states (Active, Idle, Standby and Stopped), so
> > > > someone at some point is going to read that and remove the unnecessary
> > > > cache sync in the code.  When that happens, you'll start getting data
> > > > loss.
> > > 
> > > The cache is handled identically in sd_suspend() and sd_shutdown().
> > > In fact sd_shutdown() will skip handling it if the device has already been
> > > suspended, so the assumption is built into the code and has been so
> > > for a long time.
> > > 
> > > Though it wouldn't hurt to add a comment that says that the system going
> > > to S3 or S4 will cut power to a lot of disk so that the cache needs to be synced
> > > even if the spec says we need not. Runtime PM doesn't much alter the
> > > situation.
> > 
> > I think you're confusing two things.  Sleep states (S3 and S4) aren't
> > spec'd in SCSI, so we have to take care of everything (including the
> > cache before power off) because they're done invisibly to the disk.  The
> 
> Yes, but this confusion is necessary. The driver core is supposed to
> be generic and knows strictly speaking only suspended and active.
> It is a driver's job to do what needs to be done and translate this
> into the appropriate device states.

Currently the sd driver's suspend routine is not very sophisticated.  
It needs to become smarter about the differences between system
suspend, runtime suspend, and power off.

> > same tends to go for link power management, which was previously our
> > only form of runtime PM, but which doesn't actually affect the disk at
> > all and, of course, ACPI power off of devices (ZPDD).
> 
> The latter however does cut power to the drive. So the driver should do
> what it does when other operations that affect power are done.
> 
> > Disk runtime power states are defined in the standard and so we rely on
> > the standard taking care of the cache.  I suspect the most efficient use
> > may be via the power management mode page, which does everything
> > automatically on timers (you just get to set the timer interval, plus
> > some transports *may* require an initialising command which we already
> > have some provision for) than doing it all ourselves from block.
> 
> Well, yes, but we need support modes of power management that cut off
> power to the disk in any case, so what does it matter if we also do it for
> runtime PM?
> 
> Are you concerned about layering?

It sounds like James is partly concerned about efficiency.  If Lin
Ming's patches are merged then we will be doing runtime suspend
relatively often, not just when the device file is closed.  The
sd_suspend routine should know when SYNCHRONIZE CACHE is needed and
when it can be skipped.

>From what I gather of this discussion, we can avoid flushing the cache 
during (1) a runtime suspend provided (2) the drive isn't going to be 
powered down.  If either (1) or (2) doesn't hold then the cache needs 
to be synchronized.

The problem with relying on the internal timers and the power
management mode page is that the transitions take place automatically
and the host system doesn't know about them.  We _want_ to know about
them so that the higher layers of the device tree can go to low power
when the disk does.

On the other hand, perhaps sd_suspend/sd_resume could use the mode page
by telling it to go into or out of Stopped mode immediately.

Alan Stern

