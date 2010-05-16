From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] advansys: ISA support depends on ISA_DMA_API
Date: Sun, 16 May 2010 04:05:31 +0100
Message-ID: <1273979131.2564.98.camel@localhost>
References: <1266543527.10567.713.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QobOJBhPnyGSF+T+4XXy"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38572 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752467Ab0EPDFh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 May 2010 23:05:37 -0400
In-Reply-To: <1266543527.10567.713.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Martin Michlmayr <tbm@cyrius.com>


--=-QobOJBhPnyGSF+T+4XXy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-02-19 at 01:38 +0000, Ben Hutchings wrote:
> The advansys driver supports ISA cards using DMA but not PIO-only.
> Fix the dependency and preprocessor conditions.

If I recall correctly, we subsequently discussed this on IRC and you
said this issue had been raised before and that ISA should imply
ISA_DMA_API.

So, where is it documented that ISA implies ISA_DMA_API?  There are many
dependencies in drivers/scsi/Kconfig on ISA && ISA_DMA_API which are be
redundant if this is true.

You previously wrote (archived as
<http://thread.gmane.org/gmane.linux.scsi/44923>):
> On Thu, Oct 02, 2008 at 09:49:15AM +0200, Martin Michlmayr wrote:
> > * Matthew Wilcox <matthew@wil.cx> [2008-09-30 10:13]:
> > > Huh?  I've looked into it.  ARM and MIPS provide half of an API but n=
ot
> > > the other half.  These architectures are broken.
> >=20
> > Maybe, but the point is that advansys was marked as BROKEN on !X86_32
> > before and now it's not, so the ARM/MIPS compilation errors show up
> > and that's a regression.  What you say is a good argument for my patch
> > to disable advansys for ARM/MIPS in Kconfig.
>=20
> No, ARM and MIPS need to just add stub functions that do nothing.

You mean that request_dma() should always fail?  Won't that just allow
us to build a bunch of drivers for ARM and MIPS that will never work?

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-QobOJBhPnyGSF+T+4XXy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS+9g9+e/yOyVhhEJAQKT/xAAjCliSjof8zYF2YdVJbNjosUlOmKLbJvw
OAcOmvizbnYEUhBKwKZQHi9ievR2OTVbaHWf8PvPzaetaIbnL9FO1mFI1Hrgz/J8
yNd4sZk1gOXcLnxm5TshsCGE5NM8e+4fvcB7LuS53k4mK40h78GYqgcvFgu2l7La
SSxCb0IbKqE/DNIobfUiPzQutwBYFTdt2Z+CN+LE/eZJeFLaMsPLPRSbIOpNbtP1
4Tcw+hVeMiUqljHrLjYiUTai7eC4XYBpBYX7WqWbmKaHo7ShKh5qTg8cI6LbsAkB
wJ0Sts41ToXb1TPu+y8z+KqHAsMN22SgfSjssgEBHsmkBwlAgRi3pTXihsD+kcwP
epDwU+iyMwtDt6Kf6PXtU9eg5/ehBtcCHp6jKXp8i9pWyGh7KaO6lzQN6a2wFPrd
TVVivH6qGKmhYJ5uCzdb23PpiGZ71yNuH4fQpbtIHb9TAvn+In9vAeyve431MLsw
Uecyd1swMATxzSJk9Sew1pKBOIqXzLNuzhgH8W1++haAUblVScB7cqDKKBMqkqdt
5rzn87RmzX+e58F2HD1Exd+++C2sakbm46efGy98HpLBqIm6UBImjxEwaiwS2Bxt
oJrgyNzg4ejHeH/6B9T2FlfEHrLQCP6QM2VtRRyXVjKtOZpQPn7MjFGQAUDaQkLP
eF6/tD/IT7k=
=itbm
-----END PGP SIGNATURE-----

--=-QobOJBhPnyGSF+T+4XXy--
