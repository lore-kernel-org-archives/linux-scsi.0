Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B9226C3A2
	for <linux-scsi@vger.kernel.org>; Thu,  2 Apr 2026 07:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775114236; cv=none; b=pIIeT7bu6y/Ncm0+zDSlqsWV3TxN9dVie4g4fx7KMzG0E5xf0slRRDL4KfTYA86EJza28HaboEZxDxXlMkPKDMTnaKY9LVxMnFMYSRNPXWCmD8TOzST41j4WRruRg+ALFrHEjiUWdjCgbsDMMSMIDkq6CkgMtz67U4CaqlDyKPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775114236; c=relaxed/simple;
	bh=SlVs8jIJZ4AW7Wxo9yxSZjpREVYQTXUK4KKxeJVHWVo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c7KZHHszzb9FXIFXtT6MVlAX+M0X7ftSNIYRf6JaIfbGPJJRvTvUg/oUauwNoIH4vk21lxOtXlxMKuzNZrhH2JJMA11H+5RtE9vlFVczZ7t8rXG3Io6BEfSC4iU/7XHVSAmYIHlSipqQ02AF4/AW+7aunfuzrBF4a5KEsvl6iFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Tx5JVxYi; arc=none smtp.client-ip=209.85.216.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Tx5JVxYi"
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-3567e2b4159so348854a91.0
        for <linux-scsi@vger.kernel.org>; Thu, 02 Apr 2026 00:17:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775114234; x=1775719034;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X1nvpVvk17JfQ+DD3OmsLO1BM+aJTjprL5lAoSdl9sw=;
        b=MOp3Vd3PC2ZVjWlwCzJbUEvXdSlK88+PfQqZjj6wxKbCilAg6M9DLFUjA5jCnO6esW
         dOxeRWtKrCLuyFBBVU/LRQ6/uJspUOGNtL8pXQiOCZN4AS/R4JCfKzTqWpNv5Hz8WLnH
         KhyflHk8SFOBktv9rO6VOpVHoa0aG8K9jstdlOP1AS7SeC4OEnzZuw+qUosBJTdhrxOH
         JSMFdykOBYUnD7AhHXDlDGGv0xfkn9zRQ8bZa2mRooOmjzFRMosWP1pHt5RSuCBIfC64
         2PSfmybPAP+KF0nNi6uIhYecuLMJab3rRGN5xi1vQo6juNUNhO3eOcn3PmZQ7eiPilPP
         fMig==
X-Gm-Message-State: AOJu0YzoN+kzc9zlPNLiBRNI3rrL2G0JfziCZXH1Pt/D25pqBZlTBQd6
	qXGqNFGihpAZvTy8lv6QOomiqwDPP1KnnLxyuYw66MUmyJ7WTEgTQ25u/zdXsgpjZIWkie1IdVD
	yS7UZVuaEJATBTXGTs6PjzyNqHij4o4pbaumc4cbSkaIOn75T5ucsr3XaXNSiyCKYyhnQARvNwC
	xz4FjbKv/2pKjamqWGI0Y3t3g4fxHzcQuc6cCMHS7kniLdvHyQebqC+m9bboEBayKU842HY0V2B
	UW7XbDZhE4Fzt9U1n8=
X-Gm-Gg: AeBDievWIbz1oe9zqRgwZXubBJf7CzdanbFoMcojZ7d8tYNiKfdFV/Mr11UwPvDoScM
	EpPsDpk37NQ1pAex8NdXFLTsAp9xIEqlXoRRoOkbycsgGzz0vxKrGkRSMLRq5a9onClb15WrDN7
	Fw4FLuH8g18jpOv/vOZsnab/jCQZ2x5SCoXSi/MX8UIsjcKKEzPuTqYwxo3mnZguzzb1u5S/3yV
	fQAzbjIEfh4SgOigxWXeYilDIx2275bULI7u6xDIDSPI0y7ewP1CpI899lOexRR+9/y3oOAsSR7
	gZr732yxYfNPDC1lEyfuy5dh59ROYTVL1zOljV3wThYwBCFAhHpg1/ntRo0kVZU9V61fE/QyVKE
	AKxYSzbARWhD+sNGBQrd0Zbj8JYV5cn/rUjZrOWJtoN1KAyqp0y6pVFr7txpmOYhcXfzsavHxEp
	/nRCilgoirGQZBA5/oFohivaA4AyGPCJhJl621sQG8fSg6kmqR8qT6F8dvcbk=
X-Received: by 2002:a17:90b:1d02:b0:35b:9896:cbcd with SMTP id 98e67ed59e1d1-35dc6f66f0amr5758872a91.27.1775114234322;
        Thu, 02 Apr 2026 00:17:14 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-118.dlp.protect.broadcom.com. [144.49.247.118])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-35dd36a3524sm169344a91.5.2026.04.02.00.17.13
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Apr 2026 00:17:14 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2b0be75dfd4so6356135ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 02 Apr 2026 00:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1775114232; x=1775719032; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X1nvpVvk17JfQ+DD3OmsLO1BM+aJTjprL5lAoSdl9sw=;
        b=Tx5JVxYixENut1zM61o1baMJ4WDWPqMSUKRqmZAtw03xbVMNSlH1ZlBNlKAg7OSAx9
         Oux+let+Ubiw2unSTisLOgun40T9lYF5wlI9fBkU7lx5wlXXrLFqrjI6NIfA9rdg2iQP
         jPJkVMvWaLcSFxh/5lfqauuDXhEpXGq5kOw3s=
X-Received: by 2002:a17:903:384f:b0:2b2:57ee:c04e with SMTP id d9443c01a7336-2b269add3fcmr67138325ad.18.1775114232144;
        Thu, 02 Apr 2026 00:17:12 -0700 (PDT)
X-Received: by 2002:a17:903:384f:b0:2b2:57ee:c04e with SMTP id d9443c01a7336-2b269add3fcmr67138025ad.18.1775114231667;
        Thu, 02 Apr 2026 00:17:11 -0700 (PDT)
Received: from sumit_ws.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27477c54bsm24612825ad.27.2026.04.02.00.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 00:17:10 -0700 (PDT)
From: Sumit Saxena <sumit.saxena@broadcom.com>
To: martin.petersen@oracle.com,
	axboe@kernel.dk
Cc: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH 0/3] scsi/block: NUMA-local allocations and false-sharing fixes
Date: Thu,  2 Apr 2026 13:16:34 +0530
Message-ID: <20260402074637.92417-1-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

This series contains three performance improvements targeting the SCSI
and block layers on multi-socket NUMA systems.

On multi-socket NUMA systems we observed extreme I/O throughput variance
of 50-60% between runs.  This series identifies and fixes two root causes:
cross-node memory accesses due to NUMA-unaware allocations in the scan
path, and false sharing between hot atomic counters in
struct request_queue and struct scsi_device.

The first patch makes the SCSI scan path allocate scsi_device and
scsi_target on the NUMA node of the host adapter.

The second patch addresses false sharing in struct request_queue.
This patch touches include/linux/blkdev.h, so needs review from
linux-block, an Acked-by from the block maintainer is requested before
merging via the SCSI tree.

The third patch addresses a false-sharing problem in struct
scsi_device.

Performance notes:

Tested on a dual-socket NUMA system with an mpi3mr HBA, running fio
(random read, 4K, QD 64, 16 jobs, 60s, direct I/O). 
IOPS figures are in KIOPS (thousands of IOPS):

  Configuration                    Avg KIOPS   Range (KIOPS)   Spread
  Baseline                         6,255       4,200 - 6,700   ~37%
  Baseline + patches 2-3 (align)   6,653       6,000 - 7,000   ~15%
  Baseline + all patches (1-3)     6,649       6,400 - 7,000    ~9%

Key findings:
  - Cacheline alignment patches (2-3) raise average IOPS by ~6% and
    cut throughput spread from ~37% to ~15%.
  - Adding the NUMA allocation patch (1) further tightens the spread
    to ~9% with negligible impact on average throughput.
  - The combined effect reduces the observed 50-60% run-to-run variance
    to under 10%, significantly improving workload predictability.

No functional regressions observed.

This patch series is based on Martin's for-next tree.

James Rizzo (3):
  scsi: use NUMA-local allocation for sdev and starget
  block: align nr_active_requests_shared_tags to avoid cache line
    contention
  scsi: align scsi_device iodone_cnt to avoid cache line contention

 drivers/scsi/scsi_scan.c   | 9 ++++++---
 include/linux/blkdev.h     | 4 +++-
 include/scsi/scsi_device.h | 4 +++-
 3 files changed, 12 insertions(+), 5 deletions(-)

-- 
2.43.7
