From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH] scsi: lpfc: NULL check before some freeing functions is
 not needed.
Date: Sun, 02 Dec 2018 21:52:11 +0100
Message-ID: <1543760930051-7732605-9-diffsplit-thomas@m3y3r.de>
References: <1543760930050-1499171309-0-diffsplit-thomas@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1543760930050-1499171309-0-diffsplit-thomas@m3y3r.de>
Sender: linux-kernel-owner@vger.kernel.org
To: james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

NULL check before some freeing functions is not needed.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1276,8 +1276,7 @@ lpfc_bsg_hba_set_event(struct bsg_job *j
 	return 0; /* call job done later */
 
 job_error:
-	if (dd_data != NULL)
-		kfree(dd_data);
+	kfree(dd_data);
 
 	job->dd_data = NULL;
 	return rc;
diff -u -p a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12450,8 +12450,7 @@ lpfc_sli4_oas_verify(struct lpfc_hba *ph
 		phba->cfg_fof = 1;
 	} else {
 		phba->cfg_fof = 0;
-		if (phba->device_data_mem_pool)
-			mempool_destroy(phba->device_data_mem_pool);
+		mempool_destroy(phba->device_data_mem_pool);
 		phba->device_data_mem_pool = NULL;
 	}
 
diff -u -p a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -248,25 +248,19 @@ lpfc_mem_free(struct lpfc_hba *phba)
 
 	/* Free HBQ pools */
 	lpfc_sli_hbqbuf_free_all(phba);
-	if (phba->lpfc_nvmet_drb_pool)
-		dma_pool_destroy(phba->lpfc_nvmet_drb_pool);
+	dma_pool_destroy(phba->lpfc_nvmet_drb_pool);
 	phba->lpfc_nvmet_drb_pool = NULL;
-	if (phba->lpfc_drb_pool)
-		dma_pool_destroy(phba->lpfc_drb_pool);
+	dma_pool_destroy(phba->lpfc_drb_pool);
 	phba->lpfc_drb_pool = NULL;
-	if (phba->lpfc_hrb_pool)
-		dma_pool_destroy(phba->lpfc_hrb_pool);
+	dma_pool_destroy(phba->lpfc_hrb_pool);
 	phba->lpfc_hrb_pool = NULL;
-	if (phba->txrdy_payload_pool)
-		dma_pool_destroy(phba->txrdy_payload_pool);
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
