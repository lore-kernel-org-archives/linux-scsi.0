From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: use_10_for_ms revisited?
Date: Sun, 29 Jun 2003 11:02:05 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030629110205.A4728@one-eyed-alien.net>
References: <3EFE8784.4000101@pobox.com> <20030629102222.GA14962@win.tue.nl> <3EFF14BD.3030406@pobox.com> <20030629173632.GA15024@win.tue.nl> <3EFF28AC.104@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:22023 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S265714AbTF2Rru (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2003 13:47:50 -0400
Content-Disposition: inline
In-Reply-To: <3EFF28AC.104@pobox.com>; from jgarzik@pobox.com on Sun, Jun 29, 2003 at 01:58:04PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Andries Brouwer <aebr@win.tue.nl>, linux-scsi@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 29, 2003 at 01:58:04PM -0400, Jeff Garzik wrote:
> I grant you that ATAPI is not the whole world, here, but it presents=20
> sufficient cases to warrant a common approach.  Both ide-scsi and usb=20
> storage (and my ata-scsi driver) have atapi-specific logic in them for=20
> 6-to-10 translation.  We can keep adding hueristic upon hueristic to the=
=20
> kernel to handle these things, or we can step back, look at the bigger=20
> picture, and take advantage of the commonality found.

Right now, we can handle this case with a slave_configure() function that
sets use_10_for_ms and use_10_for_rw, like usb-storage does now.  The
heuristic code in usb-storage is on the way out, once sr.c is converted (in
progress).

Devices easily identified, heuristics gone, repeated code very minimal (2
lines) -- sounds like a winner to me.  Actually, I have a feeling that any
algorithm to try to determine MMC or not (complete with it's own heuristic
to handle strange devices) will be much longer than those repeated 2 lines.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I don't have a left mouse button.  I only have one mouse and it's on my rig=
ht.
					-- Customer
User Friendly, 2/13/1999

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+/ymdIjReC7bSPZARAvuFAJ9XRN3BKLy3PO/HLcJB+GYRJD7aYwCgn6Sb
SLFNv2orYKzW9YSEWzsRv4I=
=lyVl
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
