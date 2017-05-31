From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 10/15] lpfc: Fix crash on powering off BFS VM with passthrough device
Date: Tue, 30 May 2017 23:04:34 -0700
Message-ID: <20170531060439.2073-11-jsmart2021@gmail.com>
References: <20170531060439.2073-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:34027 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751053AbdEaGFG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2017 02:05:06 -0400
Received: by mail-qk0-f196.google.com with SMTP id u75so737074qka.1
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2017 23:05:05 -0700 (PDT)
In-Reply-To: <20170531060439.2073-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Null pointer dereference when BFS VM is powered off

The driver incorrectly uses sli3_ring on SLI-4 adapters

Use the correct ring structure based on sli_rev

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index e81fa7d4deb5..c4ceef69bd6b 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -10951,6 +10951,7 @@ lpfc_sli_abort_iocb(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_iocbq *iocbq;
 	struct lpfc_iocbq *abtsiocb;
+	struct lpfc_sli_ring *pring_s4;
 	IOCB_t *cmd = NULL;
 	int errcnt = 0, ret_val = 0;
 	int i;
@@ -11004,8 +11005,15 @@ lpfc_sli_abort_iocb(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 
 		/* Setup callback routine and issue the command. */
 		abtsiocb->iocb_cmpl = lpfc_sli_abort_fcp_cmpl;
-		ret_val = lpfc_sli_issue_iocb(phba, pring->ringno,
-					      abtsiocb, 0);
+		if (phba->sli_rev == LPFC_SLI_REV4) {
+			pring_s4 = lpfc_sli4_calc_ring(phba, iocbq);
+			if (!pring_s4)
+				continue;
+			ret_val = lpfc_sli_issue_iocb(phba, pring_s4->ringno,
+						      abtsiocb, 0);
+		} else
+			ret_val = lpfc_sli_issue_iocb(phba, pring->ringno,
+						      abtsiocb, 0);
 		if (ret_val == IOCB_ERROR) {
 			lpfc_sli_release_iocbq(phba, abtsiocb);
 			errcnt++;
-- 
2.11.0
