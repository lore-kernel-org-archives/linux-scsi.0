From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] question on flushing buffers and spinning down
 disk
Date: Thu, 27 Sep 2007 16:26:56 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0709271600200.7735-100000@iolanthe.rowland.org>
References: <200709272126.47558.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:59424 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754582AbXI0U05 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Sep 2007 16:26:57 -0400
In-Reply-To: <200709272126.47558.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Thu, 27 Sep 2007, Oliver Neukum wrote:

> > > 1. autosuspend should not be specific to USB
> > 
> > Correct.  Which means support for it should be added to the SCSI
> > drivers.  SCSI autosuspend shouldn't be kluged into usb-storage in a
> > way that basically ignores what the SCSI layer is doing.
> 
> It isn't. The decision to autosuspend is based on activity on the bus.
> Now you might argue that the decision to do an autosuspend should
> always propagate upwards from the lowest level of the device tree.
> Then I ask why?

Because that's how I have always thought of it...  :-)

You're right; there's no showstopping reason particular subsystems like
SCSI can't use a different approach.  However bus activity alone isn't
a sufficient criterion.  For example, suppose somebody sends a PLAY
AUDIO command to a SCSI cdrom drive.  There won't be any bus activity
while the music is playing, but the device will be active and so it
shouldn't be suspended.  Thus the sr driver would want to fail an
autosuspend call.

Anyway, if we do end up going this route then there should be a routine
added to the SCSI core which would call the suspend methods for all the
attached devices.  This doesn't belong in usb-storage (and even worse, 
it shouldn't be duplicated in all the other low-level drivers); rather,
usb-storage should simply be able to call the new routine.

Have you thought about how autoresume would fit into this picture?  I
don't think you can rely on usb-storage telling the SCSI core to resume
devices when it gets handed a command, because the commands to spin-up
the drives would have to be transmitted first.  (The sample patch you
posted will deadlock: The other command can't begin until the spin-up
command completes, and the spin-up command won't get sent to
usb-storage until the original command completes.)  In other words,
autoresume must be handled at the level of the SCSI core.

What happens if you want to autosuspend some of the devices on a SCSI
bus but not all of them?  Obviously usb-storage wouldn't be able to
handle that, since all it knows about is overall bus activity.

> > > 2. I like to view the generic SCSI code as a library
> > 
> > That viewpoint might work out okay in some cases, but I don't think 
> > it's tenable when dealing with high-level drivers like sd and sr.
> 
> sg worries me.

Let's not worry about it for now.

> > > 3. The low level drivers will have to decide whether to suspend devices,
> > > as the generic code doesn't know whether the bus is shared.
> > 
> > I'm having trouble understanding this; it's a bit ambiguous.  Does
> > "devices" mean "SCSI devices", "host adapter devices", or both?  Does
> 
> SCSI devices
> 
> > "generic code" refer to the SCSI core, the high-level SCSI drivers, or
> > something else?  When you say the bus is "shared", do you mean there
> > are multiple SCSI devices attached to it or do you mean something else?
> 
> No multiple hosts. Think Firewire or FibreChannel. We certainly cannot
> spin down a Firewire disk some other host is using just because we
> are done with it.

But what if no other hosts are attached?  Would you still want to avoid 
spinning down the disk?  Would the disk somehow have to become 
responsible for spinning itself down?  Anyway, this isn't usb-storage's 
problem.

(For that matter, do the Firewire or FibreChannel drivers know when
other hosts are sharing the bus?)

> > In any case, that's not how I would put it.  The SCSI core and
> > high-level drivers will have to decide when they are not using SCSI
> > devices and the devices can be suspended.  When all the devices the
> 
> Err, why? After all, there's a central instance in userspace that decides
> that the whole system isn't used right now. I see no reason to not use
> this model for parts of the device tree.

Autoresume is the major complication.

There's also a philosophical objection.  Who is in a better position to
judge when a device like a SCSI drive should be autosuspended: its own
driver (sd) or someone else (usb-storage)?

Alan Stern

