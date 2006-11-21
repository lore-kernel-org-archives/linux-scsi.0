From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 1/2] SCSI: make sd and sr use sdev->timeout consistently, take #2
Date: Tue, 21 Nov 2006 12:11:01 +0900
Message-ID: <20061121031101.GS2184@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:54719 "EHLO
	ug-out-1314.google.com") by vger.kernel.org with ESMTP
	id S966910AbWKUDLK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Nov 2006 22:11:10 -0500
Received: by ug-out-1314.google.com with SMTP id m3so1396731ugc
        for <linux-scsi@vger.kernel.org>; Mon, 20 Nov 2006 19:11:09 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org
Cc: Kai.Makisara@kolumbus.fi

sd and sr use scsi_device->timeout differently.

* sd sets sdev->timeout to SD_TIMEOUT if it's zero on attach.
  sdev->timeout is used for commands received from block queue but
 internal commands use SD_TIMEOUT directly.

* sr uses constant SR_TIMEOUT for all non-ioctl commands and
  IOCTL_TIMEOUT for sr ioctls.

This patch unifies differing behaviors as follows.

* Both initialize sdev->timeout to its default value iff it's zero;
  otherwise, the specified value is used.

* All commands w/o specific timeout requirement use sdev->timeout.
  Commands which require special timeout uses HL-specific value such
  as IOCTL_TIMEOUT.

This patch also adds sdev local variable for shorter notation where
multiple references to sdev are added.

st and osst have different requirements and will be updated separately
if necessary.

Signed-off-by: Tejun Heo <htejun@gmail.com>

Index: scsi-misc-2.6/drivers/scsi/sd.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sd.c	2006-11-19 21:14:59.000000000 +0900
+++ scsi-misc-2.6/drivers/scsi/sd.c	2006-11-21 11:38:19.000000000 +0900
@@ -186,7 +186,7 @@ static ssize_t sd_store_cache_type(struc
 		return -EINVAL;
 	rcd = ct & 0x01 ? 1 : 0;
 	wce = ct & 0x02 ? 1 : 0;
-	if (scsi_mode_sense(sdp, 0x08, 8, buffer, sizeof(buffer), SD_TIMEOUT,
+	if (scsi_mode_sense(sdp, 0x08, 8, buffer, sizeof(buffer), sdp->timeout,
 			    SD_MAX_RETRIES, &data, NULL))
 		return -EINVAL;
 	len = min_t(size_t, sizeof(buffer), data.length - data.header_length -
@@ -197,7 +197,7 @@ static ssize_t sd_store_cache_type(struc
 	buffer_data[2] |= wce << 2 | rcd;
 	sp = buffer_data[0] & 0x80 ? 1 : 0;
 
-	if (scsi_mode_select(sdp, 1, sp, 8, buffer_data, len, SD_TIMEOUT,
+	if (scsi_mode_select(sdp, 1, sp, 8, buffer_data, len, sdp->timeout,
 			     SD_MAX_RETRIES, &data, &sshdr)) {
 		if (scsi_sense_valid(&sshdr))
 			scsi_print_sense_hdr(sdkp->disk->disk_name, &sshdr);
@@ -370,7 +370,6 @@ static int sd_init_command(struct scsi_c
 	struct gendisk *disk = rq->rq_disk;
 	sector_t block = rq->sector;
 	unsigned int this_count = SCpnt->request_bufflen >> 9;
-	unsigned int timeout = sdp->timeout;
 
 	SCSI_LOG_HLQUEUE(1, printk("sd_init_command: disk=%s, block=%llu, "
 			    "count=%d\n", disk->disk_name,
@@ -511,7 +510,7 @@ static int sd_init_command(struct scsi_c
 	SCpnt->transfersize = sdp->sector_size;
 	SCpnt->underflow = this_count << 9;
 	SCpnt->allowed = SD_MAX_RETRIES;
-	SCpnt->timeout_per_command = timeout;
+	SCpnt->timeout_per_command = sdp->timeout;
 
 	/*
 	 * This is the completion routine we use.  This is matched in terms
@@ -759,7 +758,7 @@ static int sd_media_changed(struct gendi
 	 */
 	retval = -ENODEV;
 	if (scsi_block_when_processing_errors(sdp))
-		retval = scsi_test_unit_ready(sdp, SD_TIMEOUT, SD_MAX_RETRIES);
+		retval = scsi_test_unit_ready(sdp, sdp->timeout, SD_MAX_RETRIES);
 
 	/*
 	 * Unable to test, unit probably not ready.   This usually
@@ -805,7 +804,7 @@ static int sd_sync_cache(struct scsi_dev
 		 * flush everything.
 		 */
 		res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
-				       SD_TIMEOUT, SD_MAX_RETRIES);
+				       sdp->timeout, SD_MAX_RETRIES);
 		if (res == 0)
 			break;
 	}
@@ -838,9 +837,12 @@ static int sd_issue_flush(struct device 
 
 static void sd_prepare_flush(request_queue_t *q, struct request *rq)
 {
+	struct device *dev = rq->rq_disk->driverfs_dev;
+	struct scsi_device *sdp = to_scsi_device(dev);
+
 	memset(rq->cmd, 0, sizeof(rq->cmd));
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
-	rq->timeout = SD_TIMEOUT;
+	rq->timeout = sdp->timeout;
 	rq->cmd[0] = SYNCHRONIZE_CACHE;
 	rq->cmd_len = 10;
 }
@@ -1028,6 +1030,7 @@ static int media_not_present(struct scsi
 static void
 sd_spinup_disk(struct scsi_disk *sdkp, char *diskname)
 {
+	struct scsi_device *sdp = sdkp->device;
 	unsigned char cmd[10];
 	unsigned long spintime_expire = 0;
 	int retries, spintime;
@@ -1046,9 +1049,9 @@ sd_spinup_disk(struct scsi_disk *sdkp, c
 			cmd[0] = TEST_UNIT_READY;
 			memset((void *) &cmd[1], 0, 9);
 
-			the_result = scsi_execute_req(sdkp->device, cmd,
+			the_result = scsi_execute_req(sdp, cmd,
 						      DMA_NONE, NULL, 0,
-						      &sshdr, SD_TIMEOUT,
+						      &sshdr, sdp->timeout,
 						      SD_MAX_RETRIES);
 
 			/*
@@ -1079,7 +1082,7 @@ sd_spinup_disk(struct scsi_disk *sdkp, c
 		/*
 		 * The device does not want the automatic start to be issued.
 		 */
-		if (sdkp->device->no_start_on_add) {
+		if (sdp->no_start_on_add) {
 			break;
 		}
 
@@ -1103,9 +1106,9 @@ sd_spinup_disk(struct scsi_disk *sdkp, c
 				cmd[1] = 1;	/* Return immediately */
 				memset((void *) &cmd[2], 0, 8);
 				cmd[4] = 1;	/* Start spin cycle */
-				scsi_execute_req(sdkp->device, cmd, DMA_NONE,
+				scsi_execute_req(sdp, cmd, DMA_NONE,
 						 NULL, 0, &sshdr,
-						 SD_TIMEOUT, SD_MAX_RETRIES);
+						 sdp->timeout, SD_MAX_RETRIES);
 				spintime_expire = jiffies + 100 * HZ;
 				spintime = 1;
 			}
@@ -1180,7 +1183,7 @@ repeat:
 		
 		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
 					      buffer, longrc ? 12 : 8, &sshdr,
-					      SD_TIMEOUT, SD_MAX_RETRIES);
+					      sdp->timeout, SD_MAX_RETRIES);
 
 		if (media_not_present(sdkp, &sshdr))
 			return;
@@ -1345,7 +1348,7 @@ sd_do_mode_sense(struct scsi_device *sdp
 		 struct scsi_sense_hdr *sshdr)
 {
 	return scsi_mode_sense(sdp, dbd, modepage, buffer, len,
-			       SD_TIMEOUT, SD_MAX_RETRIES, data,
+			       sdp->timeout, SD_MAX_RETRIES, data,
 			       sshdr);
 }
 
Index: scsi-misc-2.6/drivers/scsi/sr.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sr.c	2006-11-19 21:14:59.000000000 +0900
+++ scsi-misc-2.6/drivers/scsi/sr.c	2006-11-21 11:38:19.000000000 +0900
@@ -177,6 +177,7 @@ static void scsi_cd_put(struct scsi_cd *
 int sr_media_change(struct cdrom_device_info *cdi, int slot)
 {
 	struct scsi_cd *cd = cdi->handle;
+	struct scsi_device *sdev = cd->device;
 	int retval;
 
 	if (CDSL_CURRENT != slot) {
@@ -184,19 +185,19 @@ int sr_media_change(struct cdrom_device_
 		return -EINVAL;
 	}
 
-	retval = scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES);
+	retval = scsi_test_unit_ready(sdev, sdev->timeout, MAX_RETRIES);
 	if (retval) {
 		/* Unable to test, unit probably not ready.  This usually
 		 * means there is no disc in the drive.  Mark as changed,
 		 * and we will figure it out later once the drive is
 		 * available again.  */
-		cd->device->changed = 1;
+		sdev->changed = 1;
 		return 1;	/* This will force a flush, if called from
 				 * check_disk_change */
 	};
 
-	retval = cd->device->changed;
-	cd->device->changed = 0;
+	retval = sdev->changed;
+	sdev->changed = 0;
 	/* If the disk changed, the capacity will now be different,
 	 * so we force a re-read of this information */
 	if (retval) {
@@ -297,20 +298,21 @@ static void rw_intr(struct scsi_cmnd * S
 
 static int sr_init_command(struct scsi_cmnd * SCpnt)
 {
-	int block=0, this_count, s_size, timeout = SR_TIMEOUT;
+	int block=0, this_count, s_size;
 	struct scsi_cd *cd = scsi_cd(SCpnt->request->rq_disk);
+	struct scsi_device *sdev = cd->device;
 
 	SCSI_LOG_HLQUEUE(1, printk("Doing sr request, dev = %s, block = %d\n",
 				cd->disk->disk_name, block));
 
-	if (!cd->device || !scsi_device_online(cd->device)) {
+	if (!sdev || !scsi_device_online(sdev)) {
 		SCSI_LOG_HLQUEUE(2, printk("Finishing %ld sectors\n",
 					SCpnt->request->nr_sectors));
 		SCSI_LOG_HLQUEUE(2, printk("Retry with 0x%p\n", SCpnt));
 		return 0;
 	}
 
-	if (cd->device->changed) {
+	if (sdev->changed) {
 		/*
 		 * quietly refuse to do anything to a changed disc until the
 		 * changed bit has been reset
@@ -322,7 +324,7 @@ static int sr_init_command(struct scsi_c
 	 * we do lazy blocksize switching (when reading XA sectors,
 	 * see CDROMREADMODE2 ioctl) 
 	 */
-	s_size = cd->device->sector_size;
+	s_size = sdev->sector_size;
 	if (s_size > 2048) {
 		if (!in_interrupt())
 			sr_set_blocklength(cd, 2048);
@@ -336,7 +338,7 @@ static int sr_init_command(struct scsi_c
 	}
 
 	if (rq_data_dir(SCpnt->request) == WRITE) {
-		if (!cd->device->writeable)
+		if (!sdev->writeable)
 			return 0;
 		SCpnt->cmnd[0] = WRITE_10;
 		SCpnt->sc_data_direction = DMA_TO_DEVICE;
@@ -403,10 +405,10 @@ static int sr_init_command(struct scsi_c
 	 * host adapter, it's safe to assume that we can at least transfer
 	 * this many bytes between each connect / disconnect.
 	 */
-	SCpnt->transfersize = cd->device->sector_size;
+	SCpnt->transfersize = sdev->sector_size;
 	SCpnt->underflow = this_count << 9;
 	SCpnt->allowed = MAX_RETRIES;
-	SCpnt->timeout_per_command = timeout;
+	SCpnt->timeout_per_command = sdev->timeout;
 
 	/*
 	 * This is the completion routine we use.  This is matched in terms
@@ -579,6 +581,9 @@ static int sr_probe(struct device *dev)
 	cd->readcd_known = 0;
 	cd->readcd_cdda = 0;
 
+	if (!sdev->timeout)
+		sdev->timeout = SR_TIMEOUT;
+
 	cd->cdi.ops = &sr_dops;
 	cd->cdi.handle = cd;
 	cd->cdi.mask = 0;
@@ -619,6 +624,7 @@ fail:
 
 static void get_sectorsize(struct scsi_cd *cd)
 {
+	struct scsi_device *sdev = cd->device;
 	unsigned char cmd[10];
 	unsigned char *buffer;
 	int the_result, retries = 3;
@@ -635,8 +641,8 @@ static void get_sectorsize(struct scsi_c
 		memset(buffer, 0, 8);
 
 		/* Do the command and wait.. */
-		the_result = scsi_execute_req(cd->device, cmd, DMA_FROM_DEVICE,
-					      buffer, 8, NULL, SR_TIMEOUT,
+		the_result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE,
+					      buffer, 8, NULL, sdev->timeout,
 					      MAX_RETRIES);
 
 		retries--;
@@ -681,7 +687,7 @@ static void get_sectorsize(struct scsi_c
 			cd->capacity = 0;
 		}
 
-		cd->device->sector_size = sector_size;
+		sdev->sector_size = sector_size;
 
 		/*
 		 * Add this so that we have the ability to correctly gauge
@@ -690,7 +696,7 @@ static void get_sectorsize(struct scsi_c
 		set_capacity(cd->disk, cd->capacity);
 	}
 
-	queue = cd->device->request_queue;
+	queue = sdev->request_queue;
 	blk_queue_hardsect_size(queue, sector_size);
 out:
 	kfree(buffer);
@@ -698,12 +704,13 @@ out:
 
 Enomem:
 	cd->capacity = 0x1fffff;
-	cd->device->sector_size = 2048;	/* A guess, just in case */
+	sdev->sector_size = 2048;	/* A guess, just in case */
 	goto out;
 }
 
 static void get_capabilities(struct scsi_cd *cd)
 {
+	struct scsi_device *sdev = cd->device;
 	unsigned char *buffer;
 	struct scsi_mode_data data;
 	unsigned char cmd[MAX_COMMAND_SIZE];
@@ -739,8 +746,8 @@ static void get_capabilities(struct scsi
 		memset((void *)cmd, 0, MAX_COMMAND_SIZE);
 		cmd[0] = TEST_UNIT_READY;
 
-		the_result = scsi_execute_req (cd->device, cmd, DMA_NONE, NULL,
-					       0, &sshdr, SR_TIMEOUT,
+		the_result = scsi_execute_req (sdev, cmd, DMA_NONE, NULL,
+					       0, &sshdr, sdev->timeout,
 					       MAX_RETRIES);
 
 		retries++;
@@ -750,8 +757,8 @@ static void get_capabilities(struct scsi
 		   sshdr.sense_key == UNIT_ATTENTION)));
 
 	/* ask for mode page 0x2a */
-	rc = scsi_mode_sense(cd->device, 0, 0x2a, buffer, 128,
-			     SR_TIMEOUT, 3, &data, NULL);
+	rc = scsi_mode_sense(sdev, 0, 0x2a, buffer, 128,
+			     sdev->timeout, 3, &data, NULL);
 
 	if (!scsi_status_is_good(rc)) {
 		/* failed, drive doesn't have capabilities mode page */
@@ -816,7 +823,7 @@ static void get_capabilities(struct scsi
 	 */
 	if ((cd->cdi.mask & (CDC_DVD_RAM | CDC_MRW_W | CDC_RAM | CDC_CD_RW)) !=
 			(CDC_DVD_RAM | CDC_MRW_W | CDC_RAM | CDC_CD_RW)) {
-		cd->device->writeable = 1;
+		sdev->writeable = 1;
 	}
 
 	kfree(buffer);
