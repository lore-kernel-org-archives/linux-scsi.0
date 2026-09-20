Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0AA3AF64B;
	Sun, 20 Sep 2026 03:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789876232; cv=none; b=Z3s6seD7ueVzfY/U4IYcj0NVvbb26dyekZLWRL/xFqCnqdPe0Li6Xsdc4VQTR8tAb8kQN8qEJHfcqv7rDc/RKYCq+9MhdMwpUB72X+i99kDxV2ntoIyI41wXmCPAqY3MrF25N9ZHOprYKD0KReCgZlRL5Z5wb/KWaQUE/9b/W74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789876232; c=relaxed/simple;
	bh=SJbuG8/NOHQQsI/KbLB0Aqwypahq1vey3kBwaoMyoRA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xtpsje4j5ZMYkZIeW2X+XUY182x1i6ssU0s6ezVUh4xhNWfnmMVnckWFGr1G5Cl3JOyezdPxU+L+LGpgyid0/3E2oPHaQmnWEz31MIg4SesWw/b7miCwIczXVDg4VLq/pP5tGG+e7R7zvPWg1wh4xfO1mC9YUvRiccSYDfRE//I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Rogi/3MP; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Rogi/3MP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=el
	h06BPvOR+aqBWG+a9YMejfiEndb0cqDcnnH29KM38=; b=Rogi/3MPytkdsgRYNH
	vE6a4yjT61PA14Mi1gV6dkVW6rzhPLimfOI8jsPvEYLyFGHVYFawAEjv4AUPBxuD
	vqPav87lekW35xCb/izz1WNazgxoYbYDtvmTku3rRlfyFLtOOufdRYB/SXHJ6D0F
	mPV54ZP7vsJVD3gXaPweDTNzs=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wCXJ4jiV69q2YnYBg--.30633S2;
	Sun, 20 Sep 2026 11:49:55 +0800 (CST)
From: Pengpeng Hou <hppiscas@163.com>
To: peter.wang@mediatek.com
Cc: chaotian.jing@mediatek.com,
	chu.stanley@gmail.com,
	james.bottomley@hansenpartnership.com,
	mkp@kernel.org,
	linux-scsi@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	martin.petersen@oracle.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-arm-kernel@lists.infradead.org,
	stanleyjhu@google.com,
	hppiscas@163.com
Subject: [PATCH v2] scsi: ufs: mediatek: handle mPHY power-on failures
Date: Sun, 20 Sep 2026 11:49:53 +0800
Message-ID: <20260920034953.19535-1-hppiscas@163.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCXJ4jiV69q2YnYBg--.30633S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXF4xKw43JrW5tr1fJw43Wrg_yoW5GryDpa
	93K3yqkr1kGrWIvF429FsF93WrW3yfGFy8Gr13Cw1I93W2gr9FqFyvkryfWF4SyrZ5A3yj
	qF18ta47GanIvr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRY0PhUUUUU=
X-CM-SenderInfo: 5kssx2xfdvqiywtou0bp/xtbCxgOUXWqvV+O6XwAA3Y

The MediaTek helper enables VA09 before powering on the mPHY, but
ignores the PHY result. A failure can leave VA09 enabled and publish
mphy_powered_on as true, so a later power-on attempt is skipped.

Check phy_power_on(), attempt to unwind VA09 on failure, and leave the
state flag unchanged. Propagate the helper result from host
initialization as well as its existing resume caller. Keep the original
PHY error if the supply rollback also fails, and report that rollback
separately.

The issue was found by our static-analysis tool.

Fixes: 561e3a8726b2 ("scsi: ufs-mediatek: Fix unbalanced clock on/off")
Fixes: cf137b3ea49a ("scsi: ufs-mediatek: Support VA09 regulator operations")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
---
Changes since v1:
https://lore.kernel.org/all/20260828092311.10774-1-pengpeng@iscas.ac.cn/
Use err for the rollback result and dev_err() for operation failures, as
Stanley requested.

 drivers/ufs/host/ufs-mediatek.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 814c1b7343b9..12a6d4138e44 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -509,6 +509,7 @@ static int ufs_mtk_mphy_power_on(struct ufs_hba *hba, bool on)
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 	struct phy *mphy = host->mphy;
 	struct arm_smccc_res res;
+	int err;
 	int ret = 0;
 
 	if (!mphy || !(on ^ host->mphy_powered_on))
@@ -523,7 +524,18 @@ static int ufs_mtk_mphy_power_on(struct ufs_hba *hba, bool on)
 			usleep_range(200, 210);
 			ufs_mtk_va09_pwr_ctrl(res, 1);
 		}
-		phy_power_on(mphy);
+		ret = phy_power_on(mphy);
+		if (ret) {
+			if (ufs_mtk_is_va09_supported(hba)) {
+				ufs_mtk_va09_pwr_ctrl(res, 0);
+				err = regulator_disable(host->reg_va09);
+				if (err)
+					dev_err(hba->dev,
+						"failed to unwind va09: %d\n", err);
+			}
+			dev_err(hba->dev, "failed to enable mphy: %d\n", ret);
+			return ret;
+		}
 	} else {
 		phy_power_off(mphy);
 		if (ufs_mtk_is_va09_supported(hba)) {
@@ -1295,7 +1307,9 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 	 *
 	 * Enable phy clocks specifically here.
 	 */
-	ufs_mtk_mphy_power_on(hba, true);
+	err = ufs_mtk_mphy_power_on(hba, true);
+	if (err)
+		goto out_variant_clear;
 
 	if (ufs_mtk_is_rtff_mtcmos(hba)) {
 		/* First Restore here, to avoid backup unexpected value */

base-commit: 518e5b794c06c0f0eb40df3e202274a66202c137
-- 
2.50.1 (Apple Git-155)

