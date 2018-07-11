From: Colin King <colin.king@canonical.com>
Subject: [PATCH][scsi-next] scsi: lpfc: fix null pointer dereference on nvmebuf
Date: Wed, 11 Jul 2018 14:44:36 +0100
Message-ID: <20180711134436.21963-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The check of nvmebuf suggests that it can be null, however a recent
change dereferences it to determine oxid before it is null checked,
hence there is a potential null deference on the pointer.  Fix this
by performing the null check first.  Also remove the oxid from the
debug log message as this is no longer valid.  I considered an early
fetch of oxid if nvmebuf was valid, however, what oxid should be set
to if nvembuf is null could lead to an ambiguous logging of an invalid
oxid, so I thought just removing it from the logging was the least
confusion solution.

Detected by CoverityScan, CID#1471753 ("Dereference before null check")

Fixes: 68c9b55deea5 ("scsi: lpfc: Fix abort error path for NVMET")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 22f8a204b69f..01652d9ac619 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1742,12 +1742,9 @@ lpfc_nvmet_unsol_ls_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	uint32_t *payload;
 	uint32_t size, oxid, sid, rc;
 
-	fc_hdr = (struct fc_frame_header *)(nvmebuf->hbuf.virt);
-	oxid = be16_to_cpu(fc_hdr->fh_ox_id);
-
 	if (!nvmebuf || !phba->targetport) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
-				"6154 LS Drop IO x%x\n", oxid);
+				"6154 LS Drop IO\n");
 		oxid = 0;
 		size = 0;
 		sid = 0;
@@ -1755,6 +1752,9 @@ lpfc_nvmet_unsol_ls_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		goto dropit;
 	}
 
+	fc_hdr = (struct fc_frame_header *)(nvmebuf->hbuf.virt);
+	oxid = be16_to_cpu(fc_hdr->fh_ox_id);
+
 	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
 	payload = (uint32_t *)(nvmebuf->dbuf.virt);
 	size = bf_get(lpfc_rcqe_length,  &nvmebuf->cq_event.cqe.rcqe_cmpl);
-- 
2.17.1
