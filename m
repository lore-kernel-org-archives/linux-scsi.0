From: Douglas Gilbert <dougg@torque.net>
Subject: redundant slave_alloc() slave_destroy() calls
Date: Fri, 29 Nov 2002 19:04:06 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DE71F76.8040502@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070805010604050908070805"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dm1-33.triode.net.au [202.147.125.33])
	by iggy.triode.net.au (8.11.6/8.11.6) with ESMTP id gAT8DxU23849
	for <linux-scsi@vger.kernel.org>; Fri, 29 Nov 2002 19:14:00 +1100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------070805010604050908070805
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Attached is a scsi_debug driver view of a module load
when 2 scsi devices are simulated in lk 2.5.50.
The scsi_debug trace is slightly enhanced to show
calls to slave_alloc(). Also the address of the
passed scsi_device pointer is placed in brackets
at the end of most lines.

There are even more slave_alloc() slave_destroy()
pairs than I expected. The first pair looks very
strange (i.e. no INQUIRY is issued). The slave_
alloc [_configure] [_destroy] sequencing looks
sound, but it seems as though the scsi_scan logic
is a little over-zealous in exercising it.

Doug Gilbert

--------------070805010604050908070805
Content-Type: text/plain;
 name="sdebug_log.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sdebug_log.txt"

scsi3 : scsi_debug, Version: 1.65 (20021119), num_devs=2, dev_size_mb=8, opts=0x1
scsi_debug: slave_alloc <3 0 0 0> [db1dc400]
scsi_debug: slave_destroy <3 0 0 0> [db1dc400]
scsi_debug: slave_alloc <3 0 0 0> [db1dc400]
scsi_debug: cmd 12 00 00 00 24 00  [db1dc400]
scsi_debug: cmd 12 00 00 00 3a 00  [db1dc400]
scsi_debug: slave_alloc <3 0 0 0> [db1dc000]
  Vendor: Linux     Model: scsi_debug        Rev: 0004
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi_debug: cmd 12 01 00 00 ff 00  [db1dc400]
scsi_debug: cmd 12 01 83 00 ff 00  [db1dc400]
scsi_debug: slave_destroy <3 0 0 0> [db1dc400]
scsi_debug: slave_alloc <3 0 0 0> [db1dc400]
scsi_debug: cmd a0 00 00 00 00 00 00 00 04 08 00 00  [db1dc400]
scsi_debug: slave_destroy <3 0 0 1> [db1dc400]
scsi_debug: slave_alloc <3 0 0 1> [db1dc400]
scsi_debug: cmd 12 00 00 00 24 00  [db1dc400]
scsi_debug: cmd 12 00 00 00 3a 00  [db1dc400]
scsi_debug: slave_alloc <3 0 0 1> [db1d6c00]
  Vendor: Linux     Model: scsi_debug        Rev: 0004
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi_debug: cmd 12 01 00 00 ff 00  [db1dc400]
scsi_debug: cmd 12 01 83 00 ff 00  [db1dc400]
scsi_debug: slave_destroy <3 0 1 0> [db1dc400]
scsi_debug: slave_alloc <3 0 1 0> [db1dc400]
scsi_debug: cmd 12 00 00 00 24 00  [db1dc400]
scsi_debug: ... <3 0 1 0> non-zero result=0x10000
scsi_debug: slave_destroy <3 0 2 0> [db1dc400]
scsi_debug: slave_alloc <3 0 2 0> [db1dc400]
scsi_debug: cmd 12 00 00 00 24 00  [db1dc400]
scsi_debug: ... <3 0 2 0> non-zero result=0x10000
scsi_debug: slave_destroy <3 0 3 0> [db1dc400]
scsi_debug: slave_alloc <3 0 3 0> [db1dc400]
scsi_debug: cmd 12 00 00 00 24 00  [db1dc400]
scsi_debug: ... <3 0 3 0> non-zero result=0x10000
scsi_debug: slave_destroy <3 0 4 0> [db1dc400]
scsi_debug: slave_alloc <3 0 4 0> [db1dc400]
scsi_debug: cmd 12 00 00 00 24 00  [db1dc400]
scsi_debug: ... <3 0 4 0> non-zero result=0x10000
scsi_debug: slave_destroy <3 0 5 0> [db1dc400]
scsi_debug: slave_alloc <3 0 5 0> [db1dc400]
scsi_debug: cmd 12 00 00 00 24 00  [db1dc400]
scsi_debug: ... <3 0 5 0> non-zero result=0x10000
scsi_debug: slave_destroy <3 0 6 0> [db1dc400]
scsi_debug: slave_alloc <3 0 6 0> [db1dc400]
scsi_debug: cmd 12 00 00 00 24 00  [db1dc400]
scsi_debug: ... <3 0 6 0> non-zero result=0x10000
scsi_debug: slave_destroy <3 0 6 0> [db1dc400]
scsi_debug: slave_configure <3 0 0 0> [db1dc000]
scsi_debug: cmd 00 00 00 00 00 00  [db1dc000]
scsi_debug: cmd 1a 08 08 00 80 00  [db1dc000]
SCSI device sdb: drive cache: write back
scsi_debug: cmd 25 00 00 00 00 00 00 00 00 00  [db1dc000]
scsi_debug: ... <3 0 0 0> non-zero result=0x2
scsi_debug: cmd 25 00 00 00 00 00 00 00 00 00  [db1dc000]
SCSI device sdb: 16384 512-byte hdwr sectors (8 MB)
 sdb:<6>scsi_debug: cmd 28 00 00 00 00 00 00 00 08 00  [db1dc000]
 unknown partition table
Attached scsi disk sdb at scsi3, channel 0, id 0, lun 0
scsi_debug: slave_configure <3 0 0 1> [db1d6c00]
scsi_debug: cmd 00 00 00 00 00 00  [db1d6c00]
scsi_debug: cmd 1a 08 08 00 80 00  [db1d6c00]
SCSI device sdc: drive cache: write back
scsi_debug: cmd 25 00 00 00 00 00 00 00 00 00  [db1d6c00]
scsi_debug: ... <3 0 0 1> non-zero result=0x2
scsi_debug: cmd 25 00 00 00 00 00 00 00 00 00  [db1d6c00]
SCSI device sdc: 16384 512-byte hdwr sectors (8 MB)
 sdc:<6>scsi_debug: cmd 28 00 00 00 00 00 00 00 08 00  [db1d6c00]
 unknown partition table
Attached scsi disk sdc at scsi3, channel 0, id 0, lun 1
scsi_debug: ... built 1 host(s)

--------------070805010604050908070805--


