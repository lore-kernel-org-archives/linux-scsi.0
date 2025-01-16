Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AB022B8DF
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2025 14:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737038973; cv=none; b=nJeX0SBdKXdxH+/KprdR2mcf3IF605oufg1M+6KZ1GcNUEvS/YB0cWjNbYI12mnwGStBxpZV6Nm3zIPWDxJExLayKFehLeRMLzAcRrKB3jH0VY1UqIRW66j49Nx8fUb5U3FrQHG8jGtY3JPQ6cMaT8eNuiPKfA9ND2do0pSun2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737038973; c=relaxed/simple;
	bh=mMqcSmFFvw2TkkbHF0Z/tBSpa/sSu9tnGHtQ8tATY60=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cPR6UFi8uNwEy11E0VGUexYGZXFeoIPMdk0qmXSJlnfFuWkABHpF5CUTddnC3xzgx40nYwfGhKWzdsnfAb4BmMe6+lz23XzeMd4gevXySDnBnCB448QUFqMYiE2QuQKetLI3ppt8whqXEDzYFqeCS3+dQ4jz47bTQBJZMvMVc3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=klpmnC8R; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="klpmnC8R"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3862b40a6e0so625377f8f.0
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2025 06:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737038969; x=1737643769; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3VDvVHb7Hz9aOiJJ+fFlf31oRvekJW72ufAgH10hVdw=;
        b=klpmnC8Rc29mih5tU+C64KE486W9gvyUUxMcSb97BRBkhino/vFeLzUI8xBK0L38PU
         rsDc0fEadxBOI8D7Lsi8p3zd7fGZ9LN7/zPnEXYFG80/3km/cFgrMoNWt4dcqTUoauLM
         fIt7I8wSz+iOMWpgpjGWqnBLUYpQ2gELlTV/rJaG9XNdx3hp8Zo1XHdK/E6RbcGimMsW
         fsNpZlE4YpPp89c8WycXOK7qeqeui/tGTxRT+5CqSwF6pnIcarc1gQ0+1Kg+OEJyQG2D
         WpbACsVqQz9XusnUwJDRTQAh1iqKXCKdhYvniLrFnLVD/ylonoTL90TX9hJJ4sbCZMte
         UWNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737038969; x=1737643769;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3VDvVHb7Hz9aOiJJ+fFlf31oRvekJW72ufAgH10hVdw=;
        b=qnWWChEy981McMp+7SYUmbw9k50+ppQTu3LtZr/FxQNYEHs7OOzyJx1LoSoZnO1DSe
         CxawSm6llQRuTvAPQlvdbxBJvaM6FjkYDLZ2MsEBZ370rmqUq/7n+K0jwSiWCcfS7bsP
         oier8/hDDHaqEG1WYN81fZPiG2nCvEWrxlZ4wpybH89aazc+3KPB9k5nCy4bIKxfpjYg
         hxxDNbjB09+khfG/JUhAtzaVLARKD+bEOlyVupCfyKDA/iONYL+9aF+xiiUi7NByF4xw
         +OaTEGYK/0k6O9dkLxHEib0hBmvpoLChtQ1geEnrMY4gr/6JXaSp0cIedWkIIhnEzYo5
         DEHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVoLJcg7LfA4R8TkhCL3n5B7PkfB9W5X9ubd0tTp3qCXEVitEnpK37/h3as+2NsmT7TQKg0YpcDK1/3@vger.kernel.org
X-Gm-Message-State: AOJu0YzoUDBm2wHmuh8ObxEKwoBYQsm1g6gsMqw3uBtdO05x1T+N1Iwa
	4rL9dxS8CO2DcqRFPYHrUz9VfH+TloMmia1lfQWIA2oB9JPHDLE/CQqIdMCjzIs=
X-Gm-Gg: ASbGncsV1cuGNvgvcQfg0avg3PJmH/brXKJ5dcseXBKjcZHTtga7D3KZw5/GzcoTVfd
	sPhGKQRJcDVwsglkB8+kgI8XHOdMFCpGvzRKsCUzeC+0tvkhkGm3RzfDjNGUD9grH2PwMFAUx9f
	Ph8fo3WU4h1IY9ov3eKPVlhfAhSf3ug3mO+4icEOW/NXyQS1jbNk6yH9k2Gk1vk2LX0M3MARZN3
	FQaFdS1tQF6cK5jazuoFZum0PGurowJtTYsQzjRLpFZJuLtNFeZ9+8JNBaMncVWg7qqnr/ch1KG
	tah1B6YPbzJbvw/NawqKOmRjCyvThlg0vhl7
X-Google-Smtp-Source: AGHT+IEYjm37I0xC5oyYW1bza4Imter6m0Ap3ye3A3KaXLIpUrnXkIdWfDmQraHXh7LXwIvTqWenkQ==
X-Received: by 2002:a05:6000:1862:b0:38a:41a3:218 with SMTP id ffacd0b85a97d-38a8733899emr28060936f8f.36.1737038968835;
        Thu, 16 Jan 2025 06:49:28 -0800 (PST)
Received: from ta2.c.googlers.com (169.178.77.34.bc.googleusercontent.com. [34.77.178.169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf321508esm70310f8f.10.2025.01.16.06.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 06:49:28 -0800 (PST)
From: Tudor Ambarus <tudor.ambarus@linaro.org>
Date: Thu, 16 Jan 2025 14:49:07 +0000
Subject: [PATCH 3/4] scsi: ufs: qcom: fix dev reference leaked through
 of_qcom_ice_get
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250116-qcom-ice-fix-dev-leak-v1-3-84d937683790@linaro.org>
References: <20250116-qcom-ice-fix-dev-leak-v1-0-84d937683790@linaro.org>
In-Reply-To: <20250116-qcom-ice-fix-dev-leak-v1-0-84d937683790@linaro.org>
To: Krzysztof Kozlowski <krzk@kernel.org>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 Ulf Hansson <ulf.hansson@linaro.org>, Abel Vesa <abel.vesa@linaro.org>, 
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Eric Biggers <ebiggers@google.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, 
 andre.draszik@linaro.org, peter.griffin@linaro.org, willmcvicker@google.com, 
 kernel-team@android.com, Tudor Ambarus <tudor.ambarus@linaro.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737038965; l=881;
 i=tudor.ambarus@linaro.org; s=20241212; h=from:subject:message-id;
 bh=mMqcSmFFvw2TkkbHF0Z/tBSpa/sSu9tnGHtQ8tATY60=;
 b=ckw/p8Yr8OAqf94ouXfHUwYbbzLskOGYomyFslWm+iFcOpDzJC0mlpKDWKk8wbQ91TJMNb+5E
 nC9f+glXfEdCGF3iseCm7YkfK5PJU3TI7PKc9l6rqwoy5fHLepwJFWH
X-Developer-Key: i=tudor.ambarus@linaro.org; a=ed25519;
 pk=uQzE0NXo3dIjeowMTOPCpIiPHEz12IA/MbyzrZVh9WI=

The driver leaks the device reference taken with
of_find_device_by_node(). Fix the leak by using devm_of_qcom_ice_get().

Fixes: 56541c7c4468 ("scsi: ufs: ufs-qcom: Switch to the new ICE API")
Cc: stable@vger.kernel.org
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 23b9f6efa047..a455a95f65fc 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -125,7 +125,7 @@ static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 	int err;
 	int i;
 
-	ice = of_qcom_ice_get(dev);
+	ice = devm_of_qcom_ice_get(dev);
 	if (ice == ERR_PTR(-EOPNOTSUPP)) {
 		dev_warn(dev, "Disabling inline encryption support\n");
 		ice = NULL;

-- 
2.48.0.rc2.279.g1de40edade-goog

