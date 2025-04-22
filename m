Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1816925F98B;
	Tue, 22 Apr 2025 02:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745288284; cv=none; b=kiko6bQ4qzg0G+Cs2mvehk87wcHUwreliUO+a9AZTR8xuptg/uF6sDFh0bY1s64Gcx/ipSj/khTdkmnyvpNfdKJUHjLtP5ZCZ+F3WAN4Q3tmq0Cqf3D2l9oK5Mb1qF0tCMFb5ISBftyyrynp/g4OTKomVvAiLSwJFpj9XxziZGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745288284; c=relaxed/simple;
	bh=L3/HcG6wXKyGIPN+AAPEjXN6F2jJXbxSsfwJd+Pgyqo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VBVT8PXY7TzgSuZwhxyOsBtzBvIlOaTR1zWUfwFPrn1wQIccOipJ0EVsVAxcj3HLwyoCsqrKEpD5kli1aOOF+KtP8yFWlE5m7tCvvOBtJvqqsZnoIFMIitbEVxFgwG8f4XkMHgRJnTj22Y5fsWC/09yEuBfYrKIAlf5tGOYrTQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tAFN661f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tAFN661f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D79C4CEEE;
	Tue, 22 Apr 2025 02:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745288284;
	bh=L3/HcG6wXKyGIPN+AAPEjXN6F2jJXbxSsfwJd+Pgyqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tAFN661fW85LmZDdDVS/o4M9xgnFv7g5hka301AZeVwAxK+KWMwSHNKMyJ4t9nAUb
	 5Ix6OMqlNLAkaR/aN8zLBFd+HVj0lHhX4h5L6dICIeSdqLeZ658SZkE/JgO7Pu3g/e
	 Pf20PdYkczu9Cly1QhgfZbfGh7VyQ+dyCWAKM+WrKh0V5R4qsWu45cSI3YgBZop++r
	 StIM/o8X3yhSeAZVag5AyHaNj2Si9B16KJ49qYYgL0+z8eXcmLmAR2/TwHdunXPZ08
	 IIUywN9OWph5e4DHvruP+3JOjZyPsw20I2HfN5mTtpzn0Ocv+pNwg0NShRy45WXhvf
	 mzgUKFpglSTFA==
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
Subject: [PATCH AUTOSEL 6.6 02/15] scsi: ufs: exynos: Ensure pre_link() executes before exynos_ufs_phy_init()
Date: Mon, 21 Apr 2025 22:17:46 -0400
Message-Id: <20250422021759.1941570-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250422021759.1941570-1-sashal@kernel.org>
References: <20250422021759.1941570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.87
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
index 268189f01e15b..76703a7fa5717 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -984,9 +984,14 @@ static int exynos_ufs_pre_link(struct ufs_hba *hba)
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
@@ -994,11 +999,6 @@ static int exynos_ufs_pre_link(struct ufs_hba *hba)
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

