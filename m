From: Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [lpfc 02/19] Fixes after reviewing last set of patches. Minor fixes to previous patches
Date: Tue,  4 Apr 2017 10:16:55 -0700
Message-ID: <1491326232-11255-3-git-send-email-rkennedy@broadcom.com>
References: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:38140 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755013AbdDDRZh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2017 13:25:37 -0400
Received: from pallmd1.broadcom.com (pallmd1.ash.broadcom.net [10.85.232.165])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id C31A530C099
        for <linux-scsi@vger.kernel.org>; Tue,  4 Apr 2017 10:17:24 -0700 (PDT)
In-Reply-To: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <rkennedy@lvnvda1400.lvn.broadcom.net>

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c    |  6 +++++-
 drivers/scsi/lpfc/lpfc_debugfs.c | 14 ++++----------
 drivers/scsi/lpfc/lpfc_init.c    |  6 ++++++
 drivers/scsi/lpfc/lpfc_nvme.h    |  3 ---
 4 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 22819af..9e66cb0 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -4458,7 +4458,11 @@ lpfc_fcp_imax_store(struct device *dev, struct device_attribute *attr,
 
 	phba->cfg_fcp_imax = (uint32_t)val;
 
-	for (i = 0; i < phba->io_channel_irqs; i += LPFC_MAX_EQ_DELAY_EQID_CNT)
+	/*
+	 * Configure EQ delay multipier for interrupt coalescing using
+	 * MODIFY_EQ_DELAY for all EQs created, LPFC_MAX_EQ_DELAY at a time.
+	 */
+	for (i = 0; i < phba->io_channel_irqs; i += LPFC_MAX_EQ_DELAY)
 		lpfc_modify_hba_eq_delay(phba, i);
 
 	return strlen(buf);
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 913eed8..55a8d8f 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -3128,8 +3128,6 @@ __lpfc_idiag_print_rqpair(struct lpfc_queue *qp, struct lpfc_queue *datqp,
 			datqp->queue_id, datqp->entry_count,
 			datqp->entry_size, datqp->host_index,
 			datqp->hba_index);
-	len +=  snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len, "\n");
-
 	return len;
 }
 
@@ -5700,10 +5698,8 @@ lpfc_debugfs_terminate(struct lpfc_vport *vport)
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	struct lpfc_hba   *phba = vport->phba;
 
-	if (vport->disc_trc) {
-		kfree(vport->disc_trc);
-		vport->disc_trc = NULL;
-	}
+	kfree(vport->disc_trc);
+	vport->disc_trc = NULL;
 
 	debugfs_remove(vport->debug_disc_trc); /* discovery_trace */
 	vport->debug_disc_trc = NULL;
@@ -5770,10 +5766,8 @@ lpfc_debugfs_terminate(struct lpfc_vport *vport)
 		debugfs_remove(phba->debug_readRef); /* readRef */
 		phba->debug_readRef = NULL;
 
-		if (phba->slow_ring_trc) {
-			kfree(phba->slow_ring_trc);
-			phba->slow_ring_trc = NULL;
-		}
+		kfree(phba->slow_ring_trc);
+		phba->slow_ring_trc = NULL;
 
 		/* slow_ring_trace */
 		debugfs_remove(phba->debug_slow_ring_trc);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 6cc561b..b56da01 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3508,6 +3508,12 @@ lpfc_sli4_scsi_sgl_update(struct lpfc_hba *phba)
 	spin_unlock(&phba->scsi_buf_list_put_lock);
 	spin_unlock_irq(&phba->scsi_buf_list_get_lock);
 
+	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+			"6060 Current allocated SCSI xri-sgl count:%d, "
+			"maximum  SCSI xri count:%d (split:%d)\n",
+			phba->sli4_hba.scsi_xri_cnt,
+			phba->sli4_hba.scsi_xri_max, phba->cfg_xri_split);
+
 	if (phba->sli4_hba.scsi_xri_cnt > phba->sli4_hba.scsi_xri_max) {
 		/* max scsi xri shrinked below the allocated scsi buffers */
 		scsi_xri_cnt = phba->sli4_hba.scsi_xri_cnt -
diff --git a/drivers/scsi/lpfc/lpfc_nvme.h b/drivers/scsi/lpfc/lpfc_nvme.h
index 6277796..2582f46 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.h
+++ b/drivers/scsi/lpfc/lpfc_nvme.h
@@ -22,9 +22,6 @@
  ********************************************************************/
 
 #define LPFC_NVME_DEFAULT_SEGS		(64 + 1)	/* 256K IOs */
-#define LPFC_NVMET_MIN_POSTBUF		16
-#define LPFC_NVMET_DEFAULT_POSTBUF	1024
-#define LPFC_NVMET_MAX_POSTBUF		4096
 #define LPFC_NVME_WQSIZE		256
 
 #define LPFC_NVME_ERSP_LEN		0x20
-- 
2.1.0
