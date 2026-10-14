Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8664734D93C;
	Wed, 14 Oct 2026 05:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791956020; cv=none; b=VcPSyrxpodLTygF+3+63KUoKDTf36NIxkuco3CE1AX3JT9HY8yfsSLtMJ9aiHYn4cnKz8dNXvpid4Al5pPEI8EFjvrb6VzFxJKSVR1jMpCEYQSKNBmt01a3NjwRieKcjsmKAKE24BYcfyx+WAc73E8p4l3K/f0fufP1JygEO7OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791956020; c=relaxed/simple;
	bh=Z7l0aZmGlBb4C/ytfrvKk5lS6wnOCO736382QpRORUM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=t3tPPmyjMnYDg9tpKgz34vc38LrwycYgh96dzTFwLCFyQsGh+OoCbWIQQIO90UCTCTbXGvQ17W2GQV6XFm0ailU5M9MmX/EGX62QqZzn18m+vtmURt9FX0m6FQ8Y0wlkuPcNabIU+bAQSLmA9TN7WJOnA1esFIv6w9r+U0veclU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NtYc+0iY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NtYc+0iY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54C51F000FF;
	Wed, 14 Oct 2026 05:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791956019;
	bh=t51T6b558xIKXzl0R5FetYoqGLoypkGMlTMzsKpNJGk=;
	h=From:To:Subject:Date;
	b=NtYc+0iYReZSnfob/EwDG2YfNOxwgH938npo1sDmnGpKdQA9asjw3KXAhTNbpk0E/
	 lp8Jv5iPHCLjqwpnbWLF+rjzW4yMgNQNzHgwapIfkRla+FzvdMAOlJmEpz58cdZexG
	 YOMyF/vOo6WIFzWc2BZXowX1Qq3/NtR4P6aSWO366jbrRo8SM5Gw0zIzFq5YV2ckYk
	 RvaHGIkuUUQ8I9fvbr1qc5UNTtEKYmRpVOmCgO9p48nhxWqIT0arUg2CWROWTHQtPn
	 y3ZHYPvK3U3BDD8RZDCJcAomt+fggT1zmde+Dd/yjQSr01hGEZ+zMSWJIXg9qOoS7P
	 QKYZ126xkj0wg==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v7 00/10] Add support for storage element depopulation
Date: Wed, 14 Oct 2026 14:33:26 +0900
Message-ID: <20261014053337.2328544-1-dlemoal@kernel.org>
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

Changes from v6:
 - Addressed the nit pointed out by Christoph in patch 4
 - Added review tags

Changes from v5:
 - Rebased on latest block/for-next
 - Addressed Christoph's comments on patch 3
 - Added patch 5 to address a potential deadlock in zloop (signaled by
   sashiko)
 - Reworked the restoration of storage elements in patch 6 to avoid an
   inconsistent state of storage elements in case of error. Also added
   protection against disk removal during storage element removal and
   restoration execution.
 - Added review tags

Changes from v4:
 - Rebased on latest block/for-next
 - Added review tags to patch 1 and 2
 - Reworked patch 3, 4 and 5 to address Christoph's and sashiko comments

Changes from v3:
 - Reworked patch 1 to only provide the disk_zone_is_offline() helper
   function. Failing of read operations to offline zones is handled
   directly by the zloop driver and the new patch 7 is added to handle
   failing early read operations to offline zones of ZBC SCSI disks.
 - Added patch 2
 - Addressed further valid comments from Sashiko
   The biggest changes are in patch 2 to save the number of storage
   elements of a disk in struct gendisk and to serialize the execution of
   the storage element management operations using the zone revalidation
   mutex.
 - Rebased on latest block/for-next

Changes from v2:
 - Addressed further valid comments from Sashiko
 - Rebased on latest block/for-next

Changes from v1:
 - Addressed the many valid comments that Sashiko had
 - Rebased on latest block/for-next

Damien Le Moal (10):
  block: introduce disk_zone_is_offline()
  block: refactor blk_revalidate_disk_zones()
  block: introduce storage element management
  block: add storage element management ioctls
  zloop: avoid potential wp_lock deadlocks
  zloop: add storage element emulation
  zloop: add degrade_element control command
  scsi: sd: fail read commands to offline zones early
  scsi: sd_zbc: always revalidate zones for disks supporting head depopulation
  scsi: sd_zbc: define storage element management operations

 .../admin-guide/blockdev/zoned_loop.rst       |  29 +-
 block/blk-zoned.c                             | 500 ++++++++++-
 block/blk.h                                   |  14 +
 block/genhd.c                                 |   4 +
 block/ioctl.c                                 |   4 +
 drivers/block/zloop.c                         | 803 ++++++++++++++++--
 drivers/scsi/sd.c                             |  11 +-
 drivers/scsi/sd.h                             |   3 +
 drivers/scsi/sd_zbc.c                         | 259 +++++-
 include/linux/blkdev.h                        |  31 +
 include/uapi/linux/blkzoned.h                 |  98 +++
 include/uapi/linux/fs.h                       |   1 +
 12 files changed, 1669 insertions(+), 88 deletions(-)

-- 
2.55.0

