From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] Re: 2 PATCHES: fix request_tranferlength
Date: Sun, 28 Jul 2002 12:31:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020728123126.B12344@one-eyed-alien.net>
References: <20020727195503.C3121@one-eyed-alien.net> <Pine.LNX.4.44.0207281300320.942-100000@kai.makisara.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0207281300320.942-100000@kai.makisara.local>; from Kai.Makisara@kolumbus.fi on Sun, Jul 28, 2002 at 01:22:40PM +0300
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net


--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 28, 2002 at 01:22:40PM +0300, Kai Makisara wrote:
> On Sat, 27 Jul 2002, Matthew Dharm wrote:
>=20
> > Emulated SCSI busses _need_ to know how much data to move.  usb-storage=
 has
> > a large table to try to figure it out, but it only gets the correct ans=
wer
> > in _most_ cases, not all cases.  Only the originator of the command tru=
ly
> > knows how much data is going to be moved, so the only mechanism that ma=
kes
> > sense is to make the originator of the command indicate that number via
> > some mechanism.
> >
> Note that even the originator does not always know how much data will be
> transferred. One example is reading a tape block in variable block mode.
> The originator specifies the maximum length but the target returns less if
> the block is shorter.

That's not the problem I speak of.  Tho I recognize it....

The problem I (and sbp2 faces), is this:  Imagine the 'device' is really a
USB/ATA bridge device, with an ATA device directly attached to it.

The case of 'return short data' is a common one (INQUIRY, MODE_SENSE, etc.)
and so is well handled.

However, when speaking to the bridge, we need to provide it with (a) the
command bytes to be sent to the ATA unit, and (b) the amount of data we
intend to move.

The case that is not handled well by the bridge is the 'bad host' case of
the command bytes indicating a length which is different from the explicit
length we give.  Lots of bridges choke on this configuration.

As long as those two values _agree_, there is no problem.  A 'return short
data' case is well handled.  But we need to make those values agree.  A
variable length read isn't a problem.

I won't pretend I understand how ATA or SCSI works... all I know is that
under certain conditions, these bridge chips can't DoTheRightThing.

> The current interface is a little messy. The function scsi_do_req has the
> following signature:
>=20
> void scsi_do_req(Scsi_Request * SRpnt, const void *cmnd,
>               void *buffer, unsigned bufflen, void (*done) (Scsi_Cmnd *),
>                  int timeout, int retries)

Agreed.  Why half of these parameters aren't in the Scsi_Request structure
is beyond me.

> Another interpretation (which I have used) is that the bufflen parameter
> is always the length of the buffer _used in this transfer_. Whether the
> buffer is contiguous or defined using scatter/gather list is determined by
> SRpnt->sr_use_sg. (The lower level drivers don't have to know the actual
> length of the buffer as long as it is long enough.)

This is the interpretation I use in usb-storage.  Experimentally, it seems
to be correct.

> The second interpretation has the transfer length in exactly one place. In
> the first interpretation a complicated logic (or a new structure member)
> is needed to get the transfer length. Do we need this or should we just
> enforce the second interpretation (maybe change the name bufflen to
> maxtransfer or something like that)?
>=20
> (If the new structure member dxfer_len is useful to lower level drivers, I
> don't oppose adding it to Scsi_Request as long as it is set in
> scsi_do_req. What I am opposing is to make the callers responsible for
> redundant specifications.)

Do you see from my explanation why dxfer_len is not redundant to any other
fields?  One more example to try to make it clear...

One code path in scsi_scan.c sends an INQUIRY with cmd[4] =3D xff.  This is=
 a
command to transfer (up to) 255 bytes.  The bufflen passed is 512.

I can hear the objection "Why doesn't usb-storage inspect the command to
determine the length?".  This is, in fact, what we do now.  It only works
_most_ of the time, not all of the time.  Vendor-specifc commands are
screwed.  Several opcodes have different meaning depending on what type of
device they are sent to, so we're screwed there.  Commands which specify
length in terms of "number of blocks" also screw us up, because we don't
know what the block size is.

I've been working on this problem for more than a year.  My conclusion is
that we need a separate indication of dxfer_len.  I'm open to alternatives,
but none proposed so far gets me the information I need for usb-storage to
function properly.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Type "format c:"  That should fix everything.
					-- Greg
User Friendly, 12/18/1997

--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD4DBQE9REaOIjReC7bSPZARAhnGAKCPZAFqyboWl8j82G66uC7xY/wVDgCXQox+
26R8+dt9pfb37b9aJWcCXQ==
=/mxW
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--
