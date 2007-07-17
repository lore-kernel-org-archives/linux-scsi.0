From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/4] bsg: fix initialization error handling bugs
Date: Tue, 17 Jul 2007 19:08:44 +0900
Message-ID: <40eb9fb0d327856034312127350a427a50eb4222.1184666104.git.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:59534 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465AbXGQKJi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 06:09:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, tomof@acm.org

This fixes the following bugs and cleans up the initialization code:

- cdev_del is missing.
- unregister_chrdev_region should be used instead of unregister_chrdev.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c |   38 ++++++++++++++++++--------------------
 1 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index cdb00e5..b253784 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -1057,39 +1057,37 @@ static int __init bsg_init(void)
 
 	bsg_class = class_create(THIS_MODULE, "bsg");
 	if (IS_ERR(bsg_class)) {
-		kmem_cache_destroy(bsg_cmd_cachep);
-		return PTR_ERR(bsg_class);
+		ret = PTR_ERR(bsg_class);
+		goto destroy_kmemcache;
 	}
 
 	ret = alloc_chrdev_region(&devid, 0, BSG_MAX_DEVS, "bsg");
-	if (ret) {
-		kmem_cache_destroy(bsg_cmd_cachep);
-		class_destroy(bsg_class);
-		return ret;
-	}
+	if (ret)
+		goto destroy_bsg_class;
 
 	bsg_major = MAJOR(devid);
 
 	cdev_init(&bsg_cdev, &bsg_fops);
 	ret = cdev_add(&bsg_cdev, MKDEV(bsg_major, 0), BSG_MAX_DEVS);
-	if (ret) {
-		kmem_cache_destroy(bsg_cmd_cachep);
-		class_destroy(bsg_class);
-		unregister_chrdev_region(MKDEV(bsg_major, 0), BSG_MAX_DEVS);
-		return ret;
-	}
+	if (ret)
+		goto unregister_chrdev;
 
 	ret = scsi_register_interface(&bsg_intf);
-	if (ret) {
-		printk(KERN_ERR "bsg: failed register scsi interface %d\n", ret);
-		kmem_cache_destroy(bsg_cmd_cachep);
-		class_destroy(bsg_class);
-		unregister_chrdev(bsg_major, "bsg");
-		return ret;
-	}
+	if (ret)
+		goto remove_cdev;
 
 	printk(KERN_INFO "%s loaded (major %d)\n", bsg_version, bsg_major);
 	return 0;
+remove_cdev:
+	printk(KERN_ERR "bsg: failed register scsi interface %d\n", ret);
+	cdev_del(&bsg_cdev);
+unregister_chrdev:
+	unregister_chrdev_region(MKDEV(bsg_major, 0), BSG_MAX_DEVS);
+destroy_bsg_class:
+	class_destroy(bsg_class);
+destroy_kmemcache:
+	kmem_cache_destroy(bsg_cmd_cachep);
+	return ret;
 }
 
 MODULE_AUTHOR("Jens Axboe");
-- 
1.4.3.2

