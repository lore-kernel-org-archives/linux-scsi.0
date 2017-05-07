From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 17/19] aacraid : Add reset debugging statements
Date: Sun, 7 May 2017 06:34:22 -0700
Message-ID: <1494164064-17715-18-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
References: <1494164064-17715-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0067.outbound.protection.outlook.com ([104.47.37.67]:34981
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752860AbdEGVoi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 7 May 2017 17:44:38 -0400
In-Reply-To: <1494164064-17715-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, Prasad.Munirathnam@microsemi.com

Added info and error messages in controller reset function to log
information about the status of the IOP/SOFT reset.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/src.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 10a589b..5367d3f 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -761,8 +761,7 @@ static int aac_src_restart_adapter(struct aac_dev *dev, int bled, u8 reset_type)
 		goto invalid_out;
 
 	if (bled)
-		pr_err("%s%d: adapter kernel panic'd %x.\n",
-				dev->name, dev->id, bled);
+		dev_err(&dev->pdev->dev, "adapter kernel panic'd %x.\n", bled);
 
 	/*
 	 * When there is a BlinkLED, IOP_RESET has not effect
@@ -772,7 +771,10 @@ static int aac_src_restart_adapter(struct aac_dev *dev, int bled, u8 reset_type)
 
 	dev->a_ops.adapter_enable_int = aac_src_disable_interrupt;
 
+	dev_err(&dev->pdev->dev, "Controller reset type is %d\n", reset_type);
+
 	if (reset_type & HW_IOP_RESET) {
+		dev_info(&dev->pdev->dev, "Issuing IOP reset\n");
 		aac_send_iop_reset(dev);
 
 		/*
@@ -781,16 +783,20 @@ static int aac_src_restart_adapter(struct aac_dev *dev, int bled, u8 reset_type)
 		is_ctrl_up = aac_is_ctrl_up_and_running(dev);
 		if (!is_ctrl_up)
 			dev_err(&dev->pdev->dev, "IOP reset failed\n");
-		else
+		else {
+			dev_info(&dev->pdev->dev, "IOP reset succeded\n");
 			goto set_startup;
+		}
 	}
 
 	if (!dev->sa_firmware) {
+		dev_err(&dev->pdev->dev, "ARC Reset attempt failed\n");
 		ret = -ENODEV;
 		goto out;
 	}
 
 	if (reset_type & HW_SOFT_RESET) {
+		dev_info(&dev->pdev->dev, "Issuing SOFT reset\n");
 		aac_send_hardware_soft_reset(dev);
 		dev->msi_enabled = 0;
 
@@ -799,7 +805,8 @@ static int aac_src_restart_adapter(struct aac_dev *dev, int bled, u8 reset_type)
 			dev_err(&dev->pdev->dev, "SOFT reset failed\n");
 			ret = -ENODEV;
 			goto out;
-		}
+		} else
+			dev_info(&dev->pdev->dev, "SOFT reset succeded\n");
 	}
 
 set_startup:
-- 
2.7.4
