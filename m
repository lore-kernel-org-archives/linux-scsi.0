From: "Richard F. Rebel" <rrebel@whenu.com>
Subject: Boot order of LSI MPT Fusion devices controllable?
Date: Tue, 30 Nov 2004 12:20:24 -0500
Message-ID: <1101835224.1779.1040.camel@rebel.corp.whenu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-M2vG0p2DEtGgu+Mks5dh"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from garibaldi.swishmail.com ([209.10.110.70]:54030 "HELO
	garibaldi.swishmail.com") by vger.kernel.org with SMTP
	id S262206AbUK3RYX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2004 12:24:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--=-M2vG0p2DEtGgu+Mks5dh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hello,

I am running mdk 10.0 with kernel 2.6.3-16 out of box on a dual opteron
250 system.  The system has a LSI logic U320 controller with 7 internal
disks on two channels.

We are upgrading our system by adding an identical server and a small
SAN so we can have an active passive failover cluster for MySQL.

I purchased quad port 2gbps fc cards from LSI as I have been very happy
with the performance of the SCSI cards we already own.  Upon install,
dmesg shows:

Fusion MPT base driver 3.00.03
Copyright (c) 1999-2003 LSI Logic Corporation
mptbase: Initiating ioc0 bringup
ioc0: FC929X: Capabilities=3D{Initiator,Target,LAN}
mptbase: Initiating ioc1 bringup
ioc1: FC929X: Capabilities=3D{Initiator,Target,LAN}
mptbase: Initiating ioc2 bringup
ioc2: FC929X: Capabilities=3D{Initiator,Target,LAN}
mptbase: Initiating ioc3 bringup
ioc3: FC929X: Capabilities=3D{Initiator,Target,LAN}
mptbase: Initiating ioc4 bringup
ioc4: 53C1030: Capabilities=3D{Initiator}
mptbase: Initiating ioc5 bringup
ioc5: 53C1030: Capabilities=3D{Initiator}
SCSI subsystem initialized
Fusion MPT SCSI Host driver 3.00.03
scsi0 : ioc0: LSIFC929X, FwRev=3D01010b00h, Ports=3D1, MaxQ=3D1023, IRQ=3D2=
5
scsi1 : ioc1: LSIFC929X, FwRev=3D01010b00h, Ports=3D1, MaxQ=3D1023, IRQ=3D2=
6
scsi2 : ioc2: LSIFC929X, FwRev=3D01010b00h, Ports=3D1, MaxQ=3D1023, IRQ=3D2=
7
scsi3 : ioc3: LSIFC929X, FwRev=3D01010b00h, Ports=3D1, MaxQ=3D1023, IRQ=3D2=
4
scsi4 : ioc4: LSI53C1030, FwRev=3D01013d00h, Ports=3D1, MaxQ=3D255, IRQ=3D2=
9
  Vendor: SEAGATE   Model: ST336753LC        Rev: 0006
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SEAGATE   Model: ST336753LC        Rev: 0006
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SEAGATE   Model: ST336753LC        Rev: 0006
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SEAGATE   Model: ST336753LC        Rev: 0006
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi5 : ioc5: LSI53C1030, FwRev=3D01013d00h, Ports=3D1, MaxQ=3D255, IRQ=3D3=
0
  Vendor: SEAGATE   Model: ST336753LC        Rev: 0006
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SEAGATE   Model: ST336753LC        Rev: 0006
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SEAGATE   Model: ST336753LC        Rev: 0006
  Type:   Direct-Access                      ANSI SCSI revision: 03

Well, the difference is that the fiber channel card seems to boot first,
and thus reorders the scsi bus.  If I attach the fiber channel cables to
the switch (making all of our storage visible) and re-probe the scsi bus
by hand using the /dev interface, access to the SAN is fine etc.  Upon
reboot with the fc connected, my system panics because now the root
drive is no longer where it thinks it should be (sda is now a device on
the fiber channel switch fabric).

Is there a way to control this process or to mitigate the problem?  I
really need the system to boot properly off of local disk whether or not
the fc is connected or the devices available.

Thanks,

Richard F. Rebel

--=-M2vG0p2DEtGgu+Mks5dh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBrKvYx1ZaISfnBu0RAmEAAJ9WBo9vEmXMOYR6KkMVbFviCz2E5QCffx/5
FerBPERUVL5rxn1dM+HaQkY=
=kjha
-----END PGP SIGNATURE-----

--=-M2vG0p2DEtGgu+Mks5dh--

