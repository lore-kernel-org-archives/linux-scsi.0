From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 6/8] qla4xxx: Handle outstanding mbx cmds on hung f/w
	scenarios
Date: Fri, 30 Jul 2010 14:28:07 +0530
Message-ID: <20100730085807.GA12323@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:21496
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1754432Ab0G3JBb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jul 2010 05:01:31 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: vikas.chaudhary@qlogic.com, ravi.anand@qlogic.com, michaelc@cs.wisc.edu, nilesh.javali@qlogic.com

From: Nilesh Javali <nilesh.javali@qlogic.com>

Outstanding mailbox commands, have no way to recover on f/w hung, and we
timeout on waiting for mbx response. This in turn affects the recovery process
as follows:
 - We might already be in dpc while waiting for mbx to complete, so recovery for
   that pci function will never get invoked. Reset Timeout (10 sec) is far less
   than mbx timeout (30 sec).
 - Other mbx cmds will get stuck due to serial mbx access.

Solution is to identify fw-hung scenario and handle outstanding mbx commands to
have an early-exit instead of waiting for response.
Other mbx commands waiting for access will also do an early-exit if fw-hung is
still applicable.

Signed-off-by: Nilesh Javali <nilesh.javali@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h  |    1 +
 drivers/scsi/qla4xxx/ql4_glbl.h |    1 +
 drivers/scsi/qla4xxx/ql4_mbx.c  |   39 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_nx.c   |    3 +++
 drivers/scsi/qla4xxx/ql4_os.c   |    3 +++
 5 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 6af5d04..6c92627 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -380,6 +380,7 @@ struct scsi_qla_host {
 #define AF_MSI_ENABLED			16 /* 0x00010000 */
 #define AF_MSIX_ENABLED			17 /* 0x00020000 */
 #define AF_MBOX_COMMAND_NOPOLL		18 /* 0x00040000 */
+#define AF_FW_RECOVERY			19 /* 0x00080000 */
 
 
 	unsigned long dpc_flags;
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index c9cd5d6..ea3db23 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -93,6 +93,7 @@ void qla4xxx_free_irqs(struct scsi_qla_host *ha);
 void qla4xxx_process_response_queue(struct scsi_qla_host *ha);
 void qla4xxx_wake_dpc(struct scsi_qla_host *ha);
 void qla4xxx_get_conn_event_log(struct scsi_qla_host *ha);
+void qla4xxx_mailbox_premature_completion(struct scsi_qla_host *ha);
 
 void qla4_8xxx_pci_config(struct scsi_qla_host *);
 int qla4_8xxx_iospace_config(struct scsi_qla_host *ha);
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index c4e036b..1003e48 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -39,6 +39,15 @@ int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
 			      "pointer\n", ha->host_no, __func__));
 		return status;
 	}
+
+	if (is_qla8022(ha) &&
+	    test_bit(AF_FW_RECOVERY, &ha->flags)) {
+		DEBUG2(ql4_printk(KERN_WARNING, ha, "scsi%ld: %s: prematurely "
+		    "completing mbx cmd as firmware recovery detected\n",
+		    ha->host_no, __func__));
+		return status;
+	}
+
 	/* Mailbox code active */
 	wait_count = MBOX_TOV * 100;
 
@@ -196,6 +205,14 @@ int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
 
 	/* Check for mailbox timeout. */
 	if (!test_bit(AF_MBOX_COMMAND_DONE, &ha->flags)) {
+		if (is_qla8022(ha) &&
+		    test_bit(AF_FW_RECOVERY, &ha->flags)) {
+			DEBUG2(ql4_printk(KERN_INFO, ha,
+			    "scsi%ld: %s: prematurely completing mbx cmd as "
+			    "firmware recovery detected\n",
+			    ha->host_no, __func__));
+			goto mbox_exit;
+		}
 		DEBUG2(printk("scsi%ld: Mailbox Cmd 0x%08X timed out ...,"
 			      " Scheduling Adapter Reset\n", ha->host_no,
 			      mbx_cmd[0]));
@@ -246,6 +263,28 @@ mbox_exit:
 	return status;
 }
 
+void qla4xxx_mailbox_premature_completion(struct scsi_qla_host *ha)
+{
+	set_bit(AF_FW_RECOVERY, &ha->flags);
+	ql4_printk(KERN_INFO, ha, "scsi%ld: %s: set FW RECOVERY!\n",
+	    ha->host_no, __func__);
+
+	if (test_bit(AF_MBOX_COMMAND, &ha->flags)) {
+		if (test_bit(AF_MBOX_COMMAND_NOPOLL, &ha->flags)) {
+			complete(&ha->mbx_intr_comp);
+			ql4_printk(KERN_INFO, ha, "scsi%ld: %s: Due to fw "
+			    "recovery, doing premature completion of "
+			    "mbx cmd\n", ha->host_no, __func__);
+
+		} else {
+			set_bit(AF_MBOX_COMMAND_DONE, &ha->flags);
+			ql4_printk(KERN_INFO, ha, "scsi%ld: %s: Due to fw "
+			    "recovery, doing premature completion of "
+			    "polling mbx cmd\n", ha->host_no, __func__);
+		}
+	}
+}
+
 static uint8_t
 qla4xxx_set_ifcb(struct scsi_qla_host *ha, uint32_t *mbox_cmd,
 		 uint32_t *mbox_sts, dma_addr_t init_fw_cb_dma)
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index ec46651..0830ea9 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -2105,6 +2105,9 @@ qla4_8xxx_isp_reset(struct scsi_qla_host *ha)
 	qla4_8xxx_clear_rst_ready(ha);
 	qla4_8xxx_idc_unlock(ha);
 
+	if (rval == QLA_SUCCESS)
+		clear_bit(AF_FW_RECOVERY, &ha->flags);
+
 	return rval;
 }
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index e575d76..2bb362c 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -663,6 +663,7 @@ static void qla4_8xxx_check_fw_alive(struct scsi_qla_host *ha)
 			ha->seconds_since_last_heartbeat = 0;
 			halt_status = qla4_8xxx_rd_32(ha,
 			    QLA82XX_PEG_HALT_STATUS1);
+
 			/* Since we cannot change dev_state in interrupt
 			 * context, set appropriate DPC flag then wakeup
 			 * DPC */
@@ -674,6 +675,7 @@ static void qla4_8xxx_check_fw_alive(struct scsi_qla_host *ha)
 				set_bit(DPC_RESET_HA, &ha->dpc_flags);
 			}
 			qla4xxx_wake_dpc(ha);
+			qla4xxx_mailbox_premature_completion(ha);
 		}
 	}
 	ha->fw_heartbeat_counter = fw_heartbeat_counter;
@@ -699,6 +701,7 @@ void qla4_8xxx_watchdog(struct scsi_qla_host *ha)
 			    ha->host_no, __func__);
 			set_bit(DPC_RESET_HA, &ha->dpc_flags);
 			qla4xxx_wake_dpc(ha);
+			qla4xxx_mailbox_premature_completion(ha);
 		} else if (dev_state == QLA82XX_DEV_NEED_QUIESCENT &&
 		    !test_bit(DPC_HA_NEED_QUIESCENT, &ha->dpc_flags)) {
 			printk("scsi%ld: %s: HW State: NEED QUIES!\n",
-- 
1.6.6

