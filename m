From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 10/19] aacraid: Rework IOP reset
Date: Sun, 7 May 2017 06:34:15 -0700
Message-ID: <1494164064-17715-11-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
References: <1494164064-17715-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0060.outbound.protection.outlook.com ([104.47.38.60]:56655
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752471AbdEGVpj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 7 May 2017 17:45:39 -0400
In-Reply-To: <1494164064-17715-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, Prasad.Munirathnam@microsemi.com

Reworked IOP reset to remove unneeded variable and created a helper
function to notify fw of an imminent IOP reset.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/src.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index c0e5242..e8e9178 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -694,15 +694,17 @@ static void aac_dump_fw_fib_iop_reset(struct aac_dev *dev)
 			0, 0, 0,  0, 0, 0, NULL, NULL, NULL, NULL, NULL);
 }
 
-static void aac_send_iop_reset(struct aac_dev *dev, int bled)
+static void aac_notify_fw_of_iop_reset(struct aac_dev *dev)
 {
-	u32 var, reset_mask;
+	aac_adapter_sync_cmd(dev, IOP_RESET_ALWAYS, 0, 0, 0, 0, 0, 0, NULL,
+						NULL, NULL, NULL, NULL);
+}
 
+static void aac_send_iop_reset(struct aac_dev *dev)
+{
 	aac_dump_fw_fib_iop_reset(dev);
 
-	bled = aac_adapter_sync_cmd(dev, IOP_RESET_ALWAYS,
-				    0, 0, 0, 0, 0, 0, &var,
-				    &reset_mask, NULL, NULL, NULL);
+	aac_notify_fw_of_iop_reset(dev);
 
 	aac_set_intx_mode(dev);
 
@@ -742,7 +744,7 @@ static int aac_src_restart_adapter(struct aac_dev *dev, int bled, u8 reset_type)
 
 	switch (reset_type) {
 	case IOP_HWSOFT_RESET:
-		aac_send_iop_reset(dev, bled);
+		aac_send_iop_reset(dev);
 		/*
 		 * Check to see if KERNEL_UP_AND_RUNNING
 		 * Wait for the adapter to be up and running.
@@ -769,7 +771,7 @@ static int aac_src_restart_adapter(struct aac_dev *dev, int bled, u8 reset_type)
 		}
 		break;
 	default:
-		aac_send_iop_reset(dev, bled);
+		aac_send_iop_reset(dev);
 		break;
 	}
 
-- 
2.7.4
