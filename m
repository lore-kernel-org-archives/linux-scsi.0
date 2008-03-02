From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/4] scsi_debug: remove scsi_debug.h
Date: Sun,  2 Mar 2008 18:30:16 +0900
Message-ID: <1204450218-6858-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1204450218-6858-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1204450218-6858-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:47923 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019AbYCBJn6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Mar 2008 04:43:58 -0500
In-Reply-To: <1204450218-6858-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@HansenPartnership.com>

scsi_debug.h just incldues some function declarations. This patch removes it
with moving the scsi_host_template.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_debug.c |   58 +++++++++++++++++++++++---------------------
 drivers/scsi/scsi_debug.h |   24 ------------------
 2 files changed, 30 insertions(+), 52 deletions(-)
 delete mode 100644 drivers/scsi/scsi_debug.h

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index c19a2d6..c10234f 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -50,7 +50,6 @@
 #include <linux/stat.h>
 
 #include "scsi_logging.h"
-#include "scsi_debug.h"
 
 #define SCSI_DEBUG_VERSION "1.81"
 static const char * scsi_debug_version_date = "20070104";
@@ -167,6 +166,9 @@ static int sdebug_sectors_per;		/* sectors per cylinder */
 
 #define SDEBUG_SENSE_LEN 32
 
+#define SCSI_DEBUG_CANQUEUE  255
+#define SCSI_DEBUG_MAX_CMD_LEN 16
+
 struct sdebug_dev_info {
 	struct list_head dev_list;
 	unsigned char sense_buff[SDEBUG_SENSE_LEN];	/* weak nexus */
@@ -204,30 +206,6 @@ struct sdebug_queued_cmd {
 };
 static struct sdebug_queued_cmd queued_arr[SCSI_DEBUG_CANQUEUE];
 
-static struct scsi_host_template sdebug_driver_template = {
-	.proc_info =		scsi_debug_proc_info,
-	.name =			"SCSI DEBUG",
-	.info =			scsi_debug_info,
-	.slave_alloc =		scsi_debug_slave_alloc,
-	.slave_configure =	scsi_debug_slave_configure,
-	.slave_destroy =	scsi_debug_slave_destroy,
-	.ioctl =		scsi_debug_ioctl,
-	.queuecommand =		scsi_debug_queuecommand,
-	.eh_abort_handler =	scsi_debug_abort,
-	.eh_bus_reset_handler = scsi_debug_bus_reset,
-	.eh_device_reset_handler = scsi_debug_device_reset,
-	.eh_host_reset_handler = scsi_debug_host_reset,
-	.bios_param =		scsi_debug_biosparam,
-	.can_queue =		SCSI_DEBUG_CANQUEUE,
-	.this_id =		7,
-	.sg_tablesize =		256,
-	.cmd_per_lun =		16,
-	.max_sectors =		0xffff,
-	.unchecked_isa_dma = 	0,
-	.use_clustering = 	DISABLE_CLUSTERING,
-	.module =		THIS_MODULE,
-};
-
 static unsigned char * fake_storep;	/* ramdisk storage */
 
 static int num_aborts = 0;
@@ -376,7 +354,8 @@ int scsi_debug_queuecommand(struct scsi_cmnd * SCpnt, done_funct_t done)
 			printk("%02x ", (int)cmd[k]);
 		printk("\n");
 	}
-        if(target == sdebug_driver_template.this_id) {
+
+	if (target == SCpnt->device->host->hostt->this_id) {
 		printk(KERN_INFO "scsi_debug: initiator's id used as "
 		       "target!\n");
 		return schedule_resp(SCpnt, NULL, done,
@@ -2924,8 +2903,6 @@ static int __init scsi_debug_init(void)
 
 	init_all_queued();
 
-	sdebug_driver_template.proc_name = sdebug_proc_name;
-
 	host_to_add = scsi_debug_add_host;
         scsi_debug_add_host = 0;
 
@@ -3085,6 +3062,31 @@ static void sdebug_remove_adapter(void)
         --scsi_debug_add_host;
 }
 
+static struct scsi_host_template sdebug_driver_template = {
+	.proc_info =		scsi_debug_proc_info,
+	.proc_name =		sdebug_proc_name,
+	.name =			"SCSI DEBUG",
+	.info =			scsi_debug_info,
+	.slave_alloc =		scsi_debug_slave_alloc,
+	.slave_configure =	scsi_debug_slave_configure,
+	.slave_destroy =	scsi_debug_slave_destroy,
+	.ioctl =		scsi_debug_ioctl,
+	.queuecommand =		scsi_debug_queuecommand,
+	.eh_abort_handler =	scsi_debug_abort,
+	.eh_bus_reset_handler = scsi_debug_bus_reset,
+	.eh_device_reset_handler = scsi_debug_device_reset,
+	.eh_host_reset_handler = scsi_debug_host_reset,
+	.bios_param =		scsi_debug_biosparam,
+	.can_queue =		SCSI_DEBUG_CANQUEUE,
+	.this_id =		7,
+	.sg_tablesize =		256,
+	.cmd_per_lun =		16,
+	.max_sectors =		0xffff,
+	.unchecked_isa_dma = 	0,
+	.use_clustering = 	DISABLE_CLUSTERING,
+	.module =		THIS_MODULE,
+};
+
 static int sdebug_driver_probe(struct device * dev)
 {
         int error = 0;
diff --git a/drivers/scsi/scsi_debug.h b/drivers/scsi/scsi_debug.h
deleted file mode 100644
index 965dd5e..0000000
--- a/drivers/scsi/scsi_debug.h
+++ /dev/null
@@ -1,24 +0,0 @@
-#ifndef _SCSI_DEBUG_H
-
-#include <linux/types.h>
-
-static int scsi_debug_slave_alloc(struct scsi_device *);
-static int scsi_debug_slave_configure(struct scsi_device *);
-static void scsi_debug_slave_destroy(struct scsi_device *);
-static int scsi_debug_queuecommand(struct scsi_cmnd *,
-				   void (*done) (struct scsi_cmnd *));
-static int scsi_debug_ioctl(struct scsi_device *, int, void __user *);
-static int scsi_debug_biosparam(struct scsi_device *, struct block_device *,
-		sector_t, int[]);
-static int scsi_debug_abort(struct scsi_cmnd *);
-static int scsi_debug_bus_reset(struct scsi_cmnd *);
-static int scsi_debug_device_reset(struct scsi_cmnd *);
-static int scsi_debug_host_reset(struct scsi_cmnd *);
-static int scsi_debug_proc_info(struct Scsi_Host *, char *, char **, off_t, int, int);
-static const char * scsi_debug_info(struct Scsi_Host *);
-
-#define SCSI_DEBUG_CANQUEUE  255 	/* needs to be >= 1 */
-
-#define SCSI_DEBUG_MAX_CMD_LEN 16
-
-#endif
-- 
1.5.3.7

