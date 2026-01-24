Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9DC2E093E;
	Sat, 24 Jan 2026 12:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769256191; cv=pass; b=pw8lwrXnU+qVlolIyIjUQQiYAFhqNDVpAjieMtokFbERn6tqjg8HTe32iVt030nPLoiXG2uAoXfedHJVhHsT88YuAdfICKpjSHGIdA34U1/A7e72KUatDE+kvyivUqmUltJI7DUgnjGpTdzTJCZLJgkZk5GeXX8nuSMU+lOWhS8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769256191; c=relaxed/simple;
	bh=UhtPaGwuFlEFDj2CCUlrPu8e8xx653WtlROBXEBmR68=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=g4b0zR/khkTfqao8l4mL/jdCg9TGjjKZTBz0Cjcv0A8Sz0NUP7H9lLEqqXgcUfVfLfRUZHIfRGqecXBcmEoCmBnX6G/9eP6OBDvFIThv9rdb507DiiHkzlSkSti2j6NUA6/IbXVML7yMO/1o8ruvQtffZVshBAUs0k1toEJph98=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=Zb/zwO13; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="Zb/zwO13"
ARC-Seal: i=1; a=rsa-sha256; t=1769256162; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=MuLglDE6SViM8d+o7LBUytg7HrRpvR6/J1Xho/A8IUnXrA9lcdIYWTo8Y//rdgelQ3RR+YSb6U3B3XJakKWRURJcCifoRqsiN5VqFPr7RQ2co7V5IHECG78JnigyUUhpm1kYU0+E+4yz7Y1JttSc3gwJ5rNeYyeh3K0Q5DG6p4A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1769256162; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=QMwNSkM5XSH2k8a3Oq36FB58kMKzIsImX1FaHSGQhBs=; 
	b=CD2ZV+6QyRXCgWbLzv/OODaDyFcarIlIs6D0/t7dJ1MRI6iFs/VMXnszDY+XO3EEahj2WFeNXWk38SUL5VB5taglbudwz9Za2ztemSB019JMSHAvOwChiSQGbLl3xrmLju9KlsnapwFAtf1SKz+RAJKpjMZ3x5Q60tOmKwbsIIE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1769256162;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=QMwNSkM5XSH2k8a3Oq36FB58kMKzIsImX1FaHSGQhBs=;
	b=Zb/zwO13Ip+tgDLIMu3QMDlAOe8uyk3mLGUPAqOx6hQv59MU4jN6FpO+7rxuKfdm
	jw7lLSX5OLmZXvgaD4tnNn6D5I4qT75FocDZEKzFg3/OHfVDUlpLYfHSBJFvUEWj9EJ
	PnFZT/IT3Gi4EPurYzKNlCtmjFpS6bxDwz1ASUbs=
Received: by mx.zohomail.com with SMTPS id 1769256160863573.5722153832722;
	Sat, 24 Jan 2026 04:02:40 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Sat, 24 Jan 2026 13:01:00 +0100
Subject: [PATCH v6 14/24] scsi: ufs: mediatek: Switch to newer PM ops
 helpers
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260124-mt8196-ufs-v6-14-e7c005b60028@collabora.com>
References: <20260124-mt8196-ufs-v6-0-e7c005b60028@collabora.com>
In-Reply-To: <20260124-mt8196-ufs-v6-0-e7c005b60028@collabora.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>, 
 Kishon Vijay Abraham I <kishon@kernel.org>, 
 Peter Wang <peter.wang@mediatek.com>, Stanley Jhu <chu.stanley@gmail.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>, 
 Mark Brown <broonie@kernel.org>, Chaotian Jing <Chaotian.Jing@mediatek.com>, 
 Neil Armstrong <neil.armstrong@linaro.org>
Cc: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>, 
 kernel@collabora.com, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
 linux-phy@lists.infradead.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
X-Mailer: b4 0.14.3

SET_SYSTEM_SLEEP_PM_OPS and SET_RUNTIME_PM_OPS are deprecated.

Switch to the non-deprecated variants, and pm_ptr, removing the
ifdeffery in the process. This allows the compiler visibility into those
functions.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 3250c27cb91f..230e11533eac 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2325,7 +2325,6 @@ static void ufs_mtk_remove(struct platform_device *pdev)
 	ufshcd_pltfrm_remove(pdev);
 }
 
-#ifdef CONFIG_PM_SLEEP
 static int ufs_mtk_system_suspend(struct device *dev)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
@@ -2372,9 +2371,7 @@ static int ufs_mtk_system_resume(struct device *dev)
 
 	return ret;
 }
-#endif
 
-#ifdef CONFIG_PM
 static int ufs_mtk_runtime_suspend(struct device *dev)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
@@ -2418,13 +2415,10 @@ static int ufs_mtk_runtime_resume(struct device *dev)
 
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
@@ -2434,7 +2428,7 @@ static struct platform_driver ufs_mtk_pltform = {
 	.remove = ufs_mtk_remove,
 	.driver = {
 		.name   = "ufshcd-mtk",
-		.pm     = &ufs_mtk_pm_ops,
+		.pm     = pm_ptr(&ufs_mtk_pm_ops),
 		.of_match_table = ufs_mtk_of_match,
 	},
 };

-- 
2.52.0

