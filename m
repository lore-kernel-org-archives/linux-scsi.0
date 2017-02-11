From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194553] New: [storvsc] Add. Sense: Changed operating definition
Date: Sat, 11 Feb 2017 18:53:04 +0000
Message-ID: <bug-194553-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:42964 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750968AbdBKSxH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 11 Feb 2017 13:53:07 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2EE952845E
        for <linux-scsi@vger.kernel.org>; Sat, 11 Feb 2017 18:53:06 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id DD72628499
        for <linux-scsi@vger.kernel.org>; Sat, 11 Feb 2017 18:53:04 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=194553

            Bug ID: 194553
           Summary: [storvsc] Add. Sense: Changed operating definition
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.4.45
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: johann.fock@abas.de
        Regression: No

I have install CentOS 7 under  Hyper-V 2012
the following Messages i Get
[71004.657368] sd 3:0:0:0: [storvsc] Sense Key : Unit Attention [current] 
[71004.657408] sd 3:0:0:0: [storvsc] Add. Sense: Changed operating definition
[71004.657460] sd 3:0:0:0: Warning! Received an indication that the operating
parameters on this target have changed. The Linux SCSI layer does not automa

root@abas-server log]# rpm -qa |grep hyperv
hyperv-daemons-license-0-0.29.20160216git.el7.noarch
hyperv-daemons-0-0.29.20160216git.el7.x86_64
hypervfcopyd-0-0.29.20160216git.el7.x86_64
hypervvssd-0-0.29.20160216git.el7.x86_64
hypervkvpd-0-0.29.20160216git.el7.x86_64

ps aux | grep vss
root       742  0.0  0.0   4300   656 ?        Ss   Feb10   0:00
/usr/sbin/hypervvssd -n
root     24865  0.0  0.0 112672  2264 pts/0    S+   19:49   0:00 grep
--color=auto vss

[root@abas-server log]# lsmod | grep hy
hyperv_keyboard        16384  0 
hid_hyperv             16384  0 
hyperv_fb              20480  1 
hv_vmbus              540672  7
hv_balloon,hyperv_keyboard,hv_netvsc,hid_hyperv,hv_utils,hyperv_fb,hv_storvsc

dmesg | grep hv_bus
[    1.462203] hv_vmbus: Hyper-V Host Build:14393-10.0-0-0.576; Vmbus
version:4.0
[    1.465500] hv_vmbus: registering driver hyperv_fb
[    1.467213] ata_piix 0000:00:07.1: version 2.13
[    1.467507] ata_piix 0000:00:07.1: Hyper-V Virtual Machine detected, ATA
device ignore set
[    1.473626] hyperv_fb: Screen resolution: 1152x864, Color depth: 32
[    1.499850] FDC 0 is an 82078.
[    1.516536] hv_vmbus: registering driver hv_storvsc
[    1.522176] scsi host0: ata_piix
[    1.523457] hv_vmbus: registering driver hv_netvsc
[    1.525551] hv_vmbus: registering driver hid_hyperv
[    1.526557] hv_vmbus: registering driver hyperv_keyboard

dmesg | grep hv
[    5.045257] scsi host2: storvsc_host_t
[    5.045810] scsi 2:0:0:0: Direct-Access     Msft     Virtual Disk     1.0 
PQ: 0 ANSI: 5
[    5.052549] scsi host3: storvsc_host_t
[    5.052928] scsi 3:0:0:0: Direct-Access     Msft     Virtual Disk     1.0 
PQ: 0 ANSI: 5
[    5.109767] hv_netvsc: hv_netvsc channel opened successfully
[    5.115336] sd 2:0:0:0: [sda] 734003200 512-byte logical blocks: (376 GB/350
GiB)
[    5.115362] sd 2:0:0:0: [sda] 4096-byte physical blocks
[    5.115369] sd 3:0:0:0: [sdb] 734003200 512-byte logical blocks: (376 GB/350
GiB)
[    5.115376] sd 3:0:0:0: [sdb] 4096-byte physical blocks
[    5.117873] sd 3:0:0:0: [sdb] Write Protect is off
[    5.117877] sd 2:0:0:0: [sda] Write Protect is off
[    5.117881] sd 3:0:0:0: [sdb] Mode Sense: 0f 00 00 00
[    5.117884] sd 2:0:0:0: [sda] Mode Sense: 0f 00 00 00
[    5.118151] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[    5.118155] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[    5.122142]  sdb: sdb1
[    5.122327]  sda: sda1 sda2 sda3
[    5.124530] sd 3:0:0:0: [sdb] Attached SCSI disk
[    5.124532] sd 2:0:0:0: [sda] Attached SCSI disk
[    5.173898] hv_netvsc vmbus_14: Send section size: 6144, Section count:2560
[    5.174375] hv_netvsc vmbus_14: Device MAC 00:15:5d:64:d5:00 link state up
[    5.178426] input: Microsoft Vmbus HID-compliant Mouse as
/devices/0006:045E:0621.0001/input/input4
[    5.178774] hid-generic 0006:045E:0621.0001: input: <UNKNOWN> HID v0.01
Mouse [Microsoft Vmbus HID-compliant Mouse] on 


File System used
XFS

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
