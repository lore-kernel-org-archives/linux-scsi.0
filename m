From: <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 1/3] scsi: ufs: Introduce ufshcd_get_pwr_dev_param
Date: Mon, 25 Feb 2019 12:10:23 +0800
Message-ID: <1551067825-22654-3-git-send-email-stanley.chu@mediatek.com>
References: <1551067825-22654-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1551067825-22654-1-git-send-email-stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, avri.altman-Sjgp3cTcYWE@public.gmane.org, alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, pedrom.sousa-HKixBCOQz3hWk0Htik3J/w@public.gmane.org
Cc: chun-hung.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, vivek.gautam-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

From: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>

ufshcd_get_pwr_dev_param is for vendors to decide finally
agreed attributes for power mode change if vendors define
their host capability in struct ufs_dev_params.

This api is using by both ufs-qcom and ufs-hisi now and
will also be used in ufs-mediatek. Simply re-factor it
and then evevry vendors can reuse it.

Signed-off-by: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 98 ++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd-pltfrm.h | 21 +++++++
 2 files changed, 119 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 895a9b5ac989..508c561c9a62 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -39,6 +39,7 @@
 
 #include "ufshcd.h"
 #include "ufshcd-pltfrm.h"
+#include "unipro.h"
 
 #define UFSHCD_DEFAULT_LANES_PER_DIRECTION		2
 
@@ -289,6 +290,103 @@ static void ufshcd_init_lanes_per_dir(struct ufs_hba *hba)
 	}
 }
 
+/**
+ * ufshcd_get_pwr_dev_param - get finally agreed attributes for
+ *                            power mode change
+ * @pltfrm_param: pointer to platform parameters
+ * @dev_max: pointer to device attributes
+ * @agreed_pwr: returned agreed attributes
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+int ufshcd_get_pwr_dev_param(struct ufs_dev_params *pltfrm_param,
+			     struct ufs_pa_layer_attr *dev_max,
+			     struct ufs_pa_layer_attr *agreed_pwr)
+{
+	int min_pltfrm_gear;
+	int min_dev_gear;
+	bool is_dev_sup_hs = false;
+	bool is_pltfrm_max_hs = false;
+
+	if (dev_max->pwr_rx == FAST_MODE)
+		is_dev_sup_hs = true;
+
+	if (pltfrm_param->desired_working_mode == UFS_HS_MODE) {
+		is_pltfrm_max_hs = true;
+		min_pltfrm_gear = min_t(u32, pltfrm_param->hs_rx_gear,
+					pltfrm_param->hs_tx_gear);
+	} else {
+		min_pltfrm_gear = min_t(u32, pltfrm_param->pwm_rx_gear,
+					pltfrm_param->pwm_tx_gear);
+	}
+
+	/*
+	 * device doesn't support HS but
+	 * pltfrm_param->desired_working_mode is HS,
+	 * thus device and pltfrm_param don't agree
+	 */
+	if (!is_dev_sup_hs && is_pltfrm_max_hs) {
+		pr_info("%s: device doesn't support HS\n",
+			__func__);
+		return -ENOTSUPP;
+	} else if (is_dev_sup_hs && is_pltfrm_max_hs) {
+		/*
+		 * since device supports HS, it supports FAST_MODE.
+		 * since pltfrm_param->desired_working_mode is also HS
+		 * then final decision (FAST/FASTAUTO) is done according
+		 * to pltfrm_params as it is the restricting factor
+		 */
+		agreed_pwr->pwr_rx = pltfrm_param->rx_pwr_hs;
+		agreed_pwr->pwr_tx = agreed_pwr->pwr_rx;
+	} else {
+		/*
+		 * here pltfrm_param->desired_working_mode is PWM.
+		 * it doesn't matter whether device supports HS or PWM,
+		 * in both cases pltfrm_param->desired_working_mode will
+		 * determine the mode
+		 */
+		agreed_pwr->pwr_rx = pltfrm_param->rx_pwr_pwm;
+		agreed_pwr->pwr_tx = agreed_pwr->pwr_rx;
+	}
+
+	/*
+	 * we would like tx to work in the minimum number of lanes
+	 * between device capability and vendor preferences.
+	 * the same decision will be made for rx
+	 */
+	agreed_pwr->lane_tx = min_t(u32, dev_max->lane_tx,
+				    pltfrm_param->tx_lanes);
+	agreed_pwr->lane_rx = min_t(u32, dev_max->lane_rx,
+				    pltfrm_param->rx_lanes);
+
+	/* device maximum gear is the minimum between device rx and tx gears */
+	min_dev_gear = min_t(u32, dev_max->gear_rx, dev_max->gear_tx);
+
+	/*
+	 * if both device capabilities and vendor pre-defined preferences are
+	 * both HS or both PWM then set the minimum gear to be the chosen
+	 * working gear.
+	 * if one is PWM and one is HS then the one that is PWM get to decide
+	 * what is the gear, as it is the one that also decided previously what
+	 * pwr the device will be configured to.
+	 */
+	if ((is_dev_sup_hs && is_pltfrm_max_hs) ||
+	    (!is_dev_sup_hs && !is_pltfrm_max_hs)) {
+		agreed_pwr->gear_rx =
+			min_t(u32, min_dev_gear, min_pltfrm_gear);
+	} else if (!is_dev_sup_hs) {
+		agreed_pwr->gear_rx = min_dev_gear;
+	} else {
+		agreed_pwr->gear_rx = min_pltfrm_gear;
+	}
+	agreed_pwr->gear_tx = agreed_pwr->gear_rx;
+
+	agreed_pwr->hs_rate = pltfrm_param->hs_rate;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ufshcd_get_pwr_dev_param);
+
 /**
  * ufshcd_pltfrm_init - probe routine of the driver
  * @pdev: pointer to Platform device handle
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.h b/drivers/scsi/ufs/ufshcd-pltfrm.h
index df64c4180340..af85fb37e433 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.h
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.h
@@ -16,6 +16,27 @@
 
 #include "ufshcd.h"
 
+#define UFS_PWR_MODE 1
+#define UFS_HS_MODE 2
+
+struct ufs_dev_params {
+	u32 pwm_rx_gear;        /* pwm rx gear to work in */
+	u32 pwm_tx_gear;        /* pwm tx gear to work in */
+	u32 hs_rx_gear;         /* hs rx gear to work in */
+	u32 hs_tx_gear;         /* hs tx gear to work in */
+	u32 rx_lanes;           /* number of rx lanes */
+	u32 tx_lanes;           /* number of tx lanes */
+	u32 rx_pwr_pwm;         /* rx pwm working pwr */
+	u32 tx_pwr_pwm;         /* tx pwm working pwr */
+	u32 rx_pwr_hs;          /* rx hs working pwr */
+	u32 tx_pwr_hs;          /* tx hs working pwr */
+	u32 hs_rate;            /* rate A/B to work in HS */
+	u32 desired_working_mode;
+};
+
+int ufshcd_get_pwr_dev_param(struct ufs_dev_params *dev_param,
+			     struct ufs_pa_layer_attr *dev_max,
+			     struct ufs_pa_layer_attr *agreed_pwr);
 int ufshcd_pltfrm_init(struct platform_device *pdev,
 		       struct ufs_hba_variant_ops *vops);
 void ufshcd_pltfrm_shutdown(struct platform_device *pdev);
-- 
2.18.0
