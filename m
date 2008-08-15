From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] scsi: Add added_to_sysfs sdev flag to fix device
	scanning oops
Date: Fri, 15 Aug 2008 17:53:27 -0500
Message-ID: <1218840807.3350.72.camel@localhost.localdomain>
References: <200808111804.m7BI46kb004687@d03av03.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49827 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752111AbYHOWxd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Aug 2008 18:53:33 -0400
In-Reply-To: <200808111804.m7BI46kb004687@d03av03.boulder.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2008-08-11 at 13:03 -0500, Brian King wrote:
> The following patch fixes an oops which was observed during device scanning.
> If LUN 0 does not exist for a valid target, but non-zero LUNs do exist, a struct
> scsi_device exists only when probing the target and is deleted by the scanning
> code, by checking to see if the device's state is SDEV_CREATED. If, while scanning,
> the rport is deleted, such that target is placed into the blocked state, and
> then later the rport is added again, the LUN 0 sdev finds its way into the SDEV_RUNNING
> state. This causes the scanning code to NOT delete the sdev when scanning is complete.
> Later on, if the target is deleted, we will oops when we try to free up everything
> that gets allocated in scsi_sysfs_add_sdev, since it was never added. This patch
> fixes this issue, by adding a added_to_sysfs flag to struct scsi_device, which is
> then checked to determine what to do, both in the device probe exit code and the
> device remove code.

What this seems to be exposing is a bug in the state model around the
blocked state.

The transition:

CREATED -> BLOCK -> RUNNING

shouldn't be legal.  My initial reaction is just to forbid the CREATED
-> BLOCK transition, but it looks like the fc transport code never
checks return values from scsi_target_block() (sigh!)

So an alternate fix should be to correct the state model rather than try
and work around the deficiencies with additional flags.

It looks like, to allow the CREATED -> BLOCK -> CREATED transition we
need an extra state (CREATED_BLOCK) and we forbid the CREATED -> BLOCK
in favour of it.

The model also now allows an online transition to do CREATED_BLOCK ->
BLOCK

This is a rough code of that, does it work for you?

James

---

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
index 84b4879..c6791a7 100644
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
@@ -994,7 +1006,8 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	 */
 	sdev = scsi_device_lookup_by_target(starget, lun);
 	if (sdev) {
-		if (rescan || sdev->sdev_state != SDEV_CREATED) {
+		if (rescan || (sdev->sdev_state != SDEV_CREATED &&
+			       sdev->sdev_state != SDEV_CREATED_BLOCK)) {
 			SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
 				"scsi scan: device exists on %s\n",
 				sdev->sdev_gendev.bus_id));
@@ -1466,7 +1479,8 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	kfree(lun_data);
  out:
 	scsi_device_put(sdev);
-	if (sdev->sdev_state == SDEV_CREATED)
+	if (sdev->sdev_state == SDEV_CREATED ||
+	    sdev->sdev_state == SDEV_CREATED_BLOCK)
 		/*
 		 * the sdev we used didn't appear in the report luns scan
 		 */
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
index 80b2e93..ad3d42d 100644
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


