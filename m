From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] some scsi_scan.c restructuring for ieee1394 hotplugging
Date: Fri, 21 Feb 2003 20:52:28 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030221205228.A29247@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

I had some discussion with Ben Collins on ow to properly allow
hotplugging of ieee1394 storage device (sbp2).  While the scsi_add_host/
scsi_remove_host interface allows hotpluging of ieee1394 adapters we
need a way to register the actual devices with the scsi layer when
they're plugged in.  I've restructured the code to handle the
/proc/scsi/scsi code to add/remove devices a bit to have an interface
the ieee1394 driver can use, and created the following new interface:

	struct scsi_device *scsi_add_device(struct Scsi_Host *shost,
			uint channel, uint id, uint lun)
	int scsi_remove_device(struct scsi_device *sdev)

in addition scsi_probe_and_add_lun() got some overhaul to become
readable and can now return the struct scsi_device it probed as an
optional argument.


--- 1.51/drivers/scsi/hosts.c	Sun Feb  9 16:35:26 2003
+++ edited/drivers/scsi/hosts.c	Fri Feb 21 19:45:47 2003
@@ -270,21 +270,6 @@
 		if (scsi_check_device_busy(sdev))
 			return 1;
 
-	/*
-	 * Next we detach the high level drivers from the Scsi_Device
-	 * structures
-	 */
-	list_for_each_entry(sdev, &shost->my_devices, siblings) {
-		scsi_detach_device(sdev);
-
-		/* If something still attached, punt */
-		if (sdev->attached) {
-			printk(KERN_ERR "Attached usage count = %d\n",
-			       sdev->attached);
-			return 1;
-		}
-	}
-
 	scsi_forget_host(shost);
 	return 0;
 }
--- 1.61/drivers/scsi/scsi.h	Tue Feb 11 10:57:35 2003
+++ edited/drivers/scsi/scsi.h	Fri Feb 21 20:16:32 2003
@@ -502,8 +502,9 @@
 /*
  * Prototypes for functions in scsi_scan.c
  */
-extern int scsi_add_single_device(uint, uint, uint, uint);
-extern int scsi_remove_single_device(uint, uint, uint, uint);
+extern struct scsi_device *scsi_add_device(struct Scsi_Host *,
+		uint, uint, uint);
+extern int scsi_remove_device(struct scsi_device *);
 extern u64 scsi_calculate_bounce_limit(struct Scsi_Host *);
 
 /*
--- 1.16/drivers/scsi/scsi_proc.c	Sun Feb  9 16:35:26 2003
+++ edited/drivers/scsi/scsi_proc.c	Fri Feb 21 20:16:07 2003
@@ -398,6 +398,50 @@
 }
 #endif	/* CONFIG_SCSI_LOGGING */ 
 
+static int scsi_add_single_device(uint host, uint channel, uint id, uint lun)
+{
+	struct Scsi_Host *shost;
+	struct scsi_device *sdev;
+	int error = -ENODEV;
+
+	shost = scsi_host_hn_get(host);
+	if (!shost)
+		return -ENODEV;
+
+	if (!scsi_find_device(shost, channel, id, lun)) {
+		sdev = scsi_add_device(shost, channel, id, lun);
+		if (IS_ERR(sdev))
+			error = PTR_ERR(sdev);
+		else
+			error = 0;
+	}
+
+	scsi_host_put(shost);
+	return error;
+}
+
+static int scsi_remove_single_device(uint host, uint channel, uint id, uint lun)
+{
+	struct scsi_device *sdev;
+	struct Scsi_Host *shost;
+	int error = -ENODEV;
+
+	shost = scsi_host_hn_get(host);
+	if (!shost)
+		return -ENODEV;
+	sdev = scsi_find_device(shost, channel, id, lun);
+	if (!sdev)
+		goto out;
+	if (sdev->access_count)
+		goto out;
+
+	error = scsi_remove_device(sdev);
+out:
+	scsi_host_put(shost);
+	return error;
+}
+
+
 static int proc_scsi_gen_write(struct file * file, const char * buf,
                               unsigned long length, void *data)
 {
--- 1.59/drivers/scsi/scsi_scan.c	Tue Feb 11 10:56:25 2003
+++ edited/drivers/scsi/scsi_scan.c	Fri Feb 21 20:19:34 2003
@@ -1257,14 +1257,6 @@
 	return SCSI_SCAN_LUN_PRESENT;
 }
 
-static void scsi_remove_lun(struct scsi_device *sdev)
-{
-	devfs_unregister(sdev->de);
-	scsi_device_unregister(sdev);
-
-	scsi_free_sdev(sdev);
-}
-
 /**
  * scsi_probe_and_add_lun - probe a LUN, if a LUN is found add it
  * @sdevscan:	probe the LUN corresponding to this Scsi_Device
@@ -1282,90 +1274,77 @@
  *     SCSI_SCAN_LUN_PRESENT: a new Scsi_Device was allocated and initialized
  **/
 static int scsi_probe_and_add_lun(struct Scsi_Host *host,
-		struct request_queue **q, uint channel, uint id,
-	       	uint lun, int *bflagsp)
+		struct request_queue **q, uint channel, uint id, uint lun,
+		int *bflagsp, struct scsi_device **sdevp)
 {
-	Scsi_Device *sdev = NULL;
-	Scsi_Request *sreq = NULL;
-	unsigned char *scsi_result = NULL;
-	int bflags;
-	int res;
+	struct scsi_device *sdev;
+	struct scsi_request *sreq;
+	unsigned char *result;
+	int bflags, res = SCSI_SCAN_NO_RESPONSE;
 
 	sdev = scsi_alloc_sdev(host, q, channel, id, lun);
-	if (sdev == NULL)
-		return SCSI_SCAN_NO_RESPONSE;
+	if (!sdev)
+		goto out;
 	sreq = scsi_allocate_request(sdev);
-	if (sreq == NULL) {
-		printk(ALLOC_FAILURE_MSG, __FUNCTION__);
-		res = SCSI_SCAN_NO_RESPONSE;
-		goto bail_out;
-	}
-	/*
-	 * The sreq is for use only with sdevscan.
-	 */
-
-	scsi_result = kmalloc(256, GFP_ATOMIC |
-			      (host->unchecked_isa_dma) ?
-			      GFP_DMA : 0);
-	if (scsi_result == NULL) {
-		printk(ALLOC_FAILURE_MSG, __FUNCTION__);
-		res = SCSI_SCAN_NO_RESPONSE;
-		goto bail_out;
-	}
+	if (!sreq)
+		goto out_free_sdev;
+	result = kmalloc(256, GFP_ATOMIC |
+			(host->unchecked_isa_dma) ? __GFP_DMA : 0);
+	if (!result)
+		goto out_free_sreq;
 
-	scsi_probe_lun(sreq, scsi_result, &bflags);
+	scsi_probe_lun(sreq, result, &bflags);
 	if (sreq->sr_result)
-		res = SCSI_SCAN_NO_RESPONSE;
-	else {
+		goto out_free_result;
+
+	/*
+	 * result contains valid SCSI INQUIRY data.
+	 */
+	if ((result[0] >> 5) == 3) {
 		/*
-		 * scsi_result contains valid SCSI INQUIRY data.
+		 * For a Peripheral qualifier 3 (011b), the SCSI
+		 * spec says: The device server is not capable of
+		 * supporting a physical device on this logical
+		 * unit.
+		 *
+		 * For disks, this implies that there is no
+		 * logical disk configured at sdev->lun, but there
+		 * is a target id responding.
 		 */
-		if ((scsi_result[0] >> 5) == 3) {
-			/*
-			 * For a Peripheral qualifier 3 (011b), the SCSI
-			 * spec says: The device server is not capable of
-			 * supporting a physical device on this logical
-			 * unit.
-			 *
-			 * For disks, this implies that there is no
-			 * logical disk configured at sdev->lun, but there
-			 * is a target id responding.
-			 */
-			SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
+		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
 					"scsi scan: peripheral qualifier of 3,"
 					" no device added\n"));
-			res = SCSI_SCAN_TARGET_PRESENT;
-		} else {
-			res = scsi_add_lun(sdev, sreq, scsi_result, &bflags);
-			if (res == SCSI_SCAN_LUN_PRESENT) {
-				if ((bflags & BLIST_KEY) != 0) {
-					sdev->lockable = 0;
-					scsi_unlock_floptical(sreq,
-							      scsi_result);
-					/*
-					 * scsi_result no longer contains
-					 * the INQUIRY data.
-					 */
-				}
-				if (bflagsp != NULL)
-					*bflagsp = bflags;
-			}
+		res = SCSI_SCAN_TARGET_PRESENT;
+		goto out_free_result;
+	}
+
+	res = scsi_add_lun(sdev, sreq, result, &bflags);
+	if (res == SCSI_SCAN_LUN_PRESENT) {
+		if (bflags & BLIST_KEY) {
+			sdev->lockable = 0;
+			scsi_unlock_floptical(sreq, result);
 		}
+		if (bflagsp)
+			*bflagsp = bflags;
 	}
-bail_out:
-	if (scsi_result != NULL)
-		kfree(scsi_result);
-	if (sreq != NULL)
-		scsi_release_request(sreq);
-	if (res != SCSI_SCAN_LUN_PRESENT) {
-		if(q) {
+
+ out_free_result:
+	kfree(result);
+ out_free_sreq:
+	scsi_release_request(sreq);
+ out_free_sdev:
+	if (res == SCSI_SCAN_LUN_PRESENT) {
+		if (*sdevp)
+			*sdevp = sdev;
+	} else {
+		if (q) {
 			*q = sdev->request_queue;
 			sdev->request_queue = NULL;
 		}
 		scsi_free_sdev(sdev);
 	}
+ out:
 	return res;
-
 }
 
 /**
@@ -1451,8 +1430,8 @@
 	 * sparse_lun.
 	 */
 	for (lun = 1; lun < max_dev_lun; ++lun)
-		if ((scsi_probe_and_add_lun(shost, q, channel, id, lun, NULL)
-		     != SCSI_SCAN_LUN_PRESENT) && !sparse_lun)
+		if ((scsi_probe_and_add_lun(shost, q, channel, id, lun,
+		      NULL, NULL) != SCSI_SCAN_LUN_PRESENT) && !sparse_lun)
 			return;
 }
 
@@ -1667,7 +1646,7 @@
 			int res;
 
 			res = scsi_probe_and_add_lun(sdev->host, q,
-				       	sdev->channel, sdev->id, lun, NULL);
+				sdev->channel, sdev->id, lun, NULL, NULL);
 			if (res == SCSI_SCAN_NO_RESPONSE) {
 				/*
 				 * Got some results, but now none, abort.
@@ -1689,55 +1668,33 @@
 
 }
 
-int scsi_add_single_device(uint host, uint channel, uint id, uint lun)
+struct scsi_device *scsi_add_device(struct Scsi_Host *shost,
+				    uint channel, uint id, uint lun)
 {
-	struct Scsi_Host *shost;
-	int error = -ENODEV;
 	struct scsi_device *sdev;
+	int error = -ENODEV, res;
 
-	shost = scsi_host_hn_get(host);
-	if (!shost)
-		return -ENODEV;
-	if(scsi_find_device(shost, channel, id, lun) != NULL)
-		goto out;
-
-	if (scsi_probe_and_add_lun(shost, NULL, channel, id, lun, NULL) ==
-			SCSI_SCAN_LUN_PRESENT) {
-		error = 0;
-		sdev = scsi_find_device(shost, channel, id, lun);
-		scsi_attach_device(sdev);
-	}
-out:
-	scsi_host_put(shost);
-	return error;
+	res = scsi_probe_and_add_lun(shost, NULL, channel, id, lun,
+			NULL, &sdev);
+	if (res == SCSI_SCAN_LUN_PRESENT)
+		error = scsi_attach_device(sdev);
+
+	if (error)
+		sdev = ERR_PTR(error);
+	return sdev;
 }
 
-int scsi_remove_single_device(uint host, uint channel, uint id, uint lun)
+int scsi_remove_device(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev;
-	struct Scsi_Host *shost;
-	int error = -ENODEV;
-
-	shost = scsi_host_hn_get(host);
-	if (!shost)
-		return -ENODEV;
-	sdev = scsi_find_device(shost, channel, id, lun);
-	if (!sdev)
-		goto out;
-
-	error = -EBUSY;
-	if (sdev->access_count)
-		goto out;
 	scsi_detach_device(sdev);
 	if (sdev->attached)
-		goto out;
+		return -EINVAL;
 
-	scsi_remove_lun(sdev);
-	error = 0;
+	devfs_unregister(sdev->de);
+	scsi_device_unregister(sdev);
 
-out:
-	scsi_host_put(shost);
-	return error;
+	scsi_free_sdev(sdev);
+	return 0;
 }
 
 /**
@@ -1776,9 +1733,8 @@
 	 * Scan LUN 0, if there is some response, scan further. Ideally, we
 	 * would not configure LUN 0 until all LUNs are scanned.
 	 */
-	res = scsi_probe_and_add_lun(shost, q, channel, id, 0, &bflags);
+	res = scsi_probe_and_add_lun(shost, q, channel, id, 0, &bflags, &sdev);
 	if (res == SCSI_SCAN_LUN_PRESENT) {
-		sdev = scsi_find_device(shost, channel, id, 0);
 		if (scsi_report_lun_scan(sdev, q, bflags) != 0)
 			/*
 			 * The REPORT LUN did not scan the target,
@@ -1844,9 +1800,13 @@
 void scsi_forget_host(struct Scsi_Host *shost)
 {
 	struct list_head *le, *lh;
+	struct scsi_device *sdev;
 
-	list_for_each_safe(le, lh, &shost->my_devices)
-		scsi_remove_lun(list_entry(le, struct scsi_device, siblings));
+	list_for_each_safe(le, lh, &shost->my_devices) {
+		sdev = list_entry(le, struct scsi_device, siblings);
+		
+		scsi_remove_device(sdev);
+	}
 }
 
 /*
--- 1.26/drivers/scsi/scsi_syms.c	Tue Feb  4 19:29:25 2003
+++ edited/drivers/scsi/scsi_syms.c	Fri Feb 21 19:45:47 2003
@@ -80,6 +80,8 @@
 EXPORT_SYMBOL(scsi_slave_detach);
 EXPORT_SYMBOL(scsi_device_get);
 EXPORT_SYMBOL(scsi_device_put);
+EXPORT_SYMBOL(scsi_add_device);
+EXPORT_SYMBOL(scsi_remove_device);
 
 /*
  * This symbol is for the highlevel drivers (e.g. sg) only.
