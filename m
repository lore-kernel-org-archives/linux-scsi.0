From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] scsi_debug: add max_queue + no_uld parameters
Date: Thu, 25 Mar 2010 17:29:05 -0400
Message-ID: <4BABD5A1.4050003@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000300050305050202000503"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:38063 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709Ab0CYV3O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Mar 2010 17:29:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

This is a multi-part message in MIME format.
--------------000300050305050202000503
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

While testing the midlevel q_at_head and q_at_tail
patch for sg and the block SG_IO ioctl I found it
useful to reduce the queuing within the scsi_debug
driver. The reason is that the midlevel queue only
comes into play when the corresponding LLD queue
is full.

It is also useful when testing to be confident that
your program is the only thing issuing commands
to the (virtual) scsi_debug device. The no_uld=1
parameter will stop a scsi_debug virtual disk
appearing as /dev/sd* .

Changelog:
   - add max_queue parameter to reduce the number
     of queued commands the driver will accept.
     This parameter can be changed after the driver
     is loaded.
   - add no_uld parameter that restricts scsi_debug's
     virtual devices to the sg and bsg drivers
   - correct stale url

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------000300050305050202000503
Content-Type: text/x-patch;
 name="sdebug2633_mq_nu2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sdebug2633_mq_nu2.patch"

--- linux/drivers/scsi/scsi_debug.c	2010-02-26 12:27:56.000000000 -0500
+++ linux/drivers/scsi/scsi_debug.c2633mqnu2	2010-03-24 15:13:03.000000000 -0400
@@ -12,7 +12,7 @@
  *  SAS disks.
  *
  *
- *  For documentation see http://www.torque.net/sg/sdebug26.html
+ *  For documentation see http://sg.danny.cz/sg/sdebug26.html
  *
  *   D. Gilbert (dpg) work for Magneto-Optical device test [20010421]
  *   dpg: work for devfs large number of disks [20010809]
@@ -57,8 +57,8 @@
 #include "sd.h"
 #include "scsi_logging.h"
 
-#define SCSI_DEBUG_VERSION "1.81"
-static const char * scsi_debug_version_date = "20070104";
+#define SCSI_DEBUG_VERSION "1.82"
+static const char * scsi_debug_version_date = "20100324";
 
 /* Additional Sense Code (ASC) */
 #define NO_ADDITIONAL_SENSE 0x0
@@ -146,12 +146,18 @@ static const char * scsi_debug_version_d
 #define SAM2_LUN_ADDRESS_METHOD 0
 #define SAM2_WLUN_REPORT_LUNS 0xc101
 
+/* Can queue up to this number of commands. Typically commands that
+ * that have a non-zero delay are queued. */
+#define SCSI_DEBUG_CANQUEUE  255
+
 static int scsi_debug_add_host = DEF_NUM_HOST;
 static int scsi_debug_delay = DEF_DELAY;
 static int scsi_debug_dev_size_mb = DEF_DEV_SIZE_MB;
 static int scsi_debug_every_nth = DEF_EVERY_NTH;
 static int scsi_debug_max_luns = DEF_MAX_LUNS;
+static int scsi_debug_max_queue = SCSI_DEBUG_CANQUEUE;
 static int scsi_debug_num_parts = DEF_NUM_PARTS;
+static int scsi_debug_no_uld = 0;
 static int scsi_debug_num_tgts = DEF_NUM_TGTS; /* targets per host */
 static int scsi_debug_opts = DEF_OPTS;
 static int scsi_debug_scsi_level = DEF_SCSI_LEVEL;
@@ -191,7 +197,6 @@ static int sdebug_sectors_per;		/* secto
 
 #define SDEBUG_SENSE_LEN 32
 
-#define SCSI_DEBUG_CANQUEUE  255
 #define SCSI_DEBUG_MAX_CMD_LEN 32
 
 struct sdebug_dev_info {
@@ -2264,7 +2269,7 @@ static void timer_intr_handler(unsigned 
 	struct sdebug_queued_cmd * sqcp;
 	unsigned long iflags;
 
-	if (indx >= SCSI_DEBUG_CANQUEUE) {
+	if (indx >= scsi_debug_max_queue) {
 		printk(KERN_ERR "scsi_debug:timer_intr_handler: indx too "
 		       "large\n");
 		return;
@@ -2378,6 +2383,8 @@ static int scsi_debug_slave_configure(st
 		scsi_adjust_queue_depth(sdp, SDEBUG_TAGGED_QUEUING,
 					sdp->host->cmd_per_lun);
 	blk_queue_max_segment_size(sdp->request_queue, 256 * 1024);
+	if (scsi_debug_no_uld)
+		sdp->no_uld_attach = 1;
 	return 0;
 }
 
@@ -2404,7 +2411,7 @@ static int stop_queued_cmnd(struct scsi_
 	struct sdebug_queued_cmd *sqcp;
 
 	spin_lock_irqsave(&queued_arr_lock, iflags);
-	for (k = 0; k < SCSI_DEBUG_CANQUEUE; ++k) {
+	for (k = 0; k < scsi_debug_max_queue; ++k) {
 		sqcp = &queued_arr[k];
 		if (sqcp->in_use && (cmnd == sqcp->a_cmnd)) {
 			del_timer_sync(&sqcp->cmnd_timer);
@@ -2414,7 +2421,7 @@ static int stop_queued_cmnd(struct scsi_
 		}
 	}
 	spin_unlock_irqrestore(&queued_arr_lock, iflags);
-	return (k < SCSI_DEBUG_CANQUEUE) ? 1 : 0;
+	return (k < scsi_debug_max_queue) ? 1 : 0;
 }
 
 /* Deletes (stops) timers of all queued commands */
@@ -2425,7 +2432,7 @@ static void stop_all_queued(void)
 	struct sdebug_queued_cmd *sqcp;
 
 	spin_lock_irqsave(&queued_arr_lock, iflags);
-	for (k = 0; k < SCSI_DEBUG_CANQUEUE; ++k) {
+	for (k = 0; k < scsi_debug_max_queue; ++k) {
 		sqcp = &queued_arr[k];
 		if (sqcp->in_use && sqcp->a_cmnd) {
 			del_timer_sync(&sqcp->cmnd_timer);
@@ -2531,7 +2538,7 @@ static void __init init_all_queued(void)
 	struct sdebug_queued_cmd * sqcp;
 
 	spin_lock_irqsave(&queued_arr_lock, iflags);
-	for (k = 0; k < SCSI_DEBUG_CANQUEUE; ++k) {
+	for (k = 0; k < scsi_debug_max_queue; ++k) {
 		sqcp = &queued_arr[k];
 		init_timer(&sqcp->cmnd_timer);
 		sqcp->in_use = 0;
@@ -2623,12 +2630,12 @@ static int schedule_resp(struct scsi_cmn
 		struct sdebug_queued_cmd * sqcp = NULL;
 
 		spin_lock_irqsave(&queued_arr_lock, iflags);
-		for (k = 0; k < SCSI_DEBUG_CANQUEUE; ++k) {
+		for (k = 0; k < scsi_debug_max_queue; ++k) {
 			sqcp = &queued_arr[k];
 			if (! sqcp->in_use)
 				break;
 		}
-		if (k >= SCSI_DEBUG_CANQUEUE) {
+		if (k >= scsi_debug_max_queue) {
 			spin_unlock_irqrestore(&queued_arr_lock, iflags);
 			printk(KERN_WARNING "scsi_debug: can_queue exceeded\n");
 			return 1;	/* report busy to mid level */
@@ -2660,7 +2667,9 @@ module_param_named(dsense, scsi_debug_ds
 module_param_named(every_nth, scsi_debug_every_nth, int, S_IRUGO | S_IWUSR);
 module_param_named(fake_rw, scsi_debug_fake_rw, int, S_IRUGO | S_IWUSR);
 module_param_named(max_luns, scsi_debug_max_luns, int, S_IRUGO | S_IWUSR);
+module_param_named(max_queue, scsi_debug_max_queue, int, S_IRUGO | S_IWUSR);
 module_param_named(no_lun_0, scsi_debug_no_lun_0, int, S_IRUGO | S_IWUSR);
+module_param_named(no_uld, scsi_debug_no_uld, int, S_IRUGO);
 module_param_named(num_parts, scsi_debug_num_parts, int, S_IRUGO);
 module_param_named(num_tgts, scsi_debug_num_tgts, int, S_IRUGO | S_IWUSR);
 module_param_named(opts, scsi_debug_opts, int, S_IRUGO | S_IWUSR);
@@ -2693,7 +2702,9 @@ MODULE_PARM_DESC(dsense, "use descriptor
 MODULE_PARM_DESC(every_nth, "timeout every nth command(def=0)");
 MODULE_PARM_DESC(fake_rw, "fake reads/writes instead of copying (def=0)");
 MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");
+MODULE_PARM_DESC(max_queue, "max number of queued commands (1 to 255(def))");
 MODULE_PARM_DESC(no_lun_0, "no LU number 0 (def=0 -> have lun 0)");
+MODULE_PARM_DESC(no_uld, "stop ULD (e.g. sd driver) attaching (def=0))");
 MODULE_PARM_DESC(num_parts, "number of partitions(def=0)");
 MODULE_PARM_DESC(num_tgts, "number of targets per host to simulate(def=1)");
 MODULE_PARM_DESC(opts, "1->noise, 2->medium_err, 4->timeout, 8->recovered_err... (def=0)");
@@ -2968,6 +2979,31 @@ static ssize_t sdebug_max_luns_store(str
 DRIVER_ATTR(max_luns, S_IRUGO | S_IWUSR, sdebug_max_luns_show,
 	    sdebug_max_luns_store);
 
+static ssize_t sdebug_max_queue_show(struct device_driver * ddp, char * buf)
+{
+        return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_max_queue);
+}
+static ssize_t sdebug_max_queue_store(struct device_driver * ddp,
+				      const char * buf, size_t count)
+{
+        int n;
+
+	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n > 0) &&
+	    (n <= SCSI_DEBUG_CANQUEUE)) {
+		scsi_debug_max_queue = n;
+		return count;
+	}
+	return -EINVAL;
+}
+DRIVER_ATTR(max_queue, S_IRUGO | S_IWUSR, sdebug_max_queue_show,
+	    sdebug_max_queue_store);
+
+static ssize_t sdebug_no_uld_show(struct device_driver * ddp, char * buf)
+{
+        return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_no_uld);
+}
+DRIVER_ATTR(no_uld, S_IRUGO, sdebug_no_uld_show, NULL);
+
 static ssize_t sdebug_scsi_level_show(struct device_driver * ddp, char * buf)
 {
         return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_scsi_level);
@@ -3105,7 +3141,9 @@ static int do_create_driverfs_files(void
 	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_every_nth);
 	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_fake_rw);
 	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_max_luns);
+	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_max_queue);
 	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_no_lun_0);
+	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_no_uld);
 	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_num_parts);
 	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_num_tgts);
 	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_ptype);
@@ -3137,7 +3175,9 @@ static void do_remove_driverfs_files(voi
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_ptype);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_num_tgts);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_num_parts);
+	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_no_uld);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_no_lun_0);
+	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_max_queue);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_max_luns);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_fake_rw);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_every_nth);
@@ -3828,12 +3868,13 @@ static int sdebug_driver_probe(struct de
 
 	sdbg_host = to_sdebug_host(dev);
 
-        hpnt = scsi_host_alloc(&sdebug_driver_template, sizeof(sdbg_host));
-        if (NULL == hpnt) {
-                printk(KERN_ERR "%s: scsi_register failed\n", __func__);
-                error = -ENODEV;
+	sdebug_driver_template.can_queue = scsi_debug_max_queue;
+	hpnt = scsi_host_alloc(&sdebug_driver_template, sizeof(sdbg_host));
+	if (NULL == hpnt) {
+		printk(KERN_ERR "%s: scsi_register failed\n", __func__);
+		error = -ENODEV;
 		return error;
-        }
+	}
 
         sdbg_host->shost = hpnt;
 	*((struct sdebug_host_info **)hpnt->hostdata) = sdbg_host;

--------------000300050305050202000503--
