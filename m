From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] New: mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Fri, 18 Dec 2009 11:25:45 GMT
Message-ID: <bug-14831-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59058 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbZLRLZq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2009 06:25:46 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id nBIBPjVU022661
	for <linux-scsi@vger.kernel.org>; Fri, 18 Dec 2009 11:25:45 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14831

           Summary: mptsas - Use of ATA command pass-through results in
                    unreliable operation - drive / controller resets
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.26 - 2.6.31
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: tim@seoss.co.uk
                CC: kashyap.desai@lsi.com
        Regression: No


On Debian 2.6.26-2-amd64, and mptsas 3.04.13 from scsi-misc-2.6.git, use ATA
command pass-through on LSI SAS1068 and SAS1068E may result in:

. Device resets
. Device offline
. Controller offline (only observed on 2.6.26)

The problem seems to occur far more frequently with the SAS1068 (PCI version).

I haven't verified whether any data loss is occuring, but this does at least
seem to be a possibility.


For 2.6.26:

/lib/modules/2.6.26-2-amd64/kernel/drivers/message/fusion/mptsas.ko
version:        3.04.06
license:        GPL
description:    Fusion MPT SAS Host driver
author:         LSI Corporation

.. and a couple of WesternDigitial SATA drives,  I ran the following 
command:

while true ; do smartctl -a /dev/sg0 > /dev/null ; done

After approx 45 minutes this happened:

kernel: [5060492.926757] 
mptctldrivers/message/fusion/mptctl.c::mptctl_ioctl() @602 - Controller 
disabled.


For 2.6.32-rc4 with mptsas 3.04.13:

[   22.414415] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id
9, phy 0, sas_addr 0x1221000000000000
[   22.466953] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id
1, phy 1, sas_addr 0x1221000001000000
[   22.519305] mptsas: ioc0: attaching raid volume, channel 1, id 0
[   33.727405] Fusion MPT misc device (ioctl) driver 3.04.13
[   33.738270] mptctl: Registered with Fusion MPT base driver
[   33.749277] mptctl: /dev/mptctl @ (major,minor=10,220)
[ 5300.611795] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[ 5300.629028] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[ 5300.646254] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[ 5300.663478] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[ 5300.680700] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[ 5300.697924] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[ 5312.111795] mptbase: ioc0: LogInfo(0x31130000): Originator={PL},
Code={IO Not Yet Executed}, SubCode(0x0000)
[ 5312.131469] mptscsih: ioc0: attempting task abort! (sc=ffff88012c5fc8c0)
[ 5312.156831] mptscsih: ioc0: task abort: FAILED (sc=ffff88012c5fc8c0)
[ 5312.169534] mptscsih: ioc0: attempting target reset!
(sc=ffff88012c5fc8c0)
[ 5312.195222] mptscsih: ioc0: target reset: FAILED (sc=ffff88012c5fc8c0)
[ 5312.208276] mptscsih: ioc0: attempting bus reset! (sc=ffff88012c5fc8c0)
[ 5316.612245] mptscsih: ioc0: bus reset: SUCCESS (sc=ffff88012c5fc8c0)
[ 5328.112389] mptbase: ioc0: LogInfo(0x31140000): Originator={PL},
Code={IO Executed}, SubCode(0x0000)
[ 5328.128508] mptscsih: ioc0: attempting host reset! (sc=ffff88012c5fc8c0)
[12537.867482] mptbase: ioc0: LogInfo(0x31140000): Originator={PL},
Code={IO Executed}, SubCode(0x0000)
[12537.885769] mptscsih: ioc0: attempting host reset! (sc=ffff88012d55c8c0)
[12537.899173] mptbase: ioc0: Initiating recovery
[12559.704264] mptscsih: ioc0: host reset: SUCCESS (sc=ffff88012d55c8c0)
[44184.424640] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[44184.441866] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[44195.924782] mptbase: ioc0: LogInfo(0x31130000): Originator={PL},
Code={IO Not Yet Executed}, SubCode(0x0000)
[44195.944449] mptscsih: ioc0: attempting task abort! (sc=ffff88012c403ac0)
[44195.969799] mptscsih: ioc0: task abort: FAILED (sc=ffff88012c403ac0)
[44195.982500] mptscsih: ioc0: attempting target reset!
(sc=ffff88012c403ac0)
[44196.008182] mptscsih: ioc0: target reset: FAILED (sc=ffff88012c403ac0)
[44196.021230] mptscsih: ioc0: attempting bus reset! (sc=ffff88012c403ac0)
[44200.425026] mptscsih: ioc0: bus reset: SUCCESS (sc=ffff88012c403ac0)
[44211.925127] mptbase: ioc0: LogInfo(0x31140000): Originator={PL},
Code={IO Executed}, SubCode(0x0000)
[44211.943416] mptscsih: ioc0: attempting host reset! (sc=ffff88012c403ac0)
[44211.956814] mptbase: ioc0: Initiating recovery
[44233.760010] mptscsih: ioc0: host reset: SUCCESS (sc=ffff88012c403ac0)
[49878.447977] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00)
[49889.948381] mptbase: ioc0: LogInfo(0x31130000): Originator={PL},
Code={IO Not Yet Executed}, SubCode(0x0000)
[49889.968080] mptscsih: ioc0: attempting task abort! (sc=ffff88003799acc0)
[49889.993425] mptscsih: ioc0: task abort: FAILED (sc=ffff88003799acc0)
[49890.006129] mptscsih: ioc0: attempting target reset!
(sc=ffff88003799acc0)
[49890.031817] mptscsih: ioc0: target reset: FAILED (sc=ffff88003799acc0)
[49890.044869] mptscsih: ioc0: attempting bus reset! (sc=ffff88003799acc0)
[49894.448617] mptscsih: ioc0: bus reset: SUCCESS (sc=ffff88003799acc0)
[49905.948189] mptbase: ioc0: LogInfo(0x31140000): Originator={PL},
Code={IO Executed}, SubCode(0x0000)
[49905.966491] mptscsih: ioc0: attempting host reset! (sc=ffff88003799acc0)
[49905.979888] mptbase: ioc0: Initiating recovery

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
