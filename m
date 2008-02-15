From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [APPENDIX PATCH 07/13] dm: add memory pool
Date: Fri, 15 Feb 2008 17:31:26 -0500 (EST)
Message-ID: <20080215.173126.111205704.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761695AbYBOWcE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2008 17:32:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com

This patch prepares memory pools for request-based dm.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm.c |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletion(-)

Index: 2.6.25-rc1/drivers/md/dm.c
===================================================================
--- 2.6.25-rc1.orig/drivers/md/dm.c
+++ 2.6.25-rc1/drivers/md/dm.c
@@ -52,6 +52,22 @@ struct dm_target_io {
 	union map_info info;
 };
 
+/*
+ * For request based dm.
+ * One of these is allocated per request.
+ *
+ * Since assuming "original request : cloned request = 1 : 1" and
+ * a counter for number of clones like struct dm_io.io_count isn't needed,
+ * struct dm_io and struct target_io can merge.
+ */
+struct dm_rq_target_io {
+	struct mapped_device *md;
+	struct dm_target *ti;
+	struct request *orig, clone;
+	int error;
+	union map_info info;
+};
+
 union map_info *dm_get_mapinfo(struct bio *bio)
 {
 	if (bio && bio->bi_private)
@@ -147,6 +163,7 @@ struct mapped_device {
 #define MIN_IOS 256
 static struct kmem_cache *_io_cache;
 static struct kmem_cache *_tio_cache;
+static struct kmem_cache *_rq_tio_cache; /* tio pool for request-based dm */
 
 static int __init local_init(void)
 {
@@ -162,9 +179,13 @@ static int __init local_init(void)
 	if (!_tio_cache)
 		goto out_free_io_cache;
 
+	_rq_tio_cache = KMEM_CACHE(dm_rq_target_io, 0);
+	if (!_rq_tio_cache)
+		goto out_free_tio_cache;
+
 	r = dm_uevent_init();
 	if (r)
-		goto out_free_tio_cache;
+		goto out_free_rq_tio_cache;
 
 	_major = major;
 	r = register_blkdev(_major, _name);
@@ -178,6 +199,8 @@ static int __init local_init(void)
 
 out_uevent_exit:
 	dm_uevent_exit();
+out_free_rq_tio_cache:
+	kmem_cache_destroy(_rq_tio_cache);
 out_free_tio_cache:
 	kmem_cache_destroy(_tio_cache);
 out_free_io_cache:
@@ -188,6 +211,7 @@ out_free_io_cache:
 
 static void local_exit(void)
 {
+	kmem_cache_destroy(_rq_tio_cache);
 	kmem_cache_destroy(_tio_cache);
 	kmem_cache_destroy(_io_cache);
 	unregister_blkdev(_major, _name);
