Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD7E1E47BC
	for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 13:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730294817; cv=none; b=i6faLHUnlhj+EZrWHwHcgH/zAXgde7IgxS7pHkAwspGDsxdc3wMJrWE6ihrrPUSdV6jwdavUpap3/x/agQTtqnCRCQ72jTO+fYf40t0LysotVZEsfSCtA0LzrpKH5zegxSmx/XAb1R9Ddnrdc4grgzOdBuRn40gPjWPd0pdkE+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730294817; c=relaxed/simple;
	bh=ainmGEAe2nvxsKE3uvQszP5Qu9isSkOhSEr9wHzge2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8IOA/QBxMIEhwxEXDAJQInaDeT5IbyVM4yvwg/SbZ/RmYwxG3vXQw1jH12YJUbJpmRhDpyMVWplKXnhSpP4xPHI1NxbvalMilfQ3KcHBdIBS/FAQ2gOPE7qcqX9pPXOAHTjk+jakfW1H5kY3wNnRtViL8g/FSH+db4PByIYU94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IRuyzutJ; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IRuyzutJ"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4314c4cb752so63389365e9.2
        for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 06:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730294813; x=1730899613; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bzoMFJwewUJr88TLCzmafGB2re8jMyauaVwVQzw6WY0=;
        b=IRuyzutJOpgHKPIc8F65+3Dzj4F6QsXdLYsnARRL74s8AtI6/2f6OYsLb9AymF/BZy
         chd1ahZFl4PDtsH0S4UdOfe/5AEHkRpAYkpxKt8LTdUmT5I4jh1lw4daGdZgmgtzIJpH
         uGLWH8Z9o7qsij9BHEgvVSy/T4pZ688MSz6/A4c4YaKXlJDqwoyl+Qo+t1ZTKyPc8cVe
         TUxKCLfh2zWhE2qe33Kwul+vsUzFjd24STvHmi0r11hRc2IHqnAeZJio9WUQTN1qROJr
         4PgUN1pyBQ50Iqg2MHUVQOnDBkXKqalZJsfr3uEm9/07ADLNKSlpfWa7enNGC5RzeRR7
         5d5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730294813; x=1730899613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bzoMFJwewUJr88TLCzmafGB2re8jMyauaVwVQzw6WY0=;
        b=WS2RgQVwQ2FeQGD4BH3GAPr9JBJtkiCDGsjBuPIcPMgljvx4xnJJXecoGFdZ5gQnir
         GU2BcGPMoB/7Z/s7wUkvFxSJCOMJ2fyTOsEsLrECvXptnzAuWRsSoJYs66l++Y/j5Jk0
         cl8ByUQdZLqkcVRWJWuMwczbgPhv+kVGIDCSIi2xulKgSyUZrRCWmDK3AUcXTjqg1o8/
         iL6GoFIAyHlndXLxG3MkBfsC2PvGm37Cx0s/7+WW+JbdsEuwkwq0B5nSqwcjQQsnQpYS
         0cq9DkgQwZnK+RkBkofisfMArFNuso8iHd8ffJIwujIXBh+aaAt9u9gpZEUtrBGR59Pp
         7XGg==
X-Forwarded-Encrypted: i=1; AJvYcCWOeX8/RKNso8Upcn5LCfB20jk/Cwi0T/ozQMD1NpMoS9pF2wa56JWX5YtLYZ4OQzDxVnDBsO9MFfuq@vger.kernel.org
X-Gm-Message-State: AOJu0YzIpEivsaH+XqqmZO3EC5J7kfHqkEmE651ZdeJWvPF9WBqqDKG7
	V7Clq2FpBS+bCLDyRIJDsK4kNDhKBQD+8sfxpm4M2KQ4raiZQwtf964gf6BuSsE=
X-Google-Smtp-Source: AGHT+IHvCVDH97OPRIU78dk2sv1dUkZXYpRkqnVZcPXDtJpr/JmOXd9IkvC3KGa6t702TR8hj0iMNQ==
X-Received: by 2002:a05:600c:4f06:b0:431:5021:32 with SMTP id 5b1f17b1804b1-4319ac74308mr110456545e9.6.1730294813080;
        Wed, 30 Oct 2024 06:26:53 -0700 (PDT)
Received: from ta2.c.googlers.com.com (32.134.38.34.bc.googleusercontent.com. [34.38.134.32])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b3bdafsm15356836f8f.30.2024.10.30.06.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 06:26:52 -0700 (PDT)
From: Tudor Ambarus <tudor.ambarus@linaro.org>
To: alim.akhtar@samsung.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: krzk@kernel.org,
	linux-scsi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	andre.draszik@linaro.org,
	kernel-team@android.com,
	willmcvicker@google.com,
	Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 2/2] scsi: ufs: exynos: remove unused rx_hibern8_wait(_nsec) fields
Date: Wed, 30 Oct 2024 13:26:49 +0000
Message-ID: <20241030132649.3575865-2-tudor.ambarus@linaro.org>
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
In-Reply-To: <20241030132649.3575865-1-tudor.ambarus@linaro.org>
References: <20241030132649.3575865-1-tudor.ambarus@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rx_hibern8_wait_nsec was used to compute rx_hibern8_wait, but the later
is not used afterwards. Remove both.

Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
 drivers/ufs/host/ufs-exynos.c | 5 -----
 drivers/ufs/host/ufs-exynos.h | 2 --
 2 files changed, 7 deletions(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 91c09309c1c1..fd86252ab2ba 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -559,8 +559,6 @@ static void exynos_ufs_specify_phy_time_attr(struct exynos_ufs *ufs)
 
 	t_cfg->rx_linereset =
 		exynos_ufs_calc_time_cntr(ufs, attr->rx_dif_p_nsec);
-	t_cfg->rx_hibern8_wait =
-		exynos_ufs_calc_time_cntr(ufs, attr->rx_hibern8_wait_nsec);
 	t_cfg->rx_base_n_val =
 		exynos_ufs_calc_time_cntr(ufs, attr->rx_base_unit_nsec);
 	t_cfg->rx_gran_n_val =
@@ -1975,7 +1973,6 @@ static struct exynos_ufs_uic_attr exynos7_uic_attr = {
 	.tx_min_activatetime		= 0xa,
 	.rx_filler_enable		= 0x2,
 	.rx_dif_p_nsec			= 1000000,	/* unit: ns */
-	.rx_hibern8_wait_nsec		= 4000000,	/* unit: ns */
 	.rx_base_unit_nsec		= 100000,	/* unit: ns */
 	.rx_gran_unit_nsec		= 4000,		/* unit: ns */
 	.rx_sleep_cnt			= 1280,		/* unit: ns */
@@ -2050,7 +2047,6 @@ static struct exynos_ufs_uic_attr gs101_uic_attr = {
 	.tx_min_activatetime		= 0xa,
 	.rx_filler_enable		= 0x2,
 	.rx_dif_p_nsec			= 1000000,	/* unit: ns */
-	.rx_hibern8_wait_nsec		= 4000000,	/* unit: ns */
 	.rx_base_unit_nsec		= 100000,	/* unit: ns */
 	.rx_gran_unit_nsec		= 4000,		/* unit: ns */
 	.rx_sleep_cnt			= 1280,		/* unit: ns */
@@ -2077,7 +2073,6 @@ static struct exynos_ufs_uic_attr fsd_uic_attr = {
 	.tx_min_activatetime		= 0xa,
 	.rx_filler_enable		= 0x2,
 	.rx_dif_p_nsec			= 1000000,	/* unit: ns */
-	.rx_hibern8_wait_nsec		= 4000000,	/* unit: ns */
 	.rx_base_unit_nsec		= 100000,	/* unit: ns */
 	.rx_gran_unit_nsec		= 4000,		/* unit: ns */
 	.rx_sleep_cnt			= 1280,		/* unit: ns */
diff --git a/drivers/ufs/host/ufs-exynos.h b/drivers/ufs/host/ufs-exynos.h
index e64fe20d50c1..b7fe725c7f8e 100644
--- a/drivers/ufs/host/ufs-exynos.h
+++ b/drivers/ufs/host/ufs-exynos.h
@@ -144,7 +144,6 @@ struct exynos_ufs_uic_attr {
 	/* RX Attributes */
 	unsigned int rx_filler_enable;
 	unsigned int rx_dif_p_nsec;
-	unsigned int rx_hibern8_wait_nsec;
 	unsigned int rx_base_unit_nsec;
 	unsigned int rx_gran_unit_nsec;
 	unsigned int rx_sleep_cnt;
@@ -199,7 +198,6 @@ struct ufs_phy_time_cfg {
 	u32 tx_gran_n_val;
 	u32 tx_sleep_cnt;
 	u32 rx_linereset;
-	u32 rx_hibern8_wait;
 	u32 rx_base_n_val;
 	u32 rx_gran_n_val;
 	u32 rx_sleep_cnt;
-- 
2.47.0.199.ga7371fff76-goog

