From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [PATCH as470] Add a NOREPORTLUN blacklist flag
Date: Sun, 20 Feb 2005 22:47:09 -0800
Message-ID: <20050221064709.GA30205@one-eyed-alien.net>
References: <20050220195927.398c57e4.vsu@altlinux.ru> <Pine.LNX.4.44L0.0502202236350.9805-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:40585 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S261899AbVBUGrS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Feb 2005 01:47:18 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0502202236350.9805-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Sergey Vlasov <vsu@altlinux.ru>, Samuel Colin <Samuel.Colin3@wanadoo.fr>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 20, 2005 at 10:44:21PM -0500, Alan Stern wrote:
> On Sun, 20 Feb 2005, Sergey Vlasov wrote:
>=20
> > On Thu, 17 Feb 2005 17:31:04 -0500 (EST) Alan Stern wrote:
> >=20
> > > James:
> > >=20
> > > This patch adds a NOREPORTLUN blacklist flag for a disk made by "WDC"=
=20
> > > (Winchester?).  The drive's firmware crashes when it receives
> > > REPORT_LUNS,  even though it claims to be SCSI rev 04.
> > >=20
> > > Alan Stern
> > >=20
> > >=20
> > >=20
> > > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> > >=20
> > > =3D=3D=3D=3D=3D drivers/scsi/scsi_devinfo.c 1.14 vs edited =3D=3D=3D=
=3D=3D
> > > --- 1.14/drivers/scsi/scsi_devinfo.c	2004-12-10 11:54:56 -05:00
> > > +++ edited/drivers/scsi/scsi_devinfo.c	2005-02-16 11:30:56 -05:00
> > > @@ -201,6 +201,7 @@
> > >  	{"WangDAT", "Model 2600", "01.7", BLIST_SELECT_NO_ATN},
> > >  	{"WangDAT", "Model 3200", "02.2", BLIST_SELECT_NO_ATN},
> > >  	{"WangDAT", "Model 1300", "02.4", BLIST_SELECT_NO_ATN},
> > > +	{"WDC WD25", "00JB-00FUA0", NULL, BLIST_NOREPORTLUN},
> >=20
> > This does not look like a right solution.  WD2500JB is an IDE disk made
> > by Western Digital:
> >=20
> > http://www.wdc.com/en/products/Products.asp?DriveID=3D42
> >=20
> > Therefore the problematic LaCie device is really an USB/Firewire-to-IDE
> > adapter with the WD2500JB drive in a box.  And it is the USB-IDE part
> > which fails on the REPORT_LUNS command, not the IDE disk.  Probably
> > there are other LaCie devices with the same adapter but different disks
> > inside; adding all such IDE disks to the SCSI blacklist does not seem
> > like a good solution.  The usb-storage blacklist seems like a better
> > place for such entry.
>=20
> You are quite correct.  In fact, another user with a different brand of=
=20
> USB-IDE converter just wrote in with exactly the same problem.
>=20
> James, please withdraw the patch above.
>=20
> Matt, it looks like the best way to solve this problem is to go back to
> the old strategy of always setting the SCSI revision to 2 (no matter what
> it might actually be), at least for Direct Access devices.  That would
> suppress the REPORT_LUNS command.  Would we lose anything by doing this?

Besides the use of REPORT_LUNS on devices which actually support it?  I
don't think so...

I wonder if printing a warning if sdev->scsi_level > SCSI_2 would be
useful...

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

You are needink to look more evil.  You likink very strong coffee?
					-- Pitr to Dust Puppy
User Friendly, 10/16/1998

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFCGYPtIjReC7bSPZARAnYJAJ0QsbpB0PR2ObniyIPRMbbW6qZKAQCg1tJT
kmX8YPzszmidc7ubncWoExc=
=+wJL
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
