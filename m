From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH][RESEND] remove scsi_slave_attach/scsi_slave_detach
Date: Wed, 7 May 2003 14:57:50 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030507145750.B10284@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:37636 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S263156AbTEGMpS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 May 2003 08:45:18 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

I added those two to factor out common code from the upper drivers
a long time ago, but after Doug & Lubens nice work there's nothing
left but incrementing/decrementing a counter in struct scsi_device
that's never used except in the case were we not it must be NULL
because we just walked the chain of drivers to detach every single
one..



--- 1.42/drivers/scsi/osst.c	Fri Apr 18 17:58:31 2003
+++ edited/drivers/scsi/osst.c	Wed May  7 14:15:37 2003
@@ -5397,15 +5397,10 @@
 	if (SDp->type != TYPE_TAPE || !osst_supports(SDp))
 		return 1;
 
-	if (scsi_slave_attach(SDp)) {
-		printk(KERN_ERR "osst :E: Failed to attach scsi slave.\n");
-		return 1;
-	}
-
 	drive = alloc_disk(1);
 	if (!drive) {
 		printk(KERN_ERR "osst :E: Out of memory. Device not attached.\n");
-		goto out_slave_detach;
+		return 1;
 	}
 
 	/* if this is the first attach, build the infrastructure */
@@ -5581,8 +5576,6 @@
 
 out_put_disk:
         put_disk(drive);
-out_slave_detach:
-        scsi_slave_detach(SDp);
         return 1;
 };
 
@@ -5605,7 +5598,6 @@
 		devfs_unregister_tape(tpnt->drive->number);
 		put_disk(tpnt->drive);
 		os_scsi_tapes[i] = NULL;
-		scsi_slave_detach(SDp);
 		osst_nr_dev--;
 		write_unlock(&os_scsi_tapes_lock);
 		for (mode = 0; mode < ST_NBR_MODES; ++mode) {
--- 1.109/drivers/scsi/scsi.c	Tue Apr 29 19:40:45 2003
+++ edited/drivers/scsi/scsi.c	Wed May  7 14:15:44 2003
@@ -187,14 +197,7 @@
  */
 void scsi_release_request(struct scsi_request *sreq)
 {
-	if (likely(sreq->sr_command != NULL)) {
-    		struct request_queue *q = sreq->sr_device->request_queue;
-
-		scsi_put_command(sreq->sr_command);
-		sreq->sr_command = NULL;
-		scsi_queue_next_request(q, NULL);
-	}
-
+	__scsi_release_request(sreq);
 	kfree(sreq);
 }
 
@@ -1274,39 +1277,6 @@
 	} else {
 		/* FIXME: Send online state change hotplug event */
 	}
-}
-
-/*
- * Function:	scsi_slave_attach()
- *
- * Purpose:	Called from the upper level driver attach to handle common
- * 		attach code.
- *
- * Arguments:	sdev - scsi_device to attach
- *
- * Returns:	1 on error, 0 on succes
- *
- * Lock Status:	Protected via scsi_devicelist_mutex.
- */
-int scsi_slave_attach(struct scsi_device *sdev)
-{
-	sdev->attached++;
-	return 0;
-}
-
-/*
- * Function:	scsi_slave_detach()
- *
- * Purpose:	Called from the upper level driver attach to handle common
- * 		detach code.
- *
- * Arguments:	sdev - struct scsi_device to detach
- *
- * Lock Status:	Protected via scsi_devicelist_mutex.
- */
-void scsi_slave_detach(struct scsi_device *sdev)
-{
-	sdev->attached--;
 }
 
 /*
--- 1.78/drivers/scsi/scsi.h	Sun Apr 27 12:45:24 2003
+++ edited/drivers/scsi/scsi.h	Wed May  7 14:15:38 2003
@@ -261,8 +261,6 @@
 extern void scsi_put_command(struct scsi_cmnd *cmd);
 extern void scsi_adjust_queue_depth(Scsi_Device *, int, int);
 extern int scsi_track_queue_full(Scsi_Device *, int);
-extern int scsi_slave_attach(struct scsi_device *);
-extern void scsi_slave_detach(struct scsi_device *);
 extern int scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
 extern void scsi_set_device_offline(struct scsi_device *);
@@ -344,8 +342,6 @@
 					 * vendor-specific cmd's */
 	unsigned sector_size;	/* size in bytes */
 
-	int attached;		/* # of high level drivers attached to 
-				 * this */
 	int access_count;	/* Count of open channels/mounts */
 
 	void *hostdata;		/* available to low-level driver */
--- 1.83/drivers/scsi/scsi_scan.c	Thu May  1 20:10:59 2003
+++ edited/drivers/scsi/scsi_scan.c	Wed May  7 14:16:03 2003
@@ -1269,9 +1269,6 @@
 int scsi_remove_device(struct scsi_device *sdev)
 {
 	scsi_detach_device(sdev);
-	if (sdev->attached)
-		return -EINVAL;
-
 	scsi_device_unregister(sdev);
 	return 0;
 }
--- 1.33/drivers/scsi/scsi_syms.c	Thu May  1 18:44:51 2003
+++ edited/drivers/scsi/scsi_syms.c	Wed May  7 14:24:01 2003
@@ -77,8 +77,6 @@
 
 EXPORT_SYMBOL(scsi_io_completion);
 
-EXPORT_SYMBOL(scsi_slave_attach);
-EXPORT_SYMBOL(scsi_slave_detach);
 EXPORT_SYMBOL(scsi_device_get);
 EXPORT_SYMBOL(scsi_device_put);
 EXPORT_SYMBOL(scsi_add_device);
--- 1.110/drivers/scsi/sd.c	Fri Apr 25 14:51:41 2003
+++ edited/drivers/scsi/sd.c	Wed May  7 14:15:39 2003
@@ -1302,14 +1302,10 @@
 	SCSI_LOG_HLQUEUE(3, printk("sd_attach: scsi device: <%d,%d,%d,%d>\n", 
 			 sdp->host->host_no, sdp->channel, sdp->id, sdp->lun));
 
-	error = scsi_slave_attach(sdp);
-	if (error)
-		goto out;
-
 	error = -ENOMEM;
 	sdkp = kmalloc(sizeof(*sdkp), GFP_KERNEL);
 	if (!sdkp)
-		goto out_detach;
+		goto out;
 
 	gd = alloc_disk(16);
 	if (!gd)
@@ -1368,8 +1364,6 @@
 	put_disk(gd);
 out_free:
 	kfree(sdkp);
-out_detach:
-	scsi_slave_detach(sdp);
 out:
 	return error;
 }
@@ -1406,7 +1400,6 @@
 
 	sd_devlist_remove(sdkp);
 	del_gendisk(sdkp->disk);
-	scsi_slave_detach(sdp);
 
 	spin_lock(&sd_index_lock);
 	clear_bit(sdkp->index, sd_index_bits);
--- 1.53/drivers/scsi/sg.c	Sat Apr 26 22:04:25 2003
+++ edited/drivers/scsi/sg.c	Wed May  7 14:15:40 2003
@@ -1359,10 +1359,6 @@
 	if (!disk)
 		return -ENOMEM;
 
-	error = scsi_slave_attach(scsidp);
-	if (error)
-		goto out_put;
-		
 	write_lock_irqsave(&sg_dev_arr_lock, iflags);
 	if (sg_nr_dev >= sg_dev_max) {	/* try to resize */
 		Sg_device **tmp_da;
@@ -1375,7 +1371,7 @@
 			printk(KERN_ERR
 			       "sg_attach: device array cannot be resized\n");
 			error = -ENOMEM;
-			goto out_detach;
+			goto out;
 		}
 		write_lock_irqsave(&sg_dev_arr_lock, iflags);
 		memset(tmp_da, 0, tmp_dev_max * sizeof (Sg_device *));
@@ -1400,7 +1396,7 @@
 		if (NULL != sdp)
 			vfree((char *) sdp);
 		error = -ENODEV;
-		goto out_detach;
+		goto out;
 	}
 	if (k < sg_dev_max) {
 		if (NULL == sdp) {
@@ -1416,7 +1412,7 @@
 		write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
 		printk(KERN_ERR "sg_attach: Sg_device cannot be allocated\n");
 		error = -ENOMEM;
-		goto out_detach;
+		goto out;
 	}
 
 	SCSI_LOG_TIMEOUT(3, printk("sg_attach: dev=%d \n", k));
@@ -1473,9 +1469,7 @@
 	}
 	return 0;
 
-out_detach:
-	scsi_slave_detach(scsidp);
-out_put:
+out:
 	put_disk(disk);
 	return error;
 }
@@ -1526,7 +1520,6 @@
 			SCSI_LOG_TIMEOUT(3, printk("sg_detach: dev=%d\n", k));
 			sg_dev_arr[k] = NULL;
 		}
-		scsi_slave_detach(scsidp);
 		sg_nr_dev--;
 		break;
 	}
--- 1.77/drivers/scsi/sr.c	Sat Apr 26 22:04:25 2003
+++ edited/drivers/scsi/sr.c	Wed May  7 14:15:41 2003
@@ -515,10 +515,6 @@
 	if (sdev->type != TYPE_ROM && sdev->type != TYPE_WORM)
 		return 1;
 
-	error = scsi_slave_attach(sdev);
-	if (error)
-		return error;
-
 	error = -ENOMEM;
 	cd = kmalloc(sizeof(*cd), GFP_KERNEL);
 	if (!cd)
@@ -592,7 +588,6 @@
 fail_free:
 	kfree(cd);
 fail:
-	scsi_slave_detach(sdev);
 	return error;
 }
 
@@ -820,7 +815,6 @@
 		return;
 
 	sr_devlist_remove(cd);
-	scsi_slave_detach(SDp);
 	del_gendisk(cd->disk);
 
 	spin_lock(&sr_index_lock);
--- 1.60/drivers/scsi/st.c	Fri Apr 18 17:58:31 2003
+++ edited/drivers/scsi/st.c	Wed May  7 14:15:41 2003
@@ -3725,16 +3725,13 @@
 		return 1;
 	}
 
-	if (scsi_slave_attach(SDp))
-		return 1;
-
 	i = SDp->host->sg_tablesize;
 	if (st_max_sg_segs < i)
 		i = st_max_sg_segs;
 	buffer = new_tape_buffer(TRUE, (SDp->host)->unchecked_isa_dma, i);
 	if (buffer == NULL) {
 		printk(KERN_ERR "st: Can't allocate new tape buffer. Device not attached.\n");
-		goto out_slave_detach;
+		goto out;
 	}
 
 	disk = alloc_disk(1);
@@ -3923,8 +3920,7 @@
 	put_disk(disk);
 out_buffer_free:
 	kfree(buffer);
-out_slave_detach:
-	scsi_slave_detach(SDp);
+out:
 	return 1;
 };
 
@@ -3962,7 +3958,6 @@
 				normalize_buffer(tpnt->buffer);
 				kfree(tpnt->buffer);
 			}
-			scsi_slave_detach(SDp);
 			put_disk(tpnt->disk);
 			kfree(tpnt);
 			return;
