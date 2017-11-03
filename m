From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 08/17] lpfc: Fix display for debugfs queInfo
Date: Fri,  3 Nov 2017 15:56:19 -0700
Message-ID: <20171103225628.24716-9-jsmart2021@gmail.com>
References: <20171103225628.24716-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:44606 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751568AbdKCW4p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Nov 2017 18:56:45 -0400
Received: by mail-qk0-f193.google.com with SMTP id r64so5067332qkc.1
        for <linux-scsi@vger.kernel.org>; Fri, 03 Nov 2017 15:56:45 -0700 (PDT)
In-Reply-To: <20171103225628.24716-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Display for lpfc/fnX/iDiag/queInfo isn't formatted perfectly.
Corrected the format strings for the queue info debug messages.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index d50c481ec41c..e8c5a0927dd7 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -3248,7 +3248,7 @@ __lpfc_idiag_print_eq(struct lpfc_queue *qp, char *eqtype,
 
 	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
 			"\n%s EQ info: EQ-STAT[max:x%x noE:x%x "
-			"bs:x%x proc:x%llx eqd %d]\n",
+			"cqe_proc:x%x eqe_proc:x%llx eqd %d]\n",
 			eqtype, qp->q_cnt_1, qp->q_cnt_2, qp->q_cnt_3,
 			(unsigned long long)qp->q_cnt_4, qp->q_mode);
 	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
@@ -3368,6 +3368,12 @@ lpfc_idiag_queinfo_read(struct file *file, char __user *buf, size_t nbytes,
 		if (len >= max_cnt)
 			goto too_big;
 
+		qp = phba->sli4_hba.hdr_rq;
+		len = __lpfc_idiag_print_rqpair(qp, phba->sli4_hba.dat_rq,
+						"ELS RQpair", pbuffer, len);
+		if (len >= max_cnt)
+			goto too_big;
+
 		/* Slow-path NVME LS response CQ */
 		qp = phba->sli4_hba.nvmels_cq;
 		len = __lpfc_idiag_print_cq(qp, "NVME LS",
@@ -3385,12 +3391,6 @@ lpfc_idiag_queinfo_read(struct file *file, char __user *buf, size_t nbytes,
 		if (len >= max_cnt)
 			goto too_big;
 
-		qp = phba->sli4_hba.hdr_rq;
-		len = __lpfc_idiag_print_rqpair(qp, phba->sli4_hba.dat_rq,
-				"RQpair", pbuffer, len);
-		if (len >= max_cnt)
-			goto too_big;
-
 		goto out;
 	}
 
-- 
2.13.1
