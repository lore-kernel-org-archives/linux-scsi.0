Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com [209.85.221.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6017B2ECEAC
	for <linux-scsi@vger.kernel.org>; Fri,  9 Jan 2026 11:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767958831; cv=none; b=sg87hMyEkqxTaR15+e6WpiDEg6CSHK9EKPgWjO5KxLTOAv7AIDJin8NYh1aGe1eSV4ivcWhpbWXO7q6dkfUTFkobGOc38DoERIhXfVCZPqmH3LeOdw0dnq3Jeh1mjO/i3nW59RUy/jolaKpWX/UC4wkNYJO63h3oMaU8HaaqMjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767958831; c=relaxed/simple;
	bh=oLaz/UPrpvvVLvgT2gPEOxUMrZw3BlciMhOBrJEZYCc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Lyu1Zwa8hvpC86RQYMZxuIWqAtYdsidB65aOem8c3zAooYpYO/7Z7M8wIV1nHJddji8jSrs86ei5qYQlE5s9pt1vwAt7REwivsIhyidiu7Rw3PXI1cforqeFUXt4ptMmc2/zdnc1PSl+hbFIAgGe6Mzsc/bfZlpOa4dnzhSFY7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JnfGJXU6; arc=none smtp.client-ip=209.85.221.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JnfGJXU6"
Received: by mail-wr1-f68.google.com with SMTP id ffacd0b85a97d-432d256c2e6so1189828f8f.3
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jan 2026 03:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767958829; x=1768563629; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5J5FE2rV7ygCFlHLBwb5hCWqtsTpEMKY5DEUv0AXHWs=;
        b=JnfGJXU6i6jStRqSBg5w1tkCWStK66fva4n84d0a+JY6j0usvZunxFonpu8VBlpHYR
         Ejz1Jl/d8rpRE9HrdP1wUoboJZjejIqa7eldOJk9pjTVlTdNuv6mJYmgfLf/ZTqaQJy2
         3Z08Ld7Vz4v6AUjHUEVbfdVezPU4OoHp/bGNLWpjsV4AFX/jiIndZB++zid5dpuE6KcW
         RqZql8WbOmu1xdwLOmfbRHU7j+Mj3auxkinr7tAlZ9eMAkOFhkbrUxzIRGGRaEbCWaNG
         zTYcNFQOZrw3cJmKorLZ2SgHFc8UD94Wn19bV86UCdH0v0QUY7F7Cg/NdCnULtWkd5Yc
         fUdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767958829; x=1768563629;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5J5FE2rV7ygCFlHLBwb5hCWqtsTpEMKY5DEUv0AXHWs=;
        b=oog/5XCvYi5Q2lfB09dhvXnaYgmlo8N/nWeImEgi5fjXaxpt85HfVtwkTk7k5cfjSG
         qOxyzMYVlKMtxadjwwxvOnXnCOBxdrY8xvYg4TnrSJyS9QLFwaQf2EVtaAidMBIGEYKF
         PMPnf6JE740PPmn7TrHHpYKRl3DPbuaplTvGkTKEIPkA5HrrByJUzHyQiyHPm5WW0JSf
         MaC2Wjkd0O/WjQxLxbRWhlqtJ2ZS7rgpVhNVZbKeUtXKiGYNJm+rFqGE95AxJq/WRkpG
         g8fleVjBc7TySF1cS+qyIZMM8NSmfsyWpN5zq7YMATpJumdvusAj2bhc2tPax38LK3Bl
         Jogg==
X-Gm-Message-State: AOJu0YyNKD2qIqNXzmHwQcT/HA4HDMGFIjzMKOlq0YjuFWzcip1xYyzW
	MuzO/pSHcDmqbKdI6wl/0aU3Wr2y1Ao2RJce+ChNdmZAFxan157EIaWVj6I8Aqp4nkk=
X-Gm-Gg: AY/fxX6K51Y8lu4Ve7dyWHfXDj7aYzzMQhU28Ak0pMldWvH1Q/gH4DfU8ljoOyvy0Z6
	yDdTq7Mu7rnVpweRlojPYDQRUB0m+ceUy/qpk5nNN6JrFaNIq2Zg2vzU3aJxDXZtXI82QZkkIgC
	e8JwbxJwiGSS72aB8bOWdKgxIKrFfb2ZWotOObm2DUKG5teEYzFCM7nnfdWuyOULsc6b+evUhvW
	ES3GqpYx8ADwwC9RGXAmHOhURc9LAEKBfYerE2oBrrZZvjDn2QZ98qYG/hCQackD7YldhHN/eNm
	xDvUPTtS03MJK2eYRMYtChhnob29en/13wp4+VxtZN4fhbPy+ddNS78cWez39NYp6WE2m7I2SV/
	PdES8Djhw0miEgd9fI1dMiCmNWYgmlCRgx4I/dfOzN2ve12zIhho2P92BfmW11UuYYlYJ9BgbQH
	T7DxSH4zpnDooeC5v8kAhaggYHuhFV7tTmZCQJlcE6UvI=
X-Google-Smtp-Source: AGHT+IELE5v41GM1z995DCq/Vq26mXGNxF7McIPtRrpLDzdmNXt9k6T//iVWMpCwb1VhSb6sunaZeQ==
X-Received: by 2002:a05:6000:310d:b0:431:7a0:dbc3 with SMTP id ffacd0b85a97d-432c37983eamr11401803f8f.29.1767958828730;
        Fri, 09 Jan 2026 03:40:28 -0800 (PST)
Received: from gpeter-l.roam.corp.google.com ([2a00:23c7:3122:c601:1e1:d32d:b1c0:70fe])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0daa78sm22039102f8f.6.2026.01.09.03.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 03:40:28 -0800 (PST)
From: Peter Griffin <peter.griffin@linaro.org>
Date: Fri, 09 Jan 2026 11:40:14 +0000
Subject: [PATCH v3] scsi: ufs: exynos: call phy_notify_state() from hibern8
 callbacks
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260109-ufs-exynos-phy_notify_pmstate-v3-1-7eb692e271af@linaro.org>
X-B4-Tracking: v=1; b=H4sIAB3pYGkC/43OTQ6CMBQE4KuQrq1pH/+uvIcxpMADmmiLbSEQw
 t0tGGNc6XJm8c0sxKKRaMkpWIjBUVqplQ/hISBVJ1SLVNY+E2AQs5SFdGgsxWlW2tK+mwulnWz
 mor9bJxzSimFel3ksqiQh3ugNNnLa/cv1lQ0+Bj/jPmUnrdNm3j+MfGv/nRs55TTKoyip0yyGm
 p9vUgmjj9q0ZKNHeHMJ4yz9xYHnoMwgFBADy8ovbl3XJ0YmBW0vAQAA
X-Change-ID: 20250703-ufs-exynos-phy_notify_pmstate-c0e9db95ac66
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Krzysztof Kozlowski <krzk@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kernel-team@android.com, andre.draszik@linaro.org, willmcvicker@google.com, 
 tudor.ambarus@linaro.org, jyescas@google.com, bvanassche@acm.org, 
 Peter Griffin <peter.griffin@linaro.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2460;
 i=peter.griffin@linaro.org; h=from:subject:message-id;
 bh=oLaz/UPrpvvVLvgT2gPEOxUMrZw3BlciMhOBrJEZYCc=;
 b=owEBbQKS/ZANAwAKAc7ouNYCNHK6AcsmYgBpYOkrHReCSBWEN/TSNB6WKtGTGJD7Ov8Gz4YEB
 gvVHdsEOMOJAjMEAAEKAB0WIQQO/I5vVXh1DVa1SfzO6LjWAjRyugUCaWDpKwAKCRDO6LjWAjRy
 upYYEACZnZyKTZmwQfiAtYvOWkCyYxJZ/KNCLdxulf5MEB9TQcdgJPXm2lSC+TVjNbk0mqpwnpN
 WvTDw1mEeO3y5fYOJJSfDQJ+wywTFR6s9iqY9nK6OYg5hJU36KR7aL831JB5cj0D9EYLGW/Q8p5
 ylTTPbyfXWqyKkp9CM3+hdEcHHUyF1V0Dr7W1ftouPkX2RmnTa/1/DJaA028s33tfFuOt+NZoxN
 3M+Q9Sp+7KtyDJNsDzTciiZzce/R5uu56lfFGoWRS460/wRNMtDLhimdz1u4qY4X4bb/0bYsG5y
 jLjCNHCLLapTSzmCNtDoEpbL1de+l22NmhZjPJTnD1+rFqE2GjWVlTkRELM3H26PARMI3NGTSaB
 Gss8PVUjhXnEu4gX4MqgtIlTGC8kt6cjj5o8GC7oSRSPjWP1t6XXfbshv3htiCCbz1mpjAjq+hp
 QOVHyTbLBRPvEIpDXFJ2XW3AhhzHd7MoMEJNRtwER2JXkwtJKs0TeEwTeMf1WgjBE8TApVU3P3F
 nMk/93wGYaqnLB0W3pIpLyW3A9VllLKB8iHiaS8zFIcdddWd/GL7FV/zFqXrecSPWg8ZrgW689U
 ytnksczMBLuvSW23pK3ux7WliK0khF8I/0YL6jLW2AzqMGIBgJ2F0G4NcycVMWOtSPVL8alwBX9
 VGjzmjsQlsfw8mA==
X-Developer-Key: i=peter.griffin@linaro.org; a=openpgp;
 fpr=0EFC8E6F5578750D56B549FCCEE8B8D6023472BA

Notify the ufs phy of the hibern8 link state so that it can program the
appropriate values.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
Note: The phy_notify_state() API is part of v6.19-rc1 and onwards.
---
Changes in v3:
- Add 'static const' (Bart)
- Drop Barts reviewed-by tag for now
- Link to v2: https://lore.kernel.org/r/20260107-ufs-exynos-phy_notify_pmstate-v2-1-2b823a25208b@linaro.org

Changes in v2:
- Collect up tags
- Rebased onto next-20260106
- Update phy_notify_pmstate() to phy_notify_state()
- Link to v1: https://lore.kernel.org/r/20250703-ufs-exynos-phy_notify_pmstate-v1-1-49446d7852d1@linaro.org
---
 drivers/ufs/host/ufs-exynos.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 70d195179ebaa01f38331faaee6f8349211c4c3b..76fee3a79c77b7117a2c02f380f8c78d702ad173 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1568,12 +1568,17 @@ static void exynos_ufs_pre_hibern8(struct ufs_hba *hba, enum uic_cmd_dme cmd)
 {
 	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
 	struct exynos_ufs_uic_attr *attr = ufs->drv_data->uic_attr;
+	static const union phy_notify phystate = {
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
+	static const union phy_notify phystate = {
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

