Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4802E1BCA01
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 15:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730386852; cv=none; b=YXDHIUnFZM5HxEZ0+YQ4JjrvUG/c7B+JNLOCDKPFTQtcZJl3zd5AoOOX4DOtTjCj6xvOPEkQUbjXEYVsXeIDMK/V3EgPCbQPLbJJ6aroOsyMw+OZH4+5q78rO9iDvPRMxqRdZpNAw5yrz0/zgLOGwUS0WVCfBfLpabZ+Byr2KQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730386852; c=relaxed/simple;
	bh=W5vmLTxbqbRWektRkfu8sRg+KXRkgNHrmzi/8ND27KE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nn6824eZ2R3L0XcBqhNlJSZQQY7nNJZLt/uR2aIL/KOy/W4O+tHOTJQ05+TnUiwjQ59Nnl2Po2hj0yfwQxXCaqNmPrOhbzH7tdgOjMDaux+YVLJOTAUVztNhUtKzuIn2pJYirr8VScmAh8VtRZfu1s2aTcpfsXRAJoEZSKcSLWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KsoZYNCZ; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KsoZYNCZ"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43168d9c6c9so8633515e9.3
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 08:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730386849; x=1730991649; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CdJwrtv6R6hjXktx6QL/5y82lOaBKNXG+b2XzR89bZE=;
        b=KsoZYNCZgP8wc3K1q2K1VZEbwM4W/gnGpfabkAQkSRXxVExXORzTt0BGnhvqOtk3pG
         cDHd19p0xHF31ZdUTdlqawR/5FBn10bGGMHXVwQEBiVbL5MKadNJzka+tnCaNTon1VTU
         TnjL8Oai2klrUpQzPBYj9kcFt39vpezaOxakmvDRXs9Lq7b7ubmyiIgK2DYzhe2+ndoy
         M4kr8FaVEw7Z1IXqDj7HkDMlblAlLtWb9HvcoXzAPVyLEyNrbnDRA2rAzorSBe8pY7Bq
         CyQOQrOMUdS5+H7OtP7xJfDzugJ99l3M1HwoJSnyRyRh7aos39SYkGuTRL3zsAZCKN8w
         eL8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730386849; x=1730991649;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CdJwrtv6R6hjXktx6QL/5y82lOaBKNXG+b2XzR89bZE=;
        b=KwNttVKmashpH31nP1G4sy30KofrEGAQM+WpT/MYzRqK6tDYYDEYLt71fSni8fqv05
         UYTiyGI3TyrujaDi5dfdklBsyKSgpJJ5/S3SQLQOaizf/USYgXoGOGz3tuZEG7azm8wA
         l0VtAMIPa/TGvUp91I4lAnw43fyCfxxWu25D2ulWhkpXmOXVQZwiaj2Od0kknhw4U8Yw
         YiP2tQWC3L9DKx5zLZdjFUk0yots0eo7C5icSv53d/Be8AH0ZzJCYlw/13Af47gcipm/
         iRRfG+rgYaUbuF7ocR+5xsR8oI9GGNgI3cO1zqbIimXNAH2Msr9Ef0Yb093qC3lCipRM
         bz8g==
X-Forwarded-Encrypted: i=1; AJvYcCUNgmO8eLOs9rWphDygSIw2XkKPSpGjAugsIaKWYDKK+7orDH599Iw7AVhi/PonPvLA7fmzFXVqfOQV@vger.kernel.org
X-Gm-Message-State: AOJu0YzpBf82cshFIwBAdQ0PR8kHhs80Lp9Jz8/FFN9ZN+ELx4SWX5ps
	EDZj5jlehAzXYgTYDMm23I8qlLb/L4LnQr4T/oD5m0mc3N9CYRl2e58WZIN3bLc=
X-Google-Smtp-Source: AGHT+IGte4mqUxYrFCHTiw7rYYrBl9FrCw5E7TjmHzs9HacaVeMVUjhzif1Rg3DaulCZuAOdHbN/KA==
X-Received: by 2002:a05:600c:45cd:b0:431:5eeb:2214 with SMTP id 5b1f17b1804b1-4319ad363eamr152298075e9.33.1730386847155;
        Thu, 31 Oct 2024 08:00:47 -0700 (PDT)
Received: from gpeter-l.lan ([145.224.65.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bd8e8524sm59163225e9.5.2024.10.31.08.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2024 08:00:46 -0700 (PDT)
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
Subject: [PATCH v3 08/14] scsi: ufs: exynos: remove tx_dif_p_nsec from exynosauto_ufs_drv_init()
Date: Thu, 31 Oct 2024 15:00:27 +0000
Message-ID: <20241031150033.3440894-9-peter.griffin@linaro.org>
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

Remove the assignment of tx_dif_p_nsec as both users of
exynosauto_ufs_drv_init() function (exynosauto and gs101) set the
EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR flag meaning that tx_dif_p_nsec
has no effect.

Additionally both users also set the samsung,sysreg dt property, meaning
the execution flow will always return on the regmap_update_bits() call
before the assignment.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
v3: update commit message (Tudor)
---
 drivers/ufs/host/ufs-exynos.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index e477ab86e3c1..378c16d905c1 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -200,8 +200,6 @@ static inline void exynos_ufs_ungate_clks(struct exynos_ufs *ufs)
 
 static int exynosauto_ufs_drv_init(struct exynos_ufs *ufs)
 {
-	struct exynos_ufs_uic_attr *attr = ufs->drv_data->uic_attr;
-
 	/* IO Coherency setting */
 	if (ufs->sysreg) {
 		return regmap_update_bits(ufs->sysreg,
@@ -209,8 +207,6 @@ static int exynosauto_ufs_drv_init(struct exynos_ufs *ufs)
 					  UFS_SHARABLE, UFS_SHARABLE);
 	}
 
-	attr->tx_dif_p_nsec = 3200000;
-
 	return 0;
 }
 
-- 
2.47.0.163.g1226f6d8fa-goog

