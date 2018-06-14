From: Anatoliy Glagolev <glagolig@gmail.com>
Subject: Re: [PATCHv2] block: fix bsg_unregister and bsg_open race
Date: Thu, 14 Jun 2018 17:47:34 -0600
Message-ID: <20180614234733.GA38460@xldev-tmpl.dev.purestorage.com>
References: <20180613221417.GA22778@xldev-tmpl.dev.purestorage.com>
 <20180614083806.GA18966@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180614083806.GA18966@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Thanks, Christoph. Good catch releasing the mutex on failure path.
V2 patch with your suggestions applied.


>From 7a8dc4b10f344d915658549581158f3da2cc1f91 Mon Sep 17 00:00:00 2001
From: Anatoliy Glagolev <glagolig@gmail.com>
Date: Wed, 13 Jun 2018 15:38:51 -0600
Subject: [PATCHv2] Fix race of bsg_open and bsg_unregister
Signed-Off-By: Anatoliy Glagolev <glagolig@gmail.com>

---
 block/bsg.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 132e657..66602c4 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -693,6 +693,8 @@ static struct bsg_device *bsg_add_device(struct inode *inode,
 	struct bsg_device *bd;
 	unsigned char buf[32];
 
+	lockdep_assert_held(&bsg_mutex);
+
 	if (!blk_get_queue(rq))
 		return ERR_PTR(-ENXIO);
 
@@ -707,14 +709,12 @@ static struct bsg_device *bsg_add_device(struct inode *inode,
 	bsg_set_block(bd, file);
 
 	atomic_set(&bd->ref_count, 1);
-	mutex_lock(&bsg_mutex);
 	hlist_add_head(&bd->dev_list, bsg_dev_idx_hash(iminor(inode)));
 
 	strncpy(bd->name, dev_name(rq->bsg_dev.class_dev), sizeof(bd->name) - 1);
 	bsg_dbg(bd, "bound to <%s>, max queue %d\n",
 		format_dev_t(buf, inode->i_rdev), bd->max_queue);
 
-	mutex_unlock(&bsg_mutex);
 	return bd;
 }
 
@@ -722,7 +722,7 @@ static struct bsg_device *__bsg_get_device(int minor, struct request_queue *q)
 {
 	struct bsg_device *bd;
 
-	mutex_lock(&bsg_mutex);
+	lockdep_assert_held(&bsg_mutex);
 
 	hlist_for_each_entry(bd, bsg_dev_idx_hash(minor), dev_list) {
 		if (bd->queue == q) {
@@ -732,7 +732,6 @@ static struct bsg_device *__bsg_get_device(int minor, struct request_queue *q)
 	}
 	bd = NULL;
 found:
-	mutex_unlock(&bsg_mutex);
 	return bd;
 }
 
@@ -746,17 +745,18 @@ static struct bsg_device *bsg_get_device(struct inode *inode, struct file *file)
 	 */
 	mutex_lock(&bsg_mutex);
 	bcd = idr_find(&bsg_minor_idr, iminor(inode));
-	mutex_unlock(&bsg_mutex);
 
-	if (!bcd)
-		return ERR_PTR(-ENODEV);
+	if (!bcd) {
+		bd = ERR_PTR(-ENODEV);
+		goto out_unlock;
+	}
 
 	bd = __bsg_get_device(iminor(inode), bcd->queue);
-	if (bd)
-		return bd;
-
-	bd = bsg_add_device(inode, bcd->queue, file);
+	if (!bd)
+		bd = bsg_add_device(inode, bcd->queue, file);
 
+out_unlock:
+	mutex_unlock(&bsg_mutex);
 	return bd;
 }
 
-- 
1.9.1
