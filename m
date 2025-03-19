Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C826158DAC
	for <linux-scsi@vger.kernel.org>; Wed, 19 Mar 2025 15:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742398233; cv=none; b=jIXwP7JNXICGv5CAxWfJwVCo55jykV0LBFsnp5vb88EjyiX8fWK792qrGoz6NQtjTS3KrSbGkGjMtFhodKDm+P2SRRwQG2KkZI7c6gZkc6ZcG72e2/iJpmFRDh9KA8Wxs+5kC9GFBz8xPohsCQpPnLIfNkRM3uL9NT577UiySuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742398233; c=relaxed/simple;
	bh=/wdQQT8Uza3QQ8DxhowYsgtSCAG+eJfAgNfJhMqT56E=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=XKDHHG45DGlHUNJ08eNoz9ohtKt76KTMxrqlxOJ8/t/dV6xId64bw/hQGPolRbisO8osdxP7aokvpJVtnX1xPsW3vQM6iVlpwlN18VLrLC+nbGq6vyLhajesSWiPP7O1rU5az04bVWCZ5x2L1fzv1QQRlamdqnqaTgGzMU28Uuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=o7Z6D9mv; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="o7Z6D9mv"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43d0618746bso36572765e9.2
        for <linux-scsi@vger.kernel.org>; Wed, 19 Mar 2025 08:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742398228; x=1743003028; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qEZeyPH3DN6EY3kRLphvmTruJ5WHhFKumGbsm0McfOM=;
        b=o7Z6D9mvwWUc4ik5kMr0HVes3KqDqxi/izaFuSV6KFk0Jz3eOCZ97XGRtH6ovusEQB
         ZQKjDocnTrZ16Mth0FSAbNIbBavwaBePvlntrAJhMKxjKQ5/cpbf3W7Kr6CdS6bbWyco
         WhaE9fGwXxe89H+YUM3jke5gPrPiL1chiEbPdBu8RYLU/f9PsW0QLz+5nPKLMG1aduPg
         F7YUqnyUgX4CfihEnzVrn0TtSpoyHKqHF3opBM/DgFB7kowHfQ4QC7fHYX1twTXowVzD
         04sWdBLP1WZYpSlowIFfGuCWVHL1Da84uOUoBCxN9OFuLTbcDh5fJqQ4YJy5udr3i+at
         4jcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742398228; x=1743003028;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qEZeyPH3DN6EY3kRLphvmTruJ5WHhFKumGbsm0McfOM=;
        b=BHA6BX0AMOPswomilxrmDuJwVNN8AyXi34hUt9y954sQ4wB/oiSgRirPJjTv9uT8W/
         JNZXjNRjRdexQimbbOq4o8QbQQugt20MkWCvwet69r1ubdXZc14r9y+moUrYJiInmtwk
         x7yPDz4PXxyw3Ydzy+dyUXmSHk7JTGsTWpDddcajCjQQ9ISfZoKaCJFBKyo/UoHentM1
         AltQ7mVWSPIHuazl/CZcaLrl5S2Lcfb5vQuwKohNhEYJ6BYrOii1Bc5l4t0WjrYFxOvP
         KkhXIo7LwPUsa4ouw23kkRb3deVY65xbxdpBz4H2UEHB0t+9tTKpmgVvKA42EUrBjalS
         +nGA==
X-Gm-Message-State: AOJu0YyfV9wHjnnpi0HVyVPp0l1AZOY1vLYamgISC00/Ga0Jo7Z4g5tJ
	RM5ZHln4NOPS/Xszu5ngVZDuRf0DiQRFGiPMa1ji/F8TF7mOFZLyMg4EsBGqoB0=
X-Gm-Gg: ASbGncsTd/VDF9vZrzibD4p6RRdibhX1o2dLBHTsoo4FOsyponGeUsXCrT95V4cR1Rz
	ILRYFXcS6N2jGlHrKK7YAQAUZAh/KtmD1qjrYOH92L7Ul7fi9GTGH18HjqofOJKdTal7VVO2hJx
	y5Mzfx5K3XG7LSj4Hl8kDXvtTAj3vv9l4v3Ld/4MBvhI4tjfvzy69iTkmv4BwufhOj17XOsu56U
	Dglg7qpqUCWlYgHcL/bw8XXE8h2s3iV4pI+Qop2RgbuFieoRu5BXKanQFErZK0uG7YszNQK1L4o
	13/3XPSuVpqidFLsrf1IKooU+CKrh4U9At9JjgFQMg1iX1JxOc+FZQ+Hhbyk/n0RuRNYlfpuzVw
	e
X-Google-Smtp-Source: AGHT+IGjnNjwq+MehcbC/hNwNMnENA+yaAifRw6JfmAvbNb+L/5ZJ5fX1A2xaTQSRDS1Im7e3lx1xA==
X-Received: by 2002:a5d:6d8e:0:b0:391:1222:b444 with SMTP id ffacd0b85a97d-399739bedaamr3628438f8f.20.1742398228350;
        Wed, 19 Mar 2025 08:30:28 -0700 (PDT)
Received: from gpeter-l.roam.corp.google.com ([212.105.145.136])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d43fdaca8sm22590635e9.28.2025.03.19.08.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Mar 2025 08:30:27 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
Subject: [PATCH v2 0/7] ufs-exynos stability fixes for gs101
Date: Wed, 19 Mar 2025 15:30:17 +0000
Message-Id: <20250319-exynos-ufs-stability-fixes-v2-0-96722cc2ba1b@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAnj2mcC/x2M0QpGQBQGX0Xn2ilWhFeRi2U/nNLSHv8fybvbX
 E7TzE2KIFBqk5sC/qKy+QgmTWhcrJ/B4iKTyUyZFXnDOC+/Kf8mZT3sIKscF09yQhm1s01dGRR
 upDjYAz4R+65/nhfznIBRbAAAAA==
X-Change-ID: 20250319-exynos-ufs-stability-fixes-e8da9862e3dc
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Krzysztof Kozlowski <krzk@kernel.org>, 
 Chanho Park <chanho61.park@samsung.com>
Cc: linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, 
 Eric Biggers <ebiggers@kernel.org>, Bart Van Assche <bvanassche@acm.org>, 
 willmcvicker@google.com, kernel-team@android.com, tudor.ambarus@linaro.org, 
 andre.draszik@linaro.org, Peter Griffin <peter.griffin@linaro.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2074;
 i=peter.griffin@linaro.org; h=from:subject:message-id;
 bh=/wdQQT8Uza3QQ8DxhowYsgtSCAG+eJfAgNfJhMqT56E=;
 b=owEBbQKS/ZANAwAKAc7ouNYCNHK6AcsmYgBn2uMPIIUjvTrJwB/bf6NJvAEfmLtzYJjS2lH1T
 7BfK9xyJDKJAjMEAAEKAB0WIQQO/I5vVXh1DVa1SfzO6LjWAjRyugUCZ9rjDwAKCRDO6LjWAjRy
 unajD/9Cn7tx2QPnMfbWKfUHujf8hPZa1cu0fDAlEehSOmtXXbYACAJh5RMKun3s4cmXI1SLDV1
 NDgRqHDRg7+OfgTquDBmQBnRltEdbiw5hMN0u6W0+SxUc+7d8cdPvTqml4b3PQY4Hofg77kYdqW
 zDVjS+FgJLNTPm1jAgKGVydFbUxn6uovbzmpPPOJfosNwhRlOqreukBWwmGKVuCjs1/KGv/O4v2
 dzj1Mo+GYACOZPMqttC4X7VB6mFkyb5QnsokohAIhQ11/G8Kom7x0NITrwU7d/B/3ZioHJ4T42t
 uRQ0jqf10+jt3lFQ0fgiLV052oMwmFjEdRA9vMlcAGprcKr2kEvbR3hJxQR/VdRgULSs5LJfPx1
 JX9vgQ4LtCK8b2FlxMNcDCi0RSnIrkAM0Husi1ATJTpelimGuB3TnuT4xN7WouTrCy/UhnhRhrE
 tiym0DZ+nj26EBNIPz9eSmEZc5DrL06IWb4BfEQ9HoTzq7glC/+W36RbVgvG1wic4OovGYK6C2G
 /aGtXnyrs/KBTZDX6rw/1J2piiasyKTZ9/JYcGS5UnCfb//OXZhZcL9teaQCwLUJ0ThNnPykKPw
 oBwHDzjnJvThNpzL/J0fPTOciSwv/SNhaDqxsxRPsge01ie9OD9hS/O9C7z2y2ZBIzpUQok0BWj
 8Fe9IXbmzfPYBtg==
X-Developer-Key: i=peter.griffin@linaro.org; a=openpgp;
 fpr=0EFC8E6F5578750D56B549FCCEE8B8D6023472BA

Hi folks,

This series fixes several stability issues with the upstream ufs-exynos
driver, specifically for the gs101 SoC found in Pixel 6.

The main fix is regarding the IO cache coherency setting and ensuring
that it is correctly applied depending on if the dma-coherent property
is specified in device tree. This fixes the UFS stability issues on gs101
and I would imagine will also fix issues on exynosauto platform that
seems to have similar iocc shareability bits.

Additionally the phy reference counting is fixed which allows module
load/unload to work reliably and keeps the phy state machine in sync
with the controller glue driver.

regards,

Peter

Changes since v1:
 * Added patch for correct handling of iocc depedent on dma-coherent property
 * Rebased onto next-20250319
 * Add a gs101 specific suspend hook (Bart)
 * Drop asserting GPIO_OUT in .exit() (Peter)
 * Remove superfluous blank line (Bart)
 * Update PRDT_PREFECT_EN to PRDT_PREFETCH_EN (Bart)
 * Update commit description for desctype type 3 (Eric)
 * https://lore.kernel.org/lkml/20250226220414.343659-1-peter.griffin@linaro.org/

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
Peter Griffin (7):
      scsi: ufs: exynos: ensure pre_link() executes before exynos_ufs_phy_init()
      scsi: ufs: exynos: move ufs shareability value to drvdata
      scsi: ufs: exynos: disable iocc if dma-coherent property isn't set
      scsi: ufs: exynos: ensure consistent phy reference counts
      scsi: ufs: exynos: Enable PRDT pre-fetching with UFSHCD_CAP_CRYPTO
      scsi: ufs: exynos: Move phy calls to .exit() callback
      scsi: ufs: exynos: gs101: put ufs device in reset on .suspend()

 drivers/ufs/host/ufs-exynos.c | 85 ++++++++++++++++++++++++++++++++-----------
 drivers/ufs/host/ufs-exynos.h |  6 ++-
 2 files changed, 68 insertions(+), 23 deletions(-)
---
base-commit: 433ccb6f2e879866b8601fcb1de14e316cdb0d39
change-id: 20250319-exynos-ufs-stability-fixes-e8da9862e3dc

Best regards,
-- 
Peter Griffin <peter.griffin@linaro.org>

