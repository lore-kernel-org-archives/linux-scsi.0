From: Stefan =?ISO-8859-1?Q?V=F6lkel?= <stefan.voelkel@millenux.com>
Subject: Re: Patch: s390 root on scsi disc
Date: Sat, 19 Jun 2004 16:39:00 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087663139.26437.43.camel@localhost>
References: <1087661628.26436.30.camel@localhost>
	 <20040619142738.GA6062@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-s1dZaqcMe9hvV0JohiQP"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ping.topalis.com ([195.243.109.4]:52943 "EHLO ping.topalis.com")
	by vger.kernel.org with ESMTP id S263932AbUFSOkg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Jun 2004 10:40:36 -0400
In-Reply-To: <20040619142738.GA6062@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Heiko Carstens <Heiko.Carstens@de.ibm.com>


--=-s1dZaqcMe9hvV0JohiQP
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

On Sat, 2004-06-19 at 14:27, Christoph Hellwig wrote:
> --- zfcp_aux.c.orig	2004-06-19 16:01:25.000000000 +0000
> +++ zfcp_aux.c	2004-06-19 16:00:01.000000000 +0000
> @@ -146,6 +146,17 @@
>  module_param(flags_dump, uint, 0);
>  #endif
> =20
> +#ifndef MODULE
> +/* remember kernel boot time parameter */
> +static int __init zfcp_device(char *str)
> +{
> +	device =3D str;
> +	return 1;
> +}
> +
> +__setup("zfcpdevice=3D", zfcp_device);
> +#endif
>=20
> please use module_param instead.  still wondering why zfcp needs paramter=
s
> anyway..

Well, my problem was that passing device=3Dfoo at boot time (zfcp compiled
into the kernel) resulted in device beeing empty. device is

        module_param(device, charp, 0);
        MODULE_PARM_DESC(device, "specify initial device");

regards
	Stefan
--=20
Stefan V=F6lkel                            stefan.voelkel@millenux.com
Millenux GmbH                              mobile: +49.170.79177.17
Lilienthalstra=DFe 2                          phone: +49.711.88770.300
70825 Stuttgart-Korntal                       fax: +49.711.88770.349
     -=3D linux without limits -=3D- http://linux.zSeries.org/ =3D-

--=-s1dZaqcMe9hvV0JohiQP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBA1GwjtWF28C4HGsQRAl3BAKCHVlVTSN2zHTfx38ZiAVNmGU6htgCgpzyQ
qY1f7deQv4Y97ZBza/JOnKY=
=GzTF
-----END PGP SIGNATURE-----

--=-s1dZaqcMe9hvV0JohiQP--

