Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D4235A385
	for <linux-scsi@vger.kernel.org>; Fri,  3 Apr 2026 19:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775245283; cv=none; b=tnygSgBwtauG1afk8e+Ld9nYPVybQHvvOYzqIavLmB20M2pgJQ+thkz+I6+6WdFgnFeOMA1wqqe4+9sPWd6a2FHuKgrIrq6bslE9E6K640ERYaH4dsqG7ip/wWcu954i2FtU7TXKrMRiHVgX3RgIYxBrGPxQSmHJzt3shG6EoAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775245283; c=relaxed/simple;
	bh=s7a0+emFgbEKsMfKwqFAYZyCvfuCzCFK+lgraS8d/hY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TMtlUmqCETpGPLCbNRED6RdXoxljidNUlImwwZJw50IjofhHw4yRC24uAvBdaXYpyP6TMlSP7O9ULzTtw9zx70GBghgpC1Ri7J/rFabipZSPfOlJi+gqintz1L2Rd2SrQPFUVQUq8jxy1AQCnS0l0PmR5/H6oWNu9iQv87GBLQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=X732gt4d; arc=none smtp.client-ip=209.85.215.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="X732gt4d"
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-c7426d8c026so65686a12.2
        for <linux-scsi@vger.kernel.org>; Fri, 03 Apr 2026 12:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1775245281; x=1775850081; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=M7691Rpd885rtdqhZsGvsmlwE0WhG23SmYwp1iH7phM=;
        b=X732gt4dYDZzpBF8SuUQOx8NkFdM1i6ui7jdBAYvQe2ifH/A+vh9D5jpdIh0KgpEs4
         fZtxi34Ik5ZVDX2IIqhCIDGtSSmokaQgy5KN1ILrSz/QAmfz2cLAHARVsyNxbN0C31eG
         7rLkiYfVUhwX8lWuXZoYtMs0nZfdgjLcgyS0kSnsvsDLq4/YPVTdO2MLJqssdwwgKlug
         M4wfJ/BHnC1lcHyHHYSNyO7kswBYNLGf+bugvgBdfFa+NWolNp/Ie5Pp62rjh6fnRqLV
         tUlcFoCnceB9lXZPpqItu2Mks0m8QIEIVLr80iYFLyIWkFivMH3GNlCjK1nj6I2rvdwF
         9x8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775245281; x=1775850081;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M7691Rpd885rtdqhZsGvsmlwE0WhG23SmYwp1iH7phM=;
        b=DCPqYQygSZsul56SRBubvU1pDAsCR/2Ju8coxy/Imv+bN9dKmVqukyyMs57c2Vugfp
         5m4Pvhu5pJ5vrcwZa4o6hIinXJHKdMF0SdfZGU6/zDrlv7IyE86k0RrnuGrq0mJ6nE4/
         romROnq66dmA3o8ZGenUjqaW1tF4ySoIgLkKPuH9nBdMrycQ2eMaog8Mino6v0RdG6bQ
         hu4gvYBFLGiLX9ppZ09aI78I4rOR+szR7hhF3Bd0IegZBFYis1Q4a0huIafVbEuSins0
         ZrzvC0qRfs/eEgXw9r7Uia3/g3Jh+nuIONLTY4PySVQs0e6BmvKhMyG7LmJx0aJmc4BA
         zzbg==
X-Forwarded-Encrypted: i=1; AJvYcCXcEC77fGEJezO78erjPLMwKPZvQSRzIu1agX92z+oJhcZgjvHzW+K64Jhej+Ow/4y2FGslH2Sw9Vgi@vger.kernel.org
X-Gm-Message-State: AOJu0YwY5AislEkjEifO6s8fG/8WTOG6T7GQvE1Bt/FT+1yRD5ZYWZCB
	z1SAXIGpvQobslFk7x82bzY4O/zgO0XobDyUAdi6aEHkDOtb65tTTPC85mT3KXjMGOnQYmPqrov
	6ubW2c/U0156iO7FL/GZpWQzsYd3vblxFgUoJ8zyyTl3t8FNHebCg
X-Gm-Gg: AeBDieuUeaebehWY5Gt0IAZqYcWqiP2juNoNy5Sed7VbTYebQS9w+MT59+HXnt/XNn4
	4clo4i5SGtEpN0TWpbVhECnZvbXzeMi6fsk2/v7tQAk1d6csfL5yB+qmzrcD2N7DiAAyc5tv7uG
	EgDkMYZyaL3gs88QCMHvRI7TDCxqgydMTDhnBI23K6CcOPHWzMrlKgI/rmD4Q8nrC3iEEydOS0P
	n86gCb2fRDQgOSv4XTcIi8jNOfQDGLjyw20ELeqCknbLE4nDSucuMmVQIvaawsqtymYlTEEvjTL
	xSRF0jO3leKRExaE3GxKCK4dB0wkQCF5nUotcp4dFKN/eS5p5WgVZf8n6+f9+Kgvy81n4eaPVad
	2oleqbJoeARjfJDw3QV3pc9OaLboi+CFRWZG8H6k=
X-Received: by 2002:a05:6a00:2d12:b0:82c:66ba:5f80 with SMTP id d2e1a72fcca58-82d0db7b707mr2480662b3a.4.1775245281177;
        Fri, 03 Apr 2026 12:41:21 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-82cf9c40eadsm676630b3a.8.2026.04.03.12.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 12:41:21 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 8432334014E;
	Fri,  3 Apr 2026 13:41:20 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 6A065E41AC2; Fri,  3 Apr 2026 13:41:20 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH 0/6] block: fix integrity offset/length conversions
Date: Fri,  3 Apr 2026 13:41:03 -0600
Message-ID: <20260403194109.2255933-1-csander@purestorage.com>
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

Caleb Sander Mateos (6):
  blk-integrity: take sector_t in bio_integrity_intervals()
  block: use integrity interval instead of sector as seed
  bio-integrity-fs: pass data iter to bio_integrity_verify()
  bio-integrity-fs: use integrity interval instead of sector as seed
  t10-pi: use bio_integrity_intervals() helper
  target: use bio_integrity_intervals() helper

 block/bio-integrity-fs.c            |  5 +++--
 block/bio-integrity.c               |  2 +-
 block/t10-pi.c                      |  4 ++--
 drivers/nvme/target/io-cmd-bdev.c   |  3 +--
 drivers/target/target_core_iblock.c |  3 +--
 include/linux/blk-integrity.h       | 12 ++++++------
 6 files changed, 14 insertions(+), 15 deletions(-)

-- 
2.45.2

