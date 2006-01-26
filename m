From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: Problems with MSI-X on ia64
Date: Thu, 26 Jan 2006 14:37:14 -0600
Message-ID: <D4CFB69C345C394284E4B78B876C1CF10B8481F1@cceexc23.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ia64-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-ia64-owner@vger.kernel.org
To: "Grundler, Grant G" <grant.grundler@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ia64@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Grundler, Grant G 
> > We're using a 2.6.9 variant and a cciss driver with 
> MSI/MSI-X support.
> > The kernel has MSI enabled. On ia64 the MSI-X table is all zeroes.
> 
> Could you post the debug output you've collected so far?

There are 2 MSI-X capable controllers in the system. On IPF this is what
the tables look like:

cciss: offset = 0xfe000 table offset = 0xfe000 BIR = 0x0
cciss: 0: vector = 0,msg data = 0, msg upper addr = 0,msg addr = 0
cciss: 1: vector = 0,msg data = 0, msg upper addr = 0,msg addr = 0
cciss: 2: vector = 0,msg data = 0, msg upper addr = 0,msg addr = 0
cciss: 3: vector = 0,msg data = 0, msg upper addr = 0,msg addr = 0
cciss: using DAC cycles
ACPI: PCI interrupt 0000:88:00.0[A] -> GSI 71 (level, low) -> IRQ 61
cciss: MSI-X enabled
cciss: offset = 0xfe000 table offset = 0xfe000 BIR = 0x0
cciss: 0: vector = 0,msg data = 0, msg upper addr = 0,msg addr = 0
cciss: 1: vector = 0,msg data = 0, msg upper addr = 0,msg addr = 0
cciss: 2: vector = 0,msg data = 0, msg upper addr = 0,msg addr = 0
cciss: 3: vector = 0,msg data = 0, msg upper addr = 0,msg addr = 0
cciss: using DAC cycles
blocks= 143305920 block_size= 512
heads= 255, sectors= 32, cylinders= 17562
 
blocks= 142130880 block_size= 512
heads= 255, sectors= 32, cylinders= 17418
 
cciss/c2d0:

And this is where we hang, when enabling interrupts in the driver.

The table on x86_64 looks like this:

cciss: Device 0x3230 has been found at bus 11 dev 0 func 0
ACPI: PCI Interrupt 0000:0b:00.0[A] -> GSI 16 (level, low) -> IRQ 169
cciss: offset = 0xfe000 table offset = 0xfe000 BIR = 0x0
cciss: 0: vector = 0,msg data = 40d1, msg upper addr = 0,msg addr =
fee00000
cciss: 1: vector = 0,msg data = 40d9, msg upper addr = 0,msg addr =
fee00000
cciss: 2: vector = 0,msg data = 40e1, msg upper addr = 0,msg addr =
fee00000
cciss: 3: vector = 0,msg data = 40e9, msg upper addr = 0,msg addr =
fee00000
cciss: using DAC cycles

mikem
















> 
> > On Intel x86_64 platforms the table contains valid data and 
> everything 
> > works as expected.
> 
> It should look similar for ia64 since both use 0xfeeXXXXX 
> Processor Interrupt Block address and similar intr vectors.
> 
> > If I understand how this works the Linux kernel is supposed 
> to program 
> > up the table based on the HW platform. I can't find anything in the 
> > ia64 code that does this. For x86_64 and i386 it looks like 
> the magic 
> > address is
> > 
> > 	#define APIC_DEFAULT_BASE	0xfee00000
> > 
> > Anybody know why this isn't defined for ia64? Any answers, 
> input, or 
> > flames are appreciated.
> 
> APIC_DEAFULT_BASE isn't used.  See 
> 
> fgrep MSI_ADDRESS_HEADER drivers/pci/*
> drivers/pci/msi.c:      dest_id = (MSI_ADDRESS_HEADER << 
> MSI_ADDRESS_HEADER_SHIFT);
> drivers/pci/msi.h:#define MSI_ADDRESS_HEADER            0xfee
> drivers/pci/msi.h:#define MSI_ADDRESS_HEADER_SHIFT      12
> drivers/pci/msi.h:#define MSI_ADDRESS_HEADER_MASK       0xfff000
> 
> This is one of the things that Mark Maule/SGI needs to change 
> to support MSI on SN2.
> 
> grant
> 
