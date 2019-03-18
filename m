From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: lpfc_nvme: Fix wrong sizeof argument
Date: Mon, 18 Mar 2019 12:15:05 -0500
Message-ID: <20190318171505.GA8748@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

sizeof() is currently using the wrong argument when used in a call to
memset().  Notice that wqe is a pointer to union lpfc_wqe128, not to
union lpfc_wqe.

Fix this by using union lpfc_wqe128 instead of lpfc_wqe as argument
of sizeof().

Addresses-Coverity-ID: 1443938 ("Wrong sizeof argument")
Fixes: 5fd1108517d9 ("scsi: lpfc: Streamline NVME Initiator WQE setup")
Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index d16ca413110d..3dc0c85c7d50 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1981,7 +1981,7 @@ lpfc_get_nvme_buf(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 		/* Fill in word 3 / sgl_len during cmd submission */
 
 		/* Initialize WQE */
-		memset(wqe, 0, sizeof(union lpfc_wqe));
+		memset(wqe, 0, sizeof(union lpfc_wqe128));
 
 		if (lpfc_ndlp_check_qdepth(phba, ndlp)) {
 			atomic_inc(&ndlp->cmd_pending);
-- 
2.21.0
