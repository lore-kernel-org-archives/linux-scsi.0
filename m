From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 10/17] lpfc: Fix ndlp ref count for pt2pt mode issue RSCN
Date: Mon, 20 Nov 2017 16:00:37 -0800
Message-ID: <20171121000044.27702-11-jsmart2021@gmail.com>
References: <20171121000044.27702-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:33365 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751526AbdKUABF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Nov 2017 19:01:05 -0500
Received: by mail-qt0-f194.google.com with SMTP id r58so17034026qtc.0
        for <linux-scsi@vger.kernel.org>; Mon, 20 Nov 2017 16:01:04 -0800 (PST)
In-Reply-To: <20171121000044.27702-1-jsmart2021@gmail.com>
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
Reviewed-by: Hannes Reinecke <hare@suse.com>
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
