From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: use_10_for_ms revisited?
Date: Sun, 29 Jun 2003 11:35:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030629113551.B4728@one-eyed-alien.net>
References: <3EFE8784.4000101@pobox.com> <20030629102222.GA14962@win.tue.nl> <3EFF14BD.3030406@pobox.com> <20030629173632.GA15024@win.tue.nl> <3EFF28AC.104@pobox.com> <20030629110205.A4728@one-eyed-alien.net> <3EFF2D45.1040203@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="ftEhullJWpWg/VHq"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:35335 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S265719AbTF2SVf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2003 14:21:35 -0400
Content-Disposition: inline
In-Reply-To: <3EFF2D45.1040203@pobox.com>; from jgarzik@pobox.com on Sun, Jun 29, 2003 at 02:17:41PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Andries Brouwer <aebr@win.tue.nl>, linux-scsi@vger.kernel.org


--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 29, 2003 at 02:17:41PM -0400, Jeff Garzik wrote:
> That still doesn't address the issue use_10_for_ms being _too_=20
> fine-grained, though:  mode sense is but one part of the larger picture.
>=20
> We will still have duplicated ATAPI (and other?) logic in USB storage,=20
> ide-scsi, my driver, and elsewhere for items which are common to MMC.=20
> For many cases, it is silly to set a whole list of use_10_for_foo=20
> variables, when they are all unconditionally set to 1 when MMC is=20
> detected (->slave_configure).

I'm having difficulty seeing what duplicated code will be there after the
cleanup.... can you give an example?

One bit I see is the code which modifies the INQUIRY page to show SCSI rev
2.  Anything else?

> So, a concrete suggestion would be:
>=20
> Create 'mmc' bit for each scsi_device, set at slave_configure time.=20
> use_10_for_foo and other code can derive values from this.  i.e. provide=
=20
> enough information that can automatically set all those use_10_for_foo=20
> variables.

This sounds pretty good, if there really are more sections of code which
need more use_10_for_foo codes.  Really, (if I understand you correctly)
you're just proposing to replace all the separate use_10_for_foo codes with
a single, unified, 'mmc' code.  Do you think the use_10_for codes should
remain so they can be turned off individually, or should they all just be
replaced with the 'mmc' code?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

What the hell are you?
					-- Pitr to Dust Puppy=20
User Friendly, 12/3/1997

--ftEhullJWpWg/VHq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+/zGHIjReC7bSPZARAs/nAJ4iJazPmQ2BC9SILLOhL/fW/JBArACgtBPU
dvWUzv+iCtB2e7WLaYtSXN8=
=WitN
-----END PGP SIGNATURE-----

--ftEhullJWpWg/VHq--
