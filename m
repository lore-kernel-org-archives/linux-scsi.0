From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH RESEND 2/2] SCSI: add scsi_device->retries
Date: Sun, 19 Nov 2006 21:52:00 +0900
Message-ID: <20061119125200.GK2184@htj.dyndns.org>
References: <20061119125115.GJ2184@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:36256 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S1756644AbWKSMwL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Nov 2006 07:52:11 -0500
Received: by nf-out-0910.google.com with SMTP id o25so1953541nfa
        for <linux-scsi@vger.kernel.org>; Sun, 19 Nov 2006 04:52:10 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20061119125115.GJ2184@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

Add scsi_device->retries to provide generic control over command
retries, which is very similar to sdev->timeout.  The initial value is
-1 and high level driver is free to override on attach if negative.
Note that -1 has the same effect as 0 (no retry) and signifies that
it's the default value.  As with sdev->timeout, sdev->retries is
exported under the device sysfs node.

All high level drivers are converted to use it for retry value.
However, there are exceptions.

* sd_sync_cache() and sr::get_sectorsize() loop three more times
  around normal command execution on failure.

* st uses three retry limits - MAX_RETRIES, MAX_WRITE_RETRIES and
  MAX_READY_RETRIES, which are all zero.  This patch only converts
  MAX_RETRIES to sdev->retries.  Defining WRITE and READY retries in
  terms of sdev->retries would make more sense.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 drivers/scsi/osst.c        |  121 +++++++++++++++++++++++++++------------------
 drivers/scsi/scsi_scan.c   |    7 ++
 drivers/scsi/scsi_sysfs.c  |   28 ++++++++++
 drivers/scsi/sd.c          |   22 ++++----
 drivers/scsi/sr.c          |   10 ++-
 drivers/scsi/st.c          |   10 ++-
 include/scsi/scsi_device.h |    1 
 7 files changed, 134 insertions(+), 65 deletions(-)

Index: scsi-misc-2.6/drivers/scsi/sd.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sd.c
+++ scsi-misc-2.6/drivers/scsi/sd.c
@@ -187,7 +187,7 @@ static ssize_t sd_store_cache_type(struc
 	rcd = ct & 0x01 ? 1 : 0;
 	wce = ct & 0x02 ? 1 : 0;
 	if (scsi_mode_sense(sdp, 0x08, 8, buffer, sizeof(buffer), sdp->timeout,
-			    SD_MAX_RETRIES, &data, NULL))
+			    sdp->retries, &data, NULL))
 		return -EINVAL;
 	len = min_t(size_t, sizeof(buffer), data.length - data.header_length -
 		  data.block_descriptor_length);
@@ -198,7 +198,7 @@ static ssize_t sd_store_cache_type(struc
 	sp = buffer_data[0] & 0x80 ? 1 : 0;
 
 	if (scsi_mode_select(sdp, 1, sp, 8, buffer_data, len, sdp->timeout,
-			     SD_MAX_RETRIES, &data, &sshdr)) {
+			     sdp->retries, &data, &sshdr)) {
 		if (scsi_sense_valid(&sshdr))
 			scsi_print_sense_hdr(sdkp->disk->disk_name, &sshdr);
 		return -EINVAL;
@@ -509,7 +509,7 @@ static int sd_init_command(struct scsi_c
 	 */
 	SCpnt->transfersize = sdp->sector_size;
 	SCpnt->underflow = this_count << 9;
-	SCpnt->allowed = SD_MAX_RETRIES;
+	SCpnt->allowed = sdp->retries;
 	SCpnt->timeout_per_command = sdp->timeout;
 
 	/*
@@ -758,7 +758,7 @@ static int sd_media_changed(struct gendi
 	 */
 	retval = -ENODEV;
 	if (scsi_block_when_processing_errors(sdp))
-		retval = scsi_test_unit_ready(sdp, sdp->timeout, SD_MAX_RETRIES);
+		retval = scsi_test_unit_ready(sdp, sdp->timeout, sdp->retries);
 
 	/*
 	 * Unable to test, unit probably not ready.   This usually
@@ -804,7 +804,7 @@ static int sd_sync_cache(struct scsi_dev
 		 * flush everything.
 		 */
 		res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
-				       sdp->timeout, SD_MAX_RETRIES);
+				       sdp->timeout, sdp->retries);
 		if (res == 0)
 			break;
 	}
@@ -1052,7 +1052,7 @@ sd_spinup_disk(struct scsi_disk *sdkp, c
 			the_result = scsi_execute_req(sdp, cmd,
 						      DMA_NONE, NULL, 0,
 						      &sshdr, sdp->timeout,
-						      SD_MAX_RETRIES);
+						      sdp->retries);
 
 			/*
 			 * If the drive has indicated to us that it
@@ -1108,7 +1108,7 @@ sd_spinup_disk(struct scsi_disk *sdkp, c
 				cmd[4] = 1;	/* Start spin cycle */
 				scsi_execute_req(sdp, cmd, DMA_NONE,
 						 NULL, 0, &sshdr,
-						 sdp->timeout, SD_MAX_RETRIES);
+						 sdp->timeout, sdp->retries);
 				spintime_expire = jiffies + 100 * HZ;
 				spintime = 1;
 			}
@@ -1183,7 +1183,7 @@ repeat:
 		
 		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
 					      buffer, longrc ? 12 : 8, &sshdr,
-					      sdp->timeout, SD_MAX_RETRIES);
+					      sdp->timeout, sdp->retries);
 
 		if (media_not_present(sdkp, &sshdr))
 			return;
@@ -1348,8 +1348,7 @@ sd_do_mode_sense(struct scsi_device *sdp
 		 struct scsi_sense_hdr *sshdr)
 {
 	return scsi_mode_sense(sdp, dbd, modepage, buffer, len,
-			       sdp->timeout, SD_MAX_RETRIES, data,
-			       sshdr);
+			       sdp->timeout, sdp->retries, data, sshdr);
 }
 
 /*
@@ -1673,6 +1672,9 @@ static int sd_probe(struct device *dev)
 			sdp->timeout = SD_MOD_TIMEOUT;
 	}
 
+	if (sdp->retries < 0)
+		sdp->retries = SD_MAX_RETRIES;
+
 	gd->major = sd_major((index & 0xf0) >> 4);
 	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
 	gd->minors = 16;
Index: scsi-misc-2.6/include/scsi/scsi_device.h
===================================================================
--- scsi-misc-2.6.orig/include/scsi/scsi_device.h
+++ scsi-misc-2.6/include/scsi/scsi_device.h
@@ -134,6 +134,7 @@ struct scsi_device {
 	atomic_t ioerr_cnt;
 
 	int timeout;
+	int retries;
 
 	struct device		sdev_gendev;
 	struct class_device	sdev_classdev;
Index: scsi-misc-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ scsi-misc-2.6/drivers/scsi/scsi_sysfs.c
@@ -443,6 +443,33 @@ sdev_store_timeout (struct device *dev, 
 static DEVICE_ATTR(timeout, S_IRUGO | S_IWUSR, sdev_show_timeout, sdev_store_timeout);
 
 static ssize_t
+sdev_show_retries(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	int retries = sdev->retries;
+
+	/* negative indicates uninitialized default */
+	if (retries < 0)
+		retries = 0;
+
+	return snprintf(buf, 20, "%d\n", retries);
+}
+
+static ssize_t
+sdev_store_retries(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	int retries;
+
+	sscanf(buf, "%d\n", &retries);
+	if (retries < 0)
+		return -EINVAL;
+	sdev->retries = retries;
+	return count;
+}
+static DEVICE_ATTR(retries, S_IRUGO | S_IWUSR, sdev_show_retries, sdev_store_retries);
+
+static ssize_t
 store_rescan_field (struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
 {
 	scsi_rescan_device(dev);
@@ -548,6 +575,7 @@ static struct device_attribute *scsi_sys
 	&dev_attr_delete,
 	&dev_attr_state,
 	&dev_attr_timeout,
+	&dev_attr_retries,
 	&dev_attr_iocounterbits,
 	&dev_attr_iorequest_cnt,
 	&dev_attr_iodone_cnt,
Index: scsi-misc-2.6/drivers/scsi/sr.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sr.c
+++ scsi-misc-2.6/drivers/scsi/sr.c
@@ -185,7 +185,7 @@ int sr_media_change(struct cdrom_device_
 		return -EINVAL;
 	}
 
-	retval = scsi_test_unit_ready(sdev, sdev->timeout, MAX_RETRIES);
+	retval = scsi_test_unit_ready(sdev, sdev->timeout, sdev->retries);
 	if (retval) {
 		/* Unable to test, unit probably not ready.  This usually
 		 * means there is no disc in the drive.  Mark as changed,
@@ -407,7 +407,7 @@ static int sr_init_command(struct scsi_c
 	 */
 	SCpnt->transfersize = sdev->sector_size;
 	SCpnt->underflow = this_count << 9;
-	SCpnt->allowed = MAX_RETRIES;
+	SCpnt->allowed = sdev->retries;
 	SCpnt->timeout_per_command = sdev->timeout;
 
 	/*
@@ -583,6 +583,8 @@ static int sr_probe(struct device *dev)
 
 	if (!sdev->timeout)
 		sdev->timeout = SR_TIMEOUT;
+	if (sdev->retries < 0)
+		sdev->retries = MAX_RETRIES;
 
 	cd->cdi.ops = &sr_dops;
 	cd->cdi.handle = cd;
@@ -643,7 +645,7 @@ static void get_sectorsize(struct scsi_c
 		/* Do the command and wait.. */
 		the_result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE,
 					      buffer, 8, NULL, sdev->timeout,
-					      MAX_RETRIES);
+					      sdev->retries);
 
 		retries--;
 
@@ -748,7 +750,7 @@ static void get_capabilities(struct scsi
 
 		the_result = scsi_execute_req (sdev, cmd, DMA_NONE, NULL,
 					       0, &sshdr, sdev->timeout,
-					       MAX_RETRIES);
+					       sdev->retries);
 
 		retries++;
 	} while (retries < 5 && 
Index: scsi-misc-2.6/drivers/scsi/st.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/st.c
+++ scsi-misc-2.6/drivers/scsi/st.c
@@ -609,7 +609,7 @@ static int cross_eof(struct scsi_tape * 
 		   tape_name(STp), forward ? "forward" : "backward"));
 
 	SRpnt = st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
-			   STp->device->timeout, MAX_RETRIES, 1);
+			   STp->device->timeout, STp->device->retries, 1);
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
@@ -1787,7 +1787,7 @@ static long read_tape(struct scsi_tape *
 
 	SRpnt = *aSRpnt;
 	SRpnt = st_do_scsi(SRpnt, STp, cmd, bytes, DMA_FROM_DEVICE,
-			   STp->device->timeout, MAX_RETRIES, 1);
+			   STp->device->timeout, STp->device->retries, 1);
 	release_buffering(STp, 1);
 	*aSRpnt = SRpnt;
 	if (!SRpnt)
@@ -2451,7 +2451,7 @@ static int do_load_unload(struct scsi_ta
 		);
 
 	SRpnt = st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
-			   timeout, MAX_RETRIES, 1);
+			   timeout, STp->device->retries, 1);
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
@@ -2751,7 +2751,7 @@ static int st_int_ioctl(struct scsi_tape
 	}
 
 	SRpnt = st_do_scsi(NULL, STp, cmd, datalen, direction,
-			   timeout, MAX_RETRIES, 1);
+			   timeout, STp->device->retries, 1);
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
@@ -3988,6 +3988,8 @@ static int st_probe(struct device *dev)
 	tpnt->nbr_partitions = 0;
 	if (!SDp->timeout)
 		SDp->timeout = ST_TIMEOUT;
+	if (SDp->retries < 0)
+		SDp->retries = MAX_RETRIES;
 	tpnt->long_timeout = ST_LONG_TIMEOUT;
 	tpnt->try_dio = try_direct_io && !SDp->host->unchecked_isa_dma;
 
Index: scsi-misc-2.6/drivers/scsi/osst.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/osst.c
+++ scsi-misc-2.6/drivers/scsi/osst.c
@@ -667,6 +667,7 @@ err_out:
 static int osst_wait_ready(struct osst_tape * STp, struct osst_request ** aSRpnt,
 				 unsigned timeout, int initial_delay)
 {
+	struct scsi_device    * sdev = STp->device;
 	unsigned char		cmd[MAX_COMMAND_SIZE];
 	struct osst_request   * SRpnt;
 	unsigned long		startwait = jiffies;
@@ -683,7 +684,8 @@ static int osst_wait_ready(struct osst_t
 	memset(cmd, 0, MAX_COMMAND_SIZE);
 	cmd[0] = TEST_UNIT_READY;
 
-	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, 0, DMA_NONE, STp->device->timeout, MAX_RETRIES, 1);
+	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, 0, DMA_NONE,
+			     sdev->timeout, sdev->retries, 1);
 	*aSRpnt = SRpnt;
 	if (!SRpnt) return (-EBUSY);
 
@@ -704,7 +706,8 @@ static int osst_wait_ready(struct osst_t
 	    memset(cmd, 0, MAX_COMMAND_SIZE);
 	    cmd[0] = TEST_UNIT_READY;
 
-	    SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE, STp->device->timeout, MAX_RETRIES, 1);
+	    SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE,
+				 sdev->timeout, sdev->retries, 1);
 	}
 	*aSRpnt = SRpnt;
 #if DEBUG
@@ -731,6 +734,7 @@ static int osst_wait_ready(struct osst_t
  */
 static int osst_wait_for_medium(struct osst_tape * STp, struct osst_request ** aSRpnt, unsigned timeout)
 {
+	struct scsi_device    * sdev = STp->device;
 	unsigned char		cmd[MAX_COMMAND_SIZE];
 	struct osst_request   * SRpnt;
 	unsigned long		startwait = jiffies;
@@ -744,7 +748,8 @@ static int osst_wait_for_medium(struct o
 	memset(cmd, 0, MAX_COMMAND_SIZE);
 	cmd[0] = TEST_UNIT_READY;
 
-	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, 0, DMA_NONE, STp->device->timeout, MAX_RETRIES, 1);
+	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, 0, DMA_NONE,
+			     sdev->timeout, sdev->retries, 1);
 	*aSRpnt = SRpnt;
 	if (!SRpnt) return (-EBUSY);
 
@@ -762,7 +767,8 @@ static int osst_wait_for_medium(struct o
 	    memset(cmd, 0, MAX_COMMAND_SIZE);
 	    cmd[0] = TEST_UNIT_READY;
 
-	    SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE, STp->device->timeout, MAX_RETRIES, 1);
+	    SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE,
+				 sdev->timeout, sdev->retries, 1);
 	}
 	*aSRpnt = SRpnt;
 #if DEBUG
@@ -800,6 +806,7 @@ static int osst_position_tape_and_confir
  */
 static int osst_flush_drive_buffer(struct osst_tape * STp, struct osst_request ** aSRpnt)
 {
+	struct scsi_device    * sdev = STp->device;
 	unsigned char		cmd[MAX_COMMAND_SIZE];
 	struct osst_request   * SRpnt;
 	int			result = 0;
@@ -814,7 +821,8 @@ static int osst_flush_drive_buffer(struc
 	cmd[0] = WRITE_FILEMARKS;
 	cmd[1] = 1;
 
-	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, 0, DMA_NONE, STp->device->timeout, MAX_RETRIES, 1);
+	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, 0, DMA_NONE,
+			     sdev->timeout, sdev->retries, 1);
 	*aSRpnt = SRpnt;
 	if (!SRpnt) return (-EBUSY);
 	if (STp->buffer->syscall_result) {
@@ -889,6 +897,7 @@ static int osst_wait_frame(struct osst_t
 
 static int osst_recover_wait_frame(struct osst_tape * STp, struct osst_request ** aSRpnt, int writing)
 {
+	struct scsi_device    * sdev = STp->device;
 	struct osst_request   * SRpnt;
 	unsigned char		cmd[MAX_COMMAND_SIZE];
 	unsigned long   	startwait = jiffies;
@@ -906,7 +915,7 @@ static int osst_recover_wait_frame(struc
 		cmd[0] = WRITE_FILEMARKS;
 		cmd[1] = 1;
 		SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, 0, DMA_NONE,
-				     STp->device->timeout, MAX_RETRIES, 1);
+				     sdev->timeout, sdev->retries, 1);
 
 		while (retval && time_before (jiffies, startwait + 5*60*HZ)) {
 
@@ -923,7 +932,7 @@ static int osst_recover_wait_frame(struc
 			cmd[0] = READ_POSITION;
 
 			SRpnt = osst_do_scsi(SRpnt, STp, cmd, 20, DMA_FROM_DEVICE,
-					     STp->device->timeout, MAX_RETRIES, 1);
+					     sdev->timeout, sdev->retries, 1);
 
 			retval = ( STp->buffer->syscall_result || (STp->buffer)->b_data[15] > 25 );
 			STp->buffer->b_data = olddata; STp->buffer->buffer_size = oldsize;
@@ -947,6 +956,7 @@ static int osst_recover_wait_frame(struc
  */
 static int osst_read_frame(struct osst_tape * STp, struct osst_request ** aSRpnt, int timeout)
 {
+	struct scsi_device    * sdev = STp->device;
 	unsigned char		cmd[MAX_COMMAND_SIZE];
 	struct osst_request   * SRpnt;
 	int			retval = 0;
@@ -969,7 +979,7 @@ static int osst_read_frame(struct osst_t
 		printk(OSST_DEB_MSG "%s:D: Reading frame from OnStream tape\n", name);
 #endif
 	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, OS_FRAME_SIZE, DMA_FROM_DEVICE,
-				      STp->device->timeout, MAX_RETRIES, 1);
+			     sdev->timeout, sdev->retries, 1);
 	*aSRpnt = SRpnt;
 	if (!SRpnt)
 		return (-EBUSY);
@@ -1018,6 +1028,7 @@ static int osst_read_frame(struct osst_t
 
 static int osst_initiate_read(struct osst_tape * STp, struct osst_request ** aSRpnt)
 {
+	struct scsi_device    * sdev = STp->device;
 	struct st_partstat    * STps   = &(STp->ps[STp->partition]);
 	struct osst_request   * SRpnt  ;
 	unsigned char		cmd[MAX_COMMAND_SIZE];
@@ -1045,7 +1056,7 @@ static int osst_initiate_read(struct oss
 		printk(OSST_DEB_MSG "%s:D: Start Read Ahead on OnStream tape\n", name);
 #endif
 		SRpnt   = osst_do_scsi(*aSRpnt, STp, cmd, 0, DMA_NONE,
-				       STp->device->timeout, MAX_RETRIES, 1);
+				       sdev->timeout, sdev->retries, 1);
 		*aSRpnt = SRpnt;
 		if ((retval = STp->buffer->syscall_result))
 			printk(KERN_WARNING "%s:W: Error starting read ahead\n", name);
@@ -1388,6 +1399,7 @@ static int osst_seek_sector(struct osst_
 static int osst_read_back_buffer_and_rewrite(struct osst_tape * STp, struct osst_request ** aSRpnt,
 						unsigned int frame, unsigned int skip, int pending)
 {
+	struct scsi_device    * sdev = STp->device;
 	struct osst_request   * SRpnt = * aSRpnt;
 	unsigned char	      * buffer, * p;
 	unsigned char		cmd[MAX_COMMAND_SIZE];
@@ -1427,7 +1439,7 @@ static int osst_read_back_buffer_and_rew
 		cmd[8] = 32768 & 0xff;
 
 		SRpnt = osst_do_scsi(SRpnt, STp, cmd, OS_FRAME_SIZE, DMA_FROM_DEVICE,
-				     STp->device->timeout, MAX_RETRIES, 1);
+				     sdev->timeout, sdev->retries, 1);
 	
 		if ((STp->buffer)->syscall_result || !SRpnt) {
 			printk(KERN_ERR "%s:E: Failed to read frame back from OnStream buffer\n", name);
@@ -1499,7 +1511,7 @@ static int osst_read_back_buffer_and_rew
 				p[0], p[1], p[2], p[3]);
 #endif
 		SRpnt = osst_do_scsi(SRpnt, STp, cmd, OS_FRAME_SIZE, DMA_TO_DEVICE,
-				     STp->device->timeout, MAX_RETRIES, 1);
+				     sdev->timeout, sdev->retries, 1);
 
 		if (STp->buffer->syscall_result)
 			flag = 1;
@@ -1515,7 +1527,7 @@ static int osst_read_back_buffer_and_rew
 				cmd[0] = WRITE_FILEMARKS;
 				cmd[1] = 1;
 				SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE,
-						     STp->device->timeout, MAX_RETRIES, 1);
+						     sdev->timeout, sdev->retries, 1);
 #if DEBUG
 				if (debugging) {
 					printk(OSST_DEB_MSG "%s:D: Sleeping in re-write wait ready\n", name);
@@ -1530,7 +1542,7 @@ static int osst_read_back_buffer_and_rew
 					cmd[0] = TEST_UNIT_READY;
 
 					SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE,
-							     STp->device->timeout, MAX_RETRIES, 1);
+							     sdev->timeout, sdev->retries, 1);
 
 					if (SRpnt->sense[2] == 2 && SRpnt->sense[12] == 4 &&
 					    (SRpnt->sense[13] == 1 || SRpnt->sense[13] == 8)) {
@@ -1586,6 +1598,7 @@ static int osst_read_back_buffer_and_rew
 static int osst_reposition_and_retry(struct osst_tape * STp, struct osst_request ** aSRpnt,
 					unsigned int frame, unsigned int skip, int pending)
 {
+	struct scsi_device    * sdev = STp->device;
 	unsigned char		cmd[MAX_COMMAND_SIZE];
 	struct osst_request   * SRpnt;
 	char		      * name      = tape_name(STp);
@@ -1635,7 +1648,7 @@ static int osst_reposition_and_retry(str
 					  name, STp->frame_seq_number-1, STp->first_frame_position);
 #endif
 			SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, OS_FRAME_SIZE, DMA_TO_DEVICE,
-					     STp->device->timeout, MAX_RETRIES, 1);
+					     sdev->timeout, sdev->retries, 1);
 			*aSRpnt = SRpnt;
 
 			if (STp->buffer->syscall_result) {		/* additional write error */
@@ -2092,7 +2105,8 @@ static void osst_set_retries(struct osst
 	if (debugging)
 	    printk(OSST_DEB_MSG "%s:D: Setting number of retries on OnStream tape to %d\n", name, retries);
 
-	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_TO_DEVICE, STp->device->timeout, 0, 1);
+	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_TO_DEVICE,
+			     STp->device->timeout, 0, 1);
 	*aSRpnt = SRpnt;
 
 	if ((STp->buffer)->syscall_result)
@@ -2601,6 +2615,7 @@ static unsigned int osst_parse_firmware_
  */
 static int osst_configure_onstream(struct osst_tape *STp, struct osst_request ** aSRpnt)
 {
+	struct scsi_device           * sdev = STp->device;
 	unsigned char                  cmd[MAX_COMMAND_SIZE];
 	char                         * name = tape_name(STp);
 	struct osst_request          * SRpnt = * aSRpnt;
@@ -2618,7 +2633,7 @@ static int osst_configure_onstream(struc
 	}
 	
 	if (STp->os_fw_rev < 10600) {
-	    printk(KERN_INFO "%s:I: Old OnStream firmware revision detected (%s),\n", name, STp->device->rev);
+	    printk(KERN_INFO "%s:I: Old OnStream firmware revision detected (%s),\n", name, sdev->rev);
 	    printk(KERN_INFO "%s:I: an upgrade to version 1.06 or above is recommended\n", name);
 	}
 
@@ -2632,7 +2647,7 @@ static int osst_configure_onstream(struc
 	cmd[2] = BLOCK_SIZE_PAGE;
 	cmd[4] = BLOCK_SIZE_PAGE_LENGTH + MODE_HEADER_LENGTH;
 
-	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE, STp->device->timeout, 0, 1);
+	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE, sdev->timeout, 0, 1);
 	if (SRpnt == NULL) {
 #if DEBUG
  	    printk(OSST_DEB_MSG "osst :D: Busy\n");
@@ -2669,7 +2684,7 @@ static int osst_configure_onstream(struc
 	cmd[1] = 0x10;
 	cmd[4] = BLOCK_SIZE_PAGE_LENGTH + MODE_HEADER_LENGTH;
 
-	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_TO_DEVICE, STp->device->timeout, 0, 1);
+	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_TO_DEVICE, sdev->timeout, 0, 1);
 	*aSRpnt = SRpnt;
 	if ((STp->buffer)->syscall_result != 0) {
 	    printk (KERN_ERR "%s:E: Couldn't set tape block size mode page\n", name);
@@ -2709,7 +2724,7 @@ static int osst_configure_onstream(struc
 	(STp->buffer)->b_data[MODE_HEADER_LENGTH + 6] = 0;
 	(STp->buffer)->b_data[MODE_HEADER_LENGTH + 7] = 0;
 
-	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_TO_DEVICE, STp->device->timeout, 0, 1);
+	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_TO_DEVICE, sdev->timeout, 0, 1);
 	*aSRpnt = SRpnt;
 
 	if ((STp->buffer)->syscall_result != 0) {
@@ -2724,7 +2739,7 @@ static int osst_configure_onstream(struc
 	cmd[2] = CAPABILITIES_PAGE;
 	cmd[4] = CAPABILITIES_PAGE_LENGTH + MODE_HEADER_LENGTH;
 
-	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE, STp->device->timeout, 0, 1);
+	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE, sdev->timeout, 0, 1);
 	*aSRpnt = SRpnt;
 
 	if ((STp->buffer)->syscall_result != 0) {
@@ -2744,7 +2759,7 @@ static int osst_configure_onstream(struc
 	cmd[2] = TAPE_PARAMTR_PAGE;
 	cmd[4] = TAPE_PARAMTR_PAGE_LENGTH + MODE_HEADER_LENGTH;
 
-	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE, STp->device->timeout, 0, 1);
+	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE, sdev->timeout, 0, 1);
 	*aSRpnt = SRpnt;
 
 	if ((STp->buffer)->syscall_result != 0) {
@@ -2801,6 +2816,7 @@ static int cross_eof(struct osst_tape *S
 
 static int osst_get_frame_position(struct osst_tape *STp, struct osst_request ** aSRpnt)
 {
+	struct scsi_device    * sdev = STp->device;
 	unsigned char		scmd[MAX_COMMAND_SIZE];
 	struct osst_request   * SRpnt;
 	int			result = 0;
@@ -2819,7 +2835,7 @@ static int osst_get_frame_position(struc
 
 	STp->buffer->b_data = mybuf; STp->buffer->buffer_size = 24;
 	SRpnt = osst_do_scsi(*aSRpnt, STp, scmd, 20, DMA_FROM_DEVICE,
-			     STp->device->timeout, MAX_RETRIES, 1);
+			     sdev->timeout, sdev->retries, 1);
 	if (!SRpnt) {
 		STp->buffer->b_data = olddata; STp->buffer->buffer_size = oldsize;
 		return (-EBUSY);
@@ -2839,7 +2855,7 @@ static int osst_get_frame_position(struc
 			scmd[0] = READ_POSITION;
 			STp->buffer->b_data = mybuf; STp->buffer->buffer_size = 24;
 			SRpnt = osst_do_scsi(SRpnt, STp, scmd, 20, DMA_FROM_DEVICE,
-					     STp->device->timeout, MAX_RETRIES, 1);
+					     sdev->timeout, sdev->retries, 1);
 #if DEBUG
 			printk(OSST_DEB_MSG "%s:D: Reread position, reason=[%02x:%02x:%02x], result=[%s%02x:%02x:%02x]\n",
 					name, mysense[2], mysense[12], mysense[13], STp->buffer->syscall_result?"":"ok:",
@@ -2917,8 +2933,8 @@ static int osst_set_frame_position(struc
 		if (skip)
 			scmd[9] = 0x80;
 
-		SRpnt = osst_do_scsi(*aSRpnt, STp, scmd, 0, DMA_NONE, STp->long_timeout,
-								MAX_RETRIES, 1);
+		SRpnt = osst_do_scsi(*aSRpnt, STp, scmd, 0, DMA_NONE,
+				     STp->long_timeout, STp->device->retries, 1);
 		if (!SRpnt)
 			return (-EBUSY);
 		*aSRpnt  = SRpnt;
@@ -2970,6 +2986,7 @@ out:
 /* Flush the write buffer (never need to write if variable blocksize). */
 static int osst_flush_write_buffer(struct osst_tape *STp, struct osst_request ** aSRpnt)
 {
+	struct scsi_device    * sdev = STp->device;
 	int			offset, transfer, blks = 0;
 	int			result = 0;
 	unsigned char		cmd[MAX_COMMAND_SIZE];
@@ -3056,7 +3073,7 @@ static int osst_flush_write_buffer(struc
 #endif
 
 		SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, transfer, DMA_TO_DEVICE,
-				     STp->device->timeout, MAX_RETRIES, 1);
+				     sdev->timeout, sdev->retries, 1);
 		*aSRpnt = SRpnt;
 		if (!SRpnt)
 			return (-EBUSY);
@@ -3162,6 +3179,7 @@ static int osst_flush_buffer(struct osst
 
 static int osst_write_frame(struct osst_tape * STp, struct osst_request ** aSRpnt, int synchronous)
 {
+	struct scsi_device    * sdev = STp->device;
 	unsigned char		cmd[MAX_COMMAND_SIZE];
 	struct osst_request   * SRpnt;
 	int			blks;
@@ -3212,8 +3230,8 @@ static int osst_write_frame(struct osst_
 	if (!synchronous)
 		STp->write_pending = 1;
 #endif
-	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, OS_FRAME_SIZE, DMA_TO_DEVICE, STp->device->timeout,
-			     MAX_RETRIES, synchronous);
+	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, OS_FRAME_SIZE, DMA_TO_DEVICE,
+			     sdev->timeout, sdev->retries, synchronous);
 	if (!SRpnt)
 		return (-EBUSY);
 	*aSRpnt = SRpnt;
@@ -3817,6 +3835,7 @@ static void osst_log_options(struct osst
 
 static int osst_set_options(struct osst_tape *STp, long options)
 {
+	struct scsi_device * sdev = STp->device;
 	int		    value;
 	long		    code;
 	struct st_modedef * STm;
@@ -3844,7 +3863,7 @@ static int osst_set_options(struct osst_
 		STp->do_auto_lock     = (options & MT_ST_AUTO_LOCK) != 0;
 		STp->can_bsr          = (options & MT_ST_CAN_BSR) != 0;
 		STp->omit_blklims     = (options & MT_ST_NO_BLKLIMS) != 0;
-		if ((STp->device)->scsi_level >= SCSI_2)
+		if (sdev->scsi_level >= SCSI_2)
 			STp->can_partitions = (options & MT_ST_CAN_PARTITIONS) != 0;
 		STp->scsi2_logical    = (options & MT_ST_SCSI2LOGICAL) != 0;
 		STm->sysv	      = (options & MT_ST_SYSV) != 0;
@@ -3873,7 +3892,7 @@ static int osst_set_options(struct osst_
 			STp->can_bsr = value;
 		if ((options & MT_ST_NO_BLKLIMS) != 0)
 			STp->omit_blklims = value;
-		if ((STp->device)->scsi_level >= SCSI_2 &&
+		if (sdev->scsi_level >= SCSI_2 &&
 		    (options & MT_ST_CAN_PARTITIONS) != 0)
 			STp->can_partitions = value;
 		if ((options & MT_ST_SCSI2LOGICAL) != 0)
@@ -3922,7 +3941,7 @@ static int osst_set_options(struct osst_
 					     (value & ~MT_ST_SET_LONG_TIMEOUT));
 		}
 		else {
-			STp->device->timeout = value * HZ;
+			sdev->timeout = value * HZ;
 			printk(KERN_INFO "%s:I: Normal timeout set to %d seconds.\n", name, value);
 		}
 	}
@@ -3974,6 +3993,7 @@ static int osst_set_options(struct osst_
 static int osst_int_ioctl(struct osst_tape * STp, struct osst_request ** aSRpnt,
 			     unsigned int cmd_in, unsigned long arg)
 {
+	struct scsi_device    * sdev = STp->device;
 	int			timeout;
 	long			ltmp;
 	int			i, ioctl_result;
@@ -4113,7 +4133,7 @@ static int osst_int_ioctl(struct osst_ta
 		 cmd[2] = (arg >> 16);
 		 cmd[3] = (arg >> 8);
 		 cmd[4] = arg;
-		 timeout = STp->device->timeout;
+		 timeout = sdev->timeout;
 #if DEBUG
 		 if (debugging) 
 			   printk(OSST_DEB_MSG "%s:D: Writing %d setmark(s).\n", name,
@@ -4140,7 +4160,7 @@ static int osst_int_ioctl(struct osst_ta
 			 cmd[4] = 3;		/* retension then mount */
 		 if (cmd_in == MTOFFL)
 			 cmd[4] = 4;		/* rewind then eject */
-		 timeout = STp->device->timeout;
+		 timeout = sdev->timeout;
 #if DEBUG
 		 if (debugging) {
 			 switch (cmd_in) {
@@ -4249,7 +4269,8 @@ static int osst_int_ioctl(struct osst_ta
 		return (-ENOSYS);
 	}
 
-	SRpnt = osst_do_scsi(SRpnt, STp, cmd, datalen, direction, timeout, MAX_RETRIES, 1);
+	SRpnt = osst_do_scsi(SRpnt, STp, cmd, datalen, direction, timeout,
+			     sdev->retries, 1);
 
 	ioctl_result = (STp->buffer)->syscall_result;
 
@@ -4364,6 +4385,7 @@ static int os_scsi_tape_open(struct inod
 	unsigned char	      cmd[MAX_COMMAND_SIZE];
 	struct osst_request * SRpnt = NULL;
 	struct osst_tape    * STp;
+	struct scsi_device  * sdev;
 	struct st_modedef   * STm;
 	struct st_partstat  * STps;
 	char		    * name;
@@ -4385,6 +4407,7 @@ static int os_scsi_tape_open(struct inod
 	}
 
 	name = tape_name(STp);
+	sdev = STp->device;
 
 	if (STp->in_use) {
 		write_unlock(&os_scsi_tapes_lock);
@@ -4393,7 +4416,7 @@ static int os_scsi_tape_open(struct inod
 #endif
 		return (-EBUSY);
 	}
-	if (scsi_device_get(STp->device)) {
+	if (scsi_device_get(sdev)) {
 		write_unlock(&os_scsi_tapes_lock);
 #if DEBUG
                 printk(OSST_DEB_MSG "%s:D: Failed scsi_device_get.\n", name);
@@ -4405,7 +4428,7 @@ static int os_scsi_tape_open(struct inod
 	write_unlock(&os_scsi_tapes_lock);
 	STp->rew_at_close = TAPE_REWIND(inode);
 
-	if( !scsi_block_when_processing_errors(STp->device) ) {
+	if( !scsi_block_when_processing_errors(sdev) ) {
 		return -ENXIO;
 	}
 
@@ -4465,7 +4488,8 @@ static int os_scsi_tape_open(struct inod
 	memset (cmd, 0, MAX_COMMAND_SIZE);
 	cmd[0] = TEST_UNIT_READY;
 
-	SRpnt = osst_do_scsi(NULL, STp, cmd, 0, DMA_NONE, STp->device->timeout, MAX_RETRIES, 1);
+	SRpnt = osst_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
+			     sdev->timeout, sdev->retries, 1);
 	if (!SRpnt) {
 		retval = (STp->buffer)->syscall_result;		/* FIXME - valid? */
 		goto err_out;
@@ -4486,7 +4510,7 @@ static int os_scsi_tape_open(struct inod
 			cmd[1] = 1;
 			cmd[4] = 1;
 			SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE,
-					     STp->device->timeout, MAX_RETRIES, 1);
+					     sdev->timeout, sdev->retries, 1);
 		}
 		osst_wait_ready(STp, &SRpnt, (SRpnt->sense[13]==1?15:3) * 60, 0);
 	}
@@ -4503,7 +4527,7 @@ static int os_scsi_tape_open(struct inod
 			cmd[0] = TEST_UNIT_READY;
 
 			SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE,
-					     STp->device->timeout, MAX_RETRIES, 1);
+					     sdev->timeout, sdev->retries, 1);
 			if ((SRpnt->sense[0] & 0x70) != 0x70 ||
 			    (SRpnt->sense[2] & 0x0f) != UNIT_ATTENTION)
 				break;
@@ -4539,7 +4563,7 @@ static int os_scsi_tape_open(struct inod
 		cmd[2] = VENDOR_IDENT_PAGE;
 		cmd[4] = VENDOR_IDENT_PAGE_LENGTH + MODE_HEADER_LENGTH;
 
-		SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE, STp->device->timeout, 0, 1);
+		SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE, sdev->timeout, 0, 1);
 
 		if (STp->buffer->syscall_result                     ||
 		    STp->buffer->b_data[MODE_HEADER_LENGTH + 2] != 'L' ||
@@ -4602,7 +4626,7 @@ static int os_scsi_tape_open(struct inod
 #if DEBUG
 		printk(OSST_DEB_MSG "%s:D: Applying soft reset\n", name);
 #endif
-		SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_TO_DEVICE, STp->device->timeout, 0, 1);
+		SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_TO_DEVICE, sdev->timeout, 0, 1);
 
 		STp->header_ok = 0;
 
@@ -4612,7 +4636,7 @@ static int os_scsi_tape_open(struct inod
 			cmd[0] = TEST_UNIT_READY;
 
 			SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE,
-					     STp->device->timeout, MAX_RETRIES, 1);
+					     sdev->timeout, sdev->retries, 1);
 			if ((SRpnt->sense[0] & 0x70) != 0x70 ||
 			    (SRpnt->sense[2] & 0x0f) == NOT_READY)
 			break;
@@ -4640,7 +4664,7 @@ static int os_scsi_tape_open(struct inod
 		 printk(KERN_INFO "%s:I: Device did not become Ready in open\n", name);
 
 	if ((STp->buffer)->syscall_result != 0) {
-		if ((STp->device)->scsi_level >= SCSI_2 &&
+		if (sdev->scsi_level >= SCSI_2 &&
 		    (SRpnt->sense[0] & 0x70) == 0x70 &&
 		    (SRpnt->sense[2] & 0x0f) == NOT_READY &&
 		     SRpnt->sense[12] == 0x3a) { /* Check ASC */
@@ -4718,7 +4742,7 @@ err_out:
 	normalize_buffer(STp->buffer);
 	STp->header_ok = 0;
 	STp->in_use = 0;
-	scsi_device_put(STp->device);
+	scsi_device_put(sdev);
 
 	return retval;
 }
@@ -4849,6 +4873,7 @@ static int osst_ioctl(struct inode * ino
 	struct st_partstat  * STps;
 	struct osst_request * SRpnt = NULL;
 	struct osst_tape    * STp   = file->private_data;
+	struct scsi_device  * sdev  = STp->device;
 	char		    * name  = tape_name(STp);
 	void	    __user  * p     = (void __user *)arg;
 
@@ -4871,7 +4896,7 @@ static int osst_ioctl(struct inode * ino
 	 * may try and take the device offline, in which case all further
 	 * access to the device is prohibited.
 	 */
-	if( !scsi_block_when_processing_errors(STp->device) ) {
+	if( !scsi_block_when_processing_errors(sdev) ) {
 		retval = (-ENXIO);
 		goto out;
 	}
@@ -4958,7 +4983,7 @@ static int osst_ioctl(struct inode * ino
 			}
 			reset_state(STp);
 			/* remove this when the midlevel properly clears was_reset */
-			STp->device->was_reset = 0;
+			sdev->was_reset = 0;
 		}
 
 		if (mtc.mt_op != MTCOMPRESSION  && mtc.mt_op != MTLOCK         &&
@@ -5165,7 +5190,7 @@ static int osst_ioctl(struct inode * ino
 
 	up(&STp->lock);
 
-	return scsi_ioctl(STp->device, cmd_in, p);
+	return scsi_ioctl(sdev, cmd_in, p);
 
 out:
 	if (SRpnt) osst_release_request(SRpnt);
@@ -5825,6 +5850,8 @@ static int osst_probe(struct device *dev
 	tpnt->max_block = OS_DATA_SIZE;
 	if (!SDp->timeout)
 		SDp->timeout = OSST_TIMEOUT;
+	if (SDp->retries < 0)
+		SDp->retries = MAX_RETRIES;
 	tpnt->long_timeout = OSST_LONG_TIMEOUT;
 
 	/* Recognize OnStream tapes */
Index: scsi-misc-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_scan.c
+++ scsi-misc-2.6/drivers/scsi/scsi_scan.c
@@ -261,6 +261,13 @@ static struct scsi_device *scsi_alloc_sd
 	 */
 	sdev->borken = 1;
 
+	/*
+	 * -1 indicates uninitialized default and equivalent to zero
+	 * in effect.  High level driver is allowed to adjust retries
+	 * if it's negative.
+	 */
+	sdev->retries = -1;
+
 	sdev->request_queue = scsi_alloc_queue(sdev);
 	if (!sdev->request_queue) {
 		/* release fn is set up in scsi_sysfs_device_initialise, so
