From: Ravi Anand <ravi.anand@qlogic.com>
Subject: [PATCH 03/11] qla4xxx: Link Down -> Mark all devices missing
Date: Fri, 29 Jan 2010 22:28:31 -0800
Message-ID: <20100130062831.GD10274@linux-qf4p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:8995 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab0A3G0l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Jan 2010 01:26:41 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@suse.de>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

This change will cut 20 seconds of failover times.
Previously, the driver took no action on a Link Down,
and waited for the I/O on a dead connection to timeout
in the firmware before marking the DDB missing.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h  |    1 +
 drivers/scsi/qla4xxx/ql4_init.c |   12 +++++++++---
 drivers/scsi/qla4xxx/ql4_isr.c  |   13 +++++++++----
 drivers/scsi/qla4xxx/ql4_os.c   |   11 +++++++++++
 4 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 9c37989..2923e8e 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -321,6 +321,7 @@ struct scsi_qla_host {
 #define DPC_ISNS_RESTART		7 /* 0x00000080 */
 #define DPC_AEN				9 /* 0x00000200 */
 #define DPC_GET_DHCP_IP_ADDR		15 /* 0x00008000 */
+#define DPC_LINK_CHANGED		18 /* 0x00040000 */
 
 	struct Scsi_Host *host; /* pointer to host data */
 	uint32_t tot_ddbs;
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index cad9d45..aafd1b5 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -1273,6 +1273,7 @@ int qla4xxx_initialize_adapter(struct scsi_qla_host *ha,
 	int status = QLA_ERROR;
 	int8_t ip_address[IP_ADDR_LEN] = {0} ;
 
+	clear_bit(AF_ONLINE, &ha->flags);
 	ha->eeprom_cmd_data = 0;
 
 	qla4x00_pci_config(ha);
@@ -1450,10 +1451,15 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha,
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
index c196d55..36e6e85 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -498,15 +498,20 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 			break;
 
 		case MBOX_ASTS_LINK_UP:
-			DEBUG2(printk("scsi%ld: AEN %04x Adapter LINK UP\n",
-				      ha->host_no, mbox_status));
 			set_bit(AF_LINK_UP, &ha->flags);
+			if (test_bit(AF_INIT_DONE, &ha->flags))
+				set_bit(DPC_LINK_CHANGED, &ha->dpc_flags);
+
+			DEBUG2(printk("scsi%ld: AEN %04x Adapter LINK UP\n",
+					ha->host_no, mbox_status));
 			break;
 
 		case MBOX_ASTS_LINK_DOWN:
-			DEBUG2(printk("scsi%ld: AEN %04x Adapter LINK DOWN\n",
-				      ha->host_no, mbox_status));
 			clear_bit(AF_LINK_UP, &ha->flags);
+			set_bit(DPC_LINK_CHANGED, &ha->dpc_flags);
+
+			DEBUG2(printk("scsi%ld: AEN %04x Adapter LINK DOWN\n",
+                                      ha->host_no, mbox_status));
 			break;
 
 		case MBOX_ASTS_HEARTBEAT:
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 83c8b5e..97d35fd 100644
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
@@ -1091,6 +1092,16 @@ static void qla4xxx_do_dpc(struct work_struct *work)
 			}
 		}
 	}
+
+	if (test_and_clear_bit(DPC_LINK_CHANGED, &ha->dpc_flags)) {
+		if (!test_bit(AF_LINK_UP, &ha->flags)) {
+		/* ---- link down? --- */
+			list_for_each_entry_safe(ddb_entry, dtemp, &ha->ddb_list, list) {
+			if (atomic_read(&ddb_entry->state) == DDB_STATE_ONLINE)
+				qla4xxx_mark_device_missing(ha, ddb_entry);
+			}
+		}
+	}
 }
 
 /**
-- 
1.6.0.2

