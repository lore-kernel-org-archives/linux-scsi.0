From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: lpfc: remove redundant null check on eqe
Date: Fri,  8 Sep 2017 09:02:01 +0100
Message-ID: <20170908080201.9592-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The pointer eqe is always non-null inside the while loop, so the
check to see if eqe is NULL is redudant and hence can be removed.

Detected by CoverityScan CID#1248693 ("Logically Dead Code")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 8b119f87b51d..80036a9fae7f 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -13760,9 +13760,6 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 	 * Process all the event on FCP fast-path EQ
 	 */
 	while ((eqe = lpfc_sli4_eq_get(fpeq))) {
-		if (eqe == NULL)
-			break;
-
 		ccount += lpfc_sli4_hba_handle_eqe(phba, eqe, hba_eqidx);
 		if (!(++ecount % fpeq->entry_repost) ||
 		    ccount > LPFC_MAX_ISR_CQE)
-- 
2.14.1

