From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: hpsa: free irq on q indexed by h->intr_mode and not i
Date: Mon, 14 Nov 2016 12:59:35 +0000
Message-ID: <20161114125935.12158-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Use correct index on q, use h->intr_mode instead of i. Issue
detected using static analysis with cppcheck

Fixes: bc2bb1543e62a5d0 ("scsi: hpsa: use pci_alloc_irq_vectors and automatic irq affinity")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9459925..0d4f21c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -8220,7 +8220,7 @@ static void hpsa_free_irqs(struct ctlr_info *h)
 
 	if (!h->msix_vectors || h->intr_mode != PERF_MODE_INT) {
 		/* Single reply queue, only one irq to free */
-		free_irq(pci_irq_vector(h->pdev, 0), &h->q[i]);
+		free_irq(pci_irq_vector(h->pdev, 0), &h->q[h->intr_mode]);
 		h->q[h->intr_mode] = 0;
 		return;
 	}
-- 
2.10.2
