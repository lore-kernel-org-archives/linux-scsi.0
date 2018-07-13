From: Colin King <colin.king@canonical.com>
Subject: [PATCH][V2] scsi: lpfc: remove null check on nvmebuf
Date: Fri, 13 Jul 2018 09:39:54 +0100
Message-ID: <20180713083954.26877-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The null checks on nvmebuf are redundant as nvmebuf is always obtained
from a container_of() and hence can never be null. Remove all the
redundant null checks. This also cleans up a static analysis warning.

Detected by CoverityScan, CID#1471753 ("Dereference before null check")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---

V2: Remove null pointer checks thanks to James Bottomley for spotting
that the caller obtains nvmebuf from container_of().

---
 drivers/scsi/lpfc/lpfc_nvmet.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 22f8a204b69f..b766afe10d3d 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1745,7 +1745,7 @@ lpfc_nvmet_unsol_ls_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	fc_hdr = (struct fc_frame_header *)(nvmebuf->hbuf.virt);
 	oxid = be16_to_cpu(fc_hdr->fh_ox_id);
 
-	if (!nvmebuf || !phba->targetport) {
+	if (!phba->targetport) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
 				"6154 LS Drop IO x%x\n", oxid);
 		oxid = 0;
@@ -1770,8 +1770,7 @@ lpfc_nvmet_unsol_ls_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		lpfc_nvmeio_data(phba, "NVMET LS  DROP: "
 				 "xri x%x sz %d from %06x\n",
 				 oxid, size, sid);
-		if (nvmebuf)
-			lpfc_in_buf_free(phba, &nvmebuf->dbuf);
+		lpfc_in_buf_free(phba, &nvmebuf->dbuf);
 		return;
 	}
 	ctxp->phba = phba;
@@ -1814,8 +1813,7 @@ lpfc_nvmet_unsol_ls_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			ctxp->oxid, rc);
 
 	/* We assume a rcv'ed cmd ALWAYs fits into 1 buffer */
-	if (nvmebuf)
-		lpfc_in_buf_free(phba, &nvmebuf->dbuf);
+	lpfc_in_buf_free(phba, &nvmebuf->dbuf);
 
 	atomic_inc(&tgtp->xmt_ls_abort);
 	lpfc_nvmet_unsol_ls_issue_abort(phba, ctxp, sid, oxid);
-- 
2.17.1
