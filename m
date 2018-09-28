From: Evan Green <evgreen@chromium.org>
Subject: [PATCH v2 2/2] scsi: ufs: Execute START_STOP_UNIT during init
Date: Fri, 28 Sep 2018 16:02:03 -0700
Message-ID: <20180928230203.905-3-evgreen@chromium.org>
References: <20180928230203.905-1-evgreen@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180928230203.905-1-evgreen@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Adrian Hunter <adrian.hunter@intel.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Gwendal Grignou <gwendal@chromium.org>
List-Id: linux-scsi@vger.kernel.org

For UFS devices that are provisioned to have an initial power mode
(bInitPowerMode) of "sleep", Linux will currently fail to enumerate
the device. This is because the UFS specification says that the
device must get a START_STOP_UNIT SCSI command to wake the unit
up before other common initialization features like the device
descriptor will be available to be read.

This script executes a TEST UNIT READY and a START STOP UNIT SCSI
command to bring the device out of sleep mode before performing
additional low-level initialization.

Signed-off-by: Evan Green <evgreen@chromium.org>
---
Changes since v1:
	* Refactored into two patches.
	* Converted a leftover raw printk into dev_err.

 drivers/scsi/ufs/ufshcd.c | 44 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufshcd.h | 11 +++++++++++
 2 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d5c9ca581905..f19c44c7c2e5 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -243,6 +243,9 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba);
 static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
 static void ufshcd_hba_exit(struct ufs_hba *hba);
+static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
+				   enum ufs_dev_pwr_mode pwr_mode);
+
 static int ufshcd_probe_hba(struct ufs_hba *hba);
 static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 				 bool skip_ref_clk);
@@ -4221,6 +4224,35 @@ static int ufshcd_complete_dev_init(struct ufs_hba *hba)
 	return err;
 }
 
+/**
+ * ufshcd_power_on() - checks device power state, and sends START STOP UNIT
+ * if needed to bring the device out of sleep mode.
+ * @hba: per-adapter instance
+ *
+ */
+static int ufshcd_power_on(struct ufs_hba *hba)
+{
+	uint32_t current_pwr_mode;
+	int rc;
+
+	rc = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+		QUERY_ATTR_IDN_POWER_MODE, 0, 0,
+		&current_pwr_mode);
+
+	if (rc) {
+		dev_err(hba->dev, "Failed to get bCurrentPowerMode: %d\n", rc);
+		return rc;
+	}
+
+	if (current_pwr_mode != UFS_PWR_SLEEP)
+		return 0;
+
+	rc = ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE);
+	if (rc)
+		dev_err(hba->dev, "Failed to set power mode: %d\n", rc);
+
+	return rc;
+}
 /**
  * ufshcd_make_hba_operational - Make UFS controller operational
  * @hba: per adapter instance
@@ -6687,6 +6719,17 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 	if (ret)
 		goto out;
 
+	/*
+	 * Unit Attention will need to be cleared after a reset and before
+	 * the device can be told to come out of sleep mode.
+	 */
+	hba->wlun_dev_clr_ua = true;
+	ret = ufshcd_power_on(hba);
+	if (ret) {
+		dev_err(hba->dev, "Failed to start unit. err = %d\n", ret);
+		goto out;
+	}
+
 	/* Init check for device descriptor sizes */
 	ufshcd_init_desc_sizes(hba);
 
@@ -6708,7 +6751,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 	/* UFS device is also active now */
 	ufshcd_set_ufs_dev_active(hba);
 	ufshcd_force_reset_auto_bkops(hba);
-	hba->wlun_dev_clr_ua = true;
 
 	if (ufshcd_get_max_pwr_mode(hba)) {
 		dev_err(hba->dev,
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 33fdd3f281ae..7c340a4b6873 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -128,6 +128,17 @@ enum uic_link_state {
 #define ufshcd_set_link_hibern8(hba) ((hba)->uic_link_state = \
 				    UIC_LINK_HIBERN8_STATE)
 
+/* Values for the bCurrentPowerMode attribute */
+enum ufs_pwr_mode {
+	UFS_PWR_IDLE = 0x0,
+	UFS_PWR_PRE_ACTIVE = 0x1,
+	UFS_PWR_ACTIVE = 0x11,
+	UFS_PWR_PRE_SLEEP = 0x20,
+	UFS_PWR_SLEEP = 0x22,
+	UFS_PWR_PRE_PWR_DOWN = 0x30,
+	UFS_PWR_DOWN = 0x33,
+};
+
 /*
  * UFS Power management levels.
  * Each level is in increasing order of power savings.
-- 
2.16.4
