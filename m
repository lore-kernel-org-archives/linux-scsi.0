Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6356C2B9A3;
	Thu, 28 Mar 2024 00:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711586662; cv=none; b=IsXY8czlTtMric555vwpPtvUKZkkNc0E+4wyvDlK+c01aSqBz7kACJjhgvrWOF3fGvW/GWnqoCWGvFVAGKfN0X6ZV9aQxgGGXnKq0Q1YyEpRxjJrUgPgcfM/VZCQYVNAsb+vkFAB9rp+w/yoh+HXi4C7vuJKAHDcGkrRlowZvnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711586662; c=relaxed/simple;
	bh=JWcFjyy+OD/TNvYIfUUGiuk5k3y51VJlLmQxqzZP42Y=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZ3bCA6gjTbokl7PsdAgUGQus5CjFISIF8lg1a3lxLqsvJOsBV75uO8sEdEWk2/TESIEjQEq2ailKR2E0db+E5joqHqNj+vg2swWG9ierHsn1Vrg2ejdFHK97L3YudkHLjLwg2AEVW7T/8B7IYRJBo63Cda3EfaTKOvde75IUDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gidhj3PJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gidhj3PJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248E1C433C7;
	Thu, 28 Mar 2024 00:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711586662;
	bh=JWcFjyy+OD/TNvYIfUUGiuk5k3y51VJlLmQxqzZP42Y=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=gidhj3PJSs25ona2MLVYHS5ZdvH7WofywoqHZFBVdNZbQWzs15PwSDgdQ6WRcX6qn
	 4gonsGJOg0wBOv5JOGD89CV8nb1DnROHR4s26LSpsyjdiYnodNNiG1+fJJ4zX85FqO
	 NsYKOsaIRdjpYZiOyfXnveli68miC9yIO3fJLBnLN0Z9md3Fh5KuUEwoVmVxWQCzc7
	 9o2dEpgK0mudY2GkxxCsJIaqwCzxx4HqdrT3o77nI7o/G3koc6eBM6DF1fylJx/9SL
	 BNBhRD703+z1p2onaJ0b+02+QpTIAgjJiX374uMw0VQigHX9MkpFZQxXH5O4v6DrVF
	 ntuxTkFe8/Jqg==
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
Subject: [PATCH v3 05/30] block: Introduce bio_straddles_zones() and bio_offset_from_zone_start()
Date: Thu, 28 Mar 2024 09:43:44 +0900
Message-ID: <20240328004409.594888-6-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328004409.594888-1-dlemoal@kernel.org>
References: <20240328004409.594888-1-dlemoal@kernel.org>
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

