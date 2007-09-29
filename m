From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] question on flushing buffers and spinning down
 disk
Date: Sat, 29 Sep 2007 12:38:33 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0709291156460.29112-100000@netrider.rowland.org>
References: <200709282333.15203.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:1628 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756269AbXI2Qif (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2007 12:38:35 -0400
In-Reply-To: <200709282333.15203.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: Pavel Machek <pavel@ucw.cz>, linux-usb-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Fri, 28 Sep 2007, Oliver Neukum wrote:

> Am Freitag 28 September 2007 schrieb Alan Stern:
> > On Fri, 28 Sep 2007, Oliver Neukum wrote:
> >=20
> > > Am Donnerstag 27 September 2007 schrieb Alan Stern:
> > > > There's also a philosophical objection. =A0Who is in a better p=
osition to
> > > > judge when a device like a SCSI drive should be autosuspended: =
its own
> > > > driver (sd) or someone else (usb-storage)?
> > >=20
> > > Then a philosophical answer. The highest entity which understands=
 what
> > > it is doing when using power management. Highest here to be under=
stood
> > > not as a position in the device tree, but in the flow of informat=
ion.
> >=20
> > In this sense, sd is higher than usb-storage, right?  Because I/O
> > requests pass through sd first, then usb-storage, on their way to t=
he=20
> > device.
>=20
> Yes, but sr doesn't know hardware.

I don't know what that's supposed to mean.  And whatever that means, it
must be equally true that usb-storage doesn't know CD drives.  Or disk
drives, or flash memories, or SCSI tape drives, or ...  On the whole,
I'd say that usb-storage's lack of knowledge about SCSI devices greatly
outweighs sr's lack of knowledge about hardware.


> > My point is that when dealing with SCSI disks, sd understands the=20
> > implications of Power Management better than usb-storage does. =20
> > Similarly, when dealing with SCSI cd drives, sr understands the=20
> > implications of Power Management better than usb-storage.
>=20
> No. The capabilities of the hardware are determined by USB.
> USB imposes two strict rules.
>=20
> 1. The host cannot talk to a suspended device (keeping it suspended)
> 2. Power consumption is very limited
>=20
> It makes no sense to talk about power management of devices as
> such. You need to talk about devices on the bus type they are connect=
ed
> to.

You forget that the USB bus ends at the USB interface chip on the
device.  From there on it's a different sort of bus.  It might be ATA,
as in commonly-available USB-ATA converter boxes.  It might be a
genuine SCSI bus, as in some USB-SCSI bridges.  It might be an internal
flash-memory "bus".  It might be a full-blown Linux gadget.  And so on.

The suspend done by usb-storage suspends only the USB part of the link.=
 =20
It might or might not affect anything beyond the device's USB chip,=20
depending on how the device was designed.

Your (1) is correct, since all communication must take place over the
USB link.  Your (2) is wrong -- the _link_'s power consumption is
indeed limited, but the _device_ could be self-powered and so its power
consumption need not be affected by the link state.  For instance in
the case of a USB-ATA drive enclosure, power consumption is affected
more by whether or not the disk is spinning than anything else.

> > Hence by your own argument, the SCSI high-level drivers should be=20
> > responsible for autosuspending their respective devices.  usb-stora=
ge,=20
> > on the other hand, should be responsible only for suspending the=20
> > transport, since that's what it does understand.
>=20
> The weakest link of the chain determines the whole.

We're talking about conserving energy, not destroying chains.  :-)

> > > That is in our case usb-storage. Sr or sd can't do it because the=
y don't
> > > and can't understand power management.
> >=20
> > That's simply not true.  If sd didn't understand Power Management t=
hen=20
> > sd_suspend() and sd_resume() would be empty.
>=20
> It understands on and off. The methods simply do what is to be done
> to safely switch off a disk.

That's arguable, at least as regards START-STOP UNIT.  Spinning down a
disk is more than just preparation; it is itself a power-saving
measure.

And anyway, that's beside the point.  The SCSI drivers do what they can
or what they must -- it's none of usb-storage's business.  All
usb-storage cares about is whether the link will be needed, and the
only code that can tell it is the code that uses the link -- i.e., the=20
SCSI drivers.


> > > Now they might be asked to provide some helpers. An open count an=
d
> > > notifications about the state of the queue would be obvious. Othe=
r
> > > suggestions?
> >=20
> > I still think you're trying to go about it all backwards.
>=20
> I am using the point where the logical flow of information and the de=
vice
> tree diverge.

I don't understand that.

Suppose we have devices A1 and A2, where A1 is the parent and A2 is the=
=20
child.  In order to pass between the CPU and A2, data must flow through=
=20
A1.  Let D1 and D2 be the drivers for A1 and A2.

It may be that for D2 to communicate with A2, it has to ask D1 to send=20
or receive the data for it.  Or it may be that once D1 has configured=20
A1, data can flow automatically through A1 with no need for further=20
involvement on D1's part.  Would you say that in either case the flow=20
of information has diverged from the device tree?

Suppose D1 decides that it wants to suspend A1, thus breaking the data
link to A2.  Shouldn't it get D2's permission first?  Better yet,
shouldn't it wait until D2 tells it: "Okay, A2 is safely suspended and
I'm not going to talk to it for a while, you can suspend the link"?

Alan Stern

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
