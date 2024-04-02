Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605581292CF;
	Tue,  2 Apr 2024 12:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712061585; cv=none; b=fK0o6r8ZPQSI1aoRtCWhXTiBM1zGMpVA9maslpKiSoymaH87cYTd9H06ed4Jep0L16LTDDF/6kwlkoRtIF0EP4w1mOaZyyYHjSWrZ++Ag7Qijbi4TuW7kkE0LGc4f2eSFItVqf6pECXioefoS8hk0+K/yK1ohg1DnoU+ivO+OiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712061585; c=relaxed/simple;
	bh=VitcxIZwdIEEK2MqVqH5NGz5tB5a5Ml9jwK0sEUOq+4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LEdmnlqvfU/wnADSZWcObiTXgFjSQyQ10MUq4Pq18+My+uIQGT8X4adIxqgP9Jh2B07CId2AVgAQOzZf7TzMC6exvjg4gBrUtC/61sonP+grS70rXrJJQXitEVSjRApNSRkBrAaQdpIEh7E3DuaYCnj89SDovFDoiRkPkZdTO2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ri+XpJlO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ri+XpJlO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319FEC43390;
	Tue,  2 Apr 2024 12:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712061585;
	bh=VitcxIZwdIEEK2MqVqH5NGz5tB5a5Ml9jwK0sEUOq+4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Ri+XpJlOYoQ9xkn3B6JSE2KLSGCwtt8+NW6c595UF38FZUYHQMyS7prbITGS5n3W1
	 BIcXt87oRQfrmd7Hutm2yKvjnHlBs79KS5IAHgmwO8Mcjs8KUe5CXp3BU8s9erDyTc
	 vL8Aq+e1Y2TNlGrJRYS6ANhrE/SbC9nqPBB7ZPaKTsBdIimsITlgPETwfEzyIjV0Kf
	 tjZTdfGiia/xVHD+W+7fGOP1Q5MWdq36A+4N/lIMbdmSSWGl6kMmUiQuuK7gtTGba8
	 L4jDCTrcj0RIK5plzNCcuh3hfP8hA3WOWAO65VqED3L1u1znwr0idmQ7QCG8/UJDYU
	 Bgdr6Pxj9hPOA==
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
Subject: [PATCH v4 25/28] block: Replace zone_wlock debugfs entry with zone_wplugs entry
Date: Tue,  2 Apr 2024 21:39:04 +0900
Message-ID: <20240402123907.512027-26-dlemoal@kernel.org>
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
index 8ba05d468604..988b40667321 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1823,17 +1823,34 @@ EXPORT_SYMBOL_GPL(blk_revalidate_disk_zones);
 
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

