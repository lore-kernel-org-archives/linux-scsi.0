From: Michael J Gruber <michaeljgruber+fedora-lists@gmail.com>
Subject: Wrong SSD sector count with after reboot
Date: Tue, 11 Sep 2012 17:02:23 +0200
Message-ID: <504F527F.7000604@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39485 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab2IKPC2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2012 11:02:28 -0400
Received: by eekc1 with SMTP id c1so499604eek.19
        for <linux-scsi@vger.kernel.org>; Tue, 11 Sep 2012 08:02:27 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

[Originally posted to fedora-general, where Alan Cox suspected a usb
issue and suggested linux-usb; they suggested linux-scsi.]

F17 with current updates gets the sector count wrong (too large by 5)
for my SSD (Jetflash USB), resulting in read errors (during boot, fdisk
reading the disk etc.) for those sectors. While everything "seems to
work" this is not OK, of course. I'd be grateful for any clue.

[The device provides USB to S-ATA, is USB3, connected to a USB2 port.]

Test systems (Fedora)
============
F16 with updates (kernel 3.4.9-2)
F17 live (kernel 3.3.4-5)
F17 with updates (kernels 3.3.4-5, 3.5.0-2, 3.5.2-3,
3.5.3-13.6.0-0.rc2.git2.1.fc18)

After several rounds of testing, the described problem appears to be
independent of the mentioned kernel versions. It is not present after
the first boot, appears with the first soft reboot and remains to be
present until the next hard reboot (shutdown, wait a few secs, boot again).

[Since I had switched between different kernels by rebooting I had been
tricked into that previous diagnosis. After rebooting the same
versions again and again, soft and hard, I'm convinced it's the
difference between first boot and subsequent reboots.]


lsusb
=====
Bus 002 Device 003: ID 2174:07d0

dmesg
=====
(after a common part about the USB to S-ATA device)

After a cold boot:
[  287.229149] scsi6 : usb-storage 2-1.5:1.0
[  288.230862] scsi 6:0:0:0: Direct-Access     JetFlash TS128GSSD18C3
 0004 PQ: 0 ANSI: 0
[  288.231591] sd 6:0:0:0: Attached scsi generic sg7 type 0
[  288.232184] sd 6:0:0:0: [sdg] 250069676 512-byte logical blocks: (128
GB/119 GiB)
[  288.234815] sd 6:0:0:0: [sdg] Write Protect is off
[  288.234820] sd 6:0:0:0: [sdg] Mode Sense: 03 00 00 00
[  288.235676] sd 6:0:0:0: [sdg] No Caching mode page present
[  288.235680] sd 6:0:0:0: [sdg] Assuming drive cache: write through

After a reboot:
[    2.661796] scsi5 : usb-storage 2-1.5:1.0
[    3.665597] scsi 5:0:0:0: Direct-Access     JetFlash TS128GSSD18C3
 0004 PQ: 0 ANSI: 0
[    3.666375] sd 5:0:0:0: Attached scsi generic sg6 type 0
[    3.666917] sd 5:0:0:0: [sdf] 250069681 512-byte logical blocks: (128
GB/119 GiB)
[    3.667784] sd 5:0:0:0: [sdf] Write Protect is off
[    3.667789] sd 5:0:0:0: [sdf] Mode Sense: 03 00 00 00
[    3.668657] sd 5:0:0:0: [sdf] No Caching mode page present
[    3.668661] sd 5:0:0:0: [sdf] Assuming drive cache: write through

Note the different sector count!
After enumerating the partitions, dmesg throws:
[    3.674173]  sdf: sdf1 sdf2 sdf3 sdf4 < sdf5 >
[    3.678160] sd 5:0:0:0: [sdf] No Caching mode page present
[    3.678165] sd 5:0:0:0: [sdf] Assuming drive cache: write through
[    3.678168] sd 5:0:0:0: [sdf] Attached SCSI disk

[    3.694795] sd 5:0:0:0: [sdf] Unhandled sense code
[    3.694798] sd 5:0:0:0: [sdf]  Result: hostbyte=invalid
driverbyte=DRIVER_SENSE
[    3.694802] sd 5:0:0:0: [sdf]  Sense Key : Medium Error [current]
[    3.694806] sd 5:0:0:0: [sdf]  Add. Sense: Recorded entity not found
[    3.694811] sd 5:0:0:0: [sdf] CDB: Read(10): 28 00 0e e7 c2 b0 00 00
01 00
[    3.694821] end_request: critical target error, dev sdf, sector 250069680
[    3.694824] Buffer I/O error on device sdf, logical block 250069680

The last few lines get repeated.

The same difference in sector size is reported by fdisk and hdparm:
 geometry      = 15566/255/63, sectors = 250069676, start = 0
vs.
 geometry      = 15566/255/63, sectors = 250069681, start = 0

Interestingly, "hdparm -N" agrees in both cases:
max sectors   = 250069680/1(250069680?), HPA setting seems invalid
(buggy kernel device driver?)

But ignore_hpa=0 for the libata module in all cases (Fedora default).

Stomped!

I can provide the full dmesg, of course. Please help :|


