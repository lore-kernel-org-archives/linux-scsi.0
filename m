From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Sat, 26 Apr 2003 18:34:28 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030426183428.B8697@one-eyed-alien.net>
References: <UTC200304262144.h3QLiAt04450.aeb@smtp.cwi.nl> <20030426151356.A8697@one-eyed-alien.net> <1051397024.4089.86.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="/WwmFnJnmDyWGHa4"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:31496 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S263192AbTD0BWV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Apr 2003 21:22:21 -0400
Content-Disposition: inline
In-Reply-To: <1051397024.4089.86.camel@mulgrave>; from James.Bottomley@SteelEye.com on Sat, Apr 26, 2003 at 05:43:43PM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andries.Brouwer@cwi.nl, greg@kroah.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net


--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 26, 2003 at 05:43:43PM -0500, James Bottomley wrote:
> On Sat, 2003-04-26 at 17:13, Matthew Dharm wrote:
> > > Of course it is bad when variables have a function that differs
> > > from what is suggested by their name. So, sr_bufflen must be
> > > the length of the buffer and nothing else. If the length of
> > > the transfer is needed, there must be a field sr_xferlen or so.
> >=20
> > Sounds good.  It also sounds very similar to what I proposed some time =
ago.
> > Here's a question from that discussion: How you you set sr_xferlen?  I'm
> > guessing that you want to add a parameters to scsi_wait_req()?  Or
> > will you simply remove the bufflen parameter and force callers to set b=
oth
> > fields in the struct scsi_request?
> >=20
> > Either way, you'll be touching a great deal of code.  Which isn't
> > necessarily a bad thing, but it might raise a few eyebrows....
>=20
> What's actually wrong with simply parsing the commands?  For all SCSI
> Spec commands there's a well known algorithm to get the transfer size
> from the command group.  For vendor specific commands, well the
> mid-layer doesn't issue them so you'd just have to rely on the user
> doing it to pass the correct buffer length (which is no different really
> from what happens today).

To parse correctly, I would need to remember what type of device it is by
snooping the INQUIRY data.  I would also have to keep around data such as
block size (for TYPE_DISK).  I haven't even looked at what extra data I
would need to keep around for all the other types.

Why should usb-storage do that when someone else (the command source)
already knows this data?  Whatever is sending the command already knows how
much data to expect -- my reparsing the command to try to figure it out is
guaranteed to be less precise than just using the correct answer from the
source of the command.

Also, user-issued commands can specify buffer size and transfer length
separately, but only one value gets given to the usb-storage driver.  The
other is dropped on the floor somewhere in the mid-layer.

In the end, I guess the short-answer to 'what is wrong with parsing' is
that we tried it for over a year, and it kept biting us on the ass with
weird corner-cases and strange devices.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

We can customize our colonels.
					-- Tux
User Friendly, 12/1/1998

--/WwmFnJnmDyWGHa4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+qzOkIjReC7bSPZARAq1SAKC4zL8AJrbfVoC4L9yP0bvxH407iACfd9Va
ENlR41dzc8Mf0EZSanRn0gg=
=ApoF
-----END PGP SIGNATURE-----

--/WwmFnJnmDyWGHa4--
