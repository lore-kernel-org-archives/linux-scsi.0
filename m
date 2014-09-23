From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH V4 12/17] scsi: ufs: refactor configuring power mode
Date: Tue, 23 Sep 2014 10:31:34 +0300
Message-ID: <1411457499-8074-13-git-send-email-draviv@codeaurora.org>
References: <1411457499-8074-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1411457499-8074-1-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Dolev Raviv <draviv@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Sometimes, the device shall report its maximum power and speed
capabilities, but we might not wish to configure it to use those
maximum capabilities.
This change adds support for the vendor specific host driver to
implement power change notify callback.

To enable configuring different power modes (number of lanes,
gear number and fast/slow modes) it is necessary to split the
configuration stage from the stage that reads the device max power mode.
In addition, it is not required to read the configuration more than
once, thus the configuration is stored after reading it once.

Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a621827..e820262 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -179,6 +179,8 @@ static void ufshcd_hba_exit(struct ufs_hba *hba);
 static int ufshcd_probe_hba(struct ufs_hba *hba);
 static int ufshcd_host_reset_and_restore(struct ufs_hba *hba);
 static irqreturn_t ufshcd_intr(int irq, void *__hba);
+static int ufshcd_config_pwr_mode(struct ufs_hba *hba,
+		struct ufs_pa_layer_attr *desired_pwr_mode);
 
 static inline int ufshcd_enable_irq(struct ufs_hba *hba)
 {
@@ -1959,40 +1961,83 @@ static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 }
 
 /**
- * ufshcd_config_max_pwr_mode - Set & Change power mode with
- *	maximum capability attribute information.
- * @hba: per adapter instance
- *
- * Returns 0 on success, non-zero value on failure
+ * ufshcd_get_max_pwr_mode - reads the max power mode negotiated with device
+ * @hba: per-adapter instance
  */
-static int ufshcd_config_max_pwr_mode(struct ufs_hba *hba)
+static int ufshcd_get_max_pwr_mode(struct ufs_hba *hba)
 {
-	enum {RX = 0, TX = 1};
-	u32 lanes[] = {1, 1};
-	u32 gear[] = {1, 1};
-	u8 pwr[] = {FASTAUTO_MODE, FASTAUTO_MODE};
-	int ret;
+	struct ufs_pa_layer_attr *pwr_info = &hba->max_pwr_info.info;
+
+	if (hba->max_pwr_info.is_valid)
+		return 0;
+
+	pwr_info->pwr_tx = FASTAUTO_MODE;
+	pwr_info->pwr_rx = FASTAUTO_MODE;
+	pwr_info->hs_rate = PA_HS_MODE_B;
 
 	/* Get the connected lane count */
-	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDRXDATALANES), &lanes[RX]);
-	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES), &lanes[TX]);
+	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDRXDATALANES),
+			&pwr_info->lane_rx);
+	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
+			&pwr_info->lane_tx);
+
+	if (!pwr_info->lane_rx || !pwr_info->lane_tx) {
+		dev_err(hba->dev, "%s: invalid connected lanes value. rx=%d, tx=%d\n",
+				__func__,
+				pwr_info->lane_rx,
+				pwr_info->lane_tx);
+		return -EINVAL;
+	}
 
 	/*
 	 * First, get the maximum gears of HS speed.
 	 * If a zero value, it means there is no HSGEAR capability.
 	 * Then, get the maximum gears of PWM speed.
 	 */
-	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_MAXRXHSGEAR), &gear[RX]);
-	if (!gear[RX]) {
-		ufshcd_dme_get(hba, UIC_ARG_MIB(PA_MAXRXPWMGEAR), &gear[RX]);
-		pwr[RX] = SLOWAUTO_MODE;
+	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_MAXRXHSGEAR), &pwr_info->gear_rx);
+	if (!pwr_info->gear_rx) {
+		ufshcd_dme_get(hba, UIC_ARG_MIB(PA_MAXRXPWMGEAR),
+				&pwr_info->gear_rx);
+		if (!pwr_info->gear_rx) {
+			dev_err(hba->dev, "%s: invalid max pwm rx gear read = %d\n",
+				__func__, pwr_info->gear_rx);
+			return -EINVAL;
+		}
+		pwr_info->pwr_rx = SLOWAUTO_MODE;
 	}
 
-	ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_MAXRXHSGEAR), &gear[TX]);
-	if (!gear[TX]) {
+	ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_MAXRXHSGEAR),
+			&pwr_info->gear_tx);
+	if (!pwr_info->gear_tx) {
 		ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_MAXRXPWMGEAR),
-				    &gear[TX]);
-		pwr[TX] = SLOWAUTO_MODE;
+				&pwr_info->gear_tx);
+		if (!pwr_info->gear_tx) {
+			dev_err(hba->dev, "%s: invalid max pwm tx gear read = %d\n",
+				__func__, pwr_info->gear_tx);
+			return -EINVAL;
+		}
+		pwr_info->pwr_tx = SLOWAUTO_MODE;
+	}
+
+	hba->max_pwr_info.is_valid = true;
+	return 0;
+}
+
+int ufshcd_change_power_mode(struct ufs_hba *hba,
+			     struct ufs_pa_layer_attr *pwr_mode)
+{
+	int ret;
+
+	/* if already configured to the requested pwr_mode */
+	if (pwr_mode->gear_rx == hba->pwr_info.gear_rx &&
+	    pwr_mode->gear_tx == hba->pwr_info.gear_tx &&
+	    pwr_mode->lane_rx == hba->pwr_info.lane_rx &&
+	    pwr_mode->lane_tx == hba->pwr_info.lane_tx &&
+	    pwr_mode->pwr_rx == hba->pwr_info.pwr_rx &&
+	    pwr_mode->pwr_tx == hba->pwr_info.pwr_tx &&
+	    pwr_mode->hs_rate == hba->pwr_info.hs_rate) {
+		dev_dbg(hba->dev, "%s: power already configured\n", __func__);
+		return 0;
 	}
 
 	/*
@@ -2001,23 +2046,67 @@ static int ufshcd_config_max_pwr_mode(struct ufs_hba *hba)
 	 * - PA_TXGEAR, PA_ACTIVETXDATALANES, PA_TXTERMINATION,
 	 * - PA_HSSERIES
 	 */
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXGEAR), gear[RX]);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_ACTIVERXDATALANES), lanes[RX]);
-	if (pwr[RX] == FASTAUTO_MODE)
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXGEAR), pwr_mode->gear_rx);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_ACTIVERXDATALANES),
+			pwr_mode->lane_rx);
+	if (pwr_mode->pwr_rx == FASTAUTO_MODE ||
+			pwr_mode->pwr_rx == FAST_MODE)
 		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXTERMINATION), TRUE);
+	else
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXTERMINATION), FALSE);
 
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXGEAR), gear[TX]);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_ACTIVETXDATALANES), lanes[TX]);
-	if (pwr[TX] == FASTAUTO_MODE)
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXGEAR), pwr_mode->gear_tx);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_ACTIVETXDATALANES),
+			pwr_mode->lane_tx);
+	if (pwr_mode->pwr_tx == FASTAUTO_MODE ||
+			pwr_mode->pwr_tx == FAST_MODE)
 		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXTERMINATION), TRUE);
+	else
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXTERMINATION), FALSE);
 
-	if (pwr[RX] == FASTAUTO_MODE || pwr[TX] == FASTAUTO_MODE)
-		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_HSSERIES), PA_HS_MODE_B);
+	if (pwr_mode->pwr_rx == FASTAUTO_MODE ||
+	    pwr_mode->pwr_tx == FASTAUTO_MODE ||
+	    pwr_mode->pwr_rx == FAST_MODE ||
+	    pwr_mode->pwr_tx == FAST_MODE)
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_HSSERIES),
+						pwr_mode->hs_rate);
 
-	ret = ufshcd_uic_change_pwr_mode(hba, pwr[RX] << 4 | pwr[TX]);
-	if (ret)
+	ret = ufshcd_uic_change_pwr_mode(hba, pwr_mode->pwr_rx << 4
+			| pwr_mode->pwr_tx);
+
+	if (ret) {
 		dev_err(hba->dev,
-			"pwr_mode: power mode change failed %d\n", ret);
+			"%s: power mode change failed %d\n", __func__, ret);
+	} else {
+		if (hba->vops && hba->vops->pwr_change_notify)
+			hba->vops->pwr_change_notify(hba,
+				POST_CHANGE, NULL, pwr_mode);
+
+		memcpy(&hba->pwr_info, pwr_mode,
+			sizeof(struct ufs_pa_layer_attr));
+	}
+
+	return ret;
+}
+
+/**
+ * ufshcd_config_pwr_mode - configure a new power mode
+ * @hba: per-adapter instance
+ * @desired_pwr_mode: desired power configuration
+ */
+static int ufshcd_config_pwr_mode(struct ufs_hba *hba,
+		struct ufs_pa_layer_attr *desired_pwr_mode)
+{
+	struct ufs_pa_layer_attr final_params = { 0 };
+	int ret;
+
+	if (hba->vops && hba->vops->pwr_change_notify)
+		hba->vops->pwr_change_notify(hba,
+		     PRE_CHANGE, desired_pwr_mode, &final_params);
+	else
+		memcpy(&final_params, desired_pwr_mode, sizeof(final_params));
+
+	ret = ufshcd_change_power_mode(hba, &final_params);
 
 	return ret;
 }
@@ -3684,7 +3773,16 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 	hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
 	hba->wlun_dev_clr_ua = true;
 
-	ufshcd_config_max_pwr_mode(hba);
+	if (ufshcd_get_max_pwr_mode(hba)) {
+		dev_err(hba->dev,
+			"%s: Failed getting max supported power mode\n",
+			__func__);
+	} else {
+		ret = ufshcd_config_pwr_mode(hba, &hba->max_pwr_info.info);
+		if (ret)
+			dev_err(hba->dev, "%s: Failed setting power mode, err = %d\n",
+					__func__, ret);
+	}
 
 	/*
 	 * If we are in error handling context or in power management callbacks
@@ -4851,6 +4949,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	host->unique_id = host->host_no;
 	host->max_cmd_len = MAX_CDB_SIZE;
 
+	hba->max_pwr_info.is_valid = false;
+
 	/* Initailize wait queue for task management */
 	init_waitqueue_head(&hba->tm_wq);
 	init_waitqueue_head(&hba->tm_tag_wq);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 1ee429d..caebdcb 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -221,6 +221,22 @@ struct ufs_clk_info {
 
 #define PRE_CHANGE      0
 #define POST_CHANGE     1
+
+struct ufs_pa_layer_attr {
+	u32 gear_rx;
+	u32 gear_tx;
+	u32 lane_rx;
+	u32 lane_tx;
+	u32 pwr_rx;
+	u32 pwr_tx;
+	u32 hs_rate;
+};
+
+struct ufs_pwr_mode_info {
+	bool is_valid;
+	struct ufs_pa_layer_attr info;
+};
+
 /**
  * struct ufs_hba_variant_ops - variant specific callbacks
  * @name: variant name
@@ -232,6 +248,9 @@ struct ufs_clk_info {
  *                     variant specific Uni-Pro initialization.
  * @link_startup_notify: called before and after Link startup is carried out
  *                       to allow variant specific Uni-Pro initialization.
+ * @pwr_change_notify: called before and after a power mode change
+ *			is carried out to allow vendor spesific capabilities
+ *			to be set.
  * @suspend: called during host controller PM callback
  * @resume: called during host controller PM callback
  */
@@ -243,6 +262,9 @@ struct ufs_hba_variant_ops {
 	int     (*setup_regulators)(struct ufs_hba *, bool);
 	int     (*hce_enable_notify)(struct ufs_hba *, bool);
 	int     (*link_startup_notify)(struct ufs_hba *, bool);
+	int	(*pwr_change_notify)(struct ufs_hba *,
+					bool, struct ufs_pa_layer_attr *,
+					struct ufs_pa_layer_attr *);
 	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
 	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
 };
@@ -302,6 +324,8 @@ struct ufs_init_prefetch {
  * @auto_bkops_enabled: to track whether bkops is enabled in device
  * @vreg_info: UFS device voltage regulator information
  * @clk_list_head: UFS host controller clocks list node head
+ * @pwr_info: holds current power mode
+ * @max_pwr_info: keeps the device max valid pwm
  */
 struct ufs_hba {
 	void __iomem *mmio_base;
@@ -384,6 +408,9 @@ struct ufs_hba {
 	struct list_head clk_list_head;
 
 	bool wlun_dev_clr_ua;
+
+	struct ufs_pa_layer_attr pwr_info;
+	struct ufs_pwr_mode_info max_pwr_info;
 };
 
 #define ufshcd_writel(hba, val, reg)	\
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
