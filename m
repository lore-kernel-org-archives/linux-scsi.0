Received: from mail-pg1-f227.google.com (mail-pg1-f227.google.com [209.85.215.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BDD430310
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 11:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785928452; cv=none; b=upXPCOXuTcc8oD3Hchj6WJXtMu8Jf+PLmWuQq6Kl9aDrW/SP6aWVkwttfMJmhJBBsCJeNSJCug6SY4Gb+1nJ8DXp/j3zLuhEr/dgGtDL5QVtzqY0qtvPzeeG23e1T4sw1HWHGPx1k5ALg+lziH+vZrlyiAWMT8Jg/PGIUChSK+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785928452; c=relaxed/simple;
	bh=W13x2h+Pc+Xpx+vCcdzj1HkS/TOjlN3jv23geKzbr0s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GdwwqeOaQ+CRE7Wmfr7aGJlmBWyQirDF4Llwvp+hn45qdukoGu3ZdsMcsoq/jElXUhYFIeTMUe2ZyPr+k6b/D8RG1bW7tgUqImoXQSePpKEhyPIJMwz8UXooopuIYC3gBG/Odo3dIATuYuePwVHwtGMa17skh9bCZpcFT6/oo0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=RGd7Umgr; arc=none smtp.client-ip=209.85.215.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="RGd7Umgr"
Received: by mail-pg1-f227.google.com with SMTP id 41be03b00d2f7-c9e0b89e228so483232a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2026 04:14:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785928450; x=1786533250;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=eb5w2KqbkLcA7sQNHivZyyYvOroVrUlNMLhZXmSrAig=;
        b=KMVGBZGLjgOerSporrjWTtY9izBQycxF7vk4MgLWqrVGI63n+d3Dx3C+2Tmq57Pw9L
         EymTN5OeQXo91rOUqFCB4hdh6jhTZ9h9o+ZFo2KzZJFGlexGLMbka6gOsKOEnKEH1tMg
         AmK+HkokyP5/UZHJxsFY83BFbnjpGG9J16wXlLnT1x9MsuECWsFko9ui06FbpSMhlfKG
         8N5aVezMhSM0PdjZUZVk7LqAZsGgjCVLWYn8mx1L59OQ9Z404c7vuaBz1GfQ1fcStVxU
         LJyOydbxi3mDw6z27Ok2jLIhRIXKJPn84CXDRJVqS/r53Nce4QgYqU52s94U1me5F4Cs
         u2QQ==
X-Gm-Message-State: AOJu0YyrrO9czNSruA+nTJb2oDnUGWhRKPRCflWl/n3s0/N9BkcowggW
	Ugmw8T5LAADbMt35Rxev4y3Gau/yfsaFXYeqN94fjKAvSU43SD5mEhvSCNXT0KB1vwnlGVRVKN+
	oduxOnNqpQQxw8WSUVXBw0I/dg2FjfqFEcm1dhnRlk7VPWpXVsBRKAWDB++cAcQX6xm4E3DOH6X
	Ld7muxEOX1nER2QVWqm5X17fHJKamnyuvVUMpbiCPOKBc2J1Ph1YiBQIutLFckgh9V8EwBQ6crf
	e7gVKJF4q5b2ohN
X-Gm-Gg: AR+sD10bJDcRZssJL7pvTujkuS9qhoigtAX+JtHOeMib4y1Dj1KheL2tFuXC4XB/YAe
	wrsVWVG+/ksiZYRLQxuve/GXzG5CXD6tbjLviwNSqjPQp6jBkfF6nXnqp2lCkx78YEKwNa+eRws
	3xXSYK4Tk/dOo08B/ocUAIv/NvdiM4qgZL0f+fpnTx2O2p1n4mIU0vFw+RivcEODL0T9dzzGQey
	4Lk3emzzzXZEqFPjGgEIx1uu9uFRQo8LUuE6GHStxcWdjtzMTPGTRbq/R+MeIKjzD1GD6BTVx9S
	8Jo+JW9nN4WnmhIjYql7lB4mv4hBdkaANwXm2Tk2aC8Ur3yZZlFzZyQEWijDAarpQqPr5/SxBnh
	Z92U9xlKoHWzojq1Ch/T14fgd5N2T95MmSsWlUfX1N7vVChz54Db+2pWcSyzq3O0iM0dKDdvelT
	pmkK8mLMlO34D3x2CYFHe/sDGF70k+R/aw6JY=
X-Received: by 2002:a05:6a20:3d02:b0:3c3:8d4c:6673 with SMTP id adf61e73a8af0-3cb85fabfffmr6951593637.37.1785928449569;
        Wed, 05 Aug 2026 04:14:09 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-22.dlp.protect.broadcom.com. [144.49.247.22])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-cbe707f678dsm697133a12.4.2026.08.05.04.14.09
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Aug 2026 04:14:09 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c96b4f58ddcso763426a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2026 04:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785928448; x=1786533248; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eb5w2KqbkLcA7sQNHivZyyYvOroVrUlNMLhZXmSrAig=;
        b=RGd7UmgrbcGB3QVhc9GvIH4l77YcMTk7xMX8cY1OH2x6tdRVupi7jkh5e7ARCNvNTQ
         kNiYL5RvstgK6MLb9kwvwU0UZXKtVGCJ20KMSyVCeaPFTZU6O2GbUb5k6uIOIq38wCWd
         +AwH3d5MPCqqWPyfq6TlfSWr8Z4y5OYRvItps=
X-Received: by 2002:a05:6a20:7fa3:b0:3bf:a489:1483 with SMTP id adf61e73a8af0-3cb85fac015mr6358189637.33.1785928447891;
        Wed, 05 Aug 2026 04:14:07 -0700 (PDT)
X-Received: by 2002:a05:6a20:7fa3:b0:3bf:a489:1483 with SMTP id adf61e73a8af0-3cb85fac015mr6358109637.33.1785928447276;
        Wed, 05 Aug 2026 04:14:07 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3158673b7f4sm16740227eec.17.2026.08.05.04.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 04:14:06 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v4 00/10] mpi3mr: Few Enhancements and minor fixes
Date: Wed,  5 Aug 2026 16:36:24 +0530
Message-ID: <20260805110634.346670-1-ranjan.kumar@broadcom.com>
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

 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h      |  77 ++++++++-
 drivers/scsi/mpi3mr/mpi/mpi30_image.h     |   7 +-
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h       |  15 +-
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h |   2 +-
 drivers/scsi/mpi3mr/mpi3mr.h              |  13 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c          |  44 +++--
 drivers/scsi/mpi3mr/mpi3mr_fw.c           | 193 +++++++++++++++++-----
 drivers/scsi/mpi3mr/mpi3mr_os.c           | 173 ++++++++++++-------
 drivers/scsi/mpi3mr/mpi3mr_transport.c    | 103 ++++++++++--
 9 files changed, 479 insertions(+), 148 deletions(-)

-- 
2.47.3

