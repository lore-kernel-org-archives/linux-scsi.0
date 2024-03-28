Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E3D3C473;
	Thu, 28 Mar 2024 00:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711586695; cv=none; b=O6b7szdQ0YWRz0ahBdxmuizfqnZmAhP802AFN1qDHrUw7o7OsGhDxTyuA+DcLHCsCT0aruIbt1V7S4fu5jYOzP/Vx40UPZ5VULX/x+dKTQuFX4/Wq1dTI3A2qas34D1m8/65jLft2t9wenIYfdlQH3lV5ZFPrlBaJrwxSThU5T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711586695; c=relaxed/simple;
	bh=SDWELck1RoGv2VSJxikvYBXlMcfGyvAzaBGySLOyeYQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqBECfTQGSZbaD/Y3Q+F4a9YPAMoe8ZD3IQzWwG1bT7QlQh3bJlZsyuXOTCOgZj6XEgkeUikmUDGnMnFo5k3V8oGxkPVJFCSbffl7vx52e7zm69T5yFOcTNv1F+hGzBaPKGkq5G7pQviXtDHJNB3Xe+cr8xtooenkzbVLl2RYPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UtLiGjhX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UtLiGjhX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC58C433C7;
	Thu, 28 Mar 2024 00:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711586695;
	bh=SDWELck1RoGv2VSJxikvYBXlMcfGyvAzaBGySLOyeYQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=UtLiGjhX7AvMYzjDfFZ574opBQKTuiGSVHa8HUFdQRks1nmKYrwiclfJWjCK4rHgF
	 3ka+LaBu08t+pri56NnCyZi++BT4E4O5D+vbvAd6cTkkBQ57jXABwUQols6NoRKVjB
	 4GmQTs20RPIc/t3eTB9CcQ8mhxi4MxCerYzCbS8XaToCvmFDgEESyNi41712rPG+lG
	 JaWbqWJi9c4rUdIbd4sK0U5m4/wwX4AgY2mLq5zVv8yLr9HYsi/mSi6P/Tuu0yMQBp
	 HXu7wX3iFKtgY2h5NDSaY+cDvA/ufODF87BJwzf9eAtZd4mQ1Kyq0Ny7t2pEKMOBZE
	 bP1E/b+nbXU7A==
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
Subject: [PATCH v3 25/30] block: Do not check zone type in blk_check_zone_append()
Date: Thu, 28 Mar 2024 09:44:04 +0900
Message-ID: <20240328004409.594888-26-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328004409.594888-1-dlemoal@kernel.org>
References: <20240328004409.594888-1-dlemoal@kernel.org>
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

