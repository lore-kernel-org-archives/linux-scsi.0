From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH; make sr.c respect use_10_for_ms
Date: Sun, 22 Jun 2003 14:06:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030622140657.A22396@one-eyed-alien.net>
References: <20030621165920.F2811@one-eyed-alien.net> <1056241551.1775.14.camel@mulgrave> <20030621174640.M2811@one-eyed-alien.net> <1056250487.1775.58.camel@mulgrave> <20030621212406.N2811@one-eyed-alien.net> <1056290282.1979.4.camel@mulgrave> <20030622124917.A21716@one-eyed-alien.net> <20030622125650.D21716@one-eyed-alien.net> <1056314343.10846.93.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:26376 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S265882AbTFVUwy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Jun 2003 16:52:54 -0400
Content-Disposition: inline
In-Reply-To: <1056314343.10846.93.camel@mulgrave>; from James.Bottomley@SteelEye.com on Sun, Jun 22, 2003 at 03:37:28PM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: torvalds@transmeta.com, Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 22, 2003 at 03:37:28PM -0500, James Bottomley wrote:
> On Sun, 2003-06-22 at 14:56, Matthew Dharm wrote:
> > > But (as I read it -- remember I'm not an expert), the old sr.c code d=
idn't
> > > set the DBD bit, just like the new code.  So whatever formula applied=
 to
> > > the old code should apply to the new code, yes?
>=20
> Hmm, the diff I sent was an older one which had the dbd meaning
> inverted.  The attached is the one I'm actually testing.

Ah.. I'll review this.

> > The code James sent sets DBD to 0 -- I like that, as many usb-storage
> > devices choke when DBD is set to 1.  I believe in avoiding the DBD bit =
as
> > much as possible, and James seems to have eliminated it.
> >=20
> > However, DBD=3D=3D0 means that a block descriptor is likely to be retur=
ned --
> > so we need to add in the size of the block descriptor header.
>=20
> OK, now I'm confused.  the write caching determination code that you and
> Andries spent a while getting to work has DBD=3D=3D1, and I thought we'd
> eliminated all the USB problems with that code...

Yeah, it's confusing.

Andries and I spent a great deal of time getting the use_10_for_ms worked
out -- and that's helped greatly.  The DBD=3D1 for cache determination was
there before that, and is still there, and I would still like it removed.
However, with the use_10_for_ms code in place, many more devices don't
-fatally- choke when DBD=3D1.  Lots still do, however.

Up until now, I really didn't understand what DBD did... now that I do, I
really don't understand why we use it at all.  It's a matter of
convenience to parse the data, I guess, but it comes at a great expense of
incompatiblity.

> Since the BD skip code is quite a wodge of complexity, I'd like to know
> what devices fail on DBD=3D=3D1 before trying to add it all in, especially
> as we (fortunatly) have nothing in the kernel that actually wants to see
> the BDs.

The problem as I see it is ATAPI devices.  That means that sbp2, ide-scsi,
and usb-storage (all of which bridge ATAPI devices to the SCSI layer) will
be affected.  These devices don't include the DBD bit in their command
specification -- the bit is reserved.

Unfortunately, more data is difficult to come by -- the cache-detect code
is still relatively new, and the use_10_for_ms is even newer (read: last
week).  We haven't had the opportunity to get the bug reports back from
everywhere to find out how bad the problem is.  The devices I have avoid
the fatal condition by rejecting all commands with the DBD bit set, but
it is still an error condition I'd like to avoid.

And I'm pretty certain that there are devices for which setting DBD is
fatal still.  I just don't have any hard evidence to prove I'm right.  Tho
I have yet to see a USB device answer the cache-detect query with a
meaningful answer.

And, I don't see DBD as a required element.  It's a convenience item, which
will create a great deal of headache for us.

I don't see how the BD code is complex.  If we change it so that DBD=3D=3D0
always, then this problem goes away completely.  Just change the calculation
of header_offset to include the DBD size (taken from the header) and we're
done -- the callers still get an offset into the data which shows them
where the mode page starts.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

My mother not mind to die for stoppink Windows NT!  She is rememberink=20
Stalin!
					-- Pitr
User Friendly, 9/6/1998

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+9hpxIjReC7bSPZARAkg9AJ9XBvMNJrntQm5mpc0dUhbDLBKnWwCeOq8T
iQSQHzJSbqpN0r0j0EooIXg=
=KTRW
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
