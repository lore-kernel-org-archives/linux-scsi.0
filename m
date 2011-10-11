From: James Smart <james.smart@emulex.com>
Subject: [PATCH 3/6] lpfc 8.3.27: Change algorithm for getting physical port
 name
Date: Mon, 10 Oct 2011 21:33:25 -0400
Message-ID: <1318296807.5189.12.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht2.emulex.com ([138.239.113.184]:33721 "EHLO
	exht2.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750748Ab1JKBhj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Oct 2011 21:37:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Implemented new algorithm for getting physical port name for all SLI4 devices


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hw4.h  |  161 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 lpfc_init.c |   17 ++++-
 lpfc_sli.c  |  180 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 lpfc_sli4.h |   14 ++++
 4 files changed, 366 insertions(+), 6 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2011-10-10 16:46:36.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2011-10-10 16:46:37.000000000 -0400
@@ -785,6 +785,8 @@ union lpfc_sli4_cfg_shdr {
 #define LPFC_Q_CREATE_VERSION_2	2
 #define LPFC_Q_CREATE_VERSION_1	1
 #define LPFC_Q_CREATE_VERSION_0	0
+#define LPFC_OPCODE_VERSION_0	0
+#define LPFC_OPCODE_VERSION_1	1
 	} request;
 	struct {
 		uint32_t word6;
@@ -848,6 +850,7 @@ struct mbox_header {
 #define LPFC_MBOX_OPCODE_EQ_DESTROY			0x37
 #define LPFC_MBOX_OPCODE_QUERY_FW_CFG			0x3A
 #define LPFC_MBOX_OPCODE_FUNCTION_RESET			0x3D
+#define LPFC_MBOX_OPCODE_GET_PORT_NAME			0x4D
 #define LPFC_MBOX_OPCODE_MQ_CREATE_EXT			0x5A
 #define LPFC_MBOX_OPCODE_GET_RSRC_EXTENT_INFO		0x9A
 #define LPFC_MBOX_OPCODE_GET_ALLOC_RSRC_EXTENT		0x9B
@@ -2030,6 +2033,15 @@ struct lpfc_mbx_read_config {
 #define lpfc_mbx_rd_conf_extnts_inuse_MASK	0x00000001
 #define lpfc_mbx_rd_conf_extnts_inuse_WORD	word1
 	uint32_t word2;
+#define lpfc_mbx_rd_conf_lnk_numb_SHIFT		0
+#define lpfc_mbx_rd_conf_lnk_numb_MASK		0x0000003F
+#define lpfc_mbx_rd_conf_lnk_numb_WORD		word2
+#define lpfc_mbx_rd_conf_lnk_type_SHIFT		6
+#define lpfc_mbx_rd_conf_lnk_type_MASK		0x00000003
+#define lpfc_mbx_rd_conf_lnk_type_WORD		word2
+#define lpfc_mbx_rd_conf_lnk_ldv_SHIFT		8
+#define lpfc_mbx_rd_conf_lnk_ldv_MASK		0x00000001
+#define lpfc_mbx_rd_conf_lnk_ldv_WORD		word2
 #define lpfc_mbx_rd_conf_topology_SHIFT		24
 #define lpfc_mbx_rd_conf_topology_MASK		0x000000FF
 #define lpfc_mbx_rd_conf_topology_WORD		word2
@@ -2563,8 +2575,152 @@ struct lpfc_mbx_get_prof_cfg {
 	} u;
 };
 
+struct lpfc_controller_attribute {
+	uint32_t version_string[8];
+	uint32_t manufacturer_name[8];
+	uint32_t supported_modes;
+	uint32_t word17;
+#define lpfc_cntl_attr_eprom_ver_lo_SHIFT	0
+#define lpfc_cntl_attr_eprom_ver_lo_MASK	0x000000ff
+#define lpfc_cntl_attr_eprom_ver_lo_WORD	word17
+#define lpfc_cntl_attr_eprom_ver_hi_SHIFT	8
+#define lpfc_cntl_attr_eprom_ver_hi_MASK	0x000000ff
+#define lpfc_cntl_attr_eprom_ver_hi_WORD	word17
+	uint32_t mbx_da_struct_ver;
+	uint32_t ep_fw_da_struct_ver;
+	uint32_t ncsi_ver_str[3];
+	uint32_t dflt_ext_timeout;
+	uint32_t model_number[8];
+	uint32_t description[16];
+	uint32_t serial_number[8];
+	uint32_t ip_ver_str[8];
+	uint32_t fw_ver_str[8];
+	uint32_t bios_ver_str[8];
+	uint32_t redboot_ver_str[8];
+	uint32_t driver_ver_str[8];
+	uint32_t flash_fw_ver_str[8];
+	uint32_t functionality;
+	uint32_t word105;
+#define lpfc_cntl_attr_max_cbd_len_SHIFT	0
+#define lpfc_cntl_attr_max_cbd_len_MASK		0x0000ffff
+#define lpfc_cntl_attr_max_cbd_len_WORD		word105
+#define lpfc_cntl_attr_asic_rev_SHIFT		16
+#define lpfc_cntl_attr_asic_rev_MASK		0x000000ff
+#define lpfc_cntl_attr_asic_rev_WORD		word105
+#define lpfc_cntl_attr_gen_guid0_SHIFT		24
+#define lpfc_cntl_attr_gen_guid0_MASK		0x000000ff
+#define lpfc_cntl_attr_gen_guid0_WORD		word105
+	uint32_t gen_guid1_12[3];
+	uint32_t word109;
+#define lpfc_cntl_attr_gen_guid13_14_SHIFT	0
+#define lpfc_cntl_attr_gen_guid13_14_MASK	0x0000ffff
+#define lpfc_cntl_attr_gen_guid13_14_WORD	word109
+#define lpfc_cntl_attr_gen_guid15_SHIFT		16
+#define lpfc_cntl_attr_gen_guid15_MASK		0x000000ff
+#define lpfc_cntl_attr_gen_guid15_WORD		word109
+#define lpfc_cntl_attr_hba_port_cnt_SHIFT	24
+#define lpfc_cntl_attr_hba_port_cnt_MASK	0x000000ff
+#define lpfc_cntl_attr_hba_port_cnt_WORD	word109
+	uint32_t word110;
+#define lpfc_cntl_attr_dflt_lnk_tmo_SHIFT	0
+#define lpfc_cntl_attr_dflt_lnk_tmo_MASK	0x0000ffff
+#define lpfc_cntl_attr_dflt_lnk_tmo_WORD	word110
+#define lpfc_cntl_attr_multi_func_dev_SHIFT	24
+#define lpfc_cntl_attr_multi_func_dev_MASK	0x000000ff
+#define lpfc_cntl_attr_multi_func_dev_WORD	word110
+	uint32_t word111;
+#define lpfc_cntl_attr_cache_valid_SHIFT	0
+#define lpfc_cntl_attr_cache_valid_MASK		0x000000ff
+#define lpfc_cntl_attr_cache_valid_WORD		word111
+#define lpfc_cntl_attr_hba_status_SHIFT		8
+#define lpfc_cntl_attr_hba_status_MASK		0x000000ff
+#define lpfc_cntl_attr_hba_status_WORD		word111
+#define lpfc_cntl_attr_max_domain_SHIFT		16
+#define lpfc_cntl_attr_max_domain_MASK		0x000000ff
+#define lpfc_cntl_attr_max_domain_WORD		word111
+#define lpfc_cntl_attr_lnk_numb_SHIFT		24
+#define lpfc_cntl_attr_lnk_numb_MASK		0x0000003f
+#define lpfc_cntl_attr_lnk_numb_WORD		word111
+#define lpfc_cntl_attr_lnk_type_SHIFT		30
+#define lpfc_cntl_attr_lnk_type_MASK		0x00000003
+#define lpfc_cntl_attr_lnk_type_WORD		word111
+	uint32_t fw_post_status;
+	uint32_t hba_mtu[8];
+	uint32_t word121;
+	uint32_t reserved1[3];
+	uint32_t word125;
+#define lpfc_cntl_attr_pci_vendor_id_SHIFT	0
+#define lpfc_cntl_attr_pci_vendor_id_MASK	0x0000ffff
+#define lpfc_cntl_attr_pci_vendor_id_WORD	word125
+#define lpfc_cntl_attr_pci_device_id_SHIFT	16
+#define lpfc_cntl_attr_pci_device_id_MASK	0x0000ffff
+#define lpfc_cntl_attr_pci_device_id_WORD	word125
+	uint32_t word126;
+#define lpfc_cntl_attr_pci_subvdr_id_SHIFT	0
+#define lpfc_cntl_attr_pci_subvdr_id_MASK	0x0000ffff
+#define lpfc_cntl_attr_pci_subvdr_id_WORD	word126
+#define lpfc_cntl_attr_pci_subsys_id_SHIFT	16
+#define lpfc_cntl_attr_pci_subsys_id_MASK	0x0000ffff
+#define lpfc_cntl_attr_pci_subsys_id_WORD	word126
+	uint32_t word127;
+#define lpfc_cntl_attr_pci_bus_num_SHIFT	0
+#define lpfc_cntl_attr_pci_bus_num_MASK		0x000000ff
+#define lpfc_cntl_attr_pci_bus_num_WORD		word127
+#define lpfc_cntl_attr_pci_dev_num_SHIFT	8
+#define lpfc_cntl_attr_pci_dev_num_MASK		0x000000ff
+#define lpfc_cntl_attr_pci_dev_num_WORD		word127
+#define lpfc_cntl_attr_pci_fnc_num_SHIFT	16
+#define lpfc_cntl_attr_pci_fnc_num_MASK		0x000000ff
+#define lpfc_cntl_attr_pci_fnc_num_WORD		word127
+#define lpfc_cntl_attr_inf_type_SHIFT		24
+#define lpfc_cntl_attr_inf_type_MASK		0x000000ff
+#define lpfc_cntl_attr_inf_type_WORD		word127
+	uint32_t unique_id[2];
+	uint32_t word130;
+#define lpfc_cntl_attr_num_netfil_SHIFT		0
+#define lpfc_cntl_attr_num_netfil_MASK		0x000000ff
+#define lpfc_cntl_attr_num_netfil_WORD		word130
+	uint32_t reserved2[4];
+};
+
+struct lpfc_mbx_get_cntl_attributes {
+	union  lpfc_sli4_cfg_shdr cfg_shdr;
+	struct lpfc_controller_attribute cntl_attr;
+};
+
+struct lpfc_mbx_get_port_name {
+	struct mbox_header header;
+	union {
+		struct {
+			uint32_t word4;
+#define lpfc_mbx_get_port_name_lnk_type_SHIFT	0
+#define lpfc_mbx_get_port_name_lnk_type_MASK	0x00000003
+#define lpfc_mbx_get_port_name_lnk_type_WORD	word4
+		} request;
+		struct {
+			uint32_t word4;
+#define lpfc_mbx_get_port_name_name0_SHIFT	0
+#define lpfc_mbx_get_port_name_name0_MASK	0x000000FF
+#define lpfc_mbx_get_port_name_name0_WORD	word4
+#define lpfc_mbx_get_port_name_name1_SHIFT	8
+#define lpfc_mbx_get_port_name_name1_MASK	0x000000FF
+#define lpfc_mbx_get_port_name_name1_WORD	word4
+#define lpfc_mbx_get_port_name_name2_SHIFT	16
+#define lpfc_mbx_get_port_name_name2_MASK	0x000000FF
+#define lpfc_mbx_get_port_name_name2_WORD	word4
+#define lpfc_mbx_get_port_name_name3_SHIFT	24
+#define lpfc_mbx_get_port_name_name3_MASK	0x000000FF
+#define lpfc_mbx_get_port_name_name3_WORD	word4
+#define LPFC_LINK_NUMBER_0			0
+#define LPFC_LINK_NUMBER_1			1
+#define LPFC_LINK_NUMBER_2			2
+#define LPFC_LINK_NUMBER_3			3
+		} response;
+	} u;
+};
+
 /* Mailbox Completion Queue Error Messages */
-#define MB_CQE_STATUS_SUCCESS 			0x0
+#define MB_CQE_STATUS_SUCCESS			0x0
 #define MB_CQE_STATUS_INSUFFICIENT_PRIVILEGES	0x1
 #define MB_CQE_STATUS_INVALID_PARAMETER		0x2
 #define MB_CQE_STATUS_INSUFFICIENT_RESOURCES	0x3
@@ -2648,8 +2804,9 @@ struct lpfc_mqe {
 		struct lpfc_mbx_run_link_diag_test link_diag_test;
 		struct lpfc_mbx_get_func_cfg get_func_cfg;
 		struct lpfc_mbx_get_prof_cfg get_prof_cfg;
-		struct lpfc_mbx_nop nop;
 		struct lpfc_mbx_wr_object wr_object;
+		struct lpfc_mbx_get_port_name get_port_name;
+		struct lpfc_mbx_nop nop;
 	} un;
 };
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2011-10-10 16:46:36.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2011-10-10 16:46:37.000000000 -0400
@@ -1733,11 +1733,20 @@ lpfc_parse_vpd(struct lpfc_hba *phba, ui
 				j = 0;
 				Length -= (3+i);
 				while(i--) {
-				phba->Port[j++] = vpd[index++];
-				if (j == 19)
-					break;
+					if ((phba->sli_rev == LPFC_SLI_REV4) &&
+					    (phba->sli4_hba.pport_name_sta ==
+					     LPFC_SLI4_PPNAME_GET)) {
+						j++;
+						index++;
+					} else
+						phba->Port[j++] = vpd[index++];
+					if (j == 19)
+						break;
 				}
-				phba->Port[j] = 0;
+				if ((phba->sli_rev != LPFC_SLI_REV4) ||
+				    (phba->sli4_hba.pport_name_sta ==
+				     LPFC_SLI4_PPNAME_NON))
+					phba->Port[j] = 0;
 				continue;
 			}
 			else {
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2011-10-10 16:46:36.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2011-10-10 16:46:37.000000000 -0400
@@ -389,6 +389,16 @@ struct lpfc_iov {
 	uint32_t vf_number;
 };
 
+struct lpfc_sli4_lnk_info {
+	uint8_t lnk_dv;
+#define LPFC_LNK_DAT_INVAL	0
+#define LPFC_LNK_DAT_VAL	1
+	uint8_t lnk_tp;
+#define LPFC_LNK_GE	0x0 /* FCoE */
+#define LPFC_LNK_FC	0x1 /* FC   */
+	uint8_t lnk_no;
+};
+
 /* SLI4 HBA data structure entries */
 struct lpfc_sli4_hba {
 	void __iomem *conf_regs_memmap_p; /* Kernel memory mapped address for
@@ -504,6 +514,10 @@ struct lpfc_sli4_hba {
 	struct list_head sp_els_xri_aborted_work_queue;
 	struct list_head sp_unsol_work_queue;
 	struct lpfc_sli4_link link_state;
+	struct lpfc_sli4_lnk_info lnk_info;
+	uint32_t pport_name_sta;
+#define LPFC_SLI4_PPNAME_NON	0
+#define LPFC_SLI4_PPNAME_GET	1
 	struct lpfc_iov iov;
 	spinlock_t abts_scsi_buf_list_lock; /* list of aborted SCSI IOs */
 	spinlock_t abts_sgl_list_lock; /* list of aborted els IOs */
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2011-10-10 16:46:36.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2011-10-10 16:46:37.000000000 -0400
@@ -4692,6 +4692,175 @@ lpfc_sli4_read_rev(struct lpfc_hba *phba
 }
 
 /**
+ * lpfc_sli4_retrieve_pport_name - Retrieve SLI4 device physical port name
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine retrieves SLI4 device physical port name this PCI function
+ * is attached to.
+ *
+ * Return codes
+ *      0 - sucessful
+ *      otherwise - failed to retrieve physical port name
+ **/
+static int
+lpfc_sli4_retrieve_pport_name(struct lpfc_hba *phba)
+{
+	LPFC_MBOXQ_t *mboxq;
+	struct lpfc_mbx_read_config *rd_config;
+	struct lpfc_mbx_get_cntl_attributes *mbx_cntl_attr;
+	struct lpfc_controller_attribute *cntl_attr;
+	struct lpfc_mbx_get_port_name *get_port_name;
+	void *virtaddr = NULL;
+	uint32_t alloclen, reqlen;
+	uint32_t shdr_status, shdr_add_status;
+	union lpfc_sli4_cfg_shdr *shdr;
+	char cport_name = 0;
+	int rc;
+
+	/* We assume nothing at this point */
+	phba->sli4_hba.lnk_info.lnk_dv = LPFC_LNK_DAT_INVAL;
+	phba->sli4_hba.pport_name_sta = LPFC_SLI4_PPNAME_NON;
+
+	mboxq = (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mboxq)
+		return -ENOMEM;
+
+	/* obtain link type and link number via READ_CONFIG */
+	lpfc_read_config(phba, mboxq);
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+	if (rc == MBX_SUCCESS) {
+		rd_config = &mboxq->u.mqe.un.rd_config;
+		if (bf_get(lpfc_mbx_rd_conf_lnk_ldv, rd_config)) {
+			phba->sli4_hba.lnk_info.lnk_dv = LPFC_LNK_DAT_VAL;
+			phba->sli4_hba.lnk_info.lnk_tp =
+				bf_get(lpfc_mbx_rd_conf_lnk_type, rd_config);
+			phba->sli4_hba.lnk_info.lnk_no =
+				bf_get(lpfc_mbx_rd_conf_lnk_numb, rd_config);
+			lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+					"3081 lnk_type:%d, lnk_numb:%d\n",
+					phba->sli4_hba.lnk_info.lnk_tp,
+					phba->sli4_hba.lnk_info.lnk_no);
+			goto retrieve_ppname;
+		} else
+			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+					"3082 Mailbox (x%x) returned ldv:x0\n",
+					bf_get(lpfc_mqe_command,
+					       &mboxq->u.mqe));
+	} else
+		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+				"3083 Mailbox (x%x) failed, status:x%x\n",
+				bf_get(lpfc_mqe_command, &mboxq->u.mqe),
+				bf_get(lpfc_mqe_status, &mboxq->u.mqe));
+
+	/* obtain link type and link number via COMMON_GET_CNTL_ATTRIBUTES */
+	reqlen = sizeof(struct lpfc_mbx_get_cntl_attributes);
+	alloclen = lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_COMMON,
+			LPFC_MBOX_OPCODE_GET_CNTL_ATTRIBUTES, reqlen,
+			LPFC_SLI4_MBX_NEMBED);
+	if (alloclen < reqlen) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"3084 Allocated DMA memory size (%d) is "
+				"less than the requested DMA memory size "
+				"(%d)\n", alloclen, reqlen);
+		rc = -ENOMEM;
+		goto out_free_mboxq;
+	}
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+	virtaddr = mboxq->sge_array->addr[0];
+	mbx_cntl_attr = (struct lpfc_mbx_get_cntl_attributes *)virtaddr;
+	shdr = &mbx_cntl_attr->cfg_shdr;
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
+	if (shdr_status || shdr_add_status || rc) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+				"3085 Mailbox x%x (x%x/x%x) failed, "
+				"rc:x%x, status:x%x, add_status:x%x\n",
+				bf_get(lpfc_mqe_command, &mboxq->u.mqe),
+				lpfc_sli_config_mbox_subsys_get(phba, mboxq),
+				lpfc_sli_config_mbox_opcode_get(phba, mboxq),
+				rc, shdr_status, shdr_add_status);
+		rc = -ENXIO;
+		goto out_free_mboxq;
+	}
+	cntl_attr = &mbx_cntl_attr->cntl_attr;
+	phba->sli4_hba.lnk_info.lnk_dv = LPFC_LNK_DAT_VAL;
+	phba->sli4_hba.lnk_info.lnk_tp =
+		bf_get(lpfc_cntl_attr_lnk_type, cntl_attr);
+	phba->sli4_hba.lnk_info.lnk_no =
+		bf_get(lpfc_cntl_attr_lnk_numb, cntl_attr);
+	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+			"3086 lnk_type:%d, lnk_numb:%d\n",
+			phba->sli4_hba.lnk_info.lnk_tp,
+			phba->sli4_hba.lnk_info.lnk_no);
+
+retrieve_ppname:
+	lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_COMMON,
+		LPFC_MBOX_OPCODE_GET_PORT_NAME,
+		sizeof(struct lpfc_mbx_get_port_name) -
+		sizeof(struct lpfc_sli4_cfg_mhdr),
+		LPFC_SLI4_MBX_EMBED);
+	get_port_name = &mboxq->u.mqe.un.get_port_name;
+	shdr = (union lpfc_sli4_cfg_shdr *)&get_port_name->header.cfg_shdr;
+	bf_set(lpfc_mbox_hdr_version, &shdr->request, LPFC_OPCODE_VERSION_1);
+	bf_set(lpfc_mbx_get_port_name_lnk_type, &get_port_name->u.request,
+		phba->sli4_hba.lnk_info.lnk_tp);
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
+	if (shdr_status || shdr_add_status || rc) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+				"3087 Mailbox x%x (x%x/x%x) failed: "
+				"rc:x%x, status:x%x, add_status:x%x\n",
+				bf_get(lpfc_mqe_command, &mboxq->u.mqe),
+				lpfc_sli_config_mbox_subsys_get(phba, mboxq),
+				lpfc_sli_config_mbox_opcode_get(phba, mboxq),
+				rc, shdr_status, shdr_add_status);
+		rc = -ENXIO;
+		goto out_free_mboxq;
+	}
+	switch (phba->sli4_hba.lnk_info.lnk_no) {
+	case LPFC_LINK_NUMBER_0:
+		cport_name = bf_get(lpfc_mbx_get_port_name_name0,
+				&get_port_name->u.response);
+		phba->sli4_hba.pport_name_sta = LPFC_SLI4_PPNAME_GET;
+		break;
+	case LPFC_LINK_NUMBER_1:
+		cport_name = bf_get(lpfc_mbx_get_port_name_name1,
+				&get_port_name->u.response);
+		phba->sli4_hba.pport_name_sta = LPFC_SLI4_PPNAME_GET;
+		break;
+	case LPFC_LINK_NUMBER_2:
+		cport_name = bf_get(lpfc_mbx_get_port_name_name2,
+				&get_port_name->u.response);
+		phba->sli4_hba.pport_name_sta = LPFC_SLI4_PPNAME_GET;
+		break;
+	case LPFC_LINK_NUMBER_3:
+		cport_name = bf_get(lpfc_mbx_get_port_name_name3,
+				&get_port_name->u.response);
+		phba->sli4_hba.pport_name_sta = LPFC_SLI4_PPNAME_GET;
+		break;
+	default:
+		break;
+	}
+
+	if (phba->sli4_hba.pport_name_sta == LPFC_SLI4_PPNAME_GET) {
+		phba->Port[0] = cport_name;
+		phba->Port[1] = '\0';
+		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+				"3091 SLI get port name: %s\n", phba->Port);
+	}
+
+out_free_mboxq:
+	if (rc != MBX_TIMEOUT) {
+		if (bf_get(lpfc_mqe_command, &mboxq->u.mqe) == MBX_SLI4_CONFIG)
+			lpfc_sli4_mbox_cmd_free(phba, mboxq);
+		else
+			mempool_free(mboxq, phba->mbox_mem_pool);
+	}
+	return rc;
+}
+
+/**
  * lpfc_sli4_arm_cqeq_intr - Arm sli-4 device completion and event queues
  * @phba: pointer to lpfc hba data structure.
  *
@@ -5754,6 +5923,17 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 		kfree(vpd);
 		goto out_free_mbox;
 	}
+
+	/*
+	 * Retrieve sli4 device physical port name, failure of doing it
+	 * is considered as non-fatal.
+	 */
+	rc = lpfc_sli4_retrieve_pport_name(phba);
+	if (!rc)
+		lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
+				"3080 Successful retrieving SLI4 device "
+				"physical port name: %s.\n", phba->Port);
+
 	/*
 	 * Evaluate the read rev and vpd data. Populate the driver
 	 * state with the results. If this routine fails, the failure



