From: Matthew Wilcox <matthew@wil.cx>
Subject: Canonical SCSI messages
Date: Fri, 1 Oct 2004 17:53:24 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041001165324.GE16153@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:2728 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264984AbUJAQx1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Oct 2004 12:53:27 -0400
Received: from willy by www.linux.org.uk with local (Exim 4.33)
	id 1CDQeq-0006fv-W0
	for linux-scsi@vger.kernel.org; Fri, 01 Oct 2004 17:53:25 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Recently I've been staring at a lot of dmesg output that looks like:

sym4: <1010-66> rev 0x1 at pci 0003:00:02.0 irq 58
sym4: using 64 bit DMA addressing
sym4: Symbios NVRAM, ID 7, Fast-80, SE, parity checking
sym4: open drain IRQ line driver, using on-chip SRAM
sym4: using LOAD/STORE-based firmware.
sym4: handling phase mismatch from SCRIPTS.
sym4: SCSI BUS has been reset.
scsi4 : sym-2.1.18k
  Vendor: HP 18.2G  Model: ST318406LC        Rev: HP05
  Type:   Direct-Access                      ANSI SCSI revision: 02
sym4:6:0: tagged command queuing enabled, command queue depth 16.
scsi(4:0:6:0): Beginning Domain Validation
sym4:6: wide asynchronous.
sym4:6: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 31)
scsi(4:0:6:0): Ending Domain Validation

The difference between scsi(4:0:6:0) and sym4:6:0 annoyed me sufficiently
that I remembered a patch from Mike Anderson and Patrick Mansfield a few
months ago.  Their patch makes the output look like:

PCI: Enabling device: (0000:00:0c.0), cmd 143
sym53c8xx 0000:00:0c.0: chip <875> rev 0x4 at pci 0000:00:0c.0 irq 17
sym53c8xx 0000:00:0c.0: No NVRAM, ID 7, Fast-20, SE, parity checking 
sym53c8xx 0000:00:0c.0: SCSI BUS has been reset.
scsi0 : sym-2.1.18f
sym53c8xx 0000:00:0c.0: 0: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 16)
  Vendor: IBM       Model: IC35L036UWD210-0  Rev: S5BS
  Type:   Direct-Access                      ANSI SCSI revision: 03

I have to say, I'm not keen on using the PCI address, partly because it's
so long, partly because we'd still have a discrepancy between the scsi
layer's reports and the driver's reports, and partly because I'd like
to see all scsi drivers report in the same format (and not everything
is pci).

I quite like the scsi(H:C:I:L) format that scsi_transport_spi.c uses.
It means that people still have to look up what scsiN maps to, but I
don't think that's a huge problem.  It certainly beats having to look
up that scsi3 is sym1 is pci0000:00:0c.1

I'm going to start converting sym2 over to this scheme unless I hear
any objections.  I'd like to see it look something like:

scsi4 : sym-2.1.18k
scsi4: <1010-66> rev 0x1 at pci 0003:00:02.0 irq 58
scsi4: using 64 bit DMA addressing
scsi4: Symbios NVRAM, ID 7, Fast-80, SE, parity checking
scsi4: open drain IRQ line driver, using on-chip SRAM
scsi4: using LOAD/STORE-based firmware.
scsi4: handling phase mismatch from SCRIPTS.
scsi4: SCSI BUS has been reset.
  Vendor: HP 18.2G  Model: ST318406LC        Rev: HP05
  Type:   Direct-Access                      ANSI SCSI revision: 02
scsi(4:0:6:0): tagged command queuing enabled, command queue depth 16.
scsi(4:0:6:0): Beginning Domain Validation
scsi(4:0:6:0): wide asynchronous.
scsi(4:0:6:0): FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 31)
scsi(4:0:6:0): Ending Domain Validation

I'd also like to make sym2 less verbose at boot.  Which pieces of
information above are people willing to lose during bootup?  My personal
favourites are:

scsi4: using 64 bit DMA addressing
scsi4: open drain IRQ line driver, using on-chip SRAM
scsi4: using LOAD/STORE-based firmware.
scsi4: handling phase mismatch from SCRIPTS.

but maybe other people like that information?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
