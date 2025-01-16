Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819FC22C9E3
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2025 14:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737038974; cv=none; b=QemLvp2IvJLh6nB54GOAvIlmwmI145RCcleZNmQWeO8pu0GbVkOvOel25+MO+qUB91NXRkWidBGF90Fg1QUUYRJ3o7er0+mjNv55Nk66GaqDZjSCge7WHwbQ5UjKaJli+bU6hOoJt4cxa44kjMl/ENEfOrw9IVXLr5qzFvBFHlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737038974; c=relaxed/simple;
	bh=SLPk0X7feJzjbp6iNB5msnLoDstFDxW+7yuOzADYOIY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=G2XNSiEhLFrSS+L2/u1HRI1oT6q+3Jz5eBs5tBX8si9oUrjb9NQhOQh7Th2gMqlBgTjHxmgAr0zjR6U3F+FE41siOM1VHq3XSC7OFkk6zasIjdCCUkraj6donhW3TNUm5J6BBuiYbTQl4q3RNPGftwJ3L98c5JlLObrd/0fIK1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=k+paxNDI; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="k+paxNDI"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3863c36a731so885212f8f.1
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2025 06:49:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737038969; x=1737643769; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e7cRMSVWB1iA1Z/E9hbzESrNuj3mM1/u3MbHi16H2W4=;
        b=k+paxNDIjOxDJgPjAQG1KtidazknNY471iVzSHZQNe6EgPboggEra9/7VcAlUw7/o8
         fY5tDLXNNxoIfYERctcld0qybKoLCBy5gfdMaWR2LpefZTo6J+Z9ytcHocx+O3VDxInC
         3mqZxcLEemohTrWZBpxHrbvB8ONTmm4gUXB5vvzEr7WQXl6ESFPiuc/U2XhUZRLI/9bS
         IPm3I83AR8ub4NYD2Z8WBUJN+aoZToBv0cvpiiNvGzhH3d6zPrEGQGFtaZt30uHSYO/9
         q706kNsf99ulZQCS0aOYibKgTuvitR7LNS8OblVZLa3PkQLGDhGcu78k/OzPWbIrgbeH
         u6qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737038969; x=1737643769;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e7cRMSVWB1iA1Z/E9hbzESrNuj3mM1/u3MbHi16H2W4=;
        b=ZGOW+qJz5DfJeG09ZdndN99RY0Iby2Kx5LgQf/W+cNtIeu7l7uFTmgzK6k7JF5tP+e
         jUKzhPquo6Mau5wjp816VuSMzRAN5JbhoN0utj0baYS+LA0S4mVfjxKlsVQu1gw+s9rs
         jlsiimh0by4NKVCQPG8a+iX+RedfdJIBwMF6EWTKZ60Gli6xdBXjItdtn3iDaFplOKpo
         HBf2pQaaHTA44zHknP3z9qB1clCVOZ1tXMTwBmVSQbg+DaQK7fn6ccjOIOIDqpy2epO7
         V8aPb+vEDTFhmG/88vs66au2Sho0Zl9Rt7ticSDtqdV+bZe+S3hNEz6tLTlVdLHg8SUs
         kYTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwbd6uAdCR0htyZjXTEsVogBxR6k9jWj9Yk+0d3WBvQAD/hmnCsL6Y7/nDio2GlTPDx13TynzlHYNm@vger.kernel.org
X-Gm-Message-State: AOJu0YzJRSg8PWiKjXQhST1XewdtiFo14FeS+dg/jXHHWrBoTcnv9Ay7
	383E/yHTPM9MQJgbrQgf+Y+/0QzYw5JwA67jzVvcE/gOQk/ePkHSBBfwVD294jpgSjNaZajOkm0
	P93o=
X-Gm-Gg: ASbGncvEbcl4abJ+O1l2MAQF7ur+xN8qPcv3HtdLP4338rMkP75TSriiGAHwQTfnnKD
	Ld59tV4M8/4Yr5GQXVH1CkbG+s5cjldBwySNJ91nFPQY5KipRABNR/Q5OSNMbaKshm0uCSnsj3/
	IuHrtzPNMmEg1GSYLgpp4juWmvckoABcXtXaU/onZsdOb0u7gemc24O5KHSkPno1ts23pqvWo8V
	vF4USQOEFVX34iBtun+tRvPhBDzMPZNRae3k7lSmxCxjPLTYJ+eya/nM+lpVoofGsKtHBFtN4it
	Nkmk/JbMV6LJon03dFGsEcuTi+2EYN83dVwY
X-Google-Smtp-Source: AGHT+IGuLmvbYhQXQ99Ngdjm7P7XXhs6Xz5bChZGEdZB5e+12utWg4WoIKuw3R2n6RN9NlrJ92GEfA==
X-Received: by 2002:adf:a3c7:0:b0:38a:88d0:18d6 with SMTP id ffacd0b85a97d-38a88d018dcmr19384870f8f.42.1737038969571;
        Thu, 16 Jan 2025 06:49:29 -0800 (PST)
Received: from ta2.c.googlers.com (169.178.77.34.bc.googleusercontent.com. [34.77.178.169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf321508esm70310f8f.10.2025.01.16.06.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 06:49:29 -0800 (PST)
From: Tudor Ambarus <tudor.ambarus@linaro.org>
Date: Thu, 16 Jan 2025 14:49:08 +0000
Subject: [PATCH 4/4] soc: qcom: ice: make of_qcom_ice_get() static
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250116-qcom-ice-fix-dev-leak-v1-4-84d937683790@linaro.org>
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
 kernel-team@android.com, Tudor Ambarus <tudor.ambarus@linaro.org>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737038965; l=1554;
 i=tudor.ambarus@linaro.org; s=20241212; h=from:subject:message-id;
 bh=SLPk0X7feJzjbp6iNB5msnLoDstFDxW+7yuOzADYOIY=;
 b=G8iEARZbH9wv6CQbJi1hOS5u+HYxxskB3G6McP5l6dHKR3FG9vTnp5n4BD0jqXTdLl4BSdAzC
 4JF38mDEPEmDQ7SXoKyDlewZGuD6XTgwZIpVqagkG1RWcJfa0FQRTzo
X-Developer-Key: i=tudor.ambarus@linaro.org; a=ed25519;
 pk=uQzE0NXo3dIjeowMTOPCpIiPHEz12IA/MbyzrZVh9WI=

There's no consumer calling it left, make the method static.

Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
 drivers/soc/qcom/ice.c | 3 +--
 include/soc/qcom/ice.h | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index 9cdf0acba6d1..1a2f77cc7175 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -262,7 +262,7 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
  * Return: ICE pointer on success, NULL if there is no ICE data provided by the
  * consumer or ERR_PTR() on error.
  */
-struct qcom_ice *of_qcom_ice_get(struct device *dev)
+static struct qcom_ice *of_qcom_ice_get(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct qcom_ice *ice;
@@ -323,7 +323,6 @@ struct qcom_ice *of_qcom_ice_get(struct device *dev)
 
 	return ice;
 }
-EXPORT_SYMBOL_GPL(of_qcom_ice_get);
 
 static void qcom_ice_put(const struct qcom_ice *ice)
 {
diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
index d5f6a228df65..fdf1b5c21eb9 100644
--- a/include/soc/qcom/ice.h
+++ b/include/soc/qcom/ice.h
@@ -33,7 +33,6 @@ int qcom_ice_program_key(struct qcom_ice *ice,
 			 const u8 crypto_key[], u8 data_unit_size,
 			 int slot);
 int qcom_ice_evict_key(struct qcom_ice *ice, int slot);
-struct qcom_ice *of_qcom_ice_get(struct device *dev);
 struct qcom_ice *devm_of_qcom_ice_get(struct device *dev);
 
 #endif /* __QCOM_ICE_H__ */

-- 
2.48.0.rc2.279.g1de40edade-goog

