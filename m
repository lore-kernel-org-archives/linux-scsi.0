From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 13/19] aacraid: Rework aac_src_restart
Date: Sun, 7 May 2017 06:34:18 -0700
Message-ID: <1494164064-17715-14-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
References: <1494164064-17715-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0047.outbound.protection.outlook.com ([104.47.38.47]:43008
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752667AbdEGVp4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 7 May 2017 17:45:56 -0400
In-Reply-To: <1494164064-17715-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, Prasad.Munirathnam@microsemi.com

Removed switch case and replaced with if mask checks. Moved KERNEL_PANIC
check to when bled is less than 0.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/src.c | 34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 8ed7be0..10a589b 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -772,8 +772,7 @@ static int aac_src_restart_adapter(struct aac_dev *dev, int bled, u8 reset_type)
 
 	dev->a_ops.adapter_enable_int = aac_src_disable_interrupt;
 
-	switch (reset_type) {
-	case IOP_HWSOFT_RESET:
+	if (reset_type & HW_IOP_RESET) {
 		aac_send_iop_reset(dev);
 
 		/*
@@ -784,12 +783,14 @@ static int aac_src_restart_adapter(struct aac_dev *dev, int bled, u8 reset_type)
 			dev_err(&dev->pdev->dev, "IOP reset failed\n");
 		else
 			goto set_startup;
+	}
 
-		if (!dev->sa_firmware) {
-			ret = -ENODEV;
-			goto out;
-		}
+	if (!dev->sa_firmware) {
+		ret = -ENODEV;
+		goto out;
+	}
 
+	if (reset_type & HW_SOFT_RESET) {
 		aac_send_hardware_soft_reset(dev);
 		dev->msi_enabled = 0;
 
@@ -799,30 +800,19 @@ static int aac_src_restart_adapter(struct aac_dev *dev, int bled, u8 reset_type)
 			ret = -ENODEV;
 			goto out;
 		}
-
-		break;
-	case HW_SOFT_RESET:
-		if (dev->sa_firmware) {
-			aac_send_hardware_soft_reset(dev);
-			aac_set_intx_mode(dev);
-		}
-		break;
-	default:
-		aac_send_iop_reset(dev);
-		break;
 	}
 
-invalid_out:
-
-	if (src_readl(dev, MUnit.OMR) & KERNEL_PANIC)
-		ret = -ENODEV;
-
 set_startup:
 	if (startup_timeout < 300)
 		startup_timeout = 300;
 
 out:
 	return ret;
+
+invalid_out:
+	if (src_readl(dev, MUnit.OMR) & KERNEL_PANIC)
+		ret = -ENODEV;
+goto out;
 }
 
 /**
-- 
2.7.4
