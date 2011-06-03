From: Xiangliang Yu <yuxiangl@marvell.com>
Subject: BUG: linux-2.6.39 kernel panic issue when hot-plut disk during I/O
Date: Thu, 2 Jun 2011 20:27:28 -0700
Message-ID: <F766E4F80769BD478052FB6533FA745D19FADEEADF@SC-VEXCH4.marvell.com>
References: <20110602234645.6352.38075.stgit@localhost6.localdomain6>
 <9CA988CDD3E54DBA829117B230B6F986@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:52483 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751701Ab1FCD1m convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jun 2011 23:27:42 -0400
In-Reply-To: <9CA988CDD3E54DBA829117B230B6F986@usish.com.cn>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>, 'Dan Williams' <dan.j.williams@intel.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>
Cc: 'Lindar Liu' <lindar_liu@usish.com>, 'Ankit Jain' <jankit@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Xiangliang Yu <yuxiangl@marvell.com>

Hi, all
I upgrade kernel version to 2.6.39 and find out a kernel panic when I test the MVSAS driver: kernel panic if hot-plug disk during I/O. But the driver is OK in version 2.6.37. And I test the AHCI driver in 2.6.39, the result is OK. I change queue-depth to 1 in 2.6.39, and kernel panic again. However, when add a printk debug statement in ata_sas_queuecmd function, and kernel panic is gone. According to the above, i think the bug is LIBSAS bug, may be is some lock issue. But can't find the real problem, so, please look at the issue. Thanks! See below for the log info:

drivers/scsi/mvsas/mv_sas.c 2204:port 1 ctrl sts=0x111000.
drivers/scsi/mvsas/mv_sas.c 2206:Port 1 irq sts = 0x1000081
drivers/scsi/mvsas/mv_sas.c 2204:port 1 ctrl sts=0x111000.
drivers/scsi/mvsas/mv_sas.c 2206:Port 1 irq sts = 0x10000
drivers/scsi/mvsas/mv_sas.c 2259:notify plug in on phy[1]
drivers/scsi/mvsas/mv_94xx.c 505:get all reg link rate is 0x111000
drivers/scsi/mvsas/mv_94xx.c 510:get link rate is 9
drivers/scsi/mvsas/mv_sas.c 1344:port 1 attach dev info is 20001
drivers/scsi/mvsas/mv_sas.c 1346:port 1 attach sas addr is 1
drivers/scsi/mvsas/mv_sas.c 379:phy 1 byte dmaded.
sas: phy-7:1 added to port-7:1, phy_mask:0x2 ( 100000000000000)
sas: DOING DISCOVERY on port 1, pid:66
drivers/scsi/mvsas/mv_sas.c 1509:found dev[0:5] is gone.
sas: Enter sas_scsi_recover_host
ata8: sas eh calling libata port error handler
ata9: sas eh calling libata port error handler
sas: sas_ata_hard_reset: Found ATA device.
ata9.00: ATA-7: ST3160815AS, 3.AAD, max UDMA/133
ata9.00: 312581808 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata9.00: configured for UDMA/133
sas: --- Exit sas_scsi_recover_host
scsi_error_handler: restart op.
scsi_error_handler: autopm .
scsi 7:0:1:0: Direct-Access     ATA      ST3160815AS      3.AA PQ: 0 ANSI: 5
sd 7:0:1:0: [sdc] 312581808 512-byte logical blocks: (160 GB/149 GiB)
sd 7:0:1:0: Attached scsi generic sg2 type 0
sas: DONE DISCOVERY on port 1, pid:66, result:0
sd 7:0:1:0: [sdc] Write Protect is off
sd 7:0:1:0: [sdc] Mode Sense: 00 3a 00 00
sd 7:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sdc: detected capacity change from 0 to 160041885696
scsi_error_handler: set state.
 sdc: unknown partition table
sd 7:0:1:0: [sdc] Attached SCSI disk
drivers/scsi/mvsas/mv_sas.c 2204:port 1 ctrl sts=0x0.
drivers/scsi/mvsas/mv_sas.c 2206:Port 1 irq sts = 0x1001001
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [c] tag[c], task [efceae80]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [13] tag[13], task [efcea5c0]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [14] tag[14], task [efcea480]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [3] tag[3], task [f535e440]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [d] tag[d], task [efcead40]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [9] tag[9], task [f3a83bc0]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [1c] tag[1c], task [f3a83a80]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [1b] tag[1b], task [f3a83080]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [15] tag[15], task [efcea340]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [a] tag[a], task [efd92200]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [6] tag[6], task [efd92700]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [f] tag[f], task [efc11940]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [8] tag[8], task [efd92480]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [11] tag[11], task [f4200d40]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [12] tag[12], task [efcea700]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [1d] tag[1d], task [f535ebc0]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [16] tag[16], task [efd92340]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [5] tag[5], task [efd92840]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [1a] tag[1a], task [f4200c00]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [19] tag[19], task [f535e940]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [7] tag[7], task [f535e300]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [1] tag[1], task [efd92d40]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [b] tag[b], task [efd920c0]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [1e] tag[1e], task [f4200700]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [17] tag[17], task [efcea0c0]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [2] tag[2], task [f3a83940]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [0] tag[0], task [f535ed00]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [18] tag[18], task [f4200e80]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [10] tag[10], task [efc116c0]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [4] tag[4], task [efd92980]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2090:Release slot [e] tag[e], task [efc11d00]:
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2232:phy1 Unplug Notice
drivers/scsi/mvsas/mv_sas.c 2204:port 1 ctrl sts=0x0.
drivers/scsi/mvsas/mv_sas.c 2206:Port 1 irq sts = 0x1
sas: Enter sas_scsi_recover_host
ata9: sas eh calling libata cmd error handler
ata8: sas eh calling libata port error handler
ata9: sas eh calling libata port error handler
ata9.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 action 0x6
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:b0:eb:37/00:00:0e:00:00/40 tag 0 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:a0:af:69/00:00:00:00:00/40 tag 1 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:f8:df:d2/00:00:10:00:00/40 tag 2 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:b8:95:8e/00:00:0e:00:00/40 tag 3 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:58:9d:60/00:00:01:00:00/40 tag 4 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:98:13:4f/00:00:02:00:00/40 tag 5 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:10:72:3d/00:00:08:00:00/40 tag 6 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:c0:64:0d/00:00:00:00:00/40 tag 7 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:c8:62:fb/00:00:0f:00:00/40 tag 8 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:90:9e:29/00:00:10:00:00/40 tag 9 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:38:08:50/00:00:0f:00:00/40 tag 10 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:90:15:f6/00:00:0f:00:00/40 tag 11 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:28:b9:f3/00:00:0b:00:00/40 tag 12 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:28:e5:90/00:00:0b:00:00/40 tag 13 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:c0:9a:85/00:00:0a:00:00/40 tag 14 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:48:d4:3e/00:00:00:00:00/40 tag 15 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:48:11:30/00:00:0c:00:00/40 tag 16 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:c0:a4:8c/00:00:0b:00:00/40 tag 17 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:78:2b:bf/00:00:0e:00:00/40 tag 18 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:38:ff:84/00:00:0c:00:00/40 tag 19 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:28:49:41/00:00:0c:00:00/40 tag 20 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:90:c9:09/00:00:11:00:00/40 tag 21 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:40:bd:5d/00:00:01:00:00/40 tag 22 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:38:da:c3/00:00:01:00:00/40 tag 23 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:c0:1b:f4/00:00:06:00:00/40 tag 24 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:80:26:4b/00:00:03:00:00/40 tag 25 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:48:d1:7c/00:00:00:00:00/40 tag 26 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:b0:1f:0d/00:00:12:00:00/40 tag 27 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:08:55:9e/00:00:0b:00:00/40 tag 28 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:58:5b:12/00:00:04:00:00/40 tag 29 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9.00: failed command: READ FPDMA QUEUED
ata9.00: cmd 60/08:00:e8:03:be/00:00:0e:00:00/40 tag 30 ncq 4096 in
         res 01/04:20:58:9d:60/00:00:01:00:00/40 Emask 0x12 (ATA bus error)
ata9.00: status: { ERR }
ata9.00: error: { ABRT }
ata9: hard resetting link
sas: sas_ata_hard_reset: Found ATA device.
drivers/scsi/mvsas/mv_sas.c 906:SATA/STP port 1 does not attachdevice.
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 2139:phy1 Removed Device
sas_deform_port: 1.
drivers/scsi/mvsas/mv_sas.c 906:SATA/STP port 1 does not attachdevice.
sas: sas_ata_task_done: SAS error 8a
ata9.00: both IDENTIFYs aborted, assuming NODEV
ata9.00: revalidation failed (errno=-2)
sd 7:0:1:0: [sdc] Synchronizing SCSI cache
ata9: hard resetting link
sas: sas_ata_hard_reset: Found ATA device.
drivers/scsi/mvsas/mv_sas.c 906:SATA/STP port 1 does not attachdevice.
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 906:SATA/STP port 1 does not attachdevice.
sas: sas_ata_task_done: SAS error 8a
ata9.00: both IDENTIFYs aborted, assuming NODEV
ata9.00: revalidation failed (errno=-2)
ata9: hard resetting link
sas: sas_ata_hard_reset: Found ATA device.
drivers/scsi/mvsas/mv_sas.c 906:SATA/STP port 1 does not attachdevice.
sas: sas_ata_task_done: SAS error 8a
drivers/scsi/mvsas/mv_sas.c 906:SATA/STP port 1 does not attachdevice.
sas: sas_ata_task_done: SAS error 8a
ata9.00: both IDENTIFYs aborted, assuming NODEV
ata9.00: revalidation failed (errno=-2)
ata9.00: disabled
ata9: EH complete
sas: --- Exit sas_scsi_recover_host
scsi_error_handler: restart op.
scsi_error_handler: autopm .
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 0e be 03 e8 00 00 08 00
end_request: I/O error, dev sdc, sector 247333864
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 04 12 5b 58 00 00 08 00
end_request: I/O error, dev sdc, sector 68311896
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 0b 9e 55 08 00 00 08 00
end_request: I/O error, dev sdc, sector 194925832
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 12 0d 1f b0 00 00 08 00
end_request: I/O error, dev sdc, sector 302849968
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 00 7c d1 48 00 00 08 00
end_request: I/O error, dev sdc, sector 8180040
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 03 4b 26 80 00 00 08 00
end_request: I/O error, dev sdc, sector 55256704
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 06 f4 1b c0 00 00 08 00
end_request: I/O error, dev sdc, sector 116661184
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 01 c3 da 38 00 00 08 00
end_request: I/O error, dev sdc, sector 29612600
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 01 5d bd 40 00 00 08 00
end_request: I/O error, dev sdc, sector 22920512
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 11 09 c9 90 00 00 08 00
end_request: I/O error, dev sdc, sector 285854096
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 0c 41 49 28 00 00 08 00
end_request: I/O error, dev sdc, sector 205605160
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 0c 84 ff 38 00 00 08 00
end_request: I/O error, dev sdc, sector 210042680
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 0e bf 2b 78 00 00 08 00
end_request: I/O error, dev sdc, sector 247409528
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 0b 8c a4 c0 00 00 08 00
end_request: I/O error, dev sdc, sector 193766592
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 0c 30 11 48 00 00 08 00
end_request: I/O error, dev sdc, sector 204476744
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 00 3e d4 48 00 00 08 00
end_request: I/O error, dev sdc, sector 4117576
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 0a 85 9a c0 00 00 08 00
end_request: I/O error, dev sdc, sector 176528064
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 0b 90 e5 28 00 00 08 00
end_request: I/O error, dev sdc, sector 194045224
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 0b f3 b9 28 00 00 08 00
end_request: I/O error, dev sdc, sector 200522024
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 0f f6 15 90 00 00 08 00
end_request: I/O error, dev sdc, sector 267785616
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 0f 50 08 38 00 00 08 00
end_request: I/O error, dev sdc, sector 256903224
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 10 29 9e 90 00 00 08 00
end_request: I/O error, dev sdc, sector 271163024
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 0f fb 62 c8 00 00 08 00
end_request: I/O error, dev sdc, sector 268133064
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 00 0d 64 c0 00 00 08 00
end_request: I/O error, dev sdc, sector 877760
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 08 3d 72 10 00 00 08 00
end_request: I/O error, dev sdc, sector 138244624
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 02 4f 13 98 00 00 08 00
end_request: I/O error, dev sdc, sector 38736792
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 01 60 9d 58 00 00 08 00
end_request: I/O error, dev sdc, sector 23108952
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 0e 8e 95 b8 00 00 08 00
end_request: I/O error, dev sdc, sector 244225464
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 10 d2 df f8 00 00 08 00
end_request: I/O error, dev sdc, sector 282255352
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 00 69 af a0 00 00 08 00
end_request: I/O error, dev sdc, sector 6926240
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] CDB: Read(10): 28 00 0e 37 eb b0 00 00 08 00
end_request: I/O error, dev sdc, sector 238545840
scsi_io_completion: end request.
sd 7:0:1:0: [sdc] Unhandled error code
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 7:0:1:0: [sdc] Stopping disk
sd 7:0:1:0: [sdc] START_STOP FAILED
sd 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
drivers/scsi/mvsas/mv_sas.c 1509:found dev[0:5] is gone.
sas_deform_port: 2.
sas_deform_port: 3.
scsi 7:0:1:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
scsi 7:0:1:0: [sdc] CDB: Read(10): 28 00 12 37 3a 60 00 00 08 00
end_request: I/O error, dev sdc, sector 305609312
BUG: unable to handle kernel paging request at 76656453
IP: [<c051c9a4>] elv_completed_request+0x31/0x3e
*pde = 00000000
Oops: 0000 [#1] SMP
last sysfs file: /sys/block/sdb/stat
Modules linked in: mvsas libsas ipv6 autofs4 cpufreq_ondemand acpi_cpufreq mperf loop dm_multipath scsi_dh video sbs sbshc power_meter hwmon battery ac power_supply lp sg option usb_wwan usbserial tpm_tis tpm r8169 mii i2c_i801 i2c_core tpm_bios scsi_transport_sas rtc_cmos rtc_core rtc_lib button serio_raw parport_pc parport pcspkr dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod ata_piix ahci libahci libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last unloaded: libsas]

Pid: 9099, comm: scsi_eh_7 Not tainted 2.6.39 #5 System manufacturer System Product Name/P7H55-M
EIP: 0060:[<c051c9a4>] EFLAGS: 00010002 CPU: 0
EIP is at elv_completed_request+0x31/0x3e
EAX: 7665642f EBX: f5776504 ECX: f5e629c0 EDX: f3b17a28
ESI: f3b17a28 EDI: f5776504 EBP: f5776504 ESP: f5c0df50
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process scsi_eh_7 (pid: 9099, ti=f5c0c000 task=f5778490 task.ti=f4b2a000)
Stack:
 00000246 c051f624 00000246 f3b17a28 fffffffb f5776504 c051fa63 fffffffb
 f3b17a28 fffffffb f3b17a28 c051fa80 00000000 c051fab0 f83d69fc f41e48c0
 f83c3819 00000000 00040000 f5776504 00000000 00000000 f5776504 00000000
Call Trace:
 [<c051f624>] ? __blk_put_request+0x22/0x99
 [<c051fa63>] ? blk_end_bidi_request+0x34/0x4a
 [<c051fa80>] ? blk_end_request+0x7/0xc
 [<c051fab0>] ? blk_end_request_err+0x2b/0x31
 [<f83c3819>] ? scsi_io_completion+0x3a7/0x402 [scsi_mod]
 [<c0524f5a>] ? blk_done_softirq+0x42/0x50
 [<c0433668>] ? __do_softirq+0xa5/0x143
 [<c04335c3>] ? local_bh_enable_ip+0x67/0x67
 <IRQ>
 [<c0417743>] ? smp_apic_timer_interrupt+0x6b/0x75
 [<c069d91a>] ? apic_timer_interrupt+0x2a/0x30
 [<c042007b>] ? flush_tlb_mm+0x3d/0x5b
 [<c042fdd1>] ? vprintk+0x331/0x33d
 [<f83c432c>] ? scsi_request_fn+0x2fb/0x3bb [scsi_mod]
 [<c04528c2>] ? module_refcount+0x64/0x77
 [<f83c1e54>] ? scsi_block_when_processing_errors+0xc7/0xc7 [scsi_mod]
 [<c042fdf1>] ? printk+0x14/0x18
 [<f83c22bc>] ? scsi_error_handler+0x468/0x4e0 [scsi_mod]
 [<c042bd99>] ? complete+0x28/0x36
 [<f83c1e54>] ? scsi_block_when_processing_errors+0xc7/0xc7 [scsi_mod]
 [<c0443c46>] ? kthread+0x65/0x6a
 [<c0443be1>] ? kthread_stop+0x8d/0x8d
 [<c06a27f6>] ? kernel_thread_helper+0x6/0xd
Code: 8b 42 20 f6 c4 40 74 2e 83 7a 24 01 74 04 a8 40 74 24 83 e0 11 48 0f 95 c0 83 e0 01 ff 8c 83 64 02 00 00 f6 42 21 04 74 0d 8b 01 <8b> 48 24 85 c9 74 04 89 d8 ff d1 5b c3 8d 42 4c e8 9a 40 01 00
EIP: [<c051c9a4>] elv_completed_request+0x31/0x3e SS:ESP 0068:f5c0df50
CR2: 0000000076656453
---[ end trace 29b20858e32b84e9 ]---
Kernel panic - not syncing: Fatal exception in interrupt
Pid: 9099, comm: scsi_eh_7 Tainted: G      D     2.6.39 #5
Call Trace:
 [<c042f1e6>] ? panic+0x53/0x12e
 [<c069e3b2>] ? oops_end+0x89/0x94
 [<c041cf29>] ? no_context+0x10d/0x116
 [<c041d07c>] ? bad_area_nosemaphore+0xa/0xc
 [<c069fc03>] ? do_page_fault+0x3b8/0x3c0
 [<c04d0f75>] ? aio_complete+0x155/0x15f
 [<c069d427>] ? _raw_spin_lock_irqsave+0x9/0xd
 [<c05a0ded>] ? mix_pool_bytes_extract+0x4d/0x135
 [<c069f84b>] ? vmalloc_fault+0xc3/0xc3
 [<c069db3a>] ? error_code+0x5a/0x60
 [<c05a00d8>] ? pci_ite887x_init+0x206/0x206
 [<c069f84b>] ? vmalloc_fault+0xc3/0xc3
 [<c051c9a4>] ? elv_completed_request+0x31/0x3e
 [<c051f624>] ? __blk_put_request+0x22/0x99
 [<c051fa63>] ? blk_end_bidi_request+0x34/0x4a
 [<c051fa80>] ? blk_end_request+0x7/0xc
 [<c051fab0>] ? blk_end_request_err+0x2b/0x31
 [<f83c3819>] ? scsi_io_completion+0x3a7/0x402 [scsi_mod]
 [<c0524f5a>] ? blk_done_softirq+0x42/0x50
 [<c0433668>] ? __do_softirq+0xa5/0x143
 [<c04335c3>] ? local_bh_enable_ip+0x67/0x67
 <IRQ>  [<c0417743>] ? smp_apic_timer_interrupt+0x6b/0x75
 [<c069d91a>] ? apic_timer_interrupt+0x2a/0x30
 [<c042007b>] ? flush_tlb_mm+0x3d/0x5b
 [<c042fdd1>] ? vprintk+0x331/0x33d
 [<f83c432c>] ? scsi_request_fn+0x2fb/0x3bb [scsi_mod]
 [<c04528c2>] ? module_refcount+0x64/0x77
 [<f83c1e54>] ? scsi_block_when_processing_errors+0xc7/0xc7 [scsi_mod]
 [<c042fdf1>] ? printk+0x14/0x18
 [<f83c22bc>] ? scsi_error_handler+0x468/0x4e0 [scsi_mod]
 [<c042bd99>] ? complete+0x28/0x36
 [<f83c1e54>] ? scsi_block_when_processing_errors+0xc7/0xc7 [scsi_mod]
 [<c0443c46>] ? kthread+0x65/0x6a
 [<c0443be1>] ? kthread_stop+0x8d/0x8d
 [<c06a27f6>] ? kernel_thread_helper+0x6/0xd
