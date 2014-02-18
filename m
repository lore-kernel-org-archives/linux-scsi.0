From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 70751] New: mpt2sas: system disks dropped when execute SMART
 tests
Date: Tue, 18 Feb 2014 10:48:27 +0000
Message-ID: <bug-70751-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38081 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755244AbaBRKsd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Feb 2014 05:48:33 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 71A7D20213
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2014 10:48:32 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 2953820142
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2014 10:48:29 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=70751

            Bug ID: 70751
           Summary: mpt2sas: system disks dropped when execute SMART tests
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.8
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: mihaly.arva-toth+kernelorg@virtual-call-center.eu
        Regression: No

Created attachment 126551
  --> https://bugzilla.kernel.org/attachment.cgi?id=126551&action=edit
dmesg from boot

This bug is similar to #60644 but errors are different.

I've a SuperMicro SSG-6047R-E1R36L server with LSI2308 HBA, which handled by
mpt2sas kernel driver. I'm using four SATA HDD in server, 2 disks in software
RAID-1 with installed Ubuntu 12.04 LTS (3.8.0-29) and 2 disks for standalone
Ceph OSD storage.

When I run SMART short/extended test on one of first two disk (which holds
system), I think driver sends something wrong to controller. I
can reproduce every time with smartctl -t short /dev/sda (but I need to do
restart after crash)

I turn on mpt2sas.debug_logging=0x3f8:

2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.132677] sd 0:0:1:0: [sdb] CDB: 
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.132683] Write(10): 2a 08 00 00
08 08 00 00 01 00
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.132698] mpt2sas0:     
sas_address(0x500304800089138d), phy(13)
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.132701] mpt2sas0:     
enclosure_logical_id(0x50030480008913bf), slot(1)
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.132704] mpt2sas0:     
handle(0x000b), ioc_status(success)(0x0000), smid(48)
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.132707] mpt2sas0:     
request_len(512), underflow(512), resid(512)
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.132710] mpt2sas0:      tag(0),
transfer_count(0), sc->result(0x00000002)
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.132713] mpt2sas0:     
scsi_status(check condition)(0x02), scsi_state(autosense valid )(0x01)
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.132716] mpt2sas0:     
[sense_key,asc,ascq]: [0x05,0x21,0x00], count(18)
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.132730] sd 0:0:1:0: [sdb]  
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.132733] Result:
hostbyte=DID_OK driverbyte=DRIVER_SENSE
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.132736] sd 0:0:1:0: [sdb]  
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.132738] Sense Key : Illegal
Request [current] 
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.132743] Info fld=0x808
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.132745] sd 0:0:1:0: [sdb]  
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.132749] Add. Sense: Logical
block address out of range
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.132753] sd 0:0:1:0: [sdb] CDB: 
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.132755] Write(10): 2a 08 00 00
08 08 00 00 01 00
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.132767] end_request: critical
target error, dev sdb, sector 2056
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.133132] end_request: critical
target error, dev sdb, sector 2056
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.133495] md: super_written gets
error=-121, uptodate=0
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.133500] md/raid1:md0: Disk
failure on sdb1, disabling device.
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.133500] md/raid1:md0:
Operation continuing on 1 devices.
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.157908] RAID1 conf printout:
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.157913]  --- wd:1 rd:2
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.157917]  disk 0, wo:0, o:1,
dev:sda1
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.157920]  disk 1, wo:1, o:0,
dev:sdb1
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.160890] RAID1 conf printout:
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.160903]  --- wd:1 rd:2
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.160908]  disk 0, wo:0, o:1,
dev:sda1
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.175482] EXT4-fs error (device
md0): ext4_journal_start_sb:349: Detected aborted journal
2014-02-18T10:50:28+01:00 stor3 kernel: : [ 1103.175534] EXT4-fs (md0):
Remounting filesystem read-only

I tried rootfs with ext4 and xfs filesystems too. When I run SMART test on 3rd
or 4th HDD (not system disk), there is no crash and tests
working fine. When I boot from a live CD, I can run SMART tests on all HDDs
without problem. I tried to install and booted latest stable
FreeBSD and SMART tests working well, no hang up.

I tired the latest LSI firmware P17 and latest mpt2sas kernel driver compiled
to this kernel, but problem still exists. Also I tried ASPM disable, PERR and
SERR disable and Above 4G encoding enabled but nothing helps. I'm using WD RE3
and RE4 SATA disks.

I found an another guy who runs same issue:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/906873/comments/4

So the bug exists in linux kernel only, and crash happens only when I try to
run SMART tests on booted system's disks.

dmesg from boot has been attached.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
