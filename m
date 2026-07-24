Received: from mail-vk1-f226.google.com (mail-vk1-f226.google.com [209.85.221.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D1E422E37
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 10:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784889158; cv=none; b=dv005EYwwN7Hr646uIPP2RZl8ebgJL46gNrMVNfvuQ/fO0gIiXVGrc1mbgiBG2GuMq1mI7Mq+mfI4nUgM18TW69mp/EhAIRmJHITA+CaKPMswIImZaZeKz2CxbNyEPybDxlIqzIdnUYiYw0SFHE/gQBoYzqsu3pkxgLk1Ohj50c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784889158; c=relaxed/simple;
	bh=od6xcfMJkptLhSZno1wwAKVXaDjw395EglmLi6SQ8G4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qNb9JexYYksOCrtteL2J2cil3eG8H+PYcovnbVMYvXia63JJidVjHoTEIy8kiK16wmsGKdVsZnRlAP+GFN19BXWdztsPppWQhtbnbmK04XgJdSGxfjtiFwoYTgnVcia3yR8Qg9cpuBUmd0+wjuFpUzCuyRBf62vYoWxSX5kjvsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=IvkTv6TQ; arc=none smtp.client-ip=209.85.221.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="IvkTv6TQ"
Received: by mail-vk1-f226.google.com with SMTP id 71dfb90a1353d-5bf9466867cso67253e0c.2
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 03:32:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784889153; x=1785493953;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=llWl+7v6OH43wefoHdfS/9jYWzbJyBjS3PDNsQ+lnjo=;
        b=hwxxxk/17dFJaEgdPb4r4ICnBE1ehDc184b/oQ8GNedoRhM7RhzTWRQ8r6/YFuJ+PL
         MjdGNks+ca17ltbgOI+hKNqKD5fxWRQaYI2HgTR809CsVp1iYGazIcnTr5kLihtMcrIS
         zZukaxRLeSrGLxkWzPr6lF1ED+p1/jfJE8Wsu7uAT1f17uX2PiJbbNfWh3SFIr3Fomdr
         iX7F4EhpTlLsFNkqxN7Y7uAEJ2/sAdRrT5594jv1r0XzKEdL799USs9tgJgQDmO2yEIw
         iDKltJY4aLuIJy8UikZQPBbf6S0X97/hylRLQFDzgRNl6qOccBkVk406GlxgF6J3u+S3
         K7HQ==
X-Gm-Message-State: AOJu0YzeLkIMUGw6pGlSJ40Y/j6JTBdxEh+u1PmLr8ZJ62wV+Ov4E9V1
	/+vDYGTwQ6N9D8QAXcSV5+tUBvfojRlQEPL92AXmebwZsauQIqQv+UeBNzWVdPNOReaKcGEh595
	WBD7rjL2JqfiY974/eC+Ct+m/qQ5dPkPm2fcq+E+hZZMinUOMHQcQg4L5cJO+PA99ojRpIKcuNo
	udSsOPT30Oq33V2Ea58k1pyRbtG3Sp7tpJFtaQ59OcyGJS78PjUKDyLRYM+VwYWmblZVKG5V6kZ
	rbdMtCgCb12HgSr
X-Gm-Gg: AR+sD11ZLMnVOYK1v6vy46l8wmk0IWsi7C6sOuuGn4OksOPqcD0UpAH6bvzkz6EjkbR
	p2IKY4wKo5+VOcL4A4JYnPCNv7Gx1VERLfXeIPs4DnnGsuYCfwIXXLSHI35Swy8YGnrawLjUF3w
	ZqEJr6K1wRaJT9BSH1HT2vKqr4gEiypl8nKd/WY/hh0lYpH8isK5mqy5bHQTa5lB8GGVY8uZAtx
	4yfr5CbAFdmakM1nrj/1SBXxQHi9EEaQJdOwCHIsS528O2oA19XhwgSpllM2Hd1Sclm7/jHLiNA
	qUFuogBVW2R4BZXFusJmOopkxjTDlzo7GE388fi1hv8cv1Ue3jRvgqemiFFkXETfJeY8dVYZA8N
	bBX3oKvDqgNgrd9Mh4LHnsFSz0uYAoHxQiQPtn+jQq02Pl5myzer1rj4B7L7KabfsXoByfm2iSd
	WzyzwOl/CcYRIhV4JwWvj6CEAr95C182ybnUg=
X-Received: by 2002:a05:6122:3a12:b0:5bf:a181:d46d with SMTP id 71dfb90a1353d-5c2d9ff4689mr2917993e0c.3.1784889153359;
        Fri, 24 Jul 2026 03:32:33 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 71dfb90a1353d-5c2c65ad85asm952853e0c.7.2026.07.24.03.32.33
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jul 2026 03:32:33 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c860544c077so642473a12.3
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 03:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784889152; x=1785493952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=llWl+7v6OH43wefoHdfS/9jYWzbJyBjS3PDNsQ+lnjo=;
        b=IvkTv6TQfj5sNXX2uXOiO4zLychxmWI1EWnvXWqVXLhexj8G0rf4Tl1QeAgcC9DZx7
         MeiwlZYvEi/o4vkLjnjeTZ+4eCOXl4ZuaEB+J5Ins20QCIM5X8GEJPruZH6jr0yVVyl8
         0HGbsqqTy5wrc+eVkrFbwVbV9JW4YQfqPOBiE=
X-Received: by 2002:a05:6a21:a393:b0:3c3:7427:5ed8 with SMTP id adf61e73a8af0-3c44afb4fffmr7909502637.8.1784889152191;
        Fri, 24 Jul 2026 03:32:32 -0700 (PDT)
X-Received: by 2002:a05:6a21:a393:b0:3c3:7427:5ed8 with SMTP id adf61e73a8af0-3c44afb4fffmr7909466637.8.1784889151672;
        Fri, 24 Jul 2026 03:32:31 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e1cf8fasm30233211eec.31.2026.07.24.03.32.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 03:32:31 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v3 00/10] mpi3mr: Few Enhancements and minor fixes
Date: Fri, 24 Jul 2026 15:54:55 +0530
Message-ID: <20260724102505.115136-1-ranjan.kumar@broadcom.com>
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
  references until after cancellation, and prevented deadlocks during module
  unload.
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

 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h      |  77 +++++++++++-
 drivers/scsi/mpi3mr/mpi/mpi30_image.h     |   7 +-
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h       |  15 ++-
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h |   2 +-
 drivers/scsi/mpi3mr/mpi3mr.h              |  12 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c          |  24 ++--
 drivers/scsi/mpi3mr/mpi3mr_fw.c           | 142 ++++++++++++++++++----
 drivers/scsi/mpi3mr/mpi3mr_os.c           |  99 ++++++++-------
 drivers/scsi/mpi3mr/mpi3mr_transport.c    |  56 +++++++--
 9 files changed, 332 insertions(+), 102 deletions(-)

-- 
2.47.3

