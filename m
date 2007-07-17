From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: advansys cleanup
Date: Tue, 17 Jul 2007 10:37:54 -0600
Message-ID: <20070717163754.GD14791@parisc-linux.org>
References: <20070716202815.GQ13826@parisc-linux.org> <20070717142455.GB14791@parisc-linux.org> <Pine.LNX.4.64.0707171103500.20043@death.krwtech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:39376 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593AbXGQQh4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 12:37:56 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707171103500.20043@death.krwtech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ken Witherow <ken@krwtech.com>
Cc: linux-scsi@vger.kernel.org, jeffreyfreeman@syncleus.com, Christoph Hellwig <hch@infradead.org>

On Tue, Jul 17, 2007 at 11:36:11AM -0400, Ken Witherow wrote:
> Instead, I pulled the raw advansys.c from the tree provided and dropped 
> that in place.

Hm, sorry about that.  I suspect that advansys.c has changed since
2.6.22.

>   CC      drivers/scsi/advansys.o
> drivers/scsi/advansys.c:795:2: warning: #warning this driver is still not 
> properly converted to the DMA API

Yeah, I'm not planning on getting rid of that warning.  Yet, anyway.

>   MODPOST vmlinux
> WARNING: drivers/built-in.o(.text+0x99045): Section mismatch: reference to 
> .init.text: (between 'advansys_board_found' and 'advansys_pci_probe')

Oops.  Probably simple to fix, I'll look into that.

> 
> I've attached my regular dmesg as well as my dmesg with the failure of the 
> updated advansys driver.

The important bit is this one:

-ACPI: PCI Interrupt 0000:00:09.0[A] -> GSI 17 (level, low) -> IRQ 16
-scsi0 : AdvanSys SCSI 3.3K: PCI Ultra: IO 0x1800-0x180F, IRQ 0x10
+scsi0 : AdvanSys SCSI 3.3K: PCI Ultra: IO 0x1800-0x180F, IRQ 0x5
+advansys: advansys_detect: unknown bus type: 4

Somehow I've messed up the IRQ.

The unknown bus type is just a minor oversight -- i ripped out the
handling of PCI bus types from advansys_detect, but let it try to probe
for them anyway, which it no longer knows how to handle.

> I'd be glad to attempt the patches again. It would be easier for me if you 
> sent me the raw patches, if possible.

How about I send you a patch on top of the advansys.c you got from that
git tree?

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
