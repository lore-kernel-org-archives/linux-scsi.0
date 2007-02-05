From: Mark Rustad <mrustad@gmail.com>
Subject: aic79xx noise on hot insert in 2.6.19.x and 2.6.20
Date: Mon, 5 Feb 2007 17:17:32 -0600
Message-ID: <C33207EA-8376-4A2F-828C-23B00327C42D@gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.235]:3829 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933437AbXBEXRe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Feb 2007 18:17:34 -0500
Received: by wr-out-0506.google.com with SMTP id 68so1354667wri
        for <linux-scsi@vger.kernel.org>; Mon, 05 Feb 2007 15:17:33 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

I have systems with Supermicro X6-class (Nocona/Lindenhurst)  
motherboards with Adaptec SCSI and SAFTE backplanes running software  
RAID-1 (md) on a pair of drives. When I hot-insert a drive, I get a  
lot of noise from the kernel apparently due to lack of handling  
something in the interrupt routine. So far, life seems to go on after  
the event, but not knowing anything about the internals of the  
driver, I am concerned enough to want to ask about it.

The kernel messages are below, with my added comments starting with  
-----:

----- vvvvv Here is where I pop a drive out to induce an error
sd 0:0:5:0: SCSI error: return code = 0x00010000
end_request: I/O error, dev sdb, sector 10538504
md: super_written gets error=-5, uptodate=0
raid1: Disk failure on sdb3, disabling device.
	Operation continuing on 1 devices
RAID1 conf printout:
--- wd:1 rd:6
disk 0, wo:0, o:1, dev:sda3
disk 1, wo:1, o:0, dev:sdb3
RAID1 conf printout:
--- wd:1 rd:6
disk 0, wo:0, o:1, dev:sda3
sd 0:0:5:0: SCSI error: return code = 0x00010000
end_request: I/O error, dev sdb, sector 0
Buffer I/O error on device sdb, logical block 0
Buffer I/O error on device sdb, logical block 1
Buffer I/O error on device sdb, logical block 2
Buffer I/O error on device sdb, logical block 3
Buffer I/O error on device sdb, logical block 4
Buffer I/O error on device sdb, logical block 5
Buffer I/O error on device sdb, logical block 6
Buffer I/O error on device sdb, logical block 7
Buffer I/O error on device sdb, logical block 8
Buffer I/O error on device sdb, logical block 9
sd 0:0:5:0: SCSI error: return code = 0x00010000
end_request: I/O error, dev sdb, sector 0
raid1: Disk failure on sdb2, disabling device.
	Operation continuing on 1 devices
raid1: Disk failure on sdb5, disabling device.
	Operation continuing on 1 devices
RAID1 conf printout:
--- wd:1 rd:6
disk 0, wo:0, o:1, dev:sda2
disk 1, wo:1, o:0, dev:sdb2
raid1: Disk failure on sdb6, disabling device.
	Operation continuing on 1 devices
RAID1 conf printout:
--- wd:1 rd:6
disk 0, wo:0, o:1, dev:sda5
disk 1, wo:1, o:0, dev:sdb5
RAID1 conf printout:
--- wd:1 rd:6
disk 0, wo:0, o:1, dev:sda6
disk 1, wo:1, o:0, dev:sdb6
RAID1 conf printout:
--- wd:1 rd:6
disk 0, wo:0, o:1, dev:sda2
RAID1 conf printout:
--- wd:1 rd:6
disk 0, wo:0, o:1, dev:sda5
RAID1 conf printout:
--- wd:1 rd:6
disk 0, wo:0, o:1, dev:sda6

----- ^^^^^ a script causes all of the RAID components on the device to
----- be failed out of the RAID, as I expect and life goes on with one
----- drive

----- vvvvv I don't know if these 2 messages are a worry or not
Removing MK_MSG scb
Removing MK_MSG scb
sd 0:0:5:0: SCSI error: return code = 0x00010000
end_request: I/O error, dev sdb, sector 0
printk: 30 messages suppressed.
Buffer I/O error on device sdb, logical block 0
sd 0:0:5:0: SCSI error: return code = 0x00010000
end_request: I/O error, dev sdb, sector 0
sd 0:0:5:0: SCSI error: return code = 0x00010000
end_request: I/O error, dev sdb, sector 0
printk: 15 messages suppressed.
Buffer I/O error on device sdb, logical block 0
Removing MK_MSG scb

----- vvvvv Here is where I re-insert the drive

scsi0: Someone reset channel A

----- vvvvv This looks like a possible problem to me

scsi0: Missing case in ahd_handle_scsiint. status = 0

----- vvvvv Here is all of the noise I was referring to

 >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x0 Mode 0x33
Card was paused
INTSTAT[0x8]:(SCSIINT) SELOID[0x6] SELID[0x20]
HS_MAILBOX[0x0] INTCTL[0x80]:(SWTMINTMASK) SEQINTSTAT[0x0]
SAVED_MODE[0x11] DFFSTAT[0x33]:(CURRFIFO_NONE|FIFO0FREE|FIFO1FREE)
SCSISIGI[0x0]:(P_DATAOUT) SCSIPHASE[0x0] SCSIBUS[0x0]
LASTPHASE[0x1]:(P_DATAOUT|P_BUSFREE) SCSISEQ0[0x0]
SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI) SEQCTL0[0x0]
SEQINTCTL[0x0] SEQ_FLAGS[0x0] SEQ_FLAGS2[0x0] QFREEZE_COUNT[0x3]
KERNEL_QFREEZE_COUNT[0x3] MK_MESSAGE_SCB[0x1b]
MK_MESSAGE_SCSIID[0x57] SSTAT0[0x0] SSTAT1[0x0]
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x0] SIMODE1[0xa4]:(ENSCSIPERR| 
ENSCSIRST|ENSELTIMO)
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0]
LQOSTAT1[0x0] LQOSTAT2[0x0]

SCB Count = 36 CMDS_PENDING = 0 LASTSCB 0x1a CURRSCB 0x1a NEXTSCB 0xff80
qinstart = 41211 qinfifonext = 41212
QINFIFO: 0x1a
WAITING_TID_QUEUES:
Pending list:
26 FIFO_USE[0x0] SCB_CONTROL[0x48]:(STATUS_RCVD|DISCENB)
SCB_SCSIID[0x67]
Total 1
Kernel Free SCB list: 8 21 27 35 7 14 11 33 29 31 18 20 2 10 30 4 32  
5 9 17 0 23 12 34 25 6 19 15 16 3 28 22 24 13 1
Sequencer Complete DMA-inprog list:
Sequencer Complete list:
Sequencer DMA-Up and Complete list:
Sequencer On QFreeze and Complete list:


scsi0: FIFO0 Free, LONGJMP == 0x8059, SCB 0x8
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT| 
ENCFG4DATA|ENSAVEPTRS)
SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL)

scsi0: FIFO1 Free, LONGJMP == 0x80f7, SCB 0x1a
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT| 
ENCFG4DATA|ENSAVEPTRS)
SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL)
LQIN: 0x8 0x0 0x0 0x8 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0  
0x0 0x0 0x0 0x0
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x1
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0

SIMODE0[0xc]:(ENOVERRUN|ENIOERR)
CCSCBCTL[0x0]
scsi0: REG0 == 0xffff, SINDEX = 0x1e0, DINDEX = 0xe1
scsi0: SCBPTR == 0x1a, SCB_NEXT == 0xff80, SCB_NEXT2 == 0xffc3
CDB 3c 1 4 80 9 88
STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>

----- vvvvv Beyond here everything is as I expect. My scripts bring the
----- new device into the RAID and resync begins and eventually  
completes
----- successfully.

md: unbind<sdb2>
md: export_rdev(sdb2)
md: unbind<sdb3>
md: export_rdev(sdb3)
md: unbind<sdb5>
md: export_rdev(sdb5)
md: unbind<sdb6>
md: export_rdev(sdb6)
SCSI device sdb: 71132959 512-byte hdwr sectors (36420 MB)
sdb: Write Protect is off
sdb: Mode Sense: cb 00 00 08
SCSI device sdb: write cache: disabled, read cache: enabled, doesn't  
support DPO or FUA
sdb: unknown partition table
SCSI device sdb: 71132959 512-byte hdwr sectors (36420 MB)
sdb: Write Protect is off
sdb: Mode Sense: cb 00 00 08
SCSI device sdb: write cache: disabled, read cache: enabled, doesn't  
support DPO or FUA
sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 >
md: bind<sdb2>
RAID1 conf printout:
--- wd:1 rd:6
disk 0, wo:0, o:1, dev:sda2
disk 1, wo:1, o:1, dev:sdb2
md: recovery of RAID array md0
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.

Is there something here to worry about? I can live with the noise for  
now at least.

-- 
Mark Rustad, MRustad@gmail.com


