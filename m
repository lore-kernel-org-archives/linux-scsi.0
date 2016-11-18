From: Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH] ufs: qcom: Properly clear hba priv on failure
Date: Fri, 18 Nov 2016 12:55:42 -0800
Message-ID: <1479502542-1136-1-git-send-email-bjorn.andersson@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In the case where we fail to acquire the phy the hba priv will be set
already, so during cleanup ufs_qcom_setup_clocks() will dereference the
now free, but still "valid looking" pointer "host".

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index d345434b084f..7bd88ffee47a 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1197,7 +1197,7 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 	if (IS_ERR(host->generic_phy)) {
 		err = PTR_ERR(host->generic_phy);
 		dev_err(dev, "%s: PHY get failed %d\n", __func__, err);
-		goto out;
+		goto out_host_free;
 	}
 
 	err = ufs_qcom_bus_register(host);
-- 
2.5.0
