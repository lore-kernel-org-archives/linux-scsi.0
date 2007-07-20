From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] bsg: fix bsg_register_queue error path
Date: Fri, 20 Jul 2007 16:50:10 -0500
Message-ID: <1184968210.3455.66.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:60425 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753810AbXGTVuM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jul 2007 17:50:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <Jens.Axboe@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

unfortunately, if IS_ERR(class_dev) is true, that means class_dev isn't
null and the check in the error leg is pointless ... it's also asking
for trouble to request unregistration of a device we haven't actually
created (although it works currently).  Fix by using explicit gotos and
unregisters.

James

diff --git a/block/bsg.c b/block/bsg.c
index d4fa8cd..1659d63 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -993,7 +993,7 @@ retry:
 	if (q->kobj.sd) {
 		ret = sysfs_create_link(&q->kobj, &bcd->class_dev->kobj, "bsg");
 		if (ret)
-			goto err;
+			goto err_unregister;
 	}
 
 	list_add_tail(&bcd->list, &bsg_class_list);
@@ -1001,9 +1001,10 @@ retry:
 
 	mutex_unlock(&bsg_mutex);
 	return 0;
+
+err_unregister:
+	class_device_unregister(class_dev);
 err:
-	if (class_dev)
-		class_device_destroy(bsg_class, MKDEV(bsg_major, bcd->minor));
 	mutex_unlock(&bsg_mutex);
 	return ret;
 }


