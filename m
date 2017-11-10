From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 10/17] lpfc: Fix ndlp ref count for pt2pt mode issue RSCN
Date: Thu,  9 Nov 2017 17:08:27 -0800
Message-ID: <20171110010834.4542-11-jsmart2021@gmail.com>
References: <20171110010834.4542-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:47624 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755523AbdKJBIx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Nov 2017 20:08:53 -0500
Received: by mail-qk0-f193.google.com with SMTP id m189so10117935qke.4
        for <linux-scsi@vger.kernel.org>; Thu, 09 Nov 2017 17:08:53 -0800 (PST)
In-Reply-To: <20171110010834.4542-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

pt2pt ndlp ref count prematurely goes to 0. There was reference
removed that should only be removed if connected to a switch,
not if in point-to-point mode.

Add a mode check before the reference remove.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 532cd4b49c5d..911066c9612d 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2956,8 +2956,8 @@ lpfc_issue_els_scr(struct lpfc_vport *vport, uint32_t nportid, uint8_t retry)
 	/* This will cause the callback-function lpfc_cmpl_els_cmd to
 	 * trigger the release of node.
 	 */
-
-	lpfc_nlp_put(ndlp);
+	if (!(vport->fc_flag & FC_PT2PT))
+		lpfc_nlp_put(ndlp);
 	return 0;
 }
 
-- 
2.13.1
