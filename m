From: Matthew Galgoci <mgalgoci@redhat.com>
Subject: Patch for dynamically added adapters
Date: Thu, 28 Aug 2003 18:05:09 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0308281803140.15010-100000@lacrosse.corp.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pix-525-pool.redhat.com ([66.187.233.200]:61848 "EHLO
	lacrosse.corp.redhat.com") by vger.kernel.org with ESMTP
	id S264379AbTH1WFQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2003 18:05:16 -0400
Received: from localhost (mgalgoci@localhost)
	by lacrosse.corp.redhat.com (8.11.6/8.9.3) with ESMTP id h7SM59v10502
	for <linux-scsi@vger.kernel.org>; Thu, 28 Aug 2003 18:05:09 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi Folks,

This patch is derived largely and mostly from the following work by Erik Andersen <andersen@codepoet.org>
and the original patch is here: http://linux1394.org/patches/scsi_add_rem.diff

I basically added smp locking to what appeared to be critical code paths, and did a minor simplification or
two. The reason I did this is because the only alternative to automatic registration of firewire block
devices is 1) manual device registation via echo foo > /proc/scsi/scsi or 2) http://linux1394.org/faq.html#hotplug

I'd rather not have a shell script frobbing for scsi devices ;(

Anyhow, please review this, I'd be interested in feedback.

Regards,

Matthew Galgoci


diff -urN linux-2.4.22-rc2-ac3.orig/drivers/ieee1394/sbp2.c linux-2.4.22-rc2-ac3/drivers/ieee1394/sbp2.c
--- linux-2.4.22-rc2-ac3.orig/drivers/ieee1394/sbp2.c	2003-08-17 10:44:12.000000000 +0000
+++ linux-2.4.22-rc2-ac3/drivers/ieee1394/sbp2.c	2003-08-18 19:20:38.000000000 +0000
@@ -231,7 +231,7 @@
  * enable this define to make use of it. This provides better hotplug
  * support. The mentioned patch is not part of the kernel proper though,
  * because it is considered somewhat of a hack. */
-//#define SBP2_USE_SCSI_ADDREM_HACK
+#define SBP2_USE_SCSI_ADDREM_HACK
 
 
 /*
diff -urN linux-2.4.22-rc2-ac3.orig/drivers/scsi/hosts.h linux-2.4.22-rc2-ac3/drivers/scsi/hosts.h
--- linux-2.4.22-rc2-ac3.orig/drivers/scsi/hosts.h	2003-08-17 15:02:20.000000000 +0000
+++ linux-2.4.22-rc2-ac3/drivers/scsi/hosts.h	2003-08-19 02:07:18.000000000 +0000
@@ -535,6 +535,13 @@
 int scsi_register_device(struct Scsi_Device_Template * sdpnt);
 void scsi_deregister_device(struct Scsi_Device_Template * tpnt);
 
+/* Support for hot plugging and unplugging devices -- safe for 
+ * ieee1394 or USB devices, but probably not for normal SCSI... */
+extern int scsi_add_single_device(struct Scsi_Host *shpnt, 
+	int channel, int id, int lun);
+extern int scsi_remove_single_device(struct Scsi_Host *shpnt, 
+	int channel, int id, int lun);
+
 /* These are used by loadable modules */
 extern int scsi_register_module(int, void *);
 extern int scsi_unregister_module(int, void *);
diff -urN linux-2.4.22-rc2-ac3.orig/drivers/scsi/scsi.c linux-2.4.22-rc2-ac3/drivers/scsi/scsi.c
--- linux-2.4.22-rc2-ac3.orig/drivers/scsi/scsi.c	2003-08-17 10:44:53.000000000 +0000
+++ linux-2.4.22-rc2-ac3/drivers/scsi/scsi.c	2003-08-19 02:31:31.000000000 +0000
@@ -1559,6 +1559,109 @@
     }
 }
 
+/* Support for plugging/unplugging SCSI devices.  This feature is
+ * probably unsafe for standard SCSI devices, but is perfectly
+ * normal for things like ieee1394 or USB drives since these
+ * busses are designed for hotplugging.  Use at your own risk.... */
+int scsi_add_single_device(struct Scsi_Host *shpnt, 
+	int channel, int id, int lun)
+{
+	Scsi_Device *scd;
+	unsigned long flags;
+
+	/* Do a bit of sanity checking */
+	if (shpnt==NULL) {
+		return -ENXIO;
+	}
+
+	/* Check if they asked us to add an already existing device.
+	 * If so, ignore their misguided efforts. */
+	spin_lock_irqsave(&device_request_lock, flags);
+	for (scd = shpnt->host_queue; scd; scd = scd->next) {
+		if ((scd->channel == channel && scd->id == id && scd->lun == lun)) {
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&device_request_lock, flags);
+
+	if (scd) {
+		return -ENOSYS;
+	}
+
+	scan_scsis(shpnt, 1, channel, id, lun);
+	return 0;
+}
+
+/* Support for plugging/unplugging SCSI devices.  This feature is
+ * probably unsafe for standard SCSI devices, but is perfectly
+ * normal for things like ieee1394 or USB drives since these
+ * busses are designed for hotplugging.  Use at your own risk.... */
+int scsi_remove_single_device(struct Scsi_Host *shpnt, 
+	int channel, int id, int lun)
+{
+	Scsi_Device *scd;
+	struct Scsi_Device_Template *SDTpnt;
+	unsigned long flags;
+
+	/* Do a bit of sanity checking */
+	if (shpnt==NULL) {
+		return  -ENODEV;
+	}
+
+	/* Make sure the specified device is in fact present */
+	spin_lock_irqsave(&device_request_lock, flags);
+	for (scd = shpnt->host_queue; scd; scd = scd->next) {
+		if ((scd->channel == channel && scd->id == id && scd->lun == lun)) {
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&device_request_lock, flags);
+
+	if (scd==NULL) {
+		return -ENODEV;
+	}
+
+	/* See if the specified device is busy */
+	if (scd->access_count) {
+		return -EBUSY;
+	}
+
+	spin_lock_irqsave(&device_request_lock, flags);
+
+	SDTpnt = scsi_devicelist;
+	while (SDTpnt != NULL) {
+		if (SDTpnt->detach)
+			(*SDTpnt->detach) (scd);
+		SDTpnt = SDTpnt->next;
+	}
+
+	if (scd->attached == 0) {
+		/* Nobody is using this device, so we
+		 * can now free all command structures.  */
+		if (shpnt->hostt->revoke)
+			shpnt->hostt->revoke(scd);
+		devfs_unregister (scd->de);
+		scsi_release_commandblocks(scd);
+
+		/* Now we can remove the device structure */
+		if (scd->next != NULL)
+			scd->next->prev = scd->prev;
+
+		if (scd->prev != NULL)
+			scd->prev->next = scd->next;
+
+		if (shpnt->host_queue == scd) {
+			shpnt->host_queue = scd->next;
+		}
+		blk_cleanup_queue(&scd->request_queue);
+		kfree((char *) scd);
+	}
+
+	spin_unlock_irqrestore(&device_request_lock, flags);
+
+	return 0;
+}
+
 #ifdef CONFIG_PROC_FS
 static int scsi_proc_info(char *buffer, char **start, off_t offset, int length)
 {
@@ -1611,8 +1714,6 @@
 static int proc_scsi_gen_write(struct file * file, const char * buf,
                               unsigned long length, void *data)
 {
-	struct Scsi_Device_Template *SDTpnt;
-	Scsi_Device *scd;
 	struct Scsi_Host *HBA_ptr;
 	char *p;
 	int host, channel, id, lun;
@@ -1751,33 +1852,11 @@
 				break;
 			}
 		}
-		err = -ENXIO;
-		if (!HBA_ptr)
-			goto out;
-
-		for (scd = HBA_ptr->host_queue; scd; scd = scd->next) {
-			if ((scd->channel == channel
-			     && scd->id == id
-			     && scd->lun == lun)) {
-				break;
-			}
-		}
-
-		err = -ENOSYS;
-		if (scd)
-			goto out;	/* We do not yet support unplugging */
-
-		scan_scsis(HBA_ptr, 1, channel, id, lun);
-
-		/* FIXME (DB) This assumes that the queue_depth routines can be used
-		   in this context as well, while they were all designed to be
-		   called only once after the detect routine. (DB) */
-		/* queue_depth routine moved to inside scan_scsis(,1,,,) so
-		   it is called before build_commandblocks() */
-
-		err = length;
+		if ((err=scsi_add_single_device(HBA_ptr, channel, id, lun))==0)
+		    err = length;
 		goto out;
 	}
+
 	/*
 	 * Usage: echo "scsi remove-single-device 0 1 2 3" >/proc/scsi/scsi
 	 * with  "0 1 2 3" replaced by your "Host Channel Id Lun".
@@ -1803,58 +1882,7 @@
 				break;
 			}
 		}
-		err = -ENODEV;
-		if (!HBA_ptr)
-			goto out;
-
-		for (scd = HBA_ptr->host_queue; scd; scd = scd->next) {
-			if ((scd->channel == channel
-			     && scd->id == id
-			     && scd->lun == lun)) {
-				break;
-			}
-		}
-
-		if (scd == NULL)
-			goto out;	/* there is no such device attached */
-
-		err = -EBUSY;
-		if (scd->access_count)
-			goto out;
-
-		SDTpnt = scsi_devicelist;
-		while (SDTpnt != NULL) {
-			if (SDTpnt->detach)
-				(*SDTpnt->detach) (scd);
-			SDTpnt = SDTpnt->next;
-		}
-
-		if (scd->attached == 0) {
-			/*
-			 * Nobody is using this device any more.
-			 * Free all of the command structures.
-			 */
-                        if (HBA_ptr->hostt->revoke)
-                                HBA_ptr->hostt->revoke(scd);
-			devfs_unregister (scd->de);
-			scsi_release_commandblocks(scd);
-
-			/* Now we can remove the device structure */
-			if (scd->next != NULL)
-				scd->next->prev = scd->prev;
-
-			if (scd->prev != NULL)
-				scd->prev->next = scd->next;
-
-			if (HBA_ptr->host_queue == scd) {
-				HBA_ptr->host_queue = scd->next;
-			}
-			blk_cleanup_queue(&scd->request_queue);
-			kfree((char *) scd);
-		} else {
-			goto out;
-		}
-		err = 0;
+		err=scsi_remove_single_device(HBA_ptr, channel, id, lun);
 	}
 out:
 	
diff -urN linux-2.4.22-rc2-ac3.orig/drivers/scsi/scsi_syms.c linux-2.4.22-rc2-ac3/drivers/scsi/scsi_syms.c
--- linux-2.4.22-rc2-ac3.orig/drivers/scsi/scsi_syms.c	2002-08-03 00:39:44.000000000 +0000
+++ linux-2.4.22-rc2-ac3/drivers/scsi/scsi_syms.c	2003-08-18 23:59:25.000000000 +0000
@@ -103,3 +103,9 @@
 extern int scsi_delete_timer(Scsi_Cmnd *);
 EXPORT_SYMBOL(scsi_add_timer);
 EXPORT_SYMBOL(scsi_delete_timer);
+
+/* Support for hot plugging and unplugging devices -- safe for 
+ * ieee1394 or USB devices, but probably not for normal SCSI... */
+EXPORT_SYMBOL_GPL(scsi_add_single_device);
+EXPORT_SYMBOL_GPL(scsi_remove_single_device);
+



-- 

Matthew Galgoci		"Dirty deeds, done dirt cheap"
System Administrator
Red Hat, Inc
919.754.3700 x44155

