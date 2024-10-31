Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39431A7066
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 15:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730386846; cv=none; b=mV8ju5OVuSpgxQUYMMxtMS56rzq8TAD7FahGlmsK/qNDrQ/aaFsQMTN08j1sPyGw7dIvs38s9WXg/+rJ/rxUu0XhAkz5INnQISjcWqagU07Vu66GwqaQ+uiP1vv3Vju2AYKT+Xp1eknaR6yTyKVp6j4V5QcI6HwU3Nk9HpNH/xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730386846; c=relaxed/simple;
	bh=xDtKwqvnqxZAQP4VrzospgjmeLcn8uf+9e8SZLyCgpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UxbuLEkiNvtN36xfT+zK6nHjoEHKJ+EHST5XEGpZ/xJgvdKANqRnlBwvD6q2xINYmMwI+6Hm3F8DVYp7H5HfZs6nePdvQc3v8UiM3t6vh6HSA2unlE2tjcbtRcgPaOWJmSI8j9ueNwi8M3N4Jz0KL+EAIze7jMm/2mtxCbRbs/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RwsHdhjI; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RwsHdhjI"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4319399a411so9004035e9.2
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 08:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730386842; x=1730991642; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=usrOkYEIhJMHpNEH11NB+5bvhSO9JoP7forJzaG92bc=;
        b=RwsHdhjIExPULOr8gokrXIL6m3DfiFvnZ/FHMDuA7Z3LVFvC/7zrMMeVVViBi8ieoK
         9UcN7MsodWT0pitCRrwixcwafmaVdBFeN3OAj8CMvueOI62BF/32KUoyVM312Y6A+dH4
         7jkTLib2OkQV15e894FzYUdqpfx9fF799RPdKQJ/gK3ZTl824CdGiJoM3dnCvYnj3L1D
         TKuw4CCmzsfSw/Riw55VZBRhQxN92Dr1LzJ9JxnHwsfZLpz6r4GcwE1A3a6szUoUxPDv
         dhhcMjs0HBgZUpcpRKWV6A4n99uFnfFt2ofLu7NC0Z4O+62zlUYVbjrCLb9T9bXXl5Md
         9RSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730386842; x=1730991642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=usrOkYEIhJMHpNEH11NB+5bvhSO9JoP7forJzaG92bc=;
        b=OMmjz4WPMRg5SMKtIQeLR9f1ZyJLd3eZ9Te4nbgMadTuymKP3D/lv37l3ykKXh8+e4
         VOSIHLpJy0llXT7WhFo7WbcGYhiRSumB29ygqALHNsbLtj/dLN5fG3J8qJZugz5BK5V/
         b0IJLCXdoOrl7tB3C3l+jnAOWF4pss+yrmQuJDOz3gpgsTE1kFNnTlQU9B2DhFmMXGjU
         B5Dz5XCdCz8QVRfn4VYl47eGr22ix2L070JqP94HZQbs1/dLTKyIOc6prEnthnG84s9J
         Wz/Elu+JlD/bUwxjTF70Mg+V9nyBaMPoflTXzssrFqf4n9XTyqR/oLrxr/udrmecK3gY
         hQxw==
X-Forwarded-Encrypted: i=1; AJvYcCVAcO5en0NoAhHmLjfrC35t+Ngm8KVNHACg9lbQ3ObDR15RbMzzavrzuPT05tfz40EeGfpNjbdRwH7k@vger.kernel.org
X-Gm-Message-State: AOJu0YxBq2dVrKZVBrcVZOMf5r6/B1xZiH9tK3D35tE3o7re+eeLmTfO
	B6gvUJwoM+GAqJnFyBSVe2/r0GlStlCimwHrsOfPkDjHDc7ilRt2mjE2pFxw1qc=
X-Google-Smtp-Source: AGHT+IE2nRqDWcprFbqsyiRnRrZSmdUyGUKgVh+UN0C5kREuaiIMyson1wnaLb7mms/VbQSk1nr2fA==
X-Received: by 2002:a05:600c:4a88:b0:431:9397:9ac9 with SMTP id 5b1f17b1804b1-431aa292eb4mr115733635e9.15.1730386842144;
        Thu, 31 Oct 2024 08:00:42 -0700 (PDT)
Received: from gpeter-l.lan ([145.224.65.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bd8e8524sm59163225e9.5.2024.10.31.08.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2024 08:00:41 -0700 (PDT)
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
	Peter Griffin <peter.griffin@linaro.org>,
	stable@vger.kernel.org
Subject: [PATCH v3 04/14] scsi: ufs: exynos: add check inside exynos_ufs_config_smu()
Date: Thu, 31 Oct 2024 15:00:23 +0000
Message-ID: <20241031150033.3440894-5-peter.griffin@linaro.org>
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

Move the EXYNOS_UFS_OPT_UFSPR_SECURE check inside exynos_ufs_config_smu().

This way all call sites will benefit from the check. This fixes a bug
currently in the exynos_ufs_resume() path on gs101 as it calls
exynos_ufs_config_smu() and we end up accessing registers that can only
be accessed from secure world which results in a serror.

Fixes: d11e0a318df8 ("scsi: ufs: exynos: Add support for Tensor gs101 SoC")
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Cc: stable@vger.kernel.org
---
v3: CC stable and be more verbose in commit message (Tudor)
---
 drivers/ufs/host/ufs-exynos.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 33de7ff747a2..f4454e89040f 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -719,6 +719,9 @@ static void exynos_ufs_config_smu(struct exynos_ufs *ufs)
 {
 	u32 reg, val;
 
+	if (ufs->opts & EXYNOS_UFS_OPT_UFSPR_SECURE)
+		return;
+
 	exynos_ufs_disable_auto_ctrl_hcc_save(ufs, &val);
 
 	/* make encryption disabled by default */
@@ -1454,8 +1457,8 @@ static int exynos_ufs_init(struct ufs_hba *hba)
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
2.47.0.163.g1226f6d8fa-goog

