Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4C116D301;
	Wed, 12 Jun 2024 07:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718178210; cv=none; b=BAe+Geug82tId+YY2fgajnXDLkUIjil+JnGpmvkRUab2jfoCUftj9Eg5F9s3KV+Df0KlFpLlWf39CJknrJoO2cMjQzK9ZyIRh2TCOYm8jvQ+WorgDaqkGiFliEAe6hvy4wCXEB+ru7dZvdj4DfK3nP+NcANG2wGSDcgszKkkAJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718178210; c=relaxed/simple;
	bh=K9MBVzw8pOo1gyqCI5gTzX5FvDaBQEiToN0XXU2CLjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iqin+XKMpu6fIIbiyvIPjnc90uPFCh2xc7r455PTiklrAl0P1sA8o+CKfAYrZSzymm6W4ymSPLXeL/OxBoVJ+nRQ+Sw1MtP9QGi9a686Z5Ru0YLIpY54dhRcOCsyEKsyKGCq2BLo16OeN4sCIyePhFy1nRaD+Dxn4Q1HadhSMz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=eoHZXYnc; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="eoHZXYnc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1718178207;
	bh=K9MBVzw8pOo1gyqCI5gTzX5FvDaBQEiToN0XXU2CLjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eoHZXYncZyQl8K7MWDaJC1sFeWZxHXStMI1HqUfD1Va/32VVj+OxGTeEStnJTIcDS
	 mJLX9np5dQ0zn74aPE9fs6p0BJAz7I8fomj99yIVCEZzZdo7WInMOZ2eNRpEPXZbmG
	 gjaZ66SQehY8Qw24C1Ho5EZwfzYrpryfHrtiXov4hIFYK9Gofvw8GruUGyLa2B4wOp
	 FPqrmFrUpiuH4NntZgI50fnAMnunJOkXq9FbKXiIv8nmVPa7Sy2267ELCXDZykVYJg
	 ZnLQBkvtge9Qemf+TwEzXFRFFIj6KzFmc0Khitl75Zjg7a5U2mYJtBSNxyycBm3Kz5
	 GhLzEyB5dd0Dg==
Received: from IcarusMOD.eternityproject.eu (cola.collaboradmins.com [195.201.22.229])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by madrid.collaboradmins.com (Postfix) with ESMTPSA id 677DB378219B;
	Wed, 12 Jun 2024 07:43:26 +0000 (UTC)
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
Subject: [PATCH v5 4/8] scsi: ufs: ufs-mediatek: Avoid underscores in crypt clock names
Date: Wed, 12 Jun 2024 09:43:05 +0200
Message-ID: <20240612074309.50278-5-angelogioacchino.delregno@collabora.com>
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

Change all of crypt_{mux,lp,perf} clock names to crypt-{mux,lp-perf}:
retaining compatibility with the old names is ignored as there is no
user of this driver declaring any of those clocks, and the binding
also doesn't allow these ones at all.

Fixes: 590b0d2372fe ("scsi: ufs-mediatek: Support performance mode for inline encryption engine")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 8d0e7ea52541..10a550e7e628 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -605,15 +605,15 @@ static int ufs_mtk_init_boost_crypt(struct ufs_hba *hba)
 		return -ENOMEM;
 
 	cfg = host->crypt;
-	ret = ufs_mtk_init_host_clk(hba, "crypt_mux", &cfg->clk_crypt_mux);
+	ret = ufs_mtk_init_host_clk(hba, "crypt-mux", &cfg->clk_crypt_mux);
 	if (ret)
 		goto out;
 
-	ret = ufs_mtk_init_host_clk(hba, "crypt_lp", &cfg->clk_crypt_lp);
+	ret = ufs_mtk_init_host_clk(hba, "crypt-lp", &cfg->clk_crypt_lp);
 	if (ret)
 		goto out;
 
-	ret = ufs_mtk_init_host_clk(hba, "crypt_perf", &cfg->clk_crypt_perf);
+	ret = ufs_mtk_init_host_clk(hba, "crypt-perf", &cfg->clk_crypt_perf);
 	if (ret)
 		goto out;
 
-- 
2.45.2

