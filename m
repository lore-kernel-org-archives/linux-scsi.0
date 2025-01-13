Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7401B1FC7FC;
	Mon, 13 Jan 2025 18:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736793328; cv=none; b=Gf5WGqBvPVeysI8+GeTCQaRzCaeUvCPiGhQruSepKEKKIA6iPcn736jp49xnVsbTLOPT/4NcFKWEN3x0G6qGQOLDL/dx5ljmcO2nKJPwBh9FinXDTBpZkYU9vRTcPD6dE36JSt5TMCpGk8OW2eP7WFImPCV6obSG/kTExSjJ4Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736793328; c=relaxed/simple;
	bh=J3AxO9abyylv373NfKkPGlmMSGT+EVWJVM9UPh1tgoU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kvxNUz1NrUgUVRUCpHL3M8X0MeK5wo1npoQCo9P4npp1gxQiIVcKPFJpZDggVOPnVJ3k5WJyk1AQJiYsdjEvGsT7bdb4A0iS83yvnQ+r1YN/ECW1IDbQptqJpczcLQb5aR/VSts59BTW+QlkcDfkMCeeBDSBFBwXnckCuP2BRVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i8S2T/aN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i8S2T/aN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10727C4CEE1;
	Mon, 13 Jan 2025 18:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736793328;
	bh=J3AxO9abyylv373NfKkPGlmMSGT+EVWJVM9UPh1tgoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i8S2T/aNO5ud6lnlju2OjLQ7PvS8v10djP9MmGhX3zadBRitfvdjPyD5/i4aBKMOL
	 b/gyTorD+bRwuUhbzKUtISUqL6/jmvymGCXs2YA7Q0K/Y/0dRupn/02zgm0npc3pqd
	 t1PeDbYC9DxyyyaNlQDNzPApYzs9K2dFpMXkBn+7Z5I/Vwqs4vDQXje7fPwE5m+HUf
	 aF/YVN57wQ321fw/FbOMFTc4BGGC++Si0ojkFuOGyWManiOd4OYJGAPzRU0Uuu2JbT
	 aKHlrOq9I9zsJUOiYIlR5a7DXeLLSrq3GdCcu7JS32LalATvemkivU1YXADyhuDs1K
	 AOxbL+0z/a99g==
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
Subject: [PATCH AUTOSEL 6.6 06/10] scsi: ufs: core: Honor runtime/system PM levels if set by host controller drivers
Date: Mon, 13 Jan 2025 13:35:07 -0500
Message-Id: <20250113183511.1783990-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250113183511.1783990-1-sashal@kernel.org>
References: <20250113183511.1783990-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.71
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
index 84dac9050074..5c74293fd685 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10484,14 +10484,17 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
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

