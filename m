From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [linux-usb-devel] FW: USB 2.0 external hard drive problem
Date: Mon, 9 Feb 2004 13:11:47 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040209211147.GB29283@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0402091132000.1650-100000@ida.rowland.org> <1076345415.2090.30.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CUfgB8w4ZwR/yMy5"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:3209 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S265173AbUBIVMF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Feb 2004 16:12:05 -0500
Content-Disposition: inline
In-Reply-To: <1076345415.2090.30.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Joerg Schilling <schilling@fokus.fraunhofer.de>, magliery@csb.yale.edu, appro@fy.chalmers.se, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>


--CUfgB8w4ZwR/yMy5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 09, 2004 at 11:50:13AM -0500, James Bottomley wrote:
> On Mon, 2004-02-09 at 11:40, Alan Stern wrote:
> > In the absence of anything better, we're forced to assume "bad" status=
=20
> > corresponds to Check Condition...
> >=20
> > What do you think, Matt?  Should we remove the auto-sense for short=20
> > transfers when we get "good" status?  Bearing in mind that it's=20
> > technically legal, but other drivers or programs may not expect it?  Al=
so=20
> > bearing in mind that we have no choice but to auto-sense for non-IN=20
> > transfers with the CB transport.
>=20
> OK, if you want to understand what the mid-layer problem is, look at
> scsi_finish_command().  You see in there we set DRIVER_SENSE if we find
> any valid sense code in the sense buffer (including NO SENSE)
>=20
> We will return this to the user as a sense error at various points.
>=20
> The safest course, if you want to send unsolicited request sense
> commands is probably to zero out the sense buffer if you get NO SENSE
> back.

This seems like the right approach to me.  It should follow the principal
of least suprise for existing users, while work around the reported issue.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

A female who groks UNIX?  My universe is collapsing.
					-- Mike
User Friendly, 10/11/1998

--CUfgB8w4ZwR/yMy5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAJ/eTIjReC7bSPZARApuRAJ0SNg8JFQeFY+b5PKJY2duIZUEpaQCeK6im
jE6WLO5tEfO+bD30cTqY3mI=
=ZVEr
-----END PGP SIGNATURE-----

--CUfgB8w4ZwR/yMy5--
