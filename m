From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v9 07/10] block: add a new interface to block events
Date: Sun, 18 Nov 2012 18:28:24 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1211181822320.9225-100000@netrider.rowland.org>
References: <20121118215657.GA25790@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <20121118215657.GA25790@mtj.dyndns.org>
Sender: linux-pm-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Aaron Lu <aaron.lu@intel.com>, Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 18 Nov 2012, Tejun Heo wrote:

> > Does it really take 10 seconds to recover from an ATA suspend?  That 
> > sounds awfully long.
> 
> If it's using the same ->suspend ops as the regular system suspend,
> 10secs isn't a crazy number.  If the controller goes offline, the PHY
> would go offline too and the only way to come back from that is
> performing full probing sequence.  From SATA procotol POV, it isn't
> too bad.  It's just link initiazliation followed by IDENTIFY and some
> config commands.
> 
> The problem is that SATA devices aren't really designed to be used
> like that.  If you reset a ODD w/ a media in it, it'll probably spin
> it up and try to re-establish media state during probe sequence.  It
> isn't designed that way and has never been used like that.  SATA has
> its own dynamic link power management (DIPM/HIPM) tho.

Is it possible to use those to implement runtime suspend?  Or are they 
handled autonomously by the hardware?

> So, this whole autopm thing doesn't sound like a good idea to me.

No doubt it's better suited to some devices than to others.

> > Hence there's a tradeoff.  How can we use the minimum amount of energy
> > while still polling the drive acceptably often?  In general, the kernel
> > doesn't know.  That's why these things can be controlled from
> > userspace.  And the answer may be different for ATA drives vs.  
> > USB-connected drives.
> > 
> > Does this answer your questions?
> 
> I think the only reason autopm doesn't blow up for SATA devices is
> that userland usually automatically mounts them thus effectively
> disabling autopm.

Either that or else because it hasn't been fully implemented yet.  :-)

>  I *think* the only sane thing we can do is doing
> autopm iff zpodd is available && no media.

That may be true for SATA.  For USB optical drives, it does make sense
to power-down the host controller when the drive isn't in use.  USB
suspend/resume takes on the order of 50-100 ms or so.

Alan Stern

