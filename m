From: Laurence Oberman <loberman@redhat.com>
Subject: Re: st driver doesn't seem to grok LTO partitioning
Date: Wed, 6 Jan 2016 10:23:34 -0500 (EST)
Message-ID: <1993563395.3556606.1452093814452.JavaMail.zimbra@redhat.com>
References: <20151218170644.24167419@harpe.intellique.com> <20151230222418.03e40cf7@harpe.intellique.com> <AC6651F8-0642-42DF-A3B1-72C5A8D8E665@kolumbus.fi> <alpine.LSU.2.11.1601041219340.1615@xnv.znxvfnen.cevingr> <20160104124626.3112e8c0@harpe.intellique.com> <CAAzz28iCoG-rjnL7EsjHXA7UtRJSCEXuwL3+27ZBo7fckcBAfg@mail.gmail.com> <688812570.3359420.1452030904683.JavaMail.zimbra@redhat.com> <20160106161049.34f29973@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:49161 "EHLO
	mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbcAFPXq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2016 10:23:46 -0500
In-Reply-To: <20160106161049.34f29973@harpe.intellique.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Laurence Oberman <oberman.l@gmail.com>, Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org

Hello Emanuel

I am using this device, its an Ultrium 5 (LTO5)
Its an older changer and I am unable to update the firmware, still work=
ing on that.

What version of mt are you using, as I am testing using a RHEL7.2 base =
and the upstream patched kernel.

Linux example.redhat.com 4.3.3 #1 SMP Tue Jan 5 15:58:47 EST 2016 x86_6=
4 x86_64 x86_64 GNU/Linux

# tapeinfo -f /dev/st0
Product Type: Tape Drive
Vendor ID: 'QUANTUM '
Product ID: 'ULTRIUM 5       '
Revision: '3060'
Attached Changer API: No
SerialNumber: 'HU1023AKHE'
MinBlock: 1
MaxBlock: 16777215
SCSI ID: 0
SCSI LUN: 0
Ready: yes
BufferedMode: yes
Medium Type: Not Loaded
Density Code: 0x58
BlockSize: 512
DataCompEnabled: yes
DataCompCapable: yes
DataDeCompEnabled: yes
CompType: 0x1
DeCompType: 0x1
BOP: yes
Block Position: 0
Partition 0 Remaining Kbytes: 1541692
Partition 0 Size in Kbytes: 1541692
ActivePartition: 0
EarlyWarningSize: 0
NumPartitions: 0
MaxPartitions: 0

Drive is working fine,

# mt -f /dev/st0 status
SCSI 2 tape drive:
=46ile number=3D0, block number=3D0, partition=3D0.
Tape block size 512 bytes. Density code 0x58 (no translation).
Soft error count since last status=3D0
General status bits on (41010000):
 BOT ONLINE IM_REP_EN

This is what I get when I try and partition and I believe this may be a=
 firmware issue for me.

mt -f /dev/st0  stsetoption can-partitions

[ 5343.620005] st 0:0:0:0: [st0] Block limits 1 - 16777215 bytes.
[ 5343.621424] st 0:0:0:0: [st0] Mode sense. Length 11, medium 0, WBS 1=
0, BLL 8
[ 5343.622005] st 0:0:0:0: [st0] Density 58, tape length: 0, drv buffer=
: 1
[ 5343.622606] st 0:0:0:0: [st0] Block size: 512, buffer size: 4096 (8 =
blocks).
[ 5343.623208] st 0:0:0:0: [st0] Mode 0 options: buffer writes: 1, asyn=
c writes: 1, read ahead: 1
[ 5343.623810] st 0:0:0:0: [st0]     can bsr: 1, two FMs: 0, fast mteom=
: 0, auto lock: 0,
[ 5343.624413] st 0:0:0:0: [st0]     defs for wr: 0, no block limits: 0=
, partitions: 1, s2 log: 0
[ 5343.625011] st 0:0:0:0: [st0]     sysv: 0 nowait: 0 sili: 0 nowait_f=
ilemark: 0
[ 5343.625623] st 0:0:0:0: [st0]     debugging: 1
[ 5343.626222] st 0:0:0:0: [st0] Rewinding tape.

# mt -f /dev/nst0  mkpartition 1
/dev/nst0: Input/output error





Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
=46rom: "Emmanuel Florac" <eflorac@intellique.com>
To: "Laurence Oberman" <loberman@redhat.com>
Cc: "Laurence Oberman" <oberman.l@gmail.com>, "Kai Makisara" <Kai.Makis=
ara@kolumbus.fi>, linux-scsi@vger.kernel.org
Sent: Wednesday, January 6, 2016 10:10:49 AM
Subject: Re: st driver doesn't seem to grok LTO partitioning

Le Tue, 5 Jan 2016 16:55:04 -0500 (EST)
Laurence Oberman <loberman@redhat.com> =C3=A9crivait:

> mt -f /dev/nst0  mkpartition 1
>=20

What is the type of drive exactly? I still couldn't test with the LTO-5
drive as the machine it's connected to is being reinstalled.

--=20
-----------------------------------------------------------------------=
-
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
-----------------------------------------------------------------------=
-
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
