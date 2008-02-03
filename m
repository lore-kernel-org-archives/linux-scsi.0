From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [PATCH] bugfix for an underflow condition in usb storage & isd200.c
Date: Sun, 3 Feb 2008 11:23:16 -0800
Message-ID: <20080203192316.GF27785@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0802031025180.12447-100000@netrider.rowland.org> <47A5EBC0.3060401@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="juZjCTNxrMaZdGZC"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:49890
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752363AbYBCTX4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Feb 2008 14:23:56 -0500
Content-Disposition: inline
In-Reply-To: <47A5EBC0.3060401@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Mark Glines <mark@glines.org>, James Bottomley <James.Bottomley@SteelEye.com>, USB list <linux-usb@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>


--juZjCTNxrMaZdGZC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 03, 2008 at 06:28:48PM +0200, Boaz Harrosh wrote:
> >From 3610cfa93c990bbbafb296134ac01ef6d426eb8d Mon Sep 17 00:00:00 2001
> From: Boaz Harrosh <bharrosh@panasas.com>
> Date: Thu, 31 Jan 2008 21:31:31 +0200
> Subject: [PATCH] bugfix for an overflow condition in usb storage & isd200=
.c
>=20
>   scsi_scan is issuing a 36-byte INQUIRY request to llds. isd200 would
>   volunteer 96 bytes of INQUIRY. This caused an overflow condition in
>   protocol.c usb_stor_access_xfer_buf(). So first fix is to
>   usb_stor_access_xfer_buf() to properly handle overflow/underflow condit=
ions.
>   Then usb_stor_set_xfer_buf() should report this condition as cmnd->resu=
lt =3D=3D
>   (DID_BAD_TARGET << 16).
>=20
>   Then also isd200.c is fixed to only return the type of INQUIRY && SENSE
>   the upper layer asked for.
>=20
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  drivers/usb/storage/isd200.c   |    7 +++++--
>  drivers/usb/storage/protocol.c |   20 ++++++++++++++++----
>  2 files changed, 21 insertions(+), 6 deletions(-)

Looking at this again, I think I see Alan's point.  The modifications to
ISD200 code aren't really needed.

Or, put another way, if you're going to modify the ISD200 code, you should
fix up all the other users of usb_stor_access_xfer_buf() -- there are over
a dozen or so, and it looks like none of them have sanity checks for length
(but the happen to work right now).

But, the modifications to usb_stor_access_xfer_buf() look good -- no
request from a sub-driver should be allowed to scribble into memory.  The
current code does make the implicit assumption that there is enough
storage, and will walk right off the end of the sg list if there isn't.

I'm not sure I like the mods to usb_stor_set_xfer_buf().  Any place we set
a status that we know is going to be thrown away is an invitation for a
problem later if someone changes the code to preserve that status.  It's a
jack-in-the-box, waiting to spring open in our face later.  The limit check
(which mirrors the usb_stor_access_xfer_buf modification) and WARN_ON() are
probably good.

In a strictly technical sense, the change to protocol.c are sufficient.
That is, they will prevent a serious error.  There is a justification tho
to fix all of the users of usb_stor_access_buf() to not attempt to use more
SCSI buffer than exists.

My opinion is this:  Let's make the protocol.c mods (modulo my comments
about setting useless status bits) now.  Then, let's decide if we're going
to patch all the other users of the usb_stor_*_xfer_buf() functions as a
separate discussion.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

C:  They kicked your ass, didn't they?
S:  They were cheating!
					-- The Chief and Stef
User Friendly, 11/19/1997

--juZjCTNxrMaZdGZC
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHphSkHL9iwnUZqnkRAm3IAJ9EId7+GXha6CSM8WXdira1QPNnhwCeNd94
cTY1AMUZye+TiN3uNhfscX8=
=Cm0J
-----END PGP SIGNATURE-----

--juZjCTNxrMaZdGZC--
