From: james.smart@avagotech.com (James Smart)
Subject: [PATCH v2 11/15] lpfc: Correct loss of RSCNs during array
 takeaway/giveback testing.
Date: Thu, 21 May 2015 13:55:27 -0400
Message-ID: <555e1c0f.U9cjP6tJsuPqwu0U%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:33421 "EHLO
	mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217AbbEURzc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2015 13:55:32 -0400
Received: by qkgv12 with SMTP id v12so61626550qkg.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 May 2015 10:55:31 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by mx.google.com with ESMTPSA id 139sm13603349qhb.26.2015.05.21.10.55.30
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Thu, 21 May 2015 10:55:31 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Correct loss of RSCNs during array takeaway/giveback testing.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index b490ef5..4d3d931 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1514,7 +1514,7 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 	struct fc_rport *rport;
 	struct serv_parm *sp;
 	uint8_t  name[sizeof(struct lpfc_name)];
-	uint32_t rc, keepDID = 0;
+	uint32_t rc, keepDID = 0, keep_nlp_flag = 0;
 	int  put_node;
 	int  put_rport;
 	unsigned long *active_rrqs_xri_bitmap = NULL;
@@ -1603,9 +1603,9 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 		       ndlp->active_rrqs_xri_bitmap,
 		       phba->cfg_rrq_xri_bitmap_sz);
 
-	if (ndlp->nlp_flag & NLP_NPR_2B_DISC)
-		new_ndlp->nlp_flag |= NLP_NPR_2B_DISC;
-	ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+	keep_nlp_flag = new_ndlp->nlp_flag;
+	new_ndlp->nlp_flag = ndlp->nlp_flag;
+	ndlp->nlp_flag = keep_nlp_flag;
 
 	/* Set state will put new_ndlp on to node list if not already done */
 	lpfc_nlp_set_state(vport, new_ndlp, ndlp->nlp_state);
@@ -1648,7 +1648,9 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 			memcpy(ndlp->active_rrqs_xri_bitmap,
 			       active_rrqs_xri_bitmap,
 			       phba->cfg_rrq_xri_bitmap_sz);
-		lpfc_drop_node(vport, ndlp);
+
+		if (!NLP_CHK_NODE_ACT(ndlp))
+			lpfc_drop_node(vport, ndlp);
 	}
 	else {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-- 
1.7.11.7

