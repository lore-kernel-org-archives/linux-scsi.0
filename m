Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9F78615C;
	Tue,  2 Apr 2024 12:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712061582; cv=none; b=KT/Y1JN80MQKdIWwhu1CoxvPkrKWPrRpS9+AF8KYBJv2Zfi7DTeI3SofZgOkq/Mk0pfQQF+xL4uZVTNnN7f857kUw6+enCZPw2kMDUJuItOPlgrSQ7Lmb8i6h3hZTK0MpuXglunMvfj1aJJVJryaLpLLiOyjFIM4xvq3/ZjuLZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712061582; c=relaxed/simple;
	bh=swSQmLVcxXZAAaPOdJC4n8okb3JMRstty8OESc7Mb0Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYWfLAP8S8zKwUP1aBf1WTX0qRgZZFwQlTxDFC6lCZyhXZPka4u6VimVf6mcnM4lOfthyqq0WlG5PnOjz/9qmh8DCSPUI3WTudNbyPRERNPr/nrmx3o416JBYlZYdFzlNgMaGbOzIIg82aaVifHqevxQm5/ACjEKbbD7Hf6usQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A5hURzze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A5hURzze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67723C43399;
	Tue,  2 Apr 2024 12:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712061582;
	bh=swSQmLVcxXZAAaPOdJC4n8okb3JMRstty8OESc7Mb0Q=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=A5hURzzeQGcd+l1ymrBhuHcqB81VC0dBnQICFZmfrNYI1uHlRt0t5rwh86uP4KULJ
	 uGgHvHi1nAsYbEqd+ehowcO499P5J1zqiz0roQ+p2ZqRzTnwYlHOA/WOKh+sUpvRA6
	 zSNPopUHbKeY41OxZqYLfdXFgHEtGJfOmTNNk0eT2Dpu0HGC3zegiFjQn0lwZtuOFa
	 N3lZBla8TrhdqMdJJJD0K9AoFeChcctDN61/bmL4EEyOeE1bE7R4Ig7nNeNLoFSoSx
	 XupKrehgtA6oBWzzy6B5fVuogPLCQq3EQmSV8UoT7Va8c9xXB43AJzIzsKySUwAgn9
	 kpqpRaefmA1YA==
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
Subject: [PATCH v4 23/28] block: Do not check zone type in blk_check_zone_append()
Date: Tue,  2 Apr 2024 21:39:02 +0900
Message-ID: <20240402123907.512027-24-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240402123907.512027-1-dlemoal@kernel.org>
References: <20240402123907.512027-1-dlemoal@kernel.org>
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

