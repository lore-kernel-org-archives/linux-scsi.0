Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84676D1A3;
	Wed,  3 Apr 2024 08:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712133776; cv=none; b=rFub7q9fR9o3fTDgqM/CGKpaJfGCDGYl+WGwNZolF6UPbBvPQLFHPxhPLw6QF3YcLERW5mJQq1caMtgkyZ0TiXUi+FMWLy7pMgmA6aP9hzgSdIqNytXOfd+PqJWNk2wVL4eXglMy0UIAcUQkHVhsfifM94IWmdwcb0ESsmktTdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712133776; c=relaxed/simple;
	bh=jjiUilvd0iKnYt0AP2dJMfoR1ndfXit0U3Y/hv0duX0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMMZtGyFHyStkB2+pNIJslGR0OKz24g7LeHTW9jdNZKFfWqGtfSuRB+JxkYxvdAKp7lGu3Iex3G80k0DcukDPjeSOVdqtT1caT7JFItE6+bNkHX+2EJFyO7nc+NiJeU0/RREM8qJP/wTtwnrigs2k8Eat3kGqtJ1K4+itRTU0FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fob5/M3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fob5/M3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E668BC43399;
	Wed,  3 Apr 2024 08:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712133776;
	bh=jjiUilvd0iKnYt0AP2dJMfoR1ndfXit0U3Y/hv0duX0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Fob5/M3R5ElofVQ1/9H11uJ3AONmZ7efp85jIVm06uuzoDT0CmpNJM4jgYiDBng91
	 Zu3IhU97e8Oxm46GdOuo4rh5WZj4nK1sDGLM0aoQ3hnSQKE6rdCSLLHJW8HK8uU7cK
	 LS5MsAYyu9ZeZIRihDyyHLD03nxg9Edwjr/Wy+178maMEtEOXEt10VpL0qDV8WS5eU
	 K6dlpeT8Sj4QbOzgtimuJxiyjZPEJREy952ZDyKeLWDUSwNVW7nkBREyMommPlNNG9
	 cHx9T+1UrRBM/gCsGClZG+iG4lbieamWUa7Kms4KLWbl7qh6hFtYHxQnZBverfnYv+
	 R1eRkk84kEPAA==
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
Subject: [PATCH v5 04/28] block: Introduce bio_straddles_zones() and bio_offset_from_zone_start()
Date: Wed,  3 Apr 2024 17:42:23 +0900
Message-ID: <20240403084247.856481-5-dlemoal@kernel.org>
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

Implement the inline helper functions bio_straddles_zones() and
bio_offset_from_zone_start() to respectively test if a BIO crosses a
zone boundary (the start sector and last sector belong to different
zones) and to obtain the offset of a BIO from the start sector of its
target zone.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 include/linux/blkdev.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c3e8f7cf96be..ec7bd7091467 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -853,6 +853,13 @@ static inline unsigned int bio_zone_no(struct bio *bio)
 	return disk_zone_no(bio->bi_bdev->bd_disk, bio->bi_iter.bi_sector);
 }
 
+static inline bool bio_straddles_zones(struct bio *bio)
+{
+	return bio_sectors(bio) &&
+		bio_zone_no(bio) !=
+		disk_zone_no(bio->bi_bdev->bd_disk, bio_end_sector(bio) - 1);
+}
+
 static inline unsigned int bio_zone_is_seq(struct bio *bio)
 {
 	return disk_zone_is_seq(bio->bi_bdev->bd_disk, bio->bi_iter.bi_sector);
@@ -1328,6 +1335,12 @@ static inline sector_t bdev_offset_from_zone_start(struct block_device *bdev,
 	return sector & (bdev_zone_sectors(bdev) - 1);
 }
 
+static inline sector_t bio_offset_from_zone_start(struct bio *bio)
+{
+	return bdev_offset_from_zone_start(bio->bi_bdev,
+					   bio->bi_iter.bi_sector);
+}
+
 static inline bool bdev_is_zone_start(struct block_device *bdev,
 				      sector_t sector)
 {
-- 
2.44.0

