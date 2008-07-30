From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 1/6] cciss: make rebuild_lun_table behave better
Date: Wed, 30 Jul 2008 16:06:50 -0500
Message-ID: <20080730210650.GA1758@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:30028 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbYG3VGv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jul 2008 17:06:51 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>

Patch 1 of 6

This patch makes the rebuild_lun_table smart enough to not rip a logical
volume out from under the OS. Without this fix if a customer is running
hpacucli to monitor their storage the driver will blindly remove and re-add
the disks whenever the utility calls the CCISS_REGNEWD ioctl. Unfortunately,
both hpacucli and ACUXE call the ioctl repeatedly. Customers have reported
IO coming to a standstill. Calling the ioctl is the problem, this patch is
the fix.
Please consider this patch for inclusion.

Thanks,
mikem

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
Signed-off-by: Mike Miller <mike.miller@hp.com>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index d81632c..9b0dc00 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1332,13 +1332,46 @@ static void cciss_softirq_done(struct request *rq)
 	spin_unlock_irqrestore(&h->lock, flags);
 }
 
+/* This function gets the serial number of a logical drive via
+ * inquiry page 0x83.  Serial no. is 16 bytes.  If the serial
+ * number cannot be had, for whatever reason, 16 bytes of 0xff
+ * are returned instead.
+ */
+static void cciss_get_serial_no(int ctlr, int logvol, int withirq,
+				unsigned char *serial_no, int buflen)
+{
+#define PAGE_83_INQ_BYTES 64
+	int rc;
+	unsigned char *buf;
+
+	if (buflen > 16)
+		buflen = 16;
+	memset(serial_no, 0xff, buflen);
+	buf = kzalloc(PAGE_83_INQ_BYTES, GFP_KERNEL);
+	if (!buf)
+		return;
+	memset(serial_no, 0, buflen);
+	if (withirq)
+		rc = sendcmd_withirq(CISS_INQUIRY, ctlr, buf,
+			PAGE_83_INQ_BYTES, 1, logvol, 0x83, TYPE_CMD);
+	else
+		rc = sendcmd(CISS_INQUIRY, ctlr, buf,
+			PAGE_83_INQ_BYTES, 1, logvol, 0x83, NULL, TYPE_CMD);
+	if (rc == IO_OK)
+		memcpy(serial_no, &buf[8], buflen);
+	kfree(buf);
+	return;
+}
+
 /* This function will check the usage_count of the drive to be updated/added.
- * If the usage_count is zero then the drive information will be updated and
- * the disk will be re-registered with the kernel.  If not then it will be
- * left alone for the next reboot.  The exception to this is disk 0 which
- * will always be left registered with the kernel since it is also the
- * controller node.  Any changes to disk 0 will show up on the next
- * reboot.
+ * If the usage_count is zero and it is a heretofore unknown drive, or,
+ * the drive's capacity, geometry, or serial number has changed,
+ * then the drive information will be updated and the disk will be
+ * re-registered with the kernel.  If these conditions don't hold,
+ * then it will be left alone for the next reboot.  The exception to this
+ * is disk 0 which will always be left registered with the kernel since it
+ * is also the controller node.  Any changes to disk 0 will show up on
+ * the next reboot.
  */
 static void cciss_update_drive_info(int ctlr, int drv_index)
 {
@@ -1349,9 +1382,65 @@ static void cciss_update_drive_info(int ctlr, int drv_index)
 	sector_t total_size;
 	unsigned long flags = 0;
 	int ret = 0;
+	drive_info_struct *drvinfo;
+
+	/* Get information about the disk and modify the driver structure */
+	inq_buff = kmalloc(sizeof(InquiryData_struct), GFP_KERNEL);
+	drvinfo = kmalloc(sizeof(*drvinfo), GFP_KERNEL);
+	if (inq_buff == NULL || drvinfo == NULL)
+		goto mem_msg;
+
+	/* testing to see if 16-byte CDBs are already being used */
+	if (h->cciss_read == CCISS_READ_16) {
+		cciss_read_capacity_16(h->ctlr, drv_index, 1,
+			&total_size, &block_size);
+
+	} else {
+		cciss_read_capacity(ctlr, drv_index, 1,
+				    &total_size, &block_size);
+
+		/* if read_capacity returns all F's this volume is >2TB */
+		/* in size so we switch to 16-byte CDB's for all */
+		/* read/write ops */
+		if (total_size == 0xFFFFFFFFULL) {
+			cciss_read_capacity_16(ctlr, drv_index, 1,
+			&total_size, &block_size);
+			h->cciss_read = CCISS_READ_16;
+			h->cciss_write = CCISS_WRITE_16;
+		} else {
+			h->cciss_read = CCISS_READ_10;
+			h->cciss_write = CCISS_WRITE_10;
+		}
+	}
+
+	cciss_geometry_inquiry(ctlr, drv_index, 1, total_size, block_size,
+			       inq_buff, drvinfo);
+	drvinfo->block_size = block_size;
+	drvinfo->nr_blocks = total_size + 1;
+
+	cciss_get_serial_no(ctlr, drv_index, 1, drvinfo->serial_no,
+			sizeof(drvinfo->serial_no));
+
+	/* Is it the same disk we already know, and nothing's changed? */
+	if (h->drv[drv_index].raid_level != -1 &&
+		((memcmp(drvinfo->serial_no,
+				h->drv[drv_index].serial_no, 16) == 0) &&
+		drvinfo->block_size == h->drv[drv_index].block_size &&
+		drvinfo->nr_blocks == h->drv[drv_index].nr_blocks &&
+		drvinfo->heads == h->drv[drv_index].heads &&
+		drvinfo->sectors == h->drv[drv_index].sectors &&
+		drvinfo->cylinders == h->drv[drv_index].cylinders)) {
+			/* The disk is unchanged, nothing to update */
+			goto freeret;
+	}
+
+	/* Not the same disk, or something's changed, so we need to */
+	/* deregister it, and re-register it, if it's not in use. */
 
 	/* if the disk already exists then deregister it before proceeding */
-	if (h->drv[drv_index].raid_level != -1) {
+	/* (unless it's the first disk (for the controller node). */
+	if (h->drv[drv_index].raid_level != -1 && drv_index != 0) {
+		printk(KERN_WARNING "disk %d has changed.\n", drv_index);
 		spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
 		h->drv[drv_index].busy_configuring = 1;
 		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
@@ -1366,43 +1455,23 @@ static void cciss_update_drive_info(int ctlr, int drv_index)
 
 	/* If the disk is in use return */
 	if (ret)
-		return;
-
-	/* Get information about the disk and modify the driver structure */
-	inq_buff = kmalloc(sizeof(InquiryData_struct), GFP_KERNEL);
-	if (inq_buff == NULL)
-		goto mem_msg;
-
- 	/* testing to see if 16-byte CDBs are already being used */
- 	if (h->cciss_read == CCISS_READ_16) {
- 		cciss_read_capacity_16(h->ctlr, drv_index, 1,
- 			&total_size, &block_size);
- 		goto geo_inq;
- 	}
-
-	cciss_read_capacity(ctlr, drv_index, 1,
-			    &total_size, &block_size);
-
-  	/* if read_capacity returns all F's this volume is >2TB in size */
-  	/* so we switch to 16-byte CDB's for all read/write ops */
-  	if (total_size == 0xFFFFFFFFULL) {
-		cciss_read_capacity_16(ctlr, drv_index, 1,
-		&total_size, &block_size);
-		h->cciss_read = CCISS_READ_16;
-		h->cciss_write = CCISS_WRITE_16;
-	} else {
-		h->cciss_read = CCISS_READ_10;
-		h->cciss_write = CCISS_WRITE_10;
-	}
-geo_inq:
-	cciss_geometry_inquiry(ctlr, drv_index, 1, total_size, block_size,
-			       inq_buff, &h->drv[drv_index]);
+		goto freeret;
+
+	/* Save the new information from cciss_geometry_inquiry */
+	/* and serial number inquiry. */
+	h->drv[drv_index].block_size = drvinfo->block_size;
+	h->drv[drv_index].nr_blocks = drvinfo->nr_blocks;
+	h->drv[drv_index].heads = drvinfo->heads;
+	h->drv[drv_index].sectors = drvinfo->sectors;
+	h->drv[drv_index].cylinders = drvinfo->cylinders;
+	h->drv[drv_index].raid_level = drvinfo->raid_level;
+	memcpy(h->drv[drv_index].serial_no, drvinfo->serial_no, 16);
 
 	++h->num_luns;
 	disk = h->gendisk[drv_index];
 	set_capacity(disk, h->drv[drv_index].nr_blocks);
 
-	/* if it's the controller it's already added */
+	/* if it's the controller (if drv_index == 0) it's already added */
 	if (drv_index) {
 		disk->queue = blk_init_queue(do_cciss_request, &h->lock);
 		sprintf(disk->disk_name, "cciss/c%dd%d", ctlr, drv_index);
@@ -1439,6 +1508,7 @@ geo_inq:
 
       freeret:
 	kfree(inq_buff);
+	kfree(drvinfo);
 	return;
       mem_msg:
 	printk(KERN_ERR "cciss: out of memory\n");
@@ -1480,7 +1550,6 @@ static int rebuild_lun_table(ctlr_info_t *h, struct gendisk *del_disk)
 	int ctlr = h->ctlr;
 	int num_luns;
 	ReportLunData_struct *ld_buff = NULL;
-	drive_info_struct *drv = NULL;
 	int return_code;
 	int listlength = 0;
 	int i;
@@ -1496,98 +1565,117 @@ static int rebuild_lun_table(ctlr_info_t *h, struct gendisk *del_disk)
 		return -EBUSY;
 	}
 	h->busy_configuring = 1;
+	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
 
-	/* if del_disk is NULL then we are being called to add a new disk
-	 * and update the logical drive table.  If it is not NULL then
-	 * we will check if the disk is in use or not.
-	 */
-	if (del_disk != NULL) {
-		drv = get_drv(del_disk);
-		drv->busy_configuring = 1;
-		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
-		return_code = deregister_disk(del_disk, drv, 1);
-		drv->busy_configuring = 0;
-		h->busy_configuring = 0;
-		return return_code;
-	} else {
-		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
-		if (!capable(CAP_SYS_RAWIO))
-			return -EPERM;
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
 
-		ld_buff = kzalloc(sizeof(ReportLunData_struct), GFP_KERNEL);
-		if (ld_buff == NULL)
-			goto mem_msg;
-
-		return_code = sendcmd_withirq(CISS_REPORT_LOG, ctlr, ld_buff,
-					      sizeof(ReportLunData_struct), 0,
-					      0, 0, TYPE_CMD);
-
-		if (return_code == IO_OK) {
-			listlength =
-				be32_to_cpu(*(__be32 *) ld_buff->LUNListLength);
-		} else {	/* reading number of logical volumes failed */
-			printk(KERN_WARNING "cciss: report logical volume"
-			       " command failed\n");
-			listlength = 0;
-			goto freeret;
-		}
+	ld_buff = kzalloc(sizeof(ReportLunData_struct), GFP_KERNEL);
+	if (ld_buff == NULL)
+		goto mem_msg;
+
+	return_code = sendcmd_withirq(CISS_REPORT_LOG, ctlr, ld_buff,
+				      sizeof(ReportLunData_struct), 0,
+				      0, 0, TYPE_CMD);
 
-		num_luns = listlength / 8;	/* 8 bytes per entry */
-		if (num_luns > CISS_MAX_LUN) {
-			num_luns = CISS_MAX_LUN;
-			printk(KERN_WARNING "cciss: more luns configured"
-			       " on controller than can be handled by"
-			       " this driver.\n");
+	if (return_code == IO_OK)
+		listlength = be32_to_cpu(*(__be32 *) ld_buff->LUNListLength);
+	else {	/* reading number of logical volumes failed */
+		printk(KERN_WARNING "cciss: report logical volume"
+		       " command failed\n");
+		listlength = 0;
+		goto freeret;
+	}
+
+	num_luns = listlength / 8;	/* 8 bytes per entry */
+	if (num_luns > CISS_MAX_LUN) {
+		num_luns = CISS_MAX_LUN;
+		printk(KERN_WARNING "cciss: more luns configured"
+		       " on controller than can be handled by"
+		       " this driver.\n");
+	}
+
+	/* Compare controller drive array to driver's drive array */
+	/* to see if any drives are missing on the controller due */
+	/* to action of Array Config Utility (user deletes drive) */
+	/* and deregister logical drives which have disappeared.  */
+	for (i = 0; i <= h->highest_lun; i++) {
+		int j;
+		drv_found = 0;
+		for (j = 0; j < num_luns; j++) {
+			memcpy(&lunid, &ld_buff->LUN[j][0], 4);
+			lunid = le32_to_cpu(lunid);
+			if (h->drv[i].LunID == lunid) {
+				drv_found = 1;
+				break;
+			}
+		}
+		if (!drv_found) {
+			/* Deregister it from the OS, it's gone. */
+			spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+			h->drv[i].busy_configuring = 1;
+			spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+			return_code = deregister_disk(h->gendisk[i],
+				&h->drv[i], 1);
+			h->drv[i].busy_configuring = 0;
 		}
+	}
 
-		/* Compare controller drive array to drivers drive array.
-		 * Check for updates in the drive information and any new drives
-		 * on the controller.
-		 */
-		for (i = 0; i < num_luns; i++) {
-			int j;
+	/* Compare controller drive array to driver's drive array.
+	 * Check for updates in the drive information and any new drives
+	 * on the controller due to ACU adding logical drives, or changing
+	 * a logical drive's size, etc.  Reregister any new/changed drives
+	 */
+	for (i = 0; i < num_luns; i++) {
+		int j;
 
-			drv_found = 0;
+		drv_found = 0;
 
-			lunid = (0xff &
-				 (unsigned int)(ld_buff->LUN[i][3])) << 24;
-			lunid |= (0xff &
-				  (unsigned int)(ld_buff->LUN[i][2])) << 16;
-			lunid |= (0xff &
-				  (unsigned int)(ld_buff->LUN[i][1])) << 8;
-			lunid |= 0xff & (unsigned int)(ld_buff->LUN[i][0]);
+		memcpy(&lunid, &ld_buff->LUN[i][0], 4);
+		lunid = le32_to_cpu(lunid);
 
-			/* Find if the LUN is already in the drive array
-			 * of the controller.  If so then update its info
-			 * if not is use.  If it does not exist then find
-			 * the first free index and add it.
-			 */
-			for (j = 0; j <= h->highest_lun; j++) {
-				if (h->drv[j].LunID == lunid) {
-					drv_index = j;
-					drv_found = 1;
-				}
+		/* Find if the LUN is already in the drive array
+		 * of the driver.  If so then update its info
+		 * if not in use.  If it does not exist then find
+		 * the first free index and add it.
+		 */
+		for (j = 0; j <= h->highest_lun; j++) {
+			if (h->drv[j].raid_level != -1 &&
+				h->drv[j].LunID == lunid) {
+				drv_index = j;
+				drv_found = 1;
+				break;
 			}
+		}
 
-			/* check if the drive was found already in the array */
-			if (!drv_found) {
-				drv_index = cciss_find_free_drive_index(ctlr);
-				if (drv_index == -1)
-					goto freeret;
-
-				/*Check if the gendisk needs to be allocated */
+		/* check if the drive was found already in the array */
+		if (!drv_found) {
+			drv_index = cciss_find_free_drive_index(ctlr);
+			if (drv_index == -1)
+				goto freeret;
+			/*Check if the gendisk needs to be allocated */
+			if (!h->gendisk[drv_index]) {
+				h->gendisk[drv_index] =
+					alloc_disk(1 << NWD_SHIFT);
 				if (!h->gendisk[drv_index]){
-					h->gendisk[drv_index] = alloc_disk(1 << NWD_SHIFT);
-					if (!h->gendisk[drv_index]){
-						printk(KERN_ERR "cciss: could not allocate new disk %d\n", drv_index);
-						goto mem_msg;
-					}
+					printk(KERN_ERR "cciss: could not "
+						"allocate new disk %d\n",
+						drv_index);
+					goto mem_msg;
 				}
 			}
 			h->drv[drv_index].LunID = lunid;
-			cciss_update_drive_info(ctlr, drv_index);
-		}		/* end for */
-	}			/* end else */
+
+			/* Don't need to mark this busy because nobody
+			 * else knows about this disk yet to contend
+			 * for access to it.
+			 */
+			h->drv[drv_index].busy_configuring = 0;
+			wmb();
+
+		}
+		cciss_update_drive_info(ctlr, drv_index);
+	}		/* end for */
 
       freeret:
 	kfree(ld_buff);
@@ -1599,6 +1687,7 @@ static int rebuild_lun_table(ctlr_info_t *h, struct gendisk *del_disk)
 	return -1;
       mem_msg:
 	printk(KERN_ERR "cciss: out of memory\n");
+	h->busy_configuring = 0;
 	goto freeret;
 }
 
@@ -1654,15 +1743,15 @@ static int deregister_disk(struct gendisk *disk, drive_info_struct *drv,
 		 * other than disk 0 we will call put_disk.  We do not
 		 * do this for disk 0 as we need it to be able to
 		 * configure the controller.
-		*/
+		 */
 		if (clear_all){
 			/* This isn't pretty, but we need to find the
 			 * disk in our array and NULL our the pointer.
 			 * This is so that we will call alloc_disk if
 			 * this index is used again later.
-			*/
+			 */
 			for (i=0; i < CISS_MAX_LUN; i++){
-				if(h->gendisk[i] == disk){
+				if (h->gendisk[i] == disk) {
 					h->gendisk[i] = NULL;
 					break;
 				}
@@ -1690,7 +1779,7 @@ static int deregister_disk(struct gendisk *disk, drive_info_struct *drv,
 		if (drv == h->drv + h->highest_lun) {
 			/* if so, find the new hightest lun */
 			int i, newhighest = -1;
-			for (i = 0; i < h->highest_lun; i++) {
+			for (i = 0; i <= h->highest_lun; i++) {
 				/* if the disk has size > 0, it is available */
 				if (h->drv[i].heads)
 					newhighest = i;
@@ -3320,6 +3409,9 @@ geo_inq:
 			cciss_geometry_inquiry(cntl_num, i, 0, total_size,
 					       block_size, inq_buff,
 					       &hba[cntl_num]->drv[i]);
+			cciss_get_serial_no(cntl_num, i, 0,
+				hba[cntl_num]->drv[i].serial_no,
+				sizeof(hba[cntl_num]->drv[i].serial_no));
 		} else {
 			/* initialize raid_level to indicate a free space */
 			hba[cntl_num]->drv[i].raid_level = -1;
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index b70988d..24a7efa 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -39,6 +39,8 @@ typedef struct _drive_info_struct
 				   *to prevent it from being opened or it's queue
 				   *from being started.
 				  */
+	__u8 serial_no[16]; /* from inquiry page 0x83, */
+			    /* not necc. null terminated. */
 } drive_info_struct;
 
 #ifdef CONFIG_CISS_SCSI_TAPE
