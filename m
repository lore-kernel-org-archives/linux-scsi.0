Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794754219;
	b=xWRfxNM7GRW1SPLA5xKStOkdQrqd2VXF59tpNKflaJBxjZD3gPbdZPQeNvrEd0T5gTZE
	 96LIASu7HEH3Fvyk00TNtlyvQNZytRgPzXBW5R/pJJpd2O3qxE3n3r3TVLm21yvx0Odpk
	 MyUei4HAmp0R0mAOvi/AGYxfqiNMgiS3MDAIS152PnXAXkMojN6dOAfIaM0SVOAlJIMP9
	 mAH9M7DBUnQLhtvOU7/cbont33Sq1xMmECu4NLIximJxKkErN4Jr0FhSybUtwDQ3tQ2uj
	 ZfTP33LVy1+bwwBrnnPuRj85QWk0gNx+7tpepnk+57hUP+BZF+l6dGJxdZCnqsOLcig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794754219;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=svG0nk+4KxvSRS2+yy8D9zKfzMdUcXDsRQ7QMMGiMao=;
	b=F1YOdxyrfJ6b9iU71ax1B6PIjtN0yRRAjZnxPwho80Ebj40p3HwzVXjSwpu+un4f2t1K
	 ZySA3WJfEgQmA9PMxVzqbiFOPvy1H31C6MuQ8B/dPx55CDjXUHzuli9nadqRo2p3ZPCFf
	 208IGu1ZUmqDPXS/SXihR1nCNgjlh34h32E/EvO19Rxm8R8wo/d4Qg6GscDBHrdFI5Efy
	 cjaNILdADX/EssG+OU/+olo3Fn5z3tJ9ySXVTX1sut1MGT1u/5ilGFkEXKKdGBlwY9w3L
	 y5vSFzUo8E5Q404Xu7i89u8nkMexFCYkW+jWq/Gr2aLCRfIeOsOC9EVd8PqAYiV2uMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GU59RVzX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF34606A31D;
	Sun, 15 Nov 2026 14:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GU59RVzX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91591F000C4;
	Sun, 15 Nov 2026 14:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794754218;
	bh=svG0nk+4KxvSRS2+yy8D9zKfzMdUcXDsRQ7QMMGiMao=;
	h=From:To:Subject:Date;
	b=GU59RVzXqMk8aIatILswMZg/D483q/Rq7uDjggFdpU4gX7BLYUwjI0YsXk/WzwLUt
	 cuibx1zqcBc2sMjduX7ufvfA40bK8Onm1hZ4hVb5yk6bOX7y5mYi3REQOhJZ2Qq4sU
	 6GO1jDglA1vmHEDVw7NnW72AEaD4C94GqrQ9f0Lqy5ybSWcAWf2/dpeS6aFsuoLnA4
	 hkS9TN4sDl24eeF1FLT+Pa3VFgAjIEEOeZp4NDrEB0cNevs/0JtocGM+smj2vUXLmb
	 Wfi2mI0BIvawh6swlaRv3CW9przNeW8kBoFhQDvthI6e7EfWjj3PAsaNlhdXS6hPFL
	 lMadPBZNNm5CA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v9 00/13] Add support for storage element depopulation
Date: Sun, 15 Nov 2026 23:50:02 +0900
Message-ID: <20261115145015.938426-1-dlemoal@kernel.org>
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
  zloop: keep zone write pointer and condition consistent
  zloop: fix zone reporting consistency
  zloop: add storage element emulation
  zloop: add degrade_element control command
  scsi: scsi_proto: refine the definition of storage element health
  scsi: sd_zbc: always revalidate zones for disks supporting head depopulation
  scsi: sd_zbc: define storage element management operations
  scsi: sd: fail read commands to offline zones early

 .../admin-guide/blockdev/zoned_loop.rst       |  33 +-
 block/blk-zoned.c                             | 450 +++++++++-
 block/blk.h                                   |  14 +
 block/genhd.c                                 |   4 +
 block/ioctl.c                                 |   4 +
 drivers/block/zloop.c                         | 841 +++++++++++++++++-
 drivers/scsi/sd.c                             |  23 +-
 drivers/scsi/sd.h                             |   5 +
 drivers/scsi/sd_zbc.c                         | 538 ++++++++++-
 include/linux/blkdev.h                        |  64 ++
 include/scsi/scsi_proto.h                     |   6 +-
 include/uapi/linux/blkzoned.h                 | 106 +++
 include/uapi/linux/fs.h                       |   1 +
 13 files changed, 2007 insertions(+), 82 deletions(-)

-- 
2.56.0

