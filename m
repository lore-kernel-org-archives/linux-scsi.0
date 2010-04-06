From: Ravi Anand <ravi.anand@qlogic.com>
Subject: [PATCH 05/12] qla4xxx: Updated firmware ready timeout algorithm
Date: Tue, 6 Apr 2010 03:14:08 -0700
Message-ID: <20100406101408.GL22922@linux-qf4p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:27577 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab0DFKPq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2010 06:15:46 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Updated firmware ready timeout algorithm to prevent
long delays and use jiffies to time out instead of
counter. Also use msleep_interruptible instead of msleep.

Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_init.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 2c14235..e91b33a 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -1046,7 +1046,7 @@ static void qla4x00_pci_config(struct scsi_qla_host *ha)
 static int qla4xxx_start_firmware_from_flash(struct scsi_qla_host *ha)
 {
 	int status = QLA_ERROR;
-	uint32_t max_wait_time;
+	unsigned long max_wait_time;
 	unsigned long flags;
 	uint32_t mbox_status;
 
@@ -1078,7 +1078,10 @@ static int qla4xxx_start_firmware_from_flash(struct scsi_qla_host *ha)
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	/* Wait for firmware to come UP. */
-	max_wait_time = FIRMWARE_UP_TOV * 4;
+	DEBUG2(printk(KERN_INFO "scsi%ld: %s: Wait up to %d seconds for "
+		      "boot firmware to complete... \n",
+		      ha->host_no, __func__, FIRMWARE_UP_TOV));
+	max_wait_time = jiffies + (FIRMWARE_UP_TOV * HZ);
 	do {
 		uint32_t ctrl_status;
 
@@ -1092,16 +1095,15 @@ static int qla4xxx_start_firmware_from_flash(struct scsi_qla_host *ha)
 		if (mbox_status == MBOX_STS_COMMAND_COMPLETE)
 			break;
 
-		DEBUG2(printk("scsi%ld: %s: Waiting for boot firmware to "
-			      "complete... ctrl_sts=0x%x, remaining=%d\n",
-			      ha->host_no, __func__, ctrl_status,
-			      max_wait_time));
+		DEBUG2(printk(KERN_INFO "scsi%ld: %s: Waiting for boot "
+			      "firmware to complete... ctrl_sts=0x%x\n",
+			      ha->host_no, __func__, ctrl_status));
 
-		msleep(250);
-	} while ((max_wait_time--));
+		msleep_interruptible(250);
+	} while (!time_after_eq(jiffies, max_wait_time));
 
 	if (mbox_status == MBOX_STS_COMMAND_COMPLETE) {
-		DEBUG(printk("scsi%ld: %s: Firmware has started\n",
+		DEBUG(printk(KERN_INFO "scsi%ld: %s: Firmware has started\n",
 			     ha->host_no, __func__));
 
 		spin_lock_irqsave(&ha->hardware_lock, flags);
-- 
1.6.0.2

----- End forwarded message -----
