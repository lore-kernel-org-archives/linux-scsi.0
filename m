Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C10F13AD12
	for <linux-scsi@vger.kernel.org>; Thu, 28 Mar 2024 20:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711658763; cv=none; b=CEIPW9gHgHZDTuKPjEfLFDsekD6koXd1m2v3F2uKtf5VPtNvkuZYA49jZvgTnp/22ZixZ2wxlmcOrkMhxmai9kInBTCObsey7q7O6gpRvXUqzqloWwFHBXj0q+nVNFAF6JplanGHvp5CaGY4f9sOzocvewT6IlpINvFaEVwZ7EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711658763; c=relaxed/simple;
	bh=4Fz178QR/piCy1oylUTMuDaEW9dLh/iogDNu5WpJ05Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AxQWKMDtZ8RSgPulxqt5qJQ2v0iaaJejbho8Sc91NJAGH1IDojanOU5gRkxCM8YuBakYUI1877ErypUkjwqi4EgOfL5PUHLXkpQDMOrxQML3yh3Mz+dKlYMqmHfYXdqjX71XXHFK73eo89FLvCTOFtXqUsm9nEKRWi0NY98Eibs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yNNwSSpv; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yNNwSSpv"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-414970d4185so10040485e9.3
        for <linux-scsi@vger.kernel.org>; Thu, 28 Mar 2024 13:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711658760; x=1712263560; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gihd7cntoI/c9dKCWsDUCUdVda0GMecgJqmR9/ZB/JM=;
        b=yNNwSSpvYuNypMG7aBLrZOwmyc5IPJlvV6iKv4zqBYZvPqvDhOJBV3374KwyeLEBjM
         enGiSVFqfwmQUEOGZQPY2WES6ne80tNdOjzJSJ9dVoIGPDiHUk7SjDXx5dQ2bmkiSZmS
         ZVX0aMmuRAkNq+PZcdaX4jccwExEDPyJSzx78sXFA3Y73yoeDn8JFV12XCmJU3Cy4P5F
         ZrUrmv2VwBj+anFfrC1QPYwSVy7AhiEjwCxBkiP0+6dM6mvCSibUN5egMznK8fUN2qHC
         zE4HJnzn/BNpN82oQpOTyLRRuNjdsMk3XRgVv5J9xAieFxLmbf1EGEBPF2lZhDlmD+1h
         4GlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711658760; x=1712263560;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gihd7cntoI/c9dKCWsDUCUdVda0GMecgJqmR9/ZB/JM=;
        b=HWXFfaOgG7RFfGsh7E05RPLm9h4A2N/kvJ0XIBbPL0iwMQyNKlRr6kZnk+6/Ii1qXG
         SdhVrpIAM16We0pqJ88xnqlc8p+6mkCycsWwm35yBax110WKgw+hUM3X6w5ptvDVk24/
         LxqGZev1OOBB7TQpsZ7ovHu1L1HrqSNjNwoxcr7poiwAKgzkBpcfXB+lCrtuxVy2ahqk
         QX3x490LbO3OQ72xKvvs64PeFpjDI5IWpGVQwQPvaZdTobnPD6dDHeOcD8Xy8HWP5Li/
         LcfGVR3fo/Mc1tubytB42DMsuhoJi0/D+mTXM8lP4TxHzLrVCuEqk2s82cUhlKNYFwVb
         UAuQ==
X-Gm-Message-State: AOJu0Ywn5hEXYjgQN1MKrG13apX6AziiuUqna0bZQ4g+WhzBX8Set6h8
	au3VUHu87JQVyFQ8iYc8wIYF0s+bux3ezwGO5zlK39/KAteJnoXJqHGP6xMt/8I=
X-Google-Smtp-Source: AGHT+IFIld09eVWLoR912QMzlPipAzeDg7jl33IVXCQwpqaJJvkmoUuBfzq9qCgnmB/IJDmhPMrZ6g==
X-Received: by 2002:a05:600c:468c:b0:414:1eb:3010 with SMTP id p12-20020a05600c468c00b0041401eb3010mr304229wmo.17.1711658759914;
        Thu, 28 Mar 2024 13:45:59 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.223.50])
        by smtp.gmail.com with ESMTPSA id t15-20020a05600c198f00b0041497459204sm4762697wmq.12.2024.03.28.13.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 13:45:59 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Thu, 28 Mar 2024 21:45:48 +0100
Subject: [PATCH 4/6] scsi: sr: drop driver owner initialization
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240328-b4-module-owner-scsi-v1-4-c86cb4f6e91c@linaro.org>
References: <20240328-b4-module-owner-scsi-v1-0-c86cb4f6e91c@linaro.org>
In-Reply-To: <20240328-b4-module-owner-scsi-v1-0-c86cb4f6e91c@linaro.org>
To: "James E.J. Bottomley" <jejb@linux.ibm.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 =?utf-8?q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
 Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=624;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=4Fz178QR/piCy1oylUTMuDaEW9dLh/iogDNu5WpJ05Y=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmBdb+42KAcqRgn5Z2VbIu8bbhRdnyFNx2LZu3v
 KxbbucT+muJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgXW/gAKCRDBN2bmhouD
 17T5D/oDY+G7rZG4gjc2lMsI13yuufpx9LdNJZeci5LgHYjWQ4o9zSkFZ3jj36LAJFMH+VujJs3
 oOfV1KGQQ9olmVbClqhLWE0dbpTyRumUzT0exw4aX8g2dtGwy5ALHUGppm7Lx++hwt18Fw8goy3
 K6jF2z5UWkIiWGBjtDulwoj9gti3aykR/5pN0zIc6XoADK7Nsp4Z0i896pNULRGwIwBIUUAS+PL
 JqsN0MTUpxUeoVL574/m+Zo1Z6d3ECzn86MA5U8WjRGRnsGbC45Ns36cW9NUf3gZNZYouXWUx0M
 iGOf0ngHZaVVyrL81OzuNgPblNMnQ7weyU7++Zlvc5fqMH55V44HRgN28WH4p8xRftIRh/wGZ8K
 cGGcotfCFOxn68+sKhTNPfUZLEpXQoz2iHl3VssfJ7Z4q5xQuQIHVv2i+7sCCfjLXhwJbYCWZYj
 bMfnBgLpUmR83RQ1XOG4uYQMzgyWIqPwc6AStwGoX57m0FPstizWVgf3NkyhrezotcAp7JXM3bj
 REoBsw+Vbbr02IqB21+GkBTHJVs9sv16QSdURaBqtQyR0JKvlozukWaWOhI1Urssmd+NtYyvQ/x
 jUhO0sRGPzI+IxSLyU/Oj5eewx7QTUAf7zM8SMmp8/Jg+pEGZEwbvt+hUrpGbvXvWkhEU+6u4d5
 QRJpVPeCg92RiMg==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

Core in scsi_register_driver() already sets the .owner, so driver
does not need to.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/scsi/sr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 268b3a40891e..7ab000942b97 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -95,7 +95,6 @@ static const struct dev_pm_ops sr_pm_ops = {
 static struct scsi_driver sr_template = {
 	.gendrv = {
 		.name   	= "sr",
-		.owner		= THIS_MODULE,
 		.probe		= sr_probe,
 		.remove		= sr_remove,
 		.pm		= &sr_pm_ops,

-- 
2.34.1

