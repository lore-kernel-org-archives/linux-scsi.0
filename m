Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD571F61C
	for <linux-scsi@vger.kernel.org>; Tue, 26 Mar 2024 17:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711475201; cv=none; b=TEhO+rh1fqp50QkYVFmliiqMY4LtY+L4AnII2raiEVCeEoxE3iQYa74sSWnCC43RH7EA20DGc+KwpeeKj9+A+nWcu6hgBjWEKaaNjnzzoWm7tBoPSRWSp51agN6uWLogl6+Gi6NOmUyOF1fwHiJbamHfdXf75MpETOUcdY2goDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711475201; c=relaxed/simple;
	bh=Az76Er8yXjZV/tqoHhSzJRIVBRn0rXo06jGlOz2rx8Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fvgciX+MuZs5xIUT/hjezBjlreRnngB7ZxuZkmMeoaJMkLpjDLvD51Zp5AdYw0RZXWxWC0j9lDqAM7v+/mz7fXqgQMGxm556jSKwSjIhiDf6OiPryeB0ivoPyrz6Ndg4l0ATcyw7/X8gGruD3LOFTyNHYESVzJC+CCtoPfHQYqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eS1Kh0c/; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eS1Kh0c/"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a468226e135so695806866b.0
        for <linux-scsi@vger.kernel.org>; Tue, 26 Mar 2024 10:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711475197; x=1712079997; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rMq/Chsdogq+cfRuHXND3ep8x+cn4B09GRV/ht38i7U=;
        b=eS1Kh0c/FOy5NJYA0S6xP7LpznhK0XAGKYzfH0H58he3fORWd8LHvqTDk1wnbl4TXn
         VpfFCL4d/N/LIQv0lBpyeRaX9lGfaYTuKLyL6VYXHRIZf+dedj7uLKMQXwBVFMQtHu4G
         ceqPBEmFYxse/yi33Sc1Ht6R2IRtB5+80fyuDw6OFSYPmaitvBcYRvUD3TSON7S50gDE
         LBgdbyM/aeD7Kmu4p1gNDOtQKd8AVj11eIvdS1nepohMTMGnhGLo3NwBcdioYy+z2P96
         jX9Z2JelKmm38dIyrxm9tW/Jm1UmqHIiU9h10VvcS40//raXva/y0DCAaiZE7sRNSd6q
         UcZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711475197; x=1712079997;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rMq/Chsdogq+cfRuHXND3ep8x+cn4B09GRV/ht38i7U=;
        b=E7py/9GJqIHPQTk9UsJeZ//CKsKCh9m8bY7YS954hypkgDNtvfd2JjgrURBit7V6mK
         FIJZqpIa7SfjJjnPxfjcyNfqko/elk6c1y+p6WpmbEvZRfmupR5Czytnlx2JsXuX+amB
         OIO+VN9Gv/Nlk48g4LLoxCPkvtkOuxFcRc5DRNz5D9pC63O6DnB8GHby/PqHBCxHTIln
         lXGnv1HqF/wZWioh0pDB5oPzekujN+dORgIzgLU7angzDi0oFtRZ8OAGnPDyUgga0fZc
         eovr0Pb0QZlnWwAsGznmIweDbDH4yKEs8pdmXi6lg4CF+pTwtUC1dEELxzaTSe9PNyvA
         bq9Q==
X-Forwarded-Encrypted: i=1; AJvYcCX0ES0cs8ofl971ZT5KK0ezS9/zD9hTbvmO0lIXkEd2+oK4yT+OAZezi1/XBfAC6nVcZiMSnmHXV293jfexm7sWqymeCFlVTdfF8g==
X-Gm-Message-State: AOJu0YwsFaUuwa1DKIFgT/9nqyXiBsHSl/dzhyX+4YzNHwPP1PGdGuSH
	CSFiHt2kJSxN1rxSCcGnft/1h7Qh+qdJsy4mwPCL6D9oNJDArSVtRhZn6CV614QLbs5x0asI6pe
	0
X-Google-Smtp-Source: AGHT+IFsb/a8yspkgTaU63ejswPOvVq7IprH+YwgB965qrt8TOYqeYtYghC4E1sSxqaEMfHnP4XXUw==
X-Received: by 2002:a17:906:d10d:b0:a47:16d1:113f with SMTP id b13-20020a170906d10d00b00a4716d1113fmr2580119ejz.47.1711475197572;
        Tue, 26 Mar 2024 10:46:37 -0700 (PDT)
Received: from krzk-bin.. ([178.197.222.44])
        by smtp.gmail.com with ESMTPSA id l19-20020a17090612d300b00a46cffe6d06sm4451438ejb.42.2024.03.26.10.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 10:46:37 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Andy Gross <agross@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 2/3] dt-bindings: ufs: qcom: document SC7180 UFS
Date: Tue, 26 Mar 2024 18:46:31 +0100
Message-Id: <20240326174632.209745-2-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240326174632.209745-1-krzysztof.kozlowski@linaro.org>
References: <20240326174632.209745-1-krzysztof.kozlowski@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document already upstreamed and used Qualcomm SC7180 UFS host controller
to fix dtbs_check warnings like:

  sc7180-idp.dtb: ufshc@1d84000: compatible:0: 'qcom,sc7180-ufshc' is not one of ...
  sc7180-idp.dtb: ufshc@1d84000: clocks: [[39, 99], [39, 7], [39, 98], [39, 107], [36, 0], [39, 106], [39, 105]] is too short
  sc7180-idp.dtb: ufshc@1d84000: clock-names: ['core_clk', 'bus_aggr_clk', 'iface_clk', 'core_clk_unipro', ...] is too short

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 .../devicetree/bindings/ufs/qcom,ufs.yaml     | 34 ++++++++++++++++---
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
index 1ab3d16917ac..7e6d442545ad 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -27,6 +27,7 @@ properties:
           - qcom,msm8996-ufshc
           - qcom,msm8998-ufshc
           - qcom,sa8775p-ufshc
+          - qcom,sc7180-ufshc
           - qcom,sc7280-ufshc
           - qcom,sc8180x-ufshc
           - qcom,sc8280xp-ufshc
@@ -43,11 +44,11 @@ properties:
       - const: jedec,ufs-2.0
 
   clocks:
-    minItems: 8
+    minItems: 7
     maxItems: 11
 
   clock-names:
-    minItems: 8
+    minItems: 7
     maxItems: 11
 
   dma-coherent: true
@@ -113,6 +114,31 @@ required:
 allOf:
   - $ref: ufs-common.yaml
 
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - qcom,sc7180-ufshc
+    then:
+      properties:
+        clocks:
+          minItems: 7
+          maxItems: 7
+        clock-names:
+          items:
+            - const: core_clk
+            - const: bus_aggr_clk
+            - const: iface_clk
+            - const: core_clk_unipro
+            - const: ref_clk
+            - const: tx_lane0_sync_clk
+            - const: rx_lane0_sync_clk
+        reg:
+          maxItems: 1
+        reg-names:
+          maxItems: 1
+
   - if:
       properties:
         compatible:
@@ -250,7 +276,7 @@ allOf:
         reg:
           maxItems: 1
         clocks:
-          minItems: 8
+          minItems: 7
           maxItems: 8
     else:
       properties:
@@ -258,7 +284,7 @@ allOf:
           minItems: 1
           maxItems: 2
         clocks:
-          minItems: 8
+          minItems: 7
           maxItems: 11
 
 unevaluatedProperties: false
-- 
2.34.1

