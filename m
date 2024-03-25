Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF80F1C3229;
	Mon, 25 Mar 2024 04:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711341913; cv=none; b=sdOqX2IzODZ9AzTEAQzEAJhluiw6fDmcrQCFXoCORHe4xH2muypoTUivN+4zXjxy9+KJUqN8wE9Wo0d6ZUKi4yttD5DOT/1GYUE3KwUmIZ6XIrjxgX8gf6wSSS0PTKquq30IBSFrDiZhcBcxzHX2bCfK48KU/HQ/GMqpb8NRbjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711341913; c=relaxed/simple;
	bh=gbFvlE45AMOYhclxLRqAMSp/D87j0sXcK9Wkkb49nPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9f1Z1AeKFeaDJf1qNlk9Jf7ERvHNP2xy1IYMzz/O2xxevqRw/Fo7RfAGLsItDbeWTZ8WP2uDsgd0bSQ7se4qwn27S2EYamW4Qn/0Ga/ut7igsizlJBdnA+mAnFFp+3hgSAPziQY2vyQvZd0Ek4t9+M5cFAcssniY/BCXQBl0M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tIekmjfc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tIekmjfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B4AC433F1;
	Mon, 25 Mar 2024 04:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711341913;
	bh=gbFvlE45AMOYhclxLRqAMSp/D87j0sXcK9Wkkb49nPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tIekmjfcEiO+qMsVuUFHN2CIsnnEuXdRpk+on/GLtjgBP1JiZf6fuZhAxlmQKO0NP
	 NzgRtO1CL91PpXeUM3F3jOaMac3ApGVLTRH4twh3sSqZ6yacfV68iruai6gWo12xai
	 DHRnMnkCRRtRviino2GJ/Z11iW+V9B+E3aQh1Y08BEP5pOIbbFf4ssY9BJqIkbZEaB
	 ETTnCUDoPlHIiVjZquw1X1Xuj+IIXtoGYz+zDJrnC5U4M8gpAL1c1vOonCs4ybtPm8
	 9pln3QwC62WpxCvyT4MPc6NCSBw5Pgnb8ASOnJ9txWQsdr1xkxGB/SfqVqeJ7cPGOL
	 7VVpq40Y2B+bA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 09/28] block: Fake max open zones limit when there is no limit
Date: Mon, 25 Mar 2024 13:44:33 +0900
Message-ID: <20240325044452.3125418-10-dlemoal@kernel.org>
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

For a zoned block device that has no limit on the number of open zones
and no limit on the number of active zones, the zone write plug mempool
size defaults to 128 zone write plugs. For such case, set the device
max_open_zones queue limit to this value to indicate to the user the
potential performance penalty that may happen when writing
simultaneously to more zones than the mempool size.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c      | 22 ++++++++++++++++++++--
 include/linux/blkdev.h |  1 +
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 4e93293b1233..33dea8ca9a6f 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1428,6 +1428,9 @@ void disk_free_zone_resources(struct gendisk *disk)
 
 	disk->zone_capacity = 0;
 	disk->nr_zones = 0;
+
+	if (!disk->zone_hw_limits)
+		disk_set_max_open_zones(disk, 0);
 }
 
 static int disk_revalidate_zone_resources(struct gendisk *disk,
@@ -1437,11 +1440,24 @@ static int disk_revalidate_zone_resources(struct gendisk *disk,
 	unsigned int hash_size;
 	int ret;
 
-	hash_size = max(lim->max_open_zones, lim->max_active_zones);
-	if (!hash_size)
+	/*
+	 * If the device has no limit on the maximum number of open and active
+	 * zones, set the max_open_zones queue limit to indicate the size of
+	 * the zone write plug memory pool and hash table size so that the user
+	 * is aware of the potential performance penalty for simultaneously
+	 * writing to too many zones.
+	 */
+	disk->zone_hw_limits =
+		max(lim->max_active_zones, lim->max_open_zones);
+	if (!disk->zone_hw_limits)
 		hash_size = BLK_ZONE_DEFAULT_WPLUG_HASH_SIZE;
+	else
+		hash_size = disk->zone_hw_limits;
 	hash_size = min(hash_size, nr_zones);
 
+	if (!disk->zone_hw_limits && hash_size < nr_zones)
+		disk_set_max_open_zones(disk, hash_size);
+
 	if (!disk->zone_wplugs_hash)
 		return disk_alloc_zone_resources(disk, hash_size);
 
@@ -1451,6 +1467,8 @@ static int disk_revalidate_zone_resources(struct gendisk *disk,
 		if (ret)
 			return ret;
 		disk->zone_wplugs_pool_size = hash_size;
+		if (!disk->zone_hw_limits && hash_size < nr_zones)
+			disk_set_max_open_zones(disk, hash_size);
 	}
 
 	return 0;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 68c60039a7ea..8eb99cab7221 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -193,6 +193,7 @@ struct gendisk {
 	 */
 	unsigned int		nr_zones;
 	unsigned int		zone_capacity;
+	unsigned int		zone_hw_limits;
 	unsigned long		*conv_zones_bitmap;
 	unsigned long		*seq_zones_wlock;
 	unsigned int		zone_wplugs_pool_size;
-- 
2.44.0

