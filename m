From: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v6 2/7] scsi: ufs-qcom: Re-factor ufshcd_get_pwr_dev_param
Date: Sat, 16 Mar 2019 13:04:42 +0800
Message-ID: <1552712687-20186-4-git-send-email-stanley.chu@mediatek.com>
References: <1552712687-20186-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1552712687-20186-1-git-send-email-stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, chunfeng.yun-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, yingjoe.chen-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, kishon-l0cyMroinI0@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, avri.altman-Sjgp3cTcYWE@public.gmane.org, alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, pedrom.sousa-HKixBCOQz3hWk0Htik3J/w@public.gmane.org
Cc: chun-hung.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, vivek.gautam-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

ufshcd_get_pwr_dev_param function and ufs_dev_params struct
are re-factored to ufs common driver thus change the way this
driver used.

Signed-off-by: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Reviewed-by: Avri Altman <avri.altman-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 106 ++----------------------------------
 1 file changed, 4 insertions(+), 102 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 3aeadb14aae1..a6b6f6eb9061 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -595,104 +595,6 @@ static int ufs_qcom_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	return err;
 }
 
-struct ufs_qcom_dev_params {
-	u32 pwm_rx_gear;	/* pwm rx gear to work in */
-	u32 pwm_tx_gear;	/* pwm tx gear to work in */
-	u32 hs_rx_gear;		/* hs rx gear to work in */
-	u32 hs_tx_gear;		/* hs tx gear to work in */
-	u32 rx_lanes;		/* number of rx lanes */
-	u32 tx_lanes;		/* number of tx lanes */
-	u32 rx_pwr_pwm;		/* rx pwm working pwr */
-	u32 tx_pwr_pwm;		/* tx pwm working pwr */
-	u32 rx_pwr_hs;		/* rx hs working pwr */
-	u32 tx_pwr_hs;		/* tx hs working pwr */
-	u32 hs_rate;		/* rate A/B to work in HS */
-	u32 desired_working_mode;
-};
-
-static int ufs_qcom_get_pwr_dev_param(struct ufs_qcom_dev_params *qcom_param,
-				      struct ufs_pa_layer_attr *dev_max,
-				      struct ufs_pa_layer_attr *agreed_pwr)
-{
-	int min_qcom_gear;
-	int min_dev_gear;
-	bool is_dev_sup_hs = false;
-	bool is_qcom_max_hs = false;
-
-	if (dev_max->pwr_rx == FAST_MODE)
-		is_dev_sup_hs = true;
-
-	if (qcom_param->desired_working_mode == FAST) {
-		is_qcom_max_hs = true;
-		min_qcom_gear = min_t(u32, qcom_param->hs_rx_gear,
-				      qcom_param->hs_tx_gear);
-	} else {
-		min_qcom_gear = min_t(u32, qcom_param->pwm_rx_gear,
-				      qcom_param->pwm_tx_gear);
-	}
-
-	/*
-	 * device doesn't support HS but qcom_param->desired_working_mode is
-	 * HS, thus device and qcom_param don't agree
-	 */
-	if (!is_dev_sup_hs && is_qcom_max_hs) {
-		pr_err("%s: failed to agree on power mode (device doesn't support HS but requested power is HS)\n",
-			__func__);
-		return -ENOTSUPP;
-	} else if (is_dev_sup_hs && is_qcom_max_hs) {
-		/*
-		 * since device supports HS, it supports FAST_MODE.
-		 * since qcom_param->desired_working_mode is also HS
-		 * then final decision (FAST/FASTAUTO) is done according
-		 * to qcom_params as it is the restricting factor
-		 */
-		agreed_pwr->pwr_rx = agreed_pwr->pwr_tx =
-						qcom_param->rx_pwr_hs;
-	} else {
-		/*
-		 * here qcom_param->desired_working_mode is PWM.
-		 * it doesn't matter whether device supports HS or PWM,
-		 * in both cases qcom_param->desired_working_mode will
-		 * determine the mode
-		 */
-		 agreed_pwr->pwr_rx = agreed_pwr->pwr_tx =
-						qcom_param->rx_pwr_pwm;
-	}
-
-	/*
-	 * we would like tx to work in the minimum number of lanes
-	 * between device capability and vendor preferences.
-	 * the same decision will be made for rx
-	 */
-	agreed_pwr->lane_tx = min_t(u32, dev_max->lane_tx,
-						qcom_param->tx_lanes);
-	agreed_pwr->lane_rx = min_t(u32, dev_max->lane_rx,
-						qcom_param->rx_lanes);
-
-	/* device maximum gear is the minimum between device rx and tx gears */
-	min_dev_gear = min_t(u32, dev_max->gear_rx, dev_max->gear_tx);
-
-	/*
-	 * if both device capabilities and vendor pre-defined preferences are
-	 * both HS or both PWM then set the minimum gear to be the chosen
-	 * working gear.
-	 * if one is PWM and one is HS then the one that is PWM get to decide
-	 * what is the gear, as it is the one that also decided previously what
-	 * pwr the device will be configured to.
-	 */
-	if ((is_dev_sup_hs && is_qcom_max_hs) ||
-	    (!is_dev_sup_hs && !is_qcom_max_hs))
-		agreed_pwr->gear_rx = agreed_pwr->gear_tx =
-			min_t(u32, min_dev_gear, min_qcom_gear);
-	else if (!is_dev_sup_hs)
-		agreed_pwr->gear_rx = agreed_pwr->gear_tx = min_dev_gear;
-	else
-		agreed_pwr->gear_rx = agreed_pwr->gear_tx = min_qcom_gear;
-
-	agreed_pwr->hs_rate = qcom_param->hs_rate;
-	return 0;
-}
-
 #ifdef CONFIG_MSM_BUS_SCALING
 static int ufs_qcom_get_bus_vote(struct ufs_qcom_host *host,
 		const char *speed_mode)
@@ -920,7 +822,7 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
 {
 	u32 val;
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
-	struct ufs_qcom_dev_params ufs_qcom_cap;
+	struct ufs_dev_params ufs_qcom_cap;
 	int ret = 0;
 
 	if (!dev_req_params) {
@@ -959,9 +861,9 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
 				ufs_qcom_cap.hs_rx_gear = UFS_HS_G2;
 		}
 
-		ret = ufs_qcom_get_pwr_dev_param(&ufs_qcom_cap,
-						 dev_max_params,
-						 dev_req_params);
+		ret = ufshcd_get_pwr_dev_param(&ufs_qcom_cap,
+					       dev_max_params,
+					       dev_req_params);
 		if (ret) {
 			pr_err("%s: failed to determine capabilities\n",
 					__func__);
-- 
2.18.0
