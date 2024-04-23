Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D2F144306
	for <linux-scsi@vger.kernel.org>; Tue, 23 Apr 2024 20:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713905422; cv=none; b=UZul2QcKGT/lnWVYUk6g6BRzB1cd67dCjjhpfDJeBF7C+ybJ2HI2n8qZ0aR1vzno/KOXkuq6ao9V+PX5ezaWeLjO0/tublf+M0ir3hraqvZQTHQrWzth3XTlCa1gfaFXJjFrhrDsen7GR8gRmQDFHvJ2Q2Aa55AdgF7mccRqSGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713905422; c=relaxed/simple;
	bh=WfkPLo16W+IyF/O7XM3xMKPYypFNJEWjEmOzEVbzyPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=croXDirc4rQI0hKUpeIvTnto9xF3X2+YKwDOEWPFRo6kVUy57/HY5aHpkiBqWvBc69SgGfQBNzg2u0Np7g76WYfXG8Oq3P0IhJvyxN85WBoCfjSO+zDXoRVXU4a8fTFhbdhcJqJGe4GE4coT+lzXXlf+YWQwIYtqsQcWWPTaQJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=k6MWVal8; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="k6MWVal8"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-41af670176cso815625e9.0
        for <linux-scsi@vger.kernel.org>; Tue, 23 Apr 2024 13:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713905419; x=1714510219; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RO0Q7DT7yLKUiAcPvW3Nf6mTKRVRL8o5OiH+h8e335U=;
        b=k6MWVal8UG3L3xoeRrUSE8wj+NhXfd9e0AYPlIMtWHOqJ7rrSwe7bmHgg0EBmA9qAN
         vZ87bdKbo8jJ0qr/GYb+2uZM5eg1tj0tWg0hvA9j8gRI/UbEeToqAhWrE/Xjn8l6EFqw
         O3aQWgAYc9Jw1hwukf1rRlIyr5g1Qqbn8mmVcgJo8g/EM8Z3/bJFITO/PIGpq1t6Dd0i
         7hUGkrLYVL1LynXOAAIeOnwIY9nOtAfPe7LpFmpLAUO00D1y2hFH6c0+npLdve9B2g/3
         9+xoaMQB+RRLwvHZ7Jkc0lmcBQRl1F6hhYfaomroUGppd8ueuxAECjH+O2hvYmWeQEJu
         BITg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713905419; x=1714510219;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RO0Q7DT7yLKUiAcPvW3Nf6mTKRVRL8o5OiH+h8e335U=;
        b=gwvKWtCqypNfVECp3uL0XtIRtWLXUnKw5nRimIgN76b9JsS2t9pIsYEivyoURRIDji
         UPgfQGmnJRKTyTtek0gfBtCjIo1R5kyYsAQQqHMAm8Ht+DghGQHVuL+gAh34KtColJwM
         N0eL+rWznafEojestvajPX47hu+Ru1CiJnrsVsz/Hy0UlHnKrH38W9zCDJoatcUWTxYw
         BxfNqw+q3R0XaPpmScK7TTtOr7+e7o0t1ueYJmE2QOf++1X5txC+55vDcwiziu0WkD+U
         DwEBXiR4g1+FFcNYmL04VnPU0Q2c7+RhGkQD4KTNAWKB4tr6q81gWe4DRMtxqSKYICnz
         VpBQ==
X-Gm-Message-State: AOJu0YzUPkikX5fETTIOokcij4xIgVOIiHwPKZGYNkZyz8lzRb9Ym2TK
	EZLZfWDSNCxY8gR1DXPd93u57hwHUceP/mUYb12MOt46OKa1PL8TkeBVQ+9YrtM=
X-Google-Smtp-Source: AGHT+IF8O2EPzbnNSG6U4NWCE/9Bmgh96w+1G9WQQPsP87ZTH8fEdARtLUqlxUJ0kewOWRJsF6pWyg==
X-Received: by 2002:a05:600c:444b:b0:416:7b2c:df0f with SMTP id v11-20020a05600c444b00b004167b2cdf0fmr297771wmn.7.1713905419532;
        Tue, 23 Apr 2024 13:50:19 -0700 (PDT)
Received: from gpeter-l.lan ([2a0d:3344:2e8:8510:4269:2542:5a09:9ca1])
        by smtp.gmail.com with ESMTPSA id bg5-20020a05600c3c8500b00419f419236fsm13065443wmb.41.2024.04.23.13.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Apr 2024 13:50:19 -0700 (PDT)
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
Subject: [PATCH v2 04/14] arm64: dts: exynos: gs101: enable cmu-hsi2 clock controller
Date: Tue, 23 Apr 2024 21:49:56 +0100
Message-ID: <20240423205006.1785138-5-peter.griffin@linaro.org>
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

Enable the cmu_hsi2 clock management unit. It feeds some of
the high speed interfaces such as PCIe and UFS.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 arch/arm64/boot/dts/exynos/google/gs101.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/boot/dts/exynos/google/gs101.dtsi b/arch/arm64/boot/dts/exynos/google/gs101.dtsi
index eddb6b326fde..38ac4fb1397e 100644
--- a/arch/arm64/boot/dts/exynos/google/gs101.dtsi
+++ b/arch/arm64/boot/dts/exynos/google/gs101.dtsi
@@ -1253,6 +1253,18 @@ pinctrl_hsi1: pinctrl@11840000 {
 			interrupts = <GIC_SPI 471 IRQ_TYPE_LEVEL_HIGH 0>;
 		};
 
+		cmu_hsi2: clock-controller@14400000 {
+			compatible = "google,gs101-cmu-hsi2";
+			reg = <0x14400000 0x4000>;
+			#clock-cells = <1>;
+			clocks = <&ext_24_5m>,
+				 <&cmu_top CLK_DOUT_CMU_HSI2_BUS>,
+				 <&cmu_top CLK_DOUT_CMU_HSI2_PCIE>,
+				 <&cmu_top CLK_DOUT_CMU_HSI2_UFS_EMBD>,
+				 <&cmu_top CLK_DOUT_CMU_HSI2_MMC_CARD>;
+			clock-names = "oscclk", "bus", "pcie", "ufs_embd", "mmc_card";
+		};
+
 		pinctrl_hsi2: pinctrl@14440000 {
 			compatible = "google,gs101-pinctrl";
 			reg = <0x14440000 0x00001000>;
-- 
2.44.0.769.g3c40516874-goog

