Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AAF7181B91;
	Mon, 25 Mar 2024 04:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711341939; cv=none; b=rEvzG2qIdk6IYnLgOI/8iZUftxMZL/ZSWW3whkOq5zHkZSSbfPjT3up2ISgSh35dD0eWD4rCp0BllyfkFpK6sPPIcIRwRi/IkAbLeioraNxklD2QbG3cKP6IKrojGxOhYVM0tq5zoLGaFPgePmMMBB6Haq6Z1Z6kZ+NEWOUizN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711341939; c=relaxed/simple;
	bh=3ZvoBtiQeBGYm5zSAkkBddhfdz5kCTqejobXH5IUrKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqe+Q4u9Gzb14JUm+sun4cIbBqbCEawQHwhT3Sm/hb2L9xyYnKFmb7WzejPTEDqkfwMexLdVeUiKQ+bJtz6OFyeGcHgBY58pt/aye99v74/jGsYp33T7c0TTi61uc0RQ5IlN8cAaL4qVUl/6YsSXo/PIj0796VxoDoOONoT0nro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hOwZWFfb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hOwZWFfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A384C433C7;
	Mon, 25 Mar 2024 04:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711341939;
	bh=3ZvoBtiQeBGYm5zSAkkBddhfdz5kCTqejobXH5IUrKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hOwZWFfb0BlNqR5qxznHoJ12UNjLdtdPCWX4rHkAU2SAcZzGzuXYgQDfnS9XOshZh
	 FrXr5REHpUBEj1z08kYjOzeyAXGbAeD6qg9WCA8AGzsrfnsH2i3fY9IFvk34nHvDbQ
	 gr0Fo55U19nET79AEjAAX6s4X4y5BxzQlS2TGCiy1CHBXIP6wz+kosCheyNnB1cr6M
	 Gx8GxXo6q33BWZad9qBMc0cguO1NWIR98gfDweTonlN5i9Mc1dyGTQpY3hPNV/eFvG
	 w5Ifl7h/dtmfqeYy2cKM1U156ey67JAjlmHAQGs6LXSy6i0Z2u59tkwKFUr79EHmAM
	 jbxdmI1dfOTmw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 24/28] block: Do not check zone type in blk_check_zone_append()
Date: Mon, 25 Mar 2024 13:44:48 +0900
Message-ID: <20240325044452.3125418-25-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240325044452.3125418-1-dlemoal@kernel.org>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
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
---
 block/blk-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c6d41e1c7a0a..64eb135c7501 100644
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

