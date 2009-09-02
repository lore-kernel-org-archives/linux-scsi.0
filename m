From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 7/8] be2iscsi: Firmware Commands to chip
Date: Wed, 2 Sep 2009 09:43:47 +0530
Message-ID: <20090902041337.GA19345@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:33400 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752337AbZIBENg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2009 00:13:36 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

  These files contain code for all supported Firmware
  commands to the chip. These routines are mostly accessed
  from be_main.c.

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_mgmt.c |  321 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/be2iscsi/be_mgmt.h |  249 ++++++++++++++++++++++++++++++
 2 files changed, 570 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/be2iscsi/be_mgmt.c
 create mode 100644 drivers/scsi/be2iscsi/be_mgmt.h

diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
new file mode 100644
index 0000000..12e644f
--- /dev/null
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -0,0 +1,321 @@
+/**
+ * Copyright (C) 2005 - 2009 ServerEngines
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.  The full GNU General
+ * Public License is included in this distribution in the file called COPYING.
+ *
+ * Written by: Jayamohan Kallickal (jayamohank@serverengines.com)
+ *
+ * Contact Information:
+ * linux-drivers@serverengines.com
+ *
+ * ServerEngines
+ * 209 N. Fair Oaks Ave
+ * Sunnyvale, CA 94085
+ *
+ */
+
+#include "be_mgmt.h"
+#include "be_iscsi.h"
+
+unsigned char mgmt_get_fw_config(struct be_ctrl_info *ctrl,
+				struct beiscsi_hba *phba)
+{
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct be_fw_cfg *req = embedded_payload(wrb);
+	int status = 0;
+
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_COMMON,
+			   OPCODE_COMMON_QUERY_FIRMWARE_CONFIG, sizeof(*req));
+
+	status = be_mbox_notify(ctrl);
+	if (!status) {
+		struct be_fw_cfg *pfw_cfg;
+		pfw_cfg = req;
+		phba->fw_config.phys_port = pfw_cfg->phys_port;
+		phba->fw_config.iscsi_icd_start =
+					pfw_cfg->ulp[0].icd_base;
+		phba->fw_config.iscsi_icd_count =
+					pfw_cfg->ulp[0].icd_count;
+		phba->fw_config.iscsi_cid_start =
+					pfw_cfg->ulp[0].sq_base;
+		phba->fw_config.iscsi_cid_count =
+					pfw_cfg->ulp[0].sq_count;
+	} else {
+		shost_printk(KERN_WARNING, phba->shost,
+			     "Failed in mgmt_get_fw_config \n");
+	}
+
+	spin_unlock(&ctrl->mbox_lock);
+	return status;
+}
+
+unsigned char mgmt_check_supported_fw(struct be_ctrl_info *ctrl)
+{
+	struct be_dma_mem nonemb_cmd;
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct be_mgmt_controller_attributes *req;
+	struct be_sge *sge = nonembedded_sgl(wrb);
+	int status = 0;
+
+	nonemb_cmd.va = pci_alloc_consistent(ctrl->pdev,
+				sizeof(struct be_mgmt_controller_attributes),
+				&nonemb_cmd.dma);
+	if (nonemb_cmd.va == NULL) {
+		SE_DEBUG(DBG_LVL_1,
+			 "Failed to allocate memory for mgmt_check_supported_fw"
+			 "\n");
+		return -1;
+	}
+	nonemb_cmd.size = sizeof(struct be_mgmt_controller_attributes);
+	req = nonemb_cmd.va;
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+	be_wrb_hdr_prepare(wrb, sizeof(*req), false, 1);
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_COMMON,
+			   OPCODE_COMMON_GET_CNTL_ATTRIBUTES, sizeof(*req));
+	sge->pa_hi = cpu_to_le32(upper_32_bits(nonemb_cmd.dma));
+	sge->pa_lo = cpu_to_le32(nonemb_cmd.dma & 0xFFFFFFFF);
+	sge->len = cpu_to_le32(nonemb_cmd.size);
+
+	status = be_mbox_notify(ctrl);
+	if (!status) {
+		struct be_mgmt_controller_attributes_resp *resp = nonemb_cmd.va;
+		SE_DEBUG(DBG_LVL_8, "Firmware version of CMD: %s\n",
+			resp->params.hba_attribs.flashrom_version_string);
+		SE_DEBUG(DBG_LVL_8, "Firmware version is : %s\n",
+			resp->params.hba_attribs.firmware_version_string);
+		SE_DEBUG(DBG_LVL_8,
+			"Developer Build, not performing version check...\n");
+
+	} else
+		SE_DEBUG(DBG_LVL_1, " Failed in mgmt_check_supported_fw\n");
+	if (nonemb_cmd.va)
+		pci_free_consistent(ctrl->pdev, nonemb_cmd.size,
+				    nonemb_cmd.va, nonemb_cmd.dma);
+
+	spin_unlock(&ctrl->mbox_lock);
+	return status;
+}
+
+unsigned char mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short chute)
+{
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct iscsi_cleanup_req *req = embedded_payload(wrb);
+	int status = 0;
+
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
+			   OPCODE_COMMON_ISCSI_CLEANUP, sizeof(*req));
+
+	req->chute = chute;
+	req->hdr_ring_id = 0;
+	req->data_ring_id = 0;
+
+	status = be_mbox_notify(ctrl);
+	if (status)
+		shost_printk(KERN_WARNING, phba->shost,
+			     " mgmt_epfw_cleanup , FAILED\n");
+	spin_unlock(&ctrl->mbox_lock);
+	return status;
+}
+
+unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
+				   unsigned int icd, unsigned int cid)
+{
+	struct be_dma_mem nonemb_cmd;
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct be_sge *sge = nonembedded_sgl(wrb);
+	struct invalidate_commands_params_in *req;
+	int status = 0;
+
+	nonemb_cmd.va = pci_alloc_consistent(ctrl->pdev,
+				sizeof(struct invalidate_commands_params_in),
+				&nonemb_cmd.dma);
+	if (nonemb_cmd.va == NULL) {
+		SE_DEBUG(DBG_LVL_1,
+			 "Failed to allocate memory for"
+			 "mgmt_invalidate_icds \n");
+		return -1;
+	}
+	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);
+	req = nonemb_cmd.va;
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+
+	be_wrb_hdr_prepare(wrb, sizeof(*req), false, 1);
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
+			OPCODE_COMMON_ISCSI_ERROR_RECOVERY_INVALIDATE_COMMANDS,
+			sizeof(*req));
+	req->ref_handle = 0;
+	req->cleanup_type = CMD_ISCSI_COMMAND_INVALIDATE;
+	req->icd_count = 0;
+	req->table[req->icd_count].icd = icd;
+	req->table[req->icd_count].cid = cid;
+	sge->pa_hi = cpu_to_le32(upper_32_bits(nonemb_cmd.dma));
+	sge->pa_lo = cpu_to_le32(nonemb_cmd.dma & 0xFFFFFFFF);
+	sge->len = cpu_to_le32(nonemb_cmd.size);
+
+	status = be_mbox_notify(ctrl);
+	if (status)
+		SE_DEBUG(DBG_LVL_1, "ICDS Invalidation Failed\n");
+	spin_unlock(&ctrl->mbox_lock);
+	if (nonemb_cmd.va)
+		pci_free_consistent(ctrl->pdev, nonemb_cmd.size,
+				    nonemb_cmd.va, nonemb_cmd.dma);
+	return status;
+}
+
+unsigned char mgmt_invalidate_connection(struct beiscsi_hba *phba,
+					 struct beiscsi_endpoint *beiscsi_ep,
+					 unsigned short cid,
+					 unsigned short issue_reset,
+					 unsigned short savecfg_flag)
+{
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct iscsi_invalidate_connection_params_in *req =
+						embedded_payload(wrb);
+	int status = 0;
+
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI_INI,
+			   OPCODE_ISCSI_INI_DRIVER_INVALIDATE_CONNECTION,
+			   sizeof(*req));
+	req->session_handle = beiscsi_ep->fw_handle;
+	req->cid = cid;
+	if (issue_reset)
+		req->cleanup_type = CMD_ISCSI_CONNECTION_ISSUE_TCP_RST;
+	else
+		req->cleanup_type = CMD_ISCSI_CONNECTION_INVALIDATE;
+	req->save_cfg = savecfg_flag;
+	status = be_mbox_notify(ctrl);
+	if (status)
+		SE_DEBUG(DBG_LVL_1, "Invalidation Failed\n");
+
+	spin_unlock(&ctrl->mbox_lock);
+	return status;
+}
+
+unsigned char mgmt_upload_connection(struct beiscsi_hba *phba,
+				unsigned short cid, unsigned int upload_flag)
+{
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct tcp_upload_params_in *req = embedded_payload(wrb);
+	int status = 0;
+
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+	be_cmd_hdr_prepare(&req->hdr, CMD_COMMON_TCP_UPLOAD,
+			   OPCODE_COMMON_TCP_UPLOAD, sizeof(*req));
+	req->id = (unsigned short)cid;
+	req->upload_type = (unsigned char)upload_flag;
+	status = be_mbox_notify(ctrl);
+	if (status)
+		SE_DEBUG(DBG_LVL_1, "mgmt_upload_connection Failed\n");
+	spin_unlock(&ctrl->mbox_lock);
+	return status;
+}
+
+int mgmt_open_connection(struct beiscsi_hba *phba,
+			 struct sockaddr *dst_addr,
+			 struct beiscsi_endpoint *beiscsi_ep)
+{
+	struct hwi_controller *phwi_ctrlr;
+	struct hwi_context_memory *phwi_context;
+	struct sockaddr_in *daddr_in = (struct sockaddr_in *)dst_addr;
+	struct sockaddr_in6 *daddr_in6 = (struct sockaddr_in6 *)dst_addr;
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct tcp_connect_and_offload_in *req = embedded_payload(wrb);
+	unsigned short def_hdr_id;
+	unsigned short def_data_id;
+	struct phys_addr template_address = { 0, 0 };
+	struct phys_addr *ptemplate_address;
+	int status = 0;
+	unsigned short cid = beiscsi_ep->ep_cid;
+
+	phwi_ctrlr = phba->phwi_ctrlr;
+	phwi_context = phwi_ctrlr->phwi_ctxt;
+	def_hdr_id = (unsigned short)HWI_GET_DEF_HDRQ_ID(phba);
+	def_data_id = (unsigned short)HWI_GET_DEF_BUFQ_ID(phba);
+
+	ptemplate_address = &template_address;
+	ISCSI_GET_PDU_TEMPLATE_ADDRESS(phba, ptemplate_address);
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
+			   OPCODE_COMMON_ISCSI_TCP_CONNECT_AND_OFFLOAD,
+			   sizeof(*req));
+	if (dst_addr->sa_family == PF_INET) {
+		__be32 s_addr = daddr_in->sin_addr.s_addr;
+		req->ip_address.ip_type = BE2_IPV4;
+		req->ip_address.ip_address[0] = s_addr & 0x000000ff;
+		req->ip_address.ip_address[1] = (s_addr & 0x0000ff00) >> 8;
+		req->ip_address.ip_address[2] = (s_addr & 0x00ff0000) >> 16;
+		req->ip_address.ip_address[3] = (s_addr & 0xff000000) >> 24;
+		req->tcp_port = ntohs(daddr_in->sin_port);
+		beiscsi_ep->dst_addr = daddr_in->sin_addr.s_addr;
+		beiscsi_ep->dst_tcpport = ntohs(daddr_in->sin_port);
+		beiscsi_ep->ip_type = BE2_IPV4;
+	} else if (dst_addr->sa_family == PF_INET6) {
+		req->ip_address.ip_type = BE2_IPV6;
+		memcpy(&req->ip_address.ip_address,
+		       &daddr_in6->sin6_addr.in6_u.u6_addr8, 16);
+		req->tcp_port = ntohs(daddr_in6->sin6_port);
+		beiscsi_ep->dst_tcpport = ntohs(daddr_in6->sin6_port);
+		memcpy(&beiscsi_ep->dst6_addr,
+		       &daddr_in6->sin6_addr.in6_u.u6_addr8, 16);
+		beiscsi_ep->ip_type = BE2_IPV6;
+	} else{
+		shost_printk(KERN_ERR, phba->shost, "unknown addr family %d\n",
+			     dst_addr->sa_family);
+		spin_unlock(&ctrl->mbox_lock);
+		return -EINVAL;
+
+	}
+	req->cid = cid;
+	req->cq_id = phwi_context->be_cq.id;
+	req->defq_id = def_hdr_id;
+	req->hdr_ring_id = def_hdr_id;
+	req->data_ring_id = def_data_id;
+	req->do_offload = 1;
+	req->dataout_template_pa.lo = ptemplate_address->lo;
+	req->dataout_template_pa.hi = ptemplate_address->hi;
+	status = be_mbox_notify(ctrl);
+	if (!status) {
+		struct iscsi_endpoint *ep;
+		struct tcp_connect_and_offload_out *ptcpcnct_out =
+							embedded_payload(wrb);
+
+		ep = phba->ep_array[ptcpcnct_out->cid];
+		beiscsi_ep = ep->dd_data;
+		beiscsi_ep->fw_handle = 0;
+		beiscsi_ep->cid_vld = 1;
+		SE_DEBUG(DBG_LVL_8, "mgmt_open_connection Success\n");
+	} else
+		SE_DEBUG(DBG_LVL_1, "mgmt_open_connection Failed\n");
+	spin_unlock(&ctrl->mbox_lock);
+	return status;
+}
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
new file mode 100644
index 0000000..00e816e
--- /dev/null
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -0,0 +1,249 @@
+/**
+ * Copyright (C) 2005 - 2009 ServerEngines
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.  The full GNU General
+ * Public License is included in this distribution in the file called COPYING.
+ *
+ * Written by: Jayamohan Kallickal (jayamohank@serverengines.com)
+ *
+ * Contact Information:
+ * linux-drivers@serverengines.com
+ *
+ * ServerEngines
+ * 209 N. Fair Oaks Ave
+ * Sunnyvale, CA 94085
+ *
+ */
+
+#ifndef _BEISCSI_MGMT_
+#define _BEISCSI_MGMT_
+
+#include <linux/types.h>
+#include <linux/list.h>
+#include "be_iscsi.h"
+#include "be_main.h"
+
+/**
+ * Pseudo amap definition in which each bit of the actual structure is defined
+ * as a byte: used to calculate offset/shift/mask of each field
+ */
+struct amap_mcc_sge {
+	u8 pa_lo[32];		/* dword 0 */
+	u8 pa_hi[32];		/* dword 1 */
+	u8 length[32];		/* DWORD 2 */
+} __packed;
+
+/**
+ * Pseudo amap definition in which each bit of the actual structure is defined
+ * as a byte: used to calculate offset/shift/mask of each field
+ */
+struct amap_mcc_wrb_payload {
+	union {
+		struct amap_mcc_sge sgl[19];
+		u8 embedded[59 * 32];	/* DWORDS 57 to 115 */
+	} u;
+} __packed;
+
+/**
+ * Pseudo amap definition in which each bit of the actual structure is defined
+ * as a byte: used to calculate offset/shift/mask of each field
+ */
+struct amap_mcc_wrb {
+	u8 embedded;		/* DWORD 0 */
+	u8 rsvd0[2];		/* DWORD 0 */
+	u8 sge_count[5];	/* DWORD 0 */
+	u8 rsvd1[16];		/* DWORD 0 */
+	u8 special[8];		/* DWORD 0 */
+	u8 payload_length[32];
+	u8 tag[64];		/* DWORD 2 */
+	u8 rsvd2[32];		/* DWORD 4 */
+	struct amap_mcc_wrb_payload payload;
+};
+
+struct mcc_sge {
+	u32 pa_lo;		/* dword 0 */
+	u32 pa_hi;		/* dword 1 */
+	u32 length;		/* DWORD 2 */
+} __packed;
+
+struct mcc_wrb_payload {
+	union {
+		struct mcc_sge sgl[19];
+		u32 embedded[59];	/* DWORDS 57 to 115 */
+	} u;
+} __packed;
+
+#define MCC_WRB_EMBEDDED_MASK                0x00000001
+
+struct mcc_wrb {
+	u32 dw[0];		/* DWORD 0 */
+	u32 payload_length;
+	u32 tag[2];		/* DWORD 2 */
+	u32 rsvd2[1];		/* DWORD 4 */
+	struct mcc_wrb_payload payload;
+};
+
+unsigned char mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short chute);
+int mgmt_open_connection(struct beiscsi_hba *phba, struct sockaddr *dst_addr,
+			 struct beiscsi_endpoint *beiscsi_ep);
+
+unsigned char mgmt_upload_connection(struct beiscsi_hba *phba,
+				     unsigned short cid,
+				     unsigned int upload_flag);
+unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
+				   unsigned int icd, unsigned int cid);
+
+struct iscsi_invalidate_connection_params_in {
+	struct be_cmd_req_hdr hdr;
+	unsigned int session_handle;
+	unsigned short cid;
+	unsigned short unused;
+	unsigned short cleanup_type;
+	unsigned short save_cfg;
+} __packed;
+
+struct iscsi_invalidate_connection_params_out {
+	unsigned int session_handle;
+	unsigned short cid;
+	unsigned short unused;
+} __packed;
+
+union iscsi_invalidate_connection_params {
+	struct iscsi_invalidate_connection_params_in request;
+	struct iscsi_invalidate_connection_params_out response;
+} __packed;
+
+struct invalidate_command_table {
+	unsigned short icd;
+	unsigned short cid;
+} __packed;
+
+struct invalidate_commands_params_in {
+	struct be_cmd_req_hdr hdr;
+	unsigned int ref_handle;
+	unsigned int icd_count;
+	struct invalidate_command_table table[128];
+	unsigned short cleanup_type;
+	unsigned short unused;
+} __packed;
+
+struct invalidate_commands_params_out {
+	unsigned int ref_handle;
+	unsigned int icd_count;
+	unsigned int icd_status[128];
+} __packed;
+
+union invalidate_commands_params {
+	struct invalidate_commands_params_in request;
+	struct invalidate_commands_params_out response;
+} __packed;
+
+struct mgmt_hba_attributes {
+	u8 flashrom_version_string[32];
+	u8 manufacturer_name[32];
+	u32 supported_modes;
+	u8 seeprom_version_lo;
+	u8 seeprom_version_hi;
+	u8 rsvd0[2];
+	u32 fw_cmd_data_struct_version;
+	u32 ep_fw_data_struct_version;
+	u32 future_reserved[12];
+	u32 default_extended_timeout;
+	u8 controller_model_number[32];
+	u8 controller_description[64];
+	u8 controller_serial_number[32];
+	u8 ip_version_string[32];
+	u8 firmware_version_string[32];
+	u8 bios_version_string[32];
+	u8 redboot_version_string[32];
+	u8 driver_version_string[32];
+	u8 fw_on_flash_version_string[32];
+	u32 functionalities_supported;
+	u16 max_cdblength;
+	u8 asic_revision;
+	u8 generational_guid[16];
+	u8 hba_port_count;
+	u16 default_link_down_timeout;
+	u8 iscsi_ver_min_max;
+	u8 multifunction_device;
+	u8 cache_valid;
+	u8 hba_status;
+	u8 max_domains_supported;
+	u8 phy_port;
+	u32 firmware_post_status;
+	u32 hba_mtu[8];
+	u32 future_u32[4];
+} __packed;
+
+struct mgmt_controller_attributes {
+	struct mgmt_hba_attributes hba_attribs;
+	u16 pci_vendor_id;
+	u16 pci_device_id;
+	u16 pci_sub_vendor_id;
+	u16 pci_sub_system_id;
+	u8 pci_bus_number;
+	u8 pci_device_number;
+	u8 pci_function_number;
+	u8 interface_type;
+	u64 unique_identifier;
+	u8 netfilters;
+	u8 rsvd0[3];
+	u8 future_u32[4];
+} __packed;
+
+struct be_mgmt_controller_attributes {
+	struct be_cmd_req_hdr hdr;
+	struct mgmt_controller_attributes params;
+} __packed;
+
+struct be_mgmt_controller_attributes_resp {
+	struct be_cmd_resp_hdr hdr;
+	struct mgmt_controller_attributes params;
+} __packed;
+
+/* configuration management */
+
+#define GET_MGMT_CONTROLLER_WS(phba)    (phba->pmgmt_ws)
+
+/* MGMT CMD flags */
+
+#define MGMT_CMDH_FREE                (1<<0)
+
+/*  --- MGMT_ERROR_CODES --- */
+/*  Error Codes returned in the status field of the CMD response header */
+#define MGMT_STATUS_SUCCESS 0	/* The CMD completed without errors */
+#define MGMT_STATUS_FAILED 1	/* Error status in the Status field of */
+				/* the CMD_RESPONSE_HEADER  */
+
+#define ISCSI_GET_PDU_TEMPLATE_ADDRESS(pc, pa) {\
+    pa->lo = phba->init_mem[ISCSI_MEM_GLOBAL_HEADER].mem_array[0].\
+					bus_address.u.a32.address_lo;  \
+    pa->hi = phba->init_mem[ISCSI_MEM_GLOBAL_HEADER].mem_array[0].\
+					bus_address.u.a32.address_hi;  \
+}
+
+struct beiscsi_endpoint {
+	struct beiscsi_hba *phba;
+	struct beiscsi_sess *sess;
+	struct beiscsi_conn *conn;
+	unsigned short ip_type;
+	char dst6_addr[ISCSI_ADDRESS_BUF_LEN];
+	unsigned long dst_addr;
+	unsigned short ep_cid;
+	unsigned int fw_handle;
+	u16 dst_tcpport;
+	u16 cid_vld;
+};
+
+unsigned char mgmt_get_fw_config(struct be_ctrl_info *ctrl,
+				 struct beiscsi_hba *phba);
+
+unsigned char mgmt_invalidate_connection(struct beiscsi_hba *phba,
+					 struct beiscsi_endpoint *beiscsi_ep,
+					 unsigned short cid,
+					 unsigned short issue_reset,
+					 unsigned short savecfg_flag);
+#endif
-- 
1.6.4

