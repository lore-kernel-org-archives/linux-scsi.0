From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 18652] mptscsih: ioc0: attempting task abort when heavy disk
 operations on MPT SAS
Date: Wed, 3 Aug 2011 06:31:56 GMT
Message-ID: <201108030631.p736VuJv032435@demeter1.kernel.org>
References: <bug-18652-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:53732 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab1HCGb5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2011 02:31:57 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p736VuXV032436
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 3 Aug 2011 06:31:56 GMT
In-Reply-To: <bug-18652-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=18652


Daobang Wang <wangdb@toyou.com.cn> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |wangdb@toyou.com.cn




--- Comment #8 from Daobang Wang <wangdb@toyou.com.cn>  2011-08-03 06:31:49 ---
I test it on 2.6.36.4 with HitachiHDE72101, it has the same issue.

sd 7:0:9:0: [sdj] CDB: cdb[0]=0x28: 28 00 00 18 ac 00 00 01 c8 00
mptbase: ioc0: LogInfo(0x31110700): Originator={PL}, Code={Reset},
SubCode(0x0700) cb_idx mptbase_reply
mptbase: ioc0: LogInfo(0x31140000): Originator={PL}, Code={IO Executed},
SubCode(0x0000) cb_idx mptscsih_io_done
mptscsih: ioc0: task abort: SUCCESS (sc=ffff8801937cd1c0)
mptbase: ioc0: LogInfo(0x31110700): Originator={PL}, Code={Reset},
SubCode(0x0700) cb_idx mptscsih_io_done
mptscsih: ioc0: attempting task abort! (sc=ffff8801e562d4c0)
sd 7:0:9:0: [sdj] CDB: cdb[0]=0x2a: 2a 00 00 18 ab 00 00 01 00 00
mptscsih: ioc0: task abort: SUCCESS (sc=ffff8801e562d4c0)
mptscsih: ioc0: attempting task abort! (sc=ffff88021eb6c880)
...............

And i saw the /var/log/messages, there were some log:

Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1627904
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1628160
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1628920
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1629096
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1630120
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1631144
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1619456
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1632168
Aug  3 12:00:13 nss12345678 kernel: 
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1616384
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1620992
Aug  3 12:00:13 nss12345678 kernel:  00 00 18 ae 00 00 04 00 00
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1617408
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1618432
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1619808
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1619968
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1619984
Aug  3 12:00:13 nss12345678 kernel:  00 18 b8 18 00 00 e8 00
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1619992
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1620224
Aug  3 12:00:13 nss12345678 kernel:  00
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1620480
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1620736
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1621248
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1621504
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1621760
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1622784
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1623808
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1624832
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1625856
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1626880
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector
1627648
Aug  3 12:00:13 nss12345678 kernel: end_request: I/O error, dev sdb, sector 16
Aug  3 12:00:13 nss12345678 kernel: md: super_written gets error=-5, uptodate=0
Aug  3 12:00:13 nss12345678 kernel: md/raid:md127: Disk failure on sdb,
disabling device.
But it was ok when test it with smartctl

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
