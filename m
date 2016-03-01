From: Yves-Alexis Perez <corsac@corsac.net>
Subject: Re: Page allocation failure (order 7) in UAS code
Date: Tue, 01 Mar 2016 12:20:43 +0100
Message-ID: <1456831243.3303.0.camel@corsac.net>
References: <1456825361.17330.9.camel@corsac.net>
	 <56D573CF.1000600@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-ZrNX1z3i7uxmVe3YoVEQ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pic75-3-78-194-244-226.fbxo.proxad.net ([78.194.244.226]:36958
	"EHLO molly.corsac.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbcCALUv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2016 06:20:51 -0500
Received: from corsac.net (unknown [IPv6:2a01:e34:ec2f:4e21::2])
	by molly.corsac.net (Postfix) with ESMTPS id 43BF278
	for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2016 12:20:47 +0100 (CET)
In-Reply-To: <56D573CF.1000600@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org


--=-ZrNX1z3i7uxmVe3YoVEQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On mar., 2016-03-01 at 11:49 +0100, Hans de Goede wrote:
> Can you try building a kernel with the following line in
> drivers/usb/storage/uas.c :
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .can_queue =3D 65536,=C2=
=A0=C2=A0=C2=A0=C2=A0 /* Is there a limit on the _host_ ? */
>=20
> (around line 815) Replaced with
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .can_queue =3D MAX_CMNDS=
,
>=20
> That should help as MAX_CMNDS is 256, so claiming that we can queue more
> is not helpful, and that likely is what is causing this quite high order
> alloc.

Hi,

I've rebuilt a 4.4.3 + above patch. I'll report back in few hours to see if=
 I
can still reproduce.

Regards,
--=20
Yves-Alexis


--=-ZrNX1z3i7uxmVe3YoVEQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJW1XsLAAoJEG3bU/KmdcCloyQH/2RrTdWv8y2ebgqh749OXUAM
PIc1TRHk5+BBEdJhCpzn3DqQc5h41BmVG5c5rJRp5UiPhUHZA4O8HAu/5bvxH/Fh
jUgcdMlEU5KoIAepiBpF97RA/yp9qpSBiPJdwk1rnZR8WdFvjgUyf8wapxT761h/
IcMSdbPTHxcoVAIPmojS5TNo+bpA0FvX4FN6yeK4WuREeXlz7Ra2DOMqa+0ma5M5
je/Tp2zV800xqVKd8R7+shYBBrY9KcEXhlcLr3bb/+j4VblRu6Ep7vR14tR9WwT4
G0Xq8KOvJ5/SAhnXK5b9ect9UdKVHE1IBocOEZdsbm698rvAYXS5xcEi4N28/HA=
=qCPX
-----END PGP SIGNATURE-----

--=-ZrNX1z3i7uxmVe3YoVEQ--
