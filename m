From: Matthew Wilcox <willy@debian.org>
Subject: Re: PROBLEM: sym53c8xx is broken on HP LH 4 after Linux 2.2
Date: Sun, 9 Nov 2003 16:37:56 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031109163756.GB2014@parcelfarce.linux.theplanet.co.uk>
References: <3FAC4BB1.mail1NJ11B4U4@exploits.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:7837 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262580AbTKIQh6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Nov 2003 11:37:58 -0500
Content-Disposition: inline
In-Reply-To: <3FAC4BB1.mail1NJ11B4U4@exploits.org>
List-Id: linux-scsi@vger.kernel.org
To: Russell Kroll <rkroll@exploits.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Nov 07, 2003 at 07:49:37PM -0600, Russell Kroll wrote:
> On the HP NetServer LH4, the sym53c8xx driver only works in 2.2 kernels, 
> and fails with a "CACHE INCORRECTLY CONFIGURED" error on 2.4 and 2.6.  
> This also applies to the sym53c8xx_2 driver.

Hi Russell.  I'm really interested in fixing this for the sym2 driver in 2.6.
Given this bit of the lspci log:

01:07.0 SCSI storage controller: LSI Logic / Symbios Logic 53c895 (rev 01)
	Subsystem: Hewlett-Packard Company: Unknown device 1000
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 247 (7500ns min, 16000ns max), cache line size 08
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at 1400 [size=256]
	Region 1: Memory at 40000000 (32-bit, non-prefetchable) [size=256]
	Region 2: Memory at 40001000 (32-bit, non-prefetchable) [size=4K]

01:07.0 SCSI storage controller: LSI Logic / Symbios Logic 53c895 (rev 01)
	Subsystem: Hewlett-Packard Company: Unknown device 1000
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 247 (7500ns min, 16000ns max), cache line size 08
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at a000 [size=256]
	Region 1: Memory at e8101000 (32-bit, non-prefetchable) [size=256]
	Region 2: Memory at e8100000 (32-bit, non-prefetchable) [size=4K]

I would say that this is a PCI problem, not a sym2 problem.  I'm only
trying to pass the buck to another of my personalities though, since I also
hack PCI stuff.  I really don't think we should have two devices with the
same domain:bus:slot.function since there's no way to do pci config
cycles to one or the other.

> Some background on the hardware: the LH4 seems to have two 53c895 
> interfaces on board.  In 2.2, you can't see the primary interface in 
> lspci, perhaps due to the bug that was fixed by the pre4-1 patch.  This is 
> generally not a problem, since the NetRAID/MegaRAID typically covers that 
> interface.

Hmm.. is this what's meant by the comment:

        /*
         *  Ignore Symbios chips controlled by various RAID controllers.
         *  These controllers set value 0x52414944 at RAM end - 16.
         */
#if defined(__i386__)
        if (base_2_c) {
		...
                        ram_val = readl_raw(ram_ptr + ram_size - 16);
                        iounmap(ram_ptr);
                        if (ram_val == 0x52414944) {
                                printf_info("%s: not initializing, "
                                            "driven by RAID controller.\n",
                                            sym_name(device));
                                return -1;
                        }

> On 2.4, both interfaces are visible, and the driver can't seem to latch 
> onto the second one.  I don't care if the first one doesn't work, since 
> I don't intend to talk to the disks that way.  All I need is the second 
> one, since that's where my tape drive is connected.
> 
> This system happens to be a dual Pentium III, but I've whittled the kernel 
> builds down to generic UP/Pentium settings without any positive effect.  I 
> even threw out just about everything except what I need to boot at one 
> point.  I've tried using "sym53c8xx=excl:0x1400", but it doesn't help.  
> It's not something in userspace which causes this, since it still happens 
> when I boot with 'init=/bin/sh'.
> 
> I intend to run 2.4.22 on this system, but tried 2.6.0-test9 in case the 
> problem had been discovered and fixed in that tree.  Unfortunately, it 
> also failed.  I haven't tried mangling 2.6's PCI code to duplicate the
> effects of backing out that patch yet.
> 
> This box is not in production, so I can run tests and try different  
> things.  My own attempts at making the driver work were not successful.
> 
> I'm stuck.  Any advice or pointers would be appreciated.

I have a couple of suggestions.

First, I have a strong suspicion that updating your firmware will
fix this problem.  But once we do that, we lose this opportunity for
debugging the pci code.  So after we're done robustifying the pci code,
you can go to http://welcome.hp.com/country/us/en/support.html select
"Download drivers and software", enter 'lh 4' in the box, submit, then
select "Cross operating system (BIOS, Firmware, etc)".

Second, I want to see what the PCI code is up to.  So, can you change
the #undef DEBUG to #define DEBUG in linux-2.6.0-test9/drivers/pci/probe.c
then boot that kernel and send me the dmesg output.

Thanks.

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
