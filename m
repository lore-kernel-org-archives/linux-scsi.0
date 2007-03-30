From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] bsg: minor bug fixes
Date: Fri, 30 Mar 2007 10:39:02 +0900
Message-ID: <20070330103902U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:35530 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbXC3Bh5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Mar 2007 21:37:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org

This fixes the following minor issues:

- When bsg_register_queue is called with a request queue that doesn't
have request_fn, it returns -EINVAL instead of zero.

- add EXPORT_SYMBOL_GPL for bsg_register_queue and
bsg_unregister_queue.

- shut up gcc warnings

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c         |    6 ++++--
 include/linux/bsg.h |    2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 4ef3cc5..53bf6d4 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -961,8 +961,9 @@ void bsg_unregister_queue(struct request
 	bsg_device_nr--;
 	mutex_unlock(&bsg_mutex);
 }
+EXPORT_SYMBOL_GPL(bsg_unregister_queue);
 
-int bsg_register_queue(struct request_queue *q, char *name)
+int bsg_register_queue(struct request_queue *q, const char *name)
 {
 	struct bsg_class_device *bcd, *__bcd;
 	dev_t dev;
@@ -973,7 +974,7 @@ int bsg_register_queue(struct request_qu
 	 * we need a proper transport to send commands, not a stacked device
 	 */
 	if (!q->request_fn)
-		return 0;
+		return -EINVAL;
 
 	bcd = &q->bsg_dev;
 	memset(bcd, 0, sizeof(*bcd));
@@ -1025,6 +1026,7 @@ err:
 	mutex_unlock(&bsg_mutex);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(bsg_register_queue);
 
 static int bsg_add(struct class_device *cl_dev, struct class_interface *cl_intf)
 {
diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index 0475a6d..0dd01f9 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -51,7 +51,7 @@ struct bsg_class_device {
 	struct request_queue *queue;
 };
 
-extern int bsg_register_queue(struct request_queue *, char *);
+extern int bsg_register_queue(struct request_queue *, const char *);
 extern void bsg_unregister_queue(struct request_queue *);
 #else
 struct bsg_class_device { };
-- 
1.4.3.2

