Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEA01D5ABA;
	Mon, 13 Jan 2025 18:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736793288; cv=none; b=tDAzb7tn3wploQfYqBPYbP+23BjLjxSqqqZuGzC9eoAn0tV437Z40aUwf703vyvIvzJwT6PGhyaGKWGPswuQNpjh0QALyODq6zA7nkNZpX7XK5hCfF3iOPZZUiHEiLT1ww1ur/j1DwTgWUAki7FEevjybZBEeNU4/c1H3KBw7+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736793288; c=relaxed/simple;
	bh=ndlq/w9vXLcVuQ3oJkWMS36HYWEtrKJrtDG4/IxWrsQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PtkVqsOiUcaUsKxOTa3wbVRc0McnLgE3wDAZb72rgSXL4NoFEu/V2MNe9tiEXPluTHYu0TyyjrtFfQ9M0xzZ5a5Inm9V8/I2uzspS1EBs16lkxHQvFPW9DIhSzfHlic9Gt6LlDAdChxxA9TpKMImxpF6W7Q8P5E9Gd+S9KXSlbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IH6tMwJo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IH6tMwJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02810C4CED6;
	Mon, 13 Jan 2025 18:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736793288;
	bh=ndlq/w9vXLcVuQ3oJkWMS36HYWEtrKJrtDG4/IxWrsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IH6tMwJoc2xQGryQ9dGK0wQvZ/M1N53gx/yIdYMhVMWzzb3dhyUwY6kx5knv2MPdj
	 6Zlsql+IRqJsNuoeU1e7WoIppfXMVuHZhvwFoh+H8Un/tj28Cfp/F9QAJ17WEn0oIo
	 46sb8oD3jwXYbWickNep6oYQJJfwkFKGrQIZaVqehM6+5WZsO+HzJ6bFIEars5JKEk
	 HnpFaOzXh2kvWchhejSjMF1fpc5RJ4rdQbFRioWOg4qKwmvxlyVM0sIFZWTBqZ7uKR
	 Zb/keOiXMN2DuYmCgESeJLeF46T9tCmqGtknbi/mGy07oK8Q+fyIcibv/4FdrrRa3h
	 U1royVqzJtRQg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	peter.wang@mediatek.com,
	avri.altman@wdc.com,
	ahalaney@redhat.com,
	quic_mnaresh@quicinc.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 09/20] scsi: ufs: core: Honor runtime/system PM levels if set by host controller drivers
Date: Mon, 13 Jan 2025 13:34:14 -0500
Message-Id: <20250113183425.1783715-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250113183425.1783715-1-sashal@kernel.org>
References: <20250113183425.1783715-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.9
Content-Transfer-Encoding: 8bit

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit bb9850704c043e48c86cc9df90ee102e8a338229 ]

Otherwise, the default levels will override the levels set by the host
controller drivers.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20241219-ufs-qcom-suspend-fix-v3-2-63c4b95a70b9@linaro.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index bc13133efaa5..68d9f5ad5061 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10590,14 +10590,17 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	}
 
 	/*
-	 * Set the default power management level for runtime and system PM.
+	 * Set the default power management level for runtime and system PM if
+	 * not set by the host controller drivers.
 	 * Default power saving mode is to keep UFS link in Hibern8 state
 	 * and UFS device in sleep state.
 	 */
-	hba->rpm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
+	if (!hba->rpm_lvl)
+		hba->rpm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
 						UFS_SLEEP_PWR_MODE,
 						UIC_LINK_HIBERN8_STATE);
-	hba->spm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
+	if (!hba->spm_lvl)
+		hba->spm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
 						UFS_SLEEP_PWR_MODE,
 						UIC_LINK_HIBERN8_STATE);
 
-- 
2.39.5

