From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 43/47] fas216: Rework device reset to not rely on SCSI command pointer
Date: Wed, 28 Jun 2017 10:33:09 +0200
Message-ID: <1498638793-44672-44-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53811 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751739AbdF1Idl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:41 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The device reset code should not rely on the SCSI command pointer;
it will be going away with the device reset handler rework.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/arm/fas216.c | 51 +++++++++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index c93ad3a..e3ff1c3 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -1985,8 +1985,7 @@ static void fas216_devicereset_done(FAS216_Info *info, struct scsi_cmnd *SCpnt,
 {
 	fas216_log(info, LOG_ERROR, "fas216 device reset complete");
 
-	info->rstSCpnt = NULL;
-	info->rst_dev_status = 1;
+	info->rst_dev_status = 0;
 	wake_up(&info->eh_wait);
 }
 
@@ -2139,12 +2138,12 @@ static void fas216_done(FAS216_Info *info, unsigned int result)
 
 	fas216_checkmagic(info);
 
-	if (!info->SCpnt)
+	if (!info->SCpnt && !info->rst_dev_status)
 		goto no_command;
 
 	SCpnt = info->SCpnt;
 	info->SCpnt = NULL;
-    	info->scsi.phase = PHASE_IDLE;
+	info->scsi.phase = PHASE_IDLE;
 
 	if (info->scsi.aborting) {
 		fas216_log(info, 0, "uncaught abort - returning DID_ABORT");
@@ -2156,7 +2155,7 @@ static void fas216_done(FAS216_Info *info, unsigned int result)
 	 * Sanity check the completion - if we have zero bytes left
 	 * to transfer, we should not have a valid pointer.
 	 */
-	if (info->scsi.SCp.ptr && info->scsi.SCp.this_residual == 0) {
+	if (SCpnt && info->scsi.SCp.ptr && info->scsi.SCp.this_residual == 0) {
 		scmd_printk(KERN_INFO, SCpnt,
 			    "zero bytes left to transfer, but buffer pointer still valid: ptr=%p len=%08x\n",
 			    info->scsi.SCp.ptr, info->scsi.SCp.this_residual);
@@ -2169,12 +2168,18 @@ static void fas216_done(FAS216_Info *info, unsigned int result)
 	 * the sense information, fas216_kick will re-assert the busy
 	 * status.
 	 */
-	info->device[SCpnt->device->id].parity_check = 0;
-	clear_bit(SCpnt->device->id * 8 +
-		  (u8)(SCpnt->device->lun & 0x7), info->busyluns);
-
-	fn = (void (*)(FAS216_Info *, struct scsi_cmnd *, unsigned int))SCpnt->host_scribble;
-	fn(info, SCpnt, result);
+	if (SCpnt) {
+		info->device[SCpnt->device->id].parity_check = 0;
+		clear_bit(SCpnt->device->id * 8 +
+			  (u8)(SCpnt->device->lun & 0x7), info->busyluns);
+	}
+	if (info->rst_dev_status) {
+		info->rst_dev_status = 0;
+		wake_up(&info->eh_wait);
+	} else {
+		fn = (void (*)(FAS216_Info *, struct scsi_cmnd *, unsigned int))SCpnt->host_scribble;
+		fn(info, SCpnt, result);
+	}
 
 	if (info->scsi.irq) {
 		spin_lock_irqsave(&info->host_lock, flags);
@@ -2326,9 +2331,9 @@ static void fas216_eh_timer(unsigned long data)
 
 	del_timer(&info->eh_timer);
 
-	if (info->rst_bus_status == 0)
+	if (info->rst_bus_status == 1)
 		info->rst_bus_status = -1;
-	if (info->rst_dev_status == 0)
+	if (info->rst_dev_status == 1)
 		info->rst_dev_status = -1;
 
 	wake_up(&info->eh_wait);
@@ -2471,9 +2476,10 @@ int fas216_eh_abort(struct scsi_cmnd *SCpnt)
  */
 int fas216_eh_device_reset(struct scsi_cmnd *SCpnt)
 {
-	FAS216_Info *info = (FAS216_Info *)SCpnt->device->host->hostdata;
+	struct scsi_device *sdev = SCpnt->device;
+	FAS216_Info *info = (FAS216_Info *)sdev->host->hostdata;
 	unsigned long flags;
-	int i, res = FAILED, target = SCpnt->device->id;
+	int i, res = FAILED, target = sdev->id;
 
 	fas216_log(info, LOG_ERROR, "device reset for target %d", target);
 
@@ -2487,7 +2493,7 @@ int fas216_eh_device_reset(struct scsi_cmnd *SCpnt)
 		 * and we need a bus reset.
 		 */
 		if (info->SCpnt && !info->scsi.disconnectable &&
-		    info->SCpnt->device->id == SCpnt->device->id)
+		    info->SCpnt->device->id == sdev->id)
 			break;
 
 		/*
@@ -2505,14 +2511,7 @@ int fas216_eh_device_reset(struct scsi_cmnd *SCpnt)
 		for (i = 0; i < 8; i++)
 			clear_bit(target * 8 + i, info->busyluns);
 
-		/*
-		 * Hijack this SCSI command structure to send
-		 * a bus device reset message to this device.
-		 */
-		SCpnt->host_scribble = (void *)fas216_devicereset_done;
-
-		info->rst_dev_status = 0;
-		info->rstSCpnt = SCpnt;
+		info->rst_dev_status = 1;
 
 		if (info->scsi.phase == PHASE_IDLE)
 			fas216_kick(info);
@@ -2523,13 +2522,13 @@ int fas216_eh_device_reset(struct scsi_cmnd *SCpnt)
 		/*
 		 * Wait up to 30 seconds for the reset to complete.
 		 */
-		wait_event(info->eh_wait, info->rst_dev_status);
+		wait_event(info->eh_wait, info->rst_dev_status <= 0);
 
 		del_timer_sync(&info->eh_timer);
 		spin_lock_irqsave(&info->host_lock, flags);
 		info->rstSCpnt = NULL;
 
-		if (info->rst_dev_status == 1)
+		if (info->rst_dev_status == 0)
 			res = SUCCESS;
 	} while (0);
 
-- 
1.8.5.6
