From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v9 07/10] block: add a new interface to block events
Date: Sun, 18 Nov 2012 21:07:22 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1211182058450.10879-100000@netrider.rowland.org>
References: <20121118233531.GC25790@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20121118233531.GC25790@mtj.dyndns.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Aaron Lu <aaron.lu@intel.com>, Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 18 Nov 2012, Tejun Heo wrote:

> Hey, Alan.

Hey...

> It's controlled by /sys/class/scsi_host/hostX/link_power_management.
> Once enabled, the power saving is completedly handled by hardware.  If
> link stays idle longer than certain duration, the hardware initiates
> low power state and leaves it when something needs to happen.
> 
> > > So, this whole autopm thing doesn't sound like a good idea to me.
> > 
> > No doubt it's better suited to some devices than to others.
> 
> Yeah, SATA seems to need a different approach than USB.

Based on your description, I agree.

> > That may be true for SATA.  For USB optical drives, it does make sense
> > to power-down the host controller when the drive isn't in use.  USB
> > suspend/resume takes on the order of 50-100 ms or so.
> 
> I see.  For SATA too, the controller / link bring up doesn't take too
> long.  The crappy part is what the attached, especially ATAPI, devices
> would do after such events as those events will be visible to them
> basically as random link resets.
> 
> So, at least for SATA, I think what autopm can do is...
> 
> * Trigger zpodd if possible.
> 
> * Trigger suspend iff polling isn't happening on the device.

That sums it up nicely.  Of course, the PM core is unaware of details
such as media polling.  What we can do is have the SATA runtime-idle
method return -EBUSY if the device isn't a ZPODD and if polling is
enabled.  Unfortunately I don't think there's any way currently to
trigger autopm when the user turns off polling.  Maybe something could
be added to the appropriate sysfs handler.

Alan Stern

