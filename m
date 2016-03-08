From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v7 01/17] scsi: ufs-qcom: add number of lanes per direction
Date: Tue,  8 Mar 2016 14:35:52 +0200
Message-ID: <1457440568-13084-2-git-send-email-ygardi@codeaurora.org>
References: <1457440568-13084-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1457440568-13084-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, ygardi@codeaurora.org, Gilad Broner <gbroner@codeaurora.org>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, "open list:OPEN FIRMWARE AND FLATTENED
	DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Different platform may have different number of lanes
for the UFS link.
Add parameter to device tree specifying how many lanes
should be configured for the UFS link.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  3 ++
 drivers/scsi/ufs/ufs-qcom.c                        | 39 ++++++++++++----------
 drivers/scsi/ufs/ufshcd-pltfrm.c                   | 19 +++++++++++
 drivers/scsi/ufs/ufshcd.c                          |  1 +
 drivers/scsi/ufs/ufshcd.h                          |  2 ++
 5 files changed, 47 insertions(+), 17 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
index 03c0e98..66f6adf 100644
--- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
+++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
@@ -38,6 +38,9 @@ Optional properties:
 			  defined or a value in the array is "0" then it is assumed
 			  that the frequency is set by the parent clock or a
 			  fixed rate clock source.
+-lanes-per-direction	: number of lanes available per direction - either 1 or 2.
+			  Note that it is assume same number of lanes is used both
+			  directions at once. If not specified, default is 2 lanes per direction.
 
 Note: If above properties are not defined it can be assumed that the supply
 regulators or clocks are always on.
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 4f38d00..ed57729 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2013-2015, Linux Foundation. All rights reserved.
+ * Copyright (c) 2013-2016, Linux Foundation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
@@ -132,21 +132,24 @@ static int ufs_qcom_enable_lane_clks(struct ufs_qcom_host *host)
 	if (err)
 		goto disable_rx_l0;
 
-	err = ufs_qcom_host_clk_enable(dev, "rx_lane1_sync_clk",
-		host->rx_l1_sync_clk);
-	if (err)
-		goto disable_tx_l0;
+	if (host->hba->lanes_per_direction > 1) {
+		err = ufs_qcom_host_clk_enable(dev, "rx_lane1_sync_clk",
+			host->rx_l1_sync_clk);
+		if (err)
+			goto disable_tx_l0;
 
-	err = ufs_qcom_host_clk_enable(dev, "tx_lane1_sync_clk",
-		host->tx_l1_sync_clk);
-	if (err)
-		goto disable_rx_l1;
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
@@ -170,14 +173,16 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
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
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index d2a7b12..718f12e 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -40,6 +40,8 @@
 #include "ufshcd.h"
 #include "ufshcd-pltfrm.h"
 
+#define UFSHCD_DEFAULT_LANES_PER_DIRECTION		2
+
 static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 {
 	int ret = 0;
@@ -277,6 +279,21 @@ void ufshcd_pltfrm_shutdown(struct platform_device *pdev)
 }
 EXPORT_SYMBOL_GPL(ufshcd_pltfrm_shutdown);
 
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
  * ufshcd_pltfrm_init - probe routine of the driver
  * @pdev: pointer to Platform device handle
@@ -331,6 +348,8 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
+	ufshcd_init_lanes_per_dir(hba);
+
 	err = ufshcd_init(hba, mmio_base, irq);
 	if (err) {
 		dev_err(dev, "Initialization failed\n");
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9c1b94b..a8e42df 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -40,6 +40,7 @@
 #include <linux/async.h>
 #include <linux/devfreq.h>
 
+#include <linux/of.h>
 #include "ufshcd.h"
 #include "unipro.h"
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index e3931d0..9ae7f85 100644
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
