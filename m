From: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RESEND v3 3/5] scsi: ufs: Fix regulator load and icc-level
 configuration
Date: Wed, 27 Mar 2019 17:58:25 +0800
Message-ID: <1553680707-28579-4-git-send-email-stanley.chu@mediatek.com>
References: <1553680707-28579-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1553680707-28579-1-git-send-email-stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
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
Cc: marc.w.gonzalez-GANU6spQydw@public.gmane.org, chun-hung.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Currently if a regulator has "<name>-fixed-regulator"
property in device tree, it will skip current limit initialization.
This lead to a zero "max_uA" value in struct ufs_vreg.

However, "regulator_set_load" operation shall be required
on regulators which have valid current limits, otherwise a zero
"max_uA" set by "regulator_set_load" may cause unexpected behavior
when this regulator is enabled or set as high power mode.

Similarly, in device's icc_level configuration flow, the target
icc_level shall be updated if regulator also has valid current limit,
otherwise a wrong icc_level will be calculated by zero "max_uA" and
thus causes unexpected results after it is written to device.

Signed-off-by: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
---
 drivers/scsi/ufs/ufshcd.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 81d99aebb867..5ba49c8cd2a3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6294,19 +6294,19 @@ static u32 ufshcd_find_max_sup_active_icc_level(struct ufs_hba *hba,
 		goto out;
 	}
 
-	if (hba->vreg_info.vcc)
+	if (hba->vreg_info.vcc && hba->vreg_info.vcc->max_uA)
 		icc_level = ufshcd_get_max_icc_level(
 				hba->vreg_info.vcc->max_uA,
 				POWER_DESC_MAX_ACTV_ICC_LVLS - 1,
 				&desc_buf[PWR_DESC_ACTIVE_LVLS_VCC_0]);
 
-	if (hba->vreg_info.vccq)
+	if (hba->vreg_info.vccq && hba->vreg_info.vccq->max_uA)
 		icc_level = ufshcd_get_max_icc_level(
 				hba->vreg_info.vccq->max_uA,
 				icc_level,
 				&desc_buf[PWR_DESC_ACTIVE_LVLS_VCCQ_0]);
 
-	if (hba->vreg_info.vccq2)
+	if (hba->vreg_info.vccq2 && hba->vreg_info.vccq2->max_uA)
 		icc_level = ufshcd_get_max_icc_level(
 				hba->vreg_info.vccq2->max_uA,
 				icc_level,
@@ -7004,6 +7004,15 @@ static int ufshcd_config_vreg_load(struct device *dev, struct ufs_vreg *vreg,
 	if (!vreg)
 		return 0;
 
+	/*
+	 * "set_load" operation shall be required on those regulators
+	 * which specifically configured current limitation. Otherwise
+	 * zero max_uA may cause unexpected behavior when regulator is
+	 * enabled or set as high power mode.
+	 */
+	if (!vreg->max_uA)
+		return 0;
+
 	ret = regulator_set_load(vreg->reg, ua);
 	if (ret < 0) {
 		dev_err(dev, "%s: %s set load (ua=%d) failed, err=%d\n",
-- 
2.18.0
