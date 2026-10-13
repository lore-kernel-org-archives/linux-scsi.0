Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A09C4F7CDE;
	Tue, 13 Oct 2026 12:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894474; cv=none; b=QTbaiMzFeu6UuDuv4N64tid/88QxwPR7up3pv0K0091It7s1+oULi2YSIR6JX9QQIuRmk2tw9eKxX3J2uWsxJ+1Ktenhw9YivT1r2Lu1Vwv+I+AVCYQvumuubuOmSDihp6sd9a2WEy6kw2NBVVaaMt6iuwCKRYVubO0CwaJcEP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894474; c=relaxed/simple;
	bh=NlSGd8voogXvhYUu+UwAiHMJt5zFSS136LnNYjDK3TI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Atu9LjKDXmxNwwneMln0mzF/kV6q9IQ0BZGQH8Rs9ZKg4zQHdTJpTgILy7FvKqlPbLas2DdB5T+aus/aW6Uuy2Te1VXJ3cQ0tVF2BframsyRHuUPa3QDcyiwgAGvb4dGmBfaig8B/w802cZrO32toBD77e012Pxmiw9/ZZNxmzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dijji771; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dijji771"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607C71F00893;
	Tue, 13 Oct 2026 12:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791894473;
	bh=ycxOM4TzPLsGmQH6ulsf1AgoyN4SkD22jB62HRw8+hc=;
	h=From:To:Subject:Date;
	b=dijji771V8ZIG44fNl8uSjRjYcSeAMtiD0BYhIi2Ca23Sm2CPS1RvfyIrVX/t8y3d
	 r5zPOzj7EQHMypOrdYb3UCjiXrDF7utoBabX3ZlqYcVyQqrfPvEsj3xd858oV23DBs
	 InDfksjniQG8dvSwutenT5utl6NsFIOJt3yzxT0LXJatjPTevSDaKb09ePuHS8lGTI
	 GhWQIa0yw3HME6KhgyLACKUpwflSt0h2j+CQWd/nvCGdtcjAub41WC0i/OtcgLQ3lr
	 qreY7cFFcrFVzeGYBWG8tPKh8tWbAIg3bsmaP9I1cY1gmFX7/RfeTUf3DKzaO7JL/5
	 JZV62ZuXIhHUg==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v6 00/10] Add support for storage element depopulation
Date: Tue, 13 Oct 2026 21:27:40 +0900
Message-ID: <20261013122750.2237843-1-dlemoal@kernel.org>
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
 block/blk-zoned.c                             | 504 ++++++++++-
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
 12 files changed, 1673 insertions(+), 88 deletions(-)

-- 
2.55.0

