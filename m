From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [RFC][PATCH v2]Add pm8001 SAS/SATA HBA driver
Date: Sat, 10 Oct 2009 21:27:10 +0200
Message-ID: <200910102127.17843.eike-kernel@sf-tec.de>
References: <9A9AF0C219C5433DB5A8D61D4914C599@usish.com.cn> <9510C503D9D946EDB9AD0B61044881EF@usish.com.cn> <da824cf30910091937l761e1b8bo311dc2a0bbf1c115@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart16521694.kAZkucbelN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:34931 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934621AbZJJT15 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Oct 2009 15:27:57 -0400
In-Reply-To: <da824cf30910091937l761e1b8bo311dc2a0bbf1c115@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: jack wang <jack_wang@usish.com>, James Bottomley <James.Bottomley@suse.de>, lindar_liu <lindar_liu@usish.com>, matthew@wil.cx, linux-scsi@vger.kernel.org, tom_peng@usish.com, aoqingy <aoqingyun@usish.com>, roy_wang@usish.com

--nextPart16521694.kAZkucbelN
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Grant Grundler wrote:

> Later in the patch I see:
> +       pm8001_ha->tags =3D kmalloc(sizeof(unsigned long)*PM8001_MAX_DEVI=
CES,
> +               GFP_KERNEL);
>=20
> What are we limiting to 1024 devices? LUNS?
> I noticed the constant was also used in an initialization loop too.

There are some other things that I find suspicious at this point:

=2Dfor allocations of array kcalloc() is usually the way to go as it does=20
overflow checks for the multiplication result (not needed here with the=20
current values, but doesn't really hurt in init path either)
=2Dusing sizeof(*pm8001_ha->tags) would make sure it's the correct size no=
=20
matter what type this will ever be, because ...
=2Dunsigned long has different size on 32 and 64 bit, I don't know if that =
makes=20
sense here. AFAICT this is sort of bitmap here so this probably doesn't nee=
d=20
to double it's size on 64 bit.

Greetings,

Eike

--nextPart16521694.kAZkucbelN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkrQ4BUACgkQXKSJPmm5/E4kvwCgmNaN5cOlkNow3tGQrq+ABVd8
BV0An2ZSpHII0KzP7T1fIuPZfGht/GTu
=iOmz
-----END PGP SIGNATURE-----

--nextPart16521694.kAZkucbelN--
