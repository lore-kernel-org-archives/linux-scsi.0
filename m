From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] remove kmalloc'ed scsi_sense_hdr
Date: Tue, 8 Jul 2008 12:40:57 +0900
Message-ID: <20080708124056T.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:39467 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756087AbYGHDlD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jul 2008 23:41:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

This is an update of:

http://marc.info/?l=linux-scsi&m=121325263200592&w=2

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] remove kmalloc'ed scsi_sense_hdr

We don't do DMA to struct scsi_sense_hdr directly. There is no point
in using kmalloc for struct scsi_sense_hdr, just 8 bytes. This patch
simplifies some code to replace kmalloc'ed scsi_sense_hdr with one on
the stack.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_lib.c |   17 +++++------------
 drivers/scsi/sd.c       |   12 ++++++------
 drivers/scsi/sr.c       |   12 +++++-------
 3 files changed, 16 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0451903..d37cd5e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1953,18 +1953,16 @@ EXPORT_SYMBOL(scsi_mode_sense);
  **/
 int
 scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
-		     struct scsi_sense_hdr *sshdr_external)
+		     struct scsi_sense_hdr *sshdr)
 {
 	char cmd[] = {
 		TEST_UNIT_READY, 0, 0, 0, 0, 0,
 	};
-	struct scsi_sense_hdr *sshdr;
+	struct scsi_sense_hdr sshdr_internal;
 	int result;
 
-	if (!sshdr_external)
-		sshdr = kzalloc(sizeof(*sshdr), GFP_KERNEL);
-	else
-		sshdr = sshdr_external;
+	if (!sshdr)
+		sshdr = &sshdr_internal;
 
 	/* try to eat the UNIT_ATTENTION if there are enough retries */
 	do {
@@ -1974,10 +1972,6 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 		 sshdr && sshdr->sense_key == UNIT_ATTENTION &&
 		 --retries);
 
-	if (!sshdr)
-		/* could not allocate sense buffer, so can't process it */
-		return result;
-
 	if ((driver_byte(result) & DRIVER_SENSE) && sdev->removable) {
 
 		if ((scsi_sense_valid(sshdr)) &&
@@ -1987,8 +1981,7 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 			result = 0;
 		}
 	}
-	if (!sshdr_external)
-		kfree(sshdr);
+
 	return result;
 }
 EXPORT_SYMBOL(scsi_test_unit_ready);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 71069d9..2f5bd7c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -750,11 +750,13 @@ static int sd_media_changed(struct gendisk *disk)
 {
 	struct scsi_disk *sdkp = scsi_disk(disk);
 	struct scsi_device *sdp = sdkp->device;
-	struct scsi_sense_hdr *sshdr = NULL;
+	struct scsi_sense_hdr sshdr;
 	int retval;
 
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_media_changed\n"));
 
+	memset(&sshdr, 0, sizeof(sshdr));
+
 	if (!sdp->removable)
 		return 0;
 
@@ -782,9 +784,8 @@ static int sd_media_changed(struct gendisk *disk)
 	retval = -ENODEV;
 
 	if (scsi_block_when_processing_errors(sdp)) {
-		sshdr  = kzalloc(sizeof(*sshdr), GFP_KERNEL);
 		retval = scsi_test_unit_ready(sdp, SD_TIMEOUT, SD_MAX_RETRIES,
-					      sshdr);
+					      &sshdr);
 	}
 
 	/*
@@ -793,9 +794,9 @@ static int sd_media_changed(struct gendisk *disk)
 	 * and we will figure it out later once the drive is
 	 * available again.
 	 */
-	if (retval || (scsi_sense_valid(sshdr) &&
+	if (retval || (scsi_sense_valid(&sshdr) &&
 		       /* 0x3a is medium not present */
-		       sshdr->asc == 0x3a)) {
+		       sshdr.asc == 0x3a)) {
 		set_media_not_present(sdkp);
 		retval = 1;
 		goto out;
@@ -814,7 +815,6 @@ out:
 	if (retval != sdkp->previous_state)
 		sdev_evt_send_simple(sdp, SDEV_EVT_MEDIA_CHANGE, GFP_KERNEL);
 	sdkp->previous_state = retval;
-	kfree(sshdr);
 	return retval;
 }
 
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 7ee86d4..af93ca5 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -200,18 +200,17 @@ static int sr_media_change(struct cdrom_device_info *cdi, int slot)
 {
 	struct scsi_cd *cd = cdi->handle;
 	int retval;
-	struct scsi_sense_hdr *sshdr;
+	struct scsi_sense_hdr sshdr;
 
 	if (CDSL_CURRENT != slot) {
 		/* no changer support */
 		return -EINVAL;
 	}
 
-	sshdr =  kzalloc(sizeof(*sshdr), GFP_KERNEL);
-	retval = sr_test_unit_ready(cd->device, sshdr);
-	if (retval || (scsi_sense_valid(sshdr) &&
+	retval = sr_test_unit_ready(cd->device, &sshdr);
+	if (retval || (scsi_sense_valid(&sshdr) &&
 		       /* 0x3a is medium not present */
-		       sshdr->asc == 0x3a)) {
+		       sshdr.asc == 0x3a)) {
 		/* Media not present or unable to test, unit probably not
 		 * ready. This usually means there is no disc in the drive.
 		 * Mark as changed, and we will figure it out later once
@@ -239,11 +238,10 @@ out:
 		sdev_evt_send_simple(cd->device, SDEV_EVT_MEDIA_CHANGE,
 				     GFP_KERNEL);
 	cd->previous_state = retval;
-	kfree(sshdr);
 
 	return retval;
 }
- 
+
 /*
  * sr_done is the interrupt routine for the device driver.
  *
-- 
1.5.5.GIT

