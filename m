From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: use_10_for_ms revisited?
Date: Sat, 28 Jun 2003 23:54:13 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030628235413.I26995@one-eyed-alien.net>
References: <3EFE8784.4000101@pobox.com> <20030628233824.H26995@one-eyed-alien.net> <3EFE8B7B.2000109@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="fmvA4kSBHQVZhkR6"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:27155 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S265585AbTF2GkO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2003 02:40:14 -0400
Content-Disposition: inline
In-Reply-To: <3EFE8B7B.2000109@pobox.com>; from jgarzik@pobox.com on Sun, Jun 29, 2003 at 02:47:23AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org


--fmvA4kSBHQVZhkR6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm somewhat concerned that, just as we're finding something that works,
we're going to go off in another direction.

I certainly wouldn't mind removing the code that manipulates the SCSI
revision number.

But, the 6-to-10 conversion code (at least for USB) is all about to go
away, once we settle on how sr.c (and friends) should handle use_10_for_ms
-- so one of your reasons to change all this is already moot.

I guess, in part, I'm hesitant to rely on fields in the INQUIRY data that
nobody has checked to verify that they are actually useful.  Most USB
devices are made on ultra-low testing, and commonly have bad bits in any
field that isn't used by Windows or MacOS.

Matt

On Sun, Jun 29, 2003 at 02:47:23AM -0400, Jeff Garzik wrote:
> Matthew Dharm wrote:
> > On Sun, Jun 29, 2003 at 02:30:28AM -0400, Jeff Garzik wrote:
> >=20
> >>I was reading the specs just now, and I see that the inquiry page=20
> >>defines how ATAPI and USB devices indicate they are compliant with MMC-=
4.
> >=20
> >=20
> > It does?  I guess I've missed that.
>=20
> I'm looking at MMC-4 revision 2a (whatever was on t10.org tonight).
>=20
> Immediately after table 286 (standard inquiry data format), it describes=
=20
> the information I believe we can use to determine that 10-byte commands=
=20
> (only) need to be sent.  peripheral qualifier, peripheral device type,=20
> version, and interface dependent field #1.
>=20
> These fields can be used to differentiate atapi/usb devices from older=20
> scsi devices.  One concrete example is that atapi reports zero in the=20
> version field, even though it's mmc-4 compliant.  But the Linux scsi=20
> stack treats that instead as the most ancient of ancient scsi devices :)=
=20
>   So, to counteract this, the ide-scsi module and other places will=20
> patch the inquiry page data to indicate a higher scsi revision.
>=20
> Other examples are several places where 6-byte commands are converted=20
> into 10-byte commands.  The right answer is to simply know when to send=
=20
> 10-byte commands in the first place, thus eliminating the need for any=20
> translation.
>=20
>=20
> > If you're talking about the INQUIRY command, the data better be within =
the
> > first 36 bytes, or it's likely to not actually be there.
>=20
> Certainly.
>=20
> 	Jeff
>=20
>=20
>=20

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

You were using cheat codes too.  You guys suck.
					-- Greg to General Studebaker
User Friendly, 12/16/1997

--fmvA4kSBHQVZhkR6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+/o0VIjReC7bSPZARAlCeAJoDjo66FxNoNiIvQLwa3lyUu2QmqACggOqL
2YqE/n/TBFs4jgtQg3WtIY4=
=wG4m
-----END PGP SIGNATURE-----

--fmvA4kSBHQVZhkR6--
