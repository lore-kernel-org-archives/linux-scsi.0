From: jsmart2021@gmail.com
Subject: [PATCH 15/20] lpfc: correct double print
Date: Sat,  4 Mar 2017 09:30:35 -0800
Message-ID: <1488648640-5170-16-git-send-email-jsmart2021@gmail.com>
References: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:36576 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752230AbdCDRbI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Mar 2017 12:31:08 -0500
Received: by mail-qk0-f193.google.com with SMTP id n141so10941029qke.3
        for <linux-scsi@vger.kernel.org>; Sat, 04 Mar 2017 09:31:07 -0800 (PST)
In-Reply-To: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

Correct a merge error that had debug data printed twice for the
same element

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 9f4798e..913eed82 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -3653,17 +3653,6 @@ lpfc_idiag_queacc_write(struct file *file, const char __user *buf,
 			idiag.ptr_private = phba->sli4_hba.nvmels_cq;
 			goto pass_check;
 		}
-		/* NVME LS complete queue */
-		if (phba->sli4_hba.nvmels_cq &&
-		    phba->sli4_hba.nvmels_cq->queue_id == queid) {
-			/* Sanity check */
-			rc = lpfc_idiag_que_param_check(
-					phba->sli4_hba.nvmels_cq, index, count);
-			if (rc)
-				goto error_out;
-			idiag.ptr_private = phba->sli4_hba.nvmels_cq;
-			goto pass_check;
-		}
 		/* FCP complete queue */
 		if (phba->sli4_hba.fcp_cq) {
 			for (qidx = 0; qidx < phba->cfg_fcp_io_channel;
@@ -3738,17 +3727,6 @@ lpfc_idiag_queacc_write(struct file *file, const char __user *buf,
 			idiag.ptr_private = phba->sli4_hba.nvmels_wq;
 			goto pass_check;
 		}
-		/* NVME LS work queue */
-		if (phba->sli4_hba.nvmels_wq &&
-		    phba->sli4_hba.nvmels_wq->queue_id == queid) {
-			/* Sanity check */
-			rc = lpfc_idiag_que_param_check(
-					phba->sli4_hba.nvmels_wq, index, count);
-			if (rc)
-				goto error_out;
-			idiag.ptr_private = phba->sli4_hba.nvmels_wq;
-			goto pass_check;
-		}
 		/* FCP work queue */
 		if (phba->sli4_hba.fcp_wq) {
 			for (qidx = 0; qidx < phba->cfg_fcp_io_channel;
-- 
2.5.0
