Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC5C47F75;
	Fri,  2 Feb 2024 07:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706859097; cv=none; b=Ryv5ZO6HswAe7WnzC5Ppv1S/sDy91T+j0rHJmUeH1ihXmrw7hrUZ9Ju6R6pgb7C/PoaQesY5Z+2nSaqZecyVivJbR+5Tj4TTBQhNoTucjQ5qyQ+0C8pWt2W6I6RLDlnYy5rEO9aSOs+W79w5gdMu5NtnTOg+aXzoG6E9QvVZpeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706859097; c=relaxed/simple;
	bh=YQ3wADarjsP7/875Pls3MOojqq6hPwCFptt9CZDxvoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Id5gpUR2Y6n+uYFhrbn7sHggPIvcIuooOqmGnVfT12EBjXQfbOfmw/3/3HWYLa14DbMPXC7qWZHNYmur2bpLtWjXvDe4FQ5IcDk/Khmw3oVWQI0mp9mUoEdeyQj9EGl5+rjQeXGuy5MMKtDQAKJlYlibWVzRD2/8BrbT+zUUPh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EBCYVAtl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EBCYVAtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31992C43390;
	Fri,  2 Feb 2024 07:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706859097;
	bh=YQ3wADarjsP7/875Pls3MOojqq6hPwCFptt9CZDxvoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBCYVAtlYbTlaxrtjSgPhz5XcLncVrA9dxot60VTGh7hhQjuHmyVsB9R+XLR50lDz
	 MwvZq25YmXSH4wgvcepCW7KwX3yA8ACM8XZI3S5MELHMh5prv59GOK9LieSmpFzd0I
	 WbJpJK9CKRrNONX2YznlZpLxTDeJabCPFISWjJvkpzU5Eo+Tuh7YsJHTflpJn43F8Y
	 v62UcW2Ex83hN0m7hF6N9SaTcLZDzCII8bjO1ESpgrCSlA4//KLIQT32exUKYLH71y
	 mK2SC9gLQDRLm0AyHTsf+8brvnBEodQ6c0qSy6iEbxAZT6+oYEKNgLnYfEzGY9wOFL
	 d7XLcZkjVcFAg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 21/26] block: Do not check zone type in blk_check_zone_append()
Date: Fri,  2 Feb 2024 16:30:59 +0900
Message-ID: <20240202073104.2418230-22-dlemoal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240202073104.2418230-1-dlemoal@kernel.org>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
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
---
 block/blk-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3945cfcc4d9b..bb4af8ddd8e7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -577,8 +577,7 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
 		return BLK_STS_NOTSUPP;
 
 	/* The bio sector must point to the start of a sequential zone */
-	if (!bdev_is_zone_start(bio->bi_bdev, bio->bi_iter.bi_sector) ||
-	    !bio_zone_is_seq(bio))
+	if (!bdev_is_zone_start(bio->bi_bdev, bio->bi_iter.bi_sector))
 		return BLK_STS_IOERR;
 
 	/*
-- 
2.43.0

