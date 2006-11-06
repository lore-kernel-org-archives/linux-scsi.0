From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: [PATCH 11/12] repost: cciss: cleanup cciss_interrupt mode
Date: Mon, 6 Nov 2006 14:29:44 -0600
Message-ID: <20061106202944.GK17847@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel13.hp.com ([156.153.255.238]:5833 "EHLO palrel13.hp.com")
	by vger.kernel.org with ESMTP id S1753719AbWKFU3p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Nov 2006 15:29:45 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

PATCH 11 of 12

This patch is a pretty simple cleanup for cciss_interrupt_mode.
Please consider this for inclusion.

Thanks,
mikem

Signed-off-by: Mike Miller <mike.miller@hp.com>

--------------------------------------------------------------------------------
---

 drivers/block/cciss.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/block/cciss.c~cciss_cleanup_int_mode_for_lx2619-rc4 drivers/block/cciss.c
--- linux-2.6/drivers/block/cciss.c~cciss_cleanup_int_mode_for_lx2619-rc4	2006-11-06 13:28:48.000000000 -0600
+++ linux-2.6-root/drivers/block/cciss.c	2006-11-06 13:28:48.000000000 -0600
@@ -2785,23 +2785,21 @@ static void __devinit cciss_interrupt_mo
 		if (err > 0) {
 			printk(KERN_WARNING "cciss: only %d MSI-X vectors "
 			       "available\n", err);
+			goto default_int_mode;
 		} else {
 			printk(KERN_WARNING "cciss: MSI-X init failed %d\n",
 			       err);
+			goto default_int_mode;
 		}
 	}
 	if (pci_find_capability(pdev, PCI_CAP_ID_MSI)) {
 		if (!pci_enable_msi(pdev)) {
-			c->intr[SIMPLE_MODE_INT] = pdev->irq;
 			c->msi_vector = 1;
-			return;
 		} else {
 			printk(KERN_WARNING "cciss: MSI init failed\n");
-			c->intr[SIMPLE_MODE_INT] = pdev->irq;
-			return;
 		}
 	}
-      default_int_mode:
+default_int_mode:
 #endif				/* CONFIG_PCI_MSI */
 	/* if we get here we're going to use the default interrupt mode */
 	c->intr[SIMPLE_MODE_INT] = pdev->irq;
_
