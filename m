From: bernd@rhm.de
Subject: ADAPTEC Ultra320 hotplugging with 2.6.x
Date: Fri, 11 Mar 2005 00:13:55 +0100 (MEZ)
Message-ID: <200503102313.AAA08804@node130.rhm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received: from mail.Space.Net ([195.30.0.8]:39941 "HELO mail.space.net")
	by vger.kernel.org with SMTP id S263404AbVCJXOD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Mar 2005 18:14:03 -0500
Received: (from bernd@localhost)
	by node130.rhm.de (8.9.3 (PHNE_28760)/8.8.6) id AAA08804
	for linux-scsi@vger.kernel.org; Fri, 11 Mar 2005 00:13:55 +0100 (MEZ)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

we have some problems replacing a SCSI disk in runtime. The problems
started with kernel 2.6.x, with kernels 2.4.x we never saw any problems.
We tried all kernels from 2.6.8 to 2.6.11-rc3-bk3-20050206171922-bigsmp,
the last one we found for SuSE 9.2. All kernels showed this problem.

Our boxes have 2 controllers, here the shortened info out of boot.msg 
(for one controller only, the other is similar):

<6>scsi1: Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 1.3.11
<4>       <Adaptec AIC7902 Ultra320 SCSI adapter>
<4>       aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 67-100Mhz,512 SCBs
<4>
<4>(scsi1:A:0): 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
<5>  Vendor: MAXTOR    Model: ATLAS10K5_147SCA  Rev: JNZ3
<5>  Type:   Direct-Access                      ANSI SCSI revision: 03
<4>scsi1:A:0:0: Tagged Queuing enabled.  Depth 32
<5>SCSI device sda: 287332384 512-byte hdwr sectors (147114 MB)
<5>SCSI device sda: drive cache: write back
<5>SCSI device sda: 287332384 512-byte hdwr sectors (147114 MB)
<5>SCSI device sda: drive cache: write back
<6> sda: sda1 sda2
<5>Attached scsi disk sda at scsi1, channel 0, id 0, lun 0
<5>  Vendor: ESG-SHV   Model: SCA HSBP M15      Rev: 0.11
<5>  Type:   Processor                          ANSI SCSI revision: 02

Each controller is responsible for 5 SCA disks. The disks are mirrored in
a software RAID1 (mdadm) from one controller to the other. When a disk 
fails we have to hot replace it without downtime. So we pull it out, we
do an "echo remove-single-scsi-disk ...", then we plug in the new disk and
do an 'echo add-...'. The new disk spins up as expected but after some
time _all_ disks on that controller aren't working anymore (this results
in all RAID's going into degraded mode).

To simplify matters and reducing log-output I reproduced this behavior
with two disks on either controller. I replaced (<host><channel><id><lu<)
disk 1/0/0/0 while 1/0/4/0 was working as 2/0/8/0 and 2/0/9/0 do on the 
other controller. When the "echo add-single-scsi-disk 1 0 0 0 ...." is
given the following scenario happens resulting in two lost disks, e.g.
1/0/0/0 which was to be replaced and in addition 1/0/4/0 which was good
before. 

- why are _all_ disks on the controller where the replacement takes place
  set to offline?

- is this a problem of the driver or are there problems in the controller?

- is the controller supported by kernel 2.6.x?

- there is a tool called scsirastool. We tried this, too. It shows the same
  problems. The guys from there mentioned a driver 1.3.2 which we found only
  for kernel 2.4.x. We have version 1.3.11 which is not available for kernel
  2.6.x)

Any hints are very welcome because we are pretty lost. Thank's in advance
and sorry for this long thread.
B. Rieke

After the command echo "add-single-scsi-disk 1 0 0 0" > /proc/scsi/scsi 
is given the following takes place. The lines from 'Dump Card State Begins'
to '....Ends' are repeated 4 time:

scsi1: ILLEGAL_PHASE 0x80
(scsi1:A:0:0): Abort Message Sent
scsi1:0:0:0: Attempting to abort cmd f6c07080: 0x12 0x0 0x0 0x0 0x24 0x0
scsi1: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi1: Dumping Card State at program address 0x1ae Mode 0x11
Card was paused
SWTMINTMASK) SEQINTSTAT[0x0] 
SAVED_MODE[0x11] DFFSTAT[0x11]:(CURRFIFO_1|FIFO0FREE) 
SCSISIGI[0x0]:(P_DATAOUT) SCSIPHASE[0x0] SCSIBUS[0x0] 
LASTPHASE[0xa0]:(P_MESGOUT) SCSISEQ0[0x0] SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI) 
SEQCTL0[0x10]:(FASTMODE) SEQINTCTL[0x0] SEQ_FLAGS[0x0] 
SEQ_FLAGS2[0x0] SSTAT0[0x0] SSTAT1[0x8]:(BUSFREE) 
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x0] SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO) 
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
LQOSTAT1[0x0] LQOSTAT2[0x0] 

SCB Count = 32 CMDS_PENDING = 2 LASTSCB 0x11 CURRSCB 0x11 NEXTSCB 0xff02
qinstart = 52611 qinfifonext = 52612
QINFIFO: 0x1b
WAITING_TID_QUEUES:
Pending list:
 27 FIFO_USE[0x0] SCB_CONTROL[0x68]:(STATUS_RCVD|TAG_ENB|DISCENB) 
SCB_SCSIID[0x47] 
 17 FIFO_USE[0x0] SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x7] 
Total 2
Kernel Free SCB list: 10 11 6 25 31 18 13 28 22 20 4 8 21 2 26 30 12 23 14 9 24 3 16 5 0 1 7 15 29 19 
Sequencer Complete DMA-inprog list: 
Sequencer Complete list: 
Sequencer DMA-Up and Complete list: 

scsi1: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x11
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 
SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x0] 
scsi1: FIFO1 Active, LONGJMP == 0x8278, SCB 0x11
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 
SEQINTSRC[0x0] DFCNTRL[0x4]:(DIRECTION) DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
SG_CACHE_SHADOW[0x3]:(LAST_SEG_DONE|LAST_SEG) SG_STATE[0x0] 
DFFSXFRCTL[0x0] SOFFCNT[0x0] MDFFSTAT[0x14]:(DLZERO|LASTSDONE) 
SHADDR = 0x06, SHCNT = 0x0 HADDR = 0x00, HCNT = 0x0 
CCSGCTL[0x10]:(SG_CACHE_AVAIL) 
LQIN: 0x55 0x3c 0x0 0x11 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
scsi1: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x42
scsi1: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
SIMODE0[0xc]:(ENOVERRUN|ENIOERR) 
CCSCBCTL[0x4]:(CCSCBDIR) 
scsi1: REG0 == 0x60, SINDEX = 0x1ff, DINDEX = 0x102
scsi1: SCBPTR == 0x11, SCB_NEXT == 0xff40, SCB_NEXT2 == 0xfff9
CDB 0 0 0 0 0 0
STACK: 0x125 0x125 0x125 0x125 0x0 0x25f 0x241 0xa7
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
DevQ(0:0:0): 0 waiting
DevQ(0:4:0): 0 waiting
DevQ(0:6:0): 0 waiting
scsi1:0:4:0: Cmd aborted from QINFIFO
Recovery code sleeping
Recovery code awake
Timer Expired
scsi1: Device reset returning 0x2003
Recovery code sleeping
Recovery code awake
Timer Expired
scsi1: Device reset returning 0x2003
Recovery SCB completes
last messsage repeated 2 times
scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 0 lun 0
scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 4 lun 0
SCSI error : <1 0 4 0> return code = 0x8000002
Info fld=0x0, Current sdb: sense key Aborted Command
end_request: I/O error, dev sdb, sector 287306206
md: write_disk_sb failed for device sdb2
md: errors occurred during superblock update, repeating
scsi1 (4:0): rejecting I/O to offline device
md: write_disk_sb failed for device sdb2
md: errors occurred during superblock update, repeating
last two messages repeated 100 times
scsi1 (4:0): rejecting I/O to offline device
md: write_disk_sb failed for device sdb2
md: excessive errors occurred during superblock update, exiting
scsi1 (4:0): rejecting I/O to offline device
raid1: Disk failure on sdb2, disabling device. 
    Operation continuing on 1 devices
RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:1, o:0, dev:sdb2
 disk 1, wo:0, o:1, dev:sdc2
RAID1 conf printout:
 --- wd:1 rd:2
 disk 1, wo:0, o:1, dev:sdc2
