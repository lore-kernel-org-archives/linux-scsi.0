From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass larger receive buffer
Date: Thu, 13 Nov 2003 11:13:44 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031113111344.B30194@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0311131200420.949-100000@ida.rowland.org> <1068744259.13580.41.camel@patrh9> <20031113100424.A26197@beaverton.ibm.com> <1068747355.16444.22.camel@patrh9> <1068747746.16444.30.camel@patrh9> <1068747998.16444.35.camel@patrh9> <1068748629.16444.58.camel@patrh9>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="l76fUT7nc3MelDdI"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:33807 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S264391AbTKMTOk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 14:14:40 -0500
Content-Disposition: inline
In-Reply-To: <1068748629.16444.58.camel@patrh9>; from p.lavarre@ieee.org on Thu, Nov 13, 2003 at 11:37:09AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: patmans@us.ibm.com, stern@rowland.harvard.edu, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org


--l76fUT7nc3MelDdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2003 at 11:37:09AM -0700, Pat LaVarre wrote:
> > > How about we blacklist all the bInterfaceSubClass that Windows does n=
ot
> > > regard as generic.  I remember Windows does regard bInterfaceSubClass=
 =3D
> > > x06 as generic.  I think I remember there are two others.
> >=20
> > grep -i generic
> > in windows/inf/usbstor.inf yields, hex:
> >=20
> > 08 02 50
> > 08 05 50
> > 08 06 50
> >=20
> > How about we [guess] disk writable
> > [without risking mode sense]
> > if we do not find bInterfaceSubClass in
> > the set x 02 05 06?
>=20
> In short:
>=20
> Or how about we only blacklist mode sense from devices that report
> bInterfaceSubClass =3D any of the x07..FF Reserved codes?  Surely a device
> sending us a formally Reserved code is a good first clue that it may not
> behave robustly thereafter?  Or maybe we just blacklist mode sense from
> bInterfaceSubClass =3D xFF FormallyReservedButInformallyVendorSpecific?=
=20
> Surely a device sending us that code is an even better first clue that
> it may not behave robustly thereafter?

Our experience tells us that xFF is often used because designers are one of
the following:
	(a) lazy
	(b) incompetient
	(c) driven by marketing, which wants to load an .inf so their
	device seems 'special' (custom icons, etc.)

So xFF doesn't really tell us, deterministically, anything at all.

Knowing that the device is direct-access, however, implies very strongly
that MODE_SENSE[_10] is a bad idea.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Okay, this isn't funny anymore! Let me down!  I'll tell Bill on you!!
					-- Microsoft Salesman
User Friendly, 4/1/1998

--l76fUT7nc3MelDdI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/s9foIjReC7bSPZARAuixAJ9P5Y+aw0AB1RYqOJK+jcLVhLF1UACgjsDt
u2fYwN/al3L7dkNYC9DUu5Y=
=LS8h
-----END PGP SIGNATURE-----

--l76fUT7nc3MelDdI--
