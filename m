From: Ravi Anand <ravi.anand@qlogic.com>
Subject: [PATCH 03/12] qla4xxx: set device state as per Link UP and LINK
	DOWN
Date: Tue, 6 Apr 2010 03:13:55 -0700
Message-ID: <20100406101355.GJ22922@linux-qf4p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:27557 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab0DFKPe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2010 06:15:34 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Link Down -> Mark all devices missing
 Previously, the driver took no action on a Link Down,
 and waited for the I/O on a dead connection to timeout
 in the firmware before marking the DDB missing.

Link Up -> Mark all devices online
 F/W will do auto login to all the devices only once.
 After that its the responsibility of the driver to
 relogin to devices whenever there is :
        * Any sort of connection failure or
        * KATO expires indicating target has logged out or
        * I/O times out etc.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h  |    1 +
 drivers/scsi/qla4xxx/ql4_init.c |   12 +++++++--
 drivers/scsi/qla4xxx/ql4_isr.c  |   15 +++++++++---
 drivers/scsi/qla4xxx/ql4_os.c   |   46 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 67 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index bbd9352..45a6779 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -311,6 +311,7 @@ struct scsi_qla_host {
 #define DPC_ISNS_RESTART		7 /* 0x00000080 */
 #define DPC_AEN				9 /* 0x00000200 */
 #define DPC_GET_DHCP_IP_ADDR		15 /* 0x00008000 */
+#define DPC_LINK_CHANGED		18 /* 0x00040000 */
 
 	struct Scsi_Host *host; /* pointer to host data */
 	uint32_t tot_ddbs;
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 6da6f51..2c14235 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -1279,6 +1279,7 @@ int qla4xxx_initialize_adapter(struct scsi_qla_host *ha,
 	int status = QLA_ERROR;
 	int8_t ip_address[IP_ADDR_LEN] = {0} ;
 
+	clear_bit(AF_ONLINE, &ha->flags);
 	ha->eeprom_cmd_data = 0;
 
 	qla4x00_pci_config(ha);
@@ -1456,10 +1457,15 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha,
 		 * the device came back.
 		 */
 	} else {
-		/* Device went away, try to relogin. */
-		/* Mark device missing */
-		if (atomic_read(&ddb_entry->state) == DDB_STATE_ONLINE)
+		/* Device went away, mark device missing */
+		if (atomic_read(&ddb_entry->state) == DDB_STATE_ONLINE) {
+			DEBUG2(dev_info(&ha->pdev->dev, "%s mark missing "
+					"ddb_entry 0x%p sess 0x%p conn 0x%p\n",
+					__func__, ddb_entry,
+					ddb_entry->sess, ddb_entry->conn));
 			qla4xxx_mark_device_missing(ha, ddb_entry);
+		}
+
 		/*
 		 * Relogin if device state changed to a not active state.
 		 * However, do not relogin if this aen is a result of an IOCTL
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index c196d55..9db286d 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -498,15 +498,22 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 			break;
 
 		case MBOX_ASTS_LINK_UP:
-			DEBUG2(printk("scsi%ld: AEN %04x Adapter LINK UP\n",
-				      ha->host_no, mbox_status));
 			set_bit(AF_LINK_UP, &ha->flags);
+			if (test_bit(AF_INIT_DONE, &ha->flags))
+				set_bit(DPC_LINK_CHANGED, &ha->dpc_flags);
+
+			DEBUG2(printk(KERN_INFO "scsi%ld: AEN %04x Adapter"
+					" LINK UP\n", ha->host_no,
+					mbox_status));
 			break;
 
 		case MBOX_ASTS_LINK_DOWN:
-			DEBUG2(printk("scsi%ld: AEN %04x Adapter LINK DOWN\n",
-				      ha->host_no, mbox_status));
 			clear_bit(AF_LINK_UP, &ha->flags);
+			set_bit(DPC_LINK_CHANGED, &ha->dpc_flags);
+
+			DEBUG2(printk(KERN_INFO "scsi%ld: AEN %04x Adapter"
+					" LINK DOWN\n", ha->host_no,
+					mbox_status));
 			break;
 
 		case MBOX_ASTS_HEARTBEAT:
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 83c8b5e..9ff4cae 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -684,6 +684,7 @@ static void qla4xxx_timer(struct scsi_qla_host *ha)
 	     test_bit(DPC_RESET_HA_DESTROY_DDB_LIST, &ha->dpc_flags) ||
 	     test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags) ||
 	     test_bit(DPC_GET_DHCP_IP_ADDR, &ha->dpc_flags) ||
+	     test_bit(DPC_LINK_CHANGED, &ha->dpc_flags) ||
 	     test_bit(DPC_AEN, &ha->dpc_flags)) &&
 	     ha->dpc_thread) {
 		DEBUG2(printk("scsi%ld: %s: scheduling dpc routine"
@@ -1091,6 +1092,51 @@ static void qla4xxx_do_dpc(struct work_struct *work)
 			}
 		}
 	}
+
+	if (test_and_clear_bit(DPC_LINK_CHANGED, &ha->dpc_flags)) {
+		if (!test_bit(AF_LINK_UP, &ha->flags)) {
+			/* ---- link down? --- */
+			list_for_each_entry_safe(ddb_entry, dtemp,
+						 &ha->ddb_list, list) {
+				if (atomic_read(&ddb_entry->state) ==
+						DDB_STATE_ONLINE)
+					qla4xxx_mark_device_missing(ha,
+							ddb_entry);
+			}
+		} else {
+			/* ---- link up? --- *
+			 * F/W will auto login to all devices ONLY ONCE after
+			 * link up during driver initialization and runtime
+			 * fatal error recovery.  Therefore, the driver must
+			 * manually relogin to devices when recovering from
+			 * connection failures, logouts, expired KATO, etc. */
+
+			list_for_each_entry_safe(ddb_entry, dtemp,
+							&ha->ddb_list, list) {
+				if ((atomic_read(&ddb_entry->state) ==
+						 DDB_STATE_MISSING) ||
+				    (atomic_read(&ddb_entry->state) ==
+						 DDB_STATE_DEAD)) {
+					if (ddb_entry->fw_ddb_device_state ==
+					    DDB_DS_SESSION_ACTIVE) {
+						atomic_set(&ddb_entry->state,
+							   DDB_STATE_ONLINE);
+						dev_info(&ha->pdev->dev,
+							 "scsi%ld: %s: ddb[%d]"
+							 " os[%d] marked"
+							 " ONLINE\n",
+							 ha->host_no, __func__,
+							 ddb_entry->fw_ddb_index,
+							 ddb_entry->os_target_id);
+
+						iscsi_unblock_session(ddb_entry->sess);
+					} else
+						qla4xxx_relogin_device(ha, ddb_entry);
+				}
+
+			}
+		}
+	}
 }
 
 /**
-- 
1.6.0.2

----- End forwarded message -----
