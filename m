From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 2/2] Update the SCSI state model to allow blocking in the
	created state
Date: Fri, 22 Aug 2008 16:53:31 -0500
Message-ID: <1219442011.3339.107.camel@localhost.localdomain>
References: <200808111804.m7BI46kb004687@d03av03.boulder.ibm.com>
	 <1218840807.3350.72.camel@localhost.localdomain>
	 <48A981F0.5030002@linux.vnet.ibm.com>
	 <1219068727.3261.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46285 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756773AbYHVVxe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2008 17:53:34 -0400
In-Reply-To: <1219068727.3261.7.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org

Brian King <brking@linux.vnet.ibm.com> reported that fibre channel
devices can oops during scanning if their ports block (because the
device goes from CREATED -> BLOCK -> RUNNING rather than CREATED ->
BLOCK -> CREATED).

Fix this by adding a new state: CREATED_BLOCK which can only transition
back to CREATED and disallow the CREATED -> BLOCK transition.  Now both
the created and blocked states that the mid-layer recognises can include
CREATED_BLOCK.

James

---

 drivers/scsi/scsi_lib.c    |   39 ++++++++++++++++++++++++++++++---------
 drivers/scsi/scsi_scan.c   |   16 ++++++++++++++--
 drivers/scsi/scsi_sysfs.c  |    1 +
 include/scsi/scsi_device.h |   14 +++++++++-----
 4 files changed, 54 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ff5d56b..42b33a3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1250,6 +1250,7 @@ int scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
 			break;
 		case SDEV_QUIESCE:
 		case SDEV_BLOCK:
+		case SDEV_CREATED_BLOCK:
 			/*
 			 * If the devices is blocked we defer normal commands.
 			 */
@@ -2063,10 +2064,13 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 
 	switch (state) {
 	case SDEV_CREATED:
-		/* There are no legal states that come back to
-		 * created.  This is the manually initialised start
-		 * state */
-		goto illegal;
+		switch (oldstate) {
+		case SDEV_CREATED_BLOCK:
+			break;
+		default:
+			goto illegal;
+		}
+		break;
 			
 	case SDEV_RUNNING:
 		switch (oldstate) {
@@ -2104,8 +2108,17 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 
 	case SDEV_BLOCK:
 		switch (oldstate) {
-		case SDEV_CREATED:
 		case SDEV_RUNNING:
+		case SDEV_CREATED_BLOCK:
+			break;
+		default:
+			goto illegal;
+		}
+		break;
+
+	case SDEV_CREATED_BLOCK:
+		switch (oldstate) {
+		case SDEV_CREATED:
 			break;
 		default:
 			goto illegal;
@@ -2393,8 +2406,12 @@ scsi_internal_device_block(struct scsi_device *sdev)
 	int err = 0;
 
 	err = scsi_device_set_state(sdev, SDEV_BLOCK);
-	if (err)
-		return err;
+	if (err) {
+		err = scsi_device_set_state(sdev, SDEV_CREATED_BLOCK);
+
+		if (err)
+			return err;
+	}
 
 	/* 
 	 * The device has transitioned to SDEV_BLOCK.  Stop the
@@ -2437,8 +2454,12 @@ scsi_internal_device_unblock(struct scsi_device *sdev)
 	 * and goose the device queue if successful.  
 	 */
 	err = scsi_device_set_state(sdev, SDEV_RUNNING);
-	if (err)
-		return err;
+	if (err) {
+		err = scsi_device_set_state(sdev, SDEV_CREATED);
+
+		if (err)
+			return err;
+	}
 
 	spin_lock_irqsave(q->queue_lock, flags);
 	blk_start_queue(q);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 55e76c0..c64bf13 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -730,6 +730,8 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		int *bflags, int async)
 {
+	int ret;
+
 	/*
 	 * XXX do not save the inquiry, since it can change underneath us,
 	 * save just vendor/model/rev.
@@ -885,7 +887,17 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
 	/* set the device running here so that slave configure
 	 * may do I/O */
-	scsi_device_set_state(sdev, SDEV_RUNNING);
+	ret = scsi_device_set_state(sdev, SDEV_RUNNING);
+	if (ret) {
+		ret = scsi_device_set_state(sdev, SDEV_BLOCK);
+
+		if (ret) {
+			sdev_printk(KERN_ERR, sdev,
+				    "in wrong state %s to complete scan\n",
+				    scsi_device_state_name(sdev->sdev_state));
+			return SCSI_SCAN_NO_RESPONSE;
+		}
+	}
 
 	if (*bflags & BLIST_MS_192_BYTES_FOR_3F)
 		sdev->use_192_bytes_for_3f = 1;
@@ -899,7 +911,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	transport_configure_device(&sdev->sdev_gendev);
 
 	if (sdev->host->hostt->slave_configure) {
-		int ret = sdev->host->hostt->slave_configure(sdev);
+		ret = sdev->host->hostt->slave_configure(sdev);
 		if (ret) {
 			/*
 			 * if LLDD reports slave not present, don't clutter
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ab3c718..09d311d 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -34,6 +34,7 @@ static const struct {
 	{ SDEV_QUIESCE, "quiesce" },
 	{ SDEV_OFFLINE,	"offline" },
 	{ SDEV_BLOCK,	"blocked" },
+	{ SDEV_CREATED_BLOCK, "created-blocked" },
 };
 
 const char *scsi_device_state_name(enum scsi_device_state state)
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index cc46652..b49e725 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -42,9 +42,11 @@ enum scsi_device_state {
 				 * originate in the mid-layer) */
 	SDEV_OFFLINE,		/* Device offlined (by error handling or
 				 * user request */
-	SDEV_BLOCK,		/* Device blocked by scsi lld.  No scsi 
-				 * commands from user or midlayer should be issued
-				 * to the scsi lld. */
+	SDEV_BLOCK,		/* Device blocked by scsi lld.  No
+				 * scsi commands from user or midlayer
+				 * should be issued to the scsi
+				 * lld. */
+	SDEV_CREATED_BLOCK,	/* same as above but for created devices */
 };
 
 enum scsi_device_event {
@@ -393,11 +395,13 @@ static inline int scsi_device_online(struct scsi_device *sdev)
 }
 static inline int scsi_device_blocked(struct scsi_device *sdev)
 {
-	return sdev->sdev_state == SDEV_BLOCK;
+	return sdev->sdev_state == SDEV_BLOCK ||
+		sdev->sdev_state == SDEV_CREATED_BLOCK;
 }
 static inline int scsi_device_created(struct scsi_device *sdev)
 {
-	return sdev->sdev_state == SDEV_CREATED;
+	return sdev->sdev_state == SDEV_CREATED ||
+		sdev->sdev_state == SDEV_CREATED_BLOCK;
 }
 
 /* accessor functions for the SCSI parameters */
-- 
1.5.6.3



