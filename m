From: Ravi Anand <ravi.anand@qlogic.com>
Subject: [PATCH 01/12] qla4xxx: wait for device to come online in reset_lun
Date: Tue, 6 Apr 2010 03:13:33 -0700
Message-ID: <20100406101333.GH22922@linux-qf4p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:27529 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab0DFKPM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2010 06:15:12 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>


From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

wait upto 10s for device to come online otherwise indicating
an error condition.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h |    1 +
 drivers/scsi/qla4xxx/ql4_mbx.c |   22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 81b5f29..38e261d 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -146,6 +146,7 @@
 #define ISNS_DEREG_TOV			5
 
 #define MAX_RESET_HA_RETRIES		2
+#define DEVICE_ONLINE_TOV		10
 
 /*
  * SCSI Request Block structure	 (srb)	that is placed
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 09d6d4b..4d8b3cb 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -679,11 +679,33 @@ int qla4xxx_reset_lun(struct scsi_qla_host * ha, struct ddb_entry * ddb_entry,
 	uint32_t mbox_cmd[MBOX_REG_COUNT];
 	uint32_t mbox_sts[MBOX_REG_COUNT];
 	int status = QLA_SUCCESS;
+	unsigned long wait_online;
 
 	DEBUG2(printk("scsi%ld:%d:%d: lun reset issued\n", ha->host_no,
 		      ddb_entry->os_target_id, lun));
 
 	/*
+	 * If device is not online wait for 10 sec for device to come online.
+	 * else return error
+	 */
+	if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
+		wait_online = jiffies + (DEVICE_ONLINE_TOV * HZ);
+		while (time_before(jiffies, wait_online)) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule_timeout(HZ);
+			if (atomic_read(&ddb_entry->state) == DDB_STATE_ONLINE)
+				break;
+		}
+
+		if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
+			DEBUG2(printk(KERN_WARNING "scsi%ld: %s: Unable to "
+					"reset lun. Device is not online.\n",
+					ha->host_no, __func__));
+			return QLA_ERROR;
+		}
+	}
+
+	/*
 	 * Send lun reset command to ISP, so that the ISP will return all
 	 * outstanding requests with RESET status
 	 */
-- 
1.6.0.2

----- End forwarded message -----
