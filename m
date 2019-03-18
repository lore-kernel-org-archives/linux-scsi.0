From: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3 4/5] scsi: ufs: Change "<name>-max-microamp" to
 non-mandatory property
Date: Mon, 18 Mar 2019 10:14:39 +0800
Message-ID: <1552875280-16196-6-git-send-email-stanley.chu@mediatek.com>
References: <1552875280-16196-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1552875280-16196-1-git-send-email-stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
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

In dt-bindings for ufs, "<name>-max-microamp" property indicates
current limit and is mandatory if "<name>-fixed-regulator" is not
defined on a specified regulator.

However, in some platforms, regulators without "<name>-fixed-regulator"
deifned may not need to define their current limit. They may only
want to define voltage range for proper voltage switching in
different power modes, especially for vcc, vccq or vccq2.

However, missing "<name>-max-microamp" property in device tree
will lead to initialization fail, thus above limitation shall be
resolved to tolerate such kind of regulators.

After resolving this, these regulators without "<name>-max-microamp"
will have undefined "max current" value, i.e., zero value in "max_uA"
field in struct ufs_vreg. Because we do bypass current switching
operation (by regulator_set_load) in case of undefined current limit,
this patch shall be safe.

Signed-off-by: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 588079286e8a..2f244d388ca8 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -157,11 +157,9 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
 		goto out;
 
 	snprintf(prop_name, MAX_PROP_SIZE, "%s-max-microamp", name);
-	ret = of_property_read_u32(np, prop_name, &vreg->max_uA);
-	if (ret) {
-		dev_err(dev, "%s: unable to find %s err %d\n",
-				__func__, prop_name, ret);
-		goto out;
+	if (of_property_read_u32(np, prop_name, &vreg->max_uA)) {
+		dev_info(dev, "%s: unable to find %s\n", __func__, prop_name);
+		vreg->max_uA = 0;
 	}
 
 	if (!strcmp(name, "vcc")) {
-- 
2.18.0
