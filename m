From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] scsi_device refcounting and list lockdown
Date: Mon, 27 Oct 2003 16:57:13 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031027155713.GA28140@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:52448 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263285AbTJ0P5W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Oct 2003 10:57:22 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

 - shost->my_devices is gone and replaced by ->__devices, which is not
   exposed to drivers and locked by the host lock.  Use the exported
   helpers that do proper refcounting to access it.
 - sdev->access_count is gone as a side-effect, the sg interfaces
   to export it now return 1 for a present scsi_device.
 - drivers/scsi/host.h is empty now.


--- 1.44/drivers/ieee1394/sbp2.c	Tue Sep  2 20:08:00 2003
+++ edited/drivers/ieee1394/sbp2.c	Mon Oct 27 12:01:48 2003
@@ -991,7 +991,7 @@
 static void sbp2_remove_device(struct scsi_id_instance_data *scsi_id)
 {
 	struct sbp2scsi_host_info *hi = scsi_id->hi;
-	struct scsi_device *sdev = scsi_find_device(hi->scsi_host, 0, scsi_id->id, 0);
+	struct scsi_device *sdev;
 
 	SBP2_DEBUG("sbp2_remove_device");
 
@@ -999,8 +999,13 @@
 	sbp2scsi_complete_all_commands(scsi_id, DID_NO_CONNECT);
 
 	/* Remove it from the scsi layer now */
-	if (sdev)
+	/* XXX(hch): why can't we simply cache the scsi_device
+	   	     in struct scsi_id_instance_data? */
+	sdev = scsi_device_lookup(hi->scsi_host, 0, scsi_id->id, 0);
+	if (sdev) {
 		scsi_remove_device(sdev);
+		scsi_device_put(sdev);
+	}
 
 	sbp2util_remove_command_orb_pool(scsi_id);
 
--- 1.44/drivers/scsi/53c700.c	Sat Sep 20 11:35:53 2003
+++ edited/drivers/scsi/53c700.c	Mon Oct 27 12:01:48 2003
@@ -1057,15 +1057,18 @@
 		__u8 lun;
 		struct NCR_700_command_slot *slot;
 		__u8 reselection_id = hostdata->reselection_id;
-		Scsi_Device *SDp;
+		struct scsi_device *SDp;
+		unsigned long flags;
 
 		lun = hostdata->msgin[0] & 0x1f;
 
 		hostdata->reselection_id = 0xff;
 		DEBUG(("scsi%d: (%d:%d) RESELECTED!\n",
 		       host->host_no, reselection_id, lun));
+
 		/* clear the reselection indicator */
-		SDp = scsi_find_device(host, 0, reselection_id, lun);
+		spin_lock_irqsave(host->host_lock, flags);
+		SDp = __scsi_device_lookup(host, 0, reselection_id, lun);
 		if(unlikely(SDp == NULL)) {
 			printk(KERN_ERR "scsi%d: (%d:%d) HAS NO device\n",
 			       host->host_no, reselection_id, lun);
@@ -1092,6 +1095,7 @@
 			}
 			slot = (struct NCR_700_command_slot *)SCp->host_scribble;
 		}
+		spin_unlock_irqrestore(host->host_lock, flags);
 
 		if(slot == NULL) {
 			printk(KERN_ERR "scsi%d: (%d:%d) RESELECTED but no saved command (MSG = %02x %02x %02x)!!\n",
@@ -1498,7 +1502,7 @@
 			       host->host_no, SCp, SCp == NULL ? NULL : SCp->host_scribble, dsp, dsp - hostdata->pScript);
 
 			/* clear all the negotiated parameters */
-	    		list_for_each_entry(SDp, &host->my_devices, siblings)
+			__shost_for_each_device(SDp, host)
 				SDp->hostdata = 0;
 			
 			/* clear all the slots and their pending commands */
--- 1.28/drivers/scsi/NCR53C9x.c	Sun Jul 27 21:24:27 2003
+++ edited/drivers/scsi/NCR53C9x.c	Mon Oct 27 12:01:48 2003
@@ -815,6 +815,7 @@
 
 static int esp_host_info(struct NCR_ESP *esp, char *ptr, off_t offset, int len)
 {
+	struct scsi_device *sdev;
 	struct info_str info;
 	int i;
 
@@ -867,23 +868,20 @@
 	
 	/* Now describe the state of each existing target. */
 	copy_info(&info, "Target #\tconfig3\t\tSync Capabilities\tDisconnect\n");
-	for(i = 0; i < 15; i++) {
-		if(esp->targets_present & (1 << i)) {
-			Scsi_Device *SDptr;
-			struct esp_device *esp_dev;
 
-			list_for_each_entry(SDptr, &esp->ehost->my_devices,
-					siblings)
-				if(SDptr->id == i)
-					break;
+	shost_for_each_device(sdev, esp->ehost) {
+		struct esp_device *esp_dev = sdev->hostdata;
+		uint id = sdev->id;
+
+		if (!(esp->targets_present & (1 << id)))
+			continue;
 
-			esp_dev = SDptr->hostdata;
-			copy_info(&info, "%d\t\t", i);
-			copy_info(&info, "%08lx\t", esp->config3[i]);
-			copy_info(&info, "[%02lx,%02lx]\t\t\t", esp_dev->sync_max_offset,
-				  esp_dev->sync_min_period);
-			copy_info(&info, "%s\n", esp_dev->disconnect ? "yes" : "no");
-		}
+		copy_info(&info, "%d\t\t", id);
+		copy_info(&info, "%08lx\t", esp->config3[id]);
+		copy_info(&info, "[%02lx,%02lx]\t\t\t",
+			esp_dev->sync_max_offset,
+			esp_dev->sync_min_period);
+		copy_info(&info, "%s\n", esp_dev->disconnect ? "yes" : "no");
 	}
 
 	return info.pos > info.offset? info.pos - info.offset : 0;
===== drivers/scsi/constants.c 1.13 vs edited =====
--- 1.13/drivers/scsi/constants.c	Thu Oct 16 10:52:45 2003
+++ edited/drivers/scsi/constants.c	Mon Oct 27 12:01:49 2003
@@ -6,13 +6,13 @@
  *   by D. Gilbert and aeb (20020609)
  */
 
-#include <linux/module.h>
-
 #include <linux/config.h>
+#include <linux/module.h>
 #include <linux/blkdev.h>
 #include <linux/kernel.h>
+
+#include <scsi/scsi_host.h>
 #include "scsi.h"
-#include "hosts.h"
 
 #define CONST_COMMAND   0x01
 #define CONST_STATUS    0x02
--- 1.33/drivers/scsi/esp.c	Sun Aug  3 18:07:28 2003
+++ edited/drivers/scsi/esp.c	Mon Oct 27 12:01:49 2003
@@ -1309,6 +1309,7 @@
 
 static int esp_host_info(struct esp *esp, char *ptr, off_t offset, int len)
 {
+	struct scsi_device *sdev;
 	struct info_str info;
 	int i;
 
@@ -1384,25 +1385,23 @@
 	
 	/* Now describe the state of each existing target. */
 	copy_info(&info, "Target #\tconfig3\t\tSync Capabilities\tDisconnect\tWide\n");
-	for (i = 0; i < 15; i++) {
-		if (esp->targets_present & (1 << i)) {
-			Scsi_Device *SDptr;
-			struct esp_device *esp_dev;
 
-			list_for_each_entry(SDptr, &esp->ehost->my_devices,
-					siblings)
-				if(SDptr->id == i)
-					break;
+	shost_for_each_device(sdev, esp->ehost) {
+		struct esp_device *esp_dev = sdev->hostdata;
+		uint id = sdev->id;
+
+		if (!(esp->targets_present & (1 << id)))
+			continue;
 
-			esp_dev = SDptr->hostdata;
-			copy_info(&info, "%d\t\t", i);
-			copy_info(&info, "%08lx\t", esp->config3[i]);
-			copy_info(&info, "[%02lx,%02lx]\t\t\t", esp_dev->sync_max_offset,
-				  esp_dev->sync_min_period);
-			copy_info(&info, "%s\t\t", esp_dev->disconnect ? "yes" : "no");
-			copy_info(&info, "%s\n",
-				  (esp->config3[i] & ESP_CONFIG3_EWIDE) ? "yes" : "no");
-		}
+		copy_info(&info, "%d\t\t", id);
+		copy_info(&info, "%08lx\t", esp->config3[id]);
+		copy_info(&info, "[%02lx,%02lx]\t\t\t",
+			esp_dev->sync_max_offset,
+			esp_dev->sync_min_period);
+		copy_info(&info, "%s\t\t",
+			esp_dev->disconnect ? "yes" : "no");
+		copy_info(&info, "%s\n",
+			(esp->config3[id] & ESP_CONFIG3_EWIDE) ? "yes" : "no");
 	}
 	return info.pos > info.offset? info.pos - info.offset : 0;
 }
===== drivers/scsi/fcal.c 1.13 vs edited =====
--- 1.13/drivers/scsi/fcal.c	Sat Sep 20 16:06:41 2003
+++ edited/drivers/scsi/fcal.c	Mon Oct 27 12:01:49 2003
@@ -228,7 +228,7 @@
 #endif
 	SPRINTF ("Initiator AL-PA: %02x\n", fc->sid);
 
-	SPRINTF ("\nAttached devices: %s\n", !list_empty(&host->my_devices) ? "" : "none");
+	SPRINTF ("\nAttached devices:\n");
 	
 	for (i = 0; i < fc->posmap->len; i++) {
 		unsigned char alpa = fc->posmap->list[i];
===== drivers/scsi/hosts.c 1.94 vs edited =====
--- 1.94/drivers/scsi/hosts.c	Sun Sep 21 19:52:38 2003
+++ edited/drivers/scsi/hosts.c	Mon Oct 27 12:01:49 2003
@@ -1,6 +1,7 @@
 /*
  *  hosts.c Copyright (C) 1992 Drew Eckhardt
  *          Copyright (C) 1993, 1994, 1995 Eric Youngdale
+ *          Copyright (C) 2002-2003 Christoph Hellwig
  *
  *  mid to lowlevel SCSI driver interface
  *      Initial versions: Drew Eckhardt
@@ -30,8 +31,8 @@
 #include <linux/completion.h>
 #include <linux/unistd.h>
 
+#include <scsi/scsi_host.h>
 #include "scsi.h"
-#include "hosts.h"
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -50,6 +51,11 @@
 	.release	= scsi_host_cls_release,
 };
 
+static int scsi_device_cancel_cb(struct device *dev, void *data)
+{
+	return scsi_device_cancel(to_scsi_device(dev), *(int *)data);
+}
+
 /**
  * scsi_host_cancel - cancel outstanding IO to this host
  * @shost:	pointer to struct Scsi_Host
@@ -57,11 +63,7 @@
  **/
 void scsi_host_cancel(struct Scsi_Host *shost, int recovery)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(shost->host_lock, flags);
 	set_bit(SHOST_CANCEL, &shost->shost_state);
-	spin_unlock_irqrestore(shost->host_lock, flags);
 	device_for_each_child(&shost->shost_gendev, &recovery,
 			      scsi_device_cancel_cb);
 	wait_event(shost->host_wait, (!test_bit(SHOST_RECOVERY,
@@ -74,15 +76,11 @@
  **/
 void scsi_remove_host(struct Scsi_Host *shost)
 {
-	unsigned long flags;
-
 	scsi_host_cancel(shost, 0);
 	scsi_proc_host_rm(shost);
 	scsi_forget_host(shost);
 
-	spin_lock_irqsave(shost->host_lock, flags);
 	set_bit(SHOST_DEL, &shost->shost_state);
-	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	class_device_unregister(&shost->shost_classdev);
 	device_del(&shost->shost_gendev);
@@ -209,7 +207,7 @@
 
 	spin_lock_init(&shost->default_lock);
 	scsi_assign_lock(shost, &shost->default_lock);
-	INIT_LIST_HEAD(&shost->my_devices);
+	INIT_LIST_HEAD(&shost->__devices);
 	INIT_LIST_HEAD(&shost->eh_cmd_q);
 	INIT_LIST_HEAD(&shost->starved_list);
 	init_waitqueue_head(&shost->host_wait);
@@ -323,23 +321,20 @@
  **/
 struct Scsi_Host *scsi_host_lookup(unsigned short hostnum)
 {
-	struct class *class = class_get(&shost_class);
+	struct class *class = &shost_class;
 	struct class_device *cdev;
 	struct Scsi_Host *shost = ERR_PTR(-ENXIO), *p;
 
-	if (class) {
-		down_read(&class->subsys.rwsem);
-		list_for_each_entry(cdev, &class->children, node) {
-			p = class_to_shost(cdev);
-			if (p->host_no == hostnum) {
-				shost = scsi_host_get(p);
-				break;
-			}
+	down_read(&class->subsys.rwsem);
+	list_for_each_entry(cdev, &class->children, node) {
+		p = class_to_shost(cdev);
+		if (p->host_no == hostnum) {
+			shost = scsi_host_get(p);
+			break;
 		}
-		up_read(&class->subsys.rwsem);
 	}
+	up_read(&class->subsys.rwsem);
 
-	class_put(&shost_class);
 	return shost;
 }
 
===== drivers/scsi/hosts.h 1.75 vs edited =====
--- 1.75/drivers/scsi/hosts.h	Mon Sep  1 22:56:57 2003
+++ edited/drivers/scsi/hosts.h	Mon Oct 27 12:01:49 2003
@@ -1,49 +1,2 @@
-/*
- *  hosts.h Copyright (C) 1992 Drew Eckhardt
- *          Copyright (C) 1993, 1994, 1995, 1998, 1999 Eric Youngdale
- *
- *  mid to low-level SCSI driver interface header
- *      Initial versions: Drew Eckhardt
- *      Subsequent revisions: Eric Youngdale
- *
- *  <drew@colorado.edu>
- *
- *	 Modified by Eric Youngdale eric@andante.org to
- *	 add scatter-gather, multiple outstanding request, and other
- *	 enhancements.
- *
- *  Further modified by Eric Youngdale to support multiple host adapters
- *  of the same type.
- *
- *  Jiffies wrap fixes (host->resetting), 3 Dec 1998 Andrea Arcangeli
- *
- *  Restructured scsi_host lists and associated functions.
- *  September 04, 2002 Mike Anderson (andmike@us.ibm.com)
- */
-
-#ifndef _HOSTS_H
-#define _HOSTS_H
-
-#include <linux/config.h>
-
+// #warning "This file is obsolete, please use <scsi/scsi_host.h> instead"
 #include <scsi/scsi_host.h>
-
-/**
- * scsi_find_device - find a device given the host
- * @shost:	SCSI host pointer
- * @channel:	SCSI channel (zero if only one channel)
- * @pun:	SCSI target number (physical unit number)
- * @lun:	SCSI Logical Unit Number
- **/
-static inline struct scsi_device *scsi_find_device(struct Scsi_Host *shost,
-                                            int channel, int pun, int lun) {
-        struct scsi_device *sdev;
-
-	list_for_each_entry (sdev, &shost->my_devices, siblings)
-                if (sdev->channel == channel && sdev->id == pun
-                   && sdev->lun ==lun)
-                        return sdev;
-        return NULL;
-}
-
-#endif
--- 1.129/drivers/scsi/scsi.c	Sat Oct 18 01:14:06 2003
+++ edited/drivers/scsi/scsi.c	Mon Oct 27 12:01:49 2003
@@ -1,6 +1,7 @@
 /*
  *  scsi.c Copyright (C) 1992 Drew Eckhardt
  *         Copyright (C) 1993, 1994, 1995, 1999 Eric Youngdale
+ *         Copyright (C) 2002, 2003 Christoph Hellwig
  *
  *  generic mid-level SCSI driver
  *      Initial versions: Drew Eckhardt
@@ -36,7 +37,6 @@
  *  out_of_space hacks, D. Gilbert (dpg) 990608
  */
 
-#include <linux/config.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
@@ -54,8 +54,8 @@
 #include <linux/kmod.h>
 #include <linux/interrupt.h>
 
+#include <scsi/scsi_host.h>
 #include "scsi.h"
-#include "hosts.h"
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -883,49 +883,124 @@
 	return depth;
 }
 
+/**
+ * scsi_device_get  -  get an addition reference to a scsi_device
+ * @sdev:	device to get a reference to
+ *
+ * Gets a reference to the scsi_device and increments the use count
+ * of the underlying LLDD module.  You must hold host_lock of the
+ * parent Scsi_Host or already have a reference when calling this.
+ */
 int scsi_device_get(struct scsi_device *sdev)
 {
-	struct class *class = class_get(&sdev_class);
-
-	if (!class)
-		goto out;
 	if (test_bit(SDEV_DEL, &sdev->sdev_state))
-		goto out;
-	if (!try_module_get(sdev->host->hostt->module))
-		goto out;
+		return -ENXIO;
 	if (!get_device(&sdev->sdev_gendev))
-		goto out_put_module;
-	atomic_inc(&sdev->access_count);
-	class_put(&sdev_class);
+		return -ENXIO;
+	if (!try_module_get(sdev->host->hostt->module)) {
+		put_device(&sdev->sdev_gendev);
+		return -ENXIO;
+	}
 	return 0;
+}
+EXPORT_SYMBOL(scsi_device_get);
 
- out_put_module:
+/**
+ * scsi_device_put  -  release a reference to a scsi_device
+ * @sdev:	device to release a reference on.
+ *
+ * Release a reference to the scsi_device and decrements the use count
+ * of the underlying LLDD module.  The device is freed once the last
+ * user vanishes.
+ */
+void scsi_device_put(struct scsi_device *sdev)
+{
 	module_put(sdev->host->hostt->module);
- out:
-	class_put(&sdev_class);
-	return -ENXIO;
+	put_device(&sdev->sdev_gendev);
 }
+EXPORT_SYMBOL(scsi_device_put);
 
-void scsi_device_put(struct scsi_device *sdev)
+/* helper for shost_for_each_device, thus not documented */
+struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *shost,
+					   struct scsi_device *prev)
 {
-	struct class *class = class_get(&sdev_class);
+	struct list_head *list = (prev ? &prev->siblings : &shost->__devices);
+	struct scsi_device *next = NULL;
+	unsigned long flags;
 
-	if (!class)
-		return;
+	spin_lock_irqsave(shost->host_lock, flags);
+	while (list->next != &shost->__devices) {
+		next = list_entry(list->next, struct scsi_device, siblings);
+		/* skip devices that we can't get a reference to */
+		if (!scsi_device_get(next))
+			break;
+		list = list->next;
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	module_put(sdev->host->hostt->module);
-	atomic_dec(&sdev->access_count);
-	put_device(&sdev->sdev_gendev);
-	class_put(&sdev_class);
+	if (prev)
+		scsi_device_put(prev);
+	return next;
 }
+EXPORT_SYMBOL(__scsi_iterate_devices);
 
-int scsi_device_cancel_cb(struct device *dev, void *data)
+/**
+ * scsi_device_lookup - find a device given the host (UNLOCKED)
+ * @shost:	SCSI host pointer
+ * @channel:	SCSI channel (zero if only one channel)
+ * @pun:	SCSI target number (physical unit number)
+ * @lun:	SCSI Logical Unit Number
+ *
+ * Looks up the scsi_device with the specified @channel, @id, @lun for a
+ * give host. The returned scsi_device does not have an additional reference.
+ * You must hold the host's host_lock over this call and any access to the
+ * returned scsi_device.
+ *
+ * Note:  The only reason why drivers would want to use this is because
+ * they're need to access the device list in irq context.  Otherwise you
+ * really want to use scsi_device_lookup instead.
+ **/
+struct scsi_device *__scsi_device_lookup(struct Scsi_Host *shost,
+		uint channel, uint id, uint lun)
+{
+	struct scsi_device *sdev;
+
+	list_for_each_entry(sdev, &shost->__devices, siblings) {
+		if (sdev->channel == channel && sdev->id == id &&
+				sdev->lun ==lun)
+			return sdev;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(__scsi_device_lookup);
+
+/**
+ * scsi_device_lookup - find a device given the host
+ * @shost:	SCSI host pointer
+ * @channel:	SCSI channel (zero if only one channel)
+ * @id:		SCSI target number (physical unit number)
+ * @lun:	SCSI Logical Unit Number
+ *
+ * Looks up the scsi_device with the specified @channel, @id, @lun for a
+ * give host.  The returned scsi_device has an additional reference that
+ * needs to be release with scsi_host_put once you're done with it.
+ **/
+struct scsi_device *scsi_device_lookup(struct Scsi_Host *shost,
+		uint channel, uint id, uint lun)
 {
-	struct scsi_device *sdev = to_scsi_device(dev);
-	int recovery = *(int *)data;
+	struct scsi_device *sdev;
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	sdev = __scsi_device_lookup(shost, channel, id, lun);
+	if (sdev && scsi_device_get(sdev))
+		sdev = NULL;
+	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	return scsi_device_cancel(sdev, recovery);
+	return sdev;
 }
+EXPORT_SYMBOL(scsi_device_lookup);
 
 /**
  * scsi_device_cancel - cancel outstanding IO to this device
===== drivers/scsi/scsi.h 1.91 vs edited =====
--- 1.91/drivers/scsi/scsi.h	Sat Sep 20 13:50:50 2003
+++ edited/drivers/scsi/scsi.h	Mon Oct 27 12:01:41 2003
@@ -116,12 +116,6 @@
 #define scsi_to_pci_dma_dir(scsi_dir)	((int)(scsi_dir))
 #define scsi_to_sbus_dma_dir(scsi_dir)	((int)(scsi_dir))
 
-/*
- * This is the crap from the old error handling code.  We have it in a special
- * place so that we can more easily delete it later on.
- */
-#include "scsi_obsolete.h"
-
 /* obsolete typedef junk. */
 #include "scsi_typedefs.h"
 
--- 1.7/drivers/scsi/scsi_devinfo.c	Thu Oct 16 10:56:58 2003
+++ edited/drivers/scsi/scsi_devinfo.c	Mon Oct 27 12:01:49 2003
@@ -6,10 +6,11 @@
 #include <linux/moduleparam.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
-#include <scsi/scsi_devinfo.h>
 
+#include <scsi/scsi_devinfo.h>
+#include <scsi/scsi_host.h>
 #include "scsi.h"
-#include "hosts.h"
+
 #include "scsi_priv.h"
 
 /*
===== drivers/scsi/scsi_error.c 1.65 vs edited =====
--- 1.65/drivers/scsi/scsi_error.c	Sun Sep 21 19:49:36 2003
+++ edited/drivers/scsi/scsi_error.c	Mon Oct 27 12:01:49 2003
@@ -22,11 +22,10 @@
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
-#include <linux/smp_lock.h>
-#include <scsi/scsi_ioctl.h>
 
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_ioctl.h>
 #include "scsi.h"
-#include "hosts.h"
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
===== drivers/scsi/scsi_ioctl.c 1.24 vs edited =====
--- 1.24/drivers/scsi/scsi_ioctl.c	Mon Aug 25 15:37:40 2003
+++ edited/drivers/scsi/scsi_ioctl.c	Mon Oct 27 12:01:49 2003
@@ -17,11 +17,11 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/string.h>
-
 #include <linux/blkdev.h>
-#include "scsi.h"
-#include "hosts.h"
+
+#include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
+#include "scsi.h"
 
 #include "scsi_logging.h"
 
===== drivers/scsi/scsi_lib.c 1.113 vs edited =====
--- 1.113/drivers/scsi/scsi_lib.c	Sat Sep 20 15:53:02 2003
+++ edited/drivers/scsi/scsi_lib.c	Mon Oct 27 12:01:52 2003
@@ -16,9 +16,9 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 
-#include "scsi.h"
-#include "hosts.h"
 #include <scsi/scsi_driver.h>
+#include <scsi/scsi_host.h>
+#include "scsi.h"
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -335,13 +335,14 @@
  */
 static void scsi_single_lun_run(struct scsi_device *current_sdev)
 {
-	struct scsi_device *sdev;
+	struct Scsi_Host *shost = current_sdev->host;
+	struct scsi_device *sdev, *tmp;
 	unsigned long flags;
 
-	spin_lock_irqsave(current_sdev->host->host_lock, flags);
+	spin_lock_irqsave(shost->host_lock, flags);
 	WARN_ON(!current_sdev->sdev_target->starget_sdev_user);
 	current_sdev->sdev_target->starget_sdev_user = NULL;
-	spin_unlock_irqrestore(current_sdev->host->host_lock, flags);
+	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	/*
 	 * Call blk_run_queue for all LUNs on the target, starting with
@@ -351,21 +352,26 @@
 	 */
 	blk_run_queue(current_sdev->request_queue);
 
-	spin_lock_irqsave(current_sdev->host->host_lock, flags);
-	if (current_sdev->sdev_target->starget_sdev_user) {
-		/*
-		 * After unlock, this races with anyone clearing
-		 * starget_sdev_user, but we (should) always enter this
-		 * function again, avoiding any problems.
-		 */
-		spin_unlock_irqrestore(current_sdev->host->host_lock, flags);
-		return;
-	}
-	spin_unlock_irqrestore(current_sdev->host->host_lock, flags);
+	/*
+	 * After unlock, this races with anyone clearing starget_sdev_user,
+	 * but we always enter this function again, avoiding any problems.
+	 */
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (current_sdev->sdev_target->starget_sdev_user)
+		goto out;
+	list_for_each_entry_safe(sdev, tmp, &current_sdev->same_target_siblings,
+			same_target_siblings) {
+		if (scsi_device_get(sdev))
+			continue;
 
-	list_for_each_entry(sdev, &current_sdev->same_target_siblings,
-			    same_target_siblings)
+		spin_unlock_irqrestore(shost->host_lock, flags);
 		blk_run_queue(sdev->request_queue);
+		spin_lock_irqsave(shost->host_lock, flags);
+	
+		scsi_device_put(sdev);
+	}
+ out:
+	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
 /*
===== drivers/scsi/scsi_module.c 1.6 vs edited =====
--- 1.6/drivers/scsi/scsi_module.c	Thu Jul 31 16:32:16 2003
+++ edited/drivers/scsi/scsi_module.c	Mon Oct 27 12:01:50 2003
@@ -11,8 +11,8 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
+#include <scsi/scsi_host.h>
 #include "scsi.h"
-#include "hosts.h"
 
 
 static int __init init_this_scsi_driver(void)
--- 1.4/drivers/scsi/scsi_pc98.c	Fri May  2 21:28:28 2003
+++ edited/drivers/scsi/scsi_pc98.c	Mon Oct 27 12:01:50 2003
@@ -11,8 +11,8 @@
 #include <linux/blkdev.h>
 #include <asm/pc9800.h>
 
+#include <scsi/scsi_host.h>
 #include "scsi.h"
-#include "hosts.h"
 
 
 static int pc98_first_bios_param(struct scsi_device *sdev, int *ip)
--- 1.38/drivers/scsi/scsi_proc.c	Sat Sep 20 11:35:07 2003
+++ edited/drivers/scsi/scsi_proc.c	Mon Oct 27 12:01:50 2003
@@ -27,8 +27,8 @@
 #include <linux/seq_file.h>
 #include <asm/uaccess.h>
 
+#include <scsi/scsi_host.h>
 #include "scsi.h"
-#include "hosts.h"
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -212,15 +212,13 @@
 	shost = scsi_host_lookup(host);
 	if (IS_ERR(shost))
 		return PTR_ERR(shost);
-	sdev = scsi_find_device(shost, channel, id, lun);
-	if (!sdev)
-		goto out;
-	if (atomic_read(&sdev->access_count))
-		goto out;
+	sdev = scsi_device_lookup(shost, channel, id, lun);
+	if (sdev) {
+		scsi_remove_device(sdev);
+		scsi_device_put(sdev);
+		error = 0;
+	}
 
-	scsi_remove_device(sdev);
-	error = 0;
-out:
 	scsi_host_put(shost);
 	return error;
 }
===== drivers/scsi/scsi_scan.c 1.109 vs edited =====
--- 1.109/drivers/scsi/scsi_scan.c	Thu Oct 16 10:56:58 2003
+++ edited/drivers/scsi/scsi_scan.c	Mon Oct 27 12:01:50 2003
@@ -32,10 +32,10 @@
 #include <linux/blkdev.h>
 #include <asm/semaphore.h>
 
-#include "scsi.h"
-#include "hosts.h"
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_devinfo.h>
+#include <scsi/scsi_host.h>
+#include "scsi.h"
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -190,13 +190,13 @@
 	       	uint channel, uint id, uint lun)
 {
 	struct scsi_device *sdev, *device;
+	unsigned long flags;
 
 	sdev = kmalloc(sizeof(*sdev), GFP_ATOMIC);
 	if (!sdev)
 		goto out;
 
 	memset(sdev, 0, sizeof(*sdev));
-	atomic_set(&sdev->access_count, 0);
 	sdev->vendor = scsi_null_device_strs;
 	sdev->model = scsi_null_device_strs;
 	sdev->rev = scsi_null_device_strs;
@@ -240,7 +240,8 @@
 	 * If there are any same target siblings, add this to the
 	 * sibling list
 	 */
-	list_for_each_entry(device, &shost->my_devices, siblings) {
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_for_each_entry(device, &shost->__devices, siblings) {
 		if (device->id == sdev->id &&
 		    device->channel == sdev->channel) {
 			list_add_tail(&sdev->same_target_siblings,
@@ -258,10 +259,8 @@
 	if (!sdev->scsi_level)
 		sdev->scsi_level = SCSI_2;
 
-	/*
-	 * Add it to the end of the shost->my_devices list.
-	 */
-	list_add_tail(&sdev->siblings, &shost->my_devices);
+	list_add_tail(&sdev->siblings, &shost->__devices);
+	spin_unlock_irqrestore(shost->host_lock, flags);
 	return sdev;
 
 out_free_queue:
@@ -285,21 +284,21 @@
 {
 	unsigned long flags;
 
+	spin_lock_irqsave(sdev->host->host_lock, flags);
 	list_del(&sdev->siblings);
 	list_del(&sdev->same_target_siblings);
+	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
 	if (sdev->request_queue)
 		scsi_free_queue(sdev->request_queue);
-	if (sdev->inquiry)
-		kfree(sdev->inquiry);
+
 	spin_lock_irqsave(sdev->host->host_lock, flags);
 	list_del(&sdev->starved_entry);
-	if (sdev->single_lun) {
-		if (--sdev->sdev_target->starget_refcnt == 0)
-			kfree(sdev->sdev_target);
-	}
+	if (sdev->single_lun && --sdev->sdev_target->starget_refcnt == 0)
+		kfree(sdev->sdev_target);
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
+	kfree(sdev->inquiry);
 	kfree(sdev);
 }
 
@@ -678,7 +677,7 @@
 	 * host adapter calls into here with rescan == 0.
 	 */
 	if (rescan) {
-		sdev = scsi_find_device(host, channel, id, lun);
+		sdev = scsi_device_lookup(host, channel, id, lun);
 		if (sdev) {
 			SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
 				"scsi scan: device exists on <%d:%d:%d:%d>\n",
@@ -689,6 +688,8 @@
 				*bflagsp = scsi_get_device_flags(sdev,
 								 sdev->vendor,
 								 sdev->model);
+			/* XXX: bandaid until callers do refcounting */
+			scsi_device_put(sdev);
 			return SCSI_SCAN_LUN_PRESENT;
 		}
 	}
@@ -1232,14 +1233,25 @@
 
 void scsi_forget_host(struct Scsi_Host *shost)
 {
-	struct list_head *le, *lh;
-	struct scsi_device *sdev;
+	struct scsi_device *sdev, *tmp;
+	unsigned long flags;
 
-	list_for_each_safe(le, lh, &shost->my_devices) {
-		sdev = list_entry(le, struct scsi_device, siblings);
-		
+	/*
+	 * Ok, this look a bit strange.  We always look for the first device
+	 * on the list as scsi_remove_device removes them from it - thus we
+	 * also have to release the lock.
+	 * We don't need to get another reference to the device before
+	 * releasing the lock as we already own the reference from
+	 * scsi_register_device that's release in scsi_remove_device.  And
+	 * after that we don't look at sdev anymore.
+	 */
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_for_each_entry_safe(sdev, tmp, &shost->__devices, siblings) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
 		scsi_remove_device(sdev);
+		spin_lock_irqsave(shost->host_lock, flags);
 	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
 /*
===== drivers/scsi/scsi_syms.c 1.45 vs edited =====
--- 1.45/drivers/scsi/scsi_syms.c	Thu Jul 31 16:32:18 2003
+++ edited/drivers/scsi/scsi_syms.c	Mon Oct 27 12:01:50 2003
@@ -18,13 +18,14 @@
 #include <asm/irq.h>
 #include <asm/dma.h>
 
-#include "scsi.h"
 #include <scsi/scsi_driver.h>
+#include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
-#include "hosts.h"
+#include <scsi/scsicam.h>
+#include "scsi.h"
+
 #include "scsi_logging.h"
 
-#include <scsi/scsicam.h>
 
 /*
  * This source file contains the symbol table used by scsi loadable
@@ -82,8 +83,6 @@
 
 EXPORT_SYMBOL(scsi_io_completion);
 
-EXPORT_SYMBOL(scsi_device_get);
-EXPORT_SYMBOL(scsi_device_put);
 EXPORT_SYMBOL(scsi_add_device);
 EXPORT_SYMBOL(scsi_remove_device);
 EXPORT_SYMBOL(scsi_device_cancel);
===== drivers/scsi/scsi_sysfs.c 1.35 vs edited =====
--- 1.35/drivers/scsi/scsi_sysfs.c	Sat Oct 18 01:34:55 2003
+++ edited/drivers/scsi/scsi_sysfs.c	Mon Oct 27 12:01:50 2003
@@ -11,8 +11,9 @@
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/device.h>
+
+#include <scsi/scsi_host.h>
 #include "scsi.h"
-#include "hosts.h"
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -257,20 +258,12 @@
 	scsi_rescan_device(dev);
 	return count;
 }
-
 static DEVICE_ATTR(rescan, S_IWUSR, NULL, store_rescan_field)
 
 static ssize_t sdev_store_delete(struct device *dev, const char *buf,
 				 size_t count)
 {
-	struct scsi_device *sdev = to_scsi_device(dev);
-
-	/*
-	 * FIXME and scsi_proc.c: racey use of access_count,
-	 */
-	if (atomic_read(&sdev->access_count))
-		return -EBUSY;
-	scsi_remove_device(sdev);
+	scsi_remove_device(to_scsi_device(dev));
 	return count;
 };
 static DEVICE_ATTR(delete, S_IWUSR, NULL, sdev_store_delete);
@@ -403,22 +396,11 @@
  **/
 void scsi_remove_device(struct scsi_device *sdev)
 {
-	struct class *class = class_get(&sdev_class);
-
 	class_device_unregister(&sdev->sdev_classdev);
-
-	if (class) {
-		down_write(&class->subsys.rwsem);
-		set_bit(SDEV_DEL, &sdev->sdev_state);
-		if (sdev->host->hostt->slave_destroy)
-			sdev->host->hostt->slave_destroy(sdev);
-		device_del(&sdev->sdev_gendev);
-		up_write(&class->subsys.rwsem);
-	}
-
+	if (sdev->host->hostt->slave_destroy)
+		sdev->host->hostt->slave_destroy(sdev);
+	device_del(&sdev->sdev_gendev);
 	put_device(&sdev->sdev_gendev);
-
-	class_put(&sdev_class);
 }
 
 int scsi_register_driver(struct device_driver *drv)
===== drivers/scsi/sg.c 1.70 vs edited =====
--- 1.70/drivers/scsi/sg.c	Tue Oct 21 00:15:18 2003
+++ edited/drivers/scsi/sg.c	Mon Oct 27 12:01:50 2003
@@ -914,7 +914,8 @@
 	case SG_GET_VERSION_NUM:
 		return put_user(sg_version_num, (int *) arg);
 	case SG_GET_ACCESS_COUNT:
-		val = (sdp->device ? atomic_read(&sdp->device->access_count) : 0);
+		/* faked - we don't have a real access count anymore */
+		val = (sdp->device ? 1 : 0);
 		return put_user(val, (int *) arg);
 	case SG_GET_REQUEST_TABLE:
 		result = verify_area(VERIFY_WRITE, (void *) arg,
@@ -2903,7 +2904,7 @@
 			PRINT_PROC("%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n",
 				   scsidp->host->host_no, scsidp->channel,
 				   scsidp->id, scsidp->lun, (int) scsidp->type,
-				   (int) atomic_read(&scsidp->access_count),
+				   1,
 				   (int) scsidp->queue_depth,
 				   (int) scsidp->device_busy,
 				   (int) scsidp->online);
===== drivers/scsi/arm/acornscsi.c 1.35 vs edited =====
--- 1.35/drivers/scsi/arm/acornscsi.c	Mon Aug 25 15:37:34 2003
+++ edited/drivers/scsi/arm/acornscsi.c	Mon Oct 27 12:01:49 2003
@@ -2930,7 +2930,7 @@
 
     p += sprintf(p, "\nAttached devices:\n");
 
-    list_for_each_entry(scd, &instance->my_devices, siblings) {
+    shost_for_each_device(scd, instance) {
 	p += sprintf(p, "Device/Lun TaggedQ      Sync\n");
 	p += sprintf(p, "     %d/%d   ", scd->id, scd->lun);
 	if (scd->tagged_supported)
@@ -2953,8 +2953,10 @@
 	    p = buffer;
 	}
 	pos = p - buffer;
-	if (pos + begin > offset + length)
+	if (pos + begin > offset + length) {
+	    scsi_device_put(scd);
 	    break;
+	}
     }
 
     pos = p - buffer;
--- 1.9/include/scsi/scsi_device.h	Thu Oct 16 10:56:58 2003
+++ edited/include/scsi/scsi_device.h	Mon Oct 27 12:01:52 2003
@@ -22,10 +22,13 @@
 };
 
 struct scsi_device {
-	struct list_head    siblings;   /* list of all devices on this host */
-	struct list_head    same_target_siblings; /* just the devices sharing same target id */
 	struct Scsi_Host *host;
 	struct request_queue *request_queue;
+
+	/* the next two are protected by the host->host_lock */
+	struct list_head    siblings;   /* list of all devices on this host */
+	struct list_head    same_target_siblings; /* just the devices sharing same target id */
+
 	volatile unsigned short device_busy;	/* commands actually active on low-level */
 	spinlock_t sdev_lock;           /* also the request queue_lock */
 	spinlock_t list_lock;
@@ -45,8 +48,6 @@
 					 * vendor-specific cmd's */
 	unsigned sector_size;	/* size in bytes */
 
-	atomic_t access_count;	/* Count of open channels/mounts */
-
 	void *hostdata;		/* available to low-level driver */
 	char devfs_name[256];	/* devfs junk */
 	char type;
@@ -108,14 +109,48 @@
 extern struct scsi_device *scsi_add_device(struct Scsi_Host *,
 		uint, uint, uint);
 extern void scsi_remove_device(struct scsi_device *);
-extern int scsi_device_cancel_cb(struct device *, void *);
 extern int scsi_device_cancel(struct scsi_device *, int);
 
 extern int scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
-
+extern struct scsi_device *scsi_device_lookup(struct Scsi_Host *,
+					      uint, uint, uint);
+extern struct scsi_device *__scsi_device_lookup(struct Scsi_Host *,
+						uint, uint, uint);
+
+/* only exposed to implement shost_for_each_device */
+extern struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *,
+						  struct scsi_device *);
+
+/**
+ * shost_for_each_device  -  iterate over all devices of a host
+ * @sdev:	iterator
+ * @host:	host whiches devices we want to iterate over
+ *
+ * This traverses over each devices of @shost.  The devices have
+ * a reference that must be released by scsi_host_put when breaking
+ * out of the loop.
+ */
 #define shost_for_each_device(sdev, shost) \
-	list_for_each_entry((sdev), &((shost)->my_devices), siblings)
+	for ((sdev) = __scsi_iterate_devices((shost), NULL); \
+	     (sdev); \
+	     (sdev) = __scsi_iterate_devices((shost), (sdev)))
+
+/**
+ * __shost_for_each_device  -  iterate over all devices of a host (UNLOCKED)
+ * @sdev:	iterator
+ * @host:	host whiches devices we want to iterate over
+ *
+ * This traverses over each devices of @shost.  It does _not_ take a
+ * reference on the scsi_device, thus it the whole loop must be protected
+ * by shost->host_lock.
+ *
+ * Note:  The only reason why drivers would want to use this is because
+ * they're need to access the device list in irq context.  Otherwise you
+ * really want to use shost_for_each_device instead.
+ */
+#define __shost_for_each_device(sdev, shost) \
+	list_for_each_entry((sdev), &((shost)->__devices), siblings)
 
 extern void scsi_adjust_queue_depth(struct scsi_device *, int, int);
 extern int scsi_track_queue_full(struct scsi_device *, int);
===== include/scsi/scsi_driver.h 1.1 vs edited =====
--- 1.1/include/scsi/scsi_driver.h	Thu Jun 26 19:08:24 2003
+++ edited/include/scsi/scsi_driver.h	Mon Oct 27 12:01:50 2003
@@ -4,6 +4,7 @@
 #include <linux/device.h>
 
 struct module;
+struct scsi_cmnd;
 
 
 struct scsi_driver {
===== include/scsi/scsi_host.h 1.12 vs edited =====
--- 1.12/include/scsi/scsi_host.h	Thu Oct 16 10:56:58 2003
+++ edited/include/scsi/scsi_host.h	Mon Oct 27 12:01:50 2003
@@ -125,15 +125,6 @@
 	int (* eh_host_reset_handler)(struct scsi_cmnd *);
 
 	/*
-	 * Old EH handlers, no longer used. Make them warn the user of old
-	 * drivers by using a wrong type
-	 *
-	 * Status: MORE THAN OBSOLETE
-	 */
-	int (* abort)(int);
-	int (* reset)(int, int);
-
-	/*
 	 * Before the mid layer attempts to scan for a new device where none
 	 * currently exists, it will call this entry in your driver.  Should
 	 * your driver need to allocate any structs or perform any other init
@@ -363,19 +354,30 @@
 };
 
 struct Scsi_Host {
-	struct list_head	my_devices;
+	/*
+	 * __devices is protected by the host_lock, but you should
+	 * usually use scsi_device_lookup / shost_for_each_device
+	 * to access it and don't care about locking yourself.
+	 * In the rare case of beeing in irq context you can use
+	 * their __ prefixed variants with the lock held. NEVER
+	 * access this list directly from a driver.
+	 */
+	struct list_head	__devices;
+	
 	struct scsi_host_cmd_pool *cmd_pool;
 	spinlock_t		free_list_lock;
-	struct list_head	free_list;   /* backup store of cmd structs */
+	struct list_head	free_list; /* backup store of cmd structs */
 	struct list_head	starved_list;
 
 	spinlock_t		default_lock;
 	spinlock_t		*host_lock;
 
+	struct semaphore	scan_mutex;/* serialize scanning activity */
+
 	struct list_head	eh_cmd_q;
 	struct task_struct    * ehandler;  /* Error recovery thread. */
-	struct semaphore      * eh_wait;   /* The error recovery thread waits on
-                                          this. */
+	struct semaphore      * eh_wait;   /* The error recovery thread waits
+					      on this. */
 	struct completion     * eh_notify; /* wait for eh to begin or end */
 	struct semaphore      * eh_action; /* Wait for specific actions on the
                                           host. */
@@ -477,12 +479,6 @@
 	 * module_init/module_exit.
 	 */
 	struct list_head sht_legacy_list;
-
-	/*
-	 * This mutex serializes all scsi scanning activity from kernel- and
-	 * userspace.
-	 */
-	struct semaphore scan_mutex;
 
 	/*
 	 * We should ensure that this is aligned, both for better performance
