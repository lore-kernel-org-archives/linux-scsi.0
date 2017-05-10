From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V2 12/19] aacraid: Rework SOFT reset code
Date: Wed, 10 May 2017 09:39:46 -0700
Message-ID: <1494434393-17261-13-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
References: <1494434393-17261-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0070.outbound.protection.outlook.com ([104.47.37.70]:59902
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751585AbdEJGYU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 May 2017 02:24:20 -0400
In-Reply-To: <1494434393-17261-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, Prasad.Munirathnam@microsemi.com

Now the driver issues a soft reset and waits for the controller to be up
and running by periodically checking on the status of the controller
health registers. Also prevents ARC adapters from issuing soft reset if
IOP resets failed.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Reviewed-by: David Carroll <david.carroll@microsemi.com>

---
Changes in V2:
None

 drivers/scsi/aacraid/src.c | 38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 67185eb..8ed7be0 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -754,8 +754,8 @@ static void aac_send_hardware_soft_reset(struct aac_dev *dev)
 
 static int aac_src_restart_adapter(struct aac_dev *dev, int bled, u8 reset_type)
 {
-	unsigned long status, start;
 	bool is_ctrl_up;
+	int ret = 0;
 
 	if (bled < 0)
 		goto invalid_out;
@@ -785,24 +785,21 @@ static int aac_src_restart_adapter(struct aac_dev *dev, int bled, u8 reset_type)
 		else
 			goto set_startup;
 
-		/*
-		 * Check to see if KERNEL_UP_AND_RUNNING
-		 * Wait for the adapter to be up and running.
-		 * If !KERNEL_UP_AND_RUNNING issue HW Soft Reset
-		 */
-		status = src_readl(dev, MUnit.OMR);
-		if (dev->sa_firmware
-		 && !(status & KERNEL_UP_AND_RUNNING)) {
-			start = jiffies;
-			do {
-				status = src_readl(dev, MUnit.OMR);
-				if (time_after(jiffies,
-				 start+HZ*SOFT_RESET_TIME)) {
-					aac_send_hardware_soft_reset(dev);
-					start = jiffies;
-				}
-			} while (!(status & KERNEL_UP_AND_RUNNING));
+		if (!dev->sa_firmware) {
+			ret = -ENODEV;
+			goto out;
 		}
+
+		aac_send_hardware_soft_reset(dev);
+		dev->msi_enabled = 0;
+
+		is_ctrl_up = aac_is_ctrl_up_and_running(dev);
+		if (!is_ctrl_up) {
+			dev_err(&dev->pdev->dev, "SOFT reset failed\n");
+			ret = -ENODEV;
+			goto out;
+		}
+
 		break;
 	case HW_SOFT_RESET:
 		if (dev->sa_firmware) {
@@ -818,13 +815,14 @@ static int aac_src_restart_adapter(struct aac_dev *dev, int bled, u8 reset_type)
 invalid_out:
 
 	if (src_readl(dev, MUnit.OMR) & KERNEL_PANIC)
-		return -ENODEV;
+		ret = -ENODEV;
 
 set_startup:
 	if (startup_timeout < 300)
 		startup_timeout = 300;
 
-	return 0;
+out:
+	return ret;
 }
 
 /**
-- 
2.7.4
