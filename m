Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB001CAB2;
	Thu, 28 Mar 2024 00:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711586672; cv=none; b=aOHdmDjPls9ZbE6Le4mqtgC9d9njLx6TnkexQsXRFxd1svBHexbn6GSn/WVgdlQdnRzwEOG/Fr2/uynHvQKFT5uKj+09iHJN/r2pzycXoSQhJoJk7rIm86egvJRESiLgZJF/1iqaKSbtmuOjW7SZYj4/5XDQ6CtMERbzVuvLXRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711586672; c=relaxed/simple;
	bh=67vW/LNmxZSLw/yk2h3NDIMn1MfJX7wyN/BwdoeFk2Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DbIknbc4OHmrP9Yrjle+PFIl4LJA2KdDdNdRVVqdtFjLHBz13B+CzGJLtwkwglulZD2iNzgqpKrStBFx59i33RGSWnLRXnJJ7hjhxDGeqXyE12rLxcuNyIaRKv2M7dDi2BO57YPycIExEaDTZgbIm/gvfw3p6j1nvzDGByBxYLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GE6GtSlJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GE6GtSlJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB25C43394;
	Thu, 28 Mar 2024 00:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711586671;
	bh=67vW/LNmxZSLw/yk2h3NDIMn1MfJX7wyN/BwdoeFk2Q=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=GE6GtSlJyTAwhFKAFGL3ad49VhCRk8fO53UwpVSWlBEoYVvlnwtBJOjPGXqrjdBCP
	 /7Xf8BXVnAU243M972uN86UMEuk5OlF7djhm1kslOim6NBuF8rlxX1HvBgsqgYUuGm
	 lOb9cogEODxmISzgfoE49SyaPTaCCRqaTJgMgAPXitMxA8w5agkLH+QEjWe/eB8EiC
	 6QyXXxdQvoyij1ENtv3VQlN1RBfRFlCSWTNcAs6JyV6QGntTNSQ+hpJE/NMIF+a0tD
	 FbhzK/gKBTTYfID2zW9R9GbW3CoKIdVB4aS2wmZC7XggPXSTchexXN1evJmJUlTtvN
	 qA6zVGhqvnCkA==
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
Subject: [PATCH v3 10/30] block: Fake max open zones limit when there is no limit
Date: Thu, 28 Mar 2024 09:43:49 +0900
Message-ID: <20240328004409.594888-11-dlemoal@kernel.org>
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

For a zoned block device that has no limit on the number of open zones
and no limit on the number of active zones, the zone write plug free
list is initialized with 128 zone write plugs. For such case, set the
device max_open_zones queue limit to this value to indicate to the user
the potential performance penalty that may happen when writing
simultaneously to more zones than the free list size.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 3084dae5408e..8ad5d271d3f8 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1570,17 +1570,24 @@ static int disk_revalidate_zone_resources(struct gendisk *disk,
 {
 	struct queue_limits *lim = &disk->queue->limits;
 	unsigned int max_nr_zwplugs;
+	bool set_max_open = false;
 	int ret;
 
 	/*
 	 * If the device has no limit on the maximum number of open and active
 	 * zones, use BLK_ZONE_DEFAULT_MAX_NR_WPLUGS for the maximum number
-	 * of zone write plugs to hash.
+	 * of zone write plugs to hash and set the max_open_zones queue limit
+	 * of the device to indicate to the user the number of pre-allocated
+	 * zone write plugsso that the user is aware of the potential
+	 * performance penalty for simultaneously writing to more zones than
+	 * this limit.
 	 */
 	max_nr_zwplugs = max(lim->max_open_zones, lim->max_active_zones);
-	if (!max_nr_zwplugs)
+	if (!max_nr_zwplugs) {
 		max_nr_zwplugs =
 			min(BLK_ZONE_DEFAULT_MAX_NR_WPLUGS, nr_zones);
+		set_max_open = true;
+	}
 
 	if (!disk->zone_wplugs_hash) {
 		ret = disk_alloc_zone_resources(disk, max_nr_zwplugs);
@@ -1596,6 +1603,9 @@ static int disk_revalidate_zone_resources(struct gendisk *disk,
 			return ret;
 	}
 
+	if (set_max_open)
+		disk_set_max_open_zones(disk, max_nr_zwplugs);
+
 	return 0;
 }
 
-- 
2.44.0

