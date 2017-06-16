From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 03/11] Vport creation is failing with "Link Down" error
Date: Thu, 15 Jun 2017 22:56:43 -0700
Message-ID: <20170616055651.9674-4-jsmart2021@gmail.com>
References: <20170616055651.9674-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:35288 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752068AbdFPF5H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jun 2017 01:57:07 -0400
Received: by mail-qt0-f196.google.com with SMTP id x58so7924827qtc.2
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jun 2017 22:57:07 -0700 (PDT)
In-Reply-To: <20170616055651.9674-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Vport creation fails for SLI-3 adapters.

Mailbox submission fails because mailbox interrupt is disabled. Mailbox
interrupt is disabled during port reset.

Do reset only for physical port.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 9d3a12636455..77283705eb8d 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3691,14 +3691,6 @@ lpfc_get_wwpn(struct lpfc_hba *phba)
 	LPFC_MBOXQ_t *mboxq;
 	MAILBOX_t *mb;
 
-	if (phba->sli_rev < LPFC_SLI_REV4) {
-		/* Reset the port first */
-		lpfc_sli_brdrestart(phba);
-		rc = lpfc_sli_chipset_init(phba);
-		if (rc)
-			return (uint64_t)-1;
-	}
-
 	mboxq = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool,
 						GFP_KERNEL);
 	if (!mboxq)
@@ -3852,8 +3844,19 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 	int i;
 	uint64_t wwn;
 	bool use_no_reset_hba = false;
+	int rc;
 
-	wwn = lpfc_get_wwpn(phba);
+	if (lpfc_no_hba_reset_cnt) {
+		if (phba->sli_rev < LPFC_SLI_REV4 &&
+		    dev == &phba->pcidev->dev) {
+			/* Reset the port first */
+			lpfc_sli_brdrestart(phba);
+			rc = lpfc_sli_chipset_init(phba);
+			if (rc)
+				return NULL;
+		}
+		wwn = lpfc_get_wwpn(phba);
+	}
 
 	for (i = 0; i < lpfc_no_hba_reset_cnt; i++) {
 		if (wwn == lpfc_no_hba_reset[i]) {
-- 
2.11.0
