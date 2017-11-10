From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 16/17] lpfc: small sg cnt cleanup
Date: Thu,  9 Nov 2017 17:08:33 -0800
Message-ID: <20171110010834.4542-17-jsmart2021@gmail.com>
References: <20171110010834.4542-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:49506 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755540AbdKJBI7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Nov 2017 20:08:59 -0500
Received: by mail-qt0-f169.google.com with SMTP id y45so3921002qty.6
        for <linux-scsi@vger.kernel.org>; Thu, 09 Nov 2017 17:08:59 -0800 (PST)
In-Reply-To: <20171110010834.4542-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

The logic for sg_seg_cnt is a bit convoluted. This patch tries to
clean up a couple of areas, especially around the +2 and +1 logic.

This patch:
- cleans up the lpfc_sg_seg_cnt attribute to specify a real minimum
  rather than making the minimum be whatever the default is.
- Remove the hardcoding of +2 (for the number of elements we use in
  a sgl for cmd iu and rsp iu) and +1 (an additional entry to
  compensate for nvme's reduction of io size based on a possible
  partial page) logic in sg list initialization. In the case where
  the +1 logic is referenced in host and target io checks, use the
  values set in the transport template as that value was properly set.

There can certainly be more done in this area and it will be addressed
in combined host/target driver effort.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h       |  1 +
 drivers/scsi/lpfc/lpfc_attr.c  |  2 +-
 drivers/scsi/lpfc/lpfc_init.c  | 19 ++++++++++++++-----
 drivers/scsi/lpfc/lpfc_nvme.c  |  3 ++-
 drivers/scsi/lpfc/lpfc_nvmet.c |  2 +-
 5 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 46a89bdff8e4..dd2191c83052 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -55,6 +55,7 @@ struct lpfc_sli2_slim;
 #define LPFC_MAX_SG_SLI4_SEG_CNT_DIF 128 /* sg element count per scsi cmnd */
 #define LPFC_MAX_SG_SEG_CNT_DIF 512	/* sg element count per scsi cmnd  */
 #define LPFC_MAX_SG_SEG_CNT	4096	/* sg element count per scsi cmnd */
+#define LPFC_MIN_SG_SEG_CNT	32	/* sg element count per scsi cmnd */
 #define LPFC_MAX_SGL_SEG_CNT	512	/* SGL element count per scsi cmnd */
 #define LPFC_MAX_BPL_SEG_CNT	4096	/* BPL element count per scsi cmnd */
 #define LPFC_MAX_NVME_SEG_CNT	256	/* max SGL element cnt per NVME cmnd */
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 598e07f43912..74d6fe984df4 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -5135,7 +5135,7 @@ LPFC_ATTR(delay_discovery, 0, 0, 1,
  * this parameter will be limited to 128 if BlockGuard is enabled under SLI4
  * and will be limited to 512 if BlockGuard is enabled under SLI3.
  */
-LPFC_ATTR_R(sg_seg_cnt, LPFC_DEFAULT_SG_SEG_CNT, LPFC_DEFAULT_SG_SEG_CNT,
+LPFC_ATTR_R(sg_seg_cnt, LPFC_MIN_SG_SEG_CNT, LPFC_DEFAULT_SG_SEG_CNT,
 	    LPFC_MAX_SG_SEG_CNT, "Max Scatter Gather Segment Count");
 
 /*
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index c466ceb43bc9..92dc865ca52c 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5812,6 +5812,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	struct lpfc_mqe *mqe;
 	int longs;
 	int fof_vectors = 0;
+	int extra;
 	uint64_t wwn;
 
 	phba->sli4_hba.num_online_cpu = num_online_cpus();
@@ -5867,13 +5868,21 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	 */
 
 	/*
+	 * 1 for cmd, 1 for rsp, NVME adds an extra one
+	 * for boundary conditions in its max_sgl_segment template.
+	 */
+	extra = 2;
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME)
+		extra++;
+
+	/*
 	 * It doesn't matter what family our adapter is in, we are
 	 * limited to 2 Pages, 512 SGEs, for our SGL.
 	 * There are going to be 2 reserved SGEs: 1 FCP cmnd + 1 FCP rsp
 	 */
 	max_buf_size = (2 * SLI4_PAGE_SIZE);
-	if (phba->cfg_sg_seg_cnt > LPFC_MAX_SGL_SEG_CNT - 2)
-		phba->cfg_sg_seg_cnt = LPFC_MAX_SGL_SEG_CNT - 2;
+	if (phba->cfg_sg_seg_cnt > LPFC_MAX_SGL_SEG_CNT - extra)
+		phba->cfg_sg_seg_cnt = LPFC_MAX_SGL_SEG_CNT - extra;
 
 	/*
 	 * Since lpfc_sg_seg_cnt is module param, the sg_dma_buf_size
@@ -5906,14 +5915,14 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		 */
 		phba->cfg_sg_dma_buf_size = sizeof(struct fcp_cmnd) +
 				sizeof(struct fcp_rsp) +
-				((phba->cfg_sg_seg_cnt + 2) *
+				((phba->cfg_sg_seg_cnt + extra) *
 				sizeof(struct sli4_sge));
 
 		/* Total SGEs for scsi_sg_list */
-		phba->cfg_total_seg_cnt = phba->cfg_sg_seg_cnt + 2;
+		phba->cfg_total_seg_cnt = phba->cfg_sg_seg_cnt + extra;
 
 		/*
-		 * NOTE: if (phba->cfg_sg_seg_cnt + 2) <= 256 we only
+		 * NOTE: if (phba->cfg_sg_seg_cnt + extra) <= 256 we only
 		 * need to post 1 page for the SGL.
 		 */
 	}
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 67bd0ff299d1..0a42956058e9 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -62,6 +62,7 @@ lpfc_get_nvme_buf(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp);
 static void
 lpfc_release_nvme_buf(struct lpfc_hba *, struct lpfc_nvme_buf *);
 
+static struct nvme_fc_port_template lpfc_nvme_template;
 
 /**
  * lpfc_nvme_create_queue -
@@ -1174,7 +1175,7 @@ lpfc_nvme_prep_io_dma(struct lpfc_vport *vport,
 
 		first_data_sgl = sgl;
 		lpfc_ncmd->seg_cnt = nCmd->sg_cnt;
-		if (lpfc_ncmd->seg_cnt > phba->cfg_nvme_seg_cnt + 1) {
+		if (lpfc_ncmd->seg_cnt > lpfc_nvme_template.max_sgl_segments) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
 					"6058 Too many sg segments from "
 					"NVME Transport.  Max %d, "
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 2b50aecc2722..d80cd1def3b9 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -2003,7 +2003,7 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 		return NULL;
 	}
 
-	if (rsp->sg_cnt > phba->cfg_nvme_seg_cnt) {
+	if (rsp->sg_cnt > lpfc_tgttemplate.max_sgl_segments) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
 				"6109 NVMET prep FCP wqe: seg cnt err: "
 				"NPORT x%x oxid x%x ste %d cnt %d\n",
-- 
2.13.1
