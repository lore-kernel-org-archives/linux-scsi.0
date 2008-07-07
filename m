From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUG]  linux-next: Tree for March 25 kernel oops, when loading
	mpt fusion driver - regression
Date: Mon, 07 Jul 2008 15:25:21 -0500
Message-ID: <1215462321.3274.34.camel@localhost.localdomain>
References: <20080325175224.3ee62b09.sfr@canb.auug.org.au>
	 <47E9F0B0.4060006@linux.vnet.ibm.com>  <20080626203857.GB3815@redhat.com>
	 <1215372215.4197.28.camel@localhost.localdomain>
	 <487279C9.2010802@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <487279C9.2010802@linux.vnet.ibm.com>
Sender: linux-next-owner@vger.kernel.org
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: David Teigland <teigland@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Andy Whitcroft <apw@shadowen.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2008-07-08 at 01:47 +0530, Kamalesh Babulal wrote:
> James Bottomley wrote:
> > On Thu, 2008-06-26 at 15:38 -0500, David Teigland wrote:
> >> On Wed, Mar 26, 2008 at 12:14:00PM +0530, Kamalesh Babulal wrote:
> >>> Hi Stephen,
> >>>
> >>> Kernel bug is hit while booting up the next-20080325 kernel with MPT
> >>> Fusion driver built in.This was reported previously for the
> >>> next-20080320 kernel
> >>> http://marc.info/?l=linux-next&m=120601013920868&w=2
> >> Hi, did you ever get this fixed?  I've been having the same problem,
> >> http://marc.info/?l=linux-scsi&m=121061780821823&w=4
> >> still exists on 2.6.26-rc8 for me,
> >>
> >> Loading scsi_transport_spi.ko module
> >> Loading mptscsih.ko module
> >> Loading mptspi.ko module
> >> Fusion MPT SPI Host driver 3.04.06
> >> ACPI: PCI Interrupt 0000:86:01.0[A] -> GSI 32 (level, low) -> IRQ 32
> >> mptbase: ioc0: Initiating bringup
> >> ioc0: LSI53C1030 B2: Capabilities={Initiator,Target}
> >> mptbase: ioc0: PCI-MSI enabled
> > 
> > I speculate that this might be related to the problem.  The fusion
> > driver was recently flipped to default to MSI enable (previously it had
> > disabled them).  Could you boot it with the fusion module parameter
> > 
> > mpt_msi_enable=0
> > 
> > if it actually boots that will be a good confirmation that MSI is to
> > blame.
> > 
> >> mptbase: ioc0: Initiating recovery
> > 
> > This I suspect is because of a lost interrupt.
> > 
> >> BUG: unable to handle kernel NULL pointer dereference at 0000000000000948
> > 
> > And this one looks to be a second bug:  The MSI fault path is actually
> > causing this oops.
> > 
> > James
> > 
> Hi James,
> 
> Kernel Bug is still reproducible with 2.6.26-rc9-git1 kernel, I tried booting with mpt_msi_enable=0
> as boot paramenter, but the call trace remains the same
> 
> oading mptbase.ko module[    6.766853] Fusion MPT base driver 3.04.06
> 
> [    6.783482] Copyright (c) 1999-2007 LSI Corporation
> Loading mptscsih.ko module
> Loading mptspi.ko module
> [    6.813157] Fusion MPT SPI Host driver 3.04.06
> [    6.827369] ACPI: PCI Interrupt 0000:01:01.0[A] -> GSI 22 (level, low) -> IRQ 22
> [    6.850624] mptbase: ioc0: Initiating bringup
> [    6.985601] ioc0: LSI53C1030 B2: Capabilities={Initiator}
> [    7.002711] mptbase: ioc0: PCI-MSI enabled
                                ^^^^^^^^^^^^^^^

If you had successfully specified mpt_msi_enable=0 this line wouldn't
appear.

My best guess is that you incorrectly specified it as a kernel command
line parameter rather than a module parameter.

James
