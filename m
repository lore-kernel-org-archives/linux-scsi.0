From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/2] scsi: sd: set ready_to_power_off for scsi disk
Date: Thu, 13 Sep 2012 16:46:29 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1209131639250.31536-100000@netrider.rowland.org>
References: <1787325.sGDVDNVD6E@linux-lqwf.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1787325.sGDVDNVD6E@linux-lqwf.site>
Sender: linux-acpi-owner@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Aaron Lu <aaron.lu@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lwe@gmail.com>, Jack Wang <jack_wang@usish.com>, Shane Huang <shane.huang@amd.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 13 Sep 2012, Oliver Neukum wrote:

> On Thursday 13 September 2012 12:24:46 Alan Stern wrote:
> > On Thu, 13 Sep 2012, Oliver Neukum wrote:
> 
> > > Yes, but this confusion is necessary. The driver core is supposed to
> > > be generic and knows strictly speaking only suspended and active.
> > > It is a driver's job to do what needs to be done and translate this
> > > into the appropriate device states.
> > 
> > Currently the sd driver's suspend routine is not very sophisticated.  
> > It needs to become smarter about the differences between system
> > suspend, runtime suspend, and power off.
> 
> In what way?

sd_suspend should know whether or not to issue the SYNCHRONIZE CACHE 
command.

> > It sounds like James is partly concerned about efficiency.  If Lin
> > Ming's patches are merged then we will be doing runtime suspend
> > relatively often, not just when the device file is closed.  The
> > sd_suspend routine should know when SYNCHRONIZE CACHE is needed and
> > when it can be skipped.
> 
> How? This depends on the hardware?

It depends partly on the hardware, partly on the type of suspend, and 
partly on the flag settings in sysfs.

> > From what I gather of this discussion, we can avoid flushing the cache 
> > during (1) a runtime suspend provided (2) the drive isn't going to be 
> > powered down.  If either (1) or (2) doesn't hold then the cache needs 
> > to be synchronized.
> 
> This is true, but how is it relevant?

This, or something like it, is the algorithm sd_suspend should use for 
determining whether or not to issue SYNCHRONIZE CACHE.

> > The problem with relying on the internal timers and the power
> > management mode page is that the transitions take place automatically
> > and the host system doesn't know about them.  We _want_ to know about
> > them so that the higher layers of the device tree can go to low power
> > when the disk does.
> 
> Why would you want that to correlate? The operation of the controller
> and the driver is independent of the state.

That's the problem -- I would like them not to be so independent.  The
reason stated above: If we know when the controller puts the drive in a
low-power state then we can tell the higher layers of the device tree
to go to low power at those times.

> And what would it tell us, as the driver knows aout all IO anyway?

But the driver doesn't know when the controller has spun down the disk.  
That's something else sd_suspend has to worry about.

Alan Stern

