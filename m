Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954D0267F4C;
	Tue, 22 Apr 2025 02:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745288310; cv=none; b=QAy2O9vXMF2E8dLFAB38aD8VVhDrUoX5spG2J52i9FBOWH7yJGxiNe9+rzEFPMvHOj15iMz9lY8PbyMd2LTRN6dXuZH9lMiJYS3/DHWirfrqULGINvGIumv9bHE575i3X8y/NQ5xPPJOFz/9Nifc/xX51K1w3R5mjQefMflOuw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745288310; c=relaxed/simple;
	bh=iTTR50UEs+yrc/reCuVPmDh42fZK32s3XImxX3rVRIg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lw9u9BEDFjuyJGSQM5d8pX6tSsiQuMnaVIRNPTO/FR89QkP25OMJU9/nGlhSnv/p59UOO0cmyh0YeehHr50nK1TD1sRnL3u3t5oB2pkXbr33a5sUChK6SsjZrQ1xDx/Q0Xv4Zo/N+8XhmdDtv8yzlSPCNSXSe0utRUN84lBuZxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XDxjbC9n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XDxjbC9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24125C4CEED;
	Tue, 22 Apr 2025 02:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745288310;
	bh=iTTR50UEs+yrc/reCuVPmDh42fZK32s3XImxX3rVRIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDxjbC9nWQSMxkn/J39Sk6V4V0+ei+dOvlNtxJy+XTE6D6KnlkCCtN7wqYl8JNZqK
	 eMsniPVD1M2TUvp7pWtUmVOOh0z1UxWkzO7lbNW/RhD53OZhiQltzQUtBF7A1vLr41
	 QYO6LVYE4JWrjvGJiM5NQtlspuRXFAesXyb+v6YJfWgEWZS4nKSvdC7KUSX0GsET/D
	 fSKr074fS5SMCZUQp7pe+4Sk/E7/QtSpJ7P0uJK/jZ6b5GoTwvqDlBBN+rY2xo3mmh
	 ztjKAUTPC5gwtL3fSWQe1dQXdwqm0pmodK0pRLnKD5Wr/nQlrSC+/6sRu+LIpSk9ty
	 2QaWmjb62LTaQ==
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
Subject: [PATCH AUTOSEL 6.1 02/12] scsi: ufs: exynos: Ensure pre_link() executes before exynos_ufs_phy_init()
Date: Mon, 21 Apr 2025 22:18:16 -0400
Message-Id: <20250422021826.1941778-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250422021826.1941778-1-sashal@kernel.org>
References: <20250422021826.1941778-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.134
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
index c0030a03dd34d..3c10029723c79 100644
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

