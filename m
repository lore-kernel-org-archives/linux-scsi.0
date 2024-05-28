Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8B516D9A4
	for <linux-scsi@vger.kernel.org>; Tue, 28 May 2024 13:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716903414; cv=none; b=lyRv2ItcatKyOQDCl5hH18rD9s/mSnwMntS76lbNHoY/3VERpHQyWNv1M2mmfb5j2yhSsUxsebw1cytK/Nyfxz246hkNH+0k2sFxhHIq8hgG3omklBHEEZAMTUeU8sHLooSS1NnPnRWnhkWSnDXgSwYoSmGywmRgruLO+eBbm3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716903414; c=relaxed/simple;
	bh=LcFYy25T3EVBDfPNggp7aNeBJ3nKQigviyyutbZj/ic=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=EQZ6UIOtw08Jci2q+vZVH/7OU2v/MfjPFeVH9h4/nvKoaJv8yJ2i4QuCV+ddz3PUmDZruJuziDnnm0XS/SiH8sz+MgtXJ9TeEaq/tHevOgauawuWoR9w3B6M0gjDd2hji43lsDmJYkANzZF63mn2Clx+DR2Ph+/92cu+4KfNdIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jTb5wdh+; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jTb5wdh+"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2e6f33150bcso8587281fa.2
        for <linux-scsi@vger.kernel.org>; Tue, 28 May 2024 06:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1716903410; x=1717508210; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0bYb7kOPdOLKl3Fm8ZrNzYyGK5OCoefcEw1BChMcgKI=;
        b=jTb5wdh+UozWoOAN2ihLdkippy6N+LSuKVLIEHeX+VCpGOvKfGJVcS6Jynj7C+qzeJ
         1RhUkhyEivROVups+94YyQDuSe0Nu2M/FevkmfKJDdT+65vWcaLc5PDa1+C3/uAaLV+T
         XGCbTOMGok//ADntUjcSAXSXgbWXUoZt6vI6UgW//DJQJXaz9Dvep+/cC32nqA5APs3H
         1BkUOD5wnBtTxqVqd12NAecmB/ra1atKhE44ouHItjXeKuL/Qoxa+XhzO1MxnMnDZ9hz
         QmVIo2Huar/A34v9IpUGGxJhKnOmz11ZwjbVRm2wsgImfdfdZKGbyGCAlGyWAcJskSbU
         w2Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716903410; x=1717508210;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0bYb7kOPdOLKl3Fm8ZrNzYyGK5OCoefcEw1BChMcgKI=;
        b=QBbJYUj6VvjWDsPqzrAqqs7Ps1jKxZYcbJ304+clYItj+0REtcfWhhck4JitgXJmpx
         vECEjlhKUFJtlgXbr9LJAnKnEap8oUP3sz0JIxrIH+19foHdVO3ioEYj93BQXaBWT1Sk
         5NSWis8hpY4k1tvXsmVUsSeVwCTe9rTSqdLYIjfWCjZHF/+2XLchuZ6292wqofD21quJ
         TPT6gPO/P12Eoi7VqHMVH5+dhBfaAZqUvJy9BPsCkzlUMBN10I027CeXLervIgcyx9tB
         1iXsVAwcMVPm9T4RGujjYuiSEsTQBlW67/yYuVuE+RHnePQyNzDXvL+QS5YGfbx0x8sQ
         2iPQ==
X-Forwarded-Encrypted: i=1; AJvYcCWaJu0hrdLFLcu8bg9kAxVrrUeLAYWYp36NZ0Y2JSfoStOTYQbSCvPCR5HxYwHOAIzpmfSGS0qSZzNzRSbc3zhxHV23DcMhNGbnvw==
X-Gm-Message-State: AOJu0YwiirqI2jfK93u5C7Y9Kv+LtBfV9mi2lryvVJot7Ge5qJvXqz95
	Cw6FXIQlbZE4BKBHH9TMvhXWNrGAbNuRbHKRTijDlKHJJKueeK3AfwleCXUyDuU=
X-Google-Smtp-Source: AGHT+IHI1raF5XEZx6ugM9rq7xZ+1m35vsCAfIsmrZNbGvF40rrrsZfXEL0MmMw0rXWJdsHE/hDoKg==
X-Received: by 2002:a2e:8e95:0:b0:2e1:bb65:8306 with SMTP id 38308e7fff4ca-2e95b27ee28mr86320561fa.44.1716903409814;
        Tue, 28 May 2024 06:36:49 -0700 (PDT)
Received: from umbar.lan ([192.130.178.91])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2e95bcd8e4bsm22566981fa.41.2024.05.28.06.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 May 2024 06:36:48 -0700 (PDT)
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Tue, 28 May 2024 16:36:48 +0300
Subject: [PATCH v5] dt-bindings: ufs: qcom,ufs: drop source clock entries
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240528-msm8996-fix-ufs-v5-1-b475c341126e@linaro.org>
X-B4-Tracking: v=1; b=H4sIAO/dVWYC/3XNQW7CMBAF0Ksgr+tqPBkndle9B+rCScZgqSTIh
 ogqyt0Z2EAVWP75+m9mVTgnLuprM6vMUyppHCTYj43q9mHYsU69ZIWABAheH8rBeV/rmC76HIu
 ODgLXPfWui0pWx8xS3cXtj+R9Kqcx/90fTOZ2fW9NRoM20LQW2TaE8P2bhpDHzzHv1A2b8Akw1
 RpAAWoLjXUd1mTdCqieAbcGKgEIQmjJSxGqFUAPgOAFQAIwm4Cujc42/h+wLMsVV2nY2nIBAAA
 =
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
 Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2765;
 i=dmitry.baryshkov@linaro.org; h=from:subject:message-id;
 bh=LcFYy25T3EVBDfPNggp7aNeBJ3nKQigviyyutbZj/ic=;
 b=owEBbQGS/pANAwAKAYs8ij4CKSjVAcsmYgBmVd3wjxYDqABMNJG8T5NY0H+WB1xmn+b7lcWY1
 UEH8pkv8xKJATMEAAEKAB0WIQRMcISVXLJjVvC4lX+LPIo+Aiko1QUCZlXd8AAKCRCLPIo+Aiko
 1aZGCACuCYcdAXdlGAUU4r4RYvSftl/0cmcCSR3mhiLgGYLGBYCHqAvmzDoLvdh3vD/+sAc2qDd
 bjFixwJ3a5PrTL9W55wg2zRHdKuQaGfeRrfZr9Gb24wxCvUQoYuoNW7FcHJOWJT9aTJ/Wui77bx
 hufH5/z2e1vZsHNKmGAvbkJXJ/3tx2vJku+6wSFivZ+/XXs3ixTYFemkuNRjsZ3aYAqFfc2i78w
 NgScSWVF1N342XvdbTPf6y3pouTmC1nWv6Fztf5FJ6ydyRS7FqIgGv4J4hwKxkzy28NmFuPvPDY
 Hht6JhNGV0HZxSbieaaXLdCgv98mtPxzizVMYgv0+/nNLEQy
X-Developer-Key: i=dmitry.baryshkov@linaro.org; a=openpgp;
 fpr=8F88381DD5C873E4AE487DA5199BF1243632046A

There is no need to mention and/or to touch in any way the intermediate
(source) clocks. Drop them from MSM8996 UFSHCD schema, making it follow
the example lead by all other platforms.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
Changes in v5:
- Rebased on top of linux-next
- Dropped arm64 / DT patches applied by Bjorn
- Link to v4: https://lore.kernel.org/r/20240408-msm8996-fix-ufs-v4-0-ee1a28bf8579@linaro.org

Changes in v4:
- Rebased on top of linux-next to resolve conflict with UFS schema
  changes
- Link to v3: https://lore.kernel.org/r/20240218-msm8996-fix-ufs-v3-0-40aab49899a3@linaro.org

Changes in v3:
- dropped the patch conflicting with Yassine's patch that got accepted
- Cc stable on the UFS change (Manivannan)
- Fixed typos in the commit message (Manivannan)
- Link to v2: https://lore.kernel.org/r/20240213-msm8996-fix-ufs-v2-0-650758c26458@linaro.org

Changes in v2:
- Dropped patches adding RX_SYMBOL_1_CLK, MSM8996 uses single lane
  (Krzysztof).
- Link to v1: https://lore.kernel.org/r/20240209-msm8996-fix-ufs-v1-0-107b52e57420@linaro.org
---
 Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
index cd3680dc002f..25a5edeea164 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -46,11 +46,11 @@ properties:
 
   clocks:
     minItems: 7
-    maxItems: 11
+    maxItems: 9
 
   clock-names:
     minItems: 7
-    maxItems: 11
+    maxItems: 9
 
   dma-coherent: true
 
@@ -217,16 +217,14 @@ allOf:
     then:
       properties:
         clocks:
-          minItems: 11
-          maxItems: 11
+          minItems: 9
+          maxItems: 9
         clock-names:
           items:
-            - const: core_clk_src
             - const: core_clk
             - const: bus_clk
             - const: bus_aggr_clk
             - const: iface_clk
-            - const: core_clk_unipro_src
             - const: core_clk_unipro
             - const: core_clk_ice
             - const: ref_clk
@@ -287,7 +285,7 @@ allOf:
           maxItems: 2
         clocks:
           minItems: 7
-          maxItems: 11
+          maxItems: 9
 
 unevaluatedProperties: false
 

---
base-commit: 652f7c84aa3d99568e9e57d74b08cad927adba4e
change-id: 20240209-msm8996-fix-ufs-f80ae6d4d8cf

Best regards,
-- 
Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

