From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH] qla2xxx: silence two GCC warnings
Date: Sun, 30 Sep 2012 23:21:30 +0200
Message-ID: <3591681.K68OpP9yPi@eto>
References: <1349003274.15306.6.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1619425.UVYHHceP1Z"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:40830 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627Ab2I3VVr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Sep 2012 17:21:47 -0400
In-Reply-To: <1349003274.15306.6.camel@x61.thuisdomein>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>, linux-scsi@vger.kernel.org
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, linux-kernel@vger.kernel.org


--nextPart1619425.UVYHHceP1Z
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Sonntag 30 September 2012, 13:07:54 schrieb Paul Bolle:
> Compiling qla_gs.o (part of the qla2xxx module) triggers two GCC
> warnings:
>     drivers/scsi/qla2xxx/qla_gs.c: In function =E2=80=98qla2x00_fdmi_=
rhba=E2=80=99:
>     drivers/scsi/qla2xxx/qla_gs.c:1339:7: warning: array subscript is=
 above
> array bounds [-Warray-bounds] drivers/scsi/qla2xxx/qla_gs.c: In funct=
ion
> =E2=80=98qla2x00_fdmi_register=E2=80=99: drivers/scsi/qla2xxx/qla_gs.=
c:1663:15: warning:
> array subscript is above array bounds [-Warray-bounds]
>=20
> It seems that the sequence of a strcpy followed by a strlen confuses =
GCC
> when it is keeping track of array bounds here. (It is not clear to me=

> which array triggers this warning and by how much GCC thinks the
> subscript is above its bounds. Neither is it clear to me why comparab=
le
> code in these two functions doesn't trigger this warning.)
>=20
> The easiest way to silence these warnings is to hardcode the length o=
f
> these two strings in the code here. The length used here is the lengt=
h
> of the string, including its NUL terminator, rounded up to the next
> multiple of four.

This adds some magic values, which is asking for trouble once someone c=
hanges=20
the manufacturer string or something. What about something like this:

const char *qlogic =3D "QLogic Corporation";
strcpy(eiter->a.manufacturer, qlogic);
alen +=3D round_up(strlen(qlogic), 4);
...

Eike
--nextPart1619425.UVYHHceP1Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAlBot+AACgkQXKSJPmm5/E5WcQCfWjNqE5yJHPEMHHBRFq++DQ4B
+CsAoKThjAOhtJoAYJ4M0QeMTS+kHiM7
=z0Rh
-----END PGP SIGNATURE-----

--nextPart1619425.UVYHHceP1Z--

