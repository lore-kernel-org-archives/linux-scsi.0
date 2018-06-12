From: Zhouyang Jia <jiazhouyang09@gmail.com>
Subject: [PATCH] scsi: esas2r: add error handling for pci_enable_device
Date: Tue, 12 Jun 2018 12:14:09 +0800
Message-ID: <1528776850-39672-1-git-send-email-jiazhouyang09@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Zhouyang Jia <jiazhouyang09@gmail.com>, Bradley Grove <linuxdrivers@attotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When pci_enable_device fails, the lack of error-handling code may
cause unexpected results.

This patch adds error-handling code after calling pci_enable_device.

Signed-off-by: Zhouyang Jia <jiazhouyang09@gmail.com>
---
 drivers/scsi/esas2r/esas2r_init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index 9dffcb2..364538c 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -707,6 +707,9 @@ int esas2r_resume(struct pci_dev *pdev)
 	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
 		       "pci_enable_device() called");
 	rez = pci_enable_device(pdev);
+	if (rez)
+		goto error_exit;
+
 	pci_set_master(pdev);
 
 	if (!a) {
-- 
2.7.4
