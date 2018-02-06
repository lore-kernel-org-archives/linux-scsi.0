From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198689] New: Setro has no effect for SCSI device
Date: Tue, 06 Feb 2018 08:18:00 +0000
Message-ID: <bug-198689-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:60766 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752183AbeBFISC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Feb 2018 03:18:02 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 9D3212874E
        for <linux-scsi@vger.kernel.org>; Tue,  6 Feb 2018 08:18:01 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=198689

            Bug ID: 198689
           Summary: Setro has no effect for SCSI device
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: all
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: AACRAID
          Assignee: scsi_drivers-aacraid@kernel-bugs.osdl.org
          Reporter: yzlining@foxmail.com
        Regression: No

Hi,
We found a problem when using SCSI device.

Setting the read-only attribute to scsi disk by calling "ioctl(fd, BLKROSET,
&ro)"
only block the first write operation.

In detail:
1: set ioctl(fd, BLKROSET, &ro)
2: dd to the block device(as /dev/sdc), write failed
3: dd to the block device again, write successed

Above operation can be reproduced by following script:

#! /bin/bash
DEV=$1
[[ "$DEV" =~ ^/dev/sd ]] || echo "Need a scsi device to reproduce"
blockdev --setro $DEV
echo $DEV getro is [ $(blockdev --getro $DEV) ]
dd if=/dev/zero of=$DEV count=1
echo $DEV getro is [ $(blockdev --getro $1) ]
dd if=/dev/zero of=$DEV count=1

Environment:
  - Kernel: ALL
  We reproduced this problem in following kernel version: 4.15 4.10, 3.10.
  And by reference source, we think the problem exist in all versions.
  - Driver: SCSI
  it exists only when using SCSI disks, and xen-blk，virtio-blk do not have such
a 
  problem

Here is a test result:
# uname -r
4.15.0+

# ./reproduce.sh /dev/sda
/dev/sda getro is [ 1 ]
dd: writing to ‘/dev/sda’: Operation not permitted
1+0 records in
0+0 records out
0 bytes (0 B) copied, 0.000258806 s, 0.0 kB/s
/dev/sda getro is [ 0 ]
1+0 records in
1+0 records out
512 bytes (512 B) copied, 0.000321595 s, 1.6 MB/s

---

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
