From: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: scsi: ufs-mediatek: Add UFS support for Mediatek SoC chips
Date: Sat, 16 Mar 2019 13:04:39 +0800
Message-ID: <1552712687-20186-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
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
Cc: chun-hung.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, vivek.gautam-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hello,

This patch series adds UFS M-PHY and UFS host driver support in MediaTek chipsets.

In the meantime, re-factors ufshcd_get_pwr_dev_param in vendors' drivers. This function is for vendors to decide finally agreed attributes for power mode change if vendors define
their host capability in struct ufs_dev_params. Because it is using by both ufs-qcom and ufs-hisi and also used in ufs-mediatek in this series, simply re-factor it and then every vendors can reuse it.

Changes since v5:
-	phy-mtk-ufs: Change mphy_readl/mphy_writel() to inline functions.
-	Fix typo in cover letter.

Changes since v4:
-	phy-mtk-ufs:
	  * Sort name in Kconfig and Makefile
	  * Drop "inline" and fix symbol name for mphy_set_bit()/mphy_clr_bit().
-	dt-bindings: phy-mtk-ufs: Drop "-clk" in clock names.
-	dt-bindings: ufs-mediatek:
	  * Change clock name "ufs-clk" to "ufs".
	  * Drop vcc related first. VCC control is planned to be added back by another patch accompanied with VCC/ICC logic fix in ufs common driver.

Changes since v3:
-	dt-bindings: Use specific compatible name for both ufs-mediatek and phy-mtk-ufs, remove interrupt-parent and lanes-per-direction in ufs-mediatek, and fix descriptions.

Changes since v2:
-	Fix header style with SPDX-License-Identifier declaration used.
-	Simplify ufs-phy-mtk to single source file since we has one MPHY version now, and do fixes according to Chunfeng Yun's comments.
-	Add dt-bindings of ufs-phy-mtk.

Changes since v1:
-	Re-factor ufshcd_get_pwr_dev_param in mediatek/qcom/hisi vendor drivers.
-	Introduce ufs-phy-mtk to have a good extension capability for different power control flows in future different MPHY versions.
-	Bind ufs-phy-mtk and hook suitable callbacks in ufs-mediatek driver.
-	Use PA_LOCAL_TX_LCC_ENABLE attribute defined in unipro.h instead.
-	Do some minor format fixes.
