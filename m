Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23C0143C5B
	for <linux-scsi@vger.kernel.org>; Tue, 23 Apr 2024 20:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713905421; cv=none; b=aUeJ/3OD7azXiePgB+mV2sfPhv1pUX4WWROaCsxBWFeWrwIRBOy6fT6agooulXtBFWPcBuFW/6QgIPrCvde15gD+9Ax+CSiCQofcgbNQbLJ1jlWa4aGxOpkhiTDa3ckYHIhpesWe2YMIMRaj38nQT45ilPs1puHbKXyo++FbM5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713905421; c=relaxed/simple;
	bh=BXQ2t9iAj7eohIsEGoqiB0oQevfiMgMotmBetgnWWks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQgJ3SoAALNe8EohJha6rbVX3nrKEKrNBbgwKBCBhzYUYH3NqLXnQ7SwXihPCuvZXJgTL3CwD2KGko4/yBoAACWDB/Ps2AxbynnjD7Y98psjJ9iAnvRx3wTsJOcD/YVOLg2gXZI5rO3gurBomIXO286/vjUTNLINzddJwBJ3ww8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NYHtLYuR; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NYHtLYuR"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-41a5b68eceeso20029475e9.3
        for <linux-scsi@vger.kernel.org>; Tue, 23 Apr 2024 13:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713905417; x=1714510217; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7YDoEtxb3WAccXiFYU++BdYy9LiGKO7VakM6fMKLsd0=;
        b=NYHtLYuRD8KiNchDzCfr5vYz24pnWq3+l5rwgx+EZ5aeiEmRMmofy/vq4IhBIdfbpE
         8gdnAADZgVqNnnZpr2HO0td7v/iurPIVo+5961eRr/WgGZOKdezdmCobp5CHMZnXbY2C
         JiqQ6c5mPqL6mwEqo17vDki9tpIz2wUlJ0iOICTq1oNo1IL3o0Exz+K1dpnhgVoEidGy
         9r+hx0O1slo4GN3jJ58wDpfFh2Kvnjk4vjUxoK8WKoiYMNJK/Oj4hgPnFYZMY4z2ogTt
         ubDucXIOU58k6Z3OlXNQ0HFB9ZKjZ5JLAKcEw7QHi67uSxMNY4CYhmlufuz/vFT3jax+
         tRWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713905417; x=1714510217;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7YDoEtxb3WAccXiFYU++BdYy9LiGKO7VakM6fMKLsd0=;
        b=phqX9P0ptX53Ru9NGqiAfGPZBsE2cFnXLo5RiAJwUuVMuYz/T7Ygf6jLo5POBuvxT0
         lSmkOM0Xs948UbtGgm5/J+GyLUhvUaumy8LUlDdVyQzQoFgRmTD4+JE2vMzeqdlFcwP+
         3vQllqTXKWDNC79sM+XLjlGySkTVH/iL9QzdTg6xA8gsd/pL+SqGx6gE81r2I3eUkmrn
         lsdJaizvQFJYGtOpdvUm4qhyvStDEM5YPOha1QXc9OtiAJD8GIu+oj7KT4Yw1wKZQTmE
         ZKvYOk9plgyKy7vIcCaA7M4gCjTbddFg8+kyuTOeBgxnmG3EL5/5zNd/T0VaOKM9leW1
         f+jQ==
X-Gm-Message-State: AOJu0Ywf71tk2RfiZ74V/cgImW6sOcK3ZWZYWv7KE7SBte+6RFQm5jSJ
	A9/g+x0ePunmLD5XYrnPBdBmXMtT9j5AXRdthgfjXJsVK2NmvPJ4IG7F6tWrcJA=
X-Google-Smtp-Source: AGHT+IG67KylFXiAI0/BsAFLR1B8wx1LOJwe93ySSY8NQpxdP8gGTGPG7VdGHrq1rWe4qptsIIR9aA==
X-Received: by 2002:a05:600c:310a:b0:418:5e80:a6fa with SMTP id g10-20020a05600c310a00b004185e80a6famr337401wmo.14.1713905417453;
        Tue, 23 Apr 2024 13:50:17 -0700 (PDT)
Received: from gpeter-l.lan ([2a0d:3344:2e8:8510:4269:2542:5a09:9ca1])
        by smtp.gmail.com with ESMTPSA id bg5-20020a05600c3c8500b00419f419236fsm13065443wmb.41.2024.04.23.13.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Apr 2024 13:50:17 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: mturquette@baylibre.com,
	sboyd@kernel.org,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	vkoul@kernel.org,
	kishon@kernel.org,
	alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	s.nawrocki@samsung.com,
	cw00.choi@samsung.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	ebiggers@kernel.org
Cc: linux-scsi@vger.kernel.org,
	linux-phy@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-clk@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	tudor.ambarus@linaro.org,
	andre.draszik@linaro.org,
	saravanak@google.com,
	willmcvicker@google.com,
	Peter Griffin <peter.griffin@linaro.org>
Subject: [PATCH v2 03/14] dt-bindings: ufs: exynos-ufs: Add gs101 compatible
Date: Tue, 23 Apr 2024 21:49:55 +0100
Message-ID: <20240423205006.1785138-4-peter.griffin@linaro.org>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
In-Reply-To: <20240423205006.1785138-1-peter.griffin@linaro.org>
References: <20240423205006.1785138-1-peter.griffin@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add dedicated google,gs101-ufs compatible for Google Tensor gs101
SoC.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 .../bindings/ufs/samsung,exynos-ufs.yaml      | 38 +++++++++++++++++--
 1 file changed, 35 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
index b2b509b3944d..1179527d29d1 100644
--- a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
@@ -12,12 +12,10 @@ maintainers:
 description: |
   Each Samsung UFS host controller instance should have its own node.
 
-allOf:
-  - $ref: ufs-common.yaml
-
 properties:
   compatible:
     enum:
+      - google,gs101-ufs
       - samsung,exynos7-ufs
       - samsung,exynosautov9-ufs
       - samsung,exynosautov9-ufs-vh
@@ -38,14 +36,24 @@ properties:
       - const: ufsp
 
   clocks:
+    minItems: 2
     items:
       - description: ufs link core clock
       - description: unipro main clock
+      - description: fmp clock
+      - description: ufs aclk clock
+      - description: ufs pclk clock
+      - description: sysreg clock
 
   clock-names:
+    minItems: 2
     items:
       - const: core_clk
       - const: sclk_unipro_main
+      - const: fmp
+      - const: ufs_aclk
+      - const: ufs_pclk
+      - const: sysreg
 
   phys:
     maxItems: 1
@@ -72,6 +80,30 @@ required:
   - clocks
   - clock-names
 
+allOf:
+  - $ref: ufs-common.yaml
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: google,gs101-ufs
+
+    then:
+      properties:
+        clocks:
+          minItems: 6
+
+        clock-names:
+          minItems: 6
+
+    else:
+      properties:
+        clocks:
+          maxItems: 2
+
+        clock-names:
+          maxItems: 2
+
 unevaluatedProperties: false
 
 examples:
-- 
2.44.0.769.g3c40516874-goog

