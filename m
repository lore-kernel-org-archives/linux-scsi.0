From: Kilian CAVALOTTI <kilian.cavalotti@lip6.fr>
Subject: SCSI errors with multipath IO
Date: Wed, 17 May 2006 20:26:26 +0200
Message-ID: <200605172026.26745.kilian.cavalotti@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kick.jknet.org ([82.231.159.30]:28678 "EHLO smtp.jknet.org")
	by vger.kernel.org with ESMTP id S1750854AbWEQS0X convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 14:26:23 -0400
Received: from spip.jknet.org (spip.jknet.org [192.168.0.8])
	by smtp.jknet.org (Postfix) with ESMTP id 4FF6876F74
	for <linux-scsi@vger.kernel.org>; Wed, 17 May 2006 20:26:19 +0200 (CEST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I have a problem with a file server setup, using mdadm multipath featur=
es.

The host has two identical HBAs (LSI Logic U320, using mptspi module fr=
om=20
2.6.16), each of them is linked to a dual channel SCSI-to-SATA RAID Sub=
system=20
(http://www.infortrend.com/2_product/a16u-g1410.asp). This way, I aim t=
o have=20
a redundant IO path to the disks array to assure failover.

I created the MD device using mdadm:
mdadm --create /dev/md0 -n 2 --level=3Dmultipath /dev/sdb /dev/sdc
I also tried with multipath-tools, and that works great until some poin=
t,=20
where I get the following errors:

sd 3:0:0:0: SCSI error: return code =3D 0xb0000
end_request: I/O error, dev sdc, sector 439427200
device-mapper: dm-multipath: Failing path 8:32.
end_request: I/O error, dev sdc, sector 439427208
mptbase: ioc2: LogInfo(0x11070000): F/W: DMA Error
mptbase: ioc2: IOCStatus(0x004b): SCSI IOC Terminated
mptbase: ioc2: LogInfo(0x11070000): F/W: DMA Error
mptbase: ioc2: IOCStatus(0x004b): SCSI IOC Terminated
=2E..

The part I'm curious about is the "SCSI error: return code =3D 0xb0000"=
=2E What=20
does that mean?
This error appears randomly on both interfaces, under heavy I/O. And it=
 does=20
not seems to occur when using only one interface (/dev/sdb directly, ra=
ther=20
than /dev/md0 or /dev/mapper/<id>.

Is this a mpt or md related problem?

Thanks in advance for any hint,
--=20
Kilian CAVALOTTI                      Administrateur r=C3=A9seaux et sy=
st=C3=A8mes
UPMC / CNRS - LIP6 (C870)
8, rue du Capitaine Scott                          Tel. : 01 44 27 88 5=
4
75015 Paris - France                               Fax. : 01 44 27 70 0=
0
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
