Received: from mail-pf1-f225.google.com (mail-pf1-f225.google.com [209.85.210.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA77C2D781B
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 01:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776391067; cv=none; b=Lgd1o1zh/46T3EnvlItAPpCw3dCCE/IX0Qc0OZksuMwB/LaCyH1eUDZS9qSBWTZTpmwpYsQ7LL/5v1c4hI42bepI8VEhOxuvgHMD4eDKGVsqS6QaNoyS27JPIrFBIDIpqemEgD7pBRUZ2ARhqC89nMVz6UX1IsAqCdIW9lOfEPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776391067; c=relaxed/simple;
	bh=H7gpgcOZQqlOz3UfsDNLcCOef8f555rSPNFVL/tklSA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PmqtGp84QwJDVk2/l+evpVBHtWpj5DDa5iW5cBQfz0AJHIkjZpccD1f9kbfRhDFoKEx2FOhVn8EP5dQgCXHVqLiwIsZhMoySRWdJQm0Gb0j5ZqEyu/7u34lye/UDWUg7EjvrUqybgotC1nYsQsFU1ThU8DtAmRfOtn8uTWMumyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=YTorg9Qi; arc=none smtp.client-ip=209.85.210.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="YTorg9Qi"
Received: by mail-pf1-f225.google.com with SMTP id d2e1a72fcca58-82f1fbe6899so32656b3a.0
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 18:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1776391060; x=1776995860; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FUQOgbnR7fb9TvRKeaJrBXV8GjBjh4S9IAVC916d1UI=;
        b=YTorg9QigkhvWrGwYpyHFmDLxSx/S4R0Pzjprjlv7CD6ip11GOgi5S9Oj1icBdLbDp
         lR6OjeocUkpFTQ7A0SbnMKKOlW0YQdUb0UmMxtffNcTuwvC4UINYWePE7IHURHWaO9ur
         AjYE9/EXfuJZkMtQuPJ7BF/0ctNw0y3jCp4BgcIc3QUlEOY+QPD+zzZwcqZO2hEyif6G
         uURk6leOkEO3cUosW6Veogkvdpt0vLKcx+Z5BciDtCDZL9IwlKB0afS32VCKhN15wwwN
         2jMVfw6n3FfyXzKavj0yshFRCfmhNzhh7W2kdTsgbB/HPYzNbEAZvOmjqy68lWYz/t6S
         eZZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776391060; x=1776995860;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FUQOgbnR7fb9TvRKeaJrBXV8GjBjh4S9IAVC916d1UI=;
        b=j49fYE3anK09+UGlWLfPNaSsnP3y36OjbaP+avgYNth2hc4hColrbP+SSXXZJpzfOS
         JeIZ+ZKHO7g+VyY+UTG3dDtNYObnPNmIjGhTapFzCR/ZU6D9Ucn2x/kJSwBNLq0qnc6O
         uYxfYbemX1y4X283pPlzbMMfh2olhxjvD2o6xLc0+abF/U4D21KxYUWRMzbmjvFWlmZB
         Q1vNAiIvE0p7CbwHg8pCujFFNwlUDE39P5Clk07dgSSz066kf4ViPNjg1dmLLisICZR4
         OZap4pmWQksLdJzn+kkmNEimk5LkXfDicgNvhDQQKm+x+QIeJva6wfG2bMPU2EeiM8V/
         vgwQ==
X-Forwarded-Encrypted: i=1; AFNElJ/XngaS1aw68ih5lLWYKzsmwDvv93O5jK7VMbaRr1CZuWXcWeskPgiSPX7MZUGZVB4N3mC8v1K6FKlD@vger.kernel.org
X-Gm-Message-State: AOJu0YylPvzD0EcaIA6FWob1UTeHdXQdhldhVq9nzB0pEsB2s6zV//0x
	5rWHIzOQtoYuk+1mlfLoFprKXCVn7gDICACusBhPwAjPK4VAeVwMwFheoHizfjftQTpXDqtGUrq
	XhaJZiIJrabSZLrBIl2OXVlrE7P4Oi9H1/m8QlweLdzsgw0NUITt/
X-Gm-Gg: AeBDietKdzloZYGr2vhlFor0KtjQLJuKWcTdFzfseMmYniL++XFfajZJWG3GNpj+CfI
	GG8C+48dkfNRphKRk5gpEh9TQ+8qcqTt45b21E5QPcvBK8XXtZSHIMo7U5KlOH2+WlrRzA0n9Xs
	BSffa7ye4MZvEjNdIWrKAIxS0W9pXXfoYckom8nYNZUBKrtFsRilMBBtdYfJc8nOt8+jW1lP8wo
	ZtPoVGh5kXxL5ff/FYFwGlk7IDHdal78D7tOAvY75nwHkiymOOD8srFPVTfW92cDq5hhxjuOTeF
	8JbHU0Z3Dgga3lGpmTd4RAfOvNP0DXBsuXqMfTrvNuYY5EK6pnIs/Q6Zo/p65GcONYLM0a74Mie
	TbYgTXnlUjnz8Z5HFw0pqli4kzlAowa/O0WqhVPdduacNhkbMIg==
X-Received: by 2002:a17:90b:1d52:b0:35f:b204:c62c with SMTP id 98e67ed59e1d1-3614022c036mr490528a91.0.1776391060538;
        Thu, 16 Apr 2026 18:57:40 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-36141943c35sm24518a91.3.2026.04.16.18.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 18:57:40 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id C637C3406AA;
	Thu, 16 Apr 2026 19:57:39 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id B6B12E406BE; Thu, 16 Apr 2026 19:57:39 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Anuj Gupta <anuj20.g@samsung.com>,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v3 0/6] block: fix integrity offset/length conversions
Date: Thu, 16 Apr 2026 19:57:26 -0600
Message-ID: <20260417015732.2692434-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The block layer's integrity code currently sets the seed (initial
reference tag) in units of 512-byte sectors but increments it in units
of integrity intervals. Not only do the T10 DIF formats require ref tags
to be the lower bits of the logical block address, but mixing the two
units means the ref tags used for a particular logical block vary based
on its offset within a read/write request. This looks to be a
longstanding bug affecting block devices that support integrity with
block sizes > 512 bytes; I'm surprised it wasn't noticed before.

Also fix the newly added fs_bio_integrity_verify() to pass
bio_integrity_verify() a struct bdev_iter representing the data instead
of the integrity. Most of the integrity data is currently being skipped.

v3:
- Drop bi and bip arguments to bip_set_seed() (Christoph)

v2:
- Reorder fixes before refactoring commits
- Use u64, SECTOR_SHIFT (Christoph)
- Don't take sector_t in bip_set_seed() (Christoph)

Caleb Sander Mateos (6):
  block: use integrity interval instead of sector as seed
  bio-integrity-fs: pass data iter to bio_integrity_verify()
  blk-integrity: take u64 in bio_integrity_intervals()
  bio-integrity-fs: use integrity interval instead of sector as seed
  t10-pi: use bio_integrity_intervals() helper
  blk-integrity: avoid sector_t in bip_{get,set}_seed()

 block/bio-integrity-fs.c            |  8 ++++++--
 block/bio-integrity.c               |  4 ++--
 block/t10-pi.c                      |  7 ++++---
 drivers/nvme/target/io-cmd-bdev.c   |  3 +--
 drivers/target/target_core_iblock.c |  3 +--
 include/linux/bio-integrity.h       | 11 -----------
 include/linux/blk-integrity.h       | 27 ++++++++++++++++++++-------
 include/linux/bvec.h                |  1 +
 8 files changed, 35 insertions(+), 29 deletions(-)

-- 
2.45.2

