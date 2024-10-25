Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201D120D506
	for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2024 13:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729862105; cv=none; b=UsFq2ggzQ2Mei3D3WTEYlH0VdoCmkOWz193im/Z8p5sCohmCaGDxLoIANA+tAEfkHDqWQACxZ+zAAYLJgwEat/3K9vcFEL90GJyg5OVWZMDVuMj4aKIqX3vJEpFXZYDjdcylzzRJITwqkaymst5TENruTO1AaY+J8jvkMgc9iq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729862105; c=relaxed/simple;
	bh=KgknpPj0iOoQwiAH+NqX1OZF6SNzI/a1pt2l/tElo20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZFtpRxQLdwGmf8Gx+T1jgcpESHZT9DzI2B/SqbTM8sbqwH0mdDm7Q+qhcO6+7UqUXhxk/o7+yURHyYR4vxhxwtuC5cKI7xFIr9YhMYTrq4+wBGejcpYgWlt4H5tOMdqVDgYQ6aSQ2yavMGeKEM4WPdBbXnTvtaM6cLpQW6lkOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RXESPEVn; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RXESPEVn"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4315e62afe0so20833975e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2024 06:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729862101; x=1730466901; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hwJALAAeKO6DZ5STVB6W3oZmi4qjYoxF/2Uc+rthKgs=;
        b=RXESPEVnCDqturQkxU4EWOC1dqwlB1am6qoIjk7u03VDNraJt8fqOn9gXYhr+CVxR+
         P9Gnu72DI226tr61oTtjG/EAD29pS9Mam/M5jHutfrsRgigkY5QM+Cg1WLMd2VmH/L2e
         a5Xp5Lwn6rBBUUyBW2CJFpp24cTvtK3hPCsQuNxTfFF2rMCd7Txll+37a+JmkLGmDo/d
         Oo/miWICCbIiOkxGHT4NfEX1nCiBSTloDXgR7gYAT0KrTQReUiwL54cTMAYwgTp8XWmN
         l+F7OA1yaOLNyfVUIGyWfe/mmExlRUmeNb77R/wifw/v8rWELRAwV61rLhvM+HxI/4rV
         QaNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729862101; x=1730466901;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hwJALAAeKO6DZ5STVB6W3oZmi4qjYoxF/2Uc+rthKgs=;
        b=YWjB7tv6zQFn5lvvjlFgCvmMqMJplN9htEiCJJY7v07CTy2kYTfWrtVCZup7MAmGyl
         L851xIBCWvXXLpQOX9z4x81tnpIvMZx8+qVXQJHlnPrLZ2c17Qj0uiEko8wVmabQICC9
         QrJO8nDLk88Oobtv85Unm1j8DPPZyf+N7eODMd+dLItZwpIeJVSk1xrF7a1FiuPdGIMs
         1L2tVp6QF21eV3pPAWEf/nxsHRajR9KmHK2/lyW9v4yKyjU5RZJ174fxgBzknPTGr9mQ
         +5zV/MaGkZvpuT3PONEvYjgLtjWN6J2Sq+8CAQ6wTmU2Nooo6X7IQ+IZPNJEdGp1yRFa
         tLqg==
X-Forwarded-Encrypted: i=1; AJvYcCWqBeP36tNO59jeoZkxC/CE8+mU/PMwYHCQR57jgZpOLg7Kkn+WTpvpIOEwuxlSWB6/Inor7ATwfSQd@vger.kernel.org
X-Gm-Message-State: AOJu0YzTe6lFA0NutoLxFqGFFVOEXQycDveahJQHhgcjYf8HxNSwqw8p
	RiDG3yovUGy8Url3YxJl8eoELgsul66fYhCblYYU4HNOMZV3SFSMvq3bA3WFH1c=
X-Google-Smtp-Source: AGHT+IG93PjcVz+7+9Ks5a4tZOcJmfpGpRSJSrp4oHNgenqx8uAoLySbtv12lhSPEbntHZWJ76vNhQ==
X-Received: by 2002:a05:600c:1d8f:b0:431:5bae:c600 with SMTP id 5b1f17b1804b1-4318c780d48mr50376755e9.34.1729862101341;
        Fri, 25 Oct 2024 06:15:01 -0700 (PDT)
Received: from gpeter-l.lan ([145.224.67.228])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4318b58b6bdsm47616685e9.45.2024.10.25.06.14.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2024 06:15:00 -0700 (PDT)
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
Subject: [PATCH v2 09/11] scsi: ufs: exynos: set ACG to be controlled by UFS_ACG_DISABLE
Date: Fri, 25 Oct 2024 14:14:40 +0100
Message-ID: <20241025131442.112862-10-peter.griffin@linaro.org>
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

HCI_IOP_ACG_DISABLE is an undocumented register in the TRM but the
downstream driver sets this register so we follow suit here.

The register is already 0 presumed to be set by the bootloader as
the comment downstream implies the reset state is 1. So whilst this
is a nop currently, it should help with suspend/resume.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/ufs/host/ufs-exynos.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index b0cbb147c7a1..fa4e61f152c4 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -76,6 +76,10 @@
 #define CLK_CTRL_EN_MASK	(REFCLK_CTRL_EN |\
 				 UNIPRO_PCLK_CTRL_EN |\
 				 UNIPRO_MCLK_CTRL_EN)
+
+#define HCI_IOP_ACG_DISABLE	0x100
+#define HCI_IOP_ACG_DISABLE_EN	BIT(0)
+
 /* Device fatal error */
 #define DFES_ERR_EN		BIT(31)
 #define DFES_DEF_L2_ERRS	(UIC_DATA_LINK_LAYER_ERROR_RX_BUF_OF |\
@@ -220,10 +224,15 @@ static int exynos_ufs_shareability(struct exynos_ufs *ufs)
 static int gs101_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
 {
 	struct ufs_hba *hba = ufs->hba;
+	u32 reg;
 
 	/* Enable WriteBooster */
 	hba->caps |= UFSHCD_CAP_WB_EN;
 
+	/* set ACG to be controlled by UFS_ACG_DISABLE */
+	reg = hci_readl(ufs, HCI_IOP_ACG_DISABLE);
+	hci_writel(ufs, reg & (~HCI_IOP_ACG_DISABLE_EN), HCI_IOP_ACG_DISABLE);
+
 	return exynos_ufs_shareability(ufs);
 }
 
-- 
2.47.0.163.g1226f6d8fa-goog

