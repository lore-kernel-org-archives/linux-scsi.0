Received: from mail-ua1-f100.google.com (mail-ua1-f100.google.com [209.85.222.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465054CA267
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2026 18:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783536037; cv=none; b=esh+fr5IeJUi4TrfTle1qEzKf/+uW4P1iAOG2rjw1uDxRPq6ChLA4iPo8r1F/W4YnFRZcKS7g+Ptx9Zy9ZECzbD34wp0GcQRSs25tBuS/iuLftLG2Jtf4x8emsgf9qR/dvhO2lBu3alvNfAlyuW+GgtoNqqmJ21D12P+GegmHMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783536037; c=relaxed/simple;
	bh=iQK6YWH1QlcyiDFs/CKHBOsYQhBXjb7Oe/nKCYrcK0s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b0Ht1kEpgTNjUWx3nVRLPu1WAznCo7hc+TK4dQ4+V9mLYfUxqV5zIUKdh79IGvafJZUFYzGY910XisEHHb53TdPBeB/uBnwFqcNmPDAuYy1q+TmFfLJlQvuh0G2cOhcubU5NDlT2jU/3KsYJBA5uqSx20nl94M4No4tELLqhoHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=CMYZUgfE; arc=none smtp.client-ip=209.85.222.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="CMYZUgfE"
Received: by mail-ua1-f100.google.com with SMTP id a1e0cc1a2514c-9666739d3bcso368013241.0
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2026 11:40:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783536024; x=1784140824;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Tp94kv6ojOYNImSEYf4qUNC2Ktn+w2jRAhNPGU5/AiE=;
        b=KTM8+MXxDJ7MLHO1y+m6QQJqkRNc5+kbkXm2nYtLoKNL9ZYp2xxhQD84brbQOMe2bH
         fu7vLkRXyGljS5xZQEmHKexC0HopV5FEplchY/MmGLubulMOQ7eJketnd9ECQdKVJ1Nb
         aouskY8TIiDcjoYoEtYkLOIG6adpmUiVoNok9kFh+k5E7v2w+s3I+7Zb5uExwGyPAEh1
         oSafH8FzhyhNBquspMf/6nXr4ondh/R4mh0//nLmi7FsK+aAIB8mMKzdAJqG0epO+tY8
         4g91m9yj7yp+Y9F8eWFc6GKMYgvbF8T6ka0bZlH8tyQwXHfiSIknwGrFEfx4iVC0THli
         nfUw==
X-Gm-Message-State: AOJu0YwjfQVj5Y6AvT5TAHzcQzBZqe7tn9y4hrAN5YhVWuQGj28bMOOC
	FJuD+2HmPUYv/Ub7nTfzl2MpsyOkG21krW0xiWs1x1opQewPqNf+UJyzZgTAQWbe07zQOMFeMnc
	Fq9CnOI1X9qiiMSdJFcHLaA96pxG0sSz2WIXtVXBsQp9Xn1mIfD4zcjvHFmZwjSKsy/+czg7gqq
	47Fzr9cqpxPKTmmSesO3eGov+dJHil7YE/54VcgLrO34bTVd2YZzBiKPpCXynFo5/H5jSpam9g+
	3qI3UF8T0iF9ykC
X-Gm-Gg: AfdE7cn0PICA55ygJDcCuNQbyd7B/qDUWtDV6LIs8Wu17xbmWiAvPKmlvz1Q1GLLgok
	/eCWvU3zB1MO2u/t4+3sp0Bv+W2GNkGQ2k/IBAAJeXwzoaylYZv+BjYpchmqsbq5wC8YCN05yvb
	d4V6CkyI4ivi4r604kaWO2NuHNn96soMUHtfe2lgeUINgoHCoezKkwtazFQkfMcOlR3gXkSc2Ze
	7yVRS3fBpbjU5rQUvHMEy40FJT8Au1xpkZAiLLSS60OVsKEKpsjqgkqxvp/gw6DQHixhz9LzvaS
	Bw99CYKvtvOwQyDgN6c395aVQ0ysMobvWaC9YCbyq7ype1UVIufZEXTr1YZvLfhBks+dlO0HV8A
	8p1Et8Ovd9FlTajoCp4tzBdys/EStwyOI+wBMGaR4gNZ4V5t8o8kZ8yFtmyrmPmF9uvFaJSMuwg
	Z2xp6m0HnnDos9K919s7MAM7UtvN17bVMssTciZCNbbIqIhA==
X-Received: by 2002:a05:6102:370a:b0:650:94b2:3839 with SMTP id ada2fe7eead31-744dff2c879mr2102890137.7.1783536023889;
        Wed, 08 Jul 2026 11:40:23 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-11.dlp.protect.broadcom.com. [144.49.247.11])
        by smtp-relay.gmail.com with ESMTPS id ada2fe7eead31-744d6e13d7csm263433137.14.2026.07.08.11.40.23
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jul 2026 11:40:23 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3810e5c5871so1886520a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2026 11:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1783536023; x=1784140823; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Tp94kv6ojOYNImSEYf4qUNC2Ktn+w2jRAhNPGU5/AiE=;
        b=CMYZUgfE1/y5eK8ynKV9n9dL4JN7069qWr+Rgs4lG+6UnwgkvZCjyF4Y7USyDidi0o
         0Vtr6T6nx4WV6xPoITcLHdpLYNxn29ArWqQXOEIYR20ouvqVgRXwAzG/WARtvvtNxEQ5
         p7EzHsbB7mAkPQNlpCENB5ubrShVqS3lnPG+A=
X-Received: by 2002:a17:90b:28c3:b0:37f:db06:2299 with SMTP id 98e67ed59e1d1-38942f70dfbmr3728893a91.21.1783536022595;
        Wed, 08 Jul 2026 11:40:22 -0700 (PDT)
X-Received: by 2002:a17:90b:28c3:b0:37f:db06:2299 with SMTP id 98e67ed59e1d1-38942f70dfbmr3728861a91.21.1783536021831;
        Wed, 08 Jul 2026 11:40:21 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3117d847e17sm19820599eec.18.2026.07.08.11.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 11:40:21 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v2 00/10] mpi3mr: Few Enhancements and minor fixes
Date: Thu,  9 Jul 2026 00:02:55 +0530
Message-ID: <20260708183305.244485-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Few Enhancements and minor fixes of mpi3mr driver.

Changes since v1:
- Fixed test robot build warning.
- Patch 1: Added le32_to_cpu() conversion for driver_pg1.flags to prevent
  incorrect logic on big-endian architectures.
- Patch 4: Added bounds checking for firmware-provided NVMe page size to
  prevent undefined shift behavior and potential divide-by-zero panics.
- Patch 5: Added missing dma_rmb() memory barriers in reply queue 
  processing loops to prevent weakly ordered architectures from 
  processing stale data.
- Patch 6: Hardened operational queue error handling to prevent 
  NULL pointer dereferences and deferred kernel panics 
  during driver cleanup.
- Patch 7: Fixed a TOCTOU Use-After-Free race condition and reference leak
  during firmware event cleanup by safely acquiring the event reference
  under a spinlock.
- Patch 8: Added missing NULL pointer checks for rphy allocations and
  handled sas_rphy_add() failures to prevent NULL pointer dereferences
  and resource leaks.
- Patch 9: Added return value check for mpi3mr_add_host_phy() to prevent
  a NULL pointer dereference during device addition events.

Ranjan Kumar (10):
  mpi3mr: Skip device shutdown during unload per controller
    configuration
  mpi3mr: Update MPI Headers to revision 41
  mpi3mr: Add early timestamp synchronization after driver load
  mpi3mr: Fix NVMe page size caching for non-operational devices
  mpi3mr: Fix performance regression caused by extended IRQ poll sleep
  mpi3mr: Fix memory leak on operational queue creation failure
  mpi3mr: Fix firmware event reference leak during cleanup
  mpi3mr: Fix SAS port allocation and registration error handling
  mpi3mr: Fix SAS PHY cleanup in host addition error paths
  mpi3mr: Driver version update to 8.18.0.8.50

 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h      |  77 ++++++++++++++-
 drivers/scsi/mpi3mr/mpi/mpi30_image.h     |   7 +-
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h       |  15 ++-
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h |   2 +-
 drivers/scsi/mpi3mr/mpi3mr.h              |  12 ++-
 drivers/scsi/mpi3mr/mpi3mr_fw.c           | 109 ++++++++++++++++++----
 drivers/scsi/mpi3mr/mpi3mr_os.c           |  26 +++++-
 drivers/scsi/mpi3mr/mpi3mr_transport.c    |  57 +++++++++--
 8 files changed, 253 insertions(+), 52 deletions(-)

-- 
2.47.3

