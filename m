From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/7] scsi: replace sr_test_unit_ready() with scsi_test_unit_ready()
Date: Mon,  1 Nov 2010 19:44:39 +0100
Message-ID: <1288637081-5183-6-git-send-email-tj@kernel.org>
References: <1288637081-5183-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1288637081-5183-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, jack@suse.cz, James.Bottomley@HansenPartnership.com
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

The usage of TUR has been confusing involving several different
commits updating different parts over time.  Currently, the only
differences between scsi_test_unit_ready() and sr_test_unit_ready()
are,

* scsi_test_unit_ready() also sets sdev->changed on NOT_READY.

* scsi_test_unit_ready() returns 0 if TUR ended with UNIT_ATTENTION or
  NOT_READY.

Due to the above two differences, sr is using its own
sr_test_unit_ready(), but sd - the sole user of the above extra
handling - doesn't even need them.

Where scsi_test_unit_ready() is used in sd_media_changed(), the code
is looking for device ready w/ media present state which is true iff
TUR succeeds w/o sense data or UA, and when the device is not ready
for whatever reason sd_media_changed() explicitly marks media as
missing so there's no reason to set sdev->changed automatically from
scsi_test_unit_ready() on NOT_READY.

Drop both special handlings from scsi_test_unit_ready(), which makes
it equivalant to sr_test_unit_ready(), and replace
sr_test_unit_ready() with scsi_test_unit_ready().  Also, drop
unnecessary explicit NOT_READY check from sd_media_changed().
Checking return value is enough for testing device readiness.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/scsi/scsi_lib.c |   13 +------------
 drivers/scsi/sd.c       |   10 +---------
 drivers/scsi/sr.c       |   37 ++++++-------------------------------
 drivers/scsi/sr.h       |    1 -
 drivers/scsi/sr_ioctl.c |    2 +-
 5 files changed, 9 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index eafeeda..13bf891 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1984,8 +1984,7 @@ EXPORT_SYMBOL(scsi_mode_sense);
  *		in.
  *
  *	Returns zero if unsuccessful or an error if TUR failed.  For
- *	removable media, a return of NOT_READY or UNIT_ATTENTION is
- *	translated to success, with the ->changed flag updated.
+ *	removable media, UNIT_ATTENTION sets ->changed flag.
  **/
 int
 scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
@@ -2012,16 +2011,6 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 	} while (scsi_sense_valid(sshdr) &&
 		 sshdr->sense_key == UNIT_ATTENTION && --retries);
 
-	if (!sshdr)
-		/* could not allocate sense buffer, so can't process it */
-		return result;
-
-	if (sdev->removable && scsi_sense_valid(sshdr) &&
-	    (sshdr->sense_key == UNIT_ATTENTION ||
-	     sshdr->sense_key == NOT_READY)) {
-		sdev->changed = 1;
-		result = 0;
-	}
 	if (!sshdr_external)
 		kfree(sshdr);
 	return result;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b9ab3a5..8d488a9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1045,15 +1045,7 @@ static int sd_media_changed(struct gendisk *disk)
 					      sshdr);
 	}
 
-	/*
-	 * Unable to test, unit probably not ready.   This usually
-	 * means there is no disc in the drive.  Mark as changed,
-	 * and we will figure it out later once the drive is
-	 * available again.
-	 */
-	if (retval || (scsi_sense_valid(sshdr) &&
-		       /* 0x3a is medium not present */
-		       sshdr->asc == 0x3a)) {
+	if (retval) {
 		set_media_not_present(sdkp);
 		retval = 1;
 		goto out;
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index d7b383c..63cdbc6 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -165,32 +165,6 @@ static void scsi_cd_put(struct scsi_cd *cd)
 	mutex_unlock(&sr_ref_mutex);
 }
 
-/* identical to scsi_test_unit_ready except that it doesn't
- * eat the NOT_READY returns for removable media */
-int sr_test_unit_ready(struct scsi_device *sdev, struct scsi_sense_hdr *sshdr)
-{
-	int retries = MAX_RETRIES;
-	int the_result;
-	u8 cmd[] = {TEST_UNIT_READY, 0, 0, 0, 0, 0 };
-
-	/* issue TEST_UNIT_READY until the initial startup UNIT_ATTENTION
-	 * conditions are gone, or a timeout happens
-	 */
-	do {
-		the_result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL,
-					      0, sshdr, SR_TIMEOUT,
-					      retries--, NULL);
-		if (scsi_sense_valid(sshdr) &&
-		    sshdr->sense_key == UNIT_ATTENTION)
-			sdev->changed = 1;
-
-	} while (retries > 0 &&
-		 (!scsi_status_is_good(the_result) ||
-		  (scsi_sense_valid(sshdr) &&
-		   sshdr->sense_key == UNIT_ATTENTION)));
-	return the_result;
-}
-
 /*
  * This function checks to see if the media has been changed in the
  * CDROM drive.  It is possible that we have already sensed a change,
@@ -213,10 +187,11 @@ static int sr_media_change(struct cdrom_device_info *cdi, int slot)
 	}
 
 	sshdr =  kzalloc(sizeof(*sshdr), GFP_KERNEL);
-	retval = sr_test_unit_ready(cd->device, sshdr);
-	if (retval || (scsi_sense_valid(sshdr) &&
-		       /* 0x3a is medium not present */
-		       sshdr->asc == 0x3a)) {
+	retval = scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES,
+				      sshdr);
+	if (host_byte(retval) || (scsi_sense_valid(sshdr) &&
+				  /* ASC 0x3a is medium not present */
+				  sshdr->asc == 0x3a)) {
 		/* Media not present or unable to test, unit probably not
 		 * ready. This usually means there is no disc in the drive.
 		 * Mark as changed, and we will figure it out later once
@@ -780,7 +755,7 @@ static void get_capabilities(struct scsi_cd *cd)
 	}
 
 	/* eat unit attentions */
-	sr_test_unit_ready(cd->device, &sshdr);
+	scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
 
 	/* ask for mode page 0x2a */
 	rc = scsi_mode_sense(cd->device, 0, 0x2a, buffer, 128,
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index 1e144df..81fbc0b 100644
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -61,7 +61,6 @@ int sr_select_speed(struct cdrom_device_info *cdi, int speed);
 int sr_audio_ioctl(struct cdrom_device_info *, unsigned int, void *);
 
 int sr_is_xa(Scsi_CD *);
-int sr_test_unit_ready(struct scsi_device *sdev, struct scsi_sense_hdr *sshdr);
 
 /* sr_vendor.c */
 void sr_vendor_init(Scsi_CD *);
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index 3cd8ffb..8be3055 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -307,7 +307,7 @@ int sr_drive_status(struct cdrom_device_info *cdi, int slot)
 		/* we have no changer support */
 		return -EINVAL;
 	}
-	if (0 == sr_test_unit_ready(cd->device, &sshdr))
+	if (!scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr))
 		return CDS_DISC_OK;
 
 	/* SK/ASC/ASCQ of 2/4/1 means "unit is becoming ready" */
-- 
1.7.1
