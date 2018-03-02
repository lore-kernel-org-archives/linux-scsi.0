From: Can Guo <cang@codeaurora.org>
Subject: [PATCH v1] scsi: ufs: add 2 lane support
Date: Fri,  2 Mar 2018 16:18:08 +0800
Message-ID: <20180302082346.8188-1-cang@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: subhashj@codeaurora.org, asutoshd@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Venkat Gopalakrishnan <venkatg@codeaurora.org>, Can Guo <cang@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Venkat Gopalakrishnan <venkatg@codeaurora.org>

Qcom ufs controller v3.1.0 supports 2 lanes, add support
to configure 2 lanes during phy initialization.

Signed-off-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 2b38db2..51889ad 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -113,10 +113,10 @@ static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
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
 
@@ -147,18 +147,15 @@ static int ufs_qcom_enable_lane_clks(struct ufs_qcom_host *host)
 		if (err)
 			goto disable_tx_l0;
 
-		err = ufs_qcom_host_clk_enable(dev, "tx_lane1_sync_clk",
-			host->tx_l1_sync_clk);
-		if (err)
-			goto disable_rx_l1;
+		/* The tx lane1 clk could be muxed, hence keep this optional */
+		if (host->tx_l1_sync_clk)
+			ufs_qcom_host_clk_enable(dev, "tx_lane1_sync_clk",
+						 host->tx_l1_sync_clk);
 	}
 
 	host->is_lane_clks_enabled = true;
 	goto out;
 
-disable_rx_l1:
-	if (host->hba->lanes_per_direction > 1)
-		clk_disable_unprepare(host->rx_l1_sync_clk);
 disable_tx_l0:
 	clk_disable_unprepare(host->tx_l0_sync_clk);
 disable_rx_l0:
@@ -189,8 +186,9 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
 		if (err)
 			goto out;
 
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
