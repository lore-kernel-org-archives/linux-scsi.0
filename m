From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: lpfc: ensure els_wq is being checked before destroying it
Date: Sat,  6 May 2017 23:13:55 +0100
Message-ID: <20170506221355.13552-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

I believe there is a typo on the wq destroy of els_wq, currently
the driver is checking if els_cq is not null and I think this
should be a check on els_wq instead.

Detected by CoverityScan, CID#1411629 ("Copy-paste error")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 90ae354a9c45..c925bbe9b35d 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8847,7 +8847,7 @@ lpfc_sli4_queue_unset(struct lpfc_hba *phba)
 		lpfc_wq_destroy(phba, phba->sli4_hba.nvmels_wq);
 
 	/* Unset ELS work queue */
-	if (phba->sli4_hba.els_cq)
+	if (phba->sli4_hba.els_wq)
 		lpfc_wq_destroy(phba, phba->sli4_hba.els_wq);
 
 	/* Unset unsolicited receive queue */
-- 
2.11.0

