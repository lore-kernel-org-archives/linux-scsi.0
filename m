From: Willem Riede <wrlk@riede.org>
Subject: Interference between ide-scsi and aic7xxx in 2.5.73-bk6
Date: Sun, 29 Jun 2003 10:08:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030629140847.GP1147@linnie.riede.org>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_sQVcuJQ2XoggZz/9b5klKQ)"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.comcast.net ([24.153.64.116]:52451 "EHLO
	smtp-out.comcast.net") by vger.kernel.org with ESMTP
	id S265662AbTF2Nx1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2003 09:53:27 -0400
Received: from linnie.riede.org
 (pcp04239971pcs.eatntn01.nj.comcast.net [68.39.173.54])
 by mtaout01.icomcast.net
 (iPlanet Messaging Server 5.2 HotFix 1.16 (built May 14 2003))
 with ESMTP id <0HH800DR6XT0IV@mtaout01.icomcast.net> for
 linux-scsi@vger.kernel.org; Sun, 29 Jun 2003 10:05:25 -0400 (EDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--Boundary_(ID_sQVcuJQ2XoggZz/9b5klKQ)
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline

I am experimenting with 2.5.73-bk6. Specifically, I'm trying to improve the 
ide-scsi error handling, which has been an on-and-off battle for me for a 
while now as I try to get the OnStream DI-30 to work properly with 2.5.

That means patches to ide-scsi.c and ide-iops.c -- see attached.

Before I get into describing what happens, let me tell you about the
hardware I use for this testing.

It is a dual PIII at 600MHz, SuperMicro P6DBS motherboard, Intel 440BX
chipset, 512M memory and the following devices as reported during boot:

Loading aic7xxx module
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.35
        <Adaptec aic7895 Ultra SCSI adapter>
        aic7895C: Ultra Wide Channel A, SCSI Id=7, 32/253 SCBs

(scsi0:A:3): 10.000MB/s transfers (10.000MHz, offset 7)
(scsi0:A:6): 10.000MB/s transfers (10.000MHz, offset 8)
  Vendor: OnStream  Model: SC-30             Rev: 1.09
  Type:   Sequential-Access                  ANSI SCSI revision: 02
  Vendor: MATSHITA  Model: CD-R   CW-7502    Rev: 4.17
  Type:   CD-ROM                             ANSI SCSI revision: 02
scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.35
        <Adaptec aic7895 Ultra SCSI adapter>
        aic7895C: Ultra Wide Channel B, SCSI Id=7, 32/253 SCBs

(scsi1:A:0): 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
(scsi1:A:1): 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
  Vendor: IBM       Model: DNES-318350W      Rev: SA30
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi1:A:0:0: Tagged Queuing enabled.  Depth 16
SCSI device sda: 35843670 512-byte hdwr sectors (18352 MB)
sda: cache data unavailable
sda: assuming drive cache: write through
 sda: sda1 sda2 sda3 sda4
Attached scsi disk sda at scsi1, channel 0, id 0, lun 0
  Vendor: IBM       Model: DGHS09U           Rev: 0350
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi1:A:1:0: Tagged Queuing enabled.  Depth 16
SCSI device sdb: 17916240 512-byte hdwr sectors (9173 MB)
sdb: asking for cache data failed
sdb: assuming drive cache: write through
 sdb: sdb1 sdb2 sdb3
Attached scsi disk sdb at scsi1, channel 0, id 1, lun 0

hda: ATAPI 32X CD-ROM drive, 5644kB Cache, (U)DMA
Uniform CD-ROM driver Revision: 3.12
scsi2 : SCSI host adapter emulation for IDE ATAPI devices
  Vendor: OnStream  Model: ADR Series        Rev: 5.05
  Type:   Sequential-Access                  ANSI SCSI revision: 02
scsi3 : SCSI host adapter emulation for IDE ATAPI devices
  Vendor: OnStream  Model: DI-30             Rev: 1.07
  Type:   Sequential-Access                  ANSI SCSI revision: 02
scsi4 : SCSI host adapter emulation for IDE ATAPI devices
  Vendor: CONNER    Model: CTT8000-A         Rev: 2.08
  Type:   Sequential-Access                  ANSI SCSI revision: 02


During boot, well before any of my experiments kick in, I see - with
recent 2.5 kernels only - the following:

(scsi1:A:0:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:0:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:0:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:0:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:0:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:0:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:0:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:0:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:0:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:0:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:0:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:0:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:0:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:0:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:0:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:0:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:0:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:0:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:0:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:0:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x83 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (42 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x83 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (42 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x83 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (42 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x83 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (42 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x83 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (42 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (76 of 96 bytes). Treated as error

What would cause that? Is it safe to ignore?

Now, on to what happens when I exercise the DI-30. 

This is what a successful error recovery would look like (with scsi logging
at level 4):

Jun 29 08:34:03 fallguy kernel: Error handler scsi_eh_3 waking up
Jun 29 08:34:03 fallguy kernel: scsi_eh_prt_fail_stats: 3:0:0:0 cmds failed: 0, cancel: 1
Jun 29 08:34:03 fallguy kernel: Total of 1 commands on 1 devices require eh work
Jun 29 08:34:03 fallguy kernel: scsi_eh_3: aborting cmd:0xce3d96e0
Jun 29 08:34:03 fallguy kernel: ide-scsi: abort called on hdc for 35576
Jun 29 08:34:05 fallguy kernel: hdc: irq timeout: status=0xd8 { Busy }
Jun 29 08:34:05 fallguy kernel: ide-scsi: waiting in abort
Jun 29 08:34:05 fallguy kernel: hdc: ATAPI reset complete
Jun 29 08:34:05 fallguy kernel: hdc: irq timeout: status=0xd0 { Busy }
Jun 29 08:34:05 fallguy kernel: hdc: ATAPI reset complete
Jun 29 08:34:05 fallguy kernel: hdc: irq timeout: status=0xd0 { Busy }
Jun 29 08:34:05 fallguy kernel: ide-scsi: abort fail return
Jun 29 08:34:05 fallguy kernel: scsi_eh_3: aborting cmd failed:0xce3d96e0
Jun 29 08:34:05 fallguy kernel: scsi_eh_3: Sending BDR sdev: 0xdfaa36c0
Jun 29 08:34:05 fallguy kernel: ide-scsi: reset called on hdc for 35576
Jun 29 08:34:05 fallguy kernel: ide-scsi: drive->abort completed, now do_reset
Jun 29 08:34:05 fallguy kernel: hdc: ATAPI reset complete
Jun 29 08:34:05 fallguy kernel: ide-scsi: reset success return
Jun 29 08:34:05 fallguy kernel: scsi_eh_done scmd: ce3d96e0 result: 0
Jun 29 08:34:05 fallguy kernel: scsi_send_eh_cmnd: scmd: ce3d96e0, rtn:2002
Jun 29 08:34:05 fallguy kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Jun 29 08:34:05 fallguy kernel: scsi_eh_tur: scmd ce3d96e0 rtn 2002
Jun 29 08:34:05 fallguy kernel: scsi_eh_3: flush retry cmd: ce3d96e0
Jun 29 08:34:05 fallguy kernel: scsi_restart_operations: waking up host to restart
Jun 29 08:34:05 fallguy kernel: Error handler scsi_eh_3 sleeping

But often, things go haywire and aic7xxx gets all shook up (FYI, sda4 is /):

scsi_eh_3: aborting cmd:0xdbf09594
ide-scsi: abort called on hdc for 29285
ide-scsi: device did not become ready in abort
hdc: irq timeout: status=0xd8 { Busy }
scsi_eh_3: aborting cmd failed:0xdbf09594
scsi_eh_3: Sending BDR sdev: 0xd78952d4
ide-scsi: reset called on hdc for 29285
ide-scsi: atapi_abort called on hdc to do drive reset
ide-scsi: drive->abort completed, now do_reset
hdc: ATAPI reset complete
Error handler scsi_eh_1 waking up
scsi_eh_prt_fail_stats: 1:0:0:0 cmds failed: 0, cancel: 1
Total of 1 commands on 1 devices require eh work
scsi_eh_1: aborting cmd:0xdf9c5594
scsi1:0:0:0: Attempting to queue an ABORT message
CDB: 0x2a 0x0 0x1 0xb2 0x14 0x91 0x0 0x0 0x10 0x0
scsi1:0:0:0: Command already completed
aic7xxx_abort returns 0x2002
scsi_eh_times_out: scmd:df9c5594
scsi1:0:0:0: Attempting to queue an ABORT message
CDB: 0x0 0x0 0x0 0x0 0x0 0x0
scsi1:0:0:0: Command already completed
aic7xxx_abort returns 0x2002
scsi_send_eh_cmnd: scmd: df9c5594, rtn:2003
scsi_eh_tur: scmd df9c5594 rtn 2003
scsi_eh_1: Sending BDR sdev: 0xdf91b660
scsi1:0:0:0: Attempting to queue a TARGET RESET message
CDB: 0x2a 0x0 0x1 0xb2 0x14 0x91 0x0 0x0 0x10 0x0
scsi1:0:0:0: Command not found
aic7xxx_dev_reset returns 0x2002
scsi_eh_times_out: scmd:df9c5594
scsi1:0:0:0: Attempting to queue an ABORT message
CDB: 0x0 0x0 0x0 0x0 0x0 0x0
scsi1:0:0:0: Command already completed
aic7xxx_abort returns 0x2002
scsi_send_eh_cmnd: scmd: df9c5594, rtn:2003
scsi_eh_tur: scmd df9c5594 rtn 2003
scsi_eh_1: Sending BRST chan: 0
scsi_try_bus_reset: Snd Bus RST
scsi_eh_times_out: scmd:df9c5594
scsi1:0:0:0: Attempting to queue an ABORT message
CDB: 0x0 0x0 0x0 0x0 0x0 0x0
scsi1: At time of recovery, card was paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi1: Dumping Card State in Message-out phase, at SEQADDR 0x164
Card was paused
ACCUM = 0xa0, SINDEX = 0x61, DINDEX = 0xe4, ARG_2 = 0x1
HCNT = 0x0 SCBPTR = 0x2
SCSISIGI[0xb6]:(REQI|BSYI|ATNI|MSGI|CDI) ERROR[0x0]
SCSIBUSL[0xc0] LASTPHASE[0xa0]:(MSGI|CDI) SCSISEQ[0x12]:(ENAUTOATNP|ENRSELI)
SBLKCTL[0x2]:(SELWIDE) SCSIRATE[0x0] SEQCTL[0x10]:(FASTMODE)
SEQ_FLAGS[0x40]:(NO_CDB_SENT) SSTAT0[0x7]:(DMADONE|SPIORDY|SDONE)
SSTAT1[0x3]:(REQINIT|PHASECHG) SSTAT2[0x0] SSTAT3[0x0]
SIMODE0[0x0] SIMODE1[0xac]:(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO)
SXFRCTL0[0x88]:(SPIOEN|DFON) DFCNTRL[0x0] DFSTATUS[0x2d]:(FIFOEMP|DFTHRESH|HDONE|FIFOQWDEMP)
STACK: 0xd6 0x159 0xd6 0x159
SCB count = 20
Kernel NEXTQSCB = 11
Card NEXTQSCB = 11
QINFIFO entries:
Waiting Queue entries:
Disconnected Queue entries:
QOUTFIFO entries:
Sequencer Free SCB List: 11 1 12 4 14 13 3 5 7 15 10 6 0 8 9 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
Sequencer SCB Info:
  0 SCB_CONTROL[0xe8]:(ULTRAENB|TAG_ENB|DISCENB|TARGET_SCB)
SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff]
  1 SCB_CONTROL[0xe8]:(ULTRAENB|TAG_ENB|DISCENB|TARGET_SCB)
SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff]
  2 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) SCB_SCSIID[0x7] SCB_LUN[0x0]
SCB_TAG[0x5]
  3 SCB_CONTROL[0xe8]:(ULTRAENB|TAG_ENB|DISCENB|TARGET_SCB)
SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff]
  4 SCB_CONTROL[0xe8]:(ULTRAENB|TAG_ENB|DISCENB|TARGET_SCB)
SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff]
  5 SCB_CONTROL[0xe8]:(ULTRAENB|TAG_ENB|DISCENB|TARGET_SCB)
SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff]
  6 SCB_CONTROL[0xe8]:(ULTRAENB|TAG_ENB|DISCENB|TARGET_SCB)
SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff]
  7 SCB_CONTROL[0xe8]:(ULTRAENB|TAG_ENB|DISCENB|TARGET_SCB)
SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff]
  8 SCB_CONTROL[0xe8]:(ULTRAENB|TAG_ENB|DISCENB|TARGET_SCB)
SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff]
  9 SCB_CONTROL[0xe8]:(ULTRAENB|TAG_ENB|DISCENB|TARGET_SCB)
SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff]
 10 SCB_CONTROL[0xe8]:(ULTRAENB|TAG_ENB|DISCENB|TARGET_SCB)
SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff]
 11 SCB_CONTROL[0xe8]:(ULTRAENB|TAG_ENB|DISCENB|TARGET_SCB)
SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff]
 12 SCB_CONTROL[0xe8]:(ULTRAENB|TAG_ENB|DISCENB|TARGET_SCB)
SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff]
 13 SCB_CONTROL[0xe8]:(ULTRAENB|TAG_ENB|DISCENB|TARGET_SCB)
SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff]
 14 SCB_CONTROL[0xe8]:(ULTRAENB|TAG_ENB|DISCENB|TARGET_SCB)
SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff]
 15 SCB_CONTROL[0xe8]:(ULTRAENB|TAG_ENB|DISCENB|TARGET_SCB)
SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff]
 16 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
 17 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
 18 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
 19 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
 20 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
 21 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
 22 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
 23 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
 24 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
 25 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
 26 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
 27 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
 28 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
 29 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
 30 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
 31 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
SCB_LUN[0xff]:(LID) SCB_TAG[0xff]
Pending list:
  5 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) SCB_SCSIID[0x7] SCB_LUN[0x0]
Kernel Free SCB list: 10 13 12 1 15 7 3 4 14 0 6 2 19 8 9 18 17 16
DevQ(0:0:0): 0 waiting
DevQ(0:1:0): 0 waiting
                                                                                                                                
     
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi1:0:0:0: Device is active, asserting ATN
Recovery code sleeping
Recovery code awake
Timer Expired
aic7xxx_abort returns 0x2003
scsi_send_eh_cmnd: scmd: df9c5594, rtn:2003
scsi_eh_tur: scmd df9c5594 rtn 2003
scsi_eh_1: Sending HRST
scsi_try_host_reset: Snd Host RST
scsi_eh_1: HRST failed
scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 0 lun 0
scsi_eh_1: flush finish cmd: df9c5594
SCSI error : <1 0 0 0> return code = 0x6000000
end_request: I/O error, dev sda, sector 28447889
scsi_restart_operations: waking up host to restart
Error handler scsi_eh_1 sleeping
scsi1 (0:0): rejecting I/O to offline device
Aborting journal on device sda4.
journal commit I/O error
ext3_abort called.
EXT3-fs abort (device sda4): ext3_journal_start: Detected aborted journal
Remounting filesystem read-only
EXT3-fs error (device sda4) in start_transaction: Journal has aborted


How can my experiments cause this? Unless I touch scsi structures without proper
locking, but I don't see where :-( Or is this an independent problem?

I appreciate any insight anybody has to offer.

Thanks, Willem Riede.


--Boundary_(ID_sQVcuJQ2XoggZz/9b5klKQ)
Content-type: text/plain; charset=us-ascii; NAME=ide-iops.patch-2573bk6
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=ide-iops.patch-2573bk6

--- linux-2.5.73-bk6/drivers/ide/ide-iops.c	2003-06-28 09:06:21.000000000 -0400
+++ /home/wriede/develop/ide-iops.c	2003-06-22 22:26:49.000000000 -0400
@@ -1115,6 +1115,7 @@
 	}
 	/* done polling */
 	hwgroup->poll_timeout = 0;
+	hwgroup->busy--;
 	return ide_stopped;
 }
 
@@ -1134,6 +1135,7 @@
 		if (hwif->reset_poll(drive)) {
 			printk(KERN_ERR "%s: host reset_poll failure for %s.\n",
 				hwif->name, drive->name);
+			hwgroup->busy--;
 			return ide_stopped;
 		}
 	}
@@ -1179,6 +1181,7 @@
 		}
 	}
 	hwgroup->poll_timeout = 0;	/* done polling */
+	hwgroup->busy--;
 	return ide_stopped;
 }
 
@@ -1267,6 +1270,7 @@
 #if OK_TO_RESET_CONTROLLER
 	if (!IDE_CONTROL_REG) {
 		spin_unlock_irqrestore(&ide_lock, flags);
+		hwgroup->busy--;
 		return ide_stopped;
 	}
 
@@ -1315,6 +1319,7 @@
 
 ide_startstop_t ide_do_reset (ide_drive_t *drive)
 {
+	HWGROUP(drive)->busy++;
 	return do_reset1(drive, 0);
 }
 

--Boundary_(ID_sQVcuJQ2XoggZz/9b5klKQ)
Content-type: text/plain; charset=us-ascii; NAME=ide-scsi.patch-2573bk6
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=ide-scsi.patch-2573bk6

--- linux-2.5.73-bk6/drivers/scsi/ide-scsi.c	2003-06-28 09:29:16.000000000 -0400
+++ /home/wriede/develop/ide-scsi.c	2003-06-23 20:16:53.000000000 -0400
@@ -45,6 +45,7 @@
 #include <linux/hdreg.h>
 #include <linux/slab.h>
 #include <linux/ide.h>
+#include <linux/delay.h>
 
 #include <asm/io.h>
 #include <asm/bitops.h>
@@ -54,7 +55,7 @@
 #include "hosts.h"
 #include <scsi/sg.h>
 
-#define IDESCSI_DEBUG_LOG		0
+#define IDESCSI_DEBUG_LOG               0
 
 typedef struct idescsi_pc_s {
 	u8 c[12];				/* Actual packet bytes */
@@ -69,7 +70,7 @@
 	Scsi_Cmnd *scsi_cmd;			/* SCSI command */
 	void (*done)(Scsi_Cmnd *);		/* Scsi completion routine */
 	unsigned long flags;			/* Status/Action flags */
-	unsigned long timeout;			/* Command timeout */
+	unsigned long timeout;			/* Command timeout (in jiffies) */
 } idescsi_pc_t;
 
 /*
@@ -87,7 +88,7 @@
 #define IDESCSI_SG_TRANSFORM		1	/* /dev/sg transformation */
 
 /*
- *	Log flags
+ *	Log flags (defines bit position within idescsi_scsi_t::log)
  */
 #define IDESCSI_LOG_CMD			0	/* Log SCSI commands */
 
@@ -270,7 +271,7 @@
 	printk("]\n");
 }
 
-static int idescsi_check_condition(ide_drive_t *drive, struct request *failed_command)
+static int idescsi_check_condition(ide_drive_t *drive, idescsi_pc_t *failed_command)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
 	idescsi_pc_t   *pc;
@@ -298,8 +299,8 @@
 	rq->flags = REQ_SENSE;
 	pc->timeout = jiffies + WAIT_READY;
 	/* NOTE! Save the failed packet command in "rq->buffer" */
-	rq->buffer = (void *) failed_command->special;
-	pc->scsi_cmd = ((idescsi_pc_t *) failed_command->special)->scsi_cmd;
+	rq->buffer = (void *) failed_command;
+	pc->scsi_cmd = failed_command->scsi_cmd;
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
 		printk ("ide-scsi: %s: queue cmd = ", drive->name);
 		hexdump(pc->c, 6);
@@ -307,6 +308,38 @@
 	return ide_do_drive_cmd(drive, rq, ide_preempt);
 }
 
+/* code derived from ide_cdrom_error() -- see ide-cd.c */
+
+ide_startstop_t idescsi_atapi_abort (ide_drive_t *drive, const char *msg)
+{
+	struct request *rq;
+
+	if (drive == NULL || (rq = HWGROUP(drive)->rq) == NULL)
+		return ide_stopped;
+#if 1 //IDESCSI_DEBUG_LOG
+	printk (KERN_ERR "ide-scsi: atapi_abort called on %s to do %s\n", drive->name, msg);
+#endif
+	/* retry only "normal" I/O: */
+	if (rq->flags & (REQ_DRIVE_CMD | REQ_DRIVE_TASK)) {
+		rq->errors = 1;
+printk (KERN_ERR "ide-scsi: atapi_abort calls end_drive_cmd\n");
+		ide_end_drive_cmd(drive, BUSY_STAT, 0);
+printk (KERN_ERR "ide-scsi: returned from end_drive_cmd\n");
+		return ide_stopped;
+	}
+	rq->errors |= ERROR_RESET;
+	if (HWIF(drive)->INB(IDE_STATUS_REG) & (BUSY_STAT|DRQ_STAT)) {
+#if 1 //IDESCSI_DEBUG_LOG
+		printk (KERN_ERR "ide-scsi: forcing HWIF abort\n");
+#endif
+		HWIF(drive)->OUTB(WIN_IDLEIMMEDIATE,IDE_COMMAND_REG);
+	}
+	DRIVER(drive)->end_request(drive, 0, 0);
+	del_timer(&HWGROUP(drive)->timer);
+	HWGROUP(drive)->handler = NULL;
+	return ide_stopped;
+}
+
 static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
@@ -342,7 +375,7 @@
 	} else if (rq->errors) {
 		if (log)
 			printk ("ide-scsi: %s: check condition for %lu\n", drive->name, pc->scsi_cmd->serial_number);
-		if (!idescsi_check_condition(drive, rq))
+		if (!idescsi_check_condition(drive, pc))
 			/* we started a request sense, so we'll be back, exit for now */
 			return 0;
 		pc->scsi_cmd->result = (CHECK_CONDITION << 1) | (DID_OK << 16);
@@ -536,12 +569,8 @@
 		set_bit(PC_DMA_OK, &pc->flags);
 
 	if (test_bit(IDESCSI_DRQ_INTERRUPT, &scsi->flags)) {
-		if (HWGROUP(drive)->handler != NULL)
-			BUG();
-		ide_set_handler(drive, &idescsi_transfer_pc,
-				get_timeout(pc), NULL);
 		/* Issue the packet command */
-		HWIF(drive)->OUTB(WIN_PACKETCMD, IDE_COMMAND_REG);
+		ide_execute_command(drive, WIN_PACKETCMD, &idescsi_transfer_pc, get_timeout(pc), NULL);
 		return ide_started;
 	} else {
 		/* Issue the packet command */
@@ -633,6 +662,7 @@
 	.cleanup		= idescsi_cleanup,
 	.do_request		= idescsi_do_request,
 	.end_request		= idescsi_end_request,
+	.abort			= idescsi_atapi_abort,
 	.drives			= LIST_HEAD_INIT(idescsi_driver.drives),
 };
 
@@ -664,8 +694,6 @@
 	.ioctl		= idescsi_ide_ioctl,
 };
 
-static int idescsi_attach(ide_drive_t *drive);
-
 static int idescsi_slave_configure(Scsi_Device * sdp)
 {
 	/* Configure detected device */
@@ -772,8 +800,7 @@
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
 
-	/* this was a layering violation and we can't support it
-	   anymore, sorry. */
+	/* this was a layering violation and we can't support it anymore, sorry. */
 #if 0
 	struct gendisk *disk = cmd->request->rq_disk;
 
@@ -788,11 +815,20 @@
 
 static int idescsi_queue (Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *))
 {
+	struct scsi_device * sdev = cmd->device;
 	idescsi_scsi_t *scsi = scsihost_to_idescsi(cmd->device->host);
 	ide_drive_t *drive = scsi->drive;
 	struct request *rq = NULL;
 	idescsi_pc_t *pc = NULL;
 
+	if ((sdev->channel > 0) ||
+	    (sdev->id >= sdev->host->max_id) ||
+	    (sdev->lun >= sdev->host->max_lun)) {
+		printk(KERN_INFO "ide-scsi: channel:id:lun %d:%d:%d not "
+		       "present\n", sdev->channel, sdev->id, sdev->lun);
+		cmd->result = DID_NO_CONNECT << 16;
+		goto abort1;
+	}
 	if (!drive) {
 		printk (KERN_ERR "ide-scsi: drive id %d not present\n", cmd->device->id);
 		goto abort;
@@ -804,9 +840,8 @@
 		printk (KERN_ERR "ide-scsi: %s: out of memory\n", drive->name);
 		goto abort;
 	}
-
-	memset (pc->c, 0, 12);
-	pc->flags = 0;
+	memset(pc, 0, sizeof(idescsi_pc_t));
+	memset(rq, 0, sizeof(struct request));
 	pc->rq = rq;
 	memcpy (pc->c, cmd->cmnd, cmd->cmd_len);
 	if (cmd->use_sg) {
@@ -839,85 +874,125 @@
 	rq->special = (char *) pc;
 	rq->bio = idescsi_dma_bio (drive, pc);
 	rq->flags = REQ_SPECIAL;
-	spin_unlock_irq(cmd->device->host->host_lock);
+	spin_unlock_irq(sdev->host->host_lock);
 	(void) ide_do_drive_cmd (drive, rq, ide_end);
-	spin_lock_irq(cmd->device->host->host_lock);
+	spin_lock_irq(sdev->host->host_lock);
 	return 0;
 abort:
+	cmd->result = DID_ERROR << 16;
+abort1:
 	if (pc) kfree (pc);
 	if (rq) kfree (rq);
-	cmd->result = DID_ERROR << 16;
 	done(cmd);
-	return 1;
+	return 0;
 }
 
-static int idescsi_abort (Scsi_Cmnd *cmd)
+static int idescsi_scsi_eh_abort (Scsi_Cmnd *cmd)
 {
-	int countdown = 8;
+	int countdown = 20; /* 120;    /* maximum is 12 seconds because ide interrupt timeout is 10 sec. */
+	int notyetprinted = 1;
 	unsigned long flags;
 	idescsi_scsi_t *scsi = scsihost_to_idescsi(cmd->device->host);
 	ide_drive_t *drive = scsi->drive;
 
-	printk (KERN_ERR "ide-scsi: abort called for %lu\n", cmd->serial_number);
+	if (!drive)
+		return FAILED;
+	printk (KERN_ERR "ide-scsi: abort called on %s for %lu\n", drive->name, cmd->serial_number);
+	/* first, the device needs to become not-busy */
+	if (ide_wait_not_busy(HWIF(drive), 12000)) {
+		printk(KERN_WARNING "ide-scsi: device did not become ready in abort\n");
+		return FAILED;
+	}
 	while (countdown--) {
-		/* is cmd active?
+		/* is cmd active in the SCSI sub-system?
 		 *  need to lock so this stuff doesn't change under us */
-		spin_lock_irqsave(&ide_lock, flags);
 		if (scsi->pc && scsi->pc->scsi_cmd && 
 				scsi->pc->scsi_cmd->serial_number == cmd->serial_number) {
 			/* yep - let's give it some more time - 
 			 * we can do that, we're in _our_ error kernel thread */
-			spin_unlock_irqrestore(&ide_lock, flags);
-			scsi_sleep(HZ);
+#if 1 //IDESCSI_DEBUG_LOG
+			if (notyetprinted) {
+				printk(KERN_WARNING "ide-scsi: waiting in abort\n");
+				notyetprinted = 0;
+			}
+#endif
+			mdelay(100);
 			continue;
 		}
+		spin_lock_irqsave(&ide_lock, flags);
 		/* no, but is it queued in the ide subsystem? */
+printk(KERN_WARNING "ide-scsi: check elevator queue\n");
 		if (elv_queue_empty(&drive->queue)) {
 			spin_unlock_irqrestore(&ide_lock, flags);
+#if 1 //IDESCSI_DEBUG_LOG
+			printk(KERN_WARNING "ide-scsi: abort success return\n");
+#endif
 			return SUCCESS;
 		}
 		spin_unlock_irqrestore(&ide_lock, flags);
-		schedule_timeout(HZ/10);
+		mdelay(100);
 	}
+#if 1 //IDESCSI_DEBUG_LOG
+	printk(KERN_WARNING "ide-scsi: abort fail return\n");
+#endif
 	return FAILED;
 }
 
-static int idescsi_reset (Scsi_Cmnd *cmd)
+static int idescsi_scsi_eh_reset (Scsi_Cmnd *cmd)
 {
+	int countdown = 10;
 	unsigned long flags;
-	struct request *req;
 	idescsi_scsi_t *idescsi = scsihost_to_idescsi(cmd->device->host);
 	ide_drive_t *drive = idescsi->drive;
 
-	printk (KERN_ERR "ide-scsi: reset called for %lu\n", cmd->serial_number);
-	/* first null the handler for the drive and let any process
-	 * doing IO (on another CPU) run to (partial) completion
-	 * the lock prevents processing new requests */
+	if (!drive)
+		return FAILED;
+	printk (KERN_ERR "ide-scsi: reset called on %s for %lu\n", drive->name, cmd->serial_number);
 	spin_lock_irqsave(&ide_lock, flags);
-	while (HWGROUP(drive)->handler) {
-		HWGROUP(drive)->handler = NULL;
-		schedule_timeout(1);
-	}
-	/* now nuke the drive queue */
-	while ((req = elv_next_request(&drive->queue))) {
-		blkdev_dequeue_request(req);
-		end_that_request_last(req);
-	}
-	/* FIXME - this will probably leak memory */
-	HWGROUP(drive)->rq = NULL;
+        /*
+         * we use the busy flag to reserve the hwgroup for ourselves without holding
+         * the ide lock for a long time during the reset, reset will clear the busy
+         */
+        HWGROUP(drive)->busy = 1;
+	spin_unlock_irqrestore(&ide_lock, flags);
+        /*
+         * Abort the current command on the group if there is one, taking care not to
+         * allow anything else to be queued and to die on the spot if we miss one somehow
+         */
+        DRIVER(drive)->abort(drive, "drive reset");
+        if (HWGROUP(drive)->rq)
+                BUG();
+	/* FIXME - this will probably leak memory (both rq and pc) */
 	if (drive_to_idescsi(drive))
 		drive_to_idescsi(drive)->pc = NULL;
-	spin_unlock_irqrestore(&ide_lock, flags);
+#if 1 //IDESCSI_DEBUG_LOG
+	printk(KERN_WARNING "ide-scsi: drive->abort completed, now do_reset\n");
+#endif
 	/* finally, reset the drive (and its partner on the bus...) */
-	ide_do_reset (drive);	
+	(void) ide_do_reset (drive);
+	spin_lock_irqsave(&ide_lock, flags);
+	HWGROUP(drive)->busy--;
+	spin_unlock_irqrestore(&ide_lock, flags);
+	/* in theory, this can take 30 seconds, but ide_spin_wait_hwgroup waits only 3,
+	 * usually, that is enough, but we call repeatedly, just to be covered */
+	while (ide_spin_wait_hwgroup(drive) && --countdown)
+		printk (KERN_INFO "ide-scsi: waiting for reset drive to complete\n");
+	/* for some reason when successful ide_spin_wait_hwgroup exits with ide_lock taken */
+	if (countdown) spin_unlock_irq(&ide_lock);
+	if (HWGROUP(drive)->busy) {
+		printk (KERN_CRIT "ide-scsi: reset drive did not complete in time\n");
+		return FAILED;
+	}
+#if 1 //IDESCSI_DEBUG_LOG
+	printk(KERN_WARNING "ide-scsi: reset success return\n");
+#endif
 	return SUCCESS;
 }
 
 static int idescsi_bios(struct scsi_device *sdev, struct block_device *bdev,
 		sector_t capacity, int *parm)
 {
-	idescsi_scsi_t *idescsi = scsihost_to_idescsi(sdev->host);
-	ide_drive_t *drive = idescsi->drive;
+	ide_drive_t *drive = scsihost_to_idescsi(sdev->host)->drive;
 
 	if (drive->bios_cyl && drive->bios_head && drive->bios_sect) {
 		parm[0] = drive->bios_head;
@@ -934,8 +1009,10 @@
 	.slave_configure        = idescsi_slave_configure,
 	.ioctl			= idescsi_ioctl,
 	.queuecommand		= idescsi_queue,
-	.eh_abort_handler	= idescsi_abort,
-	.eh_device_reset_handler = idescsi_reset,
+	.eh_abort_handler	= idescsi_scsi_eh_abort,
+	.eh_device_reset_handler = idescsi_scsi_eh_reset,
+	.eh_bus_reset_handler   = idescsi_scsi_eh_reset,
+	.eh_host_reset_handler  = idescsi_scsi_eh_reset,
 	.bios_param		= idescsi_bios,
 	.can_queue		= 40,
 	.this_id		= -1,

--Boundary_(ID_sQVcuJQ2XoggZz/9b5klKQ)--
