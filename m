From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 4/5] bsg: remove minor in struct bsg_device
Date: Mon, 31 Mar 2008 10:03:41 +0900
Message-ID: <1206925422-4722-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: 20080331092020R.fujita.tomonori@lab.ntt.co.jp
 <1206925422-4722-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206925422-4722-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206925422-4722-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206925422-4722-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:52121 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612AbYCaBFK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Mar 2008 21:05:10 -0400
In-Reply-To: <1206925422-4722-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, pw@osc.edu, tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

minor in struct bsg_device is used as identifier to find the
corresponding struct bsg_device_class. However, request_queuse can be
used as identifier for that and the minor in struct bsg_device is
unnecessary.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 block/bsg.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index b413318..9339981 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -37,7 +37,6 @@ struct bsg_device {
 	struct list_head done_list;
 	struct hlist_node dev_list;
 	atomic_t ref_count;
-	int minor;
 	int queued_cmds;
 	int done_cmds;
 	wait_queue_head_t wq_done;
@@ -758,9 +757,8 @@ static struct bsg_device *bsg_add_device(struct inode *inode,
 	bsg_set_block(bd, file);
 
 	atomic_set(&bd->ref_count, 1);
-	bd->minor = iminor(inode);
 	mutex_lock(&bsg_mutex);
-	hlist_add_head(&bd->dev_list, bsg_dev_idx_hash(bd->minor));
+	hlist_add_head(&bd->dev_list, bsg_dev_idx_hash(iminor(inode)));
 
 	strncpy(bd->name, rq->bsg_dev.class_dev->class_id, sizeof(bd->name) - 1);
 	dprintk("bound to <%s>, max queue %d\n",
@@ -770,7 +768,7 @@ static struct bsg_device *bsg_add_device(struct inode *inode,
 	return bd;
 }
 
-static struct bsg_device *__bsg_get_device(int minor)
+static struct bsg_device *__bsg_get_device(int minor, struct request_queue *q)
 {
 	struct bsg_device *bd;
 	struct hlist_node *entry;
@@ -778,7 +776,7 @@ static struct bsg_device *__bsg_get_device(int minor)
 	mutex_lock(&bsg_mutex);
 
 	hlist_for_each_entry(bd, entry, bsg_dev_idx_hash(minor), dev_list) {
-		if (bd->minor == minor) {
+		if (bd->queue == q) {
 			atomic_inc(&bd->ref_count);
 			goto found;
 		}
@@ -806,7 +804,7 @@ static struct bsg_device *bsg_get_device(struct inode *inode, struct file *file)
 	if (!bcd)
 		return ERR_PTR(-ENODEV);
 
-	bd = __bsg_get_device(iminor(inode));
+	bd = __bsg_get_device(iminor(inode), bcd->queue);
 	if (bd)
 		return bd;
 
-- 
1.5.3.7

