From: Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH] scsi: ufs-mediatek: fix uninitialized variable
Date: Thu, 21 Mar 2019 14:19:25 +0100
Message-ID: <20190321131925.27421-1-anders.roxell@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.ibm.com, martin.petersen@oracle.com, matthias.bgg@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, Anders Roxell <anders.roxell@linaro.org>
List-Id: linux-scsi@vger.kernel.org

When building the ufs-mediatek driver variable 'ret' may be used
uninitialized.

../drivers/scsi/ufs/ufs-mediatek.c: In function ‘ufs_mtk_setup_clocks’:
../drivers/scsi/ufs/ufs-mediatek.c:96:6: warning: ‘ret’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  int ret;
      ^~~

Rework to return directly instead of using a local variable 'ret'.

Fixes: ddd90623ce26 ("scsi: ufs-mediatek: Add UFS support for Mediatek SoC chips")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 drivers/scsi/ufs/ufs-mediatek.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index ce4767784937..330d68871b06 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -93,7 +93,6 @@ static int ufs_mtk_setup_clocks(struct ufs_hba *hba, bool on,
 				enum ufs_notify_change_status status)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
-	int ret;
 
 	/*
 	 * In case ufs_mtk_init() is not yet done, simply ignore.
@@ -106,18 +105,18 @@ static int ufs_mtk_setup_clocks(struct ufs_hba *hba, bool on,
 	switch (status) {
 	case PRE_CHANGE:
 		if (!on)
-			ret = phy_power_off(host->mphy);
+			return phy_power_off(host->mphy);
 		break;
 	case POST_CHANGE:
 		if (on)
-			ret = phy_power_on(host->mphy);
+			return phy_power_on(host->mphy);
 		break;
 	default:
-		ret = -EINVAL;
+		return -EINVAL;
 		break;
 	}
 
-	return ret;
+	return 0;
 }
 
 /**
-- 
2.20.1
