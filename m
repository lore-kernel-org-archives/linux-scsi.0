Received: from mail-dy1-f227.google.com (mail-dy1-f227.google.com [74.125.82.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492E339DBE2
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 11:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776683376; cv=none; b=Wa/b9H2I2ZH1kyliIPE84lLFMrWvq/E9X89FfHwUDUJz9zrh/hGnZapTIAmmcGxBA4VHoBLuFlu4wAlcuvu65nq1FlZ4/xaoAyu4ssp5X04U6YzU4YNCBZsWGEnCI52Kh8q8w2ESq1SltRGfQBRrqxJIom+WamWTnLPdGEPHwyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776683376; c=relaxed/simple;
	bh=BqiatpiZK82yHpofKxSogwomIgLQIYYScdESQkvH10E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oKWwlHc7T+pqi1BHWS/ZHfKt/B+tjbt7JrCQkO+QJGmN3Ml4aq/+/bAzy7/JZLpIc092GAQ/MMW1in/R0zbrJ4mn2256q3B43Y3SP7eT03iGDmUlvMzs8vIuiwH2tpmd4cQlALjuAiDKzx7MMnDqQmfikrvcNZLi33SIZ6I8xuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=BT99HENN; arc=none smtp.client-ip=74.125.82.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BT99HENN"
Received: by mail-dy1-f227.google.com with SMTP id 5a478bee46e88-2d832f2f44cso2914526eec.0
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 04:09:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776683367; x=1777288167;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nqaMgTOsYO0gFcKZhql6upDj4RcuT3QIXW9T6oujAMo=;
        b=mPYR18HApkCa6Wa5xeGfWYWXWFJ4XiFEgu+DUSBdTQrcGJTJ9ya2GKJt2kT2F4K2Ws
         HSueDF5TmcLkVOjjKqayApD46XaKQGdhl+V59fQC+s+VFxkpREtaH066SIbwrW0p+9oH
         +Mxb542g0BTXpxbRRjo2BdE9DAh6Aae2/sNtwAJTSKER+xdy+/Pnt5wWjfA/zPLoFPrw
         7bu/WM+EJQdvBYGrE/F4dll3DjP1hMUiXknxOza9xiKrsFvSDjcUds1FMJZi0fo3gF3F
         mgilKss6WHOKcXhrl6kP2rCo2DYhB02Wtke5wcaAmM3PhnqNhRNVq9DAUcCWNagnW68A
         Dlog==
X-Gm-Message-State: AOJu0YzhNvWgZlgrvNRwgPS3/uof8FyI9wSikaTVpbJc3aSEEJxyPWlM
	q03Yqmt8OpQUdN3GUpcVudvmSJ5po9JUpGXXQYMMOPHQMpHB5mLZ90XqNRUy5eg7NBXN8Bquhuj
	CoehHMAjvKrn0vvzQ3E/jeEA/LS/iEv8XyKd0GITU+Z96qvjbukEtRKJTCjK71AJtNlPIWpf/Bc
	0xeKjPhSfYRKItiCZY7B+k3zZ1985MMPMHkS1Vm5G5pJikv9EQh76jFKwnXkBivT17wq5spbIzG
	kDcpqmZAhYietKT
X-Gm-Gg: AeBDieur7Td/L9VmqWJthzZlJIdnloRLJwbmcZnug9njfsHjjO97fttcMlxDeTNAYk4
	y8iF1E4ENVvPrNubIDKvmEJ9bLoPFjjlaUEwu1ZupzLULrefX9IL8ffzMImhKnrWeOAXxDUe3ad
	DlV2CVrkZkNNwFnYiQS6xeWjcEeKX+dfdXIGOERcZo8LXYVnqJ5FkEuxFwDI35YqGYhC2GpQkDx
	RkrGESVp25OhZUfIepa0uzzZ8LyWTGdjG/JutUVvw4a1I4An5uqs/RXvwcp+tMEVdUGPYT4w+DX
	JNyy/BsJprvwF7v19mY/4lk0chdYLWdJdXNTmfk66gjhmbJ7/7FfjCv34EQUqeENkiDklG747mq
	JQb6497/Xkgy1m1NdIXLg28q2MjOu0QOtrLStIPpEfyFXzNr1LulGpimKky6YpPg0LwafQIXVpJ
	dvW3mQtSgyyjVJ8cZewyNgqOqC9UgksUJ8AwV5xbpe34gNmv5ZB0RCRn3ZIcc8o8Z152I=
X-Received: by 2002:a05:7300:5728:b0:2cf:28e8:d784 with SMTP id 5a478bee46e88-2e478a3314cmr6385268eec.19.1776683366952;
        Mon, 20 Apr 2026 04:09:26 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-24.dlp.protect.broadcom.com. [144.49.247.24])
        by smtp-relay.gmail.com with ESMTPS id 5a478bee46e88-2e53ccce7c9sm659482eec.29.2026.04.20.04.09.26
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Apr 2026 04:09:26 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2b242062308so50521115ad.2
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 04:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1776683364; x=1777288164; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nqaMgTOsYO0gFcKZhql6upDj4RcuT3QIXW9T6oujAMo=;
        b=BT99HENNdkFPbqIX+H9FN3Yq2y/j9D0lnFMcRO9dWco5nCNgWgKqxOgE9PNfedzQF0
         qfHUdJjgIphk21frDtTblu7/VQSFhq4mbm5jK0JxbJWbhzx9Wn8LTQOcCRCkDfNX1Sea
         gFB4i0fr+ty7KYsJLV1VSJjdjEvkATsGIjxGo=
X-Received: by 2002:a17:903:1d2:b0:2b2:41a9:8e10 with SMTP id d9443c01a7336-2b5f9f4e110mr143585555ad.23.1776683364389;
        Mon, 20 Apr 2026 04:09:24 -0700 (PDT)
X-Received: by 2002:a17:903:1d2:b0:2b2:41a9:8e10 with SMTP id d9443c01a7336-2b5f9f4e110mr143585245ad.23.1776683363864;
        Mon, 20 Apr 2026 04:09:23 -0700 (PDT)
Received: from sumit_ws.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5faa1739fsm103115415ad.22.2026.04.20.04.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 04:09:23 -0700 (PDT)
From: Sumit Saxena <sumit.saxena@broadcom.com>
To: martin.petersen@oracle.com,
	axboe@kernel.dk
Cc: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH v2 0/3] scsi/block: NUMA-local scan allocations, shared-tag path cleanup, and SCSI I/O counters
Date: Mon, 20 Apr 2026 17:08:36 +0530
Message-ID: <20260420113846.1401374-1-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

This series contains three performance improvements targeting the SCSI
and block layers on multi-socket NUMA and heavily loaded SMP systems.

On multi-socket NUMA systems we observed extreme I/O throughput variance
of 50-60% between runs.  This series identifies and fixes two root causes:
cross-node memory accesses due to NUMA-unaware allocations in the scan
path, and false sharing between hot atomic counters in struct request_queue
and struct scsi_device.

Performance notes:

Tested on a dual-socket NUMA system (2x 32-core, 256 GB/socket) with
an mpi3mr HBA, running fio (random read, 4K, QD 64, 16 jobs, 60 s,
direct I/O).  IOPS figures are in KIOPS (thousands of IOPS):

  Configuration                    Avg KIOPS   Range (KIOPS)   Spread
  Baseline                         6,255       4,200 - 6,700   ~37%
  Baseline + all patches           7,350       7,000 - 7,700    ~10%

Key findings:

These patches combinedly reduces the observed 50-60% run-to-run variance
to under 10%, significantly improving workload predictability and
improves IOPs by 16-18%.

No functional regressions observed.

This patch series is based on Martin's for-next tree.

Changes in v2
--------------

  Patch 1 — Same functional goal as v1 patch 1: NUMA-local scsi_device /
  scsi_target allocations in the scan path so steady-state I/O does not
  habitually touch remote memory when the host has a fixed DMA/NUMA
  affinity.

  Patch 2 — Replaces v1’s ____cacheline_aligned_in_smp on
  nr_active_requests_shared_tags with shared tags removal work done by
  Bart Van Assche [1], rebased for the current tree; it removes the
  atomic counter- nr_active_request_shared_tags that motivated the v1
  false-sharing workaround and, in our testing, improves IOPS on the order
  of roughly 16–18% for the shared-tag workload exercised.
  This patch touches include/linux/blkdev.h, so needs review from
  linux-block@vger.kernel.org; an Acked-by from the block maintainer is
  requested before merging via the SCSI tree.

  Patch 3 — Replaces v1’s cache-line padding of iodone_cnt with
  percpu_counter for both iorequest_cnt and iodone_cnt, so submission and
  completion paths mostly update CPU-local state instead of bouncing a
  single cache line, without inflating struct scsi_device for SMP
  alignment.

[1]: https://lore.kernel.org/linux-block/20240529213921.3166462-1-bvanassche@acm.org/

James Rizzo (1):
  scsi: scan: allocate sdev and starget on the NUMA node of the host adapter

Bart Van Assche (1):
  block: drop shared-tag fairness throttling

Sumit Saxena (1):
  scsi: use percpu counters for iorequest_cnt and iodone_cnt

 12 files changed, 68 insertions(+), 145 deletions(-)

---
2.43.7
