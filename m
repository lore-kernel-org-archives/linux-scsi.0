From: Matthew Wilcox <matthew@wil.cx>
Subject: Asynchronous scsi scanning, version 9
Date: Sun, 28 May 2006 21:19:15 -0600
Message-ID: <20060529031915.GB23405@parisc-linux.org>
References: <20060511143352.GI12272@parisc-linux.org> <20060518172258.GL1604@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:11139 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1751131AbWE2DTQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 May 2006 23:19:16 -0400
Content-Disposition: inline
In-Reply-To: <20060518172258.GL1604@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This version of the patch incorporates the feedback from Storage Summit
and fixes a few more little bugs.  James, could you grep for 'yucky'
and advise me whether you prefer the way I've done it, or the way I
suggest we might want to do it?

--- cut ---

Add the scsi_mod.scan kernel parameter to determine how scsi busses
are scanned.  "sync" is the current behaviour.  "none" punts scanning
scsi busses to userspace.  "async" is the new default.

With async, we spawn a kernel thread to scan each scsi host.  As each
thread completes its scan, it waits for all its predecessors to complete,
then adds the devices it found, preserving current device naming.
The late_initcall ensures that all built-in drivers finish their scans
before init is started.

Boot-time benefits from this include cutting 2 minutes from the prior
4 minute boot time of an hp rx8620 with 16 CPUs and 18 scsi hosts,
and several seconds from smaller machines.  If scsi were moved earlier
in the initialisation sequence, more gains could be realised as more
devices could be initialised in parallel with the scsi devices.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

Index: ./drivers/scsi/scsi_scan.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/scsi_scan.c,v
retrieving revision 1.40.2.1
retrieving revision 1.41
diff -u -p -r1.40.2.1 -r1.41
--- ./drivers/scsi/scsi_scan.c	27 May 2006 15:58:03 -0000	1.40.2.1
+++ ./drivers/scsi/scsi_scan.c	29 May 2006 02:51:18 -0000	1.41
@@ -30,7 +30,9 @@
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
-#include <asm/semaphore.h>
+#include <linux/delay.h>
+#include <linux/kthread.h>
+#include <linux/spinlock.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -88,6 +90,11 @@ module_param_named(max_luns, max_scsi_lu
 MODULE_PARM_DESC(max_luns,
 		 "last scsi LUN (should be between 1 and 2^32-1)");
 
+static char scsi_scan_type[] = "async";
+
+module_param_string(scan, scsi_scan_type, sizeof(scsi_scan_type), S_IRUGO);
+MODULE_PARM_DESC(scan, "sync, async or none");
+
 /*
  * max_scsi_report_luns: the maximum number of LUNS that will be
  * returned from the REPORT LUNS command. 8 times this value must
@@ -109,6 +116,50 @@ MODULE_PARM_DESC(inq_timeout, 
 		 "Timeout (in seconds) waiting for devices to answer INQUIRY."
 		 " Default is 5. Some non-compliant devices need more.");
 
+static spinlock_t async_scan_lock = SPIN_LOCK_UNLOCKED;
+static LIST_HEAD(scanning_hosts);
+
+struct async_scan_data {
+	struct list_head list;
+	struct Scsi_Host *shost;
+	struct completion prev_finished;
+};
+
+static int scsi_complete_async_scans(void)
+{
+	struct async_scan_data *data;
+
+	do {
+		if (list_empty(&scanning_hosts))
+			return 0;
+		data = kmalloc(sizeof(*data), GFP_KERNEL);
+		if (!data)
+			msleep(1);
+	} while (!data);
+
+	data->shost = NULL;
+	init_completion(&data->prev_finished);
+
+	spin_lock(&async_scan_lock);
+	if (list_empty(&scanning_hosts))
+		goto done;
+	list_add_tail(&data->list, &scanning_hosts);
+	spin_unlock(&async_scan_lock);
+
+	printk(KERN_INFO "scsi: waiting for bus probes to complete ...\n");
+	wait_for_completion(&data->prev_finished);
+
+	spin_lock(&async_scan_lock);
+	list_del(&data->list);
+ done:
+	spin_unlock(&async_scan_lock);
+
+	kfree(data);
+	return 0;
+}
+late_initcall(scsi_complete_async_scans);
+
+
 /**
  * scsi_unlock_floptical - unlock device via a special MODE SENSE command
  * @sdev:	scsi device to send command to
@@ -629,7 +680,8 @@ static int scsi_probe_lun(struct scsi_de
  *     SCSI_SCAN_NO_RESPONSE: could not allocate or setup a scsi_device
  *     SCSI_SCAN_LUN_PRESENT: a new scsi_device was allocated and initialized
  **/
-static int scsi_add_lun(struct scsi_device *sdev, char *inq_result, int *bflags)
+static int scsi_add_lun(struct scsi_device *sdev, char *inq_result,
+			int *bflags, int async)
 {
 	/*
 	 * XXX do not save the inquiry, since it can change underneath us,
@@ -802,7 +854,7 @@ static int scsi_add_lun(struct scsi_devi
 	 * register it and tell the rest of the kernel
 	 * about it.
 	 */
-	if (scsi_sysfs_add_sdev(sdev) != 0)
+	if (!async && scsi_sysfs_add_sdev(sdev) != 0)
 		return SCSI_SCAN_NO_RESPONSE;
 
 	return SCSI_SCAN_LUN_PRESENT;
@@ -914,7 +966,7 @@ static int scsi_probe_and_add_lun(struct
 		goto out_free_result;
 	}
 
-	res = scsi_add_lun(sdev, result, &bflags);
+	res = scsi_add_lun(sdev, result, &bflags, shost->async_scan);
 	if (res == SCSI_SCAN_LUN_PRESENT) {
 		if (bflags & BLIST_KEY) {
 			sdev->lockable = 0;
@@ -1427,6 +1479,12 @@ void scsi_scan_target(struct device *par
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
 
+	if (strncmp(scsi_scan_type, "none", 4) == 0)
+		return;
+
+	if (!shost->async_scan)
+		scsi_complete_async_scans();
+
 	mutex_lock(&shost->scan_mutex);
 	if (scsi_host_scan_allowed(shost))
 		__scsi_scan_target(parent, channel, id, lun, rescan);
@@ -1472,6 +1530,9 @@ int scsi_scan_host_selected(struct Scsi_
 		"%s: <%u:%u:%u>\n",
 		__FUNCTION__, channel, id, lun));
 
+	if (!shost->async_scan)
+		scsi_complete_async_scans();
+
 	if (((channel != SCAN_WILD_CARD) && (channel > shost->max_channel)) ||
 	    ((id != SCAN_WILD_CARD) && (id > shost->max_id)) ||
 	    ((lun != SCAN_WILD_CARD) && (lun > shost->max_lun)))
@@ -1492,14 +1553,143 @@ int scsi_scan_host_selected(struct Scsi_
 	return 0;
 }
 
+/* The error handling here is pretty yucky.  Do we want an
+ * shost_for_each_device_safe() iterator?
+ */
+static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
+{
+	struct scsi_device *sdev;
+	shost_for_each_device(sdev, shost) {
+		int err;
+ next:
+		err = scsi_sysfs_add_sdev(sdev);
+		if (err) {
+			struct scsi_device *tmp = sdev;
+			sdev = __scsi_iterate_devices(shost, sdev);
+			scsi_destroy_sdev(tmp);
+			goto next;
+		}
+	}
+}
+
+/**
+ * scsi_prep_async_scan - prepare for an async scan
+ * @shost: the host which will be scanned
+ * Returns: a cookie to be passed to scsi_finish_async_scan()
+ *
+ * If your driver does not use scsi_scan_host(), you can call this function
+ * to tell the midlayer you're about to commence an asynchronous scan.
+ * This reserves your device's position in the scanning list and ensures
+ * that other asynchronous scans started after yours won't affect the
+ * disc ordering.
+ */
+struct async_scan_data * scsi_prep_async_scan(struct Scsi_Host *shost)
+{
+	struct async_scan_data *data;
+
+	if (strncmp(scsi_scan_type, "sync", 4) == 0)
+		return NULL;
+
+	if (shost->async_scan) {
+		printk("%s called twice for host %d", __FUNCTION__,
+				shost->host_no);
+		dump_stack();
+		return NULL;
+	}
+
+	data = kmalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		goto err;
+	data->shost = scsi_host_get(shost);
+	if (!data->shost)
+		goto err;
+	init_completion(&data->prev_finished);
+
+	spin_lock(&async_scan_lock);
+	shost->async_scan = 1;
+	if (list_empty(&scanning_hosts))
+		complete(&data->prev_finished);
+	list_add_tail(&data->list, &scanning_hosts);
+	spin_unlock(&async_scan_lock);
+
+	return data;
+
+ err:
+	kfree(data);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(scsi_prep_async_scan);
+
+/**
+ * scsi_finish_async_scan - asynchronous scan has finished
+ * @data: cookie returned from earlier call to scsi_prep_async_scan()
+ *
+ * Once your driver has found all the devices currently present, call
+ * this function.  It will announce all the devices it has found to
+ * the rest of the system.
+ */
+void scsi_finish_async_scan(struct async_scan_data *data)
+{
+	struct Scsi_Host *shost;
+
+	if (!data)
+		return;
+
+	shost = data->shost;
+	if (!shost->async_scan) {
+		printk("%s called twice for host %d", __FUNCTION__,
+				shost->host_no);
+		dump_stack();
+		return;
+	}
+
+	wait_for_completion(&data->prev_finished);
+
+	scsi_sysfs_add_devices(shost);
+
+	spin_lock(&async_scan_lock);
+	shost->async_scan = 0;
+	list_del(&data->list);
+	if (!list_empty(&scanning_hosts)) {
+		struct async_scan_data *next = list_entry(scanning_hosts.next,
+				struct async_scan_data, list);
+		complete(&next->prev_finished);
+	}
+	spin_unlock(&async_scan_lock);
+
+	scsi_host_put(shost);
+	kfree(data);
+}
+EXPORT_SYMBOL_GPL(scsi_finish_async_scan);
+
+static int do_scan_async(void *_data)
+{
+	struct async_scan_data *data = _data;
+	scsi_scan_host_selected(data->shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
+				SCAN_WILD_CARD, 0);
+
+	scsi_finish_async_scan(data);
+	return 0;
+}
+
 /**
  * scsi_scan_host - scan the given adapter
  * @shost:	adapter to scan
  **/
 void scsi_scan_host(struct Scsi_Host *shost)
 {
-	scsi_scan_host_selected(shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
-				SCAN_WILD_CARD, 0);
+	struct async_scan_data *data;
+
+	if (strncmp(scsi_scan_type, "none", 4) == 0)
+		return;
+
+	data = scsi_prep_async_scan(shost);
+	if (!data) {
+		scsi_scan_host_selected(shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
+					SCAN_WILD_CARD, 0);
+		return;
+	}
+	kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
 }
 EXPORT_SYMBOL(scsi_scan_host);
 
Index: ./include/scsi/scsi_device.h
===================================================================
RCS file: /var/cvs/linux-2.6/include/scsi/scsi_device.h,v
retrieving revision 1.28.2.1
retrieving revision 1.28
diff -u -p -r1.28.2.1 -r1.28
--- ./include/scsi/scsi_device.h	27 May 2006 15:58:17 -0000	1.28.2.1
+++ ./include/scsi/scsi_device.h	19 May 2006 02:43:19 -0000	1.28
@@ -298,6 +298,10 @@ extern int scsi_execute_async(struct scs
 			      void (*done)(void *, char *, int, int),
 			      gfp_t gfp);
 
+struct async_scan_data;
+struct async_scan_data * scsi_prep_async_scan(struct Scsi_Host *shost);
+void scsi_finish_async_scan(struct async_scan_data *data);
+
 static inline void scsi_device_reprobe(struct scsi_device *sdev)
 {
 	device_reprobe(&sdev->sdev_gendev);
Index: ./include/scsi/scsi_host.h
===================================================================
RCS file: /var/cvs/linux-2.6/include/scsi/scsi_host.h,v
retrieving revision 1.27.2.1
retrieving revision 1.27
diff -u -p -r1.27.2.1 -r1.27
--- ./include/scsi/scsi_host.h	27 May 2006 15:58:17 -0000	1.27.2.1
+++ ./include/scsi/scsi_host.h	19 May 2006 02:43:19 -0000	1.27
@@ -541,6 +541,9 @@ struct Scsi_Host {
 	 */
 	unsigned ordered_tag:1;
 
+	/* Are we currently performing an async scan? */
+	unsigned async_scan:1;
+
 	/*
 	 * Optional work queue to be utilized by the transport
 	 */

