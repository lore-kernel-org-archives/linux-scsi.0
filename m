From: Can Guo <cang@codeaurora.org>
Subject: [PATCH v2 1/1] scsi: ufs: make UFS Tx lane1 clock optional for QCOM platforms
Date: Thu, 11 Oct 2018 05:33:14 -0700
Message-ID: <1539261196-14550-1-git-send-email-cang@codeaurora.org>
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
---

Changes since v1:
- Incorporated review comments from Doug.
- Update the commit title and commit message.

 drivers/scsi/ufs/ufs-qcom.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 2b38db2..a7ec959 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -79,13 +79,19 @@ static int ufs_qcom_get_connected_tx_lanes(struct ufs_hba *hba, u32 *tx_lanes)
 }
 
 static int ufs_qcom_host_clk_get(struct device *dev,
-		const char *name, struct clk **clk_out)
+		const char *name, struct clk **clk_out, bool optional)
 {
 	struct clk *clk;
 	int err = 0;
 
 	clk = devm_clk_get(dev, name);
-	if (IS_ERR(clk)) {
+	if (clk == ERR_PTR(-EPROBE_DEFER)) {
+		err = -EPROBE_DEFER;
+		dev_warn(dev, "required clock %s hasn't probed yet, err %d\n",
+				name, err);
+	} else if (IS_ERR(clk)) {
+		if (optional)
+			return 0;
 		err = PTR_ERR(clk);
 		dev_err(dev, "%s: failed to get %s err %d",
 				__func__, name, err);
@@ -113,10 +119,10 @@ static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
 	if (!host->is_lane_clks_enabled)
 		return;
 
-	if (host->hba->lanes_per_direction > 1)
+	if (host->tx_l1_sync_clk)
 		clk_disable_unprepare(host->tx_l1_sync_clk);
 	clk_disable_unprepare(host->tx_l0_sync_clk);
-	if (host->hba->lanes_per_direction > 1)
+	if (host->rx_l1_sync_clk)
 		clk_disable_unprepare(host->rx_l1_sync_clk);
 	clk_disable_unprepare(host->rx_l0_sync_clk);
 
@@ -141,12 +147,14 @@ static int ufs_qcom_enable_lane_clks(struct ufs_qcom_host *host)
 	if (err)
 		goto disable_rx_l0;
 
-	if (host->hba->lanes_per_direction > 1) {
+	if (host->rx_l1_sync_clk) {
 		err = ufs_qcom_host_clk_enable(dev, "rx_lane1_sync_clk",
 			host->rx_l1_sync_clk);
 		if (err)
 			goto disable_tx_l0;
+	}
 
+	if (host->tx_l1_sync_clk) {
 		err = ufs_qcom_host_clk_enable(dev, "tx_lane1_sync_clk",
 			host->tx_l1_sync_clk);
 		if (err)
@@ -157,8 +165,7 @@ static int ufs_qcom_enable_lane_clks(struct ufs_qcom_host *host)
 	goto out;
 
 disable_rx_l1:
-	if (host->hba->lanes_per_direction > 1)
-		clk_disable_unprepare(host->rx_l1_sync_clk);
+	clk_disable_unprepare(host->rx_l1_sync_clk);
 disable_tx_l0:
 	clk_disable_unprepare(host->tx_l0_sync_clk);
 disable_rx_l0:
@@ -172,25 +179,25 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
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
