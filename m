From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Sun, 27 Apr 2003 02:35:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030427023517.A15212@one-eyed-alien.net>
References: <UTC200304262144.h3QLiAt04450.aeb@smtp.cwi.nl> <20030426151356.A8697@one-eyed-alien.net> <1051397024.4089.86.camel@mulgrave> <20030426183428.B8697@one-eyed-alien.net> <1051409717.4089.146.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:14858 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S263865AbTD0JXI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Apr 2003 05:23:08 -0400
Content-Disposition: inline
In-Reply-To: <1051409717.4089.146.camel@mulgrave>; from James.Bottomley@SteelEye.com on Sat, Apr 26, 2003 at 09:15:07PM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andries.Brouwer@cwi.nl, greg@kroah.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 26, 2003 at 09:15:07PM -0500, James Bottomley wrote:
> On Sat, 2003-04-26 at 20:34, Matthew Dharm wrote:
> > To parse correctly, I would need to remember what type of device it is =
by
> > snooping the INQUIRY data.  I would also have to keep around data such =
as
> > block size (for TYPE_DISK).  I haven't even looked at what extra data I
> > would need to keep around for all the other types.
>=20
> OK, I don't understand this.  To extract the transfer length from a
> given SCSI command (excluding vendor specific ones) is a well defined
> process.  All you need is the command, it doesn't require knowing device
> type or anything else.

Okay.  A READ_10 command for 4 blocks.  How many bytes is that?  The
command bytes in question look something like this:
	0x28 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x4 0x0

I don't see a way to know the byte count without having additional
knowledge about the device.  Maybe I'm wrong -- I certainly don't claim to
be a SCSI expert.  So explain it to me.

> > Why should usb-storage do that when someone else (the command source)
> > already knows this data?  Whatever is sending the command already knows=
 how
> > much data to expect -- my reparsing the command to try to figure it out=
 is
> > guaranteed to be less precise than just using the correct answer from t=
he
> > source of the command.
>=20
> Because we're exploring options for this "lengthen the transfer size"
> behaviour the USB layer exhibits.  Assuming you can transfer more bytes
> than the indicated buffer size is a recipe for data corruption problems
> down the line.

My point in asking the question was to emphasize that I do not believe the
transfer length to be calculable (only guessable) -- why guess when some
bit of code has to know?

The problem if transferring more data than the buffer has room for is an
obvious problem -- that I don't debate.

> > Also, user-issued commands can specify buffer size and transfer length
> > separately, but only one value gets given to the usb-storage driver.  T=
he
> > other is dropped on the floor somewhere in the mid-layer.
>=20
> I usually use the SCSI_IOCTL_SEND_COMMAND, which only allows the
> specification of a buffer size (rather than both length and buffer
> size), how do you send SCSI commands?

Okay, I'm wrong here.  I would have sworn that the SG3 interface allowed me
to specify the two values separately -- I have quite a bit of code that
uses that interface.

Interestinly enough, the one value it specifies it defines as the length of
the transfer, not the size of the buffer -- at least, according to the sg
HOWTO.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Hey, has anyone seen the Microsoft sales guy? It's his feeding time...
					-- Mike
User Friendly, 4/17/1998

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+q6RVIjReC7bSPZARApnxAKCwY7VO8mr9Gw8GtWHu0I8GQOAczgCggneD
1TlKsbcmaFnWZjw82cS8be4=
=+nNN
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
