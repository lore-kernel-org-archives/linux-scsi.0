From: ravi.anand@qlogic.com
Subject: [PATCH 09/11] Drop Unused Code
Date: Tue, 7 Mar 2006 16:35:58 -0800
Message-ID: <1141778153256-git-send-email-ravi.anand@qlogic.com>
References: <11417781172980-git-send-email-ravi.anand@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:49906 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S964859AbWCHAgB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2006 19:36:01 -0500
In-Reply-To: <11417781172980-git-send-email-ravi.anand@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, arjan@infradead.org
Cc: ravi.anand@qlogic.com

Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>


---

 drivers/scsi/qla4xxx/ql4_mbx.c      |   53 -------------------
 drivers/scsi/qla4xxx/ql4_os.c       |   98 +++++++++++++++--------------------
 drivers/scsi/qla4xxx/ql4_settings.h |    1 
 3 files changed, 42 insertions(+), 110 deletions(-)

729bb4a63a6272bda7a7bebace86a54aa6c68372
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 094d16b..3b81468 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -177,59 +177,6 @@ mbox_exit:
 	return status;
 }
 
-#if 0
-int qla4xxx_send_noop(scsi_qla_host_t * ha)
-{
-	uint32_t mbox_cmd[MBOX_REG_COUNT];
-	uint32_t mbox_sts[MBOX_REG_COUNT];
-	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
-	memset(&mbox_sts, 0, sizeof(mbox_sts));
-	mbox_cmd[0] = MBOX_CMD_NOP;
-	if (qla4xxx_mailbox_command(ha, 1, 1, &mbox_cmd[0], &mbox_sts[0])
-	    != QLA_SUCCESS) {
-		DEBUG2( printk(KERN_INFO "scsi%d: NOP failed\n", ha->host_no));
-		return (QLA_ERROR);
-	}
-
-	else {
-		return (QLA_SUCCESS);
-	}
-}
-
-int qla4xxx_mbx_test(scsi_qla_host_t * ha)
-{
-	uint32_t mbox_cmd[MBOX_REG_COUNT];
-	uint32_t mbox_sts[MBOX_REG_COUNT];
-	int i;
-	int status;
-	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
-	memset(&mbox_sts, 0, sizeof(mbox_sts));
-	mbox_cmd[0] = MBOX_CMD_REGISTER_TEST;
-	mbox_cmd[1] = 0x11111111;
-	mbox_cmd[2] = 0x22222222;
-	mbox_cmd[3] = 0x33333333;
-	mbox_cmd[4] = 0x44444444;
-	mbox_cmd[5] = 0x55555555;
-	mbox_cmd[6] = 0x66666666;
-	mbox_cmd[7] = 0x77777777;
-	if (qla4xxx_mailbox_command(ha, 8, 8, &mbox_cmd[0], &mbox_sts[0])
-	    != QLA_SUCCESS) {
-		return (QLA_ERROR);
-	}
-	if (mbox_sts[1] != 0x11111111 || mbox_sts[2] != 0x22222222
-	    || mbox_sts[3] != 0x33333333 || mbox_sts[4] != 0x44444444
-	    || mbox_sts[5] != 0x55555555 || mbox_sts[6] != 0x66666666
-	    || mbox_sts[7] != 0x77777777) {
-		status = QLA_ERROR;
-	}
-
-	else {
-		status = QLA_SUCCESS;
-	}
-	return (status);
-}
-
-#endif				/*  */
 
 /*
  * qla4xxx_issue_iocb
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 746814f..0e87a0f 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -945,18 +945,6 @@ qla4xxx_timer(scsi_qla_host_t *ha)
 	DEBUG2(ha->seconds_since_last_intr++;)
 }
 
-int
-qla4xxx_check_for_disable_hba_reset(scsi_qla_host_t * ha)
-{
-#if DISABLE_HBA_RESETS
-	clear_bit(DPC_RESET_HA, &ha->dpc_flags);
-	clear_bit(DPC_RESET_HA_INTR, &ha->dpc_flags);
-	clear_bit(DPC_RESET_HA_DESTROY_DDB_LIST, &ha->dpc_flags);
-	return 0;
-#else
-	return 1;
-#endif
-}
 
 /**************************************************************************
  * qla4xxx_do_dpc
@@ -1008,55 +996,53 @@ static int qla4xxx_do_dpc(void *data)
 		    test_bit(DPC_RESET_HA, &ha->dpc_flags) ||
 		    test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags) ||
 		    test_bit(DPC_RESET_HA_DESTROY_DDB_LIST, &ha->dpc_flags)) {
-			if (qla4xxx_check_for_disable_hba_reset(ha)) {
-				if (test_bit(DPC_RESET_HA_DESTROY_DDB_LIST,
-				    &ha->dpc_flags))
-					/*
-					 * dg 09/23 Never initialize ddb list
-					 * once we up and running
-					 * qla4xxx_recover_adapter(ha,
-					 *    REBUILD_DDB_LIST);
-					 */
-					qla4xxx_recover_adapter(ha,
-					    PRESERVE_DDB_LIST);
+			if (test_bit(DPC_RESET_HA_DESTROY_DDB_LIST,
+			    &ha->dpc_flags))
+				/*
+				 * dg 09/23 Never initialize ddb list
+				 * once we up and running
+				 * qla4xxx_recover_adapter(ha,
+				 *    REBUILD_DDB_LIST);
+				 */
+				qla4xxx_recover_adapter(ha,
+				    PRESERVE_DDB_LIST);
+
+			if (test_bit(DPC_RESET_HA, &ha->dpc_flags))
+				qla4xxx_recover_adapter(ha,
+				    PRESERVE_DDB_LIST);
+
+			if (test_and_clear_bit(DPC_RESET_HA_INTR,
+			    &ha->dpc_flags)) {
+				uint8_t wait_time = RESET_INTR_TOV;
+				unsigned long flags = 0;
+
+				qla4xxx_flush_active_srbs(ha);
+
+				spin_lock_irqsave(&ha->hardware_lock,
+				    flags);
+				while ((RD_REG_DWORD(
+					&ha->reg->ctrl_status) &
+					(CSR_SOFT_RESET|
+					 CSR_FORCE_SOFT_RESET)) != 0) {
+					if (--wait_time == 0)
+						break;
 
-				if (test_bit(DPC_RESET_HA, &ha->dpc_flags))
-					qla4xxx_recover_adapter(ha,
-					    PRESERVE_DDB_LIST);
-
-				if (test_and_clear_bit(DPC_RESET_HA_INTR,
-				    &ha->dpc_flags)) {
-					uint8_t wait_time = RESET_INTR_TOV;
-					unsigned long flags = 0;
-
-					qla4xxx_flush_active_srbs(ha);
-
-					spin_lock_irqsave(&ha->hardware_lock,
-					    flags);
-					while ((RD_REG_DWORD(
-						&ha->reg->ctrl_status) &
-                                                (CSR_SOFT_RESET|
-						 CSR_FORCE_SOFT_RESET)) != 0) {
-						if (--wait_time == 0)
-							break;
-
-						spin_unlock_irqrestore(
-						    &ha->hardware_lock, flags);
-
-						msleep(1000);
-
-						spin_lock_irqsave(
-						    &ha->hardware_lock, flags);
-					}
 					spin_unlock_irqrestore(
 					    &ha->hardware_lock, flags);
 
-					if (wait_time == 0)
-						DEBUG2(printk(
-						    "scsi%ld: %s: SR|FSR bit "
-						    "not cleared-- resetting\n",
-						    ha->host_no, __func__));
+					msleep(1000);
+
+					spin_lock_irqsave(
+					    &ha->hardware_lock, flags);
 				}
+				spin_unlock_irqrestore(
+				    &ha->hardware_lock, flags);
+
+				if (wait_time == 0)
+					DEBUG2(printk(
+					    "scsi%ld: %s: SR|FSR bit "
+					    "not cleared-- resetting\n",
+					    ha->host_no, __func__));
 			}
 		}
 
diff --git a/drivers/scsi/qla4xxx/ql4_settings.h b/drivers/scsi/qla4xxx/ql4_settings.h
index ff64aba..94a51db 100644
--- a/drivers/scsi/qla4xxx/ql4_settings.h
+++ b/drivers/scsi/qla4xxx/ql4_settings.h
@@ -9,4 +9,3 @@
  * Compile time Options:
  *     0 - Disable and 1 - Enable
  */
-#define	DISABLE_HBA_RESETS	0
-- 
1.2.4.g9201-dirty


