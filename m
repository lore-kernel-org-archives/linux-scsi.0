From: Erik Andersen <andersen@codepoet.org>
Subject: [PATCH] SCSI hotplug support
Date: Sun, 13 Oct 2002 23:40:35 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021014054035.GA10686@codepoet.org>
Reply-To: andersen@codepoet.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Using the following patch I am able to make ieee1394 properly
connect and disconnect SBP-2 devices to/from the SCSI subsystem.
Without this patch, firewire devices are only registered with the
SCSI subsystem if they are connected when the host adaptor is
registered, and are only unregistered from the SCSI subsystem
when the firewire driver modules are removed from the kernel.
This is far from desirable...

This patch works by exporting within the kernel the functionality
already provided to userspace via /proc/scsi/scsi, i.e.:
	echo "scsi add-single-device 0 1 2 3" >/proc/scsi/scsi
and 
	echo "scsi remove-single-device 0 1 2 3" >/proc/scsi/scsi
is exported within the kernel as scsi_add_single_device() and 
scsi_remove_single_device().  A separate patch to the sbp2 driver
then uses these interfaces when devices are plugged or unplugged.
After looking though the current code, there does not seem to be
any other way to accomplish the same thing using the current SCSI
infrastructure.  Anyone have any objections to such a patch?  For
2.4.x?  Comments? 

Please CC me as I am not subscribed to linux-scsi, thanks,

 -Erik

--
Erik B. Andersen             http://codepoet-consulting.com/
--This message was written using 73% post-consumer electrons--


--- orig/drivers/scsi/hosts.h	2002-10-09 04:41:10.000000000 -0600
+++ linux-2.4.19/drivers/scsi/hosts.h	2002-10-09 04:41:10.000000000 -0600
@@ -532,6 +532,13 @@
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
--- orig/drivers/scsi/scsi.c	2002-10-09 04:41:10.000000000 -0600
+++ linux-2.4.19/drivers/scsi/scsi.c	2002-10-09 04:41:10.000000000 -0600
@@ -1553,6 +1553,96 @@
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
+
+	/* Do a bit of sanity checking */
+	if (shpnt==NULL) {
+		return  -ENXIO;
+	}
+
+	/* Check if they asked us to add an already existing device.
+	 * If so, ignore their misguided efforts. */
+	for (scd = shpnt->host_queue; scd; scd = scd->next) {
+		if ((scd->channel == channel && scd->id == id && scd->lun == lun)) {
+			break;
+		}
+	}
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
+
+	/* Do a bit of sanity checking */
+	if (shpnt==NULL) {
+		return  -ENODEV;
+	}
+
+	/* Make sure the specified device is in fact present */
+	for (scd = shpnt->host_queue; scd; scd = scd->next) {
+		if ((scd->channel == channel && scd->id == id && scd->lun == lun)) {
+			break;
+		}
+	}
+	if (scd==NULL) {
+		return -ENODEV;
+	}
+
+	/* See if the specified device is busy */
+	if (scd->access_count)
+		return -EBUSY;
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
+	return 0;
+}
+
 #ifdef CONFIG_PROC_FS
 static int scsi_proc_info(char *buffer, char **start, off_t offset, int length)
 {
@@ -1605,8 +1695,6 @@
 static int proc_scsi_gen_write(struct file * file, const char * buf,
                               unsigned long length, void *data)
 {
-	struct Scsi_Device_Template *SDTpnt;
-	Scsi_Device *scd;
 	struct Scsi_Host *HBA_ptr;
 	char *p;
 	int host, channel, id, lun;
@@ -1745,33 +1833,11 @@
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
@@ -1797,58 +1863,8 @@
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
+		goto out;
 	}
 out:
 	
--- orig/drivers/scsi/scsi_syms.c	2002-10-09 04:41:10.000000000 -0600
+++ linux-2.4.19/drivers/scsi/scsi_syms.c	2002-10-09 04:41:10.000000000 -0600
@@ -103,3 +103,9 @@
 extern int scsi_delete_timer(Scsi_Cmnd *);
 EXPORT_SYMBOL(scsi_add_timer);
 EXPORT_SYMBOL(scsi_delete_timer);
+
+/* Support for hot plugging and unplugging devices -- safe for 
+ * ieee1394 or USB devices, but probably not for normal SCSI... */
+EXPORT_SYMBOL(scsi_add_single_device);
+EXPORT_SYMBOL(scsi_remove_single_device);
+
