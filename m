From: "Grzegorz Nosek" <grzegorz.nosek@gmail.com>
Subject: Hotplugging U160 disks on a Fast-40 sym53c8xx
Date: Sat, 17 Nov 2007 15:09:08 +0100
Message-ID: <121a28810711170609k18f5476fwc3064c9f60682a46@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:38009 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759418AbXKQOJK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Nov 2007 09:09:10 -0500
Received: by nf-out-0910.google.com with SMTP id g13so1041636nfb
        for <linux-scsi@vger.kernel.org>; Sat, 17 Nov 2007 06:09:09 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

I have a problem with hotplugging hard disks to an old Compaq ProLiant
360 with the following SCSI controllers:

00:01.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1510 (rev 02)
00:01.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1510 (rev 02)

(without the SmartArray stuff), working fine with the sym53c8xx
driver. The disks are in hotswap bays.

The following scenario works for some of the drives I tested (a Compaq
18GB Fast-40 drive that came with the server and an antique 4GB WDC),
but fails with a U160 36GB SEAGATE (model SX336704LC, firmware BC13).

1. Boot with two drives (can be seen in lsscsi et al.)
2. scsi-spin -w -d /dev/sdb (disk spins down)
3. scsiadd -r 1 0 1 0 (the other disk is at  1 0 0 0)
4. Remove the disk from the bay, wait a few seconds, insert it again.

Up to this point everything works fine.

5. scsiadd -s 1

Here is where the problem starts. The old disks are detected normally,
spin up and can be seen, mounted etc. The U160 disk just makes the
activity LED blink briefly and nothing else happens (i.e. I'm left
with just one disk). dmesg says nothing.

It works fine with the Seagate unless I physically remove it from the
bay and insert it again (disconnecting from the controller).

I tried a 2.6.18-5 kernel from Debian etch, another 2.6.18.something
from the Insert Live CD and a home-built 2.6.20.14

Is this a known problem? Can anything be done to the
disk/controller/whatever for the bus scan to work after boot? If you
need any more information, feel free to ask.

Please keep me CC'd as I'm not subscribed.

Best regards,
 Grzegorz Nosek

PS. A dmesg fragment from the boot process:

[    3.299410] sym0: <1510d> rev 0x2 at pci 0000:00:01.0 irq 3
[    3.301595] sym0: No NVRAM, ID 7, Fast-40, LVD, parity checking
[    3.308215] sym0: SCSI BUS has been reset.
[    3.308305] scsi0 : sym-2.2.3
[   10.711471] sym1: <1510d> rev 0x2 at pci 0000:00:01.1 irq 10
[   10.713617] sym1: No NVRAM, ID 7, Fast-40, LVD, parity checking
[   10.720232] sym1: SCSI BUS has been reset.
[   10.720315] scsi1 : sym-2.2.3
[   13.714494] scsi 1:0:0:0: Direct-Access     SEAGATE  SX336704LC
  BC13 PQ: 0 ANSI: 3
[   13.714628]  target1:0:0: tagged command queuing enabled, command
queue depth 16.
[   13.714761]  target1:0:0: Beginning Domain Validation
[   13.715111]  target1:0:0: asynchronous
[   13.720460]  target1:0:0: wide asynchronous
[   13.722697]  target1:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 31)
[   13.725598]  target1:0:0: Domain Validation skipping write tests
[   13.725678]  target1:0:0: Ending Domain Validation
[   13.728281] scsi 1:0:1:0: Direct-Access     SEAGATE  SX336704LC
  BC13 PQ: 0 ANSI: 3
[   13.728405]  target1:0:1: tagged command queuing enabled, command
queue depth 16.
[   13.728536]  target1:0:1: Beginning Domain Validation
[   13.728875]  target1:0:1: asynchronous
[   13.734173]  target1:0:1: wide asynchronous
[   13.736407]  target1:0:1: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 31)
[   13.739337]  target1:0:1: Domain Validation skipping write tests
[   13.739419]  target1:0:1: Ending Domain Validation
[   17.608744] SCSI device sda: 71132960 512-byte hdwr sectors (36420 MB)
[   17.610405] sda: Write Protect is off
[   17.610492] sda: Mode Sense: cb 00 10 08
[   17.612136] SCSI device sda: write cache: disabled, read cache:
enabled, supports DPO and FUA
[   17.613208] SCSI device sda: 71132960 512-byte hdwr sectors (36420 MB)
[   17.614874] sda: Write Protect is off
[   17.614950] sda: Mode Sense: cb 00 10 08
[   17.616578] SCSI device sda: write cache: disabled, read cache:
enabled, supports DPO and FUA
[   17.616704]  sda: sda1
[   17.627500] sd 1:0:0:0: Attached scsi disk sda
[   17.629152] SCSI device sdb: 71132960 512-byte hdwr sectors (36420 MB)
[   17.630812] sdb: Write Protect is off
[   17.630888] sdb: Mode Sense: cb 00 10 08
[   17.632528] SCSI device sdb: write cache: disabled, read cache:
enabled, supports DPO and FUA
[   17.633623] SCSI device sdb: 71132960 512-byte hdwr sectors (36420 MB)
[   17.635293] sdb: Write Protect is off
[   17.635371] sdb: Mode Sense: cb 00 10 08
[   17.637018] SCSI device sdb: write cache: disabled, read cache:
enabled, supports DPO and FUA
[   17.637142]  sdb: sdb1
[   17.643063] sd 1:0:1:0: Attached scsi disk sdb
[   17.643264] sd 1:0:0:0: Attached scsi generic sg0 type 0
[   17.643394] sd 1:0:1:0: Attached scsi generic sg1 type 0
