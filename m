From: Sayali Lokhande <sayalil@codeaurora.org>
Subject: [PATCH V11 1/2] scsi: ufs: set the device reference clock setting
Date: Wed, 29 Aug 2018 10:05:37 +0530
Message-ID: <1535517338-26077-2-git-send-email-sayalil@codeaurora.org>
References: <1535517338-26077-1-git-send-email-sayalil@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1535517338-26077-1-git-send-email-sayalil@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, evgreen@chromium.org, riteshh@codeaurora.org
Cc: stummala@codeaurora.org, adrian.hunter@intel.com, linux-scsi@vger.kernel.org, Sayali Lokhande <sayalil@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
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
 drivers/scsi/ufs/ufs.h           | 14 +++++++
 drivers/scsi/ufs/ufshcd-pltfrm.c |  2 +
 drivers/scsi/ufs/ufshcd.c        | 90 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.h        |  2 +
 4 files changed, 108 insertions(+)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 14e5bf7..a2e76b1 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -378,6 +378,20 @@ enum query_opcode {
 	UPIU_QUERY_OPCODE_TOGGLE_FLAG	= 0x8,
 };
 
+/* bRefClkFreq attribute values */
+enum ufs_ref_clk_freq {
+	REF_CLK_FREQ_19_2_MHZ	= 0,
+	REF_CLK_FREQ_26_MHZ	= 1,
+	REF_CLK_FREQ_38_4_MHZ	= 2,
+	REF_CLK_FREQ_52_MHZ	= 3,
+	REF_CLK_FREQ_INVAL	= -1,
+};
+
+struct ufs_ref_clk {
+	u32 freq_hz;
+	enum ufs_ref_clk_freq val;
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
index c5b1bf1..e01cdc0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6296,6 +6296,89 @@ static void ufshcd_def_desc_sizes(struct ufs_hba *hba)
 	hba->desc_size.hlth_desc = QUERY_DESC_HEALTH_DEF_SIZE;
 }
 
+static struct ufs_ref_clk ufs_ref_clk_freqs[] = {
+	{19200000, REF_CLK_FREQ_19_2_MHZ},
+	{26000000, REF_CLK_FREQ_26_MHZ},
+	{38400000, REF_CLK_FREQ_38_4_MHZ},
+	{52000000, REF_CLK_FREQ_52_MHZ},
+	{0, REF_CLK_FREQ_INVAL},
+};
+
+static inline enum ufs_ref_clk_freq
+ufs_get_bref_clk_from_hz(u32 freq)
+{
+	int i = 0;
+
+	while (ufs_ref_clk_freqs[i].freq_hz != freq) {
+		if (!ufs_ref_clk_freqs[i].freq_hz)
+			return REF_CLK_FREQ_INVAL;
+		i++;
+	}
+
+	return ufs_ref_clk_freqs[i].val;
+}
+
+void ufshcd_parse_dev_ref_clk_freq(struct ufs_hba *hba)
+{
+	struct device *dev = hba->dev;
+	struct device_node *np = dev->of_node;
+	struct clk *refclk = NULL;
+	u32 freq = 0;
+
+	if (!np)
+		return;
+
+	refclk = of_clk_get_by_name(np, "ref_clk");
+	if (!refclk)
+		return;
+
+	freq = clk_get_rate(refclk);
+
+	hba->dev_ref_clk_freq =
+		ufs_get_bref_clk_from_hz(freq);
+
+	if (hba->dev_ref_clk_freq == REF_CLK_FREQ_INVAL)
+		dev_err(hba->dev,
+		"%s: invalid ref_clk setting = %d\n",
+		__func__, freq);
+}
+
+static int ufshcd_set_dev_ref_clk(struct ufs_hba *hba)
+{
+	int err, ref_clk = -1;
+	u32 freq = hba->dev_ref_clk_freq;
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
+			QUERY_ATTR_IDN_REF_CLK_FREQ, 0, 0, &freq);
+
+	if (err) {
+		dev_err(hba->dev, "%s: bRefClkFreq setting to %u Hz failed\n",
+		__func__, ufs_ref_clk_freqs[freq].freq_hz);
+		goto out;
+	}
+	/*
+	 * It is good to print this out here to debug any later failures
+	 * related to gear switch.
+	 */
+	dev_dbg(hba->dev, "%s: bRefClkFreq setting to %u Hz succeeded\n",
+		__func__, ufs_ref_clk_freqs[freq].freq_hz);
+
+out:
+	return err;
+}
+
 /**
  * ufshcd_probe_hba - probe hba to detect device and initialize
  * @hba: per-adapter instance
@@ -6361,6 +6444,12 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 			"%s: Failed getting max supported power mode\n",
 			__func__);
 	} else {
+		/*
+		 * Set the right value to bRefClkFreq before attempting to
+		 * switch to HS gears.
+		 */
+		if (hba->dev_ref_clk_freq != REF_CLK_FREQ_INVAL)
+			ufshcd_set_dev_ref_clk(hba);
 		ret = ufshcd_config_pwr_mode(hba, &hba->max_pwr_info.info);
 		if (ret) {
 			dev_err(hba->dev, "%s: Failed setting power mode, err = %d\n",
@@ -7690,6 +7779,7 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 	hba->host = host;
 	hba->dev = dev;
 	*hba_handle = hba;
+	hba->dev_ref_clk_freq = REF_CLK_FREQ_INVAL;
 
 	INIT_LIST_HEAD(&hba->clk_list_head);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 8110dcd..45013b6 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -548,6 +548,7 @@ struct ufs_hba {
 	void *priv;
 	unsigned int irq;
 	bool is_irq_enabled;
+	enum ufs_ref_clk_freq dev_ref_clk_freq;
 
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
