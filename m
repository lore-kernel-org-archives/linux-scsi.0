From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 13:51:59 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030922135159.A30167@one-eyed-alien.net>
References: <UTC200309221956.h8MJucs21996.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:27148 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S262745AbTIVUwV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 16:52:21 -0400
Content-Disposition: inline
In-Reply-To: <UTC200309221956.h8MJucs21996.aeb@smtp.cwi.nl>; from Andries.Brouwer@cwi.nl on Mon, Sep 22, 2003 at 09:56:38PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: James.Bottomley@steeleye.com, david-b@pacbell.net, greg@kroah.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, patmans@us.ibm.com, stern@rowland.harvard.edu, torvalds@osdl.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 22, 2003 at 09:56:38PM +0200, Andries.Brouwer@cwi.nl wrote:
> A scsi device declares its level of scsi compliance.
> Most USB storage devices are not very scsi compliant at all,
> and report 0 there.

Not exactly.  The reporting of 0, 1, 2, or something random in that field
appears to be completely unrelated to the capabilities of the device.  I've
found -zero- correlation between the revision level and how the device
functions.

Also, sampling my devices, I see a wide range of values reported -- saying
'most report 0' would be incorrect based on my data.

> To everybody's surprise USB storage does
>=20
>         US_DEBUGP("Fixing INQUIRY data to show SCSI rev 2 - was %d\n",
>                   data_ptr[2] & 7);
>=20
>         /* Change the SCSI revision number */
>         data_ptr[2] =3D (data_ptr[2] & ~7) | 2;
>=20
> It claims that the device is SCSI-2 compliant, even when the
> device itself does not make that claim at all.
>=20
> Suppose that we stop changing this compliance level.
> Then getting SCSI-1 or no compliance level could be a
> "conservative mode" flag.
>=20
> [Of course this was done for a reason - USB storage was written
> assuming the SCSI layer given. If we stop changing the SCSI level
> that may require changes in the SCSI code. Probably Matt remembers
> what the problems were.]

It's been a couple of years since I looked at this.... but I positively
recall that I added this code to fix definate and clear problems.

One that is immediately obvious to me is that if the SCSI level is < 2, we
can't address anything beyond the 6-byte command limit.

Another that immediately comes to mind is that the display in
/proc/scsi/scsi would show version ffffffff

I've heard arguments from various people (including Jorge Shilling and some
device-vendor folks) that I shouldn't override this value... the argument I
used to counter that request was that things break completely if I don't
override the value; I don't have a record of what specifically breaks.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

A:  The most ironic oxymoron wins ...
DP: "Microsoft Works"
A:  Uh, okay, you win.
					-- A.J. & Dust Puppy
User Friendly, 1/18/1998

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/b2DvIjReC7bSPZARAs3bAKCu60YL+8zh5pl3w9mUZBabbJ87KgCfVZsj
aKq63cjGr+lk3CzsUZ8wDEQ=
=Rlrc
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
