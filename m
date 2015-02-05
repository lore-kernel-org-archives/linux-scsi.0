From: James Smart <james.smart@emulex.com>
Subject: [PATCH 15/21] lpfc: Implement support for wire-only DIF devices
Date: Thu, 5 Feb 2015 14:25:17 -0500
Message-ID: <1423164317.7917.39.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:20692 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586AbbBETZ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2015 14:25:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


---
 drivers/scsi/lpfc/lpfc.h         |  41 ++++
 drivers/scsi/lpfc/lpfc_attr.c    |  65 ++++++-
 drivers/scsi/lpfc/lpfc_crtn.h    |   3 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c |   3 +
 drivers/scsi/lpfc/lpfc_init.c    |  24 ++-
 drivers/scsi/lpfc/lpfc_mbox.c    |   4 +-
 drivers/scsi/lpfc/lpfc_scsi.c    | 410 ++++++++++++++++++++++++++++++++++++---
 drivers/scsi/lpfc/lpfc_scsi.h    |   7 +-
 drivers/scsi/lpfc/lpfc_sli.c     |  36 ++--
 9 files changed, 532 insertions(+), 61 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 922e59d..e192c2d 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -295,6 +295,42 @@ enum hba_state {
 	LPFC_HBA_ERROR       =  -1
 };
 
+/* Structure used to identify all devices controlled
+ * by the External DIF logic.
+ */
+struct lpfc_external_dif_support {
+	struct list_head listentry;
+	struct lpfc_name portName;
+	uint64_t lun;
+	uint16_t sid;
+	uint8_t dif_info;
+	uint8_t reserved1;
+};
+
+/* Struct used to identify External DIF vendor specific info */
+struct lpfc_vendor_dif {
+	uint8_t length;
+	uint8_t version;
+	uint8_t dif_info;
+#define LPFC_FDIF_ATO		0x01
+#define LPFC_FDIF_REFCHK	0x02
+#define LPFC_FDIF_APPCHK	0x04
+#define LPFC_FDIF_GRDCHK	0x08
+#define LPFC_FDIF_SPTMASK	0x70
+#define LPFC_FDIF_PROTECT	0x80
+	uint8_t reserved1;
+};
+
+/* Defines used to identify a External DIF device */
+#define LPFC_INQ_VID_OFFSET	8
+#define LPFC_INQ_VDIF_OFFSET	168
+#define LPFC_INQ_FDIF_SZ	(LPFC_INQ_VDIF_OFFSET + 4)
+#define LPFC_INQ_FDIF_VENDOR	"3PARdata"	/* Vendor Identification */
+#define LPFC_INQ_FDIF_VERSION	1
+#define LPFC_INQ_FDIF_SIZE	2
+#define LPFC_FDIF_CDB_PROTECT	0x20		/* Set RD/WR PROTECT = 001 */
+
+
 struct lpfc_vport {
 	struct lpfc_hba *phba;
 	struct list_head listentry;
@@ -441,6 +477,10 @@ struct lpfc_vport {
 	unsigned long rcv_buffer_time_stamp;
 	uint32_t vport_flag;
 #define STATIC_VPORT	1
+
+	/* Used to discover External DIF devices */
+	struct list_head external_dif_list;
+	spinlock_t external_dif_lock;	/* lock for external_dif_list */
 };
 
 struct hbq_s {
@@ -739,6 +779,7 @@ struct lpfc_hba {
 #define OAS_LUN_VALID	0x04
 	uint32_t cfg_XLanePriority;
 	uint32_t cfg_enable_bg;
+	uint32_t cfg_external_dif;
 	uint32_t cfg_hostmem_hgp;
 	uint32_t cfg_log_verbose;
 	uint32_t cfg_aer_support;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index faf0e8c..891e2d1 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -135,16 +135,29 @@ lpfc_bg_info_show(struct device *dev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
+	int len = 0;
 
-	if (phba->cfg_enable_bg)
+	if (phba->cfg_enable_bg) {
 		if (phba->sli3_options & LPFC_SLI3_BG_ENABLED)
-			return snprintf(buf, PAGE_SIZE, "BlockGuard Enabled\n");
+			len +=  snprintf(buf, PAGE_SIZE,
+					 "BlockGuard Enabled\n");
 		else
-			return snprintf(buf, PAGE_SIZE,
+			len +=  snprintf(buf, PAGE_SIZE,
 					"BlockGuard Not Supported\n");
-	else
-			return snprintf(buf, PAGE_SIZE,
+	} else {
+			len +=  snprintf(buf, PAGE_SIZE,
 					"BlockGuard Disabled\n");
+	}
+
+	if (phba->cfg_external_dif) {
+		if (phba->sli3_options & LPFC_SLI3_BG_ENABLED)
+			len += snprintf(buf + len, PAGE_SIZE,
+					"External DIF Enabled\n");
+		else
+			len += snprintf(buf + len, PAGE_SIZE,
+					"External DIF Not Supported\n");
+	}
+	return len;
 }
 
 static ssize_t
@@ -4681,6 +4694,30 @@ LPFC_ATTR_R(EnableXLane, 0, 0, 1, "Enable Express Lane Feature.");
 */
 LPFC_ATTR_RW(XLanePriority, 0, 0x0, 0x7f, "CS_CTL for Express Lane Feature.");
 
+
+/*
+ * For T10 DIF / protection data support, the driver supports 4 modes
+ * of operation.
+ *
+ * Mode 1: (lpfc_enable_bg=1 lpfc_external_dif=1)
+ * All normal T10 DIF devices are supported.
+ * External DIF devices are supported.
+ *
+ * Mode 2: (lpfc_enable_bg=0 lpfc_external_dif=1)
+ * If you don't want to have the extra overhead of the upper SCSI Layer
+ * supporting T10-DIF, but you still want to support External DIF devices.
+ * Normal T10 DIF devices are NOT supported.
+ * External DIF devices are supported.
+ *
+ * Mode 3: (lpfc_enable_bg=1 lpfc_external_dif=0)
+ * All normal T10 DIF devices are supported.
+ * External DIF devices are NOT supported.
+ *
+ * Mode 4: (lpfc_enable_bg=0 lpfc_external_dif=1)
+ * No normal T10-DIF and no external DIF devices supported,
+ * This would be the driver default values for these module parameters.
+ */
+
 /*
 # lpfc_enable_bg: Enable BlockGuard (Emulex's Implementation of T10-DIF)
 #       0  = BlockGuard disabled (default)
@@ -4690,6 +4727,15 @@ LPFC_ATTR_RW(XLanePriority, 0, 0x0, 0x7f, "CS_CTL for Express Lane Feature.");
 LPFC_ATTR_R(enable_bg, 0, 0, 1, "Enable BlockGuard Support");
 
 /*
+# lpfc_external_dif: Enable External DIF support on select devices
+#       0  = External DIF disabled (default)
+#       1  = External DIF enabled
+# Value range is [0,1]. Default value is 0.
+*/
+LPFC_ATTR_R(external_dif, 0, 0, 1,
+	    "External T10-DIF Support, on select devices");
+
+/*
 # lpfc_fcp_look_ahead: Look ahead for completions in FCP start routine
 #       0  = disabled (default)
 #       1  = enabled
@@ -4703,7 +4749,7 @@ unsigned int lpfc_fcp_look_ahead = LPFC_LOOK_AHEAD_OFF;
 # lpfc_prot_mask: i
 #	- Bit mask of host protection capabilities used to register with the
 #	  SCSI mid-layer
-# 	- Only meaningful if BG is turned on (lpfc_enable_bg=1).
+#	- Only meaningful if BG is turned on, lpfc_enable_bg = 1
 #	- Allows you to ultimately specify which profiles to use
 #	- Default will result in registering capabilities for all profiles.
 #	- SHOST_DIF_TYPE1_PROTECTION	1
@@ -4726,6 +4772,7 @@ MODULE_PARM_DESC(lpfc_prot_mask, "host protection mask");
 #	- Bit mask of protection guard types to register with the SCSI mid-layer
 #	- Guard types are currently either 1) T10-DIF CRC 2) IP checksum
 #	- Allows you to ultimately specify which profiles to use
+#	- Only meaningful if BG is turned on, lpfc_enable_bg = 1
 #	- Default will result in registering capabilities for all guard types
 #
 */
@@ -4837,6 +4884,7 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_fcp_cpu_map,
 	&dev_attr_lpfc_fcp_io_channel,
 	&dev_attr_lpfc_enable_bg,
+	&dev_attr_lpfc_external_dif,
 	&dev_attr_lpfc_soft_wwnn,
 	&dev_attr_lpfc_soft_wwpn,
 	&dev_attr_lpfc_soft_wwn_enable,
@@ -5839,6 +5887,11 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	phba->cfg_oas_lun_status = 0;
 	phba->cfg_oas_flags = 0;
 	lpfc_enable_bg_init(phba, lpfc_enable_bg);
+	lpfc_external_dif_init(phba, lpfc_external_dif);
+
+	if (phba->cfg_enable_bg || phba->cfg_external_dif)
+		phba->sli3_options |= LPFC_SLI3_BG_ENABLED;
+
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		phba->cfg_poll = 0;
 	else
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index dd01ea8..a7b4fc7 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -366,7 +366,8 @@ extern int lpfc_delay_discovery;
 int  lpfc_vport_symbolic_node_name(struct lpfc_vport *, char *, size_t);
 int  lpfc_vport_symbolic_port_name(struct lpfc_vport *, char *,	size_t);
 void lpfc_terminate_rport_io(struct fc_rport *);
-void lpfc_dev_loss_tmo_callbk(struct fc_rport *rport);
+void lpfc_dev_loss_tmo_callbk(struct fc_rport *);
+void lpfc_external_dif_cleanup(struct lpfc_vport *, struct lpfc_name *);
 
 struct lpfc_vport *lpfc_create_port(struct lpfc_hba *, int, struct device *);
 int  lpfc_vport_disable(struct fc_vport *fc_vport, bool disable);
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 2a51df7..17da14e 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -143,6 +143,9 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 		return;
 	}
 
+	/* Cleanup all External DIF devices that match this rports WWPN */
+	lpfc_external_dif_cleanup(vport, &ndlp->nlp_portname);
+
 	if (ndlp->nlp_state == NLP_STE_MAPPED_NODE)
 		return;
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index afaa45d..78345a8 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -154,8 +154,6 @@ lpfc_config_port_prep(struct lpfc_hba *phba)
 		       sizeof(phba->wwpn));
 	}
 
-	phba->sli3_options = 0x0;
-
 	/* Setup and issue mailbox READ REV command */
 	lpfc_read_rev(phba, pmb);
 	rc = lpfc_sli_issue_mbox(phba, pmb, MBX_POLL);
@@ -2523,6 +2521,7 @@ lpfc_cleanup(struct lpfc_vport *vport)
 {
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_nodelist *ndlp, *next_ndlp;
+	struct lpfc_external_dif_support *dp, *next_dp;
 	int i = 0;
 
 	if (phba->link_state > LPFC_LINK_DOWN)
@@ -2600,6 +2599,15 @@ lpfc_cleanup(struct lpfc_vport *vport)
 		msleep(10);
 	}
 	lpfc_cleanup_vports_rrqs(vport, NULL);
+
+	/* Cleanup any discovered External DIF devices for this vport */
+	list_for_each_entry_safe(dp, next_dp, &vport->external_dif_list,
+				 listentry) {
+		spin_lock_irq(&vport->external_dif_lock);
+		list_del(&dp->listentry);
+		spin_unlock_irq(&vport->external_dif_lock);
+		kfree(dp);
+	}
 }
 
 /**
@@ -3348,6 +3356,10 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 	if (error)
 		goto out_put_shost;
 
+	/* Initialize objects used to discover External DIF devices */
+	INIT_LIST_HEAD(&vport->external_dif_list);
+	spin_lock_init(&vport->external_dif_lock);
+
 	spin_lock_irq(&phba->hbalock);
 	list_add_tail(&vport->listentry, &phba->port_list);
 	spin_unlock_irq(&phba->hbalock);
@@ -4992,7 +5004,7 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
 	lpfc_template.sg_tablesize = phba->cfg_sg_seg_cnt;
 
 	/* There are going to be 2 reserved BDEs: 1 FCP cmnd + 1 FCP rsp */
-	if (phba->cfg_enable_bg) {
+	if (phba->sli3_options & LPFC_SLI3_BG_ENABLED) {
 		/*
 		 * The scsi_buf for a T10-DIF I/O will hold the FCP cmnd,
 		 * the FCP rsp, and a BDE for each. Sice we have no control
@@ -5185,7 +5197,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	 * used to create the sg_dma_buf_pool must be dynamically calculated.
 	 */
 
-	if (phba->cfg_enable_bg) {
+	if (phba->sli3_options & LPFC_SLI3_BG_ENABLED) {
 		/*
 		 * The scsi_buf for a T10-DIF I/O will hold the FCP cmnd,
 		 * the FCP rsp, and a SGE for each. Sice we have no control
@@ -6286,7 +6298,9 @@ lpfc_post_init_setup(struct lpfc_hba *phba)
 	 */
 	shost = pci_get_drvdata(phba->pcidev);
 	shost->can_queue = phba->cfg_hba_queue_depth - 10;
-	if (phba->sli3_options & LPFC_SLI3_BG_ENABLED)
+
+	/* Setup T10-DIF interface with SCSI Layer API */
+	if (phba->cfg_enable_bg)
 		lpfc_setup_bg(phba, shost);
 
 	lpfc_host_attrib_init(shost);
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 06241f5..702283e 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -1280,7 +1280,7 @@ lpfc_config_port(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	/* If HBA supports SLI=3 ask for it */
 
 	if (phba->sli_rev == LPFC_SLI_REV3 && phba->vpd.sli3Feat.cerbm) {
-		if (phba->cfg_enable_bg)
+		if (phba->sli3_options & LPFC_SLI3_BG_ENABLED)
 			mb->un.varCfgPort.cbg = 1; /* configure BlockGuard */
 		if (phba->cfg_enable_dss)
 			mb->un.varCfgPort.cdss = 1; /* Configure Security */
@@ -2071,7 +2071,7 @@ lpfc_request_features(struct lpfc_hba *phba, struct lpfcMboxq *mboxq)
 	bf_set(lpfc_mbx_rq_ftr_rq_perfh, &mboxq->u.mqe.un.req_ftrs, 1);
 
 	/* Enable DIF (block guard) only if configured to do so. */
-	if (phba->cfg_enable_bg)
+	if (phba->sli3_options & LPFC_SLI3_BG_ENABLED)
 		bf_set(lpfc_mbx_rq_ftr_rq_dif, &mboxq->u.mqe.un.req_ftrs, 1);
 
 	/* Enable NPIV only if configured to do so. */
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 5612ba6..9ed5f44 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -80,6 +80,9 @@ lpfc_rport_data_from_scsi_device(struct scsi_device *sdev)
 }
 
 static void
+lpfc_external_dif(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
+		  uint8_t *cdb_ptr);
+static void
 lpfc_release_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb);
 static void
 lpfc_release_scsi_buf_s3(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb);
@@ -564,7 +567,7 @@ lpfc_sli4_fcp_xri_aborted(struct lpfc_hba *phba,
 		&phba->sli4_hba.lpfc_abts_scsi_buf_list, list) {
 		if (psb->cur_iocbq.sli4_xritag == xri) {
 			list_del(&psb->list);
-			psb->exch_busy = 0;
+			psb->flags &= ~LPFC_SBUF_XBUSY;
 			psb->status = IOSTAT_SUCCESS;
 			spin_unlock(
 				&phba->sli4_hba.abts_scsi_buf_list_lock);
@@ -596,7 +599,7 @@ lpfc_sli4_fcp_xri_aborted(struct lpfc_hba *phba,
 		if (iocbq->sli4_xritag != xri)
 			continue;
 		psb = container_of(iocbq, struct lpfc_scsi_buf, cur_iocbq);
-		psb->exch_busy = 0;
+		psb->flags &= ~LPFC_SBUF_XBUSY;
 		spin_unlock_irqrestore(&phba->hbalock, iflag);
 		if (!list_empty(&pring->txq))
 			lpfc_worker_wake_up(phba);
@@ -683,10 +686,10 @@ lpfc_sli4_post_scsi_sgl_list(struct lpfc_hba *phba,
 						psb->cur_iocbq.sli4_xritag);
 				if (status) {
 					/* failure, put on abort scsi list */
-					psb->exch_busy = 1;
+					psb->flags |= LPFC_SBUF_XBUSY;
 				} else {
 					/* success, put on SCSI buffer list */
-					psb->exch_busy = 0;
+					psb->flags &= ~LPFC_SBUF_XBUSY;
 					psb->status = IOSTAT_SUCCESS;
 					num_posted++;
 				}
@@ -716,10 +719,10 @@ lpfc_sli4_post_scsi_sgl_list(struct lpfc_hba *phba,
 					 struct lpfc_scsi_buf, list);
 			if (status) {
 				/* failure, put on abort scsi list */
-				psb->exch_busy = 1;
+				psb->flags |= LPFC_SBUF_XBUSY;
 			} else {
 				/* success, put on SCSI buffer list */
-				psb->exch_busy = 0;
+				psb->flags &= ~LPFC_SBUF_XBUSY;
 				psb->status = IOSTAT_SUCCESS;
 				num_posted++;
 			}
@@ -833,7 +836,8 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *vport, int num_to_alloc)
 		 * 4K Page alignment is CRITICAL to BlockGuard, double check
 		 * to be sure.
 		 */
-		if (phba->cfg_enable_bg  && (((unsigned long)(psb->data) &
+		if ((phba->sli3_options & LPFC_SLI3_BG_ENABLED) &&
+		    (((unsigned long)(psb->data) &
 		    (unsigned long)(SLI4_PAGE_SIZE - 1)) != 0)) {
 			pci_pool_free(phba->lpfc_scsi_dma_buf_pool,
 				      psb->data, psb->dma_handle);
@@ -1097,7 +1101,7 @@ lpfc_release_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
 	psb->nonsg_phys = 0;
 	psb->prot_seg_cnt = 0;
 
-	if (psb->exch_busy) {
+	if (psb->flags & LPFC_SBUF_XBUSY) {
 		spin_lock_irqsave(&phba->sli4_hba.abts_scsi_buf_list_lock,
 					iflag);
 		psb->pCmd = NULL;
@@ -1125,7 +1129,7 @@ lpfc_release_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
 static void
 lpfc_release_scsi_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
 {
-
+	psb->flags &= ~(LPFC_SBUF_NORMAL_DIF | LPFC_SBUF_PASS_DIF);
 	phba->lpfc_release_scsi_buf(phba, psb);
 }
 
@@ -1267,6 +1271,38 @@ lpfc_scsi_prep_dma_buf_s3(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
 	return 0;
 }
 
+/**
+ * lpfc_scsi_get_prot_op - Gets the SCSI defined protection data operation
+ * @sc: The SCSI Layer structure for the IO in question.
+ *
+ * This routine calls the SCSI Layer to get the protectio data operation
+ * associated with the specified IO. Then, if this is an IO effected by an
+ * External DIF device, the protection operation is adjusted accordingly.
+ *
+ * Returns the SCSI defined protection data operation
+ **/
+uint32_t
+lpfc_scsi_get_prot_op(struct scsi_cmnd *sc)
+{
+	struct lpfc_scsi_buf *lpfc_cmd;
+	uint32_t op = scsi_get_prot_op(sc);
+
+	lpfc_cmd = (struct lpfc_scsi_buf *)sc->host_scribble;
+	if (lpfc_cmd->flags & LPFC_SBUF_NORMAL_DIF) {
+		if (sc->sc_data_direction == DMA_FROM_DEVICE)
+			op = SCSI_PROT_READ_STRIP;
+		else if (sc->sc_data_direction == DMA_TO_DEVICE)
+			op = SCSI_PROT_WRITE_INSERT;
+	} else if (lpfc_cmd->flags & LPFC_SBUF_PASS_DIF) {
+		if (sc->sc_data_direction == DMA_FROM_DEVICE)
+			op = SCSI_PROT_READ_PASS;
+		else if (sc->sc_data_direction == DMA_TO_DEVICE)
+			op = SCSI_PROT_WRITE_PASS;
+	}
+	return op;
+}
+
+
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 
 /* Return if if error injection is detected by Initiator */
@@ -1298,7 +1334,7 @@ lpfc_bg_err_inject(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	struct scsi_dif_tuple *src = NULL;
 	struct lpfc_nodelist *ndlp;
 	struct lpfc_rport_data *rdata;
-	uint32_t op = scsi_get_prot_op(sc);
+	uint32_t op = lpfc_scsi_get_prot_op(sc);
 	uint32_t blksize;
 	uint32_t numblks;
 	sector_t lba;
@@ -1702,7 +1738,7 @@ lpfc_sc_to_bg_opcodes(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	uint8_t ret = 0;
 
 	if (lpfc_cmd_guard_csum(sc)) {
-		switch (scsi_get_prot_op(sc)) {
+		switch (lpfc_scsi_get_prot_op(sc)) {
 		case SCSI_PROT_READ_INSERT:
 		case SCSI_PROT_WRITE_STRIP:
 			*rxop = BG_OP_IN_NODIF_OUT_CSUM;
@@ -1725,13 +1761,13 @@ lpfc_sc_to_bg_opcodes(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		default:
 			lpfc_printf_log(phba, KERN_ERR, LOG_BG,
 				"9063 BLKGRD: Bad op/guard:%d/IP combination\n",
-					scsi_get_prot_op(sc));
+					lpfc_scsi_get_prot_op(sc));
 			ret = 1;
 			break;
 
 		}
 	} else {
-		switch (scsi_get_prot_op(sc)) {
+		switch (lpfc_scsi_get_prot_op(sc)) {
 		case SCSI_PROT_READ_STRIP:
 		case SCSI_PROT_WRITE_INSERT:
 			*rxop = BG_OP_IN_CRC_OUT_NODIF;
@@ -1754,7 +1790,7 @@ lpfc_sc_to_bg_opcodes(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		default:
 			lpfc_printf_log(phba, KERN_ERR, LOG_BG,
 				"9075 BLKGRD: Bad op/guard:%d/CRC combination\n",
-					scsi_get_prot_op(sc));
+					lpfc_scsi_get_prot_op(sc));
 			ret = 1;
 			break;
 		}
@@ -1782,7 +1818,7 @@ lpfc_bg_err_opcodes(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	uint8_t ret = 0;
 
 	if (lpfc_cmd_guard_csum(sc)) {
-		switch (scsi_get_prot_op(sc)) {
+		switch (lpfc_scsi_get_prot_op(sc)) {
 		case SCSI_PROT_READ_INSERT:
 		case SCSI_PROT_WRITE_STRIP:
 			*rxop = BG_OP_IN_NODIF_OUT_CRC;
@@ -1807,7 +1843,7 @@ lpfc_bg_err_opcodes(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 
 		}
 	} else {
-		switch (scsi_get_prot_op(sc)) {
+		switch (lpfc_scsi_get_prot_op(sc)) {
 		case SCSI_PROT_READ_STRIP:
 		case SCSI_PROT_WRITE_INSERT:
 			*rxop = BG_OP_IN_CSUM_OUT_NODIF;
@@ -2628,7 +2664,7 @@ static int
 lpfc_prot_group_type(struct lpfc_hba *phba, struct scsi_cmnd *sc)
 {
 	int ret = LPFC_PG_TYPE_INVALID;
-	unsigned char op = scsi_get_prot_op(sc);
+	unsigned char op = lpfc_scsi_get_prot_op(sc);
 
 	switch (op) {
 	case SCSI_PROT_READ_STRIP:
@@ -2673,12 +2709,12 @@ lpfc_bg_scsi_adjust_dl(struct lpfc_hba *phba,
 	/* Check if there is protection data on the wire */
 	if (sc->sc_data_direction == DMA_FROM_DEVICE) {
 		/* Read check for protection data */
-		if (scsi_get_prot_op(sc) ==  SCSI_PROT_READ_INSERT)
+		if (lpfc_scsi_get_prot_op(sc) ==  SCSI_PROT_READ_INSERT)
 			return fcpdl;
 
 	} else {
 		/* Write check for protection data */
-		if (scsi_get_prot_op(sc) ==  SCSI_PROT_WRITE_STRIP)
+		if (lpfc_scsi_get_prot_op(sc) ==  SCSI_PROT_WRITE_STRIP)
 			return fcpdl;
 	}
 
@@ -2895,7 +2931,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
 	guard_tag = 0;
 
 	/* First check to see if there is protection data to examine */
-	prot = scsi_get_prot_op(cmd);
+	prot = lpfc_scsi_get_prot_op(cmd);
 	if ((prot == SCSI_PROT_READ_STRIP) ||
 	    (prot == SCSI_PROT_WRITE_INSERT) ||
 	    (prot == SCSI_PROT_NORMAL))
@@ -3177,7 +3213,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd,
 		cmd->sense_buffer[10] = 0x80; /* Validity bit */
 
 		/* bghm is a "on the wire" FC frame based count */
-		switch (scsi_get_prot_op(cmd)) {
+		switch (lpfc_scsi_get_prot_op(cmd)) {
 		case SCSI_PROT_READ_INSERT:
 		case SCSI_PROT_WRITE_STRIP:
 			bghm /= cmd->device->sector_size;
@@ -3459,7 +3495,7 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 		}
 	}
 
-	switch (scsi_get_prot_op(scsi_cmnd)) {
+	switch (lpfc_scsi_get_prot_op(scsi_cmnd)) {
 	case SCSI_PROT_WRITE_STRIP:
 	case SCSI_PROT_READ_STRIP:
 		lpfc_cmd->cur_iocbq.iocb_flag |= LPFC_IO_DIF_STRIP;
@@ -3693,6 +3729,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 	uint32_t host_status = DID_OK;
 	uint32_t rsplen = 0;
 	uint32_t logit = LOG_FCP | LOG_FCP_ERROR;
+	uint8_t  asc, ascq;
 

 	/*
@@ -3840,7 +3877,16 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 		scsi_set_resid(cmnd, scsi_bufflen(cmnd));
 	}
 
- out:
+out:
+	if (vport->phba->cfg_external_dif &&
+	    (lpfc_cmd->flags & (LPFC_SBUF_NORMAL_DIF | LPFC_SBUF_PASS_DIF))) {
+		asc = cmnd->sense_buffer[12];
+		ascq = cmnd->sense_buffer[13];
+		/* Check for LOGICAL BLOCK GUARD CHECK / REF TAG failed */
+		if ((scsi_status == SAM_STAT_CHECK_CONDITION) &&
+		    (asc == 0x10) && ((ascq == 1) || (ascq == 3)))
+			host_status = DID_ERROR; /* Convert to retryable err */
+	}
 	cmnd->result = ScsiResult(host_status, scsi_status);
 	lpfc_send_scsi_error_event(vport->phba, vport, lpfc_cmd, rsp_iocb);
 }
@@ -3882,7 +3928,10 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	lpfc_cmd->result = (pIocbOut->iocb.un.ulpWord[4] & IOERR_PARAM_MASK);
 	lpfc_cmd->status = pIocbOut->iocb.ulpStatus;
 	/* pick up SLI4 exhange busy status from HBA */
-	lpfc_cmd->exch_busy = pIocbOut->iocb_flag & LPFC_EXCHANGE_BUSY;
+	if (pIocbOut->iocb_flag & LPFC_EXCHANGE_BUSY)
+		lpfc_cmd->flags |= LPFC_SBUF_XBUSY;
+	else
+		lpfc_cmd->flags &= ~LPFC_SBUF_XBUSY;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	if (lpfc_cmd->prot_data_type) {
@@ -4001,7 +4050,8 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 			if ((lpfc_cmd->result == IOERR_RX_DMA_FAILED ||
 			     lpfc_cmd->result == IOERR_TX_DMA_FAILED) &&
 			     pIocbOut->iocb.unsli3.sli3_bg.bgstat) {
-				if (scsi_get_prot_op(cmd) != SCSI_PROT_NORMAL) {
+				if (lpfc_scsi_get_prot_op(cmd) !=
+				    SCSI_PROT_NORMAL) {
 					/*
 					 * This is a response for a BG enabled
 					 * cmd. Parse BG error
@@ -4184,6 +4234,10 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 		memset(ptr, 0, (LPFC_FCP_CDB_LEN - scsi_cmnd->cmd_len));
 	}
 
+	/* Check if we want to make this IO an External DIF device */
+	if (vport->phba->cfg_external_dif)
+		lpfc_external_dif(vport, lpfc_cmd, &fcp_cmnd->fcpCdb[0]);
+
 	fcp_cmnd->fcpCntl1 = SIMPLE_Q;
 
 	sli4 = (phba->sli_rev == LPFC_SLI_REV4);
@@ -4241,7 +4295,8 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 
 	piocbq->iocb.ulpClass = (pnode->nlp_fcp_info & 0x0f);
 	piocbq->context1  = lpfc_cmd;
-	piocbq->iocb_cmpl = lpfc_scsi_cmd_iocb_cmpl;
+	if (piocbq->iocb_cmpl == NULL)
+		piocbq->iocb_cmpl = lpfc_scsi_cmd_iocb_cmpl;
 	piocbq->iocb.ulpTimeout = lpfc_cmd->timeout;
 	piocbq->vport = vport;
 }
@@ -4481,6 +4536,296 @@ void lpfc_poll_timeout(unsigned long ptr)
 }
 
 /**
+ * lpfc_external_dif_cleanup - Clean up a specific External DIF device
+ * @vport: The virtual port for which this call is being executed.
+ * @pname WWPN to match
+ *
+ * This routine scans the discovered External DIF devices for the vport
+ * for a match using the targets WWPN. All luns matching that WWPN will be
+ * removed. This routine is called when dev_loss for a target is envoked.
+ **/
+void
+lpfc_external_dif_cleanup(struct lpfc_vport *vport, struct lpfc_name *pname)
+{
+	struct lpfc_external_dif_support *dp, *next_dp;
+	unsigned long flags;
+	uint8_t *name;
+
+	spin_lock_irqsave(&vport->external_dif_lock, flags);
+	list_for_each_entry_safe(dp, next_dp, &vport->external_dif_list,
+				 listentry) {
+		name = (uint8_t *)&dp->portName;
+		if (memcmp(name, (uint8_t *)pname,
+			   sizeof(struct lpfc_name)) == 0) {
+			list_del(&dp->listentry);
+			lpfc_printf_log(vport->phba, KERN_WARNING, LOG_BG,
+					"0701 Remove External DIF device "
+					"scsi_id x%x: lun_id x%llx: WWPN "
+					"%02x:%02x:%02x:%02x:"
+					"%02x:%02x:%02x:%02x\n",
+					dp->sid, dp->lun,
+					*name, *(name+1), *(name+2), *(name+3),
+					*(name+4), *(name+5), *(name+6),
+					*(name+7));
+			kfree(dp);
+		}
+	}
+	spin_unlock_irqrestore(&vport->external_dif_lock, flags);
+}
+
+/**
+ * lpfc_external_dif_match - Look up a specific External DIF device
+ * @vport: The virtual port for which this call is being executed.
+ * @lun: lun id used to specify the desired External DIF device
+ * @sid: SCSI id used to specify the desired External DIF device
+ *
+ * This routine scans the discovered External DIF devices for the vport
+ * for a match using the lun/sid criteria.
+ *
+ * Return code :
+ *   NULL - device not found
+ *   dp   - struct lpfc_external_dif_support of matching device
+ **/
+struct lpfc_external_dif_support *
+lpfc_external_dif_match(struct lpfc_vport *vport, uint64_t lun, uint32_t sid)
+{
+	struct lpfc_external_dif_support *dp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vport->external_dif_lock, flags);
+	list_for_each_entry(dp, &vport->external_dif_list, listentry) {
+		if ((dp->sid == sid) && (dp->lun == lun)) {
+			spin_unlock_irqrestore(&vport->external_dif_lock,
+					       flags);
+			return dp;
+		}
+	}
+	spin_unlock_irqrestore(&vport->external_dif_lock, flags);
+	return NULL;
+}
+
+/**
+ * lpfc_external_dif_cmpl - IOCB completion routine for a External DIF IO
+ * @phba: The Hba for which this call is being executed.
+ * @pIocbIn: The command IOCBQ for the scsi cmnd.
+ * @pIocbOut: The response IOCBQ for the scsi cmnd.
+ *
+ * This routine processes the External DIF SCSi command cmpl before calling the
+ * normal SCSI cmpl routine (lpfc_scsi_cmd_iocb_cmpl). There are 2 types of
+ * External DIF completions, INQUIRY and READ/WRITE SCSI commands.
+ *
+ * We use INQUIRY to discover External DIF devices. An External DIF device does
+ * not advertise itself as T10-DIF capable using standard bits in the INQUIRY
+ * and READ_CAPACITY commands. Instead, it uses some vendor specific
+ * information in the standard INQUIRY command to turn on this feature.
+ *
+ * For READ/WRITE IOs we convert the IO back into a normal IO so it can be
+ * completed to the SCSI layer. The SCSI layer is unaware the IO was actually
+ * transmitted on the wire in T10 DIF Type 1 format.
+ **/
+static void
+lpfc_external_dif_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
+		       struct lpfc_iocbq *pIocbOut)
+{
+	struct lpfc_scsi_buf *lpfc_cmd =
+		(struct lpfc_scsi_buf *)pIocbIn->context1;
+	struct lpfc_vport *vport = pIocbIn->vport;
+	struct fcp_rsp *fcprsp = lpfc_cmd->fcp_rsp;
+	uint32_t resp_info = fcprsp->rspStatus2;
+	struct scsi_cmnd *cmnd = lpfc_cmd->pCmd;
+	uint32_t status = pIocbOut->iocb.ulpStatus;
+	struct lpfc_rport_data *rdata;
+	struct lpfc_nodelist *pnode;
+	struct lpfc_external_dif_support *dp;
+	struct lpfc_vendor_dif *vendor_dif_infop;
+	struct fcp_cmnd *fcpcmd;
+	struct scsi_device *sdev;
+	struct scatterlist *sgde;
+	unsigned long flags;
+	uint8_t *data_inq;
+	uint8_t *name;
+	uint32_t cnt;
+
+	if (status) {
+		if ((status != IOSTAT_FCP_RSP_ERROR) ||
+		    !(resp_info & RESID_UNDER))
+			goto out;
+	}
+
+	/* Only success and RESID_UNDER make it here */
+	switch (cmnd->cmnd[0]) {
+	case INQUIRY:
+		fcpcmd = lpfc_cmd->fcp_cmnd;
+		sgde = scsi_sglist(cmnd);
+		data_inq = (uint8_t *)sg_virt(sgde);
+
+		/* Make sure the INQUIRY payload has our
+		 * vendor specific info included.
+		 */
+		cnt = be32_to_cpu(fcpcmd->fcpDl) -
+			be32_to_cpu(fcprsp->rspResId);
+		if (cnt < LPFC_INQ_FDIF_SZ)
+			break;
+
+		/* Jump to T10 Vendor Identification field */
+		data_inq += LPFC_INQ_VID_OFFSET;
+		if ((memcmp(data_inq, LPFC_INQ_FDIF_VENDOR,
+			    sizeof(LPFC_INQ_FDIF_VENDOR) != 0)))
+			break;
+
+		sdev = cmnd->device;
+		if (lpfc_external_dif_match(vport, sdev->lun, sdev->id))
+			break; /* device already exists */
+
+		/* Jump to Vendor specific DIF info */
+		vendor_dif_infop = (struct lpfc_vendor_dif *)(data_inq +
+			(LPFC_INQ_VDIF_OFFSET - LPFC_INQ_VID_OFFSET));
+
+		/* Check to see if External DIF protection is enabled and we
+		 * are version 1. Currently we only support DIF Type 1
+		 * (GRD_CHK / REF_CHK)
+		 */
+		if ((vendor_dif_infop->length != LPFC_INQ_FDIF_SIZE) ||
+		    (vendor_dif_infop->version != LPFC_INQ_FDIF_VERSION) ||
+		    (vendor_dif_infop->dif_info != (LPFC_FDIF_PROTECT |
+		    LPFC_FDIF_REFCHK |  LPFC_FDIF_GRDCHK))) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_BG,
+					"0709 External DIF Vendor info error "
+					"Data: %02x %02x %02x\n",
+					vendor_dif_infop->length,
+					vendor_dif_infop->version,
+					vendor_dif_infop->dif_info);
+			break;
+		}
+
+		/* New External DIF device found */
+		dp = kmalloc(sizeof(struct lpfc_external_dif_support),
+			     GFP_ATOMIC);
+		if (!dp)
+			break;
+		dp->lun = sdev->lun;
+		dp->sid = sdev->id;
+		dp->dif_info = vendor_dif_infop->dif_info;
+
+		rdata = lpfc_cmd->rdata;
+		pnode = rdata->pnode;
+		memcpy(&dp->portName, &pnode->nlp_portname,
+		       sizeof(struct lpfc_name));
+
+		spin_lock_irqsave(&vport->external_dif_lock, flags);
+		list_add_tail(&dp->listentry, &vport->external_dif_list);
+		spin_unlock_irqrestore(&vport->external_dif_lock, flags);
+
+		name = (uint8_t *)&pnode->nlp_portname;
+		lpfc_printf_log(phba, KERN_WARNING, LOG_BG,
+				"0712 Discovered External DIF device NPortId "
+				"x%x: scsi_id x%x: lun_id x%llx: WWPN "
+				"%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
+				pnode->nlp_DID, dp->sid, dp->lun,
+				*name, *(name+1), *(name+2), *(name+3),
+				*(name+4), *(name+5), *(name+6), *(name+7));
+		break;
+	case READ_10:
+	case READ_12:
+	case READ_16:
+	case WRITE_10:
+	case WRITE_12:
+	case WRITE_16:
+	case WRITE_SAME:
+	case WRITE_SAME_16:
+	case WRITE_VERIFY:
+		break;
+	default:
+		break;
+	}
+out:
+	lpfc_scsi_cmd_iocb_cmpl(phba, pIocbIn, pIocbOut);
+}
+
+/**
+ * lpfc_external_dif - Check to see if we want to process this IO as a External DIF
+ * @vport: The virtual port for which this call is being executed.
+ * @lpfc_cmd: Pointer to lpfc_scsi_buf data structure.
+ *
+ * This routine will selectively force normal IOs to be processed as a
+ * READ_STRIP / WRITE_INSERT T10-DIF IO. The upper SCSI Layer will be unaware
+ * that the IO is going to be transmitted on the wire with T10-DIF protection
+ * data. This routine also diverts INQUIRY command cmpletions so they can be
+ * used to scan for External DIF devices.
+ **/
+static void
+lpfc_external_dif(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
+		  uint8_t *cdb_ptr)
+{
+	struct scsi_cmnd *cmnd = lpfc_cmd->pCmd;
+	struct lpfc_iocbq *piocbq = &(lpfc_cmd->cur_iocbq);
+	struct scsi_device *sdev;
+
+	switch (scsi_get_prot_op(cmnd)) {
+	case SCSI_PROT_NORMAL:
+	case SCSI_PROT_READ_INSERT:
+	case SCSI_PROT_WRITE_STRIP:
+		break;
+	default:
+		return;
+	}
+
+	switch (cdb_ptr[0]) {
+	case INQUIRY:
+		/* We are only interested in page 0 */
+		if ((cdb_ptr[1] != 0) || (cdb_ptr[2] != 0))
+			return;
+
+		/* Divert cmpl to check for a External DIF device */
+		piocbq->iocb_cmpl = lpfc_external_dif_cmpl;
+		return;
+	case READ_10:
+	case READ_12:
+	case READ_16:
+		/* Is this a Force DIF device */
+		sdev = cmnd->device;
+		if (!lpfc_external_dif_match(vport, sdev->lun, sdev->id))
+			return;
+
+		/* This is an IO for a External DIF device, so set the
+		 * appropriate bits so we send protection data on the wire.
+		 */
+		cdb_ptr[1] |= LPFC_FDIF_CDB_PROTECT; /* Set RDPROTECT = 001 */
+		piocbq->iocb_cmpl = lpfc_external_dif_cmpl;
+		break;
+	case WRITE_10:
+	case WRITE_12:
+	case WRITE_16:
+	case WRITE_SAME:
+	case WRITE_SAME_16:
+	case WRITE_VERIFY:
+		/* Is this a Force DIF device */
+		sdev = cmnd->device;
+		if (!lpfc_external_dif_match(vport, sdev->lun, sdev->id))
+			return;
+
+		/* This is an IO for a External DIF device, so set the
+		 * appropriate bits so we send protection data on the wire.
+		 */
+		cdb_ptr[1] |= LPFC_FDIF_CDB_PROTECT; /* Set WRPROTECT = 001 */
+		piocbq->iocb_cmpl = lpfc_external_dif_cmpl;
+		break;
+	default:
+		return;
+	}
+
+	switch (scsi_get_prot_op(cmnd)) {
+	case SCSI_PROT_NORMAL:
+		lpfc_cmd->flags |= LPFC_SBUF_NORMAL_DIF;
+		break;
+	case SCSI_PROT_READ_INSERT:
+	case SCSI_PROT_WRITE_STRIP:
+		lpfc_cmd->flags |= LPFC_SBUF_PASS_DIF;
+		break;
+	}
+}
+
+/**
  * lpfc_queuecommand - scsi_host_template queuecommand entry point
  * @cmnd: Pointer to scsi_cmnd data structure.
  * @done: Pointer to done routine.
@@ -4551,10 +4896,13 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	lpfc_cmd->rdata = rdata;
 	lpfc_cmd->timeout = 0;
 	lpfc_cmd->start_time = jiffies;
+	lpfc_cmd->cur_iocbq.iocb_cmpl = NULL;
 	cmnd->host_scribble = (unsigned char *)lpfc_cmd;
 
-	if (scsi_get_prot_op(cmnd) != SCSI_PROT_NORMAL) {
-		if (vport->phba->cfg_enable_bg) {
+	lpfc_scsi_prep_cmnd(vport, lpfc_cmd, ndlp);
+
+	if (lpfc_scsi_get_prot_op(cmnd) != SCSI_PROT_NORMAL) {
+		if (phba->sli3_options & LPFC_SLI3_BG_ENABLED) {
 			lpfc_printf_vlog(vport,
 					 KERN_INFO, LOG_SCSI_CMD,
 					 "9033 BLKGRD: rcvd %s cmd:x%x "
@@ -4567,7 +4915,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 		}
 		err = lpfc_bg_scsi_prep_dma_buf(phba, lpfc_cmd);
 	} else {
-		if (vport->phba->cfg_enable_bg) {
+		if (phba->sli3_options & LPFC_SLI3_BG_ENABLED) {
 			lpfc_printf_vlog(vport,
 					 KERN_INFO, LOG_SCSI_CMD,
 					 "9038 BLKGRD: rcvd PROT_NORMAL cmd: "
@@ -4583,8 +4931,6 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	if (err)
 		goto out_host_busy_free_buf;
 
-	lpfc_scsi_prep_cmnd(vport, lpfc_cmd, ndlp);
-
 	atomic_inc(&ndlp->cmd_pending);
 	err = lpfc_sli_issue_iocb(phba, LPFC_FCP_RING,
 				  &lpfc_cmd->cur_iocbq, SLI_IOCB_RET_IOCB);
@@ -5109,7 +5455,7 @@ static int
 lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 {
 	struct Scsi_Host  *shost = cmnd->device->host;
-	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
 	struct lpfc_rport_data *rdata;
 	struct lpfc_nodelist *pnode;
 	unsigned tgt_id = cmnd->device->id;
diff --git a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
index 0389ac1..bb9a455 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.h
+++ b/drivers/scsi/lpfc/lpfc_scsi.h
@@ -134,7 +134,12 @@ struct lpfc_scsi_buf {
 
 	uint32_t timeout;
 
-	uint16_t exch_busy;     /* SLI4 hba reported XB on complete WCQE */
+	uint16_t flags;
+#define LPFC_SBUF_XBUSY		0x1	/* SLI4 hba reported XB on WCQE cmpl */
+					/* External DIF device IO conversions */
+#define LPFC_SBUF_NORMAL_DIF	0x2	/* normal mode to insert/strip */
+#define LPFC_SBUF_PASS_DIF	0x4	/* insert/strip mode to passthru */
+
 	uint16_t status;	/* From IOCB Word 7- ulpStatus */
 	uint32_t result;	/* From IOCB Word 4. */
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c76c2a1..066428b 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4526,7 +4526,6 @@ lpfc_sli_config_port(struct lpfc_hba *phba, int sli_mode)
 		phba->sli3_options &= ~(LPFC_SLI3_NPIV_ENABLED |
 					LPFC_SLI3_HBQ_ENABLED |
 					LPFC_SLI3_CRP_ENABLED |
-					LPFC_SLI3_BG_ENABLED |
 					LPFC_SLI3_DSS_ENABLED);
 		if (rc != MBX_SUCCESS) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
@@ -4592,13 +4591,20 @@ lpfc_sli_config_port(struct lpfc_hba *phba, int sli_mode)
 		phba->hbq_get = phba->mbox->us.s3_pgp.hbq_get;
 		phba->port_gp = phba->mbox->us.s3_pgp.port;
 
-		if (phba->cfg_enable_bg) {
-			if (pmb->u.mb.un.varCfgPort.gbg)
-				phba->sli3_options |= LPFC_SLI3_BG_ENABLED;
-			else
+		/*
+		 * If the port cannot support the host's requested features
+		 * then turn off the global config parameters to disable the
+		 * feature in the driver.  This is not a fatal error.
+		 */
+		if (phba->sli3_options & LPFC_SLI3_BG_ENABLED) {
+			if (pmb->u.mb.un.varCfgPort.gbg == 0) {
+				phba->cfg_enable_bg = 0;
+				phba->cfg_external_dif = 0;
+				phba->sli3_options &= ~LPFC_SLI3_BG_ENABLED;
 				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 						"0443 Adapter did not grant "
 						"BlockGuard\n");
+			}
 		}
 	} else {
 		phba->hbq_get = NULL;
@@ -4689,7 +4695,6 @@ lpfc_sli_hba_setup(struct lpfc_hba *phba)
 	} else {
 		phba->iocb_cmd_size = SLI2_IOCB_CMD_SIZE;
 		phba->iocb_rsp_size = SLI2_IOCB_RSP_SIZE;
-		phba->sli3_options = 0;
 	}
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
@@ -6407,12 +6412,13 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	 * then turn off the global config parameters to disable the
 	 * feature in the driver.  This is not a fatal error.
 	 */
-	phba->sli3_options &= ~LPFC_SLI3_BG_ENABLED;
-	if (phba->cfg_enable_bg) {
-		if (bf_get(lpfc_mbx_rq_ftr_rsp_dif, &mqe->un.req_ftrs))
-			phba->sli3_options |= LPFC_SLI3_BG_ENABLED;
-		else
+	if (phba->sli3_options & LPFC_SLI3_BG_ENABLED) {
+		if (!(bf_get(lpfc_mbx_rq_ftr_rsp_dif, &mqe->un.req_ftrs))) {
+			phba->cfg_enable_bg = 0;
+			phba->cfg_external_dif = 0;
+			phba->sli3_options &= ~LPFC_SLI3_BG_ENABLED;
 			ftr_rsp++;
+		}
 	}
 
 	if (phba->max_vpi && phba->cfg_enable_npiv &&
@@ -6425,8 +6431,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 				"x%x x%x x%x\n", mqe->un.req_ftrs.word2,
 				mqe->un.req_ftrs.word3, phba->cfg_enable_bg,
 				phba->cfg_enable_npiv, phba->max_vpi);
-		if (!(bf_get(lpfc_mbx_rq_ftr_rsp_dif, &mqe->un.req_ftrs)))
-			phba->cfg_enable_bg = 0;
+
 		if (!(bf_get(lpfc_mbx_rq_ftr_rsp_npiv, &mqe->un.req_ftrs)))
 			phba->cfg_enable_npiv = 0;
 	}
@@ -10326,7 +10331,10 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba *phba,
 		!(cmdiocbq->iocb_flag & LPFC_IO_LIBDFC)) {
 		lpfc_cmd = container_of(cmdiocbq, struct lpfc_scsi_buf,
 			cur_iocbq);
-		lpfc_cmd->exch_busy = rspiocbq->iocb_flag & LPFC_EXCHANGE_BUSY;
+		if (rspiocbq->iocb_flag & LPFC_EXCHANGE_BUSY)
+			lpfc_cmd->flags |= LPFC_SBUF_XBUSY;
+		else
+			lpfc_cmd->flags &= ~LPFC_SBUF_XBUSY;
 	}
 
 	pdone_q = cmdiocbq->context_un.wait_queue;
-- 
1.7.11.7

Signed-off-by: James Smart <james.smart@emulex.com>
Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>



