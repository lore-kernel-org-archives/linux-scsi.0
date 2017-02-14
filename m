From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/6] sd: improve TUR handling in sd_check_events
Date: Tue, 14 Feb 2017 20:15:56 +0100
Message-ID: <20170214191600.17480-3-hch@lst.de>
References: <20170214191600.17480-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170214191600.17480-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernek.dk
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Remove bogus evaluations of retval and sshdr when the device is offline,
and fix a possible NULL pointer dereference by allocating the 8 byte
sized sense header on stack.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 40b4038c019e..11e290d1dbff 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1425,7 +1425,6 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 {
 	struct scsi_disk *sdkp = scsi_disk_get(disk);
 	struct scsi_device *sdp;
-	struct scsi_sense_hdr *sshdr = NULL;
 	int retval;
 
 	if (!sdkp)
@@ -1454,22 +1453,21 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 	 * by sd_spinup_disk() from sd_revalidate_disk(), which happens whenever
 	 * sd_revalidate() is called.
 	 */
-	retval = -ENODEV;
-
 	if (scsi_block_when_processing_errors(sdp)) {
-		sshdr  = kzalloc(sizeof(*sshdr), GFP_KERNEL);
+		struct scsi_sense_hdr sshdr = { 0, };
+
 		retval = scsi_test_unit_ready(sdp, SD_TIMEOUT, SD_MAX_RETRIES,
-					      sshdr);
-	}
+					      &sshdr);
 
-	/* failed to execute TUR, assume media not present */
-	if (host_byte(retval)) {
-		set_media_not_present(sdkp);
-		goto out;
-	}
+		/* failed to execute TUR, assume media not present */
+		if (host_byte(retval)) {
+			set_media_not_present(sdkp);
+			goto out;
+		}
 
-	if (media_not_present(sdkp, sshdr))
-		goto out;
+		if (media_not_present(sdkp, &sshdr))
+			goto out;
+	}
 
 	/*
 	 * For removable scsi disk we have to recognise the presence
@@ -1485,7 +1483,6 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 	 *	Medium present state has changed in either direction.
 	 *	Device has indicated UNIT_ATTENTION.
 	 */
-	kfree(sshdr);
 	retval = sdp->changed ? DISK_EVENT_MEDIA_CHANGE : 0;
 	sdp->changed = 0;
 	scsi_disk_put(sdkp);
-- 
2.11.0
