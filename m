From: hong.ye@adic.com
Subject: RE: adaptec problem (now LSI U320 problem)
Date: Fri, 2 May 2003 06:36:54 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <995FF289C9D69747A09E429926445954014B9A28@penguin.adic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [63.81.117.28] ([63.81.117.28]:37864 "EHLO penguin.adic.com")
	by vger.kernel.org with ESMTP id S262894AbTEBN2M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2003 09:28:12 -0400
List-Id: linux-scsi@vger.kernel.org
To: andrew.r.cress@intel.com, invictus_rm@hotmail.com
Cc: linux-scsi@vger.kernel.org

What's your PCI bus clock rate. For LSI 1030 driver, PCI bus clock rate need to be 66MHZ or 133MHZ. I had similar problem before and I found that 1030 driver won't work properly if PCI bus clock rate is 33MHZ.

Hong 

-----Original Message-----
From: Cress, Andrew R [mailto:andrew.r.cress@intel.com] 
Sent: Friday, May 02, 2003 9:35 AM
To: 'invictus rm'
Cc: 'linux-scsi@vger.kernel.org'
Subject: RE: adaptec problem (now LSI U320 problem)

I notice that the lsil.com web site has a 2.05.00 version of the FusionMPT
driver.  Perhaps that would help.

Andy

-----Original Message-----
From: invictus rm [mailto:invictus_rm@hotmail.com] 
Sent: Wednesday, April 30, 2003 12:25 PM
To: linux-scsi@vger.kernel.org
Cc: andrew.r.cress@intel.com
Subject: RE: adaptec problem !!!


Thanks Andrew,
    By making the termination proper, the HDD + Adaptec is working fine.

    But now i am facing another problem....

   With the same HDD and termination I tried using the LSI53C1030 with
   the same kernel(2.4.18) on the same PCI slot.

   But to my disappointment the bootup sequence came up with the
   following logs.
   On putting the Adaptec HBA again , to check whether any termination
   related problem, it seems to work fine .
   Its a problem only when i attach LSI53C1030

LOGS
=====

Fusion MPT base driver 2.02.01
Copyright (c) 1999-2002 LSI Logic Corporation
mptbase: Initiating ioc0 bringup
ioc0: 53C1030: Capabilities={Initiator}
mptbase: Initiating ioc1 bringup
ioc1: 53C1030: Capabilities={Initiator}
mptbase: Initiating ioc1 recovery
mptbase: Initiating ioc1 recovery
mptbase: Initiating ioc1 recovery
mptbase: Initiating ioc1 recovery
mptbase: 2 MPT adapters found, 2 installed.
Fusion MPT SCSI Host driver 2.02.01
scsi0 : ioc0: LSI53C1030, FwRev=01000000h, Ports=1, MaxQ=255, IRQ=91
scsi1 : ioc1: LSI53C1030, FwRev=01000000h, Ports=1, MaxQ=255, IRQ=-1
  Vendor: SEAGATE   Model: ST39140LC         Rev: 1503
  Type:   Direct-Access                      ANSI SCSI revision: 02
scsi : aborting command due to timeout : pid 16, scsi1, channel 0, id 0, lun

0 I
nquiry 00 00 00 ff 00
mptscsih: OldAbort scheduling ABORT SCSI IO (sc=dfe75e00)
  IOs outstanding = 1
mptscsih: ioc1: Issue of TaskMgmt Successful!
SCSI host 1 abort (pid 16) timed out - resetting
SCSI bus is being reset for host 1 channel 0.
mptscsih: OldReset scheduling BUS_RESET (sc=dfe75e00)
  IOs outstanding = 1
SCSI host 1 channel 0 reset (pid 16) timed out - trying harder
SCSI bus is being reset for host 1 channel 0.
mptscsih: OldReset scheduling BUS_RESET (sc=dfe75e00)
  IOs outstanding = 1
SCSI host 1 reset (pid 16) timed out again -
probably an unrecoverable SCSI bus or device hang.
mptbase: Initiating ioc1 recovery
SCSI host 1 reset (pid 18) timed out again -
probably an unrecoverable SCSI bus or device hang.



Thanks for all the help  extended so far

rgds
rm







>From: "Cress, Andrew R" <andrew.r.cress@intel.com>
>To: "'invictus rm'" <invictus_rm@hotmail.com>, linux-scsi@vger.kernel.org
>Subject: RE: adaptec problem !!!
>Date: Tue, 29 Apr 2003 06:45:40 -0700
>
>You didn't say, but I assume that this hardware configuration hasn't been
>tested
>with any OS successfully yet, so we need to check out the hardware side
>first.
>Something is apparently wrong with the SCSI cabling or termination.
>My guess would be that it is not properly terminated.
>
>Basically, you need one termination at each end of the SCSI cable.
>The Adaptec BIOS menus show whether or not the adapter has termination on 
>or
>off.
>The disk mode pages (or jumpers) show whether the disk has termination on 
>or
>off.
>Or, there may be an active terminator on the SCSI cable.
>If you have an active terminator and the disk has termination turned on, 
>you
>may be
>doubly terminated.  Or if neither one is terminated, that would also be a
>problem.
>
>If termination is ok, try swapping the SCSI cable.
>
>Andy
>
>-----Original Message-----
>From: invictus rm [mailto:invictus_rm@hotmail.com]
>Sent: Tuesday, April 29, 2003 9:22 AM
>To: linux-scsi@vger.kernel.org
>Subject: adaptec problem !!!
>
>
>
>Hi ,
>I am trying to make an adaptec SCSI HBA work with a hard disk attached to 
>my
>
>IBM 750FX board on a PCI slot(linux-2.4.19 from Monta Vista website).
>The following bootup message summarises the problem.
>
>As my knowledege of SCSI is very limited, it would of great help if smebdy
>can decode the error message . Is it a problem with PCI configuration ??
>
>Any help in this regard will be highly appreciated.
>
>BOOTUPLOG
>=========
>
>SCSI subsystem driver Revision: 1.00
>scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.8
>         <Adaptec 29160 Ultra160 SCSI adapter>
>         aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
>
>blk: queue c09b0c18, I/O limit 4095Mb (mask 0xffffffff)
>
>   Vendor: SEAGATE   Model: ST39140LC         Rev: 1503
>   Type:   Direct-Access                      ANSI SCSI revision: 02
>
>blk: queue c09b0e18, I/O limit 4095Mb (mask 0xffffffff)
>
>(scsi0:A:0): 80.000MB/s transfers (40.000MHz, offset 15, 16bit)
>(scsi0:A:0:1): parity error detected in Data-in phase. SEQADDR(0x1a3)
>SCSIRATE(0
>x93)
>scsi0:0:0:1: Attempting to queue an ABORT message
>scsi0: Dumping Card State in Message-in phase, at SEQADDR 0x169
>ACCUM = 0x1, SINDEX = 0x81, DINDEX = 0x21, ARG_2 = 0xff
>HCNT = 0x0 SCBPTR = 0x0
>SCSISEQ = 0x12, SBLKCTL = 0xa
>DFCNTRL = 0x0, DFSTATUS = 0x88
>LASTPHASE = 0xe0, SCSISIGI = 0x54, SXFRCTL0 = 0x88
>SSTAT0 = 0x0, SSTAT1 = 0x5
>SCSIPHASE = 0x2
>STACK == 0x34, 0x0, 0x160, 0x167
>SCB count = 4
>Kernel NEXTQSCB = 3
>Card NEXTQSCB = 3
>QINFIFO entries:
>Waiting Queue entries:
>Disconnected Queue entries:
>QOUTFIFO entries:
>Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
>21 2
>2 23 24 25 26 27 28 29 30 31
>Sequencer SCB Info: 0(c 0x40, s 0x7, l 1, t 0x2) 1(c 0x0, s 0xff, l 255, t
>0xff)
>2(c 0x0, s 0xff, l 255, t 0xff) 3(c 0x0, s 0xff, l 255, t 0xff) 4(c 0x0, s
>0xff
>, l 255, t 0xff) 5(c 0x0, s 0xff, l 255, t 0xff) 6(c 0x0, s 0xff, l 255, t
>0xff)
>7(c 0x0, s 0xff, l 255, t 0xff) 8(c 0x0, s 0xff, l 255, t 0xff) 9(c 0x0, s
>0xff
>, l 255, t 0xff) 10(c 0x0, s 0xff, l 255, t 0xff) 11(c 0x0, s 0xff, l 255, 
>t
>
>0xf
>f) 12(c 0x0, s 0xff, l 255, t 0xff) 13(c 0x0, s 0xff, l 255, t 0xff) 14(c
>0x0, s
>0xff, l 255, t 0xff) 15(c 0x0, s 0xff, l 255, t 0xff) 16(c 0x0, s 0xff, l
>255,
>t 0xff) 17(c 0x0, s 0xff, l 255, t 0xff) 18(c 0x0, s 0xff, l 255, t 0xff)
>19(c 0
>x0, s 0xff, l 255, t 0xff) 20(c 0x0, s 0xff, l 255, t 0xff) 21(c 0x0, s
>0xff, l
>255, t 0xff) 22(c 0x0, s 0xff, l 255, t 0xff) 23(c 0x0, s 0xff, l 255, t
>0xff) 2
>4(c 0x0, s 0xff, l 255, t 0xff) 25(c 0x0, s 0xff, l 255, t 0xff) 26(c 0x0, 
>s
>
>0xf
>f, l 255, t 0xff) 27(c 0x0, s 0xff, l 255, t 0xff) 28(c 0x0, s 0xff, l 255,
>t 0x
>ff) 29(c 0x0, s 0xff, l 255, t 0xff) 30(c 0x0, s 0xff, l 255, t 0xff) 31(c
>0x0,
>s 0xff, l 255, t 0xff)
>Pending list: 2(c 0x40, s 0x7, l 1)
>Kernel Free SCB list: 1 0
>Untagged Q(0): 2
>DevQ(0:0:0): 0 waiting
>DevQ(0:0:1): 0 waiting
>scsi0:0:0:1: Device is active, asserting ATN
>Recovery code sleeping
>Recovery code awake
>Timer Expired
>aic7xxx_abort returns 0x2003
>scsi0:0:0:1: Attempting to queue a TARGET RESET message
>aic7xxx_dev_reset returns 0x2003
>Recovery SCB completes
>(scsi0:A:0:1): parity error detected in Data-in phase. SEQADDR(0x1a3)
>SCSIRATE(0
>x93)
>scsi0:0:0:1: Attempting to queue an ABORT message
>scsi0: Dumping Card State in Command phase, at SEQADDR 0x167
>ACCUM = 0x80, SINDEX = 0x81, DINDEX = 0xe4, ARG_2 = 0x0
>HCNT = 0x0 SCBPTR = 0x0
>SCSISEQ = 0x12, SBLKCTL = 0xa
>DFCNTRL = 0x4, DFSTATUS = 0x88
>LASTPHASE = 0x80, SCSISIGI = 0x54, SXFRCTL0 = 0x88
>SSTAT0 = 0x5, SSTAT1 = 0x5
>SCSIPHASE = 0x2
>STACK == 0x34, 0x167, 0x34, 0x167
>SCB count = 4
>Kernel NEXTQSCB = 2
>Card NEXTQSCB = 2
>QINFIFO entries:
>Waiting Queue entries:
>Disconnected Queue entries:
>QOUTFIFO entries:
>Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
>21 2
>2 23 24 25 26 27 28 29 30 31
>Sequencer SCB Info: 0(c 0x0, s 0x7, l 1, t 0x3) 1(c 0x0, s 0xff, l 255, t
>0xff)
>2(c 0x0, s 0xff, l 255, t 0xff) 3(c 0x0, s 0xff, l 255, t 0xff) 4(c 0x0, s
>0xff,
>l 255, t 0xff) 5(c 0x0, s 0xff, l 255, t 0xff) 6(c 0x0, s 0xff, l 255, t
>0xff)
>7(c 0x0, s 0xff, l 255, t 0xff) 8(c 0x0, s 0xff, l 255, t 0xff) 9(c 0x0, s
>0xff,
>l 255, t 0xff) 10(c 0x0, s 0xff, l 255, t 0xff) 11(c 0x0, s 0xff, l 255, t
>0xff
>) 12(c 0x0, s 0xff, l 255, t 0xff) 13(c 0x0, s 0xff, l 255, t 0xff) 14(c
>0x0, s
>0xff, l 255, t 0xff) 15(c 0x0, s 0xff, l 255, t 0xff) 16(c 0x0, s 0xff, l
>255, t
>0xff) 17(c 0x0, s 0xff, l 255, t 0xff) 18(c 0x0, s 0xff, l 255, t 0xff) 
>19(c
>
>0x
>0, s 0xff, l 255, t 0xff) 20(c 0x0, s 0xff, l 255, t 0xff) 21(c 0x0, s 
>0xff,
>
>l 2
>55, t 0xff) 22(c 0x0, s 0xff, l 255, t 0xff) 23(c 0x0, s 0xff, l 255, t
>0xff) 24
>(c 0x0, s 0xff, l 255, t 0xff) 25(c 0x0, s 0xff, l 255, t 0xff) 26(c 0x0, s
>0xff
>, l 255, t 0xff) 27(c 0x0, s 0xff, l 255, t 0xff) 28(c 0x0, s 0xff, l 255, 
>t
>
>0xf
>f) 29(c 0x0, s 0xff, l 255, t 0xff) 30(c 0x0, s 0xff, l 255, t 0xff) 31(c
>0x0, s
>0xff, l 255, t 0xff)
>Pending list: 3(c 0x0, s 0x7, l 1)
>Kernel Free SCB list: 1 0
>Untagged Q(0): 3
>DevQ(0:0:0): 0 waiting
>DevQ(0:0:1): 0 waiting
>scsi0:0:0:1: Device is active, asserting ATN
>Recovery code sleeping
>Recovery code awake
>aic7xxx_abort returns 0x2002
>scsi: device set offline - not ready or command retry failed after bus
>reset: ho
>st 0 channel 0 id 0 lun 1
>
>scsi0:0:1:0: Attempting to queue an ABORT message
>scsi0: Dumping Card State in Command phase, at SEQADDR 0x167
>ACCUM = 0x80, SINDEX = 0x81, DINDEX = 0xe4, ARG_2 = 0x0
>HCNT = 0x0 SCBPTR = 0x0
>SCSISEQ = 0x12, SBLKCTL = 0xa
>DFCNTRL = 0x4, DFSTATUS = 0x88
>LASTPHASE = 0x80, SCSISIGI = 0x54, SXFRCTL0 = 0x88
>SSTAT0 = 0x5, SSTAT1 = 0x5
>SCSIPHASE = 0x2
>STACK == 0x34, 0x167, 0x34, 0x167
>SCB count = 4
>Kernel NEXTQSCB = 1
>Card NEXTQSCB = 2
>QINFIFO entries: 2
>Waiting Queue entries:
>Disconnected Queue entries:
>QOUTFIFO entries:
>Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
>21 2
>2 23 24 25 26 27 28 29 30 31
>Sequencer SCB Info: 0(c 0x0, s 0x7, l 1, t 0x3) 1(c 0x0, s 0xff, l 255, t
>0xff)
>2(c 0x0, s 0xff, l 255, t 0xff) 3(c 0x0, s 0xff, l 255, t 0xff) 4(c 0x0, s
>0xff,
>l 255, t 0xff) 5(c 0x0, s 0xff, l 255, t 0xff) 6(c 0x0, s 0xff, l 255, t
>0xff)
>7(c 0x0, s 0xff, l 255, t 0xff) 8(c 0x0, s 0xff, l 255, t 0xff) 9(c 0x0, s
>0xff,
>l 255, t 0xff) 10(c 0x0, s 0xff, l 255, t 0xff) 11(c 0x0, s 0xff, l 255, t
>0xff
>) 12(c 0x0, s 0xff, l 255, t 0xff) 13(c 0x0, s 0xff, l 255, t 0xff) 14(c
>0x0, s
>0xff, l 255, t 0xff) 15(c 0x0, s 0xff, l 255, t 0xff) 16(c 0x0, s 0xff, l
>255, t
>0xff) 17(c 0x0, s 0xff, l 255, t 0xff) 18(c 0x0, s 0xff, l 255, t 0xff) 
>19(c
>
>0x
>0, s 0xff, l 255, t 0xff) 20(c 0x0, s 0xff, l 255, t 0xff) 21(c 0x0, s 
>0xff,
>
>l 2
>55, t 0xff) 22(c 0x0, s 0xff, l 255, t 0xff) 23(c 0x0, s 0xff, l 255, t
>0xff) 24
>(c 0x0, s 0xff, l 255, t 0xff) 25(c 0x0, s 0xff, l 255, t 0xff) 26(c 0x0, s
>0xff
>, l 255, t 0xff) 27(c 0x0, s 0xff, l 255, t 0xff) 28(c 0x0, s 0xff, l 255, 
>t
>
>0xf
>f) 29(c 0x0, s 0xff, l 255, t 0xff) 30(c 0x0, s 0xff, l 255, t 0xff) 31(c
>0x0, s
>0xff, l 255, t 0xff)
>Pending list: 2(c 0x40, s 0x17, l 0), 3(c 0x0, s 0x7, l 1)
>Kernel Free SCB list: 0
>Untagged Q(0): 3
>Untagged Q(1): 2
>DevQ(0:0:0): 0 waiting
>DevQ(0:0:1): 0 waiting
>DevQ(0:1:0): 0 waiting
>scsi0:0:1:0: Cmd aborted from QINFIFO
>aic7xxx_abort returns 0x2002
>scsi0:0:1:0: Attempting to queue an ABORT message
>scsi0: Dumping Card State in Command phase, at SEQADDR 0x167
>ACCUM = 0x80, SINDEX = 0x81, DINDEX = 0xe4, ARG_2 = 0x0
>HCNT = 0x0 SCBPTR = 0x0
>SCSISEQ = 0x12, SBLKCTL = 0xa
>DFCNTRL = 0x4, DFSTATUS = 0x88
>LASTPHASE = 0x80, SCSISIGI = 0x54, SXFRCTL0 = 0x88
>SSTAT0 = 0x5, SSTAT1 = 0x5
>SCSIPHASE = 0x2
>STACK == 0x34, 0x167, 0x34, 0x167
>SCB count = 4
>Kernel NEXTQSCB = 2
>Card NEXTQSCB = 1
>QINFIFO entries: 1
>Waiting Queue entries:
>Disconnected Queue entries:
>QOUTFIFO entries:
>Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
>21 2
>2 23 24 25 26 27 28 29 30 31
>Sequencer SCB Info: 0(c 0x0, s 0x7, l 1, t 0x3) 1(c 0x0, s 0xff, l 255, t
>0xff)
>2(c 0x0, s 0xff, l 255, t 0xff) 3(c 0x0, s 0xff, l 255, t 0xff) 4(c 0x0, s
>0xff,
>l 255, t 0xff) 5(c 0x0, s 0xff, l 255, t 0xff) 6(c 0x0, s 0xff, l 255, t
>0xff)
>7(c 0x0, s 0xff, l 255, t 0xff) 8(c 0x0, s 0xff, l 255, t 0xff) 9(c 0x0, s
>0xff,
>l 255, t 0xff) 10(c 0x0, s 0xff, l 255, t 0xff) 11(c 0x0, s 0xff, l 255, t
>0xff
>) 12(c 0x0, s 0xff, l 255, t 0xff) 13(c 0x0, s 0xff, l 255, t 0xff) 14(c
>0x0, s
>0xff, l 255, t 0xff) 15(c 0x0, s 0xff, l 255, t 0xff) 16(c 0x0, s 0xff, l
>255, t
>0xff) 17(c 0x0, s 0xff, l 255, t 0xff) 18(c 0x0, s 0xff, l 255, t 0xff) 
>19(c
>
>0x
>0, s 0xff, l 255, t 0xff) 20(c 0x0, s 0xff, l 255, t 0xff) 21(c 0x0, s 
>0xff,
>
>l 2
>55, t 0xff) 22(c 0x0, s 0xff, l 255, t 0xff) 23(c 0x0, s 0xff, l 255, t
>0xff) 24
>(c 0x0, s 0xff, l 255, t 0xff) 25(c 0x0, s 0xff, l 255, t 0xff) 26(c 0x0, s
>0xff
>, l 255, t 0xff) 27(c 0x0, s 0xff, l 255, t 0xff) 28(c 0x0, s 0xff, l 255, 
>t
>
>0xf
>f) 29(c 0x0, s 0xff, l 255, t 0xff) 30(c 0x0, s 0xff, l 255, t 0xff) 31(c
>0x0, s
>0xff, l 255, t 0xff)
>Pending list: 1(c 0x40, s 0x17, l 0), 3(c 0x0, s 0x7, l 1)
>Kernel Free SCB list: 0
>Untagged Q(0): 3
>Untagged Q(1): 1
>DevQ(0:0:0): 0 waiting
>DevQ(0:0:1): 0 waiting
>DevQ(0:1:0): 0 waiting
>scsi0:0:1:0: Cmd aborted from QINFIFO
>aic7xxx_abort returns 0x2002
>scsi0:0:1:0: Attempting to queue a TARGET RESET message
>scsi0:0:1:0: Is not an active device
>aic7xxx_dev_reset returns 0x2002
>scsi0:0:1:0: Attempting to queue an ABORT message
>scsi0: Dumping Card State in Command phase, at SEQADDR 0x167
>ACCUM = 0x80, SINDEX = 0x81, DINDEX = 0xe4, ARG_2 = 0x0
>HCNT = 0x0 SCBPTR = 0x0
>SCSISEQ = 0x12, SBLKCTL = 0xa
>DFCNTRL = 0x4, DFSTATUS = 0x88
>LASTPHASE = 0x80, SCSISIGI = 0x54, SXFRCTL0 = 0x88
>SSTAT0 = 0x5, SSTAT1 = 0x5
>SCSIPHASE = 0x2
>STACK == 0x34, 0x167, 0x34, 0x167
>SCB count = 4
>Kernel NEXTQSCB = 1
>Card NEXTQSCB = 2
>QINFIFO entries: 2
>Waiting Queue entries:
>Disconnected Queue entries:
>QOUTFIFO entries:
>Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
>21 2
>2 23 24 25 26 27 28 29 30 31
>Sequencer SCB Info: 0(c 0x0, s 0x7, l 1, t 0x3) 1(c 0x0, s 0xff, l 255, t
>0xff)
>2(c 0x0, s 0xff, l 255, t 0xff) 3(c 0x0, s 0xff, l 255, t 0xff) 4(c 0x0, s
>0xff,
>l 255, t 0xff) 5(c 0x0, s 0xff, l 255, t 0xff) 6(c 0x0, s 0xff, l 255, t
>0xff)
>7(c 0x0, s 0xff, l 255, t 0xff) 8(c 0x0, s 0xff, l 255, t 0xff) 9(c 0x0, s
>0xff,
>l 255, t 0xff) 10(c 0x0, s 0xff, l 255, t 0xff) 11(c 0x0, s 0xff, l 255, t
>0xff
>) 12(c 0x0, s 0xff, l 255, t 0xff) 13(c 0x0, s 0xff, l 255, t 0xff) 14(c
>0x0, s
>0xff, l 255, t 0xff) 15(c 0x0, s 0xff, l 255, t 0xff) 16(c 0x0, s 0xff, l
>255, t
>0xff) 17(c 0x0, s 0xff, l 255, t 0xff) 18(c 0x0, s 0xff, l 255, t 0xff) 
>19(c
>
>0x
>0, s 0xff, l 255, t 0xff) 20(c 0x0, s 0xff, l 255, t 0xff) 21(c 0x0, s 
>0xff,
>
>l 2
>55, t 0xff) 22(c 0x0, s 0xff, l 255, t 0xff) 23(c 0x0, s 0xff, l 255, t
>0xff) 24
>(c 0x0, s 0xff, l 255, t 0xff) 25(c 0x0, s 0xff, l 255, t 0xff) 26(c 0x0, s
>0xff
>, l 255, t 0xff) 27(c 0x0, s 0xff, l 255, t 0xff) 28(c 0x0, s 0xff, l 255, 
>t
>
>0xf
>f) 29(c 0x0, s 0xff, l 255, t 0xff) 30(c 0x0, s 0xff, l 255, t 0xff) 31(c
>0x0, s
>0xff, l 255, t 0xff)
>Pending list: 2(c 0x40, s 0x17, l 0), 3(c 0x0, s 0x7, l 1)
>Kernel Free SCB list: 0
>Untagged Q(0): 3
>Untagged Q(1): 2
>DevQ(0:0:0): 0 waiting
>DevQ(0:0:1): 0 waiting
>DevQ(0:1:0): 0 waiting
>scsi0:0:1:0: Cmd aborted from QINFIFO
>aic7xxx_abort returns 0x2002
>Recovery SCB completes
>scsi: device set offline - not ready or command retry failed after bus
>reset: ho
>st 0 channel 0 id 1 lun 0
>scsi0:A:0:0: Tagged Queuing enabled.  Depth 253
>Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
>(scsi0:A:0:0): parity error detected in Data-in phase. SEQADDR(0x1a3)
>SCSIRATE(0
>x93)
>scsi0:0:0:0: Attempting to queue an ABORT message
>scsi0: Dumping Card State in Command phase, at SEQADDR 0x167
>ACCUM = 0x80, SINDEX = 0x81, DINDEX = 0xe4, ARG_2 = 0x0
>HCNT = 0x0 SCBPTR = 0x0
>SCSISEQ = 0x12, SBLKCTL = 0xa
>DFCNTRL = 0x4, DFSTATUS = 0x88
>LASTPHASE = 0x80, SCSISIGI = 0x54, SXFRCTL0 = 0x88
>SSTAT0 = 0x5, SSTAT1 = 0x5
>SCSIPHASE = 0x2
>STACK == 0x34, 0x167, 0x34, 0x167
>SCB count = 4
>Kernel NEXTQSCB = 3
>Card NEXTQSCB = 3
>QINFIFO entries:
>Waiting Queue entries:
>Disconnected Queue entries:
>QOUTFIFO entries:
>Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
>21 2
>2 23 24 25 26 27 28 29 30 31
>Sequencer SCB Info: 0(c 0x0, s 0x7, l 0, t 0x1) 1(c 0x0, s 0xff, l 255, t
>0xff)
>2(c 0x0, s 0xff, l 255, t 0xff) 3(c 0x0, s 0xff, l 255, t 0xff) 4(c 0x0, s
>0xff,
>l 255, t 0xff) 5(c 0x0, s 0xff, l 255, t 0xff) 6(c 0x0, s 0xff, l 255, t
>0xff)
>7(c 0x0, s 0xff, l 255, t 0xff) 8(c 0x0, s 0xff, l 255, t 0xff) 9(c 0x0, s
>0xff,
>l 255, t 0xff) 10(c 0x0, s 0xff, l 255, t 0xff) 11(c 0x0, s 0xff, l 255, t
>0xff
>) 12(c 0x0, s 0xff, l 255, t 0xff) 13(c 0x0, s 0xff, l 255, t 0xff) 14(c
>0x0, s
>0xff, l 255, t 0xff) 15(c 0x0, s 0xff, l 255, t 0xff) 16(c 0x0, s 0xff, l
>255, t
>0xff) 17(c 0x0, s 0xff, l 255, t 0xff) 18(c 0x0, s 0xff, l 255, t 0xff) 
>19(c
>
>0x
>0, s 0xff, l 255, t 0xff) 20(c 0x0, s 0xff, l 255, t 0xff) 21(c 0x0, s 
>0xff,
>
>l 2
>55, t 0xff) 22(c 0x0, s 0xff, l 255, t 0xff) 23(c 0x0, s 0xff, l 255, t
>0xff) 24
>(c 0x0, s 0xff, l 255, t 0xff) 25(c 0x0, s 0xff, l 255, t 0xff) 26(c 0x0, s
>0xff
>, l 255, t 0xff) 27(c 0x0, s 0xff, l 255, t 0xff) 28(c 0x0, s 0xff, l 255, 
>t
>
>0xf
>f) 29(c 0x0, s 0xff, l 255, t 0xff) 30(c 0x0, s 0xff, l 255, t 0xff) 31(c
>0x0, s
>0xff, l 255, t 0xff)
>Pending list: 1(c 0x0, s 0x7, l 0)
>Kernel Free SCB list: 2 0
>DevQ(0:0:0): 0 waiting
>scsi0:0:0:0: Device is active, asserting ATN
>Recovery code sleeping
>Recovery code awake
>aic7xxx_abort returns 0x2002
>
>rgds
>rm
>
>
>
>
>
>_________________________________________________________________
>Hot picks. Free downloads. http://www.msn.co.in/musicnew/musicshop Visit
>music shop
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


_________________________________________________________________
Still unmarried? Not for long. http://www.msn.co.in/Matrimony/ Find a life 
partner now
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
