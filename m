From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Sun, 23 Mar 2003 23:04:38 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030323230438.E24668@one-eyed-alien.net>
References: <20030322193705.C17056@one-eyed-alien.net> <Pine.LNX.4.44.0303222005520.29393-100000@home.transmeta.com> <20030322233136.D17056@one-eyed-alien.net> <1048467235.1634.22.camel@mulgrave> <20030323173733.B24668@one-eyed-alien.net> <1048469946.1643.2.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="KuLpqunXa7jZSBt+"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1048469946.1643.2.camel@mulgrave>; from James.Bottomley@SteelEye.com on Sun, Mar 23, 2003 at 07:39:01PM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>


--KuLpqunXa7jZSBt+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Well, here's my list of what the 'popular OS' uses for all devices:

INQUIRY (for only 36 bytes -- nothing else!)
TEST_UNIT_READY
REQUEST_SENSE
ALLOW_MEDIUM_REMOVAL (mostly for eject purposes)

For disk-like media:

READ_10
WRITE_10

I'd have to go back to my notes for tape and CD media.  But those aren't my
biggest problem areas -- the common probe and the disk driver are my
biggest headaches.

Note that MODE_SENSE isn't on this list.  How does the 'popular OS' test
for write-protect, you ask?  It tries to write and then looks for a
failure, AFAICT.

Note that this data comes from observations about what commands all devices
seem to support.

I'd be willing to write a helper, but I'm a bit out of my element here...
can someone at least suggest a good place to put such a helper (or
volunteer to mock one up for me)?

Matt

On Sun, Mar 23, 2003 at 07:39:01PM -0600, James Bottomley wrote:
> On Sun, 2003-03-23 at 19:37, Matthew Dharm wrote:
> > Actually, there is such a list.  It's the commands that the 'popular OS'
> > uses, and I have a pretty good idea exactly what those are.  That's why=
 my
> > original approach was to just cut out the commands that fell outside th=
at
> > definition.
>=20
> Well, if you want to write a helper for the mid layer that checks the
> commands and returns a Check Condition with sense Illegal Reguest on the
> bad ones, that sounds like the best approach.  You can then call the
> helper function in the queuecommand of the problem emulated drivers.
>=20
> Can you publish a rough list of these?
>=20
> James
>=20

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Dudes! May the Open Source be with you.
					-- Eric S. Raymond
User Friendly, 12/3/1998

--KuLpqunXa7jZSBt+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+fq4GIjReC7bSPZARAsJ6AJ0fxhLRjE+9VskmjfrjbR7s2MRVYgCfTWRC
uaF0C/8EmAc9Cl1929WI7vY=
=AGOo
-----END PGP SIGNATURE-----

--KuLpqunXa7jZSBt+--
