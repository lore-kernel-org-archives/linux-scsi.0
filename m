From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Questions about transfer lengths
Date: Sun, 15 Sep 2002 13:09:21 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020915130921.A21056@one-eyed-alien.net>
References: <20020913172656.B3611@one-eyed-alien.net> <Pine.LNX.4.33L2.0209151547190.11901-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33L2.0209151547190.11901-100000@netrider.rowland.org>; from stern@rowland.harvard.edu on Sun, Sep 15, 2002 at 03:57:50PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: usb-storage <usb-storage@one-eyed-alien.net>, linux-scsi <linux-scsi@vger.kernel.org>


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 15, 2002 at 03:57:50PM -0400, Alan Stern wrote:
> On Fri, 13 Sep 2002, Matthew Dharm wrote:
>=20
> > > From what you're saying, it sounds like the ideal thing would be to u=
se
> > > C :=3D D, but instead as a defense against buggy callers we actually =
should
> > > try to set C :=3D min(A,D,E) if we can determine A, and C :=3D min(D,=
E)
> > > otherwise.  In any case we should always check and report it as a bug=
 if
> > > A !=3D D or D !=3D E.  Note that this is definitely _not_ what the co=
de does
> > > now.
> >
> > Um... we do check that C !=3D D or E -- we used to BUG_ON() if they were
> > different, but Linus didn't like that.  Eventually, we will be removing=
 the
> > entire usb_stor_transfer_length() mess, tho.
>=20
> That's not quite true.  If we look at E at all (which we only do
> sometimes), we only make sure that C =3D min(D,E).  And we don't log an
> error message if D !=3D E.

True enough.

> > > And why does the current code only calculate A for reads and not for
> > > writes?
> >
> > The asymmetry of USB.  If we're writing and we write too much, the devi=
ce
> > can tell us.  If we're reading and we read too much, all we get is a CSW
> > block loaded into our user buffer.
>=20
> Okay, that explains that.  But consider this:  For now, the only reasons
> we have for going through all these shenanigans are:
>=20
> 	1.  We don't trust the caller to get it right; and
>=20
> 	2.  If the caller gets it wrong, we want to make sure that it
> 	doesn't look as though things worked okay when in fact they didn't
> 	(reading CSW bytes into a data buffer for example).
>=20
> Given these reasons, I think the best course is always to take the time to
> compute A and E whenever possible, for writes as well as reads, and always
> log an error (and maybe a stack trace) if they disagree.  After all, if
> the whole point is to catch our callers' errors, then let's look for them!
> (Also, it would help simplify part of the isd200 driver, where apparently
> the length embedded in the CDB needs to be decoded for both reads and
> writes.)

The point of where I'm trying to take the code is that we should compute
nothing, because we cannot guarantee that we are correct.  We _must_ trust
the caller to get it right.... there is no perfect algorithm for
determining, given the information available to the usb-storage driver,
what the 'right' answer is.  The best we can do is use a heuristic to
get close, and that's not acceptable.  The caller is the only party that
can get it right, so we must insist that it does so.

Remember, we're not worried about target error here, only host error.  The
major thing we must do is make certain that the length in the CBW matches
the command (because _lots_ of bridges freak out if that's not true).  Most
of the other logic is to try to catch weirdo callers that didn't get it
right in creative ways -- most of the callers are already fixed now.

I'm merging patches right now... the show_trace() is changing into a
KERN_ERR printk.  I figure that by next week we should be ripping out all
of that function... we'll actually likely just move it into debug.c, just
in case we ever need it again.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

My mother not mind to die for stoppink Windows NT!  She is rememberink=20
Stalin!
					-- Pitr
User Friendly, 9/6/1998

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9hOjwIjReC7bSPZARAnOiAKCjyUDnLCKsmzocLQ7N7g8YHBTfugCcC1vl
j9ErH0JuxTeLrgJYHYgOV0s=
=Hks3
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
