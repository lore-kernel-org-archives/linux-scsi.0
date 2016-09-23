From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 172831] New: Adaptec ASR7805 in RAID (Expose RAW) mode recreate
 block devices and broke MDRAID
Date: Fri, 23 Sep 2016 23:44:04 +0000
Message-ID: <bug-172831-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759017AbcIWXoI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Sep 2016 19:44:08 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id D06C0203B7
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2016 23:44:06 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id AF150203A9
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2016 23:44:04 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=172831

            Bug ID: 172831
           Summary: Adaptec ASR7805 in RAID (Expose RAW) mode recreate
                    block devices and broke MDRAID
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.7.4-1.el7.elrepo.x86_64
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: AACRAID
          Assignee: scsi_drivers-aacraid@kernel-bugs.osdl.org
          Reporter: v.badalyan@open-bs.ru
        Regression: No

1. Have 2 x Adaptec ASR7805 in RAID (Expose RAW) mode
2. Have 8 SSD in Raw (Pass Through) mode
3. Have Centos 7
4. Create linux software raid 10
5. After reboot:

a) mdadm in boot time found and create raid10 device.
b) raid10 device is started
c) block devices recreated after 1-2 secs (and gets other names!)
d) raid10 marked as degraded. 1-2 disks say is Offline (old data)

Becouse it is not system volume i simple do hot fix in rc.local:

mdadm -S /dev/md*
mdadm -As
mount -o discard /dev/md/0_0 /mnt/SSD

dmesg, ./arcconf GETCONFIG 1 and 2, dmidecode in attach!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
