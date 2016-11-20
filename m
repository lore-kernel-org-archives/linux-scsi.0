From: Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH v2] ufs: qcom: Properly clear hba priv on failure
Date: Sat, 19 Nov 2016 22:34:51 -0800
Message-ID: <1479623691-7612-1-git-send-email-bjorn.andersson@linaro.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Subhash Jadavani <subhashj@codeaurora.org>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

ufs_qcom_init() sets the hba priv data before attempting to acquire the
phy handle, so make sure to clear this in the case of an error. Failing
to do this will make ufs_qcom_setup_clocks() operate on the uninitalized
host object.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index d345434b084f..4de372d271b0 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1197,12 +1197,12 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 	if (IS_ERR(host->generic_phy)) {
 		err = PTR_ERR(host->generic_phy);
 		dev_err(dev, "%s: PHY get failed %d\n", __func__, err);
-		goto out;
+		goto out_variant_clear;
 	}
 
 	err = ufs_qcom_bus_register(host);
 	if (err)
-		goto out_host_free;
+		goto out_variant_clear;
 
 	ufs_qcom_get_controller_revision(hba, &host->hw_ver.major,
 		&host->hw_ver.minor, &host->hw_ver.step);
@@ -1267,7 +1267,7 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 	phy_power_off(host->generic_phy);
 out_unregister_bus:
 	phy_exit(host->generic_phy);
-out_host_free:
+out_variant_clear:
 	ufshcd_set_variant(hba, NULL);
 out:
 	return err;
-- 
2.5.0
