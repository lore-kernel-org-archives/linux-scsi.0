Received: from mail-pf1-f225.google.com (mail-pf1-f225.google.com [209.85.210.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3907192D97
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 00:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776298968; cv=none; b=RNTpoGInIeaha+0jXz9D34wXhfblS3mTtopopvcqJ38VQx+2f/LlWfaraYqvzkyZP0s/3QC7qAkMoUKMHZE7Gu+I0Z+FwRemCeZyHei5vB5o0G0QTNbyF1ROJ0o4UAsJdP/iXQ9PI730c93z+WI1XUI2a0G20vOx3NAtrOHPvKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776298968; c=relaxed/simple;
	bh=ZsNzzGBZWRqGf2uq6G6j10Q+trCcIWrDEn8dRrN0A+w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l+ffnhvhfuE4lRRG2H/wattoAHCTwvSsQ6gBtxUcgk0r5lTGPS/ZP5XEkaZ1WLItEmlLM9jQ/YPSyu8dG/EtomCcTLmO/XpzrjXGCujB1+7Yv1FYEwPL2usolqfQbgWMe3wCvlew34YLb+ldD+eL+empzPKHo978PoJdcRtvuy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=QdBkYjZg; arc=none smtp.client-ip=209.85.210.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="QdBkYjZg"
Received: by mail-pf1-f225.google.com with SMTP id d2e1a72fcca58-8244105fa96so135865b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2026 17:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1776298967; x=1776903767; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=32BeK9NcDM0TTacs4Hgu5YnQIjPRb6EDjdK365GBPos=;
        b=QdBkYjZg4GcvOsulgVGLN6Yty+QsEbBvYWqsK9h3dF7jbJWgX4mCT4/D1D0j/8Tv+J
         5Yp8rJivwDJkNZhw5M104fimxjMCPZnnsmI8u1dgc+bt+NVrD5r2WfXs64QLqtEvN6Kf
         eOEZhVK0EguESYlUsx1HhkNgzXn2izp+Sp8TViUDzcdF9lLNVKyJqQqdv0XXtnGRM9SC
         QbYOzhhluh6zuQT6kbEs89FUCKn8CMAVSbgP5gEmYEl/JTWaG3fDweNWeQUicDi1mdOT
         PuoNMiwN5YHh6s7cdPf6rjkMU4Wm62fG3ASI2FKa5jr4RJzMVIIZmn9bVDy81wgPC9lL
         K3hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776298967; x=1776903767;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=32BeK9NcDM0TTacs4Hgu5YnQIjPRb6EDjdK365GBPos=;
        b=i/r+aI+GvOKBSsUXQMSTDlTgTho7aAciPcvtAQbae3xtHaRLr4GkPyNokS5fyMGZsG
         K6wVKMElNngNNkyM9qeiZhEVtfIDE/3gH0JeChEr51lDNoFNbmh5Tsxu1B4/lY9uFdwN
         X1rMsSWgOtaVKHqP/p5XNn13xsNWQPQxgpg7l/EfTVNc1cbAlGU17TP1d6fRLxbxKNER
         ZBJVUmbMnm+piArurqk+YPNALW/jXqUAymHliDt566En2/luOlELSb9YvQA08+8ueoLI
         ausyIVvHyEB3otNiKL7TnuM6z+LMAUX/s3G4ARczWfaFAKUc9RncymSb4OBHjd/Ffsw1
         pdCw==
X-Forwarded-Encrypted: i=1; AFNElJ/Nba+YfkhmKfeRedyr94iUBZqdQg5CohCOtznEQJhNFZIJIo4aYBpmPihSOe/7OsU7kBNbETce8of3@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7YiAOQvf0KYzNjU+M3JZTjEHUEysj2RD4KZ19B+xG30Rk6sIC
	SvBGlv7+zAFSx1eG0+e42tLpomwcL5Q0Rf5ETRS2nXChEjKL+70TgActI2x4cGnJcB11j9eFW57
	rcnUH7H+oUpyFJ3h0JYz0S5EeiqVxqcMXPErb
X-Gm-Gg: AeBDiev061HH93F+66hE/kI1zJxt7xXIE/ddFZVSLHgaZ9RvB27xt95ep0Kk770af23
	bEJf0Mp9I/tlpfL3rCNtnVQKzg+QnpaosiWVlFCzhtRPtEpmR0SFC7MCKOwB4cY4+ti1s/MMZIa
	VnAGMOSqpjZvGqxuUCzUN4YyZh0U/u/0Rl75TPjkbfuuqyaMeCoIwDiieTviYm8Tazca4CXZMvT
	M3eAa1A0gcc0TWpVwdhbAPsaVBmzho/uLSCcxIVxHy6Om9Opy91XbYYunxafPgFHSmVgBXKvvmb
	HNbyGiUG3CH34AGCtT9KGxcQDMDaCmletFd0Y2kMWmAnlrV701l4o2KxEXpQkTmHwSSMXD8I2UL
	o2BhDW33AXwod3oWGSm1lIKf8+zkMZxJ+/CfdaMmHHkQcTA3DjtwXwQ70Bwq3wXO6
X-Received: by 2002:a05:6a00:809:b0:81f:453d:1ab9 with SMTP id d2e1a72fcca58-82f678215a0mr2547248b3a.3.1776298967035;
        Wed, 15 Apr 2026 17:22:47 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-82f6741a4a2sm280415b3a.7.2026.04.15.17.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 17:22:47 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id A7CFE3405AE;
	Wed, 15 Apr 2026 18:22:45 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 914E7E41B93; Wed, 15 Apr 2026 18:22:45 -0600 (MDT)
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
Subject: [PATCH v2 0/6] block: fix integrity offset/length conversions
Date: Wed, 15 Apr 2026 18:22:08 -0600
Message-ID: <20260416002214.2048150-1-csander@purestorage.com>
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

 block/bio-integrity-fs.c            |  5 +++--
 block/bio-integrity.c               |  4 ++--
 block/t10-pi.c                      |  7 ++++---
 drivers/nvme/target/io-cmd-bdev.c   |  3 +--
 drivers/target/target_core_iblock.c |  3 +--
 include/linux/bio-integrity.h       | 11 -----------
 include/linux/blk-integrity.h       | 28 +++++++++++++++++++++-------
 include/linux/bvec.h                |  1 +
 8 files changed, 33 insertions(+), 29 deletions(-)

-- 
2.45.2

