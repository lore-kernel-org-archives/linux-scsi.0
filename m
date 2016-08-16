From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 153241] New: Kernel (unconditionally?) repeatedly attempts to
 issue SMART commands via ATA pass-through
Date: Tue, 16 Aug 2016 19:59:29 +0000
Message-ID: <bug-153241-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49328 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033AbcHPT7e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Aug 2016 15:59:34 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id ADB64201DD
	for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2016 19:59:32 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id DAC30201ED
	for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2016 19:59:29 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=153241

            Bug ID: 153241
           Summary: Kernel (unconditionally?) repeatedly attempts to issue
                    SMART commands via ATA pass-through
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 4.4.14
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: markk@clara.co.uk
        Regression: No

With a recent kernel update (on Lubuntu 16.04 x64-64), I noticed some error
messages in the log on connecting a USB hard drive, for example:

[ 1580.500043] usb 2-1: new high-speed USB device number 4 using ehci-pci
[ 1580.633247] usb 2-1: New USB device found, idVendor=0bc2, idProduct=3300
[ 1580.633255] usb 2-1: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[ 1580.633260] usb 2-1: Product: Desktop         
[ 1580.633264] usb 2-1: Manufacturer: Seagate 
[ 1580.633268] usb 2-1: SerialNumber: [redacted]
[ 1580.672701] usb-storage 2-1:1.0: USB Mass Storage device detected
[ 1580.674539] scsi host5: usb-storage 2-1:1.0
[ 1580.674639] usbcore: registered new interface driver usb-storage
[ 1580.676522] usbcore: registered new interface driver uas
[ 1581.673205] scsi 5:0:0:0: Direct-Access     Seagate  Desktop          0146
PQ: 0 ANSI: 4
[ 1581.676331] sd 5:0:0:0: Attached scsi generic sg2 type 0
[ 1581.677416] sd 5:0:0:0: [sdb] 732566644 4096-byte logical blocks: (3.00
TB/2.73 TiB)
[ 1581.677907] sd 5:0:0:0: [sdb] Write Protect is off
[ 1581.677918] sd 5:0:0:0: [sdb] Mode Sense: 1c 00 00 00
[ 1581.678407] sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[ 1581.690549]  sdb: sdb1
[ 1581.692636] sd 5:0:0:0: [sdb] Attached SCSI disk
[ 1581.846416] sd 5:0:0:0: [sdb] tag#0 FAILED Result: hostbyte=DID_ERROR
driverbyte=DRIVER_SENSE
[ 1581.846426] sd 5:0:0:0: [sdb] tag#0 Sense Key : Hardware Error [current]
[descriptor] 
[ 1581.846432] sd 5:0:0:0: [sdb] tag#0 Add. Sense: No additional sense
information
[ 1581.846439] sd 5:0:0:0: [sdb] tag#0 CDB: ATA command pass through(16) 85 06
20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[ 1581.929398] sd 5:0:0:0: [sdb] tag#0 FAILED Result: hostbyte=DID_ERROR
driverbyte=DRIVER_SENSE
[ 1581.929403] sd 5:0:0:0: [sdb] tag#0 Sense Key : Hardware Error [current]
[descriptor] 
[ 1581.929405] sd 5:0:0:0: [sdb] tag#0 Add. Sense: No additional sense
information
[ 1581.929409] sd 5:0:0:0: [sdb] tag#0 CDB: ATA command pass through(12)/Blank
a1 06 20 da 00 00 4f c2 00 b0 00 00

The ATA pass-through commands are attempted every ten minutes, so the tag#0...
lines repeat in the kernel log. The commands are something to do with SMART.

It seems other people are seeing this problem too:
"kernel-4.6.3-300 shows false warnings about USB hard disks."
https://bugzilla.redhat.com/show_bug.cgi?id=1351305

"Worrisome USB disk messages in 4.6.0-1, but not 4.5.0-2"
https://lists.debian.org/debian-user/2016/07/msg00988.html


I bisected between 4.4.13 and 4.4.14 with this result:

$ git bisect bad
0dec8c0d67c64401d97122e4eba347ccc5850622 is the first bad commit
commit 0dec8c0d67c64401d97122e4eba347ccc5850622
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Fri May 13 12:04:06 2016 -0700

    scsi_lib: correctly retry failed zero length REQ_TYPE_FS commands

    commit a621bac3044ed6f7ec5fa0326491b2d4838bfa93 upstream.

    When SCSI was written, all commands coming from the filesystem
    (REQ_TYPE_FS commands) had data.  This meant that our signal for needing
    to complete the command was the number of bytes completed being equal to
    the number of bytes in the request.  Unfortunately, with the advent of
    flush barriers, we can now get zero length REQ_TYPE_FS commands, which
    confuse this logic because they satisfy the condition every time.  This
    means they never get retried even for retryable conditions, like UNIT
    ATTENTION because we complete them early assuming they're done.  Fix
    this by special casing the early completion condition to recognise zero
    length commands with errors and let them drop through to the retry code.

    Reported-by: Sebastian Parschauer <s.parschauer@gmx.de>
    Signed-off-by: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
    Tested-by: Jack Wang <jinpu.wang@profitbricks.com>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


>From that commit description, it sounds like it may not be the real/root cause
of the problem though? Just that now, commands which might have been silently
dropped/ignored before, no longer are.


So, questions...

Does the kernel now unconditionally try to issue ATA pass-through commands
(opcodes 0x85 and 0xA1)? That could be problematic for several reasons:

 - The FAILED log messages are likely to make the user think their drive is
defective. Perhaps the majority of USB hard drives (well, USB-to-IDE/SATA
bridges) don't support ATA pass-through. And things like USB card readers or
flash drives definitely won't.

 - Over time the log gets filled up with repeated messages as the kernel issues
the commands every ten minutes. If the first attempt fails, don't keep trying
to avoid spamming the log and giving users heart attacks thinking their disks
are about to die. :)
Perhaps print some explanation, e.g. "target probably does not support ATA
pass-through commands".

 - Knowing the state of drive/bridge firmware:
  - some devices could hang or lock up on receiving the unknown commands,
perhaps requiring power cycling to recover
  - some devices could corrupt data being read or written when receiving the
unknown commands
  - some devices could even be "bricked" on receiving the commands, if 0x85 or
0xA1 opcodes have some vendor-specific function

 - Is there any way to blacklist a given device, e.g. by USB ID, so no
SMART/ATA pass-through commands are issued? Though that wouldn't work for
native SCSI drives.

-- 
You are receiving this mail because:
You are the assignee for the bug.
