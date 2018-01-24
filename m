From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 14/19] lpfc: Validate adapter support for SRIU option
Date: Wed, 24 Jan 2018 14:45:43 -0800
Message-ID: <20180124224548.9530-15-jsmart2021@gmail.com>
References: <20180124224548.9530-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:43695 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933100AbeAXWqR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jan 2018 17:46:17 -0500
Received: by mail-qt0-f196.google.com with SMTP id s3so14627088qtb.10
        for <linux-scsi@vger.kernel.org>; Wed, 24 Jan 2018 14:46:17 -0800 (PST)
In-Reply-To: <20180124224548.9530-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

When using the special option to suppress the response iu, ensure
the adapter fully supports the feature by checking feature flags
from the adapter.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h  |  3 +++
 drivers/scsi/lpfc/lpfc_init.c | 13 ++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 7c3afc3d3121..52fe28ae50fa 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -3293,6 +3293,9 @@ struct lpfc_sli4_parameters {
 #define cfg_eqdr_SHIFT				8
 #define cfg_eqdr_MASK				0x00000001
 #define cfg_eqdr_WORD				word19
+#define cfg_nosr_SHIFT				9
+#define cfg_nosr_MASK				0x00000001
+#define cfg_nosr_WORD				word19
 #define LPFC_NODELAY_MAX_IO		32
 };
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 7fc2db968379..895b1da784ee 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -10473,8 +10473,19 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 		phba->cfg_enable_fc4_type = LPFC_ENABLE_FCP;
 	}
 
-	if (bf_get(cfg_xib, mbx_sli4_parameters) && phba->cfg_suppress_rsp)
+	/*
+	 * To support Suppress Response feature we must satisfy 3 conditions.
+	 * lpfc_suppress_rsp module parameter must be set (default).
+	 * In SLI4-Parameters Descriptor:
+	 * Extended Inline Buffers (XIB) must be supported.
+	 * Suppress Response IU Not Supported (SRIUNS) must NOT be supported
+	 * (double negative).
+	 */
+	if (phba->cfg_suppress_rsp && bf_get(cfg_xib, mbx_sli4_parameters) &&
+	    !(bf_get(cfg_nosr, mbx_sli4_parameters)))
 		phba->sli.sli_flag |= LPFC_SLI_SUPPRESS_RSP;
+	else
+		phba->cfg_suppress_rsp = 0;
 
 	if (bf_get(cfg_eqdr, mbx_sli4_parameters))
 		phba->sli.sli_flag |= LPFC_SLI_USE_EQDR;
-- 
2.13.1
