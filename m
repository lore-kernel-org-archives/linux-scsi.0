Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF057375F9C
	for <linux-scsi@vger.kernel.org>; Sat, 18 Apr 2026 13:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776519021; cv=none; b=nO3IOdII7VHvZCYS6ne6bTGjbtlHmZEsDD2LyX/K7I3JhpDpnT3rqrzzKT0FM/XcBdLD/KeqlTA2dzjlnFf92/rB9zcX/UHYdXA2KHkyxLpNizkEGftSUzXpS2HytypCAEosJZEGewXDHkp29S7tDdg3YPNnyj1IrgymCd++rEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776519021; c=relaxed/simple;
	bh=V1U+gnjA+uxt3WG5dwiL8Df5nR1/QAjxu/eBmWcDCPQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=k+Ax/j8dox94hZ/rx8rFzDgRzxk/gSBKLciZmQTLwHIcL98eA0pbjBe/YxBbdpyJJhl2d+SJoJPqOTFcmhk/Jl4Bx0qM3jQQg8LaMKqMuymWCXuy74RCVcfgb1Z8+eyhfL3pPnCTrgZTh+Zb8WHIjOzPLMMx0Z5oz4NxSxruvec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=snu.ac.kr; spf=pass smtp.mailfrom=snu.ac.kr; dkim=pass (1024-bit key) header.d=snu.ac.kr header.i=@snu.ac.kr header.b=Wfu8AS91; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=snu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=snu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=snu.ac.kr header.i=@snu.ac.kr header.b="Wfu8AS91"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3591cc98871so708783a91.3
        for <linux-scsi@vger.kernel.org>; Sat, 18 Apr 2026 06:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=snu.ac.kr; s=google; t=1776519016; x=1777123816; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RfriTNh3ogcuoYSBfpRbPbj1+pM0fCwODSvxv9ciWHk=;
        b=Wfu8AS91CJ86Ub1eXvxkigjAn4qF5I+OhLD/38xOfM0jf/LqZB/snTF1X21IqSiAlN
         NtfmX13I0JUjQa5+9K+IowpHSEBxT88O6pbz8rOWYYBOeIl21kHs6k3GwR/X2+/uMUmT
         GfySPMg1P6+nkd22Ycu+L9Hp/q0U94FTIWs5E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776519016; x=1777123816;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RfriTNh3ogcuoYSBfpRbPbj1+pM0fCwODSvxv9ciWHk=;
        b=QbIq8mBDQ28uEgRVSjOX+kNHP/5+DwTtLwdQuCjBxb7wmuXedO0mDiPHIJZktHCo2K
         AdnUjahS4huyn96Z16OeG1UKotSrErx18uDuQjbxjzTRwtLEwS6YUNfAOYMfKbSen416
         4p877p70rxWoUmV1wTXSrzEj1yOBpN8HnEIGZQ3flyzF/FAYR3C0P+I2zStHMbDlsUH1
         cV7TPlRjvOFjxqOZyBz2gJH0h5qgRcpUBz6lAilpotJqTOwXXniw2ABiVnovd2er8xyU
         j1iu0Gor8d3eQ+S67SNo3LxU+lxHGuIs36B+aRVtEO4LihhbV1LJpXV3Ati5TXnMwPVF
         vnnw==
X-Forwarded-Encrypted: i=1; AFNElJ93TXRUG4YOBhUegnenw7k6YC5Cj7hpzO9A6w8v9OBjh2bWlSgbkPQD176zmhaGuhaelXpa6yVL/8xC@vger.kernel.org
X-Gm-Message-State: AOJu0YzdIsqVaoRQ4OvzIkNpG3xTsS1dH5LnVQrVXOWhr2yMhcHs8E+B
	RytKDidwI6E43GIWc5rfZV0xtD8fLWELm3P73LuQ0twNImeG0hcPlvEXOBb73itZo4wAEtmpjN6
	f2HiyICI=
X-Gm-Gg: AeBDieuTouvymRcV+U1cft9q/sdaph7GQ256uepW9FBMQCoo3aA5eDdtjSLyNkq8EDk
	4+FFafQeyHN1Jv4FjooXsJhg6QXxiAOr2wSiYIH7I5392RGzJP4nPwIMqtEaiCiJYFqpPS8JzVK
	qUwM3ixX7sAuFMWPX9wrBzMRX3JT0Zv8PQkOHEJV6yGqaR6mhju5fR0wusBTOxmEYm0sUJURJOL
	b3cb1B9ZPER9MLVpRcyw8xoxqM9BbYKPcKLzQweSpZ16tXSPrFEZOtw655rVUjqulxH5aucZnPy
	Ko33qwI93g59yBQjB7ArqcarIP0RQ3X1Evh82Vu5pfqx9uElssC6GiN36SI7GHRc7uTUPRrar/Q
	EIUMuSEfUvhvv6pANN0BkHPEBsyj/eOIx1GbWvnU2hE8BT8IKI8Elw3z1VuagrpSEaHkDv85A4d
	Ir16Mher6FEOdviqghRmgs9ElJaw+itSA6lBH7rEByljX3BpCuA94raslZbOyd5UAyJy7yqw==
X-Received: by 2002:a17:90b:278f:b0:35b:e4f8:7cc5 with SMTP id 98e67ed59e1d1-361404a5988mr6206590a91.25.1776519015954;
        Sat, 18 Apr 2026 06:30:15 -0700 (PDT)
Received: from nunu.. (nunu.snu.ac.kr. [147.46.112.82])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3614195a9fbsm6843001a91.11.2026.04.18.06.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 06:30:15 -0700 (PDT)
From: Sangyun Kim <sangyun.kim@snu.ac.kr>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Duoming Zhou <duoming@zju.edu.cn>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] scsi: mvsas: fix UAF races in mvs_free() teardown
Date: Sat, 18 Apr 2026 22:30:01 +0900
Message-Id: <20260418133003.2462460-1-sangyun.kim@snu.ac.kr>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series fixes two teardown-path use-after-free bugs in
drivers/scsi/mvsas that are reachable when mvs_pci_remove() runs
with pending delayed work on mvi->wq_list.

The fixes are split so each one addresses a single issue and bisects
cleanly.  Patch 2 depends on patch 1 (both touch mvs_free() and
patch 1 sets the ordering that patch 2 extends).

Patch 1 - "scsi: mvsas: drain delayed work before unmapping MMIO in
mvs_free()"

  mvs_free() calls MVS_CHIP_DISP->chip_iounmap(mvi) before the loop
  that cancels mwq->work_q.  If an mvs_work_queue() callback is
  scheduled or already running when chip_iounmap() executes, it
  dereferences the unmapped BAR via MVS_CHIP_DISP->read_phy_ctl() and
  takes a page fault.

  Move the cancel_delayed_work_sync() loop above chip_iounmap() (and
  above scsi_host_put()) so that no callback can touch MMIO or host
  state that has already been torn down.

Patch 2 - "scsi: mvsas: fix iterator use-after-free in mvs_free() wq
drain loop"

  mvs_free() walks mvi->wq_list with list_for_each_entry() while
  calling cancel_delayed_work_sync() on each node.  If the callback
  for the current node is already executing, mvs_work_queue() will
  list_del() and kfree() its own struct mvs_wq before the sync
  returns, and the iterator then dereferences the freed node's
  ->entry.next.  Converting to the _safe() variant is not enough
  because the saved "next" cursor can itself be freed by another
  callback while mvi->lock is dropped.

  Drain the list one entry at a time under mvi->lock: mvs_free()
  uses list_first_entry() + list_del_init() to detach the head
  before dropping the lock around cancel_delayed_work_sync() +
  kfree().  mvs_work_queue() checks list_empty(&mwq->entry) under
  mvi->lock and skips its own list_del_init() + kfree() when
  teardown has already claimed the entry, giving a single-owner
  rule for the struct mvs_wq free.

Signed-off-by: Sangyun Kim <sangyun.kim@snu.ac.kr>

Sangyun Kim (2):
  scsi: mvsas: drain delayed work before unmapping MMIO in mvs_free()
  scsi: mvsas: fix iterator use-after-free in mvs_free() wq drain loop

 drivers/scsi/mvsas/mv_init.c | 13 +++++++++++--
 drivers/scsi/mvsas/mv_sas.c  | 10 +++++++---
 2 files changed, 18 insertions(+), 5 deletions(-)


base-commit: 772a896a56e0e3ef9424a025cec9176f9d8f4552
-- 
2.34.1

