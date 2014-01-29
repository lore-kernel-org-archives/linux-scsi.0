From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 3/8] be2iscsi : Fix IRQ_Affinity support in driver.
Date: Wed, 29 Jan 2014 02:16:41 -0500
Message-ID: <1390979807-16718-3-git-send-email-Jayamohan.Kallickal@emulex.com>
References: <1390979807-16718-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:33907 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaA2HRB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jan 2014 02:17:01 -0500
Received: by mail-pb0-f50.google.com with SMTP id rq2so1415312pbb.23
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jan 2014 23:17:00 -0800 (PST)
In-Reply-To: <1390979807-16718-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 Provides IRQ_Affinity setting for the driver. Enabling IRQ_Affinity
 is through  module params. Default IRQ_AFFINITY  support is OFF.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.h |  9 +++-
 drivers/scsi/be2iscsi/be_main.c | 97 +++++++++++++++++++++++++++++++++++++++--
 drivers/scsi/be2iscsi/be_main.h | 22 +++++++---
 drivers/scsi/be2iscsi/be_mgmt.c | 63 ++++++++++++++++++++++++--
 drivers/scsi/be2iscsi/be_mgmt.h | 49 ++++++++++++++++++---
 5 files changed, 222 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 770b6c8..69f849e 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -174,6 +174,7 @@ struct be_mcc_mailbox {
 #define OPCODE_COMMON_EQ_DESTROY			55
 #define OPCODE_COMMON_QUERY_FIRMWARE_CONFIG		58
 #define OPCODE_COMMON_FUNCTION_RESET			61
+#define OPCODE_COMMON_GET_CNTL_ADV_ATTRIB		121
 
 /**
  * LIST of opcodes that are common between Initiator and Target
@@ -197,6 +198,8 @@ struct be_mcc_mailbox {
 #define OPCODE_COMMON_ISCSI_WRBQ_CREATE			66
 #define OPCODE_COMMON_ISCSI_WRBQ_DESTROY		67
 
+#define MBOX_CMD_V2					0x01
+
 struct be_cmd_req_hdr {
 	u8 opcode;		/* dword 0 */
 	u8 subsystem;		/* dword 0 */
@@ -966,6 +969,9 @@ struct amap_it_dmsg_cqe_v2 {
 #define DB_DEF_PDU_WRB_INDEX_SHIFT	16
 #define DB_DEF_PDU_NUM_POSTED_SHIFT	24
 
+#define BEISCSI_IFD_STATE_DISABLE      0x0
+#define BEISCSI_IFD_STATE_ENABLE       0x1
+
 struct fragnum_bits_for_sgl_cra_in {
 	struct be_cmd_req_hdr hdr;
 	u32 num_bits;
@@ -1002,7 +1008,8 @@ struct tcp_connect_and_offload_in {
 	u16 hdr_ring_id;
 	u16 data_ring_id;
 	u8 do_offload;
-	u8 rsvd0[3];
+	u8 ifd_state;
+	u8 rsvd0[2];
 } __packed;
 
 struct tcp_connect_and_offload_out {
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 1a1729b..89bf558 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -47,6 +47,7 @@
 static unsigned int be_iopoll_budget = 10;
 static unsigned int be_max_phys_size = 64;
 static unsigned int enable_msix = 1;
+static unsigned int beiscsi_irq_affinity_enable;
 
 MODULE_DEVICE_TABLE(pci, beiscsi_pci_id_table);
 MODULE_DESCRIPTION(DRV_DESC " " BUILD_STR);
@@ -59,6 +60,7 @@ module_param(be_max_phys_size, uint, S_IRUGO);
 MODULE_PARM_DESC(be_max_phys_size,
 		"Maximum Size (In Kilobytes) of physically contiguous "
 		"memory that can be allocated. Range is 16 - 128");
+module_param(beiscsi_irq_affinity_enable, uint, 0);
 
 #define beiscsi_disp_param(_name)\
 ssize_t	\
@@ -1026,6 +1028,46 @@ static irqreturn_t be_isr(int irq, void *dev_id)
 	}
 }
 
+static void beiscsi_set_irq_affinity_params(struct beiscsi_hba *phba,
+		uint16_t cpu_index, uint16_t eqcq_index, uint16_t msix_vec)
+{
+	struct hwi_controller *phwi_ctrlr;
+	struct hwi_context_memory *phwi_context;
+
+	phwi_ctrlr = phba->phwi_ctrlr;
+	phwi_context = phwi_ctrlr->phwi_ctxt;
+
+	if (msix_vec) {
+		if (cpu_online(cpu_index))
+			cpumask_set_cpu(cpu_index,
+					&phba->msix_cpu_map[
+					cpu_index].affinity_mask);
+		else
+			cpumask_copy(&phba->msix_cpu_map[
+				     cpu_index].affinity_mask,
+				     cpu_online_mask);
+
+		phba->msix_cpu_map[cpu_index].eq_id =
+			phwi_context->be_eq[eqcq_index].q.id;
+		phba->msix_cpu_map[cpu_index].cq_id =
+			phwi_context->be_cq[eqcq_index].id;
+		phba->msix_cpu_map[cpu_index].cpu_id = cpu_index;
+		phba->msix_cpu_map[cpu_index].nvec = msix_vec;
+		phba->msix_cpu_map[cpu_index].node_id =
+			cpu_to_node(cpu_index);
+
+		irq_set_affinity_hint(msix_vec,
+				      &phba->msix_cpu_map[
+				      cpu_index].affinity_mask);
+	} else {
+		phba->msix_cpu_map[cpu_index].eq_id =
+			phba->msix_cpu_map[eqcq_index].eq_id;
+		phba->msix_cpu_map[cpu_index].cq_id =
+			phba->msix_cpu_map[eqcq_index].cq_id;
+		phba->msix_cpu_map[cpu_index].cpu_id = cpu_index;
+	}
+}
+
 static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 {
 	struct pci_dev *pcidev = phba->pcidev;
@@ -1059,7 +1101,11 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 				kfree(phba->msi_name[i]);
 				goto free_msix_irqs;
 			}
+			if (beiscsi_irq_affinity_enable)
+				beiscsi_set_irq_affinity_params(phba,
+								i, i, msix_vec);
 		}
+
 		phba->msi_name[i] = kzalloc(BEISCSI_MSI_NAME, GFP_KERNEL);
 		if (!phba->msi_name[i]) {
 			ret = -ENOMEM;
@@ -1078,6 +1124,12 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 			goto free_msix_irqs;
 		}
 
+		if (beiscsi_irq_affinity_enable) {
+			j = i;
+			while (i++ < num_online_cpus())
+				beiscsi_set_irq_affinity_params(phba,
+								i, (i - j), 0);
+		}
 	} else {
 		ret = request_irq(pcidev->irq, be_isr, IRQF_SHARED,
 				  "beiscsi", phba);
@@ -4663,10 +4715,9 @@ beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,
 
 	/* Check for the adapter family */
 	if (is_chip_be2_be3r(phba))
-		beiscsi_offload_cxn_v0(params, pwrb_handle,
-				       phba->init_mem);
+		beiscsi_offload_cxn_v0(phba, params, pwrb_handle);
 	else
-		beiscsi_offload_cxn_v2(params, pwrb_handle);
+		beiscsi_offload_cxn_v2(phba, params, pwrb_handle);
 
 	be_dws_le_to_cpu(pwrb_handle->pwrb,
 			 sizeof(struct iscsi_target_context_update_wrb));
@@ -4860,6 +4911,8 @@ int beiscsi_iotask_v2(struct iscsi_task *task, struct scatterlist *sg,
 	struct beiscsi_hba *phba = beiscsi_conn->phba;
 	struct iscsi_wrb *pwrb = NULL;
 	unsigned int doorbell = 0;
+	uint8_t cpu_num;
+	u8 cq_num;
 
 	pwrb = io_task->pwrb_handle->pwrb;
 
@@ -4891,6 +4944,13 @@ int beiscsi_iotask_v2(struct iscsi_task *task, struct scatterlist *sg,
 		      io_task->psgl_handle->sgl_index);
 
 	hwi_write_sgl_v2(pwrb, sg, num_sg, io_task);
+	if (phba->func_caps & BE_ADAPTER_IFD_CAP) {
+		cpu_num = get_cpu();
+		cq_num = phba->msix_cpu_map[cpu_num].cq_id;
+		AMAP_SET_BITS(struct amap_iscsi_wrb_v2, cq_id, pwrb, cq_num);
+		put_cpu();
+	}
+
 	AMAP_SET_BITS(struct amap_iscsi_wrb_v2, ptr2nextwrb, pwrb,
 		      io_task->pwrb_handle->nxt_wrb_index);
 
@@ -4917,6 +4977,7 @@ static int beiscsi_iotask(struct iscsi_task *task, struct scatterlist *sg,
 	struct beiscsi_hba *phba = beiscsi_conn->phba;
 	struct iscsi_wrb *pwrb = NULL;
 	unsigned int doorbell = 0;
+	uint8_t cpu_num, cq_num;
 
 	pwrb = io_task->pwrb_handle->pwrb;
 	io_task->cmd_bhs->iscsi_hdr.exp_statsn = 0;
@@ -4948,6 +5009,13 @@ static int beiscsi_iotask(struct iscsi_task *task, struct scatterlist *sg,
 
 	hwi_write_sgl(pwrb, sg, num_sg, io_task);
 
+	if (phba->func_caps & BE_ADAPTER_IFD_CAP) {
+		cpu_num = get_cpu();
+		cq_num = phba->msix_cpu_map[cpu_num].cq_id;
+		AMAP_SET_BITS(struct amap_iscsi_wrb, cq_id, pwrb, cq_num);
+		put_cpu();
+	}
+
 	AMAP_SET_BITS(struct amap_iscsi_wrb, ptr2nextwrb, pwrb,
 		      io_task->pwrb_handle->nxt_wrb_index);
 	be_dws_le_to_cpu(pwrb, sizeof(struct iscsi_wrb));
@@ -4972,6 +5040,7 @@ static int beiscsi_mtask(struct iscsi_task *task)
 	unsigned int doorbell = 0;
 	unsigned int cid;
 	unsigned int pwrb_typeoffset = 0;
+	uint8_t cpu_num, cq_num;
 
 	cid = beiscsi_conn->beiscsi_conn_cid;
 	pwrb = io_task->pwrb_handle->pwrb;
@@ -5003,6 +5072,19 @@ static int beiscsi_mtask(struct iscsi_task *task)
 		pwrb_typeoffset = SKH_WRB_TYPE_OFFSET;
 	}
 
+	if (phba->func_caps & BE_ADAPTER_IFD_CAP) {
+		cpu_num = get_cpu();
+		cq_num = phba->msix_cpu_map[cpu_num].cq_id;
+
+		if (is_chip_be2_be3r(phba))
+			AMAP_SET_BITS(struct amap_iscsi_wrb,
+				      cq_id, pwrb, cq_num);
+		else
+			AMAP_SET_BITS(struct amap_iscsi_wrb_v2,
+				      cq_id, pwrb, cq_num);
+		put_cpu();
+	}
+
 
 	switch (task->hdr->opcode & ISCSI_OPCODE_MASK) {
 	case ISCSI_OP_LOGIN:
@@ -5587,6 +5669,15 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 			phba->num_cpus = 1;
 	}
 
+
+	if (beiscsi_irq_affinity_enable) {
+		if (mgmt_get_adapter_caps(phba))
+			beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_INIT,
+				    "BM_%d : Error in getting Capabilites"
+				    "IRQ_Affinity setting is disabled\n");
+	} else
+		phba->func_caps = BEISCSI_IFD_STATE_DISABLE;
+
 	phba->shost->max_id = phba->params.cxns_per_ctrl;
 	beiscsi_get_params(phba);
 	phba->shost->can_queue = phba->params.ios_per_ctrl;
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 31fa27b..0076119 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -234,6 +234,15 @@ struct sgl_handle {
 	struct iscsi_sge *pfrag;
 };
 
+struct msix_vec_map {
+	 cpumask_t affinity_mask;
+	u16     eq_id;
+	u16     cq_id;
+	u32     nvec;
+	unsigned int cpu_id;
+	unsigned int node_id;
+};
+
 struct hba_parameters {
 	unsigned int ios_per_ctrl;
 	unsigned int cxns_per_ctrl;
@@ -412,12 +421,13 @@ struct beiscsi_hba {
 	unsigned int interface_handle;
 	struct mgmt_session_info boot_sess;
 	struct invalidate_command_table inv_tbl[128];
-
+	struct msix_vec_map msix_cpu_map[MAX_CPUS];
 	unsigned int attr_log_enable;
 	int (*iotask_fn)(struct iscsi_task *,
 			struct scatterlist *sg,
 			uint32_t num_sg, uint32_t xferlen,
 			uint32_t writedir);
+	uint32_t func_caps;
 };
 
 struct beiscsi_session {
@@ -479,20 +489,21 @@ struct be_cmd_bhs {
 
 struct beiscsi_io_task {
 	struct wrb_handle *pwrb_handle;
+	struct be_cmd_bhs *cmd_bhs;
+	unsigned short bhs_len;
 	struct sgl_handle *psgl_handle;
+	struct hwi_wrb_context *pwrb_context;
 	struct beiscsi_conn *conn;
 	struct scsi_cmnd *scsi_cmnd;
+	uint8_t wrb_type;
 	unsigned int cmd_sn;
 	unsigned int flags;
 	unsigned short cid;
 	unsigned short header_len;
 	itt_t libiscsi_itt;
-	struct be_cmd_bhs *cmd_bhs;
 	struct be_bus_address bhs_pa;
-	unsigned short bhs_len;
 	dma_addr_t mtask_addr;
 	uint32_t mtask_data_count;
-	uint8_t wrb_type;
 };
 
 struct be_nonio_bhs {
@@ -745,7 +756,8 @@ struct amap_iscsi_wrb {
 	u8 ptr2nextwrb[8];	/* DWORD 1 */
 	u8 r2t_exp_dtl[24];	/* DWORD 1 */
 	u8 sgl_icd_idx[12];	/* DWORD 2 */
-	u8 rsvd0[20];		/* DWORD 2 */
+	u8 cq_id[10];		/* DWORD 2 */
+	u8 rsvd0[10];		/* DWORD 2 */
 	u8 exp_data_sn[32];	/* DWORD 3 */
 	u8 iscsi_bhs_addr_hi[32];	/* DWORD 4 */
 	u8 iscsi_bhs_addr_lo[32];	/* DWORD 5 */
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 088bdf7..1b6c3fb 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -758,11 +758,47 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 	sge->pa_hi = cpu_to_le32(upper_32_bits(nonemb_cmd->dma));
 	sge->pa_lo = cpu_to_le32(nonemb_cmd->dma & 0xFFFFFFFF);
 	sge->len = cpu_to_le32(nonemb_cmd->size);
+
+	/* Enable interrupt redirection for CXN */
+	if (phba->func_caps & BE_ADAPTER_IFD_CAP)
+		req->ifd_state = BEISCSI_IFD_STATE_ENABLE;
+
 	be_mcc_notify(phba);
 	spin_unlock(&ctrl->mbox_lock);
 	return tag;
 }
 
+int mgmt_get_adapter_caps(struct beiscsi_hba *phba)
+{
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct be_mgmt_cntl_additional_attrib *req = embedded_payload(wrb);
+	int status = 0;
+
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_COMMON,
+			   OPCODE_COMMON_GET_CNTL_ADV_ATTRIB,
+			   sizeof(*req));
+	status = be_mbox_notify(ctrl);
+
+	if (status) {
+		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_INIT,
+			    "BG_%d : Failed in mgmt_get_adapter_caps\n");
+		spin_unlock(&ctrl->mbox_lock);
+		phba->func_caps = BEISCSI_IFD_STATE_DISABLE;
+		return status;
+	}
+
+	phba->func_caps = req->params.func_caps;
+	spin_unlock(&ctrl->mbox_lock);
+	return status;
+}
+
+
+
 unsigned int mgmt_get_all_if_id(struct beiscsi_hba *phba)
 {
 	struct be_ctrl_info *ctrl = &phba->ctrl;
@@ -1525,11 +1561,13 @@ beiscsi_phys_port_disp(struct device *dev, struct device_attribute *attr,
 			phba->fw_config.phys_port);
 }
 
-void beiscsi_offload_cxn_v0(struct beiscsi_offload_params *params,
-			     struct wrb_handle *pwrb_handle,
-			     struct be_mem_descriptor *mem_descr)
+void beiscsi_offload_cxn_v0(struct beiscsi_hba *phba,
+			     struct beiscsi_offload_params *params,
+			     struct wrb_handle *pwrb_handle)
 {
 	struct iscsi_wrb *pwrb = pwrb_handle->pwrb;
+	struct be_mem_descriptor *mem_descr = phba->init_mem;
+	uint8_t cpu_num, cq_num;
 
 	memset(pwrb, 0, sizeof(*pwrb));
 	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb,
@@ -1588,12 +1626,21 @@ void beiscsi_offload_cxn_v0(struct beiscsi_offload_params *params,
 	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb,
 		      pad_buffer_addr_lo, pwrb,
 		      mem_descr->mem_array[0].bus_address.u.a32.address_lo);
+
+	if (phba->func_caps & BE_ADAPTER_IFD_CAP) {
+		cpu_num = get_cpu();
+		cq_num = phba->msix_cpu_map[cpu_num].cq_id;
+		AMAP_SET_BITS(struct amap_iscsi_wrb, cq_id, pwrb, cq_num);
+		put_cpu();
+	}
 }
 
-void beiscsi_offload_cxn_v2(struct beiscsi_offload_params *params,
+void beiscsi_offload_cxn_v2(struct beiscsi_hba *phba,
+			     struct beiscsi_offload_params *params,
 			     struct wrb_handle *pwrb_handle)
 {
 	struct iscsi_wrb *pwrb = pwrb_handle->pwrb;
+	uint8_t cpu_num, cq_num;
 
 	memset(pwrb, 0, sizeof(*pwrb));
 
@@ -1660,4 +1707,12 @@ void beiscsi_offload_cxn_v2(struct beiscsi_offload_params *params,
 		      pwrb,
 		     (params->dw[offsetof(struct amap_beiscsi_offload_params,
 		      exp_statsn) / 32] + 1));
+
+	if (phba->func_caps & BE_ADAPTER_IFD_CAP) {
+		cpu_num = get_cpu();
+		cq_num = phba->msix_cpu_map[cpu_num].cq_id;
+		AMAP_SET_BITS(struct amap_iscsi_wrb_v2, cq_id, pwrb, cq_num);
+		put_cpu();
+	}
+
 }
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index 01b8c97..e1dd796 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -221,6 +221,41 @@ struct be_mgmt_controller_attributes_resp {
 	struct mgmt_controller_attributes params;
 } __packed;
 
+#define BE_ADAPTER_IFD_CAP     0x01
+struct mgmt_cntrl_additional_attrib {
+	u16 ipl_file_number;
+	u8 ipl_file_version;
+	u8 rsvd0;
+	u8 on_die_temp;
+	u8 rsvd1[3];
+	u32 func_caps;
+	u32 rsvd2[4];
+	u8 fcoe_universal_bios_version[32];
+	u8 fcoe_x86_bios_version[32];
+	u8 fcoe_efi_bios_version[32];
+	u8 fcoe_fcode_version[32];
+	u8 uefi_bios_version[32];
+	u8 uefi_nic_version[32];
+	u8 uefi_fcode_version[32];
+	u8 uefi_iscsi_version[32];
+	u8 iscsi_x86_bios_version[32];
+	u8 pxe_x86_bios_version[32];
+	u8 fcoe_default_wwpn[8];
+	u8 ext_phy_version[32];
+	u8 fc_universal_bios_version[32];
+	u8 fc_x86_bios_version[32];
+	u8 fc_efi_bios_version[32];
+	u8 fc_fcode_version[32];
+	u8 ext_phy_crc_label[8];
+	u8 rsvd3[88];
+} __packed;
+
+struct be_mgmt_cntl_additional_attrib {
+	struct be_cmd_req_hdr hdr;
+	struct mgmt_cntrl_additional_attrib params;
+} __packed;
+
+
 struct be_bsg_vendor_cmd {
 	struct be_cmd_req_hdr hdr;
 	unsigned short region;
@@ -269,6 +304,8 @@ struct beiscsi_endpoint {
 int mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 				 struct beiscsi_hba *phba);
 
+int mgmt_get_adapter_caps(struct beiscsi_hba *phba);
+
 unsigned int mgmt_invalidate_connection(struct beiscsi_hba *phba,
 					 struct beiscsi_endpoint *beiscsi_ep,
 					 unsigned short cid,
@@ -328,12 +365,14 @@ ssize_t beiscsi_free_session_disp(struct device *dev,
 ssize_t beiscsi_phys_port_disp(struct device *dev,
 				struct device_attribute *attr, char *buf);
 
-void beiscsi_offload_cxn_v0(struct beiscsi_offload_params *params,
-			     struct wrb_handle *pwrb_handle,
-			     struct be_mem_descriptor *mem_descr);
-
-void beiscsi_offload_cxn_v2(struct beiscsi_offload_params *params,
+void beiscsi_offload_cxn_v0(struct beiscsi_hba *phba,
+			     struct beiscsi_offload_params *params,
 			     struct wrb_handle *pwrb_handle);
+
+void beiscsi_offload_cxn_v2(struct beiscsi_hba *phba,
+			    struct beiscsi_offload_params *params,
+			    struct wrb_handle *pwrb_handle);
+
 void beiscsi_ue_detect(struct beiscsi_hba *phba);
 
 #endif
-- 
1.8.5.3

