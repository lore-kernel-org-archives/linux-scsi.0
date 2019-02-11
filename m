From: Marc Gonzalez <marc.w.gonzalez@free.fr>
Subject: [PATCH v5 1/2] scsi: ufs: Do not disable vccq in UFSHC driver
Date: Mon, 11 Feb 2019 14:32:15 +0100
Message-ID: <be3ef9bf-438b-4e8a-62c4-f75458e8ecc0@free.fr>
References: <494cd639-89a7-8868-b63a-ea7cdcba9777@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <494cd639-89a7-8868-b63a-ea7cdcba9777@free.fr>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Jeffrey Hugo <jhugo@codeaurora.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Joao Pinto <jpinto@synopsys.com>, Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>, Bart Van Assche <bart.vanassche@wdc.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>, Ohad Sharabi <ohad.sharabi@wdc.com>, Venkat Gopalakrishnan <venkatg@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Commit 60f0187031c0 ("disable vccq if it's not needed by UFS device")
introduced a small power optimization as a driver quirk: ignore the
vccq load specified in the UFSHC DT node when said host controller
is connected to specific Flash chips (Samsung and Hynix currently).

Unfortunately, this optimization breaks UFS on systems where vccq
powers not only the Flash chip, but the host controller as well,
such as APQ8098 MEDIABOX or MTP8998:

[    3.929877] ufshcd-qcom 1da4000.ufshc: ufshcd_query_attr: opcode 0x04 for idn 13 failed, index 0, err = -11
[    5.433815] ufshcd-qcom 1da4000.ufshc: ufshcd_query_attr: opcode 0x04 for idn 13 failed, index 0, err = -11
[    6.937771] ufshcd-qcom 1da4000.ufshc: ufshcd_query_attr: opcode 0x04 for idn 13 failed, index 0, err = -11
[    6.937866] ufshcd-qcom 1da4000.ufshc: ufshcd_query_attr_retry: query attribute, idn 13, failed with error -11 after 3 retires
[    6.946412] ufshcd-qcom 1da4000.ufshc: ufshcd_disable_auto_bkops: failed to enable exception event -11
[    6.957972] ufshcd-qcom 1da4000.ufshc: dme-peer-get: attr-id 0x1587 failed 3 retries
[    6.967181] ufshcd-qcom 1da4000.ufshc: dme-peer-get: attr-id 0x1586 failed 3 retries
[    6.975025] ufshcd-qcom 1da4000.ufshc: ufshcd_get_max_pwr_mode: invalid max pwm tx gear read = 0
[    6.982755] ufshcd-qcom 1da4000.ufshc: ufshcd_probe_hba: Failed getting max supported power mode
[    8.505770] ufshcd-qcom 1da4000.ufshc: ufshcd_query_flag: Sending flag query for idn 3 failed, err = -11
[   10.009807] ufshcd-qcom 1da4000.ufshc: ufshcd_query_flag: Sending flag query for idn 3 failed, err = -11
[   11.513766] ufshcd-qcom 1da4000.ufshc: ufshcd_query_flag: Sending flag query for idn 3 failed, err = -11
[   11.513861] ufshcd-qcom 1da4000.ufshc: ufshcd_query_flag_retry: query attribute, opcode 5, idn 3, failed with error -11 after 3 retires
[   13.049807] ufshcd-qcom 1da4000.ufshc: __ufshcd_query_descriptor: opcode 0x01 for idn 8 failed, index 0, err = -11
[   14.553768] ufshcd-qcom 1da4000.ufshc: __ufshcd_query_descriptor: opcode 0x01 for idn 8 failed, index 0, err = -11
[   16.057767] ufshcd-qcom 1da4000.ufshc: __ufshcd_query_descriptor: opcode 0x01 for idn 8 failed, index 0, err = -11
[   16.057872] ufshcd-qcom 1da4000.ufshc: ufshcd_read_desc_param: Failed reading descriptor. desc_id 8, desc_index 0, param_offset 0, ret -11
[   16.067109] ufshcd-qcom 1da4000.ufshc: ufshcd_init_icc_levels: Failed reading power descriptor.len = 98 ret = -11
[   37.073787] ufshcd-qcom 1da4000.ufshc: link startup failed 1

In my opinion, the rationale for the original patch is questionable.
If neither the UFSHC, nor the Flash chip, require any load from vccq,
then that power rail should simply not be specified at all in the DT.

Working around that fact in the driver is detrimental, as evidenced
by the failure to initialize the host controller on MSM8998.

Revert the original patch, and clean up loose ends in the next patch.

Relevant patches:

60f0187031c05e04cbadffb62f557d0ff3564490
c58ab7aab71e2c783087115f0ce1623c2fdcf0b2
46c1cf706076500cdcde3445be97233793eec7f1

Signed-off-by: Marc Gonzalez <marc.w.gonzalez@free.fr>
---
 drivers/scsi/ufs/ufs.h    |  1 -
 drivers/scsi/ufs/ufshcd.c | 59 +++------------------------------------
 2 files changed, 4 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 6d176815e6ce..21e4ccb5ba6e 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -514,7 +514,6 @@ struct ufs_vreg {
 	struct regulator *reg;
 	const char *name;
 	bool enabled;
-	bool unused;
 	int min_uV;
 	int max_uV;
 	int min_uA;
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5ca4581e60d5..a5bfcf04fdba 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -251,7 +251,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba);
 static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 				 bool skip_ref_clk);
 static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
-static int ufshcd_set_vccq_rail_unused(struct ufs_hba *hba, bool unused);
 static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba);
 static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
 static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
@@ -6830,11 +6829,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 	ufs_fixup_device_setup(hba, &card);
 	ufshcd_tune_unipro_params(hba);
 
-	ret = ufshcd_set_vccq_rail_unused(hba,
-		(hba->dev_quirks & UFS_DEVICE_NO_VCCQ) ? true : false);
-	if (ret)
-		goto out;
-
 	/* UFS device is also active now */
 	ufshcd_set_ufs_dev_active(hba);
 	ufshcd_force_reset_auto_bkops(hba);
@@ -7018,24 +7012,13 @@ static int ufshcd_config_vreg_load(struct device *dev, struct ufs_vreg *vreg,
 static inline int ufshcd_config_vreg_lpm(struct ufs_hba *hba,
 					 struct ufs_vreg *vreg)
 {
-	if (!vreg)
-		return 0;
-	else if (vreg->unused)
-		return 0;
-	else
-		return ufshcd_config_vreg_load(hba->dev, vreg,
-					       UFS_VREG_LPM_LOAD_UA);
+	return ufshcd_config_vreg_load(hba->dev, vreg, UFS_VREG_LPM_LOAD_UA);
 }
 
 static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
 					 struct ufs_vreg *vreg)
 {
-	if (!vreg)
-		return 0;
-	else if (vreg->unused)
-		return 0;
-	else
-		return ufshcd_config_vreg_load(hba->dev, vreg, vreg->max_uA);
+	return ufshcd_config_vreg_load(hba->dev, vreg, vreg->max_uA);
 }
 
 static int ufshcd_config_vreg(struct device *dev,
@@ -7073,9 +7056,7 @@ static int ufshcd_enable_vreg(struct device *dev, struct ufs_vreg *vreg)
 {
 	int ret = 0;
 
-	if (!vreg)
-		goto out;
-	else if (vreg->enabled || vreg->unused)
+	if (!vreg || vreg->enabled)
 		goto out;
 
 	ret = ufshcd_config_vreg(dev, vreg, true);
@@ -7095,9 +7076,7 @@ static int ufshcd_disable_vreg(struct device *dev, struct ufs_vreg *vreg)
 {
 	int ret = 0;
 
-	if (!vreg)
-		goto out;
-	else if (!vreg->enabled || vreg->unused)
+	if (!vreg || !vreg->enabled)
 		goto out;
 
 	ret = regulator_disable(vreg->reg);
@@ -7203,36 +7182,6 @@ static int ufshcd_init_hba_vreg(struct ufs_hba *hba)
 	return 0;
 }
 
-static int ufshcd_set_vccq_rail_unused(struct ufs_hba *hba, bool unused)
-{
-	int ret = 0;
-	struct ufs_vreg_info *info = &hba->vreg_info;
-
-	if (!info)
-		goto out;
-	else if (!info->vccq)
-		goto out;
-
-	if (unused) {
-		/* shut off the rail here */
-		ret = ufshcd_toggle_vreg(hba->dev, info->vccq, false);
-		/*
-		 * Mark this rail as no longer used, so it doesn't get enabled
-		 * later by mistake
-		 */
-		if (!ret)
-			info->vccq->unused = true;
-	} else {
-		/*
-		 * rail should have been already enabled hence just make sure
-		 * that unused flag is cleared.
-		 */
-		info->vccq->unused = false;
-	}
-out:
-	return ret;
-}
-
 static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 					bool skip_ref_clk)
 {
-- 
2.17.1
