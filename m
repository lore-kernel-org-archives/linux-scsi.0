From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH 1/2] [SCSI] libsrp: replace kfifo_init with kfifo_alloc
Date: Mon, 19 Nov 2012 16:58:58 +0800
Message-ID: <1353315539-10424-1-git-send-email-yuanhan.liu@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Stefani Seibold <stefani@seibold.net>
List-Id: linux-scsi@vger.kernel.org

kfifo_init will use a pre-allocated buffer as fifo buffer; the buffer
size is determinted at caller side. While, kfifo will maintain a real
kfifo buffer size(power of 2 aligned). So, the two size may not be
equal.

So, to be safe. We should use kfifo_alloc instead. git grep 'kfifo_init\>'
shows that this is one user of kfifo_init(2 in total).

Replace it with kfifo_alloc, as I propose to remove kfifo_init API
later.

Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 drivers/scsi/libsrp.c |   22 ++++++++++------------
 include/scsi/libsrp.h |    1 -
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
index 0707ecd..63db792 100644
--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -50,34 +50,32 @@ static int srp_iu_pool_alloc(struct srp_queue *q, size_t max,
 			     struct srp_buf **ring)
 {
 	int i;
+	int ret;
 	struct iu_entry *iue;
 
-	q->pool = kcalloc(max, sizeof(struct iu_entry *), GFP_KERNEL);
+	q->pool = kcalloc(max, sizeof(struct iu_entry), GFP_KERNEL);
 	if (!q->pool)
 		return -ENOMEM;
-	q->items = kcalloc(max, sizeof(struct iu_entry), GFP_KERNEL);
-	if (!q->items)
-		goto free_pool;
+
+	ret = kfifo_alloc(&q->queue, max * sizeof(void *), GFP_KERNEL);
+	if (ret < 0) {
+		kfree(q->pool);
+		return ret;
+	}
 
 	spin_lock_init(&q->lock);
-	kfifo_init(&q->queue, (void *) q->pool, max * sizeof(void *));
 
-	for (i = 0, iue = q->items; i < max; i++) {
+	for (i = 0, iue = q->pool; i < max; i++) {
 		kfifo_in(&q->queue, (void *) &iue, sizeof(void *));
 		iue->sbuf = ring[i];
 		iue++;
 	}
 	return 0;
-
-	kfree(q->items);
-free_pool:
-	kfree(q->pool);
-	return -ENOMEM;
 }
 
 static void srp_iu_pool_free(struct srp_queue *q)
 {
-	kfree(q->items);
+	kfifo_free(&q->queue);
 	kfree(q->pool);
 }
 
diff --git a/include/scsi/libsrp.h b/include/scsi/libsrp.h
index f4105c9..999b1e7 100644
--- a/include/scsi/libsrp.h
+++ b/include/scsi/libsrp.h
@@ -21,7 +21,6 @@ struct srp_buf {
 
 struct srp_queue {
 	void *pool;
-	void *items;
 	struct kfifo queue;
 	spinlock_t lock;
 };
-- 
1.7.7.6
