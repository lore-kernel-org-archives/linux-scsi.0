Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9385D1AAB1;
	Fri,  2 Feb 2024 07:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706859084; cv=none; b=twGFIETzIaX3jhEW80dDKYzvoH8F2o/Lj6CmAogDs3VXG87qs81MVvG0gyFsXoVMv5jd2d0pbwZjs5ap2kC4k1P5eNQ7gT1QCq1pYQFO4XebwlQ+xYKr74IwPCVo/Ye7kVvBXPiZEHu5aROT3kjinTdEKO0DhVFri01ecMxWhjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706859084; c=relaxed/simple;
	bh=JcK0DvN/ouz81IHsurC3xGsyhiqtwSUFnaXPQFDq2Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjcTCl/Kf+26Djt0IZDMo60S78iT+Djz+u/8L0+k4/IvmzrmNUhxhqHDRhAy/jSbpVNFHDJTgGlTqzLX/c51HJEdpwUnF6CRqiJGsAXrSM+orXUU+ZWUA6lweFIEpzJ1jUmlNQnkOaIO/Y++7uBN3XU2yQoTAvyue2n8NyRuUo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TNyttXF2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TNyttXF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C8CEC43390;
	Fri,  2 Feb 2024 07:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706859084;
	bh=JcK0DvN/ouz81IHsurC3xGsyhiqtwSUFnaXPQFDq2Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNyttXF2mv64NBCq3RPLSI5VtJHYR2q+5r9hwteTF2E+GFv8ftgCKnshygPFGCunE
	 bCnA3ikNP278K/jbTJ+iyb4l/tr6uB0F3iXzI84Y5/FQwb5hRctrSPuaTCCozZocu2
	 7LejhQ4rL1bAeX2cC4ZEly6YTEJU6ZmXbkFe+Ugfd8LZLGifJYJWcB7Y+FhbU+iEqb
	 wmPIB29Rc/FT09FeDL6PrsGsdxCNFJ7hcBUwBmypXluB76yVrmJHRNKh0dMrQ79MfS
	 +7U4Hhwk/pS71JLim5I3s2U5wuau2BL6iwSScSyLnriPPZuc4VbrxPQyU0TAfZQloc
	 OoUNRryb2ZM2A==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/26] ublk_drv: Do not request ELEVATOR_F_ZBD_SEQ_WRITE elevator feature
Date: Fri,  2 Feb 2024 16:30:50 +0900
Message-ID: <20240202073104.2418230-13-dlemoal@kernel.org>
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
feature. Removing this allows using a zoned ublk device with any
scheduler, including "none".

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/block/ublk_drv.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 1dfb2e77898b..35fb9cc739eb 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -252,8 +252,6 @@ static int ublk_dev_param_zoned_apply(struct ublk_device *ub)
 
 	disk_set_zoned(ub->ub_disk);
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, ub->ub_disk->queue);
-	blk_queue_required_elevator_features(ub->ub_disk->queue,
-					     ELEVATOR_F_ZBD_SEQ_WRITE);
 	disk_set_max_active_zones(ub->ub_disk, p->max_active_zones);
 	disk_set_max_open_zones(ub->ub_disk, p->max_open_zones);
 	blk_queue_max_zone_append_sectors(ub->ub_disk->queue, p->max_zone_append_sectors);
-- 
2.43.0

