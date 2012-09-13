From: Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH 1/2] scsi: sd: set ready_to_power_off for scsi disk
Date: Thu, 13 Sep 2012 14:34:28 +0200
Message-ID: <1791163.r67kWVIx1R@linux-lqwf.site>
References: <1347522049-1836-1-git-send-email-aaron.lu@intel.com> <39641980.Xo4Ylv7ahU@linux-lqwf.site> <1347533467.2720.45.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1347533467.2720.45.camel@dabdike.int.hansenpartnership.com>
Sender: linux-acpi-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Aaron Lu <aaron.lu@intel.com>, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lwe@gmail.com>, Jack Wang <jack_wang@usish.com>, Shane Huang <shane.huang@amd.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thursday 13 September 2012 11:51:07 James Bottomley wrote:
> On Thu, 2012-09-13 at 12:16 +0200, Oliver Neukum wrote:
> > On Thursday 13 September 2012 10:26:44 James Bottomley wrote:
> > > On Thu, 2012-09-13 at 17:07 +0800, Aaron Lu wrote:
> > 
> > > > So I think this is basically 2 things, one is the runtime suspend of the
> > > > disk, another is when it is runtime suspended, how to remove its power.
> > > > I'm currently doing the latter one, which is simpler, so I want to do it
> > > > first :-)
> > > 
> > > Well, I don't like the way the interaction of the patches is going.
> > > You're the one proposing powering down the device outside of the
> > > standards defined transitions, so you need to be responsible for the
> > > actions that necessitates, including synchronizing the cache.  The specs
> > > (SPC-4) say that cache management is explicitly unnecessary for the
> > > standard SCSI power states (Active, Idle, Standby and Stopped), so
> > > someone at some point is going to read that and remove the unnecessary
> > > cache sync in the code.  When that happens, you'll start getting data
> > > loss.
> > 
> > The cache is handled identically in sd_suspend() and sd_shutdown().
> > In fact sd_shutdown() will skip handling it if the device has already been
> > suspended, so the assumption is built into the code and has been so
> > for a long time.
> > 
> > Though it wouldn't hurt to add a comment that says that the system going
> > to S3 or S4 will cut power to a lot of disk so that the cache needs to be synced
> > even if the spec says we need not. Runtime PM doesn't much alter the
> > situation.
> 
> I think you're confusing two things.  Sleep states (S3 and S4) aren't
> spec'd in SCSI, so we have to take care of everything (including the
> cache before power off) because they're done invisibly to the disk.  The

Yes, but this confusion is necessary. The driver core is supposed to
be generic and knows strictly speaking only suspended and active.
It is a driver's job to do what needs to be done and translate this
into the appropriate device states.

> same tends to go for link power management, which was previously our
> only form of runtime PM, but which doesn't actually affect the disk at
> all and, of course, ACPI power off of devices (ZPDD).

The latter however does cut power to the drive. So the driver should do
what it does when other operations that affect power are done.

> Disk runtime power states are defined in the standard and so we rely on
> the standard taking care of the cache.  I suspect the most efficient use
> may be via the power management mode page, which does everything
> automatically on timers (you just get to set the timer interval, plus
> some transports *may* require an initialising command which we already
> have some provision for) than doing it all ourselves from block.

Well, yes, but we need support modes of power management that cut off
power to the disk in any case, so what does it matter if we also do it for
runtime PM?

Are you concerned about layering?

	Regards
		Oliver

