From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH; make sr.c respect use_10_for_ms
Date: Sun, 22 Jun 2003 12:56:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030622125650.D21716@one-eyed-alien.net>
References: <20030621165920.F2811@one-eyed-alien.net> <1056241551.1775.14.camel@mulgrave> <20030621174640.M2811@one-eyed-alien.net> <1056250487.1775.58.camel@mulgrave> <20030621212406.N2811@one-eyed-alien.net> <1056290282.1979.4.camel@mulgrave> <20030622124917.A21716@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="P+33d92oIH25kiaB"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:6664 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S265804AbTFVTmr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Jun 2003 15:42:47 -0400
Content-Disposition: inline
In-Reply-To: <20030622124917.A21716@one-eyed-alien.net>; from mdharm-scsi@one-eyed-alien.net on Sun, Jun 22, 2003 at 12:49:17PM -0700
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, torvalds@transmeta.com, Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>


--P+33d92oIH25kiaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 22, 2003 at 12:49:17PM -0700, Matthew Dharm wrote:
> On Sun, Jun 22, 2003 at 08:58:00AM -0500, James Bottomley wrote:
> > On Sat, 2003-06-21 at 23:24, Matthew Dharm wrote:
> > > On Sat, Jun 21, 2003 at 09:54:46PM -0500, James Bottomley wrote:
> > > >  	}
> > > > -	n =3D buffer[3] + 4;
> > > > +	n =3D rc;
> > > >  	cd->cdi.speed =3D ((buffer[n + 8] << 8) + buffer[n + 9]) / 176;
> > >=20
> > > This bit isn't right.  n is supposed to point to the start of the page
> > > data, not the page header.  The header is a different size if the com=
mand
> > > is 6-byte or 10-byte.
> >=20
> > Yes it is.
> >=20
> > That's why I eliminated the dbd bit.  Your patch was calculating the
> > offsets past the dbd headers.  However, if you tell the mode sense not
> > to send any dbd headers (which are pointless, because the routine isn't
> > interested in them), then you don't have to skip past them. and the mode
> > data begins just past the mode header.
>=20
> But (as I read it -- remember I'm not an expert), the old sr.c code didn't
> set the DBD bit, just like the new code.  So whatever formula applied to
> the old code should apply to the new code, yes?

Okay, according to my copy of the SCSI-2 spec:

 A disable block descriptors (DBD) bit of zero indicates that the target
 may return zero or more block descriptors in the returned MODE SENSE data
 (see 8.3.3), at the target's discretion. A DBD bit of one specifies that
 the target shall not return any block descriptors in the returned MODE
 SENSE data.

The code James sent sets DBD to 0 -- I like that, as many usb-storage
devices choke when DBD is set to 1.  I believe in avoiding the DBD bit as
much as possible, and James seems to have eliminated it.

However, DBD=3D=3D0 means that a block descriptor is likely to be returned =
--
so we need to add in the size of the block descriptor header.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Hi.  I have my back hairs caught in my computer fan.
					-- Customer
User Friendly, 8/20/1998

--P+33d92oIH25kiaB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+9goCIjReC7bSPZARArjaAJ9AXxnLwtLEOMtdj5YngfMrkv66hACfcxaO
GK/svRXjpT9hF1MTDpCl06Q=
=tsi+
-----END PGP SIGNATURE-----

--P+33d92oIH25kiaB--
