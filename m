From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: DPC vs tasklet
Date: Thu, 20 May 2004 19:20:16 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085073616.2784.14.camel@laptop.fenrus.com>
References: <8D43EFD7CCBDB24980134BE078C227E704E37AEB@xcm.emulex.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ce4Ksb1gfcBjLrY5V7oi"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:7334 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265237AbUETRUY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2004 13:20:24 -0400
In-Reply-To: <8D43EFD7CCBDB24980134BE078C227E704E37AEB@xcm.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Infante, Jon" <Jon.Infante@Emulex.Com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, "Smart, James" <James.Smart@Emulex.Com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>


--=-ce4Ksb1gfcBjLrY5V7oi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2004-05-20 at 18:52, Infante, Jon wrote:
> Christoph,
>=20
> I was going to take your advice:
> "usage of tasklet itself is questionable, you probably want a kernel-thre=
ad"

well there's a few angles here:
1) For IO completion (eg the common, fastpath case), you don't want to
use a tasklet OR kernel-thread, just do the completion right there and
then in the ISR, since the scsi layer completion handler you call will
queue it for real work, the final completion, by the scsi softirq
already.

2) For management work, I can see the point of doing it in a
kernel-thread, since it's 1) rare (eg slowpath) 2) complex 3) code that
might want long-ish delays or allocate memory, neither of which you want
in irq context.




--=-ce4Ksb1gfcBjLrY5V7oi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBArOjQxULwo51rQBIRAhgYAKCsAkydoH6ku8vJddH6KdQWQMMGnQCfdUMG
eG37vm8dIrBBRZIrY7iepIc=
=Blw9
-----END PGP SIGNATURE-----

--=-ce4Ksb1gfcBjLrY5V7oi--

