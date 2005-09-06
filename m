From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 4/8]  qla4xxx: iSNS routines
Date: Tue,  6 Sep 2005 15:09:21 -0700 (PDT)
Message-ID: <20050906220921.11409.71330.sendpatchset@plap.qlogic.com>
References: <20050906220841.11409.88669.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:37277 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751021AbVIFWJW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2005 18:09:22 -0400
In-Reply-To: <20050906220841.11409.88669.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

ISP4xxx driver iSNS routines and definitions.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla4xxx/ql4_isns.c | 2223 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_isns.h |  401 +++++++
 2 files changed, 2624 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/qla4xxx/ql4_isns.c
 create mode 100644 drivers/scsi/qla4xxx/ql4_isns.h

bf2f290d5776f4e883e67aed7fd928d35352fe72
diff --git a/drivers/scsi/qla4xxx/ql4_isns.c b/drivers/scsi/qla4xxx/ql4_isns.c
new file mode 100644
--- /dev/null
+++ b/drivers/scsi/qla4xxx/ql4_isns.c
@@ -0,0 +1,2223 @@
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
+void qla4xxx_isns_enable_callback(scsi_qla_host_t *, uint32_t, uint32_t,
+				  uint32_t, uint32_t);
+
+int qla4xxx_isns_restart_service(scsi_qla_host_t *);
+uint32_t qla4xxx_isns_build_iocb_handle(scsi_qla_host_t *, uint32_t,
+					PDU_ENTRY *);
+int qla4xxx_isns_get_server_request(scsi_qla_host_t *, uint32_t, uint16_t);
+int qla4xxx_isns_reassemble_pdu(scsi_qla_host_t *, uint8_t *, uint32_t *);
+int qla4xxx_isns_parse_and_dispatch_server_request(scsi_qla_host_t *,
+						       uint8_t *, uint32_t,
+						       uint16_t);
+int qla4xxx_isns_parse_and_dispatch_server_response(scsi_qla_host_t *,
+							uint8_t *, uint32_t);
+int qla4xxx_isns_build_scn_registration_packet(scsi_qla_host_t * ha,
+						   uint8_t * buffer,
+						   uint32_t buffer_size,
+						   uint32_t * packet_size);
+int qla4xxx_isns_build_scn_deregistration_packet(scsi_qla_host_t * ha,
+						     uint8_t * buffer,
+						     uint32_t buffer_size,
+						     uint32_t * packet_size);
+int qla4xxx_isns_build_registration_packet(scsi_qla_host_t * ha,
+					       uint8_t * buff,
+					       uint32_t buff_size,
+					       uint8_t * isns_entity_id,
+					       uint8_t * ip_addr,
+					       uint32_t port_number,
+					       uint32_t scn_port,
+					       uint32_t esi_port,
+					       uint8_t * local_alias,
+					       uint32_t * packet_size);
+int qla4xxx_isns_build_deregistration_packet(scsi_qla_host_t * ha,
+						 uint8_t * buff,
+						 uint32_t buff_size,
+						 uint8_t * isns_entity_id,
+						 uint8_t * ip_addr,
+						 uint32_t port_number,
+						 uint32_t * packet_size);
+int qla4xxx_isns_build_request_packet(scsi_qla_host_t * ha,
+					  uint8_t * buff, uint32_t buff_size,
+					  uint16_t function_id,
+					  uint16_t tx_id,
+					  uint8_t use_replace_flag,
+					  ATTRIBUTE_LIST * attr_list,
+					  uint32_t * packet_size);
+int qla4xxx_isns_append_attribute(scsi_qla_host_t * ha, uint8_t ** buffer,
+				      uint8_t * buffer_end,
+				      ATTRIBUTE_LIST * attr_list);
+int qla4xxx_isns_dev_attr_reg(scsi_qla_host_t *);
+int qla4xxx_isns_dev_attr_reg_rsp(scsi_qla_host_t * ha, uint8_t * buffer,
+				      uint32_t buffer_size);
+int qla4xxx_isns_dev_attr_qry_rsp(scsi_qla_host_t * ha, uint8_t * buffer,
+				      uint32_t buffer_size);
+int qla4xxx_isns_dev_get_next_rsp(scsi_qla_host_t * ha, uint8_t * buffer,
+				      uint32_t buffer_size);
+int qla4xxx_isns_dev_dereg_rsp(scsi_qla_host_t * ha, uint8_t * buffer,
+				   uint32_t buffer_size);
+int qla4xxx_isns_scn_reg_rsp(scsi_qla_host_t * ha, uint8_t * buffer,
+				 uint32_t buffer_size);
+int qla4xxx_isns_scn_dereg_rsp(scsi_qla_host_t * ha, uint8_t * buffer,
+				   uint32_t buffer_size);
+int qla4xxx_isns_scn_dereg(scsi_qla_host_t *);
+int qla4xxx_isns_scn_reg(scsi_qla_host_t * ha);
+int qla4xxx_isns_dev_get_next(scsi_qla_host_t * ha,
+				  uint8_t * last_iscsi_name);
+
+const char *isns_error_code_msg[] = ISNS_ERROR_CODE_TBL();
+
+static void
+qla4xxx_strtolower(uint8_t *str)
+{
+	uint8_t *tmp;
+
+	for (tmp = str; *tmp != '\0'; tmp++)
+		if (*tmp >= 'A' && *tmp <= 'Z')
+			*tmp += 'a' - 'A';
+}
+
+void
+qla4xxx_isns_build_entity_id(scsi_qla_host_t *ha)
+{
+	sprintf(ha->isns_entity_id, "%s.%d", ha->serial_number,
+	    ha->function_number);
+	qla4xxx_strtolower(ha->isns_entity_id);
+}
+
+int
+qla4xxx_isns_reenable(scsi_qla_host_t *ha, uint32_t isns_ip_addr,
+    uint16_t isns_server_port_num)
+{
+	set_bit(ISNS_FLAG_REREGISTER, &ha->isns_flags);
+	ISNS_CLEAR_FLAGS(ha);
+	if (qla4xxx_isns_enable(ha, isns_ip_addr, isns_server_port_num) !=
+	    QLA_SUCCESS) {
+		DEBUG5(printk("scsi%ld: %s: Failed!\n", ha->host_no,
+		    __func__));
+		return QLA_ERROR;
+	}
+	return QLA_SUCCESS;
+}
+
+/* interrupt context, hardware lock set */
+void
+qla4xxx_isns_enable_callback(scsi_qla_host_t *ha, uint32_t svr, uint32_t scn,
+    uint32_t esi, uint32_t nsh)
+{
+	ha->isns_connection_id = (uint16_t) svr & 0x0000FFFF;
+	ha->isns_scn_conn_id = (uint16_t) scn & 0x0000FFFF;
+	ha->isns_esi_conn_id = (uint16_t) esi & 0x0000FFFF;
+	ha->isns_nsh_conn_id = (uint16_t) nsh & 0x0000FFFF;
+	ha->isns_remote_port_num = (uint16_t) (svr >> 16);
+	ha->isns_scn_port_num = (uint16_t) (scn >> 16);
+	ha->isns_esi_port_num = (uint16_t) (esi >> 16);
+	ha->isns_nsh_port_num = (uint16_t) (nsh >> 16);
+	DEBUG5(printk("scsi%ld: %s: iSNS Server TCP Connect "
+	    "succeeded %d\n", ha->host_no, __func__, svr));
+	DEBUG5(printk("scsi%ld: %s: Remote iSNS Server %d ConnID %x\n",
+	    ha->host_no, __func__, ha->isns_remote_port_num,
+	    ha->isns_connection_id));
+	DEBUG5(printk("scsi%ld: %s: Local  SCN  Listen %d ConnID %x\n",
+	    ha->host_no, __func__, ha->isns_scn_port_num,
+	    ha->isns_scn_conn_id));
+	DEBUG5(printk("scsi%ld: %s: Local  ESI  Listen %d ConnID %x\n",
+	    ha->host_no, __func__, ha->isns_esi_port_num,
+	    ha->isns_esi_conn_id));
+	DEBUG5(printk("scsi%ld: %s: Local  HSN  Listen %d ConnID %x\n",
+	    ha->host_no, __func__, ha->isns_nsh_port_num,
+	    ha->isns_nsh_conn_id));
+	if (ha->isns_connection_id == (uint16_t) - 1) {
+		DEBUG2(printk("scsi%ld: %s: iSNS server refused connection\n",
+		    ha->host_no, __func__));
+		qla4xxx_isns_restart_service(ha);
+		return;
+	}
+	set_bit(ISNS_FLAG_ISNS_SRV_ENABLED, &ha->isns_flags);
+	if (test_bit(ISNS_FLAG_REREGISTER, &ha->isns_flags)) {
+		if (qla4xxx_isns_scn_dereg(ha) != QLA_SUCCESS) {
+			DEBUG2(printk("scsi%ld: %s: qla4xxx_isns_scn_dereg "
+			    "failed!\n", ha->host_no, __func__));
+			return;
+		}
+	} else {
+		if (qla4xxx_isns_dev_attr_reg(ha) != QLA_SUCCESS) {
+			DEBUG2(printk("scsi%ld: %s: qla4xxx_isns_dev_attr_reg "
+			    "failed!\n", ha->host_no, __func__));
+			return;
+		}
+	}
+}
+
+int
+qla4xxx_isns_restart_service(scsi_qla_host_t *ha)
+{
+	qla4xxx_isns_disable(ha);
+	set_bit(ISNS_FLAG_RESTART_SERVICE, &ha->isns_flags);
+	ISNS_CLEAR_FLAGS(ha);
+
+	/* Set timer for restart to complete */
+	atomic_set(&ha->isns_restart_timer, ISNS_RESTART_TOV);
+	return QLA_SUCCESS;
+}
+
+int
+qla4xxx_isns_restart_service_completion(scsi_qla_host_t *ha,
+    uint32_t isns_ip_addr, uint16_t isns_server_port_num)
+{
+	DEBUG5(printk("scsi%ld: %s: isns_ip_addr %08x\n", ha->host_no,
+	    __func__, isns_ip_addr));
+	if (qla4xxx_isns_enable(ha, isns_ip_addr, isns_server_port_num) !=
+	    QLA_SUCCESS) {
+		DEBUG5(printk("scsi%ld: %s: failed!\n", ha->host_no,
+		    __func__));
+		return QLA_ERROR;
+	} else {
+		set_bit(ISNS_FLAG_REREGISTER, &ha->isns_flags);
+		ISNS_CLEAR_FLAGS(ha);
+		return QLA_SUCCESS;
+	}
+}
+
+static void
+qla4xxx_isns_init_isns_reg_attr_list(scsi_qla_host_t *ha)
+{
+	ATTRIBUTE_LIST isns_reg_attr_list[] = {
+
+		/* Source attribute */
+		{ ISNS_ATTR_TAG_ISCSI_NAME, ISNS_ATTR_TYPE_STRING,
+			(unsigned long)ha->name_string },
+		{ ISNS_ATTR_TAG_ENTITY_IDENTIFIER, ISNS_ATTR_TYPE_STRING, -1 },
+
+		/* Entity ID. */
+		{ ISNS_ATTR_TAG_DELIMITER, ISNS_ATTR_TYPE_EMPTY, 0 },
+
+		/* Operating attributes to register */
+		{ ISNS_ATTR_TAG_ENTITY_IDENTIFIER, ISNS_ATTR_TYPE_STRING, -1},
+		{ ISNS_ATTR_TAG_ENTITY_PROTOCOL, ISNS_ATTR_TYPE_ULONG,
+			cpu_to_be32(ENTITY_PROTOCOL_ISCSI)},
+		{ ISNS_ATTR_TAG_PORTAL_IP_ADDRESS, ISNS_ATTR_TYPE_ADDRESS, -1 },
+		{ ISNS_ATTR_TAG_PORTAL_PORT, ISNS_ATTR_TYPE_ULONG, -1},
+		{ ISNS_ATTR_TAG_SCN_PORT, ISNS_ATTR_TYPE_ULONG, -1},
+		{ ISNS_ATTR_TAG_ESI_PORT, ISNS_ATTR_TYPE_ULONG, -1},
+		{ ISNS_ATTR_TAG_ISCSI_NAME, ISNS_ATTR_TYPE_STRING,
+			(unsigned long)ha->name_string},
+		{ ISNS_ATTR_TAG_ISCSI_NODE_TYPE, ISNS_ATTR_TYPE_ULONG,
+			cpu_to_be32(ISCSI_NODE_TYPE_INITIATOR) },
+		{ ISNS_ATTR_TAG_ISCSI_ALIAS, ISNS_ATTR_TYPE_STRING, -1},
+
+		/* Friendly machine name? */
+		{ 0, 0, 0 },
+	};
+
+	memcpy(ha->isns_reg_attr_list, isns_reg_attr_list,
+	    sizeof(isns_reg_attr_list));
+}
+
+static void
+qla4xxx_isns_init_isns_dereg_attr_list(scsi_qla_host_t *ha)
+{
+	ATTRIBUTE_LIST isns_dereg_attr_list[] = {
+
+		/* Source attribute */
+		{ ISNS_ATTR_TAG_ISCSI_NAME, ISNS_ATTR_TYPE_STRING,
+			(unsigned long)ha->name_string},
+
+		/* No key attribute for DevDereg */
+		{ ISNS_ATTR_TAG_DELIMITER, ISNS_ATTR_TYPE_EMPTY, 0 },
+
+		/* Operating attributes */
+		{ ISNS_ATTR_TAG_ENTITY_IDENTIFIER, ISNS_ATTR_TYPE_STRING, -1 },
+
+		/* FQDN */
+#if 0
+		{ ISNS_ATTR_TAG_PORTAL_IP_ADDRESS, ISNS_ATTR_TYPE_ADDRESS, -1 },
+		{ ISNS_ATTR_TAG_PORTAL_PORT, ISNS_ATTR_TYPE_ULONG, -1 },
+		{ ISNS_ATTR_TAG_ISCSI_NAME, ISNS_ATTR_TYPE_STRING,
+			(unsigned long)ha->name_string },
+#endif
+		{ 0, 0, 0 },
+	};
+
+	memcpy(ha->isns_dereg_attr_list, isns_dereg_attr_list,
+	    sizeof(isns_dereg_attr_list));
+}
+
+static void
+qla4xxx_isns_init_isns_scn_reg_attr_list(scsi_qla_host_t * ha)
+{
+	ATTRIBUTE_LIST isns_scn_reg_attr_list[] = {
+
+		/* Source attribute */
+		{ ISNS_ATTR_TAG_ISCSI_NAME, ISNS_ATTR_TYPE_STRING,
+			(unsigned long)ha->name_string },
+
+		/* Key attributes */
+		{ ISNS_ATTR_TAG_ISCSI_NAME, ISNS_ATTR_TYPE_STRING,
+			(unsigned long)ha->name_string },
+
+		/*
+		 * Required delimiter to indicate division between key and
+		 * operating attrs.
+		 */
+		{ ISNS_ATTR_TAG_DELIMITER, ISNS_ATTR_TYPE_EMPTY, 0 },
+
+		/* Operating attributes */
+		{ ISNS_ATTR_TAG_ISCSI_SCN_BITMAP, ISNS_ATTR_TYPE_ULONG,
+			cpu_to_be32(ISCSI_SCN_OBJECT_UPDATED |
+					ISCSI_SCN_OBJECT_ADDED |
+					ISCSI_SCN_OBJECT_REMOVED |
+					ISCSI_SCN_TARGET_AND_SELF_INFO_ONLY) },
+		{ 0, 0, 0 },
+	};
+
+	memcpy(ha->isns_scn_reg_attr_list, isns_scn_reg_attr_list,
+	    sizeof(isns_scn_reg_attr_list));
+}
+
+static void
+qla4xxx_isns_init_isns_scn_dereg_attr_list(scsi_qla_host_t *ha)
+{
+	ATTRIBUTE_LIST isns_scn_dereg_attr_list[] = {
+
+		/* Source attribute */
+		{ ISNS_ATTR_TAG_ISCSI_NAME, ISNS_ATTR_TYPE_STRING,
+			(unsigned long)ha->name_string },
+
+		/* Key attributes */
+		{ ISNS_ATTR_TAG_ISCSI_NAME, ISNS_ATTR_TYPE_STRING,
+			(unsigned long)ha->name_string },
+
+		{ 0, 0, 0 },
+	};
+
+	memcpy(ha->isns_scn_dereg_attr_list, isns_scn_dereg_attr_list,
+	    sizeof(isns_scn_dereg_attr_list));
+}
+
+static void
+qla4xxx_isns_init_isns_dev_get_next_attr_list(scsi_qla_host_t *ha)
+{
+	ATTRIBUTE_LIST isns_dev_get_next_attr_list[] = {
+
+		/* Source attribute */
+		{ ISNS_ATTR_TAG_ISCSI_NAME, ISNS_ATTR_TYPE_STRING,
+			(unsigned long)ha->name_string },
+
+		/* Key attributes */
+		{ ISNS_ATTR_TAG_ISCSI_NAME, ISNS_ATTR_TYPE_STRING, -1 },
+
+		/*
+		 * Required delimiter to indicate division between key and
+		 * operating attrs.
+		 */
+		{ ISNS_ATTR_TAG_DELIMITER, ISNS_ATTR_TYPE_EMPTY, 0 },
+
+		/* Operating attributes (attributes of object matching key
+		 * attribute to return).
+		 */
+		{ ISNS_ATTR_TAG_ISCSI_NODE_TYPE, ISNS_ATTR_TYPE_ULONG,
+			cpu_to_be32(ISCSI_NODE_TYPE_TARGET)},
+
+		{ 0, 0, 0 },
+	};
+
+	memcpy(ha->isns_dev_get_next_attr_list, isns_dev_get_next_attr_list,
+	    sizeof(isns_dev_get_next_attr_list));
+}
+
+static void
+qla4xxx_isns_init_isns_dev_attr_qry_attr_list(scsi_qla_host_t * ha)
+{
+	ATTRIBUTE_LIST isns_dev_attr_qry_attr_list[] = {
+
+		/* Source attribute */
+		{ ISNS_ATTR_TAG_ISCSI_NAME, ISNS_ATTR_TYPE_STRING,
+			(unsigned long)ha->name_string },
+
+		/* Key attributes */
+		{ ISNS_ATTR_TAG_ISCSI_NAME, ISNS_ATTR_TYPE_STRING, -1 },
+
+		/*
+		 * Required delimiter to indicate division between key and
+		 * operating attrs.
+		 */
+		{ ISNS_ATTR_TAG_DELIMITER, ISNS_ATTR_TYPE_EMPTY, 0 },
+
+		/* Operating attributes (attributes of objects matching key
+		 * attributes to return)
+		 */
+		{ ISNS_ATTR_TAG_ENTITY_PROTOCOL, ISNS_ATTR_TYPE_EMPTY, 0 },
+		{ ISNS_ATTR_TAG_ISCSI_NAME, ISNS_ATTR_TYPE_EMPTY, 0 },
+		{ ISNS_ATTR_TAG_ISCSI_NODE_TYPE, ISNS_ATTR_TYPE_EMPTY, 0 },
+		{ ISNS_ATTR_TAG_ISCSI_ALIAS, ISNS_ATTR_TYPE_EMPTY, 0 },
+
+		/* Friendly name */
+		{ ISNS_ATTR_TAG_PORTAL_SYMBOLIC_NAME, ISNS_ATTR_TYPE_EMPTY, 0 },
+		{ ISNS_ATTR_TAG_PORTAL_IP_ADDRESS, ISNS_ATTR_TYPE_EMPTY, 0 },
+		{ ISNS_ATTR_TAG_PORTAL_PORT, ISNS_ATTR_TYPE_EMPTY, 0 },
+		{ ISNS_ATTR_TAG_PORTAL_SECURITY_BITMAP, ISNS_ATTR_TYPE_EMPTY,
+			0},
+		{ ISNS_ATTR_TAG_DD_ID, ISNS_ATTR_TYPE_EMPTY, 0 },
+
+		{ 0, 0, 0 },
+	};
+
+	memcpy(ha->isns_dev_attr_qry_attr_list, isns_dev_attr_qry_attr_list,
+	    sizeof(isns_dev_attr_qry_attr_list));
+}
+
+int
+qla4xxx_isns_init_attributes(scsi_qla_host_t * ha)
+{
+
+	/* Separate these calls to minimize stack usage */
+	qla4xxx_isns_init_isns_reg_attr_list(ha);
+	qla4xxx_isns_init_isns_dereg_attr_list(ha);
+	qla4xxx_isns_init_isns_scn_reg_attr_list(ha);
+	qla4xxx_isns_init_isns_scn_dereg_attr_list(ha);
+	qla4xxx_isns_init_isns_dev_get_next_attr_list(ha);
+	qla4xxx_isns_init_isns_dev_attr_qry_attr_list(ha);
+
+	return QLA_SUCCESS;
+}
+
+int
+qla4xxx_isns_append_attribute(scsi_qla_host_t *ha, uint8_t **buffer,
+    uint8_t *buffer_end, ATTRIBUTE_LIST *attribute)
+{
+	ISNS_ATTRIBUTE *isns_attr;
+	uint32_t data_len;
+	uint8_t *local;
+
+	isns_attr = (ISNS_ATTRIBUTE *) * buffer;
+	switch (attribute->type) {
+	case ISNS_ATTR_TYPE_EMPTY:
+		data_len = 0;
+		if ((&isns_attr->value[0] + data_len) > buffer_end)
+			return QLA_ERROR;
+
+		isns_attr->tag = cpu_to_be32(attribute->isns_tag);
+		isns_attr->length = cpu_to_be32(data_len);
+		break;
+
+	case ISNS_ATTR_TYPE_STRING:
+		/*
+		 * Length must include NULL terminator.
+		 * Note also that all iSNS strings must be UTF-8 encoded.
+		 * You should encode your strings for UTF-8 before registering
+		 * them with the iSNS server.
+		 */
+		data_len = strlen((uint8_t *) attribute->data) +
+		    sizeof(uint8_t);
+		if (data_len % 4)		/* Pad to 4 byte boundary. */
+			data_len += (4 - (data_len % 4));
+
+		if ((&isns_attr->value[0] + data_len) > buffer_end)
+			return QLA_ERROR;
+
+		isns_attr->tag = cpu_to_be32(attribute->isns_tag);
+		isns_attr->length = cpu_to_be32(data_len);
+		memset(isns_attr->value, 0, data_len);
+		strcpy(&isns_attr->value[0], (uint8_t *) attribute->data);
+		break;
+
+	case ISNS_ATTR_TYPE_ULONG:
+		data_len = sizeof(uint32_t);
+		if ((isns_attr->value + data_len) > buffer_end)
+			return QLA_ERROR;
+
+		isns_attr->tag = cpu_to_be32(attribute->isns_tag);
+		isns_attr->length = cpu_to_be32(data_len);
+		*(uint32_t *) isns_attr->value = (uint32_t) attribute->data;
+		break;
+
+	case ISNS_ATTR_TYPE_ADDRESS:
+		local = (uint8_t *) attribute->data;
+		data_len = 16;	/* Size of an IPv6 address */
+		if ((isns_attr->value + data_len) > buffer_end)
+			return QLA_ERROR;
+
+		isns_attr->tag = cpu_to_be32(attribute->isns_tag);
+		isns_attr->length = cpu_to_be32(data_len);
+
+		/*
+		 * Prepend IP Address with 0xFFFF to indicate this is an IPv4
+		 * only address. IPv6 addresses not supported by driver.
+		 */
+		memset(isns_attr->value, 0, 16);
+		isns_attr->value[10] = 0xFF;
+		isns_attr->value[11] = 0xFF;
+		isns_attr->value[12] = local[0];
+		isns_attr->value[13] = local[1];
+		isns_attr->value[14] = local[2];
+		isns_attr->value[15] = local[3];
+		break;
+
+	default:
+		return QLA_ERROR;
+	}
+
+	*buffer = &isns_attr->value[0] + data_len;
+	return QLA_SUCCESS;
+}
+
+uint32_t
+qla4xxx_isns_build_iocb_handle(scsi_qla_host_t *ha, uint32_t type,
+    PDU_ENTRY *pdu_entry)
+{
+	uint32_t handle;
+
+	handle = (IOCB_ISNS_PT_PDU_TYPE(type) | (((uint8_t *) pdu_entry -
+	    (uint8_t *) ha->pdu_queue) / sizeof(PDU_ENTRY)));
+	DEBUG5(printk("scsi%ld: %s: type %x PDU %p = handle %x\n",
+	    ha->host_no, __func__, type, pdu_entry, handle));
+
+	return handle;
+}
+
+/*
+ * Remarks:
+ *      hardware_lock locked upon entry
+ */
+int
+qla4xxx_isns_get_server_request(scsi_qla_host_t *ha, uint32_t pdu_buff_len,
+    uint16_t connection_id)
+{
+	PDU_ENTRY *pdu_entry;
+	pdu_entry = qla4xxx_get_pdu(ha, max(pdu_buff_len, (uint32_t)PAGE_SIZE));
+	if (pdu_entry == NULL) {
+		DEBUG5(printk("scsi%ld: %s: get_pdu failed\n",
+		    ha->host_no, __func__));
+		return QLA_ERROR;
+	}
+	pdu_entry->SendBuffLen = 0;
+	pdu_entry->RecvBuffLen = pdu_entry->BuffLen;
+	if (qla4xxx_send_passthru0_iocb(ha, ISNS_DEVICE_INDEX, connection_id,
+	    pdu_entry->DmaBuff, pdu_entry->SendBuffLen, pdu_entry->RecvBuffLen,
+	    PT_FLAG_ISNS_PDU | PT_FLAG_WAIT_4_RESPONSE,
+	    qla4xxx_isns_build_iocb_handle(ha,
+		    /*ISNS_REQ_RSP_PDU */ ISNS_ASYNCH_REQ_PDU, pdu_entry)) !=
+	    QLA_SUCCESS) {
+		qla4xxx_free_pdu(ha, pdu_entry);
+		return QLA_ERROR;
+	}
+	return QLA_SUCCESS;
+}
+
+int
+qla4xxx_isns_build_scn_registration_packet(scsi_qla_host_t *ha,
+    uint8_t *buffer, uint32_t buffer_size, uint32_t *packet_size)
+{
+	/*
+	 * Fill in all of the run time requested data in the attribute array
+	 * then call iSNSBuildRequestPacket to do the actual work.
+	 */
+	return qla4xxx_isns_build_request_packet(ha, buffer, buffer_size,
+	    ISNS_FCID_SCNReg, ha->isns_transaction_id, 0,
+	    ha->isns_scn_reg_attr_list, packet_size);
+}
+
+int
+qla4xxx_isns_build_scn_deregistration_packet(scsi_qla_host_t *ha,
+    uint8_t *buffer, uint32_t buffer_size, uint32_t *packet_size)
+{
+	/*
+	 * Fill in all of the run time requested data in the attribute array
+	 * then call iSNSBuildRequestPacket to do the actual work.
+	 */
+	return qla4xxx_isns_build_request_packet(ha, buffer, buffer_size,
+	    ISNS_FCID_SCNDereg, ha->isns_transaction_id, 0,
+	    ha->isns_scn_dereg_attr_list, packet_size);
+}
+
+int
+qla4xxx_isns_build_registration_packet(scsi_qla_host_t *ha, uint8_t *buff,
+    uint32_t buff_size, uint8_t *isns_entity_id, uint8_t *ip_addr,
+    uint32_t port_number, uint32_t scn_port, uint32_t esi_port,
+    uint8_t *local_alias, uint32_t *packet_size)
+{
+	/*
+	 * Fill in all of the run time requested data in the attribute array,
+	 * then call build_request_packet to do the actual work.
+	 */
+	ha->isns_reg_attr_list[1].data = (unsigned long)isns_entity_id;
+	ha->isns_reg_attr_list[3].data = (unsigned long)isns_entity_id;
+	ha->isns_reg_attr_list[5].data = (unsigned long)ip_addr;
+	ha->isns_reg_attr_list[6].data = cpu_to_be32(port_number);
+	ha->isns_reg_attr_list[7].data = cpu_to_be32(scn_port);
+	ha->isns_reg_attr_list[8].data = cpu_to_be32(esi_port);
+	if (local_alias && local_alias[0])
+		ha->isns_reg_attr_list[11].data = (unsigned long)local_alias;
+	else
+		ha->isns_reg_attr_list[11].data =
+		    (unsigned long)"<No alias specified>";
+
+	return qla4xxx_isns_build_request_packet(ha, buff, buff_size,
+	    ISNS_FCID_DevAttrReg, ha->isns_transaction_id, 0,
+	    ha->isns_reg_attr_list, packet_size);
+}
+
+int
+qla4xxx_isns_build_deregistration_packet(scsi_qla_host_t *ha, uint8_t *buff,
+    uint32_t buff_size, uint8_t *isns_entity_id, uint8_t *ip_addr,
+    uint32_t port_number, uint32_t *packet_size)
+{
+	/*
+	 * Fill in all of the run time requested data in the attribute array,
+	 * then call build_request_packet to do the actual work.
+	 */
+	ha->isns_dereg_attr_list[2].data = (unsigned long)isns_entity_id;
+
+#if 0
+	ha->isns_dereg_attr_list[3].data = (unsigned long)ip_addr;
+	ha->isns_dereg_attr_list[4].data =
+	    (unsigned long)cpu_to_be32(port_number);
+
+#endif
+	return qla4xxx_isns_build_request_packet(ha, buff, buff_size,
+	    ISNS_FCID_DevDereg, ha->isns_transaction_id, 0,
+	    ha->isns_dereg_attr_list, packet_size);
+}
+
+int
+qla4xxx_isns_build_request_packet(scsi_qla_host_t *ha, uint8_t *buffer,
+    uint32_t buffer_size, uint16_t function_id, uint16_t tx_id,
+    uint8_t use_replace_flag, ATTRIBUTE_LIST *attr_list, uint32_t *packet_size)
+{
+	ISNSP_MESSAGE_HEADER *isns_message;
+	uint8_t *ptr;
+	uint8_t *buffer_end;
+	uint8_t *payload_start;
+	uint32_t i;
+	uint8_t success;
+
+	/*
+	 * Ensure that the buffer size is at a minimum sufficient to hold the
+	 * message header plus at least one attribute.
+	 */
+	if (buffer_size < (sizeof(*isns_message) + sizeof(*attr_list)))
+		return QLA_ERROR;
+
+	isns_message = (ISNSP_MESSAGE_HEADER *) buffer;
+	buffer_end = (uint8_t *) ((unsigned long)buffer + buffer_size);
+
+	/* Initialize message header contents */
+	isns_message->isnsp_version = cpu_to_be16(ISNSP_VERSION);
+	isns_message->function_id = cpu_to_be16(function_id);
+	if (use_replace_flag)
+		isns_message->flags = cpu_to_be16(ISNSP_CLIENT_SENDER |
+		    ISNSP_FIRST_PDU | ISNSP_LAST_PDU | ISNSP_REPLACE_FLAG);
+	else
+		isns_message->flags = cpu_to_be16(ISNSP_CLIENT_SENDER |
+		    ISNSP_FIRST_PDU | ISNSP_LAST_PDU);
+
+	isns_message->transaction_id = cpu_to_be16(tx_id);
+	/* First and only packet in this message */
+	isns_message->sequence_id = 0;
+	ptr = payload_start = &isns_message->payload[0];
+
+	/*
+	 * Now that most of the message header has been initialized (we'll fill
+	 * in the size when we're finished), let's append the desired attributes
+	 * to the request packet.
+	 */
+	success = 1;
+	for (i = 0; attr_list[i].type && success; i++)
+		success = (qla4xxx_isns_append_attribute(ha, &ptr, buffer_end,
+		    &attr_list[i]) == QLA_SUCCESS);
+
+	if (!success) {
+		DEBUG5(printk("scsi%ld: %s: Ran out of buffer space\n",
+		    ha->host_no, __func__));
+		return QLA_ERROR;
+	}
+
+	/*
+	 * We've successfully finished building the request packet.
+	 * Set the size field.
+	 */
+	isns_message->pdu_length = cpu_to_be16((unsigned long)ptr -
+	    (unsigned long) payload_start);
+	*packet_size = (uint32_t) ((unsigned long)ptr - (unsigned long)buffer);
+	return QLA_SUCCESS;
+}
+
+int
+qla4xxx_isns_build_server_request_response_packet(scsi_qla_host_t *ha,
+    uint8_t *buffer, uint32_t buffer_size, uint16_t function_id,
+    uint32_t error_code, uint16_t transaction_id, uint32_t *packet_size)
+{
+	ISNSP_MESSAGE_HEADER *isns_message;
+	ISNSP_RESPONSE_HEADER *isns_response;
+	uint8_t *ptr;
+	uint8_t *buffer_end;
+	uint8_t *payload_start;
+
+	/*
+	 * Ensure that the buffer size is at a minimum sufficient to hold the
+	 * message headers.
+	 */
+	if (buffer_size < (sizeof(ISNSP_MESSAGE_HEADER) +
+	    sizeof(ISNSP_RESPONSE_HEADER))) {
+		DEBUG2(printk("scsi%ld: %s: Insufficient buffer size %x\n",
+		    ha->host_no, __func__, buffer_size));
+		return QLA_ERROR;
+	}
+	isns_message = (ISNSP_MESSAGE_HEADER *) buffer;
+	isns_response = (ISNSP_RESPONSE_HEADER *) & isns_message->payload[0];
+	payload_start = (uint8_t *) isns_response;
+	buffer_end = (uint8_t *) (buffer + buffer_size);
+
+	/* Initialize message header contents. */
+	isns_message->isnsp_version = cpu_to_be16(ISNSP_VERSION);
+	isns_message->function_id = (function_id);
+
+	/*isns_message->function_id = cpu_to_be16(function_id); */
+	isns_message->flags =
+	    cpu_to_be16(ISNSP_CLIENT_SENDER | ISNSP_FIRST_PDU | ISNSP_LAST_PDU);
+	isns_message->transaction_id = (transaction_id);
+
+	/*isns_message->transaction_id = cpu_to_be16(transaction_id); */
+	/* First and only packet in this message */
+	isns_message->sequence_id = 0;
+	isns_response->error_code = cpu_to_be32(error_code);
+	ptr = &isns_response->attributes[0];
+
+	/* We've successfully finished building the request packet. */
+	isns_message->pdu_length = cpu_to_be16((unsigned long)ptr -
+	    (unsigned long) payload_start);
+	*packet_size = (unsigned long)ptr - (unsigned long)buffer;
+
+	return QLA_SUCCESS;
+}
+
+int
+qla4xxx_isns_build_dev_get_next_packet(scsi_qla_host_t *ha, uint8_t *buffer,
+    uint32_t buffer_size, uint8_t *last_iscsi_name, uint32_t *packet_size)
+{
+	/*
+	 * Fill in all of the run time requested data in the attribute array
+	 * then call qla4xxx_isns_build_request_packet to do the actual work.
+	 */
+	if (last_iscsi_name && last_iscsi_name[0]) {
+		ha->isns_dev_get_next_attr_list[1].type = ISNS_ATTR_TYPE_STRING;
+		ha->isns_dev_get_next_attr_list[1].data =
+		    (unsigned long)last_iscsi_name;
+	} else {
+		ha->isns_dev_get_next_attr_list[1].type = ISNS_ATTR_TYPE_EMPTY;
+		ha->isns_dev_get_next_attr_list[1].data = 0;
+	}
+
+	return qla4xxx_isns_build_request_packet(ha, buffer, buffer_size,
+	    ISNS_FCID_DevGetNext, ha->isns_transaction_id, 0,
+	    ha->isns_dev_get_next_attr_list, packet_size);
+}
+
+int
+qla4xxx_isns_build_dev_attr_qry_packet(scsi_qla_host_t *ha, uint8_t *buffer,
+    uint32_t buffer_size, uint8_t *object_iscsi_name, uint32_t *packet_size)
+{
+	/*
+	 * Fill in all of the run time requested data in the attribute array
+	 * then call qla4xxx_isns_build_request_packet to do the actual work.
+	 */
+	ha->isns_dev_attr_qry_attr_list[1].data =
+	    (unsigned long)object_iscsi_name;
+
+	return qla4xxx_isns_build_request_packet(ha, buffer, buffer_size,
+	    ISNS_FCID_DevAttrQry, ha->isns_transaction_id, 0,
+	    ha->isns_dev_attr_qry_attr_list, packet_size);
+}
+
+int
+qla4xxx_isns_parse_get_next_response(scsi_qla_host_t *ha, uint8_t *buffer,
+    uint32_t buffer_size, uint32_t *isns_error, uint8_t *last_iscsi_name,
+    uint32_t last_iscsi_name_size, uint8_t *IsTarget)
+{
+	ISNSP_MESSAGE_HEADER *isns_message;
+	ISNSP_RESPONSE_HEADER *isns_response;
+	ISNS_ATTRIBUTE *isns_attr;
+	uint8_t *buffer_end;
+
+	*IsTarget = 0;
+	isns_message = (ISNSP_MESSAGE_HEADER *) buffer;
+	buffer_end = (uint8_t *) ((uint8_t *) & isns_message->payload[0] +
+	    be16_to_cpu(isns_message->pdu_length));
+
+	/* Validate pdu_length specified in the iSNS message header. */
+	if (((unsigned long)buffer_end - (unsigned long)buffer) > buffer_size) {
+		DEBUG5(printk("scsi%ld: %s: Invalid length field in "
+		    "iSNS response from iSNS server\n", ha->host_no, __func__));
+		return QLA_ERROR;
+	}
+
+	/*
+	 * It is safe to assume from this point on that the pdu_length value
+	 * (and thus our idea about the end of the buffer) is valid.
+	 */
+	if (be16_to_cpu(isns_message->function_id) != ISNS_FCID_DevGetNextRsp) {
+		DEBUG5(printk("scsi%ld: %s: Invalid Function ID "
+		    "(0x%04x) in iSNS response from iSNS server\n",
+		    ha->host_no, __func__,
+		    be16_to_cpu(isns_message->function_id)));
+		return QLA_ERROR;
+	}
+
+	isns_response = (ISNSP_RESPONSE_HEADER *) & isns_message->payload[0];
+	*isns_error = be32_to_cpu(isns_response->error_code);
+	if (*isns_error) {
+		DEBUG2(printk("scsi%ld: %s: iSNS Error code: %d\n",
+		    ha->host_no, __func__, *isns_error));
+		if (*isns_error == ISNS_ERR_NO_SUCH_ENTRY) {
+			DEBUG2(printk("scsi%ld: %s: No more targets.\n",
+			    ha->host_no, __func__));
+			set_bit(ISNS_FLAG_DEV_SCAN_DONE, &ha->isns_flags);
+		} else {
+			DEBUG2(printk("scsi%ld: %s: Get Next failed. Error "
+			    "code %x\n", ha->host_no, __func__, *isns_error));
+		}
+		return QLA_ERROR;
+	}
+	isns_attr = (ISNS_ATTRIBUTE *) & isns_response->attributes[0];
+
+	/* Save the returned key attribute for the next DevGetNext request. */
+	if (VALIDATE_ATTR(isns_attr, buffer_end) &&
+	    be32_to_cpu(isns_attr->tag) == ISNS_ATTR_TAG_ISCSI_NAME) {
+		strncpy(last_iscsi_name, &isns_attr->value[0],
+		    last_iscsi_name_size);
+	} else {
+		DEBUG2(printk("scsi%ld: %s: Bad Key attribute in "
+		    "DevGetNextRsp\n", ha->host_no, __func__));
+		return QLA_ERROR;
+	}
+
+	// Point to next attribute.
+	isns_attr = NEXT_ATTR(isns_attr);
+	if (VALIDATE_ATTR(isns_attr, buffer_end) &&
+	    be32_to_cpu(isns_attr->tag) == ISNS_ATTR_TAG_DELIMITER) {
+		;		/* Do nothing. */
+	} else {
+		DEBUG2(printk("scsi%ld: %s: No delimiter in DevGetNextRsp\n",
+		    ha->host_no, __func__));
+		return QLA_ERROR;
+	}
+
+	*IsTarget = 1;		/*FIXME*/
+
+	/* Point to next attribute. */
+	isns_attr = NEXT_ATTR(isns_attr);
+	if (VALIDATE_ATTR(isns_attr, buffer_end) &&
+	    be32_to_cpu(isns_attr->tag) == ISNS_ATTR_TAG_ISCSI_NODE_TYPE) {
+		if (be32_to_cpu(*(uint32_t *) & isns_attr->value[0]) &
+		    ISCSI_NODE_TYPE_TARGET)
+			*IsTarget = 1;
+	}
+#if 0
+	else {
+		DEBUG5(printk("scsi%ld: %s: Bad operating attr in "
+		    "DevGetNextRsp (%d)\n", ha->host_no, __func__,
+		    be16_to_cpu(isns_attr->tag)));
+		return QLA_ERROR;
+	}
+
+#endif
+	return QLA_SUCCESS;
+}
+
+int
+qla4xxx_isns_parse_query_response(scsi_qla_host_t *ha, uint8_t *buffer,
+    uint32_t buffer_size, uint32_t *isns_error,
+    ISNS_DISCOVERED_TARGET *isns_discovered_target, uint8_t *IsTarget,
+    uint8_t *last_iscsi_name)
+{
+	ISNSP_MESSAGE_HEADER *isns_message;
+	ISNSP_RESPONSE_HEADER *isns_response;
+	ISNS_ATTRIBUTE *isns_attr;
+	uint8_t *buffer_end;
+	uint8_t *tmpptr;
+	uint16_t wTmp;
+	uint32_t ulTmp;
+	uint32_t i;
+
+	isns_message = (ISNSP_MESSAGE_HEADER *) buffer;
+	buffer_end = &isns_message->payload[0] +
+	    be16_to_cpu(isns_message->pdu_length);
+
+	/* Validate pdu_length specified in the iSNS message header. */
+	if (((unsigned long)buffer_end - (unsigned long)buffer) > buffer_size) {
+		DEBUG5(printk("scsi%ld: %s: Invalid length field in "
+		    "iSNS response from iSNS server\n", ha->host_no, __func__));
+		return QLA_ERROR;
+	}
+
+	/*
+	 * It is safe to assume from this point on that the pdu_length value
+	 * (and thus our idea about the end of the buffer) is valid.
+	 */
+	if (be16_to_cpu(isns_message->function_id) != ISNS_FCID_DevAttrQryRsp) {
+		DEBUG5(printk("scsi%ld: %s: Invalid Function ID %04x "
+		    "in iSNS response\n", ha->host_no, __func__,
+		    be16_to_cpu(isns_message->function_id)));
+		return QLA_ERROR;
+	}
+
+	isns_response = (ISNSP_RESPONSE_HEADER *) & isns_message->payload[0];
+	DEBUG2(printk("-----------------------------\n"));
+	DEBUG2(printk("scsi%ld: %s: DevAttrQry response from iSNS server:\n",
+	    ha->host_no, __func__));
+	*isns_error = be32_to_cpu(isns_response->error_code);
+	if (*isns_error) {
+		DEBUG5(printk("scsi%ld: %s: iSNS Query failed.  "
+		    "error_code %x.\n", ha->host_no, __func__, *isns_error));
+		return QLA_ERROR;
+	}
+	DEBUG2(printk("scsi%ld: %s: Attributes:\n", ha->host_no, __func__));
+
+	isns_attr = (ISNS_ATTRIBUTE *) & isns_response->attributes[0];
+
+	/* Skip key and delimiter attributes. */
+	while (VALIDATE_ATTR(isns_attr, buffer_end) &&
+	    be32_to_cpu(isns_attr->tag) != ISNS_ATTR_TAG_DELIMITER) {
+
+		/* Point to next attribute. */
+		if (be32_to_cpu(isns_attr->tag) == ISNS_ATTR_TAG_ISCSI_NAME) {
+			/*
+			 * Note that this string is in UTF-8 format.  In
+			 * production code, it would be necessary to convert
+			 * from UTF-8 before using the  string.
+			 */
+			DEBUG2(printk("scsi%ld: %s: MsgTag iSCSI Name: "
+			    "\"%s\"\n", ha->host_no, __func__,
+			    isns_attr->value));
+			if (strlen(isns_attr->value) > 256)
+				return QLA_ERROR;
+			strcpy(last_iscsi_name,
+			    (uint8_t *) &isns_attr->value[0]);
+		}
+		isns_attr = NEXT_ATTR(isns_attr);
+	}
+
+	if (!VALIDATE_ATTR(isns_attr, buffer_end) ||
+	    be32_to_cpu(isns_attr->tag) != ISNS_ATTR_TAG_DELIMITER) {
+		/* There was no delimiter attribute in the response. */
+		return QLA_ERROR;
+	}
+
+	/* Skip delimiter attribute. */
+	isns_attr = NEXT_ATTR(isns_attr);
+	while (VALIDATE_ATTR(isns_attr, buffer_end)) {
+		/*
+		 * We only need to parse for the operating attributes that we
+		 * requested in the DevAttrQuery.
+		 */
+		switch (be32_to_cpu(isns_attr->tag)) {
+		case ISNS_ATTR_TAG_ENTITY_PROTOCOL:
+			if (be32_to_cpu(*(uint32_t *) isns_attr->value) !=
+			    ENTITY_PROTOCOL_ISCSI) {
+				DEBUG5(printk("scsi%ld: %s: Entity "
+				    "does not support iSCSI protocol\n",
+				    ha->host_no, __func__));
+			}
+			break;
+
+		case ISNS_ATTR_TAG_ISCSI_NODE_TYPE:
+			switch (be32_to_cpu(*(uint32_t *) isns_attr->value)) {
+			case ISCSI_NODE_TYPE_TARGET:
+				*IsTarget = 1;
+				break;
+
+			case ISCSI_NODE_TYPE_INITIATOR:
+				*IsTarget = 0;
+				break;
+
+			case ISCSI_NODE_TYPE_CONTROL:
+				*IsTarget = 0;
+				break;
+
+			default:
+				*IsTarget = 0;
+				break;
+			}
+			break;
+
+		case ISNS_ATTR_TAG_MGMT_IP_ADDRESS:
+			/* WARNING: This doesn't handle IPv6 addresses. */
+			tmpptr = &isns_attr->value[0];
+			for (i = 0; i < 8; i++)
+				if (tmpptr[i])
+					return QLA_ERROR;
+
+			for (i = 8; i < 12; i++)
+				if (tmpptr[i] != 0 && tmpptr[i] != 0xFF)
+					return QLA_ERROR;
+
+			DEBUG5(printk("scsi%ld: %s: Management IP "
+			    "address: %u.%u.%u.%u\n", ha->host_no, __func__,
+			    tmpptr[12], tmpptr[13], tmpptr[14], tmpptr[15]));
+			break;
+
+		case ISNS_ATTR_TAG_PORTAL_IP_ADDRESS:
+			/* WARNING: This doesn't handle IPv6 addresses. */
+			tmpptr = &isns_attr->value[0];
+			for (i = 0; i < 8; i++)
+				if (tmpptr[i])
+					return QLA_ERROR;
+
+			for (i = 8; i < 12; i++)
+				if (tmpptr[i] != 0 && tmpptr[i] != 0xFF)
+					return QLA_ERROR;
+
+			DEBUG5(printk("scsi%ld: %s: Portal IP "
+			    "address: %u.%u.%u.%u\n", ha->host_no, __func__,
+			    tmpptr[12], tmpptr[13], tmpptr[14], tmpptr[15]));
+			if (isns_discovered_target->NumPortals >=
+			    ISNS_MAX_PORTALS)
+				break;
+
+			memcpy(isns_discovered_target->
+			    Portal[isns_discovered_target->NumPortals].IPAddr,
+			    &tmpptr[12], 4);
+			break;
+
+		case ISNS_ATTR_TAG_PORTAL_PORT:
+			wTmp = (uint16_t) (be32_to_cpu(
+			    *(uint32_t *)isns_attr->value));
+			DEBUG5(printk("scsi%ld: %s: Portal port: "
+			    "%u\n", ha->host_no, __func__,
+			    be32_to_cpu(*(uint32_t *)isns_attr-> value)));
+			if (isns_discovered_target->NumPortals >=
+			    ISNS_MAX_PORTALS)
+				break;
+
+			isns_discovered_target->
+				Portal[isns_discovered_target->NumPortals].
+				PortNumber = wTmp;
+			isns_discovered_target->NumPortals++;
+			break;
+
+		case ISNS_ATTR_TAG_PORTAL_SYMBOLIC_NAME:
+			/*
+			 * Note that this string is in UTF-8 format.  In
+			 * production code, it would be necessary to convert
+			 * from UTF-8 before using the  string.
+			 */
+			DEBUG5(printk("scsi%ld: %s: Portal Symbolic "
+			    "Name: \"%s\"\n", ha->host_no, __func__,
+			    &isns_attr->value[0]));
+
+#if 0
+			if (isns_discovered_target->NumPortals >=
+			    ISNS_MAX_PORTALS)
+				break;
+			qlstrncpy(isns_discovered_target->
+			    Portal[isns_discovered_target->NumPortals].
+			    SymbolicName, (uint8_t *) isns_attr->value, 32);
+			isns_discovered_target->
+				Portal[isns_discovered_target->NumPortals].
+				SymbolicName[31] = 0;
+#endif
+			break;
+
+		case ISNS_ATTR_TAG_SCN_PORT:
+			break;
+		case ISNS_ATTR_TAG_ESI_PORT:
+			break;
+		case ISNS_ATTR_TAG_ESI_INTERVAL:
+			break;
+		case ISNS_ATTR_TAG_REGISTRATION_PERIOD:
+			break;
+
+		case ISNS_ATTR_TAG_PORTAL_SECURITY_BITMAP:
+			ulTmp = be32_to_cpu(*(uint32_t *) isns_attr->value);
+
+			/* isns_discovered_target->SecurityBitmap = ulTmp; */
+			break;
+
+		case ISNS_ATTR_TAG_ENTITY_IDENTIFIER:
+			/*
+			 * Note that this string is in UTF-8 format.  In
+			 * production code, it would be necessary to convert
+			 * from UTF-8 before using the  string.
+			 */
+			break;
+
+		case ISNS_ATTR_TAG_ISCSI_NAME:
+			/*
+			 * Note that this string is in UTF-8 format.  In
+			 * production code, it would be necessary to convert
+			 * from UTF-8 before using the  string.
+			 */
+			if (strlen(isns_attr->value) > 256)
+				return (QLA_ERROR);
+			strcpy(isns_discovered_target->NameString,
+			       (uint8_t *) isns_attr->value);
+			break;
+
+		case ISNS_ATTR_TAG_ISCSI_ALIAS:
+			/*
+			 * Note that this string is in UTF-8 format.  In
+			 * production code, it would be necessary to convert
+			 * from UTF-8 before using the  string.
+			 */
+			if (strlen(isns_attr->value) <= 32)
+				strcpy(isns_discovered_target->Alias,
+				       (uint8_t *) isns_attr->value);
+			break;
+
+		case ISNS_ATTR_TAG_DD_ID:
+			ulTmp = be32_to_cpu(*(uint32_t *) isns_attr->value);
+			isns_discovered_target->DDID = ulTmp;
+			break;
+
+		default:
+			break;
+		}
+
+		/* Point to next attribute. */
+		isns_attr = NEXT_ATTR(isns_attr);
+	}
+	return QLA_SUCCESS;
+}
+
+int
+qla4xxx_isns_process_response(scsi_qla_host_t *ha,
+    PASSTHRU_STATUS_ENTRY *sts_entry)
+{
+	uint32_t handle = le32_to_cpu(sts_entry->handle);
+	uint32_t inResidual = le32_to_cpu(sts_entry->inResidual);
+	uint16_t connectionID = le16_to_cpu(sts_entry->connectionID);
+	PDU_ENTRY *pdu_entry =
+	    (PDU_ENTRY *) & ha->pdu_queue[IOCB_ISNS_PT_PDU_INDEX(handle)];
+	uint32_t pdu_type = IOCB_ISNS_PT_PDU_TYPE(handle);
+	uint8_t status = QLA_SUCCESS;
+
+	DEBUG5(printk("scsi%ld: %s isns_flags 0x%lx to=0x%x "
+	    "IOCS=0x%02x OutResidual/Len=0x%x/0x%x InResidual/Len=0x%x/0x%x\n",
+	    ha->host_no, __func__, ha->isns_flags,
+	    le16_to_cpu(sts_entry->timeout), sts_entry->completionStatus,
+	    le32_to_cpu(sts_entry->outResidual), pdu_entry->SendBuffLen,
+	    inResidual, pdu_entry->RecvBuffLen));
+	if (pdu_entry->RecvBuffLen - inResidual) {
+		DEBUG5(printk("PDU (0x%p) <-\n", pdu_entry->Buff));
+		DEBUG5(qla4xxx_dump_bytes(pdu_entry->Buff,
+		    pdu_entry->RecvBuffLen - inResidual));
+	}
+	if (sts_entry->completionStatus != PASSTHRU_STATUS_COMPLETE) {
+		qla4xxx_free_pdu(ha, pdu_entry);
+		set_bit(DPC_ISNS_RESTART, &ha->dpc_flags);
+		goto exit_pt_sts;
+	}
+	switch (pdu_type) {
+	case ISNS_ASYNCH_RSP_PDU:
+		qla4xxx_free_pdu(ha, pdu_entry);
+		break;
+
+	case ISNS_ASYNCH_REQ_PDU:
+		pdu_entry->RecvBuffLen -= inResidual;
+		DEBUG5(printk("scsi%ld: %s ISNS_ASYNCH_REQ_PDU  PDU "
+		    "Buff=%p, PDU RecvLen=0x%X\n", ha->host_no, __func__,
+		    pdu_entry->Buff, pdu_entry->RecvBuffLen));
+		if (qla4xxx_isns_reassemble_pdu(ha, pdu_entry->Buff,
+		    &pdu_entry->RecvBuffLen) != QLA_SUCCESS) {
+			DEBUG2(printk("scsi%ld: %s ISNS_ASYNCH_REQ_PDU "
+			    "reassemble_pdu failed!\n", ha->host_no, __func__));
+			goto exit_pt_sts;
+		}
+		if (qla4xxx_isns_parse_and_dispatch_server_request(ha,
+		    pdu_entry->Buff, pdu_entry->RecvBuffLen, connectionID) !=
+		    QLA_SUCCESS) {
+			DEBUG2(printk("scsi%ld: %s ISNS_ASYNCH_REQ_PDU "
+			    "parse_and_dispatch_server_request failed!\n",
+			    ha->host_no, __func__));
+		}
+		qla4xxx_free_pdu(ha, pdu_entry);
+		break;
+
+	case ISNS_REQ_RSP_PDU:
+		pdu_entry->RecvBuffLen -= inResidual;
+		if (qla4xxx_isns_reassemble_pdu(ha, pdu_entry->Buff,
+		    &pdu_entry->RecvBuffLen) != QLA_SUCCESS) {
+			DEBUG2(printk("scsi%ld: %s ISNS_REQ_RSP_PDU "
+			    "reassemble_pdu failed!\n", ha->host_no, __func__));
+			goto exit_pt_sts;
+		}
+		if (qla4xxx_isns_parse_and_dispatch_server_response(ha,
+		    pdu_entry->Buff, pdu_entry->RecvBuffLen) != QLA_SUCCESS) {
+			DEBUG2(printk("scsi%ld: %s ISNS_REQ_RSP_PDU "
+			    "parse_and_dispatch_server_response failed!\n",
+			    ha->host_no, __func__));
+		}
+		qla4xxx_free_pdu(ha, pdu_entry);
+		break;
+
+	default:
+		DEBUG2(printk("scsi%ld: %s iSNS handle 0x%x invalid\n",
+		    ha->host_no, __func__, sts_entry->handle));
+		status = QLA_ERROR;
+		break;
+	}
+exit_pt_sts:
+	return status;
+}
+
+int
+qla4xxx_isns_reassemble_pdu(scsi_qla_host_t *ha, uint8_t *buffer,
+    uint32_t *buffer_size)
+{
+	uint16_t copy_size = 0;
+	uint32_t new_pdu_length = 0;
+	uint32_t bytes_remaining;
+	uint32_t pdu_size;
+	uint8_t *dest_ptr = NULL;
+	uint8_t *src_ptr = NULL;
+	ISNSP_MESSAGE_HEADER *isns_message;
+	uint32_t i;
+
+	/*
+	 * We have read all the PDU's for this message.  Now reassemble them
+	 * into a single PDU.
+	 */
+	if (buffer == NULL || buffer_size == 0)
+		return QLA_ERROR;
+
+	if (*buffer_size == 0) {
+		DEBUG5(printk(KERN_WARNING "scsi%ld: %s: Length 0.  "
+		    "Nothing to reassemble\n", ha->host_no, __func__));
+		return QLA_ERROR;
+	}
+	new_pdu_length = 0;
+	bytes_remaining = *buffer_size;
+	isns_message = (ISNSP_MESSAGE_HEADER *) buffer;
+	if ((!be16_to_cpu(isns_message->flags) & ISNSP_FIRST_PDU)) {
+		*buffer_size = 0;
+		return QLA_ERROR;
+	}
+
+	/* First, calculate the size of the payload for the collapsed PDU */
+	do {
+		if (bytes_remaining < sizeof(ISNSP_MESSAGE_HEADER)) {
+			DEBUG2(printk(KERN_WARNING
+			    "scsi%ld: %s: Length 0.  bytes_remaining < "
+			    "sizeof(ISNSP_MESSAGE_HEADER).  BytesRemaining "
+			    "%x, discard PDU\n", ha->host_no, __func__,
+			    bytes_remaining));
+			*buffer_size = 0;
+			return QLA_ERROR;
+		} else if (be16_to_cpu(isns_message->isnsp_version) !=
+		    ISNSP_VERSION) {
+			DEBUG5(printk(KERN_WARNING
+			    "scsi%ld: %s: Bad Version number in iSNS Message "
+			    "Header (%04x, expecting %04x), discard PDU\n",
+			    ha->host_no, __func__,
+			    be16_to_cpu(isns_message-> isnsp_version),
+			    ISNSP_VERSION));
+			*buffer_size = 0;
+			return QLA_ERROR;
+		} else if (bytes_remaining < sizeof(ISNSP_MESSAGE_HEADER) +
+		    be16_to_cpu(isns_message->pdu_length)) {
+			DEBUG5(printk(KERN_WARNING
+			    "scsi%d: %s: Short PDU in sequence. "
+			    "BytesRemaining %x, discard PDU\n", ha->host_no,
+			    __func__, bytes_remaining));
+			*buffer_size = 0;
+			return QLA_ERROR;
+		} else if ((bytes_remaining == sizeof(ISNSP_MESSAGE_HEADER) +
+		    be16_to_cpu(isns_message->pdu_length)) &&
+			(!(be16_to_cpu(isns_message->flags) &
+			    ISNSP_LAST_PDU))) {
+			*buffer_size = 0;
+			return QLA_ERROR;
+		}
+
+		new_pdu_length += be16_to_cpu(isns_message->pdu_length);
+		pdu_size = sizeof(ISNSP_MESSAGE_HEADER) +
+		    be16_to_cpu(isns_message->pdu_length);
+		isns_message = (ISNSP_MESSAGE_HEADER *)
+			((uint8_t *) isns_message + pdu_size);
+		bytes_remaining = bytes_remaining > pdu_size ?
+		    bytes_remaining - pdu_size : 0;
+	} while (bytes_remaining);
+
+	dest_ptr = buffer;
+	bytes_remaining = *buffer_size;
+	isns_message = (ISNSP_MESSAGE_HEADER *) buffer;
+	i = 0;
+
+	DEBUG5(printk("scsi%ld: %s: PDU%d=%p payloadLength=%04x\n",
+	    ha->host_no, __func__, i, dest_ptr,
+	    be16_to_cpu(isns_message->pdu_length)));
+
+	while (bytes_remaining) {
+		/*
+		 * If this is the first PDU perform no copy, otherwise copy
+		 * just the payload.
+		 */
+		if (dest_ptr != buffer) {
+			i++;
+			copy_size = be16_to_cpu(isns_message->pdu_length);
+			src_ptr = (uint8_t *) isns_message->payload;
+			DEBUG5(printk("scsi%ld: %s: PDU%d %p <= %p "
+			    "(%04x)\n", ha->host_no, __func__, i, dest_ptr,
+			    src_ptr, copy_size));
+			memcpy(dest_ptr, src_ptr, copy_size);
+			dest_ptr += copy_size;
+		}
+		pdu_size = sizeof(ISNSP_MESSAGE_HEADER) +
+		    be16_to_cpu(isns_message->pdu_length);
+		isns_message = (ISNSP_MESSAGE_HEADER *)
+			((uint8_t *) isns_message + pdu_size);
+		bytes_remaining = bytes_remaining > pdu_size ?
+		    bytes_remaining - pdu_size : 0;
+	}
+	isns_message = (ISNSP_MESSAGE_HEADER *) buffer;
+
+	/* Update pdu_length field in reassembled PDU to reflect actual */
+	/* combined PDU payload length. */
+	isns_message->pdu_length = cpu_to_be16(new_pdu_length);
+
+	/* Also set LAST_PDU flag in reassembled PDU */
+	isns_message->flags |= cpu_to_be16(ISNSP_LAST_PDU);
+
+	/* Return number of bytes in buffer to caller. */
+	*buffer_size = new_pdu_length + sizeof(ISNSP_MESSAGE_HEADER);
+
+	return QLA_SUCCESS;
+}
+
+int
+qla4xxx_isns_scn(scsi_qla_host_t *ha, uint8_t *req_buffer,
+    uint32_t req_buffer_size, uint16_t ConnectionId)
+{
+	ISNSP_MESSAGE_HEADER *isns_req_message;
+	ISNSP_MESSAGE_HEADER *isns_rsp_message;
+	ISNSP_RESPONSE_HEADER *isns_response;
+	PDU_ENTRY *pdu_entry;
+	ISNS_ATTRIBUTE *attr;
+	uint8_t *req_buffer_end;
+	uint8_t *rsp_buffer_end;
+	uint8_t *payload_start;
+	uint8_t *ptr;
+	uint32_t packet_size;
+	uint32_t copy_size;
+
+	isns_req_message = (ISNSP_MESSAGE_HEADER *) req_buffer;
+	if ((pdu_entry = qla4xxx_get_pdu(ha, PAGE_SIZE)) == NULL) {
+		DEBUG5(printk("scsi%ld: %s: qla4xxx_get_pdu failed\n",
+		    ha->host_no, __func__));
+		return QLA_ERROR;
+	}
+
+	/* First, setup the response packet. */
+	if (qla4xxx_isns_build_server_request_response_packet(ha,
+	    pdu_entry->Buff, pdu_entry->BuffLen,
+	    be16_to_cpu(isns_req_message->function_id) | 0x8000,
+	    ISNS_ERR_SUCCESS, be16_to_cpu(isns_req_message->transaction_id),
+	    &packet_size) != QLA_SUCCESS) {
+		DEBUG5(printk("scsi%ld: %s: qla4xxx_isns_build_server_"
+		    "request_response_packet failed\n", ha->host_no, __func__));
+		qla4xxx_free_pdu(ha, pdu_entry);
+		return QLA_ERROR;
+	}
+
+	isns_rsp_message = (ISNSP_MESSAGE_HEADER *) pdu_entry->Buff;
+	isns_response = (ISNSP_RESPONSE_HEADER *) &
+	    isns_rsp_message->payload[0];
+	payload_start = (uint8_t *) isns_response;
+	rsp_buffer_end = (uint8_t *) (pdu_entry->Buff + pdu_entry->BuffLen);
+	ptr = &isns_response->attributes[0];
+	req_buffer_end = (uint8_t *) ((uint8_t *) &
+	    isns_req_message->payload[0] +
+	    be16_to_cpu(isns_req_message->pdu_length));
+
+	/*
+	 * Point to the source attribute in the request.  We need to return
+	 * only this attribute in the SCN Response.
+	 */
+	attr = (ISNS_ATTRIBUTE *) & isns_req_message->payload[0];
+	if (!VALIDATE_ATTR(attr, req_buffer_end)) {
+		isns_response->error_code = cpu_to_be32(ISNS_ERR_MSG_FORMAT);
+		DEBUG5(printk("scsi%ld: %s: Malformed packet\n",
+		    ha->host_no, __func__));
+	}
+
+	/* Validate that this is an iSCSI Name attribute. */
+	if (be32_to_cpu(attr->tag) != ISNS_ATTR_TAG_ISCSI_NAME) {
+		DEBUG5(printk("scsi%ld: %s: Did not find iSCSN Name "
+		    "attribute\n", ha->host_no, __func__));
+	}
+
+	/* Copy source attribute to return buffer. */
+	copy_size = sizeof(ISNS_ATTRIBUTE) + be32_to_cpu(attr->length);
+	if (ptr + copy_size < rsp_buffer_end) {
+		/*
+		 * Attribute will fit in the response buffer.  Go ahead
+		 * and copy it.
+		 */
+		memcpy(ptr, attr, copy_size);
+		ptr += copy_size;
+	} else {
+		DEBUG5(printk("scsi%ld: %s: Insufficient buffer size\n",
+		    ha->host_no, __func__));
+	}
+
+	/* We've successfully finished building the response packet. */
+	/* Set the size field. */
+	isns_rsp_message->pdu_length = cpu_to_be16((unsigned long)ptr -
+	    (unsigned long) payload_start);
+	packet_size = (unsigned long)ptr - (unsigned long)pdu_entry->Buff;
+	pdu_entry->SendBuffLen = packet_size;
+	pdu_entry->RecvBuffLen = 0;
+	if (qla4xxx_send_passthru0_iocb(ha, ISNS_DEVICE_INDEX, ConnectionId,
+	    pdu_entry->DmaBuff, pdu_entry->SendBuffLen, pdu_entry->RecvBuffLen,
+	    PT_FLAG_ISNS_PDU, qla4xxx_isns_build_iocb_handle(ha,
+		    ISNS_ASYNCH_RSP_PDU, pdu_entry)) != QLA_SUCCESS) {
+		DEBUG5(printk("scsi%ld: %s:  "
+		    "qla4xxx_send_passthru0_iocb failed\n", ha->host_no,
+		    __func__));
+		qla4xxx_free_pdu(ha, pdu_entry);
+		return QLA_ERROR;
+	}
+
+	if (test_bit(ISNS_FLAG_SCN_IN_PROGRESS, &ha->isns_flags)) {
+		set_bit(ISNS_FLAG_SCN_RESTART, &ha->isns_flags);
+	} else {
+		set_bit(ISNS_FLAG_SCN_IN_PROGRESS, &ha->isns_flags);
+		clear_bit(ISNS_FLAG_SCN_RESTART, &ha->isns_flags);
+		ha->isns_num_discovered_targets = 0;
+		if (qla4xxx_isns_dev_get_next(ha, NULL) != QLA_SUCCESS) {
+			DEBUG5(printk("scsi%ld: %s: "
+			    "qla4xxx_isns_dev_get_next failed\n", ha->host_no,
+			    __func__));
+			ISNS_CLEAR_FLAGS(ha);
+		}
+	}
+	return QLA_SUCCESS;
+}
+
+int
+qla4xxx_isns_esi(scsi_qla_host_t *ha, uint8_t *req_buffer,
+    uint32_t req_buffer_size, uint16_t ConnectionId)
+{
+	ISNSP_MESSAGE_HEADER *isns_req_message;
+	ISNSP_MESSAGE_HEADER *isns_rsp_message;
+	ISNSP_RESPONSE_HEADER *isns_response;
+	PDU_ENTRY *pdu_entry;
+	ISNS_ATTRIBUTE *attr;
+	uint8_t *req_buffer_end;
+	uint8_t *rsp_buffer_end;
+	uint8_t *payload_start;
+	uint8_t *ptr;
+	uint32_t packet_size;
+	uint32_t copy_size;
+
+	isns_req_message = (ISNSP_MESSAGE_HEADER *) req_buffer;
+	if ((pdu_entry = qla4xxx_get_pdu(ha, req_buffer_size +
+	    sizeof(uint32_t))) == NULL) {
+		DEBUG5(printk("scsi%ld: %s:  qla4xxx_get_pdu failed\n",
+		    ha->host_no, __func__));
+		return QLA_ERROR;
+	}
+
+	/* First, setup the response packet. */
+	if (qla4xxx_isns_build_server_request_response_packet(ha,
+	    pdu_entry->Buff, pdu_entry->BuffLen,
+	    be16_to_cpu(isns_req_message->function_id | 0x8000),
+	    ISNS_ERR_SUCCESS, be16_to_cpu(isns_req_message->transaction_id),
+	    &packet_size) != QLA_SUCCESS) {
+		DEBUG5(printk("scsi%ld: %s:  "
+		    "qla4xxx_isns_build_server_request_response_packet "
+		    "failed\n", ha->host_no, __func__));
+		qla4xxx_free_pdu(ha, pdu_entry);
+		return QLA_ERROR;
+	}
+
+	isns_rsp_message = (ISNSP_MESSAGE_HEADER *) pdu_entry->Buff;
+	isns_response = (ISNSP_RESPONSE_HEADER *) &
+	    isns_rsp_message->payload[0];
+	payload_start = (uint8_t *) isns_response;
+	rsp_buffer_end = (uint8_t *) (pdu_entry->Buff + pdu_entry->BuffLen);
+	ptr = &isns_response->attributes[0];
+	req_buffer_end = (uint8_t *) ((uint8_t *) &
+	    isns_req_message->payload[0] +
+	    be16_to_cpu(isns_req_message->pdu_length));
+
+	/* Point to the source attribute in the request.  We need to return */
+	/* all attributes in the ESI Response. */
+	attr = (ISNS_ATTRIBUTE *) & isns_req_message->payload[0];
+
+	/* Copy source attributes to return buffer. */
+	copy_size = req_buffer_end - (uint8_t *) attr;
+	if (ptr + copy_size < rsp_buffer_end) {
+		/* Attributes will fit in the response buffer.  Go ahead */
+		/* and copy them. */
+		memcpy(ptr, attr, copy_size);
+		ptr += copy_size;
+	} else {
+		DEBUG5(printk("scsi%ld: %s: Insufficient buffer size\n",
+		    ha->host_no, __func__));
+	}
+
+	/* We've successfully finished building the response packet. */
+	/* Set the size field. */
+	isns_rsp_message->pdu_length = cpu_to_be16((unsigned long)ptr -
+	    (unsigned long) payload_start);
+	packet_size = (unsigned long)ptr - (unsigned long)pdu_entry->Buff;
+	pdu_entry->SendBuffLen = packet_size;
+	pdu_entry->RecvBuffLen = 0;
+	if (qla4xxx_send_passthru0_iocb(ha, ISNS_DEVICE_INDEX, ConnectionId,
+	    pdu_entry->DmaBuff, pdu_entry->SendBuffLen, pdu_entry->RecvBuffLen,
+	    PT_FLAG_ISNS_PDU, qla4xxx_isns_build_iocb_handle(ha,
+		    ISNS_ASYNCH_RSP_PDU, pdu_entry)) != QLA_SUCCESS) {
+		DEBUG5(printk("scsi%ld: %s:  "
+		    "qla4xxx_send_passthru0_iocb failed\n", ha->host_no,
+		    __func__));
+		qla4xxx_free_pdu(ha, pdu_entry);
+		return QLA_ERROR;
+	}
+	return QLA_SUCCESS;
+}
+
+int
+qla4xxx_isns_server_request_error(scsi_qla_host_t *ha, uint8_t *buffer,
+    uint32_t buffer_size, uint16_t connection_id, uint32_t error_code)
+{
+	PDU_ENTRY *pdu_entry;
+	ISNSP_MESSAGE_HEADER *isns_message;
+	uint16_t function_id;
+	uint32_t packet_size;
+	isns_message = (ISNSP_MESSAGE_HEADER *) buffer;
+	function_id = be16_to_cpu(isns_message->function_id);
+
+	// Return "Message Format Error"
+	if ((pdu_entry = qla4xxx_get_pdu(ha, sizeof(ISNSP_MESSAGE_HEADER) +
+	    sizeof(uint32_t))) == NULL) {
+		DEBUG5(printk("scsi%ld: %s:  qla4xxx_get_pdu failed\n",
+		    ha->host_no, __func__));
+		return QLA_ERROR;
+	}
+
+	if (qla4xxx_isns_build_server_request_response_packet(ha,
+	    pdu_entry->Buff, pdu_entry->BuffLen,
+	    be16_to_cpu(isns_message->function_id) | 0x8000, error_code,
+	    be16_to_cpu(isns_message->transaction_id), &packet_size) !=
+	    QLA_SUCCESS) {
+		DEBUG5(printk("scsi%ld: %s:  "
+		    "qla4xxx_isns_build_server_request_response_packet "
+		    "failed\n", ha->host_no, __func__));
+		qla4xxx_free_pdu(ha, pdu_entry);
+		return QLA_ERROR;
+	}
+
+	pdu_entry->SendBuffLen = packet_size;
+	pdu_entry->RecvBuffLen = 0;
+	if (qla4xxx_send_passthru0_iocb(ha, ISNS_DEVICE_INDEX, connection_id,
+	    pdu_entry->DmaBuff, pdu_entry->SendBuffLen, pdu_entry->RecvBuffLen,
+	    PT_FLAG_ISNS_PDU, qla4xxx_isns_build_iocb_handle(ha,
+		    ISNS_ASYNCH_RSP_PDU, pdu_entry)) != QLA_SUCCESS) {
+		DEBUG5(printk("scsi%ld: %s:  "
+		    "qla4xxx_send_passthru0_iocb failed\n", ha->host_no,
+		    __func__));
+		qla4xxx_free_pdu(ha, pdu_entry);
+		return QLA_ERROR;
+	}
+	return QLA_SUCCESS;
+}
+
+int
+qla4xxx_isns_parse_and_dispatch_server_request(scsi_qla_host_t *ha,
+    uint8_t *buffer, uint32_t buffer_size, uint16_t connection_id)
+{
+	ISNSP_MESSAGE_HEADER *isns_message;
+	uint16_t function_id;
+	uint16_t transaction_id;
+	isns_message = (ISNSP_MESSAGE_HEADER *) buffer;
+	function_id = be16_to_cpu(isns_message->function_id);
+	transaction_id = be16_to_cpu(isns_message->transaction_id);
+
+	/* Validate pdu_length specified in the iSNS message header. */
+	if ((offsetof(ISNSP_MESSAGE_HEADER, payload) +
+	    be16_to_cpu(isns_message->pdu_length)) > buffer_size) {
+		DEBUG5(printk("scsi%ld: %s: Invalid message size %u "
+		    "%u\n", ha->host_no, __func__,
+		    (uint32_t) (offsetof(ISNSP_MESSAGE_HEADER, payload) +
+			be16_to_cpu(isns_message->pdu_length)), buffer_size));
+		if (function_id <= ISNS_FCID_ESI) {
+			return qla4xxx_isns_server_request_error(ha, buffer,
+			    buffer_size, connection_id, ISNS_ERR_MSG_FORMAT);
+		}
+		return QLA_ERROR;
+	}
+
+	/* It is safe to assume from this point on that the pdu_length value */
+	/* (and thus our idea about the end of the buffer) is valid. */
+	switch (function_id) {
+	case ISNS_FCID_SCN:
+		return qla4xxx_isns_scn(ha, buffer, buffer_size, connection_id);
+		break;
+
+	case ISNS_FCID_ESI:
+		return qla4xxx_isns_esi(ha, buffer, buffer_size, connection_id);
+		break;
+
+	default:
+		if (function_id <= ISNS_FCID_ESI) {
+			/* Return "Message Not Supported" */
+			return qla4xxx_isns_server_request_error(ha, buffer,
+			    buffer_size, connection_id,
+			    ISNS_ERR_MSG_NOT_SUPPORTED);
+		}
+		return QLA_ERROR;
+		break;
+	}
+	return QLA_SUCCESS;
+}
+
+int
+qla4xxx_isns_parse_and_dispatch_server_response(scsi_qla_host_t *ha,
+    uint8_t *buffer, uint32_t buffer_size)
+{
+	ISNSP_MESSAGE_HEADER *isns_message;
+	ISNSP_RESPONSE_HEADER *isns_response;
+	ISNS_ATTRIBUTE *isns_attr;
+	uint16_t function_id;
+	uint16_t transaction_id;
+	uint8_t *buffer_end;
+
+	isns_message = (ISNSP_MESSAGE_HEADER *) buffer;
+	buffer_end = (uint8_t *) ((uint8_t *) isns_message->payload +
+	    be16_to_cpu(isns_message->pdu_length));
+	isns_attr = (ISNS_ATTRIBUTE *) isns_message->payload;
+
+	/* Validate pdu_length specified in the iSNS message header. */
+	if (((uint32_t *) buffer_end - (uint32_t *) buffer) > buffer_size) {
+		DEBUG5(printk("scsi%ld: %s: Invalid message size %u "
+		    "%u\n", ha->host_no, __func__,
+		    (unsigned int)((uint32_t *) buffer_end -
+			(uint32_t *) buffer), buffer_size));
+		return QLA_ERROR;
+	}
+	transaction_id = be16_to_cpu(isns_message->transaction_id);
+	function_id = be16_to_cpu(isns_message->function_id);
+
+	/*
+	 * It is safe to assume from this point on that the pdu_length value
+	 * (and thus our idea about the end of the buffer) is valid.
+	 */
+	if (transaction_id > ha->isns_transaction_id) {
+		DEBUG5(printk("scsi%ld: %s: Invalid message "
+		    "transaction ID recv %x exp %x\n", ha->host_no, __func__,
+		    transaction_id, ha->isns_transaction_id));
+		DEBUG5(qla4xxx_dump_bytes(buffer, buffer_size));
+		set_bit(DPC_ISNS_RESTART, &ha->dpc_flags);
+		return QLA_ERROR;
+	}
+	isns_response = (ISNSP_RESPONSE_HEADER *) & isns_message->payload[0];
+
+	switch (function_id) {
+	case ISNS_FCID_DevAttrRegRsp:
+		DEBUG5(printk("scsi%ld: %s: received %d "
+		    "DevAttrRegRsp\n", ha->host_no, __func__, transaction_id));
+		return qla4xxx_isns_dev_attr_reg_rsp(ha, buffer, buffer_size);
+
+	case ISNS_FCID_DevAttrQryRsp:
+		return qla4xxx_isns_dev_attr_qry_rsp(ha, buffer, buffer_size);
+
+	case ISNS_FCID_DevGetNextRsp:
+		return qla4xxx_isns_dev_get_next_rsp(ha, buffer, buffer_size);
+
+	case ISNS_FCID_DevDeregRsp:
+		return qla4xxx_isns_dev_dereg_rsp(ha, buffer, buffer_size);
+
+	case ISNS_FCID_SCNRegRsp:
+		return qla4xxx_isns_scn_reg_rsp(ha, buffer, buffer_size);
+
+	case ISNS_FCID_SCNDeregRsp:
+		return qla4xxx_isns_scn_dereg_rsp(ha, buffer, buffer_size);
+
+	default:
+		DEBUG5(printk("scsi%ld: %s: Received %d Unknown iSNS "
+		    "function_id %x\n", ha->host_no, __func__, transaction_id,
+		    function_id));
+		break;
+	}
+	return QLA_SUCCESS;
+}
+
+int
+qla4xxx_isns_dev_attr_reg(scsi_qla_host_t *ha)
+{
+	PDU_ENTRY *pdu_entry;
+	uint32_t packet_size;
+
+	pdu_entry = qla4xxx_get_pdu(ha, PAGE_SIZE);
+	if (pdu_entry == NULL) {
+		DEBUG5(printk("scsi%ld: %s: get pdu failed\n",
+		    ha->host_no, __func__));
+		return QLA_ERROR;
+	}
+
+	if (qla4xxx_isns_build_registration_packet(ha, pdu_entry->Buff,
+	    pdu_entry->BuffLen, ha->isns_entity_id, ha->ip_address,
+	    ha->isns_remote_port_num, ha->isns_scn_port_num,
+	    ha->isns_esi_port_num, ha->alias, &packet_size) != QLA_SUCCESS) {
+		DEBUG5(printk("scsi%ld: %s: "
+		    "qla4xxx_isns_build_registration_packet failed\n",
+		    ha->host_no, __func__));
+		qla4xxx_free_pdu(ha, pdu_entry);
+		return QLA_ERROR;
+	}
+	pdu_entry->SendBuffLen = packet_size;
+	pdu_entry->RecvBuffLen = pdu_entry->BuffLen;
+	DEBUG5(printk("---------------------------\n"));
+	DEBUG5(printk("scsi%ld: %s:                    sending %d "
+	    "DevAttrReg\n", ha->host_no, __func__, ha->isns_transaction_id));
+	DEBUG5(printk("PDU (0x%p) 0x%x ->\n", pdu_entry->Buff,
+	    pdu_entry->SendBuffLen));
+	DEBUG5(qla4xxx_dump_bytes(pdu_entry->Buff, pdu_entry->SendBuffLen));
+	DEBUG5(printk("scsi%ld: %s: Registering iSNS . . .\n",
+	    ha->host_no, __func__));
+	if (qla4xxx_send_passthru0_iocb(ha, ISNS_DEVICE_INDEX,
+	    ISNS_DEFAULT_SERVER_CONN_ID, pdu_entry->DmaBuff,
+	    pdu_entry->SendBuffLen, pdu_entry->RecvBuffLen, PT_FLAG_ISNS_PDU |
+	    PT_FLAG_WAIT_4_RESPONSE, qla4xxx_isns_build_iocb_handle(ha,
+		    ISNS_REQ_RSP_PDU, pdu_entry)) != QLA_SUCCESS) {
+		DEBUG5(printk("scsi%ld: %s: "
+		    "qla4xxx_send_passthru0_iocb failed\n", ha->host_no,
+		    __func__));
+		qla4xxx_free_pdu(ha, pdu_entry);
+		return QLA_ERROR;
+	}
+	ha->isns_transaction_id++;
+	return QLA_SUCCESS;
+}
+
+int
+qla4xxx_isns_dev_attr_reg_rsp(scsi_qla_host_t *ha, uint8_t *buffer,
+    uint32_t buffer_size)
+{
+	ISNSP_MESSAGE_HEADER *isns_message;
+	ISNSP_RESPONSE_HEADER *isns_response;
+	uint32_t error_code;
+
+	isns_message = (ISNSP_MESSAGE_HEADER *) buffer;
+	isns_response = (ISNSP_RESPONSE_HEADER *) & isns_message->payload[0];
+	error_code = be32_to_cpu(isns_response->error_code);
+	if (error_code) {
+		DEBUG5(printk("scsi%ld: %s: iSNS DevAttrReg failed, "
+		    "error code (%x) \"%s\"\n", ha->host_no, __func__,
+		    error_code, isns_error_code_msg[error_code]));
+		clear_bit(ISNS_FLAG_ISNS_SRV_REGISTERED, &ha->isns_flags);
+		return QLA_ERROR;
+	}
+	set_bit(ISNS_FLAG_ISNS_SRV_REGISTERED, &ha->isns_flags);
+	if (qla4xxx_isns_scn_reg(ha) != QLA_SUCCESS) {
+		DEBUG5(printk("scsi%ld: %s: qla4xxx_isns_scn_reg "
+		    "failed\n", ha->host_no, __func__));
+		return QLA_ERROR;
+	}
+	return QLA_SUCCESS;
+}
+
+int
+qla4xxx_isns_scn_reg(scsi_qla_host_t *ha)
+{
+	PDU_ENTRY *isns_pdu_entry;
+	uint32_t packet_size;
+
+	if ((isns_pdu_entry = qla4xxx_get_pdu(ha, PAGE_SIZE)) == NULL) {
+		DEBUG5(printk("scsi%ld: %s: qla4xxx_get_pdu failed\n",
+		    ha->host_no, __func__));
+		return QLA_ERROR;
+	}
+	if (qla4xxx_isns_build_scn_registration_packet(ha,
+	    isns_pdu_entry->Buff, isns_pdu_entry->BuffLen, &packet_size) !=
+	    QLA_SUCCESS) {
+		DEBUG5(printk("scsi%ld: %s: qla4xxx_isns_build_scn_"
+		    "registration_packet failed\n", ha->host_no, __func__));
+		qla4xxx_free_pdu(ha, isns_pdu_entry);
+		return QLA_ERROR;
+	}
+	isns_pdu_entry->SendBuffLen = packet_size;
+	isns_pdu_entry->RecvBuffLen = isns_pdu_entry->BuffLen;
+	DEBUG5(printk("---------------------------\n"));
+	DEBUG5(printk("scsi%ld :%s:                        sending  "
+	    "%d SCNReg\n", ha->host_no, __func__, ha->isns_transaction_id));
+	DEBUG5(printk("PDU (0x%p) 0x%x ->\n", isns_pdu_entry->Buff,
+	    isns_pdu_entry->SendBuffLen));
+	DEBUG5(qla4xxx_dump_bytes(isns_pdu_entry->Buff,
+	    isns_pdu_entry->SendBuffLen));
+	if (qla4xxx_send_passthru0_iocb(ha, ISNS_DEVICE_INDEX,
+	    ISNS_DEFAULT_SERVER_CONN_ID, isns_pdu_entry->DmaBuff,
+	    isns_pdu_entry->SendBuffLen, isns_pdu_entry->RecvBuffLen,
+	    PT_FLAG_ISNS_PDU | PT_FLAG_WAIT_4_RESPONSE,
+	    qla4xxx_isns_build_iocb_handle(ha, ISNS_REQ_RSP_PDU,
+		    isns_pdu_entry)) != QLA_SUCCESS) {
+		DEBUG5(printk("scsi%ld: %s: "
+		    "qla4xxx_send_passthru0_iocb failed\n", ha->host_no,
+		    __func__));
+		qla4xxx_free_pdu(ha, isns_pdu_entry);
+		return QLA_ERROR;
+	}
+	ha->isns_transaction_id++;
+	return QLA_SUCCESS;
+}
+
+int
+qla4xxx_isns_scn_reg_rsp(scsi_qla_host_t *ha, uint8_t *buffer,
+    uint32_t buffer_size)
+{
+	ISNSP_MESSAGE_HEADER *isns_message;
+	ISNSP_RESPONSE_HEADER *isns_response;
+
+	isns_message = (ISNSP_MESSAGE_HEADER *) buffer;
+	isns_response = (ISNSP_RESPONSE_HEADER *) isns_message->payload;
+	if (isns_response->error_code) {
+		DEBUG5(printk("scsi%ld: %s: iSNS SCNReg failed, error "
+		    "code %x\n", ha->host_no, __func__,
+		    be32_to_cpu(isns_response->error_code)));
+		clear_bit(ISNS_FLAG_ISNS_SCN_REGISTERED, &ha->isns_flags);
+		return QLA_ERROR;
+	}
+	set_bit(ISNS_FLAG_ISNS_SCN_REGISTERED, &ha->isns_flags);
+	ha->isns_num_discovered_targets = 0;
+	if (qla4xxx_isns_dev_get_next(ha, NULL) != QLA_SUCCESS) {
+		DEBUG5(printk("scsi%ld: %s: qla4xxx_isns_dev_get_next "
+		    "failed\n", ha->host_no, __func__));
+	}
+	return QLA_SUCCESS;
+}
+
+int
+qla4xxx_isns_dev_attr_qry(scsi_qla_host_t *ha, uint8_t *last_iscsi_name)
+{
+	PDU_ENTRY *pdu_entry;
+	uint32_t packet_size;
+
+	if ((pdu_entry = qla4xxx_get_pdu(ha, PAGE_SIZE)) == NULL) {
+		DEBUG5(printk("scsi%ld: %s:  qla4xxx_get_pdu failed\n",
+		    ha->host_no, __func__));
+		return QLA_ERROR;
+	}
+	if (qla4xxx_isns_build_dev_attr_qry_packet(ha, pdu_entry->Buff,
+	    pdu_entry->BuffLen, last_iscsi_name, &packet_size) != QLA_SUCCESS) {
+		DEBUG5(printk("scsi%ld: %s:  "
+		    "qla4xxx_isns_build_dev_attr_qry_packet failed\n",
+		    ha->host_no, __func__));
+		qla4xxx_free_pdu(ha, pdu_entry);
+		return QLA_ERROR;
+	}
+	pdu_entry->SendBuffLen = packet_size;
+	pdu_entry->RecvBuffLen = pdu_entry->BuffLen;
+	DEBUG5(printk("---------------------------\n"));
+	DEBUG5(printk("scsi%ld: %s:                     sending  %d "
+	    "DevAttrQry\n", ha->host_no, __func__, ha->isns_transaction_id));
+	DEBUG5(printk("PDU (0x%p) 0x%x ->\n", pdu_entry->Buff,
+	    pdu_entry->SendBuffLen));
+	DEBUG5(qla4xxx_dump_bytes(pdu_entry->Buff, pdu_entry->SendBuffLen));
+	if (qla4xxx_send_passthru0_iocb(ha, ISNS_DEVICE_INDEX,
+	    ISNS_DEFAULT_SERVER_CONN_ID, pdu_entry->DmaBuff,
+	    pdu_entry->SendBuffLen, pdu_entry->RecvBuffLen, PT_FLAG_ISNS_PDU |
+	    PT_FLAG_WAIT_4_RESPONSE, qla4xxx_isns_build_iocb_handle(ha,
+		    ISNS_REQ_RSP_PDU, pdu_entry)) != QLA_SUCCESS) {
+		qla4xxx_free_pdu(ha, pdu_entry);
+		return QLA_ERROR;
+	}
+	ha->isns_transaction_id++;
+	return QLA_SUCCESS;
+}
+
+int
+qla4xxx_isns_dev_attr_qry_rsp(scsi_qla_host_t *ha, uint8_t *buffer,
+    uint32_t buffer_size)
+{
+	uint8_t *last_iscsi_name = NULL;
+	ISNS_DISCOVERED_TARGET *discovered_target = NULL;
+	uint32_t isns_error;
+	int i;
+	uint8_t bIsTarget = 1;
+	uint8_t bFound = 0;
+	int status = QLA_SUCCESS;
+
+	if (test_bit(ISNS_FLAG_SCN_RESTART, &ha->isns_flags)) {
+		clear_bit(ISNS_FLAG_SCN_RESTART, &ha->isns_flags);
+		ha->isns_num_discovered_targets = 0;
+		if (qla4xxx_isns_dev_get_next(ha, NULL) != QLA_SUCCESS) {
+			DEBUG5(printk("scsi%ld: %s: "
+			    "qla4xxx_isns_dev_get_next failed\n", ha->host_no,
+			    __func__));
+			goto exit_qry_rsp_clear_flags;
+		}
+		goto exit_qry_rsp;
+	}
+	last_iscsi_name = kmalloc(256, GFP_ATOMIC);
+	discovered_target = kmalloc(sizeof(*discovered_target), GFP_ATOMIC);
+	if (!last_iscsi_name || !discovered_target) {
+		DEBUG5(printk("scsi%ld: %s: failed to allocate "
+		    "memory\n", ha->host_no, __func__));
+		status = QLA_ERROR;
+		goto exit_qry_rsp;
+	}
+	memset(last_iscsi_name, 0, 256);
+	memset(discovered_target, 0, sizeof(ISNS_DISCOVERED_TARGET));
+	if (qla4xxx_isns_parse_query_response(ha, buffer, buffer_size,
+	    &isns_error, discovered_target, &bIsTarget, last_iscsi_name) ==
+	    QLA_SUCCESS) {
+		if (bIsTarget && discovered_target->NameString[0] &&
+		    discovered_target->NumPortals) {
+			for (i = 0; i < ha->isns_num_discovered_targets; i++) {
+				if (!strcmp(discovered_target->NameString,
+				    ha->isns_disc_tgt_databasev[i].
+				    NameString)) {
+					DEBUG5(printk("scsi%ld: %s: "
+					    "found at index %x\n", ha->host_no,
+					    __func__, i));
+					memcpy(&ha->isns_disc_tgt_databasev[i],
+					    discovered_target,
+					    sizeof(ISNS_DISCOVERED_TARGET));
+					ha->isns_disc_tgt_databasev[i] =
+					    *discovered_target;
+					bFound = 1;
+					break;
+				}
+			}
+			if (!bFound && i < MAX_ISNS_DISCOVERED_TARGETS) {
+				DEBUG5(printk("scsi%ld: %s: not "
+				    "already present, put in index %x\n",
+				    ha->host_no, __func__, i));
+				memcpy(&ha->isns_disc_tgt_databasev[i],
+				    discovered_target,
+				    sizeof(ISNS_DISCOVERED_TARGET));
+				ha->isns_num_discovered_targets++;
+			}
+		}
+	}
+	if (test_bit(ISNS_FLAG_QUERY_SINGLE_OBJECT, &ha->isns_flags))
+		goto exit_qry_rsp_clear_flags;
+	else if (last_iscsi_name[0] == 0)
+		goto exit_qry_rsp_clear_flags;
+	else {
+		if (qla4xxx_isns_dev_get_next(ha, last_iscsi_name) !=
+		    QLA_SUCCESS) {
+			DEBUG5(printk("scsi%ld: %s: "
+			    "qla4xxx_isns_dev_get_next failed\n", ha->host_no,
+			    __func__));
+			goto exit_qry_rsp_clear_flags;
+		}
+	}
+	goto exit_qry_rsp;
+exit_qry_rsp_clear_flags:
+	ISNS_CLEAR_FLAGS(ha);
+
+exit_qry_rsp:
+	if (last_iscsi_name)
+		kfree(last_iscsi_name);
+	if (discovered_target)
+		kfree(discovered_target);
+	return status;
+}
+
+int
+qla4xxx_isns_dev_get_next(scsi_qla_host_t *ha, uint8_t *last_iscsi_name)
+{
+	PDU_ENTRY *pdu_entry;
+	uint32_t packet_size;
+
+	if ((pdu_entry = qla4xxx_get_pdu(ha, PAGE_SIZE)) == NULL)
+		return QLA_ERROR;
+
+	if (qla4xxx_isns_build_dev_get_next_packet(ha, pdu_entry->Buff,
+	    pdu_entry->BuffLen, last_iscsi_name, &packet_size) !=
+	    QLA_SUCCESS) {
+		DEBUG5(printk("scsi%ld: %s:  "
+		    "qla4xxx_isns_build_dev_get_next_packet failed\n",
+		    ha->host_no, __func__));
+		qla4xxx_free_pdu(ha, pdu_entry);
+		return QLA_ERROR;
+	}
+	pdu_entry->SendBuffLen = packet_size;
+	pdu_entry->RecvBuffLen = pdu_entry->BuffLen;
+	DEBUG5(printk("---------------------------\n"));
+	DEBUG5(printk("scsi%ld: %s:                     sending  %d "
+	    "DevGetNext\n", ha->host_no, __func__, ha->isns_transaction_id));
+	DEBUG5(printk("PDU (0x%p) 0x%x ->\n", pdu_entry->Buff,
+	    pdu_entry->SendBuffLen));
+	DEBUG5(qla4xxx_dump_bytes(pdu_entry->Buff, pdu_entry->SendBuffLen));
+	if (qla4xxx_send_passthru0_iocb(ha, ISNS_DEVICE_INDEX,
+	    ISNS_DEFAULT_SERVER_CONN_ID, pdu_entry->DmaBuff,
+	    pdu_entry->SendBuffLen, pdu_entry->RecvBuffLen, PT_FLAG_ISNS_PDU |
+	    PT_FLAG_WAIT_4_RESPONSE, qla4xxx_isns_build_iocb_handle(ha,
+		    ISNS_REQ_RSP_PDU, pdu_entry)) != QLA_SUCCESS) {
+		DEBUG5(printk("scsi%ld: %s:  "
+		    "qla4xxx_send_passthru0_iocb failed\n", ha->host_no,
+		    __func__));
+		qla4xxx_free_pdu(ha, pdu_entry);
+		return QLA_ERROR;
+	}
+	ha->isns_transaction_id++;
+	return QLA_SUCCESS;
+}
+
+int
+qla4xxx_isns_dev_get_next_rsp(scsi_qla_host_t *ha, uint8_t *buffer,
+    uint32_t buffer_size)
+{
+	uint32_t isns_error = 0;
+	uint8_t bIsTarget;
+	static uint8_t last_iscsi_name[256];
+
+	if (test_bit(ISNS_FLAG_SCN_RESTART, &ha->isns_flags)) {
+		clear_bit(ISNS_FLAG_SCN_RESTART, &ha->isns_flags);
+		ha->isns_num_discovered_targets = 0;
+		if (qla4xxx_isns_dev_get_next(ha, NULL) != QLA_SUCCESS) {
+			DEBUG5(printk("scsi%ld: %s: "
+			    "qla4xxx_isns_dev_get_next failed\n", ha->host_no,
+			    __func__));
+			goto exit_get_next_rsp;
+		}
+		return QLA_SUCCESS;
+	}
+	if (qla4xxx_isns_parse_get_next_response(ha, buffer, buffer_size,
+	    &isns_error, &last_iscsi_name[0], sizeof(last_iscsi_name) - 1,
+	    &bIsTarget) != QLA_SUCCESS) {
+		if (isns_error != ISNS_ERR_NO_SUCH_ENTRY) {
+			DEBUG5(printk("scsi%ld: %s: "
+			    "qla4xxx_isns_parse_get_next_response failed\n",
+			    ha->host_no, __func__));
+		}
+		goto exit_get_next_rsp;
+	}
+#if 1
+	if (bIsTarget) {
+		if (qla4xxx_isns_dev_attr_qry(ha, &last_iscsi_name[0]) !=
+		    QLA_SUCCESS) {
+			DEBUG5(printk("scsi%ld: %s: "
+			    "qla4xxx_isns_dev_attr_qry failed\n", ha->host_no,
+			    __func__));
+			goto exit_get_next_rsp;
+		}
+	} else {
+		if (qla4xxx_isns_dev_get_next(ha, &last_iscsi_name[0]) !=
+		    QLA_SUCCESS) {
+			DEBUG5(printk("scsi%ld: %s: "
+			    "qla4xxx_isns_dev_get_next failed\n", ha->host_no,
+			    __func__));
+			goto exit_get_next_rsp;
+		}
+	}
+#else
+	if (qla4xxx_isns_dev_attr_qry(ha, &last_iscsi_name[0]) != QLA_SUCCESS) {
+		DEBUG5(printk("scsi%ld: %s: "
+		    "qla4xxx_isns_dev_attr_qry failed\n", ha->host_no,
+		    __func__));
+		goto exit_get_next_rsp;
+	}
+#endif
+	return QLA_SUCCESS;
+
+exit_get_next_rsp:
+	clear_bit(ISNS_FLAG_SCN_IN_PROGRESS, &ha->isns_flags);
+	clear_bit(ISNS_FLAG_SCN_RESTART, &ha->isns_flags);
+	return QLA_SUCCESS;
+}
+
+int
+qla4xxx_isns_dev_dereg(scsi_qla_host_t *ha)
+{
+	PDU_ENTRY *pdu_entry;
+	uint32_t packet_size;
+
+	if ((pdu_entry = qla4xxx_get_pdu(ha, PAGE_SIZE)) == NULL) {
+		DEBUG5(printk("scsi%ld: %s:  qla4xxx_get_pdu failed\n",
+		    ha->host_no, __func__));
+		return QLA_ERROR;
+	}
+	if (qla4xxx_isns_build_deregistration_packet(ha, pdu_entry->Buff,
+	    pdu_entry->BuffLen, ha->isns_entity_id, ha->isns_ip_address,
+	    ha->isns_server_port_number, &packet_size) != QLA_SUCCESS) {
+		DEBUG5(printk("scsi%ld: %s:  "
+		    "QLiSNSBuildDeregistrationPacket failed\n", ha->host_no,
+		    __func__));
+		qla4xxx_free_pdu(ha, pdu_entry);
+		return QLA_ERROR;
+	}
+	pdu_entry->SendBuffLen = packet_size;
+	pdu_entry->RecvBuffLen = pdu_entry->BuffLen;
+	DEBUG5(printk("---------------------------\n"));
+	DEBUG5(printk("scsi%ld: %s:                       sending  "
+	    "%d DevDereg\n", ha->host_no, __func__, ha->isns_transaction_id));
+	DEBUG5(printk("PDU (0x%p) 0x%x ->\n", pdu_entry->Buff,
+	    pdu_entry->SendBuffLen));
+	DEBUG5(qla4xxx_dump_bytes(pdu_entry->Buff, pdu_entry->SendBuffLen));
+	if (qla4xxx_send_passthru0_iocb(ha, ISNS_DEVICE_INDEX,
+	    ISNS_DEFAULT_SERVER_CONN_ID, pdu_entry->DmaBuff,
+	    pdu_entry->SendBuffLen, pdu_entry->RecvBuffLen, PT_FLAG_ISNS_PDU |
+	    PT_FLAG_WAIT_4_RESPONSE, qla4xxx_isns_build_iocb_handle(ha,
+		    ISNS_REQ_RSP_PDU, pdu_entry)) != QLA_SUCCESS) {
+		DEBUG5(printk("scsi%ld: %s:  "
+		    "qla4xxx_send_passthru0_iocb failed\n", ha->host_no,
+		    __func__));
+		qla4xxx_free_pdu(ha, pdu_entry);
+		return QLA_ERROR;
+	}
+	ha->isns_transaction_id++;
+	return QLA_SUCCESS;
+}
+
+int
+qla4xxx_isns_dev_dereg_rsp(scsi_qla_host_t *ha, uint8_t *buffer,
+    uint32_t buffer_size)
+{
+	ISNSP_MESSAGE_HEADER *isns_message;
+	ISNSP_RESPONSE_HEADER *isns_response;
+
+	isns_message = (ISNSP_MESSAGE_HEADER *) buffer;
+	isns_response = (ISNSP_RESPONSE_HEADER *) & isns_message->payload[0];
+	clear_bit(ISNS_FLAG_ISNS_SRV_REGISTERED, &ha->isns_flags);
+	if (be32_to_cpu(isns_response->error_code)) {
+		DEBUG5(printk("scsi%ld: %s: iSNS SCNDereg rsp code "
+		    "%x\n", ha->host_no, __func__,
+		    be32_to_cpu(isns_response->error_code)));
+	}
+	if (test_bit(ISNS_FLAG_REREGISTER, &ha->isns_flags)) {
+		clear_bit(ISNS_FLAG_REREGISTER, &ha->isns_flags);
+		if (qla4xxx_isns_dev_attr_reg(ha) != QLA_SUCCESS) {
+			DEBUG5(printk("scsi%ld: %s: "
+			    "qla4xxx_isns_dev_attr_reg failed\n", ha->host_no,
+			    __func__));
+			return QLA_ERROR;
+		}
+	}
+	return QLA_SUCCESS;
+}
+
+int
+qla4xxx_isns_scn_dereg(scsi_qla_host_t *ha)
+{
+	PDU_ENTRY *pdu_entry;
+	uint32_t packet_size;
+
+	if ((pdu_entry = qla4xxx_get_pdu(ha, PAGE_SIZE)) == NULL) {
+		DEBUG5(printk("scsi%ld: %s:  qla4xxx_get_pdu failed\n",
+		    ha->host_no, __func__));
+		return QLA_ERROR;
+	}
+	if (qla4xxx_isns_build_scn_deregistration_packet(ha, pdu_entry->Buff,
+	    pdu_entry->BuffLen, &packet_size) != QLA_SUCCESS) {
+		DEBUG5(printk("scsi%ld: %s:  qla4xxx_isns_build_scn_"
+		    "deregistration_packet failed\n", ha->host_no, __func__));
+		qla4xxx_free_pdu(ha, pdu_entry);
+		return QLA_ERROR;
+	}
+	pdu_entry->SendBuffLen = packet_size;
+	pdu_entry->RecvBuffLen = pdu_entry->BuffLen;
+	DEBUG5(printk("---------------------------\n"));
+	DEBUG5(printk("scsi%ld: %s:                       sending  "
+	    "%d SCNDereg\n", ha->host_no, __func__, ha->isns_transaction_id));
+	DEBUG5(printk("PDU (0x%p) 0x%x ->\n", pdu_entry->Buff,
+	    pdu_entry->SendBuffLen));
+	DEBUG5(qla4xxx_dump_bytes(pdu_entry->Buff, pdu_entry->SendBuffLen));
+	clear_bit(ISNS_FLAG_DEV_SCAN_DONE, &ha->isns_flags);
+
+	if (qla4xxx_send_passthru0_iocb(ha, ISNS_DEVICE_INDEX,
+	    ISNS_DEFAULT_SERVER_CONN_ID, pdu_entry->DmaBuff,
+	    pdu_entry->SendBuffLen, pdu_entry->RecvBuffLen, PT_FLAG_ISNS_PDU |
+	    PT_FLAG_WAIT_4_RESPONSE, qla4xxx_isns_build_iocb_handle(ha,
+		    ISNS_REQ_RSP_PDU, pdu_entry)) != QLA_SUCCESS) {
+		DEBUG5(printk("scsi%ld: %s:  "
+		    "qla4xxx_send_passthru0_iocb failed\n", ha->host_no,
+		    __func__));
+		qla4xxx_free_pdu(ha, pdu_entry);
+		return QLA_ERROR;
+	}
+	ha->isns_transaction_id++;
+	return QLA_SUCCESS;
+}
+
+int
+qla4xxx_isns_scn_dereg_rsp(scsi_qla_host_t *ha, uint8_t *buffer,
+    uint32_t buffer_size)
+{
+	ISNSP_MESSAGE_HEADER *isns_message;
+	ISNSP_RESPONSE_HEADER *isns_response;
+
+	isns_message = (ISNSP_MESSAGE_HEADER *) buffer;
+	isns_response = (ISNSP_RESPONSE_HEADER *) & isns_message->payload[0];
+	clear_bit(ISNS_FLAG_ISNS_SCN_REGISTERED, &ha->isns_flags);
+	if (be32_to_cpu(isns_response->error_code)) {
+		DEBUG5(printk("scsi%ld: %s: iSNS SCNDereg rsp code "
+		    "%x\n", ha->host_no, __func__,
+		    be32_to_cpu(isns_response->error_code)));
+	}
+	if (test_bit(ISNS_FLAG_REREGISTER, &ha->isns_flags)) {
+		if (qla4xxx_isns_dev_dereg(ha) != QLA_SUCCESS) {
+			DEBUG5(printk("scsi%ld: %s: QLiSNSDevDereg "
+			    "failed\n", ha->host_no, __func__));
+			return QLA_ERROR;
+		}
+	}
+	return QLA_SUCCESS;
+}
diff --git a/drivers/scsi/qla4xxx/ql4_isns.h b/drivers/scsi/qla4xxx/ql4_isns.h
new file mode 100644
--- /dev/null
+++ b/drivers/scsi/qla4xxx/ql4_isns.h
@@ -0,0 +1,401 @@
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
+#define ISNSP_VERSION           0x0001	// Current iSNS version as defined by
+// the latest spec that we support
+
+/* Swap Macros
+ *
+ * These are designed to be used on constants (such as the function codes
+ * below) such that the swapping is done by the compiler at compile time
+ * and not at run time.  Of course, they should also work on variables
+ * in which case the swapping will occur at run time.
+ */
+#define WSWAP(x) (uint16_t)(((((uint16_t)x)<<8)&0xFF00) | \
+                            ((((uint16_t)x)>>8)&0x00FF))
+#define DWSWAP(x) (uint32_t)(((((uint32_t)x)<<24)&0xFF000000) | \
+		             ((((uint32_t)x)<<8)&0x00FF0000) |  \
+		             ((((uint32_t)x)>>8)&0x0000FF00) |  \
+		             ((((uint32_t)x)>>24)&0x000000FF))
+
+/*
+ * Timeout Values
+ *******************/
+#define ISNS_RESTART_TOV	5
+
+#define IOCB_ISNS_PT_PDU_TYPE(x)                      ((x) & 0x0F000000)
+#define IOCB_ISNS_PT_PDU_INDEX(x)                     ((x) & (MAX_PDU_ENTRIES-1))
+
+#define ISNS_ASYNCH_REQ_PDU                           0x01000000
+#define ISNS_ASYNCH_RSP_PDU                           0x02000000
+#define ISNS_REQ_RSP_PDU                              0x03000000
+
+// Fake device indexes.  Used internally by the driver for indexing to other than a DDB entry
+#define ISNS_DEVICE_INDEX                             MAX_DEV_DB_ENTRIES + 0
+
+#define ISNS_CLEAR_FLAGS(ha) do {clear_bit(ISNS_FLAG_SCN_IN_PROGRESS |    \
+                                       ISNS_FLAG_SCN_RESTART | 	      \
+				       ISNS_FLAG_QUERY_SINGLE_OBJECT, \
+				       &ha->isns_flags);} while(0);
+
+// iSNS Message Function ID codes
+
+#define ISNS_FCID_DevAttrReg      0x0001	// Device Attribute Registration Request
+#define ISNS_FCID_DevAttrQry      0x0002	// Device Attribute Query Request
+#define ISNS_FCID_DevGetNext      0x0003	// Device Get Next Request
+#define ISNS_FCID_DevDereg        0x0004	// Device Deregister Request
+#define ISNS_FCID_SCNReg          0x0005	// SCN Register Request
+#define ISNS_FCID_SCNDereg        0x0006	// SCN Deregister Request
+#define ISNS_FCID_SCNEvent        0x0007	// SCN Event
+#define ISNS_FCID_SCN             0x0008	// State Change Notification
+#define ISNS_FCID_DDReg           0x0009	// DD Register
+#define ISNS_FCID_DDDereg         0x000A	// DD Deregister
+#define ISNS_FCID_DDSReg          0x000B	// DDS Register
+#define ISNS_FCID_DDSDereg        0x000C	// DDS Deregister
+#define ISNS_FCID_ESI             0x000D	// Entity Status Inquiry
+#define ISNS_FCID_Heartbeat       0x000E	// Name Service Heartbeat
+//NOT USED              0x000F-0x0010
+#define ISNS_FCID_RqstDomId       0x0011	// Request FC_DOMAIN_ID
+#define ISNS_FCID_RlseDomId       0x0012	// Release FC_DOMAIN_ID
+#define ISNS_FCID_GetDomId        0x0013	// Get FC_DOMAIN_IDs
+//RESERVED              0x0014-0x00FF
+//Vendor Specific       0x0100-0x01FF
+//RESERVED              0x0200-0x8000
+
+// iSNS Response Message Function ID codes
+
+#define ISNS_FCID_DevAttrRegRsp   0x8001	// Device Attribute Registration Response
+#define ISNS_FCID_DevAttrQryRsp   0x8002	// Device Attribute Query Response
+#define ISNS_FCID_DevGetNextRsp   0x8003	// Device Get Next Response
+#define ISNS_FCID_DevDeregRsp     0x8004	// Deregister Device Response
+#define ISNS_FCID_SCNRegRsp       0x8005	// SCN Register Response
+#define ISNS_FCID_SCNDeregRsp     0x8006	// SCN Deregister Response
+#define ISNS_FCID_SCNEventRsp     0x8007	// SCN Event Response
+#define ISNS_FCID_SCNRsp          0x8008	// SCN Response
+#define ISNS_FCID_DDRegRsp        0x8009	// DD Register Response
+#define ISNS_FCID_DDDeregRsp      0x800A	// DD Deregister Response
+#define ISNS_FCID_DDSRegRsp       0x800B	// DDS Register Response
+#define ISNS_FCID_DDSDeregRsp     0x800C	// DDS Deregister Response
+#define ISNS_FCID_ESIRsp          0x800D	// Entity Status Inquiry Response
+//NOT USED              0x800E-0x8010
+#define ISNS_FCID_RqstDomIdRsp    0x8011	// Request FC_DOMAIN_ID Response
+#define ISNS_FCID_RlseDomIdRsp    0x8012	// Release FC_DOMAIN_ID Response
+#define ISNS_FCID_GetDomIdRsp     0x8013	// Get FC_DOMAIN_IDs Response
+//RESERVED              0x8014-0x80FF
+//Vendor Specific       0x8100-0x81FF
+//RESERVED              0x8200-0xFFFF
+
+// iSNS Error Codes
+
+#define ISNS_ERR_SUCCESS                    0	// Successful
+#define ISNS_ERR_UNKNOWN                    1	// Unknown Error
+#define ISNS_ERR_MSG_FORMAT                 2	// Message Format Error
+#define ISNS_ERR_INVALID_REG                3	// Invalid Registration
+//RESERVED                                  4
+#define ISNS_ERR_INVALID_QUERY              5	// Invalid Query
+#define ISNS_ERR_SOURCE_UNKNOWN             6	// Source Unknown
+#define ISNS_ERR_SOURCE_ABSENT              7	// Source Absent
+#define ISNS_ERR_SOURCE_UNAUTHORIZED        8	// Source Unauthorized
+#define ISNS_ERR_NO_SUCH_ENTRY              9	// No Such Entry
+#define ISNS_ERR_VER_NOT_SUPPORTED          10	// Version Not Supported
+#define ISNS_ERR_INTERNAL_ERROR             11	// Internal Error
+#define ISNS_ERR_BUSY                       12	// Busy
+#define ISNS_ERR_OPT_NOT_UNDERSTOOD         13	// Option Not Understood
+#define ISNS_ERR_INVALID_UPDATE             14	// Invalid Update
+#define ISNS_ERR_MSG_NOT_SUPPORTED          15	// Message (FUNCTION_ID) Not Supported
+#define ISNS_ERR_SCN_EVENT_REJECTED         16	// SCN Event Rejected
+#define ISNS_ERR_SCN_REG_REJECTED           17	// SCN Registration Rejected
+#define ISNS_ERR_ATTR_NOT_IMPLEMENTED       18	// Attribute Not Implemented
+#define ISNS_ERR_FC_DOMAIN_ID_NOT_AVAIL     19	// FC_DOMAIN_ID Not Available
+#define ISNS_ERR_FC_DOMAIN_ID_NOT_ALLOC     20	// FC_DOMAIN_ID Not Allocated
+#define ISNS_ERR_ESI_NOT_AVAILABLE          21	// ESI Not Available
+#define ISNS_ERR_INVALID_DEREG              22	// Invalid Deregistration
+#define ISNS_ERR_REG_FEATURES_NOT_SUPPORTED 23	// Registration Features Not Supported
+
+#define ISNS_ERROR_CODE_TBL()	{  \
+	"SUCCESSFUL"	        		, \
+	"UNKNOWN ERROR"	        		, \
+	"MESSAGE FORMAT ERROR"	        	, \
+	"INVALID REGISTRATION"	        	, \
+	"RESERVED"	        		, \
+	"INVALID QUERY"	        		, \
+	"SOURCE UNKNOWN"	        	, \
+	"SOURCE ABSENT"	        		, \
+	"SOURCE UNAUTHORIZED"	        	, \
+	"NO SUCH ENTRY"	        		, \
+	"VERSION NOT SUPPORTED"	        	, \
+	"INTERNAL ERROR"	        	, \
+	"BUSY"	        			, \
+	"OPTION NOT UNDERSTOOD"	        	, \
+	"INVALID UPDATE"	        	, \
+	"MESSAGE (FUNCTION_ID) NOT SUPPORTED"	, \
+	"SCN EVENT REJECTED"	        	, \
+	"SCN REGISTRATION REJECTED"	        , \
+	"ATTRIBUTE NOT IMPLEMENTED"	        , \
+	"FC_DOMAIN_ID NOT AVAILABLE"	        , \
+	"FC_DOMAIN_ID NOT ALLOCATED"	        , \
+	"ESI NOT AVAILABLE"	        	, \
+	"INVALID DEREGISTRATION"	        , \
+	"REGISTRATION FEATURES NOT SUPPORTED"	, \
+	NULL			  \
+}
+
+// iSNS Protocol Structures
+
+typedef struct {
+	uint16_t isnsp_version;
+	uint16_t function_id;
+	uint16_t pdu_length;
+	uint16_t flags;
+	uint16_t transaction_id;
+	uint16_t sequence_id;
+	uint8_t payload[0];
+} ISNSP_MESSAGE_HEADER, *PISNSP_MESSAGE_HEADER;
+
+typedef struct {
+	uint32_t error_code;
+	uint8_t attributes[0];
+} ISNSP_RESPONSE_HEADER, *PISNSP_RESPONSE_HEADER;
+
+// iSNS Message Flags Definitions
+
+#define ISNSP_CLIENT_SENDER         0x8000
+#define ISNSP_SERVER_SENDER         0x4000
+#define ISNSP_AUTH_BLOCK_PRESENT    0x2000
+#define ISNSP_REPLACE_FLAG          0x1000
+#define ISNSP_LAST_PDU              0x0800
+#define ISNSP_FIRST_PDU             0x0400
+
+#define ISNSP_VALID_FLAGS_MASK  (ISNSP_CLIENT_SENDER | \
+                                 ISNSP_SERVER_SENDER | \
+                                 ISNSP_AUTH_BLOCK_PRESENT | \
+                                 ISNSP_REPLACE_FLAG | \
+                                 ISNSP_LAST_PDU | \
+                                 ISNSP_FIRST_PDU)
+
+// iSNS Attribute Structure
+
+typedef struct {
+	uint32_t tag;
+	uint32_t length;
+	uint8_t value[0];	// Variable length data
+} ISNS_ATTRIBUTE, *PISNS_ATTRIBUTE;
+
+// The following macro assumes that the attribute is wholly contained within
+// the buffer in question and is valid (see VALIDATE_ATTR below).
+
+static inline
+PISNS_ATTRIBUTE NEXT_ATTR(PISNS_ATTRIBUTE pattr)
+{
+	return (PISNS_ATTRIBUTE) (&pattr->value[0] +
+	    be32_to_cpu(pattr->length));
+}
+
+static inline int
+VALIDATE_ATTR(PISNS_ATTRIBUTE PAttr, uint8_t * buffer_end)
+{
+	// Ensure that the Length field of the current attribute is contained
+	// within the buffer before trying to read it, and then be sure that
+	// the entire attribute is contained within the buffer.
+
+	if ((((unsigned long)&PAttr->length + sizeof(PAttr->length)) <=
+	     (unsigned long)buffer_end)
+	    && (unsigned long)NEXT_ATTR(PAttr) <= (unsigned long)buffer_end) {
+		return 1;
+	}
+
+	return 0;
+}
+
+// iSNS-defined Attribute Tags
+
+#define ISNS_ATTR_TAG_DELIMITER                     0
+#define ISNS_ATTR_TAG_ENTITY_IDENTIFIER             1
+#define ISNS_ATTR_TAG_ENTITY_PROTOCOL               2
+#define ISNS_ATTR_TAG_MGMT_IP_ADDRESS               3
+#define ISNS_ATTR_TAG_TIMESTAMP                     4
+#define ISNS_ATTR_TAG_PROTOCOL_VERSION_RANGE        5
+#define ISNS_ATTR_TAG_REGISTRATION_PERIOD           6
+#define ISNS_ATTR_TAG_ENTITY_INDEX                  7
+#define ISNS_ATTR_TAG_ENTITY_NEXT_INDEX             8
+#define ISNS_ATTR_TAG_ENTITY_ISAKMP_PHASE_1         11
+#define ISNS_ATTR_TAG_ENTITY_CERTIFICATE            12
+#define ISNS_ATTR_TAG_PORTAL_IP_ADDRESS             16
+#define ISNS_ATTR_TAG_PORTAL_PORT                   17
+#define ISNS_ATTR_TAG_PORTAL_SYMBOLIC_NAME          18
+#define ISNS_ATTR_TAG_ESI_INTERVAL                  19
+#define ISNS_ATTR_TAG_ESI_PORT                      20
+#define ISNS_ATTR_TAG_PORTAL_GROUP                  21
+#define ISNS_ATTR_TAG_PORTAL_INDEX                  22
+#define ISNS_ATTR_TAG_SCN_PORT                      23
+#define ISNS_ATTR_TAG_PORTAL_NEXT_INDEX             24
+#define ISNS_ATTR_TAG_PORTAL_SECURITY_BITMAP        27
+#define ISNS_ATTR_TAG_PORTAL_ISAKMP_PHASE_1         28
+#define ISNS_ATTR_TAG_PORTAL_ISAKMP_PHASE_2         29
+#define ISNS_ATTR_TAG_PORTAL_CERTIFICATE            31
+#define ISNS_ATTR_TAG_ISCSI_NAME                    32
+#define ISNS_ATTR_TAG_ISCSI_NODE_TYPE               33
+#define ISNS_ATTR_TAG_ISCSI_ALIAS                   34
+#define ISNS_ATTR_TAG_ISCSI_SCN_BITMAP              35
+#define ISNS_ATTR_TAG_ISCSI_NODE_INDEX              36
+#define ISNS_ATTR_TAG_WWNN_TOKEN                    37
+#define ISNS_ATTR_TAG_ISCSI_NODE_NEXT_INDEX         38
+#define ISNS_ATTR_TAG_ISCSI_AUTH_METHOD             42
+#define ISNS_ATTR_TAG_ISCSI_NODE_CERTIFICATE        43
+#define ISNS_ATTR_TAG_PG_TAG                        48
+#define ISNS_ATTR_TAG_PG_ISCSI_NAME                 49
+#define ISNS_ATTR_TAG_PG_PORTAL_IP_ADDRESS          50
+#define ISNS_ATTR_TAG_PG_PORTAL_PORT                51
+#define ISNS_ATTR_TAG_PG_INDEX                      52
+#define ISNS_ATTR_TAG_PG_NEXT_INDEX                 53
+#define ISNS_ATTR_TAG_FC_PORT_NAME_WWPN             64
+#define ISNS_ATTR_TAG_PORT_ID                       65
+#define ISNS_ATTR_TAG_FC_PORT_TYPE                  66
+#define ISNS_ATTR_TAG_SYMBOLIC_PORT_NAME            67
+#define ISNS_ATTR_TAG_FABRIC_PORT_NAME              68
+#define ISNS_ATTR_TAG_HARD_ADDRESS                  69
+#define ISNS_ATTR_TAG_PORT_IP_ADDRESS               70
+#define ISNS_ATTR_TAG_CLASS_OF_SERVICE              71
+#define ISNS_ATTR_TAG_FC4_TYPES                     72
+#define ISNS_ATTR_TAG_FC4_DESCRIPTOR                73
+#define ISNS_ATTR_TAG_FC4_FEATURES                  74
+#define ISNS_ATTR_TAG_IFCP_SCN_BITMAP               75
+#define ISNS_ATTR_TAG_PORT_ROLE                     76
+#define ISNS_ATTR_TAG_PERMANENT_PORT_NAME           77
+#define ISNS_ATTR_TAG_PORT_CERTIFICATE              83
+#define ISNS_ATTR_TAG_FC4_TYPE_CODE                 95
+#define ISNS_ATTR_TAG_FC_NODE_NAME_WWNN             96
+#define ISNS_ATTR_TAG_SYMBOLIC_NODE_NAME            97
+#define ISNS_ATTR_TAG_NODE_IP_ADDRESS               98
+#define ISNS_ATTR_TAG_NODE_IPA                      99
+#define ISNS_ATTR_TAG_NODE_CERTIFICATE              100
+#define ISNS_ATTR_TAG_PROXY_ISCSI_NAME              101
+#define ISNS_ATTR_TAG_SWITCH_NAME                   128
+#define ISNS_ATTR_TAG_PREFERRED_ID                  129
+#define ISNS_ATTR_TAG_ASSIGNED_ID                   130
+#define ISNS_ATTR_TAG_VIRTUAL_FABRIC_ID             131
+#define ISNS_ATTR_TAG_VENDOR_OUI                    256
+//Vendor-specific iSNS Server                       257-384
+//Vendor-specific Entity                            385-512
+//Vendor-specific Portal                            513-640
+//Vendor-specific iSCSI Node                        641-768
+//Vendor-specific FC Port Name                      769-896
+//Vendor-specific FC Node Name                      897-1024
+//Vendor-specific DDS                               1025-1280
+//Vendor-Specific DD                                1281-1536
+//Vendor-specific (other)                           1237-2048
+#define ISNS_ATTR_TAG_DD_SET_ID                     2049
+#define ISNS_ATTR_TAG_DD_SET_SYMBOLIC_NAME          2050
+#define ISNS_ATTR_TAG_DD_SET_STATUS                 2051
+#define ISNS_ATTR_TAG_DD_SET_NEXT_ID                2052
+#define ISNS_ATTR_TAG_DD_ID                         2065
+#define ISNS_ATTR_TAG_DD_SYMBOLIC_NAME              2066
+#define ISNS_ATTR_TAG_DD_MEMBER_ISCSI_INDEX         2067
+#define ISNS_ATTR_TAG_DD_MEMBER_ISCSI_NAME          2068
+#define ISNS_ATTR_TAG_DD_MEMBER_IFCP_NODE           2069
+#define ISNS_ATTR_TAG_DD_MEMBER_PORTAL_INDEX        2070
+#define ISNS_ATTR_TAG_DD_MEMBER_PORTAL_IP_ADDRESS   2071
+#define ISNS_ATTR_TAG_DD_MEMBER_PORTAL_PORT         2072
+#define ISNS_ATTR_TAG_DD_FEATURES                   2078
+#define ISNS_ATTR_TAG_DD_ID_NEXT_ID                 2079
+
+// Definitions used for Entity Protocol
+
+#define ENTITY_PROTOCOL_NEUTRAL                 1
+#define ENTITY_PROTOCOL_ISCSI                   2
+#define ENTITY_PROTOCOL_IFCP                    3
+
+// Definitions used for iSCSI Node Type
+
+#define ISCSI_NODE_TYPE_TARGET                  0x00000001
+#define ISCSI_NODE_TYPE_INITIATOR               0x00000002
+#define ISCSI_NODE_TYPE_CONTROL                 0x00000004
+
+// Definitions used for iSCSI Node SCN Bitmap
+
+#define ISCSI_SCN_DD_DDS_MEMBER_ADDED           0x00000001	// Management SCN only
+#define ISCSI_SCN_DD_DDS_MEMBER_REMOVED         0x00000002	// Management SCN only
+#define ISCSI_SCN_OBJECT_UPDATED                0x00000004
+#define ISCSI_SCN_OBJECT_ADDED                  0x00000008
+#define ISCSI_SCN_OBJECT_REMOVED                0x00000010
+#define ISCSI_SCN_MANAGEMENT_SCN                0x00000020
+#define ISCSI_SCN_TARGET_AND_SELF_INFO_ONLY     0x00000040
+#define ISCSI_SCN_INITIATOR_AND_SELF_INFO_ONLY  0x00000080
+
+#define ISCSI_SCN_OBJECT_MASK                   (ISCSI_SCN_OBJECT_UPDATED |     \
+                                                 ISCSI_SCN_OBJECT_ADDED |       \
+                                                 ISCSI_SCN_OBJECT_REMOVED)
+
+// Definitions used for iSCSI Security Bitmap
+
+#define ISNS_SECURITY_BITMAP_VALID              0x00000001
+#define ISNS_SECURITY_IKE_IPSEC_ENABLED         0x00000002
+#define ISNS_SECURITY_MAIN_MODE_ENABLED         0x00000004
+#define ISNS_SECURITY_AGGRESSIVE_MODE_ENABLED   0x00000008
+#define ISNS_SECURITY_PFS_ENABLED               0x00000010
+#define ISNS_SECURITY_TRANSPORT_MODE_PREFERRED  0x00000020
+#define ISNS_SECURITY_TUNNEL_MODE_PREFERRED     0x00000040
+
+// Definitions used for Portal Port
+
+#define PORTAL_PORT_NUMBER_MASK                 0x0000FFFF
+#define PORTAL_PORT_TYPE_UDP                    0x00010000

-- 
Andrew Vasquez
