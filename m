Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E5313B58C
	for <linux-scsi@vger.kernel.org>; Thu, 28 Mar 2024 20:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711658766; cv=none; b=ci7joyyHrmRtpwaU6xLepOjA+S8h3+V4cmTjNNrHdqgD0QYwwvz9wGN7cB7gd5wHxW60gAWaUznnkDJUkbJB8fVJFz+jyXOgjBmRV0yQkz55pzuKvWsBmGuwXywFPb9X1nPqMcYHNcbfgPwpUbw+g31KwtRgCG4lEM8YOHRe79s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711658766; c=relaxed/simple;
	bh=2eL00kHrk9PZ4wV7+liPYn4xAdGVUS6T/yXYmc49iOE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GnuwVJrBZ4k3mRYiiECdWsY8oSdUexHDXR+V1RaG/cRDPYGwlL+WGUuFB1NyuV/CsV5eeGtnTDD1OKGxKqxR7SAac0G5l4fs6oht7kU1aw2uitQpKQoDjqjCWdEXxazZ5fF91+/HytixOIEzSzUSZ8QRTNq8F0Bf0n8UTSOUTlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=C3G49BWH; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="C3G49BWH"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-41490d05bafso13293485e9.1
        for <linux-scsi@vger.kernel.org>; Thu, 28 Mar 2024 13:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711658762; x=1712263562; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3fD9nrYXcpClsyVR0BSEl+mQF9yqUNdr6oBOx3H56zM=;
        b=C3G49BWH/vIoDOqRAu/SF0vmWT/GZqAX6SK2Ws/s4yMxLAPBxJT0NXNC/CJ/Ig4DhZ
         Z+pMHzBjvpsPqjOzzWvdJSlBOPOq7oZWeyJhnnWDpNOD3AEvSBU8qhhHbBCK/VPA4Wr7
         ZF69yb8mZSgwn5fx0kV39ZSpGlI7SghG5JAMtJKfNAGG851U0KgEXGE3LKcqgx4H7ibR
         zcrZ0OFji7SYNK969eT7s6w3mkqQ3ZG7g9ByOORKiMVg8ojuxXx/32xU85h109E0t2GV
         H9KzUZax/V562py5+Y1hdPYQDR3PkazzfOGfg/qEPvATto7vdb7LBEQjxoKQQcFV8QNX
         DV+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711658762; x=1712263562;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3fD9nrYXcpClsyVR0BSEl+mQF9yqUNdr6oBOx3H56zM=;
        b=mGw4Lnqe7ziyLee/lMyEAeJyIv4cDfeCKE7okRwfW676YSVxCVXVq+K5XWJ29ds1Gy
         x3M+UqsevCrBUcI6jZYKkpFiE1/LGLQyUm9gh016KRduUn0Bo5+gsWzNdLJksrIQb+Ce
         xsF6YfLbuu3JU1JYuFxkGcZnyatGWkeeSofxMAHuaHLTsSftInbe82DHh41yYfFC5ejj
         BzjSTwLp8NeWcKYZImTQbAhxPilzxGbS1qhWKRmxQrKfDQkVXPkFGQw27lcWv+z1JMR6
         B5AD1leaJ2YNQfpWhs4QUTfDlJNzkslFHxGoccop4CwjJmLg0w5J/EjRSspvcdNjFLIN
         UAPQ==
X-Gm-Message-State: AOJu0YxwTmLT/M5wmoz0TMH9oma6EhJoA4d8ZgLVCVY4EzWv6Jhh6ai8
	NriPWAQLgkqDQFZFfl/r0Jgq8pN25/1OE9cS3n+PdxG5TtaKLzKA54RS6K2fUbA=
X-Google-Smtp-Source: AGHT+IFHHL0fhd0TNG1ORkHHa7La//2Q0gCdNCxnqIaveHIvGKPFspn7Abmn+XzZF3ygcNPdLhnU+g==
X-Received: by 2002:a05:600c:1907:b0:414:5cec:a9dd with SMTP id j7-20020a05600c190700b004145ceca9ddmr416665wmq.38.1711658762607;
        Thu, 28 Mar 2024 13:46:02 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.223.50])
        by smtp.gmail.com with ESMTPSA id t15-20020a05600c198f00b0041497459204sm4762697wmq.12.2024.03.28.13.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 13:46:01 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Thu, 28 Mar 2024 21:45:50 +0100
Subject: [PATCH 6/6] ufs: core: drop driver owner initialization
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240328-b4-module-owner-scsi-v1-6-c86cb4f6e91c@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=746;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=2eL00kHrk9PZ4wV7+liPYn4xAdGVUS6T/yXYmc49iOE=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmBdb/ZVotfrMskOzAZjjergAwKXcjYoMF0jqq1
 ULj2NguWsOJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgXW/wAKCRDBN2bmhouD
 11rPD/9+pCrA4JIzLrUksF7HHrkMPhVCeIBN9FBLogbwu73/t5BWfxNnAd+V70VLTtRWkL3ScBe
 JdBh1ETXgOlBmvU2xyKUxdsxxNVNbdp1sLAYEIiSm2oHxBCU6HDZW7FowFzvxiMgGCoqIoeTS88
 /s/9LA93qtwp4ku7GiPLPXMQHG7qJy8cVVxbmKzFxC55H/F7vyBxMwN1x6fkgxYIshq8BnJZVdQ
 ClwFyo6hPlfdBXRePWhT77VmO2S6htw7bkKYiG4ZvcO53EkC9xG2dC37WCsuKekYC3mKzBTdnPT
 ZFcAUbhvi55C+VIe2AsgJk9YZi12ftLx0V0SVvI7nAViMP0hmwy2bk3dBKUBMSmQ9NdrYt6u0jZ
 2npr45NGpXi1ZBWWo9RLl+RTmeU++pGUoUCi+Rt2G1SxpNAXt4ImFZ3VEe+MWLcaYcGYJsoZVv5
 xxE2VH+pcKOSFbaf8sutTLq8q0e1Z7pnLardcBBlYTyvIiKGkVVrwkumqQslItjTDaxM/si2M/c
 YUblY1PBAHW4V5pwYcPOJC53CIPHXZLxPX238ahmQWGDFjeEOFObETl0UDi2QorSao2stiwEGNJ
 NZeEIAwLhR/Gn7awmkUmx7rjqN1Sz8aRpZZgy9/Lm3sFVYl8bQYSQy9ibn5FoTrY6LsJIzsA8lV
 5lpL9y8BX0fFj3g==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

Core in scsi_register_driver() already sets the .owner, so driver
does not need to.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Depends on first SCSI patch.
---
 drivers/ufs/core/ufshcd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e30fd125988d..77fb9b2261a7 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10896,7 +10896,6 @@ static void ufshcd_check_header_layout(void)
 static struct scsi_driver ufs_dev_wlun_template = {
 	.gendrv = {
 		.name = "ufs_device_wlun",
-		.owner = THIS_MODULE,
 		.probe = ufshcd_wl_probe,
 		.remove = ufshcd_wl_remove,
 		.pm = &ufshcd_wl_pm_ops,

-- 
2.34.1

