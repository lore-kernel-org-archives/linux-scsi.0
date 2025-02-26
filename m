Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9A526A0DE
	for <linux-scsi@vger.kernel.org>; Wed, 26 Feb 2025 22:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740607463; cv=none; b=j5G2TkdH/FHt+bq0DXSNczIAZO7iL0HRWrWPyuZx7xroZOD15t12JHX61gwgHGFF2fsovEipyHZ8BPSZZbq/1IxuOGUxds7JkOp9/RIa2v4dZlDtK7qTuuMKkCMdjjlSXwm9pocV5zKvOhmWKMMWNBM6u80h8QOnswPRfgfCj/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740607463; c=relaxed/simple;
	bh=edjG7+NpM6hUw8RgFAOna+b2UsEfIHK1mS5PuS8JmAo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oZBNYBstAFl0Huav7XZxF+D9pGWvNnSLERCKgbyTJcWn/d1BEELfaCorBgaF9PKHyha1/vVKt3JPG6AxeE7zV8rGCy6C6rTvVd8n+0/2n8y0XEZoOceJ1teEKev9SUenXL+LaeKU330O2BKFpXJQ1rkLRxB8CHSk+p2bejMgKOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SikezjYw; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SikezjYw"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2212a930001so6856005ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 26 Feb 2025 14:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1740607461; x=1741212261; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kyFN50mzARxoEv961GrQx/43IA9dhxw9QoBd7XIEQPY=;
        b=SikezjYwYTVhNtKhYmMwWOAZ8RZVLcS1D1a+AsBCnkwEyamQ8DbB6+7kM9IyrYQkPy
         wi4BGCdIXmZjXOadzgURBcWP0aSAhcjkfo6kUXjtVHQcxXyteuKSgYs4KQehjgp8IHAi
         YOQUytHc2u2HKFrJNsSFXK1xPRJQjhF5mtR3lp8Zs3kRtGjLVUCW8GqxxQBaZv+Hdtcc
         qvf85rWut7nzqPz5opBmMxmiFni7SnWMbDeqVLEzz+5pzwEzY7iplFLRT+8eiT5S2DQ3
         AgZsSXLk5b+rTlzE+fEQAWnPV+3s9XdMlCKNdt7zuC7lzpJivBBQIjkWj6Yw/Mq7aYOb
         i/gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740607461; x=1741212261;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kyFN50mzARxoEv961GrQx/43IA9dhxw9QoBd7XIEQPY=;
        b=kjgLHPYKcKfAJFHLSVbjRRbuGTXgutkc81OE10QOFGFED10CG09d75sVgRbcVlq3XX
         AAboIkWPz9IKwhjbH7i9ZfHxZc/2s/h6ZYjx/lxOCyIoeHdQIVMBHBMJnswSSmn9TEv0
         YqivpKgsxSVoMQIrQPoB0oezXtrizxoLX7PU3hWoDljW11gx9zUrgngCEDu1J8GT1uEG
         bBsQpHXB4NsQvLHNemhzPagMtbTgTeWHEp6YWnneUvH+UAGLIEHIwAoRFEW7AzWewDiX
         NrCtMQi2GGIIiOidAZhvN8MtJZ/gDcsAF2aE/PSbkG+bZk2IG/efgYtVbC0PrXKTlbNe
         BGkQ==
X-Gm-Message-State: AOJu0YyxmS+RUif/hwl510y7y4bcfyFRdRhR/2RH4znHE16Yf3qJWrOU
	oV2IvGxsi95elNo+4n5m5jk4r5HVnActDhmSqxhD/c1DG47wUH4rwEFrJZt7sQ4=
X-Gm-Gg: ASbGncssJpOk+8XYCogOACaQPxna+Qn8/VHvcx6x50Dg/dG+3HA1NTb4DX0UyChedA+
	iZ72CWGvkRpT3lOuR1pb5ckKOQpv/YAhu/XylcBOBbpKKZEpgFDYv1FVNzGaQgR7XwCVAlt1NAs
	Wno92fijtBKKVzXzkvIzpZyYp5H/7EH+1GANIXz4Tf0QfCDq4YH3nat6r7gi1YXvJ5hGv4XqoI6
	3v13DFy8Yyorm4ZxViL/GcyEJdFevmGxy56cTSm5ZhKrTZTk9yMq7vv8Juy+IpxavAQ76QUGiUH
	36/9Nz/NA5OoAIyJt/igfv0pRTXiym9jY6PP+uUK3YrO5Hn6PkDTzcqF
X-Google-Smtp-Source: AGHT+IEJEmPRHAir0pC4JxiSC41YFyAd31zLaa4ACXPDw8wOhc4r3SARGvmSjNnM+NRArbU/MX0XsQ==
X-Received: by 2002:a17:902:f552:b0:215:94eb:adb6 with SMTP id d9443c01a7336-221a1149088mr411033855ad.40.1740607461056;
        Wed, 26 Feb 2025 14:04:21 -0800 (PST)
Received: from gpeter-l.roam.corp.google.com ([104.134.203.15])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22350534004sm1044145ad.252.2025.02.26.14.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 14:04:20 -0800 (PST)
From: Peter Griffin <peter.griffin@linaro.org>
To: alim.akhtar@samsung.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	krzk@kernel.org
Cc: linux-scsi@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	willmcvicker@google.com,
	tudor.ambarus@linaro.org,
	andre.draszik@linaro.org,
	ebiggers@kernel.org,
	bvanassche@acm.org,
	kernel-team@android.com,
	Peter Griffin <peter.griffin@linaro.org>
Subject: [PATCH 0/6] ufs-exynos fixes for gs101
Date: Wed, 26 Feb 2025 22:04:08 +0000
Message-ID: <20250226220414.343659-1-peter.griffin@linaro.org>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

Whilst investigating some stability issues with the upstream ufs-exynos
driver on gs101/Pixel 6 the following fixes have been authored.

Whilst some of the stability issues remain these patches do improve
certain aspects and make things more deterministic especially module
load/unload.

regards,

Peter

Peter Griffin (6):
  scsi: ufs: exynos: ensure pre_link() executes before
    exynos_ufs_phy_init()
  scsi: ufs: exynos: move ufs shareability value to drvdata
  scsi: ufs: exynos: ensure consistent phy reference counts
  scsi: ufs: exynos: Enable PRDT pre-fetching with UFSHCD_CAP_CRYPTO
  scsi: ufs: exynos: Move phy calls to .exit() callback
  scsi: ufs: exynos: put ufs device in reset on .exit() and .suspend()

 drivers/ufs/host/ufs-exynos.c | 62 +++++++++++++++++++++++++----------
 drivers/ufs/host/ufs-exynos.h |  2 ++
 2 files changed, 46 insertions(+), 18 deletions(-)

-- 
2.48.1.658.g4767266eb4-goog

