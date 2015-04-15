From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: [PATCH] ufs: Reinstate NULL pointer checks for regulators
Date: Wed, 15 Apr 2015 12:10:53 -0700
Message-ID: <1429125053-31825-1-git-send-email-bjorn.andersson@sonymobile.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Mark Brown <broonie@kernel.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The cleanup during the introduction of regulator_set_load() was a too
optimistic and re-opened an issue with vreg being dereferenced while
being NULL.

So reinstate the NULL checks and add back the BUG_ON() to follow the
general coding convention of the implementation.

Fixes: 7b16a07c3293 ("ufs: Rename of regulator_set_optimum_mode")
Reported-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 drivers/scsi/ufs/ufshcd.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 648a44675880..540e00df6de1 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4262,8 +4262,7 @@ static int ufshcd_config_vreg_load(struct device *dev, struct ufs_vreg *vreg,
 {
 	int ret;
 
-	if (!vreg)
-		return 0;
+	BUG_ON(!vreg);
 
 	ret = regulator_set_load(vreg->reg, ua);
 	if (ret < 0) {
@@ -4277,12 +4276,18 @@ static int ufshcd_config_vreg_load(struct device *dev, struct ufs_vreg *vreg,
 static inline int ufshcd_config_vreg_lpm(struct ufs_hba *hba,
 					 struct ufs_vreg *vreg)
 {
+	if (!vreg)
+		return 0;
+
 	return ufshcd_config_vreg_load(hba->dev, vreg, UFS_VREG_LPM_LOAD_UA);
 }
 
 static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
 					 struct ufs_vreg *vreg)
 {
+	if (!vreg)
+		return 0;
+
 	return ufshcd_config_vreg_load(hba->dev, vreg, vreg->max_uA);
 }
 
-- 
1.8.2.2
