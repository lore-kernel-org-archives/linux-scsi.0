From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 11/21] lpfc: Fix NVME PRLI handling during RSCN
Date: Wed,  2 Aug 2017 16:36:38 -0700
Message-ID: <20170802233648.4573-12-jsmart2021@gmail.com>
References: <20170802233648.4573-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:38456 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751965AbdHBXiI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2017 19:38:08 -0400
Received: by mail-qt0-f196.google.com with SMTP id p3so6126505qtg.5
        for <linux-scsi@vger.kernel.org>; Wed, 02 Aug 2017 16:38:08 -0700 (PDT)
In-Reply-To: <20170802233648.4573-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

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
