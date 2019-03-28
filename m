From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: pm8001: clean up structurally dead code when PM8001_USE_MSIX is defined
Date: Thu, 28 Mar 2019 23:43:28 +0000
Message-ID: <20190328234328.15860-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jack Wang <jinpu.wang@profitbricks.com>, lindar_liu@usish.com, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

When macro PM8001_USE_MSIX is defined there are redundant dead code
calls to pm8001_chip_intx_interrupt_{enable|disable}. Clean this up
by compiling in the appropriate enable/disable handlers for the
defined PM8001_USE_MSIX and undefined PM8001_USE_MSIX cases.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index e4209091c1da..7d81246a432b 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1204,6 +1204,7 @@ void pm8001_chip_iounmap(struct pm8001_hba_info *pm8001_ha)
 	}
 }
 
+#ifndef PM8001_USE_MSIX
 /**
  * pm8001_chip_interrupt_enable - enable PM8001 chip interrupt
  * @pm8001_ha: our hba card information
@@ -1225,6 +1226,8 @@ pm8001_chip_intx_interrupt_disable(struct pm8001_hba_info *pm8001_ha)
 	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, ODMR_MASK_ALL);
 }
 
+#else
+
 /**
  * pm8001_chip_msix_interrupt_enable - enable PM8001 chip interrupt
  * @pm8001_ha: our hba card information
@@ -1256,6 +1259,7 @@ pm8001_chip_msix_interrupt_disable(struct pm8001_hba_info *pm8001_ha,
 	msi_index += MSIX_TABLE_BASE;
 	pm8001_cw32(pm8001_ha, 0,  msi_index, MSIX_INTERRUPT_DISABLE);
 }
+#endif
 
 /**
  * pm8001_chip_interrupt_enable - enable PM8001 chip interrupt
@@ -1266,10 +1270,9 @@ pm8001_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
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
@@ -1281,10 +1284,9 @@ pm8001_chip_interrupt_disable(struct pm8001_hba_info *pm8001_ha, u8 vec)
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
-- 
2.20.1
