From: alci <alci@mecadu.org>
Subject: Scsi error : device overrun on Adaptec AIC-7902B
Date: Thu, 24 Jan 2008 14:37:22 +0100
Message-ID: <1201181842.10059.3.camel@franck-gusty>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emma.lautre.net ([80.67.160.69]:47735 "EHLO emma.lautre.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001AbYAYQGo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jan 2008 11:06:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I am experiencing odd error messages on a server and can't sort out if
it is a software or hardware problem.

Server is running linux 2.6.22 kernel from Ubuntu server distro
(2.6.22-14-server) on a bi-AMD64 Opteron machine.
The SCSI board is listed as follows by lspci :

0a:07.0 SCSI storage controller: Adaptec AIC-7902B U320 (rev 10)
        Subsystem: Adaptec Unknown device 005e
        Flags: bus master, 66MHz, slow devsel, latency 72, IRQ 28
        I/O ports at 3400 [disabled] [size=256]
        Memory at df300000 (64-bit, non-prefetchable) [size=8K]
        I/O ports at 3000 [disabled] [size=256]
        [virtual] Expansion ROM at c2100000 [disabled] [size=512K]
        Capabilities: [dc] Power Management version 2
        Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+
Queue=0/1 Enable-
        Capabilities: [94] PCI-X non-bridge device

0a:07.1 SCSI storage controller: Adaptec AIC-7902B U320 (rev 10)
        Subsystem: Adaptec Unknown device 005e
        Flags: bus master, 66MHz, slow devsel, latency 72, IRQ 29
        I/O ports at 3c00 [disabled] [size=256]
        Memory at df302000 (64-bit, non-prefetchable) [size=8K]
        I/O ports at 3800 [disabled] [size=256]
        [virtual] Expansion ROM at c2180000 [disabled] [size=512K]
        Capabilities: [dc] Power Management version 2
        Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+
Queue=0/1 Enable-
        Capabilities: [94] PCI-X non-bridge device

First SCSI chain has 4 Ultra320 harddrives, and second one (scsi5) has 4
Ultra320 harddrives and a 160 tape reader.

Regularely, we have a bunch of such errors in /var/log/messages (every
10 minutes or so, when the machine is active, plus a detailed card
dump) :

Jan 24 12:20:37 pariou kernel: [64896.014316] scsi5: Transmission error
detected
Jan 24 12:20:37 pariou kernel: [64896.014347] scsi5: Dumping Card State
at program address 0x257 Mode 0x0
Jan 24 12:20:37 pariou kernel: [64896.014651] scsi5: FIFO0 Active,
LONGJMP == 0x252, SCB 0x7b
Jan 24 12:20:37 pariou kernel: [64896.014722] scsi5: FIFO1 Free, LONGJMP
== 0x81f7, SCB 0x62
Jan 24 12:20:37 pariou kernel: [64896.014808] scsi5: LQISTATE = 0x2b,
LQOSTATE = 0x0, OPTIONMODE = 0x52
Jan 24 12:20:37 pariou kernel: [64896.014812] scsi5: OS_SPACE_CNT = 0x20
MAXCMDCNT = 0x1
Jan 24 12:20:37 pariou kernel: [64896.014815] scsi5: SAVED_SCSIID = 0x0
SAVED_LUN = 0x0
Jan 24 12:20:37 pariou kernel: [64896.014834] scsi5: REG0 == 0x7d60,
SINDEX = 0x158, DINDEX = 0x10a
Jan 24 12:20:37 pariou kernel: [64896.014842] scsi5: SCBPTR == 0x7b,
SCB_NEXT == 0xff00, SCB_NEXT2 == 0x79
Jan 24 12:20:37 pariou kernel: [64896.015374] scsi5: Returning to Idle
Loop
Jan 24 12:20:37 pariou kernel: [64896.015438] scsi5: device overrun
(status a) on 0:3:0


Smartctl on /dev/sdj (scsi5 0:3:0) says : 

smartctl version 5.37 [x86_64-unknown-linux-gnu] Copyright (C) 2002-6
Bruce Allen
Home page is http://smartmontools.sourceforge.net/

Device: HITACHI  HUS151436VL3600  Version: S3C0
Serial number:         J3WE8KLA
Device type: disk
Transport protocol: Parallel SCSI (SPI-4)
Local Time is: Thu Jan 24 13:25:08 2008 CET
Device supports SMART and is Enabled
Temperature Warning Enabled
SMART Health Status: OK

Current Drive Temperature:     40 C
Drive Trip Temperature:        85 C
Manufactured in week 08 of year 2006
Recommended maximum start stop count:  50000 times
Current start stop count:      105 times
Elements in grown defect list: 0
Vendor (Seagate) cache information
  Blocks sent to initiator = 300818938986496

Error counter log:
           Errors Corrected by           Total   Correction
Gigabytes    Total
               ECC          rereads/    errors   algorithm
processed    uncorrected
           fast | delayed   rewrites  corrected  invocations   [10^9
bytes]  errors
read:     110325    93424         0    110325        956        340.501
0
write:     32845        0         0     32845          0        316.122
0

Non-medium error count:        0
No self-tests have been logged
Long (extended) Self Test duration: 607 seconds [10.1 minutes]


But yesterday, we had a worse problem, where half our disks went
offline, with the following log (one card dump for each of the four
disks).
SO, any tip on what might be going wrong ??

Thanks in advance,
Franck


[452353.991582] sd 5:0:1:0: [sdg] Attempting to queue an ABORT
message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[452353.992109] scsi5: At time of recovery, card was not paused
[452353.992116] >>>>>>>>>>>>>>>>>> Dump Card State Begins
<<<<<<<<<<<<<<<<<
[452353.992118] scsi5: Dumping Card State at program address 0x6 Mode
0x33
[452353.992121] Card was paused
[452353.992123] INTSTAT[0x0] SELOID[0x2] SELID[0x10] 
[452353.992132] HS_MAILBOX[0x0] INTCTL[0xc0]:(SWTMINTEN|SWTMINTMASK) 
[452353.992140] SEQINTSTAT[0x0] SAVED_MODE[0x0] 
[452353.992146] DFFSTAT[0x33]:(CURRFIFO_NONE|FIFO0FREE|FIFO1FREE) 
[452353.992153] SCSISIGI[0x0]:(P_DATAOUT) SCSIPHASE[0x0] 
[452353.992160] SCSIBUS[0x0] LASTPHASE[0x1]:(P_DATAOUT|P_BUSFREE) 
[452353.992168] SCSISEQ0[0x0] SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI) 
[452353.992177] SEQCTL0[0x0] SEQINTCTL[0x0] SEQ_FLAGS[0x0] 
[452353.992186] SEQ_FLAGS2[0x4]:(SELECTOUT_QFROZEN) 
[452353.992191] QFREEZE_COUNT[0xfd] KERNEL_QFREEZE_COUNT[0xfc] 
[452353.992200] MK_MESSAGE_SCB[0xff00] MK_MESSAGE_SCSIID[0xff] 
[452353.992207] SSTAT0[0x0] SSTAT1[0x0] SSTAT2[0x0] 
[452353.992216] SSTAT3[0x0] PERRDIAG[0x0] SIMODE1[0xa4]:(ENSCSIPERR|
ENSCSIRST|ENSELTIMO) 
[452353.992227] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] 
[452353.992235] LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0xe1]:(LQOSTOP0|
LQOPKT) 
[452353.992251] 
[452353.992252] SCB Count = 128 CMDS_PENDING = 0 LASTSCB 0x5c CURRSCB
0x58 NEXTSCB 0xffc0
[452353.992258] qinstart = 58805 qinfifonext = 58806
[452353.992260] QINFIFO: 0x52
[452353.992263] WAITING_TID_QUEUES:
[452353.992272] Pending list:
[452353.992275]  82 FIFO_USE[0x0] SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) 
[452353.992283] SCB_SCSIID[0x2f]:(OID) 
[452353.992286] Total 1
[452353.992288] Kernel Free SCB list: 2 86 118 88 3 108 66 23 17 26 93 9
115 101 50 74 8 85 30 120 4 110 57 7 1 125 65 63 84 116 91 76 56 92 78
22 77 21 95 123 18 36 44 28 114 126 20 83 122 24 31 19 106 61 48 94 34
124 80 46 49 62 75 54 70 97 0 99 103 104 60 11 89 79 38 41 53 15 87 51
43 113 5 52 27 32 90 119 127 58 72 112 55 100 42 105 121 81 14 117 12 59
96 13 6 47 109 64 69 25 71 35 16 37 67 40 45 102 39 111 33 68 29 10 107
73 98 
[452353.992377] Sequencer Complete DMA-inprog list: 
[452353.992382] Sequencer Complete list: 
[452353.992386] Sequencer DMA-Up and Complete list: 
[452353.992390] Sequencer On QFreeze and Complete list: 
[452353.992400] 
[452353.992401] 
[452353.992402] scsi5: FIFO0 Free, LONGJMP == 0x80f7, SCB 0x42
[452353.992405] SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|
ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 
[452353.992415] SEQINTSRC[0x40]:(CTXTDONE) DFCNTRL[0x4]:(DIRECTION) 
[452353.992424] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
[452353.992431] SG_CACHE_SHADOW[0x2]:(LAST_SEG) 
[452353.992435] SG_STATE[0x0] DFFSXFRCTL[0x0] SOFFCNT[0x0] 
[452353.992443] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) 
[452353.992456] SHADDR = 0x00, SHCNT = 0x0 HADDR = 0x00, HCNT = 0x0 
[452353.992469] CCSGCTL[0x10]:(SG_CACHE_AVAIL) 
[452353.992477] 
[452353.992478] scsi5: FIFO1 Free, LONGJMP == 0x80f7, SCB 0x1c
[452353.992481] SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|
ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 
[452353.992491] SEQINTSRC[0x0] DFCNTRL[0x4]:(DIRECTION) 
[452353.992499] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
[452353.992506] SG_CACHE_SHADOW[0x2]:(LAST_SEG) 
[452353.992511] SG_STATE[0x0] DFFSXFRCTL[0x0] SOFFCNT[0x0] 
[452353.992519] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) 
[452353.992532] SHADDR = 0x00, SHCNT = 0x0 HADDR = 0x00, HCNT = 0x0 
[452353.992546] CCSGCTL[0x10]:(SG_CACHE_AVAIL) 
[452353.992550] LQIN: 0x5 0x0 0x0 0x42 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
0x0 0x0 0x2 0x0 0x0 0x0 0x2 0x0 
[452353.992583] scsi5: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
[452353.992588] scsi5: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x1
[452353.992593] scsi5: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
[452353.992596] 
[452353.992598] SIMODE0[0xc]:(ENOVERRUN|ENIOERR) 
[452353.992604] CCSCBCTL[0x0] 
[452353.992613] scsi5: REG0 == 0x17, SINDEX = 0x1c0, DINDEX = 0x106
[452353.992621] scsi5: SCBPTR == 0x56, SCB_NEXT == 0xffc0, SCB_NEXT2 ==
0xff58
[452353.992629] CDB 2a 0 3 80 0 3a
[452353.992631] STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
[452353.992652] <<<<<<<<<<<<<<<<< Dump Card State Ends
>>>>>>>>>>>>>>>>>>
[452353.992664] scsi5:0:1:0: Cmd aborted from QINFIFO
[452353.992685] sd 5:0:1:0: scsi: Device offlined - not ready after
error recovery
[452353.992690] sd 5:0:1:0: scsi: Device offlined - not ready after
error recovery
[452353.992693] sd 5:0:2:0: scsi: Device offlined - not ready after
error recovery
[452353.992696] sd 5:0:2:0: scsi: Device offlined - not ready after
error recovery
[452353.992700] sd 5:0:1:0: scsi: Device offlined - not ready after
error recovery
[452353.992703] sd 5:0:1:0: scsi: Device offlined - not ready after
error recovery
[452353.992706] sd 5:0:2:0: scsi: Device offlined - not ready after
error recovery
[452353.992710] sd 5:0:2:0: scsi: Device offlined - not ready after
error recovery
[452353.992713] sd 5:0:4:0: scsi: Device offlined - not ready after
error recovery
[452353.992716] sd 5:0:3:0: scsi: Device offlined - not ready after
error recovery
[452353.992720] sd 5:0:1:0: scsi: Device offlined - not ready after
error recovery
[452353.992755] sd 5:0:1:0: [sdg] Result: hostbyte=invalid
driverbyte=DRIVER_OK,SUGGEST_OK
[452353.992760] end_request: I/O error, dev sdg, sector 54857151
[452353.992767] raid1: Disk failure on sdg1, disabling device. 
[452353.992768]         Operation continuing on 1 devices
[452353.992850] sd 5:0:1:0: [sdg] Result: hostbyte=invalid
driverbyte=DRIVER_OK,SUGGEST_OK
[452353.992855] end_request: I/O error, dev sdg, sector 54858175
[452353.992893] sd 5:0:2:0: [sdh] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
[452353.992899] end_request: I/O error, dev sdh, sector 54858175
[452353.992903] raid1: Disk failure on sdh1, disabling device. 
[452353.992905]         Operation continuing on 1 devices
[452353.992970] sd 5:0:2:0: [sdh] Result: hostbyte=invalid
driverbyte=DRIVER_OK,SUGGEST_OK
[452353.992975] end_request: I/O error, dev sdh, sector 54859199
[452353.993019] sd 5:0:1:0: [sdg] Result: hostbyte=invalid
driverbyte=DRIVER_OK,SUGGEST_OK
[452353.993024] end_request: I/O error, dev sdg, sector 54859199
[452353.993052] sd 5:0:1:0: [sdg] Result: hostbyte=invalid
driverbyte=DRIVER_OK,SUGGEST_OK
[452353.993058] end_request: I/O error, dev sdg, sector 54861951
[452353.993071] sd 5:0:2:0: [sdh] Result: hostbyte=invalid
driverbyte=DRIVER_OK,SUGGEST_OK
[452353.993077] end_request: I/O error, dev sdh, sector 54861631
[452353.993092] sd 5:0:2:0: [sdh] Result: hostbyte=invalid
driverbyte=DRIVER_OK,SUGGEST_OK
[452353.993097] end_request: I/O error, dev sdh, sector 54861887
[452353.993112] sd 5:0:4:0: rejecting I/O to offline device
[452353.993140] md: super_written gets error=-5, uptodate=0
[452353.993145] raid1: Disk failure on sdj1, disabling device. 
[452353.993146]         Operation continuing on 1 devices
[452353.993184] sd 5:0:4:0: rejecting I/O to offline device
[452353.993213] raid1: sdj1: rescheduling sector 59701584
[452353.993242] sd 5:0:3:0: rejecting I/O to offline device
[452353.993270] md: super_written gets error=-5, uptodate=0
[452353.993274] raid1: Disk failure on sdi1, disabling device. 
[452353.993276]         Operation continuing on 1 devices
[452353.993309] sd 5:0:3:0: rejecting I/O to offline device
[452353.993336] raid1: sdi1: rescheduling sector 61497840
[452353.993364] sd 5:0:1:0: [sdg] Result: hostbyte=invalid
driverbyte=DRIVER_OK,SUGGEST_OK
[452353.993370] end_request: I/O error, dev sdg, sector 35846227
[452353.999971] RAID1 conf printout:
[452353.999977]  --- wd:1 rd:2
[452353.999981]  disk 0, wo:0, o:1, dev:sdd1
[452353.999983]  disk 1, wo:1, o:0, dev:sdh1
[452354.000735] RAID1 conf printout:
[452354.000737]  --- wd:1 rd:2
[452354.000739]  disk 0, wo:0, o:1, dev:sde1
[452354.000741]  disk 1, wo:1, o:0, dev:sdi1
[452354.001207] RAID1 conf printout:
[452354.001208]  --- wd:1 rd:2
[452354.001210]  disk 0, wo:0, o:1, dev:sdc1
[452354.001212]  disk 1, wo:1, o:0, dev:sdg1
[452354.003735] RAID1 conf printout:
[452354.003737]  --- wd:1 rd:2
[452354.003739]  disk 0, wo:0, o:1, dev:sdf1
[452354.003742]  disk 1, wo:1, o:0, dev:sdj1
[452354.021548] RAID1 conf printout:
[452354.021550]  --- wd:1 rd:2
[452354.021552]  disk 0, wo:0, o:1, dev:sdd1
[452354.021558] RAID1 conf printout:
[452354.021560]  --- wd:1 rd:2
[452354.021562]  disk 0, wo:0, o:1, dev:sde1
[452354.021573] RAID1 conf printout:
[452354.021574]  --- wd:1 rd:2
[452354.021576]  disk 0, wo:0, o:1, dev:sdc1
[452354.041521] RAID1 conf printout:
[452354.041523]  --- wd:1 rd:2
[452354.041525]  disk 0, wo:0, o:1, dev:sdf1
[452354.043770] raid1: sde1: redirecting sector 61497840 to another
mirror
[452354.069634] raid1: sdf1: redirecting sector 59701584 to another
mirror
[454118.258537] md: unbind<sdg1>
[454118.258545] md: export_rdev(sdg1)

