Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C979C16133C;
	Mon,  5 Aug 2024 17:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722880668; cv=none; b=sSEJBwqmmyxknhGZ5xsKLN4ebo/IdoI/n3yKulT8nc8qv0LikMS7NPKmT3RjI2QadykHiV+AUawHjMMdOpb5/EjXZeVp1eoy9zMhOeOxjfiHb7lAYrN+iKfeKRg0Q6sUrdg8HPYofN3vulO1lh65wUDzYATlgKI6QEGyxNM3UYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722880668; c=relaxed/simple;
	bh=tMivHo/kyJjaTn3w5/jG0sT3rIYqeuw5htpvr53llsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClfeEqTkOb8YvWyEPxjl1NPpEFe/toDh8ho8yiec5HIwPqDggIgw0dfIejics6RYPuVE0tjhSr6EYpX9q3B8Mlw2BVFYEnX3DssRNnLrmLuwr2jeUwHyKBPFt6JwHmXM/uHZycew9sffUmT8uFkICrbdDc+NV5iAS6JUdPJcJuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OnJiJsIS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OnJiJsIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58ADC32782;
	Mon,  5 Aug 2024 17:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722880668;
	bh=tMivHo/kyJjaTn3w5/jG0sT3rIYqeuw5htpvr53llsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OnJiJsISmVTZphID0IgpMTWP4Hiie05oqXI1XxgSrFhl0w7WnjM3zBs5M88TByxup
	 8OfbPqGMbKE3PFyTDGn5nejIO+HiwDWqdJ6OpHzxDbBwGqWSzvMaqPXtOaINT6T29q
	 kBpvpoJd1Re/FqFdUs6bisiqliF/X0zXi3OWq+UpqYAAJrNGVeP2r7t3IoHD+LDmVO
	 GkScQxvBL8w06UKs6ryBYA/WoMrwRkWxCi4ysDecs20Tor/YScEP1j5jx9cknh3JVq
	 1Wbgo+VZTnMJ/LnSHkBIeLakBz8dULDTo63g9UUgzy/ZkoaUI4zknTqw/7n7qZuda7
	 kiGOSgtNLFneA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Kyoungrul Kim <k831.kim@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org,
	avri.altman@wdc.com,
	beanhuo@micron.com,
	alim.akhtar@samsung.com,
	ebiggers@google.com,
	minwoo.im@samsung.com,
	quic_mnaresh@quicinc.com,
	cw9316.lee@samsung.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 03/15] scsi: ufs: core: Check LSDBS cap when !mcq
Date: Mon,  5 Aug 2024 13:57:00 -0400
Message-ID: <20240805175736.3252615-3-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240805175736.3252615-1-sashal@kernel.org>
References: <20240805175736.3252615-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.44
Content-Transfer-Encoding: 8bit

From: Kyoungrul Kim <k831.kim@samsung.com>

[ Upstream commit 0c60eb0cc320fffbb8b10329d276af14f6f5e6bf ]

If the user sets use_mcq_mode to 0, the host will try to activate the LSDB
mode unconditionally even when the LSDBS of device HCI cap is 1. This makes
commands time out and causes device probing to fail.

To prevent that problem, check the LSDBS cap when MCQ is not supported.

Signed-off-by: Kyoungrul Kim <k831.kim@samsung.com>
Link: https://lore.kernel.org/r/20240709232520epcms2p8ebdb5c4fccc30a6221390566589bf122@epcms2p8
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 16 ++++++++++++++++
 include/ufs/ufshcd.h      |  1 +
 include/ufs/ufshci.h      |  1 +
 3 files changed, 18 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 808979a093505..d8e323fbcf21a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2281,7 +2281,17 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
 		return err;
 	}
 
+	/*
+	 * The UFSHCI 3.0 specification does not define MCQ_SUPPORT and
+	 * LSDB_SUPPORT, but [31:29] as reserved bits with reset value 0s, which
+	 * means we can simply read values regardless of version.
+	 */
 	hba->mcq_sup = FIELD_GET(MASK_MCQ_SUPPORT, hba->capabilities);
+	/*
+	 * 0h: legacy single doorbell support is available
+	 * 1h: indicate that legacy single doorbell support has been removed
+	 */
+	hba->lsdb_sup = !FIELD_GET(MASK_LSDB_SUPPORT, hba->capabilities);
 	if (!hba->mcq_sup)
 		return 0;
 
@@ -10384,6 +10394,12 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	}
 
 	if (!is_mcq_supported(hba)) {
+		if (!hba->lsdb_sup) {
+			dev_err(hba->dev, "%s: failed to initialize (legacy doorbell mode not supported)\n",
+				__func__);
+			err = -EINVAL;
+			goto out_disable;
+		}
 		err = scsi_add_host(host, hba->dev);
 		if (err) {
 			dev_err(hba->dev, "scsi_add_host failed\n");
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index e4da397360682..2a7d6f269d9e3 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1064,6 +1064,7 @@ struct ufs_hba {
 	bool ext_iid_sup;
 	bool scsi_host_added;
 	bool mcq_sup;
+	bool lsdb_sup;
 	bool mcq_enabled;
 	struct ufshcd_res_info res[RES_MAX];
 	void __iomem *mcq_base;
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index d5accacae6bca..ae93b30d25893 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -75,6 +75,7 @@ enum {
 	MASK_OUT_OF_ORDER_DATA_DELIVERY_SUPPORT	= 0x02000000,
 	MASK_UIC_DME_TEST_MODE_SUPPORT		= 0x04000000,
 	MASK_CRYPTO_SUPPORT			= 0x10000000,
+	MASK_LSDB_SUPPORT			= 0x20000000,
 	MASK_MCQ_SUPPORT			= 0x40000000,
 };
 
-- 
2.43.0

