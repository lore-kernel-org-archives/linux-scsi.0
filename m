Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B2E1917C2
	for <linux-scsi@vger.kernel.org>; Wed,  9 Oct 2024 11:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728472912; cv=none; b=WlpDOkGYhJs+mp+B3+uA3pskyk2C8iylgDKz2exxMwUcMLYTJPD0+vumDre7Mb4W4i0brJuG2AYO40qMFa+Iy3DLBLp52oLQAJ4Dhu2LeZpz/k0+Mn762iD8O6U1B45BZhQ8Y5eSROXQj11AUQlPUQWu5/uW2A6370LQRJMDIvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728472912; c=relaxed/simple;
	bh=8Ta2irAJVrZFbYoIJnnVMRr5FuTvKb6h0nr7nS2ZqFM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ftr4iSz69AlKiWUppi/FGjutJfx3HO/uKD4beJLNl9rWoZ0hg2T9LlLYfelNKZ1ggCi/hcDz8ySLx+Znml/Cq+6ZgKo0/wDdBRdzp/9UVCfPdrFV4jxjRYQFfxLpkpfFOuLMkkXiTqiL3qwb9Y4MM3A2wy5n6gIekU3b7QeWKu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BbffMFq8; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BbffMFq8"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-42cb6f3a5bcso89501555e9.2
        for <linux-scsi@vger.kernel.org>; Wed, 09 Oct 2024 04:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728472908; x=1729077708; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=w8bEMX39HCQ7oypxWwVa6yTzZiCgPg5rGUasi0elpSc=;
        b=BbffMFq800NiTAFBtMnXJz5xwy/BkiVTbbexynvvhl2p2jwSrSBFN9xEFW1VylLr33
         8GarsTABEQZF7FYlCBYd8tor4RMnVmdZknXPwvsD35E3xb04a/d8xkQKfH27x3cZbBM5
         KPJiiLYlC7JO/Z4oS4xqpViIUI8S86AXeYf3R2XVV6LDZBWghhV9dJcWr/O9EA4t0jFl
         ok23zZi7pVUAqi/5ZKO5lsdQpQxzDMJr4ouwU6Xm3NV4MuiVdGRCjulU8S6uWjUTz974
         tDnMVbPKKKSQ0N7qD9Tb8N4058b+hbh+x5IcLkgv7oyui6mx4QLBb4XKsOqlnsrSi5Vh
         h+Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728472908; x=1729077708;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w8bEMX39HCQ7oypxWwVa6yTzZiCgPg5rGUasi0elpSc=;
        b=UeWUOqDkYKKC4CyaQ3ltqjtUxDE+FX+l4hmz+wUehvnnHKyWjkbtUBEnrQz5oYDIRA
         QEYU61shigW/gkN0ZHG9N4XY8C3opdx8VnWNZBApIBMMpMZwmp20lyTcyJmYziW363IP
         uVKeozVsFRKG8rjO1OLzRZXFirSVYPdL/5U22Yw6FhaG9UfILEGraX+b6PjwQsThle5e
         LJO4fycSAC8YBBFEYrZmRdFZ7wlU6MWGV4Ye2P3d5rBEdD6uWTSZIohDNky3VROKShMW
         D1AW1vwksFnjTkX25BPZcJEzhVFk8Qm/i+fytcBI2tySY9/+FqURmcvEBW/JRaVQwARV
         iYIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWECcIm0p1qx6Bc+hL/02vx3UPlMGLBTFdupYWHfL0kcGwj1vYvolr4WvvYtruCpP1L3stQ1le1XAl@vger.kernel.org
X-Gm-Message-State: AOJu0YwfUoXvfcHvosagO5l4z6xlBhIWMHSX5PtR/Q2Iu9ZXI7mXvl+9
	h/Rv44AA4xh5epT2UI7KKrcZG/dcTBLQLEsa0XOY/CBWk4lS6viMLg4Trhm7mwE=
X-Google-Smtp-Source: AGHT+IFlsSsUBahib/8ngPAeagyTEBcN/biFoRNJET9VKN3gwYg6BtDzYVe/x/rkxByCtgvcRZdRrg==
X-Received: by 2002:a05:600c:3551:b0:430:570b:4554 with SMTP id 5b1f17b1804b1-430ccf04213mr20828715e9.3.1728472908472;
        Wed, 09 Oct 2024 04:21:48 -0700 (PDT)
Received: from gpeter-l.lan ([145.224.65.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4310c3dcdcbsm12331445e9.0.2024.10.09.04.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 04:21:47 -0700 (PDT)
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
Subject: [PATCH 0/7] UFS cleanups and enhancements to ufs-exynos for gs101
Date: Wed,  9 Oct 2024 12:21:34 +0100
Message-ID: <20241009112141.1771087-1-peter.griffin@linaro.org>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

This series provides a few cleanups, bug fixes and feature enhancements for
the ufs-exynos driver, particularly for gs101 SoC.

Regarding cleanup we remove some unused phy attribute data that isn't
required when EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR is not set.

Regarding bug fixes the check for EXYNOS_UFS_OPT_UFSPR_SECURE is moved
inside exynos_ufs_config_smu() which fixes a serror in the resume path
for gs101.

Regarding feature enhancements:
* Gear 4 is enabled which has higher speeds and better power management
* WriteBooster capability is enabled for gs101 which increases write
  performance

Note further patches in a separate series will follow to enable
UFSHCD_CAP_HIBERN8_WITH_CLK_GATING once the phy hibern8 interface is
settled over in [1]

[1] https://lore.kernel.org/linux-arm-kernel/20241002201555.3332138-3-peter.griffin@linaro.org/T/

regards,

Peter

Peter Griffin (7):
  scsi: ufs: exynos: Allow UFS Gear 4
  scsi: ufs: exynos: add check inside exynos_ufs_config_smu()
  scsi: ufs: exynos: gs101: remove EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL
  scsi: ufs: exynos: Add EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR check
  scsi: ufs: exynos: gs101: remove unused phy attribute fields
  scsi: ufs: exynos: remove tx_dif_p_nsec from exynosauto_ufs_drv_init()
  scsi: ufs: exynos: add gs101_ufs_drv_init() hook and enable
    WriteBooster

 drivers/ufs/host/ufs-exynos.c | 73 +++++++++++++++++++++--------------
 1 file changed, 43 insertions(+), 30 deletions(-)

-- 
2.47.0.rc0.187.ge670bccf7e-goog

