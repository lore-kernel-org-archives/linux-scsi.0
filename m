Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB8B1F8747
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2025 19:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751053860; cv=none; b=uotLNskybwk8PbKKz9ysCxOkqDeeFBX1KK8AY6P58oXx3HTgrhmgCm+8R8f5z6UXkZsymU4QdbvGAyctCrH6auE47hzJJw+WjCU7OFOkOXvSu/+oKUCUpdugJlRAPnoPf3xg3rUtFafjrI8IHPlL9nlI3GKeCD8qURxodu0OIwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751053860; c=relaxed/simple;
	bh=AhC7tMRWQT/Xqq0f8UZySYiHCBw/k2ot1sf8xRUAMJU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EIKgvTvEorLTFujzIPBXDNhKhVoJXkKH6rvit/TQQ0880BhmvYLAn5IMPKGnct8ghr4Mw4xkV6vuaJINXecigFUWUQPpy0+OtyscWxiGJZHfc1cOQRsqrnydVyZb1wygJr3HvuWi0qPRaQL/JGmTqtRNkslUq2v1Nt5ariPU81I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=JA+77mpB; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="JA+77mpB"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7426c44e014so3125888b3a.3
        for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2025 12:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1751053856; x=1751658656; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Wl9qIfqM25nfZqWuccDWXnXL+IVYa3s/3FeBklsXJs=;
        b=JA+77mpBOfAcHGeO7brqpuRDOFqlt1kMFFcp2oH092Mv7C+pJFHENCuFmvdSf3C3fU
         kr6t9Cqm+PrhVELOo5qIwYDTK1K89yVg/9bz9ZPFBt6QQzoTtcPef05TuLS3teCOpscs
         oah8zP0GyhqHN1ZRkJ+r4V80pIxz9FsmdbzbQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751053856; x=1751658656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Wl9qIfqM25nfZqWuccDWXnXL+IVYa3s/3FeBklsXJs=;
        b=jVFajOn6pchP6JIUBwlIwsj2z+3+oa8WkC+BKIN6Xw88Ycy2xwchToUG8yHTyCb0qV
         lF3x7tqSiqucY0NUjHUsOAAyxpsqQSy0wtx53tUi5lfsctMbYJYEz8yl3ds0hKKE6EUc
         WHIASQA2r6t04wIH7M0HtWmXKLLxql2KjLpEH3RWna+LuRJ51IJ5Ne+LHC05F8jXzR1I
         RaF0k+Ki2rJIFxN0zAN5FBkz1UU4ZjjJHfoIHFlo+RPCjj420CzA15rreL8joxCf9Q2I
         iyVRqXCp4xzhpCacNXCPhQOmawluUYP6DNY+B0h38706EFexnRdA2KzKUVOiHZhpn3AM
         cbmg==
X-Gm-Message-State: AOJu0YzAmhYQxsNBwNTC2NLqvzVX/Y8QSzcyiDXRxUsxjqp1nyKEuWxM
	qJ3vXBAVfVmyn1o0jzenxqwk01NMjllkvoP6ihGC/7WyPNzdcsVID9Q+aHU2OpbZSdV7fNY3Odf
	8iDdxnYMwf+CfYfZoM0l4BPmh+eZsfLU9LSUfVQcoB2Iz5owmenI7Oo1sKiiXaT5x67Eps4OOEF
	7VxEqEIF2GmnilicCIQL+VRvtWS464NCXy4OVE24U372SwVqKejQ==
X-Gm-Gg: ASbGnct8aRkvxUzOCgcqaXeFtsI+TtV+6FgRhKRJPDON1modtv6NAXumc9r3NQz0938
	p5NM4Ue8o8S8WgAxw2SNmY4oGp483hWKB/ZnhD8sutM1Xyb+GlU5HuPb7jo0U9pHgGepmG3F61q
	W3K1ZZRz0nDDhRpqmPlCmNxK/5wAyPeuLSbtmR6dEex8AnQRN0jt/CexJWOu3uaLCM6Qg1ChHFJ
	+XmRP7zDv9qVFj7t9xDmbbQ0JlCIWsdNt88VtRdousPmRdnKHiYGlpfPaoAVHfnuuYnaXAbjKlP
	7v38hrpfod0JyylRF5lSBJToJ2AHKh4YlCTCo2Q+fEbq3JQoXW+Dd3MnZq76NwhJL3W2RdJQ5PR
	2dOlj6P9lI6gS3fe6OypCqEWOmVY66q0=
X-Google-Smtp-Source: AGHT+IF7Kgn3cdzBHNaKLRryNNQ6ir+ld/xrNZaYegenVrcUnxIVHu0VbW11sJI5RS2Ypr61zu2A1A==
X-Received: by 2002:a17:902:dacc:b0:236:15b7:62e4 with SMTP id d9443c01a7336-23ac4608402mr72247525ad.38.1751053856375;
        Fri, 27 Jun 2025 12:50:56 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb2f247csm23485175ad.79.2025.06.27.12.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 12:50:55 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 2/4] mpi3mr: Drop unnecessary volatile from __iomem pointers
Date: Sat, 28 Jun 2025 01:15:37 +0530
Message-Id: <20250627194539.48851-3-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250627194539.48851-1-ranjan.kumar@broadcom.com>
References: <20250627194539.48851-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The volatile qualifier is redundant for __iomem pointers.

Cleaned up usage in mpi3mr_writeq() and sysif_regs pointer as
per Upstream compliance.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    | 2 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 9bbc7cb98ca3..bf272dd69d23 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1185,7 +1185,7 @@ struct mpi3mr_ioc {
 	char name[MPI3MR_NAME_LENGTH];
 	char driver_name[MPI3MR_NAME_LENGTH];
 
-	volatile struct mpi3_sysif_registers __iomem *sysif_regs;
+	struct mpi3_sysif_registers __iomem *sysif_regs;
 	resource_size_t sysif_regs_phys;
 	int bars;
 	u64 dma_mask;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 0186676698d4..8976582946a2 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -23,12 +23,12 @@ module_param(poll_queues, int, 0444);
 MODULE_PARM_DESC(poll_queues, "Number of queues for io_uring poll mode. (Range 1 - 126)");
 
 #if defined(writeq) && defined(CONFIG_64BIT)
-static inline void mpi3mr_writeq(__u64 b, volatile void __iomem *addr)
+static inline void mpi3mr_writeq(__u64 b, void __iomem *addr)
 {
 	writeq(b, addr);
 }
 #else
-static inline void mpi3mr_writeq(__u64 b, volatile void __iomem *addr)
+static inline void mpi3mr_writeq(__u64 b, void __iomem *addr)
 {
 	__u64 data_out = b;
 
-- 
2.31.1

