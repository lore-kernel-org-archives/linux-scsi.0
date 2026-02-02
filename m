Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EDD274B26;
	Mon,  2 Feb 2026 09:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770025860; cv=none; b=kby8oz/0SQ+Ou5mOdb8fFas2r9POmbWVRxjOdAseLYl0/cCrx/dwxZGRg5M5D+51UfHWSspEP3oow9GTlBX3u9yA8kcV0kdYBGzpNVbSeydSSdF//5w5WVS/9qcGwfUaL+7wdTsWHSGxG9znoMFRD1L0ZRxXQpOtSt55HdW52h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770025860; c=relaxed/simple;
	bh=9VvuiTF467pCqWROe44rFu4fSzJobnhhxxMf2Eom6eM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rqtyLdrHKTOGgNiYNFjCbyTRDlXUh6Ij62iUwbkPi6XBJCiViEK4uYX15xt2ZRNfGGUYAzpDC3Ev65k22w14shcyqhSCkQlfgEwH30++OA0ybp9soLZRgSMPWgCOSvO5hhX9diXbzgUxs5YVENA9clbH9c5YyPXITVqszddvZdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sLS8F96y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sLS8F96y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72939C116C6;
	Mon,  2 Feb 2026 09:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770025860;
	bh=9VvuiTF467pCqWROe44rFu4fSzJobnhhxxMf2Eom6eM=;
	h=From:To:Cc:Subject:Date:From;
	b=sLS8F96yFvtI2VcRrQd5MKVhMx3f/3AhVBQB0m+STBoCPWqz4SCjPi9n5lBJeXSD2
	 ZLgkDMTKQ+dFoyyf05bthwt5K5eLPEp+C3IGxH6ZgaMc6Bb/LaW/FqRP05Ek+0gkL2
	 aIWgkwWsh5TM7NVnlHC+24fDnu8iAK8bYV53YaKtQPkxwqZMZeEHJS5tEL9JfBr9lk
	 mh7kNDkRxNOKpQEPuv32e0wHeTYkla3w2HBx5kbAyrh/WpI56casA1aS4J176f+C1Q
	 B1Z/wZc/gHqBlIuScJPQVV1s2M1uwMj5Zq8LPJXASaI2y2reLgVfw+cs5OQcub2W0W
	 Tnfsp2bTbkOOQ==
From: Arnd Bergmann <arnd@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Chaotian Jing <chaotian.jing@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Stanley Jhu <chu.stanley@gmail.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Chun-Hung Wu <chun-hung.wu@mediatek.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH] scsi: ufs: host: mediatek: require CONFIG_PM
Date: Mon,  2 Feb 2026 10:50:18 +0100
Message-Id: <20260202095052.1232703-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The added print statement from a recent fix causes the
driver to fail building when CONFIG_PM is disabled:

drivers/ufs/host/ufs-mediatek.c: In function 'ufs_mtk_resume':
drivers/ufs/host/ufs-mediatek.c:1890:40: error: 'struct dev_pm_info' has no member named 'request'
 1890 |                         hba->dev->power.request,

It seems unlikely that the driver can work at all without
CONFIG_PM, so just add a dependency and remove the existing
ifdef checks, rather than adding another ifdef.

Fixes: 15ef3f5aa822 ("scsi: ufs: host: mediatek: Enhance recovery on resume failure")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/ufs/host/Kconfig        |  1 +
 drivers/ufs/host/ufs-mediatek.c | 12 +++---------
 include/ufs/ufshcd.h            |  4 ----
 3 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
index 7d5117b2dab4..964ae70e7390 100644
--- a/drivers/ufs/host/Kconfig
+++ b/drivers/ufs/host/Kconfig
@@ -72,6 +72,7 @@ config SCSI_UFS_QCOM
 config SCSI_UFS_MEDIATEK
 	tristate "Mediatek specific hooks to UFS controller platform driver"
 	depends on SCSI_UFSHCD_PLATFORM && ARCH_MEDIATEK
+	depends on PM
 	depends on RESET_CONTROLLER
 	select PHY_MTK_UFS
 	select RESET_TI_SYSCON
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 66b11cc0703b..b3daaa07e925 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2437,7 +2437,6 @@ static void ufs_mtk_remove(struct platform_device *pdev)
 	ufshcd_pltfrm_remove(pdev);
 }
 
-#ifdef CONFIG_PM_SLEEP
 static int ufs_mtk_system_suspend(struct device *dev)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
@@ -2484,9 +2483,7 @@ static int ufs_mtk_system_resume(struct device *dev)
 
 	return ret;
 }
-#endif
 
-#ifdef CONFIG_PM
 static int ufs_mtk_runtime_suspend(struct device *dev)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
@@ -2525,13 +2522,10 @@ static int ufs_mtk_runtime_resume(struct device *dev)
 
 	return ufshcd_runtime_resume(dev);
 }
-#endif
 
 static const struct dev_pm_ops ufs_mtk_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(ufs_mtk_system_suspend,
-				ufs_mtk_system_resume)
-	SET_RUNTIME_PM_OPS(ufs_mtk_runtime_suspend,
-			   ufs_mtk_runtime_resume, NULL)
+	SYSTEM_SLEEP_PM_OPS(ufs_mtk_system_suspend, ufs_mtk_system_resume)
+	RUNTIME_PM_OPS(ufs_mtk_runtime_suspend, ufs_mtk_runtime_resume, NULL)
 	.prepare	 = ufshcd_suspend_prepare,
 	.complete	 = ufshcd_resume_complete,
 };
@@ -2541,7 +2535,7 @@ static struct platform_driver ufs_mtk_pltform = {
 	.remove = ufs_mtk_remove,
 	.driver = {
 		.name   = "ufshcd-mtk",
-		.pm     = &ufs_mtk_pm_ops,
+		.pm     = pm_ptr(&ufs_mtk_pm_ops),
 		.of_match_table = ufs_mtk_of_match,
 	},
 };
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a64c19563b03..8563b6648976 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1344,17 +1344,13 @@ static inline void *ufshcd_get_variant(struct ufs_hba *hba)
 	return hba->priv;
 }
 
-#ifdef CONFIG_PM
 extern int ufshcd_runtime_suspend(struct device *dev);
 extern int ufshcd_runtime_resume(struct device *dev);
-#endif
-#ifdef CONFIG_PM_SLEEP
 extern int ufshcd_system_suspend(struct device *dev);
 extern int ufshcd_system_resume(struct device *dev);
 extern int ufshcd_system_freeze(struct device *dev);
 extern int ufshcd_system_thaw(struct device *dev);
 extern int ufshcd_system_restore(struct device *dev);
-#endif
 
 extern int ufshcd_dme_reset(struct ufs_hba *hba);
 extern int ufshcd_dme_enable(struct ufs_hba *hba);
-- 
2.39.5

