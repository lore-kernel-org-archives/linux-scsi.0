From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [PATCH] fix Sony USB mass storage - pass larger receive buffer
Date: Wed, 12 Nov 2003 17:56:27 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031112175627.B10818@one-eyed-alien.net>
References: <20031112155029.A20986@beaverton.ibm.com> <20031112160921.A10818@one-eyed-alien.net> <20031112161310.A21175@beaverton.ibm.com> <20031112164405.A21268@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="7iMSBzlTiPOCCT2k"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:22788 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S261892AbTKMB4b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Nov 2003 20:56:31 -0500
Content-Disposition: inline
In-Reply-To: <20031112164405.A21268@beaverton.ibm.com>; from patmans@us.ibm.com on Wed, Nov 12, 2003 at 04:44:05PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org


--7iMSBzlTiPOCCT2k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 12, 2003 at 04:44:05PM -0800, Patrick Mansfield wrote:
> On Wed, Nov 12, 2003 at 04:13:10PM -0800, Patrick Mansfield wrote:
> > On Wed, Nov 12, 2003 at 04:09:21PM -0800, Matthew Dharm wrote:
> > > On Wed, Nov 12, 2003 at 03:50:29PM -0800, Patrick Mansfield wrote:
> > > > James - can you please apply? This should not affect other devices =
since
> > > > we are not changing the requested length, just the size of the rece=
ive
> > > > buffer.
> > >=20
> > > This is a terrible idea.
> > >=20
> > > There is a large number of devices which choke if those two values do=
 not
> > > match.
> >=20
> > This is what we do in 2.4 - does USB fix it up for 2.4?
> >=20
> > Oh well.
>=20
> I think see the 2.4 fixups - it looks like it sets the buffer cmd_len to
> 12, but is (for usb_stor_ufi_command?) setting MODE SENSE 10 to a 8 byte
> length (cmd[8] =3D 8).

Basically, yes.  It's tweaked in a couple of places in 2.4, including some
awful heuristics....

> Can we use a minium buffer length of 12 for any requests of less than 13
> bytes?

You can try.... I don't know if it will work.

> Else, I give up on any other methods, and we should add them to the static
> black list as BLIST_MS_SKIP_PAGE_3F (skip_ms_page_3f) and probably
> BLIST_MS_SKIP_PAGE_08 just to be safe.

I'm starting to think that this may be the best solution -- blacklist all
MODE_SENSE[_10] commands from all Direct-Access devices.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Why am I talking to a toilet brush?
					-- CEO
User Friendly, 4/30/1998

--7iMSBzlTiPOCCT2k
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/suTLIjReC7bSPZARAqEjAJ9hPShEnKTxaoc8hQeOVATJzBT6xQCcDMpK
D13tmX3zqd9X5JaA39zGqfU=
=D7fv
-----END PGP SIGNATURE-----

--7iMSBzlTiPOCCT2k--
