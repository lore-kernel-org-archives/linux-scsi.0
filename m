From: Sayali Lokhande <sayalil@codeaurora.org>
Subject: [PATCH V15 1/2] scsi: ufs: set the device reference clock setting
Date: Tue, 16 Oct 2018 14:29:41 +0530
Message-ID: <1539680382-31136-2-git-send-email-sayalil@codeaurora.org>
References: <1539680382-31136-1-git-send-email-sayalil@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1539680382-31136-1-git-send-email-sayalil@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, evgreen@chromium.org, riteshh@codeaurora.org
Cc: stummala@codeaurora.org, adrian.hunter@intel.com, jlbec@evilplan.org, linux-scsi@vger.kernel.org, Sayali Lokhande <sayalil@codeaurora.org>, Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Mathieu Malaterre <malat@debian.org>, "open list:OPEN FIRMWARE AND FLATTENED
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
Reviewed-by: Evan Green <evgreen@chromium.org>
---
 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  6 ++
 drivers/scsi/ufs/ufs.h                             | 14 ++++
 drivers/scsi/ufs/ufshcd.c                          | 83 ++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.h                          |  2 +
 4 files changed, 105 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
index c39dfef..88a1d24 100644
--- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
+++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
@@ -33,6 +33,12 @@ Optional properties:
 - clocks                : List of phandle and clock specifier pairs
 - clock-names           : List of clock input name strings sorted in the same
                           order as the clocks property.
+			  "ref_clk" indicates reference clock frequency.
+			  UFS host supplies reference clock to UFS device and UFS device
+			  specification allows host to provide one of the 4 frequencies (19.2 MHz,
+			  26 MHz, 38.4 MHz, 52MHz) for reference clock. This "ref_clk" entry is
+			  parsed and used to update the reference clock setting in device.
+			  Defaults to 26 MHz(as per specification) if not specified by host.
 - freq-table-hz		: Array of <min max> operating frequencies stored in the same
                           order as the clocks property. If this property is not
 			  defined or a value in the array is "0" then it is assumed
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 14e5bf7..b3aaea8 100644
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
+	unsigned long freq_hz;
+	enum ufs_ref_clk_freq val;
+};
+
 /* Query response result code */
 enum {
 	QUERY_RESULT_SUCCESS                    = 0x00,
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c5b1bf1..9be9fa1 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6296,6 +6296,74 @@ static void ufshcd_def_desc_sizes(struct ufs_hba *hba)
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
+static enum ufs_ref_clk_freq
+ufs_get_bref_clk_from_hz(unsigned long freq)
+{
+	int i;
+
+	for (i = 0; ufs_ref_clk_freqs[i].freq_hz; i++)
+		if (ufs_ref_clk_freqs[i].freq_hz == freq)
+			return ufs_ref_clk_freqs[i].val;
+
+	return REF_CLK_FREQ_INVAL;
+}
+
+void ufshcd_parse_dev_ref_clk_freq(struct ufs_hba *hba, struct clk *refclk)
+{
+	unsigned long freq;
+
+	freq = clk_get_rate(refclk);
+
+	hba->dev_ref_clk_freq =
+		ufs_get_bref_clk_from_hz(freq);
+
+	if (hba->dev_ref_clk_freq == REF_CLK_FREQ_INVAL)
+		dev_err(hba->dev,
+		"invalid ref_clk setting = %ld\n", freq);
+}
+
+static int ufshcd_set_dev_ref_clk(struct ufs_hba *hba)
+{
+	int err;
+	u32 ref_clk;
+	u32 freq = hba->dev_ref_clk_freq;
+
+	err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			QUERY_ATTR_IDN_REF_CLK_FREQ, 0, 0, &ref_clk);
+
+	if (err) {
+		dev_err(hba->dev, "failed reading bRefClkFreq. err = %d\n",
+			err);
+		goto out;
+	}
+
+	if (ref_clk == freq)
+		goto out; /* nothing to update */
+
+	err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+			QUERY_ATTR_IDN_REF_CLK_FREQ, 0, 0, &freq);
+
+	if (err) {
+		dev_err(hba->dev, "bRefClkFreq setting to %lu Hz failed\n",
+			ufs_ref_clk_freqs[freq].freq_hz);
+		goto out;
+	}
+
+	dev_dbg(hba->dev, "bRefClkFreq setting to %lu Hz succeeded\n",
+			ufs_ref_clk_freqs[freq].freq_hz);
+
+out:
+	return err;
+}
+
 /**
  * ufshcd_probe_hba - probe hba to detect device and initialize
  * @hba: per-adapter instance
@@ -6361,6 +6429,12 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
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
@@ -6837,6 +6911,14 @@ static int ufshcd_init_clocks(struct ufs_hba *hba)
 			goto out;
 		}
 
+		/*
+		 * Parse device ref clk freq as per device tree "ref_clk".
+		 * Default dev_ref_clk_freq is set to REF_CLK_FREQ_INVAL
+		 * in ufshcd_alloc_host().
+		 */
+		if (!strcmp(clki->name, "ref_clk"))
+			ufshcd_parse_dev_ref_clk_freq(hba, clki->clk);
+
 		if (clki->max_freq) {
 			ret = clk_set_rate(clki->clk, clki->max_freq);
 			if (ret) {
@@ -7690,6 +7772,7 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 	hba->host = host;
 	hba->dev = dev;
 	*hba_handle = hba;
+	hba->dev_ref_clk_freq = REF_CLK_FREQ_INVAL;
 
 	INIT_LIST_HEAD(&hba->clk_list_head);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 8110dcd..4b5584b 100644
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
+void ufshcd_parse_dev_ref_clk_freq(struct ufs_hba *hba, struct clk *refclk);
 
 static inline void check_upiu_size(void)
 {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
