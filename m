Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A541CB32A
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 15:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730386861; cv=none; b=gf0RSOtV7ix2YGHdeH4mwfaQ8IDnTSO8OIl5MhKAGJZ4sOIZHn+OHurcj1ywGAaPgZ697VS56Y4DmPpXfXf/ttBj1wnm0K33fzBEGS41XUCtVr5U4/zYzUDmA3oKvKRuwUbys8aTRoX1or/fTsErewMGqOpZtNRuYg7lHgYwMco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730386861; c=relaxed/simple;
	bh=lZqtMnNH2Ydc3fFDJaYFEhDWQg9TQsu/RuCma6tdH5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lekctVssY4gzb//GYpkF7ikhLZq8Q9j52zx9kd8/VGsvxOa00oz5oSUBhS+78YfXVcVj0j8Q21X/Wp3WQHvRPDncXWdyZhuwAGlDM3sEoCbBbwv1QRJqkdQJciSJJte1l4MH/6nlAVp1yyhLuAFN7KIaQ0S5cfANZQghQq3xkbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=USZ8nMKH; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="USZ8nMKH"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43163667f0eso8652515e9.0
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 08:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730386858; x=1730991658; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5HsH55Dd4lXD8RaepfS+tYZBwCj18S0+Osi4b6XYRas=;
        b=USZ8nMKHVPtSfzL17p8eo8AhcHkpC+mQckhufvHtRMAl44g079kND2uIQ7SShLLWqK
         m1oaQGMQ+56CSCyeRJ86EFLvjOmnQ1zhiZUWy0N/B0p4SvF1+AtxetlTXsk6xzCsDcN6
         JdfLaMenyuGDXoCSY+C5B1zimC6iQKp90MepbGR0o68QEYCzdzd8pMizq2IxnOszNCh4
         qsn2BRyarpQvC5XNBcy+x7MabNjXl/GduErBTGBPwenmOV3Rmp2sUpdsUfqSbf0C9pDc
         cCVFotih1rX4JBGgVyCnm1mqeOQBC6F1ISS2xjym5C3IknSnEnTCaVQDcmarb5ws+hez
         cu0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730386858; x=1730991658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5HsH55Dd4lXD8RaepfS+tYZBwCj18S0+Osi4b6XYRas=;
        b=ALsns0k5xwjp5qsmNCSMo7w/vkRiMMI7z1VhebIIAYcguXdh1KbllIxI8coqNGAmxv
         JSIJ3iD9UP3fOIj0JRQBN+gNUNyliJe7x7WT2Q0TAC6N8r5aPAKIY+ru65UfZuq7/Tm5
         drqTujCsZO79X/jZsKH5aYZuXIbzba/S5gBEs34pBGx3cIcG7hQCnIp05WauvRCFYWsr
         yO2KgNar8QhGw6BFIBiitOayo9ge8hrYVfZ+ABpI51rDfAw3VihUmZRaPUQQ7XOel5nU
         vCFzyMHwhirIOd7IlGxtnceSPGR9pSKIhgl2r84J9Zcp5oybUc55hTzEZcuDhOr0W/z1
         GKIA==
X-Forwarded-Encrypted: i=1; AJvYcCVx81i41jjEzLk8c0MlomSJLcTL8weIdgMPMB1oekiYMQxQexMeiL1e67fiCpnnLL96Ve2ZocfOTDt5@vger.kernel.org
X-Gm-Message-State: AOJu0Yy94DQHRBQTB5T7C4iM/SZLH2HHjE4FJeQV8zkWD6Sgd+Bbqrq6
	K2cvipfzVquEiKRngxtAgoom/CQzKIvggydFzd8CXj32nYhORMmoi5aRE2OH1MU=
X-Google-Smtp-Source: AGHT+IGnBCp8cTrb3nL5Yu4gI9ybHFIG3eHfaMc7SBxhRN7NF7+XLcEhVXV1Ky/UKTvujdddg7F7rg==
X-Received: by 2002:a05:600c:1ca9:b0:431:50cb:2398 with SMTP id 5b1f17b1804b1-4328323f576mr1510895e9.2.1730386856237;
        Thu, 31 Oct 2024 08:00:56 -0700 (PDT)
Received: from gpeter-l.lan ([145.224.65.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bd8e8524sm59163225e9.5.2024.10.31.08.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2024 08:00:55 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: alim.akhtar@samsung.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	krzk@kernel.org
Cc: tudor.ambarus@linaro.org,
	ebiggers@kernel.org,
	andre.draszik@linaro.org,
	kernel-team@android.com,
	willmcvicker@google.com,
	linux-scsi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Peter Griffin <peter.griffin@linaro.org>
Subject: [PATCH v3 14/14] MAINTAINERS: Update UFS Exynos entry
Date: Thu, 31 Oct 2024 15:00:33 +0000
Message-ID: <20241031150033.3440894-15-peter.griffin@linaro.org>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
In-Reply-To: <20241031150033.3440894-1-peter.griffin@linaro.org>
References: <20241031150033.3440894-1-peter.griffin@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add myself as a reviewer for ufs-exynos as I'm doing various
work in this driver currently for gs101 SoC and would like to
help review relevant patches.

Additionally add the linux-samsung-soc@vger.kernel.org list
as that is relevant to this driver.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ea8a2227b822..0057faff6239 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -23826,7 +23826,9 @@ F:	drivers/ufs/host/*dwc*
 
 UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER EXYNOS HOOKS
 M:	Alim Akhtar <alim.akhtar@samsung.com>
+R:	Peter Griffin <peter.griffin@linaro.org>
 L:	linux-scsi@vger.kernel.org
+L:	linux-samsung-soc@vger.kernel.org
 S:	Maintained
 F:	drivers/ufs/host/ufs-exynos*
 
-- 
2.47.0.163.g1226f6d8fa-goog

