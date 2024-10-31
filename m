Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA9D1BBBF4
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 15:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730386850; cv=none; b=bRQvK2GMkyJ7NuUNw9USAW+NBh7yBRKuRYhmHcvVHBzK6WG2Ss7HJW+Tq+rS0KD3TiCtuw65X3j1APQ3aKOia+SlV6JwQXFBtnHstKKUPjRhqeR4m6fFvFcOMrMo3s9WdjuWyozTamGcDNTAnOTSJLSwafq/5Y8tSEKE7l/MDMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730386850; c=relaxed/simple;
	bh=ObJIfaZjIKHh2LbJ+suNUf2iHwIx5ihpEmFxKcO6q9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1GDLtSSxjBazktJA5pyWgSlOravN+4R0JKoNUY4p6kT8J+vrAWMqgIXy8IZxPbJGfcCHyPBaWY5L5Y3LZsihhUM64J0Y9Ga1gQL0VnGotJGn35IgI5BtGqXLXg/BuPo+ySZpUJLz8dfId9ZnEBBSDEfNYbDDSW3CoJCEtnxwNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Iod0Gc1w; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Iod0Gc1w"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-539ee1acb86so1077334e87.0
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 08:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730386846; x=1730991646; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EGlRIDiWOIW/oUdNVyUFBt1pPENWr+qbw5BPnPtDdZA=;
        b=Iod0Gc1wm9r/tQcEGZhbGPRtblLbczKj7gskXDcJ3XZLbdZld/ihcXeUkSDRT/3HFB
         1bWh00Z8fT2bP/irD/TvwZXSxTxyNYUsJrO7VRuWqmYANtoZCSMycbnEvceRqUzWBfn/
         LEax47MJ+OIQxdiQL6pnEPdlpNgzEnsiYdfgJwQJ0ugd1t9DUX2xH1FQzNS5knIGU4rH
         zoT2+0c0g9yBP/4/8ffPeDIt1NJkxZKrs1V0X7FgJK1u1+QQpbcyZScZ13+SNyUnN5+a
         sF0A9NWYYefZZAOn+3RpTMmlpbUm77/1RfdBfVUBNUl1h47tGExQUcM1mPD0WNQrlhOX
         6myA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730386846; x=1730991646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EGlRIDiWOIW/oUdNVyUFBt1pPENWr+qbw5BPnPtDdZA=;
        b=AV5XEw1RSBm3JV9K/QtbDBmQpIanpt0JIShwQWTj4NzHKMyg37xVBDcB6MQTTQK6uo
         awdJsA+FV4hXFKKoXlwlUrE9AJKxSb9QkDJn9vQ57Xh0WdrR3U0gHVir9nAgmcPbY1CV
         M5jqoet7KJw/YhAazyqSkAwJ46RGAjzHLWVWKtSl60iY4HsW1FkOQ5T0CAjTqgRqgIFk
         5Mn7RiMFuKluyKHDM4wMOx87VbAiMcJNyaLDgeiUyxcH5FDiuFxtF+VdzFUGaimP8IL8
         zLdTeSo7poaoRvaBxA/87Z5/SL0BBmHn0/suDdm5m5qTN5eRhK9YczVMK81Qn6UBT5yI
         zOlA==
X-Forwarded-Encrypted: i=1; AJvYcCVnxml/Xc+W6NfetOrOU9aCl6AOXuJTOaSqV3/nPIatWRX/a43f9+pd1GGAqY2EWBQ/NasN4gpsiRD1@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/nejSt1Fq6wFL40PLtznxGf3ACmADhjl0YuEKGIFJp1ce9aAN
	40fdLkCE7mAEr1o8/hR77l+CF1XYc1zl9mDQmfZ4V3+qVo0xl/VmdW2ZV0Ojf0I=
X-Google-Smtp-Source: AGHT+IEXzbBlOP0V8hZQy8KaxBb5hcC2ucoOBrtqsnAW7CPkAU8t5qtuC/NhFTjTUjwZ36RRBVibJA==
X-Received: by 2002:a05:6512:32ca:b0:539:93e8:7eca with SMTP id 2adb3069b0e04-53d65e02513mr162912e87.35.1730386845937;
        Thu, 31 Oct 2024 08:00:45 -0700 (PDT)
Received: from gpeter-l.lan ([145.224.65.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bd8e8524sm59163225e9.5.2024.10.31.08.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2024 08:00:45 -0700 (PDT)
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
Subject: [PATCH v3 07/14] scsi: ufs: exynos: gs101: remove unused phy attribute fields
Date: Thu, 31 Oct 2024 15:00:26 +0000
Message-ID: <20241031150033.3440894-8-peter.griffin@linaro.org>
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

Now that exynos_ufs_specify_phy_time_attr() checks the appropriate
EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR flag. Remove the unused fields
in gs101_uic_attr.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
 drivers/ufs/host/ufs-exynos.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 0ac940690a15..e477ab86e3c1 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -2064,26 +2064,6 @@ static const struct exynos_ufs_drv_data exynos_ufs_drvs = {
 
 static struct exynos_ufs_uic_attr gs101_uic_attr = {
 	.tx_trailingclks		= 0xff,
-	.tx_dif_p_nsec			= 3000000,	/* unit: ns */
-	.tx_dif_n_nsec			= 1000000,	/* unit: ns */
-	.tx_high_z_cnt_nsec		= 20000,	/* unit: ns */
-	.tx_base_unit_nsec		= 100000,	/* unit: ns */
-	.tx_gran_unit_nsec		= 4000,		/* unit: ns */
-	.tx_sleep_cnt			= 1000,		/* unit: ns */
-	.tx_min_activatetime		= 0xa,
-	.rx_filler_enable		= 0x2,
-	.rx_dif_p_nsec			= 1000000,	/* unit: ns */
-	.rx_hibern8_wait_nsec		= 4000000,	/* unit: ns */
-	.rx_base_unit_nsec		= 100000,	/* unit: ns */
-	.rx_gran_unit_nsec		= 4000,		/* unit: ns */
-	.rx_sleep_cnt			= 1280,		/* unit: ns */
-	.rx_stall_cnt			= 320,		/* unit: ns */
-	.rx_hs_g1_sync_len_cap		= SYNC_LEN_COARSE(0xf),
-	.rx_hs_g2_sync_len_cap		= SYNC_LEN_COARSE(0xf),
-	.rx_hs_g3_sync_len_cap		= SYNC_LEN_COARSE(0xf),
-	.rx_hs_g1_prep_sync_len_cap	= PREP_LEN(0xf),
-	.rx_hs_g2_prep_sync_len_cap	= PREP_LEN(0xf),
-	.rx_hs_g3_prep_sync_len_cap	= PREP_LEN(0xf),
 	.pa_dbg_opt_suite1_val		= 0x90913C1C,
 	.pa_dbg_opt_suite1_off		= PA_GS101_DBG_OPTION_SUITE1,
 	.pa_dbg_opt_suite2_val		= 0xE01C115F,
-- 
2.47.0.163.g1226f6d8fa-goog

