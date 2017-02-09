From: Dave Carroll <david.carroll@microsemi.com>
Subject: [PATCH] aacraid: Fix INTx/MSI-x issue with older controllers
Date: Thu, 9 Feb 2017 11:04:47 -0700
Message-ID: <20170209180447.31404-1-david.carroll@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0078.outbound.protection.outlook.com ([104.47.36.78]:43200
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751027AbdBISn6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Feb 2017 13:43:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Dave Carroll <david.carroll@microsemi.com>, linux-scsi <linux-scsi@vger.kernel.org>, aacraid@microsemi.com, Scott Benesh <scott.benesh@microsemi.com>, stable@vger.kernel.org

commit 78cbccd3bd683 ("[PATCH] aacraid: Fix for KDUMP driver hang")
 
caused a problem on older controllers which do not support MSI-x (namely
ASR3405,ASR3805). This patch conditionalizes the previous patch to 
controllers which support MSI-x

cc: stable@vger.kernel.org
Fixes: 78cbccd3bd683c295a44af8050797dc4a41376ff
Reported-by: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Signed-off-by: Dave Carroll <david.carroll@microsemi.com>
Reviewed-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/comminit.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 4f56b10..d56df36 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -50,9 +50,13 @@ struct aac_common aac_config = {
 
 static inline int aac_is_msix_mode(struct aac_dev *dev)
 {
-	u32 status;
+	u32 status = 0;
 
-	status = src_readl(dev, MUnit.OMR);
+	if (dev->pdev->device == PMC_DEVICE_S6 ||
+		dev->pdev->device == PMC_DEVICE_S7 ||
+		dev->pdev->device == PMC_DEVICE_S8) {
+		status = src_readl(dev, MUnit.OMR);
+	}
 	return (status & AAC_INT_MODE_MSIX);
 }
 
-- 
2.8.4
