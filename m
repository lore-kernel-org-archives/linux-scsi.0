Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794217907;
	b=GtUuLLmnsvqc6T4HDbNeZtkfuqmyOsK7cCQ70yzOWXZuNASEVP1JBmK/SyWAzzg2kWjK
	 2ac+BPudCUGIq5igcHAOdB1vBY4OdOth5OSDmXM+/1GCAXJ294GgRecbllD/GeeyP54DK
	 RSzioU41PoC46Chu1sIjdIjSY+Egb50BKlhxIXnEsbYjNdkZw/s4eRE4SksWU5l4wegyQ
	 jkw+uJ/PfKka0RnKv4qS7fC7SmOOzLh3YHMvCXSB0rvq1SKYe6lfe0PaHCBXXqLZRGYJS
	 uJbFmEeSZl0herkJuZ9R0Y06npiAVvzgAK18VmNtoCSIg8EpgFs6QMzGbssdjPcRJ5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794217907;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=38lNlwu/Qek1UI3mbF8CWT4oX/5tE1VslTRAVaenTwM=;
	b=GdgZjX9DOvEIdAPxi4wWytci3h3z1KCRwWt7hAfWrVsCsph2ZPeX1pd74FsoqDbU6XGj
	 eNSun6qEtVWzWbeWOduJPxpItWvgxWJEcLnQxxiaAnzfBDrQQjR0iL1i3TzBT+VeJfSaY
	 tjWCho6EWeQthtfEBKzqxJbUw13RFbtWwYvIeXDqhMPO+hSujGEVSTiPPmr43uUwHBvje
	 +s9kgEAmxve0hcRZQm+SDk49KG0h1XmtMbMi9y70Fhrqn7W2km94UndEKCZWD2sleE20w
	 Pubg0Oo+KNRowBtM0oFSUfxdgazdTMDIVQQuWu0S10dRSM7iaF0FO0/UdToGqRsqRlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hGCaPrMs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63013606A325;
	Mon,  9 Nov 2026 09:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hGCaPrMs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA7F1F0089F;
	Mon,  9 Nov 2026 09:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794217907;
	bh=38lNlwu/Qek1UI3mbF8CWT4oX/5tE1VslTRAVaenTwM=;
	h=From:To:Subject:Date;
	b=hGCaPrMsQ5kwzSOMuNYBe/nWKCB+BG0QichXkIwk9TNCGwQZubHpFnXnvT9S8V/Jv
	 KBfRra34Jyk0re/RXj1WkOeyua+TvvIM91zBWVe5bNtUNR1s6PE54Tvegru7Oi5epg
	 FU+bx8Xf8mcHMzso9q/WRFVhJYPTNjjhbd1oBVArL4CLKJdyBBWbsF8TAwqd4oWSye
	 ZKSXpD3tP64p+Ro/5xVfAfVQHI/1YAdCQyBJrYpSXJdBmSX29aRzo2YLjydp+AA2pd
	 RzUgUIJiCe8if7ZBtxgbZfbBq+QrBY82VosfLKONkUfJ5T5fjP99xAZk1m2N0kX2Tz
	 bT8py7KGR1LuQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v8 00/12] Add support for storage element depopulation
Date: Mon,  9 Nov 2026 18:51:32 +0900
Message-ID: <20261109095144.819709-1-dlemoal@kernel.org>
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

Damien Le Moal (12):
  block: introduce disk_zone_is_offline()
  block: refactor blk_revalidate_disk_zones()
  block: allow dropping all zone write plugs on revalidation
  block: introduce storage element management
  block: add storage element management ioctls
  zloop: fix zone reporting consistency
  zloop: add storage element emulation
  zloop: add degrade_element control command
  scsi: scsi_proto: refine the definition of storage element health
  scsi: sd_zbc: always revalidate zones for disks supporting head
    depopulation
  scsi: sd_zbc: define storage element management operations
  scsi: sd: fail read commands to offline zones early

 .../admin-guide/blockdev/zoned_loop.rst       |  33 +-
 block/blk-zoned.c                             | 450 +++++++++-
 block/blk.h                                   |  14 +
 block/genhd.c                                 |   4 +
 block/ioctl.c                                 |   4 +
 drivers/block/zloop.c                         | 786 +++++++++++++++++-
 drivers/scsi/sd.c                             |  23 +-
 drivers/scsi/sd.h                             |   5 +
 drivers/scsi/sd_zbc.c                         | 516 +++++++++++-
 include/linux/blkdev.h                        |  64 ++
 include/scsi/scsi_proto.h                     |   6 +-
 include/uapi/linux/blkzoned.h                 | 106 +++
 include/uapi/linux/fs.h                       |   1 +
 13 files changed, 1933 insertions(+), 79 deletions(-)

-- 
2.56.0

