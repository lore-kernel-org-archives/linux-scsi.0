From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 07/10] block: add a new interface to block events
Date: Sun, 18 Nov 2012 13:56:57 -0800
Message-ID: <20121118215657.GA25790@mtj.dyndns.org>
References: <20121118150555.GL7306@mtj.dyndns.org>
 <Pine.LNX.4.44L0.1211181221350.4991-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1211181221350.4991-100000@netrider.rowland.org>
Sender: linux-pm-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lu@intel.com>, Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, Alan.

On Sun, Nov 18, 2012 at 12:41:06PM -0500, Alan Stern wrote:
> >  If so (I can't see how
> > else it would behave), it may not really work.  I mean, you would be
> > spending about ten seconds reinitiaizing everything and then enter
> > sleep and do it all over again two seconds later, most likely wasting
> > power in the process.  Sounds weird to me.  What am I missing?
> 
> Does it really take 10 seconds to recover from an ATA suspend?  That 
> sounds awfully long.

If it's using the same ->suspend ops as the regular system suspend,
10secs isn't a crazy number.  If the controller goes offline, the PHY
would go offline too and the only way to come back from that is
performing full probing sequence.  From SATA procotol POV, it isn't
too bad.  It's just link initiazliation followed by IDENTIFY and some
config commands.

The problem is that SATA devices aren't really designed to be used
like that.  If you reset a ODD w/ a media in it, it'll probably spin
it up and try to re-establish media state during probe sequence.  It
isn't designed that way and has never been used like that.  SATA has
its own dynamic link power management (DIPM/HIPM) tho.

So, this whole autopm thing doesn't sound like a good idea to me.

> The two second value is merely the default interval for media polling.  
> Devices with no async notification mechanism require some sort of
> polling if anybody wants to know when media is inserted or removed,
> and the polling can't be carried out if the device's port is suspended.

Yeah, I know.  I wrote that thing. :)

> You asked about autopm.  "Autopm" is a rather vague and ugly term I
> made up; it means that the kernel automatically suspends the device
> after some specified idle time.  In the case of optical drives, "idle"  
> currently means the device file is not open (which implies the drive
> doesn't contain a mounted filesystem).  As far as I know, the kernel
> has no direct way to affect the power level of an optical drive that
> isn't ZP.  For these devices "suspended" is merely a logical state,
> meaning that the device isn't in use and therefore its parent can be
> put into a low-power mode.
>
> Regardless, an optical drive can't remain suspended when polling
> occurs.  So unless there's some other mechanism for getting the
> information about media changes, suspended drives (and their parents)  
> will have to be resumed periodically for polling.
> 
> Hence there's a tradeoff.  How can we use the minimum amount of energy
> while still polling the drive acceptably often?  In general, the kernel
> doesn't know.  That's why these things can be controlled from
> userspace.  And the answer may be different for ATA drives vs.  
> USB-connected drives.
> 
> Does this answer your questions?

I think the only reason autopm doesn't blow up for SATA devices is
that userland usually automatically mounts them thus effectively
disabling autopm.  I *think* the only sane thing we can do is doing
autopm iff zpodd is available && no media.

Thanks.

-- 
tejun
