From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] scsi: lpfc: Make some symbols static
Date: Fri, 31 May 2019 23:28:41 +0800
Message-ID: <20190531152841.13684-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.ibm.com, martin.petersen@oracle.com, jsmart2021@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Fix sparse warnings:

drivers/scsi/lpfc/lpfc_sli.c:115:1: warning: symbol 'lpfc_sli4_pcimem_bcopy' was not declared. Should it be static?
drivers/scsi/lpfc/lpfc_sli.c:7854:1: warning: symbol 'lpfc_sli4_process_missed_mbox_completions' was not declared. Should it be static?
drivers/scsi/lpfc/lpfc_nvmet.c:223:27: warning: symbol 'lpfc_nvmet_get_ctx_for_xri' was not declared. Should it be static?
drivers/scsi/lpfc/lpfc_nvmet.c:245:27: warning: symbol 'lpfc_nvmet_get_ctx_for_oxid' was not declared. Should it be static?
drivers/scsi/lpfc/lpfc_init.c:75:10: warning: symbol 'lpfc_present_cpu' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/lpfc/lpfc_init.c  | 2 +-
 drivers/scsi/lpfc/lpfc_nvmet.c | 4 ++--
 drivers/scsi/lpfc/lpfc_sli.c   | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index cd8e47544d07..faf43b1d3dbe 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -72,7 +72,7 @@ unsigned long _dump_buf_dif_order;
 spinlock_t _dump_buf_lock;
 
 /* Used when mapping IRQ vectors in a driver centric manner */
-uint32_t lpfc_present_cpu;
+static uint32_t lpfc_present_cpu;
 
 static void lpfc_get_hba_model_desc(struct lpfc_hba *, uint8_t *, uint8_t *);
 static int lpfc_post_rcv_buf(struct lpfc_hba *);
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index eb93189f4544..e471bbcca838 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -220,7 +220,7 @@ lpfc_nvmet_cmd_template(void)
 	/* Word 12, 13, 14, 15 - is zero */
 }
 
-struct lpfc_nvmet_rcv_ctx *
+static struct lpfc_nvmet_rcv_ctx *
 lpfc_nvmet_get_ctx_for_xri(struct lpfc_hba *phba, u16 xri)
 {
 	struct lpfc_nvmet_rcv_ctx *ctxp;
@@ -242,7 +242,7 @@ lpfc_nvmet_get_ctx_for_xri(struct lpfc_hba *phba, u16 xri)
 	return NULL;
 }
 
-struct lpfc_nvmet_rcv_ctx *
+static struct lpfc_nvmet_rcv_ctx *
 lpfc_nvmet_get_ctx_for_oxid(struct lpfc_hba *phba, u16 oxid, u32 sid)
 {
 	struct lpfc_nvmet_rcv_ctx *ctxp;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 081c4357958e..dea8b9df27c0 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -108,7 +108,7 @@ lpfc_get_iocb_from_iocbq(struct lpfc_iocbq *iocbq)
  * endianness. This function can be called with or without
  * lock.
  **/
-void
+static void
 lpfc_sli4_pcimem_bcopy(void *srcp, void *destp, uint32_t cnt)
 {
 	uint64_t *src = srcp;
@@ -7882,7 +7882,7 @@ lpfc_sli4_mbox_completions_pending(struct lpfc_hba *phba)
  * and will process all the completions associated with the eq for the
  * mailbox completion queue.
  **/
-bool
+static bool
 lpfc_sli4_process_missed_mbox_completions(struct lpfc_hba *phba)
 {
 	struct lpfc_sli4_hba *sli4_hba = &phba->sli4_hba;
-- 
2.17.1
