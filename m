From: Andrea Carpani <andrea.carpani@criticalpath.net>
Subject: scsi0: Transmission error detected with SCSI Adaptec AIC-7902 U320
Date: Thu, 29 Jun 2006 11:13:50 +0200
Message-ID: <1151572430.676.76.camel@cronos.criticalpath.it>
Reply-To: andrea.carpani@criticalpath.net
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plutone.criticalpath.it ([192.92.105.11]:20359 "EHLO
	mail.criticalpath.it") by vger.kernel.org with ESMTP
	id S1751481AbWF2JUL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jun 2006 05:20:11 -0400
Received: from cronos.criticalpath.it (192.92.105.117) by mail.criticalpath.it (7.2.056.2)
        id 44A24372000003DC for linux-scsi@vger.kernel.org; Thu, 29 Jun 2006 11:20:09 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I have a server with a weird trashing problem and while investigating on
this issue I've found a SCSI error happening 1 hour before the trashng
occours.

Can someone give me info on this kind of problem (I'm not able to
understand Card State Dump). The server has 2 72Gb disks with one
partition each mirrored between them with software raid.

Thanks,

The server is 
http://www.tyan.com/products/html/gx28b2881.html
with B2881G28U4H (Hot-swap U320 SCSI bays)

======
root # uname -a
Linux cp3a 2.6.16.19 #2 SMP Mon Jun 5 19:26:39 CEST 2006 i686 AMD
Opteron(tm) Processor 244 AuthenticAMD GNU/Linux

======
root # cat /proc/scsi/aic79xx/0
Adaptec AIC79xx driver version: 3.0
Adaptec AIC7902 Ultra320 SCSI adapter
aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 67-100Mhz, 512 SCBs
Allocated SCBs: 64, SG List Length: 128

Serial EEPROM:
0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8
0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8
0x09f4 0x0146 0x2807 0x0010 0xffff 0xffff 0xffff 0xffff
0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x0430 0xb3f7

Target 0 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz RDSTRM|DT|IU|RTI|QAS, 16bit)
        Goal: 320.000MB/s transfers (160.000MHz RDSTRM|DT|IU|RTI|QAS, 16bit)
        Curr: 320.000MB/s transfers (160.000MHz RDSTRM|DT|IU|RTI|QAS, 16bit)
        Channel A Target 0 Lun 0 Settings
                Commands Queued 3281550
                Commands Active 0
                Command Openings 32
                Max Tagged Openings 32
                Device Queue Frozen Count 0
Target 1 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz RDSTRM|DT|IU|RTI|QAS, 16bit)
        Goal: 320.000MB/s transfers (160.000MHz RDSTRM|DT|IU|RTI|QAS, 16bit)
        Curr: 320.000MB/s transfers (160.000MHz RDSTRM|DT|IU|RTI|QAS, 16bit)
        Channel A Target 1 Lun 0 Settings
                Commands Queued 3280158
                Commands Active 0
                Command Openings 32
                Max Tagged Openings 32
                Device Queue Frozen Count 0
Target 2 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz RDSTRM|DT|IU|RTI|QAS, 16bit)
Target 3 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz RDSTRM|DT|IU|RTI|QAS, 16bit)
Target 4 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz RDSTRM|DT|IU|RTI|QAS, 16bit)
Target 5 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz RDSTRM|DT|IU|RTI|QAS, 16bit)
Target 6 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz RDSTRM|DT|IU|RTI|QAS, 16bit)
Target 7 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz RDSTRM|DT|IU|RTI|QAS, 16bit)
Target 8 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz RDSTRM|DT|IU|RTI|QAS, 16bit)
Target 9 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz RDSTRM|DT|IU|RTI|QAS, 16bit)
Target 10 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz RDSTRM|DT|IU|RTI|QAS, 16bit)
Target 11 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz RDSTRM|DT|IU|RTI|QAS, 16bit)
Target 12 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz RDSTRM|DT|IU|RTI|QAS, 16bit)
Target 13 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz RDSTRM|DT|IU|RTI|QAS, 16bit)
Target 14 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz RDSTRM|DT|IU|RTI|QAS, 16bit)
Target 15 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz RDSTRM|DT|IU|RTI|QAS, 16bit)

Here is the error:

Jun 28 12:00:01 localhost kernel: scsi0: Transmission error detected
Jun 28 12:00:01 localhost kernel: LQISTAT1[0x8]:(LQICRCI_NLQ) LASTPHASE[0x1]:(P_DATAOUT|P_BUSFREE)
Jun 28 12:00:01 localhost kernel: SCSISIGI[0x60]:(P_DATAIN_DT) PERRDIAG[0x4]:(CRCERR)
Jun 28 12:00:01 localhost kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Jun 28 12:00:01 localhost kernel: scsi0: Dumping Card State at program address 0x21 Mode 0x33
Jun 28 12:00:01 localhost kernel: Card was paused
Jun 28 12:00:01 localhost kernel: INTSTAT[0x8]:(SCSIINT) SELOID[0x1] SELID[0x0] HS_MAILBOX[0x0]
Jun 28 12:00:01 localhost kernel: INTCTL[0xc0]:(SWTMINTEN|SWTMINTMASK) SEQINTSTAT[0x0]
Jun 28 12:00:01 localhost kernel: SAVED_MODE[0x11] DFFSTAT[0x24]:(CURRFIFO_0|FIFO1FREE)
Jun 28 12:00:01 localhost kernel: SCSISIGI[0x76]:(P_DATAIN_DT|REQI|BSYI|ATNI) SCSIPHASE[0x0]
Jun 28 12:00:01 localhost kernel: SCSIBUS[0x0] LASTPHASE[0x1]:(P_DATAOUT|P_BUSFREE)
Jun 28 12:00:01 localhost kernel: SCSISEQ0[0x0] SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI)
Jun 28 12:00:01 localhost kernel: SEQCTL0[0x0] SEQINTCTL[0x0] SEQ_FLAGS[0x0] SEQ_FLAGS2[0x0]
Jun 28 12:00:01 localhost kernel: QFREEZE_COUNT[0x2] KERNEL_QFREEZE_COUNT[0x2] MK_MESSAGE_SCB[0xff00]
Jun 28 12:00:01 localhost kernel: MK_MESSAGE_SCSIID[0xff] SSTAT0[0x2]:(SPIORDY) SSTAT1[0x19]:(REQINIT|BUSFREE|P
HASEMIS)
Jun 28 12:00:01 localhost kernel: SSTAT2[0x20]:(NONPACKREQ) SSTAT3[0x0] PERRDIAG[0x0]
Jun 28 12:00:01 localhost kernel: SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO)
Jun 28 12:00:01 localhost kernel: LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0xc0]:(LQIPHASE_OUTPKT|PACKETIZED)
Jun 28 12:00:01 localhost kernel: LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0xe1]:(LQOSTOP0|LQOPKT)
Jun 28 12:00:01 localhost kernel:
Jun 28 12:00:01 localhost kernel: SCB Count = 64 CMDS_PENDING = 2 LASTSCB 0x1e CURRSCB 0x25 NEXTSCB 0xff80
Jun 28 12:00:01 localhost kernel: qinstart = 25641 qinfifonext = 25641
Jun 28 12:00:01 localhost kernel: QINFIFO:
Jun 28 12:00:01 localhost kernel: WAITING_TID_QUEUES:
Jun 28 12:00:01 localhost kernel: Pending list:
Jun 28 12:00:01 localhost kernel:  37 FIFO_USE[0x0] SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) SCB_SCSIID[0x17]
Jun 28 12:00:01 localhost kernel:  49 FIFO_USE[0x0] SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) SCB_SCSIID[0x7]
Jun 28 12:00:01 localhost kernel: Total 2
Jun 28 12:00:01 localhost kernel: Kernel Free SCB list: 30 0 47 6 20 5 28 23 48 61 22 16 62 58 50 9 43 21 52 51
 4 63 32 10 36 2 11 40 60 31 12 42 35 8 46 19 54 57 3 34 55 39 38 24 33 41 14 15 25 26 29 1 18 44 59 53 45 56 2
7 17 13 7
Jun 28 12:00:01 localhost kernel: Sequencer Complete DMA-inprog list:
Jun 28 12:00:01 localhost kernel: Sequencer Complete list:
Jun 28 12:00:01 localhost kernel: Sequencer DMA-Up and Complete list:
Jun 28 12:00:01 localhost kernel: Sequencer On QFreeze and Complete list:
Jun 28 12:00:01 localhost kernel:
Jun 28 12:00:01 localhost kernel:
Jun 28 12:00:01 localhost kernel: scsi0: FIFO0 Active, LONGJMP == 0x252, SCB 0x31
Jun 28 12:00:01 localhost kernel: SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSA
VEPTRS)
Jun 28 12:00:01 localhost kernel: SEQINTSRC[0x60]:(SAVEPTRS|CTXTDONE) DFCNTRL[0x8]:(HDMAEN)
Jun 28 12:00:01 localhost kernel: DFSTATUS[0x81]:(FIFOEMP|PRELOAD_AVAIL) SG_CACHE_SHADOW[0x20]
Jun 28 12:00:01 localhost kernel: SG_STATE[0x3]:(SEGS_AVAIL|LOADING_NEEDED) DFFSXFRCTL[0x0]
Jun 28 12:00:01 localhost kernel: SOFFCNT[0x0] MDFFSTAT[0xe]:(DATAINFIFO|DLZERO|SHVALID)
Jun 28 12:00:01 localhost kernel: SHADDR = 0x0b8731000, SHCNT = 0x1000 HADDR = 0x0b8731000, HCNT = 0x1000
Jun 28 12:00:01 localhost kernel: CCSGCTL[0x10]:(SG_CACHE_AVAIL)
Jun 28 12:00:01 localhost kernel:
Jun 28 12:00:01 localhost kernel: scsi0: FIFO1 Free, LONGJMP == 0x8252, SCB 0x5
Jun 28 12:00:01 localhost kernel: SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSA
VEPTRS)
Jun 28 12:00:01 localhost kernel: SEQINTSRC[0x0] DFCNTRL[0x4]:(DIRECTION) DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD
_AVAIL)
Jun 28 12:00:01 localhost kernel: SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0]
Jun 28 12:00:01 localhost kernel: SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0
Jun 28 12:00:01 localhost kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL)
Jun 28 12:00:01 localhost kernel: LQIN: 0x5 0x0 0x0 0x31 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x2 0x0 0x0 0x
0 0x2 0x0
Jun 28 12:00:01 localhost kernel: scsi0: LQISTATE = 0x2b, LQOSTATE = 0x0, OPTIONMODE = 0x52
Jun 28 12:00:01 localhost kernel: scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x1
Jun 28 12:00:01 localhost kernel: scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
Jun 28 12:00:01 localhost kernel:
Jun 28 12:00:01 localhost kernel: SIMODE0[0xc]:(ENOVERRUN|ENIOERR)
Jun 28 12:00:01 localhost kernel: CCSCBCTL[0x4]:(CCSCBDIR)
Jun 28 12:00:01 localhost kernel: scsi0: REG0 == 0x1e, SINDEX = 0x128, DINDEX = 0x104
Jun 28 12:00:01 localhost kernel: scsi0: SCBPTR == 0x25, SCB_NEXT == 0xff80, SCB_NEXT2 == 0xff35
Jun 28 12:00:01 localhost kernel: CDB 28 0 7 76 d4 b9
Jun 28 12:00:01 localhost kernel: STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
Jun 28 12:00:01 localhost kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Jun 28 12:00:01 localhost kernel: LQICRC_NLQ
Jun 28 12:00:01 localhost kernel: LQIRETRY for LQIPHASE_OUTPKT
Jun 28 12:00:01 localhost kernel: scsi0: Returning to Idle Loop



-- 
Andrea Carpani <andrea.carpani@criticalpath.net>
Critical Path

