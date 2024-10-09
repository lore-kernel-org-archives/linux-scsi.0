Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2892191F7F
	for <linux-scsi@vger.kernel.org>; Wed,  9 Oct 2024 11:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728472914; cv=none; b=pxlOqGuGEM6jq/WBevRlFVntUJ8rlUXTAVydizlA/Vkj9f8JltxofnNmKmo+OUWoFa1X/LEbyFZVmS5ZphpGnPV9P1+LhVmeKgcyA5y/cgpEaUScWeHFaOuvEdru17qxHKfWDy7bBoGQ+CPyjiArC28Ffu4J6pIR1ZULpj2PYpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728472914; c=relaxed/simple;
	bh=hDzFSe1lRi4yyuPHSIaucwMqr2mLXU7tOlTPgv8XUzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rxfvVs5yMtkeowiNsDK5VxLfREygfnJlXj6TVRSjDtHyASUeq4693IqLeZMzMKoKIvQ2GcyCo20G+qJrVH201sW23qOh3+0lfT/WPy0BUSqCzhFG4b0RSaWmWAjaVS19sWQGnsrfV5pv+nFJJ3lyXG14+kyu+svp+KCEhweldQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bNnL24xU; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bNnL24xU"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43111cff9d3so4343665e9.1
        for <linux-scsi@vger.kernel.org>; Wed, 09 Oct 2024 04:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728472911; x=1729077711; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ghtUYLBlSjf3IggEwHExig2CKcpoS8dsJVFld1RzVuU=;
        b=bNnL24xUF+gpLihMlmHw7IUZziKucfwCEJ1OvruipQ+p+WQ0tCe5xMA6UP3zi0ptx5
         XTlw6h7d0HQBGFcJ5qqIryMpDt7WleHdfQ8YaN3mGy7+UEcqcfJPCNM8oDEtUOU1sNt/
         fmS+NxZkOkKsIgQJZDsYJBkg+a8mnQFQfhxMA/tzdGt1yggopRmy1KOeIYSgp+9ZH+zx
         PzjmYoFGaTTVEVrrIFy1Ghkm4t1aM02WVZYwOXzs0Sve5fXFCoTJB/9nXRt03FbaT2wz
         Gaicrk5LbZOoiDdGzY+5n59zPtqwhkXDYN57wRTTZJHpMMQqcxro03nfl2ObAdNmtCku
         bUyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728472911; x=1729077711;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ghtUYLBlSjf3IggEwHExig2CKcpoS8dsJVFld1RzVuU=;
        b=A/+EtFopVq34Rg2ekC/W2tKyc2egAQ8R2uBZfaeW16GXqLXnBPlKBOwILhb7pYj8Af
         IYYa4M5tVPleCus95eQmti88Vx/lJJ1gpsdcL++unHpV/eMOG+uWne9ISVKtuovmpSMQ
         m+b2FRtwHOgpM6Bv4HcSooPXS9c7EnRxLyNm+lg2A5DkcIjHe7jL780VqHnCpjDt+0ga
         ZaUvS+nqMZbjlnUj7L+skYibFhzFoYf8yQAWIHUf1+2LY+CSDkyFq0vTKIPrX3sfeHcG
         hsoW7WO5Y6nxNZ7o5TqQJbWWfGobS/FHb4FtM1HRCvZFvsuClruS8kmODQyqPZYfdQxV
         ZI6A==
X-Forwarded-Encrypted: i=1; AJvYcCVJkalTKMxvBaFcpU9TvMP8I519muali4f0KZofwesgX4evrgi5WFKVRqE+/UZRl/+lePJlUT1DRA1G@vger.kernel.org
X-Gm-Message-State: AOJu0YzLWWjgD9wDkG+iMTyLl+QrFjmc6Gp3cCDakURz6ZH7cUbigCRn
	tOReTDfpPvUwO6yfiiVXZmHQAcPxg79pT/zeOcGG8fN/GCjVYvxq9kdS1xxFhyQ=
X-Google-Smtp-Source: AGHT+IEJX2RjpFeLUHsr4Qx7o7zdf3TWL+5xxAUSFTySxWEYnSA6UXjwYDBXPN59NyQNksavaCy8pQ==
X-Received: by 2002:a05:600c:3544:b0:42f:7c9e:1f96 with SMTP id 5b1f17b1804b1-430ccf091a7mr14596575e9.1.1728472911183;
        Wed, 09 Oct 2024 04:21:51 -0700 (PDT)
Received: from gpeter-l.lan ([145.224.65.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4310c3dcdcbsm12331445e9.0.2024.10.09.04.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 04:21:49 -0700 (PDT)
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
Subject: [PATCH 1/7] scsi: ufs: exynos: Allow UFS Gear 4
Date: Wed,  9 Oct 2024 12:21:35 +0100
Message-ID: <20241009112141.1771087-2-peter.griffin@linaro.org>
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

UFS Gear 4 offers faster speeds, and better power usage so lets
enable it.

Currently ufshcd_init_host_params() sets UFS_HS_G3 as a default,
so even if the device supports G4 we end up negotiating down to
G3.

For SoCs like gs101 which have a UFS major controller version
of 3 or above advertise Gear 4. This then allows a Gear 4 link
on Pixel 6.

For earlier controller versions keep the current default behaviour
of reporting G3.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/ufs/host/ufs-exynos.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 9ec318ef52bf..e25de4b86ac0 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -771,6 +771,21 @@ static void exynos_ufs_config_sync_pattern_mask(struct exynos_ufs *ufs,
 	exynos_ufs_disable_ov_tm(hba);
 }
 
+#define UFS_HW_VER_MAJOR_MASK   GENMASK(15, 8)
+
+static u32 exynos_ufs_get_hs_gear(struct ufs_hba *hba)
+{
+	u8 major;
+
+	major = FIELD_GET(UFS_HW_VER_MAJOR_MASK, hba->ufs_version);
+
+	if (major >= 3)
+		return UFS_HS_G4;
+
+	/* Default is HS-G3 */
+	return UFS_HS_G3;
+}
+
 static int exynos_ufs_pre_pwr_mode(struct ufs_hba *hba,
 				struct ufs_pa_layer_attr *dev_max_params,
 				struct ufs_pa_layer_attr *dev_req_params)
@@ -787,6 +802,8 @@ static int exynos_ufs_pre_pwr_mode(struct ufs_hba *hba,
 	}
 
 	ufshcd_init_host_params(&host_params);
+	/* This driver only support symmetric gear setting e.g. hs_tx_gear == hs_rx_gear */
+	host_params.hs_tx_gear = host_params.hs_rx_gear = exynos_ufs_get_hs_gear(hba);
 
 	ret = ufshcd_negotiate_pwr_params(&host_params, dev_max_params, dev_req_params);
 	if (ret) {
-- 
2.47.0.rc0.187.ge670bccf7e-goog

