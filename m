From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101201] New: hpsa hang when creating ext4 FS
Date: Wed, 08 Jul 2015 10:13:26 +0000
Message-ID: <bug-101201-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33115 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758127AbbGHKNa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 06:13:30 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4D4F1206A1
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2015 10:13:29 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 3CC7120703
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2015 10:13:27 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=101201

            Bug ID: 101201
           Summary: hpsa hang when creating ext4 FS
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.16.7-ckt11-1
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: elacour@easter-eggs.com
        Regression: No

Hardware:

HP ProLiant DL385p Gen8 with 2 SSD 100G and 2 HD SATA 3TB, configured in HBA
mode, no HW RAID set up.

I boot on the Debian 8 installer, then


- load hpsa
- create one partition on each of the SSD
- create a soft RAID 1 using mdadm on those 2 partition
- raid synchronize successfully
- create a pv, then a vg on this raid without problem
- doing mkswap on a LV without problem
- doing mkfs.ext4 on a LV -> the process HANG

dmesg gives:

[ 1490.566398] hpsa 0000:03:00.0: Abort request on C6:B2:T0:L0
[ 1490.566819] hpsa 0000:03:00.0: ABORT REQUEST on C6:B2:T0:L0
Tag:0x00000000:00000030 Command:0x42 SN:0x1687d9  REQUEST SUCCEEDED.
[ 1540.309302] hpsa 0000:03:00.0: ABORT REQUEST on C6:B2:T0:L0
Tag:0x00000000:00000030 Command:0x42 SN:0x1687d9  FAILED. Aborted command has
not completed after 30 seconds.
[ 1540.309319] hpsa 0000:03:00.0: Abort request on C6:B2:T1:L0
[ 1540.345047] hpsa 0000:03:00.0: ABORT REQUEST on C6:B2:T1:L0
Tag:0x00000000:00000010 Command:0x42 SN:0x1687d8  REQUEST SUCCEEDED.
[ 1588.796036] hpsa 0000:03:00.0: ABORT REQUEST on C6:B2:T1:L0
Tag:0x00000000:00000010 Command:0x42 SN:0x1687d8  FAILED. Aborted command has
not completed after 30 seconds.
[ 1588.796090] hpsa 0000:03:00.0: resetting device 6:2:0:0


the mkfs process doesn't finish and I can no longer access disks (parted,
etc..)

I can repeat this on two identical servers.

I looked at kernel changelogs and did not see anything that may fix this on
recent releases.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
