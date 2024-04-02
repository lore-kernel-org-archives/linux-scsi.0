Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF22B85926;
	Tue,  2 Apr 2024 12:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712061572; cv=none; b=ZAH36zSuzgL0AZbuqjO8imPYs78gns3lFzNvQDFCqB5LoaDjdBmHg9Dp08CnO3Fdv9OClQP3MIhRJ+DRaEYFvvqTVW1pqVvjkK9a1qehdT5UXDdINbIvR4KWH9lB0kGud1cApfh++9EgHIhphHm3QQSeR82R2ayQ4x4pOI6pMr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712061572; c=relaxed/simple;
	bh=AlRpJddvRHquUbj18752X4Iel9EVoPRdVoTyldN+Rzo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxjtlGNkEiX2AQhUh40oaPCG43hAH6x0BaCID+HeXka2Bm2c8/J8jGUV85G7EC3G3oqn+5pXCk24mr3Bz0CRKQBwf5lg20QqTqw9OXzzOwt3WCgYoXAdgCBVRIQWpw+VEy7OMBfWwbkqrqE+Hgm7Ju1q05bW8/E9P4uYJ2nYrYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p26gum3s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p26gum3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FB4C433A6;
	Tue,  2 Apr 2024 12:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712061571;
	bh=AlRpJddvRHquUbj18752X4Iel9EVoPRdVoTyldN+Rzo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=p26gum3sBeFCuVwFVjD85N/wm2xo7Mdm6rpYY2kyiHK66ybM1M75OfL54LCZOi1rg
	 QBkp0cUna0iUDgj3eMNkKrYnXb12dMpvbNjI5hV3fvjS+e7vZs04kEBE/qtRsFYdMg
	 8WY07VgPq01sY8VpdJdQHrbcj2TLHnCtTD+72ZFadCCOTyxvaod+ZgZ2O6RUPxBBlh
	 zBTSFRlGKvha5OxfN5nK08ouhtguh0ty3kS9h+D/wNrxsGC9SUNOzdRaScbQJRKrF5
	 Nu/oKwhKnNfjSULZTTwU27W+KGCn3oDNt8uSmVafQ0hq9bZwGLKl+wSMJaUFrG6Bhp
	 9GrHUBCxr6ysg==
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
Subject: [PATCH v4 15/28] null_blk: Do not request ELEVATOR_F_ZBD_SEQ_WRITE elevator feature
Date: Tue,  2 Apr 2024 21:38:54 +0900
Message-ID: <20240402123907.512027-16-dlemoal@kernel.org>
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

With zone write plugging enabled at the block layer level, a zoned
device can only ever see at most a single write operation per zone.
There is thus no need to request a block scheduler with strick per-zone
sequential write ordering control through the ELEVATOR_F_ZBD_SEQ_WRITE
feature. Removing this allows using a zoned null_blk device with any
scheduler, including "none".

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/block/null_blk/zoned.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index 1689e2584104..8e217f8fadcd 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -165,7 +165,6 @@ int null_register_zoned_dev(struct nullb *nullb)
 	struct request_queue *q = nullb->q;
 
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
-	blk_queue_required_elevator_features(q, ELEVATOR_F_ZBD_SEQ_WRITE);
 	nullb->disk->nr_zones = bdev_nr_zones(nullb->disk->part0);
 	return blk_revalidate_disk_zones(nullb->disk, NULL);
 }
-- 
2.44.0

