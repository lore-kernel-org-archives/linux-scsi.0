From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: 2.6.23-rc4-mm1
Date: Tue, 11 Sep 2007 04:10:47 +0900
Message-ID: <20070910042256Z.tomof@acm.org>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
	<20070910174926.GC30335@shadowen.org>
	<20070910111926.9c942358.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:46235 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919AbXIJTMG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Sep 2007 15:12:06 -0400
In-Reply-To: <20070910111926.9c942358.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: apw@shadowen.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mel@csn.ul.ie, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Mon, 10 Sep 2007 11:19:26 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 10 Sep 2007 18:49:26 +0100 Andy Whitcroft <apw@shadowen.org> wrote:
> 
> > I have a couple of old NUMA-Q systems which are unable to read their
> > boot disks with 2.6.23-rc4-mm1.  The disks appear to be recognised and
> > even the partition tables read correctly, and then they go pop:
> > 
> >   qla1280: QLA1040 found on PCI bus 0, dev 10
> 
> cc's added.
> 
> >   Clocksource tsc unstable (delta = 99922590 ns)
> >   Time: jiffies clocksource has been installed.
> >   scsi(0:0): Resetting SCSI BUS
> >   scsi0 : QLogic QLA1040 PCI to SCSI Host Adapter
> >          Firmware version:  7.65.06, Driver version 3.26
> >   scsi 0:0:0:0: Direct-Access     IBM      DGHS18X          0360 PQ: 0 ANSI: 3
> >   scsi(0:0:0:0): Sync: period 10, offset 12, Wide
> >   scsi 0:0:1:0: Direct-Access     IBM OEM  DCHS09X          5454 PQ: 0 ANSI: 2
> >   scsi(0:0:1:0): Sync: period 10, offset 12, Wide
> >   scsi 0:0:2:0: Direct-Access     IBM OEM  DCHS09X          5454 PQ: 0 ANSI: 2
> >   scsi(0:0:2:0): Sync: period 10, offset 12, Wide
> >   scsi 0:0:3:0: Direct-Access     IBM OEM  DCHS09X          5454 PQ: 0 ANSI: 2
> >   scsi(0:0:3:0): Sync: period 10, offset 12, Wide
> >   scsi 0:0:4:0: Direct-Access     IBM OEM  DCHS09X          5454 PQ: 0 ANSI: 2
> >   scsi(0:0:4:0): Sync: period 10, offset 12, Wide
> >   st: Version 20070203, fixed bufsize 32768, s/g segs 256
> >   sd 0:0:0:0: [sda] 35843670 512-byte hardware sectors (18352 MB)
> >   sd 0:0:0:0: [sda] Write Protect is off
> >   sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
> >   sd 0:0:0:0: [sda] 35843670 512-byte hardware sectors (18352 MB)
> >   sd 0:0:0:0: [sda] Write Protect is off
> >   sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
> >    sda: sda1
> >   sd 0:0:0:0: [sda] Attached SCSI disk
> >   sd 0:0:1:0: [sdb] 17796077 512-byte hardware sectors (9112 MB)
> >   sd 0:0:1:0: [sdb] Write Protect is off
> >   sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
> >   sd 0:0:1:0: [sdb] 17796077 512-byte hardware sectors (9112 MB)
> >   sd 0:0:1:0: [sdb] Write Protect is off
> >   sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
> >    sdb: unknown partition table
> >   sd 0:0:1:0: [sdb] Attached SCSI disk
> >   sd 0:0:2:0: [sdc] 17796077 512-byte hardware sectors (9112 MB)
> >   sd 0:0:2:0: [sdc] Write Protect is off
> >   sd 0:0:2:0: [sdc] Write cache: disabled, read cache: enabled, supports DPO and FUA
> >   sd 0:0:2:0: [sdc] 17796077 512-byte hardware sectors (9112 MB)
> >   sd 0:0:2:0: [sdc] Write Protect is off
> >   sd 0:0:2:0: [sdc] Write cache: disabled, read cache: enabled, supports DPO and FUA
> >    sdc: sdc1
> >   sd 0:0:2:0: [sdc] Attached SCSI disk
> >   sd 0:0:3:0: [sdd] 17796077 512-byte hardware sectors (9112 MB)
> >   sd 0:0:3:0: [sdd] Write Protect is off
> >   sd 0:0:3:0: [sdd] Write cache: disabled, read cache: enabled, supports DPO and FUA
> >   sd 0:0:3:0: [sdd] 17796077 512-byte hardware sectors (9112 MB)
> >   sd 0:0:3:0: [sdd] Write Protect is off
> >   sd 0:0:3:0: [sdd] Write cache: disabled, read cache: enabled, supports DPO and FUA
> >    sdd: sdd1
> >   sd 0:0:3:0: [sdd] Attached SCSI disk
> >   sd 0:0:4:0: [sde] 17796077 512-byte hardware sectors (9112 MB)
> >   sd 0:0:4:0: [sde] Write Protect is off
> >   sd 0:0:4:0: [sde] Write cache: disabled, read cache: enabled, supports DPO and FUA
> >   sd 0:0:4:0: [sde] 17796077 512-byte hardware sectors (9112 MB)
> >   sd 0:0:4:0: [sde] Write Protect is off
> >   sd 0:0:4:0: [sde] Write cache: disabled, read cache: enabled, supports DPO and FUA
> >    sde: unknown partition table
> >   sd 0:0:4:0: [sde] Attached SCSI disk
> >   sd 0:0:0:0: Attached scsi generic sg0 type 0
> >   sd 0:0:1:0: Attached scsi generic sg1 type 0
> >   sd 0:0:2:0: Attached scsi generic sg2 type 0
> >   sd 0:0:3:0: Attached scsi generic sg3 type 0
> >   sd 0:0:4:0: Attached scsi generic sg4 type 0
> >   serio: i8042 KBD port at 0x60,0x64 irq 1
> >   serio: i8042 AUX port at 0x60,0x64 irq 12
> >   mice: PS/2 mouse device common for all mice
> >   input: AT Translated Set 2 keyboard as /class/input/input0
> >   oprofile: using NMI interrupt.
> >   TCP cubic registered
> >   NET: Registered protocol family 1
> >   NET: Registered protocol family 17
> >   Using IPI Shortcut mode
> >   input: PS/2 Logitech Mouse as /class/input/input1
> >   RAMDISK: cramfs filesystem found at block 0
> >   RAMDISK: Loading 1244KiB [1 disk] into ram disk... |/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/done.
> >   VFS: Mounted root (cramfs filesystem) readonly.
> >   Freeing unused kernel memory: 220k freed
> >   initrd-tools: 0.1.81.1
> >   mount: fs type devfs not supported by kernel
> >   FATAL: Module sd_mod not found.
> >   umount: devfs: not mounted
> >   ext3: No journal on filesystem on sda1
> >   sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
> >   end_request: I/O error, dev sda, sector 63
> >   Buffer I/O error on device sda1, logical block 0
> >   Buffer I/O error on device sda1, logical block 1
> >   Buffer I/O error on device sda1, logical block 2
> >   Buffer I/O error on device sda1, logical block 3
> >   mount: fs type devfs not supported by kernel
> >   ext3: No journal on filesystem on sda1
> >   umount: devfs: not mounted
> >   sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
> >   end_request: I/O error, dev sda, sector 28010831
> >   sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
> >   end_request: I/O error, dev sda, sector 31080815
> >   sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
> >   end_request: I/O error, dev sda, sector 31080855
> >   sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
> >   end_request: I/O error, dev sda, sector 31080919
> >   Buffer I/O error on device sda1, logical block 3885107
> >   sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
> >   end_request: I/O error, dev sda, sector 28411047
> >   sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
> >   end_request: I/O error, dev sda, sector 31135687
> >   sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
> >   end_request: I/O error, dev sda, sector 31138007
> >   sd 0:0:0:0: [sda] <6>sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
> > 
> 
> The only patch which touches qla1280 is git-block.patch.  From a quick
> squizz the change looks OK, although it's tricky and something might have
> broken.

Can you try this patch (against 2.6.23-rc4-mm1)?

>From 592bd2049cb3e6e1f1dde7cf631879f26ddffeaa Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 10 Sep 2007 04:17:13 +0100
Subject: [PATCH] qla1280: sg chaining fixes

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/qla1280.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index bd805ec..7c1eaec 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -2977,8 +2977,8 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 						cpu_to_le32(pci_dma_hi32(dma_handle)),
 						cpu_to_le32(pci_dma_lo32(dma_handle)),
 						cpu_to_le32(sg_dma_len(s)));
-					remseg--;
 				}
+				remseg -= cnt;
 				dprintk(5, "qla1280_64bit_start_scsi: "
 					"continuation packet data - b %i, t "
 					"%i, l %i \n", SCSI_BUS_32(cmd),
@@ -3250,6 +3250,8 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 
 				/* Load continuation entry data segments. */
 				for_each_sg(sg, s, remseg, cnt) {
+					if (cnt == 7)
+						break;
 					*dword_ptr++ =
 						cpu_to_le32(pci_dma_lo32(sg_dma_address(s)));
 					*dword_ptr++ =
@@ -3260,6 +3262,7 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 						cpu_to_le32(pci_dma_lo32(sg_dma_address(s))),
 						cpu_to_le32(sg_dma_len(s)));
 				}
+				remseg -= cnt;
 				dprintk(5, "qla1280_32bit_start_scsi: "
 					"continuation packet data - "
 					"scsi(%i:%i:%i)\n", SCSI_BUS_32(cmd),
-- 
1.5.2.4


