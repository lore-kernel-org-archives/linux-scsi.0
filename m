From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: aic79xx blowups in 2.6.8-1.521smp (RHAT)
Date: Tue, 05 Oct 2004 10:04:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4162AA06.3000706@adaptec.com>
References: <E1CERtQ-0001CV-9T@www.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:6557 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S269164AbUJEOFE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2004 10:05:04 -0400
In-Reply-To: <E1CERtQ-0001CV-9T@www.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Bryce as root <root@www.linux.org.uk>
Cc: linux-scsi@vger.kernel.org

Is it possible that you try Revision 007 or later?

	Luben


Bryce as root wrote:
> <sigh> where to start,..
> 
> I have a system which has an onboard aic79xx controller
> 
> lspci -vv :
> 03:0a.0 SCSI storage controller: Adaptec AIC-7902 U320 (rev 03)
>         Subsystem: Adaptec: Unknown device ffff
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
>         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 32 (10000ns min, 6250ns max), Cache Line Size 08
>         Interrupt: pin A routed to IRQ 217
>         Region 0: I/O ports at 7c00 [disabled]
>         Region 1: Memory at f3008000 (64-bit, non-prefetchable) [size=8K]
>         Region 3: I/O ports at 8000 [disabled] [size=256]
>         Capabilities: [dc] Power Management version 1
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [a0] Message Signalled Interrupts: 64bit+ Queue=0/1 Enable-
>                 Address: 0000000000000000  Data: 0000
>         Capabilities: [94] PCI-X non-bridge device.
>                 Command: DPERE- ERO+ RBC=0 OST=4
>                 Status: Bus=255 Dev=31 Func=0 64bit+ 133MHz+ SCD- USC-, DC=simple, DMMRBC=0, DMOST=4, DMCRS=1, RSCEM-
> 
> This is connected by certified U320 cable to a 15K U320 Seagate 37Gb drive
> 
> SCSI subsystem initialized
> ACPI: PCI interrupt 0000:03:0a.0[A] -> GSI 22 (level, low) -> IRQ 217
> ACPI: PCI interrupt 0000:03:0a.1[B] -> GSI 19 (level, low) -> IRQ 177
> scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 1.3.11
>         <Adaptec AIC7902 Ultra320 SCSI adapter>
>         aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI 33 or 66Mhz, 512 SCBs
> 
> (scsi0:A:0): 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
>   Vendor: SEAGATE   Model: ST336753LW        Rev: 0006
>   Type:   Direct-Access                      ANSI SCSI revision: 03
> scsi0:A:0:0: Tagged Queuing enabled.  Depth 4
> SCSI device sda: 71687372 512-byte hdwr sectors (36704 MB)
> SCSI device sda: drive cache: write back
>  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
> Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
> scsi1 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 1.3.11
>         <Adaptec AIC7902 Ultra320 SCSI adapter>
>         aic7902: Ultra320 Wide Channel B, SCSI Id=7, PCI 33 or 66Mhz, 512 SCBs
> 
> Ok, to the problem itself. I've found that the system will choke badly after
> anything from a few days to a couple of weeks, always over a LQI Phase error.
> I've asked around to help work out what the LQI Phase error is about and
> I still don't understand it.
> 
> kernel dmesg dump :
> Reseting Channel for LQI Phase error
> 
>>>>>>>>>>>>>>>>>>>Dump Card State Begins <<<<<<<<<<<<<<<<<
> 
> scsi0: Dumping Card State at program address 0x8 Mode 0x33
> Card was paused
> HS_MAILBOX[0x0] INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] 
> DFFSTAT[0x11] SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0] 
> LASTPHASE[0x1] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x10] 
> SEQINTCTL[0x0] SEQ_FLAGS[0x0] SEQ_FLAGS2[0x0] SSTAT0[0x0] 
> SSTAT1[0x9] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x0] 
> SIMODE1[0xa4] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] 
> LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x1] 
> 
> SCB Count = 4 CMDS_PENDING = 2 LASTSCB 0x1 CURRSCB 0x0 NEXTSCB 0xff00
> qinstart = 40786 qinfifonext = 40786
> QINFIFO:
> WAITING_TID_QUEUES:
> Pending list:
>   0 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
>   1 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
> Total 2
> Kernel Free SCB list: 2 3 
> Sequencer Complete DMA-inprog list: 
> Sequencer Complete list: 
> Sequencer DMA-Up and Complete list: 
> 
> scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x1
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x66] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x88] 
> scsi0: FIFO1 Active, LONGJMP == 0x257, SCB 0x1
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x8] DFSTATUS[0x0] 
> SG_CACHE_SHADOW[0x30] SG_STATE[0x6] DFFSXFRCTL[0x0] 
> SOFFCNT[0x66] MDFFSTAT[0xa] SHADDR = 0x06c420c04, SHCNT = 0x3fc 
> HADDR = 0x06c420ce0, HCNT = 0x320 CCSGCTL[0x98] 
> LQIN: 0x4 0x0 0x0 0x1 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x32 0x0 0x0 0x0 0
> x2 0x0 
> scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x42
> scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x2
> SIMODE0[0xc] 
> CCSCBCTL[0x4] 
> scsi0: REG0 == 0x3, SINDEX = 0x133, DINDEX = 0x102
> scsi0: SCBPTR == 0x0, SCB_NEXT == 0xff00, SCB_NEXT2 == 0xff11
> CDB 28 0 1 93 e9 d6
> STACK: 0x125 0x0 0x0 0x257 0x240 0x93 0x29 0x1
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> DevQ(0:0:0): 0 waiting
> SCSI error : <0 0 0 0> return code = 0x10000
> end_request: I/O error, dev sda, sector 26470870
> SCSI error : <0 0 0 0> return code = 0x10000
> end_request: I/O error, dev sda, sector 26470878
> SCSI error : <0 0 0 0> return code = 0x10000
> end_request: I/O error, dev sda, sector 26470886
> SCSI error : <0 0 0 0> return code = 0x10000
> end_request: I/O error, dev sda, sector 26470894
> SCSI error : <0 0 0 0> return code = 0x8000002
> Info fld=0x0, Current sda: sense key Aborted Command
> end_request: I/O error, dev sda, sector 26470766
> SCSI error : <0 0 0 0> return code = 0x8000002
> Info fld=0x0, Current sda: sense key Aborted Command
> end_request: I/O error, dev sda, sector 26470774
> SCSI error : <0 0 0 0> return code = 0x8000002
> Info fld=0x0, Current sda: sense key Aborted Command
> end_request: I/O error, dev sda, sector 51448252
> Buffer I/O error on device sda7, logical block 11048
> lost page write due to I/O error on sda7
> SCSI error : <0 0 0 0> return code = 0x8000002
> Info fld=0x0, Current sda: sense key Aborted Command
> end_request: I/O error, dev sda, sector 26470782
> SCSI error : <0 0 0 0> return code = 0x8000002
> Info fld=0x0, Current sda: sense key Aborted Command
> end_request: I/O error, dev sda, sector 68501204
> Buffer I/O error on device sda7, logical block 2142667
> lost page write due to I/O error on sda7
> (scsi0:A:0): 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
> 
> 
> When the system is up and running, the disk is stable and I
> get a quite respectable 72MB/s max throughput.
> 
> I have other card dumps however since this isn't my area of expertise I've
> not included them as they're roughly the same problem always starting off
> with a "Reseting Channel for LQI Phase error" error.
> 
> I should mention that I have a sister machine with the exact same HW 
> that exhibits the issues and though not a 100% indication, it
> would suggest the issue is more to do with the driver.
> 
> I did also try to rebuild the kernel with aic79xx-linux-2.6-20040522-tar.gz
> however I've not run it long enough on the box to say that it fixes the issue
> 
> Ideas anyone? or shall I just keep banging on 2.0.12 and hope it fixes/masks
> the problem?
> 
> Phil
> =--=
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

