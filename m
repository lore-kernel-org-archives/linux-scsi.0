From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] async scsi scanning, version 11
Date: Sun, 24 Sep 2006 13:06:24 -0600
Message-ID: <20060924190623.GB2595@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:61086 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S1750993AbWIXTGY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Sep 2006 15:06:24 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


OK, this is the 11th version of this patch.  Since the FC people don't
seem to have time to look into why their drivers still take
forever-and-a-day to initialise, I've dropped all the support for
non-parallel-scsi from this version of the patch.

Still outstanding:

 - The comment at the top of scsi_sysfs_add_devices().  I'd really like
   someone like James or Christoph to tell me what they prefer.

Other changes:
 - I've rejigged how we wait for async scans to complete.  Now we
   compile scsi_wait_scan in, even for the non-modular case.  Fewer
   ifdefs, less mucking around in the Makefile, more commonality between
   the modular and non-modular cases.

----

Add ability to scan scsi busses asynchronously

Since it often takes around 20-30 seconds to scan a scsi bus, it's
highly advantageous to do this in parallel with other things.  The bulk
of this patch is ensuring that devices don't change numbering, and that
all devices are discovered prior to trying to start init.  For those
who build SCSI as modules, there's a new scsi_wait_scan module that will
ensure all bus scans are finished.

This patch only handles drivers which call scsi_scan_host.  Fibre Channel,
SAS, SATA, USB and Firewire all need additional work.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 71d05f4..4ab1729 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1416,6 +1416,11 @@ running once the system is up.
 
 	scsi_logging=	[SCSI]
 
+	scsi_mod.scan=	[SCSI] sync (default) scans SCSI busses as they are
+			discovered.  async scans them in kernel threads,
+			allowing boot to proceed.  none ignores them, expecting
+			user space to do the scan.
+
 	selinux		[SELINUX] Disable or enable SELinux at boot time.
 			Format: { "0" | "1" }
 			See security/selinux/Kconfig help text.
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 1ef951b..38d0e25 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -140,6 +140,8 @@ obj-$(CONFIG_CHR_DEV_SCH)	+= ch.o
 # This goes last, so that "real" scsi devices probe earlier
 obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
 
+obj-$(CONFIG_SCSI)		+= scsi_wait_scan.o
+
 scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o constants.o \
 				   scsicam.o scsi_error.o scsi_lib.o \
 				   scsi_scan.o scsi_sysfs.o \
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 5d023d4..f458c2f 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -39,6 +39,9 @@ static inline void scsi_log_completion(s
 	{ };
 #endif
 
+/* scsi_scan.c */
+int scsi_complete_async_scans(void);
+
 /* scsi_devinfo.c */
 extern int scsi_get_device_flags(struct scsi_device *sdev,
 				 const unsigned char *vendor,
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index fd9e281..371c152 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -29,7 +29,9 @@ #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
-#include <asm/semaphore.h>
+#include <linux/delay.h>
+#include <linux/kthread.h>
+#include <linux/spinlock.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -87,6 +89,11 @@ module_param_named(max_luns, max_scsi_lu
 MODULE_PARM_DESC(max_luns,
 		 "last scsi LUN (should be between 1 and 2^32-1)");
 
+static char scsi_scan_type[6] = "sync";
+
+module_param_string(scan, scsi_scan_type, sizeof(scsi_scan_type), S_IRUGO);
+MODULE_PARM_DESC(scan, "sync, async or none");
+
 /*
  * max_scsi_report_luns: the maximum number of LUNS that will be
  * returned from the REPORT LUNS command. 8 times this value must
@@ -108,6 +115,53 @@ MODULE_PARM_DESC(inq_timeout, 
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
+int scsi_complete_async_scans(void)
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
+
+#ifdef MODULE
+/* Only exported for the benefit of scsi_wait_scan */
+EXPORT_SYMBOL_GPL(scsi_complete_async_scans);
+#endif
+
 /**
  * scsi_unlock_floptical - unlock device via a special MODE SENSE command
  * @sdev:	scsi device to send command to
@@ -619,7 +673,7 @@ static int scsi_probe_lun(struct scsi_de
  *     SCSI_SCAN_LUN_PRESENT: a new scsi_device was allocated and initialized
  **/
 static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
-		int *bflags)
+		int *bflags, int async)
 {
 	/*
 	 * XXX do not save the inquiry, since it can change underneath us,
@@ -795,7 +849,7 @@ static int scsi_add_lun(struct scsi_devi
 	 * register it and tell the rest of the kernel
 	 * about it.
 	 */
-	if (scsi_sysfs_add_sdev(sdev) != 0)
+	if (!async && scsi_sysfs_add_sdev(sdev) != 0)
 		return SCSI_SCAN_NO_RESPONSE;
 
 	return SCSI_SCAN_LUN_PRESENT;
@@ -964,7 +1018,7 @@ static int scsi_probe_and_add_lun(struct
 		goto out_free_result;
 	}
 
-	res = scsi_add_lun(sdev, result, &bflags);
+	res = scsi_add_lun(sdev, result, &bflags, shost->async_scan);
 	if (res == SCSI_SCAN_LUN_PRESENT) {
 		if (bflags & BLIST_KEY) {
 			sdev->lockable = 0;
@@ -1464,6 +1518,9 @@ void scsi_scan_target(struct device *par
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
 
+	if (!shost->async_scan)
+		scsi_complete_async_scans();
+
 	mutex_lock(&shost->scan_mutex);
 	if (scsi_host_scan_allowed(shost))
 		__scsi_scan_target(parent, channel, id, lun, rescan);
@@ -1509,6 +1566,9 @@ int scsi_scan_host_selected(struct Scsi_
 		"%s: <%u:%u:%u>\n",
 		__FUNCTION__, channel, id, lun));
 
+	if (!shost->async_scan)
+		scsi_complete_async_scans();
+
 	if (((channel != SCAN_WILD_CARD) && (channel > shost->max_channel)) ||
 	    ((id != SCAN_WILD_CARD) && (id >= shost->max_id)) ||
 	    ((lun != SCAN_WILD_CARD) && (lun > shost->max_lun)))
@@ -1529,14 +1589,140 @@ int scsi_scan_host_selected(struct Scsi_
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
+ * Tells the midlayer this host is going to do an asynchronous scan.
+ * It reserves the host's position in the scanning list and ensures
+ * that other asynchronous scans started after this one won't affect the
+ * ordering of the discovered devices.
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
+
+/**
+ * scsi_finish_async_scan - asynchronous scan has finished
+ * @data: cookie returned from earlier call to scsi_prep_async_scan()
+ *
+ * All the devices currently attached to this host have been found.
+ * This function announces all the devices it has found to the rest
+ * of the system.
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
 
diff --git a/drivers/scsi/scsi_wait_scan.c b/drivers/scsi/scsi_wait_scan.c
new file mode 100644
index 0000000..f7aea46
--- /dev/null
+++ b/drivers/scsi/scsi_wait_scan.c
@@ -0,0 +1,31 @@
+/*
+ * scsi_wait_scan.c
+ *
+ * Copyright (C) 2006 James Bottomley <James.Bottomley@SteelEye.com>
+ *
+ * This is a simple module to wait until all the async scans are
+ * complete.  The idea is to use it in initrd/initramfs scripts.  You
+ * modprobe it after all the modprobes of the root SCSI drivers and it
+ * will wait until they have all finished scanning their busses before
+ * allowing the boot to proceed
+ */
+
+#include <linux/module.h>
+#include "scsi_priv.h"
+
+static int __init wait_scan_init(void)
+{
+	scsi_complete_async_scans();
+	return 0;
+}
+
+static void __exit wait_scan_exit(void)
+{
+}
+ 
+MODULE_DESCRIPTION("SCSI wait for scans");
+MODULE_AUTHOR("James Bottomley");
+MODULE_LICENSE("GPL");
+ 
+late_initcall(wait_scan_init);
+module_exit(wait_scan_exit);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 39c6f8c..5aaa7d6 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -552,6 +552,9 @@ struct Scsi_Host {
 	/* task mgmt function in progress */
 	unsigned tmf_in_progress:1;
 
+	/* Are we currently performing an async scan? */
+	unsigned async_scan:1;
+
 	/*
 	 * Optional work queue to be utilized by the transport
 	 */
