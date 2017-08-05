From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 10/20] lpfc: Fix NVME PRLI handling during RSCN
Date: Fri,  4 Aug 2017 17:47:21 -0700
Message-ID: <20170805004731.1335-11-jsmart2021@gmail.com>
References: <20170805004731.1335-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33204 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752610AbdHEAr7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2017 20:47:59 -0400
Received: by mail-pg0-f68.google.com with SMTP id u185so3142598pgb.0
        for <linux-scsi@vger.kernel.org>; Fri, 04 Aug 2017 17:47:59 -0700 (PDT)
In-Reply-To: <20170805004731.1335-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

A race condition was found whereby the initiator would receive
the RSCN for a new NVME device before it had a chance to register
its FC4 support with the fabric. Thus, when queried by the initiator,
it would see that the target supported FC-NVME.

Corrected by making the assumption that the target always supports
FC-NVME thus a PRLI is sent. It's ok for the target to reject it.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index fe0dd42b75af..9a8808abe61f 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2177,6 +2177,16 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	uint16_t cmdsize;
 	u32 local_nlp_type, elscmd;
 
+	/*
+	 * If we are in RSCN mode, the FC4 types supported from a
+	 * previous GFT_ID command may not be accurate. So, if we
+	 * are a NVME Initiator, always look for the possibility of
+	 * the remote NPort beng a NVME Target.
+	 */
+	if (phba->sli_rev == LPFC_SLI_REV4 &&
+	    vport->fc_flag & FC_RSCN_MODE &&
+	    vport->nvmei_support)
+		ndlp->nlp_fc4_type |= NLP_FC4_NVME;
 	local_nlp_type = ndlp->nlp_fc4_type;
 
  send_next_prli:
-- 
2.13.1
