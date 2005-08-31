From: Rudolph Pereira <rudolph@usyd.edu.au>
Subject: fc remote port timeout with qla2xxx driver
Date: Wed, 31 Aug 2005 16:01:34 +1000
Message-ID: <20050831060134.GA26115@usyd.edu.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ankara.ucc.usyd.edu.au ([129.78.64.57]:63460 "EHLO
	ankara.ucc.usyd.edu.au") by vger.kernel.org with ESMTP
	id S932375AbVHaGBm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Aug 2005 02:01:42 -0400
Received: from ankara.ucc.usyd.edu.au (localhost [127.0.0.1])
	by ankara-postfilter.ucc.usyd.edu.au (Postfix) with ESMTP id F11EF13FF6E
	for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2005 16:01:38 +1000 (EST)
Received: from moria (moria.ucc.usyd.edu.au [129.78.65.52])
	by ankara.ucc.usyd.edu.au (Postfix) with ESMTP id 3393C13FF3C
	for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2005 16:01:35 +1000 (EST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I've been trying to do some basic testing with dm-multipath and in the
course of that have hit a strange situation with the following setup:

- HBA:
scsi0 : qla2xxx
qla2300 0000:07:01.0:=20
 QLogic Fibre Channel HBA Driver: 8.01.00b5-k-debug
  QLogic QLA2342 -=20
  ISP2312: PCI-X (133 MHz) @ 0000:07:01.0 hdma-, host#=3D0, fw=3D3.03.15 IPX

going to:
Host: scsi0 Channel: 00 Id: 00 Lun: 01
  Vendor: IFT      Model: A16F-R2221       Rev: 342E
  Type:   Direct-Access                    ANSI SCSI revision: 03

on kernel 2.6.13.

The strange situation is that when disconnecting the fibre on the
disk/enclosure end and reconnecting it, the FC port is not reenabled.

I've enabled DEBUG_QLA2100 and QL_DEBUG_LEVEL_14 and am seeing the
following debug messages:

=2E..
Aug 31 15:54:33 baku kernel: scsi(0): fcport-0 - port retry count: 0 remain=
ing
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D> note, this is where I reconnect th=
e fibre
Aug 31 15:55:10 baku kernel: scsi(0): RSCN database changed -- 000b 1132.
Aug 31 15:55:10 baku kernel: scsi(0): qla2x00_loop_resync()
Aug 31 15:55:10 baku kernel: scsi(0): F/W Ready - OK=20
Aug 31 15:55:10 baku kernel: scsi(0): fw_state=3D3 curr time=3D83702.
Aug 31 15:55:10 baku kernel: scsi(0): Configure loop -- dpc flags =3D0xa0
Aug 31 15:55:10 baku kernel: scsi(0): RSCN queue entry[1] =3D [00/0b1132].
Aug 31 15:55:10 baku kernel: scsi(0): Handle RSCN -- process RSCN for port =
id [0b1132].
Aug 31 15:55:10 baku kernel: scsi(0): Handle RSCN -- attempting login to [8=
2/0b1132].
Aug 31 15:55:10 baku kernel: scsi(0): Sending Login IOCB (a0002000) to [82/=
0b1132].
Aug 31 15:55:11 baku kernel: scsi(0): Process IODesc -- processing a0002000.
Aug 31 15:55:11 baku kernel: scsi(0): Login IOCB -- port id [0b1132] alread=
y assigned to loop id [81].
Aug 31 15:55:11 baku kernel: scsi(0): Login IOCB -- retrying login to [81/0=
b1132] (2).
Aug 31 15:55:11 baku kernel: scsi(0): Sending Login IOCB (a0003000) to [81/=
0b1132].
Aug 31 15:55:11 baku kernel: scsi(0): Process IODesc -- processing a0003000.
Aug 31 15:55:11 baku kernel: scsi(0): Login IOCB -- status=3D30 mb1=3D0 pn=
=3D210000d02367d125.
Aug 31 15:55:11 baku kernel: scsi(0): Login IOCB -- found RSCN fcport in fc=
ports list [f7c84600].
Aug 31 15:55:11 baku kernel: scsi(0): Login IOCB -- marking existing fcport=
 [81/0b1132] online.
Aug 31 15:55:11 baku kernel: scsi(0): Login IOCB -- Freeing RSCN fcport f5c=
12d80 [81/0b1132].
Aug 31 15:55:11 baku kernel: scsi(0): LOOP READY
Aug 31 15:55:11 baku kernel: scsi(0): qla2x00_loop_resync - end
Aug 31 15:55:16 baku kernel: scsi(0): Port Update -- creating RSCN fcport f=
5c12d80 for 81/7/6000.
Aug 31 15:55:16 baku kernel: scsi(0): Handle RSCN -- process RSCN for fcpor=
t [ffffff].
Aug 31 15:55:16 baku kernel: scsi(0): Handle RSCN -- attempting login to [8=
1/ffffff].
Aug 31 15:55:16 baku kernel: scsi(0): Sending Login IOCB (a0004000) to [81/=
ffffff].
Aug 31 15:55:16 baku kernel: scsi(0): Port login retry: 210000d02367d125, i=
d =3D 0x0081 retry cnt=3D10
Aug 31 15:55:16 baku kernel: scsi(0): Process IODesc -- processing a0004000.
Aug 31 15:55:16 baku kernel: scsi(0): fcport-0 - port retry count: 29 remai=
ning
Aug 31 15:55:16 baku kernel: scsi(0): qla2x00_port_login()
Aug 31 15:55:16 baku kernel: scsi(0): Trying Fabric Login w/loop id 0x0081 =
for port 0b1132.
Aug 31 15:55:16 baku kernel: scsi(0): Login IOCB -- loop id [81] used by po=
rt id [0b1132].
Aug 31 15:55:16 baku kernel: scsi(0): Login IOCB -- retrying login to [81/0=
b1132] (2).
Aug 31 15:55:16 baku kernel: scsi(0): Sending Login IOCB (a0005000) to [81/=
0b1132].
Aug 31 15:55:16 baku kernel: scsi(0): Process IODesc -- processing a0005000.
Aug 31 15:55:16 baku kernel: scsi(0): Login IOCB -- status=3D0 mb1=3D0 pn=
=3D210000d02367d125.
Aug 31 15:55:16 baku kernel: scsi(0): Login IOCB -- found RSCN fcport in fc=
ports list [f7c84600].
Aug 31 15:55:16 baku kernel: scsi(0): Login IOCB -- marking existing fcport=
 [81/0b1132] online.
Aug 31 15:55:16 baku kernel: scsi(0): Login IOCB -- Freeing RSCN fcport f5c=
12d80 [81/0b1132].
Aug 31 15:55:16 baku kernel: scsi(0): port login OK: logged in ID 0x81
Aug 31 15:55:16 baku kernel: scsi(0): qla2x00_port_login - end
Aug 31 15:55:50 baku kernel:  rport-0:0-0: blocked FC remote port time out:=
 removing target

at this point, the path is no longer unavailable, whereas it should be
(everything's physically connected). The most worrying indication is the
final "blocked FC remote port time out" which seems like the port is not
being unblocked when it should.

Has anyone seen this issue, and is it known, and if so, are there any
fixes for it?

Any information about this would be appreciated.
Thanks

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDFUe+K6c0oCC40tsRAtSeAJsGt5B6GcXeXgfyhqN+2rgfZZfBQACeOifE
muv3vKryIjLNS+Ecwhnm9uo=
=L/fJ
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
