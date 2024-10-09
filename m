Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A5719342F
	for <linux-scsi@vger.kernel.org>; Wed,  9 Oct 2024 11:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728472922; cv=none; b=WHBlz9hv5bcexrIyAtPj6MgA/CBiEwx4nAggR+jqK7SaECoPCANMdIYBq3iA09/XqCJpx8Z1eDxFGgcAcnmUmyBOJROGAQe+mamMdipw7LwG+7QnpLuB1NKIoc8BMCPlCiQJ7JjecFnpX4/l0EvJMQa1E0H3ew9gK6r1VjaMxnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728472922; c=relaxed/simple;
	bh=JxNG6eDRQStONM4tz52v0Ck91QG+AO2DWVUc9ANCsYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ip517HPeVLXDouhda3Ihkok8YbqdspVxYmr+sE1ZE5HKsaU+glBz9dFSmQEiZILtxpIzAFLnBEFVe4X4vbFHJ3TC+qVaIMaP9veNxAumeGDo8kKyt+1fxqvg45BJnR1i6PHAFgxQ3YQ8+ofUZwkmb3n3D9dMFBckCCN0/U5Gl8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nIvYHbmL; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nIvYHbmL"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-42e5e758093so59448135e9.1
        for <linux-scsi@vger.kernel.org>; Wed, 09 Oct 2024 04:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728472919; x=1729077719; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2DpEnA3YplEcQFI6shVCtQMIfbctSRU8+HvPgo32UcY=;
        b=nIvYHbmLfZgeRoYnHLkBTeImPy14vEevv0QP7RkkwhOXCB8s4qH18Fc39DtzEjNLBl
         I7NG22DlWetJq6E5CzfvPpstkCLGdLFSJ1JA1Yp27fWIi/wddvVUkClD/SovTnVsGzFG
         Iqlf5j2E2zZsojo3SkoNHr+AtK6PrfccKtDHAvsDvs/z8FEsVrYoJmbEJU5BORWduXB0
         9ZEkJbpFj+Uor+/+SKx3KK9UH+welIL4EhUo3vI6QHECtx+4i2LeF5NR9b/v8j5cYpiH
         w2Ii4tqJMQBv9I0O3h85MiD1YRcaY7zSe+kGczQn8AjOeEb98CdkbTGigikj++THgdaq
         +mWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728472919; x=1729077719;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2DpEnA3YplEcQFI6shVCtQMIfbctSRU8+HvPgo32UcY=;
        b=APHBIGX0C7FgfMMa8ILmJlKHr/TkM878ZWLpSGrcY53tbPVKoGZApWpNgKmBK+dLYe
         zkuX4cEzjw+bviFfmSllSGjQnJiXSYbIHQ4o8SuYlNN0fZpJvAihgRnKFDkrJKJ+h2Kx
         PZNhw6XBfgEczUqK+popTNTTPY4XDZ8NbcqXEja+lkCOXp8QgNhh5iumjk99SHEgZsF5
         tnE8eimiU9PtGndei5FCGh/+As7XwMBN1aDaVXLGAznueHc1lx8MpXgNrS+4CQy+wYF6
         fDbL4Ia+6n7TUCA+/PMB7zzWlsUkjNIGm7dxC19+JEkhqjyPU/ZbFf0HtSS8En8PivPg
         Sfuw==
X-Forwarded-Encrypted: i=1; AJvYcCWuzUaorOwNWJ/AWObY9Jk4r4tK+klw2DcHN7q3HG1KEYuHowBTs4f9fiKqeKF1ekJ+dtpf5/wc0Aj/@vger.kernel.org
X-Gm-Message-State: AOJu0YxVTyfcPMaRvPrI0yurMf5l8L7APSs4hMiHYK0XV9DVWL0XMBmQ
	rzFuXy3Rhp0l/13MVvTmWW0iGcbCVb3ePy7a1Hm/Vz8+wUwiHEuGXb9mamJ81G8=
X-Google-Smtp-Source: AGHT+IGuNlqf0UjHLa+gCSHuJwmN6aEEWrwupvo8fc+pj3U1PFfl1qX4v/XDeaScMudS3KJA7vTNzg==
X-Received: by 2002:a05:600c:4f48:b0:42c:bae0:f065 with SMTP id 5b1f17b1804b1-430ccf041a5mr15501335e9.5.1728472919068;
        Wed, 09 Oct 2024 04:21:59 -0700 (PDT)
Received: from gpeter-l.lan ([145.224.65.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4310c3dcdcbsm12331445e9.0.2024.10.09.04.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 04:21:58 -0700 (PDT)
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
Subject: [PATCH 6/7] scsi: ufs: exynos: remove tx_dif_p_nsec from exynosauto_ufs_drv_init()
Date: Wed,  9 Oct 2024 12:21:40 +0100
Message-ID: <20241009112141.1771087-7-peter.griffin@linaro.org>
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

Firstly exynosauto sets EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR so setting
tx_dif_p_nsec has no effect.

Secondly this assignment can't get executed as samsung,sysreg dt property
is provided in for this platform. Meaning the execution flow will return on
regmap_update_bits call above.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/ufs/host/ufs-exynos.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 9d668d13fe94..d4e786afbbbc 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -205,8 +205,6 @@ static int exynos7_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
 
 static int exynosauto_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
 {
-	struct exynos_ufs_uic_attr *attr = ufs->drv_data->uic_attr;
-
 	/* IO Coherency setting */
 	if (ufs->sysreg) {
 		return regmap_update_bits(ufs->sysreg,
@@ -214,8 +212,6 @@ static int exynosauto_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
 					  UFS_SHARABLE, UFS_SHARABLE);
 	}
 
-	attr->tx_dif_p_nsec = 3200000;
-
 	return 0;
 }
 
-- 
2.47.0.rc0.187.ge670bccf7e-goog

