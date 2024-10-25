Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E85020D507
	for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2024 13:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729862103; cv=none; b=VspEFXentNpa1xCS6zVUEfB3oGzj1GjEimqlbykrg6El5I1SQe9t2GvX61YrxqHvRbVTPOYfl5gAu81LQHKS7d4WLwvHKO39D/hm4T8en6Gkhzrzw3gmPJZwqxhoiPLEmf7CWViMFekV3OgzlT/yIGb/G++KObtsaSJ72FAReGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729862103; c=relaxed/simple;
	bh=UMHAH+7d2ubvmat4NPmFpXjrw0W8dqJHnrFUvo9OI4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z5L4Tj0O+LMmmK4t8VgVPQFebw4NPWXeQ75jKRgRDy/OSeCF0K2+wMCK7EOI25//tw2RQIDw3/VLAMmO+YpVqjanmmBRX4NET6KaPDNLQ1/I5v8MOrWUGAVd7elTu6dyk4Ne7l5jGGJ8/jORIjMIVkn/Y4qgW48AkNHI/DlD3W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NRPQ0cEp; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NRPQ0cEp"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-539f1292a9bso2604216e87.2
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2024 06:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729862098; x=1730466898; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8mSP0Idfdl9Bddnm7Irkt+YNMMsQJrdvTnch1RJ4UlY=;
        b=NRPQ0cEp4OpsryTWWGL5cuw3MWDowipQAhe4dDzFYXr6rKK/6b2NzSm9fP1yFi/SA4
         mqWk0TdGGaS+GR2a0xiQO0NJKK2TO7IfCUAUKQZct5w3dXrs+Z7ocGesZ8FWxrzV719f
         mspEQ/G1lD4MMzyyCrnG5jhU7k194s1lhgy+VJNTgQPs7HwmYUu6+odzom+bx/DdK5n5
         S9YI0oRbUanpsLoVITWk1jY6sOAxc/8yXDmwjtdx3+ATtYGEqZBOSoN3DpenFtxhNDin
         O3l67T0TnTinIO/5XBbbUOqU3iJcVfjkfyYDf5BNEinmzLDh0QeyjJ1RlB+IO6sJFauT
         PXBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729862098; x=1730466898;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8mSP0Idfdl9Bddnm7Irkt+YNMMsQJrdvTnch1RJ4UlY=;
        b=s+cL2Gr5blnPdGDD5iUduXlR4uq2lIdlN3EF8gqahVnSIQa8mPKSRoRBOmZj/Fg6Vu
         hu3Ci1DbogvBvMUPrueUibmGwVTmmQQ6yT4qohfHpmGSrfx0Bwc9e2LpXq0Bd7ajH3+j
         +Att1S1rpTlkRnY8QekE3UUoGm75nNqcROdbXHGJZ6IDIApdMKXSzmSvjl+yBn6WFeOK
         gvGWaO/LV4Y/MOdsne6Jj/f0ZACICtiU52rCJFtgD6U40KxXFPz5ZRsGtk7tMxq9QqrL
         ATSU/amQEhdcdB97S5pcpRrLiJ2QeLKBYd4+xoNWA5P7pcLzgzKA22VPqf7rABF2oP3P
         tyYg==
X-Forwarded-Encrypted: i=1; AJvYcCUE7vFpPERXx1RFO7Nw96AiyyEjcVU+iurSQrLLrGI/zl1r4MGgZNtOp0Rl1QP4xrHAIYAc1aca/fCS@vger.kernel.org
X-Gm-Message-State: AOJu0YxXttE1kGGxeeQ1dvFE/xLZGmOQU17TdC02uoMA8b0RTroC30Ag
	A7Jc0wMFpQCYBLH5tZhnVLxWlH2oPWBgBdz884E1yPLNCRmS9C/zdID9Lgs6ub4=
X-Google-Smtp-Source: AGHT+IFIjxCtFqGk3E1YIZeIbZDApteEen8rQ8qLd9MWNW7M5VeqNXGVeyRg3HBljC/8CXJKDn+GyA==
X-Received: by 2002:ac2:4c55:0:b0:539:fc75:99ae with SMTP id 2adb3069b0e04-53b23e1df9emr3392181e87.31.1729862098342;
        Fri, 25 Oct 2024 06:14:58 -0700 (PDT)
Received: from gpeter-l.lan ([145.224.67.228])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4318b58b6bdsm47616685e9.45.2024.10.25.06.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2024 06:14:58 -0700 (PDT)
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
	ebiggers@kernel.org,
	Peter Griffin <peter.griffin@linaro.org>
Subject: [PATCH v2 07/11] scsi: ufs: exynos: add gs101_ufs_drv_init() hook and enable WriteBooster
Date: Fri, 25 Oct 2024 14:14:38 +0100
Message-ID: <20241025131442.112862-8-peter.griffin@linaro.org>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
In-Reply-To: <20241025131442.112862-1-peter.griffin@linaro.org>
References: <20241025131442.112862-1-peter.griffin@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Factor out the common code into a new exynos_ufs_shareability() function
and provide a dedicated gs101_drv_init() hook.

This allows us to enable WriteBooster capability (UFSHCD_CAP_WB_EN) in a
way that doesn't effect other SoCs supported in this driver.

WriteBooster improves write speeds by enabling a pseudo SLC cache. Using
the `fio seqwrite` test we can achieve speeds of 945MB/s with this feature
enabled (until the cache is exhausted) before dropping back to ~260MB/s
(which are the speeds we see without the WriteBooster feature enabled).

Assuming the UFSHCD_CAP_WB_EN capability is set by the host then
WriteBooster can also be enabled and disabled via sysfs so it is possible
for the system to only enable it when extra write performance is required.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/ufs/host/ufs-exynos.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index d4e786afbbbc..40b2563fe011 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -203,7 +203,7 @@ static int exynos7_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
 	return 0;
 }
 
-static int exynosauto_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
+static int exynos_ufs_shareability(struct exynos_ufs *ufs)
 {
 	/* IO Coherency setting */
 	if (ufs->sysreg) {
@@ -215,6 +215,21 @@ static int exynosauto_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
 	return 0;
 }
 
+static int gs101_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
+{
+	struct ufs_hba *hba = ufs->hba;
+
+	/* Enable WriteBooster */
+	hba->caps |= UFSHCD_CAP_WB_EN;
+
+	return exynos_ufs_shareability(ufs);
+}
+
+static int exynosauto_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
+{
+	return exynos_ufs_shareability(ufs);
+}
+
 static int exynosauto_ufs_post_hce_enable(struct exynos_ufs *ufs)
 {
 	struct ufs_hba *hba = ufs->hba;
@@ -2124,7 +2139,7 @@ static const struct exynos_ufs_drv_data gs101_ufs_drvs = {
 	.opts			= EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR |
 				  EXYNOS_UFS_OPT_UFSPR_SECURE |
 				  EXYNOS_UFS_OPT_TIMER_TICK_SELECT,
-	.drv_init		= exynosauto_ufs_drv_init,
+	.drv_init		= gs101_ufs_drv_init,
 	.pre_link		= gs101_ufs_pre_link,
 	.post_link		= gs101_ufs_post_link,
 	.pre_pwr_change		= gs101_ufs_pre_pwr_change,
-- 
2.47.0.163.g1226f6d8fa-goog

