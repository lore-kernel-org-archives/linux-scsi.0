Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48581EB3D;
	Mon,  8 Apr 2024 01:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712540518; cv=none; b=pV41QBmwOEUXNg+NKWpDdP3dlmuSt5f15df3lh+hylMxWUprT7avSA2LJBRVtsUma1O1INqsAX+3JQr2dNMR3E1tN6qQxf+M1xhP1VTQHRGZi7Ptzu1aiHFt7oRBsBEZNS+fwiWlBzHTZbymcswniRApPahBFEN/CpdsezjoPDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712540518; c=relaxed/simple;
	bh=BAiWNhCwyIY1LaDWb3Dd92O78HHu2u6zYh3FJtbEcvw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfI+uYMu8zxXAijUTSw1MV/++xkOl7spih6I5It+utuEeuWgZvu13HJ8xgEBxzbCEIDNsVYvAMZr7+73DtPZEGYUrgHyv0vh/3gBBp2SJ2uJzktoZvGsPB6n+H2OI6xK4AWv1ac8Icmn4fvHKLJ67On7aOlzd+4m5S8RUm1iBlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T9XSrn2g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T9XSrn2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C1DC43394;
	Mon,  8 Apr 2024 01:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712540517;
	bh=BAiWNhCwyIY1LaDWb3Dd92O78HHu2u6zYh3FJtbEcvw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=T9XSrn2gljA/maWyfaIMjWYg+nPDvbA9ATjAGUw+rN6GsoqxJVeC/6hUMyy10B1dw
	 WHc7ai5v+idZuBYvvp+oADDgChySFyEvSxH4QYQaTu7UKXGh6vO7Z2wNnPPcG/zzT/
	 SHDIXWSzSbgZS9bcBHEkHc+tezyZqgufgWqmwqXX7U0j/+FUovAif1iJEfriH4qJ2C
	 bHDeLMp8wwoyGsfnI4BOnJsWMQQFtYcOH+xN4fH3hlyj3epFk5lOEls9N92c63mI/d
	 Gwj5gHzV80TluQKZj4euC0wVHq1qSgOxA2RY2ncohyYZmSZMjtUfaa3MgbNBofMr2Y
	 wnvrQcXliUp4A==
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
Subject: [PATCH v7 14/28] ublk_drv: Do not request ELEVATOR_F_ZBD_SEQ_WRITE elevator feature
Date: Mon,  8 Apr 2024 10:41:14 +0900
Message-ID: <20240408014128.205141-15-dlemoal@kernel.org>
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

With zone write plugging enabled at the block layer level, any zone
device can only ever see at most a single write operation per zone.
There is thus no need to request a block scheduler with strick per-zone
sequential write ordering control through the ELEVATOR_F_ZBD_SEQ_WRITE
feature. Removing this allows using a zoned ublk device with any
scheduler, including "none".

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Hans Holmberg <hans.holmberg@wdc.com>
Tested-by: Dennis Maisenbacher <dennis.maisenbacher@wdc.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/block/ublk_drv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index bea3d5cf8a83..ab6af84e327c 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -249,8 +249,7 @@ static int ublk_dev_param_zoned_validate(const struct ublk_device *ub)
 static void ublk_dev_param_zoned_apply(struct ublk_device *ub)
 {
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, ub->ub_disk->queue);
-	blk_queue_required_elevator_features(ub->ub_disk->queue,
-					     ELEVATOR_F_ZBD_SEQ_WRITE);
+
 	ub->ub_disk->nr_zones = ublk_get_nr_zones(ub);
 }
 
-- 
2.44.0

