From: James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Fri, 02 Apr 2010 10:41:07 -0400
Message-ID: <1270219267.2899.73.camel@mulgrave.site>
References: <Pine.LNX.4.44L0.1004021010130.1615-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1004021010130.1615-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Jonas Schwertfeger <jschwertfeger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, David Zeuthen <david-o55+BOBDEFg@public.gmane.org>, linux-hotplug-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2010-04-02 at 10:12 -0400, Alan Stern wrote:
> On Fri, 2 Apr 2010, Jonas Schwertfeger wrote:
>=20
> > Actually, you hit the nail on the head Kay. I moved the hdparm rule
> > out of the way and voil=C3=A0, the drive mounts. I then manually ra=
n hdparm
> > on the device:
> >=20
> > sudo hdparm --verbose /dev/sdb
> >=20
> > /dev/sdb:
> > outgoing cdb:  85 08 2e 00 00 00 00 00 00 00 00 00 00 40 ec 00
> > SG_IO: ATA_16 status=3D0x0, host_status=3D0x7, driver_status=3D0x0
> > SG_IO: bad response (not CHECK_CONDITION)
> > outgoing cdb:  85 08 2e 00 00 00 00 00 00 00 00 00 00 40 a1 00
> > SG_IO: ATA_16 status=3D0x0, host_status=3D0x7, driver_status=3D0x0
> > SG_IO: bad response (not CHECK_CONDITION)
> >  HDIO_DRIVE_CMD(identify) failed: Invalid exchange
> >  readonly      =3D  0 (off)
> >  readahead     =3D 256 (on)
> >  geometry      =3D 36365/64/32, sectors =3D 0, start =3D 0
> >=20
> > Does the command sent by hdparm look familiar? Exactly, it is the
> > third ATA command (IDENTIFY DEVICE) we discovered earlier and cause=
d
> > the drive to stall.
>=20
> That's nice to know.  Other people have been reporting similar=20
> problems.  Now we can tell where they come from.

Yes ... I think we're starting to need to get a handle on all these
userspace random pokes which can disrupt (the admittedly badly written
and badly tested) devices which the kernel tries so hard not to upset.

> > Does anyone know why the drive would not be able to cope with this
> > command?
>=20
> No idea.  Except that it's probably not the drive's fault, but rather=
=20
> the fault of the USB-(S)ATA chip that controls the drive.

Best guess (and it's a guess only) would be that the USB bridge SAT
layer doesn't implement ATA_16 and so fails in interesting ways when it
comes in.  Does the ATA_12 version of IDENTIFY DEVICE succeed?

James

> > And also, why does it not choke on it in USB 2.0 mode but
> > only in USB 3.0?
>=20
> That's easy: It chokes in USB-2.0 mode also.  But the ehci-hcd
> driver is able to reset the drive and recover, whereas xhci-hcd has n=
ot=20
> yet implemented reset.  Hence no recovery is possible.
>=20
> Alan Stern
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
