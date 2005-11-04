From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security in usb-storage driver
Date: Fri, 4 Nov 2005 12:30:04 -0800
Message-ID: <20051104203004.GF12384@one-eyed-alien.net>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF3F@WDSCEXBECL03.sc.wdc.com> <1131130707.3532.45.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JwB53PgKC5A7+0Ej"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:8685 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S1750774AbVKDUaR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Nov 2005 15:30:17 -0500
Content-Disposition: inline
In-Reply-To: <1131130707.3532.45.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Timothy Thelin <Timothy.Thelin@wdc.com>, t.schorpp@gmx.de, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>


--JwB53PgKC5A7+0Ej
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 04, 2005 at 12:58:27PM -0600, James Bottomley wrote:
> On Fri, 2005-11-04 at 10:30 -0800, Timothy Thelin wrote:
> > And for an even more concrete example:
> > The CY7C68300B cypress bridge board (has various siblings as well
> > on their site that act very similar) implements SCSI spec 0 (ie it
> > doesn't claim to support any scsi spec).  Now usb-storage sees
> > this in inquiry, and decides to export the device as a scsi2 device
> > since based on the usb-storage devs' experience most usb devices
> > really want scsi2 cdbs.  So SCSI core thinks this is a scsi2 device
> > and procedes to mangle the cdbs as they're going through.
>=20
> What happens if you prevent USB mangling the scsi_level?  I think, for
> the most part, we would handle 0 in about the same way as we handle 2.
> However, we could gate the if around the CDB[1] mangling as
>=20
> if (scsi_level !=3D SCSI_UNKNOWN && scsi_level <=3D SCSI_2)
>=20
> which should fix your problem, I think.

A long time ago, usb-storage didn't mangle the scsi_level.  And almost
nothing worked.  Without a SCSI level, 6-byte commands get sent; only
10-byte commands will do.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I see you've been reading alt.sex.chubby.sheep voraciously.
					-- Tanya
User Friendly, 11/24/97

--JwB53PgKC5A7+0Ej
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDa8TMHL9iwnUZqnkRArD/AKCymDQ2Ao+DIounO+a/pPV4iA6SfwCfRbtf
gX0ZvlXGCSbK3gq44y8JhgI=
=lbri
-----END PGP SIGNATURE-----

--JwB53PgKC5A7+0Ej--
