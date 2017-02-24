From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: lpfc: remove redundant assignment of sgel
Date: Fri, 24 Feb 2017 13:45:23 +0000
Message-ID: <20170224134523.5385-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

In the NVMET_FCOP_RSP case, sgel is assigned but never used and
hence is redundant and can be removed.

Detected by CoverityScan, CID#1411658 ("Unused value")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index c421e17..e59a0a8 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1445,7 +1445,6 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 
 	case NVMET_FCOP_RSP:
 		/* Words 0 - 2 */
-		sgel = &rsp->sg[0];
 		physaddr = rsp->rspdma;
 		wqe->fcp_trsp.bde.tus.f.bdeFlags = BUFF_TYPE_BDE_64;
 		wqe->fcp_trsp.bde.tus.f.bdeSize = rsp->rsplen;
-- 
2.10.2
