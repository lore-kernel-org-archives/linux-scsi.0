From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Mon, 24 Mar 2003 09:30:28 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030324093028.A1066@one-eyed-alien.net>
References: <20030322193705.C17056@one-eyed-alien.net> <Pine.LNX.4.44.0303222005520.29393-100000@home.transmeta.com> <20030322233136.D17056@one-eyed-alien.net> <1048467235.1634.22.camel@mulgrave> <20030323173733.B24668@one-eyed-alien.net> <1048469946.1643.2.camel@mulgrave> <20030323230438.E24668@one-eyed-alien.net> <1048519237.1982.16.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1048519237.1982.16.camel@mulgrave>; from James.Bottomley@SteelEye.com on Mon, Mar 24, 2003 at 09:15:57AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 24, 2003 at 09:15:57AM -0600, James Bottomley wrote:
> On Mon, 2003-03-24 at 01:04, Matthew Dharm wrote:
> > Note that MODE_SENSE isn't on this list.  How does the 'popular OS' test
> > for write-protect, you ask?  It tries to write and then looks for a
> > failure, AFAICT.
>=20
> We use MODE_SENSE on CDs to probe for capabilities: this is required
> behaviour and we've been doing for a long time.
>=20
> sd also uses MODE_SENSE to probe the cache type as well as the write
> protect state.  Cache type certainly can't be obtained any other way,
> and I'm not sure allowing writes to read only media wouldn't cause us
> more problems in the long run.

CD is fine, I was referring to MODE_SENSE in sd.c

I think allowing write to read-only media is the only way to go.  I don't
see another way to get write-protect status.

> > I'd be willing to write a helper, but I'm a bit out of my element here.=
..
> > can someone at least suggest a good place to put such a helper (or
> > volunteer to mock one up for me)?
>=20
> OK, I can do this: A simple one with either a blacklist (reject these
> commands) or whitelist (only accept these commands) going by the first
> command byte OK?

Well, you need to go by more than the first command byte -- ex. INQUIRY is
okay, unless length !=3D 36 or EVPD.

I think a blacklist is probably in order, but with a BIG COMMENT mentioning
that if someone adds new commands into the code paths they should at least
consider if they belong in the blacklist.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Type "format c:"  That should fix everything.
					-- Greg
User Friendly, 12/18/1997

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+f0C0IjReC7bSPZARAhw8AKCWiyRpeJruzae1jzSmG2qDEHDMkwCcC7Y1
9TDTdhY8po9YFDf3CeGOSXU=
=4qWV
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
