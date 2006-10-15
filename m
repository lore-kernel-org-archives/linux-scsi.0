From: "Steven N. Hirsch" <shirsch@adelphia.net>
Subject: sym53c8xx_2 negotiates improperly
Date: Sun, 15 Oct 2006 13:36:04 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0610151329300.8184@monarch.fast.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta11.adelphia.net ([68.168.78.205]:40386 "EHLO
	mta11.adelphia.net") by vger.kernel.org with ESMTP id S1161048AbWJORgF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Oct 2006 13:36:05 -0400
Received: from monarch.fast.net ([24.49.184.29]) by mta11.adelphia.net
          (InterMail vM.6.01.05.02 201-2131-123-102-20050715) with ESMTP
          id <20061015173604.BOWA2152.mta11.adelphia.net@monarch.fast.net>
          for <linux-scsi@vger.kernel.org>; Sun, 15 Oct 2006 13:36:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have recently re-installed a Symbios branded 53C1010 U160 PCI controller 
and am having problems convincing it to setup Ultra-160 (aka FAST80) with 
a Seagate SX173404LC drive.  Drive is the only device on the bus.

The BIOS reports the unit as being U160 capable, and the driver seems to 
pick this up.  Unfortunately, this happens at boot:

<6>sym0: <1010-33> rev 0x1 at pci 0000:00:09.0 irq 169
<4>sym0: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
<4>sym0: open drain IRQ line driver, using on-chip SRAM
<4>sym0: using LOAD/STORE-based firmware.
<4>sym0: handling phase mismatch from SCRIPTS.
<5>sym0: SCSI BUS has been reset.
<6>scsi0 : sym-2.2.2
<6> target0:0:0: Multiple LUNs disabled in NVRAM
<5>  Vendor: SEAGATE   Model: SX173404LC        Rev: BD13
<5>  Type:   Direct-Access                      ANSI SCSI revision: 03
<6> target0:0:0: tagged command queuing enabled, command queue depth 16.
<6> target0:0:0: Beginning Domain Validation
<6> target0:0:0: sync msgout: Synchronous Data Transfer Request period = 25 ns offset = 0 
<6> target0:0:0: sync msgin: Synchronous Data Transfer Request period = 25 ns offset = 0 
<6> 0:0:0:0: sdtr: ofs=0 per=10 div=0 fak=0 chg=0.
<6> target0:0:0: asynchronous
<6> target0:0:0: wide msgout: Wide Data Transfer Request width = 16 
<6> target0:0:0: wide msgin: Wide Data Transfer Request width = 16 
<6> 0:0:0:0: wdtr: wide=1 chg=0.
<6> target0:0:0: sync msgout: Synchronous Data Transfer Request period = 25 ns offset = 0 
<6> target0:0:0: sync msgin: Synchronous Data Transfer Request period = 25 ns offset = 0 
<6> 0:0:0:0: sdtr: ofs=0 per=10 div=0 fak=0 chg=0.
<6> target0:0:0: wide asynchronous
<6> target0:0:0: ppr msgout: Parallel Protocol Request period = 12.5 ns offset = 62 width = 16 
<6> target0:0:0: ppr msgin: Parallel Protocol Request period = 25 ns offset = 62 width = 16 
<6> target0:0:0: asynchronous
<6> 0:0:0:0: M_REJECT to send for : Parallel Protocol Request period = 25 ns offset = 62 width = 16 
<6> target0:0:0: ppr msgout: Parallel Protocol Request period = 25 ns offset = 31 width = 16 
<6> target0:0:0: ppr msgin: Parallel Protocol Request period = 25 ns offset = 31 width = 16 
<6> target0:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 31)
<6> target0:0:0: Domain Validation skipping write tests
<6> target0:0:0: Ending Domain Validation
<6> target0:0:0: ppr msgout: Parallel Protocol Request period = 25 ns offset = 31 width = 16 
<6> target0:0:0: ppr msgin: Parallel Protocol Request period = 25 ns offset = 31 width = 16 
<6> target0:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 31)

I end up with the drive operating as an Ultra2.

Is this a driver issue?  I've seen some past reports of folks turning off 
PPR negotation to get by similar problems.  If this can help, I'd 
appreciate any tips on implementing the change.

It appears that almost all parameterized low-level tweaks have been 
removed from the newer driver, so I'm guessing code hacking will be 
needed.

Any and all advice appreciated!

Steve


-- 
