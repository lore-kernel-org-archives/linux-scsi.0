From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH; make sr.c respect use_10_for_ms
Date: Sat, 21 Jun 2003 21:24:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030621212406.N2811@one-eyed-alien.net>
References: <20030621165920.F2811@one-eyed-alien.net> <1056241551.1775.14.camel@mulgrave> <20030621174640.M2811@one-eyed-alien.net> <1056250487.1775.58.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="U6leaJ20qZQc29iB"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:50450 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S265498AbTFVEKF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Jun 2003 00:10:05 -0400
Content-Disposition: inline
In-Reply-To: <1056250487.1775.58.camel@mulgrave>; from James.Bottomley@SteelEye.com on Sat, Jun 21, 2003 at 09:54:46PM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: torvalds@transmeta.com, Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>


--U6leaJ20qZQc29iB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 21, 2003 at 09:54:46PM -0500, James Bottomley wrote:
> @@ -702,7 +692,7 @@
>  		printk("%s: scsi-1 drive\n", cd->cdi.name);
>  		return;
>  	}
> -	n =3D buffer[3] + 4;
> +	n =3D rc;
>  	cd->cdi.speed =3D ((buffer[n + 8] << 8) + buffer[n + 9]) / 176;
>  	cd->readcd_known =3D 1;
>  	cd->readcd_cdda =3D buffer[n + 5] & 0x01;

This bit isn't right.  n is supposed to point to the start of the page
data, not the page header.  The header is a different size if the command
is 6-byte or 10-byte.

If you look at my patch, you can see the correct offsets you need.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

We can customize our colonels.
					-- Tux
User Friendly, 12/1/1998

--U6leaJ20qZQc29iB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+9S9mIjReC7bSPZARAm0qAKC+e3ToYtln2sjF4MPoEGqWJ7318gCeK2eM
yClP0BNy0FV4f8VulGyKnyw=
=ByMq
-----END PGP SIGNATURE-----

--U6leaJ20qZQc29iB--
