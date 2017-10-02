From: Tim Hansen <devtimhansen@gmail.com>
Subject: [PATCH] bsg: update bsg_device_list to utilize static hash table
 implementation.
Date: Mon, 2 Oct 2017 12:10:01 -0400
Message-ID: <20171002161001.GA49685@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-block-owner@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, alexander.levin@one.verizon.com, devtimhansen@gmail.com
List-Id: linux-scsi@vger.kernel.org

Updates bsg_device_list to utilize static hashtable implementation.

This is done in an effort to standarize the hashtables used across the
kernel.

Signed-off-by: Tim Hansen <devtimhansen@gmail.com>
---
 block/bsg.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index ee1335c68de7..ecb93d733b56 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -66,8 +66,8 @@ enum {
 static DEFINE_MUTEX(bsg_mutex);
 static DEFINE_IDR(bsg_minor_idr);
 
-#define BSG_LIST_ARRAY_SIZE	8
-static struct hlist_head bsg_device_list[BSG_LIST_ARRAY_SIZE];
+#define BSG_HASHTABLE_BIT_SIZE		3
+static DEFINE_HASHTABLE(bsg_device_list, BSG_HASHTABLE_BIT_SIZE);
 
 static struct class *bsg_class;
 static int bsg_major;
@@ -130,11 +130,6 @@ static struct bsg_command *bsg_alloc_command(struct bsg_device *bd)
 	return bc;
 }
 
-static inline struct hlist_head *bsg_dev_idx_hash(int index)
-{
-	return &bsg_device_list[index & (BSG_LIST_ARRAY_SIZE - 1)];
-}
-
 static int blk_fill_sgv4_hdr_rq(struct request_queue *q, struct request *rq,
 				struct sg_io_v4 *hdr, struct bsg_device *bd,
 				fmode_t has_write_perm)
@@ -716,7 +711,7 @@ static int bsg_put_device(struct bsg_device *bd)
 		goto out;
 	}
 
-	hlist_del(&bd->dev_list);
+	hash_del(&bd->dev_list);
 	mutex_unlock(&bsg_mutex);
 
 	dprintk("%s: tearing down\n", bd->name);
@@ -770,7 +765,7 @@ static struct bsg_device *bsg_add_device(struct inode *inode,
 
 	atomic_set(&bd->ref_count, 1);
 	mutex_lock(&bsg_mutex);
-	hlist_add_head(&bd->dev_list, bsg_dev_idx_hash(iminor(inode)));
+	hash_add(bsg_device_list, &bd->dev_list, iminor(inode));
 
 	strncpy(bd->name, dev_name(rq->bsg_dev.class_dev), sizeof(bd->name) - 1);
 	dprintk("bound to <%s>, max queue %d\n",
@@ -786,7 +781,7 @@ static struct bsg_device *__bsg_get_device(int minor, struct request_queue *q)
 
 	mutex_lock(&bsg_mutex);
 
-	hlist_for_each_entry(bd, bsg_dev_idx_hash(minor), dev_list) {
+	hash_for_each_possible(bsg_device_list, bd, dev_list, minor) {
 		if (bd->queue == q) {
 			atomic_inc(&bd->ref_count);
 			goto found;
@@ -1042,7 +1037,7 @@ static char *bsg_devnode(struct device *dev, umode_t *mode)
 
 static int __init bsg_init(void)
 {
-	int ret, i;
+	int ret;
 	dev_t devid;
 
 	bsg_cmd_cachep = kmem_cache_create("bsg_cmd",
@@ -1052,9 +1047,6 @@ static int __init bsg_init(void)
 		return -ENOMEM;
 	}
 
-	for (i = 0; i < BSG_LIST_ARRAY_SIZE; i++)
-		INIT_HLIST_HEAD(&bsg_device_list[i]);
-
 	bsg_class = class_create(THIS_MODULE, "bsg");
 	if (IS_ERR(bsg_class)) {
 		ret = PTR_ERR(bsg_class);
-- 
2.14.2
