From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [RFC] scsi_debug: locks and delays
Date: Wed, 18 Jun 2014 21:53:44 -0400
Message-ID: <53A242A8.6050902@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050606070806040609080501"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:36097 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756536AbaFSBxu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jun 2014 21:53:50 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp.infotech.no (Postfix) with ESMTP id C76082041D4
	for <linux-scsi@vger.kernel.org>; Thu, 19 Jun 2014 03:53:46 +0200 (CEST)
Received: from smtp.infotech.no ([127.0.0.1])
	by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2na86oR4bkAz for <linux-scsi@vger.kernel.org>;
	Thu, 19 Jun 2014 03:53:46 +0200 (CEST)
Received: from [10.7.0.6] (unknown [10.7.0.6])
	by smtp.infotech.no (Postfix) with ESMTPA id 03FC6204159
	for <linux-scsi@vger.kernel.org>; Thu, 19 Jun 2014 03:53:45 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------050606070806040609080501
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Currently the scsi_debug driver wraps every queued command
with the host_lock and every mid-level completion callback
(apart from delay=0) with a spinlock.

Attached is a patch against Linus's tree that also applies
to lk 3.15.1 . It attempts to address some of these issues.

ChangeLog
   - 'host_lock' option added that simply drops that lock
     when host_lock=0 (which is the default)
   - allow delay=-1 [delay=1 (jiffy) is still the default]
     that uses a tasklet to schedule the response quickly
   - for completions (when delay!=0) the callback to the
     mid-level is un-(spin)locked
   - completions are counted; can be viewed with
       cat /proc/scsi/scsi_debug/<host_num>
   - delay_override removed from TEST UNIT READY.
     This makes 'sg_turs -n 1m -t /dev/bsg/<hctl>' a more
     realistic test of command overhead. I get about 100k
     IOPS on my laptop.

This patch has been lightly tested. Perhaps someone could
throw a scsi-mq test at it.

Comments welcome.

Doug Gilbert

--------------050606070806040609080501
Content-Type: text/x-patch;
 name="sdebug_hlock2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sdebug_hlock2.patch"

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1328a26..6e66fe9 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -42,6 +42,9 @@
 #include <linux/scatterlist.h>
 #include <linux/blkdev.h>
 #include <linux/crc-t10dif.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/atomic.h>
 
 #include <net/checksum.h>
 
@@ -120,6 +123,7 @@ static const char * scsi_debug_version_date = "20100324";
 #define DEF_VIRTUAL_GB   0
 #define DEF_VPD_USE_HOSTNO 1
 #define DEF_WRITESAME_LENGTH 0xFFFF
+#define DEF_HOST_LOCK 0
 
 /* bit mask values for scsi_debug_opts */
 #define SCSI_DEBUG_OPT_NOISE   1
@@ -198,8 +202,10 @@ static unsigned int scsi_debug_unmap_max_desc = DEF_UNMAP_MAX_DESC;
 static unsigned int scsi_debug_write_same_length = DEF_WRITESAME_LENGTH;
 static bool scsi_debug_removable = DEF_REMOVABLE;
 static bool scsi_debug_clustering;
+static bool scsi_debug_host_lock = DEF_HOST_LOCK;
 
 static int scsi_debug_cmnd_count = 0;
+static atomic_t scsi_debug_completions;
 
 #define DEV_READONLY(TGT)      (0)
 
@@ -254,6 +260,7 @@ typedef void (* done_funct_t) (struct scsi_cmnd *);
 struct sdebug_queued_cmd {
 	int in_use;
 	struct timer_list cmnd_timer;
+	struct tasklet_struct tlet;
 	done_funct_t done_funct;
 	struct scsi_cmnd * a_cmnd;
 	int scsi_result;
@@ -2365,32 +2372,38 @@ static int resp_xdwriteread(struct scsi_cmnd *scp, unsigned long long lba,
 	return 0;
 }
 
-/* When timer goes off this function is called. */
-static void timer_intr_handler(unsigned long indx)
+/* When timer or tasket goes off this function is called. */
+static void completion_handler(unsigned long indx)
 {
 	struct sdebug_queued_cmd * sqcp;
 	unsigned long iflags;
+	done_funct_t df;
+	struct scsi_cmnd *scp;
 
+	atomic_inc(&scsi_debug_completions);
 	if (indx >= scsi_debug_max_queue) {
-		printk(KERN_ERR "scsi_debug:timer_intr_handler: indx too "
+		printk(KERN_ERR "scsi_debug:completion_handler: index too "
 		       "large\n");
 		return;
 	}
 	spin_lock_irqsave(&queued_arr_lock, iflags);
 	sqcp = &queued_arr[(int)indx];
 	if (! sqcp->in_use) {
-		printk(KERN_ERR "scsi_debug:timer_intr_handler: Unexpected "
-		       "interrupt\n");
+		printk(KERN_ERR "scsi_debug:completion_handler: Unexpected "
+		       "completion\n");
 		spin_unlock_irqrestore(&queued_arr_lock, iflags);
 		return;
 	}
+	scp = sqcp->a_cmnd;
+	df = sqcp->done_funct;
+	if (df && scp)
+		scp->result = sqcp->scsi_result;
 	sqcp->in_use = 0;
-	if (sqcp->done_funct) {
-		sqcp->a_cmnd->result = sqcp->scsi_result;
-		sqcp->done_funct(sqcp->a_cmnd); /* callback to mid level */
-	}
+	sqcp->a_cmnd = NULL;
 	sqcp->done_funct = NULL;
 	spin_unlock_irqrestore(&queued_arr_lock, iflags);
+	if (df && scp)
+		df(scp); /* callback to mid level */
 }
 
 
@@ -2516,7 +2529,10 @@ static int stop_queued_cmnd(struct scsi_cmnd *cmnd)
 	for (k = 0; k < scsi_debug_max_queue; ++k) {
 		sqcp = &queued_arr[k];
 		if (sqcp->in_use && (cmnd == sqcp->a_cmnd)) {
-			del_timer_sync(&sqcp->cmnd_timer);
+			if (scsi_debug_delay > 0)
+				del_timer_sync(&sqcp->cmnd_timer);
+			else if (scsi_debug_delay < 0)
+				tasklet_kill(&sqcp->tlet);
 			sqcp->in_use = 0;
 			sqcp->a_cmnd = NULL;
 			break;
@@ -2537,7 +2553,10 @@ static void stop_all_queued(void)
 	for (k = 0; k < scsi_debug_max_queue; ++k) {
 		sqcp = &queued_arr[k];
 		if (sqcp->in_use && sqcp->a_cmnd) {
-			del_timer_sync(&sqcp->cmnd_timer);
+			if (scsi_debug_delay > 0)
+				del_timer_sync(&sqcp->cmnd_timer);
+			else if (scsi_debug_delay < 0)
+				tasklet_kill(&sqcp->tlet);
 			sqcp->in_use = 0;
 			sqcp->a_cmnd = NULL;
 		}
@@ -2642,7 +2661,8 @@ static void __init init_all_queued(void)
 	spin_lock_irqsave(&queued_arr_lock, iflags);
 	for (k = 0; k < scsi_debug_max_queue; ++k) {
 		sqcp = &queued_arr[k];
-		init_timer(&sqcp->cmnd_timer);
+		if (scsi_debug_delay > 0)
+			init_timer(&sqcp->cmnd_timer);
 		sqcp->in_use = 0;
 		sqcp->a_cmnd = NULL;
 	}
@@ -2720,7 +2740,7 @@ static int schedule_resp(struct scsi_cmnd * cmnd,
 			       (SCSI_SENSE_BUFFERSIZE > SDEBUG_SENSE_LEN) ?
 			       SDEBUG_SENSE_LEN : SCSI_SENSE_BUFFERSIZE);
 	}
-	if (delta_jiff <= 0) {
+	if (delta_jiff == 0) {
 		if (cmnd)
 			cmnd->result = scsi_result;
 		if (done)
@@ -2746,10 +2766,15 @@ static int schedule_resp(struct scsi_cmnd * cmnd,
 		sqcp->a_cmnd = cmnd;
 		sqcp->scsi_result = scsi_result;
 		sqcp->done_funct = done;
-		sqcp->cmnd_timer.function = timer_intr_handler;
-		sqcp->cmnd_timer.data = k;
-		sqcp->cmnd_timer.expires = jiffies + delta_jiff;
-		add_timer(&sqcp->cmnd_timer);
+		if (delta_jiff > 0) {
+			sqcp->cmnd_timer.function = completion_handler;
+			sqcp->cmnd_timer.data = k;
+			sqcp->cmnd_timer.expires = jiffies + delta_jiff;
+			add_timer(&sqcp->cmnd_timer);
+		} else {
+			tasklet_init(&sqcp->tlet, completion_handler, k);
+			tasklet_schedule(&sqcp->tlet);
+		}
 		spin_unlock_irqrestore(&queued_arr_lock, iflags);
 		if (cmnd)
 			cmnd->result = 0;
@@ -2773,6 +2798,7 @@ module_param_named(dsense, scsi_debug_dsense, int, S_IRUGO | S_IWUSR);
 module_param_named(every_nth, scsi_debug_every_nth, int, S_IRUGO | S_IWUSR);
 module_param_named(fake_rw, scsi_debug_fake_rw, int, S_IRUGO | S_IWUSR);
 module_param_named(guard, scsi_debug_guard, uint, S_IRUGO);
+module_param_named(host_lock, scsi_debug_host_lock, bool, S_IRUGO | S_IWUSR);
 module_param_named(lbpu, scsi_debug_lbpu, int, S_IRUGO);
 module_param_named(lbpws, scsi_debug_lbpws, int, S_IRUGO);
 module_param_named(lbpws10, scsi_debug_lbpws10, int, S_IRUGO);
@@ -2809,7 +2835,7 @@ MODULE_VERSION(SCSI_DEBUG_VERSION);
 MODULE_PARM_DESC(add_host, "0..127 hosts allowed(def=1)");
 MODULE_PARM_DESC(ato, "application tag ownership: 0=disk 1=host (def=1)");
 MODULE_PARM_DESC(clustering, "when set enables larger transfers (def=0)");
-MODULE_PARM_DESC(delay, "# of jiffies to delay response(def=1)");
+MODULE_PARM_DESC(delay, "response delay in jiffies (def=1); 0:imm, -1:tiny");
 MODULE_PARM_DESC(dev_size_mb, "size in MB of ram shared by devs(def=8)");
 MODULE_PARM_DESC(dif, "data integrity field type: 0-3 (def=0)");
 MODULE_PARM_DESC(dix, "data integrity extensions mask (def=0)");
@@ -2817,6 +2843,7 @@ MODULE_PARM_DESC(dsense, "use descriptor sense format(def=0 -> fixed)");
 MODULE_PARM_DESC(every_nth, "timeout every nth command(def=0)");
 MODULE_PARM_DESC(fake_rw, "fake reads/writes instead of copying (def=0)");
 MODULE_PARM_DESC(guard, "protection checksum: 0=crc, 1=ip (def=0)");
+MODULE_PARM_DESC(host_lock, "use host_lock around all commands (def=0)");
 MODULE_PARM_DESC(lbpu, "enable LBP, support UNMAP command (def=0)");
 MODULE_PARM_DESC(lbpws, "enable LBP, support WRITE SAME(16) with UNMAP bit (def=0)");
 MODULE_PARM_DESC(lbpws10, "enable LBP, support WRITE SAME(10) with UNMAP bit (def=0)");
@@ -2881,7 +2908,7 @@ static int scsi_debug_show_info(struct seq_file *m, struct Scsi_Host *host)
 	    "%s [%s]\n"
 	    "num_tgts=%d, shared (ram) size=%d MB, opts=0x%x, "
 	    "every_nth=%d(curr:%d)\n"
-	    "delay=%d, max_luns=%d, scsi_level=%d\n"
+	    "delay=%d, max_luns=%d, scsi_level=%d, completions=%d\n"
 	    "sector_size=%d bytes, cylinders=%d, heads=%d, sectors=%d\n"
 	    "number of aborts=%d, device_reset=%d, bus_resets=%d, "
 	    "host_resets=%d\ndix_reads=%d dix_writes=%d dif_errors=%d\n",
@@ -2889,6 +2916,7 @@ static int scsi_debug_show_info(struct seq_file *m, struct Scsi_Host *host)
 	    scsi_debug_dev_size_mb, scsi_debug_opts, scsi_debug_every_nth,
 	    scsi_debug_cmnd_count, scsi_debug_delay,
 	    scsi_debug_max_luns, scsi_debug_scsi_level,
+	    atomic_read(&scsi_debug_completions),
 	    scsi_debug_sector_size, sdebug_cylinders_per, sdebug_heads,
 	    sdebug_sectors_per, num_aborts, num_dev_resets, num_bus_resets,
 	    num_host_resets, dix_reads, dix_writes, dif_errors);
@@ -2907,7 +2935,7 @@ static ssize_t delay_store(struct device_driver *ddp, const char *buf,
 	char work[20];
 
         if (1 == sscanf(buf, "%10s", work)) {
-		if ((1 == sscanf(work, "%d", &delay)) && (delay >= 0)) {
+		if (1 == sscanf(work, "%d", &delay)) {
 			scsi_debug_delay = delay;
 			return count;
 		}
@@ -3234,6 +3262,24 @@ static ssize_t removable_store(struct device_driver *ddp, const char *buf,
 }
 static DRIVER_ATTR_RW(removable);
 
+static ssize_t host_lock_show(struct device_driver *ddp, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%d\n", !!scsi_debug_host_lock);
+}
+static ssize_t host_lock_store(struct device_driver *ddp, const char *buf,
+			       size_t count)
+{
+	int n;
+
+	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
+		scsi_debug_host_lock = (n > 0);
+		return count;
+	}
+	return -EINVAL;
+}
+static DRIVER_ATTR_RW(host_lock);
+
+
 /* Note: The following array creates attribute files in the
    /sys/bus/pseudo/drivers/scsi_debug directory. The advantage of these
    files (over those found in the /sys/module/scsi_debug/parameters
@@ -3266,6 +3312,7 @@ static struct attribute *sdebug_drv_attrs[] = {
 	&driver_attr_ato.attr,
 	&driver_attr_map.attr,
 	&driver_attr_removable.attr,
+	&driver_attr_host_lock.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(sdebug_drv);
@@ -3570,7 +3617,7 @@ static void sdebug_remove_adapter(void)
 }
 
 static
-int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
+int scsi_debug_queuecommand_int(struct scsi_cmnd *SCpnt, done_funct_t done)
 {
 	unsigned char *cmd = (unsigned char *) SCpnt->cmnd;
 	int len, k;
@@ -3678,7 +3725,7 @@ int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
 		errsts = check_readiness(SCpnt, 1, devip);
 		break;
 	case TEST_UNIT_READY:     /* mandatory */
-		delay_override = 1;
+		/* delay_override = 1; */
 		errsts = check_readiness(SCpnt, 0, devip);
 		break;
 	case RESERVE:
@@ -3926,7 +3973,20 @@ write:
 			     (delay_override ? 0 : scsi_debug_delay));
 }
 
-static DEF_SCSI_QCMD(scsi_debug_queuecommand)
+static int
+scsi_debug_queuecommand_choose(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
+{
+	unsigned long irq_flags;
+	int rc;
+
+	if (scsi_debug_host_lock) {
+		spin_lock_irqsave(shost->host_lock, irq_flags);
+		rc = scsi_debug_queuecommand_int(cmd, cmd->scsi_done);
+		spin_unlock_irqrestore(shost->host_lock, irq_flags);
+		return rc;
+	} else
+		return scsi_debug_queuecommand_int(cmd, cmd->scsi_done);
+}
 
 static struct scsi_host_template sdebug_driver_template = {
 	.show_info =		scsi_debug_show_info,
@@ -3938,7 +3998,7 @@ static struct scsi_host_template sdebug_driver_template = {
 	.slave_configure =	scsi_debug_slave_configure,
 	.slave_destroy =	scsi_debug_slave_destroy,
 	.ioctl =		scsi_debug_ioctl,
-	.queuecommand =		scsi_debug_queuecommand,
+	.queuecommand =		scsi_debug_queuecommand_choose,
 	.eh_abort_handler =	scsi_debug_abort,
 	.eh_bus_reset_handler = scsi_debug_bus_reset,
 	.eh_device_reset_handler = scsi_debug_device_reset,
@@ -4032,7 +4092,7 @@ static int sdebug_driver_probe(struct device * dev)
         } else
 		scsi_scan_host(hpnt);
 
-
+	atomic_set(&scsi_debug_completions, 0);
         return error;
 }
 

--------------050606070806040609080501--
