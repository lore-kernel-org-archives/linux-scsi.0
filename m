From: Stefano Brivio <sbrivio@redhat.com>
Subject: [PATCH] lpfc: Don't return internal MBXERR_ERROR code from probe function
Date: Mon, 28 Aug 2017 15:05:23 +0200
Message-ID: <a1464fd9d04361952cbbc031622c3259358eb8ac.1503925436.git.sbrivio@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60094 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751161AbdH1NFp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Aug 2017 09:05:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>, QLogic-Storage-Upstream@cavium.com
Cc: Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

Internal error codes happen to be positive, thus the PCI driver
core won't treat them as failure, but we do. This would cause a
crash later on as lpfc_pci_remove_one() is called (e.g. as
shutdown function).

Fixes: 6d368e532168 ("[SCSI] lpfc 8.3.24: Add resource extent support")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 491aa95eb0f6..38cc2b5bb5a2 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -6118,6 +6118,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 				"Extents and RPI headers enabled.\n");
 		}
 		mempool_free(mboxq, phba->mbox_mem_pool);
+		rc = -EIO;
 		goto out_free_bsmbx;
 	}
 
-- 
2.9.4
