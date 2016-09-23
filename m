From: Baoyou Xie <baoyou.xie@linaro.org>
Subject: [PATCH] pm80xx: mark symbols static where possible
Date: Fri, 23 Sep 2016 21:56:35 +0800
Message-ID: <1474638995-19833-1-git-send-email-baoyou.xie@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jinpu.wang@profitbricks.com, lindar_liu@usish.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: pmchba@pmcs.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, baoyou.xie@linaro.org, xie.baoyou@zte.com.cn
List-Id: linux-scsi@vger.kernel.org

We get 2 warnings when building kernel with W=1:
drivers/scsi/pm8001/pm80xx_hwi.c:69:6: warning: no previous prototype for 'pm80xx_pci_mem_copy' [-Wmissing-prototypes]
drivers/scsi/pm8001/pm80xx_hwi.c:4540:6: warning: no previous prototype for 'mpi_set_phy_profile_req' [-Wmissing-prototypes]

In fact, these functions are only used in the file in which they are
declared and don't need a declaration, but can be made static.
so this patch marks these functions with 'static'.

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index eb4fee6..cab4024 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -66,7 +66,7 @@ int pm80xx_bar4_shift(struct pm8001_hba_info *pm8001_ha, u32 shift_value)
 	return 0;
 }
 
-void pm80xx_pci_mem_copy(struct pm8001_hba_info  *pm8001_ha, u32 soffset,
+static void pm80xx_pci_mem_copy(struct pm8001_hba_info  *pm8001_ha, u32 soffset,
 				const void *destination,
 				u32 dw_count, u32 bus_base_number)
 {
@@ -4537,8 +4537,9 @@ pm80xx_chip_isr(struct pm8001_hba_info *pm8001_ha, u8 vec)
 	return IRQ_HANDLED;
 }
 
-void mpi_set_phy_profile_req(struct pm8001_hba_info *pm8001_ha,
-	u32 operation, u32 phyid, u32 length, u32 *buf)
+static void
+mpi_set_phy_profile_req(struct pm8001_hba_info *pm8001_ha,
+			u32 operation, u32 phyid, u32 length, u32 *buf)
 {
 	u32 tag , i, j = 0;
 	int rc;
-- 
2.7.4
