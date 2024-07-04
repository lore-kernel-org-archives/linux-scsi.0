Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13F2747F;
	Thu,  4 Jul 2024 05:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720070900; cv=none; b=GriPrJ9Lr+HcCskFB1W9vCXyI7dmG0wdLqvWoqkTz63eVwCn0BHFRqto5Dv2cN3pWu4QEDlGYJlorSkBou8fEsaCW9vl65MMHIvXKZRKpi/qFuO79Aq1gUmOnDAMKkCAc5ffdH1QeeqG9FyuGO/+x15mJ+BYIxDEdWQaO7IjPPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720070900; c=relaxed/simple;
	bh=WImCDRKhkng1eJ1vgAYqhlhW1Zx9yn+bVTPAFxEVhpY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=mSZdzsSSLq2BxEbtT9V6UFZ9J90HKRfr+ZU7KZgTEWoFvPLaE/cdSHIrOikK09nriYYFl+0L6GbTzA6YRe7W/0SVyR7aHEbSSHAUfB86Jq9Scxo2BxsWDj5O+FlMx9t7OxzjGGuKa2lLcwVAirfOyI6EvLzKH+q1sv6jZufHxoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=er1Xzpu7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="er1Xzpu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACB0C3277B;
	Thu,  4 Jul 2024 05:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720070899;
	bh=WImCDRKhkng1eJ1vgAYqhlhW1Zx9yn+bVTPAFxEVhpY=;
	h=From:To:Subject:Date:From;
	b=er1Xzpu7oUDo9ukLhHd2hFrjfi6vUjbScTtVblr0a4LaBszs3RYBjqA4ddo+2oa6c
	 hhaWxLNyRgv2IkQYP3gMAgCOZ05df1uCihnxrWdKKH5kBw18J8P5LP8IptuK5QLiV1
	 R+5UI1cxvuQmb22VcA3GsWPsV+p1h8EBWTrErekpMrFrSzgiPjV0VbXk9EWiaLMxZM
	 L90pLrP3q82fVXEI0RWzqy1SPQqij33up00Io4edCMkd//CjOytMCq2ztems0Z2lmT
	 T8zz6rzzmDUj0qvXBcXJaBDMqX4RDnHf3DVfQINKfRcaTD8maBMQfEqTMLXpCx+HZ4
	 UpVC1b+MP3cMA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 0/5] Remove zone reset all emulation
Date: Thu,  4 Jul 2024 14:28:11 +0900
Message-ID: <20240704052816.623865-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Jens, Mike,

Here is a set of patches based on block/for-next to remove the emulation
for zone reset all from the block layer and move it to device mapper.
This is done because device mapper is the only zoned device driver that
does not natively support REQ_OP_ZONE_RESET_ALL. With this change, the
emulation that may be required depending on a mapped device zone mapping
is moved to device mapper and the reset all feature
(BLK_FEAT_ZONE_RESETALL) can be deleted, as well as all the code
handling this feature in blk-zoned.c. The DM-based handling of
REQ_OP_ZONE_RESET_ALL can also be much faster than the block layer
emulation as that operation can be forwarded as is to targets mapping
all sequential write required zones.

Patch 1 modifies null_blk to add the zone_full parameter to initialize
the sequential zones of a zoned null_blk device to be full. This is
convenient when testing read workloads as well as zone management
operations as that avoids having to first write to device to make the
zones full.

Patch 2 is a simple prep patch for patch 3. Patch 3 implements the
emulation for zone reset all in device mapper core code.

Patch 4 removes the block layer based emulation and modifies all drivers
setting the BLK_FEAT_ZONE_RESETALL queue limit feature to not set this
feature (and the feature is removed). This enables the use of the device
mapper emulation.

Patch 5 is a cleanup of blk-zoned.c made possible with patch 4.

Changes from v1:
 - Fixed typo in the commit message and long comment line of patch 3.
   Also removed the stubbed definition of dm_zone_get_reset_bitmap() in
   dm.h as it is not necessary.
 - Modified patch 4 to have submit_bio_noacct() treat
   REQ_OP_ZONE_RESET_ALL the same way as other zone operations.

Damien Le Moal (5):
  null_blk: Introduce the zone_full parameter
  dm: Refactor is_abnormal_io()
  dm: handle REQ_OP_ZONE_RESET_ALL
  block: Remove REQ_OP_ZONE_RESET_ALL emulation
  block: Remove blk_alloc_zone_bitmap()

 block/blk-core.c                  |   5 +-
 block/blk-zoned.c                 |  88 +----------------
 drivers/block/null_blk/main.c     |   9 +-
 drivers/block/null_blk/null_blk.h |   1 +
 drivers/block/null_blk/zoned.c    |  12 ++-
 drivers/block/ublk_drv.c          |   2 +-
 drivers/block/virtio_blk.c        |   2 +-
 drivers/md/dm-zone.c              |  50 +++++++++-
 drivers/md/dm.c                   | 159 +++++++++++++++++++++++++++---
 drivers/md/dm.h                   |   3 +
 drivers/nvme/host/zns.c           |   2 +-
 drivers/scsi/sd_zbc.c             |   2 +-
 include/linux/blkdev.h            |   5 -
 include/linux/device-mapper.h     |   7 ++
 14 files changed, 229 insertions(+), 118 deletions(-)

-- 
2.45.2

