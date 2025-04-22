Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D72B258CF7;
	Tue, 22 Apr 2025 02:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745288231; cv=none; b=mjQluzf/Z1HigJT+C+z2TwOgaWI0CpfGlLjx0pWW2DrhvYJZW5+eJF9q0am4A7TIWJRjGK5JJkaXg7GqSWGoAwbdEVoUOye102563D/AgHtTOLs10LQF1IsChYcPAZeGIChCWbO1St3nwimQxakJDdunoPqjjlmQkKK3L0d192s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745288231; c=relaxed/simple;
	bh=dGdbF4fqM8z3Qtn9iRFU1wJoMa6zdozEGaMCJ6u24Hc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BK6yk9Y/NmVs5EJwrqT2lDifcwnU8R0f36e5j7WXYWHeIYQXAFMopd/GvXUiM0yDXuy7/VRfLEp2/kT3yv24tAh+MDRklxMum/JSr93NdQKC+qBnjMLRDI3yjhyS9quXQJvHZxpchxN8DXouE6cgMY03N9ihsbwvAcpOhH89FWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pt/tSl6D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pt/tSl6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC88C4CEEF;
	Tue, 22 Apr 2025 02:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745288229;
	bh=dGdbF4fqM8z3Qtn9iRFU1wJoMa6zdozEGaMCJ6u24Hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pt/tSl6D2iBve4Vi/ccuai0uB2HEFWJpR/mNkvizE6BDIgzcu2OYi8yNw+sJbCzYo
	 NR45KP8QPjNo9mOLmbK1kIjzf65BMnO/Cg/Tvh6VgoDvHNr+LmfyyYoaB2cZqbLDnI
	 FQeAPFcuryNeiKzsEur12PJkjSd4tpt4nRDgCiYIctzO2fedMNYwNYwLVd16uoby2d
	 shfTGdgY0BQgpeOsjwculUlYTfKvjOdliVqxbV8HfY4FmIuj5smswnJLTQHDGVJCHW
	 Zd3yJ5ILP51QSqw3wEUnO0yVEO4Ou8H3YyjvF1O51Grdb5sIq3PVX59gwyl91kLGXP
	 1NnitUor8EeNg==
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
Subject: [PATCH AUTOSEL 6.12 03/23] scsi: ufs: exynos: Enable PRDT pre-fetching with UFSHCD_CAP_CRYPTO
Date: Mon, 21 Apr 2025 22:16:43 -0400
Message-Id: <20250422021703.1941244-3-sashal@kernel.org>
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

[ Upstream commit deac9ad496ec17e1ec06848964ecc635bdaca703 ]

PRDT_PREFETCH_ENABLE[31] bit should be set when desctype field of
fmpsecurity0 register is type2 (double file encryption) or type3
(support for file and disk encryption). Setting this bit enables PRDT
pre-fetching on both TXPRDT and RXPRDT.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Link: https://lore.kernel.org/r/20250319-exynos-ufs-stability-fixes-v2-5-96722cc2ba1b@linaro.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-exynos.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 7689617aa3f3c..477a9f2920765 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -34,7 +34,7 @@
  * Exynos's Vendor specific registers for UFSHCI
  */
 #define HCI_TXPRDT_ENTRY_SIZE	0x00
-#define PRDT_PREFECT_EN		BIT(31)
+#define PRDT_PREFETCH_EN	BIT(31)
 #define HCI_RXPRDT_ENTRY_SIZE	0x04
 #define HCI_1US_TO_CNT_VAL	0x0C
 #define CNT_VAL_1US_MASK	0x3FF
@@ -1045,12 +1045,17 @@ static int exynos_ufs_post_link(struct ufs_hba *hba)
 	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
 	struct phy *generic_phy = ufs->phy;
 	struct exynos_ufs_uic_attr *attr = ufs->drv_data->uic_attr;
+	u32 val = ilog2(DATA_UNIT_SIZE);
 
 	exynos_ufs_establish_connt(ufs);
 	exynos_ufs_fit_aggr_timeout(ufs);
 
 	hci_writel(ufs, 0xa, HCI_DATA_REORDER);
-	hci_writel(ufs, ilog2(DATA_UNIT_SIZE), HCI_TXPRDT_ENTRY_SIZE);
+
+	if (hba->caps & UFSHCD_CAP_CRYPTO)
+		val |= PRDT_PREFETCH_EN;
+	hci_writel(ufs, val, HCI_TXPRDT_ENTRY_SIZE);
+
 	hci_writel(ufs, ilog2(DATA_UNIT_SIZE), HCI_RXPRDT_ENTRY_SIZE);
 	hci_writel(ufs, (1 << hba->nutrs) - 1, HCI_UTRL_NEXUS_TYPE);
 	hci_writel(ufs, (1 << hba->nutmrs) - 1, HCI_UTMRL_NEXUS_TYPE);
-- 
2.39.5

