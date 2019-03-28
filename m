From: Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v4 4/5] scsi: ufs: Change "<name>-max-microamp" to
 non-mandatory property
Date: Thu, 28 Mar 2019 17:16:26 +0800
Message-ID: <1553764587-26357-5-git-send-email-stanley.chu@mediatek.com>
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

In dt-bindings for ufs, "<name>-max-microamp" property indicates
current limit and is mandatory if "<name>-fixed-regulator" is not
defined on a specified regulator.

However, in some platforms, regulators without "<name>-fixed-regulator"
property may not need to define their current limit because they may
want to define voltage range only for proper voltage switching in
different power modes, especially for vcc, vccq or vccq2.

Currently missing "<name>-max-microamp" property in device tree will
lead initialization to fail, thus such limitation shall be
resolved to tolerate this kind of regulators.

After resolving this, regulators without "<name>-max-microamp"
property will have undefined "max current" value, i.e., zero value
in "max_uA" field in struct ufs_vreg. Because we do bypass current
switching operation (by regulator_set_load) in case of undefined
current limit, this patch shall be safe.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Acked-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 32cf8c56f029..2420e6962219 100644
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
