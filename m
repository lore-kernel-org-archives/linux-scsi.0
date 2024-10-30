Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C711E260C
	for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 10:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730284044; cv=none; b=pSOS4ufUbsmBjouBCOKjhrHlT5a4eCgQu3Wd4rOr34JhG2+8BE/VEqFDddo/00ccWoIOdo2wUVViDl0aKXmEn6Gy6gyaKkUTpMUR88R3/V6coolFtf3QCZksXqtEpB+lMS0zFUGGlf0aNmnFmWMED1UIrqWWwN/Gv1jAYrmarE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730284044; c=relaxed/simple;
	bh=1vewpM2bAPjZCI45gCVSZFD94dAv/0fVsZ5NW3TKMs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWbvLXW+wtGmlOcfsixvpv6CniUXOwWcwRRU1oWGrTQluBbK7Pak9XRx0eS+8Bad3uFTKI43ZMmqMlQvug2enXcJ+NXJiKFlSzql52MQfPAwXNOEDVJP7SxqMkFQ/jxcPwn5IRSfrCGvnnbs/tr7JPQwbbFKEjAXPm+NHgXmkps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LlnoAH+Z; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LlnoAH+Z"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4315baa51d8so62011865e9.0
        for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 03:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730284040; x=1730888840; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xa7O9twJ6bmDbN5DQRcWJq8Kwm2U8nXjdv5M+G4ksMQ=;
        b=LlnoAH+Zr12rWPRfaGt0135iQMN+F/1iMrJgpj6xSP1N0PNSvIEJ9WpJbk49EXnqMv
         KijHrS8sPEjMLH9bI3f1tY6hLUChyxg7edemXwphT07CR7qWF0g9f5/eLEMYd6NEOuUT
         MW0wowM4hJIGzwyVWvnYma7URKN2vH9pCCtqVKmur1pwWxuMu75KxOc4KS4oJ82R6y1M
         YTKOP0ttjO2DprOW0oqQt/vGx9n0EZP6jkILUUunxYYkAVcscDkTMc2R2WlJZpNABOqu
         GCt5ZBpEjVSnhGRo5kLxPhQ2Tx+0pVwFcGm8lQdy6acOwgDyhaliwO8pfJLh6rXVksnp
         NH6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730284040; x=1730888840;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xa7O9twJ6bmDbN5DQRcWJq8Kwm2U8nXjdv5M+G4ksMQ=;
        b=Ac/imSuOK2BKqwF3Sg5CbN4hOnwHJ9lAQx4WXHaYZag2EFlETRPMC1ZKPTGZWkwqLu
         ZhYuar5l4w5uAT9EZAQu3Xxo2vTSYUd9sTiqRfAVH61CcjEh49o5zKOSvycz9ZB+LJwv
         uDo+6KfTLB4WmfV1FAqGztKaykbucwCkXnnwwx3ELgm6KuiquxInf7KhAE6gXTwS/StX
         wLXQm5+ifCionlnbwQ5N97+4OiwupG+w9V4SBxGP4Zih1ztXGwnFaLVlaJt4Ouw98iwf
         1HQTzrdLLvi8rTBWIBs2UTFBhYx5fxknZgpIaou3Lt9vwBRwXbmaX5fPOLBqNtCtvobn
         Ksug==
X-Forwarded-Encrypted: i=1; AJvYcCXT5rcxdoE7j3GF7HC9InUX9C2F6FMdfYFoDO5iDKb3S5tMvTFwNNm/qQJZqsA3ZoODg7AEJZNiY57N@vger.kernel.org
X-Gm-Message-State: AOJu0YwG1kd24eJ/p2U/VBNHSNDUylCTt5w5e5/miJXGAMepFKF5auQS
	h62UlAZI2TsCbVFew2MPE2+Af6lNLQFSeiOooyYH0XYaTE12kACOyKiRyIA5kjc=
X-Google-Smtp-Source: AGHT+IH3P/SUi2QfbJPyZVVflVQvstXkhGR0+ne23A7qXQP4p7DSlsWKQ60Mu7VBfsVT8CMLgRehCg==
X-Received: by 2002:a7b:c354:0:b0:431:7c78:b885 with SMTP id 5b1f17b1804b1-431aa80f822mr75969765e9.4.1730284040266;
        Wed, 30 Oct 2024 03:27:20 -0700 (PDT)
Received: from ta2.c.googlers.com.com (32.134.38.34.bc.googleusercontent.com. [34.38.134.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bd947b2bsm17074345e9.25.2024.10.30.03.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 03:27:19 -0700 (PDT)
From: Tudor Ambarus <tudor.ambarus@linaro.org>
To: alim.akhtar@samsung.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: krzk@kernel.org,
	linux-scsi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	andre.draszik@linaro.org,
	kernel-team@android.com,
	willmcvicker@google.com,
	Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 2/2] scsi: ufs: exynos: remove superfluous function parameter
Date: Wed, 30 Oct 2024 10:27:15 +0000
Message-ID: <20241030102715.3312308-2-tudor.ambarus@linaro.org>
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
In-Reply-To: <20241030102715.3312308-1-tudor.ambarus@linaro.org>
References: <20241030102715.3312308-1-tudor.ambarus@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The pointer to device can be obtained from ufs->hba->dev,
remove superfluous function parameter.

Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
 drivers/ufs/host/ufs-exynos.c | 4 ++--
 drivers/ufs/host/ufs-exynos.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index db89ebe48bcd..7e381ab1011d 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -198,7 +198,7 @@ static inline void exynos_ufs_ungate_clks(struct exynos_ufs *ufs)
 	exynos_ufs_ctrl_clkstop(ufs, false);
 }
 
-static int exynosauto_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
+static int exynosauto_ufs_drv_init(struct exynos_ufs *ufs)
 {
 	struct exynos_ufs_uic_attr *attr = ufs->drv_data->uic_attr;
 
@@ -1424,7 +1424,7 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 	exynos_ufs_fmp_init(hba, ufs);
 
 	if (ufs->drv_data->drv_init) {
-		ret = ufs->drv_data->drv_init(dev, ufs);
+		ret = ufs->drv_data->drv_init(ufs);
 		if (ret) {
 			dev_err(dev, "failed to init drv-data\n");
 			goto out;
diff --git a/drivers/ufs/host/ufs-exynos.h b/drivers/ufs/host/ufs-exynos.h
index 1646c4a9bb08..9670dc138d1e 100644
--- a/drivers/ufs/host/ufs-exynos.h
+++ b/drivers/ufs/host/ufs-exynos.h
@@ -182,7 +182,7 @@ struct exynos_ufs_drv_data {
 	unsigned int quirks;
 	unsigned int opts;
 	/* SoC's specific operations */
-	int (*drv_init)(struct device *dev, struct exynos_ufs *ufs);
+	int (*drv_init)(struct exynos_ufs *ufs);
 	int (*pre_link)(struct exynos_ufs *ufs);
 	int (*post_link)(struct exynos_ufs *ufs);
 	int (*pre_pwr_change)(struct exynos_ufs *ufs,
-- 
2.47.0.199.ga7371fff76-goog

