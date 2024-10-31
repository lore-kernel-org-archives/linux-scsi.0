Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BC61B0105
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 15:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730386847; cv=none; b=hceqHGz0pmRoeXP/D02/IqclApETSbg77LP7KWsk6cOwO+BJs/8QcTukhsX29BgWNd1QOw9hzMcHKU/gi0PrXGmocAbFdmT0D5pUpwNxAAOHSos1465t1pUboMdo0SwpF1yG4vR3u/Hod8JyAaDvc4Vg+Dny1R8yUsZ2PgGWGpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730386847; c=relaxed/simple;
	bh=XQ6lVdO/7PywiTR9Hdfz8GxGAKaSLgkznc4FBkJ+NM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCvJwJ5yAqvqSPgeFqNiyQ9daSBweJftTkPMQs2FYPvvU+ntwH+QBJGykaZw4c+QFCFhxKMNDMQ7kbFbzHiZqeKlRi7TpjDdJoH0MP1pKH5D1skoK+1n9h25KUWVILXYAZCE/UaicjgrU3zjxi3KaKoZCElR3Oz9EhJOMfqXBg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=REi5PMzs; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="REi5PMzs"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-431688d5127so8185575e9.0
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 08:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730386844; x=1730991644; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=86sA0f6Os+pjSfGkaxQ4yImAusqnRJDENyNfYooIZr8=;
        b=REi5PMzsTUkrZruNOCMEGAHaD7oq5SZBFqZrNsRBv03+4M5H0BB5bpf9tG9G6iFcVU
         +zb44qfXNLfQrFUEumAJuhsD7buhlRyIBDsjPVD/x2Gs2N7IGKUUebwpjDuB2jA2Q8BN
         UTJQ+67GrBRZsNZpDXpn8tyMkooARiY/AwDi4ryzQF8SWx+z53ektiI29lQdDWN2K9qW
         6TtivJDuG2QEQTOW7WyxelOxwzubLCZC5s8QQ+FsZzvLVHgoqx1nN9VsGmJVSx9mui/q
         QPBdcc66v6xABxqTDGSsl+CpKGbme1ngNOZ6XsmFYAU0ZCCI2JDB434axeb82rNuVriv
         nPqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730386844; x=1730991644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=86sA0f6Os+pjSfGkaxQ4yImAusqnRJDENyNfYooIZr8=;
        b=MOBQvNtfteg+HoZjuaOT5XWjaQZkJ4LqkEiJS9pRXwKTjPv+gmtChtru8ZGeS+b69s
         GrBpE6WYBZdyiFWx9E3iCq9rs2J0P5i7MGhW/xROBDGo4KGmbI3mLpTBayhwYysdD1UW
         C3mnghN/s7kRTPKR/F00MP0pAMdZQO/Ser1kXIbAKWuIjxYbVbrlPY8scWPWePKSZawr
         zUi1UiLjVc7Q1SYIOZ9Nvqe6OYLKGFrgZceCd3mF+uqUbly46NdlNyGfGkUYIDfrw1rM
         R2L+/h9vPRi6g5qrOm1XTXO41qPAc3JsTiIzKXXCKSnctHs7cwEcX8aKf+ESaXhTSJti
         Q+yw==
X-Forwarded-Encrypted: i=1; AJvYcCWOjW2KS/bcjsraVI4dB6lE/16zLmRhcjr4psUAllZJTut8nz6DpJtR2Joz5saSQTFAP8ZbQ+6YV+es@vger.kernel.org
X-Gm-Message-State: AOJu0YxNNKt8/Pdoxo3V2U29LdDf63XVA8Qa+N8Tf5QXBiFwiq6CD4Lm
	JhWq2IhR2ifNNRVSbr0p77bGPo5kPYdHjO6wcNPBnUlZJ++8fXIRjzh0gHwvpiM=
X-Google-Smtp-Source: AGHT+IHBzn01GkaFrVY+fjAehvpLRixtUxLHicSEaRnq3vqepb6mFx2FPf0yhN2kuBANtTE7+uHjZw==
X-Received: by 2002:a05:600c:46d4:b0:427:ff3b:7a20 with SMTP id 5b1f17b1804b1-4319ad049a8mr154531185e9.27.1730386843327;
        Thu, 31 Oct 2024 08:00:43 -0700 (PDT)
Received: from gpeter-l.lan ([145.224.65.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bd8e8524sm59163225e9.5.2024.10.31.08.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2024 08:00:43 -0700 (PDT)
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
Subject: [PATCH v3 05/14] scsi: ufs: exynos: gs101: remove EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL
Date: Thu, 31 Oct 2024 15:00:24 +0000
Message-ID: <20241031150033.3440894-6-peter.griffin@linaro.org>
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

Auto clk control works fine for gs101, so remove
EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL flag.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
v3: Adjust commit message to use imperative (Tudor)
---
 drivers/ufs/host/ufs-exynos.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index f4454e89040f..2c2fed691b95 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -2138,8 +2138,7 @@ static const struct exynos_ufs_drv_data gs101_ufs_drvs = {
 				  UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR |
 				  UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL |
 				  UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING,
-	.opts			= EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
-				  EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR |
+	.opts			= EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR |
 				  EXYNOS_UFS_OPT_UFSPR_SECURE |
 				  EXYNOS_UFS_OPT_TIMER_TICK_SELECT,
 	.drv_init		= exynosauto_ufs_drv_init,
-- 
2.47.0.163.g1226f6d8fa-goog

