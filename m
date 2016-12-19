From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 08/11] lpfc: Deprecate lpfc_prot_sg_seg_cnt parameter
Date: Mon, 19 Dec 2016 14:35:30 -0800
Message-ID: <585860b2.w1eWCtiavwNk6a3Q%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:49937 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933073AbcLSWfe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2016 17:35:34 -0500
Received: from flash (fx9xs32.lab.emulex.com [138.239.87.14])
        by relay.smtp.broadcom.com (Postfix) with SMTP id 93C642803E4
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2016 14:35:32 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Deprecate lpfc_prot_sg_seg_cnt parameter. Eliminates driver from
unnecessarily limiting DIF s/g list length.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h      |  1 -
 drivers/scsi/lpfc/lpfc_attr.c | 10 ----------
 2 files changed, 11 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 341b656e..c2e6ffd 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -727,7 +727,6 @@ struct lpfc_hba {
 	uint32_t cfg_fcp_io_channel;
 	uint32_t cfg_total_seg_cnt;
 	uint32_t cfg_sg_seg_cnt;
-	uint32_t cfg_prot_sg_seg_cnt;
 	uint32_t cfg_sg_dma_buf_size;
 	uint32_t cfg_hba_queue_depth;
 	uint32_t cfg_enable_hba_reset;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index c30fafe..8301c08 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -4466,14 +4466,6 @@ LPFC_ATTR_R(sg_seg_cnt, LPFC_DEFAULT_SG_SEG_CNT, LPFC_DEFAULT_SG_SEG_CNT,
 	    LPFC_MAX_SG_SEG_CNT, "Max Scatter Gather Segment Count");
 
 /*
- * This parameter will be depricated, the driver cannot limit the
- * protection data s/g list.
- */
-LPFC_ATTR_R(prot_sg_seg_cnt, LPFC_DEFAULT_SG_SEG_CNT,
-	    LPFC_DEFAULT_SG_SEG_CNT, LPFC_MAX_SG_SEG_CNT,
-	    "Max Protection Scatter Gather Segment Count");
-
-/*
  * lpfc_enable_mds_diags: Enable MDS Diagnostics
  *       0  = MDS Diagnostics disabled (default)
  *       1  = MDS Diagnostics enabled
@@ -4559,7 +4551,6 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_sg_seg_cnt,
 	&dev_attr_lpfc_max_scsicmpl_time,
 	&dev_attr_lpfc_stat_data_ctrl,
-	&dev_attr_lpfc_prot_sg_seg_cnt,
 	&dev_attr_lpfc_aer_support,
 	&dev_attr_lpfc_aer_state_cleanup,
 	&dev_attr_lpfc_sriov_nr_virtfn,
@@ -5576,7 +5567,6 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 		phba->cfg_poll = lpfc_poll;
 
 	lpfc_sg_seg_cnt_init(phba, lpfc_sg_seg_cnt);
-	lpfc_prot_sg_seg_cnt_init(phba, lpfc_prot_sg_seg_cnt);
 	lpfc_hba_queue_depth_init(phba, lpfc_hba_queue_depth);
 	lpfc_hba_log_verbose_init(phba, lpfc_log_verbose);
 	lpfc_aer_support_init(phba, lpfc_aer_support);
-- 
2.5.0


