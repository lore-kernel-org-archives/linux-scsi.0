Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974CA12D75C
	for <linux-scsi@vger.kernel.org>; Thu,  4 Apr 2024 12:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712233606; cv=none; b=h3J/F7KA0ffjnQn+rbHFArLNa5ClL88gCW6YHQerUI0IB1gyc5SRnBjlpWUTiswpLc/a7uCMwIQ+HRh7a3CeOiGnhhywe24TRQsR7eZF8tvXLQhrgYYf+e5rxvxUgPOKgzuY9yH1NHDAJmd3I1Hfu6nf0qrCveThtLZ5c82vmis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712233606; c=relaxed/simple;
	bh=2iMqsB7DjaDv1tdJXp6qd7zyM2tt1u3QD0+LtNhzesM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZoEi+lFMA/C7efrfkaRBSce2GI8gZtDDRM2pcCQJLzbIIq8hZ1H9uLNvs9gtTN5Op4RNDUOc0P/mB3dV1Q0gHjSDOqOKUjYCzOvQNWFT8r1z5OzRZBI/YAlOZskIXxp0MI+ACuj3YE7Sysr68gkmN7NUI+YdMlTWCjOtBRF1zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GpD0U80T; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GpD0U80T"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-343cfa6faf0so144217f8f.0
        for <linux-scsi@vger.kernel.org>; Thu, 04 Apr 2024 05:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712233603; x=1712838403; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ds/JjfQ2TlKCtemWTNTPAMOOadxWRRjHRCXTNztqFqc=;
        b=GpD0U80Thdn+K86O7VaQ+vay5qFHr6oDMSq5rpVutDjzkSFrf0MuPLOBbI9SLNLssO
         mSIVHC4Ue/C81pVaNrMqDJHQu6U50mf/XQYFGLmQfAhKFrQ70qfjYM8VMRCzXAxcs+SK
         Uq5PH8B3MjwGyw67dL7vpjKjbPAYiUWg4Rp3lGwCdGX0xFsBnM7kXFRP+/Ur288bJdws
         0ZcoxRWEbPI/ot7X46RF4YfIXrH98lsXyiZoBrs2MZFhY5wH7TVYFYA3yXUkwkAOP47n
         D9LKoxHRnbAzJhesmVHfyt9Da8QXfkzrVFJxB44elRjtC3sxaNBDTsBJM3k/dzgcRyFX
         T41A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712233603; x=1712838403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ds/JjfQ2TlKCtemWTNTPAMOOadxWRRjHRCXTNztqFqc=;
        b=F2BOagcWJKHR9ekiw4Ans4VIiKxyTbfIzYLvAPxFtBkefbjEculMCsINZYdqJ0tU45
         d3fVVYVUkercRbcRE+BmMnJAomhonrGE08vXa7z4TexSdaUAwU1U04/EisbtMsP9bh3e
         vxMDhXvC300yGL8TCyvqv9aSh/rgcucGoakQjA5k6v96TrFCShAGdmJ5iDavSXlC+wWH
         bSoLBUccIhVDrRh9igMuIzo9LRtGfFOUYmcFIScTgPAgTATVsVjAOtTjY+ptXrsg1rOU
         iX/86mfh49rnk2G0U+mq9wAmrzEyP8IU6cqywklaxose1BEiSGjJndUz3e3IdHeWPCKA
         kDrQ==
X-Gm-Message-State: AOJu0Yx+s4TKUKzgtxVyzoITHIwC6CUi2LUVGtYt670CCMhkP4ssDY4/
	L1bwjAeTji8ChWMGfqJL0YTNC3r2k8FGI/JMo98orwZh6L9BbbLt/ja6muop9wI=
X-Google-Smtp-Source: AGHT+IE1KcSWtq0AtIR6tJqtMgKw1sNq7p9OsCBJVxmziFYXd9baY73voLcHuEo5/99B79vRXGQPWg==
X-Received: by 2002:a5d:4589:0:b0:33e:c528:c900 with SMTP id p9-20020a5d4589000000b0033ec528c900mr2144866wrq.55.1712233603079;
        Thu, 04 Apr 2024 05:26:43 -0700 (PDT)
Received: from gpeter-l.roam.corp.google.com ([148.252.128.204])
        by smtp.gmail.com with ESMTPSA id bu14-20020a056000078e00b003434b41c83fsm12106303wrb.81.2024.04.04.05.26.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 05:26:41 -0700 (PDT)
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
	chanho61.park@samsung.com,
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
Subject: [PATCH 05/17] arm64: dts: exynos: gs101: enable cmu-hsi2 clock controller
Date: Thu,  4 Apr 2024 13:25:47 +0100
Message-ID: <20240404122559.898930-6-peter.griffin@linaro.org>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
In-Reply-To: <20240404122559.898930-1-peter.griffin@linaro.org>
References: <20240404122559.898930-1-peter.griffin@linaro.org>
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
2.44.0.478.gd926399ef9-goog

