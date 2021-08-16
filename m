Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C80C432BE
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 13:41:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B02B632C5
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 13:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237572AbhHPNmO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 09:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237753AbhHPNmM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Aug 2021 09:42:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52969C04DA31;
        Mon, 16 Aug 2021 06:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=b+mPlQ41yJJaOaprcjDi6z6quhDobi/0BF6d4pv7hHY=; b=jO8bLjuDodO2AJaxaqUBG24sow
        S43kIQc7B8n+78Dz4WnZQSVGAjXtfKVgEqhH74Vp/qxhRNuvH7zD4qA4j9Uyvn9MSMVYTForPM6fZ
        /hePVQNCSNP8sQDSOLmzDInmfio5FPp7fMh0yevDzSp1hrT0RFGf88Acu9CfdufbDGVDPI8fZ6txn
        3UUYVxVuTmMEZdpmcdDFG4KsQ/bSNX/uniNYkGrIEx2M+2qOz57nD1NP1cp4uMyCIjnWmbWIHH0dQ
        Sf1XtjvS3R5PsMjlyPpj/0VbUs67+msxOoM3zzBMa4gm0+lFNWZCte0FVwektjfXFI8csLsGqzmhI
        jxG3vBbw==;
Received: from [2001:4bb8:188:1b1:3731:604a:a6cd:dc60] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mFcb7-001Oqz-N8; Mon, 16 Aug 2021 13:24:42 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 4/9] block: cleanup the lockdep handling in *alloc_disk
Date:   Mon, 16 Aug 2021 15:19:05 +0200
Message-Id: <20210816131910.615153-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210816131910.615153-1-hch@lst.de>
References: <20210816131910.615153-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Pass the lockdep name to the low-level __blk_alloc_disk helper and
hardcode the name for it given that the number of minors or node_id
are not very useful information.  While this passes a pointless
argument for non-lockdep builds that is not really an issue as
disk allocation is a probe time only slow path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c         |  5 +++--
 block/genhd.c          |  8 +++++---
 include/linux/blk-mq.h | 10 +++-------
 include/linux/genhd.h  | 23 ++++++-----------------
 4 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index d2725f94491d..4c56e43e6992 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3133,7 +3133,8 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 }
 EXPORT_SYMBOL(blk_mq_init_queue);
 
-struct gendisk *__blk_mq_alloc_disk(struct blk_mq_tag_set *set, void *queuedata)
+struct gendisk *__blk_mq_alloc_disk(struct blk_mq_tag_set *set, void *queuedata,
+		struct lock_class_key *lkclass)
 {
 	struct request_queue *q;
 	struct gendisk *disk;
@@ -3142,7 +3143,7 @@ struct gendisk *__blk_mq_alloc_disk(struct blk_mq_tag_set *set, void *queuedata)
 	if (IS_ERR(q))
 		return ERR_CAST(q);
 
-	disk = __alloc_disk_node(0, set->numa_node);
+	disk = __alloc_disk_node(0, set->numa_node, lkclass);
 	if (!disk) {
 		blk_cleanup_queue(q);
 		return ERR_PTR(-ENOMEM);
diff --git a/block/genhd.c b/block/genhd.c
index 731a46063132..2ad2b25dfc87 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1254,7 +1254,8 @@ dev_t blk_lookup_devt(const char *name, int partno)
 	return devt;
 }
 
-struct gendisk *__alloc_disk_node(int minors, int node_id)
+struct gendisk *__alloc_disk_node(int minors, int node_id,
+		struct lock_class_key *lkclass)
 {
 	struct gendisk *disk;
 
@@ -1282,6 +1283,7 @@ struct gendisk *__alloc_disk_node(int minors, int node_id)
 	disk_to_dev(disk)->type = &disk_type;
 	device_initialize(disk_to_dev(disk));
 	inc_diskseq(disk);
+	lockdep_init_map(&disk->lockdep_map, "(bio completion)", lkclass, 0);
 #ifdef CONFIG_BLOCK_HOLDER_DEPRECATED
 	INIT_LIST_HEAD(&disk->slave_bdevs);
 #endif
@@ -1298,7 +1300,7 @@ struct gendisk *__alloc_disk_node(int minors, int node_id)
 }
 EXPORT_SYMBOL(__alloc_disk_node);
 
-struct gendisk *__blk_alloc_disk(int node)
+struct gendisk *__blk_alloc_disk(int node, struct lock_class_key *lkclass)
 {
 	struct request_queue *q;
 	struct gendisk *disk;
@@ -1307,7 +1309,7 @@ struct gendisk *__blk_alloc_disk(int node)
 	if (!q)
 		return NULL;
 
-	disk = __alloc_disk_node(0, node);
+	disk = __alloc_disk_node(0, node, lkclass);
 	if (!disk) {
 		blk_cleanup_queue(q);
 		return NULL;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 22215db36122..13ba1861e688 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -432,18 +432,14 @@ enum {
 	((policy & ((1 << BLK_MQ_F_ALLOC_POLICY_BITS) - 1)) \
 		<< BLK_MQ_F_ALLOC_POLICY_START_BIT)
 
+struct gendisk *__blk_mq_alloc_disk(struct blk_mq_tag_set *set, void *queuedata,
+		struct lock_class_key *lkclass);
 #define blk_mq_alloc_disk(set, queuedata)				\
 ({									\
 	static struct lock_class_key __key;				\
-	struct gendisk *__disk = __blk_mq_alloc_disk(set, queuedata);	\
 									\
-	if (!IS_ERR(__disk))						\
-		lockdep_init_map(&__disk->lockdep_map,			\
-			"(bio completion)", &__key, 0);			\
-	__disk;								\
+	__blk_mq_alloc_disk(set, queuedata, &__key);			\
 })
-struct gendisk *__blk_mq_alloc_disk(struct blk_mq_tag_set *set,
-		void *queuedata);
 struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *);
 int blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 		struct request_queue *q);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index b47e297cd551..3d2e5ee30677 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -259,27 +259,21 @@ static inline sector_t get_capacity(struct gendisk *disk)
 int bdev_disk_changed(struct gendisk *disk, bool invalidate);
 void blk_drop_partitions(struct gendisk *disk);
 
-extern struct gendisk *__alloc_disk_node(int minors, int node_id);
+struct gendisk *__alloc_disk_node(int minors, int node_id,
+		struct lock_class_key *lkclass);
 extern void put_disk(struct gendisk *disk);
 
 #define alloc_disk_node(minors, node_id)				\
 ({									\
 	static struct lock_class_key __key;				\
-	const char *__name;						\
-	struct gendisk *__disk;						\
 									\
-	__name = "(gendisk_completion)"#minors"("#node_id")";		\
-									\
-	__disk = __alloc_disk_node(minors, node_id);			\
-									\
-	if (__disk)							\
-		lockdep_init_map(&__disk->lockdep_map, __name, &__key, 0); \
-									\
-	__disk;								\
+	__alloc_disk_node(minors, node_id, &__key);			\
 })
 
 #define alloc_disk(minors) alloc_disk_node(minors, NUMA_NO_NODE)
 
+struct gendisk *__blk_alloc_disk(int node, struct lock_class_key *lkclass);
+
 /**
  * blk_alloc_disk - allocate a gendisk structure
  * @node_id: numa node to allocate on
@@ -291,15 +285,10 @@ extern void put_disk(struct gendisk *disk);
  */
 #define blk_alloc_disk(node_id)						\
 ({									\
-	struct gendisk *__disk = __blk_alloc_disk(node_id);		\
 	static struct lock_class_key __key;				\
 									\
-	if (__disk)							\
-		lockdep_init_map(&__disk->lockdep_map,			\
-			"(bio completion)", &__key, 0);			\
-	__disk;								\
+	__blk_alloc_disk(node_id, &__key);				\
 })
-struct gendisk *__blk_alloc_disk(int node);
 void blk_cleanup_disk(struct gendisk *disk);
 
 int __register_blkdev(unsigned int major, const char *name,
-- 
2.30.2

