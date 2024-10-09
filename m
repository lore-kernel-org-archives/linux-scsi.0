Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B611E49F
	for <linux-scsi@vger.kernel.org>; Wed,  9 Oct 2024 11:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728472917; cv=none; b=K4P03XhXVQEFEdrBuR16GhVjIVZcqlDxlj4zLpu9GZOtUFMg0w546i1aYV2bS1RUJKgn0jxgV/phEu/lM/peaMsUA2f7PWKM6FEGZdh/G3G0/vs9PJgrOEgSaG9uWwtZVt1P69OnrAuFBzYObgf0cHQhT5em/7T2c3IiavySAH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728472917; c=relaxed/simple;
	bh=V1Ebg28xAJMkAH3vygTav0+GVnN5eEH442ZJFTo8Z9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTnmSnB4bekMlcD8PhGUJTYaG3LgVHVNcobRfyQjKM6mlJw8Z4fHqCjd2NeoAudV6r/2z0SSCMKxC/0/OhMHg38LYrd0AK/gLMXVuMVgCYqNWhD61+pPjx6CjaX3eviO6a7ueT7x8hjVLz9zAo2Vxkv0uuggvNtHquCVGmkEzWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DO2Ojuj0; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DO2Ojuj0"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-37ccebd7f0dso4359375f8f.1
        for <linux-scsi@vger.kernel.org>; Wed, 09 Oct 2024 04:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728472914; x=1729077714; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LGYLAi4JF+h9/4Hxj8IqsekpEDYHXMIX8LJHajmfJfQ=;
        b=DO2Ojuj0dao6MyKQXmXDhTTqLYBCHZDd2zuVMxWnSafY0uF+sRJFJxnar8sUrZwz4A
         XI5vuuRSC0T0pJgy9CScXzg0EHPtyESHmgezpBJ1yRmXjuFKWg1J5fgo68rne3p0Ixdo
         CMZnQIEtTxbNmB2nHYDzVYhJXWnUkCwaLZnPrQs46A41RlWAQlHyME2H/vOOnDobGpVq
         UZJ0sYt3qREPkpYJzTGmFzp/3rT7bYmQifY/0+9JMe2QOPr0Bh73vFbD2Drr5ZoklgkV
         FwU9b4GISmIgEbuhkGC9+DfdTDnQogNAA6cDItHOUvFzSEKLnxfOh/IeGhWmYp/L6LQc
         w9Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728472914; x=1729077714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LGYLAi4JF+h9/4Hxj8IqsekpEDYHXMIX8LJHajmfJfQ=;
        b=H0UozHntjfDY33fwKXjuXTtWNuff86uDQOSV81w4mdP2vcXZnZFU9kAaZEA7k8MpXX
         sJQIow8Nt44bdnrpreUw07oLicLlqFvAdyW9ScttCBQ87M3QGY5H3zXar8bZIKEL2fhT
         sIp5m3InbtVYeHrsT4y3RXJINtCqDyscIKnb7HbBS+naV9jEbcev/aKWkZiw20hhdr6f
         PwZHBXzzNVMbqzBCnk1s1bxL837sTAVzP4CFkOp1PXdH7u/1Hht5dwII0bow9nRHAdF/
         9Ryqrh20Vv0q9yuzu2QjvJqXDDz+DXA45/wX6AmrHe5z+cWg3jcjjSDwfq3/ffGCnLB6
         avyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWd39IS4xACE+8eFGccNI0sRlPD13iMcdY2jRqbu2DcpK+2T3bvwuXH/RMD1PA6Y2lm7lqsdDaJ/NCD@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/C+8RK/0lq18ZC7zHrpVb91HvijmFYvLRcNHGoW3ClaZiPZiK
	DiFF3o0AZgvsxWcrrXVIHEyoWWF7ChtezaymcEUnmBJjIsVW9BcdGZtbCXPKk9Q=
X-Google-Smtp-Source: AGHT+IGdWtb+G4uTKWkGy+SLP7YhXIty2nIIk9lA4K60gde3ICkfsbfdSfZOvGEFpFCgPGCfowuJqw==
X-Received: by 2002:a5d:5e0b:0:b0:37d:3e8b:846f with SMTP id ffacd0b85a97d-37d3e8b84c9mr844904f8f.24.1728472914307;
        Wed, 09 Oct 2024 04:21:54 -0700 (PDT)
Received: from gpeter-l.lan ([145.224.65.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4310c3dcdcbsm12331445e9.0.2024.10.09.04.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 04:21:53 -0700 (PDT)
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
	Peter Griffin <peter.griffin@linaro.org>
Subject: [PATCH 3/7] scsi: ufs: exynos: gs101: remove EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL
Date: Wed,  9 Oct 2024 12:21:37 +0100
Message-ID: <20241009112141.1771087-4-peter.griffin@linaro.org>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
In-Reply-To: <20241009112141.1771087-1-peter.griffin@linaro.org>
References: <20241009112141.1771087-1-peter.griffin@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This flag is not required for gs101 SoC.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/ufs/host/ufs-exynos.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 939d08bce545..d685d3e93ea1 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -2142,8 +2142,7 @@ static const struct exynos_ufs_drv_data gs101_ufs_drvs = {
 				  UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR |
 				  UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL |
 				  UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING,
-	.opts			= EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
-				  EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR |
+	.opts			= EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR |
 				  EXYNOS_UFS_OPT_UFSPR_SECURE |
 				  EXYNOS_UFS_OPT_TIMER_TICK_SELECT,
 	.drv_init		= exynosauto_ufs_drv_init,
-- 
2.47.0.rc0.187.ge670bccf7e-goog

