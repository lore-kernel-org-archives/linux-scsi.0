Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A2F2D058;
	Mon, 15 Apr 2024 07:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713167663; cv=none; b=Dw7kYm+AMAvADLoxBsOw8irQHTy+lTeI2+DajvEN8msmpZLHUBf4LqF93sEaVklP0RmFaYzZESqyUsyuGxuTN+qEh0kL9LAsi8loCFWNISCjSBF0jk0W4bwwSWgXQuZpQbf1fWlHSm0oMUm+HxXTkZmtvnvkDcWen2INAVxvk0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713167663; c=relaxed/simple;
	bh=GYrCUPwSvlfdLE3J9cAWMICwrZAfevrC39qq1M3MwBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0/8kfKiFE3WVtLblm7g4uOgxonurw5yCus+yVBLgam7kaDHTTuHLPfHGlAFerZsn8DTZ/Yy+xDqvNY51MHAiY+rlYUM7Zu4d42sM4zKdC2rXVqnHoY2T+/ptN3MYFKXr+5GFnGgXX5kNhk+qKVH9ma1hzeBGKhems7ouuLblmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=SqsajNCp; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="SqsajNCp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1713167653;
	bh=GYrCUPwSvlfdLE3J9cAWMICwrZAfevrC39qq1M3MwBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SqsajNCpo3gAjUbKWSRE0Kc6t3OtYMGxlj7n2K1K7U8XiZ/D0hyhjxz4PGZqOpmWQ
	 /sv26ML7LZz+xrgvM22Yt5B94IESmyBqNqD0aJsHDR7g24IFLqnUhDgsu0S9KxJfly
	 CxoAzSvN4R64nTAdUFnZAN4syyj4HPAiDSbB5QLBX1Mm3op8R8RfIyC4WfDVS7hJ3c
	 EEBgp3wuTRekn9XOH0Lyf6CgQdEz2NGBGOhP04uhZy/pFh+BfaNdKqf+JvMj5+GJbF
	 t0EdU6vdi9kUP/ibLC69bYbzEb48U0IAhxlxxEktm8ZpChHdEPMoMZeCehU/IEWFKp
	 YRbIDcTH46jfA==
Received: from IcarusMOD.eternityproject.eu (cola.collaboradmins.com [195.201.22.229])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by madrid.collaboradmins.com (Postfix) with ESMTPSA id 4770C3782039;
	Mon, 15 Apr 2024 07:54:12 +0000 (UTC)
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
To: linux-scsi@vger.kernel.org
Cc: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	robh@kernel.org,
	krzysztof.kozlowski+dt@linaro.org,
	conor+dt@kernel.org,
	peter.wang@mediatek.com,
	chu.stanley@gmail.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	lgirdwood@gmail.com,
	broonie@kernel.org,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	stanley.chu@mediatek.com,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 1/8] scsi: ufs: ufs-mediatek: Remove useless mediatek,ufs-support-va09 property
Date: Mon, 15 Apr 2024 09:53:59 +0200
Message-ID: <20240415075406.47543-2-angelogioacchino.delregno@collabora.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415075406.47543-1-angelogioacchino.delregno@collabora.com>
References: <20240415075406.47543-1-angelogioacchino.delregno@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove checking the mediatek,ufs-support-va09 property to decide
whether to try to support the VA09 regulator handling and change
the ufs_mtk_init_va09_pwr_ctrl() function to make it call
devm_regulator_get_optional(): if the regulator is present, then
we set the UFS_MTK_CAP_VA09_PWR_CTRL, effectively enabling the
handling of the VA09 regulator based on that.

Also, make sure to pass the return value of the call to
devm_regulator_get_optional() to the probe function, so that
if it returns a probe deferral, the appropriate action will be
taken.

While at it, remove the error print (disguised as info...) when
the va09 regulator was not found.

Fixes: ac8c2459091c ("scsi: ufs-mediatek: Decouple features from platform bindings")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 34 +++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 0b0c923b1d7b..e4643ac49033 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -622,27 +622,38 @@ static void ufs_mtk_init_boost_crypt(struct ufs_hba *hba)
 	return;
 }
 
-static void ufs_mtk_init_va09_pwr_ctrl(struct ufs_hba *hba)
+static int ufs_mtk_init_va09_pwr_ctrl(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+	int ret;
 
-	host->reg_va09 = regulator_get(hba->dev, "va09");
-	if (IS_ERR(host->reg_va09))
-		dev_info(hba->dev, "failed to get va09");
-	else
-		host->caps |= UFS_MTK_CAP_VA09_PWR_CTRL;
+	host->reg_va09 = devm_regulator_get_optional(hba->dev, "va09");
+	if (IS_ERR(host->reg_va09)) {
+		ret = PTR_ERR(host->reg_va09);
+
+		/* Return an error only if this is a deferral */
+		if (ret == -EPROBE_DEFER)
+			return ret;
+
+		return 0;
+	}
+
+	host->caps |= UFS_MTK_CAP_VA09_PWR_CTRL;
+	return 0;
 }
 
-static void ufs_mtk_init_host_caps(struct ufs_hba *hba)
+static int ufs_mtk_init_host_caps(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 	struct device_node *np = hba->dev->of_node;
+	int ret;
 
 	if (of_property_read_bool(np, "mediatek,ufs-boost-crypt"))
 		ufs_mtk_init_boost_crypt(hba);
 
-	if (of_property_read_bool(np, "mediatek,ufs-support-va09"))
-		ufs_mtk_init_va09_pwr_ctrl(hba);
+	ret = ufs_mtk_init_va09_pwr_ctrl(hba);
+	if (ret)
+		return ret;
 
 	if (of_property_read_bool(np, "mediatek,ufs-disable-ah8"))
 		host->caps |= UFS_MTK_CAP_DISABLE_AH8;
@@ -663,6 +674,7 @@ static void ufs_mtk_init_host_caps(struct ufs_hba *hba)
 		host->caps |= UFS_MTK_CAP_RTFF_MTCMOS;
 
 	dev_info(hba->dev, "caps: 0x%x", host->caps);
+	return 0;
 }
 
 static void ufs_mtk_scale_perf(struct ufs_hba *hba, bool scale_up)
@@ -985,7 +997,9 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 	}
 
 	/* Initialize host capability */
-	ufs_mtk_init_host_caps(hba);
+	err = ufs_mtk_init_host_caps(hba);
+	if (err)
+		goto out;
 
 	ufs_mtk_init_mcq_irq(hba);
 
-- 
2.44.0

