From: Yaniv Gardi <ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH v1 01/17] scsi: ufs-qcom: add number of lanes per direction
Date: Sun, 13 Sep 2015 17:52:41 +0300
Message-ID: <1442155977-7686-2-git-send-email-ygardi@codeaurora.org>
References: <1442155977-7686-1-git-send-email-ygardi@codeaurora.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442155977-7686-1-git-send-email-ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, santoshsy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-scsi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <JBottomley-wo1vFcy6AUs@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sujit Reddy Thumma <sthumma-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Raviv Shvili <rshvili-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Sahitya Tummala <stummala-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "open list:OPEN FIRMWARE AND FLATTENED
	DEVICE TREE BINDINGS" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Different platform may have different number of lanes
for the UFS link.
Add parameter to device tree specifying how many lanes
should be configured for the UFS link.

Signed-off-by: Gilad Broner <gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Signed-off-by: Yaniv Gardi <ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

---
 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  3 ++
 drivers/scsi/ufs/ufs-qcom.c                        | 38 ++++++++++++----------
 drivers/scsi/ufs/ufshcd.c                          | 20 ++++++++++++
 drivers/scsi/ufs/ufshcd.h                          |  2 ++
 4 files changed, 46 insertions(+), 17 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
index b39e765..56b105f 100644
--- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
+++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
@@ -31,6 +31,9 @@ Optional properties:
 			  defined or a value in the array is "0" then it is assumed
 			  that the frequency is set by the parent clock or a
 			  fixed rate clock source.
+- lanes-per-direction:	number of lanes available per direction - either 1 or 2.
+			Note that it is assume same number of lanes is used both directions at once.
+			If not specified, default is 2 lanes per direction.
 
 Note: If above properties are not defined it can be assumed that the supply
 regulators or clocks are always on.
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index c99eac9..3196197 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -132,21 +132,23 @@ static int ufs_qcom_enable_lane_clks(struct ufs_qcom_host *host)
 	if (err)
 		goto disable_rx_l0;
 
-	err = ufs_qcom_host_clk_enable(dev, "rx_lane1_sync_clk",
-		host->rx_l1_sync_clk);
-	if (err)
-		goto disable_tx_l0;
-
-	err = ufs_qcom_host_clk_enable(dev, "tx_lane1_sync_clk",
-		host->tx_l1_sync_clk);
-	if (err)
-		goto disable_rx_l1;
+	if (host->hba->lanes_per_direction > 1) {
+		err = ufs_qcom_host_clk_enable(dev, "rx_lane1_sync_clk",
+			host->rx_l1_sync_clk);
+		if (err)
+			goto disable_tx_l0;
 
+		err = ufs_qcom_host_clk_enable(dev, "tx_lane1_sync_clk",
+			host->tx_l1_sync_clk);
+		if (err)
+			goto disable_rx_l1;
+	}
 	host->is_lane_clks_enabled = true;
 	goto out;
 
 disable_rx_l1:
-	clk_disable_unprepare(host->rx_l1_sync_clk);
+	if (host->hba->lanes_per_direction > 1)
+		clk_disable_unprepare(host->rx_l1_sync_clk);
 disable_tx_l0:
 	clk_disable_unprepare(host->tx_l0_sync_clk);
 disable_rx_l0:
@@ -170,14 +172,16 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
 	if (err)
 		goto out;
 
-	err = ufs_qcom_host_clk_get(dev, "rx_lane1_sync_clk",
-		&host->rx_l1_sync_clk);
-	if (err)
-		goto out;
-
-	err = ufs_qcom_host_clk_get(dev, "tx_lane1_sync_clk",
-		&host->tx_l1_sync_clk);
+	/* In case of single lane per direction, don't read lane1 clocks */
+	if (host->hba->lanes_per_direction > 1) {
+		err = ufs_qcom_host_clk_get(dev, "rx_lane1_sync_clk",
+			&host->rx_l1_sync_clk);
+		if (err)
+			goto out;
 
+		err = ufs_qcom_host_clk_get(dev, "tx_lane1_sync_clk",
+			&host->tx_l1_sync_clk);
+	}
 out:
 	return err;
 }
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 1c37a7d..9638553 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -40,6 +40,7 @@
 #include <linux/async.h>
 #include <linux/devfreq.h>
 
+#include <linux/of.h>
 #include "ufshcd.h"
 #include "unipro.h"
 #define UFSHCD_REQ_SENSE_SIZE	18
@@ -87,6 +88,8 @@
 /* Interrupt aggregation default timeout, unit: 40us */
 #define INT_AGGR_DEF_TO	0x02
 
+#define UFSHCD_DEFAULT_LANES_PER_DIRECTION		2
+
 #define ufshcd_toggle_vreg(_dev, _vreg, _on)				\
 	({                                                              \
 		int _ret;                                               \
@@ -5765,6 +5768,21 @@ static struct devfreq_dev_profile ufs_devfreq_profile = {
 	.get_dev_status	= ufshcd_devfreq_get_dev_status,
 };
 
+static void ufshcd_init_lanes_per_dir(struct ufs_hba *hba)
+{
+	struct device *dev = hba->dev;
+	int ret;
+
+	ret = of_property_read_u32(dev->of_node, "lanes-per-direction",
+		&hba->lanes_per_direction);
+	if (ret) {
+		dev_dbg(hba->dev,
+			"%s: failed to read lanes-per-direction, ret=%d\n",
+			__func__, ret);
+		hba->lanes_per_direction = UFSHCD_DEFAULT_LANES_PER_DIRECTION;
+	}
+}
+
 /**
  * ufshcd_init - Driver initialization routine
  * @hba: per-adapter instance
@@ -5788,6 +5806,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	hba->mmio_base = mmio_base;
 	hba->irq = irq;
 
+	ufshcd_init_lanes_per_dir(hba);
+
 	err = ufshcd_hba_init(hba);
 	if (err)
 		goto out_error;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index f8ce680..e7bcf65 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -509,6 +509,8 @@ struct ufs_hba {
 
 	bool wlun_dev_clr_ua;
 
+	/* Number of lanes available (1 or 2) for Rx/Tx */
+	u32 lanes_per_direction;
 	struct ufs_pa_layer_attr pwr_info;
 	struct ufs_pwr_mode_info max_pwr_info;
 
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
