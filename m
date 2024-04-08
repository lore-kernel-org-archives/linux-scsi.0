Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B718381CC;
	Mon,  8 Apr 2024 01:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712540533; cv=none; b=LbeshLh5q/+CMMFaTAZOCEklEZ9tB95PBTCmrSYPxkUMLLsHW+bkVSw9FxghH0dlY7cwu36G517vu4JGNrKD4gzTkADM5Q6+SwNi/00KSo8Y8YO/V1C4IlxsyAVmSGcV0B5NxoZG2Bx+cNweJSKn3y2oJKtk6VMDHZHyQlGcx/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712540533; c=relaxed/simple;
	bh=+ItUMOryXXhzBX320MW1H6xaMoPOl1/Lr1NZ1z2eEiA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWnZ42rbC/dhsOfyXL6oKeSJsjecv0B+oZB4pQWDUuQdpJDzZIp8+CVoXuZwom+AYMogsQ44WPplt3ZVHih6qMGAffCI/w8dkPnYVMJELedQT7cDETzQMiLmvZtv/P0eHi654DP/IONTHS6pTOPnRe8gw2TsoFjBqTgsgkYIMN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Anle1WMi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Anle1WMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06EACC43394;
	Mon,  8 Apr 2024 01:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712540533;
	bh=+ItUMOryXXhzBX320MW1H6xaMoPOl1/Lr1NZ1z2eEiA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Anle1WMi4b5Q96ApPdUZ09A/TRlgYf+0U4y+N3YxEyWJFqLxHXq3EfB3ZoCKGBo9m
	 3Y0uFA80xmqPH6YfaTNNTQZP+dudXMqjKN/4TTdHP+bmaLTkHnw/jqtNkUc+Y+dOfS
	 5cqUwgUL94lkcQHXcZ5L4z43ij4jDL6oPKntFnYgkATZO7PIiKs0IeA1NkOj7m5hPd
	 bmC9wOMAy2ENGo7Q5Z+wMdijc6hbzKQxdWfmRcgiVabq04ORh/XwFTwPM9JKDsYumd
	 Bx2Ia32DbmGzT0mbUJxsZOrl7PsYqGcRhYRXdAYK7kAh/OUPdSVB1BC1V7IyFdxqxb
	 8Aht4XDpwYuhQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v7 23/28] block: Do not check zone type in blk_check_zone_append()
Date: Mon,  8 Apr 2024 10:41:23 +0900
Message-ID: <20240408014128.205141-24-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408014128.205141-1-dlemoal@kernel.org>
References: <20240408014128.205141-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Zone append operations are only allowed to target sequential write
required zones. blk_check_zone_append() uses bio_zone_is_seq() to check
this. However, this check is not necessary because:
1) For NVMe ZNS namespace devices, only sequential write required zones
   exist, making the zone type check useless.
2) For null_blk, the driver will fail the request anyway, thus notifying
   the user that a conventional zone was targeted.
3) For all other zoned devices, zone append is now emulated using zone
   write plugging, which checks that a zone append operation does not
   target a conventional zone.

In preparation for the removal of zone write locking and its
conventional zone bitmap (used by bio_zone_is_seq()), remove the
bio_zone_is_seq() call from blk_check_zone_append().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Hans Holmberg <hans.holmberg@wdc.com>
Tested-by: Dennis Maisenbacher <dennis.maisenbacher@wdc.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3bf28149e104..e1a5344c2257 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -589,8 +589,7 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
 		return BLK_STS_NOTSUPP;
 
 	/* The bio sector must point to the start of a sequential zone */
-	if (!bdev_is_zone_start(bio->bi_bdev, bio->bi_iter.bi_sector) ||
-	    !bio_zone_is_seq(bio))
+	if (!bdev_is_zone_start(bio->bi_bdev, bio->bi_iter.bi_sector))
 		return BLK_STS_IOERR;
 
 	/*
-- 
2.44.0

