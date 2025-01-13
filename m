Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E180520E01D;
	Mon, 13 Jan 2025 18:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736793353; cv=none; b=J+hd6C7N71Zc6I/BFW0+sjhAcnrFbm0k6LW8nw+KkBxvRd3Q9moBVlJxnwpYGq+PP5GCJLC/mkWhCAvTq8rTbMSVJv1cDFuGdt5xyDEjAWaZh+g80nnkWKfCBIlV8n4fkEEtg46oF8xl4yp5/1WwEsFGCiyjiJFLJcHeET84g60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736793353; c=relaxed/simple;
	bh=spG72OXt/ZDHsxqVaWGwK0Bu5OG5+oKIqs3T3dY3qqk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TEKdgKjvzFPDVs9ZnIdIB96IMdmHn0wLy1esVc12sa6vzW+uN2vR6cdScQrEnHLQ/8Df4qbcYbr3XNYOSp7PxIf+QMC2rYvSWKYBA85cTitu9GFOvM9bxTXs2ycrw9pUUHKc/5mYt1gpjR/l24E6+NMs67aLqizgLkgE+7E3vIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mGON+FAF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mGON+FAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7A1C4CED6;
	Mon, 13 Jan 2025 18:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736793352;
	bh=spG72OXt/ZDHsxqVaWGwK0Bu5OG5+oKIqs3T3dY3qqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mGON+FAFO7Me8M76Q1/aEO9Sgk6W+OSroCSboViXdFN0vRsFMUe2yaFVMWhw6AF+w
	 3Ouvxm+VG/LeWUopaE6w8fqMIKFoeCGGQeTrkJ5S/hSsJiN/rJUAamQE4363Caq6lZ
	 TUzoIsuIuXGNJDuoWIVnEJ+5tjzTWPBFhuoHkcwgWDfcdDf3045kP76jn3UGguaTP9
	 EYg3/btN1tL3xf5v+sbvsOEvmSQsYsxJAkS04NMUF8nxyW+QuIU+J+TrFBlw2kEYcl
	 UN8Pm7XZ31L8igjIP5uSpNrULEl2cyedK4BJElBt0TS7hZbCNAdHKieWsliupWRfPP
	 jPZ5t7ijARl1A==
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
Subject: [PATCH AUTOSEL 6.1 06/10] scsi: ufs: core: Honor runtime/system PM levels if set by host controller drivers
Date: Mon, 13 Jan 2025 13:35:32 -0500
Message-Id: <20250113183537.1784136-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250113183537.1784136-1-sashal@kernel.org>
References: <20250113183537.1784136-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.124
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
index 1ea7ae78fca2..c5115f6adbdc 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9879,14 +9879,17 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
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

