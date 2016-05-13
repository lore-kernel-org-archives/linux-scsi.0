From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH] megaraid: fix error code check of register_chrdev()
Date: Sat, 14 May 2016 02:00:05 +0300
Message-ID: <1463180405-10177-1-git-send-email-khoroshilov@ispras.ru>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:37567 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081AbcEMXBY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 May 2016 19:01:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, "Martin K. Petersen" <martin.petersen@oracle.com>, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org

There is invalid error code check of register_chrdev() in megaraid_init().

register_chrdev() returns negative code in case of error,
as a result current code can try to unregister_chrdev() with error code
instead of major that may lead to unregistering somebody else's chardev.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/scsi/megaraid.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 9d05302a3bcd..ded082942ca0 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4702,7 +4702,7 @@ static int __init megaraid_init(void)
 	 * major number allocation.
 	 */
 	major = register_chrdev(0, "megadev_legacy", &megadev_fops);
-	if (!major) {
+	if (major < 0) {
 		printk(KERN_WARNING
 				"megaraid: failed to register char device\n");
 	}
@@ -4715,7 +4715,10 @@ static void __exit megaraid_exit(void)
 	/*
 	 * Unregister the character device interface to the driver.
 	 */
-	unregister_chrdev(major, "megadev_legacy");
+	if (major > 0) {
+		unregister_chrdev(major, "megadev_legacy");
+		major = 0;
+	}
 
 	pci_unregister_driver(&megaraid_pci_driver);
 
-- 
1.9.1

