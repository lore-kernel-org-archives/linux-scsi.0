From: Bryce as root <root@www.linux.org.uk>
Subject: Re: aic79xx blowups in 2.6.8-1.521smp (RHAT)
Date: Thu, 7 Oct 2004 11:48:20 +0100 (BST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1CFVoq-0004N7-JX@www.linux.org.uk>
References: <1096898453.1748.9.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:41674 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S269786AbUJGKsV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Oct 2004 06:48:21 -0400
In-Reply-To: <1096898453.1748.9.camel@mulgrave> from "James Bottomley" at Oct 04, 2004 09:00:47 AM
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Detail preamble:
Linux ZenIV.linux.org.uk 2.6.8-1.521smp #1 SMP Mon Aug 16 09:25:06 EDT 2004 i686 i686 i386 GNU/Linux
SCSI subsystem initialized
ACPI: PCI interrupt 0000:03:0a.0[A] -> GSI 22 (level, low) -> IRQ 217
ACPI: PCI interrupt 0000:03:0a.1[B] -> GSI 19 (level, low) -> IRQ 177
scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 1.3.11
        <Adaptec AIC7902 Ultra320 SCSI adapter>
        aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI 33 or 66Mhz, 512 SCBs

(scsi0:A:0): 80.000MB/s transfers (40.000MHz DT, 16bit)
  Vendor: SEAGATE   Model: ST336753LW        Rev: 0006
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi0:A:0:0: Tagged Queuing enabled.  Depth 4
SCSI device sda: 71687372 512-byte hdwr sectors (36704 MB)
SCSI device sda: drive cache: write back
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0


Mutterings:
Well I set the BIOS down to 160 and turned off Packeting and QAS and let
that run for a day

( http://ftp.linux.org.uk/~bryce/scsi-bios.gif )

Unfortunately the driver has blown up in a different way now.
I'm at a bit of a loss as to whats going on as the disk verifies
fine from the adaptec bios utils

I've now set the speed to 80 so we'll see how this goes though it's a shame
to loose the performance as a result in the drop (was 71MB/s now 61MB/s)

Phil
=--=

Logfile:
04:04:18 (scsi0:A:0:0): Unexpected busfree in DT Data-in phase, 1 SCBs aborted, PRGMCNT == 0x2e 
04:04:18 >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<< 
04:04:18 scsi0: Dumping Card State at program address 0x2c Mode 0x22 
04:04:18 Card was paused 
04:04:18 HS_MAILBOX[0x0] INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11]  
04:04:18 DFFSTAT[0x11] SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0]  
04:04:18 LASTPHASE[0x60] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x10]  
04:04:18 SEQINTCTL[0x0] SEQ_FLAGS[0x20] SEQ_FLAGS2[0x0] SSTAT0[0x0]  
04:04:18 SSTAT1[0x9] SSTAT2[0xc0] SSTAT3[0x0] PERRDIAG[0x1]  
04:04:18 SIMODE1[0xac] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0]  
04:04:19 LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0]  
04:04:19  
04:04:19 SCB Count = 4 CMDS_PENDING = 1 LASTSCB 0x3 CURRSCB 0x3 NEXTSCB 0x0 
04:04:19 qinstart = 24363 qinfifonext = 24363 
04:04:20 QINFIFO: 
04:04:20 WAITING_TID_QUEUES: 
04:04:20 Pending list: 
04:04:20 Total 0 
04:04:20 Kernel Free SCB list: 3 0 1 2  
04:04:20 Sequencer Complete DMA-inprog list:  
04:04:20 Sequencer Complete list:  
04:04:20 Sequencer DMA-Up and Complete list:  
04:04:20  
04:04:20 scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0 
04:04:20 SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]  
04:04:21 SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]  
04:04:21 SOFFCNT[0x21] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0  
04:04:21 HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x0]  
04:04:21 scsi0: FIFO1 Active, LONGJMP == 0x1ec, SCB 0x3 
04:04:21 SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x8] DFSTATUS[0x1]  
04:04:21 SG_CACHE_SHADOW[0x28] SG_STATE[0x3] DFFSXFRCTL[0x0]  
04:04:21 SOFFCNT[0x21] MDFFSTAT[0xc] SHADDR = 0x0318ebe5e, SHCNT = 0x1a2  
04:04:21 HADDR = 0x0318ebec2, HCNT = 0x13e CCSGCTL[0x10]  
04:04:21 LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0  
04:04:21 scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x42 
04:04:21 scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0 
04:04:21 SIMODE0[0xc]  
04:04:21 CCSCBCTL[0x4]  
04:04:21 scsi0: REG0 == 0x3, SINDEX = 0x122, DINDEX = 0xa9 
04:04:21 scsi0: SCBPTR == 0xff03, SCB_NEXT == 0xff00, SCB_NEXT2 == 0x0 
04:04:21 CDB 3 1 0 0 0 0 
04:04:22 STACK: 0x206 0x0 0x0 0x0 0x0 0x0 0x0 0x29 
04:04:22 <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>> 
04:04:22 DevQ(0:0:0): 0 waiting 
04:04:22 SCSI error : <0 0 0 0> return code = 0x10000 
04:04:22 end_request: I/O error, dev sda, sector 4239969 
04:04:22 SCSI error : <0 0 0 0> return code = 0x10000 
04:04:22 end_request: I/O error, dev sda, sector 4239977 
04:04:22 SCSI error : <0 0 0 0> return code = 0x10000 
04:04:22 end_request: I/O error, dev sda, sector 4239985 
04:04:22 SCSI error : <0 0 0 0> return code = 0x10000 
04:04:22 end_request: I/O error, dev sda, sector 4239993 
04:04:22 SCSI error : <0 0 0 0> return code = 0x10000 
04:04:22 end_request: I/O error, dev sda, sector 4240001 
04:04:22 (scsi0:A:0:0): No or incomplete CDB sent to device. 
04:04:23 scsi0: Issued Channel A Bus Reset. 1 SCBs aborted 
04:04:23 SCSI error : <0 0 0 0> return code = 0x8000002 
04:04:23 Info fld=0x0, Current sda: sense key Aborted Command 
04:04:23 end_request: I/O error, dev sda, sector 4240009 
04:04:23 SCSI error : <0 0 0 0> return code = 0x8000002 
04:04:23 Info fld=0x0, Current sda: sense key Aborted Command 
04:04:23 end_request: I/O error, dev sda, sector 4240017 
04:04:23 SCSI error : <0 0 0 0> return code = 0x8000002 
04:04:23 Info fld=0x0, Current sda: sense key Aborted Command 
04:04:23 end_request: I/O error, dev sda, sector 68860388 
04:04:23 Buffer I/O error on device sda7, logical block 2187565 
04:04:23 lost page write due to I/O error on sda7 
04:04:23 SCSI error : <0 0 0 0> return code = 0x8000002 
04:04:23 Info fld=0x0, Current sda: sense key Aborted Command 
04:04:23 end_request: I/O error, dev sda, sector 68860396 
04:04:25 end_request: I/O error, dev sda, sector 4240041 
04:04:25 (scsi0:A:0): 160.000MB/s transfers (80.000MHz DT, 16bit) 
04:04:25 (scsi0:A:0:0): Unexpected busfree in DT Data-in phase, 1 SCBs aborted, PRGMCNT == 0x97 
04:04:25 >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<< 
04:04:25 scsi0: Dumping Card State at program address 0x95 Mode 0x22 
04:04:25 Card was paused 
04:04:25 HS_MAILBOX[0x0] INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11]  
04:04:25 DFFSTAT[0x11] SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0]  
04:04:25 LASTPHASE[0x60] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x10]  
04:04:25 SEQINTCTL[0x80] SEQ_FLAGS[0x20] SEQ_FLAGS2[0x0] SSTAT0[0x0]  
04:04:25 SSTAT1[0x9] SSTAT2[0xc0] SSTAT3[0x0] PERRDIAG[0x1]  
04:04:25 SIMODE1[0xac] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0]  
04:04:26 LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0]  
04:04:26  
04:04:26 SCB Count = 4 CMDS_PENDING = 1 LASTSCB 0x1 CURRSCB 0x1 NEXTSCB 0x0 
04:04:26 qinstart = 87 qinfifonext = 87 
04:04:26 QINFIFO: 
04:04:26 WAITING_TID_QUEUES: 
04:04:26 Pending list: 
04:04:26 Total 0 
04:04:26 Kernel Free SCB list: 1 0 3 2  
04:04:26 Sequencer Complete DMA-inprog list:  
04:04:26 Sequencer Complete list:  
04:04:26 Sequencer DMA-Up and Complete list:  
04:04:26  
04:04:26 scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0 
04:04:26 SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]  
04:04:26 SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]  
04:04:26 SOFFCNT[0x1d] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0  
04:04:27 HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x0]  
04:04:27 scsi0: FIFO1 Active, LONGJMP == 0x1ec, SCB 0x1 
04:04:27 SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x8] DFSTATUS[0x81]  
04:04:27 SG_CACHE_SHADOW[0x20] SG_STATE[0x3] DFFSXFRCTL[0x0]  
04:04:27 SOFFCNT[0x1d] MDFFSTAT[0xc] SHADDR = 0x05a68f1ac, SHCNT = 0xe54  
04:04:27 HADDR = 0x05a68f20a, HCNT = 0xdf6 CCSGCTL[0x10]  
04:04:27 LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0  
04:04:27 scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x42 
04:04:27 scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0 
04:04:27 SIMODE0[0xc]  
04:04:27 CCSCBCTL[0x4]  
04:04:27 scsi0: REG0 == 0x1, SINDEX = 0x122, DINDEX = 0x1ba 
04:04:27 scsi0: SCBPTR == 0xff01, SCB_NEXT == 0xff00, SCB_NEXT2 == 0x0 
04:04:27 CDB 1 1 0 0 0 0 
04:04:27 STACK: 0x29 0x206 0x0 0x0 0x0 0x0 0x0 0x0 
04:04:27 <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>> 
04:04:28 DevQ(0:0:0): 0 waiting 
04:04:28 SCSI error : <0 0 0 0> return code = 0x10000 
04:04:28 end_request: I/O error, dev sda, sector 4239913 
04:04:28 SCSI error : <0 0 0 0> return code = 0x10000 
04:04:28 (scsi0:A:0:0): No or incomplete CDB sent to device.
04:04:28 scsi0: Issued Channel A Bus Reset. 1 SCBs aborted
04:04:28 (scsi0:A:0): 80.000MB/s transfers (40.000MHz DT, 16bit)
04:04:28 SCSI error : <0 0 0 0> return code = 0x8000002
04:04:29 Info fld=0x0, Current sda: sense key Aborted Command
04:04:29 end_request: I/O error, dev sda, sector 4239953
04:04:29 SCSI error : <0 0 0 0> return code = 0x8000002
04:04:29 Info fld=0x0, Current sda: sense key Aborted Command
04:04:29 end_request: I/O error, dev sda, sector 51398828
04:04:29 Buffer I/O error on device sda7, logical block 4870
04:04:29 lost page write due to I/O error on sda7
04:04:29 Aborting journal on device sda7.
04:04:29 journal commit I/O error
04:04:29 ext3_abort called.
04:04:29 EXT3-fs abort (device sda7): ext3_journal_start: Detected aborted journal
04:04:29 Remounting filesystem read-only


> 
> On Mon, 2004-10-04 at 07:24, Bryce as root wrote:
> > kernel dmesg dump :
> > Reseting Channel for LQI Phase error
> 
> This is clearly the cause of all the trouble.  The driver is a bit
> opaque at this point, but it looks like an LQI phase error occurs
> because of a phase mismatch during L_Q Information Units (These are a
> requirement for fast-160 data transfers).
> 
> I think this is a strong indicator of bus instability ... could you try
> falling back to fast-80 and turning off IU transfers (You'll probably
> either have to use the card bios or dig around in the aic79xx driver for
> the options).
> 
> James
> 
> 
> 

