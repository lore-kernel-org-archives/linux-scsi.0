Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D213231830;
	Tue, 29 Apr 2025 23:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745970629; cv=none; b=ZE3tsXgmyLtlYC6pN/Gqs1Si5pYfokdY7SiO75W9iPlV9HQqx3knPAf++3Ipv0z4PKM51wGGjqJdhzSjcdygfVfLU6vUIAfPkaHbTgHYGr0Brn+/StaPJtq6gd85Wbz3u1NMKYe8H8AtNIMvnnQlvqe+YSzh+gR942AMtjFfNIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745970629; c=relaxed/simple;
	bh=n8Mo3FjrkCxSyPzkxjmGAzGpSPy9FAU8ZZ09J5xHZIs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PUJQqvPqdWjz/pHKIUua8tEYngg8c6sEfoF5XODXGwFggWfxaaToOGU1qTzHNQ2TIt6GHw6KxrjtWxxg+jLkCAYk7wBC5H7Rp1kQjfMlCbX9tBcMv3/e8Yn3xRrW42v2BJTT5aK726XdE8t2TA9BoQM2MHmbt0T8nkULJXzJJpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eb+cmduf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eb+cmduf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3442BC4CEE3;
	Tue, 29 Apr 2025 23:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745970628;
	bh=n8Mo3FjrkCxSyPzkxjmGAzGpSPy9FAU8ZZ09J5xHZIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eb+cmdufOr9sQuP7acWX/moHcEqhh5nd1SYHRx+RkYldppaDEuYahsMQ65oflhX2k
	 Penk81HeAtNTQZka5jf8neckAMPT2rrMESwyPY6txDvz9K2OFLVy9furZGubkX4zdm
	 s38Aft8tgqCH2lfZrxm0b46zQ/i+KeljBB9QBrZXKZVQdclopiu992NBHLtz7Zg6rL
	 puwZa578WpliEujwNKFaG6onY4j9Z4ZcFblH2JvQjomDlOi6khT0EOxWZpqQuwETW8
	 P+5268UUBxNRoCniygg579zUvCy8m6ZdCJ+WXhbLx7wxwOZ/hPRQiyt5UOryAXZDuG
	 5mXq+iUetSwig==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Manish Pandey <quic_mapa@quicinc.com>,
	Bean Huo <beanhuo@micron.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	bvanassche@acm.org,
	peter.wang@mediatek.com,
	avri.altman@wdc.com,
	quic_nguyenb@quicinc.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 10/39] scsi: ufs: Introduce quirk to extend PA_HIBERN8TIME for UFS devices
Date: Tue, 29 Apr 2025 19:49:37 -0400
Message-Id: <20250429235006.536648-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250429235006.536648-1-sashal@kernel.org>
References: <20250429235006.536648-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.4
Content-Transfer-Encoding: 8bit

From: Manish Pandey <quic_mapa@quicinc.com>

[ Upstream commit 569330a34a31a52c904239439984a59972c11d28 ]

Samsung UFS devices require additional time in hibern8 mode before
exiting, beyond the negotiated handshaking phase between the host and
device.  Introduce a quirk to increase the PA_HIBERN8TIME parameter by
100 µs, a value derived from experiments, to ensure a proper hibernation
process.

Signed-off-by: Manish Pandey <quic_mapa@quicinc.com>
Link: https://lore.kernel.org/r/20250411121630.21330-3-quic_mapa@quicinc.com
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 29 +++++++++++++++++++++++++++++
 include/ufs/ufs_quirks.h  |  6 ++++++
 2 files changed, 35 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 464f13da259aa..cdd4fd9bb2d15 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -278,6 +278,7 @@ static const struct ufs_dev_quirk ufs_fixups[] = {
 	  .model = UFS_ANY_MODEL,
 	  .quirk = UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM |
 		   UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE |
+		   UFS_DEVICE_QUIRK_PA_HIBER8TIME |
 		   UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS },
 	{ .wmanufacturerid = UFS_VENDOR_SKHYNIX,
 	  .model = UFS_ANY_MODEL,
@@ -8384,6 +8385,31 @@ static int ufshcd_quirk_tune_host_pa_tactivate(struct ufs_hba *hba)
 	return ret;
 }
 
+/**
+ * ufshcd_quirk_override_pa_h8time - Ensures proper adjustment of PA_HIBERN8TIME.
+ * @hba: per-adapter instance
+ *
+ * Some UFS devices require specific adjustments to the PA_HIBERN8TIME parameter
+ * to ensure proper hibernation timing. This function retrieves the current
+ * PA_HIBERN8TIME value and increments it by 100us.
+ */
+static void ufshcd_quirk_override_pa_h8time(struct ufs_hba *hba)
+{
+	u32 pa_h8time;
+	int ret;
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_HIBERN8TIME), &pa_h8time);
+	if (ret) {
+		dev_err(hba->dev, "Failed to get PA_HIBERN8TIME: %d\n", ret);
+		return;
+	}
+
+	/* Increment by 1 to increase hibernation time by 100 µs */
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(PA_HIBERN8TIME), pa_h8time + 1);
+	if (ret)
+		dev_err(hba->dev, "Failed updating PA_HIBERN8TIME: %d\n", ret);
+}
+
 static void ufshcd_tune_unipro_params(struct ufs_hba *hba)
 {
 	ufshcd_vops_apply_dev_quirks(hba);
@@ -8394,6 +8420,9 @@ static void ufshcd_tune_unipro_params(struct ufs_hba *hba)
 
 	if (hba->dev_quirks & UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE)
 		ufshcd_quirk_tune_host_pa_tactivate(hba);
+
+	if (hba->dev_quirks & UFS_DEVICE_QUIRK_PA_HIBER8TIME)
+		ufshcd_quirk_override_pa_h8time(hba);
 }
 
 static void ufshcd_clear_dbg_ufs_stats(struct ufs_hba *hba)
diff --git a/include/ufs/ufs_quirks.h b/include/ufs/ufs_quirks.h
index 41ff44dfa1db3..f52de5ed1b3b6 100644
--- a/include/ufs/ufs_quirks.h
+++ b/include/ufs/ufs_quirks.h
@@ -107,4 +107,10 @@ struct ufs_dev_quirk {
  */
 #define UFS_DEVICE_QUIRK_DELAY_AFTER_LPM        (1 << 11)
 
+/*
+ * Some ufs devices may need more time to be in hibern8 before exiting.
+ * Enable this quirk to give it an additional 100us.
+ */
+#define UFS_DEVICE_QUIRK_PA_HIBER8TIME          (1 << 12)
+
 #endif /* UFS_QUIRKS_H_ */
-- 
2.39.5

