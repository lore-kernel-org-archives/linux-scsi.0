From: James Smart <James.Smart@Emulex.Com>
Subject: [Patch 2/8] lpfc 8.3.4: Consistently Implement persistent port
	disable
Date: Sun, 19 Jul 2009 10:01:10 -0400
Message-ID: <1248012070.15009.24.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:34676 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbZGSOBM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jul 2009 10:01:12 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n6JE1CwF021576
	for <linux-scsi@vger.kernel.org>; Sun, 19 Jul 2009 07:01:12 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Consistently implement persistent port disable.

Ability was to be managed in the adapter via firmware via flash settings.
However, not all firmware images supported it. Uniformly support it
everywhere.

Signed-off-by: James Smart <James.Smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc.h      |    1 
 drivers/scsi/lpfc/lpfc_attr.c |    7 ++
 drivers/scsi/lpfc/lpfc_crtn.h |    5 +
 drivers/scsi/lpfc/lpfc_hw.h   |    4 +
 drivers/scsi/lpfc/lpfc_init.c |   59 +++++++++++----
 drivers/scsi/lpfc/lpfc_mbox.c |   36 +++++++--
 drivers/scsi/lpfc/lpfc_sli.c  |  158 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_sli4.h |    4 +
 8 files changed, 242 insertions(+), 32 deletions(-)

--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -525,6 +525,7 @@ struct lpfc_hba {
 #define FCP_XRI_ABORT_EVENT	0x20
 #define ELS_XRI_ABORT_EVENT	0x40
 #define ASYNC_EVENT		0x80
+#define LINK_DISABLED		0x100 /* Link disabled by user */
 	struct lpfc_dmabuf slim2p;
 
 	MAILBOX_t *mbox;
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -394,7 +394,12 @@ lpfc_link_state_show(struct device *dev, struct device_attribute *attr,
 	case LPFC_INIT_MBX_CMDS:
 	case LPFC_LINK_DOWN:
 	case LPFC_HBA_ERROR:
-		len += snprintf(buf + len, PAGE_SIZE-len, "Link Down\n");
+		if (phba->hba_flag & LINK_DISABLED)
+			len += snprintf(buf + len, PAGE_SIZE-len,
+				"Link Down - User disabled\n");
+		else
+			len += snprintf(buf + len, PAGE_SIZE-len,
+				"Link Down\n");
 		break;
 	case LPFC_LINK_UP:
 	case LPFC_CLEAR_LA:
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -21,7 +21,9 @@
 typedef int (*node_filter)(struct lpfc_nodelist *, void *);
 
 struct fc_rport;
-void lpfc_dump_mem(struct lpfc_hba *, LPFC_MBOXQ_t *, uint16_t);
+void lpfc_down_link(struct lpfc_hba *, LPFC_MBOXQ_t *);
+void lpfc_sli_read_link_ste(struct lpfc_hba *);
+void lpfc_dump_mem(struct lpfc_hba *, LPFC_MBOXQ_t *, uint16_t, uint16_t);
 void lpfc_dump_wakeup_param(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_dump_static_vport(struct lpfc_hba *, LPFC_MBOXQ_t *, uint16_t);
 int lpfc_dump_fcoe_param(struct lpfc_hba *, struct lpfcMboxq *);
@@ -234,6 +236,7 @@ void lpfc_sli_def_mbox_cmpl(struct lpfc_hba *, LPFC_MBOXQ_t *);
 int lpfc_sli_issue_iocb(struct lpfc_hba *, uint32_t,
 			struct lpfc_iocbq *, uint32_t);
 void lpfc_sli_pcimem_bcopy(void *, void *, uint32_t);
+void lpfc_sli_bemem_bcopy(void *, void *, uint32_t);
 void lpfc_sli_abort_iocb_ring(struct lpfc_hba *, struct lpfc_sli_ring *);
 void lpfc_sli_flush_fcp_rings(struct lpfc_hba *);
 int lpfc_sli_ringpostbuf_put(struct lpfc_hba *, struct lpfc_sli_ring *,
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -2496,8 +2496,8 @@ typedef struct {
 #define  DMP_VPORT_REGION_SIZE	 0x200
 #define  DMP_MBOX_OFFSET_WORD	 0x5
 
-#define  DMP_REGION_FCOEPARAM	 0x17   /* fcoe param region */
-#define  DMP_FCOEPARAM_RGN_SIZE	 0x400
+#define  DMP_REGION_23	 	 0x17   /* fcoe param  and port state region */
+#define  DMP_RGN23_SIZE	 	 0x400
 
 #define  WAKE_UP_PARMS_REGION_ID    4
 #define  WAKE_UP_PARMS_WORD_SIZE   15
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -211,7 +211,7 @@ lpfc_config_port_prep(struct lpfc_hba *phba)
 		goto out_free_mbox;
 
 	do {
-		lpfc_dump_mem(phba, pmb, offset);
+		lpfc_dump_mem(phba, pmb, offset, DMP_REGION_VPD);
 		rc = lpfc_sli_issue_mbox(phba, pmb, MBX_POLL);
 
 		if (rc != MBX_SUCCESS) {
@@ -425,6 +425,9 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 		return -EIO;
 	}
 
+	/* Check if the port is disabled */
+	lpfc_sli_read_link_ste(phba);
+
 	/* Reset the DFT_HBA_Q_DEPTH to the max xri  */
 	if (phba->cfg_hba_queue_depth > (mb->un.varRdConfig.max_xri+1))
 		phba->cfg_hba_queue_depth =
@@ -524,27 +527,49 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 	/* Set up error attention (ERATT) polling timer */
 	mod_timer(&phba->eratt_poll, jiffies + HZ * LPFC_ERATT_POLL_INTERVAL);
 
-	lpfc_init_link(phba, pmb, phba->cfg_topology, phba->cfg_link_speed);
-	pmb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
-	lpfc_set_loopback_flag(phba);
-	rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
-	if (rc != MBX_SUCCESS) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+	/* Check if the port is disabled */
+	lpfc_sli_read_serdes_param(phba);
+
+	if (phba->hba_flag & LINK_DISABLED) {
+		lpfc_printf_log(phba,
+			KERN_ERR, LOG_INIT,
+			"2598 Adapter Link is disabled.\n");
+		lpfc_down_link(phba, pmb);
+		pmb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+		rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
+		if ((rc != MBX_SUCCESS) && (rc != MBX_BUSY)) {
+			lpfc_printf_log(phba,
+			KERN_ERR, LOG_INIT,
+			"2599 Adapter failed to issue DOWN_LINK"
+			" mbox command rc 0x%x\n", rc);
+
+			mempool_free(pmb, phba->mbox_mem_pool);
+			return -EIO;
+		}
+	} else {
+		lpfc_init_link(phba, pmb, phba->cfg_topology,
+			phba->cfg_link_speed);
+		pmb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+		lpfc_set_loopback_flag(phba);
+		rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
+		if (rc != MBX_SUCCESS) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0454 Adapter failed to init, mbxCmd x%x "
 				"INIT_LINK, mbxStatus x%x\n",
 				mb->mbxCommand, mb->mbxStatus);
 
-		/* Clear all interrupt enable conditions */
-		writel(0, phba->HCregaddr);
-		readl(phba->HCregaddr); /* flush */
-		/* Clear all pending interrupts */
-		writel(0xffffffff, phba->HAregaddr);
-		readl(phba->HAregaddr); /* flush */
+			/* Clear all interrupt enable conditions */
+			writel(0, phba->HCregaddr);
+			readl(phba->HCregaddr); /* flush */
+			/* Clear all pending interrupts */
+			writel(0xffffffff, phba->HAregaddr);
+			readl(phba->HAregaddr); /* flush */
 
-		phba->link_state = LPFC_HBA_ERROR;
-		if (rc != MBX_BUSY)
-			mempool_free(pmb, phba->mbox_mem_pool);
-		return -EIO;
+			phba->link_state = LPFC_HBA_ERROR;
+			if (rc != MBX_BUSY)
+				mempool_free(pmb, phba->mbox_mem_pool);
+			return -EIO;
+		}
 	}
 	/* MBOX buffer will be freed in mbox compl */
 	pmb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -79,21 +79,37 @@ lpfc_dump_static_vport(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb,
 }
 
 /**
- * lpfc_dump_mem - Prepare a mailbox command for retrieving HBA's VPD memory
+ * lpfc_down_link - Bring down HBAs link.
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
- * @offset: offset for dumping VPD memory mailbox command.
+ *
+ * This routine prepares a mailbox command to bring down HBA link.
+ **/
+void
+lpfc_down_link(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
+{
+	MAILBOX_t *mb;
+	memset(pmb, 0, sizeof(LPFC_MBOXQ_t));
+	mb = &pmb->u.mb;
+	mb->mbxCommand = MBX_DOWN_LINK;
+	mb->mbxOwner = OWN_HOST;
+}
+
+/**
+ * lpfc_dump_mem - Prepare a mailbox command for reading a region.
+ * @phba: pointer to lpfc hba data structure.
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ * @offset: offset into the region.
+ * @region_id: config region id.
  *
  * The dump mailbox command provides a method for the device driver to obtain
  * various types of information from the HBA device.
  *
- * This routine prepares the mailbox command for dumping HBA Vital Product
- * Data (VPD) memory. This mailbox command is to be used for retrieving a
- * portion (DMP_RSP_SIZE bytes) of a HBA's VPD from the HBA at an address
- * offset specified by the offset parameter.
+ * This routine prepares the mailbox command for dumping HBA's config region.
  **/
 void
-lpfc_dump_mem(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb, uint16_t offset)
+lpfc_dump_mem(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb, uint16_t offset,
+		uint16_t region_id)
 {
 	MAILBOX_t *mb;
 	void *ctx;
@@ -107,7 +123,7 @@ lpfc_dump_mem(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb, uint16_t offset)
 	mb->un.varDmp.cv = 1;
 	mb->un.varDmp.type = DMP_NV_PARAMS;
 	mb->un.varDmp.entry_index = offset;
-	mb->un.varDmp.region_id = DMP_REGION_VPD;
+	mb->un.varDmp.region_id = region_id;
 	mb->un.varDmp.word_cnt = (DMP_RSP_SIZE / sizeof (uint32_t));
 	mb->un.varDmp.co = 0;
 	mb->un.varDmp.resp_offset = 0;
@@ -1864,8 +1880,8 @@ lpfc_dump_fcoe_param(struct lpfc_hba *phba,
 
 	mb->mbxCommand = MBX_DUMP_MEMORY;
 	mb->un.varDmp.type = DMP_NV_PARAMS;
-	mb->un.varDmp.region_id = DMP_REGION_FCOEPARAM;
-	mb->un.varDmp.sli4_length = DMP_FCOEPARAM_RGN_SIZE;
+	mb->un.varDmp.region_id = DMP_REGION_23;
+	mb->un.varDmp.sli4_length = DMP_RGN23_SIZE;
 	mb->un.varWords[3] = putPaddrLow(mp->phys);
 	mb->un.varWords[4] = putPaddrHigh(mp->phys);
 	return 0;
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4139,7 +4139,7 @@ lpfc_sli4_read_fcoe_params(struct lpfc_hba *phba,
 		return -EIO;
 	}
 	data_length = mqe->un.mb_words[5];
-	if (data_length > DMP_FCOEPARAM_RGN_SIZE) {
+	if (data_length > DMP_RGN23_SIZE) {
 		lpfc_mbuf_free(phba, mp->virt, mp->phys);
 		kfree(mp);
 		return -EIO;
@@ -6789,6 +6789,33 @@ lpfc_sli_pcimem_bcopy(void *srcp, void *destp, uint32_t cnt)
 

 /**
+ * lpfc_sli_bemem_bcopy - SLI memory copy function
+ * @srcp: Source memory pointer.
+ * @destp: Destination memory pointer.
+ * @cnt: Number of words required to be copied.
+ *
+ * This function is used for copying data between a data structure
+ * with big endian representation to local endianness.
+ * This function can be called with or without lock.
+ **/
+void
+lpfc_sli_bemem_bcopy(void *srcp, void *destp, uint32_t cnt)
+{
+	uint32_t *src = srcp;
+	uint32_t *dest = destp;
+	uint32_t ldata;
+	int i;
+
+	for (i = 0; i < (int)cnt; i += sizeof(uint32_t)) {
+		ldata = *src;
+		ldata = be32_to_cpu(ldata);
+		*dest = ldata;
+		src++;
+		dest++;
+	}
+}
+
+/**
  * lpfc_sli_ringpostbuf_put - Function to add a buffer to postbufq
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
@@ -11564,3 +11591,132 @@ lpfc_sli4_read_fcf_record(struct lpfc_hba *phba, uint16_t fcf_index)
 		error = 0;
 	return error;
 }
+
+/**
+ * lpfc_sli_read_link_ste - Read region 23 to decide if link is disabled.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This function read region 23 and parse TLV for port status to
+ * decide if the user disaled the port. If the TLV indicates the
+ * port is disabled, the hba_flag is set accordingly.
+ **/
+void
+lpfc_sli_read_link_ste(struct lpfc_hba *phba)
+{
+	LPFC_MBOXQ_t *pmb = NULL;
+	MAILBOX_t *mb;
+	uint8_t *rgn23_data = NULL;
+	uint32_t offset = 0, data_size, sub_tlv_len, tlv_offset;
+	int rc;
+
+	pmb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!pmb) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"2600 lpfc_sli_read_serdes_param failed to"
+			" allocate mailbox memory\n");
+		goto out;
+	}
+	mb = &pmb->u.mb;
+
+	/* Get adapter Region 23 data */
+	rgn23_data = kzalloc(DMP_RGN23_SIZE, GFP_KERNEL);
+	if (!rgn23_data)
+		goto out;
+
+	do {
+		lpfc_dump_mem(phba, pmb, offset, DMP_REGION_23);
+		rc = lpfc_sli_issue_mbox(phba, pmb, MBX_POLL);
+
+		if (rc != MBX_SUCCESS) {
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"2601 lpfc_sli_read_link_ste failed to"
+				" read config region 23 rc 0x%x Status 0x%x\n",
+				rc, mb->mbxStatus);
+			mb->un.varDmp.word_cnt = 0;
+		}
+		/*
+		 * dump mem may return a zero when finished or we got a
+		 * mailbox error, either way we are done.
+		 */
+		if (mb->un.varDmp.word_cnt == 0)
+			break;
+		if (mb->un.varDmp.word_cnt > DMP_RGN23_SIZE - offset)
+			mb->un.varDmp.word_cnt = DMP_RGN23_SIZE - offset;
+
+		lpfc_sli_pcimem_bcopy(((uint8_t *)mb) + DMP_RSP_OFFSET,
+			rgn23_data + offset,
+			mb->un.varDmp.word_cnt);
+		offset += mb->un.varDmp.word_cnt;
+	} while (mb->un.varDmp.word_cnt && offset < DMP_RGN23_SIZE);
+
+	data_size = offset;
+	offset = 0;
+
+	if (!data_size)
+		goto out;
+
+	/* Check the region signature first */
+	if (memcmp(&rgn23_data[offset], LPFC_REGION23_SIGNATURE, 4)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"2619 Config region 23 has bad signature\n");
+			goto out;
+	}
+	offset += 4;
+
+	/* Check the data structure version */
+	if (rgn23_data[offset] != LPFC_REGION23_VERSION) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"2620 Config region 23 has bad version\n");
+		goto out;
+	}
+	offset += 4;
+
+	/* Parse TLV entries in the region */
+	while (offset < data_size) {
+		if (rgn23_data[offset] == LPFC_REGION23_LAST_REC)
+			break;
+		/*
+		 * If the TLV is not driver specific TLV or driver id is
+		 * not linux driver id, skip the record.
+		 */
+		if ((rgn23_data[offset] != DRIVER_SPECIFIC_TYPE) ||
+		    (rgn23_data[offset + 2] != LINUX_DRIVER_ID) ||
+		    (rgn23_data[offset + 3] != 0)) {
+			offset += rgn23_data[offset + 1] * 4 + 4;
+			continue;
+		}
+
+		/* Driver found a driver specific TLV in the config region */
+		sub_tlv_len = rgn23_data[offset + 1] * 4;
+		offset += 4;
+		tlv_offset = 0;
+
+		/*
+		 * Search for configured port state sub-TLV.
+		 */
+		while ((offset < data_size) &&
+			(tlv_offset < sub_tlv_len)) {
+			if (rgn23_data[offset] == LPFC_REGION23_LAST_REC) {
+				offset += 4;
+				tlv_offset += 4;
+				break;
+			}
+			if (rgn23_data[offset] != PORT_STE_TYPE) {
+				offset += rgn23_data[offset + 1] * 4 + 4;
+				tlv_offset += rgn23_data[offset + 1] * 4 + 4;
+				continue;
+			}
+
+			/* This HBA contains PORT_STE configured */
+			if (!rgn23_data[offset + 2])
+				phba->hba_flag |= LINK_DISABLED;
+
+			goto out;
+		}
+	}
+out:
+	if (pmb)
+		mempool_free(pmb, phba->mbox_mem_pool);
+	kfree(rgn23_data);
+	return;
+}
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -151,6 +151,10 @@ struct lpfc_fcf {
 #define LPFC_REGION23_SIGNATURE "RG23"
 #define LPFC_REGION23_VERSION	1
 #define LPFC_REGION23_LAST_REC  0xff
+#define DRIVER_SPECIFIC_TYPE	0xA2
+#define LINUX_DRIVER_ID		0x20
+#define PORT_STE_TYPE		0x1
+
 struct lpfc_fip_param_hdr {
 	uint8_t type;
 #define FCOE_PARAM_TYPE		0xA0


