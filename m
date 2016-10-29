From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH v3 05/12] phy: qcom-ufs: Skip obtaining rx/tx_iface_clk for msm8996 based phy
Date: Sun, 30 Oct 2016 01:52:07 +0530
Message-ID: <1477772534-14170-6-git-send-email-vivek.gautam@codeaurora.org>
References: <1477772534-14170-1-git-send-email-vivek.gautam@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1477772534-14170-1-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: kishon@ti.com, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com
Cc: sboyd@codeaurora.org, subhashj@codeaurora.org, ygardi@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

The tx_iface_clk and rx_iface_clk no longer exist with UFS Phy
present on msm8996. So skip obtaining these clocks using
compatible match.

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
---

New patch in v3 of this cleanup series.
Comes in place of the following patch in v2 -
 phy: qcom-ufs: remove failure when rx/tx_iface_clk are absent

 drivers/phy/phy-qcom-ufs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/phy/phy-qcom-ufs.c b/drivers/phy/phy-qcom-ufs.c
index a173b30..11c8cae 100644
--- a/drivers/phy/phy-qcom-ufs.c
+++ b/drivers/phy/phy-qcom-ufs.c
@@ -184,6 +184,10 @@ int ufs_qcom_phy_clk_get(struct device *dev,
 {
 	int err;
 
+	if (of_device_is_compatible(phy_common->dev->of_node,
+				"qcom,msm8996-ufs-phy-qmp-14nm"))
+		goto skip_txrx_clk;
+
 	err = ufs_qcom_phy_clk_get(phy_common->dev, "tx_iface_clk",
 				   &phy_common->tx_iface_clk);
 	if (err)
@@ -199,6 +203,7 @@ int ufs_qcom_phy_clk_get(struct device *dev,
 	if (err)
 		goto out;
 
+skip_txrx_clk:
 	/*
 	 * "ref_clk_parent" is optional hence don't abort init if it's not
 	 * found.
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
