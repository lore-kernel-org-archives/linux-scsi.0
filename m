Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A759D2580D0;
	Tue, 22 Apr 2025 02:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745288227; cv=none; b=E2JjFH2IaHs6gbEUB98IdjW44u80IAh8lxRBFz40Gh5JPARQTx7n0J/GD8bM5ZwkhEicKrpORtUdGCDwkJP7hNot0s+EnO+G3VEzXRpyS3b/SOhLfhMWlxamMfNIx5FRkhofiOAD/cvS04nDysaRRlQ+noBvTH2tFW+ovHFA960=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745288227; c=relaxed/simple;
	bh=snEszN9H4QLgMQM2SqmIYzOCYIhvNPiJcDWlBiTwL8w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T3/4eS9vxd09z5i45TiU3cen3qZy1MMy7AX/a3REwRc2gpwkQbWeETVUASFl2RoHZzGf8Ts32vQTgE4fea6XvTcfQuAnt1RwMnyzpzMrECA9LCfwVD8Vm+z0mO3ypAB4B4y5NbIRPYRyGTBDf2CkVo+dM9GmMUn3CK3G/HGkm2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d/k0zpeX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d/k0zpeX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D3BC4CEE4;
	Tue, 22 Apr 2025 02:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745288227;
	bh=snEszN9H4QLgMQM2SqmIYzOCYIhvNPiJcDWlBiTwL8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/k0zpeXMhfh1fL/Nq4HcknXq7U3W4nJNsw4nWk8xhM9dkdoIFQDaokjzJyT7G3Nn
	 rAnlC6iDughan3d1PmiTXo3+anfUXQJnV2YMOtXEOsBpFSKoJffX6xT9IUXfq/pHaT
	 tyT0fHAHEOFvdIAwejR7cJoEnqg+QsqRgHSc5ybo8eUcKQzPxdnEuT5mlWsj87W6zg
	 +FooJJgp8tZs6xED02ZMYkUnQqpPOzLmK87MIaSOx/Boxv6X7Hl15TqE+eqytRbTp8
	 tR7kXGzlDHB5Swfx/oj7iO35oIW2R7LD297el6b511v1+Gb09iKy1XFnYOtqexm/sh
	 fisQof2F5i2AQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Peter Griffin <peter.griffin@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	alim.akhtar@samsung.com,
	James.Bottomley@HansenPartnership.com,
	krzk@kernel.org,
	linux-scsi@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.12 02/23] scsi: ufs: exynos: Ensure pre_link() executes before exynos_ufs_phy_init()
Date: Mon, 21 Apr 2025 22:16:42 -0400
Message-Id: <20250422021703.1941244-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250422021703.1941244-1-sashal@kernel.org>
References: <20250422021703.1941244-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.24
Content-Transfer-Encoding: 8bit

From: Peter Griffin <peter.griffin@linaro.org>

[ Upstream commit 3d101165e72316775947d71321d97194f03dfef3 ]

Ensure clocks are enabled before configuring unipro. Additionally move
the pre_link() hook before the exynos_ufs_phy_init() calls. This means
the register write sequence more closely resembles the ordering of the
downstream driver.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Link: https://lore.kernel.org/r/20250319-exynos-ufs-stability-fixes-v2-1-96722cc2ba1b@linaro.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-exynos.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 98505c68103d0..7689617aa3f3c 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1007,9 +1007,14 @@ static int exynos_ufs_pre_link(struct ufs_hba *hba)
 	exynos_ufs_config_intr(ufs, DFES_DEF_L4_ERRS, UNIPRO_L4);
 	exynos_ufs_set_unipro_pclk_div(ufs);
 
+	exynos_ufs_setup_clocks(hba, true, PRE_CHANGE);
+
 	/* unipro */
 	exynos_ufs_config_unipro(ufs);
 
+	if (ufs->drv_data->pre_link)
+		ufs->drv_data->pre_link(ufs);
+
 	/* m-phy */
 	exynos_ufs_phy_init(ufs);
 	if (!(ufs->opts & EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR)) {
@@ -1017,11 +1022,6 @@ static int exynos_ufs_pre_link(struct ufs_hba *hba)
 		exynos_ufs_config_phy_cap_attr(ufs);
 	}
 
-	exynos_ufs_setup_clocks(hba, true, PRE_CHANGE);
-
-	if (ufs->drv_data->pre_link)
-		ufs->drv_data->pre_link(ufs);
-
 	return 0;
 }
 
-- 
2.39.5

