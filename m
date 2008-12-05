From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 6/14] lpfc 8.3.0 :  Add small features, enhance PCIE EEH
	support
Date: Thu, 4 Dec 2008 22:39:19 -0500
Message-ID: <1228448359.19053.45.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:45909 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbYLEOnc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2008 09:43:32 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id mB5EhVe6004221
	for <linux-scsi@vger.kernel.org>; Fri, 5 Dec 2008 06:43:31 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

lpfc 8.3.0 : Added 3 small features and improve PCI EEH support

- Added FC_REG_VPORTRSCN_EVENT to lpfc_nl.h

- Added code to provide option ROM version from HBA and via sysfs

- Added support for HPS bit in config port mailbox command to tell HBA
  that host group pointers are in host memory.

- Bugfix for Extended Error Handling (EEH) support on IBM PowerPC P6
  platform with MSI enabled


Signed-off-by: James Smart <James.Smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc_crtn.h |    1 +
 drivers/scsi/lpfc/lpfc_hw.h   |   37 +++++++++++++++++++++++--
 drivers/scsi/lpfc/lpfc_init.c |   61 ++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_mbox.c |   35 ++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_nl.h   |   16 ++++++-----
 5 files changed, 139 insertions(+), 11 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -22,6 +22,7 @@ typedef int (*node_filter)(struct lpfc_nodelist *, void *);
 
 struct fc_rport;
 void lpfc_dump_mem(struct lpfc_hba *, LPFC_MBOXQ_t *, uint16_t);
+void lpfc_dump_wakeup_param(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_read_nv(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_config_async(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t);
 
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -2362,6 +2362,30 @@ typedef struct {
 #define  DMP_RSP_OFFSET          0x14   /* word 5 contains first word of rsp */
 #define  DMP_RSP_SIZE            0x6C   /* maximum of 27 words of rsp data */
 
+#define  WAKE_UP_PARMS_REGION_ID    4
+#define  WAKE_UP_PARMS_WORD_SIZE   15
+
+/* Option rom version structure */
+struct prog_id {
+#ifdef __BIG_ENDIAN_BITFIELD
+	uint8_t  type;
+	uint8_t  id;
+	uint32_t ver:4;  /* Major Version */
+	uint32_t rev:4;  /* Revision */
+	uint32_t lev:2;  /* Level */
+	uint32_t dist:2; /* Dist Type */
+	uint32_t num:4;  /* number after dist type */
+#else /*  __LITTLE_ENDIAN_BITFIELD */
+	uint32_t num:4;  /* number after dist type */
+	uint32_t dist:2; /* Dist Type */
+	uint32_t lev:2;  /* Level */
+	uint32_t rev:4;  /* Revision */
+	uint32_t ver:4;  /* Major Version */
+	uint8_t  id;
+	uint8_t  type;
+#endif
+};
+
 /* Structure for MB Command UPDATE_CFG (0x1B) */
 
 struct update_cfg_var {
@@ -2555,10 +2579,17 @@ typedef struct {
 
 	uint32_t pcbLow;       /* bit 31:0  of memory based port config block */
 	uint32_t pcbHigh;      /* bit 63:32 of memory based port config block */
-	uint32_t hbainit[6];
+	uint32_t hbainit[5];
+#ifdef __BIG_ENDIAN_BITFIELD
+	uint32_t hps	   :  1; /* bit 31 word9 Host Pointer in slim */
+	uint32_t rsvd	   : 31; /* least significant 31 bits of word 9 */
+#else   /*  __LITTLE_ENDIAN */
+	uint32_t rsvd      : 31; /* least significant 31 bits of word 9 */
+	uint32_t hps	   :  1; /* bit 31 word9 Host Pointer in slim */
+#endif
 
 #ifdef __BIG_ENDIAN_BITFIELD
-	uint32_t rsvd      : 24;  /* Reserved                             */
+	uint32_t rsvd1     : 24;  /* Reserved                             */
 	uint32_t cmv	   :  1;  /* Configure Max VPIs                   */
 	uint32_t ccrp      :  1;  /* Config Command Ring Polling          */
 	uint32_t csah      :  1;  /* Configure Synchronous Abort Handling */
@@ -2576,7 +2607,7 @@ typedef struct {
 	uint32_t csah      :  1;  /* Configure Synchronous Abort Handling */
 	uint32_t ccrp      :  1;  /* Config Command Ring Polling          */
 	uint32_t cmv	   :  1;  /* Configure Max VPIs                   */
-	uint32_t rsvd      : 24;  /* Reserved                             */
+	uint32_t rsvd1     : 24;  /* Reserved                             */
 #endif
 #ifdef __BIG_ENDIAN_BITFIELD
 	uint32_t rsvd2     : 24;  /* Reserved                             */
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -236,6 +236,48 @@ lpfc_config_async_cmpl(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmboxq)
 }
 
 /**
+ * lpfc_dump_wakeup_param_cmpl: Completion handler for dump memory mailbox
+ *     command used for getting wake up parameters.
+ * @phba: pointer to lpfc hba data structure.
+ * @pmboxq: pointer to the driver internal queue element for mailbox command.
+ *
+ * This is the completion handler for dump mailbox command for getting
+ * wake up parameters. When this command complete, the response contain
+ * Option rom version of the HBA. This function translate the version number
+ * into a human readable string and store it in OptionROMVersion.
+ **/
+static void
+lpfc_dump_wakeup_param_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
+{
+	struct prog_id *prg;
+	uint32_t prog_id_word;
+	char dist = ' ';
+	/* character array used for decoding dist type. */
+	char dist_char[] = "nabx";
+
+	if (pmboxq->mb.mbxStatus != MBX_SUCCESS)
+		return;
+
+	prg = (struct prog_id *) &prog_id_word;
+
+	/* word 7 contain option rom version */
+	prog_id_word = pmboxq->mb.un.varWords[7];
+
+	/* Decode the Option rom version word to a readable string */
+	if (prg->dist < 4)
+		dist = dist_char[prg->dist];
+
+	if ((prg->dist == 3) && (prg->num == 0))
+		sprintf(phba->OptionROMVersion, "%d.%d%d",
+			prg->ver, prg->rev, prg->lev);
+	else
+		sprintf(phba->OptionROMVersion, "%d.%d%d%c%d",
+			prg->ver, prg->rev, prg->lev,
+			dist, prg->num);
+	return;
+}
+
+/**
  * lpfc_config_port_post: Perform lpfc initialization after config port.
  * @phba: pointer to lpfc hba data structure.
  *
@@ -482,6 +524,20 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 				rc);
 		mempool_free(pmb, phba->mbox_mem_pool);
 	}
+
+	/* Get Option rom version */
+	pmb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	lpfc_dump_wakeup_param(phba, pmb);
+	pmb->mbox_cmpl = lpfc_dump_wakeup_param_cmpl;
+	pmb->vport = phba->pport;
+	rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
+
+	if ((rc != MBX_BUSY) && (rc != MBX_SUCCESS)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT, "0435 Adapter failed "
+				"to get Option ROM version status x%x\n.", rc);
+		mempool_free(pmb, phba->mbox_mem_pool);
+	}
+
 	return 0;
 }
 
@@ -2406,6 +2462,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
 	phba->eratt_poll.data = (unsigned long) phba;
 
 	pci_set_master(pdev);
+	pci_save_state(pdev);
 	pci_try_set_mwi(pdev);
 
 	if (pci_set_dma_mask(phba->pcidev, DMA_64BIT_MASK) != 0)
@@ -2982,7 +3039,9 @@ static pci_ers_result_t lpfc_io_slot_reset(struct pci_dev *pdev)
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
-	pci_set_master(pdev);
+	pci_restore_state(pdev);
+	if (pdev->is_busmaster)
+		pci_set_master(pdev);
 
 	spin_lock_irq(&phba->hbalock);
 	psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -77,6 +77,38 @@ lpfc_dump_mem(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb, uint16_t offset)
 }
 
 /**
+ * lpfc_dump_mem: Prepare a mailbox command for retrieving wakeup params.
+ * @phba: pointer to lpfc hba data structure.
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ * This function create a dump memory mailbox command to dump wake up
+ * parameters.
+ */
+void
+lpfc_dump_wakeup_param(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
+{
+	MAILBOX_t *mb;
+	void *ctx;
+
+	mb = &pmb->mb;
+	/* Save context so that we can restore after memset */
+	ctx = pmb->context2;
+
+	/* Setup to dump VPD region */
+	memset(pmb, 0, sizeof(LPFC_MBOXQ_t));
+	mb->mbxCommand = MBX_DUMP_MEMORY;
+	mb->mbxOwner = OWN_HOST;
+	mb->un.varDmp.cv = 1;
+	mb->un.varDmp.type = DMP_NV_PARAMS;
+	mb->un.varDmp.entry_index = 0;
+	mb->un.varDmp.region_id = WAKE_UP_PARMS_REGION_ID;
+	mb->un.varDmp.word_cnt = WAKE_UP_PARMS_WORD_SIZE;
+	mb->un.varDmp.co = 0;
+	mb->un.varDmp.resp_offset = 0;
+	pmb->context2 = ctx;
+	return;
+}
+
+/**
  * lpfc_read_nv: Prepare a mailbox command for reading HBA's NVRAM param.
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
@@ -1061,6 +1093,9 @@ lpfc_config_port(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	mb->un.varCfgPort.pcbLow = putPaddrLow(pdma_addr);
 	mb->un.varCfgPort.pcbHigh = putPaddrHigh(pdma_addr);
 
+	/* Always Host Group Pointer is in SLIM */
+	mb->un.varCfgPort.hps = 1;
+
 	/* If HBA supports SLI=3 ask for it */
 
 	if (phba->sli_rev == 3 && phba->vpd.sli3Feat.cerbm) {
--- a/drivers/scsi/lpfc/lpfc_nl.h
+++ b/drivers/scsi/lpfc/lpfc_nl.h
@@ -22,18 +22,20 @@
 #define FC_REG_LINK_EVENT		0x0001	/* link up / down events */
 #define FC_REG_RSCN_EVENT		0x0002	/* RSCN events */
 #define FC_REG_CT_EVENT			0x0004	/* CT request events */
-#define FC_REG_DUMP_EVENT		0x0008	/* Dump events */
-#define FC_REG_TEMPERATURE_EVENT	0x0010	/* temperature events */
-#define FC_REG_ELS_EVENT		0x0020	/* lpfc els events */
-#define FC_REG_FABRIC_EVENT		0x0040	/* lpfc fabric events */
-#define FC_REG_SCSI_EVENT		0x0080	/* lpfc scsi events */
-#define FC_REG_BOARD_EVENT		0x0100	/* lpfc board events */
-#define FC_REG_ADAPTER_EVENT		0x0200	/* lpfc adapter events */
+#define FC_REG_DUMP_EVENT		0x0010	/* Dump events */
+#define FC_REG_TEMPERATURE_EVENT	0x0020	/* temperature events */
+#define FC_REG_VPORTRSCN_EVENT		0x0040	/* Vport RSCN events */
+#define FC_REG_ELS_EVENT		0x0080	/* lpfc els events */
+#define FC_REG_FABRIC_EVENT		0x0100	/* lpfc fabric events */
+#define FC_REG_SCSI_EVENT		0x0200	/* lpfc scsi events */
+#define FC_REG_BOARD_EVENT		0x0400	/* lpfc board events */
+#define FC_REG_ADAPTER_EVENT		0x0800	/* lpfc adapter events */
 #define FC_REG_EVENT_MASK		(FC_REG_LINK_EVENT | \
 						FC_REG_RSCN_EVENT | \
 						FC_REG_CT_EVENT | \
 						FC_REG_DUMP_EVENT | \
 						FC_REG_TEMPERATURE_EVENT | \
+						FC_REG_VPORTRSCN_EVENT | \
 						FC_REG_ELS_EVENT | \
 						FC_REG_FABRIC_EVENT | \
 						FC_REG_SCSI_EVENT | \


