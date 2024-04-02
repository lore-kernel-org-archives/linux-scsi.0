Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733126E602;
	Tue,  2 Apr 2024 12:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712061556; cv=none; b=Os6+vk/2qbpYqTa+KXmcxCs7FtZSKaV8THuGdfNa7m/cfN9xN6FwE+AZGDRioR8eVffXa7Wgrc/XN4DYy4xthwE9P7SGsF3/1WHuRq4POO0xcUgI61x6BWMCdcD/FMah7RJ6gSPt6IxZKMouGd8iftv+yttsj5Oy9T0O0TOYNa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712061556; c=relaxed/simple;
	bh=jjiUilvd0iKnYt0AP2dJMfoR1ndfXit0U3Y/hv0duX0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khsiXGULEDjlyaBHz22f4ErsWiCYSThf6tUULwGar3m0HX4Zrep9LT/V4BkVmhcrqnAECGcalh+cBhs/i85XBwiZYF2eFGL2KRvKLJ57DcIJlQgC4h3MNzuFmlbT7ECzyTTiAiGZM5syHw2cUuLa9yruTDaqLjPJZX1Yq3EWcJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g6F4jUlR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g6F4jUlR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED005C433C7;
	Tue,  2 Apr 2024 12:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712061556;
	bh=jjiUilvd0iKnYt0AP2dJMfoR1ndfXit0U3Y/hv0duX0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=g6F4jUlRWYHL+30frClE3iOp/DTSyRPKUjoaBos8cU/TVj5WpZVjeo0s7ZiGZ/gnK
	 JPjbUH2R0CH9LKVXWsp0vAuwP2yC7fKX4P21/bYKOp1uRr+42coVTo9Jm+MYVLY2f8
	 ugwmxr7Qru9iez1ARNe0j+eeEbNTaPh+jJyx/7XhUSy7MKuJQLLsl42IpBMcyRWZpv
	 tY4ZSI58eIogOFibd+6LVrtgPQCbCJQAQfH5MD0j05HmiMUSjT3Kcj65ETkpTCr9w8
	 IcvRe5TTxVTBwd4DNd1bq5FUTZslN92PH0PHCvShbkvwXtpMuKrNorVypxLLboZl66
	 P+i72jRvmMFGA==
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
Subject: [PATCH v4 04/28] block: Introduce bio_straddles_zones() and bio_offset_from_zone_start()
Date: Tue,  2 Apr 2024 21:38:43 +0900
Message-ID: <20240402123907.512027-5-dlemoal@kernel.org>
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

