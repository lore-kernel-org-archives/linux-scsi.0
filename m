From: Hariprasad Kelam <hariprasad.kelam@gmail.com>
Subject: [PATCH] scsi: lpfc: fix "NULL check before some freeing functions is
 not needed"
Date: Sun, 21 Jul 2019 17:12:29 +0530
Message-ID: <20190721114229.GA6886@hari-Inspiron-1545>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

As dma_pool_destroy and mempool_destroy functions has NULL check. We may
not need NULL check before calling them.

Fix below warnings reported by coccicheck
./drivers/scsi/lpfc/lpfc_mem.c:252:2-18: WARNING: NULL check before some
freeing functions is not needed.
./drivers/scsi/lpfc/lpfc_mem.c:255:2-18: WARNING: NULL check before some
freeing functions is not needed.
./drivers/scsi/lpfc/lpfc_mem.c:258:2-18: WARNING: NULL check before some
freeing functions is not needed.
./drivers/scsi/lpfc/lpfc_mem.c:261:2-18: WARNING: NULL check before some
freeing functions is not needed.
./drivers/scsi/lpfc/lpfc_mem.c:265:2-18: WARNING: NULL check before some
freeing functions is not needed.
./drivers/scsi/lpfc/lpfc_mem.c:269:2-17: WARNING: NULL check before some
freeing functions is not needed.

Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
---
 drivers/scsi/lpfc/lpfc_mem.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index 66191fa..9bdb4a0 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -248,25 +248,22 @@ lpfc_mem_free(struct lpfc_hba *phba)
 
 	/* Free HBQ pools */
 	lpfc_sli_hbqbuf_free_all(phba);
-	if (phba->lpfc_nvmet_drb_pool)
-		dma_pool_destroy(phba->lpfc_nvmet_drb_pool);
+	dma_pool_destroy(phba->lpfc_nvmet_drb_pool);
 	phba->lpfc_nvmet_drb_pool = NULL;
-	if (phba->lpfc_drb_pool)
-		dma_pool_destroy(phba->lpfc_drb_pool);
+
+	dma_pool_destroy(phba->lpfc_drb_pool);
 	phba->lpfc_drb_pool = NULL;
-	if (phba->lpfc_hrb_pool)
-		dma_pool_destroy(phba->lpfc_hrb_pool);
+
+	dma_pool_destroy(phba->lpfc_hrb_pool);
 	phba->lpfc_hrb_pool = NULL;
-	if (phba->txrdy_payload_pool)
-		dma_pool_destroy(phba->txrdy_payload_pool);
+
+	dma_pool_destroy(phba->txrdy_payload_pool);
 	phba->txrdy_payload_pool = NULL;
 
-	if (phba->lpfc_hbq_pool)
-		dma_pool_destroy(phba->lpfc_hbq_pool);
+	dma_pool_destroy(phba->lpfc_hbq_pool);
 	phba->lpfc_hbq_pool = NULL;
 
-	if (phba->rrq_pool)
-		mempool_destroy(phba->rrq_pool);
+	mempool_destroy(phba->rrq_pool);
 	phba->rrq_pool = NULL;
 
 	/* Free NLP memory pool */
-- 
2.7.4
