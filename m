From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/8]  qla4xxx: initialization routines
Date: Tue,  6 Sep 2005 15:09:01 -0700 (PDT)
Message-ID: <20050906220901.11409.44281.sendpatchset@plap.qlogic.com>
References: <20050906220841.11409.88669.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:1180 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751009AbVIFWJC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2005 18:09:02 -0400
In-Reply-To: <20050906220841.11409.88669.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

ISP4xxx driver initialization routines.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla4xxx/ql4_init.c | 1753 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_iocb.c |  595 +++++++++++++
 2 files changed, 2348 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/qla4xxx/ql4_init.c
 create mode 100644 drivers/scsi/qla4xxx/ql4_iocb.c

6755c3b78809194fe31f551b3862639ae513b9a9
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
new file mode 100644
--- /dev/null
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -0,0 +1,1753 @@
+/*
+ * Copyright (c)  2003-2005 QLogic Corporation
+ * QLogic Linux iSCSI Driver
+ *
+ * This program includes a device driver for Linux 2.6 that may be
+ * distributed with QLogic hardware specific firmware binary file.
+ * You may modify and redistribute the device driver code under the
+ * GNU General Public License as published by the Free Software
+ * Foundation (version 2 or a later version) and/or under the
+ * following terms, as applicable:
+ *
+ * 	1. Redistribution of source code must retain the above
+ * 	   copyright notice, this list of conditions and the
+ * 	   following disclaimer.
+ *
+ * 	2. Redistribution in binary form must reproduce the above
+ * 	   copyright notice, this list of conditions and the
+ * 	   following disclaimer in the documentation and/or other
+ * 	   materials provided with the distribution.
+ *
+ * 	3. The name of QLogic Corporation may not be used to
+ * 	   endorse or promote products derived from this software
+ * 	   without specific prior written permission.
+ *
+ * You may redistribute the hardware specific firmware binary file
+ * under the following terms:
+ *
+ * 	1. Redistribution of source code (only if applicable),
+ * 	   must retain the above copyright notice, this list of
+ * 	   conditions and the following disclaimer.
+ *
+ * 	2. Redistribution in binary form must reproduce the above
+ * 	   copyright notice, this list of conditions and the
+ * 	   following disclaimer in the documentation and/or other
+ * 	   materials provided with the distribution.
+ *
+ * 	3. The name of QLogic Corporation may not be used to
+ * 	   endorse or promote products derived from this software
+ * 	   without specific prior written permission
+ *
+ * REGARDLESS OF WHAT LICENSING MECHANISM IS USED OR APPLICABLE,
+ * THIS PROGRAM IS PROVIDED BY QLOGIC CORPORATION "AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
+ * PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR
+ * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
+ * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
+ * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
+ * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGE.
+ *
+ * USER ACKNOWLEDGES AND AGREES THAT USE OF THIS PROGRAM WILL NOT
+ * CREATE OR GIVE GROUNDS FOR A LICENSE BY IMPLICATION, ESTOPPEL, OR
+ * OTHERWISE IN ANY INTELLECTUAL PROPERTY RIGHTS (PATENT, COPYRIGHT,
+ * TRADE SECRET, MASK WORK, OR OTHER PROPRIETARY RIGHT) EMBODIED IN
+ * ANY OTHER QLOGIC HARDWARE OR SOFTWARE EITHER SOLELY OR IN
+ * COMBINATION WITH THIS PROGRAM.
+ */
+
+#include "ql4_def.h"
+
+#include <linux/delay.h>
+
+/*
+*  QLogic ISP4xxx Hardware Support Function Prototypes.
+ */
+extern int ql4xdiscoverywait;
+
+/*
+ * Local routines
+ */
+static int qla4xxx_start_firmware(scsi_qla_host_t * ha);
+static int qla4xxx_config_nvram(scsi_qla_host_t * ha);
+
+static void
+ql4xxx_set_mac_number(scsi_qla_host_t * ha)
+{
+	uint32_t value;
+	uint8_t func_number;
+	unsigned long flags;
+
+	/* Get the function number */
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	value = RD_REG_DWORD(&ha->reg->ctrl_status);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	func_number = (uint8_t) ((value >> 4) & 0x30);
+	switch (value & ISP_CONTROL_FN_MASK) {
+	case ISP_CONTROL_FN0_SCSI:
+		ha->mac_index = 1;
+		break;
+	case ISP_CONTROL_FN1_SCSI:
+		ha->mac_index = 3;
+		break;
+	default:
+		DEBUG2(printk("scsi%ld: %s: Invalid function number, "
+		    "ispControlStatus = 0x%x\n", ha->host_no, __func__, value));
+		break;
+	}
+	DEBUG2(printk("scsi%ld: %s: mac_index %d.\n", ha->host_no, __func__,
+	    ha->mac_index));
+}
+
+/**************************************************************************
+ * qla4xxx_free_ddb
+ *	This routine deallocates and unlinks the specified ddb_entry from the
+ *	adapter's
+ *
+ * Input:
+ * 	ha - Pointer to host adapter structure.
+ *	ddb_entry - Pointer to device database entry
+ *
+ * Returns:
+ *	None
+ *
+ * Context:
+ *	Kernel context.
+ **************************************************************************/
+void
+qla4xxx_free_ddb(scsi_qla_host_t * ha, struct ddb_entry *ddb_entry)
+{
+	/* Remove device entry from list */
+	list_del_init(&ddb_entry->list);
+
+	/* Remove device pointer from index mapping arrays */
+	ha->fw_ddb_index_map[ddb_entry->fw_ddb_index] =
+	    (ddb_entry_t *) INVALID_ENTRY;
+	ha->tot_ddbs--;
+
+	/* Free memory for device entry */
+	kfree(ddb_entry);
+}
+
+/**************************************************************************
+ * qla4xxx_free_ddb_list
+ *	This routine deallocates and removes all devices on the sppecified
+ *	adapter.
+ *
+ * Input:
+ * 	ha - Pointer to host adapter structure.
+ *
+ * Returns:
+ *	None
+ *
+ * Context:
+ *	Kernel context.
+ **************************************************************************/
+void
+qla4xxx_free_ddb_list(scsi_qla_host_t * ha)
+{
+	struct list_head *ptr;
+	struct ddb_entry *ddb_entry;
+
+	while (!list_empty(&ha->ddb_list)) {
+		/* Remove device entry from head of list */
+		ptr = ha->ddb_list.next;
+		list_del_init(ptr);
+
+		/* Free memory for device entry */
+		ddb_entry = list_entry(ptr, struct ddb_entry, list);
+		qla4xxx_free_ddb(ha, ddb_entry);
+	}
+}
+
+/*
+ * qla4xxx_init_rings
+ *	This routine initializes the internal queues for the specified adapter.
+ *
+ * Input:
+ * 	ha - Pointer to host adapter structure.
+ *
+ * Remarks:
+ *	The QLA4010 requires us to restart the queues at index 0.
+ *	The QLA4000 doesn't care, so just default to QLA4010's requirement.
+ * Returns:
+ *	QLA_SUCCESS - Always return success.
+ *
+ * Context:
+ *	Kernel context.
+ */
+int
+qla4xxx_init_rings(scsi_qla_host_t * ha)
+{
+	uint16_t i;
+	unsigned long flags = 0;
+
+	/* Initialize request queue. */
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	ha->request_out = 0;
+	ha->request_in = 0;
+	ha->request_ptr = &ha->request_ring[ha->request_in];
+	ha->req_q_count = REQUEST_QUEUE_DEPTH;
+
+	/* Initialize response queue. */
+	ha->response_in = 0;
+	ha->response_out = 0;
+	ha->response_ptr = &ha->response_ring[ha->response_out];
+
+	/*
+	 * Initialize DMA Shadow registers.  The firmware is really supposed to
+	 * take care of this, but on some uniprocessor systems, the shadow
+	 * registers aren't cleared-- causing the interrupt_handler to think
+	 * there are responses to be processed when there aren't.
+	 */
+	ha->shadow_regs->req_q_out = __constant_cpu_to_le32(0);
+	ha->shadow_regs->rsp_q_in = __constant_cpu_to_le32(0);
+	wmb();
+
+	WRT_REG_DWORD(&ha->reg->req_q_in, 0);
+	WRT_REG_DWORD(&ha->reg->rsp_q_out, 0);
+	PCI_POSTING(&ha->reg->rsp_q_out);
+
+	/* Initialize active array */
+	for (i = 0; i < MAX_SRBS; i++)
+		ha->active_srb_array[i] = 0;
+	ha->active_srb_count = 0;
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	return QLA_SUCCESS;
+}
+
+#define qla4xxx_mac_is_equal(mac1, mac2) (memcmp(mac1, mac2, MAC_ADDR_LEN) == 0)
+
+/**************************************************************************
+ * qla4xxx_validate_mac_address
+ *	This routine validates the M.A.C. Address(es) of the adapter
+ *
+ * Input:
+ * 	ha - Pointer to host adapter structure.
+ *
+ * Returns:
+ *	QLA_SUCCESS - Successfully validated M.A.C. address
+ *	QLA_ERROR   - Failed to validate M.A.C. address
+ *
+ * Context:
+ *	Kernel context.
+ **************************************************************************/
+static int
+qla4xxx_validate_mac_address(scsi_qla_host_t *ha)
+{
+	FLASH_SYS_INFO *sys_info = NULL;
+	dma_addr_t sys_info_dma;
+	int status = QLA_ERROR;
+
+	sys_info = dma_alloc_coherent(&ha->pdev->dev, sizeof(*sys_info),
+	    &sys_info_dma, GFP_KERNEL);
+	if (sys_info == NULL) {
+		DEBUG2(printk("scsi%ld: %s: Unable to allocate dma buffer.\n",
+		    ha->host_no, __func__));
+
+		goto exit_validate_mac_no_free;
+	}
+	memset(sys_info, 0, sizeof(*sys_info));
+
+	/* Get flash sys info */
+	if (qla4xxx_get_flash(ha, sys_info_dma, FLASH_OFFSET_SYS_INFO,
+	    sizeof(*sys_info)) != QLA_SUCCESS) {
+		DEBUG2(printk("scsi%ld: %s: get_flash FLASH_OFFSET_SYS_INFO "
+		    "failed\n", ha->host_no, __func__));
+
+		goto exit_validate_mac;
+	}
+
+	/* Save M.A.C. address & serial_number */
+	memcpy(ha->my_mac, &sys_info->physAddr[0].address[0],
+	    min(sizeof(ha->my_mac), sizeof(sys_info->physAddr[0].address)));
+	memcpy(ha->serial_number, &sys_info->acSerialNumber,
+	    min(sizeof(ha->serial_number), sizeof(sys_info->acSerialNumber)));
+
+	status = QLA_SUCCESS;
+
+exit_validate_mac:
+	dma_free_coherent(&ha->pdev->dev, sizeof(*sys_info), sys_info,
+	    sys_info_dma);
+
+exit_validate_mac_no_free:
+	return status;
+}
+
+/*
+ * qla4xxx_init_local_data
+ *	This routine initializes the local data for the specified adapter.
+ *
+ * Input:
+ * 	ha - Pointer to host adapter structure.
+ *
+ * Returns:
+ *	QLA_SUCCESS - Successfully initialized local data
+ *	QLA_ERROR   - Failed to initialize local data
+ *
+ * Context:
+ *	Kernel context.
+ */
+static int
+qla4xxx_init_local_data(scsi_qla_host_t *ha)
+{
+	int i;
+
+	/* Initialize passthru PDU list */
+	for (i = 0; i < (MAX_PDU_ENTRIES - 1); i++)
+		ha->pdu_queue[i].Next = &ha->pdu_queue[i + 1];
+	ha->free_pdu_top = &ha->pdu_queue[0];
+	ha->free_pdu_bottom = &ha->pdu_queue[MAX_PDU_ENTRIES - 1];
+	ha->free_pdu_bottom->Next = NULL;
+	ha->pdu_active = 0;
+
+	/* Initilize aen queue */
+	ha->aen_q_count = MAX_AEN_ENTRIES;
+
+	/* Initialize local iSNS data */
+	qla4xxx_isns_init_attributes(ha);
+	ha->isns_flags = 0;
+	atomic_set(&ha->isns_restart_timer, 0);
+	ha->isns_connection_id = 0;
+	ha->isns_remote_port_num = 0;
+	ha->isns_scn_port_num = 0;
+	ha->isns_esi_port_num = 0;
+	ha->isns_nsh_port_num = 0;
+	memset(ha->isns_entity_id, 0, sizeof(ha->isns_entity_id));
+	ha->isns_num_discovered_targets = 0;
+
+	return qla4xxx_get_firmware_status(ha);
+}
+
+static int
+qla4xxx_fw_ready(scsi_qla_host_t * ha)
+{
+	uint32_t timeout_count;
+	int ready = 0;
+
+	DEBUG2(ql4_printk(KERN_INFO, ha, "Waiting for Firmware Ready..\n"));
+	for (timeout_count = ADAPTER_INIT_TOV; timeout_count > 0;
+	     timeout_count--) {
+		if (test_and_clear_bit(DPC_GET_DHCP_IP_ADDR, &ha->dpc_flags))
+			qla4xxx_get_dhcp_ip_address(ha);
+		/* Get firmware state. */
+		if (qla4xxx_get_firmware_state(ha) != QLA_SUCCESS) {
+			DEBUG2(printk("scsi%ld: %s: unable to get firmware "
+			    "state\n", ha->host_no, __func__));
+			break;
+
+		}
+
+		if (ha->firmware_state & FW_STATE_ERROR) {
+			DEBUG2(printk("scsi%ld: %s: an unrecoverable error has "
+			    "occurred\n", ha->host_no, __func__));
+			break;
+
+		}
+		if (ha->firmware_state & FW_STATE_CONFIG_WAIT) {
+			/*
+			 * The firmware has not yet been issued an Initialize
+			 * Firmware command, so issue it now.
+			 */
+			if (qla4xxx_initialize_fw_cb(ha) == QLA_ERROR)
+				break;
+
+			/* Go back and test for ready state - no wait. */
+			continue;
+		}
+
+		if (ha->firmware_state == FW_STATE_READY) {
+			DEBUG2(ql4_printk(KERN_INFO, ha, "Firmware Ready..\n"));
+			/* The firmware is ready to process SCSI commands. */
+			DEBUG2(ql4_printk(KERN_INFO, ha,
+			    "scsi%ld: %s: MEDIA TYPE - %s\n", ha->host_no,
+			    __func__, (ha->addl_fw_state &
+			    FW_ADDSTATE_OPTICAL_MEDIA) != 0 ? "OPTICAL" :
+				"COPPER"));
+			DEBUG2(ql4_printk(KERN_INFO, ha,
+			    "scsi%ld: %s: DHCP STATE Enabled " "%s\n",
+			    ha->host_no, __func__, (ha->addl_fw_state &
+			    FW_ADDSTATE_DHCP_ENABLED) != 0 ? "YES" : "NO"));
+			DEBUG2(ql4_printk(KERN_INFO, ha,
+			    "scsi%ld: %s: LINK %s\n", ha->host_no, __func__,
+			    (ha->addl_fw_state & FW_ADDSTATE_LINK_UP) != 0 ?
+			    "UP" : "DOWN"));
+			DEBUG2(ql4_printk(KERN_INFO, ha,
+			    "scsi%ld: %s: iSNS Service " "Started %s\n",
+			    ha->host_no, __func__, (ha->addl_fw_state &
+			    FW_ADDSTATE_ISNS_SVC_ENABLED) != 0 ? "YES" : "NO"));
+
+			ready = 1;
+			/* If iSNS is enabled, start the iSNS service now. */
+			if ((ha->tcp_options & TOPT_ISNS_ENABLE) &&
+			    !IPAddrIsZero(ha->isns_ip_address)) {
+				uint32_t ip_addr = 0;
+
+				IPAddr2Uint32(ha->isns_ip_address, &ip_addr);
+				ql4_printk(KERN_INFO, ha,
+				    "Initializing ISNS..\n");
+				qla4xxx_isns_reenable(ha, ip_addr,
+				    ha->isns_server_port_number);
+			}
+			break;
+		}
+		DEBUG2(printk("scsi%ld: %s: waiting on fw, state=%x:%x - "
+		    "seconds expired= %d\n", ha->host_no, __func__,
+		    ha->firmware_state, ha->addl_fw_state, timeout_count));
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(1 * HZ);
+	}			/* end of for */
+
+	if (timeout_count <= 0)
+		DEBUG2(printk("scsi%ld: %s: FW Initialization timed out!\n",
+		    ha->host_no, __func__));
+	if (ha->firmware_state & FW_STATE_DHCP_IN_PROGRESS)
+		ready = 1;
+
+	return ready;
+}
+
+/*
+ * qla4xxx_init_firmware
+ *	This routine initializes the firmware.
+ *
+ * Input:
+ * 	ha - Pointer to host adapter structure.
+ *
+ * Returns:
+ *	QLA_SUCCESS - Successfully initialized firmware
+ *	QLA_ERROR   - Failed to initialize firmware
+ *
+ * Context:
+ *	Kernel context.
+ */
+static int
+qla4xxx_init_firmware(scsi_qla_host_t * ha)
+{
+	int status = QLA_ERROR;
+
+	ql4_printk(KERN_INFO, ha, "Initializing firmware..\n");
+	if (qla4xxx_initialize_fw_cb(ha) == QLA_ERROR) {
+		DEBUG2(printk("scsi%ld: %s: Failed to initialize firmware "
+		    "control block\n", ha->host_no, __func__));
+		return status;
+	}
+	if (!qla4xxx_fw_ready(ha))
+		return status;
+
+	set_bit(AF_ONLINE, &ha->flags);
+	return qla4xxx_get_firmware_status(ha);
+}
+
+/**************************************************************************
+ * qla4xxx_find_isns_targets
+ *	This routine locates a device handle for ther given iSNS information.
+ *	If device doesn't exist, returns NULL.
+ *
+ * Input:
+ * 	ha - Pointer to host adapter structure.
+ *      ip_addr - Pointer to IP address
+ *      alias - Pointer to iSCSI alias
+ *
+ * Returns:
+ *	Pointer to the corresponding internal device database structure
+ *
+ * Context:
+ *	Kernel context.
+ **************************************************************************/
+static inline int
+qla4xxx_is_discovered_target(scsi_qla_host_t * ha, uint8_t * ip_addr,
+    uint8_t * alias, uint8_t * name_str)
+{
+	ISNS_DISCOVERED_TARGET *discovered_target = NULL;
+	int i, j;
+
+	for (i = 0; i < ha->isns_num_discovered_targets; i++) {
+		discovered_target = &ha->isns_disc_tgt_databasev[i];
+
+		for (j = 0; j < discovered_target->NumPortals; j++) {
+			if (memcmp(discovered_target->Portal[j].IPAddr, ip_addr,
+			    min(sizeof(discovered_target->Portal[j].IPAddr),
+				    sizeof(*ip_addr)) == 0)
+			    && memcmp(discovered_target->Alias, alias,
+				    min(sizeof(discovered_target->Alias),
+					    sizeof(*alias)) == 0)
+			    && memcmp(discovered_target->NameString, name_str,
+				    min(sizeof(discovered_target->Alias),
+					    sizeof(*name_str)) == 0)) {
+
+				return QLA_SUCCESS;
+			}
+		}
+	}
+	return QLA_ERROR;
+}
+
+static struct ddb_entry *
+qla4xxx_get_ddb_entry(scsi_qla_host_t *ha, uint32_t fw_ddb_index)
+{
+	DEV_DB_ENTRY *fw_ddb_entry = NULL;
+	dma_addr_t fw_ddb_entry_dma;
+	struct ddb_entry *ddb_entry = NULL;
+	int found = 0;
+	uint32_t device_state;
+
+	/* Make sure the dma buffer is valid */
+	fw_ddb_entry = dma_alloc_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
+	    &fw_ddb_entry_dma, GFP_KERNEL);
+	if (fw_ddb_entry == NULL) {
+		DEBUG2(printk("scsi%ld: %s: Unable to allocate dma buffer.\n",
+		    ha->host_no, __func__));
+		return NULL;
+	}
+
+	if (qla4xxx_get_fwddb_entry(ha, fw_ddb_index, fw_ddb_entry,
+	    fw_ddb_entry_dma, NULL, NULL, &device_state, NULL, NULL, NULL) ==
+	    QLA_ERROR) {
+		DEBUG2(printk("scsi%ld: %s: failed get_ddb_entry for "
+		    "fw_ddb_index %d\n", ha->host_no, __func__, fw_ddb_index));
+		return NULL;
+	}
+
+	/* Allocate DDB if not already allocated. */
+	DEBUG2(printk("scsi%ld: %s: Looking for ddb[%d]\n", ha->host_no,
+	    __func__, fw_ddb_index));
+	list_for_each_entry(ddb_entry, &ha->ddb_list, list) {
+		if (memcmp(ddb_entry->iscsi_name, fw_ddb_entry->iscsiName,
+		    ISCSI_NAME_SIZE) == 0) {
+			found++;
+			break;
+		}
+	}
+
+	if (!found) {
+		DEBUG2(printk("scsi%ld: %s: ddb[%d] not found - allocating "
+		    "new ddb\n", ha->host_no, __func__, fw_ddb_index));
+		ddb_entry = qla4xxx_alloc_ddb(ha, fw_ddb_index);
+	}
+
+	/* if not found allocate new ddb */
+	dma_free_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry), fw_ddb_entry,
+	    fw_ddb_entry_dma);
+
+	return ddb_entry;
+}
+
+/**************************************************************************
+ * qla4xxx_update_ddb_entry
+ *	This routine updates the driver's internal device database entry
+ *	with information retrieved from the firmware's device database
+ *	entry for the specified device.
+ *
+ * Input:
+ * 	ha - Pointer to host adapter structure.
+ *	ddb_entry - Pointer to device database entry
+ *
+ * Output:
+ *	ddb_entry - Structure filled in.
+ *
+ * Remarks:
+ *	The ddb_entry->fw_ddb_index field must be initialized prior to
+ *	calling this routine
+ *
+ * Returns:
+ *	QLA_SUCCESS - Successfully update ddb_entry
+ *	QLA_ERROR   - Failed to update ddb_entry
+ *
+ * Context:
+ *	Kernel context.
+ **************************************************************************/
+int
+qla4xxx_update_ddb_entry(scsi_qla_host_t * ha, struct ddb_entry *ddb_entry,
+    uint32_t fw_ddb_index)
+{
+	DEV_DB_ENTRY *fw_ddb_entry = NULL;
+	dma_addr_t fw_ddb_entry_dma;
+	int status = QLA_ERROR;
+
+	if (ddb_entry == NULL) {
+		DEBUG2(printk("scsi%ld: %s: ddb_entry is NULL\n", ha->host_no,
+		    __func__));
+		goto exit_update_ddb;
+	}
+
+	/* Make sure the dma buffer is valid */
+	fw_ddb_entry = dma_alloc_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
+	    &fw_ddb_entry_dma, GFP_KERNEL);
+	if (fw_ddb_entry == NULL) {
+		DEBUG2(printk("scsi%ld: %s: Unable to allocate dma buffer.\n",
+		    ha->host_no, __func__));
+
+		goto exit_update_ddb;
+	}
+
+	if (qla4xxx_get_fwddb_entry(ha, fw_ddb_index, fw_ddb_entry,
+	    fw_ddb_entry_dma, NULL, NULL, &ddb_entry->fw_ddb_device_state, NULL,
+	    &ddb_entry->tcp_source_port_num, &ddb_entry->connection_id) ==
+	    QLA_ERROR) {
+		DEBUG2(printk("scsi%ld: %s: failed get_ddb_entry for "
+		    "fw_ddb_index %d\n", ha->host_no, __func__, fw_ddb_index));
+
+		goto exit_update_ddb;
+	}
+
+	status = QLA_SUCCESS;
+	ddb_entry->target_session_id = le16_to_cpu(fw_ddb_entry->TSID);
+	ddb_entry->task_mgmt_timeout =
+	    le16_to_cpu(fw_ddb_entry->taskMngmntTimeout);
+	ddb_entry->CmdSn = 0;
+	ddb_entry->exe_throttle = le16_to_cpu(fw_ddb_entry->exeThrottle);
+	ddb_entry->default_relogin_timeout =
+	    le16_to_cpu(fw_ddb_entry->taskMngmntTimeout);
+	ddb_entry->default_time2wait = le16_to_cpu(fw_ddb_entry->minTime2Wait);
+
+	/* Update index in case it changed */
+	ddb_entry->fw_ddb_index = fw_ddb_index;
+	ha->fw_ddb_index_map[fw_ddb_index] = ddb_entry;
+
+	memcpy(&ddb_entry->iscsi_name[0], &fw_ddb_entry->iscsiName[0],
+	    min(sizeof(ddb_entry->iscsi_name),
+		    sizeof(fw_ddb_entry->iscsiName)));
+	memcpy(&ddb_entry->ip_addr[0], &fw_ddb_entry->ipAddr[0],
+	    min(sizeof(ddb_entry->ip_addr), sizeof(fw_ddb_entry->ipAddr)));
+
+	if (qla4xxx_is_discovered_target(ha, fw_ddb_entry->ipAddr,
+	    fw_ddb_entry->iSCSIAlias, fw_ddb_entry->iscsiName) == QLA_SUCCESS)
+		set_bit(DF_ISNS_DISCOVERED, &ddb_entry->flags);
+
+	DEBUG2(printk("scsi%ld: %s: ddb[%d] - State= %x status= %d.\n",
+	    ha->host_no, __func__, fw_ddb_index,
+	    ddb_entry->fw_ddb_device_state, status);)
+
+exit_update_ddb:
+	if (fw_ddb_entry)
+		dma_free_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
+		    fw_ddb_entry, fw_ddb_entry_dma);
+
+	return status;
+}
+
+/**************************************************************************
+ * qla4xxx_alloc_ddb
+ *	This routine allocates a ddb_entry, ititializes some values, and
+ *	inserts it into the ddb list.
+ *
+ * Input:
+ * 	ha - Pointer to host adapter structure.
+ *      fw_ddb_index - Firmware's device database index
+ *
+ * Returns:
+ *	Pointer to internal device database structure
+ *
+ * Context:
+ *	Kernel context.
+ **************************************************************************/
+struct ddb_entry *
+qla4xxx_alloc_ddb(scsi_qla_host_t * ha, uint32_t fw_ddb_index)
+{
+	struct ddb_entry *ddb_entry;
+
+	DEBUG2(printk("scsi%ld: %s: fw_ddb_index [%d]\n", ha->host_no,
+	    __func__, fw_ddb_index));
+
+	ddb_entry = (struct ddb_entry *)kmalloc(sizeof(*ddb_entry), GFP_ATOMIC);
+	if (ddb_entry == NULL) {
+		DEBUG2(printk("scsi%ld: %s: Unable to allocate memory "
+		    "to add fw_ddb_index [%d]\n", ha->host_no, __func__,
+		    fw_ddb_index));
+		return ddb_entry;
+	}
+
+	memset(ddb_entry, 0, sizeof(*ddb_entry));
+	ddb_entry->fw_ddb_index = fw_ddb_index;
+	atomic_set(&ddb_entry->port_down_timer, ha->port_down_retry_count);
+	atomic_set(&ddb_entry->retry_relogin_timer, INVALID_ENTRY);
+	atomic_set(&ddb_entry->relogin_timer, 0);
+	atomic_set(&ddb_entry->relogin_retry_count, 0);
+	atomic_set(&ddb_entry->state, DDB_STATE_ONLINE);
+	list_add_tail(&ddb_entry->list, &ha->ddb_list);
+	ha->fw_ddb_index_map[fw_ddb_index] = ddb_entry;
+	ha->tot_ddbs++;
+
+	return ddb_entry;
+}
+
+/**************************************************************************
+ * qla4xxx_configure_ddbs
+ *	This routine searches for all valid firmware ddb entries and builds
+ *	an internal ddb list.
+ *
+ * Input:
+ * 	ha - Pointer to host adapter structure.
+ *
+ * Remarks:
+ *	Ddbs that are considered valid are those with a device state of
+ *	SESSION_ACTIVE.
+ *
+ * Returns:
+ *	QLA_SUCCESS - Successfully built internal ddb list, if targets available
+ *	QLA_ERROR   - Error on a mailbox command
+ *
+ * Context:
+ *	Kernel context.
+ **************************************************************************/
+static int
+qla4xxx_build_ddb_list(scsi_qla_host_t *ha)
+{
+	int status = QLA_SUCCESS;
+	uint32_t fw_ddb_index = 0;
+	uint32_t next_fw_ddb_index = 0;
+	uint32_t ddb_state;
+	uint32_t conn_err, err_code;
+	struct ddb_entry *ddb_entry;
+
+	ql4_printk(KERN_INFO, ha, "Initializing DDBs ...\n");
+	for (fw_ddb_index = 0; fw_ddb_index < MAX_DDB_ENTRIES;
+	     fw_ddb_index = next_fw_ddb_index) {
+		/* First, let's see if a device exists here */
+		if (qla4xxx_get_fwddb_entry(ha, fw_ddb_index, NULL, 0, NULL,
+		    &next_fw_ddb_index, &ddb_state, &conn_err, NULL, NULL) ==
+		    QLA_ERROR) {
+			DEBUG2(printk("scsi%ld: %s: get_ddb_entry, "
+			    "fw_ddb_index %d failed", ha->host_no, __func__,
+			    fw_ddb_index));
+			return QLA_ERROR;
+		}
+
+		DEBUG2(printk("scsi%ld: %s: Getting DDB[%d] ddbstate=0x%x, "
+		    "next_fw_ddb_index=%d.\n", ha->host_no, __func__,
+		    fw_ddb_index, ddb_state, next_fw_ddb_index));
+
+		/* Add DDB to internal our ddb list. */
+		ddb_entry = qla4xxx_get_ddb_entry(ha, fw_ddb_index);
+		if (ddb_entry == NULL) {
+			DEBUG2(printk("scsi%ld: %s: Unable to allocate memory "
+			    "for device at fw_ddb_index %d\n", ha->host_no,
+			    __func__, fw_ddb_index));
+			return QLA_ERROR;
+		}
+		/* Fill in the device structure */
+		if (qla4xxx_update_ddb_entry(ha, ddb_entry, fw_ddb_index) ==
+		    QLA_ERROR) {
+			ha->fw_ddb_index_map[fw_ddb_index] =
+			    (struct ddb_entry *)INVALID_ENTRY;
+
+			//      qla4xxx_free_ddb(ha, ddb_entry);
+			DEBUG2(printk("scsi%ld: %s: update_ddb_entry failed "
+			    "for fw_ddb_index %d.\n", ha->host_no, __func__,
+			    fw_ddb_index));
+			return QLA_ERROR;
+		}
+
+		/* if fw_ddb with session active state found,
+		 * add to ddb_list */
+		DEBUG2(printk("scsi%ld: %s: DDB[%d] added to list\n",
+		    ha->host_no, __func__, fw_ddb_index));
+
+		/* Issue relogin, if necessary. */
+		if (ddb_state == DDB_DS_SESSION_FAILED ||
+		    ddb_state == DDB_DS_NO_CONNECTION_ACTIVE) {
+
+			atomic_set(&ddb_entry->state, DDB_STATE_DEAD);
+
+			/* Try and login to device */
+			DEBUG2(printk("scsi%ld: %s: Login to DDB[%d]\n",
+			    ha->host_no, __func__, fw_ddb_index));
+			err_code = ((conn_err & 0x00ff0000) >> 16);
+			if (err_code == 0x1c || err_code == 0x06) {
+				DEBUG2(printk("%s send target completed or "
+				    "access denied failure\n", __func__));
+			} else {
+				qla4xxx_set_ddb_entry(ha, fw_ddb_index, NULL,
+				    0);
+			}
+		}
+
+		/* We know we've reached the last device when
+		 * next_fw_ddb_index is 0 */
+		if (next_fw_ddb_index == 0)
+			break;
+	}
+
+	ql4_printk(KERN_INFO, ha, "DDB list done..\n");
+
+	return status;
+}
+
+/**************************************************************************
+ * qla4xxx_devices_ready
+ *	This routine waits up to ql4xdiscoverywait seconds
+ *	F/W database during driver load time.
+ *
+ * Input:
+ * 	ha - Pointer to host adapter structure.
+ *
+ * Returns:
+ *	QLA_SUCCESS - Successfully (re)built internal ddb list
+ *	QLA_ERROR   - Failed to (re)build internal ddb list
+ *
+ * Context:
+ *	Kernel context.
+ **************************************************************************/
+static int
+qla4xxx_devices_ready(scsi_qla_host_t * ha)
+{
+	int halt_wait;
+	unsigned long discovery_wtime;
+	struct ddb_entry *ddb_entry;
+	uint32_t fw_ddb_index;
+	uint32_t next_fw_ddb_index;
+	uint32_t fw_ddb_device_state;
+	uint32_t conn_err;
+	uint32_t err_code;
+
+	discovery_wtime = jiffies + (ql4xdiscoverywait * HZ);
+
+	DEBUG(printk("Waiting (%d) for devices ...\n", ql4xdiscoverywait));
+	do {
+		/* poll for AEN. */
+		qla4xxx_get_firmware_state(ha);
+		if (test_and_clear_bit(DPC_AEN, &ha->dpc_flags)) {
+			/* Set time-between-relogin timer */
+			qla4xxx_process_aen(ha, RELOGIN_DDB_CHANGED_AENS);
+		}
+
+		/* if no relogins active or needed, halt discvery wait */
+		halt_wait = 1;
+
+		/* scan for relogins
+		 * ----------------- */
+		for (fw_ddb_index = 0; fw_ddb_index < MAX_DDB_ENTRIES;
+		    fw_ddb_index = next_fw_ddb_index) {
+			if (qla4xxx_get_fwddb_entry(ha, fw_ddb_index, NULL, 0,
+			    NULL, &next_fw_ddb_index, &fw_ddb_device_state,
+			    &conn_err, NULL, NULL) == QLA_ERROR)
+				return QLA_ERROR;
+
+			if (fw_ddb_device_state == DDB_DS_LOGIN_IN_PROCESS)
+				halt_wait = 0;
+
+			if (fw_ddb_device_state == DDB_DS_SESSION_FAILED ||
+			    fw_ddb_device_state ==
+			    DDB_DS_NO_CONNECTION_ACTIVE) {
+
+				/*
+				 * Don't want to do a relogin if connection
+				 * error is 0x1c.
+				 */
+				err_code = ((conn_err & 0x00ff0000) >> 16);
+				if (err_code == 0x1c || err_code == 0x06) {
+					DEBUG2(printk(
+					    "%s send target completed or "
+					    "access denied failure\n",
+					    __func__);)
+				} else {
+					/* We either have a device that is in
+					 * the process of relogging in or a
+					 * device that is waiting to be
+					 * relogged in */
+					halt_wait = 0;
+
+					ddb_entry =
+					    qla4xxx_lookup_ddb_by_fw_index(ha,
+						fw_ddb_index);
+					if (ddb_entry == NULL)
+						return QLA_ERROR;
+
+					if (ddb_entry->dev_scan_wait_to_start_relogin != 0
+					    && time_after_eq(jiffies,
+						    ddb_entry->dev_scan_wait_to_start_relogin))
+					{
+						ddb_entry->
+						    dev_scan_wait_to_start_relogin
+						    = 0;
+						qla4xxx_set_ddb_entry(ha,
+						    fw_ddb_index, NULL, 0);
+					}
+				}
+			}
+
+			/* We know we've reached the last device when
+			 * next_fw_ddb_index is 0 */
+			if (next_fw_ddb_index == 0)
+				break;
+		}
+
+		if (halt_wait) {
+			DEBUG2(printk("scsi%ld: %s: Delay halted.  Devices "
+			    "Ready.\n", ha->host_no, __func__));
+			return QLA_SUCCESS;
+		}
+
+		/* delay */
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(HZ * 2);
+	} while (!time_after_eq(jiffies, discovery_wtime));
+
+	DEBUG3(qla4xxx_get_conn_event_log(ha));
+
+	return (QLA_SUCCESS);
+}
+
+static void
+qla4xxx_flush_AENS(scsi_qla_host_t *ha)
+{
+	unsigned long wtime;
+
+	/* Flush the 0x8014 AEN from the firmware as a result of
+	 * Auto connect. We are basically doing get_firmware_ddb()
+	 * to determine whether we need to log back in or not.
+	 *  Trying to do a set ddb before we have processed 0x8014
+	 *  will result in another set_ddb() for the same ddb. In other
+	 *  words there will be stale entries in the aen_q.
+	 */
+	wtime = jiffies + (2 * HZ);
+	do {
+		if (qla4xxx_get_firmware_state(ha) == QLA_SUCCESS)
+			if (ha->firmware_state & (BIT_2 | BIT_0))
+				return;
+
+		if (test_and_clear_bit(DPC_AEN, &ha->dpc_flags))
+			qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
+
+		/* delay */
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(HZ * 1);
+
+	} while (!time_after_eq(jiffies, wtime));
+
+}
+
+static int
+qla4xxx_initialize_ddb_list(scsi_qla_host_t *ha)
+{
+	uint16_t fw_ddb_index;
+	int status = QLA_SUCCESS;
+
+	/* free the ddb list if is not empty */
+	if (!list_empty(&ha->ddb_list))
+		qla4xxx_free_ddb_list(ha);
+
+	for (fw_ddb_index = 0; fw_ddb_index < MAX_DDB_ENTRIES; fw_ddb_index++)
+		ha->fw_ddb_index_map[fw_ddb_index] =
+		    (struct ddb_entry *)INVALID_ENTRY;
+
+	ha->tot_ddbs = 0;
+
+	qla4xxx_flush_AENS(ha);
+
+	/*
+	 * First perform device discovery for active
+	 * fw ddb indexes and build
+	 * ddb list.
+	 */
+	if ((status = qla4xxx_build_ddb_list(ha)) == QLA_ERROR)
+		return (status);
+
+	/* Wait for an AEN */
+	qla4xxx_devices_ready(ha);
+
+	/*
+	 * Targets can come online after the inital discovery, so processing
+	 * the aens here will catch them.
+	 */
+	if (test_and_clear_bit(DPC_AEN, &ha->dpc_flags))
+		qla4xxx_process_aen(ha, PROCESS_ALL_AENS);
+
+	return status;
+}
+
+/*
+ * qla4xxx_update_ddb_list
+ *	This routine obtains device information from the F/W database after
+ *	firmware or adapter resets.  The device table is preserved.
+ *
+ * Input:
+ * 	ha - Pointer to host adapter structure.
+ *
+ * Returns:
+ *	QLA_SUCCESS - Successfully updated internal ddb list
+ *	QLA_ERROR   - Failed to update internal ddb list
+ *
+ * Context:
+ *	Kernel context.
+ */
+int
+qla4xxx_reinitialize_ddb_list(scsi_qla_host_t * ha)
+{
+	int status = QLA_SUCCESS;
+	struct ddb_entry *ddb_entry, *detemp;
+
+	/* Update the device information for all devices. */
+	list_for_each_entry_safe(ddb_entry, detemp, &ha->ddb_list, list) {
+		qla4xxx_update_ddb_entry(ha, ddb_entry,
+		    ddb_entry->fw_ddb_index);
+		if (ddb_entry->fw_ddb_device_state == DDB_DS_SESSION_ACTIVE) {
+			atomic_set(&ddb_entry->state, DDB_STATE_ONLINE);
+			DEBUG2(printk ("scsi%ld: %s: ddb index [%d] marked "
+			    "ONLINE\n", ha->host_no, __func__,
+			    ddb_entry->fw_ddb_index));
+		} else if (atomic_read(&ddb_entry->state) == DDB_STATE_ONLINE)
+			qla4xxx_mark_device_missing(ha, ddb_entry);
+	}
+	return status;
+}
+
+/**************************************************************************
+ * qla4xxx_relogin_device
+ *	This routine does a session relogin with the specified device.
+ *	The ddb entry must be assigned prior to making this call.
+ *
+ * Input:
+ * 	ha - Pointer to host adapter structure.
+ *	ddb_entry - Pointer to device database entry
+ *
+ * Returns:
+ *    QLA_SUCCESS = Successfully relogged in device
+ *    QLA_ERROR   = Failed to relogin device
+ *
+ * Context:
+ *	Kernel context.
+ **************************************************************************/
+int
+qla4xxx_relogin_device(scsi_qla_host_t * ha, struct ddb_entry * ddb_entry)
+{
+	uint16_t relogin_timer;
+
+	relogin_timer = max(ddb_entry->default_relogin_timeout,
+	    (uint16_t)RELOGIN_TOV);
+	atomic_set(&ddb_entry->relogin_timer, relogin_timer);
+
+	DEBUG2(printk("scsi%ld: Relogin index [%d]. TOV=%d\n", ha->host_no,
+	    ddb_entry->fw_ddb_index, relogin_timer));
+
+	qla4xxx_set_ddb_entry(ha, ddb_entry->fw_ddb_index, NULL, 0);
+
+	return QLA_SUCCESS;
+}
+
+/**************************************************************************
+ * qla4010_topcat_soft_reset
+ *	This routine determines if the QLA4040 TopCat chip is present.
+ *
+ * Input:
+ * 	ha - Pointer to host adapter structure.
+ *
+ * Returns:
+ *	None.
+ *
+ * Context:
+ *	Kernel context.
+ **************************************************************************/
+static void
+qla4010_get_topcat_presence(scsi_qla_host_t * ha)
+{
+	unsigned long flags;
+	uint16_t topcat;
+
+	QL4XXX_LOCK_NVRAM(ha);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	topcat = RD_NVRAM_WORD(ha, offsetof(eeprom_data_t, isp4010.topcat));
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	if ((topcat & TOPCAT_MASK) == TOPCAT_PRESENT)
+		set_bit(AF_TOPCAT_CHIP_PRESENT, &ha->flags);
+	else
+		clear_bit(AF_TOPCAT_CHIP_PRESENT, &ha->flags);
+	QL4XXX_UNLOCK_NVRAM(ha);
+}
+
+
+static int
+qla4xxx_config_nvram(scsi_qla_host_t * ha)
+{
+	unsigned long flags;
+	EXTERNAL_HW_CONFIG_REG extHwConfig;
+
+	DEBUG2(printk("scsi%ld: %s: Get EEProm parameters \n", ha->host_no,
+	    __func__));
+	QL4XXX_LOCK_FLASH(ha);
+	QL4XXX_LOCK_NVRAM(ha);
+	/* Get EEPRom Parameters from NVRAM and validate */
+	ql4_printk(KERN_INFO, ha, "Configuring NVRAM ...\n");
+	if (qla4xxx_is_NVRAM_configuration_valid(ha) == QLA_SUCCESS) {
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		extHwConfig.Asuint32_t = RD_NVRAM_WORD(ha,
+		    EEPROM_EXT_HW_CONF_OFFSET());
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	} else {
+		/*
+		 * QLogic adapters should always have a valid NVRAM.
+		 * If not valid, do not load.
+		 */
+		ql4_printk(KERN_WARNING, ha,
+		    "scsi%ld: %s: EEProm checksum invalid.  Please update "
+		    "your EEPROM\n", ha->host_no, __func__);
+
+		/* set defaults */
+		if (IS_QLA4010(ha))
+			extHwConfig.Asuint32_t = 0x1912;
+		else if (IS_QLA4022(ha))
+			extHwConfig.Asuint32_t = 0x0023;
+	}
+	DEBUG(printk("scsi%ld: %s: Setting extHwConfig to 0xFFFF%04x\n",
+	    ha->host_no, __func__, extHwConfig.Asuint32_t));
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	WRT_REG_DWORD(ISP_EXT_HW_CONF(ha),
+	    ((0xFFFF << 16) | extHwConfig.Asuint32_t));
+	PCI_POSTING(ISP_EXT_HW_CONF(ha));
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	QL4XXX_UNLOCK_NVRAM(ha);
+	QL4XXX_UNLOCK_FLASH(ha);
+
+	return 1;
+}
+
+static void
+qla4x00_pci_config(scsi_qla_host_t * ha)
+{
+	uint16_t w, mwi;
+
+	ql4_printk(KERN_INFO, ha, "Configuring PCI space...\n");
+
+	pci_set_master(ha->pdev);
+	mwi = 0;
+	if (pci_set_mwi(ha->pdev))
+		mwi = PCI_COMMAND_INVALIDATE;
+	/*
+	 * We want to respect framework's setting of PCI configuration space
+	 * command register and also want to make sure that all bits of
+	 * interest to us are properly set in command register.
+	 */
+	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
+	w |= mwi | (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
+	w &= ~PCI_COMMAND_INTX_DISABLE;
+	pci_write_config_word(ha->pdev, PCI_COMMAND, w);
+}
+
+static int
+qla4xxx_start_firmware_from_flash(scsi_qla_host_t * ha)
+{
+	int status = QLA_ERROR;
+	uint32_t max_wait_time;
+	unsigned long flags;
+	uint32_t mbox_status;
+
+	ql4_printk(KERN_INFO, ha, "Starting firmware ...\n");
+
+	/*
+	 * Start firmware from flash ROM
+	 *
+	 * WORKAROUND: Stuff a non-constant value that the firmware can
+	 * use as a seed for a random number generator in MB7 prior to
+	 * setting BOOT_ENABLE.  Fixes problem where the TCP
+	 * connections use the same TCP ports after each reboot,
+	 * causing some connections to not get re-established.
+	 */
+	DEBUG(printk("scsi%d: %s: Start firmware from flash ROM\n",
+	    ha->host_no, __func__));
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	WRT_REG_DWORD(&ha->reg->mailbox[7], jiffies);
+	if (IS_QLA4022(ha))
+		WRT_REG_DWORD(&ha->reg->u1.isp4022.nvram,
+		    SET_RMASK(NVR_WRITE_ENABLE));
+
+	WRT_REG_DWORD(&ha->reg->ctrl_status, SET_RMASK(CSR_BOOT_ENABLE));
+	PCI_POSTING(&ha->reg->ctrl_status);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	/* Wait for firmware to come UP. */
+	max_wait_time = FIRMWARE_UP_TOV * 4;
+	do {
+		uint32_t ctrl_status;
+
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		ctrl_status = RD_REG_DWORD(&ha->reg->ctrl_status);
+		mbox_status = RD_REG_DWORD(&ha->reg->mailbox[0]);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+		if (ctrl_status & SET_RMASK(CSR_SCSI_PROCESSOR_INTR))
+			break;
+		if (mbox_status == MBOX_STS_COMMAND_COMPLETE)
+			break;
+
+		DEBUG2(printk("scsi%ld: %s: Waiting for boot firmware to "
+		    "complete... ctrl_sts=0x%x, remaining=%d\n", ha->host_no,
+		    __func__, ctrl_status, max_wait_time));
+
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(HZ / 4);
+	} while ((max_wait_time--));
+
+	if (mbox_status == MBOX_STS_COMMAND_COMPLETE) {
+		DEBUG(printk("scsi%ld: %s: Firmware has started\n",
+		    ha->host_no, __func__));
+
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		WRT_REG_DWORD(&ha->reg->ctrl_status,
+		    SET_RMASK(CSR_SCSI_PROCESSOR_INTR));
+		PCI_POSTING(&ha->reg->ctrl_status);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+		status = QLA_SUCCESS;
+	} else {
+		printk(KERN_INFO "scsi%ld: %s: Boot firmware failed "
+		    "-  mbox status 0x%x\n", ha->host_no, __func__,
+		    mbox_status);
+		status = QLA_ERROR;
+	}
+	return status;
+}
+
+/**************************************************************************
+ * qla4xxx_start_firmware
+ *	This routine performs the neccessary steps to start the firmware for
+ *	the QLA4010 adapter.
+ *
+ * Input:
+ * 	ha - Pointer to host adapter structure.
+ *
+ * Returns:
+ *	QLA_SUCCESS - Successfully started QLA4xxx firmware
+ *	QLA_ERROR   - Failed to start QLA4xxx firmware
+ *
+ * Context:
+ *	Kernel context.
+ **************************************************************************/
+static int
+qla4xxx_start_firmware(scsi_qla_host_t * ha)
+{
+	unsigned long flags = 0;
+	uint32_t mbox_status;
+	int status = QLA_ERROR;
+	int soft_reset = 1;
+	int config_chip = 0;
+
+	if (IS_QLA4010(ha))
+		qla4010_get_topcat_presence(ha);
+
+	if (IS_QLA4022(ha))
+		ql4xxx_set_mac_number(ha);
+
+	QL4XXX_LOCK_DRVR_WAIT(ha);
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+
+	DEBUG2(printk("scsi%ld: %s: port_ctrl   = 0x%08X\n", ha->host_no,
+	    __func__, RD_REG_DWORD(ISP_PORT_CTRL(ha))));
+	DEBUG(printk("scsi%ld: %s: port_status = 0x%08X\n", ha->host_no,
+	    __func__, RD_REG_DWORD(ISP_PORT_STATUS(ha))));
+
+	/* Is Hardware already initialized? */
+	if ((RD_REG_DWORD(ISP_PORT_CTRL(ha)) & 0x8000) != 0) {
+		DEBUG(printk("scsi%ld: %s: Hardware has already been "
+		    "initialized\n", ha->host_no, __func__));
+
+		/* Receive firmware boot acknowledgement */
+		mbox_status = RD_REG_DWORD(&ha->reg->mailbox[0]);
+
+		DEBUG2(printk("scsi%ld: %s: H/W Config complete - mbox[0]= "
+		    "0x%x\n", ha->host_no, __func__, mbox_status));
+
+		/* Is firmware already booted? */
+		if (mbox_status == 0) {
+			/* F/W not running, must be config by net driver */
+			config_chip = 1;
+			soft_reset = 0;
+		} else {
+			WRT_REG_DWORD(&ha->reg->ctrl_status,
+			    SET_RMASK(CSR_SCSI_PROCESSOR_INTR));
+			PCI_POSTING(&ha->reg->ctrl_status);
+			spin_unlock_irqrestore(&ha->hardware_lock, flags);
+			if (qla4xxx_get_firmware_state(ha) == QLA_SUCCESS) {
+				DEBUG2(printk("scsi%ld: %s: Get firmware "
+				    "state -- state = 0x%x\n", ha->host_no,
+				    __func__, ha->firmware_state));
+				/* F/W is running */
+				if (ha->firmware_state & FW_STATE_CONFIG_WAIT) {
+					DEBUG2(printk("scsi%ld: %s: Firmware "
+					    "in known state -- config and "
+					    "boot, state = 0x%x\n",
+					    ha->host_no, __func__,
+					    ha->firmware_state));
+					config_chip = 1;
+					soft_reset = 0;
+				}
+			} else {
+				DEBUG2(printk("scsi%ld: %s: Firmware in "
+				    "unknown state -- resetting, state = "
+				    "0x%x\n", ha->host_no, __func__,
+				    ha->firmware_state));
+			}
+			spin_lock_irqsave(&ha->hardware_lock, flags);
+		}
+	} else {
+		DEBUG(printk("scsi%ld: %s: H/W initialization hasn't been "
+		    "started - resetting\n", ha->host_no, __func__));
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	DEBUG(printk("scsi%ld: %s: Flags soft_rest=%d, config= %d\n ",
+	    ha->host_no, __func__, soft_reset, config_chip));
+	if (soft_reset) {
+		DEBUG(printk("scsi%ld: %s: Issue Soft Reset\n", ha->host_no,
+		    __func__));
+		status = qla4xxx_soft_reset(ha);
+		if (status == QLA_ERROR) {
+			DEBUG(printk("scsi%d: %s: Soft Reset failed!\n",
+			    ha->host_no, __func__));
+			QL4XXX_UNLOCK_DRVR(ha);
+			return QLA_ERROR;
+		}
+		config_chip = 1;
+		/* Reset clears the semaphore, so aquire again */
+		QL4XXX_LOCK_DRVR_WAIT(ha);
+	}
+
+	if (config_chip) {
+		if (qla4xxx_config_nvram(ha))
+			status = qla4xxx_start_firmware_from_flash(ha);
+
+		QL4XXX_UNLOCK_DRVR(ha);
+		if (status == QLA_SUCCESS) {
+			qla4xxx_get_fw_version(ha);
+			if (test_and_clear_bit(AF_GET_CRASH_RECORD, &ha->flags))
+				qla4xxx_get_crash_record(ha);
+		} else {
+			DEBUG(printk("scsi%ld: %s: Firmware has NOT started\n",
+			    ha->host_no, __func__));
+		}
+	}
+	return status;
+}
+
+
+/**************************************************************************
+ * qla4xxx_initialize_adapter
+ *	This routine parforms all of the steps necessary to initialize the
+ *	adapter.
+ *
+ * Input:
+ * 	ha - Pointer to host adapter structure.
+ *	renew_ddb_list - Indicates what to do with the adapter's ddb list
+ *			after adapter recovery has completed.
+ *			0=preserve ddb list, 1=destroy and rebuild ddb list
+ *
+ * Returns:
+ *	QLA_SUCCESS - Successfully initialized adapter
+ *	QLA_ERROR   - Failed to initialize adapter
+ *
+ * Context:
+ *	Kernel context.
+ **************************************************************************/
+int
+qla4xxx_initialize_adapter(scsi_qla_host_t * ha, uint8_t renew_ddb_list)
+{
+	int status = QLA_ERROR;
+
+	qla4x00_pci_config(ha);
+
+	qla4xxx_disable_intrs(ha);
+
+	/* Initialize the Host adapter request/response queues and firmware */
+	if (qla4xxx_start_firmware(ha) == QLA_ERROR)
+		return status;
+
+	if (qla4xxx_validate_mac_address(ha) == QLA_ERROR)
+		return status;
+
+	if (qla4xxx_init_local_data(ha) == QLA_ERROR)
+		return status;
+
+	status = qla4xxx_init_firmware(ha);
+	if (status == QLA_ERROR)
+		return status;
+
+	/*
+	 * FW is waiting to get an IP address from DHCP server: Skip building
+	 * the ddb_list and wait for DHCP lease acquired aen to come in
+	 * followed by 0x8014 aen" to trigger the tgt discovery process.
+	 */
+	if (ha->firmware_state & FW_STATE_DHCP_IN_PROGRESS)
+		return status;
+
+	/* Skip device discovery if ip and subnet is zero */
+	if (IPAddrIsZero(ha->ip_address) || IPAddrIsZero(ha->subnet_mask))
+		return status;
+
+	/* If iSNS Enabled, wait for iSNS targets */
+	if (test_bit (ISNS_FLAG_ISNS_ENABLED_IN_ISP, &ha->isns_flags)) {
+		unsigned long wait_cnt = jiffies + ql4xdiscoverywait * HZ;
+
+		DEBUG(printk("scsi%ld: Delay up to %d seconds while iSNS "
+		    "targets are being discovered.\n", ha->host_no,
+		    ql4xdiscoverywait));
+		while (!time_after_eq(jiffies, wait_cnt)) {
+			if (test_bit(ISNS_FLAG_DEV_SCAN_DONE, &ha->isns_flags))
+				break;
+			qla4xxx_get_firmware_state(ha);
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule_timeout(1 * HZ);
+		}
+
+		if (!test_bit(ISNS_FLAG_ISNS_SRV_ENABLED, &ha->isns_flags)) {
+			DEBUG2(printk("scsi%ld: iSNS service failed to start\n",
+			    ha->host_no));
+		} else {
+			if (!ha->isns_num_discovered_targets) {
+				DEBUG2(printk("scsi%ld: Failed to discover "
+				    "iSNS targets\n", ha->host_no));
+			}
+		}
+	}
+
+	if (renew_ddb_list == PRESERVE_DDB_LIST) {
+		/*
+		 * We want to preserve lun states (i.e. suspended, etc.)
+		 * for recovery initiated by the driver.  So just update
+		 * the device states for the existing ddb_list.
+		 */
+		qla4xxx_reinitialize_ddb_list(ha);
+	} else if (renew_ddb_list == REBUILD_DDB_LIST) {
+		/*
+		 * We want to build the ddb_list from scratch during
+		 * driver initialization and recovery initiated by the
+		 * INT_HBA_RESET IOCTL.
+		 */
+		status = qla4xxx_initialize_ddb_list(ha);
+		if (status == QLA_ERROR) {
+			DEBUG2(printk("%s(%ld) Error occurred during build ddb "
+			    "list\n", __func__, ha->host_no));
+			goto exit_init_hba;
+		}
+
+	}
+	if (!ha->tot_ddbs) {
+		DEBUG2(printk("scsi%ld: Failed to initialize devices or none "
+		    "present in Firmware device database\n", ha->host_no));
+	}
+
+exit_init_hba:
+	return status;
+
+}
+
+/**************************************************************************
+ * qla4xxx_add_device_dynamically
+ *	This routine processes adds a device as a result of an 8014h AEN.
+ *
+ * Input:
+ * 	ha - Pointer to host adapter structure.
+ *      fw_ddb_index - Firmware's device database index
+ *
+ * Returns:
+ *	None
+ *
+ * Context:
+ *	Kernel context.
+ **************************************************************************/
+static void
+qla4xxx_add_device_dynamically(scsi_qla_host_t *ha, uint32_t fw_ddb_index)
+{
+	struct ddb_entry * ddb_entry;
+
+	/* First allocate a device structure */
+	ddb_entry = qla4xxx_get_ddb_entry(ha, fw_ddb_index);
+	if (ddb_entry == NULL) {
+		DEBUG2(printk(KERN_WARNING
+		    "scsi%ld: Unable to allocate memory to add fw_ddb_index "
+		    "%d\n", ha->host_no, fw_ddb_index));
+	} else if (qla4xxx_update_ddb_entry(ha, ddb_entry, fw_ddb_index) ==
+	    QLA_ERROR) {
+		ha->fw_ddb_index_map[fw_ddb_index] =
+		    (struct ddb_entry *)INVALID_ENTRY;
+		DEBUG2(printk(KERN_WARNING
+		    "scsi%ld: failed to add new device at index [%d]\n"
+		    "Unable to retrieve fw ddb entry\n", ha->host_no,
+		    fw_ddb_index));
+	} else {
+		/* New device. Let's add it to the database */
+		DEBUG2(printk("scsi%ld: %s: new device at index [%d]\n",
+		    ha->host_no, __func__, fw_ddb_index));
+/*FIXME*/
+		/*qla4xxx_config_os(ha);*/
+	}
+}
+
+/**************************************************************************
+ * qla4xxx_process_ddb_changed
+ *	This routine processes a Decive Database Changed AEN Event.
+ *
+ * Input:
+ * 	ha - Pointer to host adapter structure.
+ *      fw_ddb_index - Firmware's device database index
+ *      state - Device state
+ *
+ * Returns:
+ *	QLA_SUCCESS - Successfully processed ddb_changed aen
+ *	QLA_ERROR   - Failed to process ddb_changed aen
+ *
+ * Context:
+ *	Kernel context.
+ **************************************************************************/
+int
+qla4xxx_process_ddb_changed(scsi_qla_host_t * ha, uint32_t fw_ddb_index,
+    uint32_t state)
+{
+	struct ddb_entry * ddb_entry;
+	uint32_t old_fw_ddb_device_state;
+
+	/* check for out of range index */
+	if (fw_ddb_index >= MAX_DDB_ENTRIES)
+		return QLA_ERROR;
+
+	/* Get the corresponging ddb entry */
+	ddb_entry = qla4xxx_lookup_ddb_by_fw_index(ha, fw_ddb_index);
+	/* Device does not currently exist in our database. */
+	if (ddb_entry == NULL) {
+		if (state == DDB_DS_SESSION_ACTIVE)
+			qla4xxx_add_device_dynamically(ha, fw_ddb_index);
+		return QLA_SUCCESS;
+	}
+
+	/* Device already exists in our database. */
+	old_fw_ddb_device_state = ddb_entry->fw_ddb_device_state;
+	DEBUG2(printk("scsi%ld: %s DDB - old state= 0x%x, new state=0x%x for "
+	    "index [%d]\n", ha->host_no, __func__,
+	    ddb_entry->fw_ddb_device_state, state, fw_ddb_index));
+	if (old_fw_ddb_device_state == state &&
+	    state == DDB_DS_SESSION_ACTIVE) {
+		/* Do nothing, state not changed. */
+		return QLA_SUCCESS;
+	}
+
+	ddb_entry->fw_ddb_device_state = state;
+	/* Device is back online. */
+	if (ddb_entry->fw_ddb_device_state == DDB_DS_SESSION_ACTIVE) {
+		atomic_set(&ddb_entry->port_down_timer,
+		    ha->port_down_retry_count);
+		atomic_set(&ddb_entry->state, DDB_STATE_ONLINE);
+		atomic_set(&ddb_entry->relogin_retry_count, 0);
+		atomic_set(&ddb_entry->relogin_timer, 0);
+		clear_bit(DF_RELOGIN, &ddb_entry->flags);
+		clear_bit(DF_NO_RELOGIN, &ddb_entry->flags);
+		/*
+		 * Change the lun state to READY in case the lun TIMEOUT before
+		 * the device came back.
+		 */
+	} else {
+		/* Device went away, try to relogin. */
+		/* Mark device missing */
+		if (atomic_read(&ddb_entry->state) == DDB_STATE_ONLINE)
+			qla4xxx_mark_device_missing(ha, ddb_entry);
+		/*
+		 * Relogin if device state changed to a not active state.
+		 * However, do not relogin if this aen is a result of an IOCTL
+		 * logout (DF_NO_RELOGIN) or if this is a discovered device.
+		 */
+		if (ddb_entry->fw_ddb_device_state == DDB_DS_SESSION_FAILED &&
+		    !test_bit(DF_RELOGIN, &ddb_entry->flags) &&
+		    !test_bit(DF_NO_RELOGIN, &ddb_entry->flags) &&
+		    !test_bit(DF_ISNS_DISCOVERED, &ddb_entry->flags)) {
+			/*
+			 * This triggers a relogin.  After the relogin_timer
+			 * expires, the relogin gets scheduled.  We must wait a
+			 * minimum amount of time since receiving an 0x8014 AEN
+			 * with failed device_state or a logout response before
+			 * we can issue another relogin.
+			 */
+			/* Firmware padds this timeout: (time2wait +1).
+			 * Driver retry to login should be longer than F/W.
+			 * Otherwise F/W will fail
+			 * set_ddb() mbx cmd with 0x4005 since it still
+			 * counting down its time2wait.
+			 */
+			atomic_set(&ddb_entry->relogin_timer, 0);
+			atomic_set(&ddb_entry->retry_relogin_timer,
+			    ddb_entry->default_time2wait + 4);
+		}
+	}
+
+	return QLA_SUCCESS;
+}
+
+/**************************************************************************
+ * qla4xxx_login_device
+ *	This routine is called by the login IOCTL to log in the specified
+ *	device.
+ *
+ * Input:
+ * 	ha - Pointer to host adapter structure.
+ * 	fw_ddb_index - Index of the device to login
+ * 	connection_id - Connection ID of the device to login
+ *
+ * Returns:
+ *	QLA_SUCCESS - Successfully logged in device
+ *	QLA_ERROR   - Failed to login device
+ *
+ * Context:
+ *	Kernel context.
+ **************************************************************************/
+int
+qla4xxx_login_device(scsi_qla_host_t * ha, uint16_t fw_ddb_index,
+    uint16_t connection_id)
+{
+	struct ddb_entry * ddb_entry;
+	int status = QLA_ERROR;
+
+	ddb_entry = qla4xxx_lookup_ddb_by_fw_index(ha, fw_ddb_index);
+	if (ddb_entry == NULL)
+		goto exit_login_device;
+
+	if (qla4xxx_get_fwddb_entry(ha, fw_ddb_index, NULL, 0, NULL, NULL,
+	    &ddb_entry->fw_ddb_device_state, NULL, NULL, NULL) == QLA_ERROR)
+		goto exit_login_device;
+
+	if (ddb_entry->fw_ddb_device_state == DDB_DS_SESSION_ACTIVE) {
+		status = QLA_SUCCESS;
+		goto exit_login_device;
+	}
+
+	if (qla4xxx_conn_close_sess_logout(ha, fw_ddb_index, connection_id,
+	    LOGOUT_OPTION_RELOGIN) != QLA_SUCCESS)
+		goto exit_login_device;
+
+	status = QLA_SUCCESS;
+
+exit_login_device:
+	return status;
+}
+
+/**************************************************************************
+ * qla4xxx_logout_device
+ *	This support routine is called by the logout IOCTL to log out
+ *	the specified device.
+ *
+ * Input:
+ * 	ha - Pointer to host adapter structure.
+ * 	fw_ddb_index - Index of the device to logout
+ * 	connection_id - Connection ID of the device to logout
+ *
+ * Returns:
+ *	QLA_SUCCESS - Successfully logged out device
+ *	QLA_ERROR   - Failed to logout device
+ *
+ * Context:
+ *	Kernel context.
+ **************************************************************************/
+int
+qla4xxx_logout_device(scsi_qla_host_t * ha, uint16_t fw_ddb_index,
+    uint16_t connection_id)
+{
+	int status = QLA_ERROR;
+	struct ddb_entry * ddb_entry;
+	uint32_t old_fw_ddb_device_state;
+
+	ddb_entry = qla4xxx_lookup_ddb_by_fw_index(ha, fw_ddb_index);
+	if (ddb_entry == NULL)
+		goto exit_logout_device;
+
+	if (qla4xxx_get_fwddb_entry(ha, fw_ddb_index, NULL, 0, NULL, NULL,
+	    &old_fw_ddb_device_state, NULL, NULL, NULL) != QLA_SUCCESS)
+		goto exit_logout_device;
+
+	set_bit(DF_NO_RELOGIN, &ddb_entry->flags);
+	if (qla4xxx_conn_close_sess_logout(ha, fw_ddb_index, connection_id,
+	    LOGOUT_OPTION_CLOSE_SESSION) != QLA_SUCCESS)
+		goto exit_logout_device;
+
+	status = QLA_SUCCESS;
+
+exit_logout_device:
+	return status;
+}
+
+/*
+ * qla4xxx_delete_device
+ *	This routine is called by the logout IOCTL to delete the specified
+ *      device.	 Send the LOGOUT and DELETE_DDB commands for the specified
+ *      target, even if it's not in our internal database.
+ *
+ * Input:
+ * 	ha - Pointer to host adapter structure.
+ * 	fw_ddb_index - Index of the device to delete
+ * 	connection_id - Connection ID of the device to delete
+ *
+ * Returns:
+ *	QLA_SUCCESS - Successfully deleted device
+ *	QLA_ERROR   - Failed to delete device
+ */
+int
+qla4xxx_delete_device(scsi_qla_host_t * ha, uint16_t fw_ddb_index,
+    uint16_t connection_id)
+{
+	int status = QLA_ERROR;
+	uint32_t fw_ddb_device_state = 0xFFFF;
+	u_long wait_count;
+	struct ddb_entry * ddb_entry;
+
+	/* If the device is in our internal tables, set the NO_RELOGIN bit. */
+	ddb_entry = qla4xxx_lookup_ddb_by_fw_index(ha, fw_ddb_index);
+	if (ddb_entry != NULL)
+		set_bit(DF_NO_RELOGIN, &ddb_entry->flags);
+
+	/*
+	 * If the device state is already one that we can delete, bypass the
+	 * logout command.
+	 */
+	qla4xxx_get_fwddb_entry(ha, fw_ddb_index, NULL, 0, NULL, NULL,
+	    &fw_ddb_device_state, NULL, NULL, NULL);
+	if (fw_ddb_device_state == DDB_DS_UNASSIGNED ||
+	    fw_ddb_device_state == DDB_DS_NO_CONNECTION_ACTIVE ||
+	    fw_ddb_device_state == DDB_DS_SESSION_FAILED)
+		goto delete_ddb;
+
+	/* First logout index */
+	if (qla4xxx_conn_close_sess_logout(ha, fw_ddb_index, connection_id,
+	    LOGOUT_OPTION_CLOSE_SESSION) != QLA_SUCCESS) {
+		DEBUG2(printk("scsi%ld: %s: LOGOUT_OPTION_CLOSE_SESSION "
+			"failed index [%d]\n", ha->host_no, __func__,
+			fw_ddb_index));
+		goto exit_delete_ddb;
+	}
+
+	/* Wait enough time to complete logout */
+	wait_count = jiffies + LOGOUT_TOV * HZ;
+	while (qla4xxx_get_fwddb_entry(ha, fw_ddb_index, NULL, 0, NULL, NULL,
+	    &fw_ddb_device_state, NULL, NULL, NULL) == QLA_SUCCESS) {
+		if (time_after_eq(jiffies, wait_count))
+			goto exit_delete_ddb;
+		if (fw_ddb_device_state == DDB_DS_UNASSIGNED ||
+		    fw_ddb_device_state == DDB_DS_NO_CONNECTION_ACTIVE ||
+		    fw_ddb_device_state == DDB_DS_SESSION_FAILED)
+			break;
+		udelay(50);
+	}
+
+delete_ddb:
+	/* Now delete index */
+	if (qla4xxx_clear_database_entry(ha, fw_ddb_index) == QLA_SUCCESS) {
+		status = QLA_SUCCESS;
+
+		if (!ddb_entry)
+			goto exit_delete_ddb;
+
+		atomic_set(&ddb_entry->state, DDB_STATE_DEAD);
+		DEBUG(printk("scsi%ld: %s: removing index %d.\n", ha->host_no,
+		    __func__, fw_ddb_index));
+		ha->fw_ddb_index_map[fw_ddb_index] =
+		    (struct ddb_entry *)INVALID_ENTRY;
+	}
+
+exit_delete_ddb:
+	return status;
+
+}
diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
new file mode 100644
--- /dev/null
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -0,0 +1,595 @@
+/*
+ * Copyright (c)  2003-2005 QLogic Corporation
+ * QLogic Linux iSCSI Driver
+ *
+ * This program includes a device driver for Linux 2.6 that may be
+ * distributed with QLogic hardware specific firmware binary file.
+ * You may modify and redistribute the device driver code under the
+ * GNU General Public License as published by the Free Software
+ * Foundation (version 2 or a later version) and/or under the
+ * following terms, as applicable:
+ *
+ * 	1. Redistribution of source code must retain the above
+ * 	   copyright notice, this list of conditions and the
+ * 	   following disclaimer.
+ *
+ * 	2. Redistribution in binary form must reproduce the above
+ * 	   copyright notice, this list of conditions and the
+ * 	   following disclaimer in the documentation and/or other
+ * 	   materials provided with the distribution.
+ *
+ * 	3. The name of QLogic Corporation may not be used to
+ * 	   endorse or promote products derived from this software
+ * 	   without specific prior written permission.
+ *
+ * You may redistribute the hardware specific firmware binary file
+ * under the following terms:
+ *
+ * 	1. Redistribution of source code (only if applicable),
+ * 	   must retain the above copyright notice, this list of
+ * 	   conditions and the following disclaimer.
+ *
+ * 	2. Redistribution in binary form must reproduce the above
+ * 	   copyright notice, this list of conditions and the
+ * 	   following disclaimer in the documentation and/or other
+ * 	   materials provided with the distribution.
+ *
+ * 	3. The name of QLogic Corporation may not be used to
+ * 	   endorse or promote products derived from this software
+ * 	   without specific prior written permission
+ *
+ * REGARDLESS OF WHAT LICENSING MECHANISM IS USED OR APPLICABLE,
+ * THIS PROGRAM IS PROVIDED BY QLOGIC CORPORATION "AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
+ * PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR
+ * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
+ * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
+ * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
+ * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGE.
+ *
+ * USER ACKNOWLEDGES AND AGREES THAT USE OF THIS PROGRAM WILL NOT
+ * CREATE OR GIVE GROUNDS FOR A LICENSE BY IMPLICATION, ESTOPPEL, OR
+ * OTHERWISE IN ANY INTELLECTUAL PROPERTY RIGHTS (PATENT, COPYRIGHT,
+ * TRADE SECRET, MASK WORK, OR OTHER PROPRIETARY RIGHT) EMBODIED IN
+ * ANY OTHER QLOGIC HARDWARE OR SOFTWARE EITHER SOLELY OR IN
+ * COMBINATION WITH THIS PROGRAM.
+ */
+
+#include "ql4_def.h"
+
+#include <scsi/scsi_tcq.h>
+
+/**************************************************************************
+ * qla4xxx_get_req_pkt
+ *	This routine performs the following tasks:
+ *	- returns the current request_in pointer (if queue not full)
+ *	- advances the request_in pointer
+ *	- checks for queue full
+ *
+ * Input:
+ * 	ha - Pointer to host adapter structure.
+ *	queue_entry - Pointer to pointer to queue entry structure
+ *
+ * Output:
+ *	queue_entry - Return pointer to next available request packet
+ *
+ * Returns:
+ *	QLA_SUCCESS - Successfully retrieved request packet
+ *	QLA_ERROR   - Failed to retrieve request packet
+ *
+ * Context:
+ *	Kernel context.
+ **************************************************************************/
+int
+qla4xxx_get_req_pkt(scsi_qla_host_t *ha, QUEUE_ENTRY **queue_entry)
+{
+	uint16_t request_in;
+	uint8_t status = QLA_SUCCESS;
+
+	*queue_entry = ha->request_ptr;
+
+	/* get the latest request_in and request_out index */
+	request_in = ha->request_in;
+	ha->request_out = (uint16_t) le32_to_cpu(ha->shadow_regs->req_q_out);
+
+	/* Advance request queue pointer and check for queue full */
+	if (request_in == (REQUEST_QUEUE_DEPTH - 1)) {
+		request_in = 0;
+		ha->request_ptr = ha->request_ring;
+	} else {
+		request_in++;
+		ha->request_ptr++;
+	}
+
+	/* request queue is full, try again later */
+	if ((ha->iocb_cnt + 1) >= ha->iocb_hiwat) {
+		/* restore request pointer */
+		ha->request_ptr = *queue_entry;
+		status = QLA_ERROR;
+	} else {
+		ha->request_in = request_in;
+		memset(*queue_entry, 0, sizeof(**queue_entry));
+	}
+
+	return status;
+}
+
+/**************************************************************************
+ * qla4xxx_send_marker_iocb
+ *	This routine issues a marker IOCB.
+ *
+ * Input:
+ * 	ha - Pointer to host adapter structure.
+ *	ddb_entry - Pointer to device database entry
+ *	lun - SCSI LUN
+ *	marker_type - marker identifier
+ *
+ * Returns:
+ *	QLA_SUCCESS - Successfully sent marker IOCB
+ *	QLA_ERROR   - Failed to send marker IOCB
+ *
+ * Context:
+ *	Kernel context.
+ **************************************************************************/
+int
+qla4xxx_send_marker_iocb(scsi_qla_host_t *ha, ddb_entry_t *ddb_entry, int lun)
+{
+	MARKER_ENTRY *marker_entry;
+	unsigned long flags = 0;
+	uint8_t status = QLA_SUCCESS;
+
+	/* Acquire hardware specific lock */
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+
+	/* Get pointer to the queue entry for the marker */
+	if (qla4xxx_get_req_pkt(ha, (QUEUE_ENTRY **) &marker_entry) !=
+	    QLA_SUCCESS) {
+		status = QLA_ERROR;
+		goto exit_send_marker;
+	}
+
+	/* Put the marker in the request queue */
+	marker_entry->hdr.entryType = ET_MARKER;
+	marker_entry->hdr.entryCount = 1;
+	marker_entry->target = cpu_to_le16(ddb_entry->fw_ddb_index);
+	marker_entry->modifier = cpu_to_le16(MM_LUN_RESET);
+	marker_entry->lun[1] = LSB(lun);	/*SAMII compliant lun */
+	marker_entry->lun[2] = MSB(lun);
+	wmb();
+
+	/* Tell ISP it's got a new I/O request */
+	WRT_REG_DWORD(&ha->reg->req_q_in, ha->request_in);
+	PCI_POSTING(&ha->reg->req_q_in);
+
+exit_send_marker:
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	return status;
+}
+
+PDU_ENTRY *
+qla4xxx_get_pdu(scsi_qla_host_t * ha, uint32_t length)
+{
+	PDU_ENTRY *pdu;
+	PDU_ENTRY *free_pdu_top;
+	PDU_ENTRY *free_pdu_bottom;
+	uint16_t pdu_active;
+
+	if (ha->free_pdu_top == NULL)
+		return NULL;
+
+	/* Save current state */
+	free_pdu_top = ha->free_pdu_top;
+	free_pdu_bottom = ha->free_pdu_bottom;
+	pdu_active = ha->pdu_active + 1;
+
+	/* get next available pdu */
+	pdu = free_pdu_top;
+	free_pdu_top = pdu->Next;
+	if (free_pdu_top == NULL)
+		free_pdu_bottom = NULL;
+
+	/* round up to nearest page */
+	length = (length + (PAGE_SIZE - 1)) & ~(PAGE_SIZE - 1);
+
+	/* Allocate pdu buffer PDU */
+	pdu->Buff = dma_alloc_coherent(&ha->pdev->dev, length, &pdu->DmaBuff,
+	    GFP_KERNEL);
+	if (pdu->Buff == NULL)
+		return NULL;
+
+	memset(pdu->Buff, 0, length);
+
+	/* Fill in remainder of PDU */
+	pdu->BuffLen = length;
+	pdu->SendBuffLen = 0;
+	pdu->RecvBuffLen = 0;
+	pdu->Next = NULL;
+	ha->free_pdu_top = free_pdu_top;
+	ha->free_pdu_bottom = free_pdu_bottom;
+	ha->pdu_active = pdu_active;
+	return pdu;
+}
+
+void
+qla4xxx_free_pdu(scsi_qla_host_t * ha, PDU_ENTRY * pdu)
+{
+	if (ha->free_pdu_bottom == NULL) {
+		ha->free_pdu_top = pdu;
+		ha->free_pdu_bottom = pdu;
+	} else {
+		ha->free_pdu_bottom->Next = pdu;
+		ha->free_pdu_bottom = pdu;
+	}
+	dma_free_coherent(&ha->pdev->dev, pdu->BuffLen, pdu->Buff,
+	    pdu->DmaBuff);
+	ha->pdu_active--;
+
+	/* Clear PDU */
+	pdu->Buff = NULL;
+	pdu->BuffLen = 0;
+	pdu->SendBuffLen = 0;
+	pdu->RecvBuffLen = 0;
+	pdu->Next = NULL;
+	pdu->DmaBuff = 0;
+}
+
+/**************************************************************************
+ * qla4xxx_send_passthru0_iocb
+ *	This routine issues a passthru0 IOCB.
+ *
+ * Input:
+ * 	ha - Pointer to host adapter structure.
+ *
+ * Remarks: hardware_lock acquired upon entry, interrupt context
+ *
+ * Returns:
+ *	QLA_SUCCESS - Successfully sent marker IOCB
+ *	QLA_ERROR   - Failed to send marker IOCB
+ *
+ * Context:
+ *	Kernel context.
+ **************************************************************************/
+int
+qla4xxx_send_passthru0_iocb(scsi_qla_host_t * ha, uint16_t fw_ddb_index,
+    uint16_t connection_id, dma_addr_t pdu_dma_data, uint32_t send_len,
+    uint32_t recv_len, uint16_t control_flags, uint32_t handle)
+{
+	PASSTHRU0_ENTRY *passthru_entry;
+	uint8_t status = QLA_SUCCESS;
+
+	/* Get pointer to the queue entry for the marker */
+	if (qla4xxx_get_req_pkt(ha, (QUEUE_ENTRY **) &passthru_entry) !=
+	    QLA_SUCCESS) {
+		status = QLA_ERROR;
+		goto exit_send_pt0;
+	}
+
+	/* Fill in the request queue */
+	passthru_entry->hdr.entryType = ET_PASSTHRU0;
+	passthru_entry->hdr.entryCount = 1;
+	passthru_entry->handle = cpu_to_le32(handle);
+	passthru_entry->target = cpu_to_le16(fw_ddb_index);
+	passthru_entry->connectionID = cpu_to_le16(connection_id);
+	passthru_entry->timeout = __constant_cpu_to_le16(PT_DEFAULT_TIMEOUT);
+	if (send_len) {
+		control_flags |= PT_FLAG_SEND_BUFFER;
+		passthru_entry->outDataSeg64.base.addrHigh =
+		    cpu_to_le32(MSDW(pdu_dma_data));
+		passthru_entry->outDataSeg64.base.addrLow =
+		    cpu_to_le32(LSDW(pdu_dma_data));
+		passthru_entry->outDataSeg64.count = cpu_to_le32(send_len);
+	}
+	if (recv_len) {
+		passthru_entry->inDataSeg64.base.addrHigh =
+		    cpu_to_le32(MSDW(pdu_dma_data));
+		passthru_entry->inDataSeg64.base.addrLow =
+		    cpu_to_le32(LSDW(pdu_dma_data));
+		passthru_entry->inDataSeg64.count = cpu_to_le32(recv_len);
+	}
+	passthru_entry->controlFlags = cpu_to_le16(control_flags);
+	wmb();
+
+	/* Tell ISP it's got a new I/O request */
+	WRT_REG_DWORD(&ha->reg->req_q_in, ha->request_in);
+	PCI_POSTING(&ha->reg->req_q_in);
+
+exit_send_pt0:
+	return status;
+}
+
+CONTINUE_ENTRY *
+qla4xxx_alloc_cont_entry(scsi_qla_host_t * ha)
+{
+	CONTINUE_ENTRY *cont_entry;
+
+	cont_entry = (CONTINUE_ENTRY *)ha->request_ptr;
+
+	/* Advance request queue pointer */
+	if (ha->request_in == (REQUEST_QUEUE_DEPTH - 1)) {
+		ha->request_in = 0;
+		ha->request_ptr = ha->request_ring;
+	} else {
+		ha->request_in++;
+		ha->request_ptr++;
+	}
+
+	/* Load packet defaults */
+	cont_entry->hdr.entryType = ET_CONTINUE;
+	cont_entry->hdr.entryCount = 1;
+	cont_entry->hdr.systemDefined = (uint8_t) cpu_to_le16(ha->request_in);
+
+	return cont_entry;
+}
+
+uint16_t
+qla4xxx_calc_request_entries(uint16_t dsds)
+{
+	uint16_t iocbs;
+
+	iocbs = 1;
+	if (dsds > COMMAND_SEG) {
+		iocbs += (dsds - COMMAND_SEG) / CONTINUE_SEG;
+		if ((dsds - COMMAND_SEG) % CONTINUE_SEG)
+			iocbs++;
+	}
+	return iocbs;
+}
+
+void
+qla4xxx_build_scsi_iocbs(srb_t *srb, COMMAND_ENTRY *cmd_entry,
+    uint16_t tot_dsds)
+{
+	scsi_qla_host_t *ha;
+	uint16_t avail_dsds;
+	DATA_SEG_A64 *cur_dsd;
+	struct scsi_cmnd *cmd;
+
+	cmd = srb->cmd;
+	ha = srb->ha;
+
+	if (cmd->request_bufflen == 0 || cmd->sc_data_direction == DMA_NONE) {
+		/* No data being transferred */
+		cmd_entry->ttlByteCnt = __constant_cpu_to_le32(0);
+		return;
+	}
+
+	avail_dsds = COMMAND_SEG;
+	cur_dsd = (DATA_SEG_A64 *) & (cmd_entry->dataseg[0]);
+
+	/* Load data segments */
+	if (cmd->use_sg) {
+		struct scatterlist *cur_seg;
+		struct scatterlist *end_seg;
+
+		cur_seg = (struct scatterlist *)cmd->request_buffer;
+		end_seg = cur_seg + tot_dsds;
+		while (cur_seg < end_seg) {
+			dma_addr_t sle_dma;
+
+			/* Allocate additional continuation packets? */
+			if (avail_dsds == 0) {
+				CONTINUE_ENTRY *cont_entry;
+
+				cont_entry = qla4xxx_alloc_cont_entry(ha);
+				cur_dsd =
+				    (DATA_SEG_A64 *) &cont_entry->dataseg[0];
+				avail_dsds = CONTINUE_SEG;
+			}
+
+			sle_dma = sg_dma_address(cur_seg);
+			cur_dsd->base.addrLow = cpu_to_le32(LSDW(sle_dma));
+			cur_dsd->base.addrHigh = cpu_to_le32(MSDW(sle_dma));
+			cur_dsd->count = cpu_to_le32(sg_dma_len(cur_seg));
+			avail_dsds--;
+
+			cur_dsd++;
+			cur_seg++;
+		}
+	} else {
+		cur_dsd->base.addrLow = cpu_to_le32(LSDW(srb->dma_handle));
+		cur_dsd->base.addrHigh = cpu_to_le32(MSDW(srb->dma_handle));
+		cur_dsd->count = cpu_to_le32(cmd->request_bufflen);
+	}
+}
+
+/**************************************************************************
+ * qla4xxx_send_command_to_isp
+ *      This routine is called by qla4xxx_queuecommand to build an ISP
+ *      command and pass it to the ISP for execution.
+ *
+ * Input:
+ *      ha - Pointer to host adapter structure.
+ *      srb - pointer to SCSI Request Block to be sent to ISP
+ *
+ * Output:
+ *      None
+ *
+ * Remarks:
+ *      None
+ *
+ * Returns:
+ *      QLA_SUCCESS - Successfully sent command to ISP
+ *      QLA_ERROR   - Failed to send command to ISP
+ *
+ * Context:
+ *      Kernel context.
+ **************************************************************************/
+int
+qla4xxx_send_command_to_isp(scsi_qla_host_t *ha, srb_t * srb)
+{
+	struct scsi_cmnd *cmd = srb->cmd;
+	ddb_entry_t *ddb_entry;
+	COMMAND_ENTRY *cmd_entry;
+	struct scatterlist *sg;
+
+	uint16_t tot_dsds;
+	uint16_t req_cnt;
+
+	unsigned long flags;
+	uint16_t cnt;
+	uint16_t i;
+	uint32_t index;
+	char tag[2];
+
+	/* Get real lun and adapter */
+	ddb_entry = srb->ddb;
+
+	/* Send marker(s) if needed. */
+	if (ha->marker_needed == 1) {
+		if (qla4xxx_send_marker_iocb(ha, ddb_entry, cmd->device->lun) !=
+		    QLA_SUCCESS) {
+			return QLA_ERROR;
+		}
+		ha->marker_needed = 0;
+	}
+	tot_dsds = 0;
+
+	/* Acquire hardware specific lock */
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+
+	/* Check for room in active srb array */
+	index = ha->current_active_index;
+	for (i = 0; i < MAX_SRBS; i++) {
+		index++;
+		if (index == MAX_SRBS)
+			index = 1;
+		if (ha->active_srb_array[index] == 0) {
+			ha->current_active_index = index;
+			break;
+		}
+	}
+	if (i >= MAX_SRBS) {
+		printk(KERN_INFO "scsi%ld: %s: NO more SRB entries used "
+		    "iocbs=%d, \n reqs remaining=%d\n", ha->host_no, __func__,
+		    ha->iocb_cnt, ha->req_q_count);
+		goto queuing_error;
+	}
+
+	/* Calculate the number of request entries needed. */
+	if (cmd->use_sg) {
+		sg = (struct scatterlist *)cmd->request_buffer;
+		tot_dsds = pci_map_sg(ha->pdev, sg, cmd->use_sg,
+				      cmd->sc_data_direction);
+		if (tot_dsds == 0)
+			goto queuing_error;
+	} else if (cmd->request_bufflen) {
+		dma_addr_t      req_dma;
+
+		req_dma = pci_map_single(ha->pdev, cmd->request_buffer,
+		    cmd->request_bufflen, cmd->sc_data_direction);
+		if (dma_mapping_error(req_dma))
+			goto queuing_error;
+
+		srb->dma_handle = req_dma;
+		tot_dsds = 1;
+	}
+	req_cnt = qla4xxx_calc_request_entries(tot_dsds);
+
+	if (ha->req_q_count < (req_cnt + 2)) {
+		cnt = (uint16_t) le32_to_cpu(ha->shadow_regs->req_q_out);
+		if (ha->request_in < cnt)
+			ha->req_q_count = cnt - ha->request_in;
+		else
+			ha->req_q_count = REQUEST_QUEUE_DEPTH -
+			    (ha->request_in - cnt);
+	}
+
+	if (ha->req_q_count < (req_cnt + 2))
+		goto queuing_error;
+
+	/* total iocbs active */
+	if ((ha->iocb_cnt + req_cnt) >= REQUEST_QUEUE_DEPTH)
+		goto queuing_error;
+
+	/* Build command packet */
+	cmd_entry = (COMMAND_ENTRY *) ha->request_ptr;
+	cmd_entry->hdr.entryType = ET_COMMAND;
+	cmd_entry->handle = cpu_to_le32(index);
+	cmd_entry->target = cpu_to_le16(ddb_entry->fw_ddb_index);
+	cmd_entry->connection_id = cpu_to_le16(ddb_entry->connection_id);
+
+	cmd_entry->lun[1] = LSB(cmd->device->lun);	/* SAMII compliant. */
+	cmd_entry->lun[2] = MSB(cmd->device->lun);
+	cmd_entry->cmdSeqNum = cpu_to_le32(ddb_entry->CmdSn);
+	cmd_entry->ttlByteCnt = cpu_to_le32(cmd->request_bufflen);
+	memcpy(cmd_entry->cdb, cmd->cmnd, min((unsigned char)MAX_COMMAND_SIZE,
+	    cmd->cmd_len));
+	cmd_entry->dataSegCnt = cpu_to_le16(tot_dsds);
+	cmd_entry->hdr.entryCount = req_cnt;
+
+	/* Set data transfer direction control flags
+	 * NOTE: Look at data_direction bits iff there is data to be
+	 *       transferred, as the data direction bit is sometimed filled
+	 *       in when there is no data to be transferred */
+	cmd_entry->control_flags = CF_NO_DATA;
+	if (cmd->request_bufflen) {
+		if (cmd->sc_data_direction == DMA_TO_DEVICE)
+			cmd_entry->control_flags = CF_WRITE;
+		else if (cmd->sc_data_direction == DMA_FROM_DEVICE)
+			cmd_entry->control_flags = CF_READ;
+	}
+
+	/* Set tagged queueing control flags */
+	cmd_entry->control_flags |= CF_SIMPLE_TAG;
+	if (scsi_populate_tag_msg(cmd, tag)) {
+		switch (tag[0]) {
+		case MSG_HEAD_TAG:
+			cmd_entry->control_flags |= CF_HEAD_TAG;
+			break;
+		case MSG_ORDERED_TAG:
+			cmd_entry->control_flags |= CF_ORDERED_TAG;
+			break;
+		}
+	}
+
+	/* Advance request queue pointer */
+	ha->request_in++;
+	if (ha->request_in == REQUEST_QUEUE_DEPTH) {
+		ha->request_in = 0;
+		ha->request_ptr = ha->request_ring;
+	} else {
+		ha->request_ptr++;
+	}
+
+	qla4xxx_build_scsi_iocbs(srb, cmd_entry, tot_dsds);
+	wmb();
+
+	/* put command in active array */
+	ha->active_srb_array[index] = srb;
+	srb->cmd->host_scribble = (unsigned char *)(unsigned long)index;
+	//srb->active_array_index = index;
+
+	/* update counters */
+	ha->active_srb_count++;
+	srb->state = SRB_ACTIVE_STATE;
+	srb->flags |= SRB_DMA_VALID;
+
+	/* Track IOCB used */
+	ha->iocb_cnt += req_cnt;
+	srb->iocb_cnt = req_cnt;
+	ha->req_q_count -= req_cnt;
+
+	/* Debug print statements */
+	WRT_REG_DWORD(&ha->reg->req_q_in, ha->request_in);
+	PCI_POSTING(&ha->reg->req_q_in);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	return QLA_SUCCESS;
+
+queuing_error:
+	if (cmd->use_sg && tot_dsds) {
+		sg = (struct scatterlist *) cmd->request_buffer;
+		pci_unmap_sg(ha->pdev, sg, cmd->use_sg, cmd->sc_data_direction);
+	} else if (tot_dsds) {
+		pci_unmap_single(ha->pdev, srb->dma_handle,
+		    cmd->request_bufflen, cmd->sc_data_direction);
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	return QLA_ERROR;
+}

-- 
Andrew Vasquez
