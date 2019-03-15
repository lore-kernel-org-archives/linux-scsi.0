From: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 4/4] scsi: ufs: remove "<name>-fixed-regulator" device tree
 property
Date: Fri, 15 Mar 2019 17:26:14 +0800
Message-ID: <1552641974-30672-6-git-send-email-stanley.chu@mediatek.com>
References: <1552641974-30672-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1552641974-30672-1-git-send-email-stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
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

"<name>-fixed-regulator" device tree property can be
safely removed because below things are fixed or resolved,

- "<name>-max-microamp" becomes optional property: Undefined
  "<name>-max-microamp" will not cause initialization fail.

- regulator_set_load operation now has rules: Only those regulators
  which have configured current limit from "<name>-max-microamp"
  property is allowed to change its load.

The difference of regulators which define "<name>-fixed-regulator"
or not is listed as below,

- "<name>-max-microamp": If an existed regulator which defined
  "<name>-fixed-regulator", it shall be lack of "<name>-max-microamp"
  property in device tree thus regulator_set_load behaviors will be
  the same as before this patch.

- "vcc-supply-1p8": This only impacts "vcc-supply" regulator. However
  vcc shall not define "<name>-fixed-regulator" in device tree
  otherwise ufshcd_config_vreg() will use zero voltage values as
  request to regulator_set_voltage() and may lead to unexpected
  results.

Therefore this patch is safe for all existed regulators with
"<name>-fixed-regulator" property already used.

Signed-off-by: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 2f244d388ca8..a667e7ba1c8b 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -151,11 +151,6 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
 
 	vreg->name = kstrdup(name, GFP_KERNEL);
 
-	/* if fixed regulator no need further initialization */
-	snprintf(prop_name, MAX_PROP_SIZE, "%s-fixed-regulator", name);
-	if (of_property_read_bool(np, prop_name))
-		goto out;
-
 	snprintf(prop_name, MAX_PROP_SIZE, "%s-max-microamp", name);
 	if (of_property_read_u32(np, prop_name, &vreg->max_uA)) {
 		dev_info(dev, "%s: unable to find %s\n", __func__, prop_name);
-- 
2.18.0
