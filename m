From: Kurt Garloff <garloff@suse.de>
Subject: Re: WWID / SerialNo in sysfs?
Date: Tue, 10 Feb 2004 01:19:28 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040210001928.GE4538@tpkurt.garloff.de>
References: <20040209160856.GS3944@tpkurt.garloff.de> <1076343628.1804.19.camel@mulgrave> <20040209162906.GV3944@tpkurt.garloff.de> <20040209090421.B1568@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="19uQFt6ulqmgNgg1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:52129 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S265634AbUBJAU6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Feb 2004 19:20:58 -0500
Content-Disposition: inline
In-Reply-To: <20040209090421.B1568@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Linux SCSI list <linux-scsi@vger.kernel.org>


--19uQFt6ulqmgNgg1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Patrick,

On Mon, Feb 09, 2004 at 09:04:21AM -0800, Patrick Mansfield wrote:
> On Mon, Feb 09, 2004 at 05:29:06PM +0100, Kurt Garloff wrote:
> > As you know I have everything in scsidev as well already since long ;-)
> > Nice code duplication though ...
>=20
> Yes ;-)=20
>=20
> I was hoping you were supporting scsidev as backward compatible with 2.6,
> and you could get users to migrate to udev + scsi_id.

Yes, that's indeed my plan.

Make sure previous scsidev users can live with it on 2.6 without much
change and make sure future users go to udev + scsi_id.

> I made scsi_id as an only functional with sysfs (only 2.6), and it must be
> disconnected from the naming done by udev. Plus, disconnecting it from the
> naming means it can be used by multipath configuration code.

Well, accessing devices by persistent names, you'll normally want=20
to offer the three:
(a) naming by path
(b) naming by device identifier: Serial/WWID
(c) naming by contents (uuid)

All of them could be useful, think about backups, multipathing, ...

scsidev provided (a) and (b).

But for the name by path (a), scsidev used the driver name to have=20
some protection against scsi host renumbering (or PCI bus changes ...)

Thus my patch to export the names.

> Also it gets model + vendor via sysfs, mainly to avoid potential issues
> avoided in scsi_scan.c when sending a standard INQUIRY (well, AFAICT no
> one is using BLIST_INQUIRY_36 or BLIST_INQUIRY_58, but if they did, it
> avoids those issue). This still saves an extra INQUIRY command from being
> sent to the device.

scsidev does parse sysfs as well nowadays.=20
I'll release 2.32 in a few seconds, where it even works well with 2.6.x.
(2.31 was geared to work with 2.6.0-test1, but too much changed since
 then.)

In 2.4, it parsed /proc/scsi/scsi, but I had to add some extensions to=20
relate the information there to highlevel drivers ;-)

> Being able to store the serial number in the udev database would be nice,
> since we potentially have multiple users: standard interface (upper level
> driver sd/sr/st/osst), sg, and multipath. We could store it into a sysfs
> scsi_device attribute, but I am not pushing for that, and for now would
> rather have the same commands sent multiple times.

Well, the relation sg device to highlevel driver is useful to know.

> Also has these items that could be done in scsidev:
>=20
> - a white/black list text file, so we don't need to rebuild a kernel or
>   recompile the user binary to add or remove devices from the lists

I don't understand what you're telling me here.

> - page 0x80 support

It's there.

> - supports page 0x83 types 0 (vendor specific) and 1 (T10 vendor
>   identification).

scsidev currently supports EUI-64 (2) and the 8byte NAA formats (the=20
latter by just treating them as opaque 64bit quantities). The limitation
is that it's internally represented as 64bit number. I would need to
convert this to a string ...

> > The nontrivial thing was always to make the relation sg/sd/... device
> > to C:B:T:U tuple. With sysfs it's at least possible to do that in
> > a reliable way.
>=20
> As James said we can send SG_IO commands to sd, plus all of the upper
> level drivers, the only one not yet completed is osst.

As long as sg is there and has it's uses, you want to know the relations
between the sg devices and the high level scsi devices.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--19uQFt6ulqmgNgg1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAKCOPxmLh6hyYd04RAkStAJ91bPxXHJo7aiBSGIWVAknQmsSQSgCcC3mX
4ReT5+52yMhtT2GXjLj82qA=
=JRGt
-----END PGP SIGNATURE-----

--19uQFt6ulqmgNgg1--
