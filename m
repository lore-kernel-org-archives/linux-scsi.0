Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794865025;
	b=lEcaVhbrDPgzcXHEDJlrhNwckMnnrEWZf0C7e3EUB+m32dWxCPmt0GH8b1xZNUtKQy4W
	 UDG5zVOCGA2F+prNnXUNUjF6BCb1GsGduXvlJgio3u+n/zh5CsS+8B/RtFLrlX5cVbvQX
	 0xapCXbhY6kN3qq4hfie2nDQM+5BVaKL7Gl9P4nRHTe+rptQfI+ntOZ9jNorObzhdWBpv
	 3ue7mfT0R/kB8YPQ6r1dspbd4O8PkSKYxY7LGhMlTeepcGPQR/AfTV3YMFde4osb0ujK3
	 oLglSSWpBBP9+zmr2IjvlrwKqhWAdEOmIEIW3KePjnb5+EK3Y2YCXy4K+xiGvh2E6SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794865025;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2mgFCVDy66Wm/1z3BD1B3z4E8vLmizdbiZSMxStpVtQ=;
	b=1pQXHTMqHBVDqXW1z9SJEVtfeMoGc0VuNEDZIDiTix9jl2NI/mhdvc3DtAkzI4JEf2Wg
	 U/Q423NvuS2BQ6uzMZOO1gB6h3/qL4nt4x0RS82g6GoGKEDmu9TDMhtcXjj3hMtjgQsX1
	 8IHhuINVqU/d2+Y5d90HZvJUeQ/lkm6bRoF31kDHi7efj/D1JUqzStx8UDvMwXYuqcz4a
	 eldLYOqatoKTodwfuQiEjh2I9oTGzH6xNzxu/4MOKXRPp/Vi0A2WqMlbCNY9f371SB3eG
	 t1JY9QCRgEThDk//5skd9QraM+c2NjSCkzGlsbiHnb2t+Dyn4nGxwmIwmvwKP61WtYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BT2wmtps;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB8E606A322;
	Mon, 16 Nov 2026 21:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BT2wmtps
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0031F1F000C4;
	Mon, 16 Nov 2026 21:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794865024;
	bh=2mgFCVDy66Wm/1z3BD1B3z4E8vLmizdbiZSMxStpVtQ=;
	h=From:To:Subject:Date;
	b=BT2wmtpsHXKCjbG6jyR9WCNkETTMf9Kyg9kXQvobfIExPugW1UszT5IGQxPPa++bI
	 pxkCd0HUjtpBC6HnmJuSkIcbY2DaEF7jXQkw4HzjOuN0lKGuCXmaXrwkpgkr9mOhHd
	 HFWJZ131LguDLvsSpkWMoOYOTEBS8fyZx8f2meYMvsZJiiiAbhdnpHW6pMytQ2w7dW
	 w9iZCL8p4odvlHsAeTagyE6alNCFjjRTjH/lPYIwAMt+7cOYQkdenfqscvEtsYm+p1
	 4wSKj89f5Lqvoq+3UR4lfKRKGwhxugsQ95le6CBV87igrjSrMxdB//3+EPVlKeU/Ml
	 qekHglEG9G/og==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v11 00/13] Add support for storage element depopulation
Date: Tue, 17 Nov 2026 06:36:49 +0900
Message-ID: <20261116213702.225970-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.1
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

Changes from v10:
 - Addressed sashiko comment on patch 8 and 12.
 - Added review tags

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
 drivers/block/zloop.c                         | 917 ++++++++++++++++--
 drivers/scsi/sd.c                             |  23 +-
 drivers/scsi/sd.h                             |   5 +
 drivers/scsi/sd_zbc.c                         | 534 +++++++++-
 include/linux/blkdev.h                        |  64 ++
 include/scsi/scsi_proto.h                     |   6 +-
 include/uapi/linux/blkzoned.h                 | 106 ++
 include/uapi/linux/fs.h                       |   1 +
 13 files changed, 2033 insertions(+), 128 deletions(-)

-- 
2.56.1

