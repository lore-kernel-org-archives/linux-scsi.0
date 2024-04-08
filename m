Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34723524D1
	for <linux-scsi@vger.kernel.org>; Mon,  8 Apr 2024 10:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712570736; cv=none; b=uBZyq2/I5QA1E6K+Hh6cBlQPZn0sPuEWpq+AX8fI812LozLtvMYEPPUNepqvsczq1fFoCdXiAjo2RBE5pnPV4gLOaBnpCDHSRp/9WDdTD31TupIrHGtqSu4rqlEDyr5J7jFTEEB6GIgXObCvEXOjTmr8FhP8B4RszMArRX/rJyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712570736; c=relaxed/simple;
	bh=OsJTelcc7tlBV2QwkwR67SVR5ZBOd+QZDuhUnZw4FFg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t5pTqUXBVY1vzjf6s23PgC+ILchj+3xCjedn/PfpqOWhC2kl42L80rIZ7Vqf4gxSurwEd+4DF3jt3r8lzTVi+fX/1K40sUsDWWdKFrJw7xNx0kZ+SPKanOF6Nd8ba0HAaQE+sTbDVk/Lm1bDB8+wpFabJkqBTt/liQJe4mS7dEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com; spf=none smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=Ba7RVx2n; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="Ba7RVx2n"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-222a9eae9a7so2228110fac.3
        for <linux-scsi@vger.kernel.org>; Mon, 08 Apr 2024 03:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1712570734; x=1713175534; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eBLG7eQZNN9ZhfgeoyOekEyjLAkk752YA5M9Sq+ECMQ=;
        b=Ba7RVx2nkMlPZYV1qgmwM//g6czFp8lPWZLAJt3JoO+pv7iEgbCGEsHksV9F4/qMBi
         N3EuTdaWJVh+GFE46PZOK6TFYOInI2t7Q0mJexjgsUn7ycpyejoVHpXjUhhObShY9Lmh
         9EYPdQ0vp40up4vZnEn3Dri/ExXsZ5tIbwis51XvKHcJumPBfBv7JChsu5FOdPUmigeD
         ZjdLjBfeJcmFL9s/AJ+syajnnZnNm7PFR52WEpgpVvtMrpzI+v4pJBKf05z32zrWKygD
         F9z/7M//CiK6irQ4ihrSRRQcbeDG3LwZQz12o2Ylz4XxdZEwqVR7KnpqhEAvI+Rzeyrj
         pI4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712570734; x=1713175534;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eBLG7eQZNN9ZhfgeoyOekEyjLAkk752YA5M9Sq+ECMQ=;
        b=h0UmibelT5I3lThjof2afrk3oJPCXv2k8MrRt16w7k9NhY6MuLKkgofks/i/D3RA0a
         1fGKi+01hDEq8muOHkc06cAK0kmpneV/m4fTaQVXjgb8SSALGNifrVILo6MytIgJ40Ou
         E4dQVWmGxGs0Q9CxSKMK7juXzbQ1i/OuCUCDfzqEB1P9mKdoiGBw7mlPRBgbLnJkdLRV
         wdQJoiJDLMkJR+zP6h482MXRhzd8CAbEMni+9MlBo8R8FLOuViMYEg7ZHWezx4iqwcQK
         Q+2x00ESP2Xe2ALDCtjlPX9wk4PHWzGAVPQLytl4OreVbiaxW5KqZv/i415W01R5pHCR
         kGvA==
X-Forwarded-Encrypted: i=1; AJvYcCWGMnBk6KVD4vl3tfczl4IL5nLxfwcn0Gqey9SL4ZS4q5DGB/63asUSCS5BBcOmHNqA7yXQy3DGDvp6JTggepNPpzyoyT5PjVzUXg==
X-Gm-Message-State: AOJu0Yw1/p9x7/gwpfZsagAXvr80LOrrnRnM1te1IQpmWo/cz+JY+hiR
	J1s65e5zXtrUeWpStJP1sHTRJdY1LmkbXRezm317pyiNy46AKqq51TJybBKaYtY=
X-Google-Smtp-Source: AGHT+IEx7VTx0K0yOwbxPA8x0d94YSdl3SQSAKztRAl4yW5VnRP8hMQdfy/b/azX8aClfP0obPVdAQ==
X-Received: by 2002:a05:6870:f70a:b0:22e:7460:d2a8 with SMTP id ej10-20020a056870f70a00b0022e7460d2a8mr9628681oab.42.1712570733497;
        Mon, 08 Apr 2024 03:05:33 -0700 (PDT)
Received: from localhost.localdomain ([103.172.41.206])
        by smtp.googlemail.com with ESMTPSA id fe15-20020a056a002f0f00b006ea8cc9250bsm6144272pfb.44.2024.04.08.03.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 03:05:33 -0700 (PDT)
From: Lei Chen <lei.chen@smartx.com>
To: Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Lei Chen <lei.chen@smartx.com>,
	megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] scsi: megaraid_sas: make module parameter scmd_timeout writable
Date: Mon,  8 Apr 2024 06:05:03 -0400
Message-ID: <20240408100505.1732370-1-lei.chen@smartx.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When an scmd times out, block layer calls megasas_reset_timer to
make further decisions. scmd_timeout indicates when an scmd is really
timed-out. If we want to make this process more fast, we can decrease
this value. This patch allows users to change this value in run-time.

Signed-off-by: Lei Chen <lei.chen@smartx.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 3d4f13da1ae8..2a165e5dc7a3 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -91,7 +91,7 @@ module_param(dual_qdepth_disable, int, 0444);
 MODULE_PARM_DESC(dual_qdepth_disable, "Disable dual queue depth feature. Default: 0");
 
 static unsigned int scmd_timeout = MEGASAS_DEFAULT_CMD_TIMEOUT;
-module_param(scmd_timeout, int, 0444);
+module_param(scmd_timeout, int, 0644);
 MODULE_PARM_DESC(scmd_timeout, "scsi command timeout (10-90s), default 90s. See megasas_reset_timer.");
 
 int perf_mode = -1;
-- 
2.44.0

