From: Florian Lohoff <flo@rfc822.org>
Subject: Re: 2.6.3 gdth driver NMI Watchdog detected LOCKUP
Date: Sun, 28 Mar 2004 16:55:51 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040328145550.GA13566@paradigm.rfc822.org>
References: <B51CDBDEB98C094BB6E1985861F53AF302DD6E@nkse2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <B51CDBDEB98C094BB6E1985861F53AF302DD6E@nkse2k01.adaptec.com>
To: "Leubner, Achim" <Achim_Leubner@adaptec.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 26, 2004 at 01:49:24PM +0100, Leubner, Achim wrote:
> Hi,
>=20
> thanks for reporting this problem. I will include the change into our new=
 driver version and will send a patch for 2.6.4 on Monday next week to Linu=
s.
>=20

I dont think this patch will be sufficient - There is another problem
with the driver - What for example happens if we are in the
gdth_interrupt - we do have locked the HA because we are not in polling
mode. Then the error handler kicks in and sets polling_mode to TRUE -
Now the gdth_interrupt will not unlock the HA which will get one cpu to
keep spinning in the error handler.

I think calling the gdth_interrupt in polling and non-polling mode is
bogus by design.

Flo
--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
                        Heisenberg may have been here.

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAZud2Uaz2rXW+gJcRAgQDAJsE8T6LL9KL5WfY00lfF4vB7tDEzwCgiwRg
kNHP90l900caf6sob+rOsgQ=
=Hm6k
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
