Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AF9A40;
	Mon,  8 Apr 2024 01:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712540498; cv=none; b=GRRCNXCmuNi1fFsA1YekV4jn8U7pXrnYQ5xuggm/1sJb6liBLFmglENnjAlvGADZjK8JhAs3+YWD+AkNgGxoc7E9ScQ0pc2/XknBXW8ferQOwtj5nOmzDjbVixKHjQgaaLltLldpDGsLcWjI/QtW/MxrGmzZ0z6CykaMWdS3Apk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712540498; c=relaxed/simple;
	bh=cUwQkF213nGEUnN+95fFuqIB+TNqvUJ+tiTrGtsuV4Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1iGF1UOwfROu1PgXvlmCzs3+RcZEjqstqxFByJeftve3igI9t9Hh2NZPyS+AKqHFpjpluAAI7sRGTyCYIPsF78UdtACYpZkJ5iFPScMP6OC0d1KKg8fupHkD8XqjuOeJ+omEO7gqj2RIOpq5d33btnitL0rxrheBeus4gE0XlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cC0W2cVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cC0W2cVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA307C433F1;
	Mon,  8 Apr 2024 01:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712540498;
	bh=cUwQkF213nGEUnN+95fFuqIB+TNqvUJ+tiTrGtsuV4Q=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=cC0W2cVJKzH3Bt1t+2mVAEKbDWzlSMJU4F0g7pF4+ziNh2NBKjqGN1E35Y3txdyFw
	 yacBa/bMTaCJ9wqVPacuxojMgHbWRWkuR2Xl/bFr4urQ5QTs7YQDpmvgcC1bqJFPTC
	 K5faWFRAO7eST6hUGiNxVhYyb6lPa3OekJb7ZVwQVhsKKxZ55uFCjVU0jXTZrbV9Em
	 NNyO6k/9w7w16c4dcy0BqKDu8ht/gTDfhQeD8hczDIqIuRihRmdPLCvWhvLu0imqM5
	 RK8Z9BtHPU/sJ2AArRTVnvgx+R0CfQN3p/ZrNPLLUqVXsoXIoF0FXSRt2ai86qab5p
	 PSK3zRKpSwMKw==
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
Subject: [PATCH v7 04/28] block: Introduce bio_straddles_zones() and bio_offset_from_zone_start()
Date: Mon,  8 Apr 2024 10:41:04 +0900
Message-ID: <20240408014128.205141-5-dlemoal@kernel.org>
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

Implement the inline helper functions bio_straddles_zones() and
bio_offset_from_zone_start() to respectively test if a BIO crosses a
zone boundary (the start sector and last sector belong to different
zones) and to obtain the offset of a BIO from the start sector of its
target zone.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Hans Holmberg <hans.holmberg@wdc.com>
Tested-by: Dennis Maisenbacher <dennis.maisenbacher@wdc.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 include/linux/blkdev.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 172c91879999..0380b7e6f818 100644
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

