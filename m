From: james.smart@broadcom.com (James Smart)
Subject: [PATCH v3 02/17] lpfc: Correct embedded io wq element size
Date: Thu, 13 Oct 2016 15:06:03 -0700
Message-ID: <5800054b.zGLIaeTe8e0VezFn%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.avagotech.com ([199.3.246.86]:36885 "EHLO
        sgpsmtp2.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756969AbcJMWQf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2016 18:16:35 -0400
Received: from flash (fx9xs32.emulex.com [10.230.226.120])
        by sgpsmtp2.avagotech.com (Postfix) with SMTP id 492691209C9
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 15:06:05 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Correct embedded io wq element size. Embedded element sizes are
128 byte elements

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
v2 mods:
 change style of selecting wqesize using local variable

 drivers/scsi/lpfc/lpfc_init.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 734a042..af64d70 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7256,6 +7256,7 @@ int
 lpfc_sli4_queue_create(struct lpfc_hba *phba)
 {
 	struct lpfc_queue *qdesc;
+	uint32_t wqesize;
 	int idx;
 
 	/*
@@ -7340,15 +7341,10 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 		phba->sli4_hba.fcp_cq[idx] = qdesc;
 
 		/* Create Fast Path FCP WQs */
-		if (phba->fcp_embed_io) {
-			qdesc = lpfc_sli4_queue_alloc(phba,
-						      LPFC_WQE128_SIZE,
-						      LPFC_WQE128_DEF_COUNT);
-		} else {
-			qdesc = lpfc_sli4_queue_alloc(phba,
-						      phba->sli4_hba.wq_esize,
-						      phba->sli4_hba.wq_ecount);
-		}
+		wqesize = (phba->fcp_embed_io) ?
+				LPFC_WQE128_SIZE : phba->sli4_hba.wq_esize;
+		qdesc = lpfc_sli4_queue_alloc(phba, wqesize,
+						phba->sli4_hba.wq_ecount);
 		if (!qdesc) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"0503 Failed allocate fast-path FCP "
-- 
2.5.0


