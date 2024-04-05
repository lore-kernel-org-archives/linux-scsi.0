Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78E42E851;
	Fri,  5 Apr 2024 04:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712292151; cv=none; b=YS3comoAkeoPv6XUwcgTIai2iIm+t/UROMUlUysy9Fl40CzGm/yCiag7gcZRpcesudEAuKvFrv26/Z3YIIQ8ZW+4R+IKS8wiIL+6HikrHr4iWSni724WAKsrkZP5LP513lHPl8AuzVF4K0Ce9hVh8A+xBK/h1JmOA1ir9hir28k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712292151; c=relaxed/simple;
	bh=YARcYpByiC8z1QdFM74x6voKyEeLX1LQj+WGr00zNUQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1xRV9eZ8d3yhobq1eo+izAvctzNXCa3x5j4qXFLyxGyg1NAz6Yy+m/2X4N5y54eaxuUifdo9NwWvbmTuXQmygMaynyCBL3qugws44qTtaOzeZS782CbsJkk4vUU6AbF9d7pFvxbTQ21lOCaQAB5WRyE1Z+5K86l5zIgpR4o93w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NmRujvtv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NmRujvtv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C02C433A6;
	Fri,  5 Apr 2024 04:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712292151;
	bh=YARcYpByiC8z1QdFM74x6voKyEeLX1LQj+WGr00zNUQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=NmRujvtvzT8w/hIhtPuhOrktgTI6B41KnkW4YWzYTgUPkZ4W6wzFlta2UwnZQ5x5K
	 Amk4u9JM+0pLs4NjEas5eAbAK5+7dRHb1+cY/sluYPDL6rnVvdWzyQNbVyKuzv3n7S
	 kORA0l4krB4VUpjukhShj58wWCx8fdeJB3xFXQS8d72iqlaTQ9fZNQpmoy9TVaWdQN
	 qYYzkDei9aNB0jxRQFAzikE0hr9UMbtO1WUt+pgJu5w5bCsYSfEYSiSbuym1vSKqgF
	 uR1P5BerNxym+RNqrzt6KkurIQ8DCU3oS5rbxur1MDQMYbDSlCbOm13RebVseF12fo
	 sudsfYmEwcFHg==
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
Subject: [PATCH v6 15/28] null_blk: Do not request ELEVATOR_F_ZBD_SEQ_WRITE elevator feature
Date: Fri,  5 Apr 2024 13:41:54 +0900
Message-ID: <20240405044207.1123462-16-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240405044207.1123462-1-dlemoal@kernel.org>
References: <20240405044207.1123462-1-dlemoal@kernel.org>
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

