From: madhu.iyengar@qlogic.com
Subject: [PATCH 1/1] qla2xxx: ROM lock recovery if fw hangs while holding the lock.
Date: Tue,  7 Sep 2010 20:55:32 -0700
Message-ID: <1283918132-9521-2-git-send-email-madhu.iyengar@qlogic.com>
References: <1283918132-9521-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:49269 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1750849Ab0IHEA7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Sep 2010 00:00:59 -0400
In-Reply-To: <1283918132-9521-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Shyam Sundar <shyam.sundar@qlogic.com>

From: Shyam Sundar <shyam.sundar@qlogic.com>


Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |   39 ++++++++++++++++++++++++++++++++++++---
 1 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index c5ac876..73bd86d 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3165,6 +3165,20 @@ qla82xx_start_iocbs(srb_t *sp)
 	}
 }
 
+void qla82xx_rom_lock_recovery(struct qla_hw_data *ha)
+{
+	if (qla82xx_rom_lock(ha))
+		/* Someone else is holding the lock. */
+		qla_printk(KERN_INFO, ha, "Resetting rom_lock\n");
+
+	/*
+	 * Either we got the lock, or someone
+	 * else died while holding it.
+	 * In either case, unlock.
+	 */
+	qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM2_UNLOCK));
+}
+
 /*
  * qla82xx_device_bootstrap
  *    Initialize device, set DEV_READY, start fw
@@ -3179,12 +3193,13 @@ qla82xx_start_iocbs(srb_t *sp)
 static int
 qla82xx_device_bootstrap(scsi_qla_host_t *vha)
 {
-	int rval, i, timeout;
+	int rval = QLA_SUCCESS;
+	int i, timeout;
 	uint32_t old_count, count;
 	struct qla_hw_data *ha = vha->hw;
+	int need_reset = 0, peg_stuck = 1;
 
-	if (qla82xx_need_reset(ha))
-		goto dev_initialize;
+	need_reset = qla82xx_need_reset(ha);
 
 	old_count = qla82xx_rd_32(ha, QLA82XX_PEG_ALIVE_COUNTER);
 
@@ -3198,9 +3213,27 @@ qla82xx_device_bootstrap(scsi_qla_host_t *vha)
 
 		count = qla82xx_rd_32(ha, QLA82XX_PEG_ALIVE_COUNTER);
 		if (count != old_count)
+			peg_stuck = 0;
+	}
+
+	if (need_reset) {
+		/* We are trying to perform a recovery here. */
+		if (peg_stuck)
+			qla82xx_rom_lock_recovery(ha);
+		goto dev_initialize;
+	} else  {
+		/* Start of day for this ha context. */
+		if (peg_stuck) {
+			/* Either we are the first or recovery in progress. */
+			qla82xx_rom_lock_recovery(ha);
+			goto dev_initialize;
+		} else
+			/* Firmware already running. */
 			goto dev_ready;
 	}
 
+	return rval;
+
 dev_initialize:
 	/* set to DEV_INITIALIZING */
 	qla_printk(KERN_INFO, ha, "HW State: INITIALIZING\n");
-- 
1.6.0.2

