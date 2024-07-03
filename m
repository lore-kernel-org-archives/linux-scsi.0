Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8390D1C68D;
	Wed,  3 Jul 2024 23:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720049975; cv=none; b=HRA0yXiIPAM/ejokMBbzZ5YKC3eJcHkgK7n4NwHKI0OdY5VL5vHkNbKGHi8YYrt6RKDKUL6MObcsHX4oOraxyIygVLXl+l8Fh777VUAUattssv83Pev8paqOsCnm6iLzAnxPPp/81WBjltolfwu9xrH4iB5uf2dkTNzAJh43sg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720049975; c=relaxed/simple;
	bh=70oZk3WGpCc2R8nFA9z2IwUmbQv7wspIH1lOKMc/FmY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=QCWLguf5Ee+GiFHteEdtof0S7v7oJ1qdFlklqW3udQEWcsrew6uvW4PmGxLILUYl+JmGRTBShXbkPcxrYYC4MjQg6E367qbnwqfs+9y0weJSaeKcIR0UqiRJwgWrc6U+wW7LZ2mXyk453Y+8C7xyWl8OiWVc8MyV/w4iKzsBZSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YaBcf6Ln; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YaBcf6Ln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B95C2BD10;
	Wed,  3 Jul 2024 23:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720049975;
	bh=70oZk3WGpCc2R8nFA9z2IwUmbQv7wspIH1lOKMc/FmY=;
	h=From:To:Subject:Date:From;
	b=YaBcf6Lnd2MZyeVhF2AvgfefkjjxtCc9kLkHPzQ+ouW9dFheT415RrJ19oFWwXn+3
	 tHaFXMPBQ6WBqQXPI9a6Ufph/E0SpDALbW1ulAw3D9pOlRvMD3ClRfsTEiU37z31NX
	 HSzOzbWkrlphO8Yu9LzcbWyfZ6m1SamRN58D0ZKbT+gxDB843MdVGk51GpEAnEXh1L
	 aodPd9FXrw7j80JVgA+Wt93jsGSbPETAlUSavhfax+uEsKmwdGIEuviKMVM2uAEOOc
	 gdsTxDa6OYxHyZAMzGIOQhn38p/9DiPEecp0bkvEXjj5+Zo7R8yxcspgcD2/wyBSlZ
	 M8mXCeSRlFbzQ==
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
Subject: [PATCH 0/5] Remove zone reset all emulation
Date: Thu,  4 Jul 2024 08:39:27 +0900
Message-ID: <20240703233932.545228-1-dlemoal@kernel.org>
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

Damien Le Moal (5):
  null_blk: Introduce the zone_full parameter
  dm: Refactor is_abnormal_io()
  dm: handle REQ_OP_ZONE_RESET_ALL
  block: Remove REQ_OP_ZONE_RESET_ALL emulation
  block: Remove blk_alloc_zone_bitmap()

 block/blk-core.c                  |   2 +-
 block/blk-zoned.c                 |  88 +----------------
 drivers/block/null_blk/main.c     |   9 +-
 drivers/block/null_blk/null_blk.h |   1 +
 drivers/block/null_blk/zoned.c    |  12 ++-
 drivers/block/ublk_drv.c          |   2 +-
 drivers/block/virtio_blk.c        |   2 +-
 drivers/md/dm-zone.c              |  50 +++++++++-
 drivers/md/dm.c                   | 159 +++++++++++++++++++++++++++---
 drivers/md/dm.h                   |  10 ++
 drivers/nvme/host/zns.c           |   2 +-
 drivers/scsi/sd_zbc.c             |   2 +-
 include/linux/blkdev.h            |   5 -
 include/linux/device-mapper.h     |   7 ++
 14 files changed, 236 insertions(+), 115 deletions(-)

-- 
2.45.2

