From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 15/17] lpfc: Fix defects reported by Coverity Scan
Date: Thu,  1 Jun 2017 21:07:09 -0700
Message-ID: <20170602040711.21046-16-jsmart2021@gmail.com>
References: <20170602040711.21046-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:34786 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751216AbdFBEIS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2017 00:08:18 -0400
Received: by mail-qt0-f194.google.com with SMTP id o21so107355qtb.1
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jun 2017 21:08:12 -0700 (PDT)
In-Reply-To: <20170602040711.21046-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Addressed the following reported defects:

** CID 1411552:  Control flow issues  (MISSING_BREAK)
/drivers/scsi/lpfc/lpfc_sli.c: 13259 in lpfc_sli4_nvmet_handle_rcqe()

** CID 1411553:  Memory - illegal accesses  (OVERRUN)
/drivers/scsi/lpfc/lpfc_sli.c: 16218 in lpfc_fc_frame_check()

** CID 1411553:  Memory - illegal accesses  (OVERRUN)
   Overrunning array "lpfc_rctl_names" of 202 8-byte elements at element
   index 244 (byte offset 1952) using index "fc_hdr->fh_r_ctl" (which
   evaluates to 244).

** CID 1411554:  Null pointer dereferences  (REVERSE_INULL)
/drivers/scsi/lpfc/lpfc_nvmet.c: 2131 in lpfc_nvmet_unsol_fcp_abort_cmp()

** CID 1411555:  Memory - illegal accesses  (UNINIT)
/drivers/scsi/lpfc/lpfc_nvmet.c: 180 in lpfc_nvmet_ctxbuf_post()

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 10 ++++------
 drivers/scsi/lpfc/lpfc_sli.c   | 24 +++++++++---------------
 2 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 9d8c4f07a2be..64908bef6f11 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -170,7 +170,6 @@ lpfc_nvmet_ctxbuf_post(struct lpfc_hba *phba, struct lpfc_nvmet_ctxbuf *ctx_buf)
 	struct lpfc_nvmet_tgtport *tgtp;
 	struct fc_frame_header *fc_hdr;
 	struct rqb_dmabuf *nvmebuf;
-	struct lpfc_dmabuf *hbufp;
 	uint32_t *payload;
 	uint32_t size, oxid, sid, rc;
 	unsigned long iflag;
@@ -191,7 +190,6 @@ lpfc_nvmet_ctxbuf_post(struct lpfc_hba *phba, struct lpfc_nvmet_ctxbuf *ctx_buf)
 
 	spin_lock_irqsave(&phba->sli4_hba.nvmet_io_wait_lock, iflag);
 	if (phba->sli4_hba.nvmet_io_wait_cnt) {
-		hbufp = &nvmebuf->hbuf;
 		list_remove_head(&phba->sli4_hba.lpfc_nvmet_io_wait_list,
 				 nvmebuf, struct rqb_dmabuf,
 				 hbuf.list);
@@ -2165,10 +2163,6 @@ lpfc_nvmet_unsol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 	status = bf_get(lpfc_wcqe_c_status, wcqe);
 	result = wcqe->parameter;
 
-	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
-	if (ctxp->flag & LPFC_NVMET_ABORT_OP)
-		atomic_inc(&tgtp->xmt_fcp_abort_cmpl);
-
 	if (!ctxp) {
 		/* if context is clear, related io alrady complete */
 		lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
@@ -2178,6 +2172,10 @@ lpfc_nvmet_unsol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 		return;
 	}
 
+	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
+	if (ctxp->flag & LPFC_NVMET_ABORT_OP)
+		atomic_inc(&tgtp->xmt_fcp_abort_cmpl);
+
 	/* Sanity check */
 	if (ctxp->state != LPFC_NVMET_STE_ABORT) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_ABTS,
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index fb4c708ae747..f60c9e3e37d7 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -13267,6 +13267,7 @@ lpfc_sli4_nvmet_handle_rcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	case FC_STATUS_RQ_BUF_LEN_EXCEEDED:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"6126 Receive Frame Truncated!!\n");
+		/* Drop thru */
 	case FC_STATUS_RQ_SUCCESS:
 		lpfc_sli4_rq_release(hrq, drq);
 		spin_lock_irqsave(&phba->hbalock, iflags);
@@ -16137,9 +16138,6 @@ lpfc_sli4_post_scsi_sgl_block(struct lpfc_hba *phba,
 	return rc;
 }
 
-static char *lpfc_rctl_names[] = FC_RCTL_NAMES_INIT;
-static char *lpfc_type_names[] = FC_TYPE_NAMES_INIT;
-
 /**
  * lpfc_fc_frame_check - Check that this frame is a valid frame to handle
  * @phba: pointer to lpfc_hba struct that the frame was received on
@@ -16214,22 +16212,18 @@ lpfc_fc_frame_check(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr)
 	}
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
-			"2538 Received frame rctl:%s (x%x), type:%s (x%x), "
+			"2538 Received frame rctl:x%x, type:x%x, "
 			"frame Data:%08x %08x %08x %08x %08x %08x %08x\n",
-			(fc_hdr->fh_r_ctl == FC_RCTL_MDS_DIAGS) ? "MDS Diags" :
-			lpfc_rctl_names[fc_hdr->fh_r_ctl], fc_hdr->fh_r_ctl,
-			(fc_hdr->fh_type == FC_TYPE_VENDOR_UNIQUE) ?
-			"Vendor Unique" : lpfc_type_names[fc_hdr->fh_type],
-			fc_hdr->fh_type, be32_to_cpu(header[0]),
-			be32_to_cpu(header[1]), be32_to_cpu(header[2]),
-			be32_to_cpu(header[3]), be32_to_cpu(header[4]),
-			be32_to_cpu(header[5]), be32_to_cpu(header[6]));
+			fc_hdr->fh_r_ctl, fc_hdr->fh_type,
+			be32_to_cpu(header[0]), be32_to_cpu(header[1]),
+			be32_to_cpu(header[2]), be32_to_cpu(header[3]),
+			be32_to_cpu(header[4]), be32_to_cpu(header[5]),
+			be32_to_cpu(header[6]));
 	return 0;
 drop:
 	lpfc_printf_log(phba, KERN_WARNING, LOG_ELS,
-			"2539 Dropped frame rctl:%s type:%s\n",
-			lpfc_rctl_names[fc_hdr->fh_r_ctl],
-			lpfc_type_names[fc_hdr->fh_type]);
+			"2539 Dropped frame rctl:x%x type:x%x\n",
+			fc_hdr->fh_r_ctl, fc_hdr->fh_type);
 	return 1;
 }
 
-- 
2.11.0
