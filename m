From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Mon, 20 Jan 2003 22:51:08 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301202251.08356.oliver@neukum.name>
References: <10426732153816@kroah.com> <200301202148.23210.oliver@neukum.name> <3E2C68F8.7080405@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E2C68F8.7080405@pacbell.net>
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: Luben Tuikov <luben@splentec.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Am Montag, 20. Januar 2003 22:24 schrieb David Brownell:
> Oliver Neukum wrote:
> > That model cannot be applied to SCSI as it is much more diverse
> > in the number of bus types it supports.
> > USB can do it, because it knows about hubs. SCSI cannot,
> > as there are no hubs in SCSI.
>
> Hubs are irrelevant here, the key functionality is noticing
> hardware addition/disconnect.  Parts of it can be done in bus
> adapter code, parts of it can't.  SCSI probes LUNS in much
> the same way khubd probes hub ports, and as I recall most of
> that logic isn't any more specific to the adapter than virtual
> root hub code is for USB.

I should be more specific.
The SCSI is different for several reasons:
- we are talking about bus as well as device detection
- there's no common way to probe for devices
  (the probing of LUNs works only on conventional busses)
- many SCSI devices are not really SCSI devices. They just use
  the command set

SCSI hotplug detection doesn't work for the same reason that USB
can handle only detection of devices by itself. Busses on the other
hand are not handled by USB itself.

> >>Those disconnect() callbacks have a few key responsibilities, very
> >>much including shutting down the entire higher level I/O queue to
> >>that device.  I think you're saying that SCSI drivers don't have
> >>such a responsibility (unlike USB or PCI) ... if so, that would
> >>seem to be worth changing.
> >
> > If the scsi layer cannot on its own detect that a device or a bus is
> > gone, there'll be no sense in having a callback. It's just a
> > complication.
>
> Erm ... which of the three SCSI layers are you talking about?  I was
> talking about the highest level, which is precisely the layer I think
> has been identified as already needing to know when to shut down the
> I/O queues (sd_mod and friends).

In SCSI view device and bus disconnection is recognised by the lowest
level. As it knows nothing about the high layers, it notifies the midlayer
which in turn notifies the high level drivers. What should a callback do?
The low level driver cannot do more than notify.
I don't see what the midlayer could do with a callback, but I defer judgement
here to the SCSI people, but definitely the LLDD has no use for a callback.

	Regards
		Oliver

