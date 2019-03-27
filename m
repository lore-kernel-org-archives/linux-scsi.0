From: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RESEND v3 1/5] scsi: ufs: Remove unused min_uA field in struct
 ufs_vreg
Date: Wed, 27 Mar 2019 17:58:23 +0800
Message-ID: <1553680707-28579-2-git-send-email-stanley.chu@mediatek.com>
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

There are two fields related to regulator current limit in struct
ufs_vreg: "min_uA" and "max_uA".

"max_uA" is probed by "<name>-max-microamp" property from device
tree and used for

- regulator_set_load operations, and
- icc_level configuration in device.

However "min_uA" field is not used anywhere, thus we can remove it.

Signed-off-by: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Reviewed-by: Marc Gonzalez <marc.w.gonzalez-GANU6spQydw@public.gmane.org>
---
 drivers/scsi/ufs/ufs.h           | 1 -
 drivers/scsi/ufs/ufshcd-pltfrm.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 21e4ccb5ba6e..99a9c4d16f6b 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -516,7 +516,6 @@ struct ufs_vreg {
 	bool enabled;
 	int min_uV;
 	int max_uV;
-	int min_uA;
 	int max_uA;
 };
 
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 27213676329c..32cf8c56f029 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -164,7 +164,6 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
 		goto out;
 	}
 
-	vreg->min_uA = 0;
 	if (!strcmp(name, "vcc")) {
 		if (of_property_read_bool(np, "vcc-supply-1p8")) {
 			vreg->min_uV = UFS_VREG_VCC_1P8_MIN_UV;
-- 
2.18.0
