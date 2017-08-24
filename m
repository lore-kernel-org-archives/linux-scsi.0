From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/2] scsi: lpfc: avoid an unused function warning
Date: Fri, 25 Aug 2017 01:09:59 +0200
Message-ID: <20170824231016.1843118-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Dan Carpenter <dan.carpenter@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The only reference to lpfc_nvmet_replenish_context() is inside of
an #ifdef, leading to a harmless warning when CONFIG_NVME_TARGET_FC
is disabled:

drivers/scsi/lpfc/lpfc_nvmet.c:1457:1: error: 'lpfc_nvmet_replenish_context' defined but not used [-Werror=unused-function]

This replaces the preprocessor conditional with a C condition,
so the compiler can see that the function is intentionally unused.

Fixes: 9a38e4f1c82f ("scsi: lpfc: Fix MRQ > 1 context list handling")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 48a1c0c27a3f..0b7c1a49e203 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1527,7 +1527,6 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
 			    struct rqb_dmabuf *nvmebuf,
 			    uint64_t isr_timestamp)
 {
-#if (IS_ENABLED(CONFIG_NVME_TARGET_FC))
 	struct lpfc_nvmet_rcv_ctx *ctxp;
 	struct lpfc_nvmet_tgtport *tgtp;
 	struct fc_frame_header *fc_hdr;
@@ -1541,6 +1540,9 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
 	uint32_t id;
 #endif
 
+	if (!IS_ENABLED(CONFIG_NVME_TARGET_FC))
+		return;
+
 	ctx_buf = NULL;
 	if (!nvmebuf || !phba->targetport) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
@@ -1695,7 +1697,6 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
 
 	if (nvmebuf)
 		lpfc_rq_buf_free(phba, &nvmebuf->hbuf); /* repost */
-#endif
 }
 
 /**
-- 
2.9.0
