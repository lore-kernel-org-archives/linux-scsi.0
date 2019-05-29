From: Xidong Wang <wangxidong_97@163.com>
Subject: [PATCH 1/1] scsi: esas2r: esas2r_init: check return value
Date: Wed, 29 May 2019 14:09:00 +0800
Message-ID: <1559110140-3544-1-git-send-email-wangxidong_97@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Xidong Wang <wangxidong_97@163.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In esas2r_resume(), the return value of pci_enable_device() is not
checked before pdev is used.

Signed-off-by: Xidong Wang <wangxidong_97@163.com>
---
 drivers/scsi/esas2r/esas2r_init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index 950cd92..883d35f 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -686,6 +686,9 @@ int esas2r_resume(struct pci_dev *pdev)
 	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
 		       "pci_enable_device() called");
 	rez = pci_enable_device(pdev);
+	if (rez < 0) {
+		goto error_exit;
+	}
 	pci_set_master(pdev);
 
 	if (!a) {
-- 
2.7.4
