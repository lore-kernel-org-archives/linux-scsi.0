From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: mvsas errors in 2.6.36
Date: Sat, 4 Dec 2010 01:37:21 -0700
Message-ID: <201012040137.21689.thomas@fjellstrom.ca>
References: <201010290650.32892.thomas@fjellstrom.ca> <4CF95394.7010400@redhat.com> <201012041550372348573@usish.com>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tomasu.net ([64.85.170.234]:44592 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701Ab0LDIh0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Dec 2010 03:37:26 -0500
In-Reply-To: <201012041550372348573@usish.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jack_wang <jack_wang@usish.com>
Cc: David Milburn <dmilburn@redhat.com>, Andre Tomt <andre@tomt.net>, Linux Kernel List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On December 4, 2010, jack_wang wrote:
> Hi, I've done as you requested.
> here's all of the output from the first (and currently only) event:
[snip]
> Thanks.
> 
> [Jack] The error shows that there are two commands have no respounse utill the timer timeout, and scsi host enter error hander
> to quary and abort task but all failed so try to reset the device .
> 
> I look into mvs_abort_task in mv_sas.c,
> if (SATA_DEV == dev->dev_type) {
> struct mvs_slot_info *slot = task->lldd_task;
> struct task_status_struct *tstat;
> u32 slot_idx = (u32)(slot - mvi->slot_info);
> tstat = &task->task_status;
> mv_dprintk(KERN_DEBUG "mv_abort_task() mvi=%p task=%p "
>    "slot=%p slot_idx=x%x\n",
>    mvi, task, slot, slot_idx);
> tstat->stat = SAS_ABORTED_TASK;
> if (mvi_dev && mvi_dev->running_req)
> mvi_dev->running_req--;
> if (sas_protocol_ata(task->task_proto))
> mvs_free_reg_set(mvi, mvi_dev);
> mvs_slot_task_free(mvi, task, slot, slot_idx);
> return -1;
>  //// here the return -1 looks suspicuse , you can remove it to have a try
> 

I commented out that return, and am waiting for another event.. But this
time instead of rebooting, I just rmmod'ed the driver and modprobed it,
and got the following messages, some of which don't seem quite right
(to me at least):

[ 6741.390235] sd 0:0:0:0: [sdc] Synchronizing SCSI cache
[ 6741.390474] sd 0:0:0:0: [sdc] Stopping disk
[ 6741.917971] drivers/scsi/mvsas/mv_sas.c 1388:found dev[0:5] is gone.
[ 6742.000262] sd 0:0:1:0: [sdd] Synchronizing SCSI cache
[ 6742.000474] sd 0:0:1:0: [sdd] Stopping disk
[ 6742.525251] drivers/scsi/mvsas/mv_sas.c 1388:found dev[1:5] is gone.
[ 6742.560242] sd 0:0:2:0: [sde] Synchronizing SCSI cache
[ 6742.560534] sd 0:0:2:0: [sde] Stopping disk
[ 6743.088472] drivers/scsi/mvsas/mv_sas.c 1388:found dev[2:5] is gone.
[ 6743.200184] sd 0:0:3:0: [sdf] Synchronizing SCSI cache
[ 6743.200531] sd 0:0:3:0: [sdf] Stopping disk
[ 6743.713619] drivers/scsi/mvsas/mv_sas.c 1388:found dev[3:5] is gone.
[ 6743.750267] sd 0:0:4:0: [sdg] Synchronizing SCSI cache
[ 6743.750842] sd 0:0:4:0: [sdg] Stopping disk
[ 6744.272381] drivers/scsi/mvsas/mv_sas.c 1388:found dev[4:5] is gone.
[ 6744.310257] sd 0:0:5:0: [sdh] Synchronizing SCSI cache
[ 6744.311120] sd 0:0:5:0: [sdh] Stopping disk
[ 6744.827928] drivers/scsi/mvsas/mv_sas.c 1388:found dev[5:5] is gone.
[ 6744.829125] mvsas 0000:04:00.0: PCI INT A disabled
[ 6764.553594] mvsas 0000:04:00.0: mvsas: driver version 0.8.2
[ 6764.553621] mvsas 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[ 6764.553633] mvsas 0000:04:00.0: setting latency timer to 64
[ 6764.557330] mvsas 0000:04:00.0: mvsas: PCI-E x4, Bandwidth Usage: 2.5 Gbps
[ 6769.020123] drivers/scsi/mvsas/mv_sas.c 1224:port 0 attach dev info is 20004
[ 6769.020131] drivers/scsi/mvsas/mv_sas.c 1226:port 0 attach sas addr is 0
[ 6769.230098] drivers/scsi/mvsas/mv_sas.c 1224:port 1 attach dev info is 0
[ 6769.230107] drivers/scsi/mvsas/mv_sas.c 1226:port 1 attach sas addr is 1
[ 6769.440189] drivers/scsi/mvsas/mv_sas.c 1224:port 2 attach dev info is 2000200
[ 6769.440197] drivers/scsi/mvsas/mv_sas.c 1226:port 2 attach sas addr is 2
[ 6769.650098] drivers/scsi/mvsas/mv_sas.c 1224:port 3 attach dev info is 2000000
[ 6769.650106] drivers/scsi/mvsas/mv_sas.c 1226:port 3 attach sas addr is 3
[ 6769.760044] drivers/scsi/mvsas/mv_sas.c 1224:port 4 attach dev info is 0
[ 6769.760053] drivers/scsi/mvsas/mv_sas.c 1226:port 4 attach sas addr is 0
[ 6769.870131] drivers/scsi/mvsas/mv_sas.c 1224:port 5 attach dev info is 0
[ 6769.870140] drivers/scsi/mvsas/mv_sas.c 1226:port 5 attach sas addr is 0
[ 6770.080099] drivers/scsi/mvsas/mv_sas.c 1224:port 6 attach dev info is 2000000
[ 6770.080108] drivers/scsi/mvsas/mv_sas.c 1226:port 6 attach sas addr is 6
[ 6770.290091] drivers/scsi/mvsas/mv_sas.c 1224:port 7 attach dev info is 5000002
[ 6770.290100] drivers/scsi/mvsas/mv_sas.c 1226:port 7 attach sas addr is 7
[ 6770.290111] scsi9 : mvsas
[ 6770.291608] drivers/scsi/mvsas/mv_sas.c 378:phy 0 byte dmaded.
[ 6770.291618] drivers/scsi/mvsas/mv_sas.c 378:phy 1 byte dmaded.
[ 6770.291626] drivers/scsi/mvsas/mv_sas.c 378:phy 2 byte dmaded.
[ 6770.291632] drivers/scsi/mvsas/mv_sas.c 378:phy 3 byte dmaded.
[ 6770.291639] drivers/scsi/mvsas/mv_sas.c 378:phy 6 byte dmaded.
[ 6770.291646] drivers/scsi/mvsas/mv_sas.c 378:phy 7 byte dmaded.
[ 6770.291749] sas: phy-9:0 added to port-9:0, phy_mask:0x1 (               0)
[ 6770.291869] sas: phy-9:1 added to port-9:1, phy_mask:0x2 ( 100000000000000)
[ 6770.291949] sas: phy-9:2 added to port-9:2, phy_mask:0x4 ( 200000000000000)
[ 6770.292010] sas: phy-9:3 added to port-9:3, phy_mask:0x8 ( 300000000000000)
[ 6770.292073] sas: phy-9:6 added to port-9:4, phy_mask:0x40 ( 600000000000000)
[ 6770.292135] sas: phy-9:7 added to port-9:5, phy_mask:0x80 ( 700000000000000)
[ 6770.292154] sas: DOING DISCOVERY on port 0, pid:7283
[ 6770.293877] drivers/scsi/mvsas/mv_sas.c 1388:found dev[0:5] is gone.
[ 6770.294212] sas: sas_ata_phy_reset: Found ATA device.
[ 6770.321998] ata15.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[ 6770.322008] ata15.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[ 6775.320090] ata15.00: qc timeout (cmd 0xef)
[ 6775.320103] drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task() mvi=ffff880224040000 task=ffff880224cf8dc0 slot=ffff880224066520 slot_idx=x0
[ 6775.320116] drivers/scsi/mvsas/mv_sas.c 1718:mvs_abort_task:rc= 5
[ 6775.320125] ata15.00: failed to set xfermode (err_mask=0x4)
[ 6775.320925] drivers/scsi/mvsas/mv_sas.c 2083:port 0 ctrl sts=0x89800.
[ 6775.320931] drivers/scsi/mvsas/mv_sas.c 2085:Port 0 irq sts = 0x1001001
[ 6775.320942] drivers/scsi/mvsas/mv_sas.c 2111:phy0 Unplug Notice
[ 6775.331012] drivers/scsi/mvsas/mv_sas.c 2083:port 0 ctrl sts=0x199800.
[ 6775.331019] drivers/scsi/mvsas/mv_sas.c 2085:Port 0 irq sts = 0x1001081
[ 6776.068899] drivers/scsi/mvsas/mv_sas.c 2083:port 0 ctrl sts=0x199800.
[ 6776.068908] drivers/scsi/mvsas/mv_sas.c 2085:Port 0 irq sts = 0x10000
[ 6776.068916] drivers/scsi/mvsas/mv_sas.c 2138:notify plug in on phy[0]
[ 6776.078883] drivers/scsi/mvsas/mv_sas.c 1224:port 0 attach dev info is 20004
[ 6776.078883] drivers/scsi/mvsas/mv_sas.c 1226:port 0 attach sas addr is 0
[ 6776.078883] drivers/scsi/mvsas/mv_sas.c 378:phy 0 byte dmaded.
[ 6777.540093] drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[0]:rc= 0
[ 6777.540105] sas: sas_ata_phy_reset: Found ATA device.
[ 6777.540164] sas: sas_to_ata_err: Saw error 2.  What to do?
[ 6777.540172] sas: sas_ata_task_done: SAS error 2
[ 6777.540248] ata15.00: failed to IDENTIFY (I/O error, err_mask=0x100)
[ 6777.540254] sas: STUB sas_ata_scr_read
[ 6777.540260] ata15: limiting SATA link speed to 1.5 Gbps
[ 6777.540266] ata15.00: limiting speed to UDMA/133:PIO3
[ 6777.540293] drivers/scsi/mvsas/mv_sas.c 2083:port 0 ctrl sts=0x89800.
[ 6777.540299] drivers/scsi/mvsas/mv_sas.c 2085:Port 0 irq sts = 0x1001
[ 6777.540310] drivers/scsi/mvsas/mv_sas.c 2111:phy0 Unplug Notice
[ 6777.550384] drivers/scsi/mvsas/mv_sas.c 2083:port 0 ctrl sts=0x199800.
[ 6777.550390] drivers/scsi/mvsas/mv_sas.c 2085:Port 0 irq sts = 0x1081
[ 6777.571696] drivers/scsi/mvsas/mv_sas.c 2083:port 0 ctrl sts=0x199800.
[ 6777.571704] drivers/scsi/mvsas/mv_sas.c 2085:Port 0 irq sts = 0x10000
[ 6777.571712] drivers/scsi/mvsas/mv_sas.c 2138:notify plug in on phy[0]
[ 6777.581683] drivers/scsi/mvsas/mv_sas.c 1224:port 0 attach dev info is 20004
[ 6777.581683] drivers/scsi/mvsas/mv_sas.c 1226:port 0 attach sas addr is 0
[ 6777.581683] drivers/scsi/mvsas/mv_sas.c 378:phy 0 byte dmaded.
[ 6779.760042] drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[0]:rc= 0
[ 6779.760054] sas: sas_ata_phy_reset: Found ATA device.
[ 6779.787123] ata15.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[ 6779.787133] ata15.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[ 6779.826838] ata15.00: configured for UDMA/133
[ 6779.827081] scsi 9:0:0:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
[ 6779.827164] sas: DONE DISCOVERY on port 0, pid:7283, result:0
[ 6779.827188] sas: DOING DISCOVERY on port 1, pid:7283
[ 6779.828926] drivers/scsi/mvsas/mv_sas.c 1388:found dev[1:5] is gone.
[ 6779.829306] sas: sas_ata_phy_reset: Found ATA device.
[ 6779.856997] ata16.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[ 6779.857007] ata16.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[ 6784.860080] ata16.00: qc timeout (cmd 0xec)
[ 6784.860093] drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task() mvi=ffff880224040000 task=ffff88022dd92c40 slot=ffff880224066520 slot_idx=x0
[ 6784.860106] drivers/scsi/mvsas/mv_sas.c 1718:mvs_abort_task:rc= 5
[ 6784.860115] ata16.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[ 6784.860122] ata16.00: revalidation failed (errno=-5)
[ 6784.860923] drivers/scsi/mvsas/mv_sas.c 2083:port 1 ctrl sts=0x89800.
[ 6784.860930] drivers/scsi/mvsas/mv_sas.c 2085:Port 1 irq sts = 0x1001001
[ 6784.860941] drivers/scsi/mvsas/mv_sas.c 2111:phy1 Unplug Notice
[ 6784.871016] drivers/scsi/mvsas/mv_sas.c 2083:port 1 ctrl sts=0x199800.
[ 6784.871022] drivers/scsi/mvsas/mv_sas.c 2085:Port 1 irq sts = 0x1001081
[ 6785.740356] drivers/scsi/mvsas/mv_sas.c 2083:port 1 ctrl sts=0x199800.
[ 6785.740365] drivers/scsi/mvsas/mv_sas.c 2085:Port 1 irq sts = 0x10000
[ 6785.740373] drivers/scsi/mvsas/mv_sas.c 2138:notify plug in on phy[1]
[ 6785.785279] drivers/scsi/mvsas/mv_sas.c 1224:port 1 attach dev info is 0
[ 6785.785279] drivers/scsi/mvsas/mv_sas.c 1226:port 1 attach sas addr is 1
[ 6785.850460] drivers/scsi/mvsas/mv_sas.c 378:phy 1 byte dmaded.
[ 6787.080025] drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[1]:rc= 0
[ 6787.080031] sas: sas_ata_phy_reset: Found ATA device.
[ 6787.080080] sas: sas_to_ata_err: Saw error 2.  What to do?
[ 6787.080088] sas: sas_ata_task_done: SAS error 2
[ 6787.080165] ata16.00: failed to IDENTIFY (I/O error, err_mask=0x100)
[ 6787.080171] sas: STUB sas_ata_scr_read
[ 6787.080176] ata16: limiting SATA link speed to 1.5 Gbps
[ 6787.080183] ata16.00: limiting speed to UDMA/133:PIO3
[ 6787.080213] drivers/scsi/mvsas/mv_sas.c 2083:port 1 ctrl sts=0x89800.
[ 6787.080219] drivers/scsi/mvsas/mv_sas.c 2085:Port 1 irq sts = 0x1001
[ 6787.080230] drivers/scsi/mvsas/mv_sas.c 2111:phy1 Unplug Notice
[ 6787.090298] drivers/scsi/mvsas/mv_sas.c 2083:port 1 ctrl sts=0x199800.
[ 6787.090304] drivers/scsi/mvsas/mv_sas.c 2085:Port 1 irq sts = 0x1081
[ 6787.111165] drivers/scsi/mvsas/mv_sas.c 2083:port 1 ctrl sts=0x199800.
[ 6787.111173] drivers/scsi/mvsas/mv_sas.c 2085:Port 1 irq sts = 0x10000
[ 6787.111181] drivers/scsi/mvsas/mv_sas.c 2138:notify plug in on phy[1]
[ 6787.153464] drivers/scsi/mvsas/mv_sas.c 1224:port 1 attach dev info is 0
[ 6787.153464] drivers/scsi/mvsas/mv_sas.c 1226:port 1 attach sas addr is 1
[ 6787.153464] drivers/scsi/mvsas/mv_sas.c 378:phy 1 byte dmaded.
[ 6789.300083] drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[1]:rc= 0
[ 6789.300095] sas: sas_ata_phy_reset: Found ATA device.
[ 6789.327213] ata16.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[ 6789.327223] ata16.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[ 6789.366778] ata16.00: configured for UDMA/133
[ 6789.367007] scsi 9:0:1:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
[ 6789.367134] sas: DONE DISCOVERY on port 1, pid:7283, result:0
[ 6789.367172] sas: DOING DISCOVERY on port 2, pid:7283
[ 6789.368918] drivers/scsi/mvsas/mv_sas.c 1388:found dev[2:5] is gone.
[ 6789.369288] sas: sas_ata_phy_reset: Found ATA device.
[ 6789.397016] ata17.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[ 6789.397026] ata17.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[ 6794.390105] ata17.00: qc timeout (cmd 0xef)
[ 6794.390121] drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task() mvi=ffff880224040000 task=ffff880224130cc0 slot=ffff880224066520 slot_idx=x0
[ 6794.390134] drivers/scsi/mvsas/mv_sas.c 1718:mvs_abort_task:rc= 5
[ 6794.390143] ata17.00: failed to set xfermode (err_mask=0x4)
[ 6794.390952] drivers/scsi/mvsas/mv_sas.c 2083:port 2 ctrl sts=0x89800.
[ 6794.390958] drivers/scsi/mvsas/mv_sas.c 2085:Port 2 irq sts = 0x1001
[ 6794.390969] drivers/scsi/mvsas/mv_sas.c 2111:phy2 Unplug Notice
[ 6794.401034] drivers/scsi/mvsas/mv_sas.c 2083:port 2 ctrl sts=0x199800.
[ 6794.401040] drivers/scsi/mvsas/mv_sas.c 2085:Port 2 irq sts = 0x1081
[ 6795.412489] drivers/scsi/mvsas/mv_sas.c 2083:port 2 ctrl sts=0x199800.
[ 6795.412498] drivers/scsi/mvsas/mv_sas.c 2085:Port 2 irq sts = 0x10000
[ 6795.412506] drivers/scsi/mvsas/mv_sas.c 2138:notify plug in on phy[2]
[ 6795.422471] drivers/scsi/mvsas/mv_sas.c 1224:port 2 attach dev info is 2000200
[ 6795.422471] drivers/scsi/mvsas/mv_sas.c 1226:port 2 attach sas addr is 2
[ 6795.521980] drivers/scsi/mvsas/mv_sas.c 378:phy 2 byte dmaded.
[ 6796.610091] drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[2]:rc= 0
[ 6796.610103] sas: sas_ata_phy_reset: Found ATA device.
[ 6796.610147] sas: sas_to_ata_err: Saw error 2.  What to do?
[ 6796.610153] sas: sas_ata_task_done: SAS error 2
[ 6796.610183] ata17.00: failed to IDENTIFY (I/O error, err_mask=0x100)
[ 6796.610192] sas: STUB sas_ata_scr_read
[ 6796.610198] ata17: limiting SATA link speed to 1.5 Gbps
[ 6796.610206] ata17.00: limiting speed to UDMA/133:PIO3
[ 6796.610233] drivers/scsi/mvsas/mv_sas.c 2083:port 2 ctrl sts=0x89800.
[ 6796.610240] drivers/scsi/mvsas/mv_sas.c 2085:Port 2 irq sts = 0x1001
[ 6796.610251] drivers/scsi/mvsas/mv_sas.c 2111:phy2 Unplug Notice
[ 6796.620285] drivers/scsi/mvsas/mv_sas.c 2083:port 2 ctrl sts=0x199800.
[ 6796.620295] drivers/scsi/mvsas/mv_sas.c 2085:Port 2 irq sts = 0x1081
[ 6796.642316] drivers/scsi/mvsas/mv_sas.c 2083:port 2 ctrl sts=0x199800.
[ 6796.642319] drivers/scsi/mvsas/mv_sas.c 2085:Port 2 irq sts = 0x10000
[ 6796.642322] drivers/scsi/mvsas/mv_sas.c 2138:notify plug in on phy[2]
[ 6796.743532] drivers/scsi/mvsas/mv_sas.c 1224:port 2 attach dev info is 2000200
[ 6796.743532] drivers/scsi/mvsas/mv_sas.c 1226:port 2 attach sas addr is 2
[ 6796.743532] drivers/scsi/mvsas/mv_sas.c 378:phy 2 byte dmaded.
[ 6798.830036] drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[2]:rc= 0
[ 6798.830050] sas: sas_ata_phy_reset: Found ATA device.
[ 6798.857151] ata17.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[ 6798.857161] ata17.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[ 6798.896658] ata17.00: configured for UDMA/133
[ 6798.896874] scsi 9:0:2:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
[ 6798.896937] sas: DONE DISCOVERY on port 2, pid:7283, result:0
[ 6798.896964] sas: DOING DISCOVERY on port 3, pid:7283
[ 6798.898669] drivers/scsi/mvsas/mv_sas.c 1388:found dev[3:5] is gone.
[ 6798.899043] sas: sas_ata_phy_reset: Found ATA device.
[ 6798.900882] ata18.00: ATA-8: ST31000523AS, CC35, max UDMA/133
[ 6798.900885] ata18.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[ 6803.900077] ata18.00: qc timeout (cmd 0xef)
[ 6803.900091] drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task() mvi=ffff880224040000 task=ffff880224130400 slot=ffff880224066520 slot_idx=x0
[ 6803.900103] drivers/scsi/mvsas/mv_sas.c 1718:mvs_abort_task:rc= 5
[ 6803.900113] ata18.00: failed to set xfermode (err_mask=0x4)
[ 6803.900942] drivers/scsi/mvsas/mv_sas.c 2083:port 3 ctrl sts=0x89800.
[ 6803.900949] drivers/scsi/mvsas/mv_sas.c 2085:Port 3 irq sts = 0x1001
[ 6803.900961] drivers/scsi/mvsas/mv_sas.c 2111:phy3 Unplug Notice
[ 6803.911030] drivers/scsi/mvsas/mv_sas.c 2083:port 3 ctrl sts=0x199800.
[ 6803.911035] drivers/scsi/mvsas/mv_sas.c 2085:Port 3 irq sts = 0x1081
[ 6804.517325] drivers/scsi/mvsas/mv_sas.c 2083:port 3 ctrl sts=0x199800.
[ 6804.517333] drivers/scsi/mvsas/mv_sas.c 2085:Port 3 irq sts = 0x10000
[ 6804.517341] drivers/scsi/mvsas/mv_sas.c 2138:notify plug in on phy[3]
[ 6804.528992] drivers/scsi/mvsas/mv_sas.c 1224:port 3 attach dev info is 2000000
[ 6804.528992] drivers/scsi/mvsas/mv_sas.c 1226:port 3 attach sas addr is 3
[ 6804.627313] drivers/scsi/mvsas/mv_sas.c 378:phy 3 byte dmaded.
[ 6806.120086] drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[3]:rc= 0
[ 6806.120103] sas: sas_ata_phy_reset: Found ATA device.
[ 6806.120147] sas: sas_to_ata_err: Saw error 2.  What to do?
[ 6806.120153] sas: sas_ata_task_done: SAS error 2
[ 6806.120244] ata18.00: failed to IDENTIFY (I/O error, err_mask=0x100)
[ 6806.120252] sas: STUB sas_ata_scr_read
[ 6806.120258] ata18: limiting SATA link speed to 1.5 Gbps
[ 6806.120266] ata18.00: limiting speed to UDMA/133:PIO3
[ 6806.120293] drivers/scsi/mvsas/mv_sas.c 2083:port 3 ctrl sts=0x89800.
[ 6806.120300] drivers/scsi/mvsas/mv_sas.c 2085:Port 3 irq sts = 0x1001
[ 6806.120311] drivers/scsi/mvsas/mv_sas.c 2111:phy3 Unplug Notice
[ 6806.130385] drivers/scsi/mvsas/mv_sas.c 2083:port 3 ctrl sts=0x199800.
[ 6806.130392] drivers/scsi/mvsas/mv_sas.c 2085:Port 3 irq sts = 0x1081
[ 6806.134101] drivers/scsi/mvsas/mv_sas.c 2083:port 3 ctrl sts=0x199800.
[ 6806.134103] drivers/scsi/mvsas/mv_sas.c 2085:Port 3 irq sts = 0x10000
[ 6806.134106] drivers/scsi/mvsas/mv_sas.c 2138:notify plug in on phy[3]
[ 6806.171284] drivers/scsi/mvsas/mv_sas.c 1224:port 3 attach dev info is 2000000
[ 6806.171284] drivers/scsi/mvsas/mv_sas.c 1226:port 3 attach sas addr is 3
[ 6806.171284] drivers/scsi/mvsas/mv_sas.c 378:phy 3 byte dmaded.
[ 6808.340071] drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[3]:rc= 0
[ 6808.340084] sas: sas_ata_phy_reset: Found ATA device.
[ 6808.341287] ata18.00: ATA-8: ST31000523AS, CC35, max UDMA/133
[ 6808.341297] ata18.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[ 6808.342630] ata18.00: configured for UDMA/133
[ 6808.342854] scsi 9:0:3:0: Direct-Access     ATA      ST31000523AS     CC35 PQ: 0 ANSI: 5
[ 6808.342940] sas: DONE DISCOVERY on port 3, pid:7283, result:0
[ 6808.342968] sas: DOING DISCOVERY on port 4, pid:7283
[ 6808.344645] drivers/scsi/mvsas/mv_sas.c 1388:found dev[4:5] is gone.
[ 6808.345028] sas: sas_ata_phy_reset: Found ATA device.
[ 6808.372766] ata19.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[ 6808.372775] ata19.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[ 6813.370091] ata19.00: qc timeout (cmd 0xef)
[ 6813.370109] drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task() mvi=ffff880224040000 task=ffff8802241305c0 slot=ffff880224066520 slot_idx=x0
[ 6813.370121] drivers/scsi/mvsas/mv_sas.c 1718:mvs_abort_task:rc= 5
[ 6813.370130] ata19.00: failed to set xfermode (err_mask=0x4)
[ 6813.370911] drivers/scsi/mvsas/mv_sas.c 2083:port 6 ctrl sts=0x89800.
[ 6813.370917] drivers/scsi/mvsas/mv_sas.c 2085:Port 6 irq sts = 0x1001
[ 6813.370932] drivers/scsi/mvsas/mv_sas.c 2111:phy6 Unplug Notice
[ 6813.381007] drivers/scsi/mvsas/mv_sas.c 2083:port 6 ctrl sts=0x199800.
[ 6813.381014] drivers/scsi/mvsas/mv_sas.c 2085:Port 6 irq sts = 0x1081
[ 6814.132874] drivers/scsi/mvsas/mv_sas.c 2083:port 6 ctrl sts=0x199800.
[ 6814.132883] drivers/scsi/mvsas/mv_sas.c 2085:Port 6 irq sts = 0x10000
[ 6814.132891] drivers/scsi/mvsas/mv_sas.c 2138:notify plug in on phy[6]
[ 6814.200424] drivers/scsi/mvsas/mv_sas.c 1224:port 6 attach dev info is 2000000
[ 6814.200424] drivers/scsi/mvsas/mv_sas.c 1226:port 6 attach sas addr is 6
[ 6814.242707] drivers/scsi/mvsas/mv_sas.c 378:phy 6 byte dmaded.
[ 6815.590038] drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[4]:rc= 0
[ 6815.590050] sas: sas_ata_phy_reset: Found ATA device.
[ 6815.590095] sas: sas_to_ata_err: Saw error 2.  What to do?
[ 6815.590101] sas: sas_ata_task_done: SAS error 2
[ 6815.590118] ata19.00: failed to IDENTIFY (I/O error, err_mask=0x100)
[ 6815.590124] sas: STUB sas_ata_scr_read
[ 6815.590130] ata19: limiting SATA link speed to 1.5 Gbps
[ 6815.590138] ata19.00: limiting speed to UDMA/133:PIO3
[ 6815.590161] drivers/scsi/mvsas/mv_sas.c 2083:port 6 ctrl sts=0x89800.
[ 6815.590167] drivers/scsi/mvsas/mv_sas.c 2085:Port 6 irq sts = 0x1001
[ 6815.590178] drivers/scsi/mvsas/mv_sas.c 2111:phy6 Unplug Notice
[ 6815.600244] drivers/scsi/mvsas/mv_sas.c 2083:port 6 ctrl sts=0x199800.
[ 6815.600251] drivers/scsi/mvsas/mv_sas.c 2085:Port 6 irq sts = 0x1081
[ 6815.621709] drivers/scsi/mvsas/mv_sas.c 2083:port 6 ctrl sts=0x199800.
[ 6815.621712] drivers/scsi/mvsas/mv_sas.c 2085:Port 6 irq sts = 0x10000
[ 6815.621715] drivers/scsi/mvsas/mv_sas.c 2138:notify plug in on phy[6]
[ 6815.631701] drivers/scsi/mvsas/mv_sas.c 1224:port 6 attach dev info is 2000000
[ 6815.631701] drivers/scsi/mvsas/mv_sas.c 1226:port 6 attach sas addr is 6
[ 6815.631701] drivers/scsi/mvsas/mv_sas.c 378:phy 6 byte dmaded.
[ 6817.810034] drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[4]:rc= 0
[ 6817.810047] sas: sas_ata_phy_reset: Found ATA device.
[ 6817.837142] ata19.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[ 6817.837151] ata19.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[ 6817.876702] ata19.00: configured for UDMA/133
[ 6817.876963] scsi 9:0:4:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
[ 6817.877066] sas: DONE DISCOVERY on port 4, pid:7283, result:0
[ 6817.877093] sas: DOING DISCOVERY on port 5, pid:7283
[ 6817.878838] drivers/scsi/mvsas/mv_sas.c 1388:found dev[5:5] is gone.
[ 6817.879216] sas: sas_ata_phy_reset: Found ATA device.
[ 6817.906941] ata20.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[ 6817.906950] ata20.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[ 6822.900108] ata20.00: qc timeout (cmd 0xef)
[ 6822.900120] drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task() mvi=ffff880224040000 task=ffff88022ae51d00 slot=ffff880224066520 slot_idx=x0
[ 6822.900133] drivers/scsi/mvsas/mv_sas.c 1718:mvs_abort_task:rc= 5
[ 6822.900142] ata20.00: failed to set xfermode (err_mask=0x4)
[ 6822.900956] drivers/scsi/mvsas/mv_sas.c 2083:port 7 ctrl sts=0x89800.
[ 6822.900963] drivers/scsi/mvsas/mv_sas.c 2085:Port 7 irq sts = 0x1001
[ 6822.900974] drivers/scsi/mvsas/mv_sas.c 2111:phy7 Unplug Notice
[ 6822.911042] drivers/scsi/mvsas/mv_sas.c 2083:port 7 ctrl sts=0x199800.
[ 6822.911048] drivers/scsi/mvsas/mv_sas.c 2085:Port 7 irq sts = 0x1081
[ 6823.803507] drivers/scsi/mvsas/mv_sas.c 2083:port 7 ctrl sts=0x199800.
[ 6823.803516] drivers/scsi/mvsas/mv_sas.c 2085:Port 7 irq sts = 0x10000
[ 6823.803524] drivers/scsi/mvsas/mv_sas.c 2138:notify plug in on phy[7]
[ 6823.895054] drivers/scsi/mvsas/mv_sas.c 1224:port 7 attach dev info is 5000002
[ 6823.895054] drivers/scsi/mvsas/mv_sas.c 1226:port 7 attach sas addr is 7
[ 6823.913276] drivers/scsi/mvsas/mv_sas.c 378:phy 7 byte dmaded.
[ 6825.120085] drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[5]:rc= 0
[ 6825.120097] sas: sas_ata_phy_reset: Found ATA device.
[ 6825.120140] sas: sas_to_ata_err: Saw error 2.  What to do?
[ 6825.120146] sas: sas_ata_task_done: SAS error 2
[ 6825.120176] ata20.00: failed to IDENTIFY (I/O error, err_mask=0x100)
[ 6825.120184] sas: STUB sas_ata_scr_read
[ 6825.120190] ata20: limiting SATA link speed to 1.5 Gbps
[ 6825.120198] ata20.00: limiting speed to UDMA/133:PIO3
[ 6825.120224] drivers/scsi/mvsas/mv_sas.c 2083:port 7 ctrl sts=0x89800.
[ 6825.120231] drivers/scsi/mvsas/mv_sas.c 2085:Port 7 irq sts = 0x1001
[ 6825.120242] drivers/scsi/mvsas/mv_sas.c 2111:phy7 Unplug Notice
[ 6825.130285] drivers/scsi/mvsas/mv_sas.c 2083:port 7 ctrl sts=0x199800.
[ 6825.130296] drivers/scsi/mvsas/mv_sas.c 2085:Port 7 irq sts = 0x1081
[ 6825.151317] drivers/scsi/mvsas/mv_sas.c 2083:port 7 ctrl sts=0x199800.
[ 6825.151325] drivers/scsi/mvsas/mv_sas.c 2085:Port 7 irq sts = 0x10000
[ 6825.151333] drivers/scsi/mvsas/mv_sas.c 2138:notify plug in on phy[7]
[ 6825.232377] drivers/scsi/mvsas/mv_sas.c 1224:port 7 attach dev info is 5000002
[ 6825.232377] drivers/scsi/mvsas/mv_sas.c 1226:port 7 attach sas addr is 7
[ 6825.232377] drivers/scsi/mvsas/mv_sas.c 378:phy 7 byte dmaded.
[ 6827.340101] drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[5]:rc= 0
[ 6827.340112] sas: sas_ata_phy_reset: Found ATA device.
[ 6827.367259] ata20.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[ 6827.367268] ata20.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[ 6827.406888] ata20.00: configured for UDMA/133
[ 6827.407105] scsi 9:0:5:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
[ 6827.407229] sas: DONE DISCOVERY on port 5, pid:7283, result:0
[ 6827.407244] sas: sas_form_port: phy0 belongs to port0 already(1)!
[ 6827.407252] sas: sas_form_port: phy1 belongs to port1 already(1)!
[ 6827.407259] sas: sas_form_port: phy2 belongs to port2 already(1)!
[ 6827.407266] sas: sas_form_port: phy3 belongs to port3 already(1)!
[ 6827.407272] sas: sas_form_port: phy6 belongs to port4 already(1)!
[ 6827.407279] sas: sas_form_port: phy7 belongs to port5 already(1)!
[ 6827.407688] sd 9:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[ 6827.408241] sd 9:0:0:0: [sdc] Write Protect is off
[ 6827.408251] sd 9:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[ 6827.408341] sd 9:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 6827.408403] sd 9:0:2:0: [sde] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[ 6827.408429] sd 9:0:1:0: [sdd] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[ 6827.408577] sd 9:0:1:0: [sdd] Write Protect is off
[ 6827.408585] sd 9:0:1:0: [sdd] Mode Sense: 00 3a 00 00
[ 6827.408594] sd 9:0:2:0: [sde] Write Protect is off
[ 6827.408602] sd 9:0:2:0: [sde] Mode Sense: 00 3a 00 00
[ 6827.408640] sd 9:0:1:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 6827.408664] sd 9:0:2:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 6827.408946] sd 9:0:3:0: [sdf] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[ 6827.409203] sd 9:0:3:0: [sdf] Write Protect is off
[ 6827.409211] sd 9:0:3:0: [sdf] Mode Sense: 00 3a 00 00
[ 6827.409257] sd 9:0:3:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 6827.409520] sd 9:0:4:0: [sdg] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[ 6827.409653] sd 9:0:5:0: [sdh] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[ 6827.409689] sd 9:0:4:0: [sdg] Write Protect is off
[ 6827.409696] sd 9:0:4:0: [sdg] Mode Sense: 00 3a 00 00
[ 6827.409761] sd 9:0:4:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 6827.409786] sd 9:0:5:0: [sdh] Write Protect is off
[ 6827.409794] sd 9:0:5:0: [sdh] Mode Sense: 00 3a 00 00
[ 6827.409893] sd 9:0:5:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 6827.423376]  sdc: unknown partition table
[ 6827.423617] sd 9:0:0:0: [sdc] Attached SCSI disk
[ 6827.427047]  sdf: unknown partition table
[ 6827.427091]  sdg: unknown partition table
[ 6827.427193] sd 9:0:3:0: [sdf] Attached SCSI disk
[ 6827.427253] sd 9:0:4:0: [sdg] Attached SCSI disk
[ 6827.427723]  sde: unknown partition table
[ 6827.427859]  sdd: unknown partition table
[ 6827.427917] sd 9:0:2:0: [sde] Attached SCSI disk
[ 6827.428016] sd 9:0:1:0: [sdd] Attached SCSI disk
[ 6827.429659]  sdh: unknown partition table
[ 6827.429792] sd 9:0:5:0: [sdh] Attached SCSI disk

When I see another event, I'll paste it, and then reboot, and see if it
happens the same after a fresh reboot (as this test isn't quite
equivalent to the last test).

Now given I know next to nothing about SAS and SATA controllers,
this is probably a bit presumptuous of me, but I've been thinking about
this for a while. Assuming for a moment that it isn't a hardware problem
(that is, my card, drives, motherboard or cables are not contributing),
then somehow the driver is not handling something entirely correctly.
At some point the card is getting a command it does not like, or can't
handle properly when connected to SATA disks. Possibly its passing
through a SAS or SCSI command to SATA disks that don't know how to handle
it, and decide to completely ignore the command.

That of course it just my best (likely incorrect) guess as to what could
be happening. Please correct me if I'm off base.

At any rate those messages from rmmoding the old driver, and modprobing
the new one are strange. Its finding the drive on each port just fine,
but then immediately fails the xfrmode command, and decides to reprobe
the port, and for some reason decides to connect in 1.5Gbps mode rather
than the native 3Gbps.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
