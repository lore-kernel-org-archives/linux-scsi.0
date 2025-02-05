Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241CB20F071;
	Wed,  5 Feb 2025 02:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738720886; cv=none; b=fZpQQyPqV0fe1tmbDTTk7OkO387z7losf9BEZ9b+2Q4T6gEeJQnuf/DHzIMrAkfjMCAiXc7qHxmrZ/1TL4Vpnun5RgIIGIXp/hvX4M2sAIa3ktUy5M7OAYr5rdt99pMlFx3/0qGJFSCZiowr04IeLiLFmziJFPHW+Ug4x3WbrzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738720886; c=relaxed/simple;
	bh=6Dv9u9iMz+DcsLmWTQCbzBZtfz2P+8l8k57NZKBzhGM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r1JqTrb7kvibvwqN9qcRqg7CjL8J5SDh4BzN++ka/mvcPdaAGoAVrCjPYpWE9ghV0jkU792Hp44d3e+LpCKX9TSbggw6xBWSsGEq6OEucHvc9++V2LOB9eVvtvi9HG9waJ6SfXJoPwkdGOMfXaEflggyzfn9J2dFPYwig6VnL0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cwSIDfUo; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cwSIDfUo"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7b6ed0de64aso39667685a.0;
        Tue, 04 Feb 2025 18:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738720884; x=1739325684; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xvOxm3G/Y/wXWwgs+RUvwCjbDevM4XGRT57WeF3I8uE=;
        b=cwSIDfUoAHHZhMjY1A1vYl7HeZj9ZvItfLEfUqX6DfbUbUXiTF8PA+pdrGQRVkL5ng
         nj3RkFKOG2FE+/jHoXLn8897qTDvgTYCTxk6DBDT1wz+RANT1Sy5GfYKda6E/QEcXzGr
         NUN6IWrIU7zOneAneHH2ES+UXGlAIakJ01/yvo9poi5+NEOi13/GpXpMEFIbpJ+Y/EfN
         mQMLU29/2eRpUYNGovRB54SB1KnSgXphTarDz+/twQa9yiyunqgvGwNVp0s0cuZpXyyx
         dr0p+GXExAraVlRQRyGrRCbDWg6jz7wYSQ9wkotHJ2xK3L7+2FDNMLsEbxUQddcGj5hB
         6krw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738720884; x=1739325684;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xvOxm3G/Y/wXWwgs+RUvwCjbDevM4XGRT57WeF3I8uE=;
        b=FV/Ss2MwF4nDLHtu/3RZ6zlWCXjLyQPP3utzrQ9pBXdZe1ytMVSygVGNBcbmmOAlxE
         LrIf/hy0sUwq7wB5BWvs0bwNQXcxlMVvFTRblJNNhizpqghdca8ZHpdBEDgY1lf2VCgB
         rdqzL6dgHdO4EZ2r07LrQnWQuBBjvj0K+Lvhjpirr6uI2kxTj9jXtlTyaM4tSZz4HBBJ
         G1RjN1BqQCd2YPnFCqRtltls2Jy/h7UDVvAlu5r+vf8COqLju6HZg/n9BSVN8mcaGc13
         PRz1boaSZFjasCrXlsjxzgnBHGns1xmKrVCcwf9oy3jnHT3oZfVzf8t8ChGxd4Nbc+Mc
         9fcg==
X-Forwarded-Encrypted: i=1; AJvYcCVMZSJMrGVE58118c5W9McwuPYWCX4wHJ4CDG0Upmzgy82H1i/ZTgWghjL9TfdzQK4HeylpYnfK1mw/2g4=@vger.kernel.org, AJvYcCVmnWM5nv0WDm4qCEjF7fnMSqCtsVr85Y3bNpuNrtt4QAx7faixO38a9tQyYBlZ2eGAIxJ0OG2v@vger.kernel.org, AJvYcCW2qE0w7io9be/Gk9wX9MywxroHLjWqMx43tsXuUncT8pcanqUMGI+9lvu26UeAFXvxZHPc0ktPiBPddA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzF5dXJXyWrSB5WMABFF6HJm0EFpG/bGqQeWKjD4bmgA/fnlTnE
	2JXAufN4X3Ko+6kP24iXtx0krP/MT0fgOiKpu285cy0XrRhaUEp8pyMHYg==
X-Gm-Gg: ASbGncvdgutoRtUUSjpyP+I4zB+hmXMGwqklFBeiQSO7133x1RKxcpxrIk8IE+h6eod
	rGsur6manzbasqfSCtblUQyuZDAi7J8/WwFX+UaHLGo9CbSPx3gW/SgHotkD/3B75bnN9vGgCyc
	WHnYRuBUDw7knPPQikKN5Mzl22/QnuqFLzg+PTvQItD97rLgttLAoC3U2AyMJ3xm6L1TBqpSCb7
	uxWfCnriUxq6zg0m11hxERm32eqJZh88gdSZIBm1nj9XZyihkaIY9w2F6mhTX2EjQguC/jXsZez
	3r37lUNgm/EHFi18hBtS2ldamJrB3NHu5JwbBw==
X-Google-Smtp-Source: AGHT+IHrk2CDJtR+3y7SwCFZA3V2lDE1/BPlh5BttuyECZhJNhMlQscblVQmJYXG3UvRN+MtPR5P2Q==
X-Received: by 2002:a05:620a:254d:b0:7b6:d273:9b4f with SMTP id af79cd13be357-7c039aa0135mr174921085a.11.1738720883820;
        Tue, 04 Feb 2025 18:01:23 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c00a8bc32bsm705520485a.1.2025.02.04.18.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 18:01:23 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: markus.elfring@web.de
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@hansenpartnership.com,
	arun.easi@cavium.com,
	bvanassche@acm.org,
	jhasan@marvell.com,
	jiashengjiangcool@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	manish.rangankar@cavium.com,
	martin.petersen@oracle.com,
	nilesh.javali@cavium.com,
	skashyap@marvell.com,
	stable@vger.kernel.org
Subject: [PATCH RESEND v3 2/2] scsi: qedf: Add check for bdt_info
Date: Wed,  5 Feb 2025 02:01:19 +0000
Message-Id: <20250205020119.24007-2-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250205020119.24007-1-jiashengjiangcool@gmail.com>
References: <444d6d33-d916-467b-aea8-25c61977713a@web.de>
 <20250205020119.24007-1-jiashengjiangcool@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a check for "bdt_info". Otherwise, if one of the allocations
for "cmgr->io_bdt_pool[i]" fails, "bdt_info->bd_tbl" will cause a NULL
pointer dereference.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
Changelog:

v2 -> v3:

1. No change.

v1 -> v2:

1. No change.
---
 drivers/scsi/qedf/qedf_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index d52057b97a4f..1ed0ee4f8dde 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -125,7 +125,7 @@ void qedf_cmd_mgr_free(struct qedf_cmd_mgr *cmgr)
 	bd_tbl_sz = QEDF_MAX_BDS_PER_CMD * sizeof(struct scsi_sge);
 	for (i = 0; i < num_ios; i++) {
 		bdt_info = cmgr->io_bdt_pool[i];
-		if (bdt_info->bd_tbl) {
+		if (bdt_info && bdt_info->bd_tbl) {
 			dma_free_coherent(&qedf->pdev->dev, bd_tbl_sz,
 			    bdt_info->bd_tbl, bdt_info->bd_tbl_dma);
 			bdt_info->bd_tbl = NULL;
-- 
2.25.1

