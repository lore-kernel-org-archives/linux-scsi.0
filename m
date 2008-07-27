From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH] scsi: Generalise last_sector_bug; fixes regression and potential
 future issues on USB cardreaders
Date: Sun, 27 Jul 2008 09:38:42 +0100
Message-ID: <488C3412.9090704@tuffmail.co.uk>
References: <4888524D.9070906@tuffmail.co.uk>	 <4888565B.4020102@tuffmail.co.uk> <1217100375.3908.12.camel@localhost.localdomain> <488C337E.7020109@tuffmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.178]:10166 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbYG0Iir (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Jul 2008 04:38:47 -0400
Received: by ik-out-1112.google.com with SMTP id c28so3509029ika.5
        for <linux-scsi@vger.kernel.org>; Sun, 27 Jul 2008 01:38:45 -0700 (PDT)
In-Reply-To: <488C337E.7020109@tuffmail.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>

The last_sector_bug flag was added to work around a bug in certain usb
cardreaders, where they would crash if a multiple sector read included the
last sector. The original implementation avoids this by e.g. splitting an 8
sector read which includes the last sector into a 7 sector read, and a single
sector read for the last sector.  The flag is enabled for all USB devices.

This revealed a second bug in other usb cardreaders, which crash when they
get a multiple sector read which stops 1 sector short of the last sector.
Affected hardware includes the Kingston "MobileLite" external USB cardreader
and the internal USB cardreader on the Asus EeePC.

Extend the last_sector_bug workaround to ensure that any access which touches
the last 8 hardware sectors of the device is a single sector long.  Requests
are shrunk as necessary to meet this constraint.

This gives us a safety margin against potential unknown or future bugs
affecting multi-sector access to the end of the device.  The two known bugs
only affect the last 2 sectors.  However, they suggest that these devices
are prone to fencepost errors and that multi-sector access to the end of the
device is not well tested.  Popular OS's use multi-sector accesses, but they
rarely read the last few sectors.  Linux (with udev & vol_id) automatically
reads sectors from the end of the device on insertion.  It is assumed that
single sector accesses are more thoroughly tested during development.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Tested-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 01cefbb..a2b2cd7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -360,6 +360,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	struct scsi_device *sdp = q->queuedata;
 	struct gendisk *disk = rq->rq_disk;
 	sector_t block = rq->sector;
+	sector_t threshold;
 	unsigned int this_count = rq->nr_sectors;
 	unsigned int timeout = sdp->timeout;
 	int ret;
@@ -406,13 +407,21 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	}
 
 	/*
-	 * Some devices (some sdcards for one) don't like it if the
-	 * last sector gets read in a larger then 1 sector read.
+	 * Some SD card readers can't handle multi-sector accesses which touch
+	 * the last one or two hardware sectors.  Split accesses as needed.
 	 */
-	if (unlikely(sdp->last_sector_bug &&
-	    rq->nr_sectors > sdp->sector_size / 512 &&
-	    block + this_count == get_capacity(disk)))
-		this_count -= sdp->sector_size / 512;
+	threshold = get_capacity(disk) - SD_LAST_BUGGY_SECTORS *
+		(sdp->sector_size / 512);
+
+	if (unlikely(sdp->last_sector_bug && block + this_count > threshold)) {
+		if (block < threshold) {
+			/* Access up to the threshold but not beyond */
+			this_count = threshold - block;
+		} else {
+			/* Access only a single hardware sector */
+			this_count = sdp->sector_size / 512;
+		}
+	}
 
 	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt, "block=%llu\n",
 					(unsigned long long)block));
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index f6a9fe0..17b6c02 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -139,7 +139,8 @@ struct scsi_device {
 	unsigned fix_capacity:1;	/* READ_CAPACITY is too high by 1 */
 	unsigned guess_capacity:1;	/* READ_CAPACITY might be too high by 1 */
 	unsigned retry_hwerror:1;	/* Retry HARDWARE_ERROR */
-	unsigned last_sector_bug:1;	/* Always read last sector in a 1 sector read */
+	unsigned last_sector_bug:1;	/* do not use multisector accesses on
+					   SD_LAST_BUGGY_SECTORS */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
diff --git a/include/scsi/sd.h b/include/scsi/sd.h
index 4f032d4..d0364ff 100644
--- a/include/scsi/sd.h
+++ b/include/scsi/sd.h
@@ -31,6 +31,12 @@
  */
 #define SD_BUF_SIZE		512
 
+/*
+ * Number of sectors at the end of the device to avoid multi-sector accesses to
+ * in the case of last_sector_bug
+ */
+#define SD_LAST_BUGGY_SECTORS	8
+
 struct scsi_disk {
 	struct scsi_driver *driver;	/* always &sd_template */
 	struct scsi_device *device;


