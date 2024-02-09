Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29E933CD5
	for <linux-scsi@vger.kernel.org>; Fri,  9 Feb 2024 21:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707515439; cv=none; b=Niu4okUlV16Tuk+HyKBEyfLYi9EcVVmcIh3X7T3lKc0+9AFir1wCjhiwigQL9Q3ffOD85ctHg2dV9sZxJgqtKwLZscjckue69XGvMIHVcYE5BwqKdaDLuNj75OPZYp7PdQQl9cyC/AIBQdu81AHv18dsOy66KK6WzcFNaW5eO1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707515439; c=relaxed/simple;
	bh=zXQTB0UTbLqKL0nxwT+xbYvoKu354PiK4225HNhdxm8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=l9brxCkiVXgw4U8m5OXg3u5GhU67vSSFP6aY7Fg8tvT8Ug/VaMxShl1ozrbpMTB2JQydrhTuZJ/YHjKjiFN62RYXmtCq8pwO4yJygcmPPl9Gy22g+cJ5jKqgCVd7dRgqblSZZZikSaAMENT/1x9g8jjkSZsxN5Wxnexkkt4MWL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=B77Kr5br; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="B77Kr5br"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2d094bc2244so15776711fa.1
        for <linux-scsi@vger.kernel.org>; Fri, 09 Feb 2024 13:50:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707515435; x=1708120235; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4sfbHX5QAyUBZOUDcGHw44glG2jhZqLX/qM5eWSG9kw=;
        b=B77Kr5br0RC/jfhNyssAgxL2Z7nVNC2i/5+PcwizRKJKYpYeij6iEOtCqw0WLAWXWH
         cUvnWpvy46NuUWKX1BEHQNFgauQlBFjqu8g2qHFVfzzc/TVX5ul4tR+Ka8lFHgpnjt4s
         FdOKH7+aLln5JddIVRpZzkPI9zhMao7sNVNKPmnIX4LgD91dZNidvcy5uRYNyukmw8QN
         su7iU7IaDtka+d3hQEm6AWU45mC9VlqJx8n/3jOZz7jv9Wp0nVyWJcd96R5GysVitOxt
         GfaS5wXXwyKEllToAw1g2k5oXHiDIW+MeMhZSHzS1LvLILxIzg2WmrBYHGPe5qKP6kX8
         +bxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707515435; x=1708120235;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4sfbHX5QAyUBZOUDcGHw44glG2jhZqLX/qM5eWSG9kw=;
        b=AFat10ddhzRHLIUuJZB2whkrmGvh/8a49U+HGxJljoHuHeFxv5EwatTpOqXh/kPpjk
         nYa4BTFMzHznEXOSN8xsseeoTcWEx3aDWOCaJ6bLNG4bNBzkp7pXnk6aPX1hrQafh2eU
         HM0CJoeEuFL1JxtKtTEbyiAAJMzo1J3VsnbkrwZ9RL5Qo2rCw1CIl84UtmagUi6fTnp6
         e3fHZIZWaVt3yjqIJ8C7lamFmzBvT/H0uHkV9Kaf0oFae7HJ3E6QDpHPecWCT4zUb2UF
         8im3sBTllAivkuviQUXw6c4csii4Y7aBbC2fTZp00cEBxZv4ASqkprH5+/iM2LC25uEM
         A8pw==
X-Forwarded-Encrypted: i=1; AJvYcCWYABc/vVH99eZQA9GmoJdPWjBWx5igdO9Mag8WLOUzSWDi+X/Ci3QCza/PzH1l0l+Ew74A7Pj5GoElR7n8JLqdB6r++R7WIz5HCA==
X-Gm-Message-State: AOJu0YzdfDBYIe53xK40Z2HSejvVXSs7rvgTjAdjP7jLSgXObz4bLPYp
	406Z+EQQlORBtr5gyaA9wUgDwcsnBrllfMzveNBYB4qgLj4d+8ZareoiWhfx4Ag=
X-Google-Smtp-Source: AGHT+IG9Z8g0DPyp7EVYupXf/1ancgNAdrRrmH8adceFQRG8TYM0Ce9q6b0PIVHzmjWhIOmTDQfaew==
X-Received: by 2002:a2e:87cb:0:b0:2d0:dfa7:8a87 with SMTP id v11-20020a2e87cb000000b002d0dfa78a87mr180106ljj.8.1707515434943;
        Fri, 09 Feb 2024 13:50:34 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWsHbHPIyAqmzStAXa3zlKh9046xx0UWO24AgG3d2Ae/5CvzBucYjMcAD0UC5in7vJAQnqKYGUhY9GKDm40LLnUCF0PFA9W4ijayoAZCea5/JjypHrNdkZhQ9rR5cro8NWwxio+ec8kdcIAUXWXicrj5BqCFn9Fiyk2hxWg0EYxJfowxKDp2A2KYS2vOLcWqcZjyhZHm4rubviNtZn1Xhb5hszAH4JIi538SzrV/4DMYhHymATxUMOJP5dJqJ8JlkwIIC8/jwEVGy3NOML47cUV4WTmm2GS26k6I5XXgtVUsU58kWljKm5WWCCNkUlslA9kwutRf2O08LJifp7oaikXXZBVCSl6rEUyGX8eO6MWAzYtar/d57DP6C2k9GhSGSc48SQjyc94MEeM1xk1qsE+ob6vLmuTKlyc1NUFHK2dV1i6iqrHNlJUBGOy0yVuS4LhOvLRWJDr5tkfD3PCOKMuDIZ5G/qO445UksBlH/HD2fvRVj3VtpqNFdbqW1OqDnBdklOjiqX1D0Gqk2NH7u0dOONPFu9h0Rggq+LajrYxwZYPPmR+cvkmAc8XYCIJiwzkHTPbi7CafD7Rykouw/9fRIctOsn4Oog=
Received: from umbar.lan ([192.130.178.91])
        by smtp.gmail.com with ESMTPSA id t1-20020a2e2d01000000b002d0ac71862csm391162ljt.9.2024.02.09.13.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 13:50:34 -0800 (PST)
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Fri, 09 Feb 2024 23:50:31 +0200
Subject: [PATCH 1/8] dt-bindings: ufs: qcom,ufs: add second RX lane on
 MSM8996 platform
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240209-msm8996-fix-ufs-v1-1-107b52e57420@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1529;
 i=dmitry.baryshkov@linaro.org; h=from:subject:message-id;
 bh=zXQTB0UTbLqKL0nxwT+xbYvoKu354PiK4225HNhdxm8=;
 b=owEBbQGS/pANAwAKAYs8ij4CKSjVAcsmYgBlxp4ndlknkuTjzr3YIUwDh2PR22rrOETju3Aes
 xxGv6YOUdGJATMEAAEKAB0WIQRMcISVXLJjVvC4lX+LPIo+Aiko1QUCZcaeJwAKCRCLPIo+Aiko
 1f3yB/42hjMD4zHwA5aBzdnkKQvx+zi1nWnB61HhTZp/FugvwIPPdsPLpLz8BIaZKjmTsUhVvmC
 Jfhr2ctqhCPbiRB1JJ6UEYTD9WIWLlaDCM6pEtRxqu0wc0HFUZaoYpbA6KR0SAOTI0ENv93WQpM
 ixbdwIAUM2JIVTBVXHBcYAOZgZYJ5bQnj9ySI7C347lsi7Svjy/niwTzFCIjdNRguf15DLmbOAl
 q2o9eP22t/AR/gdSlbJPXk0hKsZwlW+2CFQvj+3k6+RPn5XV2uagTaIjFnHC3HoFrZ5STpkcGAm
 FKaKmmaMwoqntvRNPs6BjP44Wexd8qSgTvo3647WzqvqLmMR
X-Developer-Key: i=dmitry.baryshkov@linaro.org; a=openpgp;
 fpr=8F88381DD5C873E4AE487DA5199BF1243632046A

Describe the second RX lane used by the UFS controller on MSM8996
platform.

Fixes: 462c5c0aa798 ("dt-bindings: ufs: qcom,ufs: convert to dtschema")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
 Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
index 10c146424baa..f1de3244b473 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -43,11 +43,11 @@ properties:
 
   clocks:
     minItems: 8
-    maxItems: 11
+    maxItems: 12
 
   clock-names:
     minItems: 8
-    maxItems: 11
+    maxItems: 12
 
   dma-coherent: true
 
@@ -188,8 +188,8 @@ allOf:
     then:
       properties:
         clocks:
-          minItems: 11
-          maxItems: 11
+          minItems: 12
+          maxItems: 12
         clock-names:
           items:
             - const: core_clk_src
@@ -203,6 +203,7 @@ allOf:
             - const: ref_clk
             - const: tx_lane0_sync_clk
             - const: rx_lane0_sync_clk
+            - const: rx_lane1_sync_clk
         reg:
           minItems: 1
           maxItems: 1
@@ -257,7 +258,7 @@ allOf:
           maxItems: 2
         clocks:
           minItems: 8
-          maxItems: 11
+          maxItems: 12
 
 unevaluatedProperties: false
 

-- 
2.39.2

