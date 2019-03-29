From: Colin King <colin.king@canonical.com>
Subject: [PATCH 1/2] scsi: pm8001: clean up structurally dead code when PM8001_USE_MSIX is defined
Date: Fri, 29 Mar 2019 23:44:22 +0000
Message-ID: <20190329234423.5611-2-colin.king@canonical.com>
References: <20190329234423.5611-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190329234423.5611-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jack Wang <jinpu.wang@profitbricks.com>, lindar_liu@usish.com, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

When macro PM8001_USE_MSIX is defined there is redundant dead code
call to pm8001_cr32.  Clean this up for the defined PM8001_USE_MSIX and
undefined PM8001_USE_MSIX cases.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 7 ++++---
 drivers/scsi/pm8001/pm80xx_hwi.c | 7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index e4209091c1da..434498a78946 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4625,15 +4625,16 @@ static int pm8001_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,
 
 static u32 pm8001_chip_is_our_interupt(struct pm8001_hba_info *pm8001_ha)
 {
-	u32 value;
 #ifdef PM8001_USE_MSIX
 	return 1;
-#endif
+#else
+	u32 value;
+
 	value = pm8001_cr32(pm8001_ha, 0, MSGU_ODR);
 	if (value)
 		return 1;
 	return 0;
-
+#endif
 }
 
 /**
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 536d2b4384f8..4a176e60307f 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4619,15 +4619,16 @@ static int pm80xx_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,
 
 static u32 pm80xx_chip_is_our_interupt(struct pm8001_hba_info *pm8001_ha)
 {
-	u32 value;
 #ifdef PM8001_USE_MSIX
 	return 1;
-#endif
+#else
+	u32 value;
+
 	value = pm8001_cr32(pm8001_ha, 0, MSGU_ODR);
 	if (value)
 		return 1;
 	return 0;
-
+#endif
 }
 
 /**
-- 
2.20.1
