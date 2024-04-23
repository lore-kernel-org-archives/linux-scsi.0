Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA79A142E88
	for <linux-scsi@vger.kernel.org>; Tue, 23 Apr 2024 20:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713905415; cv=none; b=Oc0aT3Pmk7ep5OBkfmdH+kxNyorZduCatNAnhbNov10dL3bf+78oaOSiqPWoaxQiR5CircefHKLDQATXNq8EMTOJWmpsFb5jDwfdHu7Epj+Vox0mocC3858wY/zlGf+hco/bBd/C2yGe+DOvxO3ZQ/6hp/lhj3d7JzuNBViRQ4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713905415; c=relaxed/simple;
	bh=lN0o2tlEgJg9kalVb74fI9+nLCmdUkqOjjcor3skRjw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gu4jz/xLWoTyYB1Z2Ci6lW1uI0v1DREpM4F3Sntq0PT2IUtojh2RgPT+pcmvE4WwCrHjVIw2Gch2Lr9U9AMBsxRubzzOg0n0TvwacLrWhnS3F6AC2iMTOYMFVmPgSjt/swwkL0Kc6UJlnU2jvrHE4oCLkBHbJU5Tdz2xNfoH5pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aoSFYmNX; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aoSFYmNX"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-41af670185fso918335e9.0
        for <linux-scsi@vger.kernel.org>; Tue, 23 Apr 2024 13:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713905411; x=1714510211; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iDTk5oDvvrRdQcAB/F+kDJkRJSv6Emu0SrjcMhqOn4I=;
        b=aoSFYmNXC/ou/r57z+3a/IZgIYSX0U2P0m6TyNU3xqDDrzyoDwsR5sGSPumc/MfQGN
         HacIoAIdI4eiBLJpBDaUnV+SpnUc64FAjmtWxom3SsFJqr9+HBdNVrTr9nuljy67noBh
         w0vbUZrLYzM/YVmHKiSV0wvnGrwSH6HILedadpveV51j0NaPcJ/Eb65XL6vAVA5OUKF3
         tRaFCvqL8Y2AYUJY6W6l+kwcDNXcFrbEoTE1jryFOcL9/2KkkVqmEdcbuTFsodesw9Sw
         M8ZRxykmNNuJMPg9SK+j6foy4Cbi1m4YVzxU4x0XgCkuy26wH1q5pvWB2kZY8P1LneCZ
         mH9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713905411; x=1714510211;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iDTk5oDvvrRdQcAB/F+kDJkRJSv6Emu0SrjcMhqOn4I=;
        b=Tm36QpSMYe40rGWcjvcwI2LlnBkJWlv8r2kMfdhY0oEn/i9zEXec6W/IHbKe2A+9Ed
         1spnjypIpChET5sYGlMdWqgCslW2KXED4WBH2ctYcICuwHSi5LCGLEQPojYrHkKLh2Sz
         /nrbMb3Yvbu+Lb9Qy7oQFyygHUqxRnLtVSQKbhwk1SsMFCuidNtYLnjPQ6RZhk/BgM7p
         rgrSaToj+cBxqbbGO8fjLeOT0tGW7G6goQh1ZdfHuKbLk1J2ooIO7CtATk/uCvEI04Fz
         gm/XIDeGG+9tPNCNp3MfrqZNorFDCBCFqWGEr63EIOyer9A0WxBIUxOUlSRZ1IVCH5a4
         GBgw==
X-Gm-Message-State: AOJu0YxqdnRjF+eA2nB/GfGMS6vUV2a/LhMlbBqIs6UYSdTjddld7Ady
	Dh++of2AUSN9HNQ0pZ71KrZeArpWnwIzceu3a6MdCPXrRtTHEntj/iB+JefTpNQ=
X-Google-Smtp-Source: AGHT+IH9twwrV4GDTD98S7Dg0JzPI6O8DIUuVeYEzvAw6xtx7WWc6EfOFfwcn0BmyTCvX/h+qFPVTQ==
X-Received: by 2002:a05:600c:4f89:b0:41a:408b:dbd4 with SMTP id n9-20020a05600c4f8900b0041a408bdbd4mr257314wmq.7.1713905411055;
        Tue, 23 Apr 2024 13:50:11 -0700 (PDT)
Received: from gpeter-l.lan ([2a0d:3344:2e8:8510:4269:2542:5a09:9ca1])
        by smtp.gmail.com with ESMTPSA id bg5-20020a05600c3c8500b00419f419236fsm13065443wmb.41.2024.04.23.13.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Apr 2024 13:50:10 -0700 (PDT)
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
Subject: [PATCH v2 00/14] HSI2, UFS & UFS phy support for Tensor GS101
Date: Tue, 23 Apr 2024 21:49:52 +0100
Message-ID: <20240423205006.1785138-1-peter.griffin@linaro.org>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi James, Martin, Alim, Bart, Krzysztof, Vinod, all

Firstly, many thanks to everyone who reviewed and tested v1.

This series adds support for the High Speed Interface (HSI) 2 clock
management unit, UFS controller and UFS phy calibration/tuning for GS101
found in Pixel 6.

With this series applied, UFS is now functional on gs101. The SKhynix
HN8T05BZGKX015 can be enumerated, partitions mounted etc. This allows us to
move away from the initramfs rootfs we have been using for development so far.

Merge Strategy
1) UFS driver/bindings via UFS/SCSI tree (James / Martin / Alim)
2) GS101 DTS/DTSI should go via Krzysztofs Exynos SoC tree
3) Clock driver/bindings via Clock tree (Krzysztof / Stephen)
4) PHY driver/bindings via PHY tree (Vinod)

The v2 series has been rebased on next-20240422, as such all the phy parts
which were already queued by Vinod have been dropped. Two new phy patches
are added to address review feedback received after the patches were queued.

The series is broadly split into the following parts:
1) dt-bindings documentation updates
2) gs101/oriole dts & dtsi updates
3) Prepatory patches for ufs-exynos driver
4) GS101 ufs-exynos support
5) gs101 phy fixes

As well as the v1 review feedback some additional cmu_hsi2 clocks were marked
as CLK_IGNORE_UNUSED in v2 so that all other remaining clocks in cmu_hsi2 can
be disabled and UFS will still be functional.

The sysreg clock was also moved from CLK_IS_CRITICAL in clk-gs101 to ufs node,
as the system is still functional with that clock disabled, however fine grained
clocking just around sysreg register accesses doesn't result in functional UFS.

kind regards,

Peter

Changes since v1:
 - collect up tags
 - google,gs101-clock: alphabetical ordering (Andre)
 - re-order samsung,exynos-ufs.yaml as per Krzysztof review
 - Ensure google,gs101.h dt-bindings is contained with bindings patch (Andre / Krzysztof)
 - fix google,gs101-hsi2-sysreg size (0x10000 not 0x1000) (Andre)
 - drop blank lines in clk-gs101 (Andre)
 - cmu-hsi2 alphabetical ordering (Andre / Krzysztof)
 - use GPIO defines in DT and add TODO pmic comment (Krzysztof)
 - Add sysreg clock to ufs node (Andre)
 - Mark additional cmu_hsi2 clocks with CLK_IGNORE_UNUSED flag (Peter)

lore v1: https://lore.kernel.org/linux-clk/20240404122559.898930-1-peter.griffin@linaro.org/

Peter Griffin (14):
  dt-bindings: clock: google,gs101-clock:  add HSI2 clock management
    unit
  dt-bindings: soc: google: exynos-sysreg: add dedicated hsi2 sysreg
    compatible
  dt-bindings: ufs: exynos-ufs: Add gs101 compatible
  arm64: dts: exynos: gs101: enable cmu-hsi2 clock controller
  arm64: dts: exynos: gs101: Add the hsi2 sysreg node
  arm64: dts: exynos: gs101: Add ufs, ufs-phy and ufs regulator dt nodes
  clk: samsung: gs101: add support for cmu_hsi2
  scsi: ufs: host: ufs-exynos: Add EXYNOS_UFS_OPT_UFSPR_SECURE option
  scsi: ufs: host: ufs-exynos: add EXYNOS_UFS_OPT_TIMER_TICK_SELECT
    option
  scsi: ufs: host: ufs-exynos: allow max frequencies up to 267Mhz
  scsi: ufs: host: ufs-exynos: add some pa_dbg_ register offsets into
    drvdata
  scsi: ufs: host: ufs-exynos: Add support for Tensor gs101 SoC
  phy: samsung-ufs: ufs: remove superfluous mfd/syscon.h header
  phy: samsung-ufs: ufs: exit on first reported error

 .../bindings/clock/google,gs101-clock.yaml    |  30 +-
 .../soc/samsung/samsung,exynos-sysreg.yaml    |   2 +
 .../bindings/ufs/samsung,exynos-ufs.yaml      |  38 +-
 .../boot/dts/exynos/google/gs101-oriole.dts   |  18 +
 arch/arm64/boot/dts/exynos/google/gs101.dtsi  |  54 ++
 drivers/clk/samsung/clk-gs101.c               | 508 +++++++++++++++++-
 drivers/phy/samsung/phy-samsung-ufs.c         |  11 +-
 drivers/ufs/host/ufs-exynos.c                 | 197 ++++++-
 drivers/ufs/host/ufs-exynos.h                 |  24 +-
 include/dt-bindings/clock/google,gs101.h      |  63 +++
 10 files changed, 921 insertions(+), 24 deletions(-)

-- 
2.44.0.769.g3c40516874-goog

