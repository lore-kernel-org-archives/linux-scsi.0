From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 1/2] Consolidate min_not_zero
Date: Fri, 10 Sep 2010 15:20:39 +0200
Message-ID: <201009101520.47005.eike-kernel@sf-tec.de>
References: <1284096730-13147-1-git-send-email-martin.petersen@oracle.com> <1284096730-13147-2-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1324401.C7Q55ZHVkp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:42460 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938Ab0IJNUw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Sep 2010 09:20:52 -0400
In-Reply-To: <1284096730-13147-2-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com, christof.schmitt@de.ibm.com, linux-scsi@vger.kernel.org

--nextPart1324401.C7Q55ZHVkp
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Martin K. Petersen wrote:
> We have several users of min_not_zero, each of them using their own
> definition.  Move the define to kernel.h.

=46or whatever reason this one hit my inbox way later than the previous one=
=2E=20
Anyone, the same concern:

> +/*
> + * Returns the minimum that is _not_ zero, unless both are zero.
> + */
> +#define min_not_zero(__x, __y) ({		\
> +	__x =3D=3D 0 ? __y : ((__y =3D=3D 0) ? __x : min(__x, __y)); })
> +

This will evaluate the value of __x and __y multiple times. Something like=
=20
this should be better (untested):

define min_not_zero(__x, __y) ({                \
        typeof(__x) _minz1 =3D (__x);                     \
        typeof(__y) _minz2 =3D (__y);                     \
        _minz1 =3D=3D 0 ? _minz2 : ((_minz2 =3D=3D 0) ? _minz1 : min(_minz1=
, _minz2));=20
})

Eike

--nextPart1324401.C7Q55ZHVkp
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkyKMK4ACgkQXKSJPmm5/E4FyQCdE0unQWzbxcgLQ7hbrRV6T+Ln
rgIAnig9QI6kgzQjxgGrwTTMtTBbKZub
=wkJO
-----END PGP SIGNATURE-----

--nextPart1324401.C7Q55ZHVkp--
