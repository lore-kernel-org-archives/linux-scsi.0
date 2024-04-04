Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC4585644
	for <linux-scsi@vger.kernel.org>; Thu,  4 Apr 2024 12:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712233574; cv=none; b=I46PSu5QA9uBArjoJ8LPs46PFVy8QdOnI63Ap+NWvRO6Fesatq+SsEPKRlGvclVtbSWEK2rE2DkmuF9H1xtcYz3sftbTd+IBfIgV8m8w6pZwLyF8rVBaDh9iJEc2kpobnMn1i2N6SlTkqvn06sALyJ8F+Qbk+QK4M47CWZhfTn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712233574; c=relaxed/simple;
	bh=bADRJFGOvu1b0zF/Q4lv3G9rwZq8EwwDyeDlWWXD6Co=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e6fv0RU1dZ6z36ffnsb2pQBpFQri64LZ73qrmNMHol3/IAMXokU/mh5rPG20C4oVIw/8FQ6t0oH3yxluiBE3YcInT7hBoyGmzSY5IQEpuU/T2W/b9lsyMKX4QjtxB8xvcARCLkTTtM4yKlkKFi3Mw2BfmiqA/Jcvw7OpHASB9mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=c7Dl8WGr; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="c7Dl8WGr"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-415523d9824so8652605e9.3
        for <linux-scsi@vger.kernel.org>; Thu, 04 Apr 2024 05:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712233570; x=1712838370; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jJYM6tMjtFChrulSjg0o7kKxgUYy0TmdSYB4AKPdhEk=;
        b=c7Dl8WGrjLWTItx3QpPn1tbGFQqqf+0BDlci95hQt4INKr4QDj2vAdy261gNi/3ZeC
         MWTmLH1Ijym07RYr8fKnCgTryJRWtp4Fpz+vHv8xmuMldGQvVby8WysmChWitLVtPNiT
         z6RPvcEmqtab9HTK0NnBg3GcQjCJ0CTiWaVevlsfyie2PqHBY/KgA8jDzmd8IN33zXsd
         +kYLc3WeMwceyJRjnvW0euv985FH9G34i3Cyw7YgoebF3DJwkVvucFtBy4gWCZXHo/gl
         b1m6d+TvR3DENTPLZ6J8PalFntIjOl4uQsOQgddPbORO/YHi7VbFDWdgtk81Hl203YoF
         QUCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712233570; x=1712838370;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jJYM6tMjtFChrulSjg0o7kKxgUYy0TmdSYB4AKPdhEk=;
        b=GZoxVkdL0ZqvYfqXRLpLdl21SryWD4sVW3zF7VZiUf5TMjJbmluXb6F/Y3x+OgZj5W
         4/UJqQUdCobz52M5bpkQpE5b/80AO+MJLAnPZWx0M8T6hUrTGxhMHXaT/h+69PJpzK2g
         SoE/xx8oIL5Cy/cfMOoNTwlS/KnK/E9hDQy8E0bnLwoIPxeABAboO9XfoUE2mvphAahh
         wOUuHZ1fBip0hyBJCYTHosSLRxI1ruOzIvTZR2eA/oB6StPB/OklPE8KWpbZ9IRjuVX5
         j+MKr9JLGrGdls9ZAdze343qIkF2ukFdX2lDUA1L7qQSQ9fIifqYcEAf9Cq5TwinK6UU
         B5JA==
X-Gm-Message-State: AOJu0Yz6gyZDiE3ccYx5TTcld6LSKtTS9KnV4oR905PPLAQOAxyu3Xdw
	5SkezHZ8O9T4Lvg9rNO/zZSjAH/H6LrEoZ5+ieZSucvSZ2TMtBcpeXvIuMMN7DU=
X-Google-Smtp-Source: AGHT+IGhdc0j00kl/SimlNVvg9pgoaeQSTThX/VudHinZM2oZtNar8Jm+FLBUrq74KmHRHDDb/tr/A==
X-Received: by 2002:a05:600c:54ef:b0:415:533b:1071 with SMTP id jb15-20020a05600c54ef00b00415533b1071mr2316215wmb.19.1712233569988;
        Thu, 04 Apr 2024 05:26:09 -0700 (PDT)
Received: from gpeter-l.roam.corp.google.com ([148.252.128.204])
        by smtp.gmail.com with ESMTPSA id bu14-20020a056000078e00b003434b41c83fsm12106303wrb.81.2024.04.04.05.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 05:26:08 -0700 (PDT)
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
Subject: [PATCH 00/17] HSI2, UFS & UFS phy support for Tensor GS101
Date: Thu,  4 Apr 2024 13:25:42 +0100
Message-ID: <20240404122559.898930-1-peter.griffin@linaro.org>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

This series adds support for the High Speed Interface (HSI) 2 clock
management unit, UFS controller and UFS phy calibration/tuning for GS101.

With this series applied, UFS is now functional! The SKhynix HN8T05BZGKX015
can be enumerated, partitions mounted etc. This then allows us to move away
from the initramfs rootfs we have been using for development so far.

The intention is this series will be merged via Krzysztofs Samsung Exynos
tree(s). This series is rebased on next-20240404.

The series is broadly split into the following parts:
1) dt-bindings documentation updates
2) gs101 device tree updates
3) Prepatory patches for samsung-ufs driver
4) GS101 ufs-phy support
5) Prepatory patches for ufs-exynos driver
6) GS101 ufs-exynos support

Question
========

Currently the link comes up in Gear 3 due to ufshcd_init_host_params()
host_params initialisation. If I update that to use UFS_HS_G4 for
negotiation then the link come up in Gear 4. I propose (in a future patch)
to use VER register offset 0x8 to determine whether to set G4 capability
or not (if major version is >= 3).

The bitfield of VER register in gs101 docs is

RSVD [31:16] Reserved
MJR [15:8] Major version number
MNR [7:4] Minor version number
VS [3:0] Version Suffix

Can anyone confirm if other Exynos platforms supported by this driver have
the same register, and if it conforms to the bitfield described above?

I'm also open to suggestions on how else to detect and set G4 if others
have a better idea. It looks like MTK and QCOM drivers both use a version
field, hence the proposal above.

fyi I'm out of office until Monday 12th April, so I will deal with any
review feedback upon my return :-)

For anyone wishing to try out the upstream kernel on their Pixel 6 device
you can find the README on how to build / flash the kernel here
https://git.codelinaro.org/linaro/googlelt/pixelscripts

kind regards,

Peter

Peter Griffin (17):
  dt-bindings: clock: google,gs101-clock:  add HSI2 clock management
    unit
  dt-bindings: soc: google: exynos-sysreg: add dedicated hsi2 sysreg
    compatible
  dt-bindings: ufs: exynos-ufs: Add gs101 compatible
  dt-bindings: phy: samsung,ufs-phy: Add dedicated gs101-ufs-phy
    compatible
  arm64: dts: exynos: gs101: enable cmu-hsi2 clock controller
  arm64: dts: exynos: gs101: Add the hsi2 sysreg node
  arm64: dts: exynos: gs101: Add ufs, ufs-phy and ufs regulator dt nodes
  clk: samsung: gs101: add support for cmu_hsi2
  phy: samsung-ufs: use exynos_get_pmu_regmap_by_phandle() to obtain PMU
    regmap
  phy: samsung-ufs: ufs: Add SoC callbacks for calibration and clk data
    recovery
  phy: samsung-ufs: ufs: Add support for gs101 UFS phy tuning
  scsi: ufs: host: ufs-exynos: Add EXYNOS_UFS_OPT_UFSPR_SECURE option
  scsi: ufs: host: ufs-exynos: add EXYNOS_UFS_OPT_TIMER_TICK_SELECT
    option
  scsi: ufs: host: ufs-exynos: allow max frequencies up to 267Mhz
  scsi: ufs: host: ufs-exynos: add some pa_dbg_ register offsets into
    drvdata
  scsi: ufs: host: ufs-exynos: Add support for Tensor gs101 SoC
  MAINTAINERS: Add phy-gs101-ufs file to Tensor GS101.

 .../bindings/clock/google,gs101-clock.yaml    |  30 +-
 .../bindings/phy/samsung,ufs-phy.yaml         |   1 +
 .../soc/samsung/samsung,exynos-sysreg.yaml    |   2 +
 .../bindings/ufs/samsung,exynos-ufs.yaml      |  51 +-
 MAINTAINERS                                   |   1 +
 .../boot/dts/exynos/google/gs101-oriole.dts   |  17 +
 arch/arm64/boot/dts/exynos/google/gs101.dtsi  |  53 ++
 drivers/clk/samsung/clk-gs101.c               | 558 ++++++++++++++++++
 drivers/phy/samsung/Makefile                  |   1 +
 drivers/phy/samsung/phy-exynos7-ufs.c         |   1 +
 drivers/phy/samsung/phy-exynosautov9-ufs.c    |   1 +
 drivers/phy/samsung/phy-fsd-ufs.c             |   1 +
 drivers/phy/samsung/phy-gs101-ufs.c           | 182 ++++++
 drivers/phy/samsung/phy-samsung-ufs.c         |  21 +-
 drivers/phy/samsung/phy-samsung-ufs.h         |   6 +
 drivers/ufs/host/ufs-exynos.c                 | 197 ++++++-
 drivers/ufs/host/ufs-exynos.h                 |  24 +-
 include/dt-bindings/clock/google,gs101.h      |  63 ++
 18 files changed, 1179 insertions(+), 31 deletions(-)
 create mode 100644 drivers/phy/samsung/phy-gs101-ufs.c

-- 
2.44.0.478.gd926399ef9-goog

