Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB2A224C9;
	Mon,  8 Apr 2024 01:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712540519; cv=none; b=kRvWi3LbSkReag11ZOC80f6pk3RO3Oh7opD1+CzFeZmYEK1hmum+XSfJo6mUaPmWCdWfyGmvDa8BVTzZJUff37gYtJs3WHZZeG+qlI7ldyQ8hzjIZghulM5oRgBBS4Zd2WJ6xK5Jk4heBEZ2aZ9NlZYjm2ju33reOCF3IRK/pMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712540519; c=relaxed/simple;
	bh=21I6cZVbmo9GbZmqqYAGOoR45iESDFfQMFchEsaf+Cw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnV2F10wg97UXF/gFKkFjwLHT/3XJPvyeufHAFCWvXGVy/1dG/a+sh7f8c8mzYnyQ225Dth/PF+OrpagtaxXPmqiDfjO5K/CtLnMxBwOk+mOWaUgJk/wcWQHiG+5sEJcUsjtXnEwZ1RF4+1Nv2Ze7SSzytMyqRzQrcwlxv1Q0QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eUdQMmFp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eUdQMmFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB811C43390;
	Mon,  8 Apr 2024 01:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712540519;
	bh=21I6cZVbmo9GbZmqqYAGOoR45iESDFfQMFchEsaf+Cw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=eUdQMmFp+gFTPJqt4JSk9aHqShK8t6OW3cNIcVW7oiqjp/sZjtmAQFxYcXuDXKunO
	 MfGlWoVLsPMqceinaIjZv7iyIFI20dtIFOzexkfdngbeJxbGDJK1UYPtgtSxNPxM3I
	 BQikjN32iVGI1pcPAvVXaLKWdeCIqbLHQfrAWFJJXniK7h/gRzJLIxKnRk8rTrIZN7
	 k+x0XtaE3JXu44uC8XhIxjOzsO2Ys5I1f4BecDqQz+inEPRMjX6N1zLxDGvUX8NHc8
	 j33Upmz0AQun+D0lVHJB5SwEStW4heAS5IkaMsua7aORBOZyXB3aZaj3uHjDPpNrJX
	 ZKlb4gg9hIPWg==
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
Subject: [PATCH v7 15/28] null_blk: Do not request ELEVATOR_F_ZBD_SEQ_WRITE elevator feature
Date: Mon,  8 Apr 2024 10:41:15 +0900
Message-ID: <20240408014128.205141-16-dlemoal@kernel.org>
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
Tested-by: Hans Holmberg <hans.holmberg@wdc.com>
Tested-by: Dennis Maisenbacher <dennis.maisenbacher@wdc.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
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

