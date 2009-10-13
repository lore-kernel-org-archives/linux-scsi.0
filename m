From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [RFC][PATCH v3]Add pm8001 SAS/SATA HBA driver
Date: Tue, 13 Oct 2009 13:05:36 +0200
Message-ID: <200910131305.41047.eike-kernel@sf-tec.de>
References: <9A9AF0C219C5433DB5A8D61D4914C599@usish.com.cn> <da824cf30910091937l761e1b8bo311dc2a0bbf1c115@mail.gmail.com> <D7F4135C8933429C8019D47D3DB5A7D0@usish.com.cn>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2429481.ZxZ63OebOl";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:41858 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbZJMLG1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Oct 2009 07:06:27 -0400
In-Reply-To: <D7F4135C8933429C8019D47D3DB5A7D0@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jack wang <jack_wang@usish.com>
Cc: 'James Bottomley' <James.Bottomley@suse.de>, 'Grant Grundler' <grundler@google.com>, 'lindar_liu' <lindar_liu@usish.com>, matthew@wil.cx, linux-scsi@vger.kernel.org, tom_peng@usish.com, 'aoqingy' <aoqingyun@usish.com>, roy_wang@usish.com

--nextPart2429481.ZxZ63OebOl
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

jack wang wrote:
> Hi James
> Here is an updated driver patch that incorporates all the latest review
> inputs from Grant and Eike.
> Best wishes,
> Jack

+static inline u32 pm8001_read_le_32(void *virt_addr)
+{
+	return *((u32 *)((u8 *)virt_addr));
+}

The cast to u8* isn't needed.

+static inline void pm8001_write_le_32(void *addr, u32 offset, u32 val)
+{
+	*((u32 *)(((u8 *)addr)+(offset))) =3D val;
+}

void* can be added, it's a gcc extension the Linux kernel uses just=20
everywhere. So at the end this could boil down to:

*((u32 *)(addr + offset)) =3D val;

And if you have _le_32 the value passed in and returned from=20
pm8001_read_le_32() should probably be le32 instead of u32 so you can get=20
sparse checks for that.

Greetings,

Eike

--nextPart2429481.ZxZ63OebOl
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkrUXwQACgkQXKSJPmm5/E5HbgCeI3Nz8lCDOYSjJJtoRS9IHgcx
HC8AoIIxHZcSroqV04fpSIbz3JUGbZp9
=Fa3T
-----END PGP SIGNATURE-----

--nextPart2429481.ZxZ63OebOl--
