From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Sat, 5 Apr 2003 11:55:46 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030405115546.C4320@one-eyed-alien.net>
References: <20030322233136.D17056@one-eyed-alien.net> <1048467235.1634.22.camel@mulgrave> <20030323173733.B24668@one-eyed-alien.net> <1048469946.1643.2.camel@mulgrave> <20030323230438.E24668@one-eyed-alien.net> <1048519237.1982.16.camel@mulgrave> <20030324093028.A1066@one-eyed-alien.net> <1049556643.1762.16.camel@mulgrave> <20030405112759.B4320@one-eyed-alien.net> <1049571946.2538.94.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="eRtJSFbw+EEWtPj3"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:47365 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S261829AbTDETo0 (for <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Apr 2003 14:44:26 -0500
Content-Disposition: inline
In-Reply-To: <1049571946.2538.94.camel@mulgrave>; from James.Bottomley@SteelEye.com on Sat, Apr 05, 2003 at 01:45:43PM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>


--eRtJSFbw+EEWtPj3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 05, 2003 at 01:45:43PM -0600, James Bottomley wrote:
> On Sat, 2003-04-05 at 13:27, Matthew Dharm wrote:
> > I don't think this will work.  I see two problems:
> >=20
> > (1) You can't filter TEST_UNIT_READY (opcode 0).  Not a big deal, but a
> > theoretical problem.
>=20
> Yes, TUR has been mandatory since SCSI-1, so I didn't think this would
> be a problem.  Any end signal can be used, zero was the least line of
> resistance.

For the sake of completeness, I think I'd rather see something else used --
perhaps something in the high-byte (where you currently store the inversion
bit).

> > (2) We need to be able to filter at the originator.  For example,
> > MODE_SENSE is perfectly fine to send to a CD-ROM, but not to a hard-dis=
k.
> > We can't make that distinction with your code, unless we put the filter=
ing
> > code not in queuecommand but in places like sd.c.... or we need to chan=
ge
> > the filter to also take a device type.
>=20
> What's wrong with
>=20
> -		if(scsi_filter_cmd(SCp, &filter)) {
> +		if(SCp->device->type =3D=3D TYPE_DISK && scsi_filter_cmd(SCp, &filter)=
) {
>=20
> ?
>=20
> The whole idea is to provide a filter library that the emulated HBA
> drivers can use to cope with standard commands they don't like rather
> than add extra code to the mid-layer main code paths.

My big complaint about that is that it's ugly.  I would like to keep the
device type as part of the filter command structure, so I can keep the call
to scsi_filter_cmd() simple and easy to maintain.  Maybe it's just me, but
I think that editing the filter table with an extra field will be easier to
get right than trying to maintain several different filter tables (for each
device type).

I guess the real power of this filter is in the ability to add logic to
scsi_filter_exceptions()... but centralizing that seems contrary to the
idea of doing this on a per-HBA basis.

What about a filter table of structs with 3 fields -- white/blacklist, type
to apply to, and function pointer to something that returns 0 or 1?  We can
provide some of the 'test functions' in the core for those who want it
(i.e. provide something that implements the 36-byte INQUIRY restriction),
but each HBA can create an arbitrary list of their own as well.

With something like that, we might even be able to collapse some of the
current SCSI device blacklisting into this mechanism.  But that's just a
thought for the future.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It's not that hard.  No matter what the problem is, tell the customer=20
to reinstall Windows.
					-- Nurse
User Friendly, 3/22/1998

--eRtJSFbw+EEWtPj3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+jzTCIjReC7bSPZARArd1AJwO61LdgYgcjdJmEmODFcWmCf+afwCgzXK9
QL80HUoaiGwmjakeL7cSncc=
=//ui
-----END PGP SIGNATURE-----

--eRtJSFbw+EEWtPj3--
