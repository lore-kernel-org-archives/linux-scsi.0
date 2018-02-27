From: Can Guo <cang@codeaurora.org>
Subject: [PATCH v2] scsi: ufs-qcom: add number of lanes for Tx and Rx links
Date: Tue, 27 Feb 2018 13:46:17 +0800
Message-ID: <20180227055500.10416-1-cang@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: subhashj@codeaurora.org, asutoshd@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Gilad Broner <gbroner@codeaurora.org>, Can Guo <cang@codeaurora.org>, Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Venkat Gopalakrishnan <venkatg@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Amit Nischal <anischal@codeaurora.org>, Maya Erez <merez@codeaurora.org>, "open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Gilad Broner <gbroner@codeaurora.org>

Different platforms may have different number of lanes for the UFS Tx/Rx
links. Add parameter to device tree specifying how many lanes should be
configured for the UFS Tx/Rx links. And don't print err message for clocks
that are optional, this leads to unnecessary confusion about failure.

Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
---

Changes since v1:
	- Change commit subject for better description.
	- Incorporated Rob's review comments to use lanes-tx and lanes-rx
	  to handle asymmetric Tx/Rx links.

 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  4 ++
 drivers/scsi/ufs/ufs-qcom.c                        | 65 +++++++++++++---------
 drivers/scsi/ufs/ufshcd.c                          | 29 ++++++++++
 drivers/scsi/ufs/ufshcd.h                          |  5 ++
 4 files changed, 78 insertions(+), 25 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
index 5357919..257308e 100644
--- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
+++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
@@ -31,6 +31,10 @@ Optional properties:
 			  defined or a value in the array is "0" then it is assumed
 			  that the frequency is set by the parent clock or a
 			  fixed rate clock source.
+- lanes-tx		: Number of lanes available for Tx direction - either 1 or 2.
+			  If not specified, default is 2 lanes.
+- lanes-rx		: Number of lanes available for Rx direction - either 1 or 2.
+			  If not specified, default is 2 lanes.
 
 Note: If above properties are not defined it can be assumed that the supply
 regulators or clocks are always on.
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 4cdffa4..154e7f1 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -50,13 +50,10 @@ static int ufs_qcom_host_clk_get(struct device *dev,
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
@@ -78,9 +75,11 @@ static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
 	if (!host->is_lane_clks_enabled)
 		return;
 
-	clk_disable_unprepare(host->tx_l1_sync_clk);
+	if (host->tx_l1_sync_clk)
+		clk_disable_unprepare(host->tx_l1_sync_clk);
 	clk_disable_unprepare(host->tx_l0_sync_clk);
-	clk_disable_unprepare(host->rx_l1_sync_clk);
+	if (host->rx_l1_sync_clk)
+		clk_disable_unprepare(host->rx_l1_sync_clk);
 	clk_disable_unprepare(host->rx_l0_sync_clk);
 
 	host->is_lane_clks_enabled = false;
@@ -104,21 +103,23 @@ static int ufs_qcom_enable_lane_clks(struct ufs_qcom_host *host)
 	if (err)
 		goto disable_rx_l0;
 
-	err = ufs_qcom_host_clk_enable(dev, "rx_lane1_sync_clk",
-		host->rx_l1_sync_clk);
-	if (err)
-		goto disable_tx_l0;
+	if (host->hba->lanes_rx > 1) {
+		err = ufs_qcom_host_clk_enable(dev, "rx_lane1_sync_clk",
+			host->rx_l1_sync_clk);
+		if (err)
+			goto disable_tx_l0;
+	}
 
-	err = ufs_qcom_host_clk_enable(dev, "tx_lane1_sync_clk",
-		host->tx_l1_sync_clk);
-	if (err)
-		goto disable_rx_l1;
+	if (host->hba->lanes_tx > 1) {
+		/* The tx lane1 clk could be muxed, hence keep this optional */
+		if (host->tx_l1_sync_clk)
+			ufs_qcom_host_clk_enable(dev, "tx_lane1_sync_clk",
+						 host->tx_l1_sync_clk);
+	}
 
 	host->is_lane_clks_enabled = true;
 	goto out;
 
-disable_rx_l1:
-	clk_disable_unprepare(host->rx_l1_sync_clk);
 disable_tx_l0:
 	clk_disable_unprepare(host->tx_l0_sync_clk);
 disable_rx_l0:
@@ -134,21 +135,35 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
 
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
 
-	err = ufs_qcom_host_clk_get(dev, "rx_lane1_sync_clk",
-		&host->rx_l1_sync_clk);
-	if (err)
-		goto out;
+	if (host->hba->lanes_rx > 1) {
+		err = ufs_qcom_host_clk_get(dev, "rx_lane1_sync_clk",
+			&host->rx_l1_sync_clk);
+		if (err) {
+			dev_err(dev, "%s: failed to get rx_lane1_sync_clk, err %d",
+					__func__, err);
+			goto out;
+		}
+	}
 
-	err = ufs_qcom_host_clk_get(dev, "tx_lane1_sync_clk",
-		&host->tx_l1_sync_clk);
+	if (host->hba->lanes_tx > 1) {
+		/* The tx lane1 clk could be muxed, hence keep this optional */
+		ufs_qcom_host_clk_get(dev, "tx_lane1_sync_clk",
+					&host->tx_l1_sync_clk);
+	}
 out:
 	return err;
 }
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b0ade73..307d0070 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -39,6 +39,7 @@
 
 #include <linux/async.h>
 #include <linux/devfreq.h>
+#include <linux/of.h>
 
 #include "ufshcd.h"
 #include "unipro.h"
@@ -74,6 +75,8 @@
 /* Interrupt aggregation default timeout, unit: 40us */
 #define INT_AGGR_DEF_TO	0x02
 
+#define UFSHCD_DEFAULT_LANES_PER_DIRECTION		2
+
 #define ufshcd_toggle_vreg(_dev, _vreg, _on)				\
 	({                                                              \
 		int _ret;                                               \
@@ -5530,6 +5533,30 @@ static struct devfreq_dev_profile ufs_devfreq_profile = {
 	.get_dev_status	= ufshcd_devfreq_get_dev_status,
 };
 
+static void ufshcd_init_lanes_per_dir(struct ufs_hba *hba)
+{
+	struct device *dev = hba->dev;
+	int ret;
+
+	ret = of_property_read_u32(dev->of_node, "lanes-tx",
+		&hba->lanes_tx);
+	if (ret) {
+		dev_dbg(hba->dev,
+			"%s: failed to read lanes-tx, ret=%d\n",
+			__func__, ret);
+		hba->lanes_tx = UFSHCD_DEFAULT_LANES_PER_DIRECTION;
+	}
+
+	ret = of_property_read_u32(dev->of_node, "lanes-rx",
+		&hba->lanes_rx);
+	if (ret) {
+		dev_dbg(hba->dev,
+			"%s: failed to read lanes-rx, ret=%d\n",
+			__func__, ret);
+		hba->lanes_rx = UFSHCD_DEFAULT_LANES_PER_DIRECTION;
+	}
+}
+
 /**
  * ufshcd_init - Driver initialization routine
  * @hba: per-adapter instance
@@ -5553,6 +5580,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	hba->mmio_base = mmio_base;
 	hba->irq = irq;
 
+	ufshcd_init_lanes_per_dir(hba);
+
 	err = ufshcd_hba_init(hba);
 	if (err)
 		goto out_error;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c40a0e7..b3b8abe 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -500,6 +500,11 @@ struct ufs_hba {
 
 	bool wlun_dev_clr_ua;
 
+	/* Number of lanes available (1 or 2) for Tx */
+	u32 lanes_tx;
+	/* Number of lanes available (1 or 2) for Rx */
+	u32 lanes_rx;
+
 	struct ufs_pa_layer_attr pwr_info;
 	struct ufs_pwr_mode_info max_pwr_info;
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
