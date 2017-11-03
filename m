From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 10/17] lpfc: Fix ndlp ref count for pt2pt mode issue RSCN
Date: Fri,  3 Nov 2017 15:56:21 -0700
Message-ID: <20171103225628.24716-11-jsmart2021@gmail.com>
References: <20171103225628.24716-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:57191 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756040AbdKCW4r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Nov 2017 18:56:47 -0400
Received: by mail-qt0-f193.google.com with SMTP id z28so5027575qtz.13
        for <linux-scsi@vger.kernel.org>; Fri, 03 Nov 2017 15:56:47 -0700 (PDT)
In-Reply-To: <20171103225628.24716-1-jsmart2021@gmail.com>
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
index 95872a0329ad..a708d80cb609 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2962,8 +2962,8 @@ lpfc_issue_els_scr(struct lpfc_vport *vport, uint32_t nportid, uint8_t retry)
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
