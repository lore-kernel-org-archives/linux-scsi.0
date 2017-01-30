From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] PCI/MSI: don't apply affinity if there aren't enough vectors left
Date: Mon, 30 Jan 2017 13:15:41 +0100
Message-ID: <1485778541-28994-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53828 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751621AbdA3MPy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2017 07:15:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bhelgaas@google.com
Cc: bart.vanassche@sandisk.com, tglx@linutronix.de, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org

Bart reported a problem wіth an out of bounds access in the low-level
IRQ affinity code, which we root caused to the qla2xxx driver assigning
all it's MSI-X vectors to the pre and post vectors, and not having any
left for the actually spread IRQs.

This fixes this issue by not asking for affinity assignment when there
are not vectors to assign left.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Fixes: 402723ad ("PCI/MSI: Provide pci_alloc_irq_vectors_affinity()")
Reported-by: Bart Van Assche <bart.vanassche@sandisk.com>
Tested-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/pci/msi.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 50c5003..7f73bac 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -1206,6 +1206,16 @@ int pci_alloc_irq_vectors_affinity(struct pci_dev *dev, unsigned int min_vecs,
 	if (flags & PCI_IRQ_AFFINITY) {
 		if (!affd)
 			affd = &msi_default_affd;
+
+		if (affd->pre_vectors + affd->post_vectors > min_vecs)
+			return -EINVAL;
+
+		/*
+		 * If there aren't any vectors left after applying the pre/post
+		 * vectors don't bother with assigning affinity.
+		 */
+		if (affd->pre_vectors + affd->post_vectors == min_vecs)
+			affd = NULL;
 	} else {
 		if (WARN_ON(affd))
 			affd = NULL;
-- 
2.1.4

