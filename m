From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] cleanup code for /proc add/remove single device
Date: Thu, 21 Nov 2002 02:23:14 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021121022314.A8931@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

two new helpers in scsi_scan.c: scsi_add_single_device and
scsi_remove_single_device that do all hard work.  Thanks to
beeing in scsi_scan.c and using proper helpers they're a lot
smaller and cleaner.


--- 1.44/drivers/scsi/scsi.h	Sun Nov 17 16:44:35 2002
+++ edited/drivers/scsi/scsi.h	Thu Nov 21 01:05:39 2002
@@ -525,6 +525,8 @@
 extern struct scsi_device *scsi_alloc_sdev(struct Scsi_Host *,
 			uint, uint, uint);
 extern void scsi_free_sdev(struct scsi_device *);
+extern int scsi_add_single_device(uint, uint, uint, uint);
+extern int scsi_remove_single_device(uint, uint, uint, uint);
 
 /*
  * Prototypes for functions in constants.c
===== drivers/scsi/scsi_proc.c 1.9 vs edited =====
--- 1.9/drivers/scsi/scsi_proc.c	Sun Nov 17 16:49:06 2002
+++ edited/drivers/scsi/scsi_proc.c	Thu Nov 21 01:17:50 2002
@@ -399,11 +399,8 @@
 static int proc_scsi_gen_write(struct file * file, const char * buf,
                               unsigned long length, void *data)
 {
-	Scsi_Device *sdev;
-	struct Scsi_Host *shost;
-	char *p;
 	int host, channel, id, lun;
-	char * buffer;
+	char *buffer, *p;
 	int err;
 
 	if (!buf || length>PAGE_SIZE)
@@ -529,35 +526,9 @@
 		id = simple_strtoul(p + 1, &p, 0);
 		lun = simple_strtoul(p + 1, &p, 0);
 
-		printk(KERN_INFO "scsi singledevice %d %d %d %d\n", host, channel,
-		       id, lun);
-
-		for (shost = scsi_host_get_next(NULL); shost;
-		     shost = scsi_host_get_next(shost)) {
-			if (shost->host_no == host) {
-				break;
-			}
-		}
-		err = -ENXIO;
-		if (!shost)
-			goto out;
-
-		for (sdev = shost->host_queue; sdev; sdev = sdev->next) {
-			if ((sdev->channel == channel
-			     && sdev->id == id
-			     && sdev->lun == lun)) {
-				break;
-			}
-		}
-
-		err = -ENOSYS;
-		if (sdev)
-			goto out;	/* We do not yet support unplugging */
-
-		scan_scsis(shost, 1, channel, id, lun);
-		err = length;
-		goto out;
-	}
+		err = scsi_add_single_device(host, channel, id, lun);
+		if (err >= 0)
+			err = length;
 	/*
 	 * Usage: echo "scsi remove-single-device 0 1 2 3" >/proc/scsi/scsi
 	 * with  "0 1 2 3" replaced by your "Host Channel Id Lun".
@@ -569,7 +540,7 @@
 	 *     hardware and thoroughly confuse the SCSI subsystem.
 	 *
 	 */
-	else if (!strncmp("remove-single-device", buffer + 5, 20)) {
+	} else if (!strncmp("remove-single-device", buffer + 5, 20)) {
 		p = buffer + 26;
 
 		host = simple_strtoul(p, &p, 0);
@@ -577,39 +548,7 @@
 		id = simple_strtoul(p + 1, &p, 0);
 		lun = simple_strtoul(p + 1, &p, 0);
 
-
-		for (shost = scsi_host_get_next(NULL); shost;
-		     shost = scsi_host_get_next(shost)) {
-			if (shost->host_no == host) {
-				break;
-			}
-		}
-		err = -ENODEV;
-		if (!shost)
-			goto out;
-
-		for (sdev = shost->host_queue; sdev; sdev = sdev->next) {
-			if ((sdev->channel == channel
-			     && sdev->id == id
-			     && sdev->lun == lun)) {
-				break;
-			}
-		}
-
-		if (sdev == NULL)
-			goto out;	/* there is no such device attached */
-
-		err = -EBUSY;
-		if (sdev->access_count)
-			goto out;
-
-		scsi_detach_device(sdev);
-
-		if (sdev->attached == 0) {
-			devfs_unregister (sdev->de);
-			scsi_free_sdev(sdev);
-			err = 0;
-		}
+		err = scsi_remove_single_device(host, channel, id, lun);
 	}
 out:
 	
===== drivers/scsi/scsi_scan.c 1.38 vs edited =====
--- 1.38/drivers/scsi/scsi_scan.c	Sun Nov 17 16:47:20 2002
+++ edited/drivers/scsi/scsi_scan.c	Thu Nov 21 01:16:03 2002
@@ -1862,6 +1862,69 @@
 
 }
 
+int scsi_add_single_device(uint host, uint channel, uint id, uint lun)
+{
+	struct scsi_device *sdevscan, *sdev;
+	struct Scsi_Host *shost;
+	int error = -ENODEV;
+
+	shost = scsi_host_hn_get(host);
+	if (!shost)
+		return -ENODEV;
+	sdev = scsi_find_device(shost, channel, id, lun);
+	if (!sdev)
+		goto out;
+
+	error = -ENOMEM;
+	sdevscan = scsi_alloc_sdev(shost, channel, id, lun);
+	if (!sdevscan)
+		goto out;
+
+	sdevscan->scsi_level = scsi_find_scsi_level(channel, id, shost);
+	error = scsi_probe_and_add_lun(sdevscan, &sdev, NULL);
+	scsi_free_sdev(sdevscan);
+
+	error = -ENODEV;
+	if (error != SCSI_SCAN_LUN_PRESENT) 
+		goto out;
+
+	scsi_attach_device(sdev);
+	error = 0;
+
+out:
+	scsi_host_put(shost);
+	return error;
+}
+
+int scsi_remove_single_device(uint host, uint channel, uint id, uint lun)
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
+
+	error = -EBUSY;
+	if (sdev->access_count)
+		goto out;
+	scsi_detach_device(sdev);
+	if (sdev->attached)
+		goto out;
+
+	devfs_unregister(sdev->de);
+	scsi_free_sdev(sdev);
+	error = 0;
+
+out:
+	scsi_host_put(shost);
+	return error;
+}
+
 /**
  * scsi_scan_target - scan a target id, possibly including all LUNs on the
  *     target.
