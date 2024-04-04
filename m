Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E5312E1C0
	for <linux-scsi@vger.kernel.org>; Thu,  4 Apr 2024 12:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712233612; cv=none; b=Ob99h+hkXyJRh0Mux93vGISaEw2kfZ08hGtjEJuuljVBHdktkV1vpkrpt2d/2AbfpWKphqoyGpxA06vS6DfdJsspzHJv3lWdv0KHcbS54dDIkgLQBzD3fH6hqIB32cGOle4GO20iCjHwAqdwHofyM2VUO9uRwk2KaisTT5xqgLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712233612; c=relaxed/simple;
	bh=pLsBolex5BBzVJny3h+qANgA+FdDOJdRlIZd3QZQFO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qqvq23Ynctqro9ESdJEt/R5OAZed36Y+ukQVgRmsDYDzI1UHu+J+xkygso6jyifQ5C4gHVedN4VZQCJ9gofFsePCixL19E+1zIEHNj6lERcWc1OWOynNCi6BS5pH7d6Y1S4akVBOWa2Y26EheRuLtIPHSZGMFXjdhtwKVK05FG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RE/o0Hsv; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RE/o0Hsv"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2d6fd3cfaa6so12871691fa.2
        for <linux-scsi@vger.kernel.org>; Thu, 04 Apr 2024 05:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712233609; x=1712838409; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aKvvN74xOJwt4hMDICXFAAtS9sJu4IkWmxjimbRwKsc=;
        b=RE/o0HsvZK+ztocFaKv2RRKCT4K3G4kA8V+mIy+vTJwjiqURhj2+OXBbRH5RhP/Ozh
         pbasYQKOKpx96Y301KPGPj1FvoChGGriFx4wD/vp+U7c06O1CT5nzpj42MRgaJpMaUGd
         Cuki83EsJO5crHm9MtJ3/E73E+LXx8RJr9IwTouA/KgZeRF67CAliSrbTsQcQ2hVTszO
         iWOEbHfJQlKos5NyMxoTkY9akmKMa3ValAoS8wgfvuAT5Fwkg0T0OEuW0bHC94y1WDcF
         Jhr3KZTRejuuQ7P4HrwIAnBBBgNyESQD3sr6qfKQz6KNbaDegmLGk9sFsUt8iYSV6/g7
         cXeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712233609; x=1712838409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aKvvN74xOJwt4hMDICXFAAtS9sJu4IkWmxjimbRwKsc=;
        b=W1K6cep69gMMOlpFwMwraJ8+IIiEVGLpJvMO34NTOD5hSPq/pXaH/O/Bt/2WeZ16B+
         MX+xUgGOQg4N9QvTYf61zuBo1o/ouAPZc3BYkKKbEGFjbBrFk4bIIt49nOttsyhWFuK3
         OgFYbzF7wcL7/RIzMgVPoVdDzHHCd2Wj5wVYjYQJoOUCKNZxba1H6WeWY3dhTGT6A8xj
         7d3FUBhHCumYEV5U5HrnYNA5sj0xGt5uXq4fZjKf2RZlMOxHOFuMjqYLw8l29acXk9LT
         YHpZUTMi9SALRqoJPG5fwK6I01N30S7uxo4vSCCKYhJOM6/pLnvyFJ9k0Ol+mNp0rQwu
         RH0Q==
X-Gm-Message-State: AOJu0YwKHVtzk1/SMWSvXbHPJMhoeWRl/NtjXJpd/wmNPgTJ6yGmLY0w
	0WHhe6m4A5/2WaBORq8KNZ3WOqMkU7TY32vIFpP7yFJjMN4pnGCOT9AMp7Ca6ME=
X-Google-Smtp-Source: AGHT+IGXhK8kMBWmKF1bq1+yuzbm7UyP2S0ScsyuzRrvPgM0bVlL1iwbvXwfSAAP4OVpq6OKWPN1Ew==
X-Received: by 2002:a05:651c:1a2c:b0:2d8:5726:4173 with SMTP id by44-20020a05651c1a2c00b002d857264173mr1548167ljb.43.1712233609033;
        Thu, 04 Apr 2024 05:26:49 -0700 (PDT)
Received: from gpeter-l.roam.corp.google.com ([148.252.128.204])
        by smtp.gmail.com with ESMTPSA id bu14-20020a056000078e00b003434b41c83fsm12106303wrb.81.2024.04.04.05.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 05:26:48 -0700 (PDT)
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
Subject: [PATCH 06/17] arm64: dts: exynos: gs101: Add the hsi2 sysreg node
Date: Thu,  4 Apr 2024 13:25:48 +0100
Message-ID: <20240404122559.898930-7-peter.griffin@linaro.org>
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

This has some configuration bits such as sharability that
are required by UFS.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 arch/arm64/boot/dts/exynos/google/gs101.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/exynos/google/gs101.dtsi b/arch/arm64/boot/dts/exynos/google/gs101.dtsi
index 38ac4fb1397e..608369cec47b 100644
--- a/arch/arm64/boot/dts/exynos/google/gs101.dtsi
+++ b/arch/arm64/boot/dts/exynos/google/gs101.dtsi
@@ -1265,6 +1265,12 @@ cmu_hsi2: clock-controller@14400000 {
 			clock-names = "oscclk", "bus", "pcie", "ufs_embd", "mmc_card";
 		};
 
+		sysreg_hsi2: syscon@14420000 {
+			compatible = "google,gs101-hsi2-sysreg", "syscon";
+			reg = <0x14420000 0x1000>;
+			clocks = <&cmu_hsi2 CLK_GOUT_HSI2_SYSREG_HSI2_PCLK>;
+		};
+
 		pinctrl_hsi2: pinctrl@14440000 {
 			compatible = "google,gs101-pinctrl";
 			reg = <0x14440000 0x00001000>;
-- 
2.44.0.478.gd926399ef9-goog

