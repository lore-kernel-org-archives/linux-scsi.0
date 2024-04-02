Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABF385264;
	Tue,  2 Apr 2024 12:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712061570; cv=none; b=lyxzkMVjopDnOvKtbPXar+GNlXtyBBeHoq5tv5Vdc96dTlHW7wnu2vzL59eireWVci//OM1T4U2nNKLR8tPJWH5mtb14vaBDbS6hGhpfBWB4Dja9t/W385kRUkzOX9QV+Rj03cjkh7mb+qOck1ERHpwZvrCYRzSQT/LbE7dzY7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712061570; c=relaxed/simple;
	bh=nMry4ZEBzaq6P0CgjEd5nmJRTc+Xolb7U7Xwyyw7OHM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETwSGAmOe/qMY8PSxPMxDpBsDPZotTDMaY4coLY+uBcDWzf6f3LJnQ2kGbwukwdWmno54idN27/oiSX3efAi9HXNfAvVRw1rh/VuBtpowWeEfqf1qHbXDkG0yCSXqQNdHg0pblALC1oSCGsJJu6aldyQEKLeu1WBk7iT/QapZn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TGEi07KE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TGEi07KE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1602BC433C7;
	Tue,  2 Apr 2024 12:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712061570;
	bh=nMry4ZEBzaq6P0CgjEd5nmJRTc+Xolb7U7Xwyyw7OHM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=TGEi07KEhkHfl5Zi5d9hvYQePKAMqW3JSkL51rylAaNHauwGsOU0mpmwTxJmut6dX
	 dicdlf2nPcLvvgQKmNnKZkVNmGEOlBwIAja7R+uaJwZRRMNPXJFwC+pvdcZmQ45PZZ
	 t3WWzHk3WSJWoJ3wTa8S+8FcQBNEa/qVkvZ3DUlG5vxiBdXiCYovVjguux62RXmfZ8
	 Xw60qiiDE/AKxbDWh96oakGMzMAmqpA9hyxp5n31dFwqvXn3x1KSFyEz70DxKRNGvx
	 qLF6GbmuYB8mNWGG6tyydF5ekJWdOH/xQcysqRC1VpGOaVF8BHnJK8NqAhsmS3l5pp
	 Or2NU6UHosW/Q==
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
Subject: [PATCH v4 14/28] ublk_drv: Do not request ELEVATOR_F_ZBD_SEQ_WRITE elevator feature
Date: Tue,  2 Apr 2024 21:38:53 +0900
Message-ID: <20240402123907.512027-15-dlemoal@kernel.org>
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

