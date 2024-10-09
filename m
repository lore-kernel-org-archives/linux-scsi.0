Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CDE1922DF
	for <linux-scsi@vger.kernel.org>; Wed,  9 Oct 2024 11:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728472916; cv=none; b=Ekfb1lNuwx7COTevDC5A6snpeOH7bNxcS7d6mSxAJdVr9PrvaFDVVd/miINKqCJMUPTKJZByXBztJdoe7+0ME8iRLKigVxxv8L9DPC2LSz0aBh7TdFgd7qMtvhszfa+AIRlM+vNLIMI6VXorotkLfSSkI/DSJewwauSGSCwnWKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728472916; c=relaxed/simple;
	bh=U2N6z2wH72kLC/ElVe24RfJtkaCecDBL0/+mf8cDWuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lav3d0nIa0c6EJQC4QE3w5EzVHR2LzJcdLA0O5q8o1vYD8oDOuZje/1eSxt7gfI8QS7mRvbSdwtblnVs05Wg4NzQ6nLdc/DROW6FYeyZL42qdAnVmiWJuJzbZQ5kDEXTWWHR2pgw/7nOG/Z30bh6I4kh9YoEFuxhk+ZofPpuNFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=t3pys5/1; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="t3pys5/1"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43111cff9d3so4343865e9.1
        for <linux-scsi@vger.kernel.org>; Wed, 09 Oct 2024 04:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728472913; x=1729077713; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0G5+DGHRH9uKXySVvDG2zjq1MsEuwXbycCIn4qhJYMw=;
        b=t3pys5/1uuPu+UHCRAG07KCBO/jn9j6LPcd8CbXD3xjJx7sLX1ExVvewkFHZYPy7oo
         lz8XoUqjo+RQSScLvZSLsCWYcjlIas7ax7Jz6u/0slG5nggd5fK/GLEF1rAfIT/+Pxnz
         9EKcg/bOb+KqxJJRsWZZKqh8vywMxVA5AcV+cOP27XXlXfVnHx06ZPIeir986zyU0gBI
         kw0/hi/ZOqLNORwT0k6GVEE2SYhkt69tdLYJa7MqCX6tPX49mUOtXelPZLj6hu8P5uHN
         RCUgYtj2qCmrPyAYe4CSUjeUPXvd6OXFrZQogv2YSRqMTmY1DEmQeLHNmO/6cfu2wKpZ
         dELA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728472913; x=1729077713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0G5+DGHRH9uKXySVvDG2zjq1MsEuwXbycCIn4qhJYMw=;
        b=QesltSWuGzrcoB7H5WvCTvFwfLlt4rGzBSLSKex7/DTPIyiZTI5HVAV/ujhuMcWuvb
         ly/bIh6Jm5zGEk5ywWXTZ5okF5S6wolLbulnYIEteBty7iV54ZcXhfycMv/8oYvmv8Sl
         4I2p2ZkzYS4cFncqcrf9F/CfrSwDoj5V3UOxaMNC8X8ZyBPKtW3/CXl7tFr699aMa6FO
         YGvViu1ov72CLebD4R8kf5FIQ4BGgBkEfyi725dJlS2gUB2OD445Mk4U1BmlIFOylD5Y
         Y2ikEHUW9GGBsoyVL0lPjoLmVeEBZrP1XANG7Qz4IaCS1jR9CpiOJwgoyIhU6MmPu5TI
         4qRQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+Z2xLl7TabiCzvwDEvFgNh9S7rJqdHoyWAXIXFJ/l0/P080WiTKI4kGSwOSkdq5geALKqXYqTe051@vger.kernel.org
X-Gm-Message-State: AOJu0YxRm+DXN3+hgVXKsEDCO0SdKj6UC8pw31MSyYMHsdAlSQ3Msggj
	qv35pF/x0cUcyH+ckogvy2R1aXn3uBgwAZ11RPuK5CYv8GZ/U0/zEHeWzF8BSGM=
X-Google-Smtp-Source: AGHT+IGDUkReqvpDILvzLlsGK2Z3Cg76lYE/cf1NIlvq1mdgxLrmdCkneJKzCCHIFSebONF2UDAWJQ==
X-Received: by 2002:a05:600c:1ca7:b0:42c:de2f:da27 with SMTP id 5b1f17b1804b1-430ccf0859fmr13666665e9.2.1728472912789;
        Wed, 09 Oct 2024 04:21:52 -0700 (PDT)
Received: from gpeter-l.lan ([145.224.65.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4310c3dcdcbsm12331445e9.0.2024.10.09.04.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 04:21:52 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: alim.akhtar@samsung.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	krzk@kernel.org
Cc: tudor.ambarus@linaro.org,
	andre.draszik@linaro.org,
	kernel-team@android.com,
	willmcvicker@google.com,
	linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Peter Griffin <peter.griffin@linaro.org>
Subject: [PATCH 2/7] scsi: ufs: exynos: add check inside exynos_ufs_config_smu()
Date: Wed,  9 Oct 2024 12:21:36 +0100
Message-ID: <20241009112141.1771087-3-peter.griffin@linaro.org>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
In-Reply-To: <20241009112141.1771087-1-peter.griffin@linaro.org>
References: <20241009112141.1771087-1-peter.griffin@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the EXYNOS_UFS_OPT_UFSPR_SECURE check inside exynos_ufs_config_smu().

This way all call sites will benefit from the check. This fixes a bug
currently in the exynos_ufs_resume() path on gs101 which will cause
a serror.

Fixes: d11e0a318df8 ("scsi: ufs: exynos: Add support for Tensor gs101 SoC")
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/ufs/host/ufs-exynos.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index e25de4b86ac0..939d08bce545 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -724,6 +724,9 @@ static void exynos_ufs_config_smu(struct exynos_ufs *ufs)
 {
 	u32 reg, val;
 
+	if (ufs->opts & EXYNOS_UFS_OPT_UFSPR_SECURE)
+		return;
+
 	exynos_ufs_disable_auto_ctrl_hcc_save(ufs, &val);
 
 	/* make encryption disabled by default */
@@ -1457,8 +1460,8 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 	if (ret)
 		goto out;
 	exynos_ufs_specify_phy_time_attr(ufs);
-	if (!(ufs->opts & EXYNOS_UFS_OPT_UFSPR_SECURE))
-		exynos_ufs_config_smu(ufs);
+
+	exynos_ufs_config_smu(ufs);
 
 	hba->host->dma_alignment = DATA_UNIT_SIZE - 1;
 	return 0;
-- 
2.47.0.rc0.187.ge670bccf7e-goog

