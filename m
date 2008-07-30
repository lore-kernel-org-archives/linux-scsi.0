From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Subject: Re: [usb-storage] BUG: SCSI: usb storage SDHC card doesn't work in 2.6.27-rc1
Date: Tue, 29 Jul 2008 22:21:39 -0700
Message-ID: <20080730052139.GG6091@one-eyed-alien.net>
References: <103966.68801.qm@web83207.mail.mud.yahoo.com> <1217390922.6103.79.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TiqCXmo5T1hvSQQg"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754534AbYG3FV5@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1217390922.6103.79.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Frost <artusemrys@yahoo.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Matt Frost <artusemrys@sbcglobal.net>
List-Id: linux-scsi@vger.kernel.org


--TiqCXmo5T1hvSQQg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2008 at 11:08:42PM -0500, James Bottomley wrote:
> On Tue, 2008-07-29 at 17:06 -0700, Matthew Frost wrote:
> > James and co.,=20
> >=20
> > Bug report: regression in 2.6.27-rc1 -- scsi WRT usb-storage
> > Origin: Commit de72aa4c2b82a6cffe15d86a8d391ded4fb57602, "[SCSI] erase
> > invalid data returned by device"
> > Location: drivers/scsi_lib.c
> > Device: Secure Digital HC 4GB card in USB 2.0 card reader
>=20
> Actually, this is a USB issue ... I've added the correct cc's

Well, it's both a SCSI and USB issue.

The patch in question clears sections of a data buffer that a device
reports as invalid.  Basically, the usb storage spec allows devices to
transfer "garbage" data into buffers; instead of leaving the data there
(which could be leakage from something sensitive), the SCSI core now zeros
out the section of buffers that are reported as 'unused' (aka 'residue').

It does this for all devices, not just USB ones.  USB devices, however,
seem especially prone to not reporting this 'residue' correctly.

Honestly, given the problems this has caused, and the (apparently)
relatively high number of devices that don't report residue correctly, I'm
starting to seriously think this should be reverted.

Actually, I'm seriously starting to think that US_FL_IGNORE_RESIDUE should
just become a sysfs parameter which defaults to the 'ignore' state...

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

You suck Stef.
					-- Greg=20
User Friendly, 11/29/97

--TiqCXmo5T1hvSQQg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIj/pjHL9iwnUZqnkRAv/+AJ0awOYqNbEtfgvT0JxDEaViVrDx1QCgq2xJ
9ZBwjfWPQ3I5pFgNt3FEsBA=
=8Eas
-----END PGP SIGNATURE-----

--TiqCXmo5T1hvSQQg--
