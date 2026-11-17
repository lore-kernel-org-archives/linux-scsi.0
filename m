Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931062;
	b=z7apEmRnxiBxjqJVCgR8QPK/VFdjuPkceIbhUbBH4kIjlCJjtdzMTNHlRuYt6kNQLwkD
	 vh9xBu9jCbVEuEjCajKl60BsTNbyTFf0/2R+utZrwROaptddAlsyVDguYPrcO9kaRvsSN
	 yAV4iS9Qds60iU0ivWWtIO5NI1MBsP5By9AKpzcFXQv8TwH8G4Y2o4I21iTS80PqjFNSE
	 /qEthxtxLEm+/ALZdawIP+xtqFGQz7AqLr2RGam/P09kM69coQwUrLELtdp56qj7ufu6q
	 vFUYWOKxdyMVMJQzgpYEFp0gEWwCc36TyUPrwErQDrsyCX8EzH8ovda+1CG0/GWi5+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931062;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jhqJUIEyiXztC5jmGUPOhHFpC+HkKl4r/9Vqb5SnhYM=;
	b=dOTG7fzYsjVhCvL7wWMdemSIu5LkptPDbz7MIzSX2wtkbPEMkT8dQp7B27mGeRmMmODz
	 evJgpr/SLVKYWIQ5i570NINgy13aTIn+sBwsaQOlMoZziaV/MrhX1PFd981iNYnGl/zNP
	 mzXnMjLFHMgDdhcdQeSJFr3wK6HvsxKIOchpJTbtmR0ewgujcy3jpSvlDlTZSJX6EP3/v
	 IzmkoLStj6JBKEiR8ZM8LaNnFerBbf73zqjSCzrVZ63zRpSpXEd/qZ9CEbt4fBxLQWqdT
	 sYmHtk6HfdHGT4Fli1Q7XeKgnInTcJljc6ozx4GgYz9try0EmQt4a5XJf+MIsayTI7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UOOyiLIm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538A1606A331;
	Tue, 17 Nov 2026 15:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UOOyiLIm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288161F000C9;
	Tue, 17 Nov 2026 15:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794931062;
	bh=jhqJUIEyiXztC5jmGUPOhHFpC+HkKl4r/9Vqb5SnhYM=;
	h=From:To:Subject:Date;
	b=UOOyiLImOJc50XpnXf+NUK23HxhQccTMPX/Y5OgQ1Ax+eck5NJ3B1F806JhzVomPt
	 hLcWVYoNw0cKrbyh/u5MYbMVOKt1ScrMXSGCPlWkY5UYHQ+d3+MhpWmkSv3Y6E2+h+
	 BnonvE6qjVFNMwjvw+X9kOgBe0nOfJ9L8gx8dHrWrsdkinHzUXYJN/+GSTiuJdYpkQ
	 4ySQc308bkRPKiryTgyxThHZyWop0IYq2eI78xxSU9Lb/PzPISEh3Oz2Y50IcbbR1d
	 V7j8p1MwCE7UY7/6tTTEQhOkmdocYYL8cz/X8VLBLffdZJdede1lpFQrF5gBVr0bDE
	 w1YFERg7l4I+Q==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v12 00/13] Add support for storage element depopulation
Date: Wed, 18 Nov 2026 00:57:26 +0900
Message-ID: <20261117155739.304506-1-dlemoal@kernel.org>
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

Changes from v11:
 - Addressed two silly mistakes pointed out by Sashiko in patch 8 (missing
   EIO error return) and patch 12 (dead code left over from previous
   version).

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

 .../admin-guide/blockdev/zoned_loop.rst       |  36 +-
 block/blk-zoned.c                             | 450 ++++++++-
 block/blk.h                                   |  14 +
 block/genhd.c                                 |   4 +
 block/ioctl.c                                 |   4 +
 drivers/block/zloop.c                         | 919 ++++++++++++++++--
 drivers/scsi/sd.c                             |  23 +-
 drivers/scsi/sd.h                             |   5 +
 drivers/scsi/sd_zbc.c                         | 524 +++++++++-
 include/linux/blkdev.h                        |  64 ++
 include/scsi/scsi_proto.h                     |   6 +-
 include/uapi/linux/blkzoned.h                 | 106 ++
 include/uapi/linux/fs.h                       |   1 +
 13 files changed, 2027 insertions(+), 129 deletions(-)

-- 
2.56.1

