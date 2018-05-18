From: Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH v3 1/3] scsi: ufs: Extract devfreq registration
Date: Thu, 17 May 2018 23:26:36 -0700
Message-ID: <20180518062638.31777-2-bjorn.andersson@linaro.org>
References: <20180518062638.31777-1-bjorn.andersson@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180518062638.31777-1-bjorn.andersson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Andy Gross <andy.gross@linaro.org>, MyungJoo Ham <myungjoo.ham@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Failing to register with devfreq leaves hba->devfreq assigned, which
causes the error path to dereference the ERR_PTR(). Rather than bolting
on more conditionals, move the call of devm_devfreq_add_device() into
it's own function and only update hba->devfreq once it's successfully
registered.

The subsequent patch builds upon this to make UFS actually work again,
as it's been broken since f1d981eaecf8 ("PM / devfreq: Use the available
min/max frequency")

Also switch to use DEVFREQ_GOV_SIMPLE_ONDEMAND constant.

Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---

Changes since v2:
- Use DEVFREQ_GOV_SIMPLE_ONDEMAND, per Chanwoo's recommendation
- Picked up Chanwoo's R-b

Changes since v1:
- None

 drivers/scsi/ufs/ufshcd.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 00e79057f870..f04902a066cb 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1287,6 +1287,26 @@ static struct devfreq_dev_profile ufs_devfreq_profile = {
 	.get_dev_status	= ufshcd_devfreq_get_dev_status,
 };
 
+static int ufshcd_devfreq_init(struct ufs_hba *hba)
+{
+	struct devfreq *devfreq;
+	int ret;
+
+	devfreq = devm_devfreq_add_device(hba->dev,
+			&ufs_devfreq_profile,
+			DEVFREQ_GOV_SIMPLE_ONDEMAND,
+			NULL);
+	if (IS_ERR(devfreq)) {
+		ret = PTR_ERR(devfreq);
+		dev_err(hba->dev, "Unable to register with devfreq %d\n", ret);
+		return ret;
+	}
+
+	hba->devfreq = devfreq;
+
+	return 0;
+}
+
 static void __ufshcd_suspend_clkscaling(struct ufs_hba *hba)
 {
 	unsigned long flags;
@@ -6439,16 +6459,9 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 				sizeof(struct ufs_pa_layer_attr));
 			hba->clk_scaling.saved_pwr_info.is_valid = true;
 			if (!hba->devfreq) {
-				hba->devfreq = devm_devfreq_add_device(hba->dev,
-							&ufs_devfreq_profile,
-							"simple_ondemand",
-							NULL);
-				if (IS_ERR(hba->devfreq)) {
-					ret = PTR_ERR(hba->devfreq);
-					dev_err(hba->dev, "Unable to register with devfreq %d\n",
-							ret);
+				ret = ufshcd_devfreq_init(hba);
+				if (ret)
 					goto out;
-				}
 			}
 			hba->clk_scaling.is_allowed = true;
 		}
-- 
2.17.0
