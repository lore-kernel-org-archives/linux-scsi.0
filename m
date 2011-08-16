From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 3/9] qla2xxx: Fix qla24xx revision check while enabling interrupts.
Date: Tue, 16 Aug 2011 11:29:24 -0700
Message-ID: <1313519370-22963-4-git-send-email-chad.dupuis@qlogic.com>
References: <1313519370-22963-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:30993 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab1HPSjd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2011 14:39:33 -0400
In-Reply-To: <1313519370-22963-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Since we enable interrupts before initializing the firmware, use the chip
revision from PCI config space directly to perform the chip revision check.
Also remove the unnecessary firmware attributes test.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index ec53e87..477767f 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2529,11 +2529,10 @@ qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 		goto skip_msi;
 	}
 
-	if (IS_QLA2432(ha) && (ha->pdev->revision < QLA_MSIX_CHIP_REV_24XX ||
-		!QLA_MSIX_FW_MODE_1(ha->fw_attributes))) {
+	if (IS_QLA2432(ha) && (ha->pdev->revision < QLA_MSIX_CHIP_REV_24XX)) {
 		ql_log(ql_log_warn, vha, 0x0035,
 		    "MSI-X; Unsupported ISP2432 (0x%X, 0x%X).\n",
-		    ha->pdev->revision, ha->fw_attributes);
+		    ha->pdev->revision, QLA_MSIX_CHIP_REV_24XX);
 		goto skip_msix;
 	}
 
-- 
1.6.0.2


