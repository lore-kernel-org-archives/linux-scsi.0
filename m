From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] scsi_report_device_reset
Date: Thu, 8 May 2003 21:05:41 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030508210541.C28294@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:39439 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S262008AbTEHSxH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2003 14:53:07 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

aic7xxx/79xx wants a variant of scsi_report_bus_reset that operates
only on a single device.  Implement it to get rid of shost->my_devices
traversals in drivers.  (and move both to scsi_error.c)


--- 1.62/drivers/scsi/hosts.h	Wed May  7 10:25:40 2003
+++ edited/drivers/scsi/hosts.h	Thu May  8 18:24:14 2003
@@ -514,6 +514,7 @@
 extern void scsi_unblock_requests(struct Scsi_Host *);
 extern void scsi_block_requests(struct Scsi_Host *);
 extern void scsi_report_bus_reset(struct Scsi_Host *, int);
+extern void scsi_report_device_reset(struct Scsi_Host *, int, int);
 
 static inline void scsi_assign_lock(struct Scsi_Host *shost, spinlock_t *lock)
 {
--- 1.52/drivers/scsi/scsi_error.c	Wed Apr 30 18:09:21 2003
+++ edited/drivers/scsi/scsi_error.c	Thu May  8 19:14:27 2003
@@ -1624,6 +1624,74 @@
 	complete_and_exit(shost->eh_notify, 0);
 }
 
+/*
+ * Function:    scsi_report_bus_reset()
+ *
+ * Purpose:     Utility function used by low-level drivers to report that
+ *		they have observed a bus reset on the bus being handled.
+ *
+ * Arguments:   shost       - Host in question
+ *		channel     - channel on which reset was observed.
+ *
+ * Returns:     Nothing
+ *
+ * Lock status: No locks are assumed held.
+ *
+ * Notes:       This only needs to be called if the reset is one which
+ *		originates from an unknown location.  Resets originated
+ *		by the mid-level itself don't need to call this, but there
+ *		should be no harm.
+ *
+ *		The main purpose of this is to make sure that a CHECK_CONDITION
+ *		is properly treated.
+ */
+void scsi_report_bus_reset(struct Scsi_Host *shost, int channel)
+{
+	struct scsi_device *sdev;
+
+	list_for_each_entry(sdev, &shost->my_devices, siblings) {
+		if (channel == sdev->channel) {
+			sdev->was_reset = 1;
+			sdev->expecting_cc_ua = 1;
+		}
+	}
+}
+
+/*
+ * Function:    scsi_report_device_reset()
+ *
+ * Purpose:     Utility function used by low-level drivers to report that
+ *		they have observed a device reset on the device being handled.
+ *
+ * Arguments:   shost       - Host in question
+ *		channel     - channel on which reset was observed
+ *		target	    - target on which reset was observed
+ *
+ * Returns:     Nothing
+ *
+ * Lock status: No locks are assumed held.
+ *
+ * Notes:       This only needs to be called if the reset is one which
+ *		originates from an unknown location.  Resets originated
+ *		by the mid-level itself don't need to call this, but there
+ *		should be no harm.
+ *
+ *		The main purpose of this is to make sure that a CHECK_CONDITION
+ *		is properly treated.
+ */
+void scsi_report_device_reset(struct Scsi_Host *shost, int channel, int target)
+{
+	struct scsi_device *sdev;
+
+	list_for_each_entry(sdev, &shost->my_devices, siblings) {
+		if (channel == sdev->channel &&
+		    target == sdev->id) {
+			sdev->was_reset = 1;
+			sdev->expecting_cc_ua = 1;
+		}
+	}
+}
+
 static void
 scsi_reset_provider_done_command(struct scsi_cmnd *scmd)
 {
--- 1.89/drivers/scsi/scsi_lib.c	Wed Apr 30 18:09:21 2003
+++ edited/drivers/scsi/scsi_lib.c	Thu May  8 19:14:09 2003
@@ -1313,39 +1313,6 @@
 	scsi_run_host_queues(shost);
 }
 
-/*
- * Function:    scsi_report_bus_reset()
- *
- * Purpose:     Utility function used by low-level drivers to report that
- *		they have observed a bus reset on the bus being handled.
- *
- * Arguments:   shost       - Host in question
- *		channel     - channel on which reset was observed.
- *
- * Returns:     Nothing
- *
- * Lock status: No locks are assumed held.
- *
- * Notes:       This only needs to be called if the reset is one which
- *		originates from an unknown location.  Resets originated
- *		by the mid-level itself don't need to call this, but there
- *		should be no harm.
- *
- *		The main purpose of this is to make sure that a CHECK_CONDITION
- *		is properly treated.
- */
-void scsi_report_bus_reset(struct Scsi_Host *shost, int channel)
-{
-	struct scsi_device *sdev;
-
-	list_for_each_entry(sdev, &shost->my_devices, siblings) {
-		if (channel == sdev->channel) {
-			sdev->was_reset = 1;
-			sdev->expecting_cc_ua = 1;
-		}
-	}
-}
-
 int __init scsi_init_queue(void)
 {
 	int i;
--- 1.35/drivers/scsi/scsi_syms.c	Wed May  7 10:24:01 2003
+++ edited/drivers/scsi/scsi_syms.c	Thu May  8 18:24:15 2003
@@ -65,6 +65,7 @@
 EXPORT_SYMBOL(scsi_put_command);
 
 EXPORT_SYMBOL(scsi_report_bus_reset);
+EXPORT_SYMBOL(scsi_report_device_reset);
 EXPORT_SYMBOL(scsi_block_requests);
 EXPORT_SYMBOL(scsi_unblock_requests);
 EXPORT_SYMBOL(scsi_adjust_queue_depth);
--- 1.41/drivers/scsi/aic7xxx/aic79xx_osm.c	Tue May  6 14:22:53 2003
+++ edited/drivers/scsi/aic7xxx/aic79xx_osm.c	Thu May  8 18:24:16 2003
@@ -4404,22 +4404,19 @@
 	}
         case AC_SENT_BDR:
 	{
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+		WARN_ON(lun != CAM_LUN_WILDCARD);
+		scsi_report_device_reset(ahd->platform_data->host,
+					 channel - 'A', target);
+#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
 		Scsi_Device *scsi_dev;
 
 		/*
 		 * Find the SCSI device associated with this
 		 * request and indicate that a UA is expected.
-		 * XXX This should really be handled by the mid-layer.
 		 */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-		list_for_each_entry(scsi_dev,
-				    &ahd->platform_data->host->my_devices,
-				    siblings) {
-#else
 		for (scsi_dev = ahd->platform_data->host->host_queue;
 		     scsi_dev != NULL; scsi_dev = scsi_dev->next) {
-#endif
 			if (channel - 'A' == scsi_dev->channel
 			 && target == scsi_dev->id
 			 && (lun == CAM_LUN_WILDCARD
--- 1.33/drivers/scsi/aic7xxx/aic7xxx_osm.c	Tue May  6 14:22:55 2003
+++ edited/drivers/scsi/aic7xxx/aic7xxx_osm.c	Thu May  8 18:24:16 2003
@@ -4086,22 +4086,19 @@
 	}
         case AC_SENT_BDR:
 	{
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+		WARN_ON(lun != CAM_LUN_WILDCARD);
+		scsi_report_device_reset(ahc->platform_data->host,
+					 channel - 'A', target);
+#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
 		Scsi_Device *scsi_dev;
 
 		/*
 		 * Find the SCSI device associated with this
 		 * request and indicate that a UA is expected.
-		 * XXX This should really be handled by the mid-layer.
 		 */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-		list_for_each_entry(scsi_dev,
-				    &ahc->platform_data->host->my_devices,
-				    siblings) {
-#else
 		for (scsi_dev = ahc->platform_data->host->host_queue;
 		     scsi_dev != NULL; scsi_dev = scsi_dev->next) {
-#endif
 			if (channel - 'A' == scsi_dev->channel
 			 && target == scsi_dev->id
 			 && (lun == CAM_LUN_WILDCARD
