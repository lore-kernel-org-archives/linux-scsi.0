From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] scsi: sd: set ready_to_power_off for scsi disk
Date: Fri, 14 Sep 2012 09:15:18 +0100
Message-ID: <1347610518.2794.9.camel@dabdike.int.hansenpartnership.com>
References: <Pine.LNX.4.44L0.1209131213450.21932-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1209131213450.21932-100000@netrider.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.de>, Aaron Lu <aaron.lu@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lwe@gmail.com>, Jack Wang <jack_wang@usish.com>, Shane Huang <shane.huang@amd.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-09-13 at 12:24 -0400, Alan Stern wrote:
> On Thu, 13 Sep 2012, Oliver Neukum wrote:
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
> It sounds like James is partly concerned about efficiency.

Sort of, but my main worry is correctness: I don't want a path in
runtime suspend that requires a cache flush to be dependent on the flush
being in a path which doesn't because efficiency dictates that at some
time or other the unnecessary flush will get removed (and then we'll
start corrupting data).

>   If Lin
> Ming's patches are merged then we will be doing runtime suspend
> relatively often, not just when the device file is closed.  The
> sd_suspend routine should know when SYNCHRONIZE CACHE is needed and
> when it can be skipped.

Keeping the flush in sd_suspend and making sure we know when to use it
would be fine by me as well ... I just need all the independent runtime
suspend patch authors to agree on this scheme.

> >From what I gather of this discussion, we can avoid flushing the cache 
> during (1) a runtime suspend provided (2) the drive isn't going to be 
> powered down.  If either (1) or (2) doesn't hold then the cache needs 
> to be synchronized.
> 
> The problem with relying on the internal timers and the power
> management mode page is that the transitions take place automatically
> and the host system doesn't know about them.  We _want_ to know about
> them so that the higher layers of the device tree can go to low power
> when the disk does.

Sigh ... the standards guys didn't help there then, since SPC-4
specifically says there will be no notifications.

> On the other hand, perhaps sd_suspend/sd_resume could use the mode page
> by telling it to go into or out of Stopped mode immediately.

That's perfectly legal.  Even if you use timer based power state
management afforded by the mode page you can still preempt the timer
with an explicit go into this power state command.

James


