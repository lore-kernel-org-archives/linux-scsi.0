From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Sat, 26 Apr 2003 15:13:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030426151356.A8697@one-eyed-alien.net>
References: <UTC200304262144.h3QLiAt04450.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:39943 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S263103AbTDZWBs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Apr 2003 18:01:48 -0400
Content-Disposition: inline
In-Reply-To: <UTC200304262144.h3QLiAt04450.aeb@smtp.cwi.nl>; from Andries.Brouwer@cwi.nl on Sat, Apr 26, 2003 at 11:44:10PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: James.Bottomley@steeleye.com, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 26, 2003 at 11:44:10PM +0200, Andries.Brouwer@cwi.nl wrote:
> (1) usb-storage is broken in the sense that it uses sr_bufflen
> for the transfer size instead of the buffer length, then fudges
> commands to make them transfer a different length, but without
> updating sr_bufflen.

I would argue with the term 'broken', especially after having discussed
this publically and having been told that using sr_bufflen this way was not
only apropriate but recommended.

But that's water under the bridge.

> (1A)
> Of course it is bad when variables have a function that differs
> from what is suggested by their name. So, sr_bufflen must be
> the length of the buffer and nothing else. If the length of
> the transfer is needed, there must be a field sr_xferlen or so.

Sounds good.  It also sounds very similar to what I proposed some time ago.
Here's a question from that discussion: How you you set sr_xferlen?  I'm
guessing that you want to add a parameters to scsi_wait_req()?  Or
will you simply remove the bufflen parameter and force callers to set both
fields in the struct scsi_request?

Either way, you'll be touching a great deal of code.  Which isn't
necessarily a bad thing, but it might raise a few eyebrows....

> (1B)
> Of course it is bad when usb-storage fudges commands.

Agreed.  I don't think you'll find anyone who would argue this point.

> (2) Also other parts of the kernel do this translation,
> so there is a lot of duplication; see for example
> the idescsi_transform code in ide-scsi.c.

Yes, there are.  That's bothered me too.... especially when programs like
cdrecord use a special IOCTL to turn that translation on-and-off.

> Lazy as I am I had hoped that I would find the right setup
> in my mailbox. But upon returning I see essentially two replies:

Hey, I've got about a 0% success rate with patches so far, so I'm a bit
hesitant.  Besides, I'm still waiting for the EVPD-removal patch to get
accepted by Linus.

> (b) Alan says that changing must be avoided when possible.
> Of course I agree. (By the way, he says among other things
> "The SCSI midlayer could try multiple forms of MODE_SENSE", but
> that happens already.)

It does?  I know it tries MODE_SENSE for cache-data... but I think Alan was
referring to WP-detect.  Maybe I just missed something.

> So I made a patch, but will only describe it since it is long,
> and I am not quite happy yet, as you will see below.
>=20
> The first part, in drivers/usb/storage/scsiglue.c is very
> satisfactory:
>
> (496 lines deleted). That is a good start.
> If we do not fudge commands in usb-storage, then a lot of fudging code
> can go.

Very true.  If you can say that sd.c and SCSI core won't send MODE_SENSE,
all this can go.

> The next part, in drivers/usb/storage/protocol.c, is almost
> as satisfactory:
>=20
> (deleted some 200 lines changing READ_6 into READ_10, etc.)

We need to be careful here... there are several different flavors of
comamnd-protocol used by usb-storage, and we need to double-check things
like UFI before we rip everything out.  I think it can all go, but we just
need to make sure (and I'd want to see the actual patch before doing that
check).

> These lines can be deleted because the SCSI layer does not send
> such commands. (What about sg you ask? I don't care. People who
> send commands "by hand" are responsible themselves. Moreover, it
> is really bad when these handcrafted commands are changed by the
> driver - probably they were intended precisely as written.)

Agreed.

> Why doesnt SCSI send READ_6/WRITE_6? Because there is a field "ten"
> that is initially 1 and says that READ_10 must be used. It will be
> cleared only when the device returns ILLEGAL_REQUEST.
>=20
> I dislike the choice of identifier "ten" - it is difficult to grep for,
> and I changed it into use_10_for_rw, with the same function as before.
> Added a field use_10_for_ms. Thus, in scsi.h:
>=20
> +       unsigned use_10_for_rw:1; /* first try 10-byte read / write */
> +       unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select =
*/

> All this is nice and well. Remains the question how usb-storage
> makes sure that the use_10_for_rw and use_10_for_ms flags are set
> for its devices.

Why not just make us_10_for_ms default to 1, just like use_10_for_rw?  The
same logic (fallback if ILLEGAL_REQUEST) could apply to both.

> Tonight I kludged this by setting this (in protocol.c) at the moment
> the first INQUIRY is done. But that is terribly ugly.
> Did I overlook some obvious means of communication?

Not that I'm aware of.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

What, are you one of those Microsoft-bashing Linux freaks?
					-- Customer to Greg
User Friendly, 2/10/1999

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+qwSkIjReC7bSPZARAktsAKCEtrSjO1uVe08JZovwslQ31acLRwCgnTaq
DSRIJEnnW9jMEML3dW95MBo=
=AIHM
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
