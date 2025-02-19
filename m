Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B02146593
	for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2025 10:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739962255; cv=none; b=HgrEtcirrOhgIOYIH3bNEFExAWDWtELzGw5qwvW+nmC6sx/RdzAAMBMvLYozjWLH2W3npJsvtH88vBLwZ6uoxEnqx2/f1S7qrYFXRATlFLfhfVX8aXMTI6M+MdX0TFNUq6b0qAs6L1qFvxOAze9YoRiijdYY8cd/0peX6hMhyIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739962255; c=relaxed/simple;
	bh=RLMi5EmXrqGI3oC41Ek3Du7qdXadTYc150g8u9oSVhg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uAsfyx6+SQF0pA9btC+xqLRQYTId/OvaQtPGlcjXV3b5U8pVtMuZqdqzVmMoixln/KCrq9tBspf95UvocwQZlUlQxXpJqwIGqL3BTmMxjfAEtresLXCswyQOZ6ko01o+4WUOANd5qemzd9frP6cOqxsfrf9yG1TGN+eKTNgPP2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wQbQeYsK; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wQbQeYsK"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2fa48404207so13104019a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2025 02:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739962253; x=1740567053; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NxBZ1UjPnsXI4oRFjcU23i2GjzUnsRvFJSGcGiMisqQ=;
        b=wQbQeYsKD+m1lbeV377UiEF0YkqLE4a+vp5JwGd2L4n9BTUbLsFZX1jAEO8TUtMVh5
         DuBJShf+eevCrGCRZh4ixZowUSMy512hbwVEaoKrKGUDaz/KFqsLKFBT47yGZcndXF9Q
         iPtjZyD1F6e108vQDPf+W35yJSHKzYMleRxik9FxpE5wNHkChiWul1bQclUH3rFE9vbw
         H6T7NH+fczDtdU4jLghRLj9OEtwf73Zja5h14Li7Wz6PDd1dOQAyAQ4GUnqA+XgNFPqB
         d4pgvier9QxUybuzZXYreH1JNlc3NBaSJoHaGxchpea6OUfeyn2B1MN/93a5Rb/zeHjJ
         xjlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739962253; x=1740567053;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NxBZ1UjPnsXI4oRFjcU23i2GjzUnsRvFJSGcGiMisqQ=;
        b=heqKC5Hq82GSSorbMa5uMXKLvvLvdeTQAPgUyfIyxaYNoNJbYHvzjSMfFX0DwaEH4I
         laupEQTEh9Lb0vC1XnKrv+3LdTQfb+MKjWO5c5nPwd3pQ/RAKHmihxhEu+AQUYcA0Yht
         KIznkET2XVpYmNMki0Se4eJNl6mYIGmSaMUDlAZr95LytJEJYxDV6ORd5jkGaoBwALHH
         HOPARw+7EBrohfEFq0suaXox5Cj/4F6QyNY92fY2gu2iZ9eHWlmlWaknsnhomF7FN2JV
         hY8mmI3QvBcjb7wjVzWuA+CvFYqRhiOd9lEshIWWsLNcLDHHJG9Z+uA7iMwyHpND9b/e
         RiAQ==
X-Gm-Message-State: AOJu0Yx/EAsSfVTc7hPrl40PIoy3v2yk04k9SCkeYsHurSDSGM0RGZb5
	Vs6JIn0tJJDvBu5e+q/JnD0X/PdSiI5xJKSdz4c9kHVRketk4RDF1v49+uMqUQ==
X-Gm-Gg: ASbGnctVigSOGxroD+FsTeMWMe+0mcl1cTptjCqbO9eIZ9U6oPIBuYUWLM/DvUlntsV
	4yFlacx/hDVhy7+UguM1+u8uP05xK+aftZw1vzg/n8f6jVz9lFAe5o8hOEBf5Eo6xL8p1w5PiyQ
	lzT7wSySBA6+PoP8mD1gAVjioZ1It92dXd5jUizCbwNidCs4HFRYpgtvlUKB1qeGPWlzXON1pyN
	hCodkpvNaKi12jweyK69S6i11k3Q7RXQ6IYP4CXieyygp1TFeV6AVStoKrXt4SKnpumRr2/8nw+
	AE1ocE00ry1VnoX9ZKAc42OwZUKXxpmr3Tn3NH3wFHBc
X-Google-Smtp-Source: AGHT+IG/XtQGsadm1QjJPU7kl8+l/LuD/XOzE5rYqdDYyrESjHrhtCdtkSR0VBQcG92BdOSf4eQA7A==
X-Received: by 2002:a17:90b:4b91:b0:2f9:9e64:37b1 with SMTP id 98e67ed59e1d1-2fc41040fd9mr26036322a91.28.1739962253298;
        Wed, 19 Feb 2025 02:50:53 -0800 (PST)
Received: from localhost.localdomain ([120.56.197.245])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fc13ad4391sm11755451a91.27.2025.02.19.02.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2025 02:50:52 -0800 (PST)
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Bao D . Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH] scsi: ufs: core: Set default runtime/system PM levels before ufshcd_hba_init()
Date: Wed, 19 Feb 2025 16:20:47 +0530
Message-Id: <20250219105047.49932-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit bb9850704c04 ("scsi: ufs: core: Honor runtime/system PM levels if
set by host controller drivers") introduced the check for setting default
PM levels only if the levels are uninitialized by the host controller
drivers. But it missed the fact that the levels could initialized to 0
(UFS_PM_LVL_0) on purpose by the controller drivers. Even though none of
the drivers are doing so now, the logic should be fixed irrespectively.

So set the default levels unconditionally before calling ufshcd_hba_init()
API which initializes the controller drivers. It ensures that the
controller drivers could override the default levels if required.

Fixes: bb9850704c04 ("scsi: ufs: core: Honor runtime/system PM levels if set by host controller drivers")
Reported-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/core/ufshcd.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index cd404ade48dc..9a724ed860a6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10429,6 +10429,21 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	hba->irq = irq;
 	hba->vps = &ufs_hba_vps;
 
+	/*
+	 * Set the default power management level for runtime and system PM.
+	 * Host controller drivers can override them in their
+	 * 'ufs_hba_variant_ops::init' callback.
+	 *
+	 * Default power saving mode is to keep UFS link in Hibern8 state
+	 * and UFS device in sleep state.
+	 */
+	hba->rpm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
+						UFS_SLEEP_PWR_MODE,
+						UIC_LINK_HIBERN8_STATE);
+	hba->spm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
+						UFS_SLEEP_PWR_MODE,
+						UIC_LINK_HIBERN8_STATE);
+
 	err = ufshcd_hba_init(hba);
 	if (err)
 		goto out_error;
@@ -10542,21 +10557,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		goto out_disable;
 	}
 
-	/*
-	 * Set the default power management level for runtime and system PM if
-	 * not set by the host controller drivers.
-	 * Default power saving mode is to keep UFS link in Hibern8 state
-	 * and UFS device in sleep state.
-	 */
-	if (!hba->rpm_lvl)
-		hba->rpm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
-						UFS_SLEEP_PWR_MODE,
-						UIC_LINK_HIBERN8_STATE);
-	if (!hba->spm_lvl)
-		hba->spm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
-						UFS_SLEEP_PWR_MODE,
-						UIC_LINK_HIBERN8_STATE);
-
 	INIT_DELAYED_WORK(&hba->rpm_dev_flush_recheck_work, ufshcd_rpm_dev_flush_recheck_work);
 	INIT_DELAYED_WORK(&hba->ufs_rtc_update_work, ufshcd_rtc_work);
 
-- 
2.25.1

