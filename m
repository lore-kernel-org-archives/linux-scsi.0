From: James Smart <James.Smart@Emulex.Com>
Subject: [Patch 1/5] lpfc 8.3.3 : Fix various SLI-3 vs SLI-4 differences
Date: Wed, 10 Jun 2009 17:22:44 -0400
Message-ID: <1244668965.9571.15.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:37899 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757600AbZFJVWq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2009 17:22:46 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n5ALMmnc001346
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2009 14:22:48 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Fix various SLI-3 vs SLI-4 differences

Contains the following changes
- Set the CT field of FDISC to 3
- Fixed over allocation of SCSI buffers on SLI4
- Removed unused jump table entries
- Increase LPFC_WQE_DEF_COUNT to 256
- Updated FDISC context to VPI
- Fixed immediate SCSI command for LUN reset translation to WQE
- Extended mailbox handling to allow MBX_POLL commands in between async
  MBQ commands
- Fixed SID used for FDISC
- Fix crash when accessing ctlregs from sysfs for SLI4 HBAs
- Fix SLI4 firmware version not being saved or displayed correctly
- Expand CQID field in WQE structure to 16 bits
- Fix post header template mailbox command timing out
- Removed FCoE PCI device ID 0x0705

Signed-off-by: James Smart <James.Smart@emulex.com>
---

 drivers/scsi/lpfc/lpfc.h      |    4 -
 drivers/scsi/lpfc/lpfc_attr.c |    6 +
 drivers/scsi/lpfc/lpfc_ct.c   |    4 +
 drivers/scsi/lpfc/lpfc_els.c  |   14 ++-
 drivers/scsi/lpfc/lpfc_hw.h   |    1 
 drivers/scsi/lpfc/lpfc_hw4.h  |    4 -
 drivers/scsi/lpfc/lpfc_init.c |   33 +++----
 drivers/scsi/lpfc/lpfc_scsi.c |  177 +++++++------------------------------
 drivers/scsi/lpfc/lpfc_sli.c  |  198 +++++++++++++++++++++++++++++++----------
 drivers/scsi/lpfc/lpfc_sli4.h |    2 
 10 files changed, 224 insertions(+), 219 deletions(-)

--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -457,10 +457,6 @@ struct lpfc_hba {
 	void (*lpfc_scsi_prep_cmnd)
 		(struct lpfc_vport *, struct lpfc_scsi_buf *,
 		 struct lpfc_nodelist *);
-	int (*lpfc_scsi_prep_task_mgmt_cmd)
-		(struct lpfc_vport *, struct lpfc_scsi_buf *,
-		 unsigned int, uint8_t);
-
 	/* IOCB interface function jump table entries */
 	int (*__lpfc_sli_issue_iocb)
 		(struct lpfc_hba *, uint32_t,
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3113,6 +3113,9 @@ sysfs_ctlreg_write(struct kobject *kobj, struct bin_attribute *bin_attr,
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
+	if (phba->sli_rev >= LPFC_SLI_REV4)
+		return -EPERM;
+
 	if ((off + count) > FF_REG_AREA_SIZE)
 		return -ERANGE;
 
@@ -3163,6 +3166,9 @@ sysfs_ctlreg_read(struct kobject *kobj, struct bin_attribute *bin_attr,
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
+	if (phba->sli_rev >= LPFC_SLI_REV4)
+		return -EPERM;
+
 	if (off > FF_REG_AREA_SIZE)
 		return -ERANGE;
 
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1732,7 +1732,9 @@ lpfc_decode_firmware_rev(struct lpfc_hba *phba, char *fwrevision, int flag)
 	uint32_t *ptr, str[4];
 	uint8_t *fwname;
 
-	if (vp->rev.rBit) {
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		sprintf(fwrevision, "%s", vp->rev.opFwName);
+	else if (vp->rev.rBit) {
 		if (psli->sli_flag & LPFC_SLI_ACTIVE)
 			rev = vp->rev.sli2FwRev;
 		else
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -6108,9 +6108,17 @@ lpfc_issue_els_fdisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	icmd->un.elsreq64.myID = 0;
 	icmd->un.elsreq64.fl = 1;
 
-	/* For FDISC, Let FDISC rsp set the NPortID for this VPI */
-	icmd->ulpCt_h = 1;
-	icmd->ulpCt_l = 0;
+	if  (phba->sli_rev == LPFC_SLI_REV4) {
+		/* FDISC needs to be 1 for WQE VPI */
+		elsiocb->iocb.ulpCt_h = (SLI4_CT_VPI >> 1) & 1;
+		elsiocb->iocb.ulpCt_l = SLI4_CT_VPI & 1 ;
+		/* Set the ulpContext to the vpi */
+		elsiocb->iocb.ulpContext = vport->vpi + phba->vpi_base;
+	} else {
+		/* For FDISC, Let FDISC rsp set the NPortID for this VPI */
+		icmd->ulpCt_h = 1;
+		icmd->ulpCt_l = 0;
+	}
 
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
 	*((uint32_t *) (pcmd)) = ELS_CMD_FDISC;
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1183,7 +1183,6 @@ typedef struct {
 #define PCI_DEVICE_ID_ZEPHYR_DCSP   0xfe12
 #define PCI_VENDOR_ID_SERVERENGINE  0x19a2
 #define PCI_DEVICE_ID_TIGERSHARK    0x0704
-#define PCI_DEVICE_ID_TIGERSHARK_S  0x0705
 
 #define JEDEC_ID_ADDRESS            0x0080001c
 #define FIREFLY_JEDEC_ID            0x1ACC
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -422,9 +422,9 @@ struct lpfc_wqe_generic{
 #define lpfc_wqe_gen_pri_WORD		word10
 	uint32_t word11;
 #define lpfc_wqe_gen_cq_id_SHIFT	16
-#define lpfc_wqe_gen_cq_id_MASK		0x000003FF
+#define lpfc_wqe_gen_cq_id_MASK		0x0000FFFF
 #define lpfc_wqe_gen_cq_id_WORD		word11
-#define LPFC_WQE_CQ_ID_DEFAULT	0x3ff
+#define LPFC_WQE_CQ_ID_DEFAULT	0xffff
 #define lpfc_wqe_gen_wqec_SHIFT		7
 #define lpfc_wqe_gen_wqec_MASK		0x00000001
 #define lpfc_wqe_gen_wqec_WORD		word11
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -428,7 +428,8 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 	/* Reset the DFT_HBA_Q_DEPTH to the max xri  */
 	if (phba->cfg_hba_queue_depth > (mb->un.varRdConfig.max_xri+1))
 		phba->cfg_hba_queue_depth =
-			mb->un.varRdConfig.max_xri + 1;
+			(mb->un.varRdConfig.max_xri + 1) -
+					lpfc_sli4_get_els_iocb_cnt(phba);
 
 	phba->lmt = mb->un.varRdConfig.lmt;
 
@@ -1646,10 +1647,6 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
 		oneConnect = 1;
 		m = (typeof(m)) {"OCe10100-F", max_speed, "PCIe"};
 		break;
-	case PCI_DEVICE_ID_TIGERSHARK_S:
-		oneConnect = 1;
-		m = (typeof(m)) {"OCe10100-F-S", max_speed, "PCIe"};
-		break;
 	default:
 		m = (typeof(m)){ NULL };
 		break;
@@ -7184,16 +7181,19 @@ lpfc_sli4_get_els_iocb_cnt(struct lpfc_hba *phba)
 {
 	int max_xri = phba->sli4_hba.max_cfg_param.max_xri;
 
-	if (max_xri <= 100)
-		return 4;
-	else if (max_xri <= 256)
-		return 8;
-	else if (max_xri <= 512)
-		return 16;
-	else if (max_xri <= 1024)
-		return 32;
-	else
-		return 48;
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		if (max_xri <= 100)
+			return 4;
+		else if (max_xri <= 256)
+			return 8;
+		else if (max_xri <= 512)
+			return 16;
+		else if (max_xri <= 1024)
+			return 32;
+		else
+			return 48;
+	} else
+		return 0;
 }
 
 /**
@@ -7642,7 +7642,6 @@ lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
 
 	switch (dev_id) {
 	case PCI_DEVICE_ID_TIGERSHARK:
-	case PCI_DEVICE_ID_TIGERSHARK_S:
 		rc = lpfc_pci_probe_one_s4(pdev, pid);
 		break;
 	default:
@@ -7941,8 +7940,6 @@ static struct pci_device_id lpfc_id_table[] = {
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_SERVERENGINE, PCI_DEVICE_ID_TIGERSHARK,
 		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_SERVERENGINE, PCI_DEVICE_ID_TIGERSHARK_S,
-		PCI_ANY_ID, PCI_ANY_ID, },
 	{ 0 }
 };
 
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -116,6 +116,27 @@ lpfc_debug_save_dif(struct scsi_cmnd *cmnd)
 }
 
 /**
+ * lpfc_sli4_set_rsp_sgl_last - Set the last bit in the response sge.
+ * @phba: Pointer to HBA object.
+ * @lpfc_cmd: lpfc scsi command object pointer.
+ *
+ * This function is called from the lpfc_prep_task_mgmt_cmd function to
+ * set the last bit in the response sge entry.
+ **/
+static void
+lpfc_sli4_set_rsp_sgl_last(struct lpfc_hba *phba,
+				struct lpfc_scsi_buf *lpfc_cmd)
+{
+	struct sli4_sge *sgl = (struct sli4_sge *)lpfc_cmd->fcp_bpl;
+	if (sgl) {
+		sgl += 1;
+		sgl->word2 = le32_to_cpu(sgl->word2);
+		bf_set(lpfc_sli4_sge_last, sgl, 1);
+		sgl->word2 = cpu_to_le32(sgl->word2);
+	}
+}
+
+/**
  * lpfc_update_stats - Update statistical data for the command completion
  * @phba: Pointer to HBA object.
  * @lpfc_cmd: lpfc scsi command object pointer.
@@ -1978,7 +1999,7 @@ lpfc_send_scsi_error_event(struct lpfc_hba *phba, struct lpfc_vport *vport,
 }
 
 /**
- * lpfc_scsi_unprep_dma_buf_s3 - Un-map DMA mapping of SG-list for SLI3 dev
+ * lpfc_scsi_unprep_dma_buf - Un-map DMA mapping of SG-list for dev
  * @phba: The HBA for which this call is being executed.
  * @psb: The scsi buffer which is going to be un-mapped.
  *
@@ -1986,7 +2007,7 @@ lpfc_send_scsi_error_event(struct lpfc_hba *phba, struct lpfc_vport *vport,
  * field of @lpfc_cmd for device with SLI-3 interface spec.
  **/
 static void
-lpfc_scsi_unprep_dma_buf_s3(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
+lpfc_scsi_unprep_dma_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
 {
 	/*
 	 * There are only two special cases to consider.  (1) the scsi command
@@ -2003,36 +2024,6 @@ lpfc_scsi_unprep_dma_buf_s3(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
 }
 
 /**
- * lpfc_scsi_unprep_dma_buf_s4 - Un-map DMA mapping of SG-list for SLI4 dev
- * @phba: The Hba for which this call is being executed.
- * @psb: The scsi buffer which is going to be un-mapped.
- *
- * This routine does DMA un-mapping of scatter gather list of scsi command
- * field of @lpfc_cmd for device with SLI-4 interface spec. If we have to
- * remove the sgl for this scsi buffer then we will do it here. For now
- * we should be able to just call the sli3 unprep routine.
- **/
-static void
-lpfc_scsi_unprep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
-{
-	lpfc_scsi_unprep_dma_buf_s3(phba, psb);
-}
-
-/**
- * lpfc_scsi_unprep_dma_buf - Wrapper function for unmap DMA mapping of SG-list
- * @phba: The Hba for which this call is being executed.
- * @psb: The scsi buffer which is going to be un-mapped.
- *
- * This routine does DMA un-mapping of scatter gather list of scsi command
- * field of @lpfc_cmd for device with SLI-4 interface spec.
- **/
-static void
-lpfc_scsi_unprep_dma_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
-{
-	phba->lpfc_scsi_unprep_dma_buf(phba, psb);
-}
-
-/**
  * lpfc_handler_fcp_err - FCP response handler
  * @vport: The virtual port for which this call is being executed.
  * @lpfc_cmd: Pointer to lpfc_scsi_buf data structure.
@@ -2461,7 +2452,7 @@ lpfc_fcpcmd_to_iocb(uint8_t *data, struct fcp_cmnd *fcp_cmnd)
 }
 
 /**
- * lpfc_scsi_prep_cmnd_s3 - Convert scsi cmnd to FCP infor unit for SLI3 dev
+ * lpfc_scsi_prep_cmnd - Wrapper func for convert scsi cmnd to FCP info unit
  * @vport: The virtual port for which this call is being executed.
  * @lpfc_cmd: The scsi command which needs to send.
  * @pnode: Pointer to lpfc_nodelist.
@@ -2470,7 +2461,7 @@ lpfc_fcpcmd_to_iocb(uint8_t *data, struct fcp_cmnd *fcp_cmnd)
  * to transfer for device with SLI3 interface spec.
  **/
 static void
-lpfc_scsi_prep_cmnd_s3(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
+lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 		    struct lpfc_nodelist *pnode)
 {
 	struct lpfc_hba *phba = vport->phba;
@@ -2558,46 +2549,7 @@ lpfc_scsi_prep_cmnd_s3(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 }
 
 /**
- * lpfc_scsi_prep_cmnd_s4 - Convert scsi cmnd to FCP infor unit for SLI4 dev
- * @vport: The virtual port for which this call is being executed.
- * @lpfc_cmd: The scsi command which needs to send.
- * @pnode: Pointer to lpfc_nodelist.
- *
- * This routine initializes fcp_cmnd and iocb data structure from scsi command
- * to transfer for device with SLI4 interface spec.
- **/
-static void
-lpfc_scsi_prep_cmnd_s4(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
-		       struct lpfc_nodelist *pnode)
-{
-	/*
-	 * The prep cmnd routines do not touch the sgl or its
-	 * entries. We may not have to do anything different.
-	 * I will leave this function in place until we can
-	 * run some IO through the driver and determine if changes
-	 * are needed.
-	 */
-	return lpfc_scsi_prep_cmnd_s3(vport, lpfc_cmd, pnode);
-}
-
-/**
- * lpfc_scsi_prep_cmnd - Wrapper func for convert scsi cmnd to FCP info unit
- * @vport: The virtual port for which this call is being executed.
- * @lpfc_cmd: The scsi command which needs to send.
- * @pnode: Pointer to lpfc_nodelist.
- *
- * This routine wraps the actual convert SCSI cmnd function pointer from
- * the lpfc_hba struct.
- **/
-static inline void
-lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
-		    struct lpfc_nodelist *pnode)
-{
-	vport->phba->lpfc_scsi_prep_cmnd(vport, lpfc_cmd, pnode);
-}
-
-/**
- * lpfc_scsi_prep_task_mgmt_cmnd_s3 - Convert SLI3 scsi TM cmd to FCP info unit
+ * lpfc_scsi_prep_task_mgmt_cmnd - Convert SLI3 scsi TM cmd to FCP info unit
  * @vport: The virtual port for which this call is being executed.
  * @lpfc_cmd: Pointer to lpfc_scsi_buf data structure.
  * @lun: Logical unit number.
@@ -2611,7 +2563,7 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
  *   1 - Success
  **/
 static int
-lpfc_scsi_prep_task_mgmt_cmd_s3(struct lpfc_vport *vport,
+lpfc_scsi_prep_task_mgmt_cmd(struct lpfc_vport *vport,
 			     struct lpfc_scsi_buf *lpfc_cmd,
 			     unsigned int lun,
 			     uint8_t task_mgmt_cmd)
@@ -2653,68 +2605,13 @@ lpfc_scsi_prep_task_mgmt_cmd_s3(struct lpfc_vport *vport,
 		 * The driver will provide the timeout mechanism.
 		 */
 		piocb->ulpTimeout = 0;
-	} else {
+	} else
 		piocb->ulpTimeout = lpfc_cmd->timeout;
-	}
-
-	return 1;
-}
-
-/**
- * lpfc_scsi_prep_task_mgmt_cmnd_s4 - Convert SLI4 scsi TM cmd to FCP info unit
- * @vport: The virtual port for which this call is being executed.
- * @lpfc_cmd: Pointer to lpfc_scsi_buf data structure.
- * @lun: Logical unit number.
- * @task_mgmt_cmd: SCSI task management command.
- *
- * This routine creates FCP information unit corresponding to @task_mgmt_cmd
- * for device with SLI-4 interface spec.
- *
- * Return codes:
- * 	0 - Error
- * 	1 - Success
- **/
-static int
-lpfc_scsi_prep_task_mgmt_cmd_s4(struct lpfc_vport *vport,
-				struct lpfc_scsi_buf *lpfc_cmd,
-				unsigned int lun,
-				uint8_t task_mgmt_cmd)
-{
-	/*
-	 * The prep cmnd routines do not touch the sgl or its
-	 * entries. We may not have to do anything different.
-	 * I will leave this function in place until we can
-	 * run some IO through the driver and determine if changes
-	 * are needed.
-	 */
-	return lpfc_scsi_prep_task_mgmt_cmd_s3(vport, lpfc_cmd, lun,
-						task_mgmt_cmd);
-}
 
-/**
- * lpfc_scsi_prep_task_mgmt_cmnd - Wrapper func convert scsi TM cmd to FCP info
- * @vport: The virtual port for which this call is being executed.
- * @lpfc_cmd: Pointer to lpfc_scsi_buf data structure.
- * @lun: Logical unit number.
- * @task_mgmt_cmd: SCSI task management command.
- *
- * This routine wraps the actual convert SCSI TM to FCP information unit
- * function pointer from the lpfc_hba struct.
- *
- * Return codes:
- * 	0 - Error
- * 	1 - Success
- **/
-static inline int
-lpfc_scsi_prep_task_mgmt_cmd(struct lpfc_vport *vport,
-			     struct lpfc_scsi_buf *lpfc_cmd,
-			     unsigned int lun,
-			     uint8_t task_mgmt_cmd)
-{
-	struct lpfc_hba *phba = vport->phba;
+	if (vport->phba->sli_rev == LPFC_SLI_REV4)
+		lpfc_sli4_set_rsp_sgl_last(vport->phba, lpfc_cmd);
 
-	return phba->lpfc_scsi_prep_task_mgmt_cmd(vport, lpfc_cmd, lun,
-						  task_mgmt_cmd);
+	return 1;
 }
 
 /**
@@ -2730,23 +2627,19 @@ int
 lpfc_scsi_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
 {
 
+	phba->lpfc_scsi_unprep_dma_buf = lpfc_scsi_unprep_dma_buf;
+	phba->lpfc_scsi_prep_cmnd = lpfc_scsi_prep_cmnd;
+	phba->lpfc_get_scsi_buf = lpfc_get_scsi_buf;
+
 	switch (dev_grp) {
 	case LPFC_PCI_DEV_LP:
 		phba->lpfc_new_scsi_buf = lpfc_new_scsi_buf_s3;
 		phba->lpfc_scsi_prep_dma_buf = lpfc_scsi_prep_dma_buf_s3;
-		phba->lpfc_scsi_prep_cmnd = lpfc_scsi_prep_cmnd_s3;
-		phba->lpfc_scsi_unprep_dma_buf = lpfc_scsi_unprep_dma_buf_s3;
-		phba->lpfc_scsi_prep_task_mgmt_cmd =
-					lpfc_scsi_prep_task_mgmt_cmd_s3;
 		phba->lpfc_release_scsi_buf = lpfc_release_scsi_buf_s3;
 		break;
 	case LPFC_PCI_DEV_OC:
 		phba->lpfc_new_scsi_buf = lpfc_new_scsi_buf_s4;
 		phba->lpfc_scsi_prep_dma_buf = lpfc_scsi_prep_dma_buf_s4;
-		phba->lpfc_scsi_prep_cmnd = lpfc_scsi_prep_cmnd_s4;
-		phba->lpfc_scsi_unprep_dma_buf = lpfc_scsi_unprep_dma_buf_s4;
-		phba->lpfc_scsi_prep_task_mgmt_cmd =
-					lpfc_scsi_prep_task_mgmt_cmd_s4;
 		phba->lpfc_release_scsi_buf = lpfc_release_scsi_buf_s4;
 		break;
 	default:
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4211,27 +4211,6 @@ lpfc_sli4_read_rev(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
 		return -EIO;
 	}
 
-	lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
-			"(%d):0380 Mailbox cmd x%x Status x%x "
-			"Data: x%x x%x x%x x%x x%x x%x x%x x%x x%x "
-			"x%x x%x x%x x%x x%x x%x x%x x%x x%x "
-			"CQ: x%x x%x x%x x%x\n",
-			mboxq->vport ? mboxq->vport->vpi : 0,
-			bf_get(lpfc_mqe_command, mqe),
-			bf_get(lpfc_mqe_status, mqe),
-			mqe->un.mb_words[0], mqe->un.mb_words[1],
-			mqe->un.mb_words[2], mqe->un.mb_words[3],
-			mqe->un.mb_words[4], mqe->un.mb_words[5],
-			mqe->un.mb_words[6], mqe->un.mb_words[7],
-			mqe->un.mb_words[8], mqe->un.mb_words[9],
-			mqe->un.mb_words[10], mqe->un.mb_words[11],
-			mqe->un.mb_words[12], mqe->un.mb_words[13],
-			mqe->un.mb_words[14], mqe->un.mb_words[15],
-			mqe->un.mb_words[16], mqe->un.mb_words[50],
-			mboxq->mcqe.word0,
-			mboxq->mcqe.mcqe_tag0, 	mboxq->mcqe.mcqe_tag1,
-			mboxq->mcqe.trailer);
-
 	/*
 	 * The available vpd length cannot be bigger than the
 	 * DMA buffer passed to the port.  Catch the less than
@@ -4337,21 +4316,18 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 		goto out_free_vpd;
 
 	mqe = &mboxq->u.mqe;
-	if ((bf_get(lpfc_mbx_rd_rev_sli_lvl,
-		    &mqe->un.read_rev) != LPFC_SLI_REV4) ||
-	    (bf_get(lpfc_mbx_rd_rev_fcoe, &mqe->un.read_rev) == 0)) {
+	phba->sli_rev = bf_get(lpfc_mbx_rd_rev_sli_lvl, &mqe->un.read_rev);
+	if (bf_get(lpfc_mbx_rd_rev_fcoe, &mqe->un.read_rev))
+		phba->hba_flag |= HBA_FCOE_SUPPORT;
+	if (phba->sli_rev != LPFC_SLI_REV4 ||
+	    !(phba->hba_flag & HBA_FCOE_SUPPORT)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
 			"0376 READ_REV Error. SLI Level %d "
 			"FCoE enabled %d\n",
-			bf_get(lpfc_mbx_rd_rev_sli_lvl, &mqe->un.read_rev),
-			bf_get(lpfc_mbx_rd_rev_fcoe, &mqe->un.read_rev));
+			phba->sli_rev, phba->hba_flag & HBA_FCOE_SUPPORT);
 		rc = -EIO;
 		goto out_free_vpd;
 	}
-	/* Single threaded at this point, no need for lock */
-	spin_lock_irq(&phba->hbalock);
-	phba->hba_flag |= HBA_FCOE_SUPPORT;
-	spin_unlock_irq(&phba->hbalock);
 	/*
 	 * Evaluate the read rev and vpd data. Populate the driver
 	 * state with the results. If this routine fails, the failure
@@ -4365,8 +4341,32 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 		rc = 0;
 	}
 
-	/* By now, we should determine the SLI revision, hard code for now */
-	phba->sli_rev = LPFC_SLI_REV4;
+	/* Save information as VPD data */
+	phba->vpd.rev.biuRev = mqe->un.read_rev.first_hw_rev;
+	phba->vpd.rev.smRev = mqe->un.read_rev.second_hw_rev;
+	phba->vpd.rev.endecRev = mqe->un.read_rev.third_hw_rev;
+	phba->vpd.rev.fcphHigh = bf_get(lpfc_mbx_rd_rev_fcph_high,
+					 &mqe->un.read_rev);
+	phba->vpd.rev.fcphLow = bf_get(lpfc_mbx_rd_rev_fcph_low,
+				       &mqe->un.read_rev);
+	phba->vpd.rev.feaLevelHigh = bf_get(lpfc_mbx_rd_rev_ftr_lvl_high,
+					    &mqe->un.read_rev);
+	phba->vpd.rev.feaLevelLow = bf_get(lpfc_mbx_rd_rev_ftr_lvl_low,
+					   &mqe->un.read_rev);
+	phba->vpd.rev.sli1FwRev = mqe->un.read_rev.fw_id_rev;
+	memcpy(phba->vpd.rev.sli1FwName, mqe->un.read_rev.fw_name, 16);
+	phba->vpd.rev.sli2FwRev = mqe->un.read_rev.ulp_fw_id_rev;
+	memcpy(phba->vpd.rev.sli2FwName, mqe->un.read_rev.ulp_fw_name, 16);
+	phba->vpd.rev.opFwRev = mqe->un.read_rev.fw_id_rev;
+	memcpy(phba->vpd.rev.opFwName, mqe->un.read_rev.fw_name, 16);
+	lpfc_printf_log(phba, KERN_INFO, LOG_MBOX | LOG_SLI,
+			"(%d):0380 READ_REV Status x%x "
+			"fw_rev:%s fcphHi:%x fcphLo:%x flHi:%x flLo:%x\n",
+			mboxq->vport ? mboxq->vport->vpi : 0,
+			bf_get(lpfc_mqe_status, mqe),
+			phba->vpd.rev.opFwName,
+			phba->vpd.rev.fcphHigh, phba->vpd.rev.fcphLow,
+			phba->vpd.rev.feaLevelHigh, phba->vpd.rev.feaLevelLow);
 
 	/*
 	 * Discover the port's supported feature set and match it against the
@@ -5030,6 +5030,92 @@ out_not_finished:
 }
 
 /**
+ * lpfc_sli4_async_mbox_block - Block posting SLI4 asynchronous mailbox command
+ * @phba: Pointer to HBA context object.
+ *
+ * The function blocks the posting of SLI4 asynchronous mailbox commands from
+ * the driver internal pending mailbox queue. It will then try to wait out the
+ * possible outstanding mailbox command before return.
+ *
+ * Returns:
+ * 	0 - the outstanding mailbox command completed; otherwise, the wait for
+ * 	the outstanding mailbox command timed out.
+ **/
+static int
+lpfc_sli4_async_mbox_block(struct lpfc_hba *phba)
+{
+	struct lpfc_sli *psli = &phba->sli;
+	uint8_t actcmd = MBX_HEARTBEAT;
+	int rc = 0;
+	unsigned long timeout;
+
+	/* Mark the asynchronous mailbox command posting as blocked */
+	spin_lock_irq(&phba->hbalock);
+	psli->sli_flag |= LPFC_SLI_ASYNC_MBX_BLK;
+	if (phba->sli.mbox_active)
+		actcmd = phba->sli.mbox_active->u.mb.mbxCommand;
+	spin_unlock_irq(&phba->hbalock);
+	/* Determine how long we might wait for the active mailbox
+	 * command to be gracefully completed by firmware.
+	 */
+	timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba, actcmd) * 1000) +
+				   jiffies;
+	/* Wait for the outstnading mailbox command to complete */
+	while (phba->sli.mbox_active) {
+		/* Check active mailbox complete status every 2ms */
+		msleep(2);
+		if (time_after(jiffies, timeout)) {
+			/* Timeout, marked the outstanding cmd not complete */
+			rc = 1;
+			break;
+		}
+	}
+
+	/* Can not cleanly block async mailbox command, fails it */
+	if (rc) {
+		spin_lock_irq(&phba->hbalock);
+		psli->sli_flag &= ~LPFC_SLI_ASYNC_MBX_BLK;
+		spin_unlock_irq(&phba->hbalock);
+	}
+	return rc;
+}
+
+/**
+ * lpfc_sli4_async_mbox_unblock - Block posting SLI4 async mailbox command
+ * @phba: Pointer to HBA context object.
+ *
+ * The function unblocks and resume posting of SLI4 asynchronous mailbox
+ * commands from the driver internal pending mailbox queue. It makes sure
+ * that there is no outstanding mailbox command before resuming posting
+ * asynchronous mailbox commands. If, for any reason, there is outstanding
+ * mailbox command, it will try to wait it out before resuming asynchronous
+ * mailbox command posting.
+ **/
+static void
+lpfc_sli4_async_mbox_unblock(struct lpfc_hba *phba)
+{
+	struct lpfc_sli *psli = &phba->sli;
+
+	spin_lock_irq(&phba->hbalock);
+	if (!(psli->sli_flag & LPFC_SLI_ASYNC_MBX_BLK)) {
+		/* Asynchronous mailbox posting is not blocked, do nothing */
+		spin_unlock_irq(&phba->hbalock);
+		return;
+	}
+
+	/* Outstanding synchronous mailbox command is guaranteed to be done,
+	 * successful or timeout, after timing-out the outstanding mailbox
+	 * command shall always be removed, so just unblock posting async
+	 * mailbox command and resume
+	 */
+	psli->sli_flag &= ~LPFC_SLI_ASYNC_MBX_BLK;
+	spin_unlock_irq(&phba->hbalock);
+
+	/* wake up worker thread to post asynchronlous mailbox command */
+	lpfc_worker_wake_up(phba);
+}
+
+/**
  * lpfc_sli4_post_sync_mbox - Post an SLI4 mailbox to the bootstrap mailbox
  * @phba: Pointer to HBA context object.
  * @mboxq: Pointer to mailbox object.
@@ -5204,14 +5290,35 @@ lpfc_sli_issue_mbox_s4(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
 					psli->sli_flag, flag);
 		return rc;
 	} else if (flag == MBX_POLL) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
-				"(%d):2542 Mailbox command x%x (x%x) "
-				"cannot issue Data: x%x x%x\n",
+		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX | LOG_SLI,
+				"(%d):2542 Try to issue mailbox command "
+				"x%x (x%x) synchronously ahead of async"
+				"mailbox command queue: x%x x%x\n",
 				mboxq->vport ? mboxq->vport->vpi : 0,
 				mboxq->u.mb.mbxCommand,
 				lpfc_sli4_mbox_opcode_get(phba, mboxq),
 				psli->sli_flag, flag);
-		return -EIO;
+		/* Try to block the asynchronous mailbox posting */
+		rc = lpfc_sli4_async_mbox_block(phba);
+		if (!rc) {
+			/* Successfully blocked, now issue sync mbox cmd */
+			rc = lpfc_sli4_post_sync_mbox(phba, mboxq);
+			if (rc != MBX_SUCCESS)
+				lpfc_printf_log(phba, KERN_ERR,
+						LOG_MBOX | LOG_SLI,
+						"(%d):2597 Mailbox command "
+						"x%x (x%x) cannot issue "
+						"Data: x%x x%x\n",
+						mboxq->vport ?
+						mboxq->vport->vpi : 0,
+						mboxq->u.mb.mbxCommand,
+						lpfc_sli4_mbox_opcode_get(phba,
+								mboxq),
+						psli->sli_flag, flag);
+			/* Unblock the async mailbox posting afterward */
+			lpfc_sli4_async_mbox_unblock(phba);
+		}
+		return rc;
 	}
 
 	/* Now, interrupt mode asynchrous mailbox command */
@@ -5814,11 +5921,6 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		bf_set(lpfc_wqe_gen_context, &wqe->generic,
 				iocbq->iocb.ulpContext);
 
-		if (iocbq->vport->fc_myDID != 0) {
-			bf_set(els_req64_sid, &wqe->els_req,
-				 iocbq->vport->fc_myDID);
-			bf_set(els_req64_sp, &wqe->els_req, 1);
-		}
 		bf_set(lpfc_wqe_gen_ct, &wqe->generic, ct);
 		bf_set(lpfc_wqe_gen_pu, &wqe->generic, 0);
 		/* CCP CCPE PV PRI in word10 were set in the memcpy */
@@ -5877,14 +5979,19 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		 * is set and we are sending our 2nd or greater command on
 		 * this exchange.
 		 */
+		/* Always open the exchange */
+		bf_set(wqe_xc, &wqe->fcp_iread.wqe_com, 0);
 
-	/* ALLOW read & write to fall through to ICMD64 */
+		wqe->words[10] &= 0xffff0000; /* zero out ebde count */
+		bf_set(lpfc_wqe_gen_pu, &wqe->generic, iocbq->iocb.ulpPU);
+		break;
 	case CMD_FCP_ICMND64_CR:
 		/* Always open the exchange */
 		bf_set(wqe_xc, &wqe->fcp_iread.wqe_com, 0);
 
+		wqe->words[4] = 0;
 		wqe->words[10] &= 0xffff0000; /* zero out ebde count */
-		bf_set(lpfc_wqe_gen_pu, &wqe->generic, iocbq->iocb.ulpPU);
+		bf_set(lpfc_wqe_gen_pu, &wqe->generic, 0);
 	break;
 	case CMD_GEN_REQUEST64_CR:
 		/* word3 command length is described as byte offset to the
@@ -11020,10 +11127,7 @@ lpfc_sli4_post_rpi_hdr(struct lpfc_hba *phba, struct lpfc_rpi_hdr *rpi_page)
 	       rpi_page->start_rpi);
 	hdr_tmpl->rpi_paddr_lo = putPaddrLow(rpi_page->dmabuf->phys);
 	hdr_tmpl->rpi_paddr_hi = putPaddrHigh(rpi_page->dmabuf->phys);
-	if (!phba->sli4_hba.intr_enable)
-		rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
-	else
-		rc = lpfc_sli_issue_mbox_wait(phba, mboxq, mbox_tmo);
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
 	shdr = (union lpfc_sli4_cfg_shdr *) &hdr_tmpl->header.cfg_shdr;
 	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
 	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -229,7 +229,7 @@ struct lpfc_bmbx {
 
 #define LPFC_EQE_DEF_COUNT	1024
 #define LPFC_CQE_DEF_COUNT      256
-#define LPFC_WQE_DEF_COUNT      64
+#define LPFC_WQE_DEF_COUNT      256
 #define LPFC_MQE_DEF_COUNT      16
 #define LPFC_RQE_DEF_COUNT	512
 


