From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] bsg: fix bsg_unregister_queue
Date: Sat, 21 Jul 2007 13:23:25 +0900
Message-ID: <20070721132333H.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:54026 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbXGUEXk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jul 2007 00:23:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp

scsi_sysfs_add_sdev ignores the bsg_register_queue failure, so
bsg_unregister_queue must check whether the queue has a bsg device.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 4eebcd5..1ba9bc6 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -932,7 +932,8 @@ void bsg_unregister_queue(struct request
 {
 	struct bsg_class_device *bcd = &q->bsg_dev;
 
-	WARN_ON(!bcd->class_dev);
+	if (!bcd->class_dev)
+		return;
 
 	mutex_lock(&bsg_mutex);
 	sysfs_remove_link(&q->kobj, "bsg");
-- 
1.4.3.2

