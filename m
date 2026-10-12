Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7E13019C8;
	Mon, 12 Oct 2026 13:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810085; cv=none; b=s7qrtaBCNkgiEp9JMKIC2qRK5ApNgSmR2zTorWcgdrzlx8zh/C0YeoKSll37RDGBftesqphcMylGPWE1DM8NN2dDrGxAsU8b83j/Noouq5nem5B8OQ6EgqYYolja1mKG0X0rJ9ND66LMmR6iV9Lt7qQxVpZ99bMirqQ+Rl7uAXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810085; c=relaxed/simple;
	bh=T8TaS8RO8htl9pQZV2Swbfg5bf7OWcZ6+WodvKiiSh4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=WKDPKE1YuGJMjyhIxWOOo1Lqvq9FZS/C/iiyUKxZhzBs4DdmZ8U38c+wyctbGycG9AXBCfYcYnxq/mWDGsP5XZGAmdoXN3Mu+3TogH+uuvYDj8uc63BloAAeIEJQONmYzW/E9+9JFzq0h0QYIeMwfdlpInhw/yR11yp2RO50jMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jdn88c9h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jdn88c9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C33F1F0089B;
	Mon, 12 Oct 2026 13:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791810084;
	bh=jOKPtZ9zbrhUAJsShDWmhwO0C5GAlViUiD16SyXojHg=;
	h=From:To:Subject:Date;
	b=Jdn88c9hSYrQ7EsRqBKEvL6E+16RFqbN6H0q6A72hI4VqAiNUbE7o+/RrGHzZB18K
	 sv+ouY+ITtlSwMAJvB0KzD3rxdmv3BvwJcuTsNC3GnzLwMA8bKPC+9V9CAUL80/BlW
	 YaI6sKtgJDv5aNRGq8NOiIcf1gDjWHT6RMH3HVolaCm8o5CUH6N/23aFrE4m3S8OY2
	 0KluseM3MLtwbPpvhGsYWPlQ6WUt2nPcfGVtAhvUjUg/U6c1bPWFH20lsBiz9yyMtw
	 IA0mNg3Mu9/O72xyZ18yagwIDLNgNwJQQTFQRooMf5GJfRXvVQAlsHt+mxCXnZJ0g+
	 DuXBTun0V8+Yg==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v5 0/9] Add support for storage element depopulation
Date: Mon, 12 Oct 2026 22:01:12 +0900
Message-ID: <20261012130121.1902634-1-dlemoal@kernel.org>
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
   (https://sashiko.dev/#/patchset/20261006124510.882017-1-dlemoal%40kernel.org)
   The biggest changes are in patch 2 to save the number of storage
   elements of a disk in struct gendisk and to serialize the execution of
   the storage element management operations using the zone revalidation
   mutex.
 - Rebased on latest block/for-next

Changes from v2:
 - Addressed further valid comments from Sashiko
   (https://sashiko.dev/#/patchset/20261006124510.882017-1-dlemoal%40kernel.org)
 - Rebased on latest block/for-next

Changes from v1:
 - Addressed the many valid comments that Sashiko had
   (https://sashiko.dev/#/patchset/20261005094632.580753-1-dlemoal%40kernel.org)
 - Rebased on latest block/for-next

Damien Le Moal (9):
  block: introduce disk_zone_is_offline()
  block: refactor blk_revalidate_disk_zones()
  block: introduce storage element management
  block: add storage element management ioctls
  zloop: add storage element emulation
  zloop: add degrade_element control command
  scsi: sd: fail read commands to offline zones early
  scsi: sd_zbc: always revalidate zones for disks supporting head depopulation
  scsi: sd_zbc: define storage element management operations

 .../admin-guide/blockdev/zoned_loop.rst       |   8 +-
 block/blk-zoned.c                             | 516 ++++++++++++-
 block/blk.h                                   |  14 +
 block/genhd.c                                 |   4 +
 block/ioctl.c                                 |   5 +
 drivers/block/zloop.c                         | 724 ++++++++++++++++--
 drivers/scsi/sd.c                             |  11 +-
 drivers/scsi/sd.h                             |   3 +
 drivers/scsi/sd_zbc.c                         | 259 ++++++-
 include/linux/blkdev.h                        |  31 +
 include/uapi/linux/blkzoned.h                 |  83 ++
 include/uapi/linux/fs.h                       |   1 +
 12 files changed, 1582 insertions(+), 77 deletions(-)

-- 
2.55.0

