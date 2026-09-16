Received: from mail-vk1-f227.google.com (mail-vk1-f227.google.com [209.85.221.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197C7479898
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 08:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789547715; cv=none; b=A7DLsf39cRy23nMwzhdhxggS/jYcg5vQATgDIscZro0zfoUsM1JRRb5HHbAZmIXMqhiyAZnhQqDDJiudLaS/O4FKM7GNa18nby7w3uUQjHf8/5hyBXAUz+D3y7vy7sHCro0p29CPzxYYmRAtJjafwf1Mz/jTUxwLPpqQyYx//4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789547715; c=relaxed/simple;
	bh=Th4/mTBs1k01K2UZltmCmPOG69JQ1YTppuTrll4E9F4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ze6A7D4I+Hsme69D9d0MUtEQdFP00/XfOrUrai/jE9nwHKd0nb5en4gPBhKc+qBMucSREwVCP0JIMjqtBc0Dz8PKNFSFVcCSeahf4UQacmi3OSPrboBOBp+UGuy0nCrTMUhSu9nIdns0NwMXd44bl1BaNw1SuTuAdp2AkmE9AyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=MtweprDH; arc=none smtp.client-ip=209.85.221.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="MtweprDH"
Received: by mail-vk1-f227.google.com with SMTP id 71dfb90a1353d-5bf5370d38fso744635e0c.2
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 01:35:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789547710; x=1790152510;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jBIvmmYgNzEFqQf0VRJdalXmIfHSrzUAHfKsaTBQg8I=;
        b=DA35pKCO7N/pidFt+xyTNO9umIUTzeHFQ0pkpiorsXSa64JRwawX0cD50SF7S/4KWh
         WFkvpyxjlwp7oxwdfzB+JnLoo4ZWAD+7DVp7gCZ2o2VWuTPT5KLpDkNEP2ppk6i7x9TV
         0vdZAAq9qbHcq4qTASFndU6T+64fDklnYNv2W+DDW44IoapWWxLCe2S7b0sdsa+ekX7b
         Nq7F0XYWfLNxJAkvObiQtNFhdPwUHiwyy2L8bk6DGZ22UMHuEEgAQ8+ia4/q0HHbA+NR
         atfN8ojiMh1O4mwsbJ2W5x102WSn7gRpYV8pKEJURz0wtdGQLu0jmeo3HsMPJZZYGuVW
         SEeg==
X-Gm-Message-State: AFuF++lEUTVCJqvBPew1/FKzScB4+4xD/PrkqZmCJuDV0lOwBf3kc1Fx
	J9jkTJCQAx2dtaUz+7rK7Qy/IG+WwzAHYs96nRrSNW8Nr4sxeHqoAXaI21HCW/u7SU1J2Not2bW
	neFHs9a4UrgOz/JBaA/l3nierE9DELo6T/PJkVTkgpPaPqsuVY0hLYRRtpFXVPcaPNPGO062kAc
	Nd7u6BL8vb6cL5+f3rCFB4Ut9MWU4Qas2LUPw1iwfwe1bgLpcRq9KE8nWaqs9QuM/mtx5k7TJ1y
	5gEUspVKIycp78m
X-Gm-Gg: AYBFou2gGW+1g+sEz7gryo4DVMWjiV2QqSXaTJBgJ9h1/IgJd+PYw/KqNo5ZHoCRbZw
	muNtwc4JQ0/LQ0M9yVoFNYNXRkRhGV+Qhqm447SSXn2BzvxU4amfHCtmKGq0BnML7LA3lBkV3FI
	UhzOthRUu3Yti0R3zSxytqpNJB24ZshLE7Od3nXfJeKmNJjdu8YMumS8B++mD2BxwaNZh5qXZrA
	TU3slGn5xJ5Vi0QWK3Fw2NAwqOpgInoHlKwBF+cvHuvPDGmTyRI0DrFF2LI8HHJMdWDKfGO59Ex
	pvC4VjxHPFWw47gS08jqO+MnrvihKMaBcwDNXFngTbJ4uge2VS48LVyrNmQ36ej8PqpfAKJ//zN
	mo3N7YRntbVJ4qo2uU8mHbZ+I5w5sj3YwqqwGBWFenxtuRtxrbXGvh6YHKz3N2ADXXF3thlxsq9
	khUDnynfgIgYeeCT6NLCB+Lv/IGpLOuurA5NAHPg==
X-Received: by 2002:a05:6122:d98:b0:5c9:54c6:b4c6 with SMTP id 71dfb90a1353d-5c99ab555b2mr1189319e0c.2.1789547709648;
        Wed, 16 Sep 2026 01:35:09 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 71dfb90a1353d-5c998722c88sm900721e0c.0.2026.09.16.01.35.09
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2026 01:35:09 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-39e087a17dfso2459849a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 01:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789547708; x=1790152508; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jBIvmmYgNzEFqQf0VRJdalXmIfHSrzUAHfKsaTBQg8I=;
        b=MtweprDHfHo5IKvUpXL/KcTG4qC3Rp8+/CEMQCzxuQolj+xLh/oWmUPPonU/mNJMCS
         EtbjLbENWki+PbpUdtR6wHbbUC4Y1cif0cQ37BqwBtziG0DQDD+VDLfwpg7QdbdhgH5F
         DOGe7/OpTnza2gYFR5QuHC20InlZOghcwyobk=
X-Received: by 2002:a17:90b:28c6:b0:39d:f5d0:88a7 with SMTP id 98e67ed59e1d1-39e1e423305mr4160645a91.15.1789547708366;
        Wed, 16 Sep 2026 01:35:08 -0700 (PDT)
X-Received: by 2002:a17:90b:28c6:b0:39d:f5d0:88a7 with SMTP id 98e67ed59e1d1-39e1e423305mr4160559a91.15.1789547707746;
        Wed, 16 Sep 2026 01:35:07 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bf5ac47cfsm5226261eec.17.2026.09.16.01.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 01:35:07 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v5 00/10] mpi3mr: Few Enhancements and minor fixes
Date: Wed, 16 Sep 2026 13:56:55 +0530
Message-ID: <20260916082705.44712-1-ranjan.kumar@broadcom.com>
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

Changes since v4:
- Patch 4: Closed a double-fetch race on the firmware-provided page size.
- Patch 5: Stopped counting a corrupted reply descriptor as pend_ios.
- Patch 6: Synchronized op_reply_q clearing, fixed a segment-list leak.
- Patch 8: Removed a reset check causing a leak and BUG() on rediscovery.

Changes since v3:
- Patch 1: Guarded the firmware buffer loop against a bad decrement size.
- Patch 4: Made reset_to/abort_to a single write, tightened pgsz bounds.
- Patch 5: Fixed a reply_dma leak, a double-decrement, and a stalled index.
- Patch 6: Added synchronize_irq() on queue teardown, fixed a segment leak.
- Patch 7: Closed an ABBA deadlock between the EH/reset thread and worker.
- Patch 8: Fixed a fatal device_del() bug and the same deadlock as patch 7.

Changes since v2:
- Patch 1: Added missing endianness conversions (le16_to_cpu()) for
  buffer size fields in mpi3mr_alloc_diag_bufs() to prevent large memory
  allocations on big-endian architectures.
- Patch 5: Hardened reply queue processing by adding bounds checking for
  request_queue_id, fixed a TOCTOU race with a double-check pattern
  (using dma_rmb and atomic_add_unless), and replaced a direct panic()
  with a safe ioc_err() log for malformed DMA reply addresses.
- Patch 6: Fixed potential NULL pointer dereferences and Use-After-Free
  during spurious interrupts by properly clearing intr_info[*].op_reply_q
  when reply queue segments are freed.
- Patch 7: Resolved multiple concurrency issues around firmware event
  cleanup: fixed TOCTOU races by safely handling current_event under the
  fwevt_lock, fixed a Use-After-Free by delaying the release of event
  references until after cancellation, and prevented deadlocks during
  module unload.
- Patch 8: Removed an explicit sas_rphy_free() to fix a double-free
  vulnerability on the sas_rphy_add() error path, as sas_port_delete()
  implicitly handles the cleanup.

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

 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h      |  77 +++++++-
 drivers/scsi/mpi3mr/mpi/mpi30_image.h     |   7 +-
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h       |  15 +-
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h |   2 +-
 drivers/scsi/mpi3mr/mpi3mr.h              |  13 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c          |  44 +++--
 drivers/scsi/mpi3mr/mpi3mr_fw.c           | 203 +++++++++++++++++-----
 drivers/scsi/mpi3mr/mpi3mr_os.c           | 175 +++++++++++++------
 drivers/scsi/mpi3mr/mpi3mr_transport.c    |  99 +++++++++--
 9 files changed, 486 insertions(+), 149 deletions(-)

--
2.47.3
