From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 10/20] lpfc: Fix NVME PRLI handling during RSCN
Date: Wed, 23 Aug 2017 16:55:39 -0700
Message-ID: <20170823235549.2883-11-jsmart2021@gmail.com>
References: <20170823235549.2883-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35581 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751020AbdHWX4U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 19:56:20 -0400
Received: by mail-wm0-f67.google.com with SMTP id x79so1065334wma.2
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2017 16:56:20 -0700 (PDT)
In-Reply-To: <20170823235549.2883-1-jsmart2021@gmail.com>
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
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_els.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index ffbd3eddeabb..6de470e158ef 100644
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
