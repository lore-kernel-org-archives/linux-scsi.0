From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH] 3w-9xxx: fix abysmal write performance on some motherboards
Date: Fri, 09 Nov 2007 13:04:35 -0500
Message-ID: <4734A133.8090207@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host06.cybernetics.com ([206.246.200.22]:4330 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbXKISEb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Nov 2007 13:04:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linuxraid@amcc.com, linux-scsi@vger.kernel.org

The 3ware 9500S-8 SATA RAID controller exhibits terrible write
performance when PCI memory-write-and-invalidate is disabled.  This is
easy to demonstrate by replacing pci_try_set_mwi() in the patch below
with pci_clear_mwi().  My benchmarks show the following:

MWI disabled: 15 MB/s write, 330 MB/s read
MWI enabled:  240 MB/s write, 330 MB/s read

Most motherboards will enable MWI without the driver having to set it
explicitly, so most people probably wouldn't encounter this problem.
For the few motherboards that don't enable it, this patch could give a
16x performance improvement for writing.

This issue does not seem to affect the 9550SX controller, but the patch
doesn't hurt it either.  I haven't tested any of the other 3ware
controllers.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
--- linux-2.6.24-rc2/drivers/scsi/3w-9xxx.c.orig	2007-11-09 12:32:32.000000000 -0500
+++ linux-2.6.24-rc2/drivers/scsi/3w-9xxx.c	2007-11-09 12:33:20.000000000 -0500
@@ -2010,6 +2010,7 @@ static int __devinit twa_probe(struct pc
 	}
 
 	pci_set_master(pdev);
+	pci_try_set_mwi(pdev);
 
 	if (pci_set_dma_mask(pdev, DMA_64BIT_MASK)
 	    || pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK))


