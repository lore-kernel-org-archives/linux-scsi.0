From: <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 0/6] scsi: ufs-mediatek: Add UFS support for Mediatek SoC
 chips
Date: Mon, 25 Feb 2019 17:24:09 +0800
Message-ID: <1551086655-5029-2-git-send-email-stanley.chu@mediatek.com>
References: <1551086655-5029-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1551086655-5029-1-git-send-email-stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, chunfeng.yun-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, kishon-l0cyMroinI0@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, avri.altman-Sjgp3cTcYWE@public.gmane.org, alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, pedrom.sousa-HKixBCOQz3hWk0Htik3J/w@public.gmane.org
Cc: chun-hung.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, vivek.gautam-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

From: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>

Hello,

This patch series adds UFS M-PHY and UFS host driver support in MediaTek chipsets.

In the meantime, re-factors ufshcd_get_pwr_dev_param in vendors' drivers. This function is for vendors to decide finally agreed attributes for power mode change if vendors define
their host capability in struct ufs_dev_params. Because it is using by both ufs-qcom and ufs-hisi and also used in ufs-mediatek in this serious, simply re-factor it and then every vendors can reuse it.

Changes since v1:
	- Re-factor ufshcd_get_pwr_dev_param in mediatek/qcom/hisi vendor drivers.
	- Introduce ufs-phy-mtk to have a good extension capability for different power control flows in future different MPHY versions.
	- Bind ufs-phy-mtk and hook suitable callbacks in ufs-mediatek driver.
	- Use PA_LOCAL_TX_LCC_ENABLE attribute defined in unipro.h instead.
	- Do some minor format fixes.

Stanley Chu (6):
  scsi: ufs: Introduce ufshcd_get_pwr_dev_param
  scsi: ufs-qcom: Re-factor ufshcd_get_pwr_dev_param
  scsi: ufs-hisi: Re-factor ufshcd_get_pwr_dev_param
  dt-bindings: scsi: ufs: Add document for ufs-mediatek
  phy: mediatek: Add UFS M-PHY driver
  scsi: ufs-mediatek: Add UFS support for Mediatek SoC chips

 .../devicetree/bindings/ufs/ufs-mediatek.txt  |  75 ++++
 drivers/phy/mediatek/Kconfig                  |  29 +-
 drivers/phy/mediatek/Makefile                 |   2 +
 drivers/phy/mediatek/phy-mtk-ufs-12nm.c       | 151 +++++++
 drivers/phy/mediatek/phy-mtk-ufs-12nm.h       |  52 +++
 drivers/phy/mediatek/phy-mtk-ufs.c            | 189 +++++++++
 drivers/phy/mediatek/phy-mtk-ufs.h            |  76 ++++
 drivers/scsi/ufs/Kconfig                      |  14 +
 drivers/scsi/ufs/Makefile                     |   1 +
 drivers/scsi/ufs/ufs-hisi.c                   | 109 +----
 drivers/scsi/ufs/ufs-mediatek.c               | 377 ++++++++++++++++++
 drivers/scsi/ufs/ufs-mediatek.h               |  61 +++
 drivers/scsi/ufs/ufs-qcom.c                   | 106 +----
 drivers/scsi/ufs/ufshcd-pltfrm.c              |  98 +++++
 drivers/scsi/ufs/ufshcd-pltfrm.h              |  21 +
 15 files changed, 1144 insertions(+), 217 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/ufs-mediatek.txt
 create mode 100644 drivers/phy/mediatek/phy-mtk-ufs-12nm.c
 create mode 100644 drivers/phy/mediatek/phy-mtk-ufs-12nm.h
 create mode 100644 drivers/phy/mediatek/phy-mtk-ufs.c
 create mode 100644 drivers/phy/mediatek/phy-mtk-ufs.h
 create mode 100644 drivers/scsi/ufs/ufs-mediatek.c
 create mode 100644 drivers/scsi/ufs/ufs-mediatek.h

-- 
2.18.0
