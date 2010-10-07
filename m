From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 01/15] qla4xxx: Trivial cleanup
Date: Wed, 6 Oct 2010 22:47:48 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA87129406784@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:37478 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab0JGFrw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2010 01:47:52 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

* cleanup function qla4xxx_recovery_timeout
	- No need to wakeup dpc thread from function
	qla4xxx_recovery_timeout() as we are not doing anything
	in do_dpc() thread when wakeup from
	qla4xxx_recovery_timeout()

* cleanup function qla4xxx_wait_for_hba_online
	- Remove hard coded value from qla4xxx_wait_for_hba_online().

* cleanup function qla4xxx_start_firmware_from_flash
	- display seconds

* cleanup function  qla4_8xxx_load_risc
	- Remove redundant code.

* cleanup function qla4xxx_get_firmware_status
	- update debug statement

* cleanup function qla4_8xxx_try_start_fw
	- update return status

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h  |    1 +
 drivers/scsi/qla4xxx/ql4_init.c |    4 ++--
 drivers/scsi/qla4xxx/ql4_mbx.c  |    2 +-
 drivers/scsi/qla4xxx/ql4_nx.c   |   23 +++++++----------------
 drivers/scsi/qla4xxx/ql4_os.c   |    4 +---
 5 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 9dc0a66..f595ab1 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -179,6 +179,7 @@ static inline int pci_cleanup_aer_uncorrect_error_status(struct pci_dev *dev)
 #define IOCB_TOV_MARGIN			10
 #define RELOGIN_TOV			18
 #define ISNS_DEREG_TOV			5
+#define HBA_ONLINE_TOV			30
 
 #define MAX_RESET_HA_RETRIES		2
 
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 4c9be77..b6046af 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -1207,8 +1207,8 @@ static int qla4xxx_start_firmware_from_flash(struct scsi_qla_host *ha)
 			break;
 
 		DEBUG2(printk(KERN_INFO "scsi%ld: %s: Waiting for boot "
-			      "firmware to complete... ctrl_sts=0x%x\n",
-			      ha->host_no, __func__, ctrl_status));
+		    "firmware to complete... ctrl_sts=0x%x, remaining=%ld\n",
+		    ha->host_no, __func__, ctrl_status, max_wait_time));
 
 		msleep_interruptible(250);
 	} while (!time_after_eq(jiffies, max_wait_time));
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 9002170..494a28f 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -592,7 +592,7 @@ int qla4xxx_get_firmware_status(struct scsi_qla_host * ha)
 	}
 
 	ql4_printk(KERN_INFO, ha, "%ld firmare IOCBs available (%d).\n",
-	    ha->host_no, mbox_cmd[2]);
+	    ha->host_no, mbox_sts[2]);
 
 	return QLA_SUCCESS;
 }
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 5d4a382..080e297 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -1539,10 +1539,12 @@ qla4_8xxx_try_start_fw(struct scsi_qla_host *ha)
 	ql4_printk(KERN_INFO, ha,
 	    "FW: Attempting to load firmware from flash...\n");
 	rval = qla4_8xxx_start_firmware(ha, ha->hw.flt_region_fw);
-	if (rval == QLA_SUCCESS)
-		return rval;
 
-	ql4_printk(KERN_ERR, ha, "FW: Load firmware from flash FAILED...\n");
+	if (rval != QLA_SUCCESS) {
+		ql4_printk(KERN_ERR, ha, "FW: Load firmware from flash"
+		    " FAILED...\n");
+		return rval;
+	}
 
 	return rval;
 }
@@ -1763,20 +1765,9 @@ int qla4_8xxx_load_risc(struct scsi_qla_host *ha)
 	int retval;
 	retval = qla4_8xxx_device_state_handler(ha);
 
-	if (retval == QLA_SUCCESS &&
-	    !test_bit(AF_INIT_DONE, &ha->flags)) {
+	if (retval == QLA_SUCCESS && !test_bit(AF_INIT_DONE, &ha->flags))
 		retval = qla4xxx_request_irqs(ha);
-		if (retval != QLA_SUCCESS) {
-			ql4_printk(KERN_WARNING, ha,
-			    "Failed to reserve interrupt %d already in use.\n",
-			    ha->pdev->irq);
-		} else {
-			set_bit(AF_IRQ_ATTACHED, &ha->flags);
-			ha->host->irq = ha->pdev->irq;
-			ql4_printk(KERN_INFO, ha, "%s: irq %d attached\n",
-			    __func__, ha->pdev->irq);
-		}
-	}
+
 	return retval;
 }
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 370d40f..b24bf96 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -167,8 +167,6 @@ static void qla4xxx_recovery_timedout(struct iscsi_cls_session *session)
 			      "of (%d) secs exhausted, marking device DEAD.\n",
 			      ha->host_no, __func__, ddb_entry->fw_ddb_index,
 			      QL4_SESS_RECOVERY_TMO));
-
-		qla4xxx_wake_dpc(ha);
 	}
 }
 
@@ -1960,7 +1958,7 @@ static int qla4xxx_wait_for_hba_online(struct scsi_qla_host *ha)
 {
 	unsigned long wait_online;
 
-	wait_online = jiffies + (30 * HZ);
+	wait_online = jiffies + (HBA_ONLINE_TOV * HZ);
 	while (time_before(jiffies, wait_online)) {
 
 		if (adapter_up(ha))
-- 
1.6.6

