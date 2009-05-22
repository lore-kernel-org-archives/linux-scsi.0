From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 1/17] lpfc 8.3.2 : Reorganization for SLI4 - Part 1 of 3
Date: Fri, 22 May 2009 14:50:54 -0400
Message-ID: <1243018254.7729.39.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:41877 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbZEVSu5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 14:50:57 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n4MIowqR029593
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2009 11:50:58 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Reorganization for SLI4 - Part 1 of 3

Preps the organization of the driver so that the bottom half, which
interacts with the hardware, can share common code sequences for
attachment, detachment, initialization, teardown, etc with new hardware.

For very common code sections, which become specific to the interface
type, the driver uses an indirect function call. The function is set at
initialization. For less common sections, such as initialization, the
driver looks at the interface type and calls the routines relative to
the interface.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h         |   72 +-
 lpfc_debugfs.c |   17 
 lpfc_els.c     |    8 
 lpfc_hbadisc.c |   69 +
 lpfc_init.c    | 1981 ++++++++++++++++++++++++++++++++++++++++++---------------
 5 files changed, 1595 insertions(+), 552 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c	2009-05-19 09:39:27.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2009-05-22 13:14:13.000000000 -0400
@@ -280,6 +280,8 @@ lpfc_debugfs_hbqinfo_data(struct lpfc_hb
 	struct lpfc_dmabuf *d_buf;
 	struct hbq_dmabuf *hbq_buf;
 
+	if (phba->sli_rev != 3)
+		return 0;
 	cnt = LPFC_HBQINFO_SIZE;
 	spin_lock_irq(&phba->hbalock);
 
@@ -489,12 +491,15 @@ lpfc_debugfs_dumpHostSlim_data(struct lp
 				 pring->next_cmdidx, pring->local_getidx,
 				 pring->flag, pgpp->rspPutInx, pring->numRiocb);
 	}
-	word0 = readl(phba->HAregaddr);
-	word1 = readl(phba->CAregaddr);
-	word2 = readl(phba->HSregaddr);
-	word3 = readl(phba->HCregaddr);
-	len +=  snprintf(buf+len, size-len, "HA:%08x CA:%08x HS:%08x HC:%08x\n",
-	word0, word1, word2, word3);
+
+	if (phba->sli_rev <= LPFC_SLI_REV3) {
+		word0 = readl(phba->HAregaddr);
+		word1 = readl(phba->CAregaddr);
+		word2 = readl(phba->HSregaddr);
+		word3 = readl(phba->HCregaddr);
+		len +=  snprintf(buf+len, size-len, "HA:%08x CA:%08x HS:%08x "
+				 "HC:%08x\n", word0, word1, word2, word3);
+	}
 	spin_unlock_irq(&phba->hbalock);
 	return len;
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2009-05-19 09:39:27.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2009-05-22 13:14:13.000000000 -0400
@@ -84,7 +84,8 @@ lpfc_els_chk_latt(struct lpfc_vport *vpo
 	uint32_t ha_copy;
 
 	if (vport->port_state >= LPFC_VPORT_READY ||
-	    phba->link_state == LPFC_LINK_DOWN)
+	    phba->link_state == LPFC_LINK_DOWN ||
+	    phba->sli_rev > LPFC_SLI_REV3)
 		return 0;
 
 	/* Read the HBA Host Attention Register */
@@ -305,7 +306,7 @@ els_iocb_free_pcmb_exit:
  *   0 - successfully issued fabric registration login for @vport
  *   -ENXIO -- failed to issue fabric registration login for @vport
  **/
-static int
+int
 lpfc_issue_fabric_reglogin(struct lpfc_vport *vport)
 {
 	struct lpfc_hba  *phba = vport->phba;
@@ -345,8 +346,7 @@ lpfc_issue_fabric_reglogin(struct lpfc_v
 		err = 4;
 		goto fail;
 	}
-	rc = lpfc_reg_login(phba, vport->vpi, Fabric_DID, (uint8_t *)sp, mbox,
-			    0);
+	rc = lpfc_reg_rpi(phba, vport->vpi, Fabric_DID, (uint8_t *)sp, mbox, 0);
 	if (rc) {
 		err = 5;
 		goto fail_free_mbox;
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2009-05-19 09:39:27.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2009-05-22 13:14:13.000000000 -0400
@@ -23,6 +23,13 @@
 
 struct lpfc_sli2_slim;
 
+#define LPFC_PCI_DEV_LP		0x1
+#define LPFC_PCI_DEV_OC		0x2
+
+#define LPFC_SLI_REV2		2
+#define LPFC_SLI_REV3		3
+#define LPFC_SLI_REV4		4
+
 #define LPFC_MAX_TARGET		4096	/* max number of targets supported */
 #define LPFC_MAX_DISC_THREADS	64	/* max outstanding discovery els
 					   requests */
@@ -264,8 +271,8 @@ enum hba_state {
 };
 
 struct lpfc_vport {
-	struct list_head listentry;
 	struct lpfc_hba *phba;
+	struct list_head listentry;
 	uint8_t port_type;
 #define LPFC_PHYSICAL_PORT 1
 #define LPFC_NPIV_PORT  2
@@ -420,8 +427,66 @@ enum intr_type_t {
 };
 
 struct lpfc_hba {
+	/* SCSI interface function jump table entries */
+	int (*lpfc_new_scsi_buf)
+		(struct lpfc_vport *, int);
+	struct lpfc_scsi_buf * (*lpfc_get_scsi_buf)
+		(struct lpfc_hba *);
+	int (*lpfc_scsi_prep_dma_buf)
+		(struct lpfc_hba *, struct lpfc_scsi_buf *);
+	void (*lpfc_scsi_unprep_dma_buf)
+		(struct lpfc_hba *, struct lpfc_scsi_buf *);
+	void (*lpfc_release_scsi_buf)
+		(struct lpfc_hba *, struct lpfc_scsi_buf *);
+	void (*lpfc_rampdown_queue_depth)
+		(struct lpfc_hba *);
+	void (*lpfc_scsi_prep_cmnd)
+		(struct lpfc_vport *, struct lpfc_scsi_buf *,
+		 struct lpfc_nodelist *);
+	int (*lpfc_scsi_prep_task_mgmt_cmd)
+		(struct lpfc_vport *, struct lpfc_scsi_buf *,
+		 unsigned int, uint8_t);
+
+	/* IOCB interface function jump table entries */
+	int (*__lpfc_sli_issue_iocb)
+		(struct lpfc_hba *, uint32_t,
+		 struct lpfc_iocbq *, uint32_t);
+	void (*__lpfc_sli_release_iocbq)(struct lpfc_hba *,
+			 struct lpfc_iocbq *);
+	int (*lpfc_hba_down_post)(struct lpfc_hba *phba);
+
+
+	IOCB_t * (*lpfc_get_iocb_from_iocbq)
+		(struct lpfc_iocbq *);
+	void (*lpfc_scsi_cmd_iocb_cmpl)
+		(struct lpfc_hba *, struct lpfc_iocbq *, struct lpfc_iocbq *);
+
+	/* MBOX interface function jump table entries */
+	int (*lpfc_sli_issue_mbox)
+		(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t);
+	/* Slow-path IOCB process function jump table entries */
+	void (*lpfc_sli_handle_slow_ring_event)
+		(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
+		 uint32_t mask);
+	/* INIT device interface function jump table entries */
+	int (*lpfc_sli_hbq_to_firmware)
+		(struct lpfc_hba *, uint32_t, struct hbq_dmabuf *);
+	int (*lpfc_sli_brdrestart)
+		(struct lpfc_hba *);
+	int (*lpfc_sli_brdready)
+		(struct lpfc_hba *, uint32_t);
+	void (*lpfc_handle_eratt)
+		(struct lpfc_hba *);
+	void (*lpfc_stop_port)
+		(struct lpfc_hba *);
+
+
+	/* SLI4 specific HBA data structure */
+	struct lpfc_sli4_hba sli4_hba;
+
 	struct lpfc_sli sli;
-	uint32_t sli_rev;		/* SLI2 or SLI3 */
+	uint8_t pci_dev_grp;	/* lpfc PCI dev group: 0x0, 0x1, 0x2,... */
+	uint32_t sli_rev;		/* SLI2, SLI3, or SLI4 */
 	uint32_t sli3_options;		/* Mask of enabled SLI3 options */
 #define LPFC_SLI3_HBQ_ENABLED		0x01
 #define LPFC_SLI3_NPIV_ENABLED		0x02
@@ -526,11 +591,12 @@ struct lpfc_hba {
 	unsigned long data_flags;
 
 	uint32_t hbq_in_use;		/* HBQs in use flag */
-	struct list_head hbqbuf_in_list;  /* in-fly hbq buffer list */
+	struct list_head rb_pend_list;  /* Received buffers to be processed */
 	uint32_t hbq_count;	        /* Count of configured HBQs */
 	struct hbq_s hbqs[LPFC_MAX_HBQS]; /* local copy of hbq indicies  */
 
 	unsigned long pci_bar0_map;     /* Physical address for PCI BAR0 */
+	unsigned long pci_bar1_map;     /* Physical address for PCI BAR1 */
 	unsigned long pci_bar2_map;     /* Physical address for PCI BAR2 */
 	void __iomem *slim_memmap_p;	/* Kernel memory mapped address for
 					   PCI BAR0 */
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2009-05-19 09:39:27.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2009-05-22 13:14:13.000000000 -0400
@@ -555,23 +555,24 @@ lpfc_work_done(struct lpfc_hba *phba)
 		/*
 		 * Turn on Ring interrupts
 		 */
-		spin_lock_irq(&phba->hbalock);
-		control = readl(phba->HCregaddr);
-		if (!(control & (HC_R0INT_ENA << LPFC_ELS_RING))) {
-			lpfc_debugfs_slow_ring_trc(phba,
-				"WRK Enable ring: cntl:x%x hacopy:x%x",
-				control, ha_copy, 0);
-
-			control |= (HC_R0INT_ENA << LPFC_ELS_RING);
-			writel(control, phba->HCregaddr);
-			readl(phba->HCregaddr); /* flush */
-		}
-		else {
-			lpfc_debugfs_slow_ring_trc(phba,
-				"WRK Ring ok:     cntl:x%x hacopy:x%x",
-				control, ha_copy, 0);
+		if (phba->sli_rev <= LPFC_SLI_REV3) {
+			spin_lock_irq(&phba->hbalock);
+			control = readl(phba->HCregaddr);
+			if (!(control & (HC_R0INT_ENA << LPFC_ELS_RING))) {
+				lpfc_debugfs_slow_ring_trc(phba,
+					"WRK Enable ring: cntl:x%x hacopy:x%x",
+					control, ha_copy, 0);
+
+				control |= (HC_R0INT_ENA << LPFC_ELS_RING);
+				writel(control, phba->HCregaddr);
+				readl(phba->HCregaddr); /* flush */
+			} else {
+				lpfc_debugfs_slow_ring_trc(phba,
+					"WRK Ring ok:     cntl:x%x hacopy:x%x",
+					control, ha_copy, 0);
+			}
+			spin_unlock_irq(&phba->hbalock);
 		}
-		spin_unlock_irq(&phba->hbalock);
 	}
 	lpfc_work_list_done(phba);
 }
@@ -689,7 +690,7 @@ lpfc_port_link_failure(struct lpfc_vport
 	lpfc_can_disctmo(vport);
 }
 
-static void
+void
 lpfc_linkdown_port(struct lpfc_vport *vport)
 {
 	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
@@ -1147,10 +1148,12 @@ lpfc_enable_la(struct lpfc_hba *phba)
 	struct lpfc_sli *psli = &phba->sli;
 	spin_lock_irq(&phba->hbalock);
 	psli->sli_flag |= LPFC_PROCESS_LA;
-	control = readl(phba->HCregaddr);
-	control |= HC_LAINT_ENA;
-	writel(control, phba->HCregaddr);
-	readl(phba->HCregaddr); /* flush */
+	if (phba->sli_rev <= LPFC_SLI_REV3) {
+		control = readl(phba->HCregaddr);
+		control |= HC_LAINT_ENA;
+		writel(control, phba->HCregaddr);
+		readl(phba->HCregaddr); /* flush */
+	}
 	spin_unlock_irq(&phba->hbalock);
 }
 
@@ -2919,11 +2922,13 @@ restart_disc:
 		 * set port_state to PORT_READY if SLI2.
 		 * cmpl_reg_vpi will set port_state to READY for SLI3.
 		 */
-		if (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED)
-			lpfc_issue_reg_vpi(phba, vport);
-		else  {	/* NPIV Not enabled */
-			lpfc_issue_clear_la(phba, vport);
-			vport->port_state = LPFC_VPORT_READY;
+		if (phba->sli_rev < LPFC_SLI_REV4) {
+			if (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED)
+				lpfc_issue_reg_vpi(phba, vport);
+			else  {	/* NPIV Not enabled */
+				lpfc_issue_clear_la(phba, vport);
+				vport->port_state = LPFC_VPORT_READY;
+			}
 		}
 
 		/* Setup and issue mailbox INITIALIZE LINK command */
@@ -2959,11 +2964,13 @@ restart_disc:
 		 * set port_state to PORT_READY if SLI2.
 		 * cmpl_reg_vpi will set port_state to READY for SLI3.
 		 */
-		if (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED)
-			lpfc_issue_reg_vpi(phba, vport);
-		else {	/* NPIV Not enabled */
-			lpfc_issue_clear_la(phba, vport);
-			vport->port_state = LPFC_VPORT_READY;
+		if (phba->sli_rev < LPFC_SLI_REV4) {
+			if (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED)
+				lpfc_issue_reg_vpi(phba, vport);
+			else  {	/* NPIV Not enabled */
+				lpfc_issue_clear_la(phba, vport);
+				vport->port_state = LPFC_VPORT_READY;
+			}
 		}
 		break;
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2009-05-19 09:39:27.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2009-05-22 13:14:13.000000000 -0400
@@ -571,16 +571,20 @@ lpfc_hba_down_prep(struct lpfc_hba *phba
 {
 	struct lpfc_vport **vports;
 	int i;
-	/* Disable interrupts */
-	writel(0, phba->HCregaddr);
-	readl(phba->HCregaddr); /* flush */
+
+	if (phba->sli_rev <= LPFC_SLI_REV3) {
+		/* Disable interrupts */
+		writel(0, phba->HCregaddr);
+		readl(phba->HCregaddr); /* flush */
+	}
 
 	if (phba->pport->load_flag & FC_UNLOADING)
 		lpfc_cleanup_discovery_resources(phba->pport);
 	else {
 		vports = lpfc_create_vport_work_array(phba);
 		if (vports != NULL)
-			for(i = 0; i <= phba->max_vpi && vports[i] != NULL; i++)
+			for (i = 0; i <= phba->max_vports &&
+				vports[i] != NULL; i++)
 				lpfc_cleanup_discovery_resources(vports[i]);
 		lpfc_destroy_vport_work_array(phba, vports);
 	}
@@ -588,7 +592,7 @@ lpfc_hba_down_prep(struct lpfc_hba *phba
 }
 
 /**
- * lpfc_hba_down_post - Perform lpfc uninitialization after HBA reset
+ * lpfc_hba_down_post_s3 - Perform lpfc uninitialization after HBA reset
  * @phba: pointer to lpfc HBA data structure.
  *
  * This routine will do uninitialization after the HBA is reset when bring
@@ -598,8 +602,8 @@ lpfc_hba_down_prep(struct lpfc_hba *phba
  *   0 - sucess.
  *   Any other value - error.
  **/
-int
-lpfc_hba_down_post(struct lpfc_hba *phba)
+static int
+lpfc_hba_down_post_s3(struct lpfc_hba *phba)
 {
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring *pring;
@@ -909,13 +913,30 @@ lpfc_handle_deferred_eratt(struct lpfc_h
 	if ((!phba->work_hs) && (!(phba->pport->load_flag & FC_UNLOADING)))
 		phba->work_hs = old_host_status & ~HS_FFER1;
 
+	spin_lock_irq(&phba->hbalock);
 	phba->hba_flag &= ~DEFER_ERATT;
+	spin_unlock_irq(&phba->hbalock);
 	phba->work_status[0] = readl(phba->MBslimaddr + 0xa8);
 	phba->work_status[1] = readl(phba->MBslimaddr + 0xac);
 }
 
+static void
+lpfc_board_errevt_to_mgmt(struct lpfc_hba *phba)
+{
+	struct lpfc_board_event_header board_event;
+	struct Scsi_Host *shost;
+
+	board_event.event_type = FC_REG_BOARD_EVENT;
+	board_event.subcategory = LPFC_EVENT_PORTINTERR;
+	shost = lpfc_shost_from_vport(phba->pport);
+	fc_host_post_vendor_event(shost, fc_get_event_number(),
+				  sizeof(board_event),
+				  (char *) &board_event,
+				  LPFC_NL_VENDOR_ID);
+}
+
 /**
- * lpfc_handle_eratt - The HBA hardware error handler
+ * lpfc_handle_eratt_s3 - The SLI3 HBA hardware error handler
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to handle the following HBA hardware error
@@ -924,8 +945,8 @@ lpfc_handle_deferred_eratt(struct lpfc_h
  * 2 - DMA ring index out of range
  * 3 - Mailbox command came back as unknown
  **/
-void
-lpfc_handle_eratt(struct lpfc_hba *phba)
+static void
+lpfc_handle_eratt_s3(struct lpfc_hba *phba)
 {
 	struct lpfc_vport *vport = phba->pport;
 	struct lpfc_sli   *psli = &phba->sli;
@@ -934,24 +955,23 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
 	unsigned long temperature;
 	struct temp_event temp_event_data;
 	struct Scsi_Host  *shost;
-	struct lpfc_board_event_header board_event;
 
 	/* If the pci channel is offline, ignore possible errors,
-	 * since we cannot communicate with the pci card anyway. */
-	if (pci_channel_offline(phba->pcidev))
+	 * since we cannot communicate with the pci card anyway.
+	 */
+	if (pci_channel_offline(phba->pcidev)) {
+		spin_lock_irq(&phba->hbalock);
+		phba->hba_flag &= ~DEFER_ERATT;
+		spin_unlock_irq(&phba->hbalock);
 		return;
+	}
+
 	/* If resets are disabled then leave the HBA alone and return */
 	if (!phba->cfg_enable_hba_reset)
 		return;
 
 	/* Send an internal error event to mgmt application */
-	board_event.event_type = FC_REG_BOARD_EVENT;
-	board_event.subcategory = LPFC_EVENT_PORTINTERR;
-	shost = lpfc_shost_from_vport(phba->pport);
-	fc_host_post_vendor_event(shost, fc_get_event_number(),
-				  sizeof(board_event),
-				  (char *) &board_event,
-				  LPFC_NL_VENDOR_ID);
+	lpfc_board_errevt_to_mgmt(phba);
 
 	if (phba->hba_flag & DEFER_ERATT)
 		lpfc_handle_deferred_eratt(phba);
@@ -1137,7 +1157,7 @@ lpfc_handle_latt_err_exit:
  *   0 - pointer to the VPD passed in is NULL
  *   1 - success
  **/
-static int
+int
 lpfc_parse_vpd(struct lpfc_hba *phba, uint8_t *vpd, int len)
 {
 	uint8_t lenlo, lenhi;
@@ -1533,7 +1553,8 @@ lpfc_post_buffer(struct lpfc_hba *phba, 
 		icmd->ulpCommand = CMD_QUE_RING_BUF64_CN;
 		icmd->ulpLe = 1;
 
-		if (lpfc_sli_issue_iocb(phba, pring, iocb, 0) == IOCB_ERROR) {
+		if (lpfc_sli_issue_iocb(phba, pring->ringno, iocb, 0) ==
+		    IOCB_ERROR) {
 			lpfc_mbuf_free(phba, mp1->virt, mp1->phys);
 			kfree(mp1);
 			cnt++;
@@ -1761,7 +1782,6 @@ lpfc_cleanup(struct lpfc_vport *vport)
 	 * Lets wait for this to happen, if needed.
 	 */
 	while (!list_empty(&vport->fc_nodes)) {
-
 		if (i++ > 3000) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
 				"0233 Nodelist not empty\n");
@@ -1782,7 +1802,6 @@ lpfc_cleanup(struct lpfc_vport *vport)
 		/* Wait for any activity on ndlps to settle */
 		msleep(10);
 	}
-	return;
 }
 
 /**
@@ -1803,22 +1822,36 @@ lpfc_stop_vport_timers(struct lpfc_vport
 }
 
 /**
- * lpfc_stop_phba_timers - Stop all the timers associated with an HBA
+ * lpfc_stop_hba_timers - Stop all the timers associated with an HBA
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine stops all the timers associated with a HBA. This function is
  * invoked before either putting a HBA offline or unloading the driver.
  **/
-static void
-lpfc_stop_phba_timers(struct lpfc_hba *phba)
+void
+lpfc_stop_hba_timers(struct lpfc_hba *phba)
 {
-	del_timer_sync(&phba->fcp_poll_timer);
 	lpfc_stop_vport_timers(phba->pport);
 	del_timer_sync(&phba->sli.mbox_tmo);
 	del_timer_sync(&phba->fabric_block_timer);
-	phba->hb_outstanding = 0;
-	del_timer_sync(&phba->hb_tmofunc);
 	del_timer_sync(&phba->eratt_poll);
+	del_timer_sync(&phba->hb_tmofunc);
+	phba->hb_outstanding = 0;
+
+	switch (phba->pci_dev_grp) {
+	case LPFC_PCI_DEV_LP:
+		/* Stop any LightPulse device specific driver timers */
+		del_timer_sync(&phba->fcp_poll_timer);
+		break;
+	case LPFC_PCI_DEV_OC:
+		/* Stop any OneConnect device sepcific driver timers */
+		break;
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0297 Invalid device group (x%x)\n",
+				phba->pci_dev_grp);
+		break;
+	}
 	return;
 }
 
@@ -2509,9 +2542,8 @@ lpfc_disable_msi(struct lpfc_hba *phba)
  *
  * This routine it invoked to log the currently used active interrupt mode
  * to the device.
- */
-static void
-lpfc_log_intr_mode(struct lpfc_hba *phba, uint32_t intr_mode)
+ **/
+static void lpfc_log_intr_mode(struct lpfc_hba *phba, uint32_t intr_mode)
 {
 	switch (intr_mode) {
 	case 0:
@@ -2534,293 +2566,380 @@ lpfc_log_intr_mode(struct lpfc_hba *phba
 	return;
 }
 
-static void
-lpfc_stop_port(struct lpfc_hba *phba)
-{
-	/* Clear all interrupt enable conditions */
-	writel(0, phba->HCregaddr);
-	readl(phba->HCregaddr); /* flush */
-	/* Clear all pending interrupts */
-	writel(0xffffffff, phba->HAregaddr);
-	readl(phba->HAregaddr); /* flush */
-
-	/* Reset some HBA SLI setup states */
-	lpfc_stop_phba_timers(phba);
-	phba->pport->work_port_events = 0;
-
-	return;
-}
-
 /**
- * lpfc_enable_intr - Enable device interrupt
+ * lpfc_enable_pci_dev - Enable a generic PCI device.
  * @phba: pointer to lpfc hba data structure.
  *
- * This routine is invoked to enable device interrupt and associate driver's
- * interrupt handler(s) to interrupt vector(s). Depends on the interrupt
- * mode configured to the driver, the driver will try to fallback from the
- * configured interrupt mode to an interrupt mode which is supported by the
- * platform, kernel, and device in the order of: MSI-X -> MSI -> IRQ.
+ * This routine is invoked to enable the PCI device that is common to all
+ * PCI devices.
  *
  * Return codes
- *   0 - sucessful
- *   other values - error
+ * 	0 - sucessful
+ * 	other values - error
  **/
-static uint32_t
-lpfc_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
+static int
+lpfc_enable_pci_dev(struct lpfc_hba *phba)
 {
-	uint32_t intr_mode = LPFC_INTR_ERROR;
-	int retval;
+	struct pci_dev *pdev;
+	int bars;
 
-	if (cfg_mode == 2) {
-		/* Need to issue conf_port mbox cmd before conf_msi mbox cmd */
-		retval = lpfc_sli_config_port(phba, 3);
-		if (!retval) {
-			/* Now, try to enable MSI-X interrupt mode */
-			retval = lpfc_enable_msix(phba);
-			if (!retval) {
-				/* Indicate initialization to MSI-X mode */
-				phba->intr_type = MSIX;
-				intr_mode = 2;
-			}
-		}
-	}
+	/* Obtain PCI device reference */
+	if (!phba->pcidev)
+		goto out_error;
+	else
+		pdev = phba->pcidev;
+	/* Select PCI BARs */
+	bars = pci_select_bars(pdev, IORESOURCE_MEM);
+	/* Enable PCI device */
+	if (pci_enable_device_mem(pdev))
+		goto out_error;
+	/* Request PCI resource for the device */
+	if (pci_request_selected_regions(pdev, bars, LPFC_DRIVER_NAME))
+		goto out_disable_device;
+	/* Set up device as PCI master and save state for EEH */
+	pci_set_master(pdev);
+	pci_try_set_mwi(pdev);
+	pci_save_state(pdev);
 
-	/* Fallback to MSI if MSI-X initialization failed */
-	if (cfg_mode >= 1 && phba->intr_type == NONE) {
-		retval = lpfc_enable_msi(phba);
-		if (!retval) {
-			/* Indicate initialization to MSI mode */
-			phba->intr_type = MSI;
-			intr_mode = 1;
-		}
-	}
+	return 0;
 
-	/* Fallback to INTx if both MSI-X/MSI initalization failed */
-	if (phba->intr_type == NONE) {
-		retval = request_irq(phba->pcidev->irq, lpfc_intr_handler,
-				     IRQF_SHARED, LPFC_DRIVER_NAME, phba);
-		if (!retval) {
-			/* Indicate initialization to INTx mode */
-			phba->intr_type = INTx;
-			intr_mode = 0;
-		}
-	}
-	return intr_mode;
+out_disable_device:
+	pci_disable_device(pdev);
+out_error:
+	return -ENODEV;
 }
 
 /**
- * lpfc_disable_intr - Disable device interrupt
+ * lpfc_disable_pci_dev - Disable a generic PCI device.
  * @phba: pointer to lpfc hba data structure.
  *
- * This routine is invoked to disable device interrupt and disassociate the
- * driver's interrupt handler(s) from interrupt vector(s). Depending on the
- * interrupt mode, the driver will release the interrupt vector(s) for the
- * message signaled interrupt.
+ * This routine is invoked to disable the PCI device that is common to all
+ * PCI devices.
  **/
 static void
-lpfc_disable_intr(struct lpfc_hba *phba)
+lpfc_disable_pci_dev(struct lpfc_hba *phba)
 {
-	/* Disable the currently initialized interrupt mode */
-	if (phba->intr_type == MSIX)
-		lpfc_disable_msix(phba);
-	else if (phba->intr_type == MSI)
-		lpfc_disable_msi(phba);
-	else if (phba->intr_type == INTx)
-		free_irq(phba->pcidev->irq, phba);
+	struct pci_dev *pdev;
+	int bars;
 
-	/* Reset interrupt management states */
-	phba->intr_type = NONE;
-	phba->sli.slistat.sli_intr = 0;
+	/* Obtain PCI device reference */
+	if (!phba->pcidev)
+		return;
+	else
+		pdev = phba->pcidev;
+	/* Select PCI BARs */
+	bars = pci_select_bars(pdev, IORESOURCE_MEM);
+	/* Release PCI resource and disable PCI device */
+	pci_release_selected_regions(pdev, bars);
+	pci_disable_device(pdev);
+	/* Null out PCI private reference to driver */
+	pci_set_drvdata(pdev, NULL);
 
 	return;
 }
 
 /**
- * lpfc_pci_probe_one - lpfc PCI probe func to register device to PCI subsystem
- * @pdev: pointer to PCI device
- * @pid: pointer to PCI device identifier
- *
- * This routine is to be registered to the kernel's PCI subsystem. When an
- * Emulex HBA is presented in PCI bus, the kernel PCI subsystem looks at
- * PCI device-specific information of the device and driver to see if the
- * driver state that it can support this kind of device. If the match is
- * successful, the driver core invokes this routine. If this routine
- * determines it can claim the HBA, it does all the initialization that it
- * needs to do to handle the HBA properly.
+ * lpfc_reset_hba - Reset a hba
+ * @phba: pointer to lpfc hba data structure.
  *
- * Return code
- *   0 - driver can claim the device
- *   negative value - driver can not claim the device
+ * This routine is invoked to reset a hba device. It brings the HBA
+ * offline, performs a board restart, and then brings the board back
+ * online. The lpfc_offline calls lpfc_sli_hba_down which will clean up
+ * on outstanding mailbox commands.
  **/
-static int __devinit
-lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
+void
+lpfc_reset_hba(struct lpfc_hba *phba)
 {
-	struct lpfc_vport *vport = NULL;
-	struct lpfc_hba   *phba;
-	struct lpfc_sli   *psli;
-	struct lpfc_iocbq *iocbq_entry = NULL, *iocbq_next = NULL;
-	struct Scsi_Host  *shost = NULL;
-	void *ptr;
-	unsigned long bar0map_len, bar2map_len;
-	int error = -ENODEV, retval;
-	int  i, hbq_count;
-	uint16_t iotag;
-	uint32_t cfg_mode, intr_mode;
-	int bars = pci_select_bars(pdev, IORESOURCE_MEM);
-	struct lpfc_adapter_event_header adapter_event;
-
-	if (pci_enable_device_mem(pdev))
-		goto out;
-	if (pci_request_selected_regions(pdev, bars, LPFC_DRIVER_NAME))
-		goto out_disable_device;
-
-	phba = kzalloc(sizeof (struct lpfc_hba), GFP_KERNEL);
-	if (!phba)
-		goto out_release_regions;
-
-	atomic_set(&phba->fast_event_count, 0);
-	spin_lock_init(&phba->hbalock);
-
-	/* Initialize ndlp management spinlock */
-	spin_lock_init(&phba->ndlp_lock);
-
-	phba->pcidev = pdev;
+	/* If resets are disabled then set error state and return. */
+	if (!phba->cfg_enable_hba_reset) {
+		phba->link_state = LPFC_HBA_ERROR;
+		return;
+	}
+	lpfc_offline_prep(phba);
+	lpfc_offline(phba);
+	lpfc_sli_brdrestart(phba);
+	lpfc_online(phba);
+	lpfc_unblock_mgmt_io(phba);
+}
 
-	/* Assign an unused board number */
-	if ((phba->brd_no = lpfc_get_instance()) < 0)
-		goto out_free_phba;
+/**
+ * lpfc_sli_driver_resource_setup - Setup driver internal resources for SLI3 dev.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to set up the driver internal resources specific to
+ * support the SLI-3 HBA device it attached to.
+ *
+ * Return codes
+ * 	0 - sucessful
+ * 	other values - error
+ **/
+static int
+lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
+{
+	struct lpfc_sli *psli;
 
-	INIT_LIST_HEAD(&phba->port_list);
-	init_waitqueue_head(&phba->wait_4_mlo_m_q);
 	/*
-	 * Get all the module params for configuring this host and then
-	 * establish the host.
+	 * Initialize timers used by driver
 	 */
-	lpfc_get_cfgparam(phba);
-	phba->max_vpi = LPFC_MAX_VPI;
 
-	/* Initialize timers used by driver */
+	/* Heartbeat timer */
 	init_timer(&phba->hb_tmofunc);
 	phba->hb_tmofunc.function = lpfc_hb_timeout;
 	phba->hb_tmofunc.data = (unsigned long)phba;
 
 	psli = &phba->sli;
+	/* MBOX heartbeat timer */
 	init_timer(&psli->mbox_tmo);
 	psli->mbox_tmo.function = lpfc_mbox_timeout;
 	psli->mbox_tmo.data = (unsigned long) phba;
+	/* FCP polling mode timer */
 	init_timer(&phba->fcp_poll_timer);
 	phba->fcp_poll_timer.function = lpfc_poll_timeout;
 	phba->fcp_poll_timer.data = (unsigned long) phba;
+	/* Fabric block timer */
 	init_timer(&phba->fabric_block_timer);
 	phba->fabric_block_timer.function = lpfc_fabric_block_timeout;
 	phba->fabric_block_timer.data = (unsigned long) phba;
+	/* EA polling mode timer */
 	init_timer(&phba->eratt_poll);
 	phba->eratt_poll.function = lpfc_poll_eratt;
 	phba->eratt_poll.data = (unsigned long) phba;
 
-	pci_set_master(pdev);
-	pci_save_state(pdev);
-	pci_try_set_mwi(pdev);
-
-	if (pci_set_dma_mask(phba->pcidev, DMA_BIT_MASK(64)) != 0)
-		if (pci_set_dma_mask(phba->pcidev, DMA_BIT_MASK(32)) != 0)
-			goto out_idr_remove;
+	/* Host attention work mask setup */
+	phba->work_ha_mask = (HA_ERATT | HA_MBATT | HA_LATT);
+	phba->work_ha_mask |= (HA_RXMASK << (LPFC_ELS_RING * 4));
 
+	/* Get all the module params for configuring this host */
+	lpfc_get_cfgparam(phba);
 	/*
-	 * Get the bus address of Bar0 and Bar2 and the number of bytes
-	 * required by each mapping.
+	 * Since the sg_tablesize is module parameter, the sg_dma_buf_size
+	 * used to create the sg_dma_buf_pool must be dynamically calculated.
+	 * 2 segments are added since the IOCB needs a command and response bde.
 	 */
-	phba->pci_bar0_map = pci_resource_start(phba->pcidev, 0);
-	bar0map_len        = pci_resource_len(phba->pcidev, 0);
-
-	phba->pci_bar2_map = pci_resource_start(phba->pcidev, 2);
-	bar2map_len        = pci_resource_len(phba->pcidev, 2);
-
-	/* Map HBA SLIM to a kernel virtual address. */
-	phba->slim_memmap_p = ioremap(phba->pci_bar0_map, bar0map_len);
-	if (!phba->slim_memmap_p) {
-		error = -ENODEV;
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "ioremap failed for SLIM memory.\n");
-		goto out_idr_remove;
-	}
-
-	/* Map HBA Control Registers to a kernel virtual address. */
-	phba->ctrl_regs_memmap_p = ioremap(phba->pci_bar2_map, bar2map_len);
-	if (!phba->ctrl_regs_memmap_p) {
-		error = -ENODEV;
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "ioremap failed for HBA control registers.\n");
-		goto out_iounmap_slim;
-	}
-
-	/* Allocate memory for SLI-2 structures */
-	phba->slim2p.virt = dma_alloc_coherent(&phba->pcidev->dev,
-					       SLI2_SLIM_SIZE,
-					       &phba->slim2p.phys,
-					       GFP_KERNEL);
-	if (!phba->slim2p.virt)
-		goto out_iounmap;
-
-	memset(phba->slim2p.virt, 0, SLI2_SLIM_SIZE);
-	phba->mbox = phba->slim2p.virt + offsetof(struct lpfc_sli2_slim, mbx);
-	phba->pcb = (phba->slim2p.virt + offsetof(struct lpfc_sli2_slim, pcb));
-	phba->IOCBs = (phba->slim2p.virt +
-		       offsetof(struct lpfc_sli2_slim, IOCBs));
-
-	phba->hbqslimp.virt = dma_alloc_coherent(&phba->pcidev->dev,
-						 lpfc_sli_hbq_size(),
-						 &phba->hbqslimp.phys,
-						 GFP_KERNEL);
-	if (!phba->hbqslimp.virt)
-		goto out_free_slim;
-
-	hbq_count = lpfc_sli_hbq_count();
-	ptr = phba->hbqslimp.virt;
-	for (i = 0; i < hbq_count; ++i) {
-		phba->hbqs[i].hbq_virt = ptr;
-		INIT_LIST_HEAD(&phba->hbqs[i].hbq_buffer_list);
-		ptr += (lpfc_hbq_defs[i]->entry_count *
-			sizeof(struct lpfc_hbq_entry));
+	phba->cfg_sg_dma_buf_size = sizeof(struct fcp_cmnd) +
+		sizeof(struct fcp_rsp) +
+			((phba->cfg_sg_seg_cnt + 2) * sizeof(struct ulp_bde64));
+
+	if (phba->cfg_enable_bg) {
+		phba->cfg_sg_seg_cnt = LPFC_MAX_SG_SEG_CNT;
+		phba->cfg_sg_dma_buf_size +=
+			phba->cfg_prot_sg_seg_cnt * sizeof(struct ulp_bde64);
 	}
-	phba->hbqs[LPFC_ELS_HBQ].hbq_alloc_buffer = lpfc_els_hbq_alloc;
-	phba->hbqs[LPFC_ELS_HBQ].hbq_free_buffer  = lpfc_els_hbq_free;
 
-	memset(phba->hbqslimp.virt, 0, lpfc_sli_hbq_size());
+	/* Also reinitialize the host templates with new values. */
+	lpfc_vport_template.sg_tablesize = phba->cfg_sg_seg_cnt;
+	lpfc_template.sg_tablesize = phba->cfg_sg_seg_cnt;
 
-	INIT_LIST_HEAD(&phba->hbqbuf_in_list);
+	phba->max_vpi = LPFC_MAX_VPI;
+	/* This will be set to correct value after config_port mbox */
+	phba->max_vports = 0;
 
-	/* Initialize the SLI Layer to run with lpfc HBAs. */
+	/*
+	 * Initialize the SLI Layer to run with lpfc HBAs.
+	 */
 	lpfc_sli_setup(phba);
 	lpfc_sli_queue_setup(phba);
 
-	retval = lpfc_mem_alloc(phba);
-	if (retval) {
-		error = retval;
-		goto out_free_hbqslimp;
-	}
+	/* Allocate device driver memory */
+	if (lpfc_mem_alloc(phba, BPL_ALIGN_SZ))
+		return -ENOMEM;
 
-	/* Initialize and populate the iocb list per host.  */
-	INIT_LIST_HEAD(&phba->lpfc_iocb_list);
-	for (i = 0; i < LPFC_IOCB_LIST_CNT; i++) {
-		iocbq_entry = kzalloc(sizeof(struct lpfc_iocbq), GFP_KERNEL);
-		if (iocbq_entry == NULL) {
-			printk(KERN_ERR "%s: only allocated %d iocbs of "
-				"expected %d count. Unloading driver.\n",
-				__func__, i, LPFC_IOCB_LIST_CNT);
-			error = -ENOMEM;
-			goto out_free_iocbq;
-		}
+	return 0;
+}
 
-		iotag = lpfc_sli_next_iotag(phba, iocbq_entry);
+/**
+ * lpfc_sli_driver_resource_unset - Unset drvr internal resources for SLI3 dev
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to unset the driver internal resources set up
+ * specific for supporting the SLI-3 HBA device it attached to.
+ **/
+static void
+lpfc_sli_driver_resource_unset(struct lpfc_hba *phba)
+{
+	/* Free device driver memory allocated */
+	lpfc_mem_free_all(phba);
+
+	return;
+}
+
+/**
+ * lpfc_init_api_table_setup - Set up init api fucntion jump table
+ * @phba: The hba struct for which this call is being executed.
+ * @dev_grp: The HBA PCI-Device group number.
+ *
+ * This routine sets up the device INIT interface API function jump table
+ * in @phba struct.
+ *
+ * Returns: 0 - success, -ENODEV - failure.
+ **/
+int
+lpfc_init_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
+{
+	switch (dev_grp) {
+	case LPFC_PCI_DEV_LP:
+		phba->lpfc_hba_down_post = lpfc_hba_down_post_s3;
+		phba->lpfc_handle_eratt = lpfc_handle_eratt_s3;
+		phba->lpfc_stop_port = lpfc_stop_port_s3;
+		break;
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1431 Invalid HBA PCI-device group: 0x%x\n",
+				dev_grp);
+		return -ENODEV;
+		break;
+	}
+	return 0;
+}
+
+/**
+ * lpfc_setup_driver_resource_phase1 - Phase1 etup driver internal resources.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to set up the driver internal resources before the
+ * device specific resource setup to support the HBA device it attached to.
+ *
+ * Return codes
+ *	0 - sucessful
+ *	other values - error
+ **/
+static int
+lpfc_setup_driver_resource_phase1(struct lpfc_hba *phba)
+{
+	/*
+	 * Driver resources common to all SLI revisions
+	 */
+	atomic_set(&phba->fast_event_count, 0);
+	spin_lock_init(&phba->hbalock);
+
+	/* Initialize ndlp management spinlock */
+	spin_lock_init(&phba->ndlp_lock);
+
+	INIT_LIST_HEAD(&phba->port_list);
+	INIT_LIST_HEAD(&phba->work_list);
+	init_waitqueue_head(&phba->wait_4_mlo_m_q);
+
+	/* Initialize the wait queue head for the kernel thread */
+	init_waitqueue_head(&phba->work_waitq);
+
+	/* Initialize the scsi buffer list used by driver for scsi IO */
+	spin_lock_init(&phba->scsi_buf_list_lock);
+	INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list);
+
+	/* Initialize the fabric iocb list */
+	INIT_LIST_HEAD(&phba->fabric_iocb_list);
+
+	/* Initialize list to save ELS buffers */
+	INIT_LIST_HEAD(&phba->elsbuf);
+
+	/* Initialize FCF connection rec list */
+	INIT_LIST_HEAD(&phba->fcf_conn_rec_list);
+
+	return 0;
+}
+
+/**
+ * lpfc_setup_driver_resource_phase2 - Phase2 setup driver internal resources.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to set up the driver internal resources after the
+ * device specific resource setup to support the HBA device it attached to.
+ *
+ * Return codes
+ * 	0 - sucessful
+ * 	other values - error
+ **/
+static int
+lpfc_setup_driver_resource_phase2(struct lpfc_hba *phba)
+{
+	int error;
+
+	/* Startup the kernel thread for this host adapter. */
+	phba->worker_thread = kthread_run(lpfc_do_work, phba,
+					  "lpfc_worker_%d", phba->brd_no);
+	if (IS_ERR(phba->worker_thread)) {
+		error = PTR_ERR(phba->worker_thread);
+		return error;
+	}
+
+	return 0;
+}
+
+/**
+ * lpfc_unset_driver_resource_phase2 - Phase2 unset driver internal resources.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to unset the driver internal resources set up after
+ * the device specific resource setup for supporting the HBA device it
+ * attached to.
+ **/
+static void
+lpfc_unset_driver_resource_phase2(struct lpfc_hba *phba)
+{
+	/* Stop kernel worker thread */
+	kthread_stop(phba->worker_thread);
+}
+
+/**
+ * lpfc_free_iocb_list - Free iocb list.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to free the driver's IOCB list and memory.
+ **/
+static void
+lpfc_free_iocb_list(struct lpfc_hba *phba)
+{
+	struct lpfc_iocbq *iocbq_entry = NULL, *iocbq_next = NULL;
+
+	spin_lock_irq(&phba->hbalock);
+	list_for_each_entry_safe(iocbq_entry, iocbq_next,
+				 &phba->lpfc_iocb_list, list) {
+		list_del(&iocbq_entry->list);
+		kfree(iocbq_entry);
+		phba->total_iocbq_bufs--;
+	}
+	spin_unlock_irq(&phba->hbalock);
+
+	return;
+}
+
+/**
+ * lpfc_init_iocb_list - Allocate and initialize iocb list.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to allocate and initizlize the driver's IOCB
+ * list and set up the IOCB tag array accordingly.
+ *
+ * Return codes
+ *	0 - sucessful
+ *	other values - error
+ **/
+static int
+lpfc_init_iocb_list(struct lpfc_hba *phba, int iocb_count)
+{
+	struct lpfc_iocbq *iocbq_entry = NULL;
+	uint16_t iotag;
+	int i;
+
+	/* Initialize and populate the iocb list per host.  */
+	INIT_LIST_HEAD(&phba->lpfc_iocb_list);
+	for (i = 0; i < iocb_count; i++) {
+		iocbq_entry = kzalloc(sizeof(struct lpfc_iocbq), GFP_KERNEL);
+		if (iocbq_entry == NULL) {
+			printk(KERN_ERR "%s: only allocated %d iocbs of "
+				"expected %d count. Unloading driver.\n",
+				__func__, i, LPFC_IOCB_LIST_CNT);
+			goto out_free_iocbq;
+		}
+
+		iotag = lpfc_sli_next_iotag(phba, iocbq_entry);
 		if (iotag == 0) {
-			kfree (iocbq_entry);
+			kfree(iocbq_entry);
 			printk(KERN_ERR "%s: failed to allocate IOTAG. "
-			       "Unloading driver.\n",
-				__func__);
-			error = -ENOMEM;
+				"Unloading driver.\n", __func__);
 			goto out_free_iocbq;
 		}
+		iocbq_entry->sli4_xritag = NO_XRI;
 
 		spin_lock_irq(&phba->hbalock);
 		list_add(&iocbq_entry->list, &phba->lpfc_iocb_list);
@@ -2828,71 +2947,799 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 		spin_unlock_irq(&phba->hbalock);
 	}
 
-	/* Initialize HBA structure */
-	phba->fc_edtov = FF_DEF_EDTOV;
-	phba->fc_ratov = FF_DEF_RATOV;
-	phba->fc_altov = FF_DEF_ALTOV;
-	phba->fc_arbtov = FF_DEF_ARBTOV;
+	return 0;
 
-	INIT_LIST_HEAD(&phba->work_list);
-	phba->work_ha_mask = (HA_ERATT | HA_MBATT | HA_LATT);
-	phba->work_ha_mask |= (HA_RXMASK << (LPFC_ELS_RING * 4));
+out_free_iocbq:
+	lpfc_free_iocb_list(phba);
 
-	/* Initialize the wait queue head for the kernel thread */
-	init_waitqueue_head(&phba->work_waitq);
+	return -ENOMEM;
+}
 
-	/* Startup the kernel thread for this host adapter. */
-	phba->worker_thread = kthread_run(lpfc_do_work, phba,
-				       "lpfc_worker_%d", phba->brd_no);
-	if (IS_ERR(phba->worker_thread)) {
-		error = PTR_ERR(phba->worker_thread);
-		goto out_free_iocbq;
+/**
+ * lpfc_hba_alloc - Allocate driver hba data structure for a device.
+ * @pdev: pointer to pci device data structure.
+ *
+ * This routine is invoked to allocate the driver hba data structure for an
+ * HBA device. If the allocation is successful, the phba reference to the
+ * PCI device data structure is set.
+ *
+ * Return codes
+ *      pointer to @phba - sucessful
+ *      NULL - error
+ **/
+static struct lpfc_hba *
+lpfc_hba_alloc(struct pci_dev *pdev)
+{
+	struct lpfc_hba *phba;
+
+	/* Allocate memory for HBA structure */
+	phba = kzalloc(sizeof(struct lpfc_hba), GFP_KERNEL);
+	if (!phba) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1417 Failed to allocate hba struct.\n");
+		return NULL;
 	}
 
-	/* Initialize the list of scsi buffers used by driver for scsi IO. */
-	spin_lock_init(&phba->scsi_buf_list_lock);
-	INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list);
+	/* Set reference to PCI device in HBA structure */
+	phba->pcidev = pdev;
 
-	/* Initialize list of fabric iocbs */
-	INIT_LIST_HEAD(&phba->fabric_iocb_list);
+	/* Assign an unused board number */
+	phba->brd_no = lpfc_get_instance();
+	if (phba->brd_no < 0) {
+		kfree(phba);
+		return NULL;
+	}
 
-	/* Initialize list to save ELS buffers */
-	INIT_LIST_HEAD(&phba->elsbuf);
+	return phba;
+}
+
+/**
+ * lpfc_hba_free - Free driver hba data structure with a device.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to free the driver hba data structure with an
+ * HBA device.
+ **/
+static void
+lpfc_hba_free(struct lpfc_hba *phba)
+{
+	/* Release the driver assigned board number */
+	idr_remove(&lpfc_hba_index, phba->brd_no);
+
+	kfree(phba);
+	return;
+}
+
+/**
+ * lpfc_create_shost - Create hba physical port with associated scsi host.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to create HBA physical port and associate a SCSI
+ * host with it.
+ *
+ * Return codes
+ *      0 - sucessful
+ *      other values - error
+ **/
+static int
+lpfc_create_shost(struct lpfc_hba *phba)
+{
+	struct lpfc_vport *vport;
+	struct Scsi_Host  *shost;
+
+	/* Initialize HBA FC structure */
+	phba->fc_edtov = FF_DEF_EDTOV;
+	phba->fc_ratov = FF_DEF_RATOV;
+	phba->fc_altov = FF_DEF_ALTOV;
+	phba->fc_arbtov = FF_DEF_ARBTOV;
 
 	vport = lpfc_create_port(phba, phba->brd_no, &phba->pcidev->dev);
 	if (!vport)
-		goto out_kthread_stop;
+		return -ENODEV;
 
 	shost = lpfc_shost_from_vport(vport);
 	phba->pport = vport;
 	lpfc_debugfs_initialize(vport);
+	/* Put reference to SCSI host to driver's device private data */
+	pci_set_drvdata(phba->pcidev, shost);
 
-	pci_set_drvdata(pdev, shost);
+	return 0;
+}
 
-	phba->MBslimaddr = phba->slim_memmap_p;
-	phba->HAregaddr = phba->ctrl_regs_memmap_p + HA_REG_OFFSET;
-	phba->CAregaddr = phba->ctrl_regs_memmap_p + CA_REG_OFFSET;
-	phba->HSregaddr = phba->ctrl_regs_memmap_p + HS_REG_OFFSET;
-	phba->HCregaddr = phba->ctrl_regs_memmap_p + HC_REG_OFFSET;
+/**
+ * lpfc_destroy_shost - Destroy hba physical port with associated scsi host.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to destroy HBA physical port and the associated
+ * SCSI host.
+ **/
+static void
+lpfc_destroy_shost(struct lpfc_hba *phba)
+{
+	struct lpfc_vport *vport = phba->pport;
+
+	/* Destroy physical port that associated with the SCSI host */
+	destroy_port(vport);
+
+	return;
+}
+
+/**
+ * lpfc_setup_bg - Setup Block guard structures and debug areas.
+ * @phba: pointer to lpfc hba data structure.
+ * @shost: the shost to be used to detect Block guard settings.
+ *
+ * This routine sets up the local Block guard protocol settings for @shost.
+ * This routine also allocates memory for debugging bg buffers.
+ **/
+static void
+lpfc_setup_bg(struct lpfc_hba *phba, struct Scsi_Host *shost)
+{
+	int pagecnt = 10;
+	if (lpfc_prot_mask && lpfc_prot_guard) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"1478 Registering BlockGuard with the "
+				"SCSI layer\n");
+		scsi_host_set_prot(shost, lpfc_prot_mask);
+		scsi_host_set_guard(shost, lpfc_prot_guard);
+	}
+	if (!_dump_buf_data) {
+		while (pagecnt) {
+			spin_lock_init(&_dump_buf_lock);
+			_dump_buf_data =
+				(char *) __get_free_pages(GFP_KERNEL, pagecnt);
+			if (_dump_buf_data) {
+				printk(KERN_ERR "BLKGRD allocated %d pages for "
+				       "_dump_buf_data at 0x%p\n",
+				       (1 << pagecnt), _dump_buf_data);
+				_dump_buf_data_order = pagecnt;
+				memset(_dump_buf_data, 0,
+				       ((1 << PAGE_SHIFT) << pagecnt));
+				break;
+			} else
+				--pagecnt;
+		}
+		if (!_dump_buf_data_order)
+			printk(KERN_ERR "BLKGRD ERROR unable to allocate "
+			       "memory for hexdump\n");
+	} else
+		printk(KERN_ERR "BLKGRD already allocated _dump_buf_data=0x%p"
+		       "\n", _dump_buf_data);
+	if (!_dump_buf_dif) {
+		while (pagecnt) {
+			_dump_buf_dif =
+				(char *) __get_free_pages(GFP_KERNEL, pagecnt);
+			if (_dump_buf_dif) {
+				printk(KERN_ERR "BLKGRD allocated %d pages for "
+				       "_dump_buf_dif at 0x%p\n",
+				       (1 << pagecnt), _dump_buf_dif);
+				_dump_buf_dif_order = pagecnt;
+				memset(_dump_buf_dif, 0,
+				       ((1 << PAGE_SHIFT) << pagecnt));
+				break;
+			} else
+				--pagecnt;
+		}
+		if (!_dump_buf_dif_order)
+			printk(KERN_ERR "BLKGRD ERROR unable to allocate "
+			       "memory for hexdump\n");
+	} else
+		printk(KERN_ERR "BLKGRD already allocated _dump_buf_dif=0x%p\n",
+		       _dump_buf_dif);
+}
+
+/**
+ * lpfc_post_init_setup - Perform necessary device post initialization setup.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to perform all the necessary post initialization
+ * setup for the device.
+ **/
+static void
+lpfc_post_init_setup(struct lpfc_hba *phba)
+{
+	struct Scsi_Host  *shost;
+	struct lpfc_adapter_event_header adapter_event;
+
+	/* Get the default values for Model Name and Description */
+	lpfc_get_hba_model_desc(phba, phba->ModelName, phba->ModelDesc);
+
+	/*
+	 * hba setup may have changed the hba_queue_depth so we need to
+	 * adjust the value of can_queue.
+	 */
+	shost = pci_get_drvdata(phba->pcidev);
+	shost->can_queue = phba->cfg_hba_queue_depth - 10;
+	if (phba->sli3_options & LPFC_SLI3_BG_ENABLED)
+		lpfc_setup_bg(phba, shost);
+
+	lpfc_host_attrib_init(shost);
+
+	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
+		spin_lock_irq(shost->host_lock);
+		lpfc_poll_start_timer(phba);
+		spin_unlock_irq(shost->host_lock);
+	}
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"0428 Perform SCSI scan\n");
+	/* Send board arrival event to upper layer */
+	adapter_event.event_type = FC_REG_ADAPTER_EVENT;
+	adapter_event.subcategory = LPFC_EVENT_ARRIVAL;
+	fc_host_post_vendor_event(shost, fc_get_event_number(),
+				  sizeof(adapter_event),
+				  (char *) &adapter_event,
+				  LPFC_NL_VENDOR_ID);
+	return;
+}
+
+/**
+ * lpfc_sli_pci_mem_setup - Setup SLI3 HBA PCI memory space.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to set up the PCI device memory space for device
+ * with SLI-3 interface spec.
+ *
+ * Return codes
+ * 	0 - sucessful
+ * 	other values - error
+ **/
+static int
+lpfc_sli_pci_mem_setup(struct lpfc_hba *phba)
+{
+	struct pci_dev *pdev;
+	unsigned long bar0map_len, bar2map_len;
+	int i, hbq_count;
+	void *ptr;
+	int error = -ENODEV;
+
+	/* Obtain PCI device reference */
+	if (!phba->pcidev)
+		return error;
+	else
+		pdev = phba->pcidev;
+
+	/* Set the device DMA mask size */
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) != 0)
+		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0)
+			return error;
+
+	/* Get the bus address of Bar0 and Bar2 and the number of bytes
+	 * required by each mapping.
+	 */
+	phba->pci_bar0_map = pci_resource_start(pdev, 0);
+	bar0map_len = pci_resource_len(pdev, 0);
+
+	phba->pci_bar2_map = pci_resource_start(pdev, 2);
+	bar2map_len = pci_resource_len(pdev, 2);
+
+	/* Map HBA SLIM to a kernel virtual address. */
+	phba->slim_memmap_p = ioremap(phba->pci_bar0_map, bar0map_len);
+	if (!phba->slim_memmap_p) {
+		dev_printk(KERN_ERR, &pdev->dev,
+			   "ioremap failed for SLIM memory.\n");
+		goto out;
+	}
+
+	/* Map HBA Control Registers to a kernel virtual address. */
+	phba->ctrl_regs_memmap_p = ioremap(phba->pci_bar2_map, bar2map_len);
+	if (!phba->ctrl_regs_memmap_p) {
+		dev_printk(KERN_ERR, &pdev->dev,
+			   "ioremap failed for HBA control registers.\n");
+		goto out_iounmap_slim;
+	}
+
+	/* Allocate memory for SLI-2 structures */
+	phba->slim2p.virt = dma_alloc_coherent(&pdev->dev,
+					       SLI2_SLIM_SIZE,
+					       &phba->slim2p.phys,
+					       GFP_KERNEL);
+	if (!phba->slim2p.virt)
+		goto out_iounmap;
+
+	memset(phba->slim2p.virt, 0, SLI2_SLIM_SIZE);
+	phba->mbox = phba->slim2p.virt + offsetof(struct lpfc_sli2_slim, mbx);
+	phba->pcb = (phba->slim2p.virt + offsetof(struct lpfc_sli2_slim, pcb));
+	phba->IOCBs = (phba->slim2p.virt +
+		       offsetof(struct lpfc_sli2_slim, IOCBs));
+
+	phba->hbqslimp.virt = dma_alloc_coherent(&pdev->dev,
+						 lpfc_sli_hbq_size(),
+						 &phba->hbqslimp.phys,
+						 GFP_KERNEL);
+	if (!phba->hbqslimp.virt)
+		goto out_free_slim;
+
+	hbq_count = lpfc_sli_hbq_count();
+	ptr = phba->hbqslimp.virt;
+	for (i = 0; i < hbq_count; ++i) {
+		phba->hbqs[i].hbq_virt = ptr;
+		INIT_LIST_HEAD(&phba->hbqs[i].hbq_buffer_list);
+		ptr += (lpfc_hbq_defs[i]->entry_count *
+			sizeof(struct lpfc_hbq_entry));
+	}
+	phba->hbqs[LPFC_ELS_HBQ].hbq_alloc_buffer = lpfc_els_hbq_alloc;
+	phba->hbqs[LPFC_ELS_HBQ].hbq_free_buffer = lpfc_els_hbq_free;
+
+	memset(phba->hbqslimp.virt, 0, lpfc_sli_hbq_size());
+
+	INIT_LIST_HEAD(&phba->rb_pend_list);
+
+	phba->MBslimaddr = phba->slim_memmap_p;
+	phba->HAregaddr = phba->ctrl_regs_memmap_p + HA_REG_OFFSET;
+	phba->CAregaddr = phba->ctrl_regs_memmap_p + CA_REG_OFFSET;
+	phba->HSregaddr = phba->ctrl_regs_memmap_p + HS_REG_OFFSET;
+	phba->HCregaddr = phba->ctrl_regs_memmap_p + HC_REG_OFFSET;
+
+	return 0;
+
+out_free_slim:
+	dma_free_coherent(&pdev->dev, SLI2_SLIM_SIZE,
+			  phba->slim2p.virt, phba->slim2p.phys);
+out_iounmap:
+	iounmap(phba->ctrl_regs_memmap_p);
+out_iounmap_slim:
+	iounmap(phba->slim_memmap_p);
+out:
+	return error;
+}
+
+/**
+ * lpfc_sli_pci_mem_unset - Unset SLI3 HBA PCI memory space.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to unset the PCI device memory space for device
+ * with SLI-3 interface spec.
+ **/
+static void
+lpfc_sli_pci_mem_unset(struct lpfc_hba *phba)
+{
+	struct pci_dev *pdev;
+
+	/* Obtain PCI device reference */
+	if (!phba->pcidev)
+		return;
+	else
+		pdev = phba->pcidev;
+
+	/* Free coherent DMA memory allocated */
+	dma_free_coherent(&pdev->dev, lpfc_sli_hbq_size(),
+			  phba->hbqslimp.virt, phba->hbqslimp.phys);
+	dma_free_coherent(&pdev->dev, SLI2_SLIM_SIZE,
+			  phba->slim2p.virt, phba->slim2p.phys);
+
+	/* I/O memory unmap */
+	iounmap(phba->ctrl_regs_memmap_p);
+	iounmap(phba->slim_memmap_p);
+
+	return;
+}
+
+/**
+ * lpfc_sli_enable_msix - Enable MSI-X interrupt mode on SLI-3 device
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to enable the MSI-X interrupt vectors to device
+ * with SLI-3 interface specs. The kernel function pci_enable_msix() is
+ * called to enable the MSI-X vectors. Note that pci_enable_msix(), once
+ * invoked, enables either all or nothing, depending on the current
+ * availability of PCI vector resources. The device driver is responsible
+ * for calling the individual request_irq() to register each MSI-X vector
+ * with a interrupt handler, which is done in this function. Note that
+ * later when device is unloading, the driver should always call free_irq()
+ * on all MSI-X vectors it has done request_irq() on before calling
+ * pci_disable_msix(). Failure to do so results in a BUG_ON() and a device
+ * will be left with MSI-X enabled and leaks its vectors.
+ *
+ * Return codes
+ *   0 - sucessful
+ *   other values - error
+ **/
+static int
+lpfc_sli_enable_msix(struct lpfc_hba *phba)
+{
+	int rc, i;
+	LPFC_MBOXQ_t *pmb;
+
+	/* Set up MSI-X multi-message vectors */
+	for (i = 0; i < LPFC_MSIX_VECTORS; i++)
+		phba->msix_entries[i].entry = i;
+
+	/* Configure MSI-X capability structure */
+	rc = pci_enable_msix(phba->pcidev, phba->msix_entries,
+				ARRAY_SIZE(phba->msix_entries));
+	if (rc) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"0420 PCI enable MSI-X failed (%d)\n", rc);
+		goto msi_fail_out;
+	}
+	for (i = 0; i < LPFC_MSIX_VECTORS; i++)
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"0477 MSI-X entry[%d]: vector=x%x "
+				"message=%d\n", i,
+				phba->msix_entries[i].vector,
+				phba->msix_entries[i].entry);
+	/*
+	 * Assign MSI-X vectors to interrupt handlers
+	 */
+
+	/* vector-0 is associated to slow-path handler */
+	rc = request_irq(phba->msix_entries[0].vector,
+			 &lpfc_sli_sp_intr_handler, IRQF_SHARED,
+			 LPFC_SP_DRIVER_HANDLER_NAME, phba);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"0421 MSI-X slow-path request_irq failed "
+				"(%d)\n", rc);
+		goto msi_fail_out;
+	}
+
+	/* vector-1 is associated to fast-path handler */
+	rc = request_irq(phba->msix_entries[1].vector,
+			 &lpfc_sli_fp_intr_handler, IRQF_SHARED,
+			 LPFC_FP_DRIVER_HANDLER_NAME, phba);
+
+	if (rc) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"0429 MSI-X fast-path request_irq failed "
+				"(%d)\n", rc);
+		goto irq_fail_out;
+	}
+
+	/*
+	 * Configure HBA MSI-X attention conditions to messages
+	 */
+	pmb = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+
+	if (!pmb) {
+		rc = -ENOMEM;
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0474 Unable to allocate memory for issuing "
+				"MBOX_CONFIG_MSI command\n");
+		goto mem_fail_out;
+	}
+	rc = lpfc_config_msi(phba, pmb);
+	if (rc)
+		goto mbx_fail_out;
+	rc = lpfc_sli_issue_mbox(phba, pmb, MBX_POLL);
+	if (rc != MBX_SUCCESS) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX,
+				"0351 Config MSI mailbox command failed, "
+				"mbxCmd x%x, mbxStatus x%x\n",
+				pmb->u.mb.mbxCommand, pmb->u.mb.mbxStatus);
+		goto mbx_fail_out;
+	}
+
+	/* Free memory allocated for mailbox command */
+	mempool_free(pmb, phba->mbox_mem_pool);
+	return rc;
+
+mbx_fail_out:
+	/* Free memory allocated for mailbox command */
+	mempool_free(pmb, phba->mbox_mem_pool);
+
+mem_fail_out:
+	/* free the irq already requested */
+	free_irq(phba->msix_entries[1].vector, phba);
+
+irq_fail_out:
+	/* free the irq already requested */
+	free_irq(phba->msix_entries[0].vector, phba);
+
+msi_fail_out:
+	/* Unconfigure MSI-X capability structure */
+	pci_disable_msix(phba->pcidev);
+	return rc;
+}
+
+/**
+ * lpfc_sli_disable_msix - Disable MSI-X interrupt mode on SLI-3 device.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to release the MSI-X vectors and then disable the
+ * MSI-X interrupt mode to device with SLI-3 interface spec.
+ **/
+static void
+lpfc_sli_disable_msix(struct lpfc_hba *phba)
+{
+	int i;
+
+	/* Free up MSI-X multi-message vectors */
+	for (i = 0; i < LPFC_MSIX_VECTORS; i++)
+		free_irq(phba->msix_entries[i].vector, phba);
+	/* Disable MSI-X */
+	pci_disable_msix(phba->pcidev);
+
+	return;
+}
+
+/**
+ * lpfc_sli_enable_msi - Enable MSI interrupt mode on SLI-3 device.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to enable the MSI interrupt mode to device with
+ * SLI-3 interface spec. The kernel function pci_enable_msi() is called to
+ * enable the MSI vector. The device driver is responsible for calling the
+ * request_irq() to register MSI vector with a interrupt the handler, which
+ * is done in this function.
+ *
+ * Return codes
+ * 	0 - sucessful
+ * 	other values - error
+ */
+static int
+lpfc_sli_enable_msi(struct lpfc_hba *phba)
+{
+	int rc;
+
+	rc = pci_enable_msi(phba->pcidev);
+	if (!rc)
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"0462 PCI enable MSI mode success.\n");
+	else {
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"0471 PCI enable MSI mode failed (%d)\n", rc);
+		return rc;
+	}
+
+	rc = request_irq(phba->pcidev->irq, lpfc_sli_intr_handler,
+			 IRQF_SHARED, LPFC_DRIVER_NAME, phba);
+	if (rc) {
+		pci_disable_msi(phba->pcidev);
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"0478 MSI request_irq failed (%d)\n", rc);
+	}
+	return rc;
+}
+
+/**
+ * lpfc_sli_disable_msi - Disable MSI interrupt mode to SLI-3 device.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to disable the MSI interrupt mode to device with
+ * SLI-3 interface spec. The driver calls free_irq() on MSI vector it has
+ * done request_irq() on before calling pci_disable_msi(). Failure to do so
+ * results in a BUG_ON() and a device will be left with MSI enabled and leaks
+ * its vector.
+ */
+static void
+lpfc_sli_disable_msi(struct lpfc_hba *phba)
+{
+	free_irq(phba->pcidev->irq, phba);
+	pci_disable_msi(phba->pcidev);
+	return;
+}
+
+/**
+ * lpfc_sli_enable_intr - Enable device interrupt to SLI-3 device.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to enable device interrupt and associate driver's
+ * interrupt handler(s) to interrupt vector(s) to device with SLI-3 interface
+ * spec. Depends on the interrupt mode configured to the driver, the driver
+ * will try to fallback from the configured interrupt mode to an interrupt
+ * mode which is supported by the platform, kernel, and device in the order
+ * of:
+ * MSI-X -> MSI -> IRQ.
+ *
+ * Return codes
+ *   0 - sucessful
+ *   other values - error
+ **/
+static uint32_t
+lpfc_sli_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
+{
+	uint32_t intr_mode = LPFC_INTR_ERROR;
+	int retval;
+
+	if (cfg_mode == 2) {
+		/* Need to issue conf_port mbox cmd before conf_msi mbox cmd */
+		retval = lpfc_sli_config_port(phba, LPFC_SLI_REV3);
+		if (!retval) {
+			/* Now, try to enable MSI-X interrupt mode */
+			retval = lpfc_sli_enable_msix(phba);
+			if (!retval) {
+				/* Indicate initialization to MSI-X mode */
+				phba->intr_type = MSIX;
+				intr_mode = 2;
+			}
+		}
+	}
+
+	/* Fallback to MSI if MSI-X initialization failed */
+	if (cfg_mode >= 1 && phba->intr_type == NONE) {
+		retval = lpfc_sli_enable_msi(phba);
+		if (!retval) {
+			/* Indicate initialization to MSI mode */
+			phba->intr_type = MSI;
+			intr_mode = 1;
+		}
+	}
+
+	/* Fallback to INTx if both MSI-X/MSI initalization failed */
+	if (phba->intr_type == NONE) {
+		retval = request_irq(phba->pcidev->irq, lpfc_sli_intr_handler,
+				     IRQF_SHARED, LPFC_DRIVER_NAME, phba);
+		if (!retval) {
+			/* Indicate initialization to INTx mode */
+			phba->intr_type = INTx;
+			intr_mode = 0;
+		}
+	}
+	return intr_mode;
+}
+
+/**
+ * lpfc_sli_disable_intr - Disable device interrupt to SLI-3 device.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to disable device interrupt and disassociate the
+ * driver's interrupt handler(s) from interrupt vector(s) to device with
+ * SLI-3 interface spec. Depending on the interrupt mode, the driver will
+ * release the interrupt vector(s) for the message signaled interrupt.
+ **/
+static void
+lpfc_sli_disable_intr(struct lpfc_hba *phba)
+{
+	/* Disable the currently initialized interrupt mode */
+	if (phba->intr_type == MSIX)
+		lpfc_sli_disable_msix(phba);
+	else if (phba->intr_type == MSI)
+		lpfc_sli_disable_msi(phba);
+	else if (phba->intr_type == INTx)
+		free_irq(phba->pcidev->irq, phba);
+
+	/* Reset interrupt management states */
+	phba->intr_type = NONE;
+	phba->sli.slistat.sli_intr = 0;
+
+	return;
+}
+
+/**
+ * lpfc_unset_hba - Unset SLI3 hba device initialization
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to unset the HBA device initialization steps to
+ * a device with SLI-3 interface spec.
+ **/
+static void
+lpfc_unset_hba(struct lpfc_hba *phba)
+{
+	struct lpfc_vport *vport = phba->pport;
+	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
+
+	spin_lock_irq(shost->host_lock);
+	vport->load_flag |= FC_UNLOADING;
+	spin_unlock_irq(shost->host_lock);
+
+	lpfc_stop_hba_timers(phba);
+
+	phba->pport->work_port_events = 0;
+
+	lpfc_sli_hba_down(phba);
+
+	lpfc_sli_brdrestart(phba);
+
+	lpfc_sli_disable_intr(phba);
+
+	return;
+}
+
+/**
+ * lpfc_pci_probe_one_s3 - PCI probe func to reg SLI-3 device to PCI subsystem.
+ * @pdev: pointer to PCI device
+ * @pid: pointer to PCI device identifier
+ *
+ * This routine is to be called to attach a device with SLI-3 interface spec
+ * to the PCI subsystem. When an Emulex HBA with SLI-3 interface spec is
+ * presented on PCI bus, the kernel PCI subsystem looks at PCI device-specific
+ * information of the device and driver to see if the driver state that it can
+ * support this kind of device. If the match is successful, the driver core
+ * invokes this routine. If this routine determines it can claim the HBA, it
+ * does all the initialization that it needs to do to handle the HBA properly.
+ *
+ * Return code
+ * 	0 - driver can claim the device
+ * 	negative value - driver can not claim the device
+ **/
+static int __devinit
+lpfc_pci_probe_one_s3(struct pci_dev *pdev, const struct pci_device_id *pid)
+{
+	struct lpfc_hba   *phba;
+	struct lpfc_vport *vport = NULL;
+	int error;
+	uint32_t cfg_mode, intr_mode;
+
+	/* Allocate memory for HBA structure */
+	phba = lpfc_hba_alloc(pdev);
+	if (!phba)
+		return -ENOMEM;
+
+	/* Perform generic PCI device enabling operation */
+	error = lpfc_enable_pci_dev(phba);
+	if (error) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1401 Failed to enable pci device.\n");
+		goto out_free_phba;
+	}
+
+	/* Set up SLI API function jump table for PCI-device group-0 HBAs */
+	error = lpfc_api_table_setup(phba, LPFC_PCI_DEV_LP);
+	if (error)
+		goto out_disable_pci_dev;
+
+	/* Set up SLI-3 specific device PCI memory space */
+	error = lpfc_sli_pci_mem_setup(phba);
+	if (error) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1402 Failed to set up pci memory space.\n");
+		goto out_disable_pci_dev;
+	}
+
+	/* Set up phase-1 common device driver resources */
+	error = lpfc_setup_driver_resource_phase1(phba);
+	if (error) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1403 Failed to set up driver resource.\n");
+		goto out_unset_pci_mem_s3;
+	}
+
+	/* Set up SLI-3 specific device driver resources */
+	error = lpfc_sli_driver_resource_setup(phba);
+	if (error) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1404 Failed to set up driver resource.\n");
+		goto out_unset_pci_mem_s3;
+	}
+
+	/* Initialize and populate the iocb list per host */
+	error = lpfc_init_iocb_list(phba, LPFC_IOCB_LIST_CNT);
+	if (error) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1405 Failed to initialize iocb list.\n");
+		goto out_unset_driver_resource_s3;
+	}
+
+	/* Set up common device driver resources */
+	error = lpfc_setup_driver_resource_phase2(phba);
+	if (error) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1406 Failed to set up driver resource.\n");
+		goto out_free_iocb_list;
+	}
+
+	/* Create SCSI host to the physical port */
+	error = lpfc_create_shost(phba);
+	if (error) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1407 Failed to create scsi host.\n");
+		goto out_unset_driver_resource;
+	}
 
 	/* Configure sysfs attributes */
-	if (lpfc_alloc_sysfs_attr(vport)) {
+	vport = phba->pport;
+	error = lpfc_alloc_sysfs_attr(vport);
+	if (error) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"1476 Failed to allocate sysfs attr\n");
-		error = -ENOMEM;
-		goto out_destroy_port;
+		goto out_destroy_shost;
 	}
 
+	/* Now, trying to enable interrupt and bring up the device */
 	cfg_mode = phba->cfg_use_msi;
 	while (true) {
+		/* Put device to a known state before enabling interrupt */
+		lpfc_stop_port(phba);
 		/* Configure and enable interrupt */
-		intr_mode = lpfc_enable_intr(phba, cfg_mode);
+		intr_mode = lpfc_sli_enable_intr(phba, cfg_mode);
 		if (intr_mode == LPFC_INTR_ERROR) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"0426 Failed to enable interrupt.\n");
+					"0431 Failed to enable interrupt.\n");
+			error = -ENODEV;
 			goto out_free_sysfs_attr;
 		}
-		/* HBA SLI setup */
+		/* SLI-3 HBA setup */
 		if (lpfc_sli_hba_setup(phba)) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"1477 Failed to set up hba\n");
@@ -2902,185 +3749,65 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 
 		/* Wait 50ms for the interrupts of previous mailbox commands */
 		msleep(50);
-		/* Check active interrupts received */
-		if (phba->sli.slistat.sli_intr > LPFC_MSIX_VECTORS) {
+		/* Check active interrupts on message signaled interrupts */
+		if (intr_mode == 0 ||
+		    phba->sli.slistat.sli_intr > LPFC_MSIX_VECTORS) {
 			/* Log the current active interrupt mode */
 			phba->intr_mode = intr_mode;
 			lpfc_log_intr_mode(phba, intr_mode);
 			break;
 		} else {
 			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-					"0451 Configure interrupt mode (%d) "
+					"0447 Configure interrupt mode (%d) "
 					"failed active interrupt test.\n",
 					intr_mode);
-			if (intr_mode == 0) {
-				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-						"0479 Failed to enable "
-						"interrupt.\n");
-				error = -ENODEV;
-				goto out_remove_device;
-			}
-			/* Stop HBA SLI setups */
-			lpfc_stop_port(phba);
 			/* Disable the current interrupt mode */
-			lpfc_disable_intr(phba);
+			lpfc_sli_disable_intr(phba);
 			/* Try next level of interrupt mode */
 			cfg_mode = --intr_mode;
 		}
 	}
 
-	/*
-	 * hba setup may have changed the hba_queue_depth so we need to adjust
-	 * the value of can_queue.
-	 */
-	shost->can_queue = phba->cfg_hba_queue_depth - 10;
-	if (phba->sli3_options & LPFC_SLI3_BG_ENABLED) {
-
-		if (lpfc_prot_mask && lpfc_prot_guard) {
-			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-					"1478 Registering BlockGuard with the "
-					"SCSI layer\n");
-
-			scsi_host_set_prot(shost, lpfc_prot_mask);
-			scsi_host_set_guard(shost, lpfc_prot_guard);
-		}
-	}
-
-	if (!_dump_buf_data) {
-		int pagecnt = 10;
-		while (pagecnt) {
-			spin_lock_init(&_dump_buf_lock);
-			_dump_buf_data =
-				(char *) __get_free_pages(GFP_KERNEL, pagecnt);
-			if (_dump_buf_data) {
-				printk(KERN_ERR "BLKGRD allocated %d pages for "
-						"_dump_buf_data at 0x%p\n",
-						(1 << pagecnt), _dump_buf_data);
-				_dump_buf_data_order = pagecnt;
-				memset(_dump_buf_data, 0, ((1 << PAGE_SHIFT)
-							   << pagecnt));
-				break;
-			} else {
-				--pagecnt;
-			}
-
-		}
-
-		if (!_dump_buf_data_order)
-			printk(KERN_ERR "BLKGRD ERROR unable to allocate "
-					"memory for hexdump\n");
-
-	} else {
-		printk(KERN_ERR "BLKGRD already allocated _dump_buf_data=0x%p"
-		       "\n", _dump_buf_data);
-	}
-
-
-	if (!_dump_buf_dif) {
-		int pagecnt = 10;
-		while (pagecnt) {
-			_dump_buf_dif =
-				(char *) __get_free_pages(GFP_KERNEL, pagecnt);
-			if (_dump_buf_dif) {
-				printk(KERN_ERR "BLKGRD allocated %d pages for "
-						"_dump_buf_dif at 0x%p\n",
-						(1 << pagecnt), _dump_buf_dif);
-				_dump_buf_dif_order = pagecnt;
-				memset(_dump_buf_dif, 0, ((1 << PAGE_SHIFT)
-							  << pagecnt));
-				break;
-			} else {
-				--pagecnt;
-			}
-
-		}
-
-		if (!_dump_buf_dif_order)
-			printk(KERN_ERR "BLKGRD ERROR unable to allocate "
-					"memory for hexdump\n");
-
-	} else {
-		printk(KERN_ERR "BLKGRD already allocated _dump_buf_dif=0x%p\n",
-				_dump_buf_dif);
-	}
-
-	lpfc_host_attrib_init(shost);
-
-	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
-		spin_lock_irq(shost->host_lock);
-		lpfc_poll_start_timer(phba);
-		spin_unlock_irq(shost->host_lock);
-	}
+	/* Perform post initialization setup */
+	lpfc_post_init_setup(phba);
 
-	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-			"0428 Perform SCSI scan\n");
-	/* Send board arrival event to upper layer */
-	adapter_event.event_type = FC_REG_ADAPTER_EVENT;
-	adapter_event.subcategory = LPFC_EVENT_ARRIVAL;
-	fc_host_post_vendor_event(shost, fc_get_event_number(),
-		sizeof(adapter_event),
-		(char *) &adapter_event,
-		LPFC_NL_VENDOR_ID);
+	/* Check if there are static vports to be created. */
+	lpfc_create_static_vport(phba);
 
 	return 0;
 
 out_remove_device:
-	spin_lock_irq(shost->host_lock);
-	vport->load_flag |= FC_UNLOADING;
-	spin_unlock_irq(shost->host_lock);
-	lpfc_stop_phba_timers(phba);
-	phba->pport->work_port_events = 0;
-	lpfc_disable_intr(phba);
-	lpfc_sli_hba_down(phba);
-	lpfc_sli_brdrestart(phba);
+	lpfc_unset_hba(phba);
 out_free_sysfs_attr:
 	lpfc_free_sysfs_attr(vport);
-out_destroy_port:
-	destroy_port(vport);
-out_kthread_stop:
-	kthread_stop(phba->worker_thread);
-out_free_iocbq:
-	list_for_each_entry_safe(iocbq_entry, iocbq_next,
-						&phba->lpfc_iocb_list, list) {
-		kfree(iocbq_entry);
-		phba->total_iocbq_bufs--;
-	}
-	lpfc_mem_free(phba);
-out_free_hbqslimp:
-	dma_free_coherent(&pdev->dev, lpfc_sli_hbq_size(),
-			  phba->hbqslimp.virt, phba->hbqslimp.phys);
-out_free_slim:
-	dma_free_coherent(&pdev->dev, SLI2_SLIM_SIZE,
-			  phba->slim2p.virt, phba->slim2p.phys);
-out_iounmap:
-	iounmap(phba->ctrl_regs_memmap_p);
-out_iounmap_slim:
-	iounmap(phba->slim_memmap_p);
-out_idr_remove:
-	idr_remove(&lpfc_hba_index, phba->brd_no);
+out_destroy_shost:
+	lpfc_destroy_shost(phba);
+out_unset_driver_resource:
+	lpfc_unset_driver_resource_phase2(phba);
+out_free_iocb_list:
+	lpfc_free_iocb_list(phba);
+out_unset_driver_resource_s3:
+	lpfc_sli_driver_resource_unset(phba);
+out_unset_pci_mem_s3:
+	lpfc_sli_pci_mem_unset(phba);
+out_disable_pci_dev:
+	lpfc_disable_pci_dev(phba);
 out_free_phba:
-	kfree(phba);
-out_release_regions:
-	pci_release_selected_regions(pdev, bars);
-out_disable_device:
-	pci_disable_device(pdev);
-out:
-	pci_set_drvdata(pdev, NULL);
-	if (shost)
-		scsi_host_put(shost);
+	lpfc_hba_free(phba);
 	return error;
 }
 
 /**
- * lpfc_pci_remove_one - lpfc PCI func to unregister device from PCI subsystem
+ * lpfc_pci_remove_one_s3 - PCI func to unreg SLI-3 device from PCI subsystem.
  * @pdev: pointer to PCI device
  *
- * This routine is to be registered to the kernel's PCI subsystem. When an
- * Emulex HBA is removed from PCI bus, it performs all the necessary cleanup
- * for the HBA device to be removed from the PCI subsystem properly.
+ * This routine is to be called to disattach a device with SLI-3 interface
+ * spec from PCI subsystem. When an Emulex HBA with SLI-3 interface spec is
+ * removed from PCI bus, it performs all the necessary cleanup for the HBA
+ * device to be removed from the PCI subsystem properly.
  **/
 static void __devexit
-lpfc_pci_remove_one(struct pci_dev *pdev)
+lpfc_pci_remove_one_s3(struct pci_dev *pdev)
 {
 	struct Scsi_Host  *shost = pci_get_drvdata(pdev);
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
@@ -3098,7 +3825,7 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 	/* Release all the vports against this physical port */
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
-		for (i = 1; i <= phba->max_vpi && vports[i] != NULL; i++)
+		for (i = 1; i <= phba->max_vports && vports[i] != NULL; i++)
 			fc_vport_terminate(vports[i]->fc_vport);
 	lpfc_destroy_vport_work_array(phba, vports);
 
@@ -3120,7 +3847,7 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 	/* Final cleanup of txcmplq and reset the HBA */
 	lpfc_sli_brdrestart(phba);
 
-	lpfc_stop_phba_timers(phba);
+	lpfc_stop_hba_timers(phba);
 	spin_lock_irq(&phba->hbalock);
 	list_del_init(&vport->listentry);
 	spin_unlock_irq(&phba->hbalock);
@@ -3128,7 +3855,7 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 	lpfc_debugfs_terminate(vport);
 
 	/* Disable interrupt */
-	lpfc_disable_intr(phba);
+	lpfc_sli_disable_intr(phba);
 
 	pci_set_drvdata(pdev, NULL);
 	scsi_host_put(shost);
@@ -3138,7 +3865,7 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 	 * corresponding pools here.
 	 */
 	lpfc_scsi_free(phba);
-	lpfc_mem_free(phba);
+	lpfc_mem_free_all(phba);
 
 	dma_free_coherent(&pdev->dev, lpfc_sli_hbq_size(),
 			  phba->hbqslimp.virt, phba->hbqslimp.phys);
@@ -3151,36 +3878,35 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 	iounmap(phba->ctrl_regs_memmap_p);
 	iounmap(phba->slim_memmap_p);
 
-	idr_remove(&lpfc_hba_index, phba->brd_no);
-
-	kfree(phba);
+	lpfc_hba_free(phba);
 
 	pci_release_selected_regions(pdev, bars);
 	pci_disable_device(pdev);
 }
 
 /**
- * lpfc_pci_suspend_one - lpfc PCI func to suspend device for power management
+ * lpfc_pci_suspend_one_s3 - PCI func to suspend SLI-3 device for power mgmnt
  * @pdev: pointer to PCI device
  * @msg: power management message
  *
- * This routine is to be registered to the kernel's PCI subsystem to support
- * system Power Management (PM). When PM invokes this method, it quiesces the
- * device by stopping the driver's worker thread for the device, turning off
- * device's interrupt and DMA, and bring the device offline. Note that as the
- * driver implements the minimum PM requirements to a power-aware driver's PM
- * support for suspend/resume -- all the possible PM messages (SUSPEND,
- * HIBERNATE, FREEZE) to the suspend() method call will be treated as SUSPEND
- * and the driver will fully reinitialize its device during resume() method
- * call, the driver will set device to PCI_D3hot state in PCI config space
- * instead of setting it according to the @msg provided by the PM.
+ * This routine is to be called from the kernel's PCI subsystem to support
+ * system Power Management (PM) to device with SLI-3 interface spec. When
+ * PM invokes this method, it quiesces the device by stopping the driver's
+ * worker thread for the device, turning off device's interrupt and DMA,
+ * and bring the device offline. Note that as the driver implements the
+ * minimum PM requirements to a power-aware driver's PM support for the
+ * suspend/resume -- all the possible PM messages (SUSPEND, HIBERNATE, FREEZE)
+ * to the suspend() method call will be treated as SUSPEND and the driver will
+ * fully reinitialize its device during resume() method call, the driver will
+ * set device to PCI_D3hot state in PCI config space instead of setting it
+ * according to the @msg provided by the PM.
  *
  * Return code
- *   0 - driver suspended the device
- *   Error otherwise
+ * 	0 - driver suspended the device
+ * 	Error otherwise
  **/
 static int
-lpfc_pci_suspend_one(struct pci_dev *pdev, pm_message_t msg)
+lpfc_pci_suspend_one_s3(struct pci_dev *pdev, pm_message_t msg)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
@@ -3194,7 +3920,7 @@ lpfc_pci_suspend_one(struct pci_dev *pde
 	kthread_stop(phba->worker_thread);
 
 	/* Disable interrupt from device */
-	lpfc_disable_intr(phba);
+	lpfc_sli_disable_intr(phba);
 
 	/* Save device state to PCI config space */
 	pci_save_state(pdev);
@@ -3204,25 +3930,26 @@ lpfc_pci_suspend_one(struct pci_dev *pde
 }
 
 /**
- * lpfc_pci_resume_one - lpfc PCI func to resume device for power management
+ * lpfc_pci_resume_one_s3 - PCI func to resume SLI-3 device for power mgmnt
  * @pdev: pointer to PCI device
  *
- * This routine is to be registered to the kernel's PCI subsystem to support
- * system Power Management (PM). When PM invokes this method, it restores
- * the device's PCI config space state and fully reinitializes the device
- * and brings it online. Note that as the driver implements the minimum PM
- * requirements to a power-aware driver's PM for suspend/resume -- all
- * the possible PM messages (SUSPEND, HIBERNATE, FREEZE) to the suspend()
- * method call will be treated as SUSPEND and the driver will fully
- * reinitialize its device during resume() method call, the device will be
- * set to PCI_D0 directly in PCI config space before restoring the state.
+ * This routine is to be called from the kernel's PCI subsystem to support
+ * system Power Management (PM) to device with SLI-3 interface spec. When PM
+ * invokes this method, it restores the device's PCI config space state and
+ * fully reinitializes the device and brings it online. Note that as the
+ * driver implements the minimum PM requirements to a power-aware driver's
+ * PM for suspend/resume -- all the possible PM messages (SUSPEND, HIBERNATE,
+ * FREEZE) to the suspend() method call will be treated as SUSPEND and the
+ * driver will fully reinitialize its device during resume() method call,
+ * the device will be set to PCI_D0 directly in PCI config space before
+ * restoring the state.
  *
  * Return code
- *   0 - driver suspended the device
- *   Error otherwise
+ * 	0 - driver suspended the device
+ * 	Error otherwise
  **/
 static int
-lpfc_pci_resume_one(struct pci_dev *pdev)
+lpfc_pci_resume_one_s3(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
@@ -3250,7 +3977,7 @@ lpfc_pci_resume_one(struct pci_dev *pdev
 	}
 
 	/* Configure and enable interrupt */
-	intr_mode = lpfc_enable_intr(phba, phba->intr_mode);
+	intr_mode = lpfc_sli_enable_intr(phba, phba->intr_mode);
 	if (intr_mode == LPFC_INTR_ERROR) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0430 PM resume Failed to enable interrupt\n");
@@ -3269,23 +3996,24 @@ lpfc_pci_resume_one(struct pci_dev *pdev
 }
 
 /**
- * lpfc_io_error_detected - Driver method for handling PCI I/O error detected
+ * lpfc_io_error_detected_s3 - Method for handling SLI-3 device PCI I/O error
  * @pdev: pointer to PCI device.
  * @state: the current PCI connection state.
  *
- * This routine is registered to the PCI subsystem for error handling. This
- * function is called by the PCI subsystem after a PCI bus error affecting
- * this device has been detected. When this function is invoked, it will
- * need to stop all the I/Os and interrupt(s) to the device. Once that is
- * done, it will return PCI_ERS_RESULT_NEED_RESET for the PCI subsystem to
- * perform proper recovery as desired.
+ * This routine is called from the PCI subsystem for I/O error handling to
+ * device with SLI-3 interface spec. This function is called by the PCI
+ * subsystem after a PCI bus error affecting this device has been detected.
+ * When this function is invoked, it will need to stop all the I/Os and
+ * interrupt(s) to the device. Once that is done, it will return
+ * PCI_ERS_RESULT_NEED_RESET for the PCI subsystem to perform proper recovery
+ * as desired.
  *
  * Return codes
- *   PCI_ERS_RESULT_NEED_RESET - need to reset before recovery
- *   PCI_ERS_RESULT_DISCONNECT - device could not be recovered
+ * 	PCI_ERS_RESULT_NEED_RESET - need to reset before recovery
+ * 	PCI_ERS_RESULT_DISCONNECT - device could not be recovered
  **/
-static pci_ers_result_t lpfc_io_error_detected(struct pci_dev *pdev,
-				pci_channel_state_t state)
+static pci_ers_result_t
+lpfc_io_error_detected_s3(struct pci_dev *pdev, pci_channel_state_t state)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
@@ -3312,30 +4040,32 @@ static pci_ers_result_t lpfc_io_error_de
 	lpfc_sli_abort_iocb_ring(phba, pring);
 
 	/* Disable interrupt */
-	lpfc_disable_intr(phba);
+	lpfc_sli_disable_intr(phba);
 
 	/* Request a slot reset. */
 	return PCI_ERS_RESULT_NEED_RESET;
 }
 
 /**
- * lpfc_io_slot_reset - Restart a PCI device from scratch
+ * lpfc_io_slot_reset_s3 - Method for restarting PCI SLI-3 device from scratch.
  * @pdev: pointer to PCI device.
  *
- * This routine is registered to the PCI subsystem for error handling. This is
- * called after PCI bus has been reset to restart the PCI card from scratch,
- * as if from a cold-boot. During the PCI subsystem error recovery, after the
- * driver returns PCI_ERS_RESULT_NEED_RESET, the PCI subsystem will perform
- * proper error recovery and then call this routine before calling the .resume
- * method to recover the device. This function will initialize the HBA device,
- * enable the interrupt, but it will just put the HBA to offline state without
- * passing any I/O traffic.
+ * This routine is called from the PCI subsystem for error handling to
+ * device with SLI-3 interface spec. This is called after PCI bus has been
+ * reset to restart the PCI card from scratch, as if from a cold-boot.
+ * During the PCI subsystem error recovery, after driver returns
+ * PCI_ERS_RESULT_NEED_RESET, the PCI subsystem will perform proper error
+ * recovery and then call this routine before calling the .resume method
+ * to recover the device. This function will initialize the HBA device,
+ * enable the interrupt, but it will just put the HBA to offline state
+ * without passing any I/O traffic.
  *
  * Return codes
- *   PCI_ERS_RESULT_RECOVERED - the device has been recovered
- *   PCI_ERS_RESULT_DISCONNECT - device could not be recovered
+ * 	PCI_ERS_RESULT_RECOVERED - the device has been recovered
+ * 	PCI_ERS_RESULT_DISCONNECT - device could not be recovered
  */
-static pci_ers_result_t lpfc_io_slot_reset(struct pci_dev *pdev)
+static pci_ers_result_t
+lpfc_io_slot_reset_s3(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
@@ -3354,11 +4084,11 @@ static pci_ers_result_t lpfc_io_slot_res
 		pci_set_master(pdev);
 
 	spin_lock_irq(&phba->hbalock);
-	psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
+	psli->sli_flag &= ~LPFC_SLI_ACTIVE;
 	spin_unlock_irq(&phba->hbalock);
 
 	/* Configure and enable interrupt */
-	intr_mode = lpfc_enable_intr(phba, phba->intr_mode);
+	intr_mode = lpfc_sli_enable_intr(phba, phba->intr_mode);
 	if (intr_mode == LPFC_INTR_ERROR) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0427 Cannot re-enable interrupt after "
@@ -3378,15 +4108,17 @@ static pci_ers_result_t lpfc_io_slot_res
 }
 
 /**
- * lpfc_io_resume - Resume PCI I/O operation
+ * lpfc_io_resume_s3 - Method for resuming PCI I/O operation on SLI-3 device.
  * @pdev: pointer to PCI device
  *
- * This routine is registered to the PCI subsystem for error handling. It is
- * called when kernel error recovery tells the lpfc driver that it is ok to
- * resume normal PCI operation after PCI bus error recovery. After this call,
- * traffic can start to flow from this device again.
+ * This routine is called from the PCI subsystem for error handling to device
+ * with SLI-3 interface spec. It is called when kernel error recovery tells
+ * the lpfc driver that it is ok to resume normal PCI operation after PCI bus
+ * error recovery. After this call, traffic can start to flow from this device
+ * again.
  */
-static void lpfc_io_resume(struct pci_dev *pdev)
+static void
+lpfc_io_resume_s3(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
@@ -3394,6 +4126,235 @@ static void lpfc_io_resume(struct pci_de
 	lpfc_online(phba);
 }
 
+/**
+ * lpfc_pci_probe_one - lpfc PCI probe func to reg dev to PCI subsystem
+ * @pdev: pointer to PCI device
+ * @pid: pointer to PCI device identifier
+ *
+ * This routine is to be registered to the kernel's PCI subsystem. When an
+ * Emulex HBA device is presented on PCI bus, the kernel PCI subsystem looks
+ * at PCI device-specific information of the device and driver to see if the
+ * driver state that it can support this kind of device. If the match is
+ * successful, the driver core invokes this routine. This routine dispatches
+ * the action to the proper SLI-3 or SLI-4 device probing routine, which will
+ * do all the initialization that it needs to do to handle the HBA device
+ * properly.
+ *
+ * Return code
+ * 	0 - driver can claim the device
+ * 	negative value - driver can not claim the device
+ **/
+static int __devinit
+lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
+{
+	int rc;
+	uint16_t dev_id;
+
+	if (pci_read_config_word(pdev, PCI_DEVICE_ID, &dev_id))
+		return -ENODEV;
+
+	switch (dev_id) {
+	default:
+		rc = lpfc_pci_probe_one_s3(pdev, pid);
+		break;
+	}
+	return rc;
+}
+
+/**
+ * lpfc_pci_remove_one - lpfc PCI func to unreg dev from PCI subsystem
+ * @pdev: pointer to PCI device
+ *
+ * This routine is to be registered to the kernel's PCI subsystem. When an
+ * Emulex HBA is removed from PCI bus, the driver core invokes this routine.
+ * This routine dispatches the action to the proper SLI-3 or SLI-4 device
+ * remove routine, which will perform all the necessary cleanup for the
+ * device to be removed from the PCI subsystem properly.
+ **/
+static void __devexit
+lpfc_pci_remove_one(struct pci_dev *pdev)
+{
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+
+	switch (phba->pci_dev_grp) {
+	case LPFC_PCI_DEV_LP:
+		lpfc_pci_remove_one_s3(pdev);
+		break;
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1424 Invalid PCI device group: 0x%x\n",
+				phba->pci_dev_grp);
+		break;
+	}
+	return;
+}
+
+/**
+ * lpfc_pci_suspend_one - lpfc PCI func to suspend dev for power management
+ * @pdev: pointer to PCI device
+ * @msg: power management message
+ *
+ * This routine is to be registered to the kernel's PCI subsystem to support
+ * system Power Management (PM). When PM invokes this method, it dispatches
+ * the action to the proper SLI-3 or SLI-4 device suspend routine, which will
+ * suspend the device.
+ *
+ * Return code
+ * 	0 - driver suspended the device
+ * 	Error otherwise
+ **/
+static int
+lpfc_pci_suspend_one(struct pci_dev *pdev, pm_message_t msg)
+{
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+	int rc = -ENODEV;
+
+	switch (phba->pci_dev_grp) {
+	case LPFC_PCI_DEV_LP:
+		rc = lpfc_pci_suspend_one_s3(pdev, msg);
+		break;
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1425 Invalid PCI device group: 0x%x\n",
+				phba->pci_dev_grp);
+		break;
+	}
+	return rc;
+}
+
+/**
+ * lpfc_pci_resume_one - lpfc PCI func to resume dev for power management
+ * @pdev: pointer to PCI device
+ *
+ * This routine is to be registered to the kernel's PCI subsystem to support
+ * system Power Management (PM). When PM invokes this method, it dispatches
+ * the action to the proper SLI-3 or SLI-4 device resume routine, which will
+ * resume the device.
+ *
+ * Return code
+ * 	0 - driver suspended the device
+ * 	Error otherwise
+ **/
+static int
+lpfc_pci_resume_one(struct pci_dev *pdev)
+{
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+	int rc = -ENODEV;
+
+	switch (phba->pci_dev_grp) {
+	case LPFC_PCI_DEV_LP:
+		rc = lpfc_pci_resume_one_s3(pdev);
+		break;
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1426 Invalid PCI device group: 0x%x\n",
+				phba->pci_dev_grp);
+		break;
+	}
+	return rc;
+}
+
+/**
+ * lpfc_io_error_detected - lpfc method for handling PCI I/O error
+ * @pdev: pointer to PCI device.
+ * @state: the current PCI connection state.
+ *
+ * This routine is registered to the PCI subsystem for error handling. This
+ * function is called by the PCI subsystem after a PCI bus error affecting
+ * this device has been detected. When this routine is invoked, it dispatches
+ * the action to the proper SLI-3 or SLI-4 device error detected handling
+ * routine, which will perform the proper error detected operation.
+ *
+ * Return codes
+ * 	PCI_ERS_RESULT_NEED_RESET - need to reset before recovery
+ * 	PCI_ERS_RESULT_DISCONNECT - device could not be recovered
+ **/
+static pci_ers_result_t
+lpfc_io_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
+{
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+	pci_ers_result_t rc = PCI_ERS_RESULT_DISCONNECT;
+
+	switch (phba->pci_dev_grp) {
+	case LPFC_PCI_DEV_LP:
+		rc = lpfc_io_error_detected_s3(pdev, state);
+		break;
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1427 Invalid PCI device group: 0x%x\n",
+				phba->pci_dev_grp);
+		break;
+	}
+	return rc;
+}
+
+/**
+ * lpfc_io_slot_reset - lpfc method for restart PCI dev from scratch
+ * @pdev: pointer to PCI device.
+ *
+ * This routine is registered to the PCI subsystem for error handling. This
+ * function is called after PCI bus has been reset to restart the PCI card
+ * from scratch, as if from a cold-boot. When this routine is invoked, it
+ * dispatches the action to the proper SLI-3 or SLI-4 device reset handling
+ * routine, which will perform the proper device reset.
+ *
+ * Return codes
+ * 	PCI_ERS_RESULT_RECOVERED - the device has been recovered
+ * 	PCI_ERS_RESULT_DISCONNECT - device could not be recovered
+ **/
+static pci_ers_result_t
+lpfc_io_slot_reset(struct pci_dev *pdev)
+{
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+	pci_ers_result_t rc = PCI_ERS_RESULT_DISCONNECT;
+
+	switch (phba->pci_dev_grp) {
+	case LPFC_PCI_DEV_LP:
+		rc = lpfc_io_slot_reset_s3(pdev);
+		break;
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1428 Invalid PCI device group: 0x%x\n",
+				phba->pci_dev_grp);
+		break;
+	}
+	return rc;
+}
+
+/**
+ * lpfc_io_resume - lpfc method for resuming PCI I/O operation
+ * @pdev: pointer to PCI device
+ *
+ * This routine is registered to the PCI subsystem for error handling. It
+ * is called when kernel error recovery tells the lpfc driver that it is
+ * OK to resume normal PCI operation after PCI bus error recovery. When
+ * this routine is invoked, it dispatches the action to the proper SLI-3
+ * or SLI-4 device io_resume routine, which will resume the device operation.
+ **/
+static void
+lpfc_io_resume(struct pci_dev *pdev)
+{
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
+
+	switch (phba->pci_dev_grp) {
+	case LPFC_PCI_DEV_LP:
+		lpfc_io_resume_s3(pdev);
+		break;
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1429 Invalid PCI device group: 0x%x\n",
+				phba->pci_dev_grp);
+		break;
+	}
+	return;
+}
+
 static struct pci_device_id lpfc_id_table[] = {
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_VIPER,
 		PCI_ANY_ID, PCI_ANY_ID, },
@@ -3469,6 +4430,10 @@ static struct pci_device_id lpfc_id_tabl
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_PROTEUS_S,
 		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_SERVERENGINE, PCI_DEVICE_ID_TIGERSHARK,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_SERVERENGINE, PCI_DEVICE_ID_TIGERSHARK_S,
+		PCI_ANY_ID, PCI_ANY_ID, },
 	{ 0 }
 };
 
@@ -3486,7 +4451,7 @@ static struct pci_driver lpfc_driver = {
 	.probe		= lpfc_pci_probe_one,
 	.remove		= __devexit_p(lpfc_pci_remove_one),
 	.suspend        = lpfc_pci_suspend_one,
-	.resume         = lpfc_pci_resume_one,
+	.resume		= lpfc_pci_resume_one,
 	.err_handler    = &lpfc_err_handler,
 };
 


