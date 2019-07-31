From: Anil Varughese <aniljoy@cadence.com>
Subject: [PATCH] scsi: ufs: Additional clock initialization in Cadence UFS
Date: Wed, 31 Jul 2019 09:36:14 +0100
Message-ID: <20190731083614.25926-1-aniljoy@cadence.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: alim.akhtar@samsung.com, avri.altman@wdc.com, pedrom.sousa@synopsys.com
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, hare@suse.de, aniljoy@cadence.com, rafalc@cadence.com, mparab@cadence.com, jank@cadence.com, vigneshr@ti.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Configure CDNS_UFS_REG_HCLKDIV in .hce_enable_notify()
because if UFSHCD resets the controller ip because of
phy or device related errors then CDNS_UFS_REG_HCLKDIV
is reset to default value and .setup_clock() is not
called later in the sequence whereas hce_enable_notify
will be called everytime controller is reenabled.

Signed-off-by: Anil Varughese <aniljoy@cadence.com>
---
 drivers/scsi/ufs/cdns-pltfrm.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/scsi/ufs/cdns-pltfrm.c
index 86dbb723f..15ee54d28 100644
--- a/drivers/scsi/ufs/cdns-pltfrm.c
+++ b/drivers/scsi/ufs/cdns-pltfrm.c
@@ -78,6 +78,22 @@ static int cdns_ufs_setup_clocks(struct ufs_hba *hba, bool on,
 	return cdns_ufs_set_hclkdiv(hba);
 }
 
+/**
+ * Called before and after HCE enable bit is set.
+ * @hba: host controller instance
+ * @status: notify stage (pre, post change)
+ *
+ * Return zero for success and non-zero for failure
+ */
+static int cdns_ufs_hce_enable_notify(struct ufs_hba *hba,
+				      enum ufs_notify_change_status status)
+{
+	if (status != PRE_CHANGE)
+		return 0;
+
+	return cdns_ufs_set_hclkdiv(hba);
+}
+
 /**
  * cdns_ufs_init - performs additional ufs initialization
  * @hba: host controller instance
@@ -115,12 +131,14 @@ static int cdns_ufs_m31_16nm_phy_initialization(struct ufs_hba *hba)
 static const struct ufs_hba_variant_ops cdns_ufs_pltfm_hba_vops = {
 	.name = "cdns-ufs-pltfm",
 	.setup_clocks = cdns_ufs_setup_clocks,
+	.hce_enable_notify = cdns_ufs_hce_enable_notify,
 };
 
 static const struct ufs_hba_variant_ops cdns_ufs_m31_16nm_pltfm_hba_vops = {
 	.name = "cdns-ufs-pltfm",
 	.init = cdns_ufs_init,
 	.setup_clocks = cdns_ufs_setup_clocks,
+	.hce_enable_notify = cdns_ufs_hce_enable_notify,
 	.phy_initialization = cdns_ufs_m31_16nm_phy_initialization,
 };
 
-- 
2.15.0
