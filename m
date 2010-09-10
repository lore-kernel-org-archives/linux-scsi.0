From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 1/2] Consolidate min_not_zero
Date: Fri, 10 Sep 2010 10:13:51 +0200
Message-ID: <201009101014.00667.eike-kernel@sf-tec.de>
References: <1284095925-12841-1-git-send-email-martin.petersen@oracle.com> <1284095925-12841-2-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4985245.lrTXmFUr6I";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:48881 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401Ab0IJIUp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Sep 2010 04:20:45 -0400
In-Reply-To: <1284095925-12841-2-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com, christof.schmitt@de.ibm.com, linux-scsi@vger.kernel.org

--nextPart4985245.lrTXmFUr6I
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -636,6 +636,12 @@ static inline void ftrace_dump(enum ftrace_dump_mode
> oops_dump_mode) { } (void) (&_max1 =3D=3D &_max2);		\
>  	_max1 > _max2 ? _max1 : _max2; })
>=20
> +/*
> + * Returns the minimum that is _not_ zero, unless both are zero.
> + */
> +#define min_not_zero(__x, __y) ({		\
> +	__x =3D=3D 0 ? __y : ((__y =3D=3D 0) ? __x : min(__x, __y)); })
> +
>  /**
>   * clamp - return a value clamped to a given range with strict
> typechecking * @val: current value

This will evaluate the value of __x and __y multiple times. Something like=
=20
this should be better (untested):

define min_not_zero(__x, __y) ({		\
	typeof(__x) _minz1 =3D (__x);			\
	typeof(__y) _minz2 =3D (__y);			\
	_minz1 =3D=3D 0 ? _minz2 : ((_minz2 =3D=3D 0) ? _minz1 : min(_minz1, _minz=
2)); })

Eike

--nextPart4985245.lrTXmFUr6I
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkyJ6MgACgkQXKSJPmm5/E6QvwCgjm1nohX/9nHfwKI5a5FdYUL3
HFgAnAjVg6/VxCVMXMfvDNHP2mhrsFYY
=vOct
-----END PGP SIGNATURE-----

--nextPart4985245.lrTXmFUr6I--
