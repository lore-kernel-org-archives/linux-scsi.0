From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 05/19] lpfc: PLOGI failures during NPIV testing
Date: Thu, 21 Sep 2017 23:17:27 -0700
Message-ID: <20170922061741.12347-6-jsmart2021@gmail.com>
References: <20170922061741.12347-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34579 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdIVGSB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 02:18:01 -0400
Received: by mail-pg0-f68.google.com with SMTP id u18so126562pgo.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2017 23:18:00 -0700 (PDT)
In-Reply-To: <20170922061741.12347-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

Local Reject/Invalid RPI errors seen during discovery.

Temporary RPI cleanup was occurring regardless of SLI rev. It's
only necessary on SLI-4.

Adjust the test for whether cleanup is necessary.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 499df9d17339..d9a03beb76a4 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4983,7 +4983,8 @@ lpfc_nlp_remove(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	lpfc_cancel_retry_delay_tmo(vport, ndlp);
 	if ((ndlp->nlp_flag & NLP_DEFER_RM) &&
 	    !(ndlp->nlp_flag & NLP_REG_LOGIN_SEND) &&
-	    !(ndlp->nlp_flag & NLP_RPI_REGISTERED)) {
+	    !(ndlp->nlp_flag & NLP_RPI_REGISTERED) &&
+	    phba->sli_rev != LPFC_SLI_REV4) {
 		/* For this case we need to cleanup the default rpi
 		 * allocated by the firmware.
 		 */
-- 
2.13.1
