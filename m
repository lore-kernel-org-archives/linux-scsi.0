From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [PATCH] bugfix for an underflow condition in usb storage & isd200.c
Date: Tue, 5 Feb 2008 09:54:03 -0800
Message-ID: <20080205175403.GA31714@one-eyed-alien.net>
References: <20080203192316.GF27785@one-eyed-alien.net> <Pine.LNX.4.44L0.0802041500420.5186-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:33495
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752668AbYBER4x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 12:56:53 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0802041500420.5186-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Mark Glines <mark@glines.org>, James Bottomley <James.Bottomley@SteelEye.com>, USB list <linux-usb@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 04, 2008 at 03:05:58PM -0500, Alan Stern wrote:
> On Sun, 3 Feb 2008, Matthew Dharm wrote:
>=20
> I think the correct approach is to modify those routines so that they=20
> will never overrun the s-g buffer (like Boaz has done), and _document_=20
> this behavior.  Then the callers can feel free to try and transfer as=20
> much as they want, knowing that an overrun can't occur.  There won't=20
> be any need for a WARN_ON or anything else.

Six of one and a half-dozen of the other.  All we're arguing over is the
definition of "correct behavior" here.  You want to change the API so that
overrun is acceptable and handled; I prefer calling it a Bad Thing(tm).

We both agree that the code shouldn't run off the end of the s-g list.

Since you've already committed to updating the patch, then we can do it
your way.  Just make sure it's very very clear in the comments.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

E:  You run this ship with Windows?!  YOU IDIOT!
L:  Give me a break, it came bundled with the computer!
					-- ESR and Lan Solaris
User Friendly, 12/8/1998

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHqKK7HL9iwnUZqnkRAkYxAJ9fpt2Y+P0eAJKoRJ7lszxcHvN8cACfWZHi
YHr+lS6YiaL16fgQQHB8tbU=
=bbmu
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
