From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix possible NULL pointer dereference in scsi_scan.c
Date: Tue, 11 Mar 2003 20:12:27 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030311201227.A986@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

If the sdev allocation fails and q is non-null we could dereference
sdev->request_queue.  While at it reformat the function to use
goto-based cleanup - that's much easier to parse.


--- 1.64/drivers/scsi/scsi_scan.c	Fri Mar  7 01:02:09 2003
+++ edited/drivers/scsi/scsi_scan.c	Mon Mar 10 14:23:23 2003
@@ -385,83 +385,92 @@
 	struct scsi_device *sdev, *device;
 
 	sdev = kmalloc(sizeof(*sdev), GFP_ATOMIC);
-	if (sdev != NULL) {
-		memset(sdev, 0, sizeof(Scsi_Device));
-		sdev->vendor = scsi_null_device_strs;
-		sdev->model = scsi_null_device_strs;
-		sdev->rev = scsi_null_device_strs;
-		sdev->host = shost;
-		sdev->id = id;
-		sdev->lun = lun;
-		sdev->channel = channel;
-		sdev->online = TRUE;
-		INIT_LIST_HEAD(&sdev->siblings);
-		INIT_LIST_HEAD(&sdev->same_target_siblings);
-		INIT_LIST_HEAD(&sdev->cmd_list);
-		spin_lock_init(&sdev->list_lock);
-		/*
-		 * Some low level driver could use device->type
-		 */
-		sdev->type = -1;
-		/*
-		 * Assume that the device will have handshaking problems,
-		 * and then fix this field later if it turns out it
-		 * doesn't
-		 */
-		sdev->borken = 1;
-
-		if (!q || *q == NULL) {
-			sdev->request_queue = scsi_alloc_queue(shost);
-			if (!sdev->request_queue)
-				goto out_bail;
-		} else {
-			sdev->request_queue = *q;
-			*q = NULL;
-		}
+	if (!sdev)
+		goto out;
+
+	memset(sdev, 0, sizeof(*sdev));
+	sdev->vendor = scsi_null_device_strs;
+	sdev->model = scsi_null_device_strs;
+	sdev->rev = scsi_null_device_strs;
+	sdev->host = shost;
+	sdev->id = id;
+	sdev->lun = lun;
+	sdev->channel = channel;
+	sdev->online = TRUE;
+	INIT_LIST_HEAD(&sdev->siblings);
+	INIT_LIST_HEAD(&sdev->same_target_siblings);
+	INIT_LIST_HEAD(&sdev->cmd_list);
+	spin_lock_init(&sdev->list_lock);
+
+	/*
+	 * Some low level driver could use device->type
+	 */
+	sdev->type = -1;
+
+	/*
+	 * Assume that the device will have handshaking problems,
+	 * and then fix this field later if it turns out it
+	 * doesn't
+	 */
+	sdev->borken = 1;
+
+	if (!q || *q == NULL) {
+		sdev->request_queue = scsi_alloc_queue(shost);
+		if (!sdev->request_queue)
+			goto out_free_dev;
+	} else {
+		sdev->request_queue = *q;
+		*q = NULL;
+	}
+
+	sdev->request_queue->queuedata = sdev;
+	scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
+	init_waitqueue_head(&sdev->scpnt_wait);
 
-		sdev->request_queue->queuedata = sdev;
-		scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
-		init_waitqueue_head(&sdev->scpnt_wait);
-
-		if (shost->hostt->slave_alloc)
-			if (shost->hostt->slave_alloc(sdev)) {
-				goto out_bail;
-			}
-		/*
-		 * If there are any same target siblings, add this to the
-		 * sibling list
-		 */
-		list_for_each_entry(device, &shost->my_devices, siblings) {
-			if(device->id == sdev->id &&
-			   device->channel == sdev->channel) {
-				list_add_tail(&sdev->same_target_siblings,
-					      &device->same_target_siblings);
-				sdev->scsi_level = device->scsi_level;
-				break;
-			}
+	if (shost->hostt->slave_alloc) {
+		if (shost->hostt->slave_alloc(sdev))
+			goto out_free_queue;
+	}
+
+	/*
+	 * If there are any same target siblings, add this to the
+	 * sibling list
+	 */
+	list_for_each_entry(device, &shost->my_devices, siblings) {
+		if (device->id == sdev->id &&
+		    device->channel == sdev->channel) {
+			list_add_tail(&sdev->same_target_siblings,
+				      &device->same_target_siblings);
+			sdev->scsi_level = device->scsi_level;
+			break;
 		}
-		/*
-		 * If there wasn't another lun already configured at this
-		 * target, then default this device to SCSI_2 until we
-		 * know better
-		 */
-		if(!sdev->scsi_level)
-			sdev->scsi_level = SCSI_2;
-		/*
-		 * Add it to the end of the shost->my_devices list.
-		 */
-		list_add_tail(&sdev->siblings, &shost->my_devices);
-		return (sdev);
 	}
-out_bail:
-	printk(ALLOC_FAILURE_MSG, __FUNCTION__);
+
+	/*
+	 * If there wasn't another lun already configured at this
+	 * target, then default this device to SCSI_2 until we
+	 * know better
+	 */
+	if (!sdev->scsi_level)
+		sdev->scsi_level = SCSI_2;
+
+	/*
+	 * Add it to the end of the shost->my_devices list.
+	 */
+	list_add_tail(&sdev->siblings, &shost->my_devices);
+	return sdev;
+
+out_free_queue:
 	if (q && sdev->request_queue) {
 		*q = sdev->request_queue;
 		sdev->request_queue = NULL;
 	} else if (sdev->request_queue)
 		scsi_free_queue(sdev->request_queue);
 
+out_free_dev:
 	kfree(sdev);
+out:
+	printk(ALLOC_FAILURE_MSG, __FUNCTION__);
 	return NULL;
 }
 
