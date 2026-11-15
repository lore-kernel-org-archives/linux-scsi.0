Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794785610;
	b=s9XGlgLzGRx7GCtLcw7eDJpnS//NOg9aut28R0lYsImYBWBN+bklA2ZLkWKhcxCFlmq/
	 QpPHL+rc4LYV9IORN6Ed9I1zelLitNbb/Rji2qVez17YQ6IU0xQaz1NmAHVXrzHI7j6/u
	 TLrlg6UlIvhq7GD0DBX0mTMlVvBoO1w89BUSFgeY5hgbEk3jEMi3NWSCH6yJykY6BoslP
	 7aA6cXfhDQLVic0Bx3Vi837ga/0GRxhwLgARpGqQQB/rNusjUNa0FdIeuV9S8VwDj6dhq
	 qajd5Wa0Xs4m5ZGtxVRcwL4+F2fg0HM3OWAAvmCn+rIAgaHkQjj6cc9wXvzGPtUEV0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794785610;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=egxDnFMEWFfDpGaAQK4ZP9oO0nmZy+YZEMrEffQOHVg=;
	b=N+dpy6CIPSpomBY4wmlyYODUOSJRg0WrkH7LSJAvTkRzjTtISfn0aTqdXK5ahSazfx+X
	 8ZNDqpDHfKeY3oXZmaSCma47/K/tLzoFxbCpnAr3+oe6Z2CXPaPcrCeS4nVNiDR75cyLu
	 RYwSgj0aZ9divag8t9f0Kwf/dTDthLaxVVR8V0kQd/VJYp1B9pOwuO39+Qiud1l1YwOUo
	 F+dLJ8hCtmY5zxiHcNFA7xyqAFeAn5YU1J2pEtK5WljE8oSk5M/CKdkEZq2iBXO93g0cy
	 huP1uOF+TwsPeOsU0a0+jGHRdZTvUlb0i48jpS5yfsy5t4qOi6UBnrTWMl3op61DNGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TmKSa6qh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D39606A323;
	Sun, 15 Nov 2026 23:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TmKSa6qh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CC71F000C4;
	Sun, 15 Nov 2026 23:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794785610;
	bh=egxDnFMEWFfDpGaAQK4ZP9oO0nmZy+YZEMrEffQOHVg=;
	h=From:To:Subject:Date;
	b=TmKSa6qhjLOGLH13mJkKRPeBbSfn+8anmRSmxVaBrIFySlmXPcmRHcFZx7OLZ51f2
	 AMr2vjnYE1n94Dm/DBQtardqIx8NnrKfatZa2Kzb8ofJHHhy/YJxKG3HuW84C+tlp4
	 rRJq+F/VYbCP1Uiz1L2N6TmeaAc3sZWrPg5adTMPkFIA3skB1b+pJuJzSO1x+48kQX
	 zCFaWuo7ZhUz/pjJyPArN49ggEvkOrP5OyLqUqanvGZey0tcMVce9BzRz9tJBjB9KB
	 3fGrU4u3+N5jYdVk6K6uXhAgtosCe09miZTfm96+P5DhwPHV0Eapr0sVCYYkKGtr4+
	 omEm+cZLxtbjA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v10 00/13] Add support for storage element depopulation
Date: Mon, 16 Nov 2026 08:33:14 +0900
Message-ID: <20261115233327.941586-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
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

Changes from v9:
 - Addressed Sashiko comments on patch 6. This change redesigns the
   ordered zone append handling to simplify the code and avoid locking
   difficulties.
 - Addressed Sashiko comments on patch 8.

Changes from v8:
 - Addressed Sashiko comment on patch 7 by adding patch 6. Patch 7 is
   unmodified.
 - Addressed Sashiko comments on patch 8 and patch 12
 - Added review tags to unmodified pacthes

Changes from v7:
A significant amount of changes in this version to address most of the
Sashiko review comments and to simplify the code. In more details, the
changes are:
 - Added patches 3, 6, and 9.
 - Dropped former patch 5 as the use of irq-disabling spinlocks in zloop
   is not necessary.
 - Reworked patch 4 by migrating the idepop operation wait loops to the
   device drivers. This simplifies the implementation in zloop without
   making the sd driver implementation more difficult. Also fixed problems
   with errors during restoration and zone write plugs state.
 - Reworked patch 7 and 11 to be consistent with the changes in patch 4.

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

Damien Le Moal (13):
  block: introduce disk_zone_is_offline()
  block: refactor blk_revalidate_disk_zones()
  block: allow dropping all zone write plugs on revalidation
  block: introduce storage element management
  block: add storage element management ioctls
  zloop: fix ordered zone append handling
  zloop: fix zone reporting consistency
  zloop: add storage element emulation
  zloop: add degrade_element control command
  scsi: scsi_proto: refine the definition of storage element health
  scsi: sd_zbc: always revalidate zones for disks supporting head depopulation
  scsi: sd_zbc: define storage element management operations
  scsi: sd: fail read commands to offline zones early

 .../admin-guide/blockdev/zoned_loop.rst       |  33 +-
 block/blk-zoned.c                             | 450 ++++++++-
 block/blk.h                                   |  14 +
 block/genhd.c                                 |   4 +
 block/ioctl.c                                 |   4 +
 drivers/block/zloop.c                         | 924 ++++++++++++++++--
 drivers/scsi/sd.c                             |  23 +-
 drivers/scsi/sd.h                             |   5 +
 drivers/scsi/sd_zbc.c                         | 538 +++++++++-
 include/linux/blkdev.h                        |  64 ++
 include/scsi/scsi_proto.h                     |   6 +-
 include/uapi/linux/blkzoned.h                 | 106 ++
 include/uapi/linux/fs.h                       |   1 +
 13 files changed, 2052 insertions(+), 120 deletions(-)

-- 
2.56.0

