From: Doug Ledford <dledford@redhat.com>
Subject: Re: PROBLEM: sym53c8xx is broken on HP LH 4 after Linux 2.2
Date: Sun, 09 Nov 2003 11:51:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068396696.3204.11.camel@compaq.xsintricity.com>
References: <3FAC4BB1.mail1NJ11B4U4@exploits.org>
	 <20031109163756.GB2014@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51729 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S262687AbTKIQwu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Nov 2003 11:52:50 -0500
In-Reply-To: <20031109163756.GB2014@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Russell Kroll <rkroll@exploits.org>, linux-scsi mailing list <linux-scsi@vger.kernel.org>

On Sun, 2003-11-09 at 11:37, Matthew Wilcox wrote:
> On Fri, Nov 07, 2003 at 07:49:37PM -0600, Russell Kroll wrote:
> > On the HP NetServer LH4, the sym53c8xx driver only works in 2.2 kernels, 
> > and fails with a "CACHE INCORRECTLY CONFIGURED" error on 2.4 and 2.6.  
> > This also applies to the sym53c8xx_2 driver.
> 
> Hi Russell.  I'm really interested in fixing this for the sym2 driver in 2.6.
> Given this bit of the lspci log:
> 
> 01:07.0 SCSI storage controller: LSI Logic / Symbios Logic 53c895 (rev 01)
> 	Subsystem: Hewlett-Packard Company: Unknown device 1000
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
> 	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 247 (7500ns min, 16000ns max), cache line size 08
> 	Interrupt: pin A routed to IRQ 11
> 	Region 0: I/O ports at 1400 [size=256]
> 	Region 1: Memory at 40000000 (32-bit, non-prefetchable) [size=256]
> 	Region 2: Memory at 40001000 (32-bit, non-prefetchable) [size=4K]
> 
> 01:07.0 SCSI storage controller: LSI Logic / Symbios Logic 53c895 (rev 01)
> 	Subsystem: Hewlett-Packard Company: Unknown device 1000
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
> 	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 247 (7500ns min, 16000ns max), cache line size 08
> 	Interrupt: pin A routed to IRQ 11
> 	Region 0: I/O ports at a000 [size=256]
> 	Region 1: Memory at e8101000 (32-bit, non-prefetchable) [size=256]
> 	Region 2: Memory at e8100000 (32-bit, non-prefetchable) [size=4K]
> 
> I would say that this is a PCI problem, not a sym2 problem.  I'm only
> trying to pass the buck to another of my personalities though, since I also
> hack PCI stuff.  I really don't think we should have two devices with the
> same domain:bus:slot.function since there's no way to do pci config
> cycles to one or the other.

I can tell you what's going on here.  This is a 450NX based
motherboard.  The 450NX chipset from Intel was the first chipset to have
peer PCI busses.  For backwards compatibility, some machine makers
hacked their PCI BIOS to have a fake bridge device on PCI bus 0 that
points to the same bus number as the peer bus.  This way if the OS
didn't know about the peer bus registers it would still find the devices
by scanning behind the bridge.  In this case we are scanning behind this
fake bridge and then also scanning based upon the peer bus registers in
the chipset, and as a result we are finding the device twice.  In order
to fix this problem you need to change the peer bus quirk code for the
450NX chipset to scan the list of bus 0 devices looking for a bridge
that has the same config as the peer bus registers and if so delete the
bridge from the list.  That will avoid double scanning and will avoid
having the PCI code try and configure sub busses via a fake bridge when
it should do all configurations via the 450NX peer bus registers.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


