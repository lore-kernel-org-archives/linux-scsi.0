From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Questions about transfer lengths
Date: Fri, 13 Sep 2002 17:26:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020913172656.B3611@one-eyed-alien.net>
References: <20020913090148.A31114@one-eyed-alien.net> <Pine.LNX.4.33L2.0209131320280.1027-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="IiVenqGWf+H9Y6IX"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33L2.0209131320280.1027-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Fri, Sep 13, 2002 at 01:44:55PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: usb-storage <usb-storage@one-eyed-alien.net>, linux-scsi <linux-scsi@vger.kernel.org>


--IiVenqGWf+H9Y6IX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 13, 2002 at 01:44:55PM -0400, Alan Stern wrote:
> On Fri, 13 Sep 2002, Matthew Dharm wrote:
>=20
> > Since C is under our control, we use C :=3D A.  But we don't always kno=
w A,
> > since the CDB can specify size in 'blocks', the size of which varies fr=
om
> > device to device.  Thus, if we see a command that uses 'blocks' (i.e.
> > READ_10, etc), we choose to interpret A :=3D D/E -- we try to enforce t=
hat
> > D =3D=3D E.  For those commands where we actually can determine A (i.e.
> > INQUIRY, where the length is encoded in a bytecount in the CDB), we use
> > that value.
> >
> > F should be reported back to the user.  There is a residue field in the
> > request structure from the mid-layer, and we simply need to copy this d=
ata
> > back to that field.
>=20
> So far as I can tell this isn't done anywhere, and it hasn't seemed to
> hurt anything.  (In fact, grep'ing for 'resid' in the usb-storage source
> directory reveals no matches at all.)  The proper spot to fill in the
> residue field is usb_stor_transfer(), but the code doesn't do it.  That
> subroutine doesn't even know how much data got sent! -- the size
> information is not propagated from usb_stor_transfer_partial().
>=20
> Is this an error in usb-storage?  If it is, why hasn't it caused any
> problems?  Or maybe it has, and nobody realized what was going on?

It's an error.  Very few things check the residue.  Actually, nothing in
the kernel check it -- the data is passed back to userspace apps that use
the scsi-generic interface.

> > Now, the good news:  After many long discussions with Linus and other on
> > the linux-scsi list, we've decided that D =3D=3D E should be an invaria=
nt
> > established by the thing that actually originates the request.  Also, A=
 =3D=3D
> > D =3D=3D E is also a requirement.  The recent discussion on my use of B=
UG_ON()
> > is actually in relation to this -- I was trying to flag any command that
> > came down the pipe with this rule violated.
> >
> > Any place you see that A !=3D D or D !=3D E is a bug, and should be fix=
ed at
> > the higher layer that sends the command.  Eventually, all that logic to
> > determine the transfer length will be removed (it only works _most_, but
> > not _all_ of the time) and replaced with references to D.
>=20
> From what you're saying, it sounds like the ideal thing would be to use
> C :=3D D, but instead as a defense against buggy callers we actually shou=
ld
> try to set C :=3D min(A,D,E) if we can determine A, and C :=3D min(D,E)
> otherwise.  In any case we should always check and report it as a bug if
> A !=3D D or D !=3D E.  Note that this is definitely _not_ what the code d=
oes
> now.

Um... we do check that C !=3D D or E -- we used to BUG_ON() if they were
different, but Linus didn't like that.  Eventually, we will be removing the
entire usb_stor_transfer_length() mess, tho.

> And why does the current code only calculate A for reads and not for
> writes?

The asymmetry of USB.  If we're writing and we write too much, the device
can tell us.  If we're reading and we read too much, all we get is a CSW
block loaded into our user buffer.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

G:  Money isn't everything, A.J.
AJ: Who convinced you of that?
G:  The Chief, at my last salary review.
					-- Mike and Greg
User Friendly, 11/3/1998

--IiVenqGWf+H9Y6IX
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9goJPIjReC7bSPZARAso+AKCr5VSnRif9M+zAPrMR3KJNsrUYHgCcCVEK
Bb6bKa+epb+yr23lfch5Z+8=
=pr1M
-----END PGP SIGNATURE-----

--IiVenqGWf+H9Y6IX--
