From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Fri, 2 Apr 2010 10:36:25 -0700
Message-ID: <20100402173625.GB4864@xanatos>
References: <t2t59ca64281004020609sa0f67f0dj5c127e3f0b2e4db2@mail.gmail.com>
 <Pine.LNX.4.44L0.1004021010130.1615-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:9076 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755683Ab0DBRgt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Apr 2010 13:36:49 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1004021010130.1615-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jonas Schwertfeger <jschwertfeger@gmail.com>, Kay Sievers <kay.sievers@vrfy.org>, Douglas Gilbert <dgilbert@interlog.com>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>

On Fri, Apr 02, 2010 at 10:12:35AM -0400, Alan Stern wrote:
> On Fri, 2 Apr 2010, Jonas Schwertfeger wrote:
>=20
> > Actually, you hit the nail on the head Kay. I moved the hdparm rule
> > out of the way and voil=E0, the drive mounts. I then manually ran h=
dparm
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
>=20
> > Does anyone know why the drive would not be able to cope with this
> > command?
>=20
> No idea.  Except that it's probably not the drive's fault, but rather=
=20
> the fault of the USB-(S)ATA chip that controls the drive.
>=20
> > And also, why does it not choke on it in USB 2.0 mode but
> > only in USB 3.0?
>=20
> That's easy: It chokes in USB-2.0 mode also.  But the ehci-hcd
> driver is able to reset the drive and recover, whereas xhci-hcd has n=
ot=20
> yet implemented reset.  Hence no recovery is possible.

The xhci-hcd driver in 2.6.32 doesn't support configured device reset,
but it was added in 2.6.33.  So an update to a later kernel should allo=
w
the device to work in USB 3.0 mode.

Sarah Sharp
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
