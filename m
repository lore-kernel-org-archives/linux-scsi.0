From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151631] New: "Synchronizing SCSI cache" fails during(and
 delays) reboot/shutdown
Date: Sat, 06 Aug 2016 17:17:15 +0000
Message-ID: <bug-151631-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:51194 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbcHFU4L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Aug 2016 16:56:11 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F41E320819
	for <linux-scsi@vger.kernel.org>; Sat,  6 Aug 2016 17:17:17 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A49B72081B
	for <linux-scsi@vger.kernel.org>; Sat,  6 Aug 2016 17:17:15 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151631

            Bug ID: 151631
           Summary: "Synchronizing SCSI cache" fails during(and delays)
                    reboot/shutdown
           Product: IO/Storage
           Version: 2.5
    Kernel Version: <=4.7.0-g0cbbc42
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: icanrealizeum+bugzillakernelorg@gmail.com
        Regression: No

During reboot/shutdown,
here's a screenshot with the errors: https://i.imgur.com/3P7ztlj.png

I'm assuming the ohci-pci errors are unrelated, otherwise, the error
is(manually written here):
sd 3:0:0:0: [sda] Synchronizing SCSI cache
ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x40d0000 action 0x6 frozen
ata4.00: SError: { PHYRdyChg CommWake 10B8B DevExch }
ata4.00: failed command: FLUSH CACHE EXT
ata4.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 22
         res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata4.00: status { DRDY }
ata4: hard resetting link
ata4: softreset failed (1st FIS failed)
ata4: hard resetting link
...

After 2 minutes or so, the reboot/shutdown continues okay.

I've tried hdparm -F /dev/sda and hdparm -f /dev/sda during normal system
function, they both seem to work as there are no errors reported on
console/dmesg/journalctl.
This seems to tell me that Synchronizing SCSI cache should work too, unless who
knows why they aren't working?maybe something shutdown some laptop parts(like
the SSD itself) before reaching that.


Some info about what ata4 is:

[    4.728132] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.730133] ata4.00: supports DRM functions and may not be fully accessible
[    4.730603] ata4.00: NCQ Send/Recv Log not supported
[    4.730606] ata4.00: ATA-9: Samsung SSD 840 EVO 1TB, EXT0BB6Q, max UDMA/133
[    4.730609] ata4.00: 1953525168 sectors, multi 1: LBA48 NCQ (depth 31/32),
AA
[    4.730897] ata4.00: supports DRM functions and may not be fully accessible
[    4.731400] ata4.00: NCQ Send/Recv Log not supported
[    4.731408] ata4.00: configured for UDMA/133
[    4.733053] scsi 3:0:0:0: Direct-Access     ATA      Samsung SSD 840  BB6Q
PQ: 0 ANSI: 5

Note this might've worked before so this is a regression(or I just didn't see
or have these errors turned on?) with kernel: 4.7.0-rc6-ga99cde4
But with both kernels I am/was experiencing the "Unmounting /oldroot"
stalling/delay which is here:
https://bugzilla.kernel.org/show_bug.cgi?id=151621
but that message happens before(and it's systemd calling umount2 syscall) this
issue you're reading now.

file: drivers/scsi/sd.c
in function: sd_shutdown
hangs in call: sd_sync_cache(sdkp);

Cheers

-- 
You are receiving this mail because:
You are the assignee for the bug.
