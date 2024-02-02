Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576EF1B277;
	Fri,  2 Feb 2024 07:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706859086; cv=none; b=SjkFbht6JX9OCCBBqLLJkzDhz/wBPDn0mg5pBZdqFtjgMPs/MkcTfCpl6YIddKBJh0ICh/6HqoazkL9NYV569sIRTSJWdTFIuF9gKwCg/PT8ShHCV1ufktiTQrC0bOJcl9MX29PVD347NOf6SGL9rcrG5CcNh9F3OxTgcwb1/+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706859086; c=relaxed/simple;
	bh=gG/e2UXGR8jcCK5nJZ7d3Zge+Q6B/zA4dQp4IMov1Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqK533bGn/2T3hY/p8zxeCXsIdho3rDtWK01mIlqeIn/z4gYwjJj3oPOtlEAwxIIoNi/sxED48IEyBmLqnH+IrvALsTQBE+TZ+ifz1Aley49R/Pq3UeqoccFu64+taQUSmuN9ZurqVTHyArjvNMDpo8PSehKjS9QrOy4wAswxIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vu/nMIj5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vu/nMIj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0604C433C7;
	Fri,  2 Feb 2024 07:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706859085;
	bh=gG/e2UXGR8jcCK5nJZ7d3Zge+Q6B/zA4dQp4IMov1Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vu/nMIj5FtinJ+eoDDtmqapOOgiGtAhglj8ZiUQU/6AHosMDJcyPcQXAu3M57MTuq
	 9OHWgl/AeIojDVepqR8I99RBtEmDJGHkTDgAsmRQfpRAwjb81lrpLnky7NAKq9pgK5
	 isBRauizXrNnnW6xF6IMzRc1mJ93di1BJY2Bs0Tn2ag2G0ZqXMbf6A08PNSQ5ofjgy
	 5nnWvDiYb5gSNSipUR3G/Efu+MqwUnkE/C3tan6RLpXu9ppnt87OQHL5PHczgCalTT
	 8AWhUUf3g9YDnCy7UeuZ0eYz5zhj6k/SiiiRDcZKA2w82CeDfbUTW3LSYeiVe49O8a
	 PZrC6wzEf8soA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/26] null_blk: Do not request ELEVATOR_F_ZBD_SEQ_WRITE elevator feature
Date: Fri,  2 Feb 2024 16:30:51 +0900
Message-ID: <20240202073104.2418230-14-dlemoal@kernel.org>
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

With zone write plugging enabled at the block layer level, any zone
device can only ever see at most a single write operation per zone.
There is thus no need to request a block scheduler with strick per-zone
sequential write ordering control through the ELEVATOR_F_ZBD_SEQ_WRITE
feature. Removing this allows using a zoned null_blk device with any
scheduler, including "none".

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/block/null_blk/zoned.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index 6f5e0994862e..f2cb6da0dd0d 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -161,7 +161,6 @@ int null_register_zoned_dev(struct nullb *nullb)
 
 	disk_set_zoned(nullb->disk);
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
-	blk_queue_required_elevator_features(q, ELEVATOR_F_ZBD_SEQ_WRITE);
 	blk_queue_chunk_sectors(q, dev->zone_size_sects);
 	nullb->disk->nr_zones = bdev_nr_zones(nullb->disk->part0);
 	blk_queue_max_zone_append_sectors(q, dev->zone_size_sects);
-- 
2.43.0

