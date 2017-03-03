From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] vmw_pvscsi: handle the return value from pci_alloc_irq_vectors correctly
Date: Fri,  3 Mar 2017 07:57:16 -0700
Message-ID: <20170303145716.19655-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:42037 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751445AbdCCQH6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2017 11:07:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: loic.yhuel@gmail.com

It returns the number of vectors allocated when successful, so check for
a negative error only.

Fixes: 2e48e349 ("scsi: vmw_pvscsi: switch to pci_alloc_irq_vectors")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Loïc Yhuel <loic.yhuel@gmail.com>
Tested-by: Loïc Yhuel <loic.yhuel@gmail.com>
---
 drivers/scsi/vmw_pvscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index ef474a748744..c374e3b5c678 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -1487,7 +1487,7 @@ static int pvscsi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		irq_flag &= ~PCI_IRQ_MSI;
 
 	error = pci_alloc_irq_vectors(adapter->dev, 1, 1, irq_flag);
-	if (error)
+	if (error < 0)
 		goto out_reset_adapter;
 
 	adapter->use_req_threshold = pvscsi_setup_req_threshold(adapter, true);
-- 
2.11.0
