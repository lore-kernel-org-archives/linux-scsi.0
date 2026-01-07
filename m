Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C172EA169
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jan 2026 12:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767790317; cv=none; b=crG+UeSo5xmpCfi2/kZNXay2E49F6L7vAUwz+GB62yh/Ae10ey4tDVHrryNkG1DcZRwbHz4pSc1SFGBpLAuYd+5Z9tKGFJU6THCZWDaZRlLCr3hdkbW8fToAtBYNP1Wd0C2v2eVX0qJRPNT/g/ionI0x5UmKwk0pRp3aMbV1ZFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767790317; c=relaxed/simple;
	bh=b6bGsRp96mSSDNnBG4wke+H2gJj/dTJWhM/CmWnrx8k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=R2/sarBEk2wIceZqXUuRIZ9D5JTElyRGJk6u1dJfFcEmxwZsaI4s6LDIQKxNtK76SuIt+TTzmIjhiwIaTDDJKQgJ9kYh7ItqnpUd/UtheKUlOw4NCcqJGOcaankheoUmFIUvanBGaNRFTovQH0JbdNXEiJXFOOCJ+kEc2S5HlQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pCtHbAt1; arc=none smtp.client-ip=209.85.128.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pCtHbAt1"
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-47aa03d3326so17264415e9.3
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2026 04:51:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767790313; x=1768395113; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4Uu1H5BSD/8+NS93eqVir5v4iZ5eZ6Au8D2IPvaCZC4=;
        b=pCtHbAt1l6/EQdtm595wcnQYJhrK1lsqz+nXwViHg7Rc7imk0YIp6SwBQ3RYXR6SX5
         yObpg2KXCAsGiJxGHvEo6f7fG5NWA8JTL1hlT2Ovm2lenRfY69EUn2SBF3Czs3iJv+QY
         tLKoeXKEj06qBYAKaFrVLbCfcYXzz83fNJtsYi3F2ByTEY64dqiBumu5jtBNJRCWdHWv
         EHT/ifh9RuaNAbTTGY0g/s9Daa4LbHAO9dQeD5cf7GZvxq3KJ6NzlaMC6i/299yWh79x
         oCWk8rPJi+kRydIcCXyBg0rp6043O0P7BtLCgfXPgy2EkWJqddHFAWuGWouPqPWUbGQ4
         OgaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767790313; x=1768395113;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Uu1H5BSD/8+NS93eqVir5v4iZ5eZ6Au8D2IPvaCZC4=;
        b=AHE2eq6l+UIS5d0u9+jl6jFd4nmE2SEWaJbAnclJT76Sc9fC18rS2hkS8oMBPlRHpX
         xTWlHs0o3qfYsXT88n5jj+cTx0yMlXQBs55IoJff8OLU28EQ6Wg2n7roVaP36SGqUffs
         JDgDQi9hqqFJWLWOG59rVLX6S1IZDQtskO8A7bTSi9U9kDdEQlFXGhdb/MGPDtDdyjMq
         xG+r3nDhTxJdCjUFZ+ySXHZeaBUngANFcrNPpK7o4+4woBTM/QKVIG777zIpzHszDupt
         wEwxb2c+cnLX/O7hNDud2Jmr0WCM5fZvoExdrb1T+VH24lVHFMPm69hlop/7FtfNaeW8
         heWA==
X-Gm-Message-State: AOJu0YxRu4YXze4riT3vPTPyHyypxxAlc8W2r6V0Anunlzc7UZM6NC0l
	c5EYhJLFjNo2bbNNzW1+FQTPQXmi7dnNIvxcILv4SXyTmSMLli/B3FGjnij8O0qIXCE=
X-Gm-Gg: AY/fxX4WY8XxR6r10teraxCHLnl43tl91ztEH0Gb1Lz93LNG1H3ZhktKYiHsfUhWxaq
	U3mIwXlCzZ0+28xadLNhCdZDfCOPQkAcwoXlTBHCFkKU37Vsk1SnCOsIZ30e6AvcGNei8jgjXhQ
	U+JXpdpw4UwP7pixfSoNAk4nLD7akJCq2xX32hjDsxK7QBy7ZlJGJaRwy5leovQ/xyY9Sy5KRzT
	78ZSaw4LBcnR8euR+jXuXxytZ373CCbGqWHRu7m6BpgFfAB7Ul/P4t+NL3aPp7oz0PoENmVewmp
	7IChlWatV0Ycyhf+o1L76A0YbQ20Jh34hLCKrHet4swMSCBdmke8z6XuAyyRwozzrRq8I8GCwHe
	F1MySZlZKjEztzKyPTMZi05DiP7NExm6N9Wb1PDmtSTO9OwMrz7h9XYxzLkRK8q8nHMg97p3LY/
	0uBvj/IWPVNHZh1a+Yb7w02PAfaYD/Ye5Qti/HcLdDGQ==
X-Google-Smtp-Source: AGHT+IGtmy+rmCPoBaw4OXxfbS0cwSrvVmxx0w5l1Pkf23wV89pinoU5RtfWAgoq0o44R/EZc+4nJg==
X-Received: by 2002:a05:600c:3483:b0:471:1765:839c with SMTP id 5b1f17b1804b1-47d84b36a60mr25617005e9.20.1767790312777;
        Wed, 07 Jan 2026 04:51:52 -0800 (PST)
Received: from gpeter-l.roam.corp.google.com ([145.224.67.249])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f703a8csm96167505e9.13.2026.01.07.04.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 04:51:51 -0800 (PST)
From: Peter Griffin <peter.griffin@linaro.org>
Date: Wed, 07 Jan 2026 12:51:47 +0000
Subject: [PATCH v2] scsi: ufs: exynos: call phy_notify_state() from hibern8
 callbacks
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260107-ufs-exynos-phy_notify_pmstate-v2-1-2b823a25208b@linaro.org>
X-B4-Tracking: v=1; b=H4sIAONWXmkC/42Oyw6CMBQFf4V0bU1beYgr/8MQUukFbqJtbQuhI
 fy7FRduXc4szpyVeHAInlyylTiY0aPRCcQhI90o9QAUVWIimChYxU506j2FJWrjqR1jq03APrb
 26YMMQDsGtbrXhezKkqQN66DHZd+/NV928JpSJvzkiD4YF/cPM//Yf3Mzp5zmdZ6XqjoXQvHrA
 7V05mjcQJpt297ASvWI4AAAAA==
X-Change-ID: 20250703-ufs-exynos-phy_notify_pmstate-c0e9db95ac66
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Krzysztof Kozlowski <krzk@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kernel-team@android.com, andre.draszik@linaro.org, willmcvicker@google.com, 
 tudor.ambarus@linaro.org, jyescas@google.com, 
 Bart Van Assche <bvanassche@acm.org>, 
 Peter Griffin <peter.griffin@linaro.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2453;
 i=peter.griffin@linaro.org; h=from:subject:message-id;
 bh=b6bGsRp96mSSDNnBG4wke+H2gJj/dTJWhM/CmWnrx8k=;
 b=owEBbQKS/ZANAwAKAc7ouNYCNHK6AcsmYgBpXlbmWHrRbxL0hbh/4m7jouBvvAK6X/XuMtcbx
 KhVs3PMJ+eJAjMEAAEKAB0WIQQO/I5vVXh1DVa1SfzO6LjWAjRyugUCaV5W5gAKCRDO6LjWAjRy
 ut9JEACG3J2/QCQXtSVwyR1VKL0SK3TpcZ8Z9VM0tjtPjrxGKYt5vTijVq/pHd7GZMQshzuuF4y
 dXtphkj4YY9plBcc+xKo2NmzefB4icaI2juenadwRc/Jgx1Ihd94fyAizKWoYHjHs7jtWRaKAXZ
 JR006DGeGdYlIScrn9ObqX2YYd5i1tms0OQP9QIIhEtmWx64MSw1OxqhyziftYKtqCKhv6zxdGV
 QuMEiMXyIBSKa+vSSPA3mok595CTmPFpCy04co/hkyB6JXW8VKMdkTeC8nCQ/GF98n5wX2UwiRR
 bcFjicTHDbHV0qhTUOub7vdAw1IsZ0cYBp9zIsdXd91QrBdvQUJoKRmXFepkJHmCXXRgUX5oqn1
 Va9CtgSk36Y9MG8zyk5YbwT8+XHbI4hxQBIJUsQga217FkCgNuu5P0HWr0hc7sxfLF+4PNGqHbA
 oDTfOTRJbpXf2sdMc/NzZnjvDa3jf4vtjIv7Ibu//yQnLf0EfdonAaejgGmgoSoMaLDYN6rRHuJ
 jjVjhENwgsEEH8GrrO4CgE4xc3g52RewQwCG+tsQbAEuW0IUI42Re3MLnYpRRgc4pUQgLBIis61
 MHGdE8sZ2bsB1jNc2mJdprEtYVGCnYV9yHBCp3A0qzjRB/iFvdg4djG4pPkmf+zamP+hjvVIOiC
 4XaqiwfEvXcF3og==
X-Developer-Key: i=peter.griffin@linaro.org; a=openpgp;
 fpr=0EFC8E6F5578750D56B549FCCEE8B8D6023472BA

Notify the ufs phy of the hibern8 link state so that it can program the
appropriate values.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
Note 1: The phy_notify_state() API is part of v6.19-rc1 and onwards.
Note 2: I've added Barts Reviewed-by from v1. The API name and parameter
changed slightly during the phy subsystem review, but the intent is still
the same.
---
Changes in v2:
- Collect up tags
- Rebased onto next-20260106
- Update phy_notify_pmstate() to phy_notify_state()
- Link to v1: https://lore.kernel.org/r/20250703-ufs-exynos-phy_notify_pmstate-v1-1-49446d7852d1@linaro.org
---
 drivers/ufs/host/ufs-exynos.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 70d195179ebaa01f38331faaee6f8349211c4c3b..6da3d7ee744b92cfe1806fa654eb80a564ae65bb 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1568,12 +1568,17 @@ static void exynos_ufs_pre_hibern8(struct ufs_hba *hba, enum uic_cmd_dme cmd)
 {
 	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
 	struct exynos_ufs_uic_attr *attr = ufs->drv_data->uic_attr;
+	union phy_notify phystate = {
+		.ufs_state = PHY_UFS_HIBERN8_EXIT
+	};
 
 	if (cmd == UIC_CMD_DME_HIBER_EXIT) {
 		if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL)
 			exynos_ufs_disable_auto_ctrl_hcc(ufs);
 		exynos_ufs_ungate_clks(ufs);
 
+		phy_notify_state(ufs->phy, phystate);
+
 		if (ufs->opts & EXYNOS_UFS_OPT_USE_SW_HIBERN8_TIMER) {
 			static const unsigned int granularity_tbl[] = {
 				1, 4, 8, 16, 32, 100
@@ -1600,12 +1605,17 @@ static void exynos_ufs_pre_hibern8(struct ufs_hba *hba, enum uic_cmd_dme cmd)
 static void exynos_ufs_post_hibern8(struct ufs_hba *hba, enum uic_cmd_dme cmd)
 {
 	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+	union phy_notify phystate = {
+		.ufs_state = PHY_UFS_HIBERN8_ENTER
+	};
 
 	if (cmd == UIC_CMD_DME_HIBER_ENTER) {
 		ufs->entry_hibern8_t = ktime_get();
 		exynos_ufs_gate_clks(ufs);
 		if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL)
 			exynos_ufs_enable_auto_ctrl_hcc(ufs);
+
+		phy_notify_state(ufs->phy, phystate);
 	}
 }
 

---
base-commit: 6cd6c12031130a349a098dbeb19d8c3070d2dfbe
change-id: 20250703-ufs-exynos-phy_notify_pmstate-c0e9db95ac66

Best regards,
-- 
Peter Griffin <peter.griffin@linaro.org>

