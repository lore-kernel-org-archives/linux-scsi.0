Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5031AD53
	for <linux-scsi@vger.kernel.org>; Mon,  8 Apr 2024 00:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712534680; cv=none; b=a535b2I2Xv3Fxx5X5HT8HA2yNL3ypegFYgT7AKKDgMUipOzcgTvPGHXgVexRVxsDbKDCQ7KJ6S8yPtmxVcuuBdlCcofQgAXFP4yCBKfkMxgrUF7/YRMcUxroq6Uq+PceHkizy13b7/XFDHJfo/sXGiOdvrQt5+fR82wzx/CNvCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712534680; c=relaxed/simple;
	bh=aRYQeL4Y8toOXnkm/Yr4Y1fKV2VEuxZ++Bc+tR+WFvg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gilB0VucEYZegQMsUT9q9Kp86w5LLjKEt+5ulRHBZDxh5LBImig6uuZgbRD0nu8Kgp4gHwT2WjhyXzhimTq8asOqU6FKtGnD8VAHA4A7YY06qHJHrzAkMxWzObOKpFlKG+tkYLgnQMJcaQJ8Tcyi+Fw76SR7UA9MKuB57ImGS78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nKw4Fguj; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nKw4Fguj"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2d87450361fso21345871fa.2
        for <linux-scsi@vger.kernel.org>; Sun, 07 Apr 2024 17:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712534675; x=1713139475; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2V4YfKJutpGTD3SdZOEw66m0js5pB+R1nvu58HzXs+g=;
        b=nKw4Fguj3hDWIcB4K7q2fC0wgUwaPVwLAkwDMYmE/uK/HnCLn6UvGmaezFkBBIu6gJ
         PqLkkr/eFlPT+W0Af3hFPVFHmWFo8FyVyMZzYcF8/RaImxlTiSc2pqnDndYSpnViSJWu
         CrvTNVVueHg7YLA91tyCMTFJQn07NgERWTnZMj4Qvd2BOsb5okUmFUnTHJ5hHeu+T579
         CBHbzEOQ2X/7OlfOY04eYaS1zKswcgZwcAIO5OvM9HoZNqHeYNuB2TxNKVCzwstWygoV
         BtaQ2KD/JdZjhtrtRFDOPvZoq72jgLtaSqBFLMNaPVBWtvuU+lkOu5Ys8oo6uWxgIKcs
         fIYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712534675; x=1713139475;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2V4YfKJutpGTD3SdZOEw66m0js5pB+R1nvu58HzXs+g=;
        b=Xl1KS0Oce9WKjwRY5PkoZwOp6RSSmfIuZ4XiSQl6pMlh392uuFikJC34p5fsD2GqCk
         A3Zn/hjOYXLl1nWoO7e+jR/uvDO4KaEtWn2so4S1kYLCt6aiGZEguA3uc25zdDIZIizj
         I+RjSq0+tIxgMFK1Lh485eM2C9wwx7U5dRL5/pK75zOP3OGlsQeg85tcUmCCLS5zHygO
         kROW/E2DA9dLwxw+gZwt7s0vZt52ZJhc23dnB3vhrSu+vuOrjmFGhkpRUnkzfkZIs7o5
         uuIp9Pzkz12JUbTwqhPhHtP3SthUZJ19niYRiatae6QkieLkGW1r0zFNX6NkAKFyGqwL
         cc1g==
X-Forwarded-Encrypted: i=1; AJvYcCVKubdJCo+vpTop1PcYVU5FKWQpq2NbF/n//KFvjxGlE9uW9FDN3tzF+NsoZ2p7tBhBspi64YfTL97Z8NpXBFQCyxotxKb5Lybp+g==
X-Gm-Message-State: AOJu0Yytr+aHQQ1LZfg7iff/By94tyhTTXHycfUnIub4AspN65XhGx15
	/M03s4g/rbqzCh/1Htbdt3pb7xKfOb7vkptidiEJZhg0q9PoZfk+jKvbl7ZnUcA=
X-Google-Smtp-Source: AGHT+IE1D88d7O3vSYCxcmI0nBH04P0LNMhxQkl2m/MX0jIwy+GxEwOEd/jg3fCEUyILlPuE3VofGQ==
X-Received: by 2002:a2e:b17a:0:b0:2d8:2710:c64c with SMTP id a26-20020a2eb17a000000b002d82710c64cmr6077212ljm.1.1712534675071;
        Sun, 07 Apr 2024 17:04:35 -0700 (PDT)
Received: from umbar.lan ([192.130.178.91])
        by smtp.gmail.com with ESMTPSA id n9-20020a2e86c9000000b002d2191e20e1sm947077ljj.92.2024.04.07.17.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Apr 2024 17:04:34 -0700 (PDT)
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Mon, 08 Apr 2024 03:04:32 +0300
Subject: [PATCH v4 2/4] arm64: dts: qcom: msm8996: set GCC_UFS_ICE_CORE_CLK
 freq directly
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240408-msm8996-fix-ufs-v4-2-ee1a28bf8579@linaro.org>
References: <20240408-msm8996-fix-ufs-v4-0-ee1a28bf8579@linaro.org>
In-Reply-To: <20240408-msm8996-fix-ufs-v4-0-ee1a28bf8579@linaro.org>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konrad.dybcio@linaro.org>, 
 "James E.J. Bottomley" <jejb@linux.ibm.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Nitin Rawat <quic_nitirawa@quicinc.com>, Can Guo <quic_cang@quicinc.com>, 
 Naveen Kumar Goud Arepalli <quic_narepall@quicinc.com>, 
 Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
 Conor Dooley <conor+dt@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 Andy Gross <agross@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=930;
 i=dmitry.baryshkov@linaro.org; h=from:subject:message-id;
 bh=aRYQeL4Y8toOXnkm/Yr4Y1fKV2VEuxZ++Bc+tR+WFvg=;
 b=owEBbQGS/pANAwAKAYs8ij4CKSjVAcsmYgBmEzSQv043H5v3I8wskLuSYpY4T5Q0DSjfkySq3
 7WWrh+dVVWJATMEAAEKAB0WIQRMcISVXLJjVvC4lX+LPIo+Aiko1QUCZhM0kAAKCRCLPIo+Aiko
 1efiCACtQV4p+1ZDOD2mn5pK/s4Nt7O9hVrFenLdII11PAOU2E18yOzudBiHJX66LFujZeKJeoC
 ux0UBI/gE0RNAD54vq2eaHI9sF0fIVZvLxxMJn1/RTOhUJXIyLx45fe3uf2l0eLFtGM3AYs5LRP
 yhaQ8UOWmJxYIRmqPLI9nYUwxqPSPSFjY+rwRgDfsZXcTQOjQBehmLa4Pfv1mS5sg7CmG/Pla/k
 avqtbJoIIktc6EMR6cb+cMARXHm1w1dCGBPEIkPWxbQKs+qEPRgy9A8s9MUo4nOtQT7YGIiLop9
 iEA1wV+z10uSi7mZ5BYvE5M+sW1P881XmyIUQWW5rFYkRdIR
X-Developer-Key: i=dmitry.baryshkov@linaro.org; a=openpgp;
 fpr=8F88381DD5C873E4AE487DA5199BF1243632046A

Instead of setting the frequency of the interim UFS_ICE_CORE_CLK_SRC
clock, set the frequency of the leaf GCC_UFS_ICE_CORE_CLK clock directly.

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index 42ad4872f94d..da7f599bd2a5 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -2076,9 +2076,9 @@ ufshc: ufshc@624000 {
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
 				<0 0>;

-- 
2.39.2

