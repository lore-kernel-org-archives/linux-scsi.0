From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 172841] New: aacraid does not support TRIM in Raw (Pass
 Through) devices
Date: Sat, 24 Sep 2016 00:38:22 +0000
Message-ID: <bug-172841-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752987AbcIXAi0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Sep 2016 20:38:26 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 47D36203F3
        for <linux-scsi@vger.kernel.org>; Sat, 24 Sep 2016 00:38:24 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id D3F8E203EB
        for <linux-scsi@vger.kernel.org>; Sat, 24 Sep 2016 00:38:22 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=172841

            Bug ID: 172841
           Summary: aacraid does not support TRIM in Raw (Pass Through)
                    devices
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.7.4-1.el7.elrepo.x86_64
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: DC395X
          Assignee: scsi_drivers-dc395x@kernel-bugs.osdl.org
          Reporter: v.badalyan@open-bs.ru
        Regression: No

Created attachment 239601
  --> https://bugzilla.kernel.org/attachment.cgi?id=239601&action=edit
AACRAID get config 1

Have SW raid 10. 8 x Intel SSD

Can't do fstrim.
mount -o discard does not add discard flag to mount point

[root@nas ~]# fstrim -v /mnt/SSD/
fstrim: /mnt/SSD/: the discard operation is not supported

[root@nas ~]# hdparm -I /dev/sdm | grep -i trim
           *    Data Set Management TRIM supported (limit 1 block)
           *    Deterministic read data after TRIM

[root@nas ~]# mount | grep SSD
/dev/md127 on /mnt/SSD type xfs
(rw,relatime,attr2,inode64,sunit=1024,swidth=4096,noquota)

[root@nas ~]# cat /proc/mdstat
Personalities : [raid10]
md127 : active raid10 sdp1[0] sdr1[7] sdn1[6] sdm1[5] sdk1[4] sdl1[3] sdq1[2]
sdo1[1]
      937195520 blocks super 1.2 512K chunks 2 near-copies [8/8] [UUUUUUUU]
      bitmap: 7/7 pages [28KB], 65536KB chunk

unused devices: <none>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
