Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C58142E8E
	for <linux-scsi@vger.kernel.org>; Tue, 23 Apr 2024 20:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713905416; cv=none; b=B8eDpXjvDHOEamRc/NUaew1gnUAhYMViqdywEDuvFa+gprdrKwkapSQ52XjK4E9G9WTiL+deT/w3l8w92YpKYkEZFgsIOQfBGejx9UKjc+gSqpn8KUfRPRD3ENfWwoLwfEp5mvA/yh3SayvOGawdiUMs5mwT0+GcdPRNBOu/27A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713905416; c=relaxed/simple;
	bh=AKc/nnsPWAzQ9DsBniEIGOCTdrNmzXBfOXGHhHRpvpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cEkqDtgmxTf6G8PYJA9IqQHnqT7YgUo669j/4XD+6RCAUqQElo161JXDucwTk41OxwjmtI2MCc563ylWuOZA5lXfuBrIvS1WMd2AcvmLhgmmKQL5aGhvmAxOb08ZlcZqeFypG5AdCBRPCC2xPokTvaPWdrH/0lv/rcvK+qMqz7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uv+Apjr6; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uv+Apjr6"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-41aa21b06b3so18375405e9.0
        for <linux-scsi@vger.kernel.org>; Tue, 23 Apr 2024 13:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713905413; x=1714510213; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aF9NHKymRNVxjo0ZhdoKVrePsNXjazgjIUR9b5uzSGg=;
        b=uv+Apjr6z4+BVIPmMFaOZK1nNbe1mxIlHRtRaiQ5O/WD7XS5tbDf4dpaZZ3Y1q2U7M
         Tjvqx+WNQ817n6GAQQoS/1lVYLyOGMxlZ/MA6qxdppNpTU7/FEJC92WfGGDxwnxviOlY
         UlD7oqPIxVp+GchYBYcETEMCu0C+xJ+QjeNZfu9cG9ilNcDZSAoQxrqHyy28crBXZRR3
         UJlgV9+e/4/PMzmIDR07+Kxgjey1T5imsqSangEUnBJP50S4at0H4Kg2wsl1S3nIKQik
         YQHq9ARG+cQjNF0wD76PK9xt/OhOHu0T6bG95qVK3tdpq8MKTzO75h92i66BJ8i9zpOl
         QdCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713905413; x=1714510213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aF9NHKymRNVxjo0ZhdoKVrePsNXjazgjIUR9b5uzSGg=;
        b=TpiInbX5rmPNEm5JCDCS6W6dEkZAZbE1L7ktgwBEubOBQSrjhbmnCkmpjxMiWqhyoj
         nhaCiPShT3DkFoZkCvZoAjZ9nxCsd6hvV4zwtQ9vyo7BDZzPbEJupFbPU4lb1KdqGac8
         OLmrKy+cwr4jw63CjqFQFdboF4Ues4Hx56OxmJpol8wCwin7/Y9t2rksKCMPzti9hQ7b
         +SqoCOxUPGR/76LwXDU1BeMOLcMN+Vs0hKeHexDvr/009IiYyRZ2YCYrfdndl5JEfty5
         Zh23QGvUqlgdZ0KlOFiqjAzFu/bnibEMVkas3cM3wWA8/cbzeKVUQCQyh7GXZHcWEEZo
         m4iA==
X-Gm-Message-State: AOJu0Yw91EFE7oQwfFUPqEmipjXUDECEl/p/g9uTiXuWjeKYjGzAXoAj
	QXj936ESpzaZwgPwqVFzgLY3tdEq/xVTID8Qay3JLITXZJ42A0CUXDkG5Z4jjPk=
X-Google-Smtp-Source: AGHT+IGmqS4/bMk98iT3BUK9bGkkdx/i8oY6ffAbC6ME80YJx8+X4z6pBcQdBu6b6rZbGW5YANVlOw==
X-Received: by 2002:a05:600c:4585:b0:41a:9e0b:ae26 with SMTP id r5-20020a05600c458500b0041a9e0bae26mr267973wmo.41.1713905413165;
        Tue, 23 Apr 2024 13:50:13 -0700 (PDT)
Received: from gpeter-l.lan ([2a0d:3344:2e8:8510:4269:2542:5a09:9ca1])
        by smtp.gmail.com with ESMTPSA id bg5-20020a05600c3c8500b00419f419236fsm13065443wmb.41.2024.04.23.13.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Apr 2024 13:50:12 -0700 (PDT)
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
Subject: [PATCH v2 01/14] dt-bindings: clock: google,gs101-clock:  add HSI2 clock management unit
Date: Tue, 23 Apr 2024 21:49:53 +0100
Message-ID: <20240423205006.1785138-2-peter.griffin@linaro.org>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
In-Reply-To: <20240423205006.1785138-1-peter.griffin@linaro.org>
References: <20240423205006.1785138-1-peter.griffin@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add dt schema documentation and clock IDs for the High Speed Interface
2 (HSI2) clock management unit. This CMU feeds high speed interfaces
such as PCIe and UFS.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Reviewed-by: André Draszik <andre.draszik@linaro.org>
---
 .../bindings/clock/google,gs101-clock.yaml    | 30 ++++++++-
 include/dt-bindings/clock/google,gs101.h      | 63 +++++++++++++++++++
 2 files changed, 91 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/google,gs101-clock.yaml b/Documentation/devicetree/bindings/clock/google,gs101-clock.yaml
index 1d2bcea41c85..8cb0ae4f9996 100644
--- a/Documentation/devicetree/bindings/clock/google,gs101-clock.yaml
+++ b/Documentation/devicetree/bindings/clock/google,gs101-clock.yaml
@@ -29,17 +29,18 @@ properties:
     enum:
       - google,gs101-cmu-top
       - google,gs101-cmu-apm
+      - google,gs101-cmu-hsi2
       - google,gs101-cmu-misc
       - google,gs101-cmu-peric0
       - google,gs101-cmu-peric1
 
   clocks:
     minItems: 1
-    maxItems: 3
+    maxItems: 5
 
   clock-names:
     minItems: 1
-    maxItems: 3
+    maxItems: 5
 
   "#clock-cells":
     const: 1
@@ -72,6 +73,31 @@ allOf:
           items:
             - const: oscclk
 
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - google,gs101-cmu-hsi2
+
+    then:
+      properties:
+        clocks:
+          items:
+            - description: External reference clock (24.576 MHz)
+            - description: High Speed Interface bus clock (from CMU_TOP)
+            - description: High Speed Interface pcie clock (from CMU_TOP)
+            - description: High Speed Interface ufs clock (from CMU_TOP)
+            - description: High Speed Interface mmc clock (from CMU_TOP)
+
+        clock-names:
+          items:
+            - const: oscclk
+            - const: bus
+            - const: pcie
+            - const: ufs_embd
+            - const: mmc_card
+
   - if:
       properties:
         compatible:
diff --git a/include/dt-bindings/clock/google,gs101.h b/include/dt-bindings/clock/google,gs101.h
index 3dac3577788a..ac239ce6821b 100644
--- a/include/dt-bindings/clock/google,gs101.h
+++ b/include/dt-bindings/clock/google,gs101.h
@@ -518,4 +518,67 @@
 #define CLK_GOUT_PERIC1_CLK_PERIC1_USI9_USI_CLK		45
 #define CLK_GOUT_PERIC1_SYSREG_PERIC1_PCLK		46
 
+/* CMU_HSI2 */
+
+#define CLK_MOUT_HSI2_BUS_USER						1
+#define CLK_MOUT_HSI2_MMC_CARD_USER					2
+#define CLK_MOUT_HSI2_PCIE_USER						3
+#define CLK_MOUT_HSI2_UFS_EMBD_USER					4
+#define CLK_GOUT_HSI2_PCIE_GEN4_1_PCIE_003_PHY_REFCLK_IN		5
+#define CLK_GOUT_HSI2_PCIE_GEN4_1_PCIE_004_PHY_REFCLK_IN		6
+#define CLK_GOUT_HSI2_SSMT_PCIE_IA_GEN4A_1_ACLK				7
+#define CLK_GOUT_HSI2_SSMT_PCIE_IA_GEN4A_1_PCLK				8
+#define CLK_GOUT_HSI2_SSMT_PCIE_IA_GEN4B_1_ACLK				9
+#define CLK_GOUT_HSI2_SSMT_PCIE_IA_GEN4B_1_PCLK				10
+#define CLK_GOUT_HSI2_D_TZPC_HSI2_PCLK					11
+#define CLK_GOUT_HSI2_GPC_HSI2_PCLK					12
+#define CLK_GOUT_HSI2_GPIO_HSI2_PCLK					13
+#define CLK_GOUT_HSI2_HSI2_CMU_HSI2_PCLK				14
+#define CLK_GOUT_HSI2_LHM_AXI_P_HSI2_I_CLK				15
+#define CLK_GOUT_HSI2_LHS_ACEL_D_HSI2_I_CLK				16
+#define CLK_GOUT_HSI2_MMC_CARD_I_ACLK					17
+#define CLK_GOUT_HSI2_MMC_CARD_SDCLKIN					18
+#define CLK_GOUT_HSI2_PCIE_GEN4_1_PCIE_003_DBI_ACLK_UG			19
+#define CLK_GOUT_HSI2_PCIE_GEN4_1_PCIE_003_MSTR_ACLK_UG			20
+#define CLK_GOUT_HSI2_PCIE_GEN4_1_PCIE_003_SLV_ACLK_UG			21
+#define CLK_GOUT_HSI2_PCIE_GEN4_1_PCIE_003_I_DRIVER_APB_CLK		22
+#define CLK_GOUT_HSI2_PCIE_GEN4_1_PCIE_004_DBI_ACLK_UG			23
+#define CLK_GOUT_HSI2_PCIE_GEN4_1_PCIE_004_MSTR_ACLK_UG			24
+#define CLK_GOUT_HSI2_PCIE_GEN4_1_PCIE_004_SLV_ACLK_UG			25
+#define CLK_GOUT_HSI2_PCIE_GEN4_1_PCIE_004_I_DRIVER_APB_CLK		26
+#define CLK_GOUT_HSI2_PCIE_GEN4_1_PCS_PMA_PHY_UDBG_I_APB_PCLK		27
+#define CLK_GOUT_HSI2_PCIE_GEN4_1_PCS_PMA_PIPE_PAL_PCIE_I_APB_PCLK	28
+#define CLK_GOUT_HSI2_PCIE_GEN4_1_PCS_PMA_PCIEPHY210X2_QCH_I_APB_PCLK	29
+#define CLK_GOUT_HSI2_PCIE_IA_GEN4A_1_I_CLK				30
+#define CLK_GOUT_HSI2_PCIE_IA_GEN4B_1_I_CLK				31
+#define CLK_GOUT_HSI2_PPMU_HSI2_ACLK					32
+#define CLK_GOUT_HSI2_PPMU_HSI2_PCLK					33
+#define CLK_GOUT_HSI2_QE_MMC_CARD_HSI2_ACLK				34
+#define CLK_GOUT_HSI2_QE_MMC_CARD_HSI2_PCLK				35
+#define CLK_GOUT_HSI2_QE_PCIE_GEN4A_HSI2_ACLK				36
+#define CLK_GOUT_HSI2_QE_PCIE_GEN4A_HSI2_PCLK				37
+#define CLK_GOUT_HSI2_QE_PCIE_GEN4B_HSI2_ACLK				38
+#define CLK_GOUT_HSI2_QE_PCIE_GEN4B_HSI2_PCLK				39
+#define CLK_GOUT_HSI2_QE_UFS_EMBD_HSI2_ACLK				40
+#define CLK_GOUT_HSI2_QE_UFS_EMBD_HSI2_PCLK				41
+#define CLK_GOUT_HSI2_CLK_HSI2_BUS_CLK					42
+#define CLK_GOUT_HSI2_CLK_HSI2_OSCCLK_CLK				43
+#define CLK_GOUT_HSI2_SSMT_HSI2_ACLK					44
+#define CLK_GOUT_HSI2_SSMT_HSI2_PCLK					45
+#define CLK_GOUT_HSI2_SYSMMU_HSI2_CLK_S2				46
+#define CLK_GOUT_HSI2_SYSREG_HSI2_PCLK					47
+#define CLK_GOUT_HSI2_UASC_PCIE_GEN4A_DBI_1_ACLK			48
+#define CLK_GOUT_HSI2_UASC_PCIE_GEN4A_DBI_1_PCLK			49
+#define CLK_GOUT_HSI2_UASC_PCIE_GEN4A_SLV_1_ACLK			50
+#define CLK_GOUT_HSI2_UASC_PCIE_GEN4A_SLV_1_PCLK			51
+#define CLK_GOUT_HSI2_UASC_PCIE_GEN4B_DBI_1_ACLK			52
+#define CLK_GOUT_HSI2_UASC_PCIE_GEN4B_DBI_1_PCLK			53
+#define CLK_GOUT_HSI2_UASC_PCIE_GEN4B_SLV_1_ACLK			54
+#define CLK_GOUT_HSI2_UASC_PCIE_GEN4B_SLV_1_PCLK			55
+#define CLK_GOUT_HSI2_UFS_EMBD_I_ACLK					56
+#define CLK_GOUT_HSI2_UFS_EMBD_I_CLK_UNIPRO				57
+#define CLK_GOUT_HSI2_UFS_EMBD_I_FMP_CLK				58
+#define CLK_GOUT_HSI2_XIU_D_HSI2_ACLK					59
+#define CLK_GOUT_HSI2_XIU_P_HSI2_ACLK					60
+
 #endif /* _DT_BINDINGS_CLOCK_GOOGLE_GS101_H */
-- 
2.44.0.769.g3c40516874-goog

