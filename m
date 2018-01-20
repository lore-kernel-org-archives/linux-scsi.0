From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 3/3] scsi: aacraid: Auto detect INTx or MSIx mode during sync cmd processing
Date: Fri, 19 Jan 2018 17:01:57 -0800
Message-ID: <20180120010157.22674-4-RaghavaAditya.Renukunta@microsemi.com>
References: <20180120010157.22674-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0052.outbound.protection.outlook.com ([104.47.38.52]:15104
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756037AbeATBCH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Jan 2018 20:02:07 -0500
In-Reply-To: <20180120010157.22674-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

During sync command processing if legacy INTx status indicates
command is not completed, sample the MSIx register and check if
it indicates command completion, set controller MSIx enabled flag.

Signed-off-by: Prasad B Munirathnam <prasad.munirathnam@microsemi.com>
Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/aacraid.h |  1 +
 drivers/scsi/aacraid/src.c     | 22 ++++++++++++++++------
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 784783b..7834d09 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1231,6 +1231,7 @@ struct src_registers {
 
 #define SRC_ODR_SHIFT		12
 #define SRC_IDR_SHIFT		9
+#define SRC_MSI_READ_MASK	0x1000
 
 typedef void (*fib_callback)(void *ctxt, struct fib *fibctx);
 
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index b05c3cf..f9600b6 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -1399,13 +1399,23 @@ void aac_src_access_devreg(struct aac_dev *dev, int mode)
 
 static int aac_src_get_sync_status(struct aac_dev *dev)
 {
+	int msix_val = 0;
+	int legacy_val = 0;
 
-	int val;
+	msix_val = src_readl(dev, MUnit.ODR_MSI) & SRC_MSI_READ_MASK ? 1 : 0;
 
-	if (dev->msi_enabled)
-		val = src_readl(dev, MUnit.ODR_MSI) & 0x1000 ? 1 : 0;
-	else
-		val = src_readl(dev, MUnit.ODR_R) >> SRC_ODR_SHIFT;
+	if (!dev->msi_enabled) {
+		/*
+		 * if Legacy int status indicates cmd is not complete
+		 * sample MSIx register to see if it indiactes cmd complete,
+		 * if yes set the controller in MSIx mode and consider cmd
+		 * completed
+		 */
+		legacy_val = src_readl(dev, MUnit.ODR_R) >> SRC_ODR_SHIFT;
+		if (!(legacy_val & 1) && msix_val)
+			dev->msi_enabled = 1;
+		return legacy_val;
+	}
 
-	return val;
+	return msix_val;
 }
-- 
2.9.4
