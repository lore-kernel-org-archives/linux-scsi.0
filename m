From: jsmart2021@gmail.com
Subject: [PATCH 19/20] lpfc: code cleanups in NVME initiator discovery
Date: Sat,  4 Mar 2017 09:30:39 -0800
Message-ID: <1488648640-5170-20-git-send-email-jsmart2021@gmail.com>
References: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:36621 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752450AbdCDRbN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Mar 2017 12:31:13 -0500
Received: by mail-qk0-f195.google.com with SMTP id n141so10941426qke.3
        for <linux-scsi@vger.kernel.org>; Sat, 04 Mar 2017 09:31:13 -0800 (PST)
In-Reply-To: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

This patch addresses the smatch issues identified by Dan Carpenter
in http://www.spinics.net/lists/linux-scsi/msg105665.html

The issues are:

drivers/scsi/lpfc/lpfc_ct.c:943 lpfc_cmpl_ct_cmd_gft_id()
error: we previously assumed 'ndlp' could be null (see line 928)

Action: moved under if check

drivers/scsi/lpfc/lpfc_nvmet.c:1694 lpfc_nvmet_unsol_issue_abort()
error: we previously assumed 'ndlp' could be null (see line 1690)

Action: conditionalized arg in printf stmt

drivers/scsi/lpfc/lpfc_nvmet.c:1792 lpfc_nvmet_sol_fcp_issue_abort()
error: we previously assumed 'ndlp' could be null (see line 1788)

Action: conditionalized arg in printf stmt

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_ct.c    | 2 +-
 drivers/scsi/lpfc/lpfc_nvmet.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index c22bb3f..d3e9af9 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -939,8 +939,8 @@ lpfc_cmpl_ct_cmd_gft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 					 "FC4 x%08x, Data: x%08x x%08x\n",
 					 ndlp, did, ndlp->nlp_fc4_type,
 					 FC_TYPE_FCP, FC_TYPE_NVME);
+			ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
 		}
-		ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_PRLI_ISSUE);
 		lpfc_issue_els_prli(vport, ndlp, 0);
 	} else
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index a69ca6e..b7739a5 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1720,7 +1720,7 @@ lpfc_nvmet_unsol_issue_abort(struct lpfc_hba *phba,
 		atomic_inc(&tgtp->xmt_abort_rsp_error);
 		lpfc_printf_log(phba, KERN_WARNING, LOG_NVME_ABTS,
 				"6134 Drop ABTS - wrong NDLP state x%x.\n",
-				ndlp->nlp_state);
+				(ndlp) ? ndlp->nlp_state : NLP_STE_MAX_STATE);
 
 		/* No failure to an ABTS request. */
 		return 0;
@@ -1818,7 +1818,7 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 		atomic_inc(&tgtp->xmt_abort_rsp_error);
 		lpfc_printf_log(phba, KERN_WARNING, LOG_NVME_ABTS,
 				"6160 Drop ABTS - wrong NDLP state x%x.\n",
-				ndlp->nlp_state);
+				(ndlp) ? ndlp->nlp_state : NLP_STE_MAX_STATE);
 
 		/* No failure to an ABTS request. */
 		return 0;
-- 
2.5.0
