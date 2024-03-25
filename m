Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5119E1C3224;
	Mon, 25 Mar 2024 04:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711341901; cv=none; b=Ba518eRO3fY6WYKcYUh5qHonDJKFb8enmjukTGnhLX753HIBIoyWzXNWMdcB4TtHt4utS7zLLqFfokF+rMy3YGn9eYZ/A6L1izMmXSYCoQXu2wNrqkTp0lr9N84oJWYiWv2EP8g9M+QW+WC7wWHXKxa/jqyH+KoTyROvdportLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711341901; c=relaxed/simple;
	bh=iSlmyCUnHjmpRHN+T9LOCJK1RBGI0ZGWpodSejMfbxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/XBuBNdJLqdNI09c9FYO5eIIdzPAQgM5UY//F1x26bpPEotjIczgoORekM5MDUX4fMYcAh/Yya1ciZLa4uuZUA4vj1u564eTcZkKQi187Fi4Hbde79OICkuwxeVYjUsCs3pQbHKk2iK3PIaomQwq5cE6O/hkRb7Gb+r0881meE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jmIsxNI4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jmIsxNI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF06C433C7;
	Mon, 25 Mar 2024 04:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711341901;
	bh=iSlmyCUnHjmpRHN+T9LOCJK1RBGI0ZGWpodSejMfbxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jmIsxNI4hC5hn7GzdQZmjZXfvHR6dW4mpSTV9XO8plw1ahHsiQB+OrlHAzhcXmdFl
	 0kSC3Rmm9g0E+rPYLRwVyVMUwS1Joo4VOX8FhCjqYscE57vPZ8a5XW+aJ/iwnnyKXo
	 9WfszrNYkDoSlgYopbnnJna/ZtBN7bzLbbCV1XJgCLNjjAlerkXJU5cr9MjAcL9BLR
	 fvA9Wf7DjBXSwUckryVri3qCXiPYFdhFmRY7HSM8xzSl5lhxdrUh2CzH5SwTSK2qhj
	 y3ue7IPChmCd4G5cCWPI33gBNFfFJ5QQZ3+0JJMKpVSiGTNQSEUlMzMAyHJk/HEnjL
	 Sk8QTogX5tx+Q==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 04/28] block: Introduce bio_straddle_zones() and bio_offset_from_zone_start()
Date: Mon, 25 Mar 2024 13:44:28 +0900
Message-ID: <20240325044452.3125418-5-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240325044452.3125418-1-dlemoal@kernel.org>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement the inline helper functions bio_straddle_zones() and
bio_offset_from_zone_start() to respectively test if a BIO crosses a
zone boundary (the start sector and last sector belong to different
zones) and to obtain the offset of a BIO from the start sector of its
target zone.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 include/linux/blkdev.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c3e8f7cf96be..93f93f352b54 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -853,6 +853,13 @@ static inline unsigned int bio_zone_no(struct bio *bio)
 	return disk_zone_no(bio->bi_bdev->bd_disk, bio->bi_iter.bi_sector);
 }
 
+static inline bool bio_straddle_zones(struct bio *bio)
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

