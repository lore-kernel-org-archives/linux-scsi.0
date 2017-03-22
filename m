From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: pm8001: build in relevant functions and code on PM8001_USE_MSIX
Date: Wed, 22 Mar 2017 18:50:04 +0000
Message-ID: <20170322185004.1012-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:48319 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935233AbdCVTYi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2017 15:24:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jinpu.wang@profitbricks.com>, lindar_liu@usish.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, pmchba@pmcs.com, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the misx and intx variables of the interrupt enable/disable
helper functions are built in no matter what the setting of the
macro PM8001_USE_MSIX.  Clean this up by just building in the
necessary helper functions and calls to these functions depending on
the setting of PM8001_USE_MSIX.  This addresses several dead code
paths found by static analysis with CoverityScan.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 63 +++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 10546faac58c..d1be10fd1350 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1204,26 +1204,7 @@ void pm8001_chip_iounmap(struct pm8001_hba_info *pm8001_ha)
 	}
 }
 
-/**
- * pm8001_chip_interrupt_enable - enable PM8001 chip interrupt
- * @pm8001_ha: our hba card information
- */
-static void
-pm8001_chip_intx_interrupt_enable(struct pm8001_hba_info *pm8001_ha)
-{
-	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, ODMR_CLEAR_ALL);
-	pm8001_cw32(pm8001_ha, 0, MSGU_ODCR, ODCR_CLEAR_ALL);
-}
-
- /**
-  * pm8001_chip_intx_interrupt_disable- disable PM8001 chip interrupt
-  * @pm8001_ha: our hba card information
-  */
-static void
-pm8001_chip_intx_interrupt_disable(struct pm8001_hba_info *pm8001_ha)
-{
-	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, ODMR_MASK_ALL);
-}
+#ifdef PM8001_USE_MSIX
 
 /**
  * pm8001_chip_msix_interrupt_enable - enable PM8001 chip interrupt
@@ -1257,6 +1238,30 @@ pm8001_chip_msix_interrupt_disable(struct pm8001_hba_info *pm8001_ha,
 	pm8001_cw32(pm8001_ha, 0,  msi_index, MSIX_INTERRUPT_DISABLE);
 }
 
+#else
+
+/**
+ * pm8001_chip_interrupt_enable - enable PM8001 chip interrupt
+ * @pm8001_ha: our hba card information
+ */
+static void
+pm8001_chip_intx_interrupt_enable(struct pm8001_hba_info *pm8001_ha)
+{
+	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, ODMR_CLEAR_ALL);
+	pm8001_cw32(pm8001_ha, 0, MSGU_ODCR, ODCR_CLEAR_ALL);
+}
+
+ /**
+  * pm8001_chip_intx_interrupt_disable- disable PM8001 chip interrupt
+  * @pm8001_ha: our hba card information
+  */
+static void
+pm8001_chip_intx_interrupt_disable(struct pm8001_hba_info *pm8001_ha)
+{
+	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, ODMR_MASK_ALL);
+}
+#endif
+
 /**
  * pm8001_chip_interrupt_enable - enable PM8001 chip interrupt
  * @pm8001_ha: our hba card information
@@ -1266,10 +1271,9 @@ pm8001_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 {
 #ifdef PM8001_USE_MSIX
 	pm8001_chip_msix_interrupt_enable(pm8001_ha, 0);
-	return;
-#endif
+#else
 	pm8001_chip_intx_interrupt_enable(pm8001_ha);
-
+#endif
 }
 
 /**
@@ -1281,10 +1285,9 @@ pm8001_chip_interrupt_disable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 {
 #ifdef PM8001_USE_MSIX
 	pm8001_chip_msix_interrupt_disable(pm8001_ha, 0);
-	return;
-#endif
+#else
 	pm8001_chip_intx_interrupt_disable(pm8001_ha);
-
+#endif
 }
 
 /**
@@ -4613,15 +4616,15 @@ static int pm8001_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,
 
 static u32 pm8001_chip_is_our_interupt(struct pm8001_hba_info *pm8001_ha)
 {
-	u32 value;
 #ifdef PM8001_USE_MSIX
 	return 1;
-#endif
-	value = pm8001_cr32(pm8001_ha, 0, MSGU_ODR);
+#else
+	u32 value = pm8001_cr32(pm8001_ha, 0, MSGU_ODR);
+
 	if (value)
 		return 1;
 	return 0;
-
+#endif
 }
 
 /**
-- 
2.11.0
