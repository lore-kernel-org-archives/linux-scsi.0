From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 03/20] lpfc: Fix rediscovery on switch blade pull
Date: Fri,  4 Aug 2017 17:47:14 -0700
Message-ID: <20170805004731.1335-4-jsmart2021@gmail.com>
References: <20170805004731.1335-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33881 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752542AbdHEArq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2017 20:47:46 -0400
Received: by mail-pf0-f196.google.com with SMTP id t86so3207526pfe.1
        for <linux-scsi@vger.kernel.org>; Fri, 04 Aug 2017 17:47:46 -0700 (PDT)
In-Reply-To: <20170805004731.1335-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

When the switch blade is pulled out then plugged back in, the driver
does not issue a PLOGI to the target

When the switch blade is pulled out, it does not reset the link. The
driver ends up issuing a LOGO to the target, and finally sees devloss.
Since the driver believes that a LOGO is outstanding, it does not
issue a PLOGI to the target upon link up

Correct by placing the ndlp in UNUSED state When devloss happens in
LOGO_ISSUE state.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 95b2b43ac37d..a4488d6339c1 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -2192,12 +2192,15 @@ lpfc_device_rm_logo_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			  void *arg, uint32_t evt)
 {
 	/*
-	 * Take no action.  If a LOGO is outstanding, then possibly DevLoss has
-	 * timed out and is calling for Device Remove.  In this case, the LOGO
-	 * must be allowed to complete in state LOGO_ISSUE so that the rpi
-	 * and other NLP flags are correctly cleaned up.
+	 * DevLoss has timed out and is calling for Device Remove.
+	 * In this case, abort the LOGO and cleanup the ndlp
 	 */
-	return ndlp->nlp_state;
+
+	lpfc_unreg_rpi(vport, ndlp);
+	/* software abort outstanding PLOGI */
+	lpfc_els_abort(vport->phba, ndlp);
+	lpfc_drop_node(vport, ndlp);
+	return NLP_STE_FREED_NODE;
 }
 
 static uint32_t
-- 
2.13.1
