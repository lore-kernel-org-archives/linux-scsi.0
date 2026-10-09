Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AD545C6E3;
	Fri,  9 Oct 2026 09:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791536989; cv=none; b=dA6fDxxJ7se0vCagZQVaU8JXtwpGz1GDZXig6UZxj8+/Wc3FNb8BDomP8Ho5dPcejNqwcZbzCOUQZQkO8uZWyW/I84qSBTyy1lWK7CRnrlZLRulhgv1AAKCA+4ly//039xIYWFtRdZEf8ixjKjvbXUFqNY5/uSeLHqoy3M48FBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791536989; c=relaxed/simple;
	bh=4pHzXnlVXH6S4YAwE/EvlFhpeomM+qHfr6V2w0CZdfk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=QmLTzIO6YsN4WjIUOwYuLLjUUaNDq506BAfcCSW6ub3p/2UP4pyeIIPbcBeqjPpbpGa55/aX63puG50Wp587wn1AlcS6Kj/nPKXrRO/wxoqz5oGhc4CCQPlW8rSZOpXZN4qAQDflN9n/ifQzld1gXPffl31ZsyVlNI1DNVLioC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KGUUe8ZO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KGUUe8ZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C121F000FF;
	Fri,  9 Oct 2026 09:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791536987;
	bh=MrlE83UuFh2wTN0giYzBXuMAuH+ZutDH17noWzWUrJA=;
	h=From:To:Subject:Date;
	b=KGUUe8ZONzDJh6BHteZyXDcs98tKhNKUCUAh3/3P4UD2XQVAqmqzkwH9KvhwKuGXO
	 rikq8/CcXghaXvaxMeOrz9tZ8JDlVsK0u2WXxxRc/Ad3CzQUFSffhR1sLCs883ISan
	 ie4hlBxRGlct7J4Hlhy+5i+t/IeIQNI9Jbx/u6ru1ZWXuwTaAHdc7TzQ+f3mKtgIx1
	 a/v9jvfHuo/OrsawCQ+RR7sdGXtaw6yxTOPTXetU6jmYjQyyIZWYIbeqWU/oWodmTf
	 LfiZepfmaBuZOxgLA3W0hMZ0VO6asj/YEDQMkF441pfEwX1f0DZov4jvA5eBz4WnTx
	 zbJaW0URyzkqA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v4 0/9] Add support for storage element depopulation
Date: Fri,  9 Oct 2026 18:09:36 +0900
Message-ID: <20261009090945.1504194-1-dlemoal@kernel.org>
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
 block/blk-zoned.c                             | 486 +++++++++++-
 block/blk.h                                   |  14 +
 block/genhd.c                                 |   4 +
 block/ioctl.c                                 |   5 +
 drivers/block/zloop.c                         | 708 ++++++++++++++++--
 drivers/scsi/sd.c                             |  11 +-
 drivers/scsi/sd.h                             |   3 +
 drivers/scsi/sd_zbc.c                         | 259 ++++++-
 include/linux/blkdev.h                        |  31 +
 include/uapi/linux/blkzoned.h                 |  82 ++
 include/uapi/linux/fs.h                       |   1 +
 12 files changed, 1535 insertions(+), 77 deletions(-)

-- 
2.55.0

