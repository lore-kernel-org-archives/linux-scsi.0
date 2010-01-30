From: Ravi Anand <ravi.anand@qlogic.com>
Subject: [PATCH 05/11] qla4xxx: Updated firmware ready timeout algorithm to
	prevent long delays
Date: Fri, 29 Jan 2010 22:28:48 -0800
Message-ID: <20100130062848.GF10274@linux-qf4p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:9009 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab0A3G06 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Jan 2010 01:26:58 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ls_jm@qlogic.org
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

and use jiffies to time out instead of counter. Also use
msleep_interruptible instead of msleep.

Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_init.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index aafd1b5..11223d2 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -1040,7 +1040,7 @@ static void qla4x00_pci_config(struct scsi_qla_host *ha)
 static int qla4xxx_start_firmware_from_flash(struct scsi_qla_host *ha)
 {
 	int status = QLA_ERROR;
-	uint32_t max_wait_time;
+	unsigned long max_wait_time;
 	unsigned long flags;
 	uint32_t mbox_status;
 
@@ -1072,7 +1072,10 @@ static int qla4xxx_start_firmware_from_flash(struct scsi_qla_host *ha)
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	/* Wait for firmware to come UP. */
-	max_wait_time = FIRMWARE_UP_TOV * 4;
+	DEBUG2(printk("scsi%ld: %s: Wait up to %d seconds for "
+		      "boot firmware to complete... \n",
+		      ha->host_no, __func__, FIRMWARE_UP_TOV));
+	max_wait_time = jiffies + (FIRMWARE_UP_TOV * HZ);
 	do {
 		uint32_t ctrl_status;
 
@@ -1087,12 +1090,11 @@ static int qla4xxx_start_firmware_from_flash(struct scsi_qla_host *ha)
 			break;
 
 		DEBUG2(printk("scsi%ld: %s: Waiting for boot firmware to "
-			      "complete... ctrl_sts=0x%x, remaining=%d\n",
-			      ha->host_no, __func__, ctrl_status,
-			      max_wait_time));
+			      "complete... ctrl_sts=0x%x\n",
+			      ha->host_no, __func__, ctrl_status));
 
-		msleep(250);
-	} while ((max_wait_time--));
+		msleep_interruptible(250);
+	} while (!time_after_eq(jiffies, max_wait_time));
 
 	if (mbox_status == MBOX_STS_COMMAND_COMPLETE) {
 		DEBUG(printk("scsi%ld: %s: Firmware has started\n",
-- 
1.6.0.2

