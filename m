Received: from mail-qk1-f227.google.com (mail-qk1-f227.google.com [209.85.222.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAEE481A92
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 15:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787672679; cv=none; b=RScGykHLquJIZPRilIr/7TWPHkgsDBN/iUGTB04RlkLsLLo+lQKsNLAuWQS84j6o7BbJBbSXP8tEzF9USy3JoZf9ikEGaYKbk4dw8vrsvHXmnV+19DZ+wna51Buq56YTMggTdnQVxLhdG6GOI9Gnt9bCxP58hcxLzk2GRW1QhM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787672679; c=relaxed/simple;
	bh=6RqBc3eBoHYgre7gRsKcukMCIHT0lrFbOEu73On1/wU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4BPIWh4Q21lSrdfAWzZrY0WzEgNVY9By4SRDDIJrEV6BPHICSo5lUB+ojBTa5elx5NCq7JdKOH0fvEMHFnGPeALDY11pXNtLOaummCVMw25n/F8v9vzJSXVM2Gu8wjNNRAdqtJX0BMNQFiHBzi/M+pbjWZSWyBLWYlQcRsgXMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Wp28TgL4; arc=none smtp.client-ip=209.85.222.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Wp28TgL4"
Received: by mail-qk1-f227.google.com with SMTP id af79cd13be357-92e6a434cabso235269985a.1
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:44:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787672676; x=1788277476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MWXQxAoWBn+GAAVj1R7fnVfxf6Lrwlo/voWQBbcHTKY=;
        b=GqJ8usRy8C037dQkXzDIUWukiLBIJiraGaxuyO9vJVMep6x97jWw11SyZxOw4OwMMA
         VzKMF/h2t42wwQZzw1V8xWhNJlevVus7Q09lTH4SUMpm5qF6CXzbGCUhdYkmYuAWBPy0
         +Q/WZOjQFUNxtdl6gI6oiXatkYlxUn1t4F0dTAnTfa8nCUrRRpIMuS1tAx+oTZ7hIKwC
         lbyhS5sGTcEc/HRqjuXoUZyyPp1Wuja8l9ZFiuXDNdTjXk78P06X/H+EUKenJtceCHFS
         IRTuaSuNHVlNkiFCLsrlju8+SFhIcI6ARAZ9AOBsgrZjReXLSrGt712bzQPWiWUTd/z5
         w97w==
X-Gm-Message-State: AFuF++mCX0+iOwf3Br8YkBRcsoI29DkcJH7Mk1l/ZWiFYyq/FYjzJjVn
	3ItBnMwv8mOzQzPYDO5Sx7sYkn6d6JvDvLpkasXZsGLyPFHXbxxCzMddDIFzI0DSuCSt2VdzrCK
	FanpHASly95Gaotj7AMXkvFjTsyqUEbp0PiOpajIJD+Z1mTlc/BDR26LLhQTS2hdoQ439Vp+T+x
	NiSpCZBSkD/6FkSYsf2yzgtq6Rm0IJiDrhhc1SkOFgIpn8WPXba0m0/MwsQGqW2jy6FzYx1iy0s
	rH8CiTK/ldtZkMIpiy4UVrk
X-Gm-Gg: AR+sD11jmswY5dtsKEhvvxPvqcAr+qTMNzB7tqYCQWDs38ioS4rbCLq3XSUCxA/UgIM
	t1SJZXhMSUxqA2Nuj48G3o73atz7RxGRYkYm2aBIAVMrx5Tjg7YCn9kzM5NSuSoinmnkbYi3oFS
	WQ+NVdggigYwaRuj+LPAyrfeOGRgeF8IVeRfoqQgB5cOpZcfU5t6cJoyY+gwzqYEYobPP8k8CR9
	bXMDBS4uGs2JvYHKixHAzky6et6ob60RHPKLMuFLyCRK17cGkYk7P8yzUvvSsUR+uf2LMKiG5Nu
	KOVR6CATlrfIdLAksU+RELRn32JzzrVLlLQHgf6qLtQd/vFt3ja3iO/R8vEYjA6JMFr/rK87xMl
	5bU9VJxBc8uiWdArsdAnNY5J3gr1mPhzCGPsHSpPOx1m2HTHBFoq0fT53BrYdgTGmIJGVVuCZAL
	TDOGf4/rYeOPuTkU29CblbgoVt0AtdAmfb1jNm2MBQa4o=
X-Received: by 2002:a05:620a:4085:b0:936:cae5:8b38 with SMTP id af79cd13be357-9376f85e7d1mr743695785a.10.1787672676220;
        Tue, 25 Aug 2026 08:44:36 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-16.dlp.protect.broadcom.com. [144.49.247.16])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-9377e2ca653sm1694985a.1.2026.08.25.08.44.35
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 08:44:36 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cee1ec30f2so65995685ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787672674; x=1788277474; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MWXQxAoWBn+GAAVj1R7fnVfxf6Lrwlo/voWQBbcHTKY=;
        b=Wp28TgL4t/I+zSt808z2R8H6xDEk4ggTQL2vj6/enSjBzFLn9QtV9WPmNxoXZM3Ts6
         JCmby1+gPCaKgaYBRUrO2apuRuW+k1UQLXm1iu/P/NudzM8XVT2sAWwdNVakwhMfCXJY
         fLnNOLFg2Vw8jmnORIUw1Z3JMnLVls4YmHJ+k=
X-Received: by 2002:a17:903:1446:b0:2cf:b68a:340 with SMTP id d9443c01a7336-2d6dcbccfafmr157740985ad.10.1787672674149;
        Tue, 25 Aug 2026 08:44:34 -0700 (PDT)
X-Received: by 2002:a17:903:1446:b0:2cf:b68a:340 with SMTP id d9443c01a7336-2d6dcbccfafmr157739815ad.10.1787672673514;
        Tue, 25 Aug 2026 08:44:33 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f9209fafsm63445311eec.23.2026.08.25.08.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:44:33 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	sumit.saxena@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH v2 06/17] mpi3mr: Fix out-of-bounds reply frame access
Date: Wed, 26 Aug 2026 02:34:00 +0530
Message-ID: <20260825210411.301535-7-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The reply frame address reported on completion is only checked against
the start and the end of the pool. An address near the top can pass the
check while leaving less than a full frame, and an unaligned one
resolves into the middle of a frame instead of the start of one.

Require a whole frame to fit and the address to be frame aligned.

Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
v2:
 - Switched to do_div() for alignment checking to avoid potential 64-bit
   division issues on 32-bit platforms.
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 31b19ed1528e..c90358a9e950 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -123,11 +123,16 @@ void mpi3mr_build_zero_len_sge(void *paddr)
 void *mpi3mr_get_reply_virt_addr(struct mpi3mr_ioc *mrioc,
 	dma_addr_t phys_addr)
 {
+	u64 offset;
+
 	if (!phys_addr)
 		return NULL;
 
+	offset = phys_addr - mrioc->reply_buf_dma;
+
 	if ((phys_addr < mrioc->reply_buf_dma) ||
-	    (phys_addr > mrioc->reply_buf_dma_max_address))
+	    (phys_addr > mrioc->reply_buf_dma_max_address - mrioc->reply_sz) ||
+	    do_div(offset, mrioc->reply_sz))
 		return NULL;
 
 	return mrioc->reply_buf + (phys_addr - mrioc->reply_buf_dma);
-- 
2.52.0

