Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D905E1BF33F
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 15:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730386856; cv=none; b=ZGo0p9tMvrERZLoBYGdKlkOC3BCzY+23HaadP8yTjmFIMxHAGQK80paQoMQcfSjiiq+0CGNfgyVLx4vp4SJovEH97iCM0HMbYCPx3gqLirpfXiiuHl5HkwZic97roAjxmmlNZTiuvDYJXF2bDJheUV4VvAVc6ifzXguJ8UM/8R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730386856; c=relaxed/simple;
	bh=DNXiPZZOPqqCGRsSUrJuQXwDPghQpinVVwrMRAUyp2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZVWArKiHDmO2IIoomKIw7hi7d5un3gfNPMKsA3sDLW1GfOI8O9Enb8ep+Q0FNSfypSpmaQDRSoaFAREKC5nlcT4oxLad02gLWwY18Xx6S9/OK11MT5u8CZY3QUmEHBc+M7jBI1BD3wr/5MEW7lFIX6IJIN5cgFMeqJ7v7DSDT24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rUj1qxSN; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rUj1qxSN"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-37d41894a32so613144f8f.1
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 08:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730386852; x=1730991652; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4dhr5+lgkwJp/4xdbeZNcQAzRLkNmuREPhlR8Kw0nM4=;
        b=rUj1qxSNBHbEup9MP2VYlTdX3/000FECbtikzv+E+ylkPhLwzEoDCv7mSMXHqUuIQJ
         WBmKOba/6DIYKQ/ZdX6+fDKeaYblSwpen45y04VqeZrXXy2xgMzHCwu+Mj0w7REyNond
         gJi044aH98HgkrFj8kaXsBigoBjtujjzfXwm7ybFG7U495nfPhXRmvlyIeWH9JkPSVTc
         Fq9BFmbzfXahWDcELSdsLXtUJlLZUFw+hBDgTWewnc5VBJe4SAMymBuIn4mVizG3a/WP
         Bcp3LxcrH2OEYdGY8OCpCm2BOkdT7ng8qFTGBeAMizyLcGoakJx4N1hS1gTkWVi8sKuD
         fXLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730386852; x=1730991652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4dhr5+lgkwJp/4xdbeZNcQAzRLkNmuREPhlR8Kw0nM4=;
        b=VcRdhN2ShvQIT8YETd4hc5hXc/RMV6S5FyIbzvBFwT/q7kwZ1SvRE1sC6DCe6oVdX9
         80WyzAxdO0kycJOfVDEbEqGfUumSn6VN+zVP0crKjWk0a5PFh4gbW7gOr0mYQHNBis9J
         3yLfWHb4vdW3VU/7bSvx8l/bva30PB+GvqsCFP/jcOfUSsCsAuLXFzNbiJ0UFZ8IW14L
         YED36lcvpo9ldEBbU33LX3VacQy7Gb+rFy+MsBykdEUvhfMRDTJJkEbtCQjpky/OZ0MI
         arov0k+K6jGYbeLRhZryVN5N9c+4pbgPJB+5FVkJhnnM2U/rLzaBUuxH6GjKLtLf0KHW
         Mokg==
X-Forwarded-Encrypted: i=1; AJvYcCWxw2+25cF8Sew2FEHQ3rL0eBl29LcG+TUnJTLAsrH48yrnPkHVEG2ZzkluuuzAbxki8V6uelIoqZLp@vger.kernel.org
X-Gm-Message-State: AOJu0Yx09NI6tiO7tNqUC0C1Gq88p3sMFZOzrxowjA9klhd1AYzx7VfL
	WSeWIemTihRWFjPEeJBhyqrzCJE5QuTC/avxgDYL0K/O1d1tHTYtB9aro6vbWLU=
X-Google-Smtp-Source: AGHT+IHKfc7pJ6Zm8piuDfmKaMIbjSaLV4oLGDh35XiuzbNsP65XFtHQ4OrcCPyxEHtqyv/uMEAbZg==
X-Received: by 2002:a05:6000:1566:b0:374:cee6:c298 with SMTP id ffacd0b85a97d-381c79e3662mr280380f8f.21.1730386851639;
        Thu, 31 Oct 2024 08:00:51 -0700 (PDT)
Received: from gpeter-l.lan ([145.224.65.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bd8e8524sm59163225e9.5.2024.10.31.08.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2024 08:00:51 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: alim.akhtar@samsung.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	krzk@kernel.org
Cc: tudor.ambarus@linaro.org,
	ebiggers@kernel.org,
	andre.draszik@linaro.org,
	kernel-team@android.com,
	willmcvicker@google.com,
	linux-scsi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Peter Griffin <peter.griffin@linaro.org>
Subject: [PATCH v3 11/14] scsi: ufs: exynos: set ACG to be controlled by UFS_ACG_DISABLE
Date: Thu, 31 Oct 2024 15:00:30 +0000
Message-ID: <20241031150033.3440894-12-peter.griffin@linaro.org>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
In-Reply-To: <20241031150033.3440894-1-peter.griffin@linaro.org>
References: <20241031150033.3440894-1-peter.griffin@linaro.org>
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
is a nop currently, it should protect us in case the bootloader
behaviour ever changes.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
 drivers/ufs/host/ufs-exynos.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 78307440107f..5078210b2a5c 100644
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
@@ -215,10 +219,15 @@ static int exynos_ufs_shareability(struct exynos_ufs *ufs)
 static int gs101_ufs_drv_init(struct exynos_ufs *ufs)
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

