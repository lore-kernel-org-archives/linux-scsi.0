From: Can Guo <cang@codeaurora.org>
Subject: [PATCH 1/1] scsi: ufs: make UFS Tx lane1 clock optional
Date: Sun,  7 Oct 2018 21:34:34 -0700
Message-ID: <1538973275-5961-1-git-send-email-cang@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: subhashj@codeaurora.org, asutoshd@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, evgreen@chromium.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Venkat Gopalakrishnan <venkatg@codeaurora.org>, Can Guo <cang@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Venkat Gopalakrishnan <venkatg@codeaurora.org>

The UFS Tx lane1 clock could be muxed, hence keep it optional by ignoring
it if it is not provided in device tree.

Signed-off-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 46 ++++++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 2b38db2..a6e2ed3 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -85,13 +85,10 @@ static int ufs_qcom_host_clk_get(struct device *dev,
 	int err = 0;
 
 	clk = devm_clk_get(dev, name);
-	if (IS_ERR(clk)) {
+	if (IS_ERR(clk))
 		err = PTR_ERR(clk);
-		dev_err(dev, "%s: failed to get %s err %d",
-				__func__, name, err);
-	} else {
+	else
 		*clk_out = clk;
-	}
 
 	return err;
 }
@@ -113,10 +110,10 @@ static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
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
 
@@ -141,24 +138,21 @@ static int ufs_qcom_enable_lane_clks(struct ufs_qcom_host *host)
 	if (err)
 		goto disable_rx_l0;
 
-	if (host->hba->lanes_per_direction > 1) {
+	if (host->rx_l1_sync_clk) {
 		err = ufs_qcom_host_clk_enable(dev, "rx_lane1_sync_clk",
 			host->rx_l1_sync_clk);
 		if (err)
 			goto disable_tx_l0;
-
-		err = ufs_qcom_host_clk_enable(dev, "tx_lane1_sync_clk",
-			host->tx_l1_sync_clk);
-		if (err)
-			goto disable_rx_l1;
 	}
 
+	/* The tx lane1 clk could be muxed, hence keep this optional */
+	if (host->tx_l1_sync_clk)
+		ufs_qcom_host_clk_enable(dev, "tx_lane1_sync_clk",
+					 host->tx_l1_sync_clk);
+
 	host->is_lane_clks_enabled = true;
 	goto out;
 
-disable_rx_l1:
-	if (host->hba->lanes_per_direction > 1)
-		clk_disable_unprepare(host->rx_l1_sync_clk);
 disable_tx_l0:
 	clk_disable_unprepare(host->tx_l0_sync_clk);
 disable_rx_l0:
@@ -174,23 +168,33 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
 
 	err = ufs_qcom_host_clk_get(dev,
 			"rx_lane0_sync_clk", &host->rx_l0_sync_clk);
-	if (err)
+	if (err) {
+		dev_err(dev, "%s: failed to get rx_lane0_sync_clk, err %d",
+				__func__, err);
 		goto out;
+	}
 
 	err = ufs_qcom_host_clk_get(dev,
 			"tx_lane0_sync_clk", &host->tx_l0_sync_clk);
-	if (err)
+	if (err) {
+		dev_err(dev, "%s: failed to get tx_lane0_sync_clk, err %d",
+				__func__, err);
 		goto out;
+	}
 
 	/* In case of single lane per direction, don't read lane1 clocks */
 	if (host->hba->lanes_per_direction > 1) {
 		err = ufs_qcom_host_clk_get(dev, "rx_lane1_sync_clk",
 			&host->rx_l1_sync_clk);
-		if (err)
+		if (err) {
+			dev_err(dev, "%s: failed to get rx_lane1_sync_clk, err %d",
+					__func__, err);
 			goto out;
+		}
 
-		err = ufs_qcom_host_clk_get(dev, "tx_lane1_sync_clk",
-			&host->tx_l1_sync_clk);
+		/* The tx lane1 clk could be muxed, hence keep this optional */
+		ufs_qcom_host_clk_get(dev, "tx_lane1_sync_clk",
+					&host->tx_l1_sync_clk);
 	}
 out:
 	return err;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
