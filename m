From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 1/2] scsi: lpfc: spin_lock_irq() is not nestable
Date: Fri, 30 Jun 2017 11:02:51 +0300
Message-ID: <20170630080250.mjbosf64qlytrsii@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We're calling spin_lock_irq() multiple times, the problem is that on the
first spin_unlock_irq() then we will re-enable IRQs and we don't want
that.

Fixes: 966bb5b71196 ("scsi: lpfc: Break up IO ctx list into a separate get and put list")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 7dc061a14f95..afc523209845 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -866,44 +866,44 @@ lpfc_nvmet_cleanup_io_context(struct lpfc_hba *phba)
 	unsigned long flags;
 
 	spin_lock_irqsave(&phba->sli4_hba.nvmet_ctx_get_lock, flags);
-	spin_lock_irq(&phba->sli4_hba.nvmet_ctx_put_lock);
+	spin_lock(&phba->sli4_hba.nvmet_ctx_put_lock);
 	list_for_each_entry_safe(ctx_buf, next_ctx_buf,
 			&phba->sli4_hba.lpfc_nvmet_ctx_get_list, list) {
-		spin_lock_irq(&phba->sli4_hba.abts_nvme_buf_list_lock);
+		spin_lock(&phba->sli4_hba.abts_nvme_buf_list_lock);
 		list_del_init(&ctx_buf->list);
-		spin_unlock_irq(&phba->sli4_hba.abts_nvme_buf_list_lock);
+		spin_unlock(&phba->sli4_hba.abts_nvme_buf_list_lock);
 		__lpfc_clear_active_sglq(phba,
 					 ctx_buf->sglq->sli4_lxritag);
 		ctx_buf->sglq->state = SGL_FREED;
 		ctx_buf->sglq->ndlp = NULL;
 
-		spin_lock_irq(&phba->sli4_hba.sgl_list_lock);
+		spin_lock(&phba->sli4_hba.sgl_list_lock);
 		list_add_tail(&ctx_buf->sglq->list,
 			      &phba->sli4_hba.lpfc_nvmet_sgl_list);
-		spin_unlock_irq(&phba->sli4_hba.sgl_list_lock);
+		spin_unlock(&phba->sli4_hba.sgl_list_lock);
 
 		lpfc_sli_release_iocbq(phba, ctx_buf->iocbq);
 		kfree(ctx_buf->context);
 	}
 	list_for_each_entry_safe(ctx_buf, next_ctx_buf,
 			&phba->sli4_hba.lpfc_nvmet_ctx_put_list, list) {
-		spin_lock_irq(&phba->sli4_hba.abts_nvme_buf_list_lock);
+		spin_lock(&phba->sli4_hba.abts_nvme_buf_list_lock);
 		list_del_init(&ctx_buf->list);
-		spin_unlock_irq(&phba->sli4_hba.abts_nvme_buf_list_lock);
+		spin_unlock(&phba->sli4_hba.abts_nvme_buf_list_lock);
 		__lpfc_clear_active_sglq(phba,
 					 ctx_buf->sglq->sli4_lxritag);
 		ctx_buf->sglq->state = SGL_FREED;
 		ctx_buf->sglq->ndlp = NULL;
 
-		spin_lock_irq(&phba->sli4_hba.sgl_list_lock);
+		spin_lock(&phba->sli4_hba.sgl_list_lock);
 		list_add_tail(&ctx_buf->sglq->list,
 			      &phba->sli4_hba.lpfc_nvmet_sgl_list);
-		spin_unlock_irq(&phba->sli4_hba.sgl_list_lock);
+		spin_unlock(&phba->sli4_hba.sgl_list_lock);
 
 		lpfc_sli_release_iocbq(phba, ctx_buf->iocbq);
 		kfree(ctx_buf->context);
 	}
-	spin_unlock_irq(&phba->sli4_hba.nvmet_ctx_put_lock);
+	spin_unlock(&phba->sli4_hba.nvmet_ctx_put_lock);
 	spin_unlock_irqrestore(&phba->sli4_hba.nvmet_ctx_get_lock, flags);
 }
 
