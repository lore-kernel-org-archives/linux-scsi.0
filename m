Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795208814;
	b=dfnst/b1w58VzW+TmwXIlYSgUOKgnIt/UHsK6Cpd9xWUJwwByKgfh9lY2M+a+G1BMloG
	 iJv1hdIYwS0Yd7K2otI0tXOcV0uoK1hMc69L0bwuXufmb5ubZdc4vfF9XzTDTL1V0PN6K
	 lT/Ek9gE3RdtZ9O14q24kwTFkgtlBlWSLqO1LEKJVapoAHrkFE8cCqkGkjzmJpwYLZyKi
	 a92cs7UfFTM+9RtXfWVo1WlibFPYCEo7uHR92IjLyEUJFcTew5xdHkVcRKWGeecYGM8fa
	 HSATgF4kJhgslZZPdU2hBMtdQ5CB8Lri165LG0s0zr0eEktpteWB3ucTmJGbxDuCbBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795208814;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mo5GwVgfK18iqXRVbQY7NIWQqh5s4EqnC9PxdI0u1Oo=;
	b=fhf6S1o2f5w9F6JIvSmLr8HqBjS+f41Z5snQNYtsXWr20nYaivC5pOChk6iYtTumk4aI
	 XSi+61JwZKa8Tbqsp6C8GmBltm2G94tSPRttXMyORGZaezoDpFSmj4JtjIUDOCACHzYve
	 k82F7zcJuIR0ezURkkXE40TqbI+60ZSBxqvfKpEhh42grteHaHT0M7wbvothxeCug9tVm
	 at1SMYj7SE17BLIWCqqTIJWxQKyiUpVZCeZZVvIc+YGyP1lCjH15Qw9vv0kOdfr1Dc3O9
	 hufVLGR1terA4zJnOwfrxdTL0H0/tJCCod3VpT8fH98y20Y4Jy9aFJcWKg0aeIYu9lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="TXMlb/pN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD7D606A69F;
	Fri, 20 Nov 2026 21:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TXMlb/pN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BF01F000C4;
	Fri, 20 Nov 2026 21:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795208813;
	bh=Mo5GwVgfK18iqXRVbQY7NIWQqh5s4EqnC9PxdI0u1Oo=;
	h=From:To:Subject:Date;
	b=TXMlb/pN8JLS3NkpqVC2rnIogXVpxStteAAV7nN1D3j/AqS43O2HBTyqTYqCGJuOs
	 lk9itZ/3IR6X7wWYZBZVjs3Im0slgT55S16xHWsNa339VFtwStv22LfAskYuyTc18o
	 ASUaJyJfuKGarbu69IxICqIJmq3WWc2HV/Z0AWBLq4zd/5L8EzoPnCOXta04b0eHJ0
	 sgdlIeI75ME0NBOQ3B2ZHn31a8KpT78B2oyK7ng2L55JcB+OUrgEzmjvhuEdGOxZO/
	 UALY22Vhs0gnxz0MdcHIitQ4ImOrzXIqZ5zrsP9CH8ihEcYw3hK+cnBLmCOjXdLIlt
	 hOH+AR+Dl7q3w==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v13 00/13] Add support for storage element depopulation
Date: Sat, 21 Nov 2026 06:06:38 +0900
Message-ID: <20261120210651.580511-1-dlemoal@kernel.org>
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

Changes from v12:
 - Modified patch 8 to ensure that zloop device removal waits for the
   completion of storage element removal and restoration operations.
 - Added review tags.

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
 drivers/block/zloop.c                         | 946 ++++++++++++++++--
 drivers/scsi/sd.c                             |  23 +-
 drivers/scsi/sd.h                             |   5 +
 drivers/scsi/sd_zbc.c                         | 524 +++++++++-
 include/linux/blkdev.h                        |  64 ++
 include/scsi/scsi_proto.h                     |   6 +-
 include/uapi/linux/blkzoned.h                 | 106 ++
 include/uapi/linux/fs.h                       |   1 +
 13 files changed, 2054 insertions(+), 129 deletions(-)

-- 
2.56.1

