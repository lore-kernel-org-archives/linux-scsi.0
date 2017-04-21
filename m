From: jsmart2021@gmail.com
Subject: [PATCH v3 17/22] Fix max_sgl_segments settings for NVME / NVMET
Date: Fri, 21 Apr 2017 16:05:01 -0700
Message-ID: <20170421230506.925-18-jsmart2021@gmail.com>
References: <20170421230506.925-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34460 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1426493AbdDUXFe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 19:05:34 -0400
Received: by mail-oi0-f65.google.com with SMTP id y11so21737332oie.1
        for <linux-scsi@vger.kernel.org>; Fri, 21 Apr 2017 16:05:34 -0700 (PDT)
In-Reply-To: <20170421230506.925-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

Cannot set NVME segment counts to a large number

The existing module parameter lpfc_sg_seg_cnt is used for both
SCSI and NVME.

Limit the module parameter lpfc_sg_seg_cnt to 128 with the
default being 64 for both NVME and NVMET, assuming NVME is enabled in the
driver for that port. The driver will set max_sgl_segments in the
NVME/NVMET template to lpfc_sg_seg_cnt + 1.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc.h       |  3 ++-
 drivers/scsi/lpfc/lpfc_nvme.c  | 18 ++++++++++++++----
 drivers/scsi/lpfc/lpfc_nvmet.c | 19 +++++++++++++++----
 3 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 257bbdd..0fc1450 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -56,7 +56,7 @@ struct lpfc_sli2_slim;
 #define LPFC_MAX_SG_SEG_CNT	4096	/* sg element count per scsi cmnd */
 #define LPFC_MAX_SGL_SEG_CNT	512	/* SGL element count per scsi cmnd */
 #define LPFC_MAX_BPL_SEG_CNT	4096	/* BPL element count per scsi cmnd */
-#define LPFC_MIN_NVME_SEG_CNT	254
+#define LPFC_MAX_NVME_SEG_CNT	128	/* max SGL element cnt per NVME cmnd */
 
 #define LPFC_MAX_SGE_SIZE       0x80000000 /* Maximum data allowed in a SGE */
 #define LPFC_IOCB_LIST_CNT	2250	/* list of IOCBs for fast-path usage. */
@@ -781,6 +781,7 @@ struct lpfc_hba {
 	uint32_t cfg_nvmet_fb_size;
 	uint32_t cfg_total_seg_cnt;
 	uint32_t cfg_sg_seg_cnt;
+	uint32_t cfg_nvme_seg_cnt;
 	uint32_t cfg_sg_dma_buf_size;
 	uint64_t cfg_soft_wwnn;
 	uint64_t cfg_soft_wwpn;
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index cb1e82b..278ae00 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1114,12 +1114,12 @@ lpfc_nvme_prep_io_dma(struct lpfc_vport *vport,
 
 		first_data_sgl = sgl;
 		lpfc_ncmd->seg_cnt = nCmd->sg_cnt;
-		if (lpfc_ncmd->seg_cnt > phba->cfg_sg_seg_cnt) {
+		if (lpfc_ncmd->seg_cnt > phba->cfg_nvme_seg_cnt) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
 					"6058 Too many sg segments from "
 					"NVME Transport.  Max %d, "
 					"nvmeIO sg_cnt %d\n",
-					phba->cfg_sg_seg_cnt,
+					phba->cfg_nvme_seg_cnt,
 					lpfc_ncmd->seg_cnt);
 			lpfc_ncmd->seg_cnt = 0;
 			return 1;
@@ -2158,8 +2158,18 @@ lpfc_nvme_create_localport(struct lpfc_vport *vport)
 	nfcp_info.node_name = wwn_to_u64(vport->fc_nodename.u.wwn);
 	nfcp_info.port_name = wwn_to_u64(vport->fc_portname.u.wwn);
 
-	/* For now need + 1 to get around NVME transport logic */
-	lpfc_nvme_template.max_sgl_segments = phba->cfg_sg_seg_cnt + 1;
+	/* Limit to LPFC_MAX_NVME_SEG_CNT.
+	 * For now need + 1 to get around NVME transport logic.
+	 */
+	if (phba->cfg_sg_seg_cnt > LPFC_MAX_NVME_SEG_CNT) {
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME | LOG_INIT,
+				 "6300 Reducing sg segment cnt to %d\n",
+				 LPFC_MAX_NVME_SEG_CNT);
+		phba->cfg_nvme_seg_cnt = LPFC_MAX_NVME_SEG_CNT;
+	} else {
+		phba->cfg_nvme_seg_cnt = phba->cfg_sg_seg_cnt;
+	}
+	lpfc_nvme_template.max_sgl_segments = phba->cfg_nvme_seg_cnt + 1;
 	lpfc_nvme_template.max_hw_queues = phba->cfg_nvme_io_channel;
 
 	/* localport is allocated from the stack, but the registration
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 8348bb5..d0dda42 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -704,8 +704,19 @@ lpfc_nvmet_create_targetport(struct lpfc_hba *phba)
 	pinfo.port_name = wwn_to_u64(vport->fc_portname.u.wwn);
 	pinfo.port_id = vport->fc_myDID;
 
+	/* Limit to LPFC_MAX_NVME_SEG_CNT.
+	 * For now need + 1 to get around NVME transport logic.
+	 */
+	if (phba->cfg_sg_seg_cnt > LPFC_MAX_NVME_SEG_CNT) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_NVME | LOG_INIT,
+				"6400 Reducing sg segment cnt to %d\n",
+				LPFC_MAX_NVME_SEG_CNT);
+		phba->cfg_nvme_seg_cnt = LPFC_MAX_NVME_SEG_CNT;
+	} else {
+		phba->cfg_nvme_seg_cnt = phba->cfg_sg_seg_cnt;
+	}
+	lpfc_tgttemplate.max_sgl_segments = phba->cfg_nvme_seg_cnt + 1;
 	lpfc_tgttemplate.max_hw_queues = phba->cfg_nvme_io_channel;
-	lpfc_tgttemplate.max_sgl_segments = phba->cfg_sg_seg_cnt + 1;
 	lpfc_tgttemplate.target_features = NVMET_FCTGTFEAT_READDATA_RSP |
 					   NVMET_FCTGTFEAT_NEEDS_CMD_CPUSCHED |
 					   NVMET_FCTGTFEAT_CMD_IN_ISR |
@@ -1278,11 +1289,11 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 		return NULL;
 	}
 
-	if (rsp->sg_cnt > phba->cfg_sg_seg_cnt) {
+	if (rsp->sg_cnt > phba->cfg_nvme_seg_cnt) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
 				"6109 lpfc_nvmet_prep_fcp_wqe: seg cnt err: "
-				"NPORT x%x oxid:x%x\n",
-				ctxp->sid, ctxp->oxid);
+				"NPORT x%x oxid:x%x cnt %d\n",
+				ctxp->sid, ctxp->oxid, phba->cfg_nvme_seg_cnt);
 		return NULL;
 	}
 
-- 
2.9.3
