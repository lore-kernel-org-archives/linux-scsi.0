From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] scsi host / scsi device ref counting take 2 [1/3]
Date: Fri, 1 Aug 2003 13:24:31 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030801202431.GE3868@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:41405 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S270926AbTHAUUm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Aug 2003 16:20:42 -0400
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.195.10])
	by e33.co.us.ibm.com (8.12.9/8.12.2) with ESMTP id h71KKfj3275476
	for <linux-scsi@vger.kernel.org>; Fri, 1 Aug 2003 16:20:41 -0400
Received: from dyn9-47-17-195 (DYN318028BLD.beaverton.ibm.com [9.47.17.91] (may be forged))
	by westrelay01.boulder.ibm.com (8.12.9/NCO/VER6.5) with ESMTP id h71KKeAp099130
	for <linux-scsi@vger.kernel.org>; Fri, 1 Aug 2003 14:20:40 -0600
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set is against scsi-misc-2.5 cset 1.1595

Christoph, I am sorry I went dead on the last thread. I believe I address
most of your issues except the name of my callback function and the sysfs
attributes for the states. I pulled the sysfs attributes for now and
will send later. We will need to do an update on our attributes
interfaces due to some recent issues discovered by Mochel and Greg KH.

I have also put some slides up on our web site that I used at the OLS
SCSI bof to give a high level call graph of the scsi host and scsi
device reference counting.
https://www-124.ibm.com/developerworks/oss/storageio/gen-io/index.php

I have tested surprise removal with scsi_debug and usb storage.

-andmike
--
Michael Anderson
andmike@us.ibm.com


DESC
This is a cleanup patch for scsi_host removal.

- Addition of a shost_state member to the scsi_host strucuture to contain
"state" of the host instance.

- Added SHOST_ADD, SHOST_DEL, SHOST_CANCEL, SHOST_RECOVERY states for a scsi
host

- Addtion / rename of a new function scsi_host_cancel to cancel IOs in flight.

- Usage of the shost_state member to stop scsi_host_get's and calls to LLDD
queucommand under certain states.

- Reordered some of the scsi host sysfs unregistration.
EDESC


 drivers/scsi/hosts.c       |   52 +++++++++++++++++++++++++--------------------
 drivers/scsi/scsi.c        |   37 ++++++++++++++++++++++++--------
 drivers/scsi/scsi_debug.c  |    5 ----
 drivers/scsi/scsi_error.c  |    7 ++----
 drivers/scsi/scsi_lib.c    |    5 ++--
 drivers/scsi/scsi_proc.c   |   12 +++++-----
 drivers/scsi/scsi_syms.c   |    2 -
 drivers/scsi/scsi_sysfs.c  |   43 ++++++++++++++++++++++++++-----------
 drivers/scsi/sg.c          |    3 +-
 include/scsi/scsi_device.h |    3 +-
 include/scsi/scsi_host.h   |   18 ++++++++++++---
 11 files changed, 121 insertions(+), 66 deletions(-)

diff -puN drivers/scsi/hosts.c~shost_state drivers/scsi/hosts.c
--- patched-scsi-misc-2.5/drivers/scsi/hosts.c~shost_state	Thu Jul 31 14:32:18 2003
+++ patched-scsi-misc-2.5-andmike/drivers/scsi/hosts.c	Thu Jul 31 14:32:18 2003
@@ -39,30 +39,35 @@
 
 static int scsi_host_next_hn;		/* host_no for next new host */
 
+
 /**
- * scsi_remove_host - check a scsi host for release and release
- * @shost:	a pointer to a scsi host to release
- *
- * Return value:
- * 	0 on Success / 1 on Failure
+ * scsi_host_cancel - cancel outstanding IO to this host
+ * @shost:	pointer to struct Scsi_Host
+ * recovery:	recovery requested to run.
  **/
-int scsi_remove_host(struct Scsi_Host *shost)
+void scsi_host_cancel(struct Scsi_Host *shost, int recovery)
 {
-	struct scsi_device *sdev;
+	unsigned long flags;
 
-	/*
-	 * FIXME Do ref counting.  We force all of the devices offline to
-	 * help prevent race conditions where other hosts/processors could
-	 * try and get in and queue a command.
-	 */
-	list_for_each_entry(sdev, &shost->my_devices, siblings)
-		sdev->online = FALSE;
+	spin_lock_irqsave(shost->host_lock, flags);
+	set_bit(SHOST_CANCEL, &shost->shost_state);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	device_for_each_child(&shost->shost_gendev, &recovery,
+			      scsi_device_cancel_cb);
+	wait_event(shost->host_wait, (!test_bit(SHOST_RECOVERY,
+						&shost->shost_state)));
+}
 
+/**
+ * scsi_remove_host - remove a scsi host
+ * @shost:	a pointer to a scsi host to remove
+ **/
+void scsi_remove_host(struct Scsi_Host *shost)
+{
+	scsi_host_cancel(shost, 0);
 	scsi_proc_host_rm(shost);
 	scsi_forget_host(shost);
 	scsi_sysfs_remove_host(shost);
-
-	return 0;
 }
 
 /**
@@ -249,21 +254,21 @@ struct Scsi_Host *scsi_host_lookup(unsig
 {
 	struct class *class = class_get(&shost_class);
 	struct class_device *cdev;
-	struct Scsi_Host *shost = NULL, *p;
+	struct Scsi_Host *shost = ERR_PTR(-ENXIO), *p;
 
 	if (class) {
 		down_read(&class->subsys.rwsem);
 		list_for_each_entry(cdev, &class->children, node) {
 			p = class_to_shost(cdev);
 			if (p->host_no == hostnum) {
-				scsi_host_get(p);
-				shost = p;
+				shost = scsi_host_get(p);
 				break;
 			}
 		}
 		up_read(&class->subsys.rwsem);
 	}
 
+	class_put(&shost_class);
 	return shost;
 }
 
@@ -271,10 +276,12 @@ struct Scsi_Host *scsi_host_lookup(unsig
  * *scsi_host_get - inc a Scsi_Host ref count
  * @shost:	Pointer to Scsi_Host to inc.
  **/
-void scsi_host_get(struct Scsi_Host *shost)
+struct Scsi_Host *scsi_host_get(struct Scsi_Host *shost)
 {
-	get_device(&shost->shost_gendev);
-	class_device_get(&shost->shost_classdev);
+	if (test_bit(SHOST_DEL, &shost->shost_state) ||
+		!get_device(&shost->shost_gendev))
+		return NULL;
+	return shost;
 }
 
 /**
@@ -283,6 +290,5 @@ void scsi_host_get(struct Scsi_Host *sho
  **/
 void scsi_host_put(struct Scsi_Host *shost)
 {
-	class_device_put(&shost->shost_classdev);
 	put_device(&shost->shost_gendev);
 }
diff -puN drivers/scsi/scsi.c~shost_state drivers/scsi/scsi.c
--- patched-scsi-misc-2.5/drivers/scsi/scsi.c~shost_state	Thu Jul 31 14:32:18 2003
+++ patched-scsi-misc-2.5-andmike/drivers/scsi/scsi.c	Fri Aug  1 07:06:23 2003
@@ -370,7 +370,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 	struct Scsi_Host *host = cmd->device->host;
 	unsigned long flags = 0;
 	unsigned long timeout;
-	int rtn = 1;
+	int rtn = 0;
 
 	/* Assign a unique nonzero serial_number. */
 	/* XXX(hch): this is racy */
@@ -444,7 +444,12 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 				   host->hostt->queuecommand));
 
 	spin_lock_irqsave(host->host_lock, flags);
-	rtn = host->hostt->queuecommand(cmd, scsi_done);
+	if (unlikely(test_bit(SHOST_CANCEL, &host->shost_state))) {
+		cmd->result = (DID_NO_CONNECT << 16);
+		scsi_done(cmd);
+	} else {
+		rtn = host->hostt->queuecommand(cmd, scsi_done);
+	}
 	spin_unlock_irqrestore(host->host_lock, flags);
 	if (rtn) {
 		scsi_queue_insert(cmd,
@@ -901,13 +906,21 @@ void scsi_device_put(struct scsi_device 
 	module_put(sdev->host->hostt->module);
 }
 
+int scsi_device_cancel_cb(struct device *dev, void *data)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	int recovery = *(int *)data;
+
+	return scsi_device_cancel(sdev, recovery);
+}
+
 /**
- * scsi_set_device_offline - set scsi_device offline
- * @sdev:	pointer to struct scsi_device to offline. 
+ * scsi_device_cancel - cancel outstanding IO to this device
+ * @sdev:	pointer to struct scsi_device
+ * @data:	pointer to cancel value.
  *
- * Locks:	host_lock held on entry.
  **/
-void scsi_set_device_offline(struct scsi_device *sdev)
+int scsi_device_cancel(struct scsi_device *sdev, int recovery)
 {
 	struct scsi_cmnd *scmd;
 	LIST_HEAD(active_list);
@@ -934,11 +947,17 @@ void scsi_set_device_offline(struct scsi
 	if (!list_empty(&active_list)) {
 		list_for_each_safe(lh, lh_sf, &active_list) {
 			scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
-			scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD);
+			list_del_init(lh);
+			if (recovery) {
+				scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD);
+			} else {
+				scmd->result = (DID_ABORT << 16);
+				scsi_finish_command(scmd);
+			}
 		}
-	} else {
-		/* FIXME: Send online state change hotplug event */
 	}
+
+	return 0;
 }
 
 MODULE_DESCRIPTION("SCSI core");
diff -puN drivers/scsi/scsi_debug.c~shost_state drivers/scsi/scsi_debug.c
--- patched-scsi-misc-2.5/drivers/scsi/scsi_debug.c~shost_state	Thu Jul 31 14:32:18 2003
+++ patched-scsi-misc-2.5-andmike/drivers/scsi/scsi_debug.c	Thu Jul 31 14:32:18 2003
@@ -1722,10 +1722,7 @@ static int sdebug_driver_remove(struct d
 		return -ENODEV;
 	}
 
-        if (scsi_remove_host(sdbg_host->shost)) {
-                printk(KERN_ERR "%s: scsi_remove_host failed\n", __FUNCTION__);
-                return -EBUSY;
-        }
+        scsi_remove_host(sdbg_host->shost);
 
         list_for_each_safe(lh, lh_sf, &sdbg_host->dev_info_list) {
                 sdbg_devinfo = list_entry(lh, struct sdebug_dev_info,
diff -puN drivers/scsi/scsi_error.c~shost_state drivers/scsi/scsi_error.c
--- patched-scsi-misc-2.5/drivers/scsi/scsi_error.c~shost_state	Thu Jul 31 14:32:18 2003
+++ patched-scsi-misc-2.5-andmike/drivers/scsi/scsi_error.c	Thu Jul 31 14:32:18 2003
@@ -84,7 +84,7 @@ int scsi_eh_scmd_add(struct scsi_cmnd *s
 	 */
 	scmd->serial_number_at_timeout = scmd->serial_number;
 	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
-	shost->in_recovery = 1;
+	set_bit(SHOST_RECOVERY, &shost->shost_state);
 	shost->host_failed++;
 	scsi_eh_wakeup(shost);
 	spin_unlock_irqrestore(shost->host_lock, flags);
@@ -187,7 +187,7 @@ void scsi_times_out(struct scsi_cmnd *sc
  **/
 int scsi_block_when_processing_errors(struct scsi_device *sdev)
 {
-	wait_event(sdev->host->host_wait, (sdev->host->in_recovery == 0));
+	wait_event(sdev->host->host_wait, (!test_bit(SHOST_RECOVERY, &sdev->host->shost_state)));
 
 	SCSI_LOG_ERROR_RECOVERY(5, printk("%s: rtn: %d\n", __FUNCTION__,
 					  sdev->online));
@@ -1389,7 +1389,7 @@ static void scsi_restart_operations(stru
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: waking up host to restart\n",
 					  __FUNCTION__));
 
-	shost->in_recovery = 0;
+	clear_bit(SHOST_RECOVERY, &shost->shost_state);
 
 	wake_up(&shost->host_wait);
 
@@ -1599,7 +1599,6 @@ void scsi_error_handler(void *data)
 	 * that's fine.  If the user sent a signal to this thing, we are
 	 * potentially in real danger.
 	 */
-	shost->in_recovery = 0;
 	shost->eh_active = 0;
 	shost->ehandler = NULL;
 
diff -puN drivers/scsi/scsi_lib.c~shost_state drivers/scsi/scsi_lib.c
--- patched-scsi-misc-2.5/drivers/scsi/scsi_lib.c~shost_state	Thu Jul 31 14:32:18 2003
+++ patched-scsi-misc-2.5-andmike/drivers/scsi/scsi_lib.c	Thu Jul 31 14:32:18 2003
@@ -318,7 +318,8 @@ void scsi_device_unbusy(struct scsi_devi
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->host_busy--;
-	if (unlikely(shost->in_recovery && shost->host_failed))
+	if (unlikely(test_bit(SHOST_RECOVERY, &shost->shost_state) &&
+		     shost->host_failed))
 		scsi_eh_wakeup(shost);
 	spin_unlock(shost->host_lock);
 	spin_lock(&sdev->sdev_lock);
@@ -1066,7 +1067,7 @@ static inline int scsi_host_queue_ready(
 				   struct Scsi_Host *shost,
 				   struct scsi_device *sdev)
 {
-	if (shost->in_recovery)
+	if (test_bit(SHOST_RECOVERY, &shost->shost_state))
 		return 0;
 	if (shost->host_busy == 0 && shost->host_blocked) {
 		/*
diff -puN drivers/scsi/scsi_proc.c~shost_state drivers/scsi/scsi_proc.c
--- patched-scsi-misc-2.5/drivers/scsi/scsi_proc.c~shost_state	Thu Jul 31 14:32:18 2003
+++ patched-scsi-misc-2.5-andmike/drivers/scsi/scsi_proc.c	Thu Jul 31 14:32:18 2003
@@ -190,11 +190,11 @@ static int scsi_add_single_device(uint h
 {
 	struct Scsi_Host *shost;
 	struct scsi_device *sdev;
-	int error = -ENODEV;
+	int error = -ENXIO;
 
 	shost = scsi_host_lookup(host);
-	if (!shost)
-		return -ENODEV;
+	if (IS_ERR(shost))
+		return PTR_ERR(shost);
 
 	if (!scsi_find_device(shost, channel, id, lun)) {
 		sdev = scsi_add_device(shost, channel, id, lun);
@@ -212,11 +212,11 @@ static int scsi_remove_single_device(uin
 {
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost;
-	int error = -ENODEV;
+	int error = -ENXIO;
 
 	shost = scsi_host_lookup(host);
-	if (!shost)
-		return -ENODEV;
+	if (IS_ERR(shost))
+		return PTR_ERR(shost);
 	sdev = scsi_find_device(shost, channel, id, lun);
 	if (!sdev)
 		goto out;
diff -puN drivers/scsi/scsi_syms.c~shost_state drivers/scsi/scsi_syms.c
--- patched-scsi-misc-2.5/drivers/scsi/scsi_syms.c~shost_state	Thu Jul 31 14:32:18 2003
+++ patched-scsi-misc-2.5-andmike/drivers/scsi/scsi_syms.c	Thu Jul 31 14:32:18 2003
@@ -86,7 +86,7 @@ EXPORT_SYMBOL(scsi_device_get);
 EXPORT_SYMBOL(scsi_device_put);
 EXPORT_SYMBOL(scsi_add_device);
 EXPORT_SYMBOL(scsi_remove_device);
-EXPORT_SYMBOL(scsi_set_device_offline);
+EXPORT_SYMBOL(scsi_device_cancel);
 
 EXPORT_SYMBOL(__scsi_mode_sense);
 EXPORT_SYMBOL(scsi_mode_sense);
diff -puN drivers/scsi/scsi_sysfs.c~shost_state drivers/scsi/scsi_sysfs.c
--- patched-scsi-misc-2.5/drivers/scsi/scsi_sysfs.c~shost_state	Thu Jul 31 14:32:18 2003
+++ patched-scsi-misc-2.5-andmike/drivers/scsi/scsi_sysfs.c	Fri Aug  1 07:06:23 2003
@@ -54,8 +54,28 @@ static struct class_device_attribute *sc
 	NULL
 };
 
+static void scsi_host_cls_release(struct class_device *class_dev)
+{
+	struct Scsi_Host *shost;
+
+	shost = class_to_shost(class_dev);
+	put_device(&shost->shost_gendev);
+}
+
+static void scsi_host_dev_release(struct device *dev)
+{
+	struct Scsi_Host *shost;
+	struct device *parent;
+
+	parent = dev->parent;
+	shost = dev_to_shost(dev);
+	scsi_free_shost(shost);
+	put_device(parent);
+}
+
 struct class shost_class = {
 	.name		= "scsi_host",
+	.release	= scsi_host_cls_release,
 };
 
 static struct class sdev_class = {
@@ -346,16 +366,6 @@ int scsi_register_interface(struct class
 	return class_interface_register(intf);
 }
 
-static void scsi_host_release(struct device *dev)
-{
-	struct Scsi_Host *shost;
-
-	shost = dev_to_shost(dev);
-	if (!shost)
-		return;
-
-	scsi_free_shost(shost);
-}
 
 void scsi_sysfs_init_host(struct Scsi_Host *shost)
 {
@@ -364,7 +374,7 @@ void scsi_sysfs_init_host(struct Scsi_Ho
 		shost->host_no);
 	snprintf(shost->shost_gendev.name, DEVICE_NAME_SIZE, "%s",
 		shost->hostt->proc_name);
-	shost->shost_gendev.release = scsi_host_release;
+	shost->shost_gendev.release = scsi_host_dev_release;
 
 	class_device_initialize(&shost->shost_classdev);
 	shost->shost_classdev.dev = &shost->shost_gendev;
@@ -426,10 +436,14 @@ int scsi_sysfs_add_host(struct Scsi_Host
 	if (error)
 		return error;
 
+	set_bit(SHOST_ADD, &shost->shost_state);
+	get_device(shost->shost_gendev.parent);
+
 	error = class_device_add(&shost->shost_classdev);
 	if (error)
 		goto clean_device;
 
+	get_device(&shost->shost_gendev);
 	if (shost->hostt->shost_attrs) {
 		for (i = 0; shost->hostt->shost_attrs[i]; i++) {
 			error = class_attr_add(&shost->shost_classdev,
@@ -465,6 +479,11 @@ clean_device:
  **/
 void scsi_sysfs_remove_host(struct Scsi_Host *shost)
 {
-	class_device_del(&shost->shost_classdev);
+	unsigned long flags;
+	spin_lock_irqsave(shost->host_lock, flags);
+	set_bit(SHOST_DEL, &shost->shost_state);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	class_device_unregister(&shost->shost_classdev);
 	device_del(&shost->shost_gendev);
 }
diff -puN drivers/scsi/sg.c~shost_state drivers/scsi/sg.c
--- patched-scsi-misc-2.5/drivers/scsi/sg.c~shost_state	Thu Jul 31 14:32:18 2003
+++ patched-scsi-misc-2.5-andmike/drivers/scsi/sg.c	Thu Jul 31 14:32:18 2003
@@ -954,7 +954,8 @@ sg_ioctl(struct inode *inode, struct fil
 		if (sdp->detached)
 			return -ENODEV;
 		if (filp->f_flags & O_NONBLOCK) {
-			if (sdp->device->host->in_recovery)
+			if (test_bit(SHOST_RECOVERY,
+				     &sdp->device->host->shost_state))
 				return -EBUSY;
 		} else if (!scsi_block_when_processing_errors(sdp->device))
 			return -EBUSY;
diff -puN include/scsi/scsi_device.h~shost_state include/scsi/scsi_device.h
--- patched-scsi-misc-2.5/include/scsi/scsi_device.h~shost_state	Thu Jul 31 14:32:18 2003
+++ patched-scsi-misc-2.5-andmike/include/scsi/scsi_device.h	Fri Aug  1 07:06:23 2003
@@ -93,7 +93,8 @@ struct scsi_device {
 extern struct scsi_device *scsi_add_device(struct Scsi_Host *,
 		uint, uint, uint);
 extern int scsi_remove_device(struct scsi_device *);
-extern void scsi_set_device_offline(struct scsi_device *);
+extern int scsi_device_cancel_cb(struct device *, void *);
+extern int scsi_device_cancel(struct scsi_device *, int);
 
 extern int scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
diff -puN include/scsi/scsi_host.h~shost_state include/scsi/scsi_host.h
--- patched-scsi-misc-2.5/include/scsi/scsi_host.h~shost_state	Thu Jul 31 14:32:18 2003
+++ patched-scsi-misc-2.5-andmike/include/scsi/scsi_host.h	Thu Jul 31 14:32:18 2003
@@ -348,6 +348,16 @@ struct scsi_host_template {
 	struct list_head legacy_hosts;
 };
 
+/*
+ * shost states
+ */
+enum {
+	SHOST_ADD,
+	SHOST_DEL,
+	SHOST_CANCEL,
+	SHOST_RECOVERY,
+};
+
 struct Scsi_Host {
 	struct list_head	my_devices;
 	struct scsi_host_cmd_pool *cmd_pool;
@@ -413,7 +423,6 @@ struct Scsi_Host {
 	short unsigned int sg_tablesize;
 	short unsigned int max_sectors;
 
-	unsigned in_recovery:1;
 	unsigned unchecked_isa_dma:1;
 	unsigned use_clustering:1;
 	unsigned highmem_io:1;
@@ -448,6 +457,9 @@ struct Scsi_Host {
 	unsigned char n_io_port;
 	unsigned char dma_channel;
 	unsigned int  irq;
+	
+
+	unsigned long shost_state;
 
 	/* ldm bits */
 	struct device		shost_gendev;
@@ -478,8 +490,8 @@ struct Scsi_Host {
 extern struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *, int);
 extern int scsi_add_host(struct Scsi_Host *, struct device *);
 extern void scsi_scan_host(struct Scsi_Host *);
-extern int scsi_remove_host(struct Scsi_Host *);
-extern void scsi_host_get(struct Scsi_Host *);
+extern void scsi_remove_host(struct Scsi_Host *);
+extern struct Scsi_Host *scsi_host_get(struct Scsi_Host *);
 extern void scsi_host_put(struct Scsi_Host *t);
 extern struct Scsi_Host *scsi_host_lookup(unsigned short);
 

_

