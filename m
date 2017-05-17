From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH] lpfc: fix build issue if NVME_FC_TARGET is not defined
Date: Tue, 16 May 2017 20:52:29 -0700
Message-ID: <20170517035229.1145-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34855 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751319AbdEQDwp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 May 2017 23:52:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sfr@canb.auug.org.au, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, hare@suse.com
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

fix build issue if NVME_FC_TARGET is not defined. noop the code.
The code will never be invoked if target mode is not enabled.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 312f54278bd4..f94294b77b7b 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -157,6 +157,7 @@ lpfc_nvmet_xmt_ls_rsp_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 void
 lpfc_nvmet_ctxbuf_post(struct lpfc_hba *phba, struct lpfc_nvmet_ctxbuf *ctx_buf)
 {
+#if (IS_ENABLED(CONFIG_NVME_TARGET_FC))
 	struct lpfc_nvmet_rcv_ctx *ctxp = ctx_buf->context;
 	struct lpfc_nvmet_tgtport *tgtp;
 	struct fc_frame_header *fc_hdr;
@@ -260,6 +261,7 @@ lpfc_nvmet_ctxbuf_post(struct lpfc_hba *phba, struct lpfc_nvmet_ctxbuf *ctx_buf)
 		      &phba->sli4_hba.lpfc_nvmet_ctx_list);
 	phba->sli4_hba.nvmet_ctx_cnt++;
 	spin_unlock_irqrestore(&phba->sli4_hba.nvmet_io_lock, iflag);
+#endif
 }
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
-- 
2.11.0
