From: Matthew Wilcox <willy@debian.org>
Subject: Missing allowable state transition?
Date: Sun, 19 Sep 2004 03:37:49 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040919023749.GF642@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:46219 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S269729AbUISChu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Sep 2004 22:37:50 -0400
Received: from willy by www.linux.org.uk with local (Exim 4.33)
	id 1C8raH-0002VE-MX
	for linux-scsi@vger.kernel.org; Sun, 19 Sep 2004 03:37:49 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I got forwarded this dmesg from a PA-RISC user ...

----- Forwarded message from Stuart Brady -----

Linux version 2.6.9-rc2-pa5 (sdb@1986u10) (gcc version 3.3.4 (Debian 1:3.3.4-6sarge1)) #2 Sat Sep 18 19:38:34 BST 2004
[...]
53c700: Version 2.8 By James.Bottomley@HansenPartnership.com
scsi0: 53c710 rev 2 
scsi0 : LASI SCSI 53c700
Using anticipatory io scheduler
scsi0 (6:0) New error handler wants to abort command
	scsi0 : destination target 6, lun 0
        command = 0x12 00 00 00 24 00 
scsi0 (6:0) New error handler wants device reset
	scsi0 : destination target 6, lun 0
        command = 0x12 00 00 00 24 00 
scsi0 (6:0) New error handler wants BUS reset, cmd 107d1cc0
	scsi0 : destination target 6, lun 0
        command = 0x12 00 00 00 24 00 
scsi0: Bus Reset detected, executing command 107d1cc0, slot 00008520, dsp 007f0528[0528]
 failing command because of reset, slot 00008520, cmnd 107d1cc0
 0:0:6:0: Illegal state transition created->quiesce
Badness in scsi_device_set_state at drivers/scsi/scsi_lib.c:1688
Backtrace:
 [<10211750>] scsi_device_set_state+0xf0/0x164
 [<102117d8>] scsi_device_quiesce+0x14/0x64
 [<10216274>] spi_dv_device+0x68/0x178
 [<1021639c>] spi_dv_device_work_wrapper+0x18/0x38
 [<10139eb4>] worker_thread+0x1ac/0x278
 [<1013ea14>] kthread+0xdc/0xe4
 [<1010ec5c>] ret_from_kernel_thread+0x1c/0x24

  Vendor: SEAGATE   Model: ST52160N          Rev: 0285
  Type:   Direct-Access                      ANSI SCSI revision: 02
scsi(0:0:6:0): Beginning Domain Validation
scsi0: (6:0) Asynchronous
scsi0: (6:0) Synchronous at offset 8, period 100ns
scsi(0:0:6:0): Domain Validation skipping write tests
scsi(0:0:6:0): Ending Domain Validation
SCSI device sda: 4238282 512-byte hdwr sectors (2170 MB)
SCSI device sda: drive cache: write back
 sda: sda1 sda2 sda3 < sda5 sda6 >
Attached scsi disk sda at scsi0, channel 0, id 6, lun 0

----- End forwarded message -----

Seems to me it should be legitimate to go from created to quiesce.
Obviously it's not common, but it does seem legitimate if the first
command to the device causes it to require a bus reset.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
