From: Sayali Lokhande <sayalil@codeaurora.org>
Subject: [PATCH V5 1/2] scsi: ufs: set the device reference clock setting
Date: Fri,  6 Jul 2018 11:50:39 +0530
Message-ID: <1530858040-13971-2-git-send-email-sayalil@codeaurora.org>
References: <1530858040-13971-1-git-send-email-sayalil@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1530858040-13971-1-git-send-email-sayalil@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, evgreen@chromium.org, riteshh@codeaurora.org
Cc: linux-scsi@vger.kernel.org, Sayali Lokhande <sayalil@codeaurora.org>, Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Mathieu Malaterre <malat@debian.org>, "open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Subhash Jadavani <subhashj@codeaurora.org>

UFS host supplies the reference clock to UFS device and UFS device
specification allows host to provide one of the 4 frequencies (19.2 MHz,
26 MHz, 38.4 MHz, 52 MHz) for reference clock. Host should set the
device reference clock frequency setting in the device based on what
frequency it is supplying to UFS device.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
---
 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  7 +++
 drivers/scsi/ufs/ufs.h                             |  9 ++++
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |  2 +
 drivers/scsi/ufs/ufshcd.c                          | 62 ++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.h                          |  2 +
 5 files changed, 82 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
index c39dfef..bc20f59 100644
--- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
+++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
@@ -41,6 +41,12 @@ Optional properties:
 -lanes-per-direction	: number of lanes available per direction - either 1 or 2.
 			  Note that it is assume same number of lanes is used both
 			  directions at once. If not specified, default is 2 lanes per direction.
+- assigned-clock-rates 	: Specify the device reference clock frequency, must be one of the following:
+			  0: 19.2 MHz
+			  1: 26 MHz
+			  2: 38.4 MHz
+			  3: 52 MHz
+			  Defaults to 26 MHz if not specified.
 
 Note: If above properties are not defined it can be assumed that the supply
 regulators or clocks are always on.
@@ -66,4 +72,5 @@ Example:
 		freq-table-hz = <100000000 200000000>, <0 0>, <0 0>;
 		phys = <&ufsphy1>;
 		phy-names = "ufsphy";
+		assigned-clock-rates = <0>; /* reference clock freq: 19.2 MHz */
 	};
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 14e5bf7..e15deb0 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -378,6 +378,15 @@ enum query_opcode {
 	UPIU_QUERY_OPCODE_TOGGLE_FLAG	= 0x8,
 };
 
+/* bRefClkFreq attribute values */
+enum ref_clk_freq {
+	REF_CLK_FREQ_19_2_MHZ	= 0x0,
+	REF_CLK_FREQ_26_MHZ	= 0x1,
+	REF_CLK_FREQ_38_4_MHZ	= 0x2,
+	REF_CLK_FREQ_52_MHZ	= 0x3,
+	REF_CLK_FREQ_MAX	= REF_CLK_FREQ_52_MHZ,
+};
+
 /* Query response result code */
 enum {
 	QUERY_RESULT_SUCCESS                    = 0x00,
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index e82bde0..0953563 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -343,6 +343,8 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
+	ufshcd_parse_dev_ref_clk_freq(hba);
+
 	ufshcd_init_lanes_per_dir(hba);
 
 	err = ufshcd_init(hba, mmio_base, irq);
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c5b1bf1..455a6ad 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6296,6 +6296,62 @@ static void ufshcd_def_desc_sizes(struct ufs_hba *hba)
 	hba->desc_size.hlth_desc = QUERY_DESC_HEALTH_DEF_SIZE;
 }
 
+void ufshcd_parse_dev_ref_clk_freq(struct ufs_hba *hba)
+{
+	struct device *dev = hba->dev;
+	int ret;
+
+	if (!dev)
+		return;
+
+	ret = device_property_read_u32(dev, "assigned-clock-rates",
+				   &hba->dev_ref_clk_freq);
+	if (ret ||
+	    (hba->dev_ref_clk_freq > REF_CLK_FREQ_52_MHZ)) {
+		dev_err(hba->dev,
+		"%s: invalid ref_clk setting = %d\n",
+		__func__, hba->dev_ref_clk_freq);
+		hba->dev_ref_clk_freq = REF_CLK_FREQ_MAX + 1;
+	}
+}
+
+static int ufshcd_set_dev_ref_clk(struct ufs_hba *hba)
+{
+	int err = 0;
+	int ref_clk = -1;
+	static const char * const ref_clk_freqs[] = {"19.2 MHz", "26 MHz",
+						     "38.4 MHz", "52 MHz"};
+
+	err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			QUERY_ATTR_IDN_REF_CLK_FREQ, 0, 0, &ref_clk);
+
+	if (err) {
+		dev_err(hba->dev, "%s: failed reading bRefClkFreq. err = %d\n",
+			 __func__, err);
+		goto out;
+	}
+
+	if (ref_clk == hba->dev_ref_clk_freq)
+		goto out; /* nothing to update */
+
+	err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+			QUERY_ATTR_IDN_REF_CLK_FREQ, 0, 0,
+			&hba->dev_ref_clk_freq);
+
+	if (err)
+		dev_err(hba->dev, "%s: bRefClkFreq setting to %s failed\n",
+			__func__, ref_clk_freqs[hba->dev_ref_clk_freq]);
+	/*
+	 * It is good to print this out here to debug any later failures
+	 * related to gear switch.
+	 */
+	dev_dbg(hba->dev, "%s: bRefClkFreq setting to %s succeeded\n",
+			__func__, ref_clk_freqs[hba->dev_ref_clk_freq]);
+
+out:
+	return err;
+}
+
 /**
  * ufshcd_probe_hba - probe hba to detect device and initialize
  * @hba: per-adapter instance
@@ -6361,6 +6417,12 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 			"%s: Failed getting max supported power mode\n",
 			__func__);
 	} else {
+		/*
+		 * Set the right value to bRefClkFreq before attempting to
+		 * switch to HS gears.
+		 */
+		if (hba->dev_ref_clk_freq < REF_CLK_FREQ_MAX + 1)
+			ufshcd_set_dev_ref_clk(hba);
 		ret = ufshcd_config_pwr_mode(hba, &hba->max_pwr_info.info);
 		if (ret) {
 			dev_err(hba->dev, "%s: Failed setting power mode, err = %d\n",
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 8110dcd..101a75c 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -548,6 +548,7 @@ struct ufs_hba {
 	void *priv;
 	unsigned int irq;
 	bool is_irq_enabled;
+	u32 dev_ref_clk_freq;
 
 	/* Interrupt aggregation support is broken */
 	#define UFSHCD_QUIRK_BROKEN_INTR_AGGR			0x1
@@ -746,6 +747,7 @@ static inline void ufshcd_rmwl(struct ufs_hba *hba, u32 mask, u32 val, u32 reg)
 int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
 				u32 val, unsigned long interval_us,
 				unsigned long timeout_ms, bool can_sleep);
+void ufshcd_parse_dev_ref_clk_freq(struct ufs_hba *hba);
 
 static inline void check_upiu_size(void)
 {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
