From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security in usb-storage driver
Date: Sat, 5 Nov 2005 15:55:22 -0800
Message-ID: <20051105235522.GA21733@one-eyed-alien.net>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF3F@WDSCEXBECL03.sc.wdc.com> <1131130707.3532.45.camel@mulgrave> <20051104203004.GF12384@one-eyed-alien.net> <1131137395.3532.57.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:44446 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S932223AbVKEXz3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Nov 2005 18:55:29 -0500
Content-Disposition: inline
In-Reply-To: <1131137395.3532.57.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Timothy Thelin <Timothy.Thelin@wdc.com>, t.schorpp@gmx.de, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 04, 2005 at 02:49:55PM -0600, James Bottomley wrote:
> On Fri, 2005-11-04 at 12:30 -0800, Matthew Dharm wrote:
> > > What happens if you prevent USB mangling the scsi_level?  I think, for
> > > the most part, we would handle 0 in about the same way as we handle 2.
> > > However, we could gate the if around the CDB[1] mangling as
> > >=20
> > > if (scsi_level !=3D SCSI_UNKNOWN && scsi_level <=3D SCSI_2)
> > >=20
> > > which should fix your problem, I think.
> >=20
> > A long time ago, usb-storage didn't mangle the scsi_level.  And almost
> > nothing worked.  Without a SCSI level, 6-byte commands get sent; only
> > 10-byte commands will do.
>=20
> That area of the scsi subsystem has been changed significantly ...
> mainly for usb storage.  I don't believe your assertion about
> SCSI_UNKOWN only producing 6 byte CDBs to be correct, the behaviour is
> now governed by two scsi_device flags: use_10_for_rw and use_10_for_ms
> which you can control in slave configure.
>=20
> Can you just try it with a modern kernel and see if anything still
> breaks?

I just realized this plan has a problem...

The reported SCSI level of a device is mostly garbage, but not always.
I've seen 0, 1, 2, 3, and 0xff all reported.  HOWEVER, the reported value
seems independent of what devices have vendor-specific commands (and thus
need the CDB[1] not messed with).

It is an interesting experiment to remove the force-to-SCSI_2 part of the
usb-storage code (on the general principal of "we shouldn't be messing with
the data passed through the driver), but it doesn't solve the original
question of needing a way to pass commands without CDB[1] getting altered.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Pitr!  That's brilliant!  Funded by Microsoft refunds.  What sweet irony!
					-- A.J.
User Friendly, 2/15/1999

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDbUZqHL9iwnUZqnkRAs4VAJ9EzOS76bPl9nnPvhxDnhVh0VwntACfTL4M
4e1dgHQ8u7Mf9hy3EkfdXIE=
=eP2N
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
