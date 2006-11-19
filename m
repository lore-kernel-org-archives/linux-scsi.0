From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH RESEND 1/2] SCSI: use scsi_device->timeout consistently
Date: Sun, 19 Nov 2006 21:51:15 +0900
Message-ID: <20061119125115.GJ2184@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:32413 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S1756588AbWKSMvZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Nov 2006 07:51:25 -0500
Received: by nf-out-0910.google.com with SMTP id o25so1953399nfa
        for <linux-scsi@vger.kernel.org>; Sun, 19 Nov 2006 04:51:23 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

Each high level driver uses scsi_device->timeout diffrently.

* sd sets sdev->timeout to SD_TIMEOUT if it's zero on attach.
  sdev->timeout is used for commands received from block queue but
 internal commands use SD_TIMEOUT directly.

* sr uses constant SR_TIMEOUT for all non-ioctl commands and
  IOCTL_TIMEOUT for sr ioctls.

* st sets sdev->timeout to ST_TIMEOUT unconditionally.  st uses
  either sdev->timeout or scsi_tape->long_timeout depending on command
  type.

* osst uses osst_tape->timeout and osst_tape->long_timeout.

This patch unifies differing behaviors as follows.

* All highlevel drivers initialize sdev->timeout to its default value
  iff it's zero; otherwise, the specified value is used.

* All commands w/o specific timeout requirement use sdev->timeout.
  Commands which require special timeout uses HL-specific value such
  as IOCTL_TIMEOUT and scsi/osst_tape->long_timeout.

This patch also adds sdev local variable for shorter notation where
multiple references to sdev are added.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---

Sorry, the original post had linux-scsi-owner@vger instead of
linux-scsi@vger.  Reposting.

 drivers/scsi/osst.c |   78 ++++++++++++++++++++++++++--------------------------
 drivers/scsi/osst.h |    1 
 drivers/scsi/sd.c   |   31 +++++++++++---------
 drivers/scsi/sr.c   |   49 ++++++++++++++++++--------------
 drivers/scsi/st.c   |    3 +-
 5 files changed, 87 insertions(+), 75 deletions(-)

Index: scsi-misc-2.6/drivers/scsi/sd.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sd.c
+++ scsi-misc-2.6/drivers/scsi/sd.c
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
--- scsi-misc-2.6.orig/drivers/scsi/sr.c
+++ scsi-misc-2.6/drivers/scsi/sr.c
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
Index: scsi-misc-2.6/drivers/scsi/st.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/st.c
+++ scsi-misc-2.6/drivers/scsi/st.c
@@ -3986,7 +3986,8 @@ static int st_probe(struct device *dev)
 	tpnt->partition = 0;
 	tpnt->new_partition = 0;
 	tpnt->nbr_partitions = 0;
-	tpnt->device->timeout = ST_TIMEOUT;
+	if (!SDp->timeout)
+		SDp->timeout = ST_TIMEOUT;
 	tpnt->long_timeout = ST_LONG_TIMEOUT;
 	tpnt->try_dio = try_direct_io && !SDp->host->unchecked_isa_dma;
 
Index: scsi-misc-2.6/drivers/scsi/osst.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/osst.c
+++ scsi-misc-2.6/drivers/scsi/osst.c
@@ -683,7 +683,7 @@ static int osst_wait_ready(struct osst_t
 	memset(cmd, 0, MAX_COMMAND_SIZE);
 	cmd[0] = TEST_UNIT_READY;
 
-	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, 0, DMA_NONE, STp->timeout, MAX_RETRIES, 1);
+	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, 0, DMA_NONE, STp->device->timeout, MAX_RETRIES, 1);
 	*aSRpnt = SRpnt;
 	if (!SRpnt) return (-EBUSY);
 
@@ -704,7 +704,7 @@ static int osst_wait_ready(struct osst_t
 	    memset(cmd, 0, MAX_COMMAND_SIZE);
 	    cmd[0] = TEST_UNIT_READY;
 
-	    SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE, STp->timeout, MAX_RETRIES, 1);
+	    SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE, STp->device->timeout, MAX_RETRIES, 1);
 	}
 	*aSRpnt = SRpnt;
 #if DEBUG
@@ -744,7 +744,7 @@ static int osst_wait_for_medium(struct o
 	memset(cmd, 0, MAX_COMMAND_SIZE);
 	cmd[0] = TEST_UNIT_READY;
 
-	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, 0, DMA_NONE, STp->timeout, MAX_RETRIES, 1);
+	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, 0, DMA_NONE, STp->device->timeout, MAX_RETRIES, 1);
 	*aSRpnt = SRpnt;
 	if (!SRpnt) return (-EBUSY);
 
@@ -762,7 +762,7 @@ static int osst_wait_for_medium(struct o
 	    memset(cmd, 0, MAX_COMMAND_SIZE);
 	    cmd[0] = TEST_UNIT_READY;
 
-	    SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE, STp->timeout, MAX_RETRIES, 1);
+	    SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE, STp->device->timeout, MAX_RETRIES, 1);
 	}
 	*aSRpnt = SRpnt;
 #if DEBUG
@@ -814,7 +814,7 @@ static int osst_flush_drive_buffer(struc
 	cmd[0] = WRITE_FILEMARKS;
 	cmd[1] = 1;
 
-	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, 0, DMA_NONE, STp->timeout, MAX_RETRIES, 1);
+	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, 0, DMA_NONE, STp->device->timeout, MAX_RETRIES, 1);
 	*aSRpnt = SRpnt;
 	if (!SRpnt) return (-EBUSY);
 	if (STp->buffer->syscall_result) {
@@ -905,8 +905,8 @@ static int osst_recover_wait_frame(struc
 		memset(cmd, 0, MAX_COMMAND_SIZE);
 		cmd[0] = WRITE_FILEMARKS;
 		cmd[1] = 1;
-		SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, 0, DMA_NONE, STp->timeout,
-								MAX_RETRIES, 1);
+		SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, 0, DMA_NONE,
+				     STp->device->timeout, MAX_RETRIES, 1);
 
 		while (retval && time_before (jiffies, startwait + 5*60*HZ)) {
 
@@ -922,8 +922,8 @@ static int osst_recover_wait_frame(struc
 			memset(cmd, 0, MAX_COMMAND_SIZE);
 			cmd[0] = READ_POSITION;
 
-			SRpnt = osst_do_scsi(SRpnt, STp, cmd, 20, DMA_FROM_DEVICE, STp->timeout,
-										MAX_RETRIES, 1);
+			SRpnt = osst_do_scsi(SRpnt, STp, cmd, 20, DMA_FROM_DEVICE,
+					     STp->device->timeout, MAX_RETRIES, 1);
 
 			retval = ( STp->buffer->syscall_result || (STp->buffer)->b_data[15] > 25 );
 			STp->buffer->b_data = olddata; STp->buffer->buffer_size = oldsize;
@@ -969,7 +969,7 @@ static int osst_read_frame(struct osst_t
 		printk(OSST_DEB_MSG "%s:D: Reading frame from OnStream tape\n", name);
 #endif
 	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, OS_FRAME_SIZE, DMA_FROM_DEVICE,
-				      STp->timeout, MAX_RETRIES, 1);
+				      STp->device->timeout, MAX_RETRIES, 1);
 	*aSRpnt = SRpnt;
 	if (!SRpnt)
 		return (-EBUSY);
@@ -1044,7 +1044,8 @@ static int osst_initiate_read(struct oss
 #if DEBUG
 		printk(OSST_DEB_MSG "%s:D: Start Read Ahead on OnStream tape\n", name);
 #endif
-		SRpnt   = osst_do_scsi(*aSRpnt, STp, cmd, 0, DMA_NONE, STp->timeout, MAX_RETRIES, 1);
+		SRpnt   = osst_do_scsi(*aSRpnt, STp, cmd, 0, DMA_NONE,
+				       STp->device->timeout, MAX_RETRIES, 1);
 		*aSRpnt = SRpnt;
 		if ((retval = STp->buffer->syscall_result))
 			printk(KERN_WARNING "%s:W: Error starting read ahead\n", name);
@@ -1426,7 +1427,7 @@ static int osst_read_back_buffer_and_rew
 		cmd[8] = 32768 & 0xff;
 
 		SRpnt = osst_do_scsi(SRpnt, STp, cmd, OS_FRAME_SIZE, DMA_FROM_DEVICE,
-					    STp->timeout, MAX_RETRIES, 1);
+				     STp->device->timeout, MAX_RETRIES, 1);
 	
 		if ((STp->buffer)->syscall_result || !SRpnt) {
 			printk(KERN_ERR "%s:E: Failed to read frame back from OnStream buffer\n", name);
@@ -1498,7 +1499,7 @@ static int osst_read_back_buffer_and_rew
 				p[0], p[1], p[2], p[3]);
 #endif
 		SRpnt = osst_do_scsi(SRpnt, STp, cmd, OS_FRAME_SIZE, DMA_TO_DEVICE,
-					    STp->timeout, MAX_RETRIES, 1);
+				     STp->device->timeout, MAX_RETRIES, 1);
 
 		if (STp->buffer->syscall_result)
 			flag = 1;
@@ -1514,7 +1515,7 @@ static int osst_read_back_buffer_and_rew
 				cmd[0] = WRITE_FILEMARKS;
 				cmd[1] = 1;
 				SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE,
-							    STp->timeout, MAX_RETRIES, 1);
+						     STp->device->timeout, MAX_RETRIES, 1);
 #if DEBUG
 				if (debugging) {
 					printk(OSST_DEB_MSG "%s:D: Sleeping in re-write wait ready\n", name);
@@ -1528,8 +1529,8 @@ static int osst_read_back_buffer_and_rew
 					memset(cmd, 0, MAX_COMMAND_SIZE);
 					cmd[0] = TEST_UNIT_READY;
 
-					SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE, STp->timeout,
-												MAX_RETRIES, 1);
+					SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE,
+							     STp->device->timeout, MAX_RETRIES, 1);
 
 					if (SRpnt->sense[2] == 2 && SRpnt->sense[12] == 4 &&
 					    (SRpnt->sense[13] == 1 || SRpnt->sense[13] == 8)) {
@@ -1634,7 +1635,7 @@ static int osst_reposition_and_retry(str
 					  name, STp->frame_seq_number-1, STp->first_frame_position);
 #endif
 			SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, OS_FRAME_SIZE, DMA_TO_DEVICE,
-						      STp->timeout, MAX_RETRIES, 1);
+					     STp->device->timeout, MAX_RETRIES, 1);
 			*aSRpnt = SRpnt;
 
 			if (STp->buffer->syscall_result) {		/* additional write error */
@@ -2091,7 +2092,7 @@ static void osst_set_retries(struct osst
 	if (debugging)
 	    printk(OSST_DEB_MSG "%s:D: Setting number of retries on OnStream tape to %d\n", name, retries);
 
-	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_TO_DEVICE, STp->timeout, 0, 1);
+	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_TO_DEVICE, STp->device->timeout, 0, 1);
 	*aSRpnt = SRpnt;
 
 	if ((STp->buffer)->syscall_result)
@@ -2631,7 +2632,7 @@ static int osst_configure_onstream(struc
 	cmd[2] = BLOCK_SIZE_PAGE;
 	cmd[4] = BLOCK_SIZE_PAGE_LENGTH + MODE_HEADER_LENGTH;
 
-	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE, STp->timeout, 0, 1);
+	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE, STp->device->timeout, 0, 1);
 	if (SRpnt == NULL) {
 #if DEBUG
  	    printk(OSST_DEB_MSG "osst :D: Busy\n");
@@ -2668,7 +2669,7 @@ static int osst_configure_onstream(struc
 	cmd[1] = 0x10;
 	cmd[4] = BLOCK_SIZE_PAGE_LENGTH + MODE_HEADER_LENGTH;
 
-	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_TO_DEVICE, STp->timeout, 0, 1);
+	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_TO_DEVICE, STp->device->timeout, 0, 1);
 	*aSRpnt = SRpnt;
 	if ((STp->buffer)->syscall_result != 0) {
 	    printk (KERN_ERR "%s:E: Couldn't set tape block size mode page\n", name);
@@ -2708,7 +2709,7 @@ static int osst_configure_onstream(struc
 	(STp->buffer)->b_data[MODE_HEADER_LENGTH + 6] = 0;
 	(STp->buffer)->b_data[MODE_HEADER_LENGTH + 7] = 0;
 
-	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_TO_DEVICE, STp->timeout, 0, 1);
+	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_TO_DEVICE, STp->device->timeout, 0, 1);
 	*aSRpnt = SRpnt;
 
 	if ((STp->buffer)->syscall_result != 0) {
@@ -2723,7 +2724,7 @@ static int osst_configure_onstream(struc
 	cmd[2] = CAPABILITIES_PAGE;
 	cmd[4] = CAPABILITIES_PAGE_LENGTH + MODE_HEADER_LENGTH;
 
-	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE, STp->timeout, 0, 1);
+	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE, STp->device->timeout, 0, 1);
 	*aSRpnt = SRpnt;
 
 	if ((STp->buffer)->syscall_result != 0) {
@@ -2743,7 +2744,7 @@ static int osst_configure_onstream(struc
 	cmd[2] = TAPE_PARAMTR_PAGE;
 	cmd[4] = TAPE_PARAMTR_PAGE_LENGTH + MODE_HEADER_LENGTH;
 
-	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE, STp->timeout, 0, 1);
+	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE, STp->device->timeout, 0, 1);
 	*aSRpnt = SRpnt;
 
 	if ((STp->buffer)->syscall_result != 0) {
@@ -2818,7 +2819,7 @@ static int osst_get_frame_position(struc
 
 	STp->buffer->b_data = mybuf; STp->buffer->buffer_size = 24;
 	SRpnt = osst_do_scsi(*aSRpnt, STp, scmd, 20, DMA_FROM_DEVICE,
-				      STp->timeout, MAX_RETRIES, 1);
+			     STp->device->timeout, MAX_RETRIES, 1);
 	if (!SRpnt) {
 		STp->buffer->b_data = olddata; STp->buffer->buffer_size = oldsize;
 		return (-EBUSY);
@@ -2838,7 +2839,7 @@ static int osst_get_frame_position(struc
 			scmd[0] = READ_POSITION;
 			STp->buffer->b_data = mybuf; STp->buffer->buffer_size = 24;
 			SRpnt = osst_do_scsi(SRpnt, STp, scmd, 20, DMA_FROM_DEVICE,
-						    STp->timeout, MAX_RETRIES, 1);
+					     STp->device->timeout, MAX_RETRIES, 1);
 #if DEBUG
 			printk(OSST_DEB_MSG "%s:D: Reread position, reason=[%02x:%02x:%02x], result=[%s%02x:%02x:%02x]\n",
 					name, mysense[2], mysense[12], mysense[13], STp->buffer->syscall_result?"":"ok:",
@@ -3055,7 +3056,7 @@ static int osst_flush_write_buffer(struc
 #endif
 
 		SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, transfer, DMA_TO_DEVICE,
-					      STp->timeout, MAX_RETRIES, 1);
+				     STp->device->timeout, MAX_RETRIES, 1);
 		*aSRpnt = SRpnt;
 		if (!SRpnt)
 			return (-EBUSY);
@@ -3211,8 +3212,8 @@ static int osst_write_frame(struct osst_
 	if (!synchronous)
 		STp->write_pending = 1;
 #endif
-	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, OS_FRAME_SIZE, DMA_TO_DEVICE, STp->timeout,
-									MAX_RETRIES, synchronous);
+	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, OS_FRAME_SIZE, DMA_TO_DEVICE, STp->device->timeout,
+			     MAX_RETRIES, synchronous);
 	if (!SRpnt)
 		return (-EBUSY);
 	*aSRpnt = SRpnt;
@@ -3921,7 +3922,7 @@ static int osst_set_options(struct osst_
 					     (value & ~MT_ST_SET_LONG_TIMEOUT));
 		}
 		else {
-			STp->timeout = value * HZ;
+			STp->device->timeout = value * HZ;
 			printk(KERN_INFO "%s:I: Normal timeout set to %d seconds.\n", name, value);
 		}
 	}
@@ -4112,7 +4113,7 @@ static int osst_int_ioctl(struct osst_ta
 		 cmd[2] = (arg >> 16);
 		 cmd[3] = (arg >> 8);
 		 cmd[4] = arg;
-		 timeout = STp->timeout;
+		 timeout = STp->device->timeout;
 #if DEBUG
 		 if (debugging) 
 			   printk(OSST_DEB_MSG "%s:D: Writing %d setmark(s).\n", name,
@@ -4139,7 +4140,7 @@ static int osst_int_ioctl(struct osst_ta
 			 cmd[4] = 3;		/* retension then mount */
 		 if (cmd_in == MTOFFL)
 			 cmd[4] = 4;		/* rewind then eject */
-		 timeout = STp->timeout;
+		 timeout = STp->device->timeout;
 #if DEBUG
 		 if (debugging) {
 			 switch (cmd_in) {
@@ -4464,7 +4465,7 @@ static int os_scsi_tape_open(struct inod
 	memset (cmd, 0, MAX_COMMAND_SIZE);
 	cmd[0] = TEST_UNIT_READY;
 
-	SRpnt = osst_do_scsi(NULL, STp, cmd, 0, DMA_NONE, STp->timeout, MAX_RETRIES, 1);
+	SRpnt = osst_do_scsi(NULL, STp, cmd, 0, DMA_NONE, STp->device->timeout, MAX_RETRIES, 1);
 	if (!SRpnt) {
 		retval = (STp->buffer)->syscall_result;		/* FIXME - valid? */
 		goto err_out;
@@ -4485,7 +4486,7 @@ static int os_scsi_tape_open(struct inod
 			cmd[1] = 1;
 			cmd[4] = 1;
 			SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE,
-					     STp->timeout, MAX_RETRIES, 1);
+					     STp->device->timeout, MAX_RETRIES, 1);
 		}
 		osst_wait_ready(STp, &SRpnt, (SRpnt->sense[13]==1?15:3) * 60, 0);
 	}
@@ -4502,7 +4503,7 @@ static int os_scsi_tape_open(struct inod
 			cmd[0] = TEST_UNIT_READY;
 
 			SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE,
-					     STp->timeout, MAX_RETRIES, 1);
+					     STp->device->timeout, MAX_RETRIES, 1);
 			if ((SRpnt->sense[0] & 0x70) != 0x70 ||
 			    (SRpnt->sense[2] & 0x0f) != UNIT_ATTENTION)
 				break;
@@ -4538,7 +4539,7 @@ static int os_scsi_tape_open(struct inod
 		cmd[2] = VENDOR_IDENT_PAGE;
 		cmd[4] = VENDOR_IDENT_PAGE_LENGTH + MODE_HEADER_LENGTH;
 
-		SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE, STp->timeout, 0, 1);
+		SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE, STp->device->timeout, 0, 1);
 
 		if (STp->buffer->syscall_result                     ||
 		    STp->buffer->b_data[MODE_HEADER_LENGTH + 2] != 'L' ||
@@ -4601,7 +4602,7 @@ static int os_scsi_tape_open(struct inod
 #if DEBUG
 		printk(OSST_DEB_MSG "%s:D: Applying soft reset\n", name);
 #endif
-		SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_TO_DEVICE, STp->timeout, 0, 1);
+		SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_TO_DEVICE, STp->device->timeout, 0, 1);
 
 		STp->header_ok = 0;
 
@@ -4611,7 +4612,7 @@ static int os_scsi_tape_open(struct inod
 			cmd[0] = TEST_UNIT_READY;
 
 			SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE,
-						    STp->timeout, MAX_RETRIES, 1);
+					     STp->device->timeout, MAX_RETRIES, 1);
 			if ((SRpnt->sense[0] & 0x70) != 0x70 ||
 			    (SRpnt->sense[2] & 0x0f) == NOT_READY)
 			break;
@@ -5822,7 +5823,8 @@ static int osst_probe(struct device *dev
 	tpnt->nbr_partitions = 0;
 	tpnt->min_block = 512;
 	tpnt->max_block = OS_DATA_SIZE;
-	tpnt->timeout = OSST_TIMEOUT;
+	if (!SDp->timeout)
+		SDp->timeout = OSST_TIMEOUT;
 	tpnt->long_timeout = OSST_LONG_TIMEOUT;
 
 	/* Recognize OnStream tapes */
Index: scsi-misc-2.6/drivers/scsi/osst.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/osst.h
+++ scsi-misc-2.6/drivers/scsi/osst.h
@@ -548,7 +548,6 @@ struct osst_tape {
   unsigned char default_drvbuffer;  /* 0xff = don't touch, value 3 bits */
   unsigned char pos_unknown;        /* after reset position unknown */
   int write_threshold;
-  int timeout;			/* timeout for normal commands */
   int long_timeout;		/* timeout for commands known to take long time*/
 
   /* Mode characteristics */
