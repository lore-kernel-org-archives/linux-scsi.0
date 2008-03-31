From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/5] bsg: takes a ref to struct device in fops->open
Date: Mon, 31 Mar 2008 10:03:38 +0900
Message-ID: <1206925422-4722-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: 20080331092020R.fujita.tomonori@lab.ntt.co.jp
 <1206925422-4722-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:52118 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589AbYCaBFJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Mar 2008 21:05:09 -0400
In-Reply-To: <1206925422-4722-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, pw@osc.edu, tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

bsg_register_queue() takes a ref to struct device that a caller
passes. For example, bsg takes a ref to the sdev_gendev for scsi
devices. However, bsg doesn't inrease the refcount in fops->open. So
while an application opens a bsg device, the scsi device that the bsg
device holds can go away (bsg also takes a ref to a queue, but it
doesn't prevent the device from going away).

With this patch, bsg increases the refcount of struct device in
fops->open and decreases it in fops->release.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 block/bsg.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 8917c51..d8e0cb8 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -705,6 +705,7 @@ static struct bsg_device *bsg_alloc_device(void)
 static int bsg_put_device(struct bsg_device *bd)
 {
 	int ret = 0;
+	struct device *dev = bd->queue->bsg_dev.dev;
 
 	mutex_lock(&bsg_mutex);
 
@@ -730,6 +731,7 @@ static int bsg_put_device(struct bsg_device *bd)
 	kfree(bd);
 out:
 	mutex_unlock(&bsg_mutex);
+	put_device(dev);
 	return ret;
 }
 
@@ -789,21 +791,27 @@ static struct bsg_device *bsg_get_device(struct inode *inode, struct file *file)
 	struct bsg_device *bd;
 	struct bsg_class_device *bcd;
 
-	bd = __bsg_get_device(iminor(inode));
-	if (bd)
-		return bd;
-
 	/*
 	 * find the class device
 	 */
 	mutex_lock(&bsg_mutex);
 	bcd = idr_find(&bsg_minor_idr, iminor(inode));
+	if (bcd)
+		get_device(bcd->dev);
 	mutex_unlock(&bsg_mutex);
 
 	if (!bcd)
 		return ERR_PTR(-ENODEV);
 
-	return bsg_add_device(inode, bcd->queue, file);
+	bd = __bsg_get_device(iminor(inode));
+	if (bd)
+		return bd;
+
+	bd = bsg_add_device(inode, bcd->queue, file);
+	if (IS_ERR(bd))
+		put_device(bcd->dev);
+
+	return bd;
 }
 
 static int bsg_open(struct inode *inode, struct file *file)
@@ -942,7 +950,6 @@ void bsg_unregister_queue(struct request_queue *q)
 	class_device_unregister(bcd->class_dev);
 	put_device(bcd->dev);
 	bcd->class_dev = NULL;
-	bcd->dev = NULL;
 	mutex_unlock(&bsg_mutex);
 }
 EXPORT_SYMBOL_GPL(bsg_unregister_queue);
-- 
1.5.3.7

