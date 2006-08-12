From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Symbios Logic 53C876 detected as 53C875, then doesn't work
Date: Sat, 12 Aug 2006 07:22:13 -0600
Message-ID: <20060812132213.GA789@parisc-linux.org>
References: <Pine.LNX.4.64.0608120108330.21468@potato.cts.ucla.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42905 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S932509AbWHLNWO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Aug 2006 09:22:14 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0608120108330.21468@potato.cts.ucla.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Stromsoe <cbs@cts.ucla.edu>
Cc: linux-scsi@vger.kernel.org

On Sat, Aug 12, 2006 at 01:17:53AM -0700, Chris Stromsoe wrote:
> I have several Symbios Logic 53c875 cards that I'm trying to get working 
> with 2.6.17.8 i386.  The cards are all functional under Solaris and were 
> pulled from E450 within the last week.
> 
> One of the cards is not recognized at all (PCI ID 1000:0007).  The other 
> cards are PCI ID 1000:000f.

Can you try swapping the cards around?  I don't know of a device with ID
0007.  Being one bit different from 000f (which is the correct ID for
both the 875 and 876 chips) makes me suspicious it may be in a defective
PCI slot.  I had one of those recently with an Asus Nvidia board.

> Booting with with the 1000:000f cards and append="sym53c8xx.verb=2" gives 
> me:
> 
> PCI: Enabling device 0000:01:02.0 (0000 -> 0003)
> PCI: Setting latency timer of device 0000:01:02.0 to 64
> sym0: <875> rev 0x14 at pci 0000:01:02.0 irq 0
> sym0: clock multiplier found
> sym0: No NVRAM, ID 7, Fast-20, HVD, parity checking
> sym0: open drain IRQ line driver, using on-chip SRAM
> sym0: using LOAD/STORE-based firmware.
> sym0: initial SCNTL3/DMODE/DCNTL/CTEST3/4/5 = (hex) 07/ce/a8/01/80/24
> sym0: final   SCNTL3/DMODE/DCNTL/CTEST3/4/5 = (hex) 05/46/80/01/08/24
> CACHE TEST FAILED: reg dstat-sstat2 readback ffffffff.
> sym0: CACHE INCORRECTLY CONFIGURED.
> sym0: giving up ...

I don't like the look of this.  If you're getting ffffffff back from
those particular registers, the chip has clearly gone fatal.  But I use
875 controllers *all the time*, so there's something odd going on here.
I don't know what to suggest at this point, I'm afraid.
