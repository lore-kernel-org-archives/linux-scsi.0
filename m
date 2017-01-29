From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: Re: Advanced Format SAT devices show incorrect physical block size
Date: Sun, 29 Jan 2017 18:18:37 +0100
Message-ID: <201701291818.37460@pali>
References: <Pine.LNX.4.44L0.1701110954060.1900-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5973204.f6OXXvp3xS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36035 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751705AbdA2RSq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jan 2017 12:18:46 -0500
In-Reply-To: <Pine.LNX.4.44L0.1701110954060.1900-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Dainius =?utf-8?q?Masili=C5=ABnas?= <pastas4@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, Tom Yan <tom.ty89@gmail.com>

--nextPart5973204.f6OXXvp3xS
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 11 January 2017 16:23:29 Alan Stern wrote:
> On Tue, 10 Jan 2017, James Bottomley wrote:
> > On Tue, 2017-01-10 at 16:00 -0500, Alan Stern wrote:
> > > In theory, I suppose we could change the kernel so that it would
> > > default to READ CAPACITY(16) for devices that report a SCSI level
> > > >=3D 3, or something along those lines.  In general we hesitate to
> > > make changes of this sort, because they almost always end up
> > > breaking _some_ devices -- and if that happens then the change
> > > is reverted, with no exceptions.  Linus has a very strict rule
> > > about not breaking working systems.
> >=20
> > You shouldn't have to change anything: it already does (otherwise
> > how else would we detect physical exponent for proper SCSI
> > devices) see sd.c:sd_try_rc16_first().  It always returns false
> > for USB because you set sdev->try_rc_10_first
>=20
> In fact, this approach probably won't work.  See Bugzilla entries
> #43265 and #43391.  The devices in those reports claimed to be ANSI
> level 4, but they failed anyway.

Seems those devices return capacity 0x7F000000000001 or 0xFF000000000001
Maybe there is some error pattern?

> If you guys want to try the quirk flag, you can apply the patch
> below. Then set the usb-storage module parameter quirks=3Dvvvv:pppp:k
> where vvvv and pppp are the Vendor and Product ID codes for your
> device (as 4 hex digits).
>=20
> In the long run, however, this is not a viable approach.  We'd be
> better off with an explicit blacklist.

Ok, so what are next steps? I think that explicit blacklist would be=20
needed if "bad" devices is less.

How many bug reports were there?

> Alan Stern
>=20
>=20
>=20
> Index: usb-4.x/drivers/usb/storage/usb.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- usb-4.x.orig/drivers/usb/storage/usb.c
> +++ usb-4.x/drivers/usb/storage/usb.c
> @@ -498,7 +498,7 @@ void usb_stor_adjust_quirks(struct usb_d
>  			US_FL_INITIAL_READ10 | US_FL_WRITE_CACHE |
>  			US_FL_NO_ATA_1X | US_FL_NO_REPORT_OPCODES |
>  			US_FL_MAX_SECTORS_240 | US_FL_NO_REPORT_LUNS |
> -			US_FL_ALWAYS_SYNC);
> +			US_FL_ALWAYS_SYNC | US_FL_NEEDS_CAP16);
>=20
>  	p =3D quirks;
>  	while (*p) {
> @@ -551,6 +551,9 @@ void usb_stor_adjust_quirks(struct usb_d
>  		case 'j':
>  			f |=3D US_FL_NO_REPORT_LUNS;
>  			break;
> +		case 'k':
> +			f |=3D US_FL_NEEDS_CAP16;
> +			break;
>  		case 'l':
>  			f |=3D US_FL_NOT_LOCKABLE;
>  			break;

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart5973204.f6OXXvp3xS
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEUEABECAAYFAliOI+0ACgkQi/DJPQPkQ1Jx3gCXWHcGYHkYXYLdr8Q3sg7nKV19
HQCeMqjNoGFTlwnx7Mc0D+U9CH6fjOs=
=u4Wy
-----END PGP SIGNATURE-----

--nextPart5973204.f6OXXvp3xS--
