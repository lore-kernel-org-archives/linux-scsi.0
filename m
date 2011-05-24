From: James Smart <james.smart@emulex.com>
Subject: [PATCH 3/8] lpfc 8.3.24: Add SR-IOV control
Date: Tue, 24 May 2011 11:42:11 -0400
Message-ID: <1306251731.6335.15.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:23135 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751049Ab1EXPmV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2011 11:42:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add SR-IOV control

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h      |    1 
 lpfc_attr.c |  237 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 lpfc_crtn.h |    2 
 lpfc_hw.h   |    2 
 lpfc_hw4.h  |  149 +++++++++++++++++++++++++++++++++++++
 lpfc_init.c |  144 +++++++++++++++++++++++++++++++++++-
 lpfc_sli4.h |    6 +
 7 files changed, 536 insertions(+), 5 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2011-05-23 16:58:34.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2011-05-23 17:01:19.000000000 -0400
@@ -1384,6 +1384,102 @@ lpfc_dss_show(struct device *dev, struct
 }
 
 /**
+ * lpfc_sriov_hw_max_virtfn_show - Return maximum number of virtual functions
+ * @dev: class converted to a Scsi_host structure.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the formatted support level.
+ *
+ * Description:
+ * Returns the maximum number of virtual functions a physical function can
+ * support, 0 will be returned if called on virtual function.
+ *
+ * Returns: size of formatted string.
+ **/
+static ssize_t
+lpfc_sriov_hw_max_virtfn_show(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_hba *phba = vport->phba;
+	struct pci_dev *pdev = phba->pcidev;
+	union  lpfc_sli4_cfg_shdr *shdr;
+	uint32_t shdr_status, shdr_add_status;
+	LPFC_MBOXQ_t *mboxq;
+	struct lpfc_mbx_get_prof_cfg *get_prof_cfg;
+	struct lpfc_rsrc_desc_pcie *desc;
+	uint32_t max_nr_virtfn;
+	uint32_t desc_count;
+	int length, rc, i;
+
+	if ((phba->sli_rev < LPFC_SLI_REV4) ||
+	    (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) !=
+	     LPFC_SLI_INTF_IF_TYPE_2))
+		return -EPERM;
+
+	if (!pdev->is_physfn)
+		return snprintf(buf, PAGE_SIZE, "%d\n", 0);
+
+	mboxq = (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mboxq)
+		return -ENOMEM;
+
+	/* get the maximum number of virtfn support by physfn */
+	length = (sizeof(struct lpfc_mbx_get_prof_cfg) -
+		  sizeof(struct lpfc_sli4_cfg_mhdr));
+	lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_COMMON,
+			 LPFC_MBOX_OPCODE_GET_PROFILE_CONFIG,
+			 length, LPFC_SLI4_MBX_EMBED);
+	shdr = (union lpfc_sli4_cfg_shdr *)
+		&mboxq->u.mqe.un.sli4_config.header.cfg_shdr;
+	bf_set(lpfc_mbox_hdr_pf_num, &shdr->request,
+	       phba->sli4_hba.iov.pf_number + 1);
+
+	get_prof_cfg = &mboxq->u.mqe.un.get_prof_cfg;
+	bf_set(lpfc_mbx_get_prof_cfg_prof_tp, &get_prof_cfg->u.request,
+	       LPFC_CFG_TYPE_CURRENT_ACTIVE);
+
+	rc = lpfc_sli_issue_mbox_wait(phba, mboxq,
+				lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG));
+
+	if (rc != MBX_TIMEOUT) {
+		/* check return status */
+		shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+		shdr_add_status = bf_get(lpfc_mbox_hdr_add_status,
+					 &shdr->response);
+		if (shdr_status || shdr_add_status || rc)
+			goto error_out;
+
+	} else
+		goto error_out;
+
+	desc_count = get_prof_cfg->u.response.prof_cfg.rsrc_desc_count;
+
+	for (i = 0; i < LPFC_RSRC_DESC_MAX_NUM; i++) {
+		desc = (struct lpfc_rsrc_desc_pcie *)
+			&get_prof_cfg->u.response.prof_cfg.desc[i];
+		if (LPFC_RSRC_DESC_TYPE_PCIE ==
+		    bf_get(lpfc_rsrc_desc_pcie_type, desc)) {
+			max_nr_virtfn = bf_get(lpfc_rsrc_desc_pcie_nr_virtfn,
+					       desc);
+			break;
+		}
+	}
+
+	if (i < LPFC_RSRC_DESC_MAX_NUM) {
+		if (rc != MBX_TIMEOUT)
+			mempool_free(mboxq, phba->mbox_mem_pool);
+		return snprintf(buf, PAGE_SIZE, "%d\n", max_nr_virtfn);
+	}
+
+error_out:
+	if (rc != MBX_TIMEOUT)
+		mempool_free(mboxq, phba->mbox_mem_pool);
+	return -EIO;
+}
+
+/**
  * lpfc_param_show - Return a cfg attribute value in decimal
  *
  * Description:
@@ -1824,6 +1920,8 @@ static DEVICE_ATTR(lpfc_temp_sensor, S_I
 static DEVICE_ATTR(lpfc_fips_level, S_IRUGO, lpfc_fips_level_show, NULL);
 static DEVICE_ATTR(lpfc_fips_rev, S_IRUGO, lpfc_fips_rev_show, NULL);
 static DEVICE_ATTR(lpfc_dss, S_IRUGO, lpfc_dss_show, NULL);
+static DEVICE_ATTR(lpfc_sriov_hw_max_virtfn, S_IRUGO,
+		   lpfc_sriov_hw_max_virtfn_show, NULL);
 
 static char *lpfc_soft_wwn_key = "C99G71SL8032A";
 
@@ -3076,7 +3174,7 @@ static DEVICE_ATTR(lpfc_link_speed, S_IR
  *
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
- * @buf: containing the string "selective".
+ * @buf: containing enable or disable aer flag.
  * @count: unused variable.
  *
  * Description:
@@ -3160,7 +3258,7 @@ lpfc_param_show(aer_support)
 /**
  * lpfc_aer_support_init - Set the initial adapters aer support flag
  * @phba: lpfc_hba pointer.
- * @val: link speed value.
+ * @val: enable aer or disable aer flag.
  *
  * Description:
  * If val is in a valid range [0,1], then set the adapter's initial
@@ -3199,7 +3297,7 @@ static DEVICE_ATTR(lpfc_aer_support, S_I
  * lpfc_aer_cleanup_state - Clean up aer state to the aer enabled device
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
- * @buf: containing the string "selective".
+ * @buf: containing flag 1 for aer cleanup state.
  * @count: unused variable.
  *
  * Description:
@@ -3242,6 +3340,136 @@ lpfc_aer_cleanup_state(struct device *de
 static DEVICE_ATTR(lpfc_aer_state_cleanup, S_IWUSR, NULL,
 		   lpfc_aer_cleanup_state);
 
+/**
+ * lpfc_sriov_nr_virtfn_store - Enable the adapter for sr-iov virtual functions
+ *
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: containing the string the number of vfs to be enabled.
+ * @count: unused variable.
+ *
+ * Description:
+ * When this api is called either through user sysfs, the driver shall
+ * try to enable or disable SR-IOV virtual functions according to the
+ * following:
+ *
+ * If zero virtual function has been enabled to the physical function,
+ * the driver shall invoke the pci enable virtual function api trying
+ * to enable the virtual functions. If the nr_vfn provided is greater
+ * than the maximum supported, the maximum virtual function number will
+ * be used for invoking the api; otherwise, the nr_vfn provided shall
+ * be used for invoking the api. If the api call returned success, the
+ * actual number of virtual functions enabled will be set to the driver
+ * cfg_sriov_nr_virtfn; otherwise, -EINVAL shall be returned and driver
+ * cfg_sriov_nr_virtfn remains zero.
+ *
+ * If none-zero virtual functions have already been enabled to the
+ * physical function, as reflected by the driver's cfg_sriov_nr_virtfn,
+ * -EINVAL will be returned and the driver does nothing;
+ *
+ * If the nr_vfn provided is zero and none-zero virtual functions have
+ * been enabled, as indicated by the driver's cfg_sriov_nr_virtfn, the
+ * disabling virtual function api shall be invoded to disable all the
+ * virtual functions and driver's cfg_sriov_nr_virtfn shall be set to
+ * zero. Otherwise, if zero virtual function has been enabled, do
+ * nothing.
+ *
+ * Returns:
+ * length of the buf on success if val is in range the intended mode
+ * is supported.
+ * -EINVAL if val out of range or intended mode is not supported.
+ **/
+static ssize_t
+lpfc_sriov_nr_virtfn_store(struct device *dev, struct device_attribute *attr,
+			 const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
+	struct lpfc_hba *phba = vport->phba;
+	struct pci_dev *pdev = phba->pcidev;
+	int val = 0, rc = -EINVAL;
+
+	/* Sanity check on user data */
+	if (!isdigit(buf[0]))
+		return -EINVAL;
+	if (sscanf(buf, "%i", &val) != 1)
+		return -EINVAL;
+	if (val < 0)
+		return -EINVAL;
+
+	/* Request disabling virtual functions */
+	if (val == 0) {
+		if (phba->cfg_sriov_nr_virtfn > 0) {
+			pci_disable_sriov(pdev);
+			phba->cfg_sriov_nr_virtfn = 0;
+		}
+		return strlen(buf);
+	}
+
+	/* Request enabling virtual functions */
+	if (phba->cfg_sriov_nr_virtfn > 0) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"3018 There are %d virtual functions "
+				"enabled on physical function.\n",
+				phba->cfg_sriov_nr_virtfn);
+		return -EEXIST;
+	}
+
+	if (val <= LPFC_MAX_VFN_PER_PFN)
+		phba->cfg_sriov_nr_virtfn = val;
+	else {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"3019 Enabling %d virtual functions is not "
+				"allowed.\n", val);
+		return -EINVAL;
+	}
+
+	rc = lpfc_sli_probe_sriov_nr_virtfn(phba, phba->cfg_sriov_nr_virtfn);
+	if (rc) {
+		phba->cfg_sriov_nr_virtfn = 0;
+		rc = -EPERM;
+	} else
+		rc = strlen(buf);
+
+	return rc;
+}
+
+static int lpfc_sriov_nr_virtfn = LPFC_DEF_VFN_PER_PFN;
+module_param(lpfc_sriov_nr_virtfn, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(lpfc_sriov_nr_virtfn, "Enable PCIe device SR-IOV virtual fn");
+lpfc_param_show(sriov_nr_virtfn)
+
+/**
+ * lpfc_sriov_nr_virtfn_init - Set the initial sr-iov virtual function enable
+ * @phba: lpfc_hba pointer.
+ * @val: link speed value.
+ *
+ * Description:
+ * If val is in a valid range [0,255], then set the adapter's initial
+ * cfg_sriov_nr_virtfn field. If it's greater than the maximum, the maximum
+ * number shall be used instead. It will be up to the driver's probe_one
+ * routine to determine whether the device's SR-IOV is supported or not.
+ *
+ * Returns:
+ * zero if val saved.
+ * -EINVAL val out of range
+ **/
+static int
+lpfc_sriov_nr_virtfn_init(struct lpfc_hba *phba, int val)
+{
+	if (val >= 0 && val <= LPFC_MAX_VFN_PER_PFN) {
+		phba->cfg_sriov_nr_virtfn = val;
+		return 0;
+	}
+
+	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"3017 Enabling %d virtual functions is not "
+			"allowed.\n", val);
+	return -EINVAL;
+}
+static DEVICE_ATTR(lpfc_sriov_nr_virtfn, S_IRUGO | S_IWUSR,
+		   lpfc_sriov_nr_virtfn_show, lpfc_sriov_nr_virtfn_store);
+
 /*
 # lpfc_fcp_class:  Determines FC class to use for the FCP protocol.
 # Value range is [2,3]. Default value is 3.
@@ -3559,6 +3787,7 @@ struct device_attribute *lpfc_hba_attrs[
 	&dev_attr_lpfc_prot_sg_seg_cnt,
 	&dev_attr_lpfc_aer_support,
 	&dev_attr_lpfc_aer_state_cleanup,
+	&dev_attr_lpfc_sriov_nr_virtfn,
 	&dev_attr_lpfc_suppress_link_up,
 	&dev_attr_lpfc_iocb_cnt,
 	&dev_attr_iocb_hw,
@@ -3567,6 +3796,7 @@ struct device_attribute *lpfc_hba_attrs[
 	&dev_attr_lpfc_fips_level,
 	&dev_attr_lpfc_fips_rev,
 	&dev_attr_lpfc_dss,
+	&dev_attr_lpfc_sriov_hw_max_virtfn,
 	NULL,
 };
 
@@ -4767,6 +4997,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_hba_queue_depth_init(phba, lpfc_hba_queue_depth);
 	lpfc_hba_log_verbose_init(phba, lpfc_log_verbose);
 	lpfc_aer_support_init(phba, lpfc_aer_support);
+	lpfc_sriov_nr_virtfn_init(phba, lpfc_sriov_nr_virtfn);
 	lpfc_suppress_link_up_init(phba, lpfc_suppress_link_up);
 	lpfc_iocb_cnt_init(phba, lpfc_iocb_cnt);
 	phba->cfg_enable_dss = 1;
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2011-05-23 16:51:47.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2011-05-23 17:01:19.000000000 -0400
@@ -430,3 +430,5 @@ void lpfc_cleanup_wt_rrqs(struct lpfc_hb
 void lpfc_cleanup_vports_rrqs(struct lpfc_vport *, struct lpfc_nodelist *);
 struct lpfc_node_rrq *lpfc_get_active_rrq(struct lpfc_vport *, uint16_t,
 	uint32_t);
+/* functions to support SR-IOV */
+int lpfc_sli_probe_sriov_nr_virtfn(struct lpfc_hba *, int);
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2011-05-23 16:51:47.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2011-05-23 17:01:19.000000000 -0400
@@ -660,6 +660,7 @@ struct lpfc_hba {
 	uint32_t cfg_hostmem_hgp;
 	uint32_t cfg_log_verbose;
 	uint32_t cfg_aer_support;
+	uint32_t cfg_sriov_nr_virtfn;
 	uint32_t cfg_iocb_cnt;
 	uint32_t cfg_suppress_link_up;
 #define LPFC_INITIALIZE_LINK              0	/* do normal init_link mbox */
diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2011-05-23 16:58:34.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2011-05-23 17:01:19.000000000 -0400
@@ -758,6 +758,12 @@ union lpfc_sli4_cfg_shdr {
 #define lpfc_mbox_hdr_version_SHIFT	0
 #define lpfc_mbox_hdr_version_MASK	0x000000FF
 #define lpfc_mbox_hdr_version_WORD	word9
+#define lpfc_mbox_hdr_pf_num_SHIFT	16
+#define lpfc_mbox_hdr_pf_num_MASK	0x000000FF
+#define lpfc_mbox_hdr_pf_num_WORD	word9
+#define lpfc_mbox_hdr_vh_num_SHIFT	24
+#define lpfc_mbox_hdr_vh_num_MASK	0x000000FF
+#define lpfc_mbox_hdr_vh_num_WORD	word9
 #define LPFC_Q_CREATE_VERSION_2	2
 #define LPFC_Q_CREATE_VERSION_1	1
 #define LPFC_Q_CREATE_VERSION_0	0
@@ -813,6 +819,8 @@ struct mbox_header {
 #define LPFC_MBOX_OPCODE_QUERY_FW_CFG		0x3A
 #define LPFC_MBOX_OPCODE_FUNCTION_RESET		0x3D
 #define LPFC_MBOX_OPCODE_MQ_CREATE_EXT		0x5A
+#define LPFC_MBOX_OPCODE_GET_FUNCTION_CONFIG    0xA0
+#define LPFC_MBOX_OPCODE_GET_PROFILE_CONFIG	0xA4
 #define LPFC_MBOX_OPCODE_GET_SLI4_PARAMETERS	0xB5
 
 /* FCoE Opcodes */
@@ -2217,6 +2225,145 @@ struct lpfc_mbx_get_sli4_parameters {
 	struct lpfc_sli4_parameters sli4_parameters;
 };
 
+struct lpfc_rscr_desc_generic {
+#define LPFC_RSRC_DESC_WSIZE			18
+	uint32_t desc[LPFC_RSRC_DESC_WSIZE];
+};
+
+struct lpfc_rsrc_desc_pcie {
+	uint32_t word0;
+#define lpfc_rsrc_desc_pcie_type_SHIFT		0
+#define lpfc_rsrc_desc_pcie_type_MASK		0x000000ff
+#define lpfc_rsrc_desc_pcie_type_WORD		word0
+#define LPFC_RSRC_DESC_TYPE_PCIE		0x40
+	uint32_t word1;
+#define lpfc_rsrc_desc_pcie_pfnum_SHIFT		0
+#define lpfc_rsrc_desc_pcie_pfnum_MASK		0x000000ff
+#define lpfc_rsrc_desc_pcie_pfnum_WORD		word1
+	uint32_t reserved;
+	uint32_t word3;
+#define lpfc_rsrc_desc_pcie_sriov_sta_SHIFT	0
+#define lpfc_rsrc_desc_pcie_sriov_sta_MASK	0x000000ff
+#define lpfc_rsrc_desc_pcie_sriov_sta_WORD	word3
+#define lpfc_rsrc_desc_pcie_pf_sta_SHIFT	8
+#define lpfc_rsrc_desc_pcie_pf_sta_MASK		0x000000ff
+#define lpfc_rsrc_desc_pcie_pf_sta_WORD		word3
+#define lpfc_rsrc_desc_pcie_pf_type_SHIFT	16
+#define lpfc_rsrc_desc_pcie_pf_type_MASK	0x000000ff
+#define lpfc_rsrc_desc_pcie_pf_type_WORD	word3
+	uint32_t word4;
+#define lpfc_rsrc_desc_pcie_nr_virtfn_SHIFT	0
+#define lpfc_rsrc_desc_pcie_nr_virtfn_MASK	0x0000ffff
+#define lpfc_rsrc_desc_pcie_nr_virtfn_WORD	word4
+};
+
+struct lpfc_rsrc_desc_fcfcoe {
+	uint32_t word0;
+#define lpfc_rsrc_desc_fcfcoe_type_SHIFT	0
+#define lpfc_rsrc_desc_fcfcoe_type_MASK		0x000000ff
+#define lpfc_rsrc_desc_fcfcoe_type_WORD		word0
+#define LPFC_RSRC_DESC_TYPE_FCFCOE		0x43
+	uint32_t word1;
+#define lpfc_rsrc_desc_fcfcoe_vfnum_SHIFT	0
+#define lpfc_rsrc_desc_fcfcoe_vfnum_MASK	0x000000ff
+#define lpfc_rsrc_desc_fcfcoe_vfnum_WORD	word1
+#define lpfc_rsrc_desc_fcfcoe_pfnum_SHIFT	16
+#define lpfc_rsrc_desc_fcfcoe_pfnum_MASK        0x000007ff
+#define lpfc_rsrc_desc_fcfcoe_pfnum_WORD        word1
+	uint32_t word2;
+#define lpfc_rsrc_desc_fcfcoe_rpi_cnt_SHIFT	0
+#define lpfc_rsrc_desc_fcfcoe_rpi_cnt_MASK	0x0000ffff
+#define lpfc_rsrc_desc_fcfcoe_rpi_cnt_WORD	word2
+#define lpfc_rsrc_desc_fcfcoe_xri_cnt_SHIFT	16
+#define lpfc_rsrc_desc_fcfcoe_xri_cnt_MASK	0x0000ffff
+#define lpfc_rsrc_desc_fcfcoe_xri_cnt_WORD	word2
+	uint32_t word3;
+#define lpfc_rsrc_desc_fcfcoe_wq_cnt_SHIFT	0
+#define lpfc_rsrc_desc_fcfcoe_wq_cnt_MASK	0x0000ffff
+#define lpfc_rsrc_desc_fcfcoe_wq_cnt_WORD	word3
+#define lpfc_rsrc_desc_fcfcoe_rq_cnt_SHIFT	16
+#define lpfc_rsrc_desc_fcfcoe_rq_cnt_MASK	0x0000ffff
+#define lpfc_rsrc_desc_fcfcoe_rq_cnt_WORD	word3
+	uint32_t word4;
+#define lpfc_rsrc_desc_fcfcoe_cq_cnt_SHIFT	0
+#define lpfc_rsrc_desc_fcfcoe_cq_cnt_MASK	0x0000ffff
+#define lpfc_rsrc_desc_fcfcoe_cq_cnt_WORD	word4
+#define lpfc_rsrc_desc_fcfcoe_vpi_cnt_SHIFT	16
+#define lpfc_rsrc_desc_fcfcoe_vpi_cnt_MASK	0x0000ffff
+#define lpfc_rsrc_desc_fcfcoe_vpi_cnt_WORD	word4
+	uint32_t word5;
+#define lpfc_rsrc_desc_fcfcoe_fcfi_cnt_SHIFT	0
+#define lpfc_rsrc_desc_fcfcoe_fcfi_cnt_MASK	0x0000ffff
+#define lpfc_rsrc_desc_fcfcoe_fcfi_cnt_WORD	word5
+#define lpfc_rsrc_desc_fcfcoe_vfi_cnt_SHIFT	16
+#define lpfc_rsrc_desc_fcfcoe_vfi_cnt_MASK	0x0000ffff
+#define lpfc_rsrc_desc_fcfcoe_vfi_cnt_WORD	word5
+	uint32_t word6;
+	uint32_t word7;
+	uint32_t word8;
+	uint32_t word9;
+	uint32_t word10;
+	uint32_t word11;
+	uint32_t word12;
+	uint32_t word13;
+#define lpfc_rsrc_desc_fcfcoe_lnk_nr_SHIFT	0
+#define lpfc_rsrc_desc_fcfcoe_lnk_nr_MASK	0x0000003f
+#define lpfc_rsrc_desc_fcfcoe_lnk_nr_WORD	word13
+#define lpfc_rsrc_desc_fcfcoe_lnk_tp_SHIFT      6
+#define lpfc_rsrc_desc_fcfcoe_lnk_tp_MASK	0x00000003
+#define lpfc_rsrc_desc_fcfcoe_lnk_tp_WORD	word13
+#define lpfc_rsrc_desc_fcfcoe_lmc_SHIFT		8
+#define lpfc_rsrc_desc_fcfcoe_lmc_MASK		0x00000001
+#define lpfc_rsrc_desc_fcfcoe_lmc_WORD		word13
+#define lpfc_rsrc_desc_fcfcoe_lld_SHIFT		9
+#define lpfc_rsrc_desc_fcfcoe_lld_MASK		0x00000001
+#define lpfc_rsrc_desc_fcfcoe_lld_WORD		word13
+#define lpfc_rsrc_desc_fcfcoe_eq_cnt_SHIFT	16
+#define lpfc_rsrc_desc_fcfcoe_eq_cnt_MASK	0x0000ffff
+#define lpfc_rsrc_desc_fcfcoe_eq_cnt_WORD	word13
+};
+
+struct lpfc_func_cfg {
+#define LPFC_RSRC_DESC_MAX_NUM			2
+	uint32_t rsrc_desc_count;
+	struct lpfc_rscr_desc_generic desc[LPFC_RSRC_DESC_MAX_NUM];
+};
+
+struct lpfc_mbx_get_func_cfg {
+	struct mbox_header header;
+#define LPFC_CFG_TYPE_PERSISTENT_OVERRIDE	0x0
+#define LPFC_CFG_TYPE_FACTURY_DEFAULT		0x1
+#define LPFC_CFG_TYPE_CURRENT_ACTIVE		0x2
+	struct lpfc_func_cfg func_cfg;
+};
+
+struct lpfc_prof_cfg {
+#define LPFC_RSRC_DESC_MAX_NUM			2
+	uint32_t rsrc_desc_count;
+	struct lpfc_rscr_desc_generic desc[LPFC_RSRC_DESC_MAX_NUM];
+};
+
+struct lpfc_mbx_get_prof_cfg {
+	struct mbox_header header;
+#define LPFC_CFG_TYPE_PERSISTENT_OVERRIDE	0x0
+#define LPFC_CFG_TYPE_FACTURY_DEFAULT		0x1
+#define LPFC_CFG_TYPE_CURRENT_ACTIVE		0x2
+	union {
+		struct {
+			uint32_t word10;
+#define lpfc_mbx_get_prof_cfg_prof_id_SHIFT	0
+#define lpfc_mbx_get_prof_cfg_prof_id_MASK	0x000000ff
+#define lpfc_mbx_get_prof_cfg_prof_id_WORD	word10
+#define lpfc_mbx_get_prof_cfg_prof_tp_SHIFT	8
+#define lpfc_mbx_get_prof_cfg_prof_tp_MASK	0x00000003
+#define lpfc_mbx_get_prof_cfg_prof_tp_WORD	word10
+		} request;
+		struct {
+			struct lpfc_prof_cfg prof_cfg;
+		} response;
+	} u;
+};
+
 /* Mailbox Completion Queue Error Messages */
 #define MB_CQE_STATUS_SUCCESS 			0x0
 #define MB_CQE_STATUS_INSUFFICIENT_PRIVILEGES	0x1
@@ -2271,6 +2418,8 @@ struct lpfc_mqe {
 		struct lpfc_mbx_supp_pages supp_pages;
 		struct lpfc_mbx_pc_sli4_params sli4_params;
 		struct lpfc_mbx_get_sli4_parameters get_sli4_parameters;
+		struct lpfc_mbx_get_func_cfg get_func_cfg;
+		struct lpfc_mbx_get_prof_cfg get_prof_cfg;
 		struct lpfc_mbx_nop nop;
 	} un;
 };
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2011-05-23 16:58:34.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2011-05-23 17:01:19.000000000 -0400
@@ -903,6 +903,8 @@ struct RRQ {			/* Structure is in Big En
 #define rrq_rxid_WORD		rrq_exchg
 };
 
+#define LPFC_MAX_VFN_PER_PFN	255 /* Maximum VFs allowed per ARI */
+#define LPFC_DEF_VFN_PER_PFN	0   /* Default VFs due to platform limitation*/
 
 struct RTV_RSP {		/* Structure is in Big Endian format */
 	uint32_t ratov;
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2011-05-23 16:58:34.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2011-05-23 17:01:19.000000000 -0400
@@ -4034,6 +4034,36 @@ lpfc_reset_hba(struct lpfc_hba *phba)
 }
 
 /**
+ * lpfc_sli_probe_sriov_nr_virtfn - Enable a number of sr-iov virtual functions
+ * @phba: pointer to lpfc hba data structure.
+ * @nr_vfn: number of virtual functions to be enabled.
+ *
+ * This function enables the PCI SR-IOV virtual functions to a physical
+ * function. It invokes the PCI SR-IOV api with the @nr_vfn provided to
+ * enable the number of virtual functions to the physical function. As
+ * not all devices support SR-IOV, the return code from the pci_enable_sriov()
+ * API call does not considered as an error condition for most of the device.
+ **/
+int
+lpfc_sli_probe_sriov_nr_virtfn(struct lpfc_hba *phba, int nr_vfn)
+{
+	struct pci_dev *pdev = phba->pcidev;
+	int rc;
+
+	rc = pci_enable_sriov(pdev, nr_vfn);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"2806 Failed to enable sriov on this device "
+				"with vfn number nr_vf:%d, rc:%d\n",
+				nr_vfn, rc);
+	} else
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"2807 Successful enable sriov on this device "
+				"with vfn number nr_vf:%d\n", nr_vfn);
+	return rc;
+}
+
+/**
  * lpfc_sli_driver_resource_setup - Setup driver internal resources for SLI3 dev.
  * @phba: pointer to lpfc hba data structure.
  *
@@ -4048,6 +4078,7 @@ static int
 lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
 {
 	struct lpfc_sli *psli;
+	int rc;
 
 	/*
 	 * Initialize timers used by driver
@@ -4122,6 +4153,23 @@ lpfc_sli_driver_resource_setup(struct lp
 	if (lpfc_mem_alloc(phba, BPL_ALIGN_SZ))
 		return -ENOMEM;
 
+	/*
+	 * Enable sr-iov virtual functions if supported and configured
+	 * through the module parameter.
+	 */
+	if (phba->cfg_sriov_nr_virtfn > 0) {
+		rc = lpfc_sli_probe_sriov_nr_virtfn(phba,
+						 phba->cfg_sriov_nr_virtfn);
+		if (rc) {
+			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+					"2808 Requested number of SR-IOV "
+					"virtual functions (%d) is not "
+					"supported\n",
+					phba->cfg_sriov_nr_virtfn);
+			phba->cfg_sriov_nr_virtfn = 0;
+		}
+	}
+
 	return 0;
 }
 
@@ -4427,6 +4475,23 @@ lpfc_sli4_driver_resource_setup(struct l
 		goto out_free_fcp_eq_hdl;
 	}
 
+	/*
+	 * Enable sr-iov virtual functions if supported and configured
+	 * through the module parameter.
+	 */
+	if (phba->cfg_sriov_nr_virtfn > 0) {
+		rc = lpfc_sli_probe_sriov_nr_virtfn(phba,
+						 phba->cfg_sriov_nr_virtfn);
+		if (rc) {
+			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+					"3020 Requested number of SR-IOV "
+					"virtual functions (%d) is not "
+					"supported\n",
+					phba->cfg_sriov_nr_virtfn);
+			phba->cfg_sriov_nr_virtfn = 0;
+		}
+	}
+
 	return rc;
 
 out_free_fcp_eq_hdl:
@@ -5780,7 +5845,12 @@ lpfc_sli4_read_config(struct lpfc_hba *p
 {
 	LPFC_MBOXQ_t *pmb;
 	struct lpfc_mbx_read_config *rd_config;
-	uint32_t rc = 0;
+	union  lpfc_sli4_cfg_shdr *shdr;
+	uint32_t shdr_status, shdr_add_status;
+	struct lpfc_mbx_get_func_cfg *get_func_cfg;
+	struct lpfc_rsrc_desc_fcfcoe *desc;
+	uint32_t desc_count;
+	int length, i, rc = 0;
 
 	pmb = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!pmb) {
@@ -5855,7 +5925,9 @@ lpfc_sli4_read_config(struct lpfc_hba *p
 				phba->sli4_hba.max_cfg_param.fcfi_base,
 				phba->sli4_hba.max_cfg_param.max_fcfi);
 	}
-	mempool_free(pmb, phba->mbox_mem_pool);
+
+	if (rc)
+		goto read_cfg_out;
 
 	/* Reset the DFT_HBA_Q_DEPTH to the max xri  */
 	if (phba->cfg_hba_queue_depth >
@@ -5864,6 +5936,65 @@ lpfc_sli4_read_config(struct lpfc_hba *p
 		phba->cfg_hba_queue_depth =
 			phba->sli4_hba.max_cfg_param.max_xri -
 				lpfc_sli4_get_els_iocb_cnt(phba);
+
+	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) !=
+	    LPFC_SLI_INTF_IF_TYPE_2)
+		goto read_cfg_out;
+
+	/* get the pf# and vf# for SLI4 if_type 2 port */
+	length = (sizeof(struct lpfc_mbx_get_func_cfg) -
+		  sizeof(struct lpfc_sli4_cfg_mhdr));
+	lpfc_sli4_config(phba, pmb, LPFC_MBOX_SUBSYSTEM_COMMON,
+			 LPFC_MBOX_OPCODE_GET_FUNCTION_CONFIG,
+			 length, LPFC_SLI4_MBX_EMBED);
+
+	rc = lpfc_sli_issue_mbox(phba, pmb, MBX_POLL);
+	shdr = (union lpfc_sli4_cfg_shdr *)
+				&pmb->u.mqe.un.sli4_config.header.cfg_shdr;
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
+	if (rc || shdr_status || shdr_add_status) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"3026 Mailbox failed , mbxCmd x%x "
+				"GET_FUNCTION_CONFIG, mbxStatus x%x\n",
+				bf_get(lpfc_mqe_command, &pmb->u.mqe),
+				bf_get(lpfc_mqe_status, &pmb->u.mqe));
+		rc = -EIO;
+		goto read_cfg_out;
+	}
+
+	/* search for fc_fcoe resrouce descriptor */
+	get_func_cfg = &pmb->u.mqe.un.get_func_cfg;
+	desc_count = get_func_cfg->func_cfg.rsrc_desc_count;
+
+	for (i = 0; i < LPFC_RSRC_DESC_MAX_NUM; i++) {
+		desc = (struct lpfc_rsrc_desc_fcfcoe *)
+			&get_func_cfg->func_cfg.desc[i];
+		if (LPFC_RSRC_DESC_TYPE_FCFCOE ==
+		    bf_get(lpfc_rsrc_desc_pcie_type, desc)) {
+			phba->sli4_hba.iov.pf_number =
+				bf_get(lpfc_rsrc_desc_fcfcoe_pfnum, desc);
+			phba->sli4_hba.iov.vf_number =
+				bf_get(lpfc_rsrc_desc_fcfcoe_vfnum, desc);
+			break;
+		}
+	}
+
+	if (i < LPFC_RSRC_DESC_MAX_NUM)
+		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+				"3027 GET_FUNCTION_CONFIG: pf_number:%d, "
+				"vf_number:%d\n", phba->sli4_hba.iov.pf_number,
+				phba->sli4_hba.iov.vf_number);
+	else {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"3028 GET_FUNCTION_CONFIG: failed to find "
+				"Resrouce Descriptor:x%x\n",
+				LPFC_RSRC_DESC_TYPE_FCFCOE);
+		rc = -EIO;
+	}
+
+read_cfg_out:
+	mempool_free(pmb, phba->mbox_mem_pool);
 	return rc;
 }
 
@@ -7825,6 +7956,7 @@ lpfc_sli4_hba_unset(struct lpfc_hba *phb
 {
 	int wait_cnt = 0;
 	LPFC_MBOXQ_t *mboxq;
+	struct pci_dev *pdev = phba->pcidev;
 
 	lpfc_stop_hba_timers(phba);
 	phba->sli4_hba.intr_enable = 0;
@@ -7864,6 +7996,10 @@ lpfc_sli4_hba_unset(struct lpfc_hba *phb
 	/* Disable PCI subsystem interrupt */
 	lpfc_sli4_disable_intr(phba);
 
+	/* Disable SR-IOV if enabled */
+	if (phba->cfg_sriov_nr_virtfn)
+		pci_disable_sriov(pdev);
+
 	/* Stop kthread signal shall trigger work_done one more time */
 	kthread_stop(phba->worker_thread);
 
@@ -8243,6 +8379,10 @@ lpfc_pci_remove_one_s3(struct pci_dev *p
 
 	lpfc_debugfs_terminate(vport);
 
+	/* Disable SR-IOV if enabled */
+	if (phba->cfg_sriov_nr_virtfn)
+		pci_disable_sriov(pdev);
+
 	/* Disable interrupt */
 	lpfc_sli_disable_intr(phba);
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2011-03-27 11:03:17.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2011-05-23 17:01:19.000000000 -0400
@@ -365,6 +365,11 @@ struct lpfc_pc_sli4_params {
 	uint8_t rqv;
 };
 
+struct lpfc_iov {
+	uint32_t pf_number;
+	uint32_t vf_number;
+};
+
 /* SLI4 HBA data structure entries */
 struct lpfc_sli4_hba {
 	void __iomem *conf_regs_memmap_p; /* Kernel memory mapped address for
@@ -467,6 +472,7 @@ struct lpfc_sli4_hba {
 	struct list_head sp_els_xri_aborted_work_queue;
 	struct list_head sp_unsol_work_queue;
 	struct lpfc_sli4_link link_state;
+	struct lpfc_iov iov;
 	spinlock_t abts_scsi_buf_list_lock; /* list of aborted SCSI IOs */
 	spinlock_t abts_sgl_list_lock; /* list of aborted els IOs */
 };


