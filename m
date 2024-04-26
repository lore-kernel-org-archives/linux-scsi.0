Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC60D14533C
	for <linux-scsi@vger.kernel.org>; Fri, 26 Apr 2024 12:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714134011; cv=none; b=Cbg6/V/CzlJticDLY0HpqzqJ6jGl51llkFy1JGoQnM43uDohs35ah3AmXkhFchWiECmqYxEGYrLxx2Dm1sygBwKhpWw0wHQK/3UnY5K1ZxYOVJjmcEOQixJf6RmBleIc1w7SRGJrT4EHQ1V1ZAZDZ+Qktg0697DpSduZnF8ZGO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714134011; c=relaxed/simple;
	bh=Dy1L4klZ6E+fyZtM7GjTA+qKnPaR5xUfnO2DtXSeshA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pMwEBpAoJ+pWJBVco+TXYcOATbHUGECMCpnup1Ri3crE4F5lDGGOMzDdhRr3F0GH1VnVg896YS6HL/lDALOyw4HHhjsPHi4BNDRgRWv4cQRTWfKCk6VdISury4mN2FVeny5JLmK6LfGADG333vp99mP+FMwhJ2Q62hgMf9400x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SOX0o0z6; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SOX0o0z6"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-34b1e35155aso2249120f8f.3
        for <linux-scsi@vger.kernel.org>; Fri, 26 Apr 2024 05:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1714134008; x=1714738808; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BvGxGr2jzc7HNRAdQ7sDWvGQAeqzlPRu9vORrfxhJ08=;
        b=SOX0o0z61zdV4+fgRNnMGR2E7G7JnOCaf65es7OJ1W5qMnBXhdGWDzV/gsOe/ZbV5g
         3FDDmeB58fPGLyT79m71TjRl1yclzXAlR/yzz20VvInyt0vxKYcWm36gbWYgp4npqcNF
         yVDDUeiy1TDUBD1mXqtQsuBrlW6lBhs2pscX0P77rFWhb0HB2icyw+zeN78h+4iR70hx
         9QaoO2UjGHKXSco4IwkaGqupDmpca9v25XW6yDcjx8BAf6hAF6mlq4jCfmkJATzEK0MR
         rhQmfswkaAXRAds4LphvvkHuZ3vnFXR7qEsi612seypUmG2l8iEYtOZiw/0UDvxOqHuz
         nwxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714134008; x=1714738808;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BvGxGr2jzc7HNRAdQ7sDWvGQAeqzlPRu9vORrfxhJ08=;
        b=eYlbn9LnnMGXRRLYQKjKX3h/+6x/x47zvSEuJwfyb3xJ+rqIsowS7kzwY78fpP5v4a
         gKFSTN59e2HGHcuk/AVkhSykdA2nvG5318xE2rN/eDR9kq24TObKAQTh57JOXOBJaejL
         Pha2JW2cKVZNv26jlkKciwoGRKLx+M+Rqsy8/Mm9PRP+TXUr4uDKDHFhWVDRUqe91cnd
         XhqBN9S+2lsw64ElsnIgjPt7QylL6VICw69rAna/bMI9VWJAs2RqoxfJ91NSIt2fxFwf
         uUu41Pe3574VDxxD4VDuCbc+hSflvIyM3RkRPzDxT6be+glYe2VsJC/77aQOdtQ1fUt4
         /NFA==
X-Gm-Message-State: AOJu0YzM3fjBBy0b4imR3FGzz2mAXEKFu8o3hqepdk4opM/rGMq0pUML
	oJ73/XWw0gWMU9Q/cp47abaM9q70HKXNEjcScV2fdVzBPvhxceo59PaBULHWsO0=
X-Google-Smtp-Source: AGHT+IEsg35qRGx7lt+VkeY9EjpUvvgqNyRCP2x9AyOQiNHCiXlefq3poByoLhtygl/AAoAgySNIAQ==
X-Received: by 2002:adf:a457:0:b0:34a:4f1c:3269 with SMTP id e23-20020adfa457000000b0034a4f1c3269mr2072375wra.0.1714134008049;
        Fri, 26 Apr 2024 05:20:08 -0700 (PDT)
Received: from gpeter-l.lan ([2a0d:3344:2e8:8510:63cc:9bae:f542:50e4])
        by smtp.gmail.com with ESMTPSA id q2-20020adff942000000b00346bda84bf9sm22478146wrr.78.2024.04.26.05.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 05:20:07 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tudor.ambarus@linaro.org,
	andre.draszik@linaro.org,
	saravanak@google.com,
	willmcvicker@google.com,
	kernel-team@android.com,
	Peter Griffin <peter.griffin@linaro.org>
Subject: [PATCH v3 0/6] ufs-exynos support for Tensor GS101
Date: Fri, 26 Apr 2024 13:19:58 +0100
Message-ID: <20240426122004.2249178-1-peter.griffin@linaro.org>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Martin, James & Alim,

This series adds support to the ufs-exynos driver for Tensor gs101 found
in Pixel 6. It was send previously in [1] and [2] but included the other
clock, phy and DTS parts. This series has been split into just the
ufs-exynos part to hopefully make things easier.

With this series, plus the phy, clock and dts changes UFS is functional
upstream for Pixel 6. The SKhynix HN8T05BZGKX015 can be enumerated,
partitions mounted etc.

The series is split into some prepatory patches for ufs-exynos and a final
patch that adds the gs101 support.

Note the sysreg clock has been moved to ufs node as fine grained clock
control around the syscon sysreg register accesses doesn't result in
functional UFS.

regards,

Peter

Changes since v2:
 - Split into separate per subsystem/maintainer series
   (ufs, phy, clock, dts)
 - Remove ufs_ prefix on clock names (Rob)

Changes since v1:
 - collect up tags
 - re-order samsung,exynos-ufs.yaml as per Krzysztof review
 - Add sysreg clock to ufs node (Andre)

lore v1: https://lore.kernel.org/linux-clk/20240404122559.898930-1-peter.griffin@linaro.org/
lore v2: https://lore.kernel.org/linux-kernel/20240423205006.1785138-1-peter.griffin@linaro.org/


Peter Griffin (6):
  dt-bindings: ufs: exynos-ufs: Add gs101 compatible
  scsi: ufs: host: ufs-exynos: Add EXYNOS_UFS_OPT_UFSPR_SECURE option
  scsi: ufs: host: ufs-exynos: add EXYNOS_UFS_OPT_TIMER_TICK_SELECT
    option
  scsi: ufs: host: ufs-exynos: allow max frequencies up to 267Mhz
  scsi: ufs: host: ufs-exynos: add some pa_dbg_ register offsets into
    drvdata
  scsi: ufs: host: ufs-exynos: Add support for Tensor gs101 SoC

 .../bindings/ufs/samsung,exynos-ufs.yaml      |  38 +++-
 drivers/ufs/host/ufs-exynos.c                 | 197 ++++++++++++++++--
 drivers/ufs/host/ufs-exynos.h                 |  24 ++-
 3 files changed, 241 insertions(+), 18 deletions(-)

-- 
2.44.0.769.g3c40516874-goog

