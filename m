Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7154C145FF9
	for <linux-scsi@vger.kernel.org>; Tue, 23 Apr 2024 20:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713905432; cv=none; b=tCiOKZ56L1ISjMa1bFIhhDSDBZHXdSceZ87QqUrrNp2RSAIrsnDMFPEeEVCgj2L6HRm7ZoABUjOWHfARSc2pVbpLCTgnj1CQ5dICUfgVMrJlg7FmmAxPrummPrVcMaA+IivbLUNlO/fOA3Gd08Sq/uAK9ueexnd8/ZSq+dErMF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713905432; c=relaxed/simple;
	bh=R7zQTIZdvG02VCBq8bLB7RM5nOeAXTmdLzXWGj0scFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDUP0wkcHVexWYrsTnYHYGwD4SPtrTMWKY1zBR1lm/GYJDf3/NPCqQZnh0YbgjXkmNadOLmdLf5oMx0gOTCw1O5O329l7ywYdGidcOoZndgK3LIBBYM+wJX8Sg4zJxJezxj+jBkk6f5UvEq5kNxNaCz3v3vX1dL6CpXVCNZv1Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=svpKY1/D; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="svpKY1/D"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4196c62bb4eso34085255e9.2
        for <linux-scsi@vger.kernel.org>; Tue, 23 Apr 2024 13:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713905430; x=1714510230; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WCHTamsKWOa2PSWA2iiAOyEQMuVi7F/H9xo5LBfeSLo=;
        b=svpKY1/Dnn1YhNX5lAj/YA6It9ibkNInyrymKQxHdaqa1Hod7gojvXOfON69h9Tqfd
         RXF/SRySnQgxxXTdP8D4eWPHBEfierfvw7rbCJcQpF/EtVQEd4Go3K2rElhfxJ2qeKcE
         I9TBv5hmZKvkscgBSjG9o1uB8c5cDxeYtVPuqfZS6SkLv9A2AIAoAUeS0LfM0DulHjrb
         rbKJ89gFPp/dsiQgW31+nKpYQRqMKcU9Xrr+H7c15HjRkvcZ/7+jt0at+UJ9VdLppBvF
         /I5k+jnl/PqDGgQeSxSCUYsaAvkJ1mCuoCbkKAhCTmspGBHAn7D0QPNrtmuMXsu0av5E
         90iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713905430; x=1714510230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WCHTamsKWOa2PSWA2iiAOyEQMuVi7F/H9xo5LBfeSLo=;
        b=L19PMEx0QtpC86OrZl2RBsEf8ecc5iHq0lVkd7NUVEBekZjrdKDVEvAMB6JeWrV7Ud
         DgjcakOilvQrzOdsIKmXKsOfQwzoUSY0aelGSHSEiyLxKyi2pE3gIns7/925Plle+s+S
         uElcFGNWNiTGTFkgZa8wQMa/2JW8yV2OgeyLBE532ASNmDEsTQ5uQh0bSUBcSI1Fktkg
         NGHAPTrvp/w1XPRxKWRLHLjlnLIBhqJXiheqe1q+SLQ2Y1M90ceRLseCQ9Gh/UvaEAVh
         aFuq1PjRK69/58qvFxf/8wjZ9E4+knLySe4Gg65XOHL3zH40GdAlxbSQGdFDgNhPylvY
         YMVQ==
X-Gm-Message-State: AOJu0Yxq/ENrAfLfnURuc8Mb6SW+ByA74x9AFCRviJtjIt55ejWWUgsW
	yDaLmJ8LriOYd3/zTItdiO7D8qVukK4AEI/KaqYMUUqdbio+bAM3d5Nmtd1arMY=
X-Google-Smtp-Source: AGHT+IGaC6Vi359eexueF4iWi9nmGX5wxuCM1Fm/OruWavgWB268ofzG0ipJO8D32PKK0SvENR0WUA==
X-Received: by 2002:a05:600c:2991:b0:418:9d5a:f680 with SMTP id r17-20020a05600c299100b004189d5af680mr254261wmd.25.1713905429971;
        Tue, 23 Apr 2024 13:50:29 -0700 (PDT)
Received: from gpeter-l.lan ([2a0d:3344:2e8:8510:4269:2542:5a09:9ca1])
        by smtp.gmail.com with ESMTPSA id bg5-20020a05600c3c8500b00419f419236fsm13065443wmb.41.2024.04.23.13.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Apr 2024 13:50:29 -0700 (PDT)
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
	James.Bottomley@HansenPartnership.com,
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
	Peter Griffin <peter.griffin@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v2 09/14] scsi: ufs: host: ufs-exynos: add EXYNOS_UFS_OPT_TIMER_TICK_SELECT option
Date: Tue, 23 Apr 2024 21:50:01 +0100
Message-ID: <20240423205006.1785138-10-peter.griffin@linaro.org>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
In-Reply-To: <20240423205006.1785138-1-peter.griffin@linaro.org>
References: <20240423205006.1785138-1-peter.griffin@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This option is intended to be set for SoCs that have HCI_V2P1_CTRL
register and can select their tick source via IA_TICK_SEL bit.

Source clock selection for timer tick
0x0 = Bus clock (aclk)
0x1 = Function clock (mclk)

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Will McVicker <willmcvicker@google.com>
---
 drivers/ufs/host/ufs-exynos.c | 9 +++++++++
 drivers/ufs/host/ufs-exynos.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 66e52c3607e2..66093a905986 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -50,6 +50,8 @@
 #define HCI_ERR_EN_N_LAYER	0x80
 #define HCI_ERR_EN_T_LAYER	0x84
 #define HCI_ERR_EN_DME_LAYER	0x88
+#define HCI_V2P1_CTRL		0x8C
+#define IA_TICK_SEL		BIT(16)
 #define HCI_CLKSTOP_CTRL	0xB0
 #define REFCLKOUT_STOP		BIT(4)
 #define MPHY_APBCLK_STOP	BIT(3)
@@ -1005,6 +1007,13 @@ static void exynos_ufs_fit_aggr_timeout(struct exynos_ufs *ufs)
 {
 	u32 val;
 
+	/* Select function clock (mclk) for timer tick */
+	if (ufs->opts & EXYNOS_UFS_OPT_TIMER_TICK_SELECT) {
+		val = hci_readl(ufs, HCI_V2P1_CTRL);
+		val |= IA_TICK_SEL;
+		hci_writel(ufs, val, HCI_V2P1_CTRL);
+	}
+
 	val = exynos_ufs_calc_time_cntr(ufs, IATOVAL_NSEC / CNTR_DIV_VAL);
 	hci_writel(ufs, val & CNT_VAL_1US_MASK, HCI_1US_TO_CNT_VAL);
 }
diff --git a/drivers/ufs/host/ufs-exynos.h b/drivers/ufs/host/ufs-exynos.h
index 0fc21b6bbfcd..acf07cc54684 100644
--- a/drivers/ufs/host/ufs-exynos.h
+++ b/drivers/ufs/host/ufs-exynos.h
@@ -222,6 +222,7 @@ struct exynos_ufs {
 #define EXYNOS_UFS_OPT_USE_SW_HIBERN8_TIMER	BIT(4)
 #define EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR	BIT(5)
 #define EXYNOS_UFS_OPT_UFSPR_SECURE		BIT(6)
+#define EXYNOS_UFS_OPT_TIMER_TICK_SELECT	BIT(7)
 };
 
 #define for_each_ufs_rx_lane(ufs, i) \
-- 
2.44.0.769.g3c40516874-goog

