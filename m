From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 06/21] lpfc: PLOGI failures during NPIV testing
Date: Fri, 29 Sep 2017 17:34:32 -0700
Message-ID: <20170930003447.10747-7-jsmart2021@gmail.com>
References: <20170930003447.10747-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:33262 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752605AbdI3AfB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Sep 2017 20:35:01 -0400
Received: by mail-qk0-f193.google.com with SMTP id b82so392119qkc.0
        for <linux-scsi@vger.kernel.org>; Fri, 29 Sep 2017 17:35:01 -0700 (PDT)
In-Reply-To: <20170930003447.10747-1-jsmart2021@gmail.com>
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
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
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
