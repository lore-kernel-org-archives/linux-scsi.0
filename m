From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 3/8] dm core: add kmem_cache for request-based dm
Date: Fri, 03 Oct 2008 11:17:57 -0400 (EDT)
Message-ID: <20081003.111757.104028869.k-ueda@ct.jp.nec.com>
References: <20081003.110825.74754936.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56011 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbYJCPUN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Oct 2008 11:20:13 -0400
In-Reply-To: <20081003.110825.74754936.k-ueda@ct.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: agk@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, mbroz@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com

This patch prepares some kmem_cache for request-based dm.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 44 insertions(+), 1 deletion(-)

Index: 2.6.27-rc8/drivers/md/dm.c
===================================================================
--- 2.6.27-rc8.orig/drivers/md/dm.c
+++ 2.6.27-rc8/drivers/md/dm.c
@@ -32,6 +32,7 @@ static unsigned int _major = 0;
 
 static DEFINE_SPINLOCK(_minor_lock);
 /*
+ * For bio based dm.
  * One of these is allocated per bio.
  */
 struct dm_io {
@@ -43,6 +44,7 @@ struct dm_io {
 };
 
 /*
+ * For bio based dm.
  * One of these is allocated per target within a bio.  Hopefully
  * this will be simplified out one day.
  */
@@ -52,6 +54,31 @@ struct dm_target_io {
 	union map_info info;
 };
 
+/*
+ * For request based dm.
+ * One of these is allocated per request.
+ *
+ * Since assuming "original request : cloned request = 1 : 1" and
+ * a counter for number of clones like struct dm_io.io_count isn't needed,
+ * struct dm_io and struct target_io can be merged.
+ */
+struct dm_rq_target_io {
+	struct mapped_device *md;
+	struct dm_target *ti;
+	struct request *orig, clone;
+	int error;
+	union map_info info;
+};
+
+/*
+ * For request based dm.
+ * One of these is allocated per bio.
+ */
+struct dm_clone_bio_info {
+	struct bio *orig;
+	struct request *rq;
+};
+
 union map_info *dm_get_mapinfo(struct bio *bio)
 {
 	if (bio && bio->bi_private)
@@ -147,6 +174,8 @@ struct mapped_device {
 #define MIN_IOS 256
 static struct kmem_cache *_io_cache;
 static struct kmem_cache *_tio_cache;
+static struct kmem_cache *_rq_tio_cache;
+static struct kmem_cache *_bio_info_cache;
 
 static int __init local_init(void)
 {
@@ -162,9 +191,17 @@ static int __init local_init(void)
 	if (!_tio_cache)
 		goto out_free_io_cache;
 
+	_rq_tio_cache = KMEM_CACHE(dm_rq_target_io, 0);
+	if (!_rq_tio_cache)
+		goto out_free_tio_cache;
+
+	_bio_info_cache = KMEM_CACHE(dm_clone_bio_info, 0);
+	if (!_bio_info_cache)
+		goto out_free_rq_tio_cache;
+
 	r = dm_uevent_init();
 	if (r)
-		goto out_free_tio_cache;
+		goto out_free_bio_info_cache;
 
 	_major = major;
 	r = register_blkdev(_major, _name);
@@ -178,6 +215,10 @@ static int __init local_init(void)
 
 out_uevent_exit:
 	dm_uevent_exit();
+out_free_bio_info_cache:
+	kmem_cache_destroy(_bio_info_cache);
+out_free_rq_tio_cache:
+	kmem_cache_destroy(_rq_tio_cache);
 out_free_tio_cache:
 	kmem_cache_destroy(_tio_cache);
 out_free_io_cache:
@@ -188,6 +229,8 @@ out_free_io_cache:
 
 static void local_exit(void)
 {
+	kmem_cache_destroy(_bio_info_cache);
+	kmem_cache_destroy(_rq_tio_cache);
 	kmem_cache_destroy(_tio_cache);
 	kmem_cache_destroy(_io_cache);
 	unregister_blkdev(_major, _name);
