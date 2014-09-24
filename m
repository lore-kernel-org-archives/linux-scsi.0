From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85101] New: hpsa + P410 does not show connected HP SAS port
 expanders
Date: Wed, 24 Sep 2014 16:46:18 +0000
Message-ID: <bug-85101-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51895 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbaIXQqX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2014 12:46:23 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4504520265
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2014 16:46:21 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id D38AB20270
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2014 16:46:18 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=85101

            Bug ID: 85101
           Summary: hpsa + P410 does not show connected HP SAS port
                    expanders
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.17
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: linux-ide@crashplan.pro
        Regression: No

ASRock H81 + Intel Celeron G1840
 HP P410, firmware 6.60
  HP SAS Expander, firmware 2.08

In the need for upgrading the firmware on the HP SAS expanders, the HP P410 is
attached to this setup. However it does not see the any of the two connected HP
SAS expander cards, only the boot drive and P410 are shown in the lsscsi
output.

Steps to reproduce:
1. blacklist hpsa
2. reboot
3. modprobe -v hpsa
4. lsscsi

# lsscsi
[0:0:0:0]    disk    ATA      OCZ-VERTEX       1.3   /dev/sda
[4:3:0:0]    storage HP       P410             6.60  -

# modprobe -v hpsa dmesg:
[   49.567169] HP HPSA Driver (v 3.4.4-1)
[   49.567251] hpsa 0000:01:00.0: can't disable ASPM; OS doesn't have ASPM
control
[   49.567389] hpsa 0000:01:00.0: enabling device (0000 -> 0003)
[   49.567576] hpsa 0000:01:00.0: MSIX
[   49.567649] hpsa 0000:01:00.0: irq 30 for MSI/MSI-X
[   49.567705] hpsa 0000:01:00.0: irq 31 for MSI/MSI-X
[   49.567799] hpsa 0000:01:00.0: Logical aborts not supported
[   49.587966] hpsa 0000:01:00.0: hpsa0: <0x323a> at IRQ 30 using DAC
[   55.125143] scsi host4: hpsa
[   55.129439] hpsa 0000:01:00.0: RAID              device c4b3t0l0 added.
[   55.129832] scsi 4:3:0:0: RAID              HP       P410             6.60
PQ: 0 ANSI: 5
[   55.130585] scsi 4:3:0:0: Attached scsi generic sg1 type 12

Regression:
1. changed back to kernel 3.13: no difference
2. disconnect all other SAS (to SATA) cables: no difference
3. attach only one HP SAS expander: no difference
4. switch cable between P410 and SAS expander card: no differnce
5. replace HP P410 (and cables) with Adapter 7805H or Marvell 88SE9485 SAS/SATA
6Gb/s controller [1b4b:9485]: HP SAS expanders are shown

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
