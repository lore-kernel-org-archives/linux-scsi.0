From: James Smart <james.smart@emulex.com>
Subject: [PATCH 03/21] lpfc 8.3.33: Fix bug with rrq_pool not being
 destroyed during driver removal.
Date: Fri, 3 Aug 2012 12:34:15 -0400
Message-ID: <1344011655.6110.28.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:40304 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab2HCQeV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2012 12:34:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix bug with rrq_pool not being destroyed during driver removal.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_mem.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
--- a/drivers/scsi/lpfc/lpfc_mem.c	2012-07-22 10:46:05.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mem.c	2012-07-22 11:35:20.060631883 -0400
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2009 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2012 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -194,6 +194,10 @@ lpfc_mem_free(struct lpfc_hba *phba)
 		pci_pool_destroy(phba->lpfc_hbq_pool);
 	phba->lpfc_hbq_pool = NULL;
 
+	if (phba->rrq_pool)
+		mempool_destroy(phba->rrq_pool);
+	phba->rrq_pool = NULL;
+
 	/* Free NLP memory pool */
 	mempool_destroy(phba->nlp_mem_pool);
 	phba->nlp_mem_pool = NULL;



