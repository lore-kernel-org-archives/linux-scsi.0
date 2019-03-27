From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: qedi: remove declaration of nvm_image from stack
Date: Wed, 27 Mar 2019 18:11:03 +0000
Message-ID: <20190327181103.15677-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@cavium.com, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The nvm_image is a large struct qedi_nvm_iscsi_image object of
over 24K so don't declare it on the stack just for a sizeof
requirement; use sizeof on struct qedi_nvm_iscsi_image instead.

Fixes: c77a2fa3ff8f ("scsi: qedi: Add the CRC size within iSCSI NVM image")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/qedi/qedi_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index e74a62448ba4..e5db9a9954dc 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1392,10 +1392,8 @@ static void qedi_free_nvm_iscsi_cfg(struct qedi_ctx *qedi)
 
 static int qedi_alloc_nvm_iscsi_cfg(struct qedi_ctx *qedi)
 {
-	struct qedi_nvm_iscsi_image nvm_image;
-
 	qedi->iscsi_image = dma_alloc_coherent(&qedi->pdev->dev,
-					       sizeof(nvm_image),
+					       sizeof(struct qedi_nvm_iscsi_image),
 					       &qedi->nvm_buf_dma, GFP_KERNEL);
 	if (!qedi->iscsi_image) {
 		QEDI_ERR(&qedi->dbg_ctx, "Could not allocate NVM BUF.\n");
@@ -2236,14 +2234,13 @@ static void qedi_boot_release(void *data)
 static int qedi_get_boot_info(struct qedi_ctx *qedi)
 {
 	int ret = 1;
-	struct qedi_nvm_iscsi_image nvm_image;
 
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
 		  "Get NVM iSCSI CFG image\n");
 	ret = qedi_ops->common->nvm_get_image(qedi->cdev,
 					      QED_NVM_IMAGE_ISCSI_CFG,
 					      (char *)qedi->iscsi_image,
-					      sizeof(nvm_image));
+					      sizeof(struct qedi_nvm_iscsi_image));
 	if (ret)
 		QEDI_ERR(&qedi->dbg_ctx,
 			 "Could not get NVM image. ret = %d\n", ret);
-- 
2.20.1
