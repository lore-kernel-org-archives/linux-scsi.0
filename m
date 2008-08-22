From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 1/2] add inline functions for recognising created and
	blocked states
Date: Fri, 22 Aug 2008 16:43:59 -0500
Message-ID: <1219441439.3339.100.camel@localhost.localdomain>
References: <200808111804.m7BI46kb004687@d03av03.boulder.ibm.com>
	 <1218840807.3350.72.camel@localhost.localdomain>
	 <48A981F0.5030002@linux.vnet.ibm.com>
	 <1219068727.3261.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50736 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756005AbYHVVoB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2008 17:44:01 -0400
In-Reply-To: <1219068727.3261.7.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org

The created and blocked states are very shortly going to correspond to
mixed sdev_state states.

James


---
 drivers/scsi/scsi.c        |   13 +++++++------
 drivers/scsi/scsi_scan.c   |    4 ++--
 include/scsi/scsi_device.h |   11 +++++++++++
 3 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index ee6be59..762a879 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -664,13 +664,14 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		goto out;
 	}
 
-	/* Check to see if the scsi lld put this device into state SDEV_BLOCK. */
-	if (unlikely(cmd->device->sdev_state == SDEV_BLOCK)) {
+	/* Check to see if the scsi lld made this device blocked. */
+	if (unlikely(scsi_device_blocked(cmd->device))) {
 		/* 
-		 * in SDEV_BLOCK, the command is just put back on the device
-		 * queue.  The suspend state has already blocked the queue so
-		 * future requests should not occur until the device 
-		 * transitions out of the suspend state.
+		 * in blocked state, the command is just put back on
+		 * the device queue.  The suspend state has already
+		 * blocked the queue so future requests should not
+		 * occur until the device transitions out of the
+		 * suspend state.
 		 */
 		scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 84b4879..55e76c0 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -994,7 +994,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	 */
 	sdev = scsi_device_lookup_by_target(starget, lun);
 	if (sdev) {
-		if (rescan || sdev->sdev_state != SDEV_CREATED) {
+		if (rescan || !scsi_device_created(sdev)) {
 			SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
 				"scsi scan: device exists on %s\n",
 				sdev->sdev_gendev.bus_id));
@@ -1466,7 +1466,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	kfree(lun_data);
  out:
 	scsi_device_put(sdev);
-	if (sdev->sdev_state == SDEV_CREATED)
+	if (scsi_device_created(sdev))
 		/*
 		 * the sdev we used didn't appear in the report luns scan
 		 */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 80b2e93..cc46652 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -384,10 +384,21 @@ static inline unsigned int sdev_id(struct scsi_device *sdev)
 #define scmd_id(scmd) sdev_id((scmd)->device)
 #define scmd_channel(scmd) sdev_channel((scmd)->device)
 
+/*
+ * checks for positions of the SCSI state machine
+ */
 static inline int scsi_device_online(struct scsi_device *sdev)
 {
 	return sdev->sdev_state != SDEV_OFFLINE;
 }
+static inline int scsi_device_blocked(struct scsi_device *sdev)
+{
+	return sdev->sdev_state == SDEV_BLOCK;
+}
+static inline int scsi_device_created(struct scsi_device *sdev)
+{
+	return sdev->sdev_state == SDEV_CREATED;
+}
 
 /* accessor functions for the SCSI parameters */
 static inline int scsi_device_sync(struct scsi_device *sdev)
-- 
1.5.6.3



