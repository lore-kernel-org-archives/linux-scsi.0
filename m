From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] first batch of shost sysfs fixes
Date: Wed, 7 May 2003 15:03:30 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030507150329.D10284@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:39940 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S263161AbTEGMvF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 May 2003 08:51:05 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, andmike@us.ibm.com
Cc: linux-scsi@vger.kernel.org

(a) scsi_check_device_busy() is unused now, kill it.  Btw, although I
    love to see this this really means we need to imply a
    scsi_set_device_offline (or even better scsi_set_host_offline)
    in scsi_remove_host now..
(b) make shost_class static to scsi_sysfs.c, with the new device model
    changes no LLDD needs this anymore
(c) move private prototypes where they belong.

BTW, Mike, did I miss something or will your changes make every driver
converted to scsi_add_host & co OOPS on removal now?  


--- 1.60/drivers/scsi/hosts.c	Thu May  1 20:10:59 2003
+++ edited/drivers/scsi/hosts.c	Wed May  7 14:40:26 2003
@@ -193,52 +193,6 @@
 	return 0;
 }
 
-static int scsi_check_device_busy(struct scsi_device *sdev)
-{
-	struct Scsi_Host *shost = sdev->host;
-	struct scsi_cmnd *scmd;
-	unsigned long flags;
-
-	/*
-	 * Loop over all of the commands associated with the
-	 * device.  If any of them are busy, then set the state
-	 * back to inactive and bail.
-	 */
-	spin_lock_irqsave(&sdev->list_lock, flags);
-	list_for_each_entry(scmd, &sdev->cmd_list, list) {
-		if (scmd->request && scmd->request->rq_status != RQ_INACTIVE)
-			goto active;
-
-		/*
-		 * No, this device is really free.  Mark it as such, and
-		 * continue on.
-		 */
-		scmd->state = SCSI_STATE_DISCONNECTING;
-		if (scmd->request)
-			scmd->request->rq_status = RQ_SCSI_DISCONNECTING;
-	}
-	spin_unlock_irqrestore(&sdev->list_lock, flags);
-
-	return 0;
-
-active:
-	printk(KERN_ERR "SCSI device not inactive - rq_status=%d, target=%d, "
-			"pid=%ld, state=%d, owner=%d.\n",
-			scmd->request->rq_status, scmd->device->id,
-			scmd->pid, scmd->state, scmd->owner);
-
-	list_for_each_entry(sdev, &shost->my_devices, siblings) {
-		list_for_each_entry(scmd, &sdev->cmd_list, list) {
-			if (scmd->request->rq_status == RQ_SCSI_DISCONNECTING)
-				scmd->request->rq_status = RQ_INACTIVE;
-		}
-	}
-
-	spin_unlock_irqrestore(&sdev->list_lock, flags);
-	printk(KERN_ERR "Device busy???\n");
-	return 1;
-}
-
 /**
  * scsi_remove_host - check a scsi host for release and release
  * @shost:	a pointer to a scsi host to release
--- 1.61/drivers/scsi/hosts.h	Thu May  1 20:17:11 2003
+++ edited/drivers/scsi/hosts.h	Wed May  7 14:25:40 2003
@@ -590,16 +590,4 @@
         return NULL;
 }
 
-/*
- * sysfs support
- */
-extern int scsi_upper_driver_register(struct Scsi_Device_Template *);
-extern void scsi_upper_driver_unregister(struct Scsi_Device_Template *);
-extern int scsi_sysfs_add_host(struct Scsi_Host *, struct device *);
-extern void scsi_sysfs_remove_host(struct Scsi_Host *);
-
-extern void scsi_free_sdev(struct scsi_device *);
-
-extern struct class shost_class;
-
 #endif
--- 1.1/drivers/scsi/scsi_priv.h	Sun Apr 27 02:40:32 2003
+++ edited/drivers/scsi/scsi_priv.h	Wed May  7 14:25:01 2003
@@ -107,15 +108,17 @@
 /* scsi_scan.c */
 extern void scsi_scan_host(struct Scsi_Host *shost);
 extern void scsi_forget_host(struct Scsi_Host *shost);
+extern void scsi_free_sdev(struct scsi_device *);
 
 /* scsi_sysfs.c */
 extern int scsi_device_register(struct scsi_device *);
 extern void scsi_device_unregister(struct scsi_device *);
 extern int scsi_upper_driver_register(struct Scsi_Device_Template *);
 extern void scsi_upper_driver_unregister(struct Scsi_Device_Template *);
+extern int scsi_sysfs_add_host(struct Scsi_Host *, struct device *);
+extern void scsi_sysfs_remove_host(struct Scsi_Host *);
 extern int scsi_sysfs_register(void);
 extern void scsi_sysfs_unregister(void);
-
 
 /*
  * dev_info: for the black/white list in the old scsi_static_device_list
--- 1.33/drivers/scsi/scsi_syms.c	Thu May  1 18:44:51 2003
+++ edited/drivers/scsi/scsi_syms.c	Wed May  7 14:24:01 2003
@@ -107,8 +105,3 @@
  */
 EXPORT_SYMBOL(scsi_add_timer);
 EXPORT_SYMBOL(scsi_delete_timer);
-
-/*
- * sysfs support
- */
-EXPORT_SYMBOL(shost_class);
--- 1.13/drivers/scsi/scsi_sysfs.c	Mon May  5 00:48:20 2003
+++ edited/drivers/scsi/scsi_sysfs.c	Wed May  7 14:23:49 2003
@@ -53,7 +53,7 @@
 	&class_device_attr_unchecked_isa_dma,
 };
 
-struct class shost_class = {
+static struct class shost_class = {
 	.name		= "scsi_host",
 };
 
