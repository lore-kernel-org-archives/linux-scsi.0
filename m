From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [RFC] target code updates to support scanned targets
Date: Tue, 15 Feb 2005 16:38:23 -0600
Message-ID: <1108507103.5539.73.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:34533 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261921AbVBOWi0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Feb 2005 17:38:26 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j1FMcOA03023
	for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2005 17:38:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Since everyone's been asking for the ability to do target scanning, I
took a look at how this might be done in our current infrastructure.
The attached patch does three things:

1. Pulls target allocation forward so it's now allocated and destroyed
as a separate entity instead of being bound into device (LUN) allocation
2. rejig the scanning code to do target scanning via a parent generic
device rather than the HCTL numbers.
3. Exported the modified scsi_scan_target and scsi_remove_target.
4. moved our sibling lists into the target.

Immediately for iscsi and fc, this should give the ability to parent a
scanned target to something not necessarily a scsi host (needed for the
rport work) and also both of you should now be able to remove
scsi_scan_host() from your drivers.

Anyway, give it the once over and tell me what you think.

James

===== drivers/scsi/hosts.c 1.107 vs edited =====
--- 1.107/drivers/scsi/hosts.c	2005-01-18 13:15:06 -06:00
+++ edited/drivers/scsi/hosts.c	2005-02-13 18:29:58 -06:00
@@ -216,6 +216,7 @@
 	spin_lock_init(&shost->default_lock);
 	scsi_assign_lock(shost, &shost->default_lock);
 	INIT_LIST_HEAD(&shost->__devices);
+	INIT_LIST_HEAD(&shost->__targets);
 	INIT_LIST_HEAD(&shost->eh_cmd_q);
 	INIT_LIST_HEAD(&shost->starved_list);
 	init_waitqueue_head(&shost->host_wait);
===== drivers/scsi/scsi_lib.c 1.148 vs edited =====
--- 1.148/drivers/scsi/scsi_lib.c	2005-02-01 10:49:23 -06:00
+++ edited/drivers/scsi/scsi_lib.c	2005-02-14 17:05:02 -06:00
@@ -365,10 +365,11 @@
 {
 	struct Scsi_Host *shost = current_sdev->host;
 	struct scsi_device *sdev, *tmp;
+	struct scsi_target *starget = scsi_target(current_sdev);
 	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	scsi_target(current_sdev)->starget_sdev_user = NULL;
+	starget->starget_sdev_user = NULL;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	/*
@@ -380,10 +381,12 @@
 	blk_run_queue(current_sdev->request_queue);
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	if (scsi_target(current_sdev)->starget_sdev_user)
+	if (starget->starget_sdev_user)
 		goto out;
-	list_for_each_entry_safe(sdev, tmp, &current_sdev->same_target_siblings,
+	list_for_each_entry_safe(sdev, tmp, &starget->devices,
 			same_target_siblings) {
+		if (sdev == current_sdev)
+			continue;
 		if (scsi_device_get(sdev))
 			continue;
 
===== drivers/scsi/scsi_scan.c 1.140 vs edited =====
--- 1.140/drivers/scsi/scsi_scan.c	2005-01-18 13:15:06 -06:00
+++ edited/drivers/scsi/scsi_scan.c	2005-02-15 16:11:55 -06:00
@@ -200,12 +200,12 @@
  * Return value:
  *     scsi_Device pointer, or NULL on failure.
  **/
-static struct scsi_device *scsi_alloc_sdev(struct Scsi_Host *shost,
-	       	uint channel, uint id, uint lun, void *hostdata)
+static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
+					   unsigned int lun, void *hostdata)
 {
 	struct scsi_device *sdev;
-	unsigned long flags;
 	int display_failure_msg = 1, ret;
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 
 	sdev = kmalloc(sizeof(*sdev) + shost->transportt->device_size,
 		       GFP_ATOMIC);
@@ -217,9 +217,9 @@
 	sdev->model = scsi_null_device_strs;
 	sdev->rev = scsi_null_device_strs;
 	sdev->host = shost;
-	sdev->id = id;
+	sdev->id = starget->id;
 	sdev->lun = lun;
-	sdev->channel = channel;
+	sdev->channel = starget->channel;
 	sdev->sdev_state = SDEV_CREATED;
 	INIT_LIST_HEAD(&sdev->siblings);
 	INIT_LIST_HEAD(&sdev->same_target_siblings);
@@ -227,6 +227,9 @@
 	INIT_LIST_HEAD(&sdev->starved_entry);
 	spin_lock_init(&sdev->list_lock);
 
+	sdev->sdev_gendev.parent = get_device(&starget->dev);
+	sdev->sdev_target = starget;
+
 	/* usually NULL and set by ->slave_alloc instead */
 	sdev->hostdata = hostdata;
 
@@ -248,8 +251,12 @@
 
 	spin_lock_init(&sdev->sdev_lock);
 	sdev->request_queue = scsi_alloc_queue(sdev);
-	if (!sdev->request_queue)
-		goto out_free_dev;
+	if (!sdev->request_queue) {
+		/* release fn is set up in scsi_sysfs_device_initialise, so
+		 * have to free and put manually here */
+		put_device(&starget->dev);
+		goto out;
+	}
 
 	sdev->request_queue->queuedata = sdev;
 	scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
@@ -269,32 +276,117 @@
 		}
 	}
 
-	/* NOTE: this target initialisation code depends critically on
-	 * lun scanning being sequential. */
-	if (scsi_sysfs_target_initialize(sdev))
-		goto out_remove_siblings;
-
 	return sdev;
 
-out_remove_siblings:
-	spin_lock_irqsave(shost->host_lock, flags);
-	list_del(&sdev->siblings);
-	list_del(&sdev->same_target_siblings);
-	spin_unlock_irqrestore(shost->host_lock, flags);
-
-	if (shost->hostt->slave_destroy)
-		shost->hostt->slave_destroy(sdev);
 out_device_destroy:
 	transport_destroy_device(&sdev->sdev_gendev);
 	scsi_free_queue(sdev->request_queue);
-out_free_dev:
-	kfree(sdev);
 out:
 	if (display_failure_msg)
 		printk(ALLOC_FAILURE_MSG, __FUNCTION__);
 	return NULL;
 }
 
+static void scsi_target_dev_release(struct device *dev)
+{
+	struct device *parent = dev->parent;
+	struct scsi_target *starget = to_scsi_target(dev);
+	kfree(starget);
+	put_device(parent);
+}
+
+int scsi_is_target_device(const struct device *dev)
+{
+	return dev->release == scsi_target_dev_release;
+}
+EXPORT_SYMBOL(scsi_is_target_device);
+
+static struct scsi_target *__scsi_find_target(struct device *parent,
+					      int channel, uint id)
+{
+	struct scsi_target *starget, *found_starget = NULL;
+	struct Scsi_Host *shost = dev_to_shost(parent);
+	/*
+	 * Search for an existing target for this sdev.
+	 */
+	list_for_each_entry(starget, &shost->__targets, siblings) {
+		if (starget->id == id &&
+		    starget->channel == channel) {
+			found_starget = starget;
+			break;
+		}
+	}
+	if (found_starget)
+		get_device(&found_starget->dev);
+
+	return found_starget;
+}
+
+static struct scsi_target *scsi_alloc_target(struct device *parent,
+					     int channel, uint id)
+{
+	struct Scsi_Host *shost = dev_to_shost(parent);
+	struct device *dev = NULL;
+	unsigned long flags;
+	const int size = sizeof(struct scsi_target)
+		+ shost->transportt->target_size;
+	struct scsi_target *starget = kmalloc(size, GFP_ATOMIC);
+	struct scsi_target *found_target;
+
+	if (!starget) {
+		printk(KERN_ERR "%s: allocation failure\n", __FUNCTION__);
+		return NULL;
+	}
+	memset(starget, 0, size);
+	dev = &starget->dev;
+	device_initialize(dev);
+	starget->reap_ref = 1;
+	dev->parent = get_device(parent);
+	dev->release = scsi_target_dev_release;
+	sprintf(dev->bus_id, "target%d:%d:%d",
+		shost->host_no, channel, id);
+	starget->id = id;
+	starget->channel = channel;
+	INIT_LIST_HEAD(&starget->siblings);
+	INIT_LIST_HEAD(&starget->devices);
+	spin_lock_irqsave(shost->host_lock, flags);
+
+	if ((found_target = __scsi_find_target(parent, channel, id))
+	    != NULL)
+		goto found;
+	list_add_tail(&starget->siblings, &shost->__targets);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	/* allocate and add */
+	transport_setup_device(&starget->dev);
+	device_add(&starget->dev);
+	transport_add_device(&starget->dev);
+	return starget;
+
+ found:
+	found_target->reap_ref++;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	put_device(parent);
+	kfree(starget);
+	return found_target;
+}
+
+void scsi_target_reap(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	unsigned long flags;
+	spin_lock_irqsave(shost->host_lock, flags);
+
+	if (--starget->reap_ref == 0 && list_empty(&starget->devices)) {
+		list_del_init(&starget->siblings);
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		device_del(&starget->dev);
+		transport_unregister_device(&starget->dev);
+		put_device(&starget->dev);
+		return;
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+}
+
 /**
  * scsi_probe_lun - probe a single LUN using a SCSI INQUIRY
  * @sreq:	used to send the INQUIRY
@@ -651,45 +743,49 @@
  *         attached at the LUN
  *     SCSI_SCAN_LUN_PRESENT: a new Scsi_Device was allocated and initialized
  **/
-static int scsi_probe_and_add_lun(struct Scsi_Host *host,
-		uint channel, uint id, uint lun, int *bflagsp,
-		struct scsi_device **sdevp, int rescan, void *hostdata)
+static int scsi_probe_and_add_lun(struct scsi_target *starget,
+				  uint lun, int *bflagsp,
+				  struct scsi_device **sdevp, int rescan,
+				  void *hostdata)
 {
 	struct scsi_device *sdev;
 	struct scsi_request *sreq;
 	unsigned char *result;
 	int bflags, res = SCSI_SCAN_NO_RESPONSE;
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 
 	/*
 	 * The rescan flag is used as an optimization, the first scan of a
 	 * host adapter calls into here with rescan == 0.
 	 */
 	if (rescan) {
-		sdev = scsi_device_lookup(host, channel, id, lun);
+		sdev = scsi_device_lookup(shost, starget->channel,
+					  starget->id, lun);
 		if (sdev) {
 			SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
-				"scsi scan: device exists on <%d:%d:%d:%d>\n",
-				host->host_no, channel, id, lun));
+				"scsi scan: device exists on %s\n",
+				sdev->sdev_gendev.bus_id));
 			if (sdevp)
 				*sdevp = sdev;
+			else
+				scsi_device_put(sdev);
+
 			if (bflagsp)
 				*bflagsp = scsi_get_device_flags(sdev,
 								 sdev->vendor,
 								 sdev->model);
-			/* XXX: bandaid until callers do refcounting */
-			scsi_device_put(sdev);
 			return SCSI_SCAN_LUN_PRESENT;
 		}
 	}
 
-	sdev = scsi_alloc_sdev(host, channel, id, lun, hostdata);
+	sdev = scsi_alloc_sdev(starget, lun, hostdata);
 	if (!sdev)
 		goto out;
 	sreq = scsi_allocate_request(sdev, GFP_ATOMIC);
 	if (!sreq)
 		goto out_free_sdev;
 	result = kmalloc(256, GFP_ATOMIC |
-			(host->unchecked_isa_dma) ? __GFP_DMA : 0);
+			(shost->unchecked_isa_dma) ? __GFP_DMA : 0);
 	if (!result)
 		goto out_free_sreq;
 
@@ -734,8 +830,10 @@
 	scsi_release_request(sreq);
  out_free_sdev:
 	if (res == SCSI_SCAN_LUN_PRESENT) {
-		if (sdevp)
+		if (sdevp) {
+			scsi_device_get(sdev);
 			*sdevp = sdev;
+		}
 	} else {
 		if (sdev->host->hostt->slave_destroy)
 			sdev->host->hostt->slave_destroy(sdev);
@@ -759,14 +857,15 @@
  *
  *     Modifies sdevscan->lun.
  **/
-static void scsi_sequential_lun_scan(struct Scsi_Host *shost, uint channel,
-		uint id, int bflags, int lun0_res, int scsi_level, int rescan)
+static void scsi_sequential_lun_scan(struct scsi_target *starget,
+				     int bflags, int lun0_res, int scsi_level,
+				     int rescan)
 {
 	unsigned int sparse_lun, lun, max_dev_lun;
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 
 	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: Sequential scan of"
-			" host %d channel %d id %d\n", shost->host_no,
-			channel, id));
+				    "%s\n", starget->dev.bus_id));
 
 	max_dev_lun = min(max_scsi_luns, shost->max_lun);
 	/*
@@ -828,8 +927,8 @@
 	 * sparse_lun.
 	 */
 	for (lun = 1; lun < max_dev_lun; ++lun)
-		if ((scsi_probe_and_add_lun(shost, channel, id, lun,
-		      NULL, NULL, rescan, NULL) != SCSI_SCAN_LUN_PRESENT) &&
+		if ((scsi_probe_and_add_lun(starget, lun, NULL, NULL, rescan,
+					    NULL) != SCSI_SCAN_LUN_PRESENT) &&
 		    !sparse_lun)
 			return;
 }
@@ -893,6 +992,7 @@
 	struct scsi_request *sreq;
 	u8 *data;
 	struct scsi_sense_hdr sshdr;
+	struct scsi_target *starget = scsi_target(sdev);
 
 	/*
 	 * Only support SCSI-3 and up devices if BLIST_NOREPORTLUN is not set.
@@ -1043,8 +1143,8 @@
 		} else {
 			int res;
 
-			res = scsi_probe_and_add_lun(sdev->host, sdev->channel,
-				sdev->id, lun, NULL, NULL, rescan, NULL);
+			res = scsi_probe_and_add_lun(starget,
+				lun, NULL, NULL, rescan, NULL);
 			if (res == SCSI_SCAN_NO_RESPONSE) {
 				/*
 				 * Got some results, but now none, abort.
@@ -1071,17 +1171,23 @@
 }
 
 struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
-		uint id, uint lun, void *hostdata)
+				      uint id, uint lun, void *hostdata)
 {
 	struct scsi_device *sdev;
+	struct device *parent = &shost->shost_gendev;
 	int res;
+	struct scsi_target *starget = scsi_alloc_target(parent, channel, id);
+
+	if (!starget)
+		return ERR_PTR(-ENOMEM);
 
 	down(&shost->scan_mutex);
-	res = scsi_probe_and_add_lun(shost, channel, id, lun, NULL,
-				     &sdev, 1, hostdata);
+	res = scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata);
 	if (res != SCSI_SCAN_LUN_PRESENT)
 		sdev = ERR_PTR(-ENODEV);
 	up(&shost->scan_mutex);
+	scsi_target_reap(starget);
+	put_device(&starget->dev);
 
 	return sdev;
 }
@@ -1122,12 +1228,14 @@
  *     First try a REPORT LUN scan, if that does not scan the target, do a
  *     sequential scan of LUNs on the target id.
  **/
-static void scsi_scan_target(struct Scsi_Host *shost, unsigned int channel,
-			     unsigned int id, unsigned int lun, int rescan)
+void scsi_scan_target(struct device *parent, unsigned int channel,
+		      unsigned int id, unsigned int lun, int rescan)
 {
+	struct Scsi_Host *shost = dev_to_shost(parent);
 	int bflags = 0;
 	int res;
-	struct scsi_device *sdev;
+	struct scsi_device *sdev = NULL;
+	struct scsi_target *starget;
 
 	if (shost->this_id == id)
 		/*
@@ -1135,28 +1243,33 @@
 		 */
 		return;
 
+
+	starget = scsi_alloc_target(parent, channel, id);
+
+	if (!starget)
+		return;
+
+	get_device(&starget->dev);
 	if (lun != SCAN_WILD_CARD) {
 		/*
 		 * Scan for a specific host/chan/id/lun.
 		 */
-		scsi_probe_and_add_lun(shost, channel, id, lun, NULL, NULL,
-				       rescan, NULL);
-		return;
+		scsi_probe_and_add_lun(starget, lun, NULL, NULL, rescan, NULL);
+		goto out_reap;
 	}
 
 	/*
 	 * Scan LUN 0, if there is some response, scan further. Ideally, we
 	 * would not configure LUN 0 until all LUNs are scanned.
 	 */
-	res = scsi_probe_and_add_lun(shost, channel, id, 0, &bflags, &sdev,
-				     rescan, NULL);
+	res = scsi_probe_and_add_lun(starget, 0, &bflags, &sdev, rescan, NULL);
 	if (res == SCSI_SCAN_LUN_PRESENT) {
 		if (scsi_report_lun_scan(sdev, bflags, rescan) != 0)
 			/*
 			 * The REPORT LUN did not scan the target,
 			 * do a sequential scan.
 			 */
-			scsi_sequential_lun_scan(shost, channel, id, bflags,
+			scsi_sequential_lun_scan(starget, bflags,
 				       	res, sdev->scsi_level, rescan);
 	} else if (res == SCSI_SCAN_TARGET_PRESENT) {
 		/*
@@ -1165,10 +1278,20 @@
 		 * sequential lun scan with a bflags of SPARSELUN and
 		 * a default scsi level of SCSI_2
 		 */
-		scsi_sequential_lun_scan(shost, channel, id, BLIST_SPARSELUN,
+		scsi_sequential_lun_scan(starget, BLIST_SPARSELUN,
 				SCSI_SCAN_TARGET_PRESENT, SCSI_2, rescan);
 	}
+	if (sdev)
+		scsi_device_put(sdev);
+
+ out_reap:
+	/* now determine if the target has any children at all
+	 * and if not, nuke it */
+	scsi_target_reap(starget);
+
+	put_device(&starget->dev);
 }
+EXPORT_SYMBOL(scsi_scan_target);
 
 static void scsi_scan_channel(struct Scsi_Host *shost, unsigned int channel,
 			      unsigned int id, unsigned int lun, int rescan)
@@ -1193,10 +1316,10 @@
 				order_id = shost->max_id - id - 1;
 			else
 				order_id = id;
-			scsi_scan_target(shost, channel, order_id, lun, rescan);
+			scsi_scan_target(&shost->shost_gendev, channel, order_id, lun, rescan);
 		}
 	else
-		scsi_scan_target(shost, channel, id, lun, rescan);
+		scsi_scan_target(&shost->shost_gendev, channel, id, lun, rescan);
 }
 
 int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
@@ -1247,7 +1370,7 @@
 
 void scsi_forget_host(struct Scsi_Host *shost)
 {
-	struct scsi_device *sdev, *tmp;
+	struct scsi_target *starget, *tmp;
 	unsigned long flags;
 
 	/*
@@ -1260,9 +1383,9 @@
 	 * after that we don't look at sdev anymore.
 	 */
 	spin_lock_irqsave(shost->host_lock, flags);
-	list_for_each_entry_safe(sdev, tmp, &shost->__devices, siblings) {
+	list_for_each_entry_safe(starget, tmp, &shost->__targets, siblings) {
 		spin_unlock_irqrestore(shost->host_lock, flags);
-		scsi_remove_device(sdev);
+		scsi_remove_target(starget);
 		spin_lock_irqsave(shost->host_lock, flags);
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
@@ -1291,11 +1414,18 @@
 struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
 {
 	struct scsi_device *sdev;
+	struct scsi_target *starget;
+
+	starget = scsi_alloc_target(&shost->shost_gendev, 0, shost->this_id);
+	if (!starget)
+		return NULL;
 
-	sdev = scsi_alloc_sdev(shost, 0, shost->this_id, 0, NULL);
+	sdev = scsi_alloc_sdev(starget, 0, NULL);
 	if (sdev) {
+		sdev->sdev_gendev.parent = get_device(&starget->dev);
 		sdev->borken = 0;
 	}
+	put_device(&starget->dev);
 	return sdev;
 }
 EXPORT_SYMBOL(scsi_get_host_dev);
===== drivers/scsi/scsi_sysfs.c 1.67 vs edited =====
--- 1.67/drivers/scsi/scsi_sysfs.c	2005-02-12 14:25:46 -06:00
+++ edited/drivers/scsi/scsi_sysfs.c	2005-02-15 16:31:36 -06:00
@@ -154,33 +154,27 @@
 {
 	struct scsi_device *sdev;
 	struct device *parent;
+	struct scsi_target *starget;
 	unsigned long flags;
-	int delete;
 
 	parent = dev->parent;
 	sdev = to_scsi_device(dev);
+	starget = to_scsi_target(parent);
 
 	spin_lock_irqsave(sdev->host->host_lock, flags);
-	/* If we're the last LUN on the target, destroy the target */
-	delete = list_empty(&sdev->same_target_siblings);
+	if (sdev->reap)
+		starget->reap_ref++;
 	list_del(&sdev->siblings);
 	list_del(&sdev->same_target_siblings);
 	list_del(&sdev->starved_entry);
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
-	if (delete) {
-		struct scsi_target *starget = to_scsi_target(parent);
-		if (!starget->create) {
-			transport_remove_device(&starget->dev);
-			device_del(parent);
-		}
-		transport_destroy_device(&starget->dev);
-
-		put_device(parent);
-	}
 	if (sdev->request_queue)
 		scsi_free_queue(sdev->request_queue);
 
+	if (sdev->reap)
+		scsi_target_reap(scsi_target(sdev));
+
 	kfree(sdev->inquiry);
 	kfree(sdev);
 
@@ -560,14 +554,6 @@
 	return device_create_file(dev, attr);
 }
 
-static void scsi_target_dev_release(struct device *dev)
-{
-	struct scsi_target *starget = to_scsi_target(dev);
-	struct device *parent = dev->parent;
-	kfree(starget);
-	put_device(parent);
-}
-
 /**
  * scsi_sysfs_add_sdev - add scsi device to sysfs
  * @sdev:	scsi_device to add
@@ -577,25 +563,16 @@
  **/
 int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 {
-	struct scsi_target *starget = sdev->sdev_target;
 	struct Scsi_Host *shost = sdev->host;
-	int error, i, create;
+	struct scsi_target *starget = scsi_target(sdev);
+	int error, i;
 	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	create = starget->create;
-	starget->create = 0;
+	list_add_tail(&sdev->same_target_siblings, &starget->devices);
+	list_add_tail(&sdev->siblings, &shost->__devices);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	if (create) {
-		error = device_add(&starget->dev);
-		if (error) {
-			printk(KERN_ERR "Target device_add failed\n");
-			return error;
-		}
-		transport_add_device(&starget->dev);
-	}
-
 	if ((error = scsi_device_set_state(sdev, SDEV_RUNNING)) != 0)
 		return error;
 
@@ -643,7 +620,6 @@
  out:
 	return error;
 
-	class_device_del(&sdev->sdev_classdev);
  clean_device:
 	scsi_device_set_state(sdev, SDEV_CANCEL);
 
@@ -654,13 +630,10 @@
 	return error;
 }
 
-/**
- * scsi_remove_device - unregister a device from the scsi bus
- * @sdev:	scsi_device to unregister
- **/
-void scsi_remove_device(struct scsi_device *sdev)
+void __scsi_remove_device(struct scsi_device *sdev, int reap)
 {
 	struct Scsi_Host *shost = sdev->host;
+	sdev->reap = reap;
 
 	down(&shost->scan_mutex);
 	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
@@ -673,12 +646,49 @@
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_unregister_device(&sdev->sdev_gendev);
 	put_device(&sdev->sdev_gendev);
-
 out:
 	up(&shost->scan_mutex);
 }
+
+/**
+ * scsi_remove_device - unregister a device from the scsi bus
+ * @sdev:	scsi_device to unregister
+ **/
+void scsi_remove_device(struct scsi_device *sdev)
+{
+	__scsi_remove_device(sdev, 1);
+}
 EXPORT_SYMBOL(scsi_remove_device);
 
+/**
+ * scsi_remove_target - try to remove a target and all its devices
+ * @starget: the target to remove
+ *
+ * Note: This is slightly racy.  It is possible that if the user
+ * requests the addition of another device then the target won't be
+ * removed.
+ */
+void scsi_remove_target(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	unsigned long flags;
+	struct scsi_device *sdev, *tmp;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	starget->reap_ref++;
+	list_for_each_entry_safe(sdev, tmp, &shost->__devices, siblings) {
+		if (sdev->channel != starget->channel ||
+		    sdev->id != starget->id)
+			continue;
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		__scsi_remove_device(sdev, 0);
+		spin_lock_irqsave(shost->host_lock, flags);
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	scsi_target_reap(starget);
+}
+EXPORT_SYMBOL(scsi_remove_target);
+
 int scsi_register_driver(struct device_driver *drv)
 {
 	drv->bus = &scsi_bus_type;
@@ -780,7 +790,7 @@
 	snprintf(sdev->sdev_classdev.class_id, BUS_ID_SIZE,
 		 "%d:%d:%d:%d", sdev->host->host_no,
 		 sdev->channel, sdev->id, sdev->lun);
-
+	sdev->scsi_level = SCSI_2;
 	transport_setup_device(&sdev->sdev_gendev);
 }
 
@@ -789,73 +799,6 @@
 	return dev->release == scsi_device_dev_release;
 }
 EXPORT_SYMBOL(scsi_is_sdev_device);
-
-int scsi_sysfs_target_initialize(struct scsi_device *sdev)
-{
-	struct scsi_target *starget = NULL;
-	struct Scsi_Host *shost = sdev->host;
-	struct scsi_device *device;
-	struct device *dev = NULL;
-	unsigned long flags;
-	int create = 0;
-
-	spin_lock_irqsave(shost->host_lock, flags);
-	/*
-	 * Search for an existing target for this sdev.
-	 */
-	list_for_each_entry(device, &shost->__devices, siblings) {
-		if (device->id == sdev->id &&
-		    device->channel == sdev->channel) {
-			list_add_tail(&sdev->same_target_siblings,
-				      &device->same_target_siblings);
-			sdev->scsi_level = device->scsi_level;
-			starget = device->sdev_target;
-			break;
-		}
-	}
-			
-	if (!starget) {
-		const int size = sizeof(*starget) +
-			shost->transportt->target_size;
-		starget = kmalloc(size, GFP_ATOMIC);
-		if (!starget) {
-			printk(KERN_ERR "%s: allocation failure\n", __FUNCTION__);
-			spin_unlock_irqrestore(shost->host_lock,
-					       flags);
-			return -ENOMEM;
-		}
-		memset(starget, 0, size);
-		dev = &starget->dev;
-		device_initialize(dev);
-		dev->parent = get_device(&shost->shost_gendev);
-		dev->release = scsi_target_dev_release;
-		sprintf(dev->bus_id, "target%d:%d:%d",
-			shost->host_no, sdev->channel, sdev->id);
-		starget->id = sdev->id;
-		starget->channel = sdev->channel;
-		create = starget->create = 1;
-		/*
-		 * If there wasn't another lun already configured at
-		 * this target, then default this device to SCSI_2
-		 * until we know better
-		 */
-		sdev->scsi_level = SCSI_2;
-	}
-	get_device(&starget->dev);
-	sdev->sdev_gendev.parent = &starget->dev;
-	sdev->sdev_target = starget;
-	list_add_tail(&sdev->siblings, &shost->__devices);
-	spin_unlock_irqrestore(shost->host_lock, flags);
-	if (create)
-		transport_setup_device(&starget->dev);
-	return 0;
-}
-
-int scsi_is_target_device(const struct device *dev)
-{
-	return dev->release == scsi_target_dev_release;
-}
-EXPORT_SYMBOL(scsi_is_target_device);
 
 /* A blank transport template that is used in drivers that don't
  * yet implement Transport Attributes */
===== include/scsi/scsi_device.h 1.30 vs edited =====
--- 1.30/include/scsi/scsi_device.h	2005-02-03 21:35:03 -06:00
+++ edited/include/scsi/scsi_device.h	2005-02-15 15:16:31 -06:00
@@ -112,6 +112,7 @@
 	unsigned no_uld_attach:1; /* disable connecting to upper level drivers */
 	unsigned select_no_atn:1;
 	unsigned fix_capacity:1;	/* READ_CAPACITY is too high by 1 */
+	unsigned reap:1;	/* whether release reaps the target */
 
 	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
 
@@ -144,7 +145,10 @@
  */
 struct scsi_target {
 	struct scsi_device	*starget_sdev_user;
+	struct list_head	siblings;
+	struct list_head	devices;
 	struct device		dev;
+	unsigned int		reap_ref; /* protected by the host lock */
 	unsigned int		channel;
 	unsigned int		id; /* target id ... replace
 				     * scsi_device.id eventually */
@@ -226,6 +230,8 @@
 extern void scsi_device_resume(struct scsi_device *sdev);
 extern void scsi_target_quiesce(struct scsi_target *);
 extern void scsi_target_resume(struct scsi_target *);
+extern void scsi_target_reap(struct scsi_target *);
+extern void scsi_remove_target(struct scsi_target *);
 extern const char *scsi_device_state_name(enum scsi_device_state);
 extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
===== include/scsi/scsi_host.h 1.26 vs edited =====
--- 1.26/include/scsi/scsi_host.h	2005-01-19 10:01:21 -06:00
+++ edited/include/scsi/scsi_host.h	2005-02-14 08:50:50 -06:00
@@ -416,6 +416,7 @@
 	 * access this list directly from a driver.
 	 */
 	struct list_head	__devices;
+	struct list_head	__targets;
 	
 	struct scsi_host_cmd_pool *cmd_pool;
 	spinlock_t		free_list_lock;
@@ -548,11 +549,21 @@
 	unsigned long hostdata[0]  /* Used for storage of host specific stuff */
 		__attribute__ ((aligned (sizeof(unsigned long))));
 };
-#define		dev_to_shost(d)		\
-	container_of(d, struct Scsi_Host, shost_gendev)
+
 #define		class_to_shost(d)	\
 	container_of(d, struct Scsi_Host, shost_classdev)
 
+int scsi_is_host_device(const struct device *);
+
+static inline struct Scsi_Host *dev_to_shost(struct device *dev)
+{
+	while (!scsi_is_host_device(dev)) {
+		if (!dev->parent)
+			return NULL;
+		dev = dev->parent;
+	}
+	return container_of(dev, struct Scsi_Host, shost_gendev);
+}
 
 extern struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *, int);
 extern int __must_check scsi_add_host(struct Scsi_Host *, struct device *);
@@ -596,8 +607,6 @@
  */
 extern void scsi_free_host_dev(struct scsi_device *);
 extern struct scsi_device *scsi_get_host_dev(struct Scsi_Host *);
-int scsi_is_host_device(const struct device *);
-
 
 /* legacy interfaces */
 extern struct Scsi_Host *scsi_register(struct scsi_host_template *, int);


