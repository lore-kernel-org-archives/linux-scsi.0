Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E593271299
	for <linux-scsi@vger.kernel.org>; Wed, 26 Feb 2025 22:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740607473; cv=none; b=Yk1JCu9F4lWr5DXoklyq7NUTF0eoWFkL33JsQb0xlSQqYEVNTnT6mdL9+q93bkY1GlygUjC7AKI0DLLHfOR8fSVyPlQn0vG1U54ckfxXWoM2v3g/boN3o39f3R7nWUtHfj/AP2n7zJ8jt27rFb5/GIQOAcoOzr1R/0qAswpxeg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740607473; c=relaxed/simple;
	bh=qiJ5NgMCW+3w1jlKpr4Qxl9Za0XkMmw59lyuniMavhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMWew/yy82/PmAR3nyb7lTbGo2cWKnCFrsBwJdOo9CErmqVdfg1XwHflgGTUKXnLX/d2kGAe3igRjL+D4GDL5Kj0c0QDdUVNs9dHj4BqixB85KsHkuhgK392ck9udVj9HR+1CPLBojmHCtHxuQUtHlSj6Yi0ttStQriNNAm1AyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=j+I8pKwq; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="j+I8pKwq"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22113560c57so4286345ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 26 Feb 2025 14:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1740607471; x=1741212271; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZVSwZvqHp4KclUxAlGtZReiZmGLJRUAId7nnJAavdso=;
        b=j+I8pKwqaYJqCfqWZPsBRXvs4z07NZzQ09hIeY4Ya4cnMLbZIoBpftqQcXWk9D3lV3
         +THBIzqAdjZR3tRWr2IshtH4m/jE5BAPazAzQPgbLAjzCUsJcVtxeep0gGDxGbmx2gFL
         UsjaQDjc6/OhoIQc1vTilF8BBbcyJ8NER0ukGUsIElskI2DclsMoaeK+i0pe9H1zXmNx
         wCfQhldsdjvTSryXVjap7/PH7/i9M+/pzMMNd1rM+yklqTwoM+qX4a6SAsuY889St56l
         1kXXOWoLOMOIQKT4RD8SNdfqT6A/+oRLo35+WtXfd54sCr+s/+KLcHR2gb1wNqeM5UcH
         MMjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740607471; x=1741212271;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZVSwZvqHp4KclUxAlGtZReiZmGLJRUAId7nnJAavdso=;
        b=u80ZpGRhgOe2c5bwdYma8dTXi2ctSok1p6pgg+fm2fJ+L+a98STYj5/3lrQZnZDJSj
         h/HBAytHM58ea6t+OPR886zRIBypYj+BZkZ2+xiMh6/SHVP1JAtJ2pL7A/OYOIfxETbc
         dcGmqweeDNK/IYFdiEbig7PuJgzm9hu8GdBzD3e3wMEjflq+byc4jvIsN66dN89+Xc6E
         JvUsTnsuf/+1C3j6vVtensd8mTyAC59RkB+6eanZA7joWUW6spigg+D6uOHsNyR4DoU9
         ja0X2kCqGOzhXyLE+RZIiy1U9B8ijJYgmCQwuGzha0k3AEnpzxUtuGRxE6zm5QpwNmHY
         RkvA==
X-Gm-Message-State: AOJu0Yw4+ApoRbmVHmmaDuQs+Ef2pR8oZh21hzaF1OwKZidHRxR4p2g1
	XROUSfJYJJs+vSKLfb8FFfs954x+PBvokMIbge9FIWrh9P+tYHZlPoVJYOg3OiA=
X-Gm-Gg: ASbGncvwWtZ9FRPEJspxBz9ptnYUFpkAZsCggWXX5x9mhYpv2Hv6RqhtIPcayawVZvA
	ppvktn6L5xFms2SdRmEubCLbhz1K335P2SXdzQrTFSZFTF5xLNaWZ9n852Urk/A2gO+Vl3/LIZs
	Xbav17aosBnYGEfBwRx5ZuU4iv+WApcr+s3ZdCG3EMEMIe/H857S15lOMoVBf57XMQrI9v6is3J
	J3buFugG+0k+K13TTz88Ngb1EBTK4Hs/qcJKd9cJ094lxVp/Jzsm+XJKSVPMFHwOEX8iwz4/4W3
	oyiGBjxifIKRQfbwDxVe6pe06ySAy8D0EbvMX+Am6etmHCBZekp6Vsvp
X-Google-Smtp-Source: AGHT+IHv2DLo5yokOufzr6ieTPFjBCf/BVk00fjUAV4YbzWaoAbBY7sSAOQrP6QEylsN4Iqip6zQ3Q==
X-Received: by 2002:a17:902:d2c9:b0:221:f61:14c3 with SMTP id d9443c01a7336-221a0ed8294mr315855585ad.18.1740607471584;
        Wed, 26 Feb 2025 14:04:31 -0800 (PST)
Received: from gpeter-l.roam.corp.google.com ([104.134.203.15])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22350534004sm1044145ad.252.2025.02.26.14.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 14:04:31 -0800 (PST)
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
Subject: [PATCH 6/6] scsi: ufs: exynos: put ufs device in reset on .exit() and .suspend()
Date: Wed, 26 Feb 2025 22:04:14 +0000
Message-ID: <20250226220414.343659-7-peter.griffin@linaro.org>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
In-Reply-To: <20250226220414.343659-1-peter.griffin@linaro.org>
References: <20250226220414.343659-1-peter.griffin@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GPIO_OUT[0] is connected to the reset pin of embedded UFS device.
Before powering off the phy assert the reset signal.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/ufs/host/ufs-exynos.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 4c3e03a3b8d9..64e2bf924213 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1517,6 +1517,7 @@ static void exynos_ufs_exit(struct ufs_hba *hba)
 {
 	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
 
+	hci_writel(ufs, 0 << 0, HCI_GPIO_OUT);
 	phy_power_off(ufs->phy);
 	phy_exit(ufs->phy);
 }
@@ -1700,6 +1701,8 @@ static int exynos_ufs_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 	if (status == PRE_CHANGE)
 		return 0;
 
+	hci_writel(ufs, 0 << 0, HCI_GPIO_OUT);
+
 	if (!ufshcd_is_link_active(hba))
 		phy_power_off(ufs->phy);
 
-- 
2.48.1.658.g4767266eb4-goog

