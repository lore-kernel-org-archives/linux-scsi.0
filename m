From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH -next] scsi: qedf: Fix error return code in __qedf_probe()
Date: Wed, 17 Jan 2018 12:42:41 +0000
Message-ID: <1516192961-52789-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, QLogic-Storage-Upstream@cavium.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Fix to return error code -ENOMEM from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/scsi/qedf/qedf_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 40800dd..ccd9a08 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3126,6 +3126,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	qedf->cmd_mgr = qedf_cmd_mgr_alloc(qedf);
 	if (!qedf->cmd_mgr) {
 		QEDF_ERR(&(qedf->dbg_ctx), "Failed to allocate cmd mgr.\n");
+		rc = -ENOMEM;
 		goto err5;
 	}
 
@@ -3149,6 +3150,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 		create_workqueue(host_buf);
 	if (!qedf->ll2_recv_wq) {
 		QEDF_ERR(&(qedf->dbg_ctx), "Failed to LL2 workqueue.\n");
+		rc = -ENOMEM;
 		goto err7;
 	}
 
@@ -3192,6 +3194,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	if (!qedf->timer_work_queue) {
 		QEDF_ERR(&(qedf->dbg_ctx), "Failed to start timer "
 			  "workqueue.\n");
+		rc = -ENOMEM;
 		goto err7;
 	}

