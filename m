From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 08/17] lpfc: Fix display for debugfs queInfo
Date: Mon, 20 Nov 2017 16:00:35 -0800
Message-ID: <20171121000044.27702-9-jsmart2021@gmail.com>
References: <20171121000044.27702-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:39721 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751282AbdKUABC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Nov 2017 19:01:02 -0500
Received: by mail-qk0-f196.google.com with SMTP id w125so9754635qkb.6
        for <linux-scsi@vger.kernel.org>; Mon, 20 Nov 2017 16:01:02 -0800 (PST)
In-Reply-To: <20171121000044.27702-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Display for lpfc/fnX/iDiag/queInfo isn't formatted perfectly.
Corrected the format strings for the queue info debug messages.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 2bf5ad3b1512..4df5a21bd93b 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -3246,7 +3246,7 @@ __lpfc_idiag_print_eq(struct lpfc_queue *qp, char *eqtype,
 
 	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
 			"\n%s EQ info: EQ-STAT[max:x%x noE:x%x "
-			"bs:x%x proc:x%llx eqd %d]\n",
+			"cqe_proc:x%x eqe_proc:x%llx eqd %d]\n",
 			eqtype, qp->q_cnt_1, qp->q_cnt_2, qp->q_cnt_3,
 			(unsigned long long)qp->q_cnt_4, qp->q_mode);
 	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
@@ -3366,6 +3366,12 @@ lpfc_idiag_queinfo_read(struct file *file, char __user *buf, size_t nbytes,
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
@@ -3383,12 +3389,6 @@ lpfc_idiag_queinfo_read(struct file *file, char __user *buf, size_t nbytes,
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
