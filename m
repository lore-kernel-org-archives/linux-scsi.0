From: giridhar.malavali@qlogic.com
Subject: [PATCH 4/6] qla2xxx: Disable MSI on qla24xx chips other than QLA2432.
Date: Fri, 19 Mar 2010 16:59:19 -0700
Message-ID: <1269043161-2265-5-git-send-email-giridhar.malavali@qlogic.com>
References: <1269043161-2265-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:46301 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752275Ab0CSX7Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Mar 2010 19:59:25 -0400
In-Reply-To: <1269043161-2265-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>

From: Ben Hutchings <ben@decadent.org.uk>

On specific platforms, MSI is unreliable on some of the QLA24xx chips, resulting
in fatal I/O errors under load, as reported in <http://bugs.debian.org/572322>
and by some RHEL customers.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 295337d..44df0b7 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2271,30 +2271,28 @@ qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 
 	/* If possible, enable MSI-X. */
 	if (!IS_QLA2432(ha) && !IS_QLA2532(ha) &&
-	    !IS_QLA8432(ha) && !IS_QLA8001(ha))
-		goto skip_msix;
+		!IS_QLA8432(ha) && !IS_QLA8001(ha))
+		goto skip_msi;
+
+	if (ha->pdev->subsystem_vendor == PCI_VENDOR_ID_HP &&
+		(ha->pdev->subsystem_device == 0x7040 ||
+		ha->pdev->subsystem_device == 0x7041 ||
+		ha->pdev->subsystem_device == 0x1705)) {
+		DEBUG2(qla_printk(KERN_WARNING, ha,
+			"MSI-X: Unsupported ISP2432 SSVID/SSDID (0x%X,0x%X).\n",
+			ha->pdev->subsystem_vendor,
+			ha->pdev->subsystem_device));
+		goto skip_msi;
+	}
 
 	if (IS_QLA2432(ha) && (ha->pdev->revision < QLA_MSIX_CHIP_REV_24XX ||
 		!QLA_MSIX_FW_MODE_1(ha->fw_attributes))) {
 		DEBUG2(qla_printk(KERN_WARNING, ha,
 		"MSI-X: Unsupported ISP2432 (0x%X, 0x%X).\n",
 			ha->pdev->revision, ha->fw_attributes));
-
 		goto skip_msix;
 	}
 
-	if (ha->pdev->subsystem_vendor == PCI_VENDOR_ID_HP &&
-	    (ha->pdev->subsystem_device == 0x7040 ||
-		ha->pdev->subsystem_device == 0x7041 ||
-		ha->pdev->subsystem_device == 0x1705)) {
-		DEBUG2(qla_printk(KERN_WARNING, ha,
-		    "MSI-X: Unsupported ISP2432 SSVID/SSDID (0x%X, 0x%X).\n",
-		    ha->pdev->subsystem_vendor,
-		    ha->pdev->subsystem_device));
-
-		goto skip_msi;
-	}
-
 	ret = qla24xx_enable_msix(ha, rsp);
 	if (!ret) {
 		DEBUG2(qla_printk(KERN_INFO, ha,
-- 
1.6.2.rc1.30.gd43c

