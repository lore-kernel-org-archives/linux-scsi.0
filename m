Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BD83A29F;
	Mon,  8 Apr 2024 01:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712540536; cv=none; b=HfGSnEtNqVv167fozIzx4OHLEupUG9x8nJNy20AlE4oGSr1N9H39MiKIGp0ihb1UuwIoBg88uUIeiBCNuz+EW789kwabtoa7CfBRiVjS372QxntI7JXSWpYMhK5r6rDtUpRh/gcHK7OX4j4AKpmHc1AiU7qKcx+8uacX3xAD7rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712540536; c=relaxed/simple;
	bh=+JVRlxBX5aHT/XzoHY0UOH1PXIqeE4dJyv+Nxl96AQY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Si44Ad6ONod2vbK+r3Ct0nQOvdLWAAAmQN9lS7yPqAVzjd3dh4A3y+DrgWFZXMmp8W/QK+Q9Mn7BCemDRkMjuQcGgqy22SXMPICKavYHNJsfEVOGJWLzqn7d8NGPIzr/MuPAOk8DqFLmi7WqWRCDJeuvzW+iRONklGT6OxwfIIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HpFLi7dL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HpFLi7dL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6855AC433F1;
	Mon,  8 Apr 2024 01:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712540536;
	bh=+JVRlxBX5aHT/XzoHY0UOH1PXIqeE4dJyv+Nxl96AQY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=HpFLi7dL8zTkAprcsLjDjkTlBcIUNMPvr3lYyJTwmuufXd45q9mb4Mh1zOuE9Q/0D
	 Hap4gPTYrdIm6ll2crGeSr15WH6EWR9pIMmINyOriNs6z5YlUTDbk38CTGkwSa0sOW
	 8zzXHrgo7KzTymgTxxLmlB1kYnxPutICJHBmx5+R5zTpj2H5rGtM/QX/55yRnUCamM
	 qvHCYfyhAeZG44taq2GkLRKJ5K9po8bXPy3VJGACimbQWaart5HHfKDwT5rxUuYBTS
	 FdIwsqifbnkFQLdGP0MLvtBLHdxNZma9JKXko89qLPQi4hrOp0sVyVte4E7rcUQp+Q
	 A94+QlmRr4uxg==
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
Subject: [PATCH v7 25/28] block: Replace zone_wlock debugfs entry with zone_wplugs entry
Date: Mon,  8 Apr 2024 10:41:25 +0900
Message-ID: <20240408014128.205141-26-dlemoal@kernel.org>
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

In preparation to completely remove zone write locking, replace the
"zone_wlock" mq-debugfs entry that was listing zones that are
write-locked with the zone_wplugs entry which lists the zones that
currently have a write plug allocated.

The write plug information provided is: the zone number, the zone write
plug flags, the zone write plug write pointer offset and the number of
BIOs currently waiting for execution in the zone write plug BIO list.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Hans Holmberg <hans.holmberg@wdc.com>
Tested-by: Dennis Maisenbacher <dennis.maisenbacher@wdc.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-mq-debugfs.c |  2 +-
 block/blk-mq-debugfs.h |  4 ++--
 block/blk-zoned.c      | 31 ++++++++++++++++++++++++-------
 3 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 94668e72ab09..ca1f2b9422d5 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -160,7 +160,7 @@ static const struct blk_mq_debugfs_attr blk_mq_debugfs_queue_attrs[] = {
 	{ "requeue_list", 0400, .seq_ops = &queue_requeue_list_seq_ops },
 	{ "pm_only", 0600, queue_pm_only_show, NULL },
 	{ "state", 0600, queue_state_show, queue_state_write },
-	{ "zone_wlock", 0400, queue_zone_wlock_show, NULL },
+	{ "zone_wplugs", 0400, queue_zone_wplugs_show, NULL },
 	{ },
 };
 
diff --git a/block/blk-mq-debugfs.h b/block/blk-mq-debugfs.h
index 3ebe2c29b624..c80e453e3014 100644
--- a/block/blk-mq-debugfs.h
+++ b/block/blk-mq-debugfs.h
@@ -84,9 +84,9 @@ static inline void blk_mq_debugfs_unregister_rqos(struct rq_qos *rqos)
 #endif
 
 #if defined(CONFIG_BLK_DEV_ZONED) && defined(CONFIG_BLK_DEBUG_FS)
-int queue_zone_wlock_show(void *data, struct seq_file *m);
+int queue_zone_wplugs_show(void *data, struct seq_file *m);
 #else
-static inline int queue_zone_wlock_show(void *data, struct seq_file *m)
+static inline int queue_zone_wplugs_show(void *data, struct seq_file *m)
 {
 	return 0;
 }
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index a06d7f7a54c7..44699b431ad0 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1808,17 +1808,34 @@ EXPORT_SYMBOL_GPL(blk_revalidate_disk_zones);
 
 #ifdef CONFIG_BLK_DEBUG_FS
 
-int queue_zone_wlock_show(void *data, struct seq_file *m)
+int queue_zone_wplugs_show(void *data, struct seq_file *m)
 {
 	struct request_queue *q = data;
-	unsigned int i;
+	struct gendisk *disk = q->disk;
+	struct blk_zone_wplug *zwplug;
+	unsigned int zwp_wp_offset, zwp_flags;
+	unsigned int zwp_zone_no, zwp_ref;
+	unsigned int zwp_bio_list_size, i;
+	unsigned long flags;
 
-	if (!q->disk->seq_zones_wlock)
-		return 0;
+	rcu_read_lock();
+	for (i = 0; i < disk_zone_wplugs_hash_size(disk); i++) {
+		hlist_for_each_entry_rcu(zwplug,
+					 &disk->zone_wplugs_hash[i], node) {
+			spin_lock_irqsave(&zwplug->lock, flags);
+			zwp_zone_no = zwplug->zone_no;
+			zwp_flags = zwplug->flags;
+			zwp_ref = atomic_read(&zwplug->ref);
+			zwp_wp_offset = zwplug->wp_offset;
+			zwp_bio_list_size = bio_list_size(&zwplug->bio_list);
+			spin_unlock_irqrestore(&zwplug->lock, flags);
 
-	for (i = 0; i < q->disk->nr_zones; i++)
-		if (test_bit(i, q->disk->seq_zones_wlock))
-			seq_printf(m, "%u\n", i);
+			seq_printf(m, "%u 0x%x %u %u %u\n",
+				   zwp_zone_no, zwp_flags, zwp_ref,
+				   zwp_wp_offset, zwp_bio_list_size);
+		}
+	}
+	rcu_read_unlock();
 
 	return 0;
 }
-- 
2.44.0

