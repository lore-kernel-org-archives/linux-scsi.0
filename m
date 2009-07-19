From: James Smart <James.Smart@Emulex.Com>
Subject: [Patch 5/8] lpfc 8.3.4: NPIV vport fixes
Date: Sun, 19 Jul 2009 10:01:26 -0400
Message-ID: <1248012086.15009.30.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:34690 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbZGSOB2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jul 2009 10:01:28 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n6JE1SO9021593
	for <linux-scsi@vger.kernel.org>; Sun, 19 Jul 2009 07:01:28 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

NPIV vport fixes

- Fixed static vport creation on SLI4 HBAs
- Fixed vport create sending init_vpi before REG_VFI
- Fix unable to create vports on SLI4 HBA's Port2

Signed-off-by: James Smart <James.Smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc.h         |    1 
 drivers/scsi/lpfc/lpfc_crtn.h    |    4 +
 drivers/scsi/lpfc/lpfc_hbadisc.c |  114 +++++++++++++++++++++++++++++++-------
 drivers/scsi/lpfc/lpfc_init.c    |    5 ++
 drivers/scsi/lpfc/lpfc_mbox.c    |   47 ++++++++++++----
 drivers/scsi/lpfc/lpfc_sli.c     |    2 -
 drivers/scsi/lpfc/lpfc_vport.c   |   51 ++++++++++-------
 7 files changed, 168 insertions(+), 56 deletions(-)

--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -312,6 +312,7 @@ struct lpfc_vport {
 #define FC_BYPASSED_MODE        0x20000	 /* NPort is in bypassed mode */
 #define FC_VPORT_NEEDS_REG_VPI	0x80000  /* Needs to have its vpi registered */
 #define FC_RSCN_DEFERRED	0x100000 /* A deferred RSCN being processed */
+#define FC_VPORT_NEEDS_INIT_VPI 0x200000 /* Need to INIT_VPI before FDISC */
 
 	uint32_t ct_flags;
 #define FC_CT_RFF_ID		0x1	 /* RFF_ID accepted by switch */
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -25,7 +25,7 @@ void lpfc_down_link(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_sli_read_link_ste(struct lpfc_hba *);
 void lpfc_dump_mem(struct lpfc_hba *, LPFC_MBOXQ_t *, uint16_t, uint16_t);
 void lpfc_dump_wakeup_param(struct lpfc_hba *, LPFC_MBOXQ_t *);
-void lpfc_dump_static_vport(struct lpfc_hba *, LPFC_MBOXQ_t *, uint16_t);
+int lpfc_dump_static_vport(struct lpfc_hba *, LPFC_MBOXQ_t *, uint16_t);
 int lpfc_dump_fcoe_param(struct lpfc_hba *, struct lpfcMboxq *);
 void lpfc_read_nv(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_config_async(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t);
@@ -184,7 +184,7 @@ int lpfc_mbox_dev_check(struct lpfc_hba *);
 int lpfc_mbox_tmo_val(struct lpfc_hba *, int);
 void lpfc_init_vfi(struct lpfcMboxq *, struct lpfc_vport *);
 void lpfc_reg_vfi(struct lpfcMboxq *, struct lpfc_vport *, dma_addr_t);
-void lpfc_init_vpi(struct lpfcMboxq *, uint16_t);
+void lpfc_init_vpi(struct lpfc_hba *, struct lpfcMboxq *, uint16_t);
 void lpfc_unreg_vfi(struct lpfcMboxq *, uint16_t);
 void lpfc_reg_fcfi(struct lpfc_hba *, struct lpfcMboxq *);
 void lpfc_unreg_fcfi(struct lpfcMboxq *, uint16_t);
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1634,6 +1634,39 @@ out:
 }
 
 /**
+ * lpfc_init_vpi_cmpl - Completion handler for init_vpi mbox command.
+ * @phba: pointer to lpfc hba data structure.
+ * @mboxq: pointer to mailbox data structure.
+ *
+ * This function handles completion of init vpi mailbox command.
+ */
+static void
+lpfc_init_vpi_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
+{
+	struct lpfc_vport *vport = mboxq->vport;
+	if (mboxq->u.mb.mbxStatus) {
+		lpfc_printf_vlog(vport, KERN_ERR,
+				LOG_MBOX,
+				"2609 Init VPI mailbox failed 0x%x\n",
+				mboxq->u.mb.mbxStatus);
+		mempool_free(mboxq, phba->mbox_mem_pool);
+		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
+		return;
+	}
+	vport->fc_flag &= ~FC_VPORT_NEEDS_INIT_VPI;
+
+	if (phba->link_flag & LS_NPIV_FAB_SUPPORTED)
+		lpfc_initial_fdisc(vport);
+	else {
+		lpfc_vport_set_state(vport, FC_VPORT_NO_FABRIC_SUPP);
+		lpfc_printf_vlog(vport, KERN_ERR,
+			LOG_ELS,
+			"2606 No NPIV Fabric support\n");
+	}
+	return;
+}
+
+/**
  * lpfc_start_fdiscs - send fdiscs for each vports on this port.
  * @phba: pointer to lpfc hba data structure.
  *
@@ -1645,6 +1678,8 @@ lpfc_start_fdiscs(struct lpfc_hba *phba)
 {
 	struct lpfc_vport **vports;
 	int i;
+	LPFC_MBOXQ_t *mboxq;
+	int rc;
 
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL) {
@@ -1662,6 +1697,29 @@ lpfc_start_fdiscs(struct lpfc_hba *phba)
 						     FC_VPORT_LINKDOWN);
 				continue;
 			}
+			if (vports[i]->fc_flag & FC_VPORT_NEEDS_INIT_VPI) {
+				mboxq = mempool_alloc(phba->mbox_mem_pool,
+					GFP_KERNEL);
+				if (!mboxq) {
+					lpfc_printf_vlog(vports[i], KERN_ERR,
+					LOG_MBOX, "2607 Failed to allocate "
+					"init_vpi mailbox\n");
+					continue;
+				}
+				lpfc_init_vpi(phba, mboxq, vports[i]->vpi);
+				mboxq->vport = vports[i];
+				mboxq->mbox_cmpl = lpfc_init_vpi_cmpl;
+				rc = lpfc_sli_issue_mbox(phba, mboxq,
+					MBX_NOWAIT);
+				if (rc == MBX_NOT_FINISHED) {
+					lpfc_printf_vlog(vports[i], KERN_ERR,
+					LOG_MBOX, "2608 Failed to issue "
+					"init_vpi mailbox\n");
+					mempool_free(mboxq,
+						phba->mbox_mem_pool);
+				}
+				continue;
+			}
 			if (phba->link_flag & LS_NPIV_FAB_SUPPORTED)
 				lpfc_initial_fdisc(vports[i]);
 			else {
@@ -2242,13 +2300,15 @@ lpfc_create_static_vport(struct lpfc_hba *phba)
 	LPFC_MBOXQ_t *pmb = NULL;
 	MAILBOX_t *mb;
 	struct static_vport_info *vport_info;
-	int rc, i;
+	int rc = 0, i;
 	struct fc_vport_identifiers vport_id;
 	struct fc_vport *new_fc_vport;
 	struct Scsi_Host *shost;
 	struct lpfc_vport *vport;
 	uint16_t offset = 0;
 	uint8_t *vport_buff;
+	struct lpfc_dmabuf *mp;
+	uint32_t byte_count = 0;
 
 	pmb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!pmb) {
@@ -2271,7 +2331,9 @@ lpfc_create_static_vport(struct lpfc_hba *phba)
 
 	vport_buff = (uint8_t *) vport_info;
 	do {
-		lpfc_dump_static_vport(phba, pmb, offset);
+		if (lpfc_dump_static_vport(phba, pmb, offset))
+			goto out;
+
 		pmb->vport = phba->pport;
 		rc = lpfc_sli_issue_mbox_wait(phba, pmb, LPFC_MBOX_TMO);
 
@@ -2284,17 +2346,30 @@ lpfc_create_static_vport(struct lpfc_hba *phba)
 			goto out;
 		}
 
-		if (mb->un.varDmp.word_cnt >
-			sizeof(struct static_vport_info) - offset)
-			mb->un.varDmp.word_cnt =
-			sizeof(struct static_vport_info) - offset;
-
-		lpfc_sli_pcimem_bcopy(((uint8_t *)mb) + DMP_RSP_OFFSET,
-			vport_buff + offset,
-			mb->un.varDmp.word_cnt);
-		offset += mb->un.varDmp.word_cnt;
+		if (phba->sli_rev == LPFC_SLI_REV4) {
+			byte_count = pmb->u.mqe.un.mb_words[5];
+			mp = (struct lpfc_dmabuf *) pmb->context2;
+			if (byte_count > sizeof(struct static_vport_info) -
+					offset)
+				byte_count = sizeof(struct static_vport_info)
+					- offset;
+			memcpy(vport_buff + offset, mp->virt, byte_count);
+			offset += byte_count;
+		} else {
+			if (mb->un.varDmp.word_cnt >
+				sizeof(struct static_vport_info) - offset)
+				mb->un.varDmp.word_cnt =
+					sizeof(struct static_vport_info)
+						- offset;
+			byte_count = mb->un.varDmp.word_cnt;
+			lpfc_sli_pcimem_bcopy(((uint8_t *)mb) + DMP_RSP_OFFSET,
+				vport_buff + offset,
+				byte_count);
+
+			offset += byte_count;
+		}
 
-	} while (mb->un.varDmp.word_cnt &&
+	} while (byte_count &&
 		offset < sizeof(struct static_vport_info));
 

@@ -2336,16 +2411,15 @@ lpfc_create_static_vport(struct lpfc_hba *phba)
 	}
 
 out:
-	/*
-	 * If this is timed out command, setting NULL to context2 tell SLI
-	 * layer not to use this buffer.
-	 */
-	spin_lock_irq(&phba->hbalock);
-	pmb->context2 = NULL;
-	spin_unlock_irq(&phba->hbalock);
 	kfree(vport_info);
-	if (rc != MBX_TIMEOUT)
+	if (rc != MBX_TIMEOUT) {
+		if (pmb->context2) {
+			mp = (struct lpfc_dmabuf *) pmb->context2;
+			lpfc_mbuf_free(phba, mp->virt, mp->phys);
+			kfree(mp);
+		}
 		mempool_free(pmb, phba->mbox_mem_pool);
+	}
 
 	return;
 }
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2155,6 +2155,8 @@ lpfc_online(struct lpfc_hba *phba)
 			vports[i]->fc_flag &= ~FC_OFFLINE_MODE;
 			if (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED)
 				vports[i]->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
+			if (phba->sli_rev == LPFC_SLI_REV4)
+				vports[i]->fc_flag |= FC_VPORT_NEEDS_INIT_VPI;
 			spin_unlock_irq(shost->host_lock);
 		}
 		lpfc_destroy_vport_work_array(phba, vports);
@@ -7372,6 +7374,9 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 	/* Perform post initialization setup */
 	lpfc_post_init_setup(phba);
 
+	/* Check if there are static vports to be created. */
+	lpfc_create_static_vport(phba);
+
 	return 0;
 
 out_disable_intr:
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -52,30 +52,51 @@
  * This routine prepares the mailbox command for dumping list of static
  * vports to be created.
  **/
-void
+int
 lpfc_dump_static_vport(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb,
 		uint16_t offset)
 {
 	MAILBOX_t *mb;
-	void *ctx;
+	struct lpfc_dmabuf *mp;
 
 	mb = &pmb->u.mb;
-	ctx = pmb->context2;
 
 	/* Setup to dump vport info region */
 	memset(pmb, 0, sizeof(LPFC_MBOXQ_t));
 	mb->mbxCommand = MBX_DUMP_MEMORY;
-	mb->un.varDmp.cv = 1;
 	mb->un.varDmp.type = DMP_NV_PARAMS;
 	mb->un.varDmp.entry_index = offset;
 	mb->un.varDmp.region_id = DMP_REGION_VPORT;
-	mb->un.varDmp.word_cnt = DMP_RSP_SIZE/sizeof(uint32_t);
-	mb->un.varDmp.co = 0;
-	mb->un.varDmp.resp_offset = 0;
-	pmb->context2 = ctx;
 	mb->mbxOwner = OWN_HOST;
 
-	return;
+	/* For SLI3 HBAs data is embedded in mailbox */
+	if (phba->sli_rev != LPFC_SLI_REV4) {
+		mb->un.varDmp.cv = 1;
+		mb->un.varDmp.word_cnt = DMP_RSP_SIZE/sizeof(uint32_t);
+		return 0;
+	}
+
+	/* For SLI4 HBAs driver need to allocate memory */
+	mp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+	if (mp)
+		mp->virt = lpfc_mbuf_alloc(phba, 0, &mp->phys);
+
+	if (!mp || !mp->virt) {
+		kfree(mp);
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
+			"2605 lpfc_dump_static_vport: memory"
+			" allocation failed\n");
+		return 1;
+	}
+	memset(mp->virt, 0, LPFC_BPL_SIZE);
+	INIT_LIST_HEAD(&mp->list);
+	/* save address for completion */
+	pmb->context2 = (uint8_t *) mp;
+	mb->un.varWords[3] = putPaddrLow(mp->phys);
+	mb->un.varWords[4] = putPaddrHigh(mp->phys);
+	mb->un.varDmp.sli4_length = sizeof(struct static_vport_info);
+
+	return 0;
 }
 
 /**
@@ -1805,6 +1826,7 @@ lpfc_reg_vfi(struct lpfcMboxq *mbox, struct lpfc_vport *vport, dma_addr_t phys)
 
 /**
  * lpfc_init_vpi - Initialize the INIT_VPI mailbox command
+ * @phba: pointer to the hba structure to init the VPI for.
  * @mbox: pointer to lpfc mbox command to initialize.
  * @vpi: VPI to be initialized.
  *
@@ -1815,11 +1837,14 @@ lpfc_reg_vfi(struct lpfcMboxq *mbox, struct lpfc_vport *vport, dma_addr_t phys)
  * successful virtual NPort login.
  **/
 void
-lpfc_init_vpi(struct lpfcMboxq *mbox, uint16_t vpi)
+lpfc_init_vpi(struct lpfc_hba *phba, struct lpfcMboxq *mbox, uint16_t vpi)
 {
 	memset(mbox, 0, sizeof(*mbox));
 	bf_set(lpfc_mqe_command, &mbox->u.mqe, MBX_INIT_VPI);
-	bf_set(lpfc_init_vpi_vpi, &mbox->u.mqe.un.init_vpi, vpi);
+	bf_set(lpfc_init_vpi_vpi, &mbox->u.mqe.un.init_vpi,
+	       vpi + phba->vpi_base);
+	bf_set(lpfc_init_vpi_vfi, &mbox->u.mqe.un.init_vpi,
+	       phba->pport->vfi + phba->vfi_base);
 }
 
 /**
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -11341,7 +11341,7 @@ lpfc_sli4_init_vpi(struct lpfc_hba *phba, uint16_t vpi)
 	mboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mboxq)
 		return -ENOMEM;
-	lpfc_init_vpi(mboxq, vpi);
+	lpfc_init_vpi(phba, mboxq, vpi);
 	mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_INIT_VPI);
 	rc = lpfc_sli_issue_mbox_wait(phba, mboxq, mbox_tmo);
 	if (rc != MBX_TIMEOUT)
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -313,22 +313,6 @@ lpfc_vport_create(struct fc_vport *fc_vport, bool disable)
 		goto error_out;
 	}
 
-	/*
-	 * In SLI4, the vpi must be activated before it can be used
-	 * by the port.
-	 */
-	if (phba->sli_rev == LPFC_SLI_REV4) {
-		rc = lpfc_sli4_init_vpi(phba, vpi);
-		if (rc) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_VPORT,
-					"1838 Failed to INIT_VPI on vpi %d "
-					"status %d\n", vpi, rc);
-			rc = VPORT_NORESOURCES;
-			lpfc_free_vpi(phba, vpi);
-			goto error_out;
-		}
-	}
-
 	/* Assign an unused board number */
 	if ((instance = lpfc_get_instance()) < 0) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_VPORT,
@@ -367,12 +351,8 @@ lpfc_vport_create(struct fc_vport *fc_vport, bool disable)
 		goto error_out;
 	}
 
-	memcpy(vport->fc_portname.u.wwn, vport->fc_sparam.portName.u.wwn, 8);
-	memcpy(vport->fc_nodename.u.wwn, vport->fc_sparam.nodeName.u.wwn, 8);
-	if (fc_vport->node_name != 0)
-		u64_to_wwn(fc_vport->node_name, vport->fc_nodename.u.wwn);
-	if (fc_vport->port_name != 0)
-		u64_to_wwn(fc_vport->port_name, vport->fc_portname.u.wwn);
+	u64_to_wwn(fc_vport->node_name, vport->fc_nodename.u.wwn);
+	u64_to_wwn(fc_vport->port_name, vport->fc_portname.u.wwn);
 
 	memcpy(&vport->fc_sparam.portName, vport->fc_portname.u.wwn, 8);
 	memcpy(&vport->fc_sparam.nodeName, vport->fc_nodename.u.wwn, 8);
@@ -404,7 +384,34 @@ lpfc_vport_create(struct fc_vport *fc_vport, bool disable)
 	*(struct lpfc_vport **)fc_vport->dd_data = vport;
 	vport->fc_vport = fc_vport;
 
+	/*
+	 * In SLI4, the vpi must be activated before it can be used
+	 * by the port.
+	 */
+	if ((phba->sli_rev == LPFC_SLI_REV4) &&
+		(pport->vfi_state & LPFC_VFI_REGISTERED)) {
+		rc = lpfc_sli4_init_vpi(phba, vpi);
+		if (rc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_VPORT,
+					"1838 Failed to INIT_VPI on vpi %d "
+					"status %d\n", vpi, rc);
+			rc = VPORT_NORESOURCES;
+			lpfc_free_vpi(phba, vpi);
+			goto error_out;
+		}
+	} else if (phba->sli_rev == LPFC_SLI_REV4) {
+		/*
+		 * Driver cannot INIT_VPI now. Set the flags to
+		 * init_vpi when reg_vfi complete.
+		 */
+		vport->fc_flag |= FC_VPORT_NEEDS_INIT_VPI;
+		lpfc_vport_set_state(vport, FC_VPORT_LINKDOWN);
+		rc = VPORT_OK;
+		goto out;
+	}
+
 	if ((phba->link_state < LPFC_LINK_UP) ||
+	    (pport->port_state < LPFC_FABRIC_CFG_LINK) ||
 	    (phba->fc_topology == TOPOLOGY_LOOP)) {
 		lpfc_vport_set_state(vport, FC_VPORT_LINKDOWN);
 		rc = VPORT_OK;


