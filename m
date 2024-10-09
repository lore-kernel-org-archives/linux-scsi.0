Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C79192B7F
	for <linux-scsi@vger.kernel.org>; Wed,  9 Oct 2024 11:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728472919; cv=none; b=Ub23xoKFELJ/sbUdBnmnlIyoDq2aN+AE0xTw7oK3K1J/W9F9eSbD1qsXrTLi0AYiAICnq5yTRhueF2FLg93ZeV29dyszgSDUrdB3U1uwFhK1sGodlbu46ozTNtZdBNVS7Oets7AY1eJAHI8OUllfxp5RI3Ofcz8gHKr/mt4xySQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728472919; c=relaxed/simple;
	bh=yvSPo+u1rV9HCdDx8VvGiSquc9UOwDhjQSc6U8bRi3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWcP9BDlHBYjjtvqRVPhvqRTEMNkt6tghNIUiSKGQZCuIanrOv+0nXP0EmXdITdUflAAZKZE1fB5yB/WkVN02gNTu6z6bSoCxHVeODcYfs+OAjuLNevgoHlbbrdtMlONJma+hwuBcqPRqzLNcTzxto/O7m0bDDRRlZBye1hA7/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hJJJtK2T; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hJJJtK2T"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43111cff9d3so4344195e9.1
        for <linux-scsi@vger.kernel.org>; Wed, 09 Oct 2024 04:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728472916; x=1729077716; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pX3tu4r0T8hfLp3m76HchWclu4+8PXIAtD51r7i7hmo=;
        b=hJJJtK2ToIINMmy7T5IzRmvKFZ8vJ0bLHloukDrCxJqYjErmVZVRvsOUZQOxmBfIVu
         P1aSYQx83VAY6T0LQVR9+O9NcL+gMw9KPPpKiVP7QyxyQTNN1TyKOwQ0Ozkf81QL2Ql1
         YmOcFQO1Br33DnhTJxf8m+oz37pQsxy1Z37Y0y/NYYFuNHKWHLBuPh5Y9VUDwNoeveTs
         gerPXzPW80+8JiuvNddfxAuYcROH8pGfR4VhL2Ogk/lmtT8MhToFbJjLw02edmiUIDvV
         u9dfy3GGEA6qQ1j906eQ1E0ldBGO8/l5FAju0ha9rTIpL9EFuzKfjoWiUiWZG6hzUmpg
         UOmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728472916; x=1729077716;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pX3tu4r0T8hfLp3m76HchWclu4+8PXIAtD51r7i7hmo=;
        b=CozvC1pobfg+HCwK9oCl7PwkjbBjex5dJ7JcDBbCBOfC+ubm/B3Y5gVT0pARpQnpa0
         VA6gY6zj4FjCtwC/nmEuNo/SeLwev49/LVpEr4kHhoh3jwlzUwf0wu4uTTnIWPMalrKz
         QW4RueH4feEExCWRDNPItVqP8tt2l0jj7wrYsvXvOYC0V9bW3s0LEiZjJ7nK4rjpG2rX
         zgx0z7CEWBOnlBUgldTvHb+MN0x8XVQuUIkFCI1CBGecKIALjHkTgxz3yyoTyivZ87Eh
         nZz+aACcmXk9ObQH2knsePhanBJ80UJMN9i8K26G0ez57YOg++IrIhcrHA8P++HDyz9q
         HD0g==
X-Forwarded-Encrypted: i=1; AJvYcCWxJGHtR1Bv/yytqwbivp9yDfQQatK+ElmxaC3cZ8bcMHRWx1e6xgGEyiUzViiwxCE72tBULDr9AzYC@vger.kernel.org
X-Gm-Message-State: AOJu0YymfPFlGPYPxBLzGfLMCq+XygsTtWrWgsJPMpDo3tjx5lzFXHeI
	4Ya6y9Hkp+GdLI8uMp2qkV1FIObd4oH6oM1/h6PfIXmdz+vj8xyo0xEhJl6Jt7A=
X-Google-Smtp-Source: AGHT+IFlZ/wsuxYNG5Un8P/i6V6t9CA6cih0ZKz2NoHn5swbiS3uEf9ML/RKj5myS1RUufBKpr7pTA==
X-Received: by 2002:a05:600c:3b12:b0:42b:afe3:e9f4 with SMTP id 5b1f17b1804b1-430ccf08948mr14280075e9.3.1728472916015;
        Wed, 09 Oct 2024 04:21:56 -0700 (PDT)
Received: from gpeter-l.lan ([145.224.65.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4310c3dcdcbsm12331445e9.0.2024.10.09.04.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 04:21:55 -0700 (PDT)
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
Subject: [PATCH 4/7] scsi: ufs: exynos: Add EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR check
Date: Wed,  9 Oct 2024 12:21:38 +0100
Message-ID: <20241009112141.1771087-5-peter.griffin@linaro.org>
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

The values calculated in exynos_ufs_specify_phy_time_attr() are only used
in exynos_ufs_config_phy_time_attr() and exynos_ufs_config_phy_cap_attr()
if EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR flag is not set.

Add a check for this flag to exynos_ufs_specify_phy_time_attr() and
return for platforms that don't set it.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/ufs/host/ufs-exynos.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index d685d3e93ea1..a1a2fdcb8a40 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -546,6 +546,9 @@ static void exynos_ufs_specify_phy_time_attr(struct exynos_ufs *ufs)
 	struct exynos_ufs_uic_attr *attr = ufs->drv_data->uic_attr;
 	struct ufs_phy_time_cfg *t_cfg = &ufs->t_cfg;
 
+	if (ufs->opts & EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR)
+		return;
+
 	t_cfg->tx_linereset_p =
 		exynos_ufs_calc_time_cntr(ufs, attr->tx_dif_p_nsec);
 	t_cfg->tx_linereset_n =
-- 
2.47.0.rc0.187.ge670bccf7e-goog

