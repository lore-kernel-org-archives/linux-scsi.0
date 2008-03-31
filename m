From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/5] bsg: replace kobject_get with blk_get_queue
Date: Mon, 31 Mar 2008 10:03:39 +0900
Message-ID: <1206925422-4722-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: 20080331092020R.fujita.tomonori@lab.ntt.co.jp
 <1206925422-4722-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206925422-4722-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:58136 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567AbYCaBFr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Mar 2008 21:05:47 -0400
In-Reply-To: <1206925422-4722-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, pw@osc.edu, tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

Both takes a ref to a queue. But blk_get_queue checks QUEUE_FLAG_DEAD
and is more appropriate interface here.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 block/bsg.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index d8e0cb8..e2c65a1 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -740,16 +740,21 @@ static struct bsg_device *bsg_add_device(struct inode *inode,
 					 struct file *file)
 {
 	struct bsg_device *bd;
+	int ret;
 #ifdef BSG_DEBUG
 	unsigned char buf[32];
 #endif
+	ret = blk_get_queue(rq);
+	if (ret)
+		return ERR_PTR(-ENXIO);
 
 	bd = bsg_alloc_device();
-	if (!bd)
+	if (!bd) {
+		blk_put_queue(rq);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	bd->queue = rq;
-	kobject_get(&rq->kobj);
 	bsg_set_block(bd, file);
 
 	atomic_set(&bd->ref_count, 1);
-- 
1.5.3.7

