From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [RFC PATCH 07/13] dm: add memory pool
Date: Wed, 19 Mar 2008 18:10:16 -0500 (EST)
Message-ID: <20080319.181016.66181485.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, michaelc@cs.wisc.edu, hare@suse.de, agk@redhat.com, linux-kernel@vger.kernel.org
Cc: j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch prepares memory pools for request-based dm.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 38 insertions(+), 1 deletion(-)

Index: 2.6.25-rc5/drivers/md/dm.c
===================================================================
--- 2.6.25-rc5.orig/drivers/md/dm.c
+++ 2.6.25-rc5/drivers/md/dm.c
@@ -52,6 +52,27 @@ struct dm_target_io {
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
+struct dm_clone_bio_info {
+	struct bio *orig;
+	struct request *rq;
+};
+
 union map_info *dm_get_mapinfo(struct bio *bio)
 {
 	if (bio && bio->bi_private)
@@ -148,6 +169,8 @@ struct mapped_device {
 #define MIN_IOS 256
 static struct kmem_cache *_io_cache;
 static struct kmem_cache *_tio_cache;
+static struct kmem_cache *_rq_tio_cache;
+static struct kmem_cache *_bio_info_cache;
 
 static int __init local_init(void)
 {
@@ -163,9 +186,17 @@ static int __init local_init(void)
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
@@ -179,6 +210,10 @@ static int __init local_init(void)
 
 out_uevent_exit:
 	dm_uevent_exit();
+out_free_bio_info_cache:
+	kmem_cache_destroy(_bio_info_cache);
+out_free_rq_tio_cache:
+	kmem_cache_destroy(_rq_tio_cache);
 out_free_tio_cache:
 	kmem_cache_destroy(_tio_cache);
 out_free_io_cache:
@@ -189,6 +224,8 @@ out_free_io_cache:
 
 static void local_exit(void)
 {
+	kmem_cache_destroy(_bio_info_cache);
+	kmem_cache_destroy(_rq_tio_cache);
 	kmem_cache_destroy(_tio_cache);
 	kmem_cache_destroy(_io_cache);
 	unregister_blkdev(_major, _name);
