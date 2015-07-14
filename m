From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/3] [RESEND] ipr: Fix locking for unit attention handling
Date: Tue, 14 Jul 2015 11:41:29 -0500
Message-ID: <201507141641.t6EGfUKf005602@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:52195 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbbGNQle (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2015 12:41:34 -0400
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Tue, 14 Jul 2015 10:41:34 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, stable@vger.kernel.org, krisman@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com


Make sure we have the host lock held when calling scsi_report_bus_reset. Fixes
a crash seen as the __devices list in the scsi host was changing as we were
iterating through it.

Cc: <stable@vger.kernel.org>
Reviewed-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
Reviewed-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_erp_start_locking drivers/scsi/ipr.c
--- linux/drivers/scsi/ipr.c~ipr_erp_start_locking	2015-07-14 11:10:18.015330839 -0500
+++ linux-bjking1/drivers/scsi/ipr.c	2015-07-14 11:10:50.445165558 -0500
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

