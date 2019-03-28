From: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v4 5/5] scsi: ufs: Remove "<name>-fixed-regulator" device tree
 property
Date: Thu, 28 Mar 2019 17:16:27 +0800
Message-ID: <1553764587-26357-6-git-send-email-stanley.chu@mediatek.com>
References: <1553764587-26357-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1553764587-26357-1-git-send-email-stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
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
Cc: marc.w.gonzalez-GANU6spQydw@public.gmane.org, chun-hung.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, evgreen-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, vivek.gautam-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sayalil-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, beanhuo-AL4WhLSQfzjQT0dZR+AlfA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

"<name>-fixed-regulator" device tree property can be
safely removed because below things are fixed or resolved,

1. "<name>-max-microamp" becomes optional property: Undefined
   "<name>-max-microamp" will not cause initialization fail if
   "<name>-fixed-regulator" is not defined.

2. Current switching operation (by regulator_set_load) now has rules:
   Regulators will have undefined current limit if
   "<name>-fixed-regulator" is not defined. But this is safe because
   only regulator which has configured current limit from
   "<name>-max-microamp" property is allowed to change its load.

Although "<name>-fixed-regulator" is not used in any dt-bindings
in tree, this patch is still safe for regulators already defined
"<name>-fixed-regulator". To be more clear, if a regulator defined
"<name>-fixed-regulator" before, the behavior difference after
this patch is,

1. "<name>-max-microamp":
   If a regulator defined "<name>-fixed-regulator", it is not necessary
   to define "<name>-max-microamp" property in device tree and it is
   expected to have an undefined current limit, i.e., "max_uA" field
   is zero in struct ufs_vreg. This is exactly the same as patched.

2. "vcc-supply-1p8" or volatge range settings:
   * For vcc, vccq or vccq2, these three regulators shall not define
     "<name>-fixed-regulator" because defining it will lead to
     undefined voltage range and thus voltage switching will be
     unexpected.
   * For other regulators with undefined voltage range, voltage range
     will be still undefined after patched.

Therefore this patch is safe for all existed regulators with
"<name>-fixed-regulator" property already defined.

Signed-off-by: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Reviewed-by: Avri Altman <avri.altman-Sjgp3cTcYWE@public.gmane.org>
Acked-by: Alim Akhtar <alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 2420e6962219..7b404df965b2 100644
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
