Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AC33D388;
	Wed, 12 Jun 2024 07:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718178206; cv=none; b=U3K9EtEYSvOKWDqmeBLSGfYibntmHndvKiwPxMe99kMjqXZNCn3itpJmSDlW6P3TLfqQ3Jb45MxHhQfc1Cs0M/WWJB+Be+M3X5/3mJSu4xpmKwdgxI3U/lnA37XNaKAaDAmZxQueYS+rSizn9kuUuYvYGOSkkFdTgRCpdPZKbS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718178206; c=relaxed/simple;
	bh=2rsptygWifRO/c0OTQta4XS0LqTtMDZVNSsQpMH8z8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLbK/IohmGW9z/Ofc+w2qoZJSqNuFQw1lFf4mC4Vkkc6SpDciC/nzlh7UA1oNTZ2cXtJgcbXeCVgItqj94CyFRsG/GtKF9eypB9J+qt1m9MTBY42jvV6wSUmvRGpPdj/K/e7oDVj8CiESZHyhnKDTJy2J2Itizjk0favBafzc/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=2D5ReFgC; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="2D5ReFgC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1718178203;
	bh=2rsptygWifRO/c0OTQta4XS0LqTtMDZVNSsQpMH8z8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2D5ReFgCJ0rNdPab1qhWShJZEjGyFXubQVbypSqm26hV10K6fOnoNldYMD6Ir5B4l
	 dhCMjArm9ltXzjdeHpguPw2v2UyAy76xgyegFOSHz/rdRkH8suCc5jghYAHa8w1ao6
	 ESRPhlV+Zt5W+60sq1HDzpbHxXor5LAsKO7NdV4F5zvlFqUvGdZ4VfqAqHi2aH8W6Y
	 cbjJKL3Ft2B5QnPEaNz38u0AdIr6vNnW/0/sgY4+wg+aT9mbcPIWDWwJPsYg1+adMa
	 LorIwLHrd+g4dbAxr+Kf6b35R4UPipa2nxO8g63zgDEsBdQjihbFcLpgOprtotdaao
	 OF7sbDCP+beAQ==
Received: from IcarusMOD.eternityproject.eu (cola.collaboradmins.com [195.201.22.229])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by madrid.collaboradmins.com (Postfix) with ESMTPSA id 4E45437820A9;
	Wed, 12 Jun 2024 07:43:22 +0000 (UTC)
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
To: linux-scsi@vger.kernel.org
Cc: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	robh@kernel.org,
	krzysztof.kozlowski+dt@linaro.org,
	conor+dt@kernel.org,
	peter.wang@mediatek.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	lgirdwood@gmail.com,
	broonie@kernel.org,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	wenst@chromium.org,
	michael@walle.cc
Subject: [PATCH v5 1/8] scsi: ufs: ufs-mediatek: Remove useless mediatek,ufs-support-va09 property
Date: Wed, 12 Jun 2024 09:43:02 +0200
Message-ID: <20240612074309.50278-2-angelogioacchino.delregno@collabora.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240612074309.50278-1-angelogioacchino.delregno@collabora.com>
References: <20240612074309.50278-1-angelogioacchino.delregno@collabora.com>
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
index c7a0ab9b1f59..47c7d34b9be9 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -623,27 +623,38 @@ static void ufs_mtk_init_boost_crypt(struct ufs_hba *hba)
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
@@ -664,6 +675,7 @@ static void ufs_mtk_init_host_caps(struct ufs_hba *hba)
 		host->caps |= UFS_MTK_CAP_RTFF_MTCMOS;
 
 	dev_info(hba->dev, "caps: 0x%x", host->caps);
+	return 0;
 }
 
 static void ufs_mtk_scale_perf(struct ufs_hba *hba, bool scale_up)
@@ -986,7 +998,9 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 	}
 
 	/* Initialize host capability */
-	ufs_mtk_init_host_caps(hba);
+	err = ufs_mtk_init_host_caps(hba);
+	if (err)
+		goto out;
 
 	ufs_mtk_init_mcq_irq(hba);
 
-- 
2.45.2

