From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH] lpfc: fix refcount error on node list
Date: Wed, 21 Jun 2017 10:51:23 -0700
Message-ID: <20170621175123.28190-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:33693 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751114AbdFURvc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jun 2017 13:51:32 -0400
Received: by mail-qk0-f193.google.com with SMTP id p21so4548699qke.0
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2017 10:51:32 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, James Smart <james.smart@broadcom.com>

A change in remote port removal introduced a spurious put which
can cause a premature structure teardown. The affects were most
notable when the driver attempted to unload as a null pointer
would be hit.

Fix by removing the unnecessary put.

Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 7e73fdc154f7..491aa95eb0f6 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2805,13 +2805,6 @@ lpfc_cleanup(struct lpfc_vport *vport)
 			lpfc_disc_state_machine(vport, ndlp, NULL,
 					NLP_EVT_DEVICE_RECOVERY);
 
-		if (ndlp->nlp_fc4_type & NLP_FC4_NVME) {
-			/* Remove the NVME transport reference now and
-			 * continue to remove the node.
-			 */
-			lpfc_nlp_put(ndlp);
-		}
-
 		lpfc_disc_state_machine(vport, ndlp, NULL,
 					     NLP_EVT_DEVICE_RM);
 	}
-- 
2.11.0
