From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH 2/3] scsi_forget_host - scsi_debug usage
Date: Mon, 14 Jun 2004 15:06:19 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040614130619.GH1970@suse.de>
References: <20040612041930.GA21105@us.ibm.com> <20040612042106.GB21105@us.ibm.com> <20040612042232.GC21105@us.ibm.com> <20040614080632.GA7114@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:2437 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262006AbUFNNGX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jun 2004 09:06:23 -0400
Content-Disposition: inline
In-Reply-To: <20040614080632.GA7114@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Mon, Jun 14 2004, Christoph Hellwig wrote:
> On Fri, Jun 11, 2004 at 09:22:32PM -0700, Mike Anderson wrote:
> > DESC
> > scsi_forget_host - scsi_debug usage
> > 
> > Use the export scsi_forget_host interface to remove child scsi devices
> > from the scsi_host prior to removal.
> 
> Moving this into drivers sounds like a rather bad idea.  But with our

Agree

> refcounting in place I wonder whether moving scsi_forget_host first in
> scsi_remove_host wouldn't simply work.

It doesn't, device has already been deleted there. So either that needs
to be reworked if we want to allow devices to talk to themselves from
->remove(), or we just move the sync cache call to sd_release() instead.

The latter is attached.

===== drivers/scsi/sd.c 1.151 vs edited =====
--- 1.151/drivers/scsi/sd.c	2004-05-29 19:50:44 +02:00
+++ edited/drivers/scsi/sd.c	2004-06-14 15:05:34 +02:00
@@ -108,7 +108,6 @@
 
 static int sd_probe(struct device *);
 static int sd_remove(struct device *);
-static void sd_shutdown(struct device *dev);
 static void sd_rescan(struct device *);
 static int sd_init_command(struct scsi_cmnd *);
 static void sd_read_capacity(struct scsi_disk *sdkp, char *diskname,
@@ -120,7 +119,6 @@
 		.name		= "sd",
 		.probe		= sd_probe,
 		.remove		= sd_remove,
-		.shutdown	= sd_shutdown,
 	},
 	.rescan			= sd_rescan,
 	.init_command		= sd_init_command,
@@ -402,6 +400,50 @@
 	return 1;
 }
 
+/*
+ * Send a SYNCHRONIZE CACHE instruction down to the device through
+ * the normal SCSI command structure.  Wait for the command to
+ * complete.
+ */
+static void sd_sync_cache(struct scsi_device *sdp)
+{
+	struct scsi_request *sreq;
+	int retries, res;
+
+	sreq = scsi_allocate_request(sdp, GFP_KERNEL);
+	if (!sreq) {
+		printk("FAILED\n  No memory for request\n");
+		return;
+	}
+
+	sreq->sr_data_direction = DMA_NONE;
+	for (retries = 3; retries > 0; --retries) {
+		unsigned char cmd[10] = { 0 };
+
+		cmd[0] = SYNCHRONIZE_CACHE;
+		/*
+		 * Leave the rest of the command zero to indicate
+		 * flush everything.
+		 */
+		scsi_wait_req(sreq, cmd, NULL, 0, SD_TIMEOUT, SD_MAX_RETRIES);
+		if (sreq->sr_result == 0)
+			break;
+	}
+
+	res = sreq->sr_result;
+	if (res) {
+		printk(KERN_WARNING "FAILED\n  status = %x, message = %02x, "
+				    "host = %d, driver = %02x\n  ",
+				    status_byte(res), msg_byte(res),
+				    host_byte(res), driver_byte(res));
+			if (driver_byte(res) & DRIVER_SENSE)
+				print_req_sense("sd", sreq);
+	}
+	
+	scsi_release_request(sreq);
+	printk("\n");
+}
+
 /**
  *	sd_open - open a scsi disk device
  *	@inode: only i_rdev member may be used
@@ -498,8 +540,9 @@
 
 	SCSI_LOG_HLQUEUE(3, printk("sd_release: disk=%s\n", disk->disk_name));
 
-	if (!--sdkp->openers && sdev->removable) {
-		if (scsi_block_when_processing_errors(sdev))
+	if (!--sdkp->openers) {
+		sd_sync_cache(sdev);
+		if (sdev->removable && scsi_block_when_processing_errors(sdev))
 			scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);
 	}
 
@@ -1460,7 +1503,6 @@
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
 	del_gendisk(sdkp->disk);
-	sd_shutdown(dev);
 	down(&sd_ref_sem);
 	kref_put(&sdkp->kref);
 	up(&sd_ref_sem);
@@ -1492,62 +1534,6 @@
 
 	kfree(sdkp);
 }
-
-/*
- * Send a SYNCHRONIZE CACHE instruction down to the device through
- * the normal SCSI command structure.  Wait for the command to
- * complete.
- */
-static void sd_shutdown(struct device *dev)
-{
-	struct scsi_device *sdp = to_scsi_device(dev);
-	struct scsi_disk *sdkp;
-	struct scsi_request *sreq;
-	int retries, res;
-
-	sdkp = dev_get_drvdata(dev);
-	if (!sdkp)
-               return;         /* this can happen */
-
-	if (!scsi_device_online(sdp) || !sdkp->WCE)
-		return;
-
-	printk(KERN_NOTICE "Synchronizing SCSI cache for disk %s: ",
-			sdkp->disk->disk_name);
-
-	sreq = scsi_allocate_request(sdp, GFP_KERNEL);
-	if (!sreq) {
-		printk("FAILED\n  No memory for request\n");
-		return;
-	}
-
-	sreq->sr_data_direction = DMA_NONE;
-	for (retries = 3; retries > 0; --retries) {
-		unsigned char cmd[10] = { 0 };
-
-		cmd[0] = SYNCHRONIZE_CACHE;
-		/*
-		 * Leave the rest of the command zero to indicate
-		 * flush everything.
-		 */
-		scsi_wait_req(sreq, cmd, NULL, 0, SD_TIMEOUT, SD_MAX_RETRIES);
-		if (sreq->sr_result == 0)
-			break;
-	}
-
-	res = sreq->sr_result;
-	if (res) {
-		printk(KERN_WARNING "FAILED\n  status = %x, message = %02x, "
-				    "host = %d, driver = %02x\n  ",
-				    status_byte(res), msg_byte(res),
-				    host_byte(res), driver_byte(res));
-			if (driver_byte(res) & DRIVER_SENSE)
-				print_req_sense("sd", sreq);
-	}
-	
-	scsi_release_request(sreq);
-	printk("\n");
-}	
 
 /**
  *	init_sd - entry point for this driver (both when built in or when

-- 
Jens Axboe

