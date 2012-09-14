From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH 1/2] scsi: sd: set ready_to_power_off for scsi disk
Date: Fri, 14 Sep 2012 14:57:19 +0800
Message-ID: <20120914065717.GB5177@mint-spring.sh.intel.com>
References: <1791163.r67kWVIx1R@linux-lqwf.site>
 <Pine.LNX.4.44L0.1209131213450.21932-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1209131213450.21932-100000@netrider.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lwe@gmail.com>, Jack Wang <jack_wang@usish.com>, Shane Huang <shane.huang@amd.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 13, 2012 at 12:24:46PM -0400, Alan Stern wrote:
> > > Disk runtime power states are defined in the standard and so we rely on
> > > the standard taking care of the cache.  I suspect the most efficient use
> > > may be via the power management mode page, which does everything
> > > automatically on timers (you just get to set the timer interval, plus
> > > some transports *may* require an initialising command which we already
> > > have some provision for) than doing it all ourselves from block.
> > 
> > Well, yes, but we need support modes of power management that cut off
> > power to the disk in any case, so what does it matter if we also do it for
> > runtime PM?
> > 
> > Are you concerned about layering?
> 
> It sounds like James is partly concerned about efficiency.  If Lin
> Ming's patches are merged then we will be doing runtime suspend
> relatively often, not just when the device file is closed.  The
> sd_suspend routine should know when SYNCHRONIZE CACHE is needed and
> when it can be skipped.
> 
> From what I gather of this discussion, we can avoid flushing the cache 
> during (1) a runtime suspend provided (2) the drive isn't going to be 
> powered down.  If either (1) or (2) doesn't hold then the cache needs 
> to be synchronized.

Agree.

> 
> The problem with relying on the internal timers and the power
> management mode page is that the transitions take place automatically
> and the host system doesn't know about them.  We _want_ to know about
> them so that the higher layers of the device tree can go to low power
> when the disk does.

Looks like it's not easy to know when the device entered a low power
state. Constantly polling with request sense doesn't seem to be a good
idea.

This will make upper layer devices not able to enter runtime suspend
state and device's power can't be cut.

> 
> On the other hand, perhaps sd_suspend/sd_resume could use the mode page
> by telling it to go into or out of Stopped mode immediately.

BTW, is it necessary to issue the stop command before we cut its power
either due to runtime power off or system entering S3/S4/S5?

Thanks,
Aaron
