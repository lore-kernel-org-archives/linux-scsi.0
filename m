From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-usb-devel] question on flushing buffers and spinning down disk
Date: Fri, 28 Sep 2007 23:33:14 +0200
Message-ID: <200709282333.15203.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0709281101460.4062-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out001.kontent.com ([81.88.40.215]:54163 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223AbXI1VcK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Sep 2007 17:32:10 -0400
In-Reply-To: <Pine.LNX.4.44L0.0709281101460.4062-100000@iolanthe.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Pavel Machek <pavel@ucw.cz>, linux-usb-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Am Freitag 28 September 2007 schrieb Alan Stern:
> On Fri, 28 Sep 2007, Oliver Neukum wrote:
>=20
> > Am Donnerstag 27 September 2007 schrieb Alan Stern:
> > > There's also a philosophical objection. =A0Who is in a better pos=
ition to
> > > judge when a device like a SCSI drive should be autosuspended: it=
s own
> > > driver (sd) or someone else (usb-storage)?
> >=20
> > Then a philosophical answer. The highest entity which understands w=
hat
> > it is doing when using power management. Highest here to be underst=
ood
> > not as a position in the device tree, but in the flow of informatio=
n.
>=20
> In this sense, sd is higher than usb-storage, right?  Because I/O
> requests pass through sd first, then usb-storage, on their way to the=
=20
> device.

Yes, but sr doesn't know hardware.

> My point is that when dealing with SCSI disks, sd understands the=20
> implications of Power Management better than usb-storage does. =20
> Similarly, when dealing with SCSI cd drives, sr understands the=20
> implications of Power Management better than usb-storage.

No. The capabilities of the hardware are determined by USB.
USB imposes two strict rules.

1. The host cannot talk to a suspended device (keeping it suspended)
2. Power consumption is very limited

It makes no sense to talk about power management of devices as
such. You need to talk about devices on the bus type they are connected
to.
=20
> Hence by your own argument, the SCSI high-level drivers should be=20
> responsible for autosuspending their respective devices.  usb-storage=
,=20
> on the other hand, should be responsible only for suspending the=20
> transport, since that's what it does understand.

The weakest link of the chain determines the whole.
=20
> > That is in our case usb-storage. Sr or sd can't do it because they =
don't
> > and can't understand power management.
>=20
> That's simply not true.  If sd didn't understand Power Management the=
n=20
> sd_suspend() and sd_resume() would be empty.

It understands on and off. The methods simply do what is to be done
to safely switch off a disk.
=20
> > Now they might be asked to provide some helpers. An open count and
> > notifications about the state of the queue would be obvious. Other
> > suggestions?
>=20
> I still think you're trying to go about it all backwards.

I am using the point where the logical flow of information and the devi=
ce
tree diverge.

	Regards
		Oliver
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
