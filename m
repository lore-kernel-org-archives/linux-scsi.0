Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9892D22F17;
	Fri,  5 Apr 2024 04:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712292135; cv=none; b=RKIZfQpXglfIrIYrjTxjpmjpgnYokNs2m0ipClFkw2Srm2ZEgUJTdC0chBXGGDrk+mnHJ8rMfubFnj6uWXI5yJHNkVe6Ru+0Sb8LTEpLfb6XdV6q4l82881lnwAS5+TNxGl7bhOndidm95sIVZbxy60nAeP1yScUnq+Pp7VUBMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712292135; c=relaxed/simple;
	bh=7qLFKHmMqXCPhSR7cz1IzscSua25WxaMhOqOUOURAX0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKdHD7fLRfDP4IrNMxn4bH8pnikIRHAwqW4fETS/1B2xyS13yvufZb/Srk1kYMCY7jnfL0Qfouj9aJWZtFcKAivXChJg7Npph0cGLoI7RlW9WFtLfBDg5edGamrJ8t9ArLu810OeLSLkSITxu8fnOmTr+lZ0HyApPv//SplZIl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fjGtxkbY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fjGtxkbY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5233FC433C7;
	Fri,  5 Apr 2024 04:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712292135;
	bh=7qLFKHmMqXCPhSR7cz1IzscSua25WxaMhOqOUOURAX0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=fjGtxkbYkTG4F8M3FVBPb6ax8unAeIXDLJhm6OZCOnpLzNa4TNgpKooN3HJaLCG7A
	 ojb9TXtlT+8mFzaLKjbpf2Q+UqDc8vNbh8UqkCOfAypcI1wu3J9x44Qu/54DJZDPrV
	 h61pCc1Cgc0VxPfHKEaNjxugSUOeKjlQYgyLLFIjGB1+YLEhr6cbEyBOrkal/kphOl
	 1wUAfVX23sfFf07VbcdUn9ega97+RwNmKQcxbeFFrK+at4/JBTlaOIUXVwiR6IfMHG
	 M2k0tzsHVfsUG6PlnwSUJHsTmpm9CrRv1byKISklexbasa/dlcwMDfmOFAxTOkkLRr
	 Ssej2jp4eObPg==
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
Subject: [PATCH v6 04/28] block: Introduce bio_straddles_zones() and bio_offset_from_zone_start()
Date: Fri,  5 Apr 2024 13:41:43 +0900
Message-ID: <20240405044207.1123462-5-dlemoal@kernel.org>
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

