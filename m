From: Alan Stern <stern@rowland.harvard.edu>
Subject: Suggested patch for testing last sector of USB devices
Date: Fri, 19 Dec 2008 20:15:32 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0812192009210.16918-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:1158 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751167AbYLTBPe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Dec 2008 20:15:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

James, Boaz, or anyone else:

Can you comment on this patch?  Is the test inserted at the right 
place?  Have I left anything out or forgotten anything?  (This is just 
the SCSI part of the patch; the usb-storage part is separate.)

Thanks,

Alan Stern



Add a new scsi_device flag to tell sd.c that it should verify the
results of READ CAPACITY by trying the read the last sector.  This is
necessary because a large percentage of USB mass-storage devices -- too
many for a blacklist -- have a bug whereby they return the total number
of sectors rather than the index of the last sector.

The new sd_read_last_sector() routine carries out the test, using a
very short timeout and a small number of retries.  Any working device
for which the check_capacity flag is set should be able to pass the
test easily.

Index: usb-2.6/include/scsi/scsi_device.h
===================================================================
--- usb-2.6.orig/include/scsi/scsi_device.h
+++ usb-2.6/include/scsi/scsi_device.h
@@ -142,6 +142,7 @@ struct scsi_device {
 	unsigned select_no_atn:1;
 	unsigned fix_capacity:1;	/* READ_CAPACITY is too high by 1 */
 	unsigned guess_capacity:1;	/* READ_CAPACITY might be too high by 1 */
+	unsigned check_capacity:1;	/* Verify READ_CAPACITY result */
 	unsigned retry_hwerror:1;	/* Retry HARDWARE_ERROR */
 	unsigned last_sector_bug:1;	/* do not use multisector accesses on
 					   SD_LAST_BUGGY_SECTORS */
Index: usb-2.6/drivers/scsi/sd.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sd.c
+++ usb-2.6/drivers/scsi/sd.c
@@ -1275,6 +1275,88 @@ disable:
 	sdkp->capacity = 0;
 }
 
+#if defined(CONFIG_USB_STORAGE) || defined(CONFIG_USB_STORAGE_MODULE)
+/*
+ * Test disk capacity by trying to read the last sector
+ */
+static int sd_read_last_sector(struct scsi_disk *sdkp, unsigned char *buffer,
+		int sector_size)
+{
+	struct scsi_device *sdp = sdkp->device;
+	u32 last;
+	int result, resid;
+	int rc = 0;
+	unsigned char cmd[10];
+
+	/* If the capacity is unknown, assume we're okay */
+	if (sdkp->capacity <= 0)
+		return rc;
+
+	sdp->check_capacity = 0;	/* One test should be enough */
+
+	/* If the device doesn't use READ(10), assume we're okay */
+	if (!sdp->use_10_for_rw)
+		return rc;
+
+	/* If the capacity is too big for READ(10), assume we're okay */
+	if (sdkp->capacity > 0xffffffff)
+		return rc;
+
+	/* If the sector size is too big, assume we're okay */
+	if (sector_size > SD_BUF_SIZE)
+		return rc;
+	if (sector_size == 0)
+		sector_size = 512;
+
+	if (!sdkp->openers++ && sdp->removable)
+		scsi_set_medium_removal(sdp, SCSI_REMOVAL_PREVENT);
+
+	/* Start by trying to read the first sector, just to warm up */
+	memset(cmd, 0, 10);
+	cmd[0] = READ_10;
+	cmd[8] = 1;
+	result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
+			buffer, sector_size, NULL,
+			SD_TIMEOUT, SD_MAX_RETRIES, &resid);
+	if (result || resid) {
+		sdp->check_capacity = 1;	/* Try again later */
+		goto done;
+	}
+
+	/* Now try to read the last sector */
+	last = sdkp->capacity - 1;
+	cmd[2] = (last >> 24);
+	cmd[3] = (last >> 16);
+	cmd[4] = (last >> 8);
+	cmd[5] = last;
+
+	/* Allow only 1 retry, with a short timeout (some devices
+	 * violate protocol, forcing the command to be aborted).
+	 */
+	result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
+			buffer, sector_size, NULL, HZ, 1, &resid);
+	if (result || resid) {
+		sdp->fix_capacity = 1;		/* For next time */
+		rc = -EIO;
+	}
+
+ done:
+	if (!--sdkp->openers && sdp->removable) {
+		if (scsi_block_when_processing_errors(sdp))
+			scsi_set_medium_removal(sdp, SCSI_REMOVAL_ALLOW);
+	}
+	return rc;
+}
+
+#else
+static inline int sd_read_last_sector(struct scsi_disk *sdkp,
+		unsigned char *buffer, int sector_size)
+{
+	return 0;
+}
+
+#endif /* defined(CONFIG_USB_STORAGE) || ... */
+
 /*
  * read disk capacity
  */
@@ -1396,7 +1478,9 @@ repeat:
 	 * the capacity.
 	 */
 	if (sdp->fix_capacity ||
-	    (sdp->guess_capacity && (sdkp->capacity & 0x01))) {
+	    (sdp->guess_capacity && (sdkp->capacity & 0x01)) ||
+	    (sdp->check_capacity &&
+			sd_read_last_sector(sdkp, buffer, sector_size) < 0)) {
 		sd_printk(KERN_INFO, sdkp, "Adjusting the sector count "
 				"from its reported value: %llu\n",
 				(unsigned long long) sdkp->capacity);

