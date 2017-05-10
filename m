From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V2 11/19] aacraid: Add periodic checks to see IOP reset status
Date: Wed, 10 May 2017 09:39:45 -0700
Message-ID: <1494434393-17261-12-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
References: <1494434393-17261-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0049.outbound.protection.outlook.com ([104.47.42.49]:64427
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751761AbdEJGYT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 May 2017 02:24:19 -0400
In-Reply-To: <1494434393-17261-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, Prasad.Munirathnam@microsemi.com

Added function that waits with a timeout for the ctrl to be up and running
after triggering an IOP reset. Also removed 30 sec sleep as it is not
needed.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Reviewed-by: David Carroll <david.carroll@microsemi.com>

---
Changes in V2:
None

 drivers/scsi/aacraid/aacraid.h |  1 +
 drivers/scsi/aacraid/src.c     | 45 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 993f134..829f3d8 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2519,6 +2519,7 @@ struct aac_hba_info {
 
 #define	SELF_TEST_FAILED		0x00000004
 #define	MONITOR_PANIC			0x00000020
+#define	KERNEL_BOOTING			0x00000040
 #define	KERNEL_UP_AND_RUNNING		0x00000080
 #define	KERNEL_PANIC			0x00000100
 #define	FLASH_UPD_PENDING		0x00002000
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index e8e9178..67185eb 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -694,6 +694,37 @@ static void aac_dump_fw_fib_iop_reset(struct aac_dev *dev)
 			0, 0, 0,  0, 0, 0, NULL, NULL, NULL, NULL, NULL);
 }
 
+static bool aac_is_ctrl_up_and_running(struct aac_dev *dev)
+{
+	bool ctrl_up = true;
+	unsigned long status, start;
+	bool is_up = false;
+
+	start = jiffies;
+	do {
+		schedule();
+		status = src_readl(dev, MUnit.OMR);
+
+		if (status == 0xffffffff)
+			status = 0;
+
+		if (status & KERNEL_BOOTING) {
+			start = jiffies;
+			continue;
+		}
+
+		if (time_after(jiffies, start+HZ*SOFT_RESET_TIME)) {
+			ctrl_up = false;
+			break;
+		}
+
+		is_up = status & KERNEL_UP_AND_RUNNING;
+
+	} while (!is_up);
+
+	return ctrl_up;
+}
+
 static void aac_notify_fw_of_iop_reset(struct aac_dev *dev)
 {
 	aac_adapter_sync_cmd(dev, IOP_RESET_ALWAYS, 0, 0, 0, 0, 0, 0, NULL,
@@ -709,8 +740,6 @@ static void aac_send_iop_reset(struct aac_dev *dev)
 	aac_set_intx_mode(dev);
 
 	src_writel(dev, MUnit.IDR, IOP_SRC_RESET_MASK);
-
-	msleep(30000);
 }
 
 static void aac_send_hardware_soft_reset(struct aac_dev *dev)
@@ -726,6 +755,7 @@ static void aac_send_hardware_soft_reset(struct aac_dev *dev)
 static int aac_src_restart_adapter(struct aac_dev *dev, int bled, u8 reset_type)
 {
 	unsigned long status, start;
+	bool is_ctrl_up;
 
 	if (bled < 0)
 		goto invalid_out;
@@ -745,6 +775,16 @@ static int aac_src_restart_adapter(struct aac_dev *dev, int bled, u8 reset_type)
 	switch (reset_type) {
 	case IOP_HWSOFT_RESET:
 		aac_send_iop_reset(dev);
+
+		/*
+		 * Creates a delay or wait till up and running comes thru
+		 */
+		is_ctrl_up = aac_is_ctrl_up_and_running(dev);
+		if (!is_ctrl_up)
+			dev_err(&dev->pdev->dev, "IOP reset failed\n");
+		else
+			goto set_startup;
+
 		/*
 		 * Check to see if KERNEL_UP_AND_RUNNING
 		 * Wait for the adapter to be up and running.
@@ -780,6 +820,7 @@ static int aac_src_restart_adapter(struct aac_dev *dev, int bled, u8 reset_type)
 	if (src_readl(dev, MUnit.OMR) & KERNEL_PANIC)
 		return -ENODEV;
 
+set_startup:
 	if (startup_timeout < 300)
 		startup_timeout = 300;
 
-- 
2.7.4
