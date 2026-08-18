Received: from mail-pj1-f97.google.com (mail-pj1-f97.google.com [209.85.216.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0392747AF65
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 17:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787075844; cv=none; b=PS0MvFbvbXwR9vMPNI4nlrLDDvI9Ss0yrttLCPUusDU9wE0jVrB0QNWyUGDNveiyIWonevkfyOtVIFEMUQSEigbseqYbgtwsk+ZbMhL7dUrM3JApZPC/mK88bqQd7qiICo7GV8/v8I3barfzjcr5lktBq9h3yFGQ5gO8ec9SI2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787075844; c=relaxed/simple;
	bh=Fmo7yPsigqajPKR8yphLtuGp0a42yV+NGwdysAD5q0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xfx5e/f1WcH/9XiduIZ5KeLt41aIAKWnAeV6PbmOv4S4BK3dRGiBzGRW91Chv38Yi3EoSPywXSP1h450yuR0P/+AW/LkxjSxZrwvTBkdsevP34pBgLXwLB0rB8U+K8366pFD3FVDcaMqJfbBEoFbJ/yxQt0ElTXBGqBgOnwlQoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=BAL55Aht; arc=none smtp.client-ip=209.85.216.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BAL55Aht"
Received: by mail-pj1-f97.google.com with SMTP id 98e67ed59e1d1-38e88b60121so196370a91.3
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:57:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787075842; x=1787680642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0u2taD75VqdCd70afoG/cqRKa0GB+IR20/XdQeyP4DA=;
        b=b25M52mgwIJFw2dfPa10yZBFZbE3PV3ItCYkzbVMqI5Kh/vZZgEHQV2hMbTaslmsQG
         rA+EEsK1iAjDrPED+I9vIOhcMtcYd26zw7deyw6ogERmPHCw4b2UrVZSA53utgyjFbFP
         kNiVG+bhz9Ow7c4nIGkPM79T9sL5xbh0mVHJ6XZTLjJDNzP5zcDokoC2jw5LGs3nwHkA
         o2S1P5EE2OwWTAcrN/Xo/s8ZE9uWtuTBnFXJ982n9AGv+tRt6T3GG/Whtbt9Grgn3ShW
         CiGDWSE0YLKvQlty75zEiMkdOJgAyjNBAypQOsi4nSb2lRAcLjDGz5K+iM4ZojC7cd64
         242Q==
X-Gm-Message-State: AOJu0YwdWbA2kpLk7Z0ZCVRWNbpGDOZr44Egv213g6UifLE7wvuURPIY
	abHKdrH3jZsxBdU3oaoYON8y1IAjl7YuFenvWRxWDlWfrrljNezC/9yS8r7L0IklvpN2cO3laoM
	yyqU4doNWBlzlP9werQWvSvFrSZRqMrmw3ygso/TICqpGOoN7PNKzNK+pW7mOi4IZ0GgdPGOkq6
	mVd+Ud2sfrH/H2uOrn301iqlqvM7UtDuw8gaIpKE4nvVSxFqx/mPS3DjW4E8GyZ/C+yvufvY7uO
	v4/xt3z7eTp2bRDaFwVvirI
X-Gm-Gg: AR+sD13Ctb+AmK5AmE7z/Oex6yT+yteGomDYYVwqM2YsH39ByuUL8XNFno3pxFiCjWv
	WZf6OxeXNZpto52fy9zNN1k6Sia8FJew33d+RTnoiNHI9BtmOYkz1rfEJhvcmSFx2RhuJon/ch9
	8kq5R47sVn4NwJriiL8AzCfwDkA79guk0yLF9lWzlRtJeK4+dG9v20O5OMxqpEN1/c9qKMqIhYV
	acJuqrx+yG36vwm5HWcz2md6s2imhg/KKM7TaLkf7w5R536u6JvIDNVDQfN8SMYnuSgK3lf4SaH
	L85pp6SiPwNq+8jWp8EtPPbnkkRp6cZwTTecrOPAIoEs2UUum/UQZ4EUkm/Nj+U6+mQAR39Amxx
	cccwf6qbU6akBATru9dpiMjIyD21mhkvmwBxLIB4Rqa1i0v7famaF6lB+upK9LmLB+8O7bgkQY0
	2IKAUinuaVj/CuvK0cZr3LElNKlruJiA4fN5rYhqAzVs8=
X-Received: by 2002:a17:90b:39b0:b0:38e:659b:f366 with SMTP id 98e67ed59e1d1-3933b500d17mr36430300a91.0.1787075841989;
        Tue, 18 Aug 2026 10:57:21 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-16.dlp.protect.broadcom.com. [144.49.247.16])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3954d28db6esm2750023a91.2.2026.08.18.10.57.21
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2026 10:57:21 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38ecc48b3c2so297827a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787075840; x=1787680640; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0u2taD75VqdCd70afoG/cqRKa0GB+IR20/XdQeyP4DA=;
        b=BAL55Aht74sTDJJkAXsxGZMlTVGHpUZGQUQl2JSDaQn1mMl/wJDCqsRNVfLNrXEOPY
         sf6b3edlAhD9jCJmDm+uoH1Uha9fQ8mDcxImQUhSkzbcMXZWsxIoCtOtMeUd8NePOhK9
         gzY2VQcnQ11LrzCVa/rGaIk5cvSXmeG6QqW6Y=
X-Received: by 2002:a17:90a:6c96:b0:395:4de4:92c8 with SMTP id 98e67ed59e1d1-3954de49a7bmr11660543a91.15.1787075839675;
        Tue, 18 Aug 2026 10:57:19 -0700 (PDT)
X-Received: by 2002:a17:90a:6c96:b0:395:4de4:92c8 with SMTP id 98e67ed59e1d1-3954de49a7bmr11660482a91.15.1787075839057;
        Tue, 18 Aug 2026 10:57:19 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14153187de4sm16741958c88.15.2026.08.18.10.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 10:57:18 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	ranjan.kumar@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 06/17] mpi3mr: Fix out-of-bounds reply frame access
Date: Wed, 19 Aug 2026 04:44:15 +0530
Message-ID: <20260818231426.58105-7-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
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
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 681868716ebd..5e61448d8dbc 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -128,7 +128,8 @@ void *mpi3mr_get_reply_virt_addr(struct mpi3mr_ioc *mrioc,
 		return NULL;
 
 	if ((phys_addr < mrioc->reply_buf_dma) ||
-	    (phys_addr > mrioc->reply_buf_dma_max_address))
+	    (phys_addr > mrioc->reply_buf_dma_max_address - mrioc->reply_sz) ||
+	    ((phys_addr - mrioc->reply_buf_dma) % mrioc->reply_sz))
 		return NULL;
 
 	return mrioc->reply_buf + (phys_addr - mrioc->reply_buf_dma);
