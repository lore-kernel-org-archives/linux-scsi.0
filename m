Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CC480C04;
	Wed,  3 Apr 2024 08:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712133794; cv=none; b=IaQKqRISqi12j5n8g2eiU49kTLuIFHUwUgfHkBybAU/ST0cB4NLeyJ4etASAqx7sAAZiR3MLOQoJ1S5lkml2eWdrBHs50F4vNQLt7QUNjYIikDk1T10mLSbB7YJso7DcD1y5wjaEJF0kqQYKGIRNnJi5VMDXbQdGJAazI1hN5JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712133794; c=relaxed/simple;
	bh=AlRpJddvRHquUbj18752X4Iel9EVoPRdVoTyldN+Rzo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3kQQRHGDYfNTjGt1KNnm1bPhB0kA70ZEyNrnc5T6E/0KJ2UHoDSxFbKDgPNejdjQiGIiE1TU920cs0qa31Gl4tBqMC/ixTXOXYlJ12/h6EPDVQKg4l765QJgikQy/LFsSQvl5WFa0NyCTlNTXGBBIeb4HxcSfX/Kto/NjLK3Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YdN6z3xr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YdN6z3xr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BDF1C43390;
	Wed,  3 Apr 2024 08:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712133793;
	bh=AlRpJddvRHquUbj18752X4Iel9EVoPRdVoTyldN+Rzo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=YdN6z3xrKxBsFKivfIPigTGQXKhBynrMqMVs3Ir8GJImZIlEibyXJtDTDow8eGIop
	 13bDexpOPAQl5k+tNVslmZjixYnepHavVfPss7iKPEJtgMCFl9pKo3x1rJ4+ZTv3cq
	 Q2Ah6TYLYBuPURlY5xKPIr/LTPbXA25CXLDtgjtFhK1uGVLzh1LpAYg04a+UMUjqov
	 y9jk7Zu0QIwYudYRZQ8/vPBDTVwtDI0jK+z8VztbOpep5JOp5Ywwjb6XG+eLu49Gsv
	 LiTmciXqTz5CIjjUxVd66oHEBTl6SzulPZppaIhx7HYGakzsleZWZuS3MRDawAY/ZE
	 p5XEFyWeg3jSg==
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
Subject: [PATCH v5 15/28] null_blk: Do not request ELEVATOR_F_ZBD_SEQ_WRITE elevator feature
Date: Wed,  3 Apr 2024 17:42:34 +0900
Message-ID: <20240403084247.856481-16-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240403084247.856481-1-dlemoal@kernel.org>
References: <20240403084247.856481-1-dlemoal@kernel.org>
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

