Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1DA5661
	for <linux-scsi@vger.kernel.org>; Thu, 11 Dec 2025 13:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765459954; cv=none; b=jmQyF0f//4/f1HpDNN3AfPkUoVUx1ci0MzxpdSq/2eaUmJQOPEqcvNcx5llyiY1XA4rM4BWiLmFiGAx9g/ajlXyIZZhkvWQvFPnXTqXm/LDOpSuYI+1S5Z9pdK6qaeTzqIfSXiu30efFVMZy08sl5SMWJoA7YXFFLzIXa1gBzOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765459954; c=relaxed/simple;
	bh=xBim7BpAzXNhX/2MWfZcXTqtqP8TLcx3T3SUKgken9k=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=gezmckzB1mmByayUV+5PGHjaHWYopg3b+pi5IO4wNwbVZN6BB0POLZHWYmJw98/eA/yauictx0AauOP1zvLWT7ezco/jlT8veNglFsxTu0nCDczUHp8J6SCK0H4nrtF79nchWdfG3jEIvYPdsHvMUMi9J2MHTakhW0JhiV6OeLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vamshigajjela.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dqDfpoTB; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vamshigajjela.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dqDfpoTB"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29809acd049so1398175ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 11 Dec 2025 05:32:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765459952; x=1766064752; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=q2zCyRVVS+v7RvbYEfTkZSBTDCaSaENAPVHvKXbPKz4=;
        b=dqDfpoTBbMA0WFapi4z2FTQQYaS0DZfqQuId751gBVTKh9MfKV96dmK39ZvM87wf1L
         lxrGNtfUzQ/XYl1bJyEYFUoH8Qw3zRIwDTUbVzUrvhkALrXEMyZ+i0v/oVTHX/M/5co4
         +jug2Q+83zk6ddd6mL58BX0EfvzwP9rg/IuV6gBFp1bxKrXpzOCvpn4Yo3A9ykIgPVdg
         w6Spm1GQwqe0CLU39CMJb6nFAcw/W+87UB07EI7VZOiYMNBtbuGCAfU1YqOn/VAtfh7v
         35Nt/hVGbNwumfUOi5MxNjdj2Cjtxb1GIomBAoMd+Y+XD2tmNXMY/g76SqEbgQoGgeP1
         86Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765459952; x=1766064752;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q2zCyRVVS+v7RvbYEfTkZSBTDCaSaENAPVHvKXbPKz4=;
        b=k6GBHMdfmcugg2rT+dc/WpTvTFovPBjbbdyrj2GXKkj2VgNand4bRMZ4zHFMbSHMPs
         aD/tU+kWYI9SBnJYagd2vWrBmo1gmyaTv06hsWJwK1hbwcMxiK68LFm/N2qLwaK6pkvC
         Yaci0P2a4orid4/e3oqlWGUDxBrQAkgByVKanssm23WTqFG8iKxDmRZbSkMtg9/d7wL2
         z2iXDWvN0PvAP3Yi/9RSGsd++09U6Onm7OrSoX0wixrvxBV6czthExitvNEKxQPSfqFv
         eWL+Ch+pksqGiZju+jGLnsA5Ud+6FCu6zSd5VU1v/IH0YtNDDPVOw537a/I6qZdSfzt1
         jinQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvgrR9TGo0ZLv/43op6N04hWnuPzdb9o2OY00lyPHIo8GK6BLoAO0S2x403bghkx09GMdDJexWJMZd@vger.kernel.org
X-Gm-Message-State: AOJu0YzvWYZJHjbUAtVnywxYt6yvTmivTk8qB0kLb4Uie68P8OGlWszK
	WUJQpTU49Yrie/or5h2Qk0KmjibSdK9dsNuMJ0LukQDnod8SSC1vqCwy6BGkBCiDjWTD6VIa1h3
	dDsQ0DrBSwcckpr8dgHBgsGJx3sKCdvtHDQ==
X-Google-Smtp-Source: AGHT+IELlfWiPzOGXfWnxmYr7ftr95iL2A2XQ1olvykor9AUSQl/HZFfCXPSKkkwHIBR6FktiW/w3uk5T/Z6m1m/qHPz
X-Received: from ploz20.prod.google.com ([2002:a17:902:8f94:b0:297:da8b:2531])
 (user=vamshigajjela job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e88f:b0:295:7b8c:661c with SMTP id d9443c01a7336-29ec22effc7mr64177075ad.26.1765459952142;
 Thu, 11 Dec 2025 05:32:32 -0800 (PST)
Date: Thu, 11 Dec 2025 19:02:27 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251211133227.4159394-1-vamshigajjela@google.com>
Subject: [PATCH] scsi: ufs: mcq: Refactor ufshcd_mcq_enable_esi()
From: vamshi gajjela <vamshigajjela@google.com>
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, 
	bvanassche@acm.org
Cc: avri.altman@wdc.com, alim.akhtar@samsung.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, vamshi gajjela <vamshigajjela@google.com>
Content-Type: text/plain; charset="UTF-8"

Currently, ufshcd_mcq_enable_esi() manually implements a
read-modify-write sequence using ufshcd_readl() and ufshcd_writel().
It also utilizes a hardcoded magic number (0x2) for the enable bit.

Use ufshcd_rmwl() helper, replace the magic number with the
ESI_ENABLE macro to improve code readability.

No functional change intended.

Signed-off-by: vamshi gajjela <vamshigajjela@google.com>
---
 drivers/ufs/core/ufs-mcq.c | 3 +--
 include/ufs/ufshci.h       | 1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 9ab91b4c05b0..64c234096e23 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -431,8 +431,7 @@ void ufshcd_mcq_disable(struct ufs_hba *hba)
 
 void ufshcd_mcq_enable_esi(struct ufs_hba *hba)
 {
-	ufshcd_writel(hba, ufshcd_readl(hba, REG_UFS_MEM_CFG) | 0x2,
-		      REG_UFS_MEM_CFG);
+	ufshcd_rmwl(hba, ESI_ENABLE, ESI_ENABLE, REG_UFS_MEM_CFG);
 }
 EXPORT_SYMBOL_GPL(ufshcd_mcq_enable_esi);
 
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index d36df24242a3..806fdaf52bd9 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -288,6 +288,7 @@ enum {
 
 /* REG_UFS_MEM_CFG - Global Config Registers 300h */
 #define MCQ_MODE_SELECT	BIT(0)
+#define ESI_ENABLE	BIT(1)
 
 /* CQISy - CQ y Interrupt Status Register  */
 #define UFSHCD_MCQ_CQIS_TAIL_ENT_PUSH_STS	0x1
-- 
2.52.0.223.gf5cc29aaa4-goog

