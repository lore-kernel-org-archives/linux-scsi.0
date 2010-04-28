From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 04/11] qla4xxx: Updated firmware ready timeout algorithm
Date: Wed, 28 Apr 2010 11:40:37 +0530
Message-ID: <20100428061037.GA11125@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:18792
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1754080Ab0D1GZB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Apr 2010 02:25:01 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Karen Higgins <karen.higgins@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

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
index 7f6cc2e..beaeb18 100644
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
+		      "boot firmware to complete...\n",
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
1.7.0.5

