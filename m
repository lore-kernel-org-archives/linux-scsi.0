Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEF32421A;
	Mon, 15 Apr 2024 07:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713167661; cv=none; b=i4+oYl8JwTsEdGhLFnD0EeJm5efgbPu60+7MqjU/GuM2rkjpOXATOYPwdfSt5BrJLzgyQR0HUEYvVMbrX4QvkQJSaACXC9CwymKMtMr8WszjgWQRkZY/YE0bCOc/yO31A6sCCvCI8BBWmTOoNflbSR13XLuyV11ZqU0SMMZVdZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713167661; c=relaxed/simple;
	bh=mtHtsXrLALzqGVSNLxyK9tAZfpbHED2YLsLqlHv6qkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmXrNQ7mOs0S9D1SQbBtip/FzzjonjfCFFgkEvY5eB+04IqRf1d6Ov5WGHYQXh4fnKZmgyMljJiy9DpphJlRbqluVOEu6Yz2CPHgohjwvtM4fmyZhD59WfXovWJD46yfTJEK2kXQ9YTTeikcjKQcmWAITZgiBK5WCSXUe0FnWlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=boO3Pids; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="boO3Pids"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1713167658;
	bh=mtHtsXrLALzqGVSNLxyK9tAZfpbHED2YLsLqlHv6qkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=boO3PidsKRgQDIa/WhDqBUQNs7yBhxTFL7Nlsuv92KD8iRzBFz14iCVhIKRvwvsV2
	 Vt2ZWp964MKE24SKxWmksKT27IKbOwRUjckSBlcYEy95SSzhq9zdWwxR/N3VH1ncCY
	 n1tfwcrYubZTOBSGpYGDv/4P2zXN2AWmPQTDlMrUHH7zaCRmCHBK/nVvp3HZUIg4wt
	 8t8FZxOZaAp20E+fUGhnekXe0jmtWZ4TbC0TMp78fVYjBAP0A9ViS45Vmq5uu3lZcA
	 gxYNx/y3ylf8bTdAqeD4V0S6HvM6Kh5ENPBduQaA1Xb9Ow/9d/uov0+UZsxkGDWyH/
	 2Eojl66gBqDaw==
Received: from IcarusMOD.eternityproject.eu (cola.collaboradmins.com [195.201.22.229])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by madrid.collaboradmins.com (Postfix) with ESMTPSA id EE98237820AB;
	Mon, 15 Apr 2024 07:54:16 +0000 (UTC)
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
Subject: [PATCH v3 4/8] scsi: ufs: ufs-mediatek: Avoid underscores in crypt clock names
Date: Mon, 15 Apr 2024 09:54:02 +0200
Message-ID: <20240415075406.47543-5-angelogioacchino.delregno@collabora.com>
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
index 47f16e6720f4..5db6d27f75af 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -604,15 +604,15 @@ static int ufs_mtk_init_boost_crypt(struct ufs_hba *hba)
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
2.44.0

