From: Colin King <colin.king@canonical.com>
Subject: [PATCH][next] scsi: lpfc: make several unions static, fix non-ANSI prototype
Date: Tue, 13 Mar 2018 12:08:49 +0000
Message-ID: <20180313120849.30128-1-colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are several unions that are local to the source and do not need
to be in global scope, so make them static. Also add in a missing void
parameter to functions lpfc_nvme_cmd_template and
lpfc_nvmet_cmd_template to clean up non-ANSI warning.

Cleans up sparse warnings:
drivers/scsi/lpfc/lpfc_nvme.c:68:19: warning: symbol
'lpfc_iread_cmd_template' was not declared. Should it be static?
drivers/scsi/lpfc/lpfc_nvme.c:69:19: warning: symbol
'lpfc_iwrite_cmd_template' was not declared. Should it be static?
drivers/scsi/lpfc/lpfc_nvme.c:70:19: warning: symbol
'lpfc_icmnd_cmd_template' was not declared. Should it be static?
drivers/scsi/lpfc/lpfc_nvme.c:74:24: warning: non-ANSI function
'lpfc_tsend_cmd_template' was not declared. Should it be static?
drivers/scsi/lpfc/lpfc_nvmet.c:78:19: warning: symbol
'lpfc_treceive_cmd_template' was not declared. Should it be static?
drivers/scsi/lpfc/lpfc_nvmet.c:79:19: warning: symbol
'lpfc_trsp_cmd_template' was not declared. Should it be static?
drivers/scsi/lpfc/lpfc_nvmet.c:83:25: warning: non-ANSI function
declaration of function 'lpfc_nvmet_cmd_template'

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c  | 8 ++++----
 drivers/scsi/lpfc/lpfc_nvmet.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 52dd9479b538..378dca40ca20 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -65,13 +65,13 @@ lpfc_release_nvme_buf(struct lpfc_hba *, struct lpfc_nvme_buf *);
 
 static struct nvme_fc_port_template lpfc_nvme_template;
 
-union lpfc_wqe128 lpfc_iread_cmd_template;
-union lpfc_wqe128 lpfc_iwrite_cmd_template;
-union lpfc_wqe128 lpfc_icmnd_cmd_template;
+static union lpfc_wqe128 lpfc_iread_cmd_template;
+static union lpfc_wqe128 lpfc_iwrite_cmd_template;
+static union lpfc_wqe128 lpfc_icmnd_cmd_template;
 
 /* Setup WQE templates for NVME IOs */
 void
-lpfc_nvme_cmd_template()
+lpfc_nvme_cmd_template(void)
 {
 	union lpfc_wqe128 *wqe;
 
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 07f89524c320..7271c9d885dd 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -74,13 +74,13 @@ static int lpfc_nvmet_unsol_ls_issue_abort(struct lpfc_hba *,
 static void lpfc_nvmet_wqfull_flush(struct lpfc_hba *, struct lpfc_queue *,
 				    struct lpfc_nvmet_rcv_ctx *);
 
-union lpfc_wqe128 lpfc_tsend_cmd_template;
-union lpfc_wqe128 lpfc_treceive_cmd_template;
-union lpfc_wqe128 lpfc_trsp_cmd_template;
+static union lpfc_wqe128 lpfc_tsend_cmd_template;
+static union lpfc_wqe128 lpfc_treceive_cmd_template;
+static union lpfc_wqe128 lpfc_trsp_cmd_template;
 
 /* Setup WQE templates for NVME IOs */
 void
-lpfc_nvmet_cmd_template()
+lpfc_nvmet_cmd_template(void)
 {
 	union lpfc_wqe128 *wqe;
 
-- 
2.15.1
