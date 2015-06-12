From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/4] ipr: Fix locking for unit attention handling
Date: Thu, 11 Jun 2015 20:45:15 -0500
Message-ID: <201506120145.t5C1jFQW016709@d01av04.pok.ibm.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, gbertazi@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Make sure we have the host lock held when calling scsi_report_bus_reset. Fixes
a crash seen as the __devices list in the scsi host was changing as we were
iterating through it.

Cc: <stable@vger.kernel.org>
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_erp_start_locking drivers/scsi/ipr.c
--- linux/drivers/scsi/ipr.c~ipr_erp_start_locking	2015-06-11 20:18:13.806674185 -0500
+++ linux-bjking1/drivers/scsi/ipr.c	2015-06-11 20:18:13.814674115 -0500
@@ -6263,21 +6263,23 @@ static void ipr_scsi_done(struct ipr_cmn
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 	struct scsi_cmnd *scsi_cmd = ipr_cmd->scsi_cmd;
 	u32 ioasc = be32_to_cpu(ipr_cmd->s.ioasa.hdr.ioasc);
-	unsigned long hrrq_flags;
+	unsigned long lock_flags;
 
 	scsi_set_resid(scsi_cmd, be32_to_cpu(ipr_cmd->s.ioasa.hdr.residual_data_len));
 
 	if (likely(IPR_IOASC_SENSE_KEY(ioasc) == 0)) {
 		scsi_dma_unmap(scsi_cmd);
 
-		spin_lock_irqsave(ipr_cmd->hrrq->lock, hrrq_flags);
+		spin_lock_irqsave(ipr_cmd->hrrq->lock, lock_flags);
 		list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
 		scsi_cmd->scsi_done(scsi_cmd);
-		spin_unlock_irqrestore(ipr_cmd->hrrq->lock, hrrq_flags);
+		spin_unlock_irqrestore(ipr_cmd->hrrq->lock, lock_flags);
 	} else {
-		spin_lock_irqsave(ipr_cmd->hrrq->lock, hrrq_flags);
+		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+		spin_lock(&ipr_cmd->hrrq->_lock);
 		ipr_erp_start(ioa_cfg, ipr_cmd);
-		spin_unlock_irqrestore(ipr_cmd->hrrq->lock, hrrq_flags);
+		spin_unlock(&ipr_cmd->hrrq->_lock);
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 	}
 }
 
_
