From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] more sdev freeing rationalization
Date: Sat, 23 Nov 2002 03:02:42 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021123030242.A11192@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

(1) new helper in scsi_scan.c: scsi_forget_host.  it's the counterpart to
    scsi_scan_host.  it shares code with scsi_remove_single_device
    through a common subroutine, scsi_forget_host.
(2) move scsi_get_host_dev/scsi_free_host_dev (again).  Having them in
    scsi_scan.c allows to make scsi_alloc_sdev/scsi_free_sdev static.


--- 1.35/drivers/scsi/hosts.c	Fri Nov 22 12:59:03 2002
+++ edited/drivers/scsi/hosts.c	Sat Nov 23 01:31:25 2002
@@ -260,7 +260,6 @@
 int scsi_remove_host(struct Scsi_Host *shost)
 {
 	struct scsi_device *sdev;
-	struct list_head *le, *lh;
 
 	/*
 	 * FIXME Do ref counting.  We force all of the devices offline to
@@ -287,16 +286,9 @@
 			       sdev->attached);
 			return 1;
 		}
-		devfs_unregister(sdev->de);
-		device_unregister(&sdev->sdev_driverfs_dev);
-	}
-
-	/* Next we free up the Scsi_Cmnd structures for this host */
-
-	list_for_each_safe(le, lh, &shost->my_devices) {
-		scsi_free_sdev(list_entry(le, Scsi_Device, siblings));
 	}
 
+	scsi_forget_host(shost);
 	return 0;
 }
 
@@ -668,64 +660,6 @@
 	}
 }
 
-/*
- * Function:    scsi_get_host_dev()
- *
- * Purpose:     Create a Scsi_Device that points to the host adapter itself.
- *
- * Arguments:   SHpnt   - Host that needs a Scsi_Device
- *
- * Lock status: None assumed.
- *
- * Returns:     The Scsi_Device or NULL
- *
- * Notes:
- *	Attach a single Scsi_Device to the Scsi_Host - this should
- *	be made to look like a "pseudo-device" that points to the
- *	HA itself.
- *
- *	Note - this device is not accessible from any high-level
- *	drivers (including generics), which is probably not
- *	optimal.  We can add hooks later to attach 
- */
-struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
-{
-	struct scsi_device *sdev;
-
-	sdev = scsi_alloc_sdev(shost, 0, shost->this_id, 0);
-	if (sdev) {
-		scsi_build_commandblocks(sdev);
-		if (sdev->current_queue_depth == 0)
-			goto fail;
-		sdev->borken = 0;
-	}
-
-	return sdev;
-
-fail:
-	kfree(sdev);
-	return NULL;
-}
-
-/*
- * Function:    scsi_free_host_dev()
- *
- * Purpose:     Free a scsi_device that points to the host adapter itself.
- *
- * Arguments:   SHpnt   - Host that needs a Scsi_Device
- *
- * Lock status: None assumed.
- *
- * Returns:     Nothing
- *
- * Notes:
- */
-void scsi_free_host_dev(struct scsi_device *sdev)
-{
-	BUG_ON(sdev->id != sdev->host->this_id);
-	scsi_free_sdev(sdev);
-}
-
 void scsi_host_busy_inc(struct Scsi_Host *shost, Scsi_Device *sdev)
 {
 	unsigned long flags;
@@ -765,22 +699,3 @@
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-indent-level: 4
- * c-brace-imaginary-offset: 0
- * c-brace-offset: -4
- * c-argdecl-indent: 4
- * c-label-offset: -4
- * c-continued-statement-offset: 4
- * c-continued-brace-offset: 0
- * indent-tabs-mode: nil
- * tab-width: 8
- * End:
- */
===== drivers/scsi/hosts.h 1.42 vs edited =====
--- 1.42/drivers/scsi/hosts.h	Fri Nov 22 12:59:03 2002
+++ edited/drivers/scsi/hosts.h	Sat Nov 23 01:30:50 2002
@@ -532,6 +532,8 @@
  * Prototypes for functions/data in scsi_scan.c
  */
 extern void scsi_scan_host(struct Scsi_Host *);
+extern void scsi_forget_host(struct Scsi_Host *);
+
 
 struct Scsi_Device_Template
 {
===== drivers/scsi/scsi.h 1.46 vs edited =====
--- 1.46/drivers/scsi/scsi.h	Thu Nov 21 12:55:52 2002
+++ edited/drivers/scsi/scsi.h	Sat Nov 23 01:26:01 2002
@@ -507,9 +507,6 @@
 /*
  * Prototypes for functions in scsi_scan.c
  */
-extern struct scsi_device *scsi_alloc_sdev(struct Scsi_Host *,
-			uint, uint, uint);
-extern void scsi_free_sdev(struct scsi_device *);
 extern int scsi_add_single_device(uint, uint, uint, uint);
 extern int scsi_remove_single_device(uint, uint, uint, uint);
 
===== drivers/scsi/scsi_scan.c 1.43 vs edited =====
--- 1.43/drivers/scsi/scsi_scan.c	Fri Nov 22 12:59:03 2002
+++ edited/drivers/scsi/scsi_scan.c	Sat Nov 23 01:32:16 2002
@@ -465,8 +465,8 @@
  * Return value:
  *     Scsi_Device pointer, or NULL on failure.
  **/
-struct scsi_device *scsi_alloc_sdev(struct Scsi_Host *shost, uint channel,
-				    uint id, uint lun)
+static struct scsi_device *scsi_alloc_sdev(struct Scsi_Host *shost,
+					   uint channel, uint id, uint lun)
 {
 	struct scsi_device *sdev, *device;
 
@@ -535,7 +535,7 @@
  *     Undo the actions in scsi_alloc_sdev, including removing @sdev from
  *     the list, and freeing @sdev.
  **/
-void scsi_free_sdev(struct scsi_device *sdev)
+static void scsi_free_sdev(struct scsi_device *sdev)
 {
 	list_del(&sdev->siblings);
 	list_del(&sdev->same_target_siblings);
@@ -1412,6 +1412,14 @@
 	return SCSI_SCAN_LUN_PRESENT;
 }
 
+static int scsi_remove_lun(struct scsi_device *sdev)
+{
+	devfs_unregister(sdev->de);
+	device_unregister(&sdev->sdev_driverfs_dev);
+
+	scsi_free_sdev(sdev);
+}
+
 /**
  * scsi_probe_and_add_lun - probe a LUN, if a LUN is found add it
  * @sdevscan:	probe the LUN corresponding to this Scsi_Device
@@ -1934,8 +1942,7 @@
 	if (sdev->attached)
 		goto out;
 
-	devfs_unregister(sdev->de);
-	scsi_free_sdev(sdev);
+	scsi_remove_lun(sdev);
 	error = 0;
 
 out:
@@ -2060,4 +2067,70 @@
 		}
 	}
 	scsi_free_sdev(sdevscan);
+}
+
+void scsi_forget_host(struct Scsi_Host *shost)
+{
+	struct list_head *le, *lh;
+
+	list_for_each_safe(le, lh, &shost->my_devices)
+		scsi_remove_lun(list_entry(le, struct scsi_device, siblings));
+}
+
+/*
+ * Function:    scsi_get_host_dev()
+ *
+ * Purpose:     Create a Scsi_Device that points to the host adapter itself.
+ *
+ * Arguments:   SHpnt   - Host that needs a Scsi_Device
+ *
+ * Lock status: None assumed.
+ *
+ * Returns:     The Scsi_Device or NULL
+ *
+ * Notes:
+ *	Attach a single Scsi_Device to the Scsi_Host - this should
+ *	be made to look like a "pseudo-device" that points to the
+ *	HA itself.
+ *
+ *	Note - this device is not accessible from any high-level
+ *	drivers (including generics), which is probably not
+ *	optimal.  We can add hooks later to attach 
+ */
+struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
+{
+	struct scsi_device *sdev;
+
+	sdev = scsi_alloc_sdev(shost, 0, shost->this_id, 0);
+	if (sdev) {
+		scsi_build_commandblocks(sdev);
+		if (sdev->current_queue_depth == 0)
+			goto fail;
+		sdev->borken = 0;
+	}
+
+	return sdev;
+
+fail:
+	kfree(sdev);
+	return NULL;
+}
+
+/*
+ * Function:    scsi_free_host_dev()
+ *
+ * Purpose:     Free a scsi_device that points to the host adapter itself.
+ *
+ * Arguments:   SHpnt   - Host that needs a Scsi_Device
+ *
+ * Lock status: None assumed.
+ *
+ * Returns:     Nothing
+ *
+ * Notes:
+ */
+void scsi_free_host_dev(struct scsi_device *sdev)
+{
+	BUG_ON(sdev->id != sdev->host->this_id);
+	scsi_free_sdev(sdev);
 }
