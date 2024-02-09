Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088C61B7E9
	for <linux-scsi@vger.kernel.org>; Fri,  9 Feb 2024 21:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707515442; cv=none; b=T5UDfNLjUvTVf58peSnKXIrGlFHO2iCfxkz0YXdlCNBTZo1aIhN41ASVdoZojMuXY2tCQTwvz7TlhpXPnPhvt3RiE0st9TOFLQ41J+cI/Ag9RMbdNYaZhyDLFWNN3pZ0KM6fLoKHBjPyqzqpbAzsbgzlnvbLtgGGYV4f+WJjmgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707515442; c=relaxed/simple;
	bh=+sh35SiDz43Be9QOkvS4z1KDQSnZwszEyuZbCIKMEwo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=q+0WHf6EdAXnoVNKNSnYEMXRLN7YooNqJvBC8yTFg6olqakLSt+zcF9O+PIXw5h25yriZ/hi9osA7vlQTvCy/fAnkhOil3R4LG22WY5el/O5SrSlnlaqazVoDj+Zdio3SJ2KXDs26XCN6tq8rRcVC0ojZDQXaQSWp2cBq/xiSys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Oq6JCpTa; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Oq6JCpTa"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2d0e5210151so1542811fa.3
        for <linux-scsi@vger.kernel.org>; Fri, 09 Feb 2024 13:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707515439; x=1708120239; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7EAiUDLF3fClB5a1Gd3kFGd1tv/eV96vnJDqGRKqYA8=;
        b=Oq6JCpTasM5AAYQJ3x46O58cc3UMdOGdxGlmOVc6PSSLLnzANrhGmhkiUwGBfr6oBM
         ajz+xiMhx3vpmGUwdQjoFHhPtu7HYj0O7zRGEkl9ZGt9aI6qX1TsEvlyi2YA8WHlE6VK
         ukBSlm8LnWtUnk9eIQ7oNynkLXg2Qk2BQwfttuwPM8T8IcwFuhXSoXhJrzxaXRzwM9tW
         hsJRlliYqRupTXOGXbDzeiyiyRxiFeZjGvicW6PZDDUZAaBp7Cmgo2QX/aMb4AZ5QPN0
         7aQacrKg9zOdLOCQxQbyiEmqalTQsAHTNo5kpkbDIIgxLxfM1HLd1y8CNIJCRwGh+CrI
         ZSRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707515439; x=1708120239;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7EAiUDLF3fClB5a1Gd3kFGd1tv/eV96vnJDqGRKqYA8=;
        b=wl8FwR+AvfYoX3IqqWRxE56MmUSGYZgwqz8/epqklxs8mgtbbMIwJuZ2d66QlnNqF7
         mwTKg1OcP6Bc/tes8DZlnxK4tNftIljg9YQfV87qloRLsPDm1AUEw8PJ72gpMWNeqyGI
         9aWR5oysSIrH+OJz54e6w/fIWl3pyyb8wiVnsFZbFbaZMODGJDoh7Pr4Xe+dbn6P0MVQ
         0Alw5+hq+pjGmPZZY5633N0s2mh6ldj8BB64xK9+DUtaqlYtO1xkQFHhZO0k5vjSsNUh
         9iGutF12D3C5L5fxTIV1++vU/Y9d78zEtzeRTi5CxA7QG75xsj8p9wyVTh1jh8mqmzp5
         yWzA==
X-Forwarded-Encrypted: i=1; AJvYcCWh3cgc1LDpXgUplkCAIuI8R++rEMZ1jz6CWjRT4R6KDhkcz1t8rG8AqbgNxRTnpyjtA+3fJJ8xELB87k5PNQDAtCbD2v6o9OsnTg==
X-Gm-Message-State: AOJu0Yx22WLqtsG68Pih4JiHBhY2zY+MdBGtVolhkgvMqb8Fk3nKemHG
	pGglOJA/RxuFFF8xYir7Wg3qE7LuedttHKEP4eJ2oWnSdg91J3CeNwVhyINjp+w=
X-Google-Smtp-Source: AGHT+IHU2pSMQ4Z7goOURBmd2iu1XYGGr/E7eIRTSg1RqOB4crX0T5DSJTcJxouc/BHCqXxxXSYOvQ==
X-Received: by 2002:a2e:3c15:0:b0:2d0:af2a:63c8 with SMTP id j21-20020a2e3c15000000b002d0af2a63c8mr172907lja.40.1707515439056;
        Fri, 09 Feb 2024 13:50:39 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVXiNFh0kbcBC4ELLvE4dRX3tQshbR2fkYdPtGKnaiUIot52Devxiv3K9Ob00k631g1G/9NlJIL99uzrGPfpwYCsSm1QZ/5T5D0sK37mDG9J8HXzs7pMY2RicekCEr4ub0XyESlFdpoxfC09o89xMMnai51IDYL9CwfBxBeTYjG6i0Va2pADE/emBTLrk0a6yAuBiYuaebo2gdtfvSTVf1HsS8peXQSgKS0FviG6rGt0tuA+jlD+5EGlojaW8FCinCr1m6bQhONmtmJuivyXjJRR0yIo+vStRRThQc78CCnEfBBSkOJZ/AuYlYyXwi/pVy0sgAd7EJvDcQK2Qf4PifC6vLsC5HCnLe3u8ddgZzUYQ47XmAimxLK+zTcGLkzw9ukl00lrlbzINTxy4HCGSxaVUwIjkdFDNkHB/hWu5dEOjo2KWGBREZVYJ+4PRB2ZFoCl5Q6z79xCyyakTokokCV3+7q89840gL9kly4snqrQ6kcnTRisHLQ8oOsUy06RCsHwTjO5EJV5DJhWTzdh6H2HNqiDBF1zQRKM0eJ7J89aKSUDHd5ZcFUpApszvNe0Y+Mm4C7U/T6RA7+6tKIBJ1CZL1FW/+xpSE=
Received: from umbar.lan ([192.130.178.91])
        by smtp.gmail.com with ESMTPSA id t1-20020a2e2d01000000b002d0ac71862csm391162ljt.9.2024.02.09.13.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 13:50:38 -0800 (PST)
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Fri, 09 Feb 2024 23:50:36 +0200
Subject: [PATCH 6/8] arm64: dts: qcom: msm8996: set GCC_UFS_ICE_CORE_CLK
 freq directly
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240209-msm8996-fix-ufs-v1-6-107b52e57420@linaro.org>
References: <20240209-msm8996-fix-ufs-v1-0-107b52e57420@linaro.org>
In-Reply-To: <20240209-msm8996-fix-ufs-v1-0-107b52e57420@linaro.org>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konrad.dybcio@linaro.org>, 
 "James E.J. Bottomley" <jejb@linux.ibm.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Nitin Rawat <quic_nitirawa@quicinc.com>, Can Guo <quic_cang@quicinc.com>, 
 Naveen Kumar Goud Arepalli <quic_narepall@quicinc.com>, 
 Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
 Conor Dooley <conor+dt@kernel.org>, Andy Gross <andy.gross@linaro.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
 Bart Van Assche <bvanassche@acm.org>, Andy Gross <agross@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org
X-Mailer: b4 0.12.4
X-Developer-Signature: v=1; a=openpgp-sha256; l=802;
 i=dmitry.baryshkov@linaro.org; h=from:subject:message-id;
 bh=+sh35SiDz43Be9QOkvS4z1KDQSnZwszEyuZbCIKMEwo=;
 b=owEBbQGS/pANAwAKAYs8ij4CKSjVAcsmYgBlxp4oYG5Gd0OLzMKalzNm4aoxG8kTBWMSGbKft
 HyDO5hljnCJATMEAAEKAB0WIQRMcISVXLJjVvC4lX+LPIo+Aiko1QUCZcaeKAAKCRCLPIo+Aiko
 1cmaCACmMi2HsX2bWSlLj5IRSe+5MEXfaRuiFjOAT/2ir+d4T1PLWQiYxEahuMih72XpyBlAiFA
 KbwPolTPR+mkf1F6hzsuEIP1knqgyNSY+qZURaaDmtzxuE/L6V0Be0yiIxbm8o9A8haIUcG9Q9h
 i/xWtLy/qwvniGoNcGPvxGZ7n9R487U5mYxjAJAiL/25v92OU5D8ZZU1uMb1FBtIH8XpJmQ/tt2
 KjGvhOt1QHBv/xDScsOgs9OZFq0EbQiLGi0hh8oIufzS6F1kBChkLx3mU7GBM0i/KGpzY0t8YNR
 wLn7oWamLR1eRcEH/s7201keyP32knOPU8Xg9ECZErrVUkRc
X-Developer-Key: i=dmitry.baryshkov@linaro.org; a=openpgp;
 fpr=8F88381DD5C873E4AE487DA5199BF1243632046A

Instead of setting the frequency of the interim UFS_ICE_CORE_CLK_SRC
clokc, set the freency of the leaf GCC_UFS_ICE_CORE_CLK clock directly.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index 4472bbc7f058..6c847fdff192 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -2078,9 +2078,9 @@ ufshc: ufshc@624000 {
 				<0 0>,
 				<0 0>,
 				<0 0>,
-				<150000000 300000000>,
-				<75000000 150000000>,
 				<0 0>,
+				<75000000 150000000>,
+				<150000000 300000000>,
 				<0 0>,
 				<0 0>,
 				<0 0>,

-- 
2.39.2

