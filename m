From: Konstantin Khomoutov <flatworm@users.sourceforge.net>
Subject: What happened to ncr53c8xx module in 2.6? (troubles with sym53c8xx in its place)
Date: Sun, 26 Feb 2006 20:04:11 +0300
Message-ID: <20060226170411.GA300@proxysrv.domain007.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.007spb.ru ([212.113.108.55]:7103 "EHLO
	mailhub.007spb.ru") by vger.kernel.org with ESMTP id S1751259AbWBZREO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Feb 2006 12:04:14 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tvarek@proxysrv.domain007.com

I had have to upgrade from 2.4.30 to 2.6.15.4 and I've noticed that
there's no more ncr53c8xx kernel module (actually, the code seems to be
there but now it's just a part of 2 drivers for a couple of MCA-bus cards).

The problem is that I have some pretty old SCSI scanner (HP ScanJet 4p)
that was distributed with its own ISA SCSI card (NCR53c400 based, BTW,
but with that card and its driver I had no luck at all, while under
Win98 that card works OK).
Some time ago I've managed to put this scanner to work being attached to
one that same old PCI card based on Symbios Logic 53c810 rev1 chip.
The only driver that was able to control this card (with some parameters
tweakery, though) was ncr53c8xx.

As I can see, sym53c8xx had superseded ncr53c8xx in 2.6, right?
But sym53c8xx gives me this when I try to insert it while the attached
scanner is ON:

PCI: Found IRQ 9 for device 0000:02:09.0
sym0: <810> rev 0x1 at pci 0000:02:09.0 irq 9
sym0: No NVRAM, ID 7, Fast-10, SE, parity checking
CACHE TEST FAILED: timeout.
sym0: CACHE INCORRECTLY CONFIGURED.
sym0: giving up ...

The exactly same results I seen when I tried this driver under a 2.4
kernel.

I've googled that this dumb scanner doesn't report parity and that
disappoints the sym53c8xx driver, but I failed to find an appropriate
option to turn parity checking off. Furthermore, I've also googled some
info that sym53c8xx just doesn't support 53c810 chips at all.

I've also patched my kernel config to just compile ncr53c8xx as a
module, but with no luck (of course).

As you probably can see I'm unsure what to do next.
Can you please give me some advice on it (change to a different driver,
tweak ncr53c8xx somehow to make it a module, pass sym53c8xx some
parameters to make it work, whatewer...)?

Thanks in advance!

