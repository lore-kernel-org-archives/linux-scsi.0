From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] SCSI: add check_capacity flag and sd_read_last_sector()
Date: Wed, 22 Apr 2009 10:42:36 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0904221034340.3405-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:47785 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750923AbZDVOmi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2009 10:42:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <greg@kroah.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

This patch (as1196) adds a new scsi_device flag to tell sd.c that it
should verify the results of READ CAPACITY by trying the read the last
sector.  This is necessary because a large percentage of USB
mass-storage devices -- too many for a blacklist -- have a bug whereby
they return the total number of sectors rather than the index of the
last sector.

The new sd_read_last_sector() routine carries out the test, using a
very short timeout and a small number of retries.  Any working device
for which the check_capacity flag is set should be able to pass the
test easily.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

James & Greg:

Although part of this patch touches usb-storage, the majority of 
it affects SCSI files.  Is it okay if the whole thing goes in via 
James's tree?

Alan Stern



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
@@ -1426,6 +1426,89 @@ static int sd_try_rc16_first(struct scsi
 	return 0;
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
+	/* If the capacity is unknown, we can't test anything */
+	if (sdkp->capacity <= 0)
+		return rc;
+
+	/* One test should be enough (unless it's inconclusive) */
+	sdp->check_capacity = 0;
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
@@ -1479,7 +1562,9 @@ sd_read_capacity(struct scsi_disk *sdkp,
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
Index: usb-2.6/drivers/usb/storage/scsiglue.c
===================================================================
--- usb-2.6.orig/drivers/usb/storage/scsiglue.c
+++ usb-2.6/drivers/usb/storage/scsiglue.c
@@ -209,6 +209,14 @@ static int slave_configure(struct scsi_d
 		if (us->fflags & US_FL_CAPACITY_HEURISTICS)
 			sdev->guess_capacity = 1;
 
+		/* To catch devices that have the READ CAPACITY bug and
+		 * aren't on our blacklist, tell the SCSI disk driver to
+		 * test the last sector.  This flag will be ignored if
+		 * either of the previous flags causes the capacity to
+		 * be decremented. */
+		if (!(us->fflags & US_FL_CAPACITY_OK))
+			sdev->check_capacity = 1;
+
 		/* assume SPC3 or latter devices support sense size > 18 */
 		if (sdev->scsi_level > SCSI_SPC_2)
 			us->fflags |= US_FL_SANE_SENSE;
Index: usb-2.6/drivers/usb/storage/transport.c
===================================================================
--- usb-2.6.orig/drivers/usb/storage/transport.c
+++ usb-2.6/drivers/usb/storage/transport.c
@@ -560,6 +560,12 @@ static void last_sector_hacks(struct us_
 	if (sector + 1 != sdkp->capacity)
 		goto done;
 
+	/* Has the capacity already been decremented? */
+	if (sdkp->device->fix_capacity) {
+		us->use_last_sector_hacks = 0;
+		return;
+	}
+
 	if (srb->result == SAM_STAT_GOOD && scsi_get_resid(srb) == 0) {
 
 		/* The command succeeded.  We know this device doesn't

