From: Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v4 1/5] scsi: ufs: Remove unused min_uA field in struct
 ufs_vreg
Date: Thu, 28 Mar 2019 17:16:23 +0800
Message-ID: <1553764587-26357-2-git-send-email-stanley.chu@mediatek.com>
References: <1553764587-26357-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1553764587-26357-1-git-send-email-stanley.chu@mediatek.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com, pedrom.sousa@synopsys.com
Cc: marc.w.gonzalez@free.fr, chun-hung.wu@mediatek.com, kuohong.wang@mediatek.com, evgreen@chromium.org, subhashj@codeaurora.org, linux-mediatek@lists.infradead.org, peter.wang@mediatek.com, vivek.gautam@codeaurora.org, matthias.bgg@gmail.com, sayalil@codeaurora.org, Stanley Chu <stanley.chu@mediatek.com>, linux-arm-kernel@lists.infradead.org, beanhuo@micron.com
List-Id: linux-scsi@vger.kernel.org

There are two fields related to regulator current limit in struct
ufs_vreg: "min_uA" and "max_uA".

"max_uA" is probed by "<name>-max-microamp" property from device
tree and used for

- regulator_set_load operations, and
- icc_level configuration in device.

However "min_uA" field is not used anywhere, thus we can remove it.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Marc Gonzalez <marc.w.gonzalez@free.fr>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Acked-by: Alim Akhtar <alim.akhtar@samsung.com>
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
