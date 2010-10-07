From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 11/15] qla4xxx: Clear the rom lock if the firmware died
 while holding it.
Date: Wed, 6 Oct 2010 22:50:51 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8712940678E@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:39117 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab0JGFux convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2010 01:50:53 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Shyam Sundar <shyam.sundar@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

From: Shyam Sundar <shyam.sundar@qlogic.com>

There is a possibility that the firmware dies while the rom
lock is held. The only way to recover from this condition is
to forcefully unlock.

Signed-off-by: Shyam Sundar <shyam.sundar@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c |   49 ++++++++++++++++++++++++++++++++++++-----
 1 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 080e297..66946d8 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -838,8 +838,11 @@ qla4_8xxx_rom_lock(struct scsi_qla_host *ha)
 		done = qla4_8xxx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM2_LOCK));
 		if (done == 1)
 			break;
-		if (timeout >= qla4_8xxx_rom_lock_timeout)
+		if (timeout >= qla4_8xxx_rom_lock_timeout) {
+			ql4_printk(KERN_WARNING, ha,
+			    "%s: Failed to acquire rom lock", __func__);
 			return -1;
+		}
 
 		timeout++;
 
@@ -1549,6 +1552,21 @@ qla4_8xxx_try_start_fw(struct scsi_qla_host *ha)
 	return rval;
 }
 
+static void qla4_8xxx_rom_lock_recovery(struct scsi_qla_host *ha)
+{
+	if (qla4_8xxx_rom_lock(ha)) {
+		/* Someone else is holding the lock. */
+		dev_info(&ha->pdev->dev, "Resetting rom_lock\n");
+	}
+
+	/*
+	 * Either we got the lock, or someone
+	 * else died while holding it.
+	 * In either case, unlock.
+	 */
+	qla4_8xxx_rom_unlock(ha);
+}
+
 /**
  * qla4_8xxx_device_bootstrap - Initialize device, set DEV_READY, start fw
  * @ha: pointer to adapter structure
@@ -1558,11 +1576,12 @@ qla4_8xxx_try_start_fw(struct scsi_qla_host *ha)
 static int
 qla4_8xxx_device_bootstrap(struct scsi_qla_host *ha)
 {
-	int rval, i, timeout;
+	int rval = QLA_ERROR;
+	int i, timeout;
 	uint32_t old_count, count;
+	int need_reset = 0, peg_stuck = 1;
 
-	if (qla4_8xxx_need_reset(ha))
-		goto dev_initialize;
+	need_reset = qla4_8xxx_need_reset(ha);
 
 	old_count = qla4_8xxx_rd_32(ha, QLA82XX_PEG_ALIVE_COUNTER);
 
@@ -1571,12 +1590,30 @@ qla4_8xxx_device_bootstrap(struct scsi_qla_host *ha)
 		if (timeout) {
 			qla4_8xxx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
 			   QLA82XX_DEV_FAILED);
-			return QLA_ERROR;
+			return rval;
 		}
 
 		count = qla4_8xxx_rd_32(ha, QLA82XX_PEG_ALIVE_COUNTER);
 		if (count != old_count)
+			peg_stuck = 0;
+	}
+
+	if (need_reset) {
+		/* We are trying to perform a recovery here. */
+		if (peg_stuck)
+			qla4_8xxx_rom_lock_recovery(ha);
+		goto dev_initialize;
+	} else  {
+		/* Start of day for this ha context. */
+		if (peg_stuck) {
+			/* Either we are the first or recovery in progress. */
+			qla4_8xxx_rom_lock_recovery(ha);
+			goto dev_initialize;
+		} else {
+			/* Firmware already running. */
+			rval = QLA_SUCCESS;
 			goto dev_ready;
+		}
 	}
 
 dev_initialize:
@@ -1602,7 +1639,7 @@ dev_ready:
 	ql4_printk(KERN_INFO, ha, "HW State: READY\n");
 	qla4_8xxx_wr_32(ha, QLA82XX_CRB_DEV_STATE, QLA82XX_DEV_READY);
 
-	return QLA_SUCCESS;
+	return rval;
 }
 
 /**
-- 
1.6.6

