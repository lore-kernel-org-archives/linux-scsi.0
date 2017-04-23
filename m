From: Pan Bian <bianpan2016@163.com>
Subject: [PATCH 1/1] scsi: esas2r: fix unchecked return value
Date: Sun, 23 Apr 2017 13:32:39 +0800
Message-ID: <1492925559-1383-1-git-send-email-bianpan2016@163.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from m50-133.163.com ([123.125.50.133]:40599 "EHLO m50-133.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932067AbdDWFdA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 23 Apr 2017 01:33:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bradley Grove <linuxdrivers@attotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>

Function pci_enable_device() returns a negative errno on failure, and
its return value should be validated. In function esas2r_resume(), its
return value is ignored. This patch fixes the bug.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/scsi/esas2r/esas2r_init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index 6432a50..f482664 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -728,6 +728,8 @@ int esas2r_resume(struct pci_dev *pdev)
 	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
 		       "pci_enable_device() called");
 	rez = pci_enable_device(pdev);
+	if (rez)
+		goto error_exit;
 	pci_set_master(pdev);
 
 	if (!a) {
-- 
1.9.1
