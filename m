From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 35/52] atp870u: Reduce log spam on module load/unload
Date: Tue, 17 Nov 2015 19:24:11 +0100
Message-ID: <1447784668-23713-36-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56543 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932126AbbKQShX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:37:23 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 9621403..b662e39 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1260,9 +1260,7 @@ static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (pci_enable_device(pdev))
 		goto err_eio;
 
-        if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
-                printk(KERN_INFO "atp870u: use 32bit DMA mask.\n");
-        } else {
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
                 printk(KERN_ERR "atp870u: DMA mask required but not available.\n");
 		goto err_eio;
         }
@@ -1742,12 +1740,9 @@ static void atp870u_remove (struct pci_dev *pdev)
 	
 	
 	scsi_remove_host(pshost);
-	printk(KERN_INFO "free_irq : %d\n",pshost->irq);
 	free_irq(pshost->irq, pshost);
 	release_region(pshost->io_port, pshost->n_io_port);
-	printk(KERN_INFO "atp870u_free_tables : %p\n",pshost);
 	atp870u_free_tables(pshost);
-	printk(KERN_INFO "scsi_host_put : %p\n",pshost);
 	scsi_host_put(pshost);
 }
 MODULE_LICENSE("GPL");
-- 
Ondrej Zary

