Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661E5231C91
	for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2024 13:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729862104; cv=none; b=hekbF6xgYnRdWOAbZEPPt1kafloEfUfrBeD5SLRIwMwxqnlQ30ouhBFbVurF2m66ZtMjI2o+A0AzeqMgG+036TcwRfSLnCcacga2BL2uHtg6uASF/Db1khbRjQNkbajy/mUG7HXmaeS8Uqzsu82Chk5pxwk0YX2yNNxvos2okt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729862104; c=relaxed/simple;
	bh=Kbtu/Jwk87kTVLdVAMrWCkkXYYLx9gjrujo0HVB2Blc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cl0ROUQLgWN4b2gHNUY9b3SRzNZK8jyXdda0YI4FMqLg6BzRwosT7o4TnAtHb9o9JOBklex2c6/yN07Wypd7ey1XSaswGy7OqNH7Z0NW91S9Q8REfhCoIb5KWWAcsyhj+qwQ9JcIDjmVzZroHqzA46CAeVqbSMJt7crddgHNfWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wcvBNRsk; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wcvBNRsk"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43162cf1eaaso26612035e9.0
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2024 06:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729862100; x=1730466900; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Db/7vYWfVTvRELCJjsaav3g2wtQjNY/cZ7wO3qNfos=;
        b=wcvBNRskRcTbVz+u/17RThq3mHMTXmE/xDb7lwfY2yWovzZ81Z/v0WNfhU7UvhgYJH
         ZaJ+U1mx1DDVbgRSLYLD2PYvPO3Kq5/BkdcPzaetgBZmY3iatG6EzHG77HBCzlS8lj8j
         Q06o0UGoGshPVT5d9sNdxoxgPRSH02GHGGTllvxZaJXFWtkqecuPM4vrKL9hmTDMS+td
         x+y8XRAYQ2mqHur1q0Xe6GKOF2uZVy4cGY9YhG7YNUjUeJHzl5UJVOoVuJsZzIpA19mi
         BuLypD4nHD4+fe3iKY3JrVT6UlNjPUTOM9Ui48Yl0YKwVxuPnDkidrotOZdRC7cfw5T3
         iJxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729862100; x=1730466900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Db/7vYWfVTvRELCJjsaav3g2wtQjNY/cZ7wO3qNfos=;
        b=M6TJ+8wBs7WdXMXS9hYYs0g6+dOkUFNwHQILJgCGsek+UPmSK2wVSRldF1c3jsngkV
         FaFkZIN2ad3ZMP8K9A195X1Mt+ID85KM9GF707j9MGaEVRaQ9tqdU4zzXG2+2hLYcBvr
         7BJcAsghvTq/qWOF5xnQnx7izbA/opiWGZRJi1oPNSfEsi2vWX7uPoIl3azQiQgIoG/3
         gsIaRTRUtxYSPJE7b/dfgrNyfikqPBjky5re7jWe2T7qU5PYJXtXuo0wuEXV+YPuS7G7
         61bmaYDHqffIsXPfJakhzaIAMTFyy4rL3mVt3EgGSXuZEzDyQzNjR5SylaI4FnRE5uxc
         hywg==
X-Forwarded-Encrypted: i=1; AJvYcCXGFRkgkTrsx90JuC9em9LjDrW6TsZ//AXSbdDBLZ72aPuqld2nIZRyWtJCCb0SXE5AFLU8V+NuZkhM@vger.kernel.org
X-Gm-Message-State: AOJu0YyWgpyW+mdrJqxFVvVAliCFNyrim94RIDLcyCqr2n5EgklLe0Yx
	VNrgzI715Lk6tFF7YDWpT1zZaM5wqhrusys87zN01TG6hYOZHDLnACHoQ7ubIF8=
X-Google-Smtp-Source: AGHT+IGy7gCwHmZzWRjYuJdLjKUklIvRll7qzxjTVKsdjpMsJu9lcX39EllePZe+fyuRleAhBbilyQ==
X-Received: by 2002:a5d:4441:0:b0:37c:d1ea:f1ce with SMTP id ffacd0b85a97d-37efcf15f1fmr7504792f8f.25.1729862099741;
        Fri, 25 Oct 2024 06:14:59 -0700 (PDT)
Received: from gpeter-l.lan ([145.224.67.228])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4318b58b6bdsm47616685e9.45.2024.10.25.06.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2024 06:14:59 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: alim.akhtar@samsung.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	krzk@kernel.org
Cc: tudor.ambarus@linaro.org,
	andre.draszik@linaro.org,
	kernel-team@android.com,
	willmcvicker@google.com,
	linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ebiggers@kernel.org,
	Peter Griffin <peter.griffin@linaro.org>
Subject: [PATCH v2 08/11] scsi: ufs: exynos: enable write line unique transactions on gs101
Date: Fri, 25 Oct 2024 14:14:39 +0100
Message-ID: <20241025131442.112862-9-peter.griffin@linaro.org>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
In-Reply-To: <20241025131442.112862-1-peter.griffin@linaro.org>
References: <20241025131442.112862-1-peter.griffin@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previously just AXIDMA_RWDATA_BURST_LEN[3:0] field was set to 8.

To enable WLU transaction additionally we need to set Write Line
Unique enable [31], Write Line Unique Burst Length [30:27] and
AXIDMA_RWDATA_BURST_LEN[3:0].

To support WLU transaction, both burth length fields need to be 0x3.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/ufs/host/ufs-exynos.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 40b2563fe011..b0cbb147c7a1 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -48,6 +48,8 @@
 #define HCI_UNIPRO_APB_CLK_CTRL	0x68
 #define UNIPRO_APB_CLK(v, x)	(((v) & ~0xF) | ((x) & 0xF))
 #define HCI_AXIDMA_RWDATA_BURST_LEN	0x6C
+#define WLU_EN			BIT(31)
+#define WLU_BURST_LEN(x)	((x) << 27 | ((x) & 0xF))
 #define HCI_GPIO_OUT		0x70
 #define HCI_ERR_EN_PA_LAYER	0x78
 #define HCI_ERR_EN_DL_LAYER	0x7C
@@ -1925,6 +1927,12 @@ static int gs101_ufs_post_link(struct exynos_ufs *ufs)
 {
 	struct ufs_hba *hba = ufs->hba;
 
+	/*
+	 * Enable Write Line Unique. This field has to be 0x3
+	 * to support Write Line Unique transaction on gs101.
+	 */
+	hci_writel(ufs, WLU_EN | WLU_BURST_LEN(3), HCI_AXIDMA_RWDATA_BURST_LEN);
+
 	exynos_ufs_enable_dbg_mode(hba);
 	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_SAVECONFIGTIME), 0x3e8);
 	exynos_ufs_disable_dbg_mode(hba);
-- 
2.47.0.163.g1226f6d8fa-goog

