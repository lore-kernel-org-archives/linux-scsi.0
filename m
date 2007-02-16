From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] drivers/scsi/aic7xxx_old: Convert to generic
	boolean-values
Date: Fri, 16 Feb 2007 16:43:04 -0500
Message-ID: <1171662184.3161.245.camel@fc6.xsintricity.com>
References: <20070210174628.3764.89569.sendpatchset@thinktank.campus.ltu.se>
	 <1171132062.3373.31.camel@mulgrave.il.steeleye.com>
	 <20070212122738.b5e9a8af.akpm@linux-foundation.org>
	 <1171644132.3443.27.camel@mulgrave.il.steeleye.com>
	 <20070216103422.51757e89.akpm@linux-foundation.org>
	 <1171651347.3443.45.camel@mulgrave.il.steeleye.com>
	 <20070216105026.7bd17a79.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-094ve+/cXXwKfbpzhaF5"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbXBPVpf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Feb 2007 16:45:35 -0500
In-Reply-To: <20070216105026.7bd17a79.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, ricknu-0@student.ltu.se, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


--=-094ve+/cXXwKfbpzhaF5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-02-16 at 10:50 -0800, Andrew Morton wrote:

> Me no understand.
>=20
> If you take the specific example of
>=20
> void
> ahd_set_syncrate(struct ahd_softc *ahd, struct ahd_devinfo *devinfo,
> 		 u_int period, u_int offset, u_int ppr_options,
> 		 u_int type, int paused)
>=20
> then if is crufty, inappropriate and wrong that `paused' is a scalar type=
.

Although you picked a code segment out of the modern aic7xxx, there is a
matching similar one in aic7xxx_old.  Now, in all fairness, I was at one
point playing with a much more preemptable model for that driver that
allowed nested pauses, at which point the value of pause would have made
sense to be scalar, but that was a *long* time ago.

> =20
> It's just not true or sensible that the code is written so that `paused'
> can take a value of seventy eight.  It _is_ a boolean.  It is a truth
> value.  Declaring it as such in the source is all goodness.  Passing the
> value `true' into calls to this function improve readability over passing
> "1".

Hence the reason for the original upper case TRUE/FALSE.  I have to
admit, I don't really like the lower case true/false, it looks like a
variable that can be assigned, thereby changing the implementation of
the function call when in fact each calling location is hard coding a
constant.  But, that's just me and my crufty old C that differentiates
between hard coded things and variables via case.

> So I don't agree with (or understand) your objections.  But I can certain=
ly
> understand reluctance to merge a large-but-minor, do-nothing-much patch i=
nto
> a large and not-very-maintained driver.

Hehehe...and here I was thinking of factoring that thing into files and
actually bringing it into the current century.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-094ve+/cXXwKfbpzhaF5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBF1iVoTzP9PM7pjw8RAo6jAJ0Z+jzaqOoNJGmy4I7MsjJdB0naWgCfUd4p
T82dgbkJ193VLeVBvP48upg=
=98iZ
-----END PGP SIGNATURE-----

--=-094ve+/cXXwKfbpzhaF5--

