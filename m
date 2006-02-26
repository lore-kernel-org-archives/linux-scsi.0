From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: What happened to ncr53c8xx module in 2.6? (troubles with sym53c8xx in its place)
Date: Sun, 26 Feb 2006 12:09:29 -0700
Message-ID: <20060226190929.GV28587@parisc-linux.org>
References: <20060226170411.GA300@proxysrv.domain007.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:39324 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S932190AbWBZTJa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Feb 2006 14:09:30 -0500
Content-Disposition: inline
In-Reply-To: <20060226170411.GA300@proxysrv.domain007.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Sun, Feb 26, 2006 at 08:04:11PM +0300, Konstantin Khomoutov wrote:
> I had have to upgrade from 2.4.30 to 2.6.15.4 and I've noticed that
> there's no more ncr53c8xx kernel module (actually, the code seems to be
> there but now it's just a part of 2 drivers for a couple of MCA-bus cards).

One MCA card and one GSC card actually ;-)

> The problem is that I have some pretty old SCSI scanner (HP ScanJet 4p)
> that was distributed with its own ISA SCSI card (NCR53c400 based, BTW,
> but with that card and its driver I had no luck at all, while under
> Win98 that card works OK).

Somebody should probably investigate that, but I don't really want to
take on another scsi driver ...

> Some time ago I've managed to put this scanner to work being attached to
> one that same old PCI card based on Symbios Logic 53c810 rev1 chip.
> The only driver that was able to control this card (with some parameters
> tweakery, though) was ncr53c8xx.
> 
> As I can see, sym53c8xx had superseded ncr53c8xx in 2.6, right?

That's correct.  We removed support for the 8xx devices from ncr53c8xx
leaving it to drive the non-PCI 720 chip only.

> But sym53c8xx gives me this when I try to insert it while the attached
> scanner is ON:
> 
> PCI: Found IRQ 9 for device 0000:02:09.0
> sym0: <810> rev 0x1 at pci 0000:02:09.0 irq 9
> sym0: No NVRAM, ID 7, Fast-10, SE, parity checking
> CACHE TEST FAILED: timeout.
> sym0: CACHE INCORRECTLY CONFIGURED.
> sym0: giving up ...
> 
> The exactly same results I seen when I tried this driver under a 2.4
> kernel.

Are you saying that it works fine when the scanner isn't plugged in, or
is turned off?

> I've googled that this dumb scanner doesn't report parity and that
> disappoints the sym53c8xx driver, but I failed to find an appropriate
> option to turn parity checking off. Furthermore, I've also googled some
> info that sym53c8xx just doesn't support 53c810 chips at all.

I removed the option to disable parity checking.  Looks like I should
reinstate it.  I have an 810 card here that works fine, so that
information is out of date.

