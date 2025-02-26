Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A9F21D58D
	for <linux-scsi@vger.kernel.org>; Wed, 26 Feb 2025 22:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740607464; cv=none; b=SpvfmVD307u7OxggRASoQ4u7Dw8QK8htv9FdbSvqiGEbkN/EbOIBcojw+dnMJbwPaLIElXmiRAenBtgcotZmGqzlv1HRKWPC7z0TNAfMWwR2wOPqR+MG5L+Q8SrPu239dWew3bJIvV8mlX0ISFbp1++JmwIdUwayofy5Gp2yWzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740607464; c=relaxed/simple;
	bh=zzCHAyEKqRP94Nq6sEsgHMP78zfxlBlURkm2ZCY7I5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0X0K5DbhgxbGJz5WNwzJwyoWy3xp7Cb6sSPd1WYs/ESgSJlrCXvInM7zfrq/x32cWvx7MF0nSnvO0ZGk3/1iIpYJkTA1pBLpGDUWuhXREz2ITWlRkORij3Q1RgYFdKSy94nQ6BT1XydLbX+6HyPGzcA31O1H8nHEWTEIZredj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YuRAUNYq; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YuRAUNYq"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-220e989edb6so6089825ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 26 Feb 2025 14:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1740607462; x=1741212262; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KTcDz5+Yk2Rd6PndDa6YwrNqhNuGseEibA7R+3Q+jN0=;
        b=YuRAUNYqgVfywzeYfW+j0Lp4zAb+InAsfYR8RJnEnAryAHhuar6Gi9cdhjViJs8soL
         p+XTqU03rL3YUinttkeuwhvYDBYndftcQ1lb6JrayJWYaz767kT/7uSSqq4z3wDgWKw+
         tCNTZSbGkmHX0fdlTrrajQTQQ+ehAOD3ixMlGtJOJZMGY3XhMabTvcLIbIQa4rkvjvSJ
         fF9QmOj1dIRwAygKMwVXWm7oCmSnhZ3H4xNrRzbzfngxmnrYSIJAjlQScDmvXgIpDU55
         q9P5MI6BOq/HOO6RjNFwOhFij/cUQzMCamgQLxaDNE0Va6Uhysi7kn5GAc/x2beLnm5s
         Fytw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740607462; x=1741212262;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KTcDz5+Yk2Rd6PndDa6YwrNqhNuGseEibA7R+3Q+jN0=;
        b=razEsemG5Jz67R4aNl4WrpwSCSu4rqBPS+trUb+eXi5EfxX7Lr1+006CrApRuM5KxS
         fq6fWuaXax8f1Ao9GlRjSr8KfPFjTGDREHMdg3onIZx5Rlh25jLowz8Cq1W3Awqngh1N
         3bHqmXGzxdw5CtcWR6evs50NhboHBNm/ichg2zpp/obthtFWZtzr4wvQ5m28lZjpYfJ4
         MHaSgztMVMdQohx5ejxwIyqNrGTGvYPK7GLUO0T91wHGmH8w59bph0q7rF/kdx8+5MwN
         2oUJvuEb/lBKX+bBhHXe3nI1FW0u2eqM4VAiqi3hQrwOLKM7P5eA7cR3oWFMKXBHTlkX
         axgA==
X-Gm-Message-State: AOJu0YxlzhvwbTJJM7v91ogkNm/149jRnmoKD58Vw7coa5ISDMQIreOa
	YCH2QDAjTN2N+MpUP/f76l8cb8/FRNAdxcY4E0fjq4fLSqX7M7j0SZOae5OhZUs=
X-Gm-Gg: ASbGncvidbi59PoFj1yFdr8Wthu3YMASSJ4Pwwo8Et5yVjLmWV1cT1AyO17H95ef0Ti
	p14iTkeSFYCXdFZiLLBOkgPclDkqRBB3NRd/EPQR9ZLB+X9mLkOrFFxXZTfDSDBAIqQ9KYLjXGO
	iqnign3x2FxwXNpsEpPlXeeVTxuCztAmotyrfMsdqfgWSGmbK859KosDqD1JtifVJR69kkzPoGf
	Dto9ef+/fvVBvXW9rF1M98YR0T9wE3hk9QaAAGAMkQPFeKEcPFun0njubAZoR2UrRJ/W5ndF90K
	yEKfSXXKYocnsX5k1SiwLchtGMGBWsD75IqT7egJP2utHNSXdK6wIhkZ
X-Google-Smtp-Source: AGHT+IGveFL5jaPvmaU/Mebx9uyRVH5JU7x/sn/aSccHmWkURMmnvFmqMMw5M5iqYS+8/nz1Dtqa6w==
X-Received: by 2002:a17:902:dac3:b0:221:133:fcfb with SMTP id d9443c01a7336-22307b4bbcemr129932265ad.20.1740607462686;
        Wed, 26 Feb 2025 14:04:22 -0800 (PST)
Received: from gpeter-l.roam.corp.google.com ([104.134.203.15])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22350534004sm1044145ad.252.2025.02.26.14.04.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 14:04:22 -0800 (PST)
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
Subject: [PATCH 1/6] scsi: ufs: exynos: ensure pre_link() executes before exynos_ufs_phy_init()
Date: Wed, 26 Feb 2025 22:04:09 +0000
Message-ID: <20250226220414.343659-2-peter.griffin@linaro.org>
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

Ensure clocks are enabled before configuring unipro. Additionally move the
pre_link() hook before the exynos_ufs_phy_init() calls. This means the
register write sequence  more closely resembles the ordering of the
downstream driver.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/ufs/host/ufs-exynos.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 13dd5dfc03eb..cd750786187c 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1049,9 +1049,14 @@ static int exynos_ufs_pre_link(struct ufs_hba *hba)
 	exynos_ufs_config_intr(ufs, DFES_DEF_L4_ERRS, UNIPRO_L4);
 	exynos_ufs_set_unipro_pclk_div(ufs);
 
+	exynos_ufs_setup_clocks(hba, true, PRE_CHANGE);
+
 	/* unipro */
 	exynos_ufs_config_unipro(ufs);
 
+	if (ufs->drv_data->pre_link)
+		ufs->drv_data->pre_link(ufs);
+
 	/* m-phy */
 	exynos_ufs_phy_init(ufs);
 	if (!(ufs->opts & EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR)) {
@@ -1059,11 +1064,6 @@ static int exynos_ufs_pre_link(struct ufs_hba *hba)
 		exynos_ufs_config_phy_cap_attr(ufs);
 	}
 
-	exynos_ufs_setup_clocks(hba, true, PRE_CHANGE);
-
-	if (ufs->drv_data->pre_link)
-		ufs->drv_data->pre_link(ufs);
-
 	return 0;
 }
 
-- 
2.48.1.658.g4767266eb4-goog

