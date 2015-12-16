From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 15/17] lpfc: Delete unnecessary checks before the function call "mempool_destroy"
Date: Wed, 16 Dec 2015 18:12:06 -0500
Message-ID: <5671efc6.ZwH5WdfbRkt48aQV%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:35598 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302AbbLPXMZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2015 18:12:25 -0500
Received: by mail-pf0-f179.google.com with SMTP id v86so19539441pfa.2
        for <linux-scsi@vger.kernel.org>; Wed, 16 Dec 2015 15:12:25 -0800 (PST)
Received: from myfc17 (cm-wififw.emulex.com. [138.239.220.50])
        by smtp.gmail.com with ESMTPSA id 25sm7010447pfi.73.2015.12.16.15.12.23
        for <linux-scsi@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 16 Dec 2015 15:12:23 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


From: Markus Elfring <elfring@users.sourceforge.net>

The mempool_destroy() function tests whether its argument is NULL
and then returns immediately. Thus the test around the calls is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_mem.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index 3fa6533..4fb3581 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -231,15 +231,13 @@ lpfc_mem_free(struct lpfc_hba *phba)
 	if (phba->lpfc_hbq_pool)
 		pci_pool_destroy(phba->lpfc_hbq_pool);
 	phba->lpfc_hbq_pool = NULL;
-
-	if (phba->rrq_pool)
-		mempool_destroy(phba->rrq_pool);
+	mempool_destroy(phba->rrq_pool);
 	phba->rrq_pool = NULL;
 
 	/* Free NLP memory pool */
 	mempool_destroy(phba->nlp_mem_pool);
 	phba->nlp_mem_pool = NULL;
-	if (phba->sli_rev == LPFC_SLI_REV4 && phba->active_rrq_pool) {
+	if (phba->sli_rev == LPFC_SLI_REV4) {
 		mempool_destroy(phba->active_rrq_pool);
 		phba->active_rrq_pool = NULL;
 	}
-- 
1.7.11.7

