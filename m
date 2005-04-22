From: David Zanetti <david.zanetti@catalyst.net.nz>
Subject: mpt performance differences
Date: Fri, 22 Apr 2005 13:45:45 +1200
Message-ID: <1114134345.28172.104.camel@statler>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gBF/KX4L/W1tBQ1juU1Y"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from godel.catalyst.net.nz ([202.49.159.12]:29848 "EHLO
	mail1.catalyst.net.nz") by vger.kernel.org with ESMTP
	id S261913AbVDVBny (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Apr 2005 21:43:54 -0400
Received: from leibniz.catalyst.net.nz ([202.49.159.7] helo=statler.wgtn.cat-it.co.nz)
	by mail1.catalyst.net.nz with esmtp (Exim 4.34)
	id 1DOnCy-0002cn-FI
	for linux-scsi@vger.kernel.org; Fri, 22 Apr 2005 13:43:52 +1200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--=-gBF/KX4L/W1tBQ1juU1Y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi there!

We have two machines, both with LSI MPT Fusion SCSI cards in them. They
have the same CPUs, memory, etc. Their disk performance is quite
different however.

The two machines are "crusaders" and "minsk". They're both dual Operton
servers, with six 10k 72G SCA disks in them, arranged as software
RAID-10. RAM in both is the same, 4G. Both are running Debian sarge
AMD64.=20

Initally we dismissed the huge difference in hdparm -tT numbers as just
hdparm not really being a useful test, so we've run bonnie with default
settings, and there's still quite a difference between them:

Minsk
=3D=3D=3D=3D=3D
Version  1.03       ------Sequential Output------ --Sequential Input- --Ran=
dom-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --See=
ks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec=
 %CP
minsk            8G 54409  98 147492  32 18438   5 25201  44 32090   6 601.=
4  1
                    ------Sequential Create------ --------Random Create----=
----
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Dele=
te--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec=
 %CP
                 16  5569  99 +++++ +++ +++++ +++  5819  99 +++++ +++ 20239=
  99
/dev/md3:
 Timing cached reads:   3432 MB in  2.00 seconds =3D 1715.40 MB/sec
 Timing buffered disk reads:  224 MB in  3.02 seconds =3D  74.13 MB/sec

Crusaders
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Version  1.03       ------Sequential Output------ --Sequential Input- --Ran=
dom-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --See=
ks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec=
 %CP
crusaders        8G 52445  95 104509  19 21752   6 30754  54 86996  17 520.=
5  1
                    ------Sequential Create------ --------Random Create----=
----
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Dele=
te--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec=
 %CP
                 16  5824  99 +++++ +++ +++++ +++  5917  99 +++++ +++ 19196=
  99
/dev/md1:
 Timing cached reads:   3836 MB in  2.00 seconds =3D 1916.37 MB/sec
 Timing buffered disk reads:  418 MB in  3.00 seconds =3D 139.17 MB/sec

The bit we're concerned about is the read speeds, block is way lower on
minsk than crusaders.

Kernel used is 2.6.12-rc3 with 3.03.00 patches from lsil.com applied.
I've tried various combinations of kernel, without any improvement.
We've also tried the kernel on crusaders, but performance was even worse
then (as in, around 3M/s, instead of 30 we get now..)

We suspect it's caused by a quirk of a newer version of the silicon on
the controller, they're slightly different in lspci:

Minsk
=3D=3D=3D=3D=3D
0000:03:02.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030
PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 08)
        Subsystem: LSI Logic / Symbios Logic: Unknown device 1060
        Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 30
        I/O ports at 3000 [size=3D256]
        Memory at fe120000 (64-bit, non-prefetchable) [size=3D128K]
        Memory at fe100000 (64-bit, non-prefetchable) [size=3D128K]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Message Signalled Interrupts: 64bit+
Queue=3D0/0 Enable-
        Capabilities: [68] PCI-X non-bridge device.

Crusaders
=3D=3D=3D=3D=3D=3D=3D=3D=3D
0000:03:02.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030
PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 07)
        Subsystem: LSI Logic / Symbios Logic: Unknown device 1060
        Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 30
        I/O ports at 4000 [size=3D256]
        Memory at fe120000 (64-bit, non-prefetchable) [size=3D128K]
        Memory at fe100000 (64-bit, non-prefetchable) [size=3D128K]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Message Signalled Interrupts: 64bit+
Queue=3D0/0 Enable-
        Capabilities: [68] PCI-X non-bridge device.

Has anyone else seen this effect, or aware of a possible cause?

Thanks!

--=20
David Zanetti <david.zanetti@catalyst.net.nz>
Team Leader, Systems Administration
Catalyst IT Limited
+64-4-8032233 +64-21-402260

--=-gBF/KX4L/W1tBQ1juU1Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBCaFdJei0cZZ0ajFMRAsoYAKCGjLbf3c+5nJOh/+uS2cy2k62B9ACgvD6f
kQ/O/X1cQl728WcKDp4wk3A=
=EK4g
-----END PGP SIGNATURE-----

--=-gBF/KX4L/W1tBQ1juU1Y--

