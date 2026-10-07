Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E733FE344;
	Wed,  7 Oct 2026 08:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791361428; cv=none; b=Jp3Y+Vilv5HBmcZwIniiXr5FL+/bnjfux1xkkTNjBaZj4Zn1SHUKoUgONA/oVWq2GYPsFSUxkqpcyBAoOypzRCzkzHKAtikN0L4owuU0C5wgPL/TJm5DzAsIIjibMg06L2JfYEXI/bdi2desQQjVvlM27FvAIM5k2zL467uAcr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791361428; c=relaxed/simple;
	bh=yxzTlp9rIzXXOWaSt399imdtjZSBV+ofgAc2uaxChkk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=aFK8HW3kKocX/T1v+eLz1O1ZKgGWY9lXek5H+MJqpm4w5fErGb3UAHMwVx3nCKceklx48Ju/gq1/DFiyFMyLYm51DrdncsG9BJabf4YEND8tMDNK6ODjIHCfRjsX9v15FukP24ONg5XtNksgEY5kr6oNNt605DfcxAeOXxmdV2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NX3x+SRF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NX3x+SRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656401F0089B;
	Wed,  7 Oct 2026 08:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791361427;
	bh=kEVs4+7dcEMLml6lxTHvpUZIzoiNZWd6ewaNVc8E6OY=;
	h=From:To:Subject:Date;
	b=NX3x+SRFw9NY9y7UCvU7ENve49F9bk3oaID7BVlU2jGs+oPyJsAX4bm8p3U9TfGbF
	 uNpbE31Kuzd/2zqdb0wnWLW8eAkpmTMoBBfsyLiU7mZrJDsuHJOHf3eSRoiM3hG9+r
	 wFMudO4Hggi+oQyBVGO6D+AqHnZkDEwWom2TlPkGg6/EgzYGtYaXO84mRZ4W9lon8f
	 hhhYE+PbZN95P/xv/CZG3E0fhuLbps6R1vj45hr2nWsV8YGeOmj0lg9bix9qioe/ze
	 3GQwsN9FA0O2YC7ixcrcvTtwcpNmn4zx4crXys5Q7FP36VHzaIzPmOlym4QB9mmL0f
	 SknR6MGCchZaA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v3 0/7] Add support for storage element depopulation
Date: Wed,  7 Oct 2026 17:23:37 +0900
Message-ID: <20261007082344.1049179-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Jens,

These patches define a new set of block device operations for generically
using from the block layer the storage element depopulation feature of
zoned block devices. Support for this feature is added to the SCSI disk
driver and an emulation of this feature added to the zloop driver.

The management operations can be accessed using block layer API, which is
intended for file systems (e.g. zonefs and XFS), as well as using ioctls
for users using zoned disks directly from user space.

Changes from v2:
 - Addressed further valid comments from Sashiko
   (https://sashiko.dev/#/patchset/20261006124510.882017-1-dlemoal%40kernel.org)
 - Rebased on latest block/for-next

Changes from v1:
 - Addressed the many valid comments that Sashiko had
   (https://sashiko.dev/#/patchset/20261005094632.580753-1-dlemoal%40kernel.org)
 - Rebased on latest block/for-next

Damien Le Moal (7):
  block: fail reads to offline zones early
  block: introduce storage element management
  block: add storage element management ioctls
  zloop: add storage element emulation
  zloop: add degrade_element control command
  scsi: sd_zbc: always revalidate zones for disks supporting head depopulation
  scsi: sd_zbc: define storage element management operations

 .../admin-guide/blockdev/zoned_loop.rst       |   8 +-
 block/blk-core.c                              |   3 +
 block/blk-zoned.c                             | 361 +++++++++-
 block/blk.h                                   |  15 +
 block/ioctl.c                                 |   5 +
 drivers/block/zloop.c                         | 669 ++++++++++++++++--
 drivers/scsi/sd.c                             |   3 +
 drivers/scsi/sd.h                             |   3 +
 drivers/scsi/sd_zbc.c                         | 259 ++++++-
 include/linux/blkdev.h                        |  16 +
 include/uapi/linux/blkzoned.h                 |  81 +++
 include/uapi/linux/fs.h                       |   1 +
 12 files changed, 1377 insertions(+), 47 deletions(-)

-- 
2.55.0

