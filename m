From: akpm@linux-foundation.org
Subject: [patch 14/17] SCSI: early detection of medium not present, updated
Date: Tue, 02 Oct 2007 14:38:10 -0700
Message-ID: <200710022138.l92LcAPo023597@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40523 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755590AbXJBViw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 17:38:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, stern@rowland.harvard.edu, albertcc@tw.ibm.com, htejun@gmail.com, jens.axboe@oracle.com

From: Alan Stern <stern@rowland.harvard.edu>

Taken from http://bugzilla.kernel.org/show_bug.cgi?id=8904

An updated (by Albert, I assume) version of the fourteen-month-old patch here:

http://marc.info/?l=linux-kernel&m=115412002912837&w=2

Apparently fixes the bug described at
http://bugzilla.kernel.org/show_bug.cgi?id=8904

Needs some TLC.  Perhaps urgently.

Cc: Albert Lee <albertcc@tw.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_ioctl.c  |    2 +-
 drivers/scsi/scsi_lib.c    |   20 ++++++++++++++++++--
 drivers/scsi/sd.c          |    2 +-
 drivers/scsi/sr.c          |   15 +++++++++------
 include/scsi/scsi_device.h |    2 +-
 5 files changed, 30 insertions(+), 11 deletions(-)

diff -puN drivers/scsi/scsi_ioctl.c~scsi-early-detection-of-medium-not-present-updated drivers/scsi/scsi_ioctl.c
--- a/drivers/scsi/scsi_ioctl.c~scsi-early-detection-of-medium-not-present-updated
+++ a/drivers/scsi/scsi_ioctl.c
@@ -239,7 +239,7 @@ int scsi_ioctl(struct scsi_device *sdev,
 		return scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);
 	case SCSI_IOCTL_TEST_UNIT_READY:
 		return scsi_test_unit_ready(sdev, IOCTL_NORMAL_TIMEOUT,
-					    NORMAL_RETRIES);
+					    NORMAL_RETRIES, NULL);
 	case SCSI_IOCTL_START_UNIT:
 		scsi_cmd[0] = START_STOP;
 		scsi_cmd[1] = 0;
diff -puN drivers/scsi/scsi_lib.c~scsi-early-detection-of-medium-not-present-updated drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~scsi-early-detection-of-medium-not-present-updated
+++ a/drivers/scsi/scsi_lib.c
@@ -1875,15 +1875,26 @@ scsi_mode_sense(struct scsi_device *sdev
 }
 EXPORT_SYMBOL(scsi_mode_sense);
 
+/**
+ *	scsi_test_unit_ready - test if unit is ready
+ *	@sdev:	scsi device to change the state of.
+ *	@timeout: command timeout
+ *	@retries: number of retries before failing
+ *	@media_maybe_present: 1 if media maybe present or not.
+ *		              0 if media not present.
+ *
+ *	Returns zero if unsuccessful or an error if TUR failed.
+ **/
 int
-scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries)
+scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries, int *media_maybe_present)
 {
 	char cmd[] = {
 		TEST_UNIT_READY, 0, 0, 0, 0, 0,
 	};
 	struct scsi_sense_hdr sshdr;
 	int result;
-	
+	int maybe_present = 1;
+
 	result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, &sshdr,
 				  timeout, retries);
 
@@ -1892,10 +1903,15 @@ scsi_test_unit_ready(struct scsi_device 
 		if ((scsi_sense_valid(&sshdr)) &&
 		    ((sshdr.sense_key == UNIT_ATTENTION) ||
 		     (sshdr.sense_key == NOT_READY))) {
+			if (sshdr.asc == 0x3A)
+				maybe_present = 0;
 			sdev->changed = 1;
 			result = 0;
 		}
 	}
+
+	if (media_maybe_present)
+		*media_maybe_present = maybe_present;
 	return result;
 }
 EXPORT_SYMBOL(scsi_test_unit_ready);
diff -puN drivers/scsi/sd.c~scsi-early-detection-of-medium-not-present-updated drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~scsi-early-detection-of-medium-not-present-updated
+++ a/drivers/scsi/sd.c
@@ -759,7 +759,7 @@ static int sd_media_changed(struct gendi
 	retval = -ENODEV;
 
 	if (scsi_block_when_processing_errors(sdp))
-		retval = scsi_test_unit_ready(sdp, SD_TIMEOUT, SD_MAX_RETRIES);
+		retval = scsi_test_unit_ready(sdp, SD_TIMEOUT, SD_MAX_RETRIES, NULL);
 
 	/*
 	 * Unable to test, unit probably not ready.   This usually
diff -puN drivers/scsi/sr.c~scsi-early-detection-of-medium-not-present-updated drivers/scsi/sr.c
--- a/drivers/scsi/sr.c~scsi-early-detection-of-medium-not-present-updated
+++ a/drivers/scsi/sr.c
@@ -177,18 +177,21 @@ static int sr_media_change(struct cdrom_
 {
 	struct scsi_cd *cd = cdi->handle;
 	int retval;
+	int media_maybe_present;
 
 	if (CDSL_CURRENT != slot) {
 		/* no changer support */
 		return -EINVAL;
 	}
 
-	retval = scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES);
-	if (retval) {
-		/* Unable to test, unit probably not ready.  This usually
-		 * means there is no disc in the drive.  Mark as changed,
-		 * and we will figure it out later once the drive is
-		 * available again.  */
+	retval = scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES,
+				      &media_maybe_present);
+	if (retval || !media_maybe_present) {
+		/* Media not present or unable to test, unit probably not
+		 * ready. This usually means there is no disc in the drive.
+		 * Mark as changed, and we will figure it out later once
+		 * the drive is available again.
+		 */
 		cd->device->changed = 1;
 		/* This will force a flush, if called from check_disk_change */
 		retval = 1;
diff -puN include/scsi/scsi_device.h~scsi-early-detection-of-medium-not-present-updated include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h~scsi-early-detection-of-medium-not-present-updated
+++ a/include/scsi/scsi_device.h
@@ -283,7 +283,7 @@ extern int scsi_mode_select(struct scsi_
 			    struct scsi_mode_data *data,
 			    struct scsi_sense_hdr *);
 extern int scsi_test_unit_ready(struct scsi_device *sdev, int timeout,
-				int retries);
+				int retries, int *media_maybe_present);
 extern int scsi_device_set_state(struct scsi_device *sdev,
 				 enum scsi_device_state state);
 extern int scsi_device_event_notify(struct scsi_device *sdev,
_
