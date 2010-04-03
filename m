From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13594] SMART responses for SATA disks on SAS get interpreted as
 errors
Date: Sat, 3 Apr 2010 22:07:59 GMT
Message-ID: <201004032207.o33M7xgB004051@demeter.kernel.org>
References: <bug-13594-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54473 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab0DCWIC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2010 18:08:02 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o33M80xW004055
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 3 Apr 2010 22:08:00 GMT
In-Reply-To: <bug-13594-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D13594


Cl=C3=A1udio Martins <ctpm@ist.utl.pt> changed:

           What    |Removed                     |Added
-----------------------------------------------------------------------=
-----
                 CC|                            |ctpm@ist.utl.pt




--- Comment #9 from Cl=C3=A1udio Martins <ctpm@ist.utl.pt>  2010-04-03 =
22:07:47 ---
Hello,

 I'd like to point out that this bug is still present on kernel version
2.6.34-rc3-00163-g5e11611.

 I'm using a Supermicro enclosure with a SAS backplane and 16 SATA 1.5T=
B drives
(ST31500341AS).

The onboard controller, as reported by lspci:

05:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068E PCI=
-Express
=46usion-MPT SAS (rev 08)

At boot time the mptsas kernel driver reports:

scsi4 : ioc0: LSISAS1068E B3, FwRev=3D011a0000h, Ports=3D1, MaxQ=3D478,=
 IRQ=3D16

Smartmontools is version 5.38-2+lenny1 (v5.38 from Debian Lenny)


While generating I/O in the disks, I can easily make all I/O stall for =
several
minutes and even kick drives out of an MD Array by running "smartctl -a
/dev/sdX" repeatedly on several drives. During the stall, the kernel lo=
gged the
following messages:

mptbase: ioc0: LogInfo(0x31123000): Originator=3D{PL}, Code=3D{Abort},
SubCode(0x3000)
mptbase: ioc0: LogInfo(0x31123000): Originator=3D{PL}, Code=3D{Abort},
SubCode(0x3000)
mptbase: ioc0: LogInfo(0x31123000): Originator=3D{PL}, Code=3D{Abort},
SubCode(0x3000)
mptbase: ioc0: LogInfo(0x31123000): Originator=3D{PL}, Code=3D{Abort},
SubCode(0x3000)
mptscsih: ioc0: attempting task abort! (sc=3Dffff8802b57aa100)
sd 4:0:10:0: [sdk] CDB: ATA command pass through(16): 85 08 0e 00 d5 00=
 01 00
09 00 4f 00 c2 00 b0 00
mptbase: ioc0: LogInfo(0x31140000): Originator=3D{PL}, Code=3D{IO Execu=
ted},
SubCode(0x0000)
mptscsih: ioc0: task abort: SUCCESS (sc=3Dffff8802b57aa100)
mptscsih: ioc0: attempting task abort! (sc=3Dffff8802b57aa100)
sd 4:0:10:0: [sdk] CDB: Test Unit Ready: 00 00 00 00 00 00
mptbase: ioc0: LogInfo(0x31140000): Originator=3D{PL}, Code=3D{IO Execu=
ted},
SubCode(0x0000)
mptscsih: ioc0: task abort: SUCCESS (sc=3Dffff8802b57aa100)
mptscsih: ioc0: attempting task abort! (sc=3Dffff8802be35ec00)
sd 4:0:10:0: [sdk] CDB: Write(10): 2a 00 96 27 78 00 00 04 00 00
mptscsih: ioc0: task abort: SUCCESS (sc=3Dffff8802be35ec00)
mptbase: ioc0: LogInfo(0x31123000): Originator=3D{PL}, Code=3D{Abort},
SubCode(0x3000)
mptbase: ioc0: LogInfo(0x31123000): Originator=3D{PL}, Code=3D{Abort},
SubCode(0x3000)
mptscsih: ioc0: attempting task abort! (sc=3Dffff8802be35eb00)
sd 4:0:10:0: [sdk] CDB: Write(10): 2a 00 96 27 7c 00 00 04 00 00
mptscsih: ioc0: task abort: SUCCESS (sc=3Dffff8802be35eb00)
mptscsih: ioc0: attempting task abort! (sc=3Dffff8802be35eb00)
sd 4:0:10:0: [sdk] CDB: Test Unit Ready: 00 00 00 00 00 00
mptbase: ioc0: LogInfo(0x31130000): Originator=3D{PL}, Code=3D{IO Not Y=
et
Executed}, SubCode(0x0000)
mptscsih: ioc0: task abort: SUCCESS (sc=3Dffff8802be35eb00)
mptscsih: ioc0: attempting target reset! (sc=3Dffff8802b57aa100)
sd 4:0:10:0: [sdk] CDB: ATA command pass through(16): 85 08 0e 00 d5 00=
 01 00
09 00 4f 00 c2 00 b0 00
mptscsih: ioc0: target reset: FAILED (sc=3Dffff8802b57aa100)
mptscsih: ioc0: attempting bus reset! (sc=3Dffff8802b57aa100)
sd 4:0:10:0: [sdk] CDB: ATA command pass through(16): 85 08 0e 00 d5 00=
 01 00
09 00 4f 00 c2 00 b0 00
mptscsih: ioc0: bus reset: SUCCESS (sc=3Dffff8802b57aa100)
mptscsih: ioc0: attempting task abort! (sc=3Dffff8802b57aa100)
sd 4:0:10:0: [sdk] CDB: Test Unit Ready: 00 00 00 00 00 00
mptbase: ioc0: LogInfo(0x31130000): Originator=3D{PL}, Code=3D{IO Not Y=
et
Executed}, SubCode(0x0000)
mptscsih: ioc0: task abort: SUCCESS (sc=3Dffff8802b57aa100)
mptbase: ioc0: LogInfo(0x31123000): Originator=3D{PL}, Code=3D{Abort},
SubCode(0x3000)
mptbase: ioc0: LogInfo(0x31123000): Originator=3D{PL}, Code=3D{Abort},
SubCode(0x3000)
mptscsih: ioc0: attempting task abort! (sc=3Dffff8802be35eb00)
sd 4:0:10:0: [sdk] CDB: Test Unit Ready: 00 00 00 00 00 00
mptbase: ioc0: LogInfo(0x31130000): Originator=3D{PL}, Code=3D{IO Not Y=
et
Executed}, SubCode(0x0000)
mptscsih: ioc0: task abort: SUCCESS (sc=3Dffff8802be35eb00)
mptscsih: ioc0: attempting host reset! (sc=3Dffff8802b57aa100)
mptbase: ioc0: Initiating recovery
mptscsih: ioc0: host reset: SUCCESS (sc=3Dffff8802b57aa100)
end_request: I/O error, dev sdb, sector 3903551
md: super_written gets error=3D-5, uptodate=3D0
raid1: Disk failure on sdb1, disabling device.
raid1: Operation continuing on 1 devices.
end_request: I/O error, dev sda, sector 3903551
md: super_written gets error=3D-5, uptodate=3D0
RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:0, o:1, dev:sda1
 disk 1, wo:1, o:0, dev:sdb1
RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:0, o:1, dev:sda1


--------------

 I have this hardware available for a few weeks, so I am willing to hel=
p with
any tests, diagnostic operations, patches or firmware, that you might h=
ave.

 Any help with this is appreciated, since the fact that drives are bein=
g kicked
from MD arrays, makes Smartmontools use quite difficult.

 Thanks in advance for your help.

Best regards=20

Cl=C3=A1udio

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are the assignee for the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
