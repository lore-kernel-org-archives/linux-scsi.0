From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 09/19] aacraid: Using single reset mask for IOP reset
Date: Sun, 7 May 2017 06:34:14 -0700
Message-ID: <1494164064-17715-10-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
References: <1494164064-17715-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0072.outbound.protection.outlook.com ([104.47.38.72]:22896
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753341AbdEGVpj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 7 May 2017 17:45:39 -0400
In-Reply-To: <1494164064-17715-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, Prasad.Munirathnam@microsemi.com

The driver can now trigger IOP reset with a single reset mask. Removed
code that retrieves a reset_mask from the firmware.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/aacraid.h |  5 ++++-
 drivers/scsi/aacraid/src.c     | 16 ++--------------
 2 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 3ede6de..993f134 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2381,6 +2381,7 @@ struct revision
 #define SOFT_RESET_TIME			60
 
 
+
 struct aac_common
 {
 	/*
@@ -2491,7 +2492,9 @@ struct aac_hba_info {
 #define IOP_RESET_FW_FIB_DUMP		0x00000034
 #define IOP_RESET			0x00001000
 #define IOP_RESET_ALWAYS		0x00001001
-#define RE_INIT_ADAPTER			0x000000ee
+#define RE_INIT_ADAPTER		0x000000ee
+
+#define IOP_SRC_RESET_MASK		0x00000100
 
 /*
  *	Adapter Status Register
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 2e5338d..c0e5242 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -704,22 +704,10 @@ static void aac_send_iop_reset(struct aac_dev *dev, int bled)
 				    0, 0, 0, 0, 0, 0, &var,
 				    &reset_mask, NULL, NULL, NULL);
 
-	if ((bled || var != 0x00000001) && !dev->doorbell_mask)
-		bled = -EINVAL;
-	else if (dev->doorbell_mask) {
-		reset_mask = dev->doorbell_mask;
-		bled = 0;
-		var = 0x00000001;
-	}
-
 	aac_set_intx_mode(dev);
 
-	if (!bled && (dev->supplement_adapter_info.supported_options2 &
-	    AAC_OPTION_DOORBELL_RESET)) {
-		src_writel(dev, MUnit.IDR, reset_mask);
-	} else {
-		src_writel(dev, MUnit.IDR, 0x100);
-	}
+	src_writel(dev, MUnit.IDR, IOP_SRC_RESET_MASK);
+
 	msleep(30000);
 }
 
-- 
2.7.4
