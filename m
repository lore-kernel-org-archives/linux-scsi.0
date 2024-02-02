Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBB8482ED;
	Fri,  2 Feb 2024 07:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706859105; cv=none; b=KqLpFgqTLrmN8gSGc+Og9tEQbnGo5dKrk3dYT1BssP+NqwhIk5imOpUqtKG+tG7DIIl/+cdhZ27felbZazJOc5NMdyFFBvPBdEeR5jY+oA0OSW5nEjR5+4RlaeNbo3GA4nt/Vub708XNjMtNRTPgyGXA+OqTPNmsV26vQ0IHaeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706859105; c=relaxed/simple;
	bh=/Q8pmOWghzzsj4JHNfxn3eIyx6ahEntWNrlVgRhwR98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhNf/0pVXNeGrbndT4GRch34LHTxPfXNTBHsFykvCWO1RauIYfTHvGrv+IPzW5Dv0Dsd3wrvph9J5gO0jqVLR7NE2EuLKi5tOVwh2iVzVjnt77QPnx5yliuAxJaU3i7GR4avYvdMUgZlbU4lwYiwN7rFIHeB4vx1GR8L4TJ59s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lgDB1A6m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lgDB1A6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA04C433F1;
	Fri,  2 Feb 2024 07:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706859104;
	bh=/Q8pmOWghzzsj4JHNfxn3eIyx6ahEntWNrlVgRhwR98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lgDB1A6mUQn3KmNKrJShlamyiKSTb38XWSThmla0KViSLIEjaRRW1fl4luivfU6PK
	 Hy18qaOXNhRpBaBy7MyVXPbvceMh8dSU2NuvK/BzGP4tUud1boRaMeukkDpfcK1WLK
	 aCdt6sApYZ1FwB9NjWRD/ZJUzupY1zbm2h5z+11QFdTBKWIPX8prx1JJALJ+dXqGf4
	 LuEsB4Zg7CCP5CPX0HlQycOVDEggU04FPXx8F4Gnuh8qNJCn6JwxnhIh5n1cpIPsJp
	 cumdSjD+AT9JC9/J+UModUAih814Uvzms0lQAyEFz61cATK4OVr+aPdbiMemixCqpJ
	 s9beQ82M52ECw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 26/26] block: Add zone_active_wplugs debugfs entry
Date: Fri,  2 Feb 2024 16:31:04 +0900
Message-ID: <20240202073104.2418230-27-dlemoal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240202073104.2418230-1-dlemoal@kernel.org>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the zone_active_wplugs debugfs entry to list the zone number and
write pointer offset of zones that have an active zone write plug.

This helps ensure that struct blk_zone_active_wplug are reclaimed as
zones become empty or full and allows observing which zones are being
written by the block device user.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-mq-debugfs.c |  1 +
 block/blk-mq-debugfs.h |  5 +++++
 block/blk-zoned.c      | 27 +++++++++++++++++++++++++++
 3 files changed, 33 insertions(+)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index b803f5b370e9..5390526f2ab0 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -161,6 +161,7 @@ static const struct blk_mq_debugfs_attr blk_mq_debugfs_queue_attrs[] = {
 	{ "pm_only", 0600, queue_pm_only_show, NULL },
 	{ "state", 0600, queue_state_show, queue_state_write },
 	{ "zone_plugged_wplugs", 0400, queue_zone_plugged_wplugs_show, NULL },
+	{ "zone_active_wplugs", 0400, queue_zone_active_wplugs_show, NULL },
 	{ },
 };
 
diff --git a/block/blk-mq-debugfs.h b/block/blk-mq-debugfs.h
index 6d3ac4b77d59..ee0e34345ee7 100644
--- a/block/blk-mq-debugfs.h
+++ b/block/blk-mq-debugfs.h
@@ -85,11 +85,16 @@ static inline void blk_mq_debugfs_unregister_rqos(struct rq_qos *rqos)
 
 #if defined(CONFIG_BLK_DEV_ZONED) && defined(CONFIG_BLK_DEBUG_FS)
 int queue_zone_plugged_wplugs_show(void *data, struct seq_file *m);
+int queue_zone_active_wplugs_show(void *data, struct seq_file *m);
 #else
 static inline int queue_zone_plugged_wplugs_show(void *data, struct seq_file *m)
 {
 	return 0;
 }
+static inline int queue_zone_active_wplugs_show(void *data, struct seq_file *m)
+{
+	return 0;
+}
 #endif
 
 #endif
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 865fc372f25e..c9b31b28b5a2 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1526,6 +1526,33 @@ int queue_zone_plugged_wplugs_show(void *data, struct seq_file *m)
 	return 0;
 }
 
+int queue_zone_active_wplugs_show(void *data, struct seq_file *m)
+{
+	struct request_queue *q = data;
+	struct gendisk *disk = q->disk;
+	struct blk_zone_wplug *zwplug;
+	unsigned int i, wp_offset;
+	unsigned long flags;
+	bool active;
+
+	if (!disk->zone_wplugs)
+		return 0;
+
+	for (i = 0; i < disk->nr_zones; i++) {
+		zwplug = &disk->zone_wplugs[i];
+		blk_zone_wplug_lock(zwplug, flags);
+		active = zwplug->flags & BLK_ZONE_WPLUG_ACTIVE;
+		if (active)
+			wp_offset = zwplug->zawplug->wp_offset;
+		blk_zone_wplug_unlock(zwplug, flags);
+
+		if (active)
+			seq_printf(m, "%u %u\n", i, wp_offset);
+	}
+
+	return 0;
+}
+
 #endif
 
 void blk_zone_dev_init(void)
-- 
2.43.0

