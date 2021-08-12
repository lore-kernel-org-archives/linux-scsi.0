Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07439C4320A
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 07:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E147F60FD7
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 07:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbhHLHxj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 03:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbhHLHxi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Aug 2021 03:53:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB16C061765;
        Thu, 12 Aug 2021 00:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=wWW7AIkNQe77HsauzlC2WdUxTVoED3YT6I925GfE6kg=; b=kr5VcmuZYxE4sdDNZlHpeUyI0e
        dwmTFXXMzmhzWg85zDt367FiCrUEL9WOJduJdFzSRFQI10lmkasE2wXyKtTSAVq0FpSTQikspayID
        b0VhjM8F+qX4ccdb7mroAO8k+mZxoFsso1R1xuOmiwMKYJwZW5F+UpzrmY56kv/83jYHZgy8OPNZn
        TmvnJSPQV5fU6cVOf/UQ7GNj6sLyJ+yX3ZdRqejN1qFvEIDVIxjLkky+Bduxbj4Bq4vQmP/aUfuFf
        LA5cFXdGS/tSjP2NZ4/RWG/R4wL2WHEeUhkKLs6AzbwxbwidZaANrExZHsLolqJCjSL3MKAmjeA72
        1Epd3bMQ==;
Received: from [2001:4bb8:184:6215:d7d:1904:40de:694d] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mE5Ui-00EJ1b-Mz; Thu, 12 Aug 2021 07:51:28 +0000
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
Subject: [PATCH 5/8] block: remove alloc_disk and alloc_disk_node
Date:   Thu, 12 Aug 2021 09:46:39 +0200
Message-Id: <20210812074642.18592-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210812074642.18592-1-hch@lst.de>
References: <20210812074642.18592-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Most drivers should use and have been converted to use blk_alloc_disk
and blk_mq_alloc_disk.  Only the scsi ULPs and dasd still allocate
a disk separately from the request_queue, so don't bother with
convenience macros for something that should not see significant
new users and remove these wrappers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/s390/block/dasd_genhd.c |  5 ++++-
 drivers/scsi/sd.c               |  3 ++-
 drivers/scsi/sr.c               |  4 +++-
 include/linux/genhd.h           | 10 ----------
 4 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/s390/block/dasd_genhd.c b/drivers/s390/block/dasd_genhd.c
index 493e8469893c..07a69b19dd31 100644
--- a/drivers/s390/block/dasd_genhd.c
+++ b/drivers/s390/block/dasd_genhd.c
@@ -24,6 +24,8 @@
 
 #include "dasd_int.h"
 
+static struct lock_class_key dasd_bio_compl_lkclass;
+
 /*
  * Allocate and register gendisk structure for device.
  */
@@ -38,7 +40,8 @@ int dasd_gendisk_alloc(struct dasd_block *block)
 	if (base->devindex >= DASD_PER_MAJOR)
 		return -EBUSY;
 
-	gdp = alloc_disk(1 << DASD_PARTN_BITS);
+	gdp = __alloc_disk_node(1 << DASD_PARTN_BITS, NUMA_NO_NODE,
+				&dasd_bio_compl_lkclass);
 	if (!gdp)
 		return -ENOMEM;
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b8d55af763f9..4986086009f1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -129,6 +129,7 @@ static DEFINE_MUTEX(sd_ref_mutex);
 static struct kmem_cache *sd_cdb_cache;
 static mempool_t *sd_cdb_pool;
 static mempool_t *sd_page_pool;
+static struct lock_class_key sd_bio_compl_lkclass;
 
 static const char *sd_cache_types[] = {
 	"write through", "none", "write back",
@@ -3408,7 +3409,7 @@ static int sd_probe(struct device *dev)
 	if (!sdkp)
 		goto out;
 
-	gd = alloc_disk(SD_MINORS);
+	gd = __alloc_disk_node(SD_MINORS, NUMA_NO_NODE, &sd_bio_compl_lkclass);
 	if (!gd)
 		goto out_free;
 
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 94c254e9012e..fee2bdfe6132 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -106,6 +106,8 @@ static struct scsi_driver sr_template = {
 static unsigned long sr_index_bits[SR_DISKS / BITS_PER_LONG];
 static DEFINE_SPINLOCK(sr_index_lock);
 
+static struct lock_class_key sr_bio_compl_lkclass;
+
 /* This semaphore is used to mediate the 0->1 reference get in the
  * face of object destruction (i.e. we can't allow a get on an
  * object after last put) */
@@ -712,7 +714,7 @@ static int sr_probe(struct device *dev)
 
 	kref_init(&cd->kref);
 
-	disk = alloc_disk(1);
+	disk = __alloc_disk_node(1, NUMA_NO_NODE, &sr_bio_compl_lkclass);
 	if (!disk)
 		goto fail_free;
 	mutex_init(&cd->lock);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 031051057e13..bd8565e8f7c7 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -265,16 +265,6 @@ void blk_drop_partitions(struct gendisk *disk);
 struct gendisk *__alloc_disk_node(int minors, int node_id,
 		struct lock_class_key *lkclass);
 extern void put_disk(struct gendisk *disk);
-
-#define alloc_disk_node(minors, node_id)				\
-({									\
-	static struct lock_class_key __key;				\
-									\
-	__alloc_disk_node(minors, node_id, &__key);			\
-})
-
-#define alloc_disk(minors) alloc_disk_node(minors, NUMA_NO_NODE)
-
 struct gendisk *__blk_alloc_disk(int node, struct lock_class_key *lkclass);
 
 /**
-- 
2.30.2

