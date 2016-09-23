From: Baoyou Xie <baoyou.xie@linaro.org>
Subject: [PATCH] pm8001: mark symbols static where possible
Date: Fri, 23 Sep 2016 21:54:22 +0800
Message-ID: <1474638862-22595-1-git-send-email-baoyou.xie@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jinpu.wang@profitbricks.com, lindar_liu@usish.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: pmchba@pmcs.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, baoyou.xie@linaro.org, xie.baoyou@zte.com.cn
List-Id: linux-scsi@vger.kernel.org

We get 2 warnings when building kernel with W=1:
drivers/scsi/pm8001/pm8001_sas.c:530:23: warning: no previous prototype for 'pm8001_alloc_dev' [-Wmissing-prototypes]
drivers/scsi/pm8001/pm8001_hwi.c:4495:5: warning: no previous prototype for 'pm8001_chip_phy_stop_req' [-Wmissing-prototypes]

In fact, these functions are only used in the file in which they are
declared and don't need a declaration, but can be made static.
so this patch marks these functions with 'static'.

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 4 ++--
 drivers/scsi/pm8001/pm8001_sas.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 04e67a1..10546fa 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4492,8 +4492,8 @@ pm8001_chip_phy_start_req(struct pm8001_hba_info *pm8001_ha, u8 phy_id)
  * @num: the inbound queue number
  * @phy_id: the phy id which we wanted to start up.
  */
-int pm8001_chip_phy_stop_req(struct pm8001_hba_info *pm8001_ha,
-	u8 phy_id)
+static int pm8001_chip_phy_stop_req(struct pm8001_hba_info *pm8001_ha,
+				    u8 phy_id)
 {
 	struct phy_stop_req payload;
 	struct inbound_queue_table *circularQ;
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index dc33dfa..ce584c3 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -527,7 +527,7 @@ void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,
   * pm8001_alloc_dev - find a empty pm8001_device
   * @pm8001_ha: our hba card information
   */
-struct pm8001_device *pm8001_alloc_dev(struct pm8001_hba_info *pm8001_ha)
+static struct pm8001_device *pm8001_alloc_dev(struct pm8001_hba_info *pm8001_ha)
 {
 	u32 dev;
 	for (dev = 0; dev < PM8001_MAX_DEVICES; dev++) {
-- 
2.7.4
