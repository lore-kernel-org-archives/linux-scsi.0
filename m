From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Questions about transfer lengths
Date: Fri, 13 Sep 2002 09:01:48 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020913090148.A31114@one-eyed-alien.net>
References: <20020912110702.A20844@one-eyed-alien.net> <Pine.LNX.4.33L2.0209130936330.735-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33L2.0209130936330.735-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Fri, Sep 13, 2002 at 10:03:48AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: usb-storage <usb-storage@one-eyed-alien.net>, linux-scsi <linux-scsi@vger.kernel.org>


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Okay... this is a long and confusing and painful subject, but it eventually
boils down to some easier rules... it's also been discussed on linux-scsi
before, so this should just be a refresher to the folks there...

First, we need to guarantee that A =3D=3D C.  That can be different from F
without any problems, but A must =3D=3D C.

Since C is under our control, we use C :=3D A.  But we don't always know A,
since the CDB can specify size in 'blocks', the size of which varies from
device to device.  Thus, if we see a command that uses 'blocks' (i.e.
READ_10, etc), we choose to interpret A :=3D D/E -- we try to enforce that
D =3D=3D E.  For those commands where we actually can determine A (i.e.
INQUIRY, where the length is encoded in a bytecount in the CDB), we use
that value.

F should be reported back to the user.  There is a residue field in the
request structure from the mid-layer, and we simply need to copy this data
back to that field.

Now, the good news:  After many long discussions with Linus and other on
the linux-scsi list, we've decided that D =3D=3D E should be an invariant
established by the thing that actually originates the request.  Also, A =3D=
=3D
D =3D=3D E is also a requirement.  The recent discussion on my use of BUG_O=
N()
is actually in relation to this -- I was trying to flag any command that
came down the pipe with this rule violated.

Any place you see that A !=3D D or D !=3D E is a bug, and should be fixed at
the higher layer that sends the command.  Eventually, all that logic to
determine the transfer length will be removed (it only works _most_, but
not _all_ of the time) and replaced with references to D.

So that just leaves B and F... F I've discussed above.  As for B... well,
here's where we have to hope the device vendors have done their job.  We
try to avoid C !=3D B as much as possible, mostly by trying to craft the
commands being sent to look like what Windows or MacOS is likely to send --
we do this at the source of the command.  This is why the INQUIRY-sending
logic in the scsi scanning code is so involved, but it works more
universally.

So the good news is that we really are trying to reduce the number of
different values that need to be considered.

Matt

On Fri, Sep 13, 2002 at 10:03:48AM -0400, Alan Stern wrote:
> Matt:
>=20
> I don't really understand the logic behind the calculation used in
> usb_stor_transfer_length().  Why does the code distinguish between reading
> and writing?
>=20
> Clearly this question opens up a can of worms.  I realize that the issue
> of how to handle transfer lengths for emulated scsi devices is a difficult
> one.  So I invite discussion on this topic...  For those who don't know,
> this is all from the perspective of a device-driver author for
> usb-storage.
>=20
>=20
> As I see it, there's about six different quantities that concern us:
>=20
> 	A =3D the size embedded in the scsi CDB (command data block).  We
> are given this, although if needed we could alter it.
>=20
> 	B =3D the length that the device really wants to transfer.  AFAIK,
> some devices will choke if A !=3D B, some will choke if A > B, and some w=
ill
> choke if A < B.
>=20
> 	C =3D the size that we tell the interface hardware about.  (For us,
> the interface is a USB host controller.)  This is really the only value
> under our direct control.  There may be additional interfaces involved,
> such as a USB->something-else bridge; in that case we also have C' =3D the
> size passed to the extra interface.  Some hardware will choke if C' has
> the wrong value.
>=20
> 	D =3D the size of the request given to us by the caller.  That would
> be the request_bufflen field of the SRB (scsi request block).
>=20
> 	E =3D the size of the memory buffer allocated for the transfer.
> For scatter-gather transfers, this is the sum of the length fields of the
> s-g descriptors in the SRB.  For non-scatter-gather, I don't think we
> know this value -- we seem to assume that it is the same as D.
>=20
> 	F =3D the amount of data that ultimately gets transferred.  We ought
> to find this out and report it back to the user.
>=20
> Clearly it is an error if D > E, and it's disastrous if F > E.  It's
> probably also an error if F > D.  Other than that, I don't know much.
>=20
>=20
> The logic used to usb_stor_transfer_length() can be described as follows:
>=20
> 	For writes (and a few assorted types of reads), calculate C =3D
> 	min(D,E).  For most types of reads, calculate C =3D A.  Report an
> 	error in the kernel log if C !=3D D, and then return C.
>=20
> Also, we get F from the lower-level drivers, but we don't seem to use it
> (beyond checking for a truncated transfer).  Certainly we don't report the
> value back to the caller.  I presume the higher scsi routines have their
> own ways of figuring out how much data got transferred; is that correct?
>=20
> Comments of any sort are welcome.
>=20
> Alan Stern

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

What the hell are you?
					-- Pitr to Dust Puppy=20
User Friendly, 12/3/1997

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9ggvsIjReC7bSPZARAv8DAJ4+sN8SpITN7ojkjb6sPE5a0awQ5ACfUYzS
6zwcWo8UC/EDvCR4zl+4i7w=
=KXxm
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
