From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: usb storage traces
Date: Thu, 4 Dec 2003 10:44:28 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031204184428.GA17116@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0312041329450.994-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:56203 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S263463AbTLDSoc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2003 13:44:32 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0312041329450.994-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Did the device advertise 'generic scsi' or one of the other protocol codes?

Microsoft has published information that indicates that they 'translate'
the mode-sense commands into the 10-byte variants for everything bug
'transparent scsi' -- I think actually seeing that information would be
necessary in constructing a new algorithm for Linux.

Matt

On Thu, Dec 04, 2003 at 01:30:16PM -0500, Alan Stern wrote:
> Here is a digested version of a log trace contributed by Alex Sanks.  It=
=20
> was collected from a generic USB Bulk-only storage device (actually the=
=20
> g_file_storage file-backed storage gadget) attached to a host running=20
> Windows XP SP1.  It agrees quite well with the results of my own tests=20
> using USB Snoopy on a Windows 2000 host.
>=20
> In this trace, the number following the command name is the command length
> in decimal; following it are the command bytes in hex, then the direction
> and transfer length in decimal.
>=20
>=20
> INQUIRY		6: 12 00 00 00 24 00  In 36
> Vendor-specific	10: 23 00 00 00 00 00 00 00 fc 00  In 252
> 	Provokes an Invalid Command error
> REQUEST-SENSE	12: 03 00 00 00 12 00 00 00 00 00 00 00  In 18
> 	Bug in Windows: REQUEST-SENSE is really a 6-byte command
>=20
> Vendor-specific	10: 23 00 00 00 00 00 00 00 fc 00  In 252
> 	Retry previous failed command; it still doesn't work
> REQUEST-SENSE	12: 03 00 00 00 12 00 00 00 00 00 00 00  In 18
> Vendor-specific	10: 23 00 00 00 00 00 00 00 fc 00  In 252
> 	Another futile retry
> REQUEST-SENSE	12: 03 00 00 00 12 00 00 00 00 00 00 00  In 18
>=20
> READ-CAPACITY	10: 25 00 00 00 00 00 00 00 00 00  In 8
> 	Provokes Unit Attention: Reset Occurred
> REQUEST-SENSE	12: 03 00 00 00 12 00 00 00 00 00 00 00  In 18
> READ-CAPACITY	10: 25 00 00 00 00 00 00 00 00 00  In 8
> 	This time it works
>=20
> READ		10: 28 00 00 00 00 00 00 00 01 00  In 512
> 	Read the first sector
> READ		10: 28 00 00 00 00 00 00 00 01 00  In 512
> 	Windows likes reading the first sector
> READ-CAPACITY	10: 25 00 00 00 00 00 00 00 00 00  In 8
> 	It also likes reading the disk capacity
>=20
> MODE-SENSE	6: 1a 00 1c 00 c0 00  In 192
> 	Page 1c is listed as reserved; I don't know what it is;
> 	provokes Invalid Field in CDB error
> REQUEST-SENSE	12: 03 00 00 00 12 00 00 00 00 00 00 00  In 18
>=20
> MODE-SENSE	6: 1a 00 3f 00 c0 00  In 192
> 	So page 3f should work if we request 192 bytes!
>=20
> MODE-SENSE	6: 1a 00 08 00 c0 00  In 192
> 	And so should page 08!
>=20
> MODE-SELECT	6: 15 10 00 00 18 00  Out 24
> 	Although not shown here, a USB Snoopy trace reveals that this
> 	attempts to set the WCE (write cache enable) bit in page 8;
> 	here it provokes Invalid Field in CDB error
> REQUEST-SENSE	12: 03 00 00 00 12 00 00 00 00 00 00 00  In 18
>=20
> MODE-SELECT	6: 15 10 00 00 18 00  Out 24
> 	Retry of previous failed command; it fails again
> REQUEST-SENSE	12: 03 00 00 00 12 00 00 00 00 00 00 00  In 18
>=20
> READ-CAPACITY	10: 25 00 00 00 00 00 00 00 00 00  In 8
> 	Windows really likes to get the capacity!
> READ		10: 28 00 00 00 00 00 00 00 01 00  In 512
> 	And it really likes to read the first sector!
> READ		10: 28 00 00 00 00 00 00 00 01 00  In 512
> READ-CAPACITY	10: 25 00 00 00 00 00 00 00 00 00  In 8
> READ		10: 28 00 00 00 00 00 00 00 01 00  In 512
> READ-CAPACITY	10: 25 00 00 00 00 00 00 00 00 00  In 8
> 	Ommitted: this command was repeated 8 times
>=20
> TEST-UNIT-READY	6: 00 00 00 00 00 00 =20
> MODE-SENSE	6: 1a 00 00 00 0c 00  In 12
> 	I don't know what Windows expects to find in page 0;
> 	but this fails
> REQUEST-SENSE	12: 03 00 00 00 12 00 00 00 00 00 00 00  In 18
>=20
> READ-CAPACITY	10: 25 00 00 00 00 00 00 00 00 00  In 8
> 	Ommitted: this command was repeated 3 times
>=20
> TEST-UNIT-READY	6: 00 00 00 00 00 00 =20
> MODE-SENSE	6: 1a 00 00 00 0c 00  In 12
> 	Fails again
> REQUEST-SENSE	12: 03 00 00 00 12 00 00 00 00 00 00 00  In 18
> READ-CAPACITY	10: 25 00 00 00 00 00 00 00 00 00  In 8
> READ-CAPACITY	10: 25 00 00 00 00 00 00 00 00 00  In 8
>=20
>=20
> Some of the activity may depend on the contents of the partition table
> stored in the first sector.  But it seems clear that, subject to the
> unknown function of command x23 and of mode page x1c, we might be able to
> work with devices that advertise themselves as Bulk-only by requesting 192
> bytes from page x3f and page 8.
>=20
> Does anybody know what command x23 and mode page x1c do?  Although=20
> nominally vendor-specific, they must be reasonably standardized if Window=
s=20
> can get away with using them on a generic device.
>=20
> Unfortunately, there's nothing to stop a manufacturer from supplying their
> own driver which would avoid reading those pages.  So even an apparently
> normal device might react badly to these commands.  However I think it's=
=20
> still worth a try.
>=20
> Alan Stern
>=20
>=20
>=20
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Hey Chief.  We've figured out how to save the technical department.  We=20
need to be committed.
					-- The Techs
User Friendly, 1/22/1998

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/z4CMIjReC7bSPZARAv3aAJ40folEZMdBklxCtbkhos/W3Mw6dQCfQdeU
cN10xOrz6sA33wXx3XsTLok=
=RyTy
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
