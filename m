From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197877] New: arcmsr fails to initialize Areca ARC-1110/ARC-1120
 on some systems
Date: Wed, 15 Nov 2017 04:07:54 +0000
Message-ID: <bug-197877-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50394 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753891AbdKOEHz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Nov 2017 23:07:55 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id D388929D88
        for <linux-scsi@vger.kernel.org>; Wed, 15 Nov 2017 04:07:54 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=197877

            Bug ID: 197877
           Summary: arcmsr fails to initialize Areca ARC-1110/ARC-1120 on
                    some systems
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.18+
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: kr@sognnes.no
        Regression: No

Since the Areca driver was upgraded to v1.30.00.04 in kernel 3.18, ARC-1110 and
ARC-1120 controllers is no longer properly initialized on some systems. All
kernels from 3.18 onwards are affected.

Loading the module generates the following messages in the log:

---------------------
[  634.409073] Areca RAID Controller5: Model ARC-1120, F/W V1.49 2010-12-02
[  634.410504] scsi host5: Areca SATA RAID Controller (RAID6 capable)
               arcmsr version v1.30.00.04-20140919

[  634.410832] arcmsr 0000:07:0e.0: irq 19 for MSI/MSI-X
[  634.410893] arcmsr5: msi enabled
[  655.017019] arcmsr5: abort device command of scsi id = 0 lun = 0
[  655.017032] arcmsr5: scsi id = 0 lun = 0 ccb = '0xeeb00000' poll command
abort successfully
[  676.009017] arcmsr5: abort device command of scsi id = 1 lun = 0
[  676.009030] arcmsr5: scsi id = 1 lun = 0 ccb = '0xeeb00660' poll command
abort successfully

[---- (the above two lines repeat for SCSI IDs 2-15) ---]

[  970.025230] scsi 5:0:16:0: Processor         Areca    RAID controller  R001
PQ: 0 ANSI: 0 CCS
---------------------

No logical or passthrough drives are detected regardless of controller
configuration. 

The problem only affects certain hardware. The above was taken from a ProLiant
ML370 G3 (Intel x86). The issue was reproduced on x86_64 using an AMD-based
Fujitsu PC. Both systems work as expected with kernel 3.17.8, and the exact
same controllers works fine under any kernel when used in other systems, like
for instance a ProLiant ML350 G5 (x86 or x86_64).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
