From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Sat, 22 Mar 2003 23:31:36 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030322233136.D17056@one-eyed-alien.net>
References: <20030322193705.C17056@one-eyed-alien.net> <Pine.LNX.4.44.0303222005520.29393-100000@home.transmeta.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="d01dLTUuW90fS44H"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0303222005520.29393-100000@home.transmeta.com>; from torvalds@transmeta.com on Sat, Mar 22, 2003 at 08:09:57PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>


--d01dLTUuW90fS44H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 22, 2003 at 08:09:57PM -0800, Linus Torvalds wrote:
>=20
> On Sat, 22 Mar 2003, Matthew Dharm wrote:
> >
> > This patch changes how devices a probed on a SCSI bus if they are on an
> > emulated host.
>=20
> I really think this is wrong. I'd much much rather get _rid_ of that=20
> stupid "emulated" flag, instead of adding meaning to it.

Well, you could just delete it.  It's not used anywhere.

> > If a host is emulated, we (a) don't ask for EVPD data, as it's likely n=
ot
> > there, (b) assume that we have only 36-bytes of INQUIRY data, and (c) d=
on't
> > ask disks for their cache-type (assume write-through).
>=20
> ..and thus anything that wants to emulate SCSI has to never be able to be
> write-back again.

Okay, I'll admit that could be a problem.

> Now, I'd say that it is stupid to call yourself a SCSI disk if you aren't=
=20
> one _anyway_ (the raw block device interfaces are simpler and faster), bu=
t=20
> if you do, then I think it's doubly stupid to put in arbitrary=20
> restrictions like this.

The problem is this:  usb-storage interfaces via SCSI, but not just for
disks.  Tape, CD, etc. are all handled with the same protocol.  Heck, ATAPI
disk/cd/tape are handled with these code paths.

> If there are known commands that devices have trouble with (whether=20
> emulated or not), maybe we could have helper routines to do some default=
=20
> filtering, and have the queuecommand function check those. But this just=
=20
> looks ugly and hacky to me.

Well, there are lots of 'known commands' that fall in to this category.  If
we had centralized helper functions, that would be great.  But, as it
stands, right now all the low-level drivers have to do all that separately,
and badly.

Right now, we've got nothing, which leaves low-level driver folks out in
the cold.

As I see it, SCSI commands break down into two basic categories:  common
and uncommon.  Common things (basic read and write, 36-byte INQUIRY, eject,
etc.) are all fine, but the 'uncommon' things (checking cache type,
255-byte INQUIRY, etc) cause problems.  I'm trying to find a way to choke
off the problematic commands without having to write code to recognize what
is being sent (and choke it off) based on what is in the command bytes.

I'm open to suggestions.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It was a new hope.
					-- Dust Puppy
User Friendly, 12/25/1998

--d01dLTUuW90fS44H
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+fWLYIjReC7bSPZARAkDFAJ9ilbU1+vbr9PSi0zyfHyvuPPFwsQCgvlTp
2Af/dHbBUnwN21NKzFho5SY=
=qnQr
-----END PGP SIGNATURE-----

--d01dLTUuW90fS44H--
