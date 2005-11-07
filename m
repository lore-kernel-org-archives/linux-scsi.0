From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security in usb-storage driver
Date: Mon, 7 Nov 2005 08:59:39 -0800
Message-ID: <20051107165939.GA26509@one-eyed-alien.net>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF3F@WDSCEXBECL03.sc.wdc.com> <1131130707.3532.45.camel@mulgrave> <20051104203004.GF12384@one-eyed-alien.net> <1131137395.3532.57.camel@mulgrave> <20051105235522.GA21733@one-eyed-alien.net> <1131238146.9430.7.camel@mulgrave> <20051106215856.GA28452@one-eyed-alien.net> <436E8394.2010600@gmx.de> <20051106235213.GA479@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:3527 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S964884AbVKGQ7z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Nov 2005 11:59:55 -0500
Content-Disposition: inline
In-Reply-To: <20051106235213.GA479@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: thomas schorpp <t.schorpp@gmx.de>, James Bottomley <James.Bottomley@SteelEye.com>, Timothy Thelin <Timothy.Thelin@wdc.com>, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 06, 2005 at 03:52:13PM -0800, Patrick Mansfield wrote:
> Black listing would cover more cases than adding back the SG_IO flag.
>=20
> Black listing USB devices is somewhat bad/tricky, since they often don't
> show up with registered vendor + model names, and use somewhat generic
> names, for example I have an xd reader that has vendor "Generic", model
> "STORAGE DEVICE".=20
>=20
> So either the hardware is stupid, or usb-storage generates those names and
> maybe everything is OK (simple search finds nothing in usb storage code).

The hardware is stupid.  Really, I'm not that stupid, even on my worst day.

It's worse than that, actually.  I've seen devices where the VID/PID is
that of the USB/IDE bridge vendor, and the INQUIRY gives "Generic".
There's really no way to programmatically distinguish one device from
another with high reliability.

> We do have some of those name in the current scsi devinfo table ... I hav=
en't
> looked for details on them or tried to figure out if they hurt any
> devices.
>=20
> Other potential methods besides black list based on vendor + model:
>=20
> 1) If (big if, i.e. unlikely) USB devices in general don't need
> the LUN in the cdb, we could black list all USB to skip the storing of it=
.=20

Nope.  It's pretty common to see 5/6/7-in-one media readers which are
multi-LUN.

> The majority of the (single LUN) USB devices probably never look
> at the field, so perhaps we could refine the above to:=20
>=20
> 2) Black list all usb devices that don't have multiple LUNs, assuming the
> never check the cdb for a LUN value.

Iffy.  Some single-LUN devices look at the LUN field, some don't.  I'd say
it's about a 60/40 split.

> I don't know if you can tell (in usb code) if usb mass storage is
> multi-lun or not without scanning for the other LUNs (normal SCSI devices
> would have to be scanned or sent a REPORT LUNS, and even then, they could
> show up with more LUNs in the future).

For the vast majority of USB storage devices (but not all), you can
determine this pretty well.  BBB devices support a GetMaxLUN command --
usb-storage uses it to set an internal variable, but it could be passed
elsewhere.

> 3) black list via usb storage based on usb id's, kind of like the handling
> in usb slave_configure for USB_VENDOR_ID_GENESYS, though a more general
> method would be better.

See my response to #1 above.  Vendors are, apparently, stupid -- at least
when it comes to making sure devices distinguish themselves in a nice
manner.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

We can customize our colonels.
					-- Tux
User Friendly, 12/1/1998

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDb4f7HL9iwnUZqnkRApvIAKCcrLit45/iC2Is3xraH/C+UeVK9gCgooRx
OAKSbD81hu5EhxjOqdPRFFk=
=zbnh
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
