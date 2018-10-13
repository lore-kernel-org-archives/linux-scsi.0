From: Can Guo <cang@codeaurora.org>
Subject: [PATCH v4 1/1] scsi: ufs: make UFS Tx lane1 clock optional for QCOM platforms
Date: Fri, 12 Oct 2018 19:17:10 -0700
Message-ID: <1539397031-30014-1-git-send-email-cang@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dianders@chromium.org, subhashj@codeaurora.org, asutoshd@codeaurora.org, vivek.gautam@codeaurora.org, evgreen@chromium.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Venkat Gopalakrishnan <venkatg@codeaurora.org>, Can Guo <cang@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Venkat Gopalakrishnan <venkatg@codeaurora.org>

Per Qcom's UFS host controller HW design, the UFS Tx lane1 clock could be
muxed with Tx lane0 clock, hence keep Tx lane1 clock optional by ignoring
it if it is not provided in device tree. This change also performs some
cleanup to lanes per direction checks when enable/disable lane clocks just
for symmetry.

Signed-off-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Vivek Gautam <vivek.gautam@codeaurora.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
---
Changes since v3:
- Incorporated review comments from Doug.

Changes since v2:
- Incorporated review comments from Doug.

Changes since v1:
- Incorporated review comments from Doug.
- Update the commit title and commit message.

 drivers/scsi/ufs/ufs-qcom.c | 54 +++++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 2b38db2..9f9c6c7 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -79,20 +79,27 @@ static int ufs_qcom_get_connected_tx_lanes(struct ufs_hba *hba, u32 *tx_lanes)
 }
 
 static int ufs_qcom_host_clk_get(struct device *dev,
-		const char *name, struct clk **clk_out)
+		const char *name, struct clk **clk_out, bool optional)
 {
 	struct clk *clk;
 	int err = 0;
 
 	clk = devm_clk_get(dev, name);
-	if (IS_ERR(clk)) {
-		err = PTR_ERR(clk);
-		dev_err(dev, "%s: failed to get %s err %d",
-				__func__, name, err);
-	} else {
+	if (!IS_ERR(clk)) {
 		*clk_out = clk;
+		return 0;
 	}
 
+	err = PTR_ERR(clk);
+
+	if (optional && err == -ENOENT) {
+		*clk_out = NULL;
+		return 0;
+	}
+
+	if (err != -EPROBE_DEFER)
+		dev_err(dev, "failed to get %s err %d", name, err);
+
 	return err;
 }
 
@@ -113,11 +120,9 @@ static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
 	if (!host->is_lane_clks_enabled)
 		return;
 
-	if (host->hba->lanes_per_direction > 1)
-		clk_disable_unprepare(host->tx_l1_sync_clk);
+	clk_disable_unprepare(host->tx_l1_sync_clk);
 	clk_disable_unprepare(host->tx_l0_sync_clk);
-	if (host->hba->lanes_per_direction > 1)
-		clk_disable_unprepare(host->rx_l1_sync_clk);
+	clk_disable_unprepare(host->rx_l1_sync_clk);
 	clk_disable_unprepare(host->rx_l0_sync_clk);
 
 	host->is_lane_clks_enabled = false;
@@ -141,24 +146,21 @@ static int ufs_qcom_enable_lane_clks(struct ufs_qcom_host *host)
 	if (err)
 		goto disable_rx_l0;
 
-	if (host->hba->lanes_per_direction > 1) {
-		err = ufs_qcom_host_clk_enable(dev, "rx_lane1_sync_clk",
+	err = ufs_qcom_host_clk_enable(dev, "rx_lane1_sync_clk",
 			host->rx_l1_sync_clk);
-		if (err)
-			goto disable_tx_l0;
+	if (err)
+		goto disable_tx_l0;
 
-		err = ufs_qcom_host_clk_enable(dev, "tx_lane1_sync_clk",
+	err = ufs_qcom_host_clk_enable(dev, "tx_lane1_sync_clk",
 			host->tx_l1_sync_clk);
-		if (err)
-			goto disable_rx_l1;
-	}
+	if (err)
+		goto disable_rx_l1;
 
 	host->is_lane_clks_enabled = true;
 	goto out;
 
 disable_rx_l1:
-	if (host->hba->lanes_per_direction > 1)
-		clk_disable_unprepare(host->rx_l1_sync_clk);
+	clk_disable_unprepare(host->rx_l1_sync_clk);
 disable_tx_l0:
 	clk_disable_unprepare(host->tx_l0_sync_clk);
 disable_rx_l0:
@@ -172,25 +174,25 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
 	int err = 0;
 	struct device *dev = host->hba->dev;
 
-	err = ufs_qcom_host_clk_get(dev,
-			"rx_lane0_sync_clk", &host->rx_l0_sync_clk);
+	err = ufs_qcom_host_clk_get(dev, "rx_lane0_sync_clk",
+					&host->rx_l0_sync_clk, false);
 	if (err)
 		goto out;
 
-	err = ufs_qcom_host_clk_get(dev,
-			"tx_lane0_sync_clk", &host->tx_l0_sync_clk);
+	err = ufs_qcom_host_clk_get(dev, "tx_lane0_sync_clk",
+					&host->tx_l0_sync_clk, false);
 	if (err)
 		goto out;
 
 	/* In case of single lane per direction, don't read lane1 clocks */
 	if (host->hba->lanes_per_direction > 1) {
 		err = ufs_qcom_host_clk_get(dev, "rx_lane1_sync_clk",
-			&host->rx_l1_sync_clk);
+			&host->rx_l1_sync_clk, false);
 		if (err)
 			goto out;
 
 		err = ufs_qcom_host_clk_get(dev, "tx_lane1_sync_clk",
-			&host->tx_l1_sync_clk);
+			&host->tx_l1_sync_clk, true);
 	}
 out:
 	return err;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
