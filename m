From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [Linux-usb-users] USB floppy drive no longer works under 2.6.15-rc6
Date: Tue, 10 Jan 2006 09:38:30 -0800
Message-ID: <20060110173830.GA7022@one-eyed-alien.net>
References: <20060110051516.GA20407@one-eyed-alien.net> <Pine.LNX.4.44L0.0601101034590.5060-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:55192 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S932256AbWAJRiv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jan 2006 12:38:51 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0601101034590.5060-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Phil Dibowitz <phil@ipom.com>, Jan De Luyck <lkml@kcore.org>, SCSI development list <linux-scsi@vger.kernel.org>


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 10, 2006 at 10:50:15AM -0500, Alan Stern wrote:
> [Moved to linux-scsi]
>=20
> On Mon, 9 Jan 2006, Matthew Dharm wrote:
>=20
> > A long time ago, I noticed a quirk of the UFI specification in regards =
to
> > one of the options for how to indicate a LUN isn't there.  Something ab=
out
> > a special PDT, I think, in the INQUIRY respose.  I don't recall the
> > details, but I do recall thinking something along the lines of "that's
> > odd.. and it's going to confuse the SCSI core."
> >=20
> > If I can find some time to search for that oddity of spec, then modify =
the
> > UFI protocol handler to translate that oddity into a result code the SC=
SI
> > core can understand, you can close the #2 case.
>=20
> I see what you mean.  The UFI spec requires a device to return 0x1f in the
> first byte of the INQUIRY response if no device is present at the LUN. =
=20
> That's Peripheral Qualifier =3D 0 and PDT =3D 0x1f (unknown or no device)=
. =20
> Now SCSI-2 requires the value to be 0x7f to indicate no device, but UFI
> also requires the returned SCSI level to be 0, and I don't know what
> SCSI-0 says about reporting no device at a LUN.

SCSI-0 doesn't exist.  SCSI level 0 means "not really SCSI".

> Does anybody among the SCSI developers have the answer?  Should=20
> scsi_probe_and_add_lun() check for (result[0] & 0x1f) =3D=3D 0x1f wheneve=
r=20
> (result[2] & 0x07) =3D=3D 0?
>=20
> If not, perhaps usb-storage should alter the returned value and max_lun
> for a UFI device whenever we see 0x1f.

That was my intention.  I've just never gotten around to doing it and
testing it.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Ye gods! I have feet??!
					-- Dust Puppy
User Friendly, 12/4/1997

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDw/EWHL9iwnUZqnkRAms/AJ9/hvw5QaEdxlGE0EGZ6W05wgdPBACfRU7Z
VlfK6RjX3mEyQJeXWCl4gsg=
=PeBv
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
