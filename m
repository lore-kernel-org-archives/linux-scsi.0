Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87462157A46
	for <linux-scsi@vger.kernel.org>; Tue,  9 Apr 2024 20:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712694131; cv=none; b=LCKS1C8Rwk6+CNbhDE21xTuHeqKQH3/PXDMWth1QTd8vRKyXGx7jxjOFVwXdE8R1bMqksvFk/u4cbVeRWoYDixiQG6bpYmEmnpNPUKoUfiVUYwXCChzvt3vmNt8AlLR5NpNMFkhprfzSV6BMHw5xUSxAinswkh/IDigb6s9AXpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712694131; c=relaxed/simple;
	bh=LP0AE5/PUtGSyLNbe3rFEA3/mjUNWVbbofmFlYStYaU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=SIwYRiw48ZVwucOKViUG1AaIMfFm32KzbqLhZnbDUSbPeZOCHyCwexjeadmpyLvaVHdEzeD8qY/lzbl7poDiMYcSFUFKhplqPl7mpeJ+cqP6KOXdndsve/1FKD83jo2rn1sB8ImQ0dUlDjtqY9bkFKSF7iIujc5ulHy/tsm+cNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--willmcvicker.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qIOjafEK; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--willmcvicker.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qIOjafEK"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1e2a5cb5455so62016195ad.2
        for <linux-scsi@vger.kernel.org>; Tue, 09 Apr 2024 13:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712694128; x=1713298928; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=li70RG4leC6BXT61G6ins6TrGephnT1pmJh8LVW4448=;
        b=qIOjafEKF6gK2ACResldhYXO7ScfyaQDN/R5/AHjQTsIxMM7a+h/lSRGt/+riBXOIk
         dIvXqdOB6KJ0PUiPPWhtVzdmb+dng41tdpnlTKg4POjY2Er/dMRfdxPCPlFvXw9E+omD
         dr0SL8WlomT3H6IGm4FKdSewRmAe2+3AxJLiCBfxIMfBjOVUlyMcb9u3IsRZXq7CeqTS
         wvGHht/7ec1kaKEgyTUCJD3mBIAD5JBKqEibO1eNFigUsOCSsAX1lif+jY22SlGXJBvO
         s1y8wpVsJwsqZiPZHY0Gmgc2Nu1Flwdd4d5c8VvYVKn8BqJ2QIQZ43aTt+CKMsrQCqUN
         fcQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712694128; x=1713298928;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=li70RG4leC6BXT61G6ins6TrGephnT1pmJh8LVW4448=;
        b=mmIpE1uJv2DeQYXvn7Q4XfIZQeWzRMn5udxDRwoKHRA3jr3DKoANjS9YJ7WXqmR53t
         BIRCYyCxyqPNdOKIEbtuHI1aq766tZWrDa/zjzYwmcE5/wFmm/rOHSxg2b5TCC3VtAhl
         Opxo93hV/ffmes7cAxxJPxtihJBHAtpxIXXx5fctmXQ6GcHcoJIyQLlzRjnONEkoNqTK
         zriMgjV/kj+JhrZFgfAxxkyuavl1vDghVWjPQ9mnki7NjYu0zTGnSmmaBgOmOsf2FnCq
         kdCRJ/2ezQNc2Q936SwbU8g/FffkJCrPHN8gr405jtgCGCXgbwzNvSQ8XEPlngyAZ6eU
         5Aqg==
X-Forwarded-Encrypted: i=1; AJvYcCWXsShosEu+WY+m5EW+YFXXG9mahXjVpLhoRbNV7UARvcwKDgnatAJ5k6xowlF732WQaUv61DrcbFAyyf7O6SIUY0SQ7IG3hYS5Qg==
X-Gm-Message-State: AOJu0Yygs/wPLnDpfQOBkpyYEDd7ky9Vyzf30QQtUvhOA6yCQ1C7m7Xo
	Una1mu+oYkmlXgQIqn0O6g/pAqwPg+/dHUGwVPpRTtxPz5nCMKW3/Mu/q8sqsO43gGEJl3Otk7g
	VcCOfe6eTwOyhL+QQkBShNEXKfA==
X-Google-Smtp-Source: AGHT+IFRUiwCI1bVLGrKHHupMeWnTyEsNBKU9AP3ld9A7X1GTUv6ZAcQK10ulcSFjVO9m9GOgSGuiYAPdF1BHs6+B/o=
X-Received: from wmcvicker.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5ebe])
 (user=willmcvicker job=sendgmr) by 2002:a17:902:f2c9:b0:1e3:e092:53b9 with
 SMTP id h9-20020a170902f2c900b001e3e09253b9mr29282plc.4.1712694127914; Tue,
 09 Apr 2024 13:22:07 -0700 (PDT)
Date: Tue,  9 Apr 2024 13:22:02 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240409202203.1308163-1-willmcvicker@google.com>
Subject: [PATCH v1] scsi: ufs: exynos: Support module autoloading
From: Will McVicker <willmcvicker@google.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, 
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Peter Griffin <peter.griffin@linaro.org>, andre.draszik@linaro.org, 
	tudor.ambarus@linaro.org, Will McVicker <willmcvicker@google.com>, kernel-team@android.com, 
	linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Export the module alias information using the MODULE_DEVICE_TABLE()
macro in order to support auto-loading this module for devices that
support it.

$ modinfo -F alias out/linux/drivers/ufs/host/ufs-exynos.ko
of:N*T*Ctesla,fsd-ufsC*
of:N*T*Ctesla,fsd-ufs
of:N*T*Csamsung,exynosautov9-ufs-vhC*
of:N*T*Csamsung,exynosautov9-ufs-vh
of:N*T*Csamsung,exynosautov9-ufsC*
of:N*T*Csamsung,exynosautov9-ufs
of:N*T*Csamsung,exynos7-ufsC*
of:N*T*Csamsung,exynos7-ufs

Signed-off-by: Will McVicker <willmcvicker@google.com>
---
 drivers/ufs/host/ufs-exynos.c | 1 +
 1 file changed, 1 insertion(+)

Note, I tested this on a Pixel 6 device with the UFS patch series in
[1]. With both this patch and [1], the ufs-exynos module autoloads on
boot.

[1] https://lore.kernel.org/all/20240404122559.898930-1-peter.griffin@linaro.org/

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 734d40f99e31..1795860a2f06 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1748,6 +1748,7 @@ static const struct of_device_id exynos_ufs_of_match[] = {
 	  .data       = &fsd_ufs_drvs },
 	{},
 };
+MODULE_DEVICE_TABLE(of, exynos_ufs_of_match);
 
 static const struct dev_pm_ops exynos_ufs_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)

base-commit: 2c71fdf02a95b3dd425b42f28fd47fb2b1d22702
-- 
2.44.0.683.g7961c838ac-goog

