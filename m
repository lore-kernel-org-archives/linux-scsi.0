From: Matthew Wilcox <willy@debian.org>
Subject: Re: -test4 detects scsi hdds in another order than -test2 does
Date: Fri, 29 Aug 2003 19:06:28 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030829180628.GB22294@parcelfarce.linux.theplanet.co.uk>
References: <m33cfm19ar.fsf@bzzz.home.net> <3F4E4605.6040706@wmich.edu> <m3vfshrola.fsf@bzzz.home.net> <3F4F7129.1050506@wmich.edu> <m3vfsgpj8b.fsf@bzzz.home.net> <20030829091135.559a121f.akpm@osdl.org> <m3d6eopfvt.fsf_-_@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:21436 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261940AbTH2SGa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Aug 2003 14:06:30 -0400
Content-Disposition: inline
In-Reply-To: <m3d6eopfvt.fsf_-_@bzzz.home.net>
List-Id: linux-scsi@vger.kernel.org
To: Alex Tomas <bzzz@tmi.comex.ru>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

On Fri, Aug 29, 2003 at 08:50:30PM +0400, Alex Tomas wrote:

Yes, we discussed this on IRC ... output trimmed (and reversed) for
easier comparison

> output for -test2:
> sym0: <1010-33> rev 0x1 on pci bus 1 device 6 function 1 irq 28
> sym1: <1010-33> rev 0x1 on pci bus 1 device 6 function 0 irq 29
> sym2: <1010-33> rev 0x1 on pci bus 1 device 3 function 1 irq 24
> sym3: <1010-33> rev 0x1 on pci bus 1 device 3 function 0 irq 23
> Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
> Attached scsi disk sdb at scsi1, channel 0, id 0, lun 0
> Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 0
> Attached scsi generic sg1 at scsi1, channel 0, id 0, lun 0,  type 0

> output for -test4:
> sym0: <1010-33> rev 0x1 on pci bus 1 device 3 function 0 irq 23
> sym1: <1010-33> rev 0x1 on pci bus 1 device 3 function 1 irq 24
> sym2: <1010-33> rev 0x1 on pci bus 1 device 6 function 0 irq 29
> sym3: <1010-33> rev 0x1 on pci bus 1 device 6 function 1 irq 28
> Attached scsi disk sda at scsi2, channel 0, id 0, lun 0
> Attached scsi disk sdb at scsi3, channel 0, id 0, lun 0
> Attached scsi generic sg0 at scsi2, channel 0, id 0, lun 0,  type 0
> Attached scsi generic sg1 at scsi3, channel 0, id 0, lun 0,  type 0

In -test4, the sym2 driver has been converted to the pci_driver
API.  That means that the cards are now detected and probed one
after another rather than having the driver search through the pci
list, find the cards in a strange order, then whack them with the
contents of whichever NVRAM is determined to have highest priority
(which causes all kinds of strange behaviour).

In -test2, somehow the cards are discovered in reverse order.  This must
be due to NVRAM as your cards are all of the same type.  So can you try
clearing the NVRAM or configuring the cards to be in the opposite order?
That should make -test2 discover the cards in the same order as -test4.

I assumed everyone who used scsi on Linux was used to the cards appearing
in random order ...

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
