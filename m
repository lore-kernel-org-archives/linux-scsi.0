From: Jan Engelhardt <jengelh@inai.de>
Subject: Talking to reset disk without device node
Date: Fri, 18 Jan 2013 11:08:44 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1301181047490.16641@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:57575 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449Ab3ARKIq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jan 2013 05:08:46 -0500
Received: from localhost (localhost [127.0.0.1])
	by ares07.inai.de (Postfix) with ESMTP id D4AEB96A06B0
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jan 2013 11:08:44 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I have here a system with Linux 3.4.4 and what seems to be flakey
PCI bridge hardware, as it has occurred previously on different SATA
controllers and had fixed itself up after a reboot.

Anyhow, as a result of the disk "disappearing", sd_mod will
deregister it so that /dev/sdl will be invalid/cleanup by udevd. This
makes it impossible to send SMART commands to the disk, even though
the controller seems to be still able to communicate with the disk
and determine it is (still) a WDC.

Which values does 
/sys/devices/pci0000:00/0000:00:08.0/0000:01:09.0/ata14/host13/scsi_host/host13/state 
accept?

[    0.172945] pci 0000:00:08.0: [10de:0449] type 01 class 0x060401
[    0.173392] pci 0000:01:09.0: [1095:3114] type 00 class 0x010400
[    0.173403] pci 0000:01:09.0: reg 10: [io  0xc800-0xc807]
[    0.173410] pci 0000:01:09.0: reg 14: [io  0xc400-0xc403]
[    0.173417] pci 0000:01:09.0: reg 18: [io  0xc000-0xc007]
[    0.173424] pci 0000:01:09.0: reg 1c: [io  0xbc00-0xbc03]
[    0.173431] pci 0000:01:09.0: reg 20: [io  0xb800-0xb80f]
[    0.173438] pci 0000:01:09.0: reg 24: [mem 0xfdefe000-0xfdefe3ff]
[    0.173445] pci 0000:01:09.0: reg 30: [mem 0x00000000-0x0007ffff pref]
[    0.173463] pci 0000:01:09.0: supports D1 D2
[    3.106380] sata_sil 0000:01:09.0: version 2.4
[    3.106610] ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
[    3.106683] sata_sil 0000:01:09.0: Applying R_ERR on DMA activate FIS errata fix
[    3.106731] sata_sil 0000:01:09.0: setting latency timer to 64
[    3.107372] scsi13 : sata_sil
[    3.107573] ata14: SATA max UDMA/100 mmio m1024@0xfdefe000 tf 0xfdefe2c0 irq 17
[    5.044033] ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[    5.053100] ata14.00: ATA-9: WDC WD30EZRX-00DC0B0, 80.00A80, max UDMA/133
[    5.053137] ata14.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    5.061115] ata14.00: configured for UDMA/100
[    5.061225] scsi 13:0:0:0: Direct-Access     ATA      WDC WD30EZRX-00D 80.0 PQ: 0 ANSI: 5
[    5.061358] sd 13:0:0:0: [sdl] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    5.061403] sd 13:0:0:0: [sdl] 4096-byte physical blocks
[    5.061525] sd 13:0:0:0: [sdl] Write Protect is off
[    5.061677] sd 13:0:0:0: [sdl] Mode Sense: 00 3a 00 00
[    5.061712] sd 13:0:0:0: [sdl] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.731484]  sdl: unknown partition table
[    5.731667] sd 13:0:0:0: [sdl] Attached SCSI disk
[64765.190933] ata14.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[64765.190938] ata14.00: BMDMA2 stat 0x50001
[64765.190943] ata14.00: failed command: WRITE DMA EXT
[64765.190951] ata14.00: cmd 35/00:00:e0:e9:3e/00:08:62:00:00/e0 tag 0 dma 1048576 out
[64765.190953]          res 61/04:00:e0:e9:3e/00:08:62:00:00/f0 Emask 0x1 (device error)
[64765.190957] ata14.00: status: { DRDY DF ERR }
[64765.190960] ata14.00: error: { ABRT }
[64765.196394] ata14.00: failed to read native max address (err_mask=0x1)
[64765.196397] ata14.00: HPA support seems broken, skipping HPA handling
[64765.212218] ata14.00: failed to set xfermode (err_mask=0x1)
[64765.212232] ata14: hard resetting link
[64765.532049] ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[64765.557220] ata14.00: failed to set xfermode (err_mask=0x1)
[64765.557228] ata14.00: limiting speed to UDMA/100:PIO3
[64770.532046] ata14: hard resetting link
[64770.852064] ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[64770.876216] ata14.00: failed to set xfermode (err_mask=0x1)
[64770.876225] ata14.00: disabled
[64770.876329] ata14: EH complete
[64770.876373] sd 13:0:0:0: [sdl] Unhandled error code
[64770.876379] sd 13:0:0:0: [sdl]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[64770.876388] sd 13:0:0:0: [sdl] CDB: Write(10): 2a 00 62 3e e9 e0 00 08 00 00
[64770.876407] end_request: I/O error, dev sdl, sector 1648290272
[64770.876703] sd 13:0:0:0: [sdl] Unhandled error code
[64770.876708] sd 13:0:0:0: [sdl]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[64770.876716] sd 13:0:0:0: [sdl] CDB: Write(10): 2a 00 62 3e f1 e0 00 08 00 00
[64770.876731] end_request: I/O error, dev sdl, sector 1648292320
[64770.876770] sd 13:0:0:0: [sdl] Unhandled error code
[64770.876777] sd 13:0:0:0: [sdl]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[64770.876787] sd 13:0:0:0: [sdl] CDB: Read(16): 88 00 00 00 00 01 3f b0 ab 48 00 00 00 88 00 00
[64770.876809] end_request: I/O error, dev sdl, sector 5363510088
[64770.876817] Buffer I/O error on device sdl, logical block 670438761
[64770.876837] Buffer I/O error on device sdl, logical block 670438762
[...]

On doing `echo - - - >/sys/devices/pci0000:00/0000:00:08.0/0000:01:09.0/ata14/host13/scsi_host/host13/scan`,
this occurs:

[65438.178824] ata14: hard resetting link
[65438.496048] ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[65438.504977] ata14.00: failed to read native max address (err_mask=0x1)
[65438.504986] ata14.00: HPA support seems broken, skipping HPA handling
[65438.504999] ata14.00: ATA-9: WDC WD30EZRX-00DC0B0, 80.00A80, max UDMA/133
[65438.505007] ata14.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[65438.520231] ata14.00: failed to set xfermode (err_mask=0x1)
[65443.496035] ata14: hard resetting link
[65443.816053] ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[65443.840212] ata14.00: failed to set xfermode (err_mask=0x1)
[65443.840226] ata14.00: limiting speed to UDMA/100:PIO3
[65448.816053] ata14: hard resetting link
[65449.136054] ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[65449.160326] ata14.00: failed to set xfermode (err_mask=0x1)
[65449.160335] ata14.00: disabled
[65449.160356] ata14: EH complete
[65449.160380] ata14.00: detaching (SCSI 13:0:0:0)
[65449.163545] sd 13:0:0:0: [sdl] Stopping disk
[65449.163622] sd 13:0:0:0: [sdl] START_STOP FAILED
[65449.163627] sd 13:0:0:0: [sdl]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK

(So apparently, libata can still figure out that it is a WDC WD30,
but the /dev/sdl and corresponding sg device node is gone,
making it impossible to send SMART commands for further inspection.)
