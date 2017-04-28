From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195607] New: Megaraid_sas raidcard hotswap wouldn't work if
 hold the fd of block devcie in user space
Date: Fri, 28 Apr 2017 08:29:03 +0000
Message-ID: <bug-195607-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:57040 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S968234AbdD1I3F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Apr 2017 04:29:05 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 9293428304
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2017 08:29:04 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=195607

            Bug ID: 195607
           Summary: Megaraid_sas raidcard hotswap wouldn't work if hold
                    the fd of block devcie in user space
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.10.0
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: johnzzpcrystal@gmail.com
        Regression: No

reproduce :

1.choose a megaraid sas series raidcard, for example:
LSI Logic / Symbios Logic MegaRAID　SAS 2008 [Falcon] (rev 03)

2. configure the raid card as HBA card (all disks are jbod mode)
We assume /dev/sdb is attached to this raid card

3.run process:
fd = open("/dev/sdb", O_RDWR);
while (1) {
    sleep (10);
}

4. run "udevadm monitor" watch udev message in a new shell

5.unplug disk sdb and then insert 

We can see new udev message about disk's hotswap

6.redo process 5
There will be no udev message only if you reboot the server

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
