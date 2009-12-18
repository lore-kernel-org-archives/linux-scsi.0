From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Fri, 18 Dec 2009 15:31:56 GMT
Message-ID: <200912181531.nBIFVuPj016900@demeter.kernel.org>
References: <bug-14831-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36002 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbZLRPb4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2009 10:31:56 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id nBIFVuQ2016901
	for <linux-scsi@vger.kernel.org>; Fri, 18 Dec 2009 15:31:56 GMT
In-Reply-To: <bug-14831-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14831





--- Comment #3 from Tim Small <tim@seoss.co.uk>  2009-12-18 15:31:55 ---
Hmm, failed as soon as I submitted the last comment (Intel S5000PSL on-board
controller)...

filename:      
/lib/modules/2.6.26-2-amd64/kernel/drivers/message/fusion/mptsas.ko
version:        3.04.06

     Port Name         Chip Vendor/Type/Rev    MPT Rev  Firmware Rev
 1.  /proc/mpt/ioc0    LSI Logic SAS1064E 04     105      01190100


Current active firmware version is 1.25.01
Firmware image's version is MPTFW-01.25.01.00-IT
  LSI Logic
x86 BIOS image's version is MPTBIOS-6.22.00.00 (2008.04.10)


[    2.369101] ioc0: LSISAS1064E B2: Capabilities={Initiator}
[    2.371062] mptbase: ioc0: PCI-MSI enabled
[    2.371612] PCI: Setting latency timer of device 0000:04:00.0 to 64
[   18.377426] scsi0 : ioc0: LSISAS1064E B2, FwRev=01190100h, Ports=1,
MaxQ=478, IRQ=1269
[   19.249357] scsi 0:0:0:0: Direct-Access     ATA      WDC WD3200BJKT-0 1A11
PQ: 0 ANSI: 5
[  881.982165] mptbase: ioc0: LogInfo(0x30030108): Originator={IOP},
Code={Invalid Page}, SubCode(0x0108)
[  882.086359] mptbase: ioc0: LogInfo(0x30030108): Originator={IOP},
Code={Invalid Page}, SubCode(0x0108)
[ 1514.521445] mptbase: ioc0: LogInfo(0x30030108): Originator={IOP},
Code={Invalid Page}, SubCode(0x0108)
[ 1514.525947] mptbase: ioc0: LogInfo(0x30030108): Originator={IOP},
Code={Invalid Page}, SubCode(0x0108)
[ 2051.568333] mptscsih: ioc0: attempting task abort! (sc=ffff8101190f6940)
[ 2051.568446] sd 0:0:0:0: [sda] CDB: ATA command pass through(16): 85 08 0e 00
00 00 01 00 00 00 00 00 00 00 ec 00
[ 2056.593202] mptbase: ioc0: LogInfo(0x31140000): Originator={PL}, Code={IO
Executed}, SubCode(0x0000)
[ 2056.594064] mptsas: ioc0: removing sata device, channel 0, id 0, phy 0
[ 2056.594182]  port-0:0: mptsas: ioc0: delete port (0)
[ 2056.617086] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 2056.797030] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8101190f6940)
[ 2056.797166] mptscsih: ioc0: attempting task abort! (sc=ffff810124da15c0)
[ 2056.798195] sd 0:0:0:0: [sda] CDB: Synchronize Cache(10): 35 00 00 00 00 00
00 00 00 00
[ 2056.799567] mptscsih: ioc0: task abort: SUCCESS (sc=ffff810124da15c0)
[ 2056.799697] mptscsih: ioc0: attempting target reset! (sc=ffff8101190f6940)
[ 2056.799821] sd 0:0:0:0: [sda] CDB: ATA command pass through(16): 85 08 0e 00
00 00 01 00 00 00 00 00 00 00 ec 00
[ 2057.137289] mptscsih: ioc0: target reset: SUCCESS (sc=ffff8101190f6940)
[ 2057.140469] mptscsih: ioc0: attempting bus reset! (sc=ffff8101190f6940)
[ 2057.140585] sd 0:0:0:0: [sda] CDB: ATA command pass through(16): 85 08 0e 00
00 00 01 00 00 00 00 00 00 00 ec 00
[ 2057.398218] mptscsih: ioc0: bus reset: SUCCESS (sc=ffff8101190f6940)
[ 2068.601852] mptscsih: ioc0: attempting host reset! (sc=ffff8101190f6940)
[ 2068.606217] mptbase: ioc0: Initiating recovery
[ 2082.235819] mptscsih: ioc0: host reset: SUCCESS (sc=ffff8101190f6940)
[ 2082.235932] sd 0:0:0:0: Device offlined - not ready after error recovery
[ 2082.236054] sd 0:0:0:0: Device offlined - not ready after error recovery
[ 2082.236197] end_request: I/O error, dev sda, sector 19534911

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
