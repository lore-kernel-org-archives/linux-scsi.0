From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/14] blk-mq: add blk_mq_resize_tag_set()
Date: Thu,  2 Jun 2016 16:39:10 +0200
Message-ID: <1464878356-42407-9-git-send-email-hare@suse.de>
References: <1464878356-42407-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54600 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932957AbcFBOjW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jun 2016 10:39:22 -0400
In-Reply-To: <1464878356-42407-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Add a function to resize the number of tags in an existing tag set.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 block/blk-mq.c         | 15 +++++++++++++++
 include/linux/blk-mq.h |  1 +
 2 files changed, 16 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 29cbc1b..e2afe45 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2385,6 +2385,21 @@ void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues)
 }
 EXPORT_SYMBOL_GPL(blk_mq_update_nr_hw_queues);
 
+int blk_mq_resize_tag_set(struct blk_mq_tag_set *set, int new_tags)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < set->nr_hw_queues; i++) {
+		if (!set->tags[i])
+			continue;
+		ret = blk_mq_tag_update_depth(set->tags[i], new_tags);
+		if (ret)
+			break;
+	}
+	return ret;
+}
+EXPORT_SYMBOL(blk_mq_resize_tag_set);
+
 void blk_mq_disable_hotplug(void)
 {
 	mutex_lock(&all_q_mutex);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 2498fdf..8b603b6 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -181,6 +181,7 @@ void blk_mq_unregister_disk(struct gendisk *);
 
 int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set);
 void blk_mq_free_tag_set(struct blk_mq_tag_set *set);
+int blk_mq_resize_tag_set(struct blk_mq_tag_set *set, int new_tags);
 
 void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule);
 
-- 
1.8.5.6

