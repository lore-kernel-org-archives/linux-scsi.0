Received: from mail-yx1-f100.google.com (mail-yx1-f100.google.com [74.125.224.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C131E376C
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 19:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765393618; cv=none; b=YCC+lBQfCFD48nYRyhWU7vEary0ZeeMUe5ILjiZw1HEpHWgcBqpvgyFulhBWfSEu63bW020XlEsYkC/b1dZ5cbNlcOEBMcQWFJY63oFGkN/dKyukHbtBZbyX2jMYe82fjn/JDj2gqlDkKZl0zsqYV+pYzhL3Yn20Xm0JGSX8jHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765393618; c=relaxed/simple;
	bh=M910zPYCc8Xj/Y4kIrtPF4owFsRLDo2SrbCALfoImwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X9PUNdyIg4oTVpwmGFh2slQbVyCTHMqDKIcEkHAvC8tBJXS+or8SEIY/LyUClmDkVWQgCFfUED+mrQusjpEqCFXceKvEWrHwN11x8uQ3LHe/mNxZn8NEHMvsmIQmaM+QIcaixpE1MU6y/oaOtpU1h4CxMwDnYVVGn3qRa4E4RcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=dOVR9coe; arc=none smtp.client-ip=74.125.224.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="dOVR9coe"
Received: by mail-yx1-f100.google.com with SMTP id 956f58d0204a3-6446c1a7a1cso128459d50.3
        for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 11:06:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765393616; x=1765998416;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kF0ZTPTh6C8GEz16r9dHrE7VVMeg5FEEbJe17ZjuCwQ=;
        b=fDryqXcY8RKeqgCVSFNIOIZMnOP/V9KgkNNw0OoFgZk+iC7s5DKvbGIczAdNaGgB94
         NT8nueO2QOsgQskI2YNaUVobIGPfu4a4OJDbnf/8MjHoYF8TxBmzgsk1qIiVGb/xeNKa
         ajdy+LSXkrDVGJyT3aj+ai9itq6sG4/LI+zFx/Gy6K7uxheURSzcUbaXAnFUMNrvPGuA
         AdxT2bu2U9xPFEn5VoG0H/TepS0bD0YBB0oKK1LF5MTowus6SJRRy3vHFHC7W6z+hCfU
         a1bxDDJvnv78ROq4qexdCshU9YMEcDZS3KqFxY8FSeMbKELfRYqp447VNf8oFBXyi+RI
         cHUw==
X-Gm-Message-State: AOJu0YyLYIrXGMFW6ftsO8OYSNgdDlBgq21/B/X8e8kXbmscj/ErVLaB
	o7sWJbOyur+JyoX2g6Lxn13d1odgyAzHgrBsc77PHm1Qf+7srv4wRVx9rJ/dnEvMPXKVE0lvbtp
	h+v0BDM4YqAaJVN9awnyt9/Pm6e9mEVsqu6CyEeA+1CQOWAcDFnYHIiH2AoLF70rH6A61S9NHYL
	2A9hzED2pKeGhere/BdQg2ETt/eaRQm/17m3HfjhlRMQN56hXBpGYWwuKoCoazV3DydSxuAuJnN
	z7NlIERfI+6buOCRA7bE6G4
X-Gm-Gg: AY/fxX6k+qdwisuNDpG179T/E7MCEdf5rvgb8gnoGTMT8+Rv6dCtfATNmdNG2+RD3Ia
	SVS7XghTXqS+QpGIcddPEuKz+/por6xjK6ksUmTY6VwkN3ux/FaTLDa953oZ5TubdJKMfvqxwWY
	Po5cWS9DS2xcx6DqOBWTWeDiB0p3Qo8bNav7FbMN3vntG2FnsTdSvW4YWzgjHukywbCvxzA+J9o
	P3BqMtHf/UZp4hfhvpvH/wjUZerZJ6vJCYOLJ+S7pzI8ddnILs7SHM8X4u5ctWgB+4leuFPei6O
	VhFLLmIpv7BWfbyBCn4UPy1b6/iAxOkr7F1T94OmDviiu7adhDTrYR7C2dk8bRu2dYbCYgYmXT0
	sN4Asf71Jbn7FvIWEPIKVBRBXWlqu2aM4nX0u+3x8eC8jh11Ug2Oe4rgSFMtV+YXoik7Fqt2joB
	Ebqp0//wK/q6S9c7qOTomdymnHIthOZPmfRahVoBhdB5Z+TLegQvZu
X-Google-Smtp-Source: AGHT+IFKT7zFaTuekI1HlDPlKQgNtPI7LO2LWFuv+tBynHNVQ2HGJr0bHTpfuhCZrgrgLOo+hVFXPORe1PA/
X-Received: by 2002:a05:690c:c1a:b0:78c:57c1:70d9 with SMTP id 00721157ae682-78c9d7e9e18mr26303967b3.37.1765393615720;
        Wed, 10 Dec 2025 11:06:55 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-11.dlp.protect.broadcom.com. [144.49.247.11])
        by smtp-relay.gmail.com with ESMTPS id 00721157ae682-78d69e63047sm367337b3.31.2025.12.10.11.06.55
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Dec 2025 11:06:55 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-7c240728e2aso199701b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 11:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1765393614; x=1765998414; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kF0ZTPTh6C8GEz16r9dHrE7VVMeg5FEEbJe17ZjuCwQ=;
        b=dOVR9coewYVjoADpQ1WVWYWMhssvEgX2TvDZbSyoJqJPOzDxrZVyAE3g7EGQ+N282b
         KVpCbzrv73MsLwjcmRVi22Phisk/MRs/bDx0YTCvO/ULEbpbvwylmNSrzAakZTCqo9Fb
         IRjzfr7SPg+80JXYD99ng8vnB2/nFlwAtfyfg=
X-Received: by 2002:a05:6a20:94c7:b0:34a:f63:59dd with SMTP id adf61e73a8af0-366e2b8df78mr3542731637.51.1765393614060;
        Wed, 10 Dec 2025 11:06:54 -0800 (PST)
X-Received: by 2002:a05:6a20:94c7:b0:34a:f63:59dd with SMTP id adf61e73a8af0-366e2b8df78mr3542697637.51.1765393613541;
        Wed, 10 Dec 2025 11:06:53 -0800 (PST)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c22842dasm277337b3a.12.2025.12.10.11.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 11:06:53 -0800 (PST)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	stable@vger.kernel.org
Subject: [PATCH] mpi3mr: Read missing IOCFacts flag for reply queue full overflow
Date: Thu, 11 Dec 2025 05:59:29 +0530
Message-ID: <20251211002929.22071-1-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The driver was not reading the MAX_REQ_PER_REPLY_QUEUE_LIMIT
IOCFacts flag, so the reply-queue-full handling was never enabled
even on firmware that supports it. Reading this flag enables the
feature and prevents reply queue overflow

Fixes: f08b24d82749 ("scsi: mpi3mr: Avoid reply queue full condition")
Cc: stable@vger.kernel.org
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h | 1 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c     | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
index b42933fcd423..6561f98c3cb2 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
@@ -166,6 +166,7 @@ struct mpi3_ioc_facts_data {
 #define MPI3_IOCFACTS_FLAGS_SIGNED_NVDATA_REQUIRED            (0x00010000)
 #define MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_MASK            (0x0000ff00)
 #define MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_SHIFT           (8)
+#define MPI3_IOCFACTS_FLAGS_MAX_REQ_PER_REPLY_QUEUE_LIMIT     (0x00000040)
 #define MPI3_IOCFACTS_FLAGS_INITIAL_PORT_ENABLE_MASK          (0x00000030)
 #define MPI3_IOCFACTS_FLAGS_INITIAL_PORT_ENABLE_SHIFT		(4)
 #define MPI3_IOCFACTS_FLAGS_INITIAL_PORT_ENABLE_NOT_STARTED   (0x00000000)
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 8fe6e0bf342e..8c4bb7169a87 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3158,6 +3158,8 @@ static void mpi3mr_process_factsdata(struct mpi3mr_ioc *mrioc,
 	mrioc->facts.dma_mask = (facts_flags &
 	    MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_MASK) >>
 	    MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_SHIFT;
+	mrioc->facts.max_req_limit = (facts_flags &
+			MPI3_IOCFACTS_FLAGS_MAX_REQ_PER_REPLY_QUEUE_LIMIT);
 	mrioc->facts.protocol_flags = facts_data->protocol_flags;
 	mrioc->facts.mpi_version = le32_to_cpu(facts_data->mpi_version.word);
 	mrioc->facts.max_reqs = le16_to_cpu(facts_data->max_outstanding_requests);
-- 
2.47.1

