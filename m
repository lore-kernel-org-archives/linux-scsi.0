From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: [PATCH 4/8] qla4xxx: Resubmission: ql4_init.c bugfixes
Date: Wed, 23 May 2007 17:55:40 -0700
Message-ID: <1179968140.16099.9.camel@iscsi-sles10>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:4890 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160AbXEXA4m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2007 20:56:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, David Somayajulu <david.somayajulu@qlogic.com>, David Wagner <david.wagner@qlogic.com>

In qla4xxx_get_ddb_entry() and qla4xxx_add_device_dynamically() differentiate between a target which has been newly added vs a target which went offline temporarily and is online again.  In qla4xxx_build_ddb_list() firmware ddb state needs to be updated by calling qla4xxx_get_ddb_entry(). Fix qla4x00_pci_config() and clean up code.

Signed-off-by: David Somayajulu <david.somayajulu@qlogic.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

 drivers/scsi/qla4xxx/ql4_init.c |   92 +++++++++++++++++++++++++++------------
 1 files changed, 63 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 6365df2..b76ba54 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -6,6 +6,9 @@
  */
 
 #include "ql4_def.h"
+#include "ql4_glbl.h"
+#include "ql4_dbg.h"
+#include "ql4_inline.h"
 
 static struct ddb_entry * qla4xxx_alloc_ddb(struct scsi_qla_host *ha,
 					    uint32_t fw_ddb_index);
@@ -300,12 +303,12 @@ static int qla4xxx_init_firmware(struct 
 	if (!qla4xxx_fw_ready(ha))
 		return status;
 
-	set_bit(AF_ONLINE, &ha->flags);
 	return qla4xxx_get_firmware_status(ha);
 }
 
 static struct ddb_entry* qla4xxx_get_ddb_entry(struct scsi_qla_host *ha,
-					       uint32_t fw_ddb_index)
+						uint32_t fw_ddb_index,
+						uint32_t *new_tgt)
 {
 	struct dev_db_entry *fw_ddb_entry = NULL;
 	dma_addr_t fw_ddb_entry_dma;
@@ -313,6 +316,7 @@ static struct ddb_entry* qla4xxx_get_ddb
 	int found = 0;
 	uint32_t device_state;
 
+	*new_tgt = 0;
 	/* Make sure the dma buffer is valid */
 	fw_ddb_entry = dma_alloc_coherent(&ha->pdev->dev,
 					  sizeof(*fw_ddb_entry),
@@ -337,7 +341,7 @@ static struct ddb_entry* qla4xxx_get_ddb
 	DEBUG2(printk("scsi%ld: %s: Looking for ddb[%d]\n", ha->host_no,
 		      __func__, fw_ddb_index));
 	list_for_each_entry(ddb_entry, &ha->ddb_list, list) {
-		if (memcmp(ddb_entry->iscsi_name, fw_ddb_entry->iscsiName,
+		if (memcmp(ddb_entry->iscsi_name, fw_ddb_entry->iscsi_name,
 			   ISCSI_NAME_SIZE) == 0) {
 			found++;
 			break;
@@ -348,6 +352,7 @@ static struct ddb_entry* qla4xxx_get_ddb
 		DEBUG2(printk("scsi%ld: %s: ddb[%d] not found - allocating "
 			      "new ddb\n", ha->host_no, __func__,
 			      fw_ddb_index));
+		*new_tgt = 1;
 		ddb_entry = qla4xxx_alloc_ddb(ha, fw_ddb_index);
 	}
 
@@ -409,26 +414,26 @@ static int qla4xxx_update_ddb_entry(stru
 	}
 
 	status = QLA_SUCCESS;
-	ddb_entry->target_session_id = le16_to_cpu(fw_ddb_entry->TSID);
+	ddb_entry->target_session_id = le16_to_cpu(fw_ddb_entry->tsid);
 	ddb_entry->task_mgmt_timeout =
-		le16_to_cpu(fw_ddb_entry->taskMngmntTimeout);
+		le16_to_cpu(fw_ddb_entry->def_timeout);
 	ddb_entry->CmdSn = 0;
-	ddb_entry->exe_throttle = le16_to_cpu(fw_ddb_entry->exeThrottle);
+	ddb_entry->exe_throttle = le16_to_cpu(fw_ddb_entry->exec_throttle);
 	ddb_entry->default_relogin_timeout =
-		le16_to_cpu(fw_ddb_entry->taskMngmntTimeout);
-	ddb_entry->default_time2wait = le16_to_cpu(fw_ddb_entry->minTime2Wait);
+		le16_to_cpu(fw_ddb_entry->def_timeout);
+	ddb_entry->default_time2wait = le16_to_cpu(fw_ddb_entry->iscsi_def_time2wait);
 
 	/* Update index in case it changed */
 	ddb_entry->fw_ddb_index = fw_ddb_index;
 	ha->fw_ddb_index_map[fw_ddb_index] = ddb_entry;
 
-	ddb_entry->port = le16_to_cpu(fw_ddb_entry->portNumber);
-	ddb_entry->tpgt = le32_to_cpu(fw_ddb_entry->TargetPortalGroup);
-	memcpy(&ddb_entry->iscsi_name[0], &fw_ddb_entry->iscsiName[0],
+	ddb_entry->port = le16_to_cpu(fw_ddb_entry->port);
+	ddb_entry->tpgt = le32_to_cpu(fw_ddb_entry->tgt_portal_grp);
+	memcpy(&ddb_entry->iscsi_name[0], &fw_ddb_entry->iscsi_name[0],
 	       min(sizeof(ddb_entry->iscsi_name),
-		   sizeof(fw_ddb_entry->iscsiName)));
-	memcpy(&ddb_entry->ip_addr[0], &fw_ddb_entry->ipAddr[0],
-	       min(sizeof(ddb_entry->ip_addr), sizeof(fw_ddb_entry->ipAddr)));
+		   sizeof(fw_ddb_entry->iscsi_name)));
+	memcpy(&ddb_entry->ip_addr[0], &fw_ddb_entry->ip_addr[0],
+	       min(sizeof(ddb_entry->ip_addr), sizeof(fw_ddb_entry->ip_addr)));
 
 	DEBUG2(printk("scsi%ld: %s: ddb[%d] - State= %x status= %d.\n",
 		      ha->host_no, __func__, fw_ddb_index,
@@ -495,6 +500,7 @@ static int qla4xxx_build_ddb_list(struct
 	uint32_t ddb_state;
 	uint32_t conn_err, err_code;
 	struct ddb_entry *ddb_entry;
+	uint32_t new_tgt;
 
 	dev_info(&ha->pdev->dev, "Initializing DDBs ...\n");
 	for (fw_ddb_index = 0; fw_ddb_index < MAX_DDB_ENTRIES;
@@ -526,8 +532,19 @@ static int qla4xxx_build_ddb_list(struct
 					      "completed "
 					      "or access denied failure\n",
 					      ha->host_no, __func__));
-			} else
+			} else {
 				qla4xxx_set_ddb_entry(ha, fw_ddb_index, 0);
+				if (qla4xxx_get_fwddb_entry(ha, fw_ddb_index,
+					NULL, 0, NULL, &next_fw_ddb_index,
+					&ddb_state, &conn_err, NULL, NULL)
+					== QLA_ERROR) {
+					DEBUG2(printk("scsi%ld: %s:"
+						"get_ddb_entry %d failed\n",
+						ha->host_no,
+						__func__, fw_ddb_index));
+					return QLA_ERROR;
+				}
+			}
 		}
 
 		if (ddb_state != DDB_DS_SESSION_ACTIVE)
@@ -540,7 +557,7 @@ static int qla4xxx_build_ddb_list(struct
 			      ha->host_no, __func__, fw_ddb_index));
 
 		/* Add DDB to internal our ddb list. */
-		ddb_entry = qla4xxx_get_ddb_entry(ha, fw_ddb_index);
+		ddb_entry = qla4xxx_get_ddb_entry(ha, fw_ddb_index, &new_tgt);
 		if (ddb_entry == NULL) {
 			DEBUG2(printk("scsi%ld: %s: Unable to allocate memory "
 				      "for device at fw_ddb_index %d\n",
@@ -865,21 +882,19 @@ static int qla4xxx_config_nvram(struct s
 
 static void qla4x00_pci_config(struct scsi_qla_host *ha)
 {
-	uint16_t w, mwi;
+	uint16_t w;
 
 	dev_info(&ha->pdev->dev, "Configuring PCI space...\n");
 
 	pci_set_master(ha->pdev);
-	mwi = 0;
-	if (pci_set_mwi(ha->pdev))
-		mwi = PCI_COMMAND_INVALIDATE;
+	pci_set_mwi(ha->pdev);
 	/*
 	 * We want to respect framework's setting of PCI configuration space
 	 * command register and also want to make sure that all bits of
 	 * interest to us are properly set in command register.
 	 */
 	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
-	w |= mwi | (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
+	w |= PCI_COMMAND_PARITY | PCI_COMMAND_SERR;
 	w &= ~PCI_COMMAND_INTX_DISABLE;
 	pci_write_config_word(ha->pdev, PCI_COMMAND, w);
 }
@@ -911,6 +926,9 @@ static int qla4xxx_start_firmware_from_f
 		writel(set_rmask(NVR_WRITE_ENABLE),
 		       &ha->reg->u1.isp4022.nvram);
 
+        writel(2, &ha->reg->mailbox[6]);
+        readl(&ha->reg->mailbox[6]);
+
 	writel(set_rmask(CSR_BOOT_ENABLE), &ha->reg->ctrl_status);
 	readl(&ha->reg->ctrl_status);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -958,25 +976,25 @@ static int qla4xxx_start_firmware_from_f
 	return status;
 }
 
-int ql4xxx_lock_drvr_wait(struct scsi_qla_host *ha)
+int ql4xxx_lock_drvr_wait(struct scsi_qla_host *a)
 {
-#define QL4_LOCK_DRVR_WAIT	30
+#define QL4_LOCK_DRVR_WAIT	60
 #define QL4_LOCK_DRVR_SLEEP	1
 
 	int drvr_wait = QL4_LOCK_DRVR_WAIT;
 	while (drvr_wait) {
-		if (ql4xxx_lock_drvr(ha) == 0) {
+		if (ql4xxx_lock_drvr(a) == 0) {
 			ssleep(QL4_LOCK_DRVR_SLEEP);
 			if (drvr_wait) {
 				DEBUG2(printk("scsi%ld: %s: Waiting for "
-					      "Global Init Semaphore(%d)...n",
-					      ha->host_no,
+					      "Global Init Semaphore(%d)...\n",
+					      a->host_no,
 					      __func__, drvr_wait));
 			}
 			drvr_wait -= QL4_LOCK_DRVR_SLEEP;
 		} else {
 			DEBUG2(printk("scsi%ld: %s: Global Init Semaphore "
-				      "acquired.n", ha->host_no, __func__));
+				      "acquired\n", a->host_no, __func__));
 			return QLA_SUCCESS;
 		}
 	}
@@ -1142,8 +1160,10 @@ int qla4xxx_initialize_adapter(struct sc
 	 * the ddb_list and wait for DHCP lease acquired aen to come in
 	 * followed by 0x8014 aen" to trigger the tgt discovery process.
 	 */
-	if (ha->firmware_state & FW_STATE_DHCP_IN_PROGRESS)
+	if (ha->firmware_state & FW_STATE_DHCP_IN_PROGRESS){
+		set_bit(AF_ONLINE, &ha->flags);
 		return status;
+	}
 
 	/* Skip device discovery if ip and subnet is zero */
 	if (memcmp(ha->ip_address, ip_address, IP_ADDR_LEN) == 0 ||
@@ -1177,6 +1197,7 @@ int qla4xxx_initialize_adapter(struct sc
 			      ha->host_no));
 	}
 
+	set_bit(AF_ONLINE, &ha->flags);
  exit_init_hba:
 	return status;
 
@@ -1193,9 +1214,10 @@ static void qla4xxx_add_device_dynamical
 					   uint32_t fw_ddb_index)
 {
 	struct ddb_entry * ddb_entry;
+	uint32_t new_tgt;
 
 	/* First allocate a device structure */
-	ddb_entry = qla4xxx_get_ddb_entry(ha, fw_ddb_index);
+	ddb_entry = qla4xxx_get_ddb_entry(ha, fw_ddb_index, &new_tgt);
 	if (ddb_entry == NULL) {
 		DEBUG2(printk(KERN_WARNING
 			      "scsi%ld: Unable to allocate memory to add "
@@ -1203,6 +1225,18 @@ static void qla4xxx_add_device_dynamical
 		return;
 	}
 
+	if (!new_tgt && (ddb_entry->fw_ddb_index != fw_ddb_index)) {
+		/* Target has been bound to a new fw_ddb_index */
+		qla4xxx_free_ddb(ha, ddb_entry);
+		ddb_entry = qla4xxx_alloc_ddb(ha, fw_ddb_index);
+		if (ddb_entry == NULL) {
+			DEBUG2(printk(KERN_WARNING
+		      		"scsi%ld: Unable to allocate memory"
+		      		" to add fw_ddb_index %d\n",
+				ha->host_no, fw_ddb_index));
+			return;
+		}
+	}
 	if (qla4xxx_update_ddb_entry(ha, ddb_entry, fw_ddb_index) ==
 				    QLA_ERROR) {
 		ha->fw_ddb_index_map[fw_ddb_index] =

