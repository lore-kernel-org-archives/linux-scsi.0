From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/4] bsg: minor cleanup
Date: Tue, 17 Jul 2007 19:08:50 +0900
Message-ID: <6567af17c1e70ce0d1c4971307e52a4f803f3bab.1184666104.git.fujita.tomonori@lab.ntt.co.jp>
References: <40eb9fb0d327856034312127350a427a50eb4222.1184666104.git.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:59577 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbXGQKJn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 06:09:43 -0400
In-Reply-To: <40eb9fb0d327856034312127350a427a50eb4222.1184666104.git.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, tomof@acm.org

- fix MODULE_DESCRIPTION typo.
- unify MODULE_DESCRIPTION and bsg_version.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 55a4303..8e5fcf2 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -33,7 +33,8 @@ #include <scsi/scsi_device.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/sg.h>
 
-const static char bsg_version[] = "block layer sg (bsg) 0.4";
+#define BSG_DESCRIPTION	"Block layer SCSI generic (bsg) driver"
+#define BSG_VERSION	"0.4"
 
 struct bsg_device {
 	request_queue_t *queue;
@@ -1072,7 +1073,8 @@ static int __init bsg_init(void)
 	if (ret)
 		goto remove_cdev;
 
-	printk(KERN_INFO "%s loaded (major %d)\n", bsg_version, bsg_major);
+	printk(KERN_INFO BSG_DESCRIPTION "version " BSG_VERSION
+	       " loaded (major %d)\n", bsg_major);
 	return 0;
 remove_cdev:
 	printk(KERN_ERR "bsg: failed register scsi interface %d\n", ret);
@@ -1087,7 +1089,7 @@ destroy_kmemcache:
 }
 
 MODULE_AUTHOR("Jens Axboe");
-MODULE_DESCRIPTION("Block layer SGSI generic (sg) driver");
+MODULE_DESCRIPTION(BSG_DESCRIPTION);
 MODULE_LICENSE("GPL");
 
 device_initcall(bsg_init);
-- 
1.4.3.2

