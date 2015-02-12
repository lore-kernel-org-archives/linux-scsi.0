From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: [PATCH 2/5] ufs: Rename of regulator_set_optimum_mode
Date: Wed, 11 Feb 2015 19:35:28 -0800
Message-ID: <1423712131-23795-3-git-send-email-bjorn.andersson@sonymobile.com>
References: <1423712131-23795-1-git-send-email-bjorn.andersson@sonymobile.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1423712131-23795-1-git-send-email-bjorn.andersson@sonymobile.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Mark Brown <broonie@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The function regulator_set_optimum_mode() is changing name to
regulator_set_load(), so update the code accordingly. Also cleaned up
ufshcd_config_vreg_load() while touching the code.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 drivers/scsi/ufs/ufshcd.c | 27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2e4614b..4b73b94 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4225,22 +4225,15 @@ static struct scsi_host_template ufshcd_driver_template = {
 static int ufshcd_config_vreg_load(struct device *dev, struct ufs_vreg *vreg,
 				   int ua)
 {
-	int ret = 0;
-	struct regulator *reg = vreg->reg;
-	const char *name = vreg->name;
+	int ret;
 
-	BUG_ON(!vreg);
+	if (!vreg)
+		return 0;
 
-	ret = regulator_set_optimum_mode(reg, ua);
-	if (ret >= 0) {
-		/*
-		 * regulator_set_optimum_mode() returns new regulator
-		 * mode upon success.
-		 */
-		ret = 0;
-	} else {
-		dev_err(dev, "%s: %s set optimum mode(ua=%d) failed, err=%d\n",
-				__func__, name, ua, ret);
+	ret = regulator_set_load(vreg->reg, ua);
+	if (ret < 0) {
+		dev_err(dev, "%s: %s set load (ua=%d) failed, err=%d\n",
+				__func__, vreg->name, ua, ret);
 	}
 
 	return ret;
@@ -4249,18 +4242,12 @@ static int ufshcd_config_vreg_load(struct device *dev, struct ufs_vreg *vreg,
 static inline int ufshcd_config_vreg_lpm(struct ufs_hba *hba,
 					 struct ufs_vreg *vreg)
 {
-	if (!vreg)
-		return 0;
-
 	return ufshcd_config_vreg_load(hba->dev, vreg, UFS_VREG_LPM_LOAD_UA);
 }
 
 static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
 					 struct ufs_vreg *vreg)
 {
-	if (!vreg)
-		return 0;
-
 	return ufshcd_config_vreg_load(hba->dev, vreg, vreg->max_uA);
 }
 
-- 
1.8.2.2
