From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH; make sr.c respect use_10_for_ms
Date: Sun, 22 Jun 2003 12:49:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030622124917.A21716@one-eyed-alien.net>
References: <20030621165920.F2811@one-eyed-alien.net> <1056241551.1775.14.camel@mulgrave> <20030621174640.M2811@one-eyed-alien.net> <1056250487.1775.58.camel@mulgrave> <20030621212406.N2811@one-eyed-alien.net> <1056290282.1979.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:51463 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S265833AbTFVTfU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Jun 2003 15:35:20 -0400
Content-Disposition: inline
In-Reply-To: <1056290282.1979.4.camel@mulgrave>; from James.Bottomley@SteelEye.com on Sun, Jun 22, 2003 at 08:58:00AM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: torvalds@transmeta.com, Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 22, 2003 at 08:58:00AM -0500, James Bottomley wrote:
> On Sat, 2003-06-21 at 23:24, Matthew Dharm wrote:
> > On Sat, Jun 21, 2003 at 09:54:46PM -0500, James Bottomley wrote:
> > >  	}
> > > -	n =3D buffer[3] + 4;
> > > +	n =3D rc;
> > >  	cd->cdi.speed =3D ((buffer[n + 8] << 8) + buffer[n + 9]) / 176;
> >=20
> > This bit isn't right.  n is supposed to point to the start of the page
> > data, not the page header.  The header is a different size if the comma=
nd
> > is 6-byte or 10-byte.
>=20
> Yes it is.
>=20
> That's why I eliminated the dbd bit.  Your patch was calculating the
> offsets past the dbd headers.  However, if you tell the mode sense not
> to send any dbd headers (which are pointless, because the routine isn't
> interested in them), then you don't have to skip past them. and the mode
> data begins just past the mode header.

But (as I read it -- remember I'm not an expert), the old sr.c code didn't
set the DBD bit, just like the new code.  So whatever formula applied to
the old code should apply to the new code, yes?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Stef, you just got beaten by a ball of DIRT.
					-- Greg
User Friendly, 12/7/1997

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+9gg9IjReC7bSPZARAkbAAKCL2GifqdP6XjekB7nonUwWSlmfrACgskMR
qmhaUjyDT+URS7sOsQWwD7Y=
=FUig
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
