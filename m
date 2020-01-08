Return-Path: <SRS0=fkLW=25=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A72EC00523
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 06:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15FA82075B
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 06:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgAHGAA convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jan 2020 01:00:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:43128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbgAHGAA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Jan 2020 01:00:00 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 206123] New: aacraid ( PM8068) and iommu=nobypass Frozen PHB
 error  on ppc64
Date:   Wed, 08 Jan 2020 05:59:58 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: gyakovlev@gentoo.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-206123-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206123

            Bug ID: 206123
           Summary: aacraid ( PM8068) and iommu=nobypass Frozen PHB error
                    on ppc64
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 5.4.8
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: AACRAID
          Assignee: scsi_drivers-aacraid@kernel-bugs.osdl.org
          Reporter: gyakovlev@gentoo.org
        Regression: No

Device Talos Raptor T2P9D01 REV 1.01 SAS
System chassis: SC747TQ-R1620B
All disks are attached via SAS backplane on the chassis.

Problem description: I'm running linux 5.4.8 (LE, 64k pages) and using
iommu=nobypass kernel option to catch and prevent illegal DMA access.

Since installing SAS dives (4x HUH721008AL4200 drives) I'm seeing
errors in dmesg and all IO to the controller stops.
controller tries to reset itself and reports successful reset but after
that any IO to ANY disk on the controller hangs.
detailed errors in attached file.

I've been using SATA (both SSD and HDD) devices just fine before,
accessing those SAS drives seems not to trigger the error.

I've tried patching kernel with latest patches from 5.5
https://github.com/torvalds/linux/commits/master/drivers/scsi/aacraid
^ all commits from oct15, but errors still here.

Steps to reproduce
I have 4 disks, I create 4 filesystems (ext4 but it's irrelevant)
then I copy a 5gb file to tmpfs
then I copy that 5gb file to each disk in parallel couple of times.
after 1-4 attempts error happens, all IO to the controller hangs
the only way to recover is to hard-reboot

if I boot WITHOUT iommu=nobypass, everything works just fine
some key messages from attached dmesg

[    0.000000] PowerNV: IOMMU bypass window disabled.
^ here system shows that bypass disabled

[13860.157868] EEH: Frozen PHB#2-PE#fd detected
[13860.157876] EEH: PE location: UOPWR.A100034-Node0-Builtin SAS
^ hang triggered

after that EEH asks driver to reset and block/filesystem layer
starts to report errors


after that controller reports that it's been reset, but it's not
functional. any IO to any disks on controller will hang forever.

In attached dmesg I have ZFS filesystem, but it's reproduce-able with
simple single partition with ext4 on top of that. with single partition
IO also never recovers, so please don't focus on ZFS.



Any help appreciated.
I hope it's a driver bug and not a HW bug in PM8068 itself.


full dmesg below

[    0.000000] PowerNV: IOMMU bypass window disabled.
...
[13428.236656] logitech-hidpp-device 0003:046D:4069.0006: multiplier = 8
[13860.157868] EEH: Frozen PHB#2-PE#fd detected
[13860.157876] EEH: PE location: UOPWR.A100034-Node0-Builtin SAS, PHB location:
N/A
[13860.157877] EEH: Frozen PHB#2-PE#fd detected
[13860.157878] EEH: Call Trace:
[13860.157885] EEH: [000000009c57f2e8] __eeh_send_failure_event+0x60/0x110
[13860.157888] EEH: [0000000006b53b28] eeh_dev_check_failure+0x360/0x5f0
[13860.157890] EEH: [000000001947df59] eeh_check_failure+0x98/0x100
[13860.157894] EEH: [0000000066f23435] aac_src_check_health+0x8c/0xc0
[13860.157898] EEH: [00000000361f4dbd] aac_command_thread+0x718/0x930
[13860.157902] EEH: [00000000b5fb52e2] kthread+0x180/0x190
[13860.157906] EEH: [000000005791e370] ret_from_kernel_thread+0x5c/0x74
[13860.157908] EEH: This PCI device has failed 1 times in the last hour and
will be permanently disabled after 5 failures.
[13860.157908] EEH: Notify device drivers to shutdown
[13860.157910] EEH: Beginning: 'error_detected(IO frozen)'
[13860.157914] PCI 0002:01:00.0#00fd: EEH: Invoking aacraid->error_detected(IO
frozen)
[13860.157918] aacraid 0002:01:00.0: aacraid: PCI error detected 2
[13860.158142] sd 0:2:5:0: [sde] tag#788 UNKNOWN(0x2003) Result: hostbyte=0x01
driverbyte=0x00
[13860.158150] sd 0:2:5:0: [sde] tag#788 CDB: opcode=0x2a 2a 00 08 4c a9 05 00
00 40 00
[13860.158154] blk_update_request: I/O error, dev sde, sector 1113933864 op
0x1:(WRITE) flags 0x4700 phys_seg 1 prio class 0
[13860.158168] sd 0:2:5:0: [sde] tag#789 UNKNOWN(0x2003) Result: hostbyte=0x01
driverbyte=0x00
[13860.158171] sd 0:2:5:0: [sde] tag#789 CDB: opcode=0x2a 2a 00 08 4c a9 45 00
00 40 00
[13860.158174] blk_update_request: I/O error, dev sde, sector 1113934376 op
0x1:(WRITE) flags 0x4700 phys_seg 1 prio class 0
[13860.158179] sd 0:2:5:0: [sde] tag#790 UNKNOWN(0x2003) Result: hostbyte=0x01
driverbyte=0x00
[13860.158182] sd 0:2:5:0: [sde] tag#790 CDB: opcode=0x2a 2a 00 08 4c a9 85 00
00 40 00
[13860.158185] blk_update_request: I/O error, dev sde, sector 1113934888 op
0x1:(WRITE) flags 0x4700 phys_seg 1 prio class 0
[13860.158190] sd 0:2:5:0: [sde] tag#791 UNKNOWN(0x2003) Result: hostbyte=0x01
driverbyte=0x00
[13860.158193] sd 0:2:5:0: [sde] tag#791 CDB: opcode=0x2a 2a 00 08 4c a9 c5 00
00 20 00
[13860.158196] blk_update_request: I/O error, dev sde, sector 1113935400 op
0x1:(WRITE) flags 0x700 phys_seg 1 prio class 0
[13860.158200] zio pool=zdata vdev=/dev/disk/by-id/wwn-0x5000cca2565ab744-part1
error=5 type=2 offset=570325749760 size=917504 flags=40080c80
[13860.158416] blk_update_request: I/O error, dev sdf, sector 1448660344 op
0x1:(WRITE) flags 0x4700 phys_seg 1 prio class 0
[13860.158419] sd 0:2:6:0: [sdf] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x01
driverbyte=0x00
[13860.158424] blk_update_request: I/O error, dev sdf, sector 1448660088 op
0x1:(WRITE) flags 0x700 phys_seg 1 prio class 0
[13860.158426] sd 0:2:4:0: [sdd] tag#35 UNKNOWN(0x2003) Result: hostbyte=0x01
driverbyte=0x00
[13860.158429] zio pool=zdata vdev=/dev/disk/by-id/wwn-0x5000cca266d5c270-part1
error=5 type=2 offset=741705707520 size=1048576 flags=40080c80
[13860.158431] sd 0:2:6:0: [sdf] tag#1 CDB: opcode=0x2a 2a 00 0a cb bf cf 00 00
40 00
[13860.158433] sd 0:2:4:0: [sdd] tag#35 CDB: opcode=0x2a 2a 00 08 4c a4 c5 00
00 40 00
[13860.158436] blk_update_request: I/O error, dev sdf, sector 1449000568 op
0x1:(WRITE) flags 0x4700 phys_seg 1 prio class 0
[13860.158440] zio pool=zdata vdev=/dev/disk/by-id/wwn-0x5000cca266d5c270-part1
error=5 type=2 offset=741705576448 size=131072 flags=180880
[13860.158445] blk_update_request: I/O error, dev sdd, sector 1113925160 op
0x1:(WRITE) flags 0x4700 phys_seg 1 prio class 0
[13860.158449] blk_update_request: I/O error, dev sdd, sector 1113927208 op
0x1:(WRITE) flags 0x700 phys_seg 1 prio class 0
[13860.158451] sd 0:2:6:0: [sdf] tag#2 UNKNOWN(0x2003) Result: hostbyte=0x01
driverbyte=0x00
[13860.158455] zio pool=zdata vdev=/dev/disk/by-id/wwn-0x5000cca2666c6d98-part1
error=5 type=2 offset=570322341888 size=262144 flags=40080c80
[13860.158456] sd 0:2:6:0: [sdf] tag#2 CDB: opcode=0x2a 2a 00 0a cb c0 0f 00 00
40 00
[13860.158458] sd 0:2:7:0: [sdg] tag#32 UNKNOWN(0x2003) Result: hostbyte=0x01
driverbyte=0x00
[13860.158462] blk_update_request: I/O error, dev sdf, sector 1449001080 op
0x1:(WRITE) flags 0x4700 phys_seg 1 prio class 0
[13860.158464] sd 0:2:4:0: [sdd] tag#36 UNKNOWN(0x2003) Result: hostbyte=0x01
driverbyte=0x00
[13860.158466] sd 0:2:7:0: [sdg] tag#32 CDB: opcode=0x2a 2a 00 0a cb e4 4f 00
00 20 00
[13860.158470] sd 0:2:4:0: [sdd] tag#36 CDB: opcode=0x2a 2a 00 08 4c a5 05 00
00 40 00
[13860.158473] zio pool=zdata vdev=/dev/disk/by-id/wwn-0x5000cca26b5708c8-part1
error=5 type=2 offset=741918175232 size=131072 flags=180880
[13860.158480] zio pool=zdata vdev=/dev/disk/by-id/wwn-0x5000cca266d5c270-part1
error=5 type=2 offset=741879902208 size=1048576 flags=40080c80
[13860.158483] sd 0:2:4:0: [sdd] tag#38 UNKNOWN(0x2003) Result: hostbyte=0x01
driverbyte=0x00
[13860.158486] zio pool=zdata vdev=/dev/disk/by-id/wwn-0x5000cca2565ab744-part1
error=5 type=2 offset=570325094400 size=131072 flags=180880
[13860.158488] sd 0:2:4:0: [sdd] tag#38 CDB: opcode=0x2a 2a 00 08 4c a5 45 00
00 40 00
[13860.158497] zio pool=zdata vdev=/dev/disk/by-id/wwn-0x5000cca2666c6d98-part1
error=5 type=2 offset=570321293312 size=1048576 flags=40080c80
[13860.158500] zio pool=zdata vdev=/dev/disk/by-id/wwn-0x5000cca266d5c270-part1
error=5 type=2 offset=741918437376 size=1048576 flags=40080c80
[13860.158542] zio pool=zdata vdev=/dev/disk/by-id/wwn-0x5000cca2565ab744-part1
error=5 type=2 offset=570324701184 size=131072 flags=180880
[13860.158545] zio pool=zdata vdev=/dev/disk/by-id/wwn-0x5000cca2565ab744-part1
error=5 type=2 offset=570323783680 size=131072 flags=180880
[13860.158575] zio pool=zdata vdev=/dev/disk/by-id/wwn-0x5000cca2666c6d98-part1
error=5 type=2 offset=570320244736 size=1048576 flags=40080c80
[13860.158583] zio pool=zdata vdev=/dev/disk/by-id/wwn-0x5000cca266d5c270-part1
error=5 type=2 offset=741740703744 size=655360 flags=40080c80
[13860.158586] zio pool=zdata vdev=/dev/disk/by-id/wwn-0x5000cca2565ab744-part1
error=5 type=2 offset=570325225472 size=524288 flags=40080c80
[13860.158606] zio pool=zdata vdev=/dev/disk/by-id/wwn-0x5000cca26b5708c8-part1
error=5 type=2 offset=741921583104 size=1048576
...
[13860.158939] PCI 0002:01:00.0#00fd: EEH: aacraid driver reports: 'need reset'
[13860.158941] EEH: Finished:'error_detected(IO frozen)' with aggregate
recovery state:'need reset'
[13860.158945] EEH: Collect temporary log
[13860.158970] EEH: of node=0002:01:00.0
[13860.158972] EEH: PCI device/vendor: 028d9005
[13860.158975] EEH: PCI cmd/status register: 00100146
[13860.158976] EEH: PCI-E capabilities and status follow:
[13860.158987] EEH: PCI-E 00: 00020010 000081a2 00002950 00437083 
[13860.158996] EEH: PCI-E 10: 10820000 00000000 00000000 00000000 
[13860.158997] EEH: PCI-E 20: 00000000 
[13860.158998] EEH: PCI-E AER capability register set follows:
[13860.159009] EEH: PCI-E AER 00: 30020001 00000000 00400000 00462030 
[13860.159017] EEH: PCI-E AER 10: 00000000 0000e000 000001e0 00000000 
[13860.159026] EEH: PCI-E AER 20: 00000000 00000000 00000000 00000000 
[13860.159029] EEH: PCI-E AER 30: 00000000 00000000 
[13860.159031] PHB4 PHB#2 Diag-data (Version: 1)
[13860.159032] brdgCtl:    00000002
[13860.159033] RootSts:    00060040 00402000 e0820008 00100107 00000800
[13860.159035] PhbSts:     0000001c00000000 0000001c00000000
[13860.159036] Lem:        0000000100000080 0000000000000000 0000000000000080
[13860.159038] PhbErr:     0000028000000000 0000020000000000 2148000098000240
a008400000000000
[13860.159039] RxeTceErr:  6000000000000000 2000000000000000 c0000000000000fd
0000000000000000
[13860.159041] PblErr:     0000000000020000 0000000000020000 0000000000000000
0000000000000000
[13860.159042] RegbErr:    0000004000000000 0000004000000000 8800000400000000
0000000000000000
[13860.159044] PE[0fd] A/B: 8300b03800000000 8000000000000000
[13860.159046] EEH: Reset without hotplug activity
flags=40080c80
[13865.217467] aacraid 0002:01:00.0: enabling device (0140 -> 0142)
[13865.224325] EEH: Beginning: 'slot_reset'
[13865.224334] PCI 0002:01:00.0#00fd: EEH: Invoking aacraid->slot_reset()
[13865.224337] aacraid 0002:01:00.0: aacraid: PCI error - slot reset
[13865.224401] PCI 0002:01:00.0#00fd: EEH: aacraid driver reports: 'recovered'
[13865.224402] EEH: Finished:'slot_reset' with aggregate recovery
state:'recovered'
[13865.224403] EEH: Notify device driver to resume
[13865.224404] EEH: Beginning: 'resume'
[13865.224406] PCI 0002:01:00.0#00fd: EEH: Invoking aacraid->resume()




^ at this poing all IO to any of the disks on the controller hangs forever.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
