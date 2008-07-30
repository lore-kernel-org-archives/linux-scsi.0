From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 2/6] cciss: remove redundant code
Date: Wed, 30 Jul 2008 16:09:23 -0500
Message-ID: <20080730210923.GB1758@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:29743 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbYG3VJX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jul 2008 17:09:23 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>

Patch 2 of 6

This patch removes redundant code where ever logical volumes are added or
removed. It adds 3 new functions that are called instead of having the same
code spread throughout the driver. It also removes the cciss_getgeometry
function.
The patch is fairly complex but we haven't figured out how to make it any
simpler and still do everything that needs to be done. Some of the
complexity comes from having to special case booting from cciss. Otherwise
the gendisk doesn't get added in time and the switchroot will fail.

Please consider this patch for inclusion.

Thanks,
mikem

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
Signed-off-by: Mike Miller <mike.miller@hp.com>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 9b0dc00..d372db0 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -159,7 +159,7 @@ static int cciss_ioctl(struct inode *inode, struct file *filep,
 static int cciss_getgeo(struct block_device *bdev, struct hd_geometry *geo);
 
 static int cciss_revalidate(struct gendisk *disk);
-static int rebuild_lun_table(ctlr_info_t *h, struct gendisk *del_disk);
+static int rebuild_lun_table(ctlr_info_t *h, int first_time);
 static int deregister_disk(struct gendisk *disk, drive_info_struct *drv,
 			   int clear_all);
 
@@ -171,7 +171,6 @@ static void cciss_geometry_inquiry(int ctlr, int logvol,
 			int withirq, sector_t total_size,
 			unsigned int block_size, InquiryData_struct *inq_buff,
 				   drive_info_struct *drv);
-static void cciss_getgeometry(int cntl_num);
 static void __devinit cciss_interrupt_mode(ctlr_info_t *, struct pci_dev *,
 					   __u32);
 static void start_io(ctlr_info_t *h);
@@ -929,8 +928,10 @@ static int cciss_ioctl(struct inode *inode, struct file *filep,
 			return 0;
 		}
 
+	case CCISS_DEREGDISK:
+	case CCISS_REGNEWD:
 	case CCISS_REVALIDVOLS:
-		return rebuild_lun_table(host, NULL);
+		return rebuild_lun_table(host, 0);
 
 	case CCISS_GETLUNINFO:{
 			LogvolInfo_struct luninfo;
@@ -943,12 +944,6 @@ static int cciss_ioctl(struct inode *inode, struct file *filep,
 				return -EFAULT;
 			return 0;
 		}
-	case CCISS_DEREGDISK:
-		return rebuild_lun_table(host, disk);
-
-	case CCISS_REGNEWD:
-		return rebuild_lun_table(host, NULL);
-
 	case CCISS_PASSTHRU:
 		{
 			IOCTL_Command_struct iocommand;
@@ -1363,6 +1358,42 @@ static void cciss_get_serial_no(int ctlr, int logvol, int withirq,
 	return;
 }
 
+static void cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
+				int drv_index)
+{
+	disk->queue = blk_init_queue(do_cciss_request, &h->lock);
+	sprintf(disk->disk_name, "cciss/c%dd%d", h->ctlr, drv_index);
+	disk->major = h->major;
+	disk->first_minor = drv_index << NWD_SHIFT;
+	disk->fops = &cciss_fops;
+	disk->private_data = &h->drv[drv_index];
+
+	/* Set up queue information */
+	blk_queue_bounce_limit(disk->queue, h->pdev->dma_mask);
+
+	/* This is a hardware imposed limit. */
+	blk_queue_max_hw_segments(disk->queue, MAXSGENTRIES);
+
+	/* This is a limit in the driver and could be eliminated. */
+	blk_queue_max_phys_segments(disk->queue, MAXSGENTRIES);
+
+	blk_queue_max_sectors(disk->queue, h->cciss_max_sectors);
+
+	blk_queue_softirq_done(disk->queue, cciss_softirq_done);
+
+	disk->queue->queuedata = h;
+
+	blk_queue_hardsect_size(disk->queue,
+				h->drv[drv_index].block_size);
+
+	/* Make sure all queue data is written out before */
+	/* setting h->drv[drv_index].queue, as setting this */
+	/* allows the interrupt handler to start the queue */
+	wmb();
+	h->drv[drv_index].queue = disk->queue;
+	add_disk(disk);
+}
+
 /* This function will check the usage_count of the drive to be updated/added.
  * If the usage_count is zero and it is a heretofore unknown drive, or,
  * the drive's capacity, geometry, or serial number has changed,
@@ -1373,7 +1404,7 @@ static void cciss_get_serial_no(int ctlr, int logvol, int withirq,
  * is also the controller node.  Any changes to disk 0 will show up on
  * the next reboot.
  */
-static void cciss_update_drive_info(int ctlr, int drv_index)
+static void cciss_update_drive_info(int ctlr, int drv_index, int first_time)
 {
 	ctlr_info_t *h = hba[ctlr];
 	struct gendisk *disk;
@@ -1383,6 +1414,7 @@ static void cciss_update_drive_info(int ctlr, int drv_index)
 	unsigned long flags = 0;
 	int ret = 0;
 	drive_info_struct *drvinfo;
+	int was_only_controller_node;
 
 	/* Get information about the disk and modify the driver structure */
 	inq_buff = kmalloc(sizeof(InquiryData_struct), GFP_KERNEL);
@@ -1390,6 +1422,13 @@ static void cciss_update_drive_info(int ctlr, int drv_index)
 	if (inq_buff == NULL || drvinfo == NULL)
 		goto mem_msg;
 
+	/* See if we're trying to update the "controller node"
+	 * this will happen the when the first logical drive gets
+	 * created by ACU.
+	 */
+	was_only_controller_node = (drv_index == 0 &&
+				h->drv[0].raid_level == -1);
+
 	/* testing to see if 16-byte CDBs are already being used */
 	if (h->cciss_read == CCISS_READ_16) {
 		cciss_read_capacity_16(h->ctlr, drv_index, 1,
@@ -1429,25 +1468,26 @@ static void cciss_update_drive_info(int ctlr, int drv_index)
 		drvinfo->nr_blocks == h->drv[drv_index].nr_blocks &&
 		drvinfo->heads == h->drv[drv_index].heads &&
 		drvinfo->sectors == h->drv[drv_index].sectors &&
-		drvinfo->cylinders == h->drv[drv_index].cylinders)) {
+		drvinfo->cylinders == h->drv[drv_index].cylinders))
 			/* The disk is unchanged, nothing to update */
 			goto freeret;
-	}
 
-	/* Not the same disk, or something's changed, so we need to */
-	/* deregister it, and re-register it, if it's not in use. */
-
-	/* if the disk already exists then deregister it before proceeding */
-	/* (unless it's the first disk (for the controller node). */
+	/* If we get here it's not the same disk, or something's changed,
+	 * so we need to * deregister it, and re-register it, if it's not
+	 * in use.
+	 * If the disk already exists then deregister it before proceeding
+	 * (unless it's the first disk (for the controller node).
+	 */
 	if (h->drv[drv_index].raid_level != -1 && drv_index != 0) {
 		printk(KERN_WARNING "disk %d has changed.\n", drv_index);
 		spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
 		h->drv[drv_index].busy_configuring = 1;
 		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
 
-		/* deregister_disk sets h->drv[drv_index].queue = NULL */
-		/* which keeps the interrupt handler from starting */
-		/* the queue. */
+		/* deregister_disk sets h->drv[drv_index].queue = NULL
+		 * which keeps the interrupt handler from starting
+		 * the queue.
+		 */
 		ret = deregister_disk(h->gendisk[drv_index],
 				      &h->drv[drv_index], 0);
 		h->drv[drv_index].busy_configuring = 0;
@@ -1457,8 +1497,9 @@ static void cciss_update_drive_info(int ctlr, int drv_index)
 	if (ret)
 		goto freeret;
 
-	/* Save the new information from cciss_geometry_inquiry */
-	/* and serial number inquiry. */
+	/* Save the new information from cciss_geometry_inquiry
+	 * and serial number inquiry.
+	 */
 	h->drv[drv_index].block_size = drvinfo->block_size;
 	h->drv[drv_index].nr_blocks = drvinfo->nr_blocks;
 	h->drv[drv_index].heads = drvinfo->heads;
@@ -1471,46 +1512,20 @@ static void cciss_update_drive_info(int ctlr, int drv_index)
 	disk = h->gendisk[drv_index];
 	set_capacity(disk, h->drv[drv_index].nr_blocks);
 
-	/* if it's the controller (if drv_index == 0) it's already added */
-	if (drv_index) {
-		disk->queue = blk_init_queue(do_cciss_request, &h->lock);
-		sprintf(disk->disk_name, "cciss/c%dd%d", ctlr, drv_index);
-		disk->major = h->major;
-		disk->first_minor = drv_index << NWD_SHIFT;
-		disk->fops = &cciss_fops;
-		disk->private_data = &h->drv[drv_index];
-
-		/* Set up queue information */
-		blk_queue_bounce_limit(disk->queue, hba[ctlr]->pdev->dma_mask);
-
-		/* This is a hardware imposed limit. */
-		blk_queue_max_hw_segments(disk->queue, MAXSGENTRIES);
-
-		/* This is a limit in the driver and could be eliminated. */
-		blk_queue_max_phys_segments(disk->queue, MAXSGENTRIES);
-
-		blk_queue_max_sectors(disk->queue, h->cciss_max_sectors);
-
-		blk_queue_softirq_done(disk->queue, cciss_softirq_done);
-
-		disk->queue->queuedata = hba[ctlr];
-
-		blk_queue_hardsect_size(disk->queue,
-					hba[ctlr]->drv[drv_index].block_size);
-
-		/* Make sure all queue data is written out before */
-		/* setting h->drv[drv_index].queue, as setting this */
-		/* allows the interrupt handler to start the queue */
-		wmb();
-		h->drv[drv_index].queue = disk->queue;
-		add_disk(disk);
-	}
+	/* If it's not disk 0 (drv_index != 0)
+	 * or if it was disk 0, but there was previously
+	 * no actual corresponding configured logical drive
+	 * (raid_leve == -1) then we want to update the
+	 * logical drive's information.
+	 */
+	if (drv_index || first_time)
+		cciss_add_disk(h, disk, drv_index);
 
-      freeret:
+freeret:
 	kfree(inq_buff);
 	kfree(drvinfo);
 	return;
-      mem_msg:
+mem_msg:
 	printk(KERN_ERR "cciss: out of memory\n");
 	goto freeret;
 }
@@ -1535,6 +1550,73 @@ static int cciss_find_free_drive_index(int ctlr)
 	return -1;
 }
 
+/* cciss_add_gendisk finds a free hba[]->drv structure
+ * and allocates a gendisk if needed, and sets the lunid
+ * in the drvinfo structure.   It returns the index into
+ * the ->drv[] array, or -1 if none are free.
+ * is_controller_node indicates whether highest_lun should
+ * count this disk, or if it's only being added to provide
+ * a means to talk to the controller in case no logical
+ * drives have yet been configured.
+ */
+static int cciss_add_gendisk(ctlr_info_t *h, __u32 lunid)
+{
+	int drv_index;
+
+	drv_index = cciss_find_free_drive_index(h->ctlr);
+	if (drv_index == -1)
+		return -1;
+	/*Check if the gendisk needs to be allocated */
+	if (!h->gendisk[drv_index]) {
+		h->gendisk[drv_index] =
+			alloc_disk(1 << NWD_SHIFT);
+		if (!h->gendisk[drv_index]) {
+			printk(KERN_ERR "cciss%d: could not "
+				"allocate a new disk %d\n",
+				h->ctlr, drv_index);
+			return -1;
+		}
+	}
+	h->drv[drv_index].LunID = lunid;
+
+	/* Don't need to mark this busy because nobody */
+	/* else knows about this disk yet to contend */
+	/* for access to it. */
+	h->drv[drv_index].busy_configuring = 0;
+	wmb();
+	return drv_index;
+}
+
+/* This is for the special case of a controller which
+ * has no logical drives.  In this case, we still need
+ * to register a disk so the controller can be accessed
+ * by the Array Config Utility.
+ */
+static void cciss_add_controller_node(ctlr_info_t *h)
+{
+	struct gendisk *disk;
+	int drv_index;
+
+	if (h->gendisk[0] != NULL) /* already did this? Then bail. */
+		return;
+
+	drv_index = cciss_add_gendisk(h, 0);
+	if (drv_index == -1) {
+		printk(KERN_WARNING "cciss%d: could not "
+			"add disk 0.\n", h->ctlr);
+		return;
+	}
+	h->drv[drv_index].block_size = 512;
+	h->drv[drv_index].nr_blocks = 0;
+	h->drv[drv_index].heads = 0;
+	h->drv[drv_index].sectors = 0;
+	h->drv[drv_index].cylinders = 0;
+	h->drv[drv_index].raid_level = -1;
+	memset(h->drv[drv_index].serial_no, 0, 16);
+	disk = h->gendisk[drv_index];
+	cciss_add_disk(h, disk, drv_index);
+}
+
 /* This function will add and remove logical drives from the Logical
  * drive array of the controller and maintain persistency of ordering
  * so that mount points are preserved until the next reboot.  This allows
@@ -1542,10 +1624,8 @@ static int cciss_find_free_drive_index(int ctlr)
  * without a re-ordering of those drives.
  * INPUT
  * h		= The controller to perform the operations on
- * del_disk	= The disk to remove if specified.  If the value given
- *		  is NULL then no disk is removed.
  */
-static int rebuild_lun_table(ctlr_info_t *h, struct gendisk *del_disk)
+static int rebuild_lun_table(ctlr_info_t *h, int first_time)
 {
 	int ctlr = h->ctlr;
 	int num_luns;
@@ -1558,6 +1638,9 @@ static int rebuild_lun_table(ctlr_info_t *h, struct gendisk *del_disk)
 	__u32 lunid = 0;
 	unsigned long flags;
 
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
+
 	/* Set busy_configuring flag for this operation */
 	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
 	if (h->busy_configuring) {
@@ -1567,9 +1650,6 @@ static int rebuild_lun_table(ctlr_info_t *h, struct gendisk *del_disk)
 	h->busy_configuring = 1;
 	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
 
-	if (!capable(CAP_SYS_RAWIO))
-		return -EPERM;
-
 	ld_buff = kzalloc(sizeof(ReportLunData_struct), GFP_KERNEL);
 	if (ld_buff == NULL)
 		goto mem_msg;
@@ -1595,10 +1675,14 @@ static int rebuild_lun_table(ctlr_info_t *h, struct gendisk *del_disk)
 		       " this driver.\n");
 	}
 
-	/* Compare controller drive array to driver's drive array */
-	/* to see if any drives are missing on the controller due */
-	/* to action of Array Config Utility (user deletes drive) */
-	/* and deregister logical drives which have disappeared.  */
+	if (num_luns == 0)
+		cciss_add_controller_node(h);
+
+	/* Compare controller drive array to driver's drive array
+	 * to see if any drives are missing on the controller due
+	 * to action of Array Config Utility (user deletes drive)
+	 * and deregister logical drives which have disappeared.
+	 */
 	for (i = 0; i <= h->highest_lun; i++) {
 		int j;
 		drv_found = 0;
@@ -1650,34 +1734,14 @@ static int rebuild_lun_table(ctlr_info_t *h, struct gendisk *del_disk)
 
 		/* check if the drive was found already in the array */
 		if (!drv_found) {
-			drv_index = cciss_find_free_drive_index(ctlr);
+			drv_index = cciss_add_gendisk(h, lunid);
 			if (drv_index == -1)
 				goto freeret;
-			/*Check if the gendisk needs to be allocated */
-			if (!h->gendisk[drv_index]) {
-				h->gendisk[drv_index] =
-					alloc_disk(1 << NWD_SHIFT);
-				if (!h->gendisk[drv_index]){
-					printk(KERN_ERR "cciss: could not "
-						"allocate new disk %d\n",
-						drv_index);
-					goto mem_msg;
-				}
-			}
-			h->drv[drv_index].LunID = lunid;
-
-			/* Don't need to mark this busy because nobody
-			 * else knows about this disk yet to contend
-			 * for access to it.
-			 */
-			h->drv[drv_index].busy_configuring = 0;
-			wmb();
-
 		}
-		cciss_update_drive_info(ctlr, drv_index);
+		cciss_update_drive_info(ctlr, drv_index, first_time);
 	}		/* end for */
 
-      freeret:
+freeret:
 	kfree(ld_buff);
 	h->busy_configuring = 0;
 	/* We return -1 here to tell the ACU that we have registered/updated
@@ -1685,7 +1749,7 @@ static int rebuild_lun_table(ctlr_info_t *h, struct gendisk *del_disk)
 	 * additional times.
 	 */
 	return -1;
-      mem_msg:
+mem_msg:
 	printk(KERN_ERR "cciss: out of memory\n");
 	h->busy_configuring = 0;
 	goto freeret;
@@ -3290,139 +3354,9 @@ err_out_free_res:
 	return err;
 }
 
-/*
- * Gets information about the local volumes attached to the controller.
+/* Function to find the first free pointer into our hba[] array
+ * Returns -1 if no free entries are left.
  */
-static void cciss_getgeometry(int cntl_num)
-{
-	ReportLunData_struct *ld_buff;
-	InquiryData_struct *inq_buff;
-	int return_code;
-	int i;
-	int listlength = 0;
-	__u32 lunid = 0;
-	unsigned block_size;
-	sector_t total_size;
-
-	ld_buff = kzalloc(sizeof(ReportLunData_struct), GFP_KERNEL);
-	if (ld_buff == NULL) {
-		printk(KERN_ERR "cciss: out of memory\n");
-		return;
-	}
-	inq_buff = kmalloc(sizeof(InquiryData_struct), GFP_KERNEL);
-	if (inq_buff == NULL) {
-		printk(KERN_ERR "cciss: out of memory\n");
-		kfree(ld_buff);
-		return;
-	}
-	/* Get the firmware version */
-	return_code = sendcmd(CISS_INQUIRY, cntl_num, inq_buff,
-			      sizeof(InquiryData_struct), 0, 0, 0, NULL,
-			      TYPE_CMD);
-	if (return_code == IO_OK) {
-		hba[cntl_num]->firm_ver[0] = inq_buff->data_byte[32];
-		hba[cntl_num]->firm_ver[1] = inq_buff->data_byte[33];
-		hba[cntl_num]->firm_ver[2] = inq_buff->data_byte[34];
-		hba[cntl_num]->firm_ver[3] = inq_buff->data_byte[35];
-	} else {		/* send command failed */
-
-		printk(KERN_WARNING "cciss: unable to determine firmware"
-		       " version of controller\n");
-	}
-	/* Get the number of logical volumes */
-	return_code = sendcmd(CISS_REPORT_LOG, cntl_num, ld_buff,
-			      sizeof(ReportLunData_struct), 0, 0, 0, NULL,
-			      TYPE_CMD);
-
-	if (return_code == IO_OK) {
-#ifdef CCISS_DEBUG
-		printk("LUN Data\n--------------------------\n");
-#endif				/* CCISS_DEBUG */
-
-		listlength |=
-		    (0xff & (unsigned int)(ld_buff->LUNListLength[0])) << 24;
-		listlength |=
-		    (0xff & (unsigned int)(ld_buff->LUNListLength[1])) << 16;
-		listlength |=
-		    (0xff & (unsigned int)(ld_buff->LUNListLength[2])) << 8;
-		listlength |= 0xff & (unsigned int)(ld_buff->LUNListLength[3]);
-	} else {		/* reading number of logical volumes failed */
-
-		printk(KERN_WARNING "cciss: report logical volume"
-		       " command failed\n");
-		listlength = 0;
-	}
-	hba[cntl_num]->num_luns = listlength / 8;	// 8 bytes pre entry
-	if (hba[cntl_num]->num_luns > CISS_MAX_LUN) {
-		printk(KERN_ERR
-		       "ciss:  only %d number of logical volumes supported\n",
-		       CISS_MAX_LUN);
-		hba[cntl_num]->num_luns = CISS_MAX_LUN;
-	}
-#ifdef CCISS_DEBUG
-	printk(KERN_DEBUG "Length = %x %x %x %x = %d\n",
-	       ld_buff->LUNListLength[0], ld_buff->LUNListLength[1],
-	       ld_buff->LUNListLength[2], ld_buff->LUNListLength[3],
-	       hba[cntl_num]->num_luns);
-#endif				/* CCISS_DEBUG */
-
-	hba[cntl_num]->highest_lun = hba[cntl_num]->num_luns - 1;
-	for (i = 0; i < CISS_MAX_LUN; i++) {
-		if (i < hba[cntl_num]->num_luns) {
-			lunid = (0xff & (unsigned int)(ld_buff->LUN[i][3]))
-			    << 24;
-			lunid |= (0xff & (unsigned int)(ld_buff->LUN[i][2]))
-			    << 16;
-			lunid |= (0xff & (unsigned int)(ld_buff->LUN[i][1]))
-			    << 8;
-			lunid |= 0xff & (unsigned int)(ld_buff->LUN[i][0]);
-
-			hba[cntl_num]->drv[i].LunID = lunid;
-
-#ifdef CCISS_DEBUG
-			printk(KERN_DEBUG "LUN[%d]:  %x %x %x %x = %x\n", i,
-			       ld_buff->LUN[i][0], ld_buff->LUN[i][1],
-			       ld_buff->LUN[i][2], ld_buff->LUN[i][3],
-			       hba[cntl_num]->drv[i].LunID);
-#endif				/* CCISS_DEBUG */
-
-		/* testing to see if 16-byte CDBs are already being used */
-		if(hba[cntl_num]->cciss_read == CCISS_READ_16) {
-			cciss_read_capacity_16(cntl_num, i, 0,
-					    &total_size, &block_size);
-			goto geo_inq;
-		}
-		cciss_read_capacity(cntl_num, i, 0, &total_size, &block_size);
-
-		/* If read_capacity returns all F's the logical is >2TB */
-		/* so we switch to 16-byte CDBs for all read/write ops */
-		if(total_size == 0xFFFFFFFFULL) {
-			cciss_read_capacity_16(cntl_num, i, 0,
-			&total_size, &block_size);
-			hba[cntl_num]->cciss_read = CCISS_READ_16;
-			hba[cntl_num]->cciss_write = CCISS_WRITE_16;
-		} else {
-			hba[cntl_num]->cciss_read = CCISS_READ_10;
-			hba[cntl_num]->cciss_write = CCISS_WRITE_10;
-		}
-geo_inq:
-			cciss_geometry_inquiry(cntl_num, i, 0, total_size,
-					       block_size, inq_buff,
-					       &hba[cntl_num]->drv[i]);
-			cciss_get_serial_no(cntl_num, i, 0,
-				hba[cntl_num]->drv[i].serial_no,
-				sizeof(hba[cntl_num]->drv[i].serial_no));
-		} else {
-			/* initialize raid_level to indicate a free space */
-			hba[cntl_num]->drv[i].raid_level = -1;
-		}
-	}
-	kfree(ld_buff);
-	kfree(inq_buff);
-}
-
-/* Function to find the first free pointer into our hba[] array */
-/* Returns -1 if no free entries are left.  */
 static int alloc_cciss_hba(void)
 {
 	int i;
@@ -3434,11 +3368,6 @@ static int alloc_cciss_hba(void)
 			p = kzalloc(sizeof(ctlr_info_t), GFP_KERNEL);
 			if (!p)
 				goto Enomem;
-			p->gendisk[0] = alloc_disk(1 << NWD_SHIFT);
-			if (!p->gendisk[0]) {
-				kfree(p);
-				goto Enomem;
-			}
 			hba[i] = p;
 			return i;
 		}
@@ -3566,11 +3495,13 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	       ((hba[i]->nr_cmds + BITS_PER_LONG -
 		 1) / BITS_PER_LONG) * sizeof(unsigned long));
 
-#ifdef CCISS_DEBUG
-	printk(KERN_DEBUG "Scanning for drives on controller cciss%d\n", i);
-#endif				/* CCISS_DEBUG */
-
-	cciss_getgeometry(i);
+	hba[i]->num_luns = 0;
+	hba[i]->highest_lun = -1;
+	for (j = 0; j < CISS_MAX_LUN; j++) {
+		hba[i]->drv[j].raid_level = -1;
+		hba[i]->drv[j].queue = NULL;
+		hba[i]->gendisk[j] = NULL;
+	}
 
 	cciss_scsi_setup(i);
 
@@ -3583,76 +3514,10 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 
 	hba[i]->busy_initializing = 0;
 
-	do {
-		drive_info_struct *drv = &(hba[i]->drv[j]);
-		struct gendisk *disk = hba[i]->gendisk[j];
-		struct request_queue *q;
-
-		/* Check if the disk was allocated already */
-		if (!disk){
-			hba[i]->gendisk[j] = alloc_disk(1 << NWD_SHIFT);
-			disk = hba[i]->gendisk[j];
-		}
-
-		/* Check that the disk was able to be allocated */
-		if (!disk) {
-			printk(KERN_ERR "cciss: unable to allocate memory for disk %d\n", j);
-			goto clean4;
-		}
-
-		q = blk_init_queue(do_cciss_request, &hba[i]->lock);
-		if (!q) {
-			printk(KERN_ERR
-			       "cciss:  unable to allocate queue for disk %d\n",
-			       j);
-			goto clean4;
-		}
-		drv->queue = q;
-
-		blk_queue_bounce_limit(q, hba[i]->pdev->dma_mask);
-
-		/* This is a hardware imposed limit. */
-		blk_queue_max_hw_segments(q, MAXSGENTRIES);
-
-		/* This is a limit in the driver and could be eliminated. */
-		blk_queue_max_phys_segments(q, MAXSGENTRIES);
-
-		blk_queue_max_sectors(q, hba[i]->cciss_max_sectors);
-
-		blk_queue_softirq_done(q, cciss_softirq_done);
-
-		q->queuedata = hba[i];
-		sprintf(disk->disk_name, "cciss/c%dd%d", i, j);
-		disk->major = hba[i]->major;
-		disk->first_minor = j << NWD_SHIFT;
-		disk->fops = &cciss_fops;
-		disk->queue = q;
-		disk->private_data = drv;
-		disk->driverfs_dev = &pdev->dev;
-		/* we must register the controller even if no disks exist */
-		/* this is for the online array utilities */
-		if (!drv->heads && j)
-			continue;
-		blk_queue_hardsect_size(q, drv->block_size);
-		set_capacity(disk, drv->nr_blocks);
-		j++;
-	} while (j <= hba[i]->highest_lun);
-
-	/* Make sure all queue data is written out before */
-	/* interrupt handler, triggered by add_disk,  */
-	/* is allowed to start them. */
-	wmb();
-
-	for (j = 0; j <= hba[i]->highest_lun; j++)
-		add_disk(hba[i]->gendisk[j]);
-
-	/* we must register the controller even if no disks exist */
-	if (hba[i]->highest_lun == -1)
-		add_disk(hba[i]->gendisk[0]);
-
+	rebuild_lun_table(hba[i], 1);
 	return 1;
 
-      clean4:
+clean4:
 #ifdef CONFIG_CISS_SCSI_TAPE
 	kfree(hba[i]->scsi_rejects.complete);
 #endif
@@ -3667,9 +3532,9 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 				    hba[i]->errinfo_pool,
 				    hba[i]->errinfo_pool_dhandle);
 	free_irq(hba[i]->intr[SIMPLE_MODE_INT], hba[i]);
-      clean2:
+clean2:
 	unregister_blkdev(hba[i]->major, hba[i]->devname);
-      clean1:
+clean1:
 	hba[i]->busy_initializing = 0;
 	/* cleanup any queues that may have been initialized */
 	for (j=0; j <= hba[i]->highest_lun; j++){
