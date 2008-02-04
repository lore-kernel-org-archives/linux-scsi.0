From: scameron@beardog.cca.cpqcorp.net
Subject: [patch 1/3] cciss: Don't call pci_free_consistent with irqs disabled
Date: Mon, 4 Feb 2008 08:31:46 -0600
Message-ID: <20080204143146.GA3926@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:48095 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbYBDObr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 09:31:47 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mike.miller@hp.com, axboe@kernel.dk, scameron@beardog.cca.cpqcorp.net



Don't call pci_free_consistent with irqs disabled
(Was triggering a warning in arch/x86/kernel/pci-dma_32.c
in dma_free_coherent)

Signed-off-by: Stephen M. Cameron <smcameron@beardog.cca.cpqcorp.net>
---

 linux-2.6.24/drivers/block/cciss_scsi.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN linux-2.6.24/drivers/block/cciss_scsi.c~fix_pci_free_irq_bug linux-2.6.24/drivers/block/cciss_scsi.c
--- kernel.org2/linux-2.6.24/drivers/block/cciss_scsi.c~fix_pci_free_irq_bug	2008-02-04 07:52:39.000000000 -0600
+++ kernel.org2-root/linux-2.6.24/drivers/block/cciss_scsi.c	2008-02-04 07:52:39.000000000 -0600
@@ -1349,9 +1349,9 @@ cciss_unregister_scsi(int ctlr)
 	/* set scsi_host to NULL so our detect routine will 
 	   find us on register */
 	sa->scsi_host = NULL;
+	spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
 	scsi_cmd_stack_free(ctlr);
 	kfree(sa);
-	spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
 }
 
 static int 
_
