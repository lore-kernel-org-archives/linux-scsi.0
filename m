From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 2/4] scsi: ufs-qcom: add probe_defer in case phy driver not probed yet
Date: Mon,  5 Dec 2016 19:25:15 -0800
Message-ID: <1480994715-19658-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Yaniv Gardi <ygardi@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Yaniv Gardi <ygardi@codeaurora.org>

In case UFS driver is probed before the phy driver does, the
UFS driver should return a PROBE_DEFER code.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index aa43bfe..ff61461 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1194,7 +1194,16 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 	 */
 	host->generic_phy = devm_phy_get(dev, "ufsphy");
 
-	if (IS_ERR(host->generic_phy)) {
+	if (host->generic_phy == ERR_PTR(-EPROBE_DEFER)) {
+		/*
+		 * UFS driver might be probed before the phy driver does.
+		 * In that case we would like to return EPROBE_DEFER code.
+		 */
+		err = -EPROBE_DEFER;
+		dev_warn(dev, "%s: required phy device. hasn't probed yet. err = %d\n",
+			__func__, err);
+		goto out_variant_clear;
+	} else if (IS_ERR(host->generic_phy)) {
 		err = PTR_ERR(host->generic_phy);
 		dev_err(dev, "%s: PHY get failed %d\n", __func__, err);
 		goto out_variant_clear;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
