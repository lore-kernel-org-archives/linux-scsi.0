From: Andre Noll <maan@systemlinux.org>
Subject: Re: qla2xxx BUG: workqueue leaked lock or atomic
Date: Wed, 7 Mar 2007 18:09:55 +0100
Message-ID: <20070307170955.GA4252@skl-net.de>
References: <20070226133153.GC4095@skl-net.de> <20070226182617.GC9968@andrew-vasquezs-computer.local> <20070227101100.GA22572@skl-net.de> <20070227185134.GJ20397@andrew-vasquezs-computer.local> <20070228151829.GI22572@skl-net.de> <20070228153722.GJ22572@skl-net.de> <20070306203952.471218df.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965412AbXCGRKY@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070306203952.471218df.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>, Adrian Bunk <bunk@stusta.de>
List-Id: linux-scsi@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 20:39, Andrew Morton wrote:
> On Wed, 28 Feb 2007 16:37:22 +0100 Andre Noll <maan@systemlinux.org> wrot=
e:
>=20
> > On 16:18, Andre Noll wrote:
> >=20
> > > With 2.6.21-rc2 I am unable to reproduce this BUG message. However,
> > > writing to both raid systems at the same time via lvm still locks up
> > > the system within minutes.
> >=20
> > Screenshot of the resulting kernel panic:
> >=20
> > 	http://systemlinux.org/~maan/shots/kernel-panic-21-rc2-huangho2.png
> >=20
>=20
> It died in CFQ.  Please try a different IO scheduler.  Use something
> like
>=20
> 	echo deadline > /sys/block/sda/queue/scheduler
>=20
> This could still be the old qla2xxx bug, or it could be a new qla2xxx bug,
> or it could be a block bug, or it could be an LVM bug.

OK. I'm running with deadline right now. But I guess this kernel
panic was caused by an LVM bug because lockdep reported problems with
LVM. Nobody responded to my bug report on the LVM mailing list (see
http://www.redhat.com/archives/linux-lvm/2007-February/msg00102.html).

Non-working snapshots and no help from the mailing list convinced me
to ditch the lvm setup [1] in favour of linear software raid. This
means I can't do lvm-related tests any more.

BTW: Are ext3 filesystem sizes greater than 8T now officially
supported?

Thanks
Andre

[1] vg of two hardware raids, 10T together, a single lv and some snapshots
--=20

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFF7vHjWto1QDEAkw8RAkZdAKCRiDjS3z62bHLfHqhbCDbBgTgJYwCfSA9O
Chbn1P57DdIY8mvJ781K5rg=
=EJJc
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
