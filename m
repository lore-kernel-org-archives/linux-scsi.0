From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Mon, 20 Jan 2003 21:48:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301202148.23210.oliver@neukum.name>
References: <10426732153816@kroah.com> <3E2C3380.3070700@splentec.com> <3E2C5750.2040301@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E2C5750.2040301@pacbell.net>
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>, Luben Tuikov <luben@splentec.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Am Montag, 20. Januar 2003 21:08 schrieb David Brownell:
> Luben Tuikov wrote:
> >> The way this should work is that the LLD calls scsi_remove_device(), and
> >> that cuts off the flow of commands.  The LLD can promise to error-out
> >> any pending commands in the device command queue.
> >
> > I take it you mean that the transport will tell the LLDD that the device
> > is gone and it (LLDD) call the one above, SCSI Core to remove the device.
> >
> > Hmm, more thinking needs to be done here, as shouldn't this be handled
> > by hotplugging? I.e. Targets do not *initiate* events.
>
> Not exactly, but the bus driver ("transport"?) certainly does initiate
> reports like "here's a new device on the bus" or "that device is gone".
> That's when hotplugging kicks in (both in-kernel and in-userland).
>
> And the only way to access a device ("target") on the bus is to give a
> request to that bus driver.  If, when servicing that request, the bus
> driver notices the device is gone ... that can act a lot like a device
> initiating a "device gone" event would look.

Correct. As a LLDD is the lowest layer, these are equivalent thing.
Only a LLDD can positively detect a device or a bus going away.

> > The transport can notify that the device is gone, but an ULP entity will
> > call scsi_remove_device() not the other way around.
>
> That's how USB works today:  khubd shuts things down.  Device drivers
> get disconnect() callbacks, just as when their modules are removed.
>
> EXCEPT that "khubd" is part of usbcore (roughly analagous to parts
> of the scsi mid-layer) ... so the drivers acting as host side proxies
> for the target hardware ("usb device") are purely reactive.  Their
> only roles in hotplug scenarios are to bind to devices (when a new
> one appears, using probe callbacks) or unbind from them (when one
> goes away, using disconnect callbacks).

That model cannot be applied to SCSI as it is much more diverse
in the number of bus types it supports.
USB can do it, because it knows about hubs. SCSI cannot,
as there are no hubs in SCSI.

> Those disconnect() callbacks have a few key responsibilities, very
> much including shutting down the entire higher level I/O queue to
> that device.  I think you're saying that SCSI drivers don't have
> such a responsibility (unlike USB or PCI) ... if so, that would
> seem to be worth changing.

If the scsi layer cannot on its own detect that a device or a bus is gone,
there'll be no sense in having a callback. It's just a complication.

	Regards
		Oliver

