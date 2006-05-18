From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Asynchronous scsi scanning
Date: Thu, 18 May 2006 11:22:58 -0600
Message-ID: <20060518172258.GL1604@parisc-linux.org>
References: <20060511143352.GI12272@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:59590 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S932075AbWERRW7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 13:22:59 -0400
Content-Disposition: inline
In-Reply-To: <20060511143352.GI12272@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Thu, May 11, 2006 at 08:33:52AM -0600, Matthew Wilcox wrote:
> A customer has a machine with 162 scsi hosts, and just scanning the scsi
> busses takes over an hour.  Here's what I've come up with to reduce that.
> For drivers which call scsi_scan_host(), no changes are necessary.
> The fibrechannel and SAS drivers are going to take a bit more work,
> but I thought I'd send out the core first.  I'm not entirely happy about
> how the threads rendezvous; it'd be nice to not have to use a completion.

I guess nobody looked at this patch to find my bugs ;-)  Here's an
updated patch which fixes a few problems:

 - scsi_complete_async_scans() now hooks onto the end of the list and
   waits for completion, rather than the rather hacky 'sleep for one
   second until the list is empty'.
 - scsi_prep_aync_scan() now takes a reference to the host, which is
   released by scsi_finish_async_scan().  That prevents the host from
   going away while we're scanning.  I don't think this is a danger with
   normal scsi hosts, but I couldn't prove USB couldn't do it ... and
   better safe than sorry.
 - Handle some error conditions like kmalloc() and scsi_host_get() failing.
 - Keep the list lock around the wake-up-the-next-one logic to prevent
   a double-completion.

I'm going to put this patch into the parisc-linux tree to get it some
more testers.  It'd be nice if we could get this into 2.6.18 ...

--- cut ---

Scanning SCSI busses takes an inordinately long time at boot.  Attempt
to ameliorate the situation by scanning all scsi busses in parallel.
This effects a dramatic improvement in boot time, even on machines with
a single scsi bus, as the bus scan can complete while other
initialisation is occurring.  On one large configuration I have access
to, it cuts boot time from 276.45 seconds down to 149.59 seconds; over
two minutes saved.

Great care is taken not to perturb scsi device naming.

Signed-off-by: Matthew Wilcox <mattheww@wil.cx>

Index: ./drivers/scsi/scsi_scan.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/scsi_scan.c,v
retrieving revision 1.38
diff -u -p -r1.38 scsi_scan.c
--- ./drivers/scsi/scsi_scan.c	19 Apr 2006 04:55:59 -0000	1.38
+++ ./drivers/scsi/scsi_scan.c	18 May 2006 16:34:50 -0000
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
@@ -109,6 +111,45 @@ MODULE_PARM_DESC(inq_timeout, 
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
+	if (list_empty(&scanning_hosts))
+		return 0;
+
+	data = kmalloc(sizeof(*data), GFP_KERNEL);
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
+	spin_unlock(&async_scan_lock);
+
+ done:
+	kfree(data);
+	return 0;
+}
+late_initcall(scsi_complete_async_scans);
+
+
 /**
  * scsi_unlock_floptical - unlock device via a special MODE SENSE command
  * @sdev:	scsi device to send command to
@@ -629,7 +670,8 @@ static int scsi_probe_lun(struct scsi_de
  *     SCSI_SCAN_NO_RESPONSE: could not allocate or setup a scsi_device
  *     SCSI_SCAN_LUN_PRESENT: a new scsi_device was allocated and initialized
  **/
-static int scsi_add_lun(struct scsi_device *sdev, char *inq_result, int *bflags)
+static int scsi_add_lun(struct scsi_device *sdev, char *inq_result,
+			int *bflags, int async)
 {
 	/*
 	 * XXX do not save the inquiry, since it can change underneath us,
@@ -802,7 +844,7 @@ static int scsi_add_lun(struct scsi_devi
 	 * register it and tell the rest of the kernel
 	 * about it.
 	 */
-	if (scsi_sysfs_add_sdev(sdev) != 0)
+	if (!async && scsi_sysfs_add_sdev(sdev) != 0)
 		return SCSI_SCAN_NO_RESPONSE;
 
 	return SCSI_SCAN_LUN_PRESENT;
@@ -914,7 +956,7 @@ static int scsi_probe_and_add_lun(struct
 		goto out_free_result;
 	}
 
-	res = scsi_add_lun(sdev, result, &bflags);
+	res = scsi_add_lun(sdev, result, &bflags, shost->async_scan);
 	if (res == SCSI_SCAN_LUN_PRESENT) {
 		if (bflags & BLIST_KEY) {
 			sdev->lockable = 0;
@@ -1427,6 +1469,9 @@ void scsi_scan_target(struct device *par
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
 
+	if (!shost->async_scan)
+		scsi_complete_async_scans();
+
 	mutex_lock(&shost->scan_mutex);
 	if (scsi_host_scan_allowed(shost))
 		__scsi_scan_target(parent, channel, id, lun, rescan);
@@ -1492,14 +1537,127 @@ int scsi_scan_host_selected(struct Scsi_
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
+	struct Scsi_Host *shost = data->shost;
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
+	struct async_scan_data *data = scsi_prep_async_scan(shost);
+	if (!data)
+		return;
+	kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
 }
 EXPORT_SYMBOL(scsi_scan_host);
 
Index: ./include/scsi/scsi_device.h
===================================================================
RCS file: /var/cvs/linux-2.6/include/scsi/scsi_device.h,v
retrieving revision 1.27
diff -u -p -r1.27 scsi_device.h
--- ./include/scsi/scsi_device.h	3 Apr 2006 13:46:08 -0000	1.27
+++ ./include/scsi/scsi_device.h	18 May 2006 16:34:50 -0000
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
retrieving revision 1.26
diff -u -p -r1.26 scsi_host.h
--- ./include/scsi/scsi_host.h	19 Apr 2006 04:56:20 -0000	1.26
+++ ./include/scsi/scsi_host.h	18 May 2006 16:34:50 -0000
@@ -541,6 +541,9 @@ struct Scsi_Host {
 	 */
 	unsigned ordered_tag:1;
 
+	/* Are we currently performing an async scan? */
+	unsigned async_scan:1;
+
 	/*
 	 * Optional work queue to be utilized by the transport
 	 */
