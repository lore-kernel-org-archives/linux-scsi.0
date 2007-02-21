From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: [Patch 2/2] cciss: add reboot notifier support to driver
Date: Wed, 21 Feb 2007 15:12:51 -0600
Message-ID: <20070221211251.GB2672@beardog.cca.cpqcorp.net>
Reply-To: mike.miller@hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel12.hp.com ([156.153.255.237]:54431 "EHLO palrel12.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423151AbXBUVfc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Feb 2007 16:35:32 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, gregkh@novell.com

Patch 2/2

This patch adds reboot_notifier support to cciss. Changes in firmware make this patch
essential. Without this patch there may be valid data left in the controller's battery
backed write cache (BBWC) on shutdown. We found out the hard way that the kernel does
not call our cleanup routines on shutdown or reboot. It seems that only rmmod calls
the cleanup.
Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com
------------------------------------------------------------------------------------------
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 916aab0..1995b8c 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -45,6 +45,7 @@ #include <linux/dma-mapping.h>
 #include <linux/blkdev.h>
 #include <linux/genhd.h>
 #include <linux/completion.h>
+#include <linux/reboot.h>
 
 #define CCISS_DRIVER_VERSION(maj,min,submin) ((maj<<16)|(min<<8)|(submin))
 #define DRIVER_NAME "HP CISS Driver (v 3.6.14)"
@@ -132,6 +133,7 @@ #define MAX_CTLR	32
 #define MAX_CTLR_ORIG 	8
 
 static ctlr_info_t *hba[MAX_CTLR];
+static int notify_count=0;
 
 static void do_cciss_request(request_queue_t *q);
 static irqreturn_t do_cciss_intr(int irq, void *dev_id);
@@ -142,6 +144,8 @@ static int cciss_ioctl(struct inode *ino
 static int cciss_getgeo(struct block_device *bdev, struct hd_geometry *geo);
 
 static int cciss_revalidate(struct gendisk *disk);
+static int cciss_notify_reboot(struct notifier_block *this,
+					unsigned long code, void *x);
 static int rebuild_lun_table(ctlr_info_t *h, struct gendisk *del_disk);
 static int deregister_disk(struct gendisk *disk, drive_info_struct *drv,
 			   int clear_all);
@@ -193,6 +197,36 @@ #endif
 	.revalidate_disk = cciss_revalidate,
 };
 
+static struct notifier_block cciss_notifier = {
+	.notifier_call  = cciss_notify_reboot,
+};
+
+static int cciss_notify_reboot(struct notifier_block *this,
+                            unsigned long code, void *x)
+{
+	int i, return_code;
+	char flush_buf[4];
+
+	if ((code == SYS_DOWN) || (code == SYS_HALT) || 
+					(code == SYS_POWER_OFF)) {
+		printk(KERN_INFO "cciss: stopping all cciss devices.\n");
+		/* double check that all controller entrys have been removed */
+		for (i = 0; i < MAX_CTLR; i++) {
+			if (hba[i] != NULL) {
+				printk(KERN_WARNING "cciss: removing "
+						"controller %d\n", i);
+				/* flush data in battery backed cache to disks */
+				memset(flush_buf, 0, 4);
+				return_code = sendcmd(CCISS_CACHE_FLUSH, i, flush_buf, 4, 								0, 0, 0, NULL, TYPE_CMD);
+				if(return_code != IO_OK) {
+					printk(KERN_WARNING "Error Flushing cache on "
+								" controller %d\n", i); 
+				} 	
+			}
+		}
+	}
+	return NOTIFY_DONE;
+}
 /*
  * Enqueuing and dequeuing functions for cmdlists.
  */
@@ -3293,6 +3327,12 @@ #endif
 	       ((hba[i]->nr_cmds + BITS_PER_LONG -
 		 1) / BITS_PER_LONG) * sizeof(unsigned long));
 
+	if (notify_count == 0) {
+		register_reboot_notifier(&cciss_notifier);
+		notify_count=1;
+	}
+
+
 #ifdef CCISS_DEBUG
 	printk(KERN_DEBUG "Scanning for drives on controller cciss%d\n", i);
 #endif				/* CCISS_DEBUG */
@@ -3500,6 +3540,7 @@ static void __exit cciss_cleanup(void)
 	int i;
 
 	pci_unregister_driver(&cciss_pci_driver);
+	unregister_reboot_notifier(&cciss_notifier);
 	/* double check that all controller entrys have been removed */
 	for (i = 0; i < MAX_CTLR; i++) {
 		if (hba[i] != NULL) {
