From: Andre Noll <maan@systemlinux.org>
Subject: Re: qla2xxx BUG: workqueue leaked lock or atomic
Date: Thu, 8 Mar 2007 11:29:36 +0100
Message-ID: <20070308102936.GD4252@skl-net.de>
References: <20070226182617.GC9968@andrew-vasquezs-computer.local> <20070227101100.GA22572@skl-net.de> <20070227185134.GJ20397@andrew-vasquezs-computer.local> <20070228151829.GI22572@skl-net.de> <20070228153722.GJ22572@skl-net.de> <20070307184641.GY20362@kernel.dk> <20070308085209.GB4252@skl-net.de> <20070308090247.GB9671@kernel.dk> <20070308093331.GC4252@skl-net.de> <20070308093651.GC9671@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="F8dlzb82+Fcn6AgP"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:41406 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbXCHKaJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Mar 2007 05:30:09 -0500
Content-Disposition: inline
In-Reply-To: <20070308093651.GC9671@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>


--F8dlzb82+Fcn6AgP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10:36, Jens Axboe wrote:
> - Edit .config and set CONFIG_DEBUG_INFO=3Dy (near the bottom)
> - make oldconfig
> - rm block/cfq-iosched.o
> - make block/cfq-iosched.o
> - gdb block/cfq-iosched.o
>=20
> (gdb) l *cfq_dispatch_insert+0x28
>=20
> and see what that says. Should not take you more than a minute or so,
> would appreciate it!

No problem, here we go:

# gdb block/cfq-iosched.o
GNU gdb 6.4-debian
Copyright 2005 Free Software Foundation, Inc.
GDB is free software, covered by the GNU General Public License, and you are
welcome to change it and/or distribute copies of it under certain condition=
s.
Type "show copying" to see the conditions.
There is absolutely no warranty for GDB.  Type "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu"...Using host libthread_db lib=
rary "/lib/libthread_db.so.1".

(gdb) l *cfq_dispatch_insert+0x28
0xcf8 is in cfq_dispatch_insert (block/cfq-iosched.c:865).
860     }
861
862     static void cfq_dispatch_insert(request_queue_t *q, struct request =
*rq)
863     {
864             struct cfq_data *cfqd =3D q->elevator->elevator_data;
865             struct cfq_queue *cfqq =3D RQ_CFQQ(rq);
866
867             cfq_remove_request(rq);
868             cfqq->on_dispatch[rq_is_sync(rq)]++;
869             elv_dispatch_sort(q, rq);

Regards
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--F8dlzb82+Fcn6AgP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFF7+WQWto1QDEAkw8RAkhrAJ9hdhcp4Hpl/oRH7BmPC46HD/RpGACdHA1+
pwrhp8LGW5UnKm90ObormtY=
=bJAt
-----END PGP SIGNATURE-----

--F8dlzb82+Fcn6AgP--
