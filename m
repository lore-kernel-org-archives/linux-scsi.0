From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 13/15] lpfc 8.2.8 : Add MSI-X support
Date: Sun, 24 Aug 2008 21:50:30 -0400
Message-ID: <1219629030.7890.45.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:52526 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbYHYBu2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Aug 2008 21:50:28 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m7P1oRR5020014
	for <linux-scsi@vger.kernel.org>; Sun, 24 Aug 2008 18:50:27 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add support for MSI-X Multi-Message interrupts. We use different vectors
for fast-path interrupts (i/o) and slow-patch interrupts (discovery, etc).


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h         |   35 ++++
 lpfc_attr.c    |    8 -
 lpfc_crtn.h    |   41 ++---
 lpfc_hbadisc.c |    2 
 lpfc_hw.h      |   63 ++++++++
 lpfc_init.c    |  230 ++++++++++++++++++++++++++------
 lpfc_mbox.c    |   80 +++++++++++
 lpfc_sli.c     |  401 +++++++++++++++++++++++++++++++++++++++++++--------------
 lpfc_version.h |    4 
 9 files changed, 698 insertions(+), 166 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2008-08-24 20:49:55.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2008-08-24 20:50:26.000000000 -0400
@@ -2414,12 +2414,12 @@ LPFC_ATTR_RW(poll_tmo, 10, 1, 255,
 /*
 # lpfc_use_msi: Use MSI (Message Signaled Interrupts) in systems that
 #		support this feature
-#       0  = MSI disabled (default)
+#       0  = MSI disabled
 #       1  = MSI enabled
-#	2  = MSI-X enabled
-# Value range is [0,2]. Default value is 0.
+#       2  = MSI-X enabled (default)
+# Value range is [0,2]. Default value is 2.
 */
-LPFC_ATTR_R(use_msi, 0, 0, 2, "Use Message Signaled Interrupts (1) or "
+LPFC_ATTR_R(use_msi, 2, 0, 2, "Use Message Signaled Interrupts (1) or "
 	    "MSI-X (2), if possible");
 
 /*
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2008-08-24 20:47:07.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2008-08-24 20:50:26.000000000 -0400
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-typedef int (*node_filter)(struct lpfc_nodelist *ndlp, void *param);
+typedef int (*node_filter)(struct lpfc_nodelist *, void *);
 
 struct fc_rport;
 void lpfc_dump_mem(struct lpfc_hba *, LPFC_MBOXQ_t *, uint16_t);
@@ -26,11 +26,11 @@ void lpfc_read_nv(struct lpfc_hba *, LPF
 void lpfc_config_async(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t);
 
 void lpfc_heart_beat(struct lpfc_hba *, LPFC_MBOXQ_t *);
-int lpfc_read_la(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb,
-		 struct lpfc_dmabuf *mp);
+int lpfc_read_la(struct lpfc_hba *, LPFC_MBOXQ_t *, struct lpfc_dmabuf *);
 void lpfc_clear_la(struct lpfc_hba *, LPFC_MBOXQ_t *);
-void lpfc_issue_clear_la(struct lpfc_hba *phba, struct lpfc_vport *vport);
+void lpfc_issue_clear_la(struct lpfc_hba *, struct lpfc_vport *);
 void lpfc_config_link(struct lpfc_hba *, LPFC_MBOXQ_t *);
+int lpfc_config_msi(struct lpfc_hba *, LPFC_MBOXQ_t *);
 int lpfc_read_sparam(struct lpfc_hba *, LPFC_MBOXQ_t *, int);
 void lpfc_read_config(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_read_lnk_stat(struct lpfc_hba *, LPFC_MBOXQ_t *);
@@ -43,7 +43,7 @@ void lpfc_unreg_vpi(struct lpfc_hba *, u
 void lpfc_init_link(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t, uint32_t);
 
 struct lpfc_vport *lpfc_find_vport_by_did(struct lpfc_hba *, uint32_t);
-void lpfc_cleanup_rpis(struct lpfc_vport *vport, int remove);
+void lpfc_cleanup_rpis(struct lpfc_vport *, int);
 int lpfc_linkdown(struct lpfc_hba *);
 void lpfc_port_link_failure(struct lpfc_vport *);
 void lpfc_mbx_cmpl_read_la(struct lpfc_hba *, LPFC_MBOXQ_t *);
@@ -135,7 +135,7 @@ void lpfc_ct_unsol_event(struct lpfc_hba
 int lpfc_ns_cmd(struct lpfc_vport *, int, uint8_t, uint32_t);
 int lpfc_fdmi_cmd(struct lpfc_vport *, struct lpfc_nodelist *, int);
 void lpfc_fdmi_tmo(unsigned long);
-void lpfc_fdmi_timeout_handler(struct lpfc_vport *vport);
+void lpfc_fdmi_timeout_handler(struct lpfc_vport *);
 
 int lpfc_config_port_prep(struct lpfc_hba *);
 int lpfc_config_port_post(struct lpfc_hba *);
@@ -155,6 +155,8 @@ int lpfc_sli_queue_setup(struct lpfc_hba
 void lpfc_handle_eratt(struct lpfc_hba *);
 void lpfc_handle_latt(struct lpfc_hba *);
 irqreturn_t lpfc_intr_handler(int, void *);
+irqreturn_t lpfc_sp_intr_handler(int, void *);
+irqreturn_t lpfc_fp_intr_handler(int, void *);
 
 void lpfc_read_rev(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_config_ring(struct lpfc_hba *, int, LPFC_MBOXQ_t *);
@@ -175,11 +177,12 @@ void lpfc_mem_free(struct lpfc_hba *);
 void lpfc_stop_vport_timers(struct lpfc_vport *);
 
 void lpfc_poll_timeout(unsigned long ptr);
-void lpfc_poll_start_timer(struct lpfc_hba * phba);
-void lpfc_sli_poll_fcp_ring(struct lpfc_hba * hba);
+void lpfc_poll_start_timer(struct lpfc_hba *);
+void lpfc_poll_eratt(unsigned long);
+void lpfc_sli_poll_fcp_ring(struct lpfc_hba *);
 struct lpfc_iocbq * lpfc_sli_get_iocbq(struct lpfc_hba *);
-void lpfc_sli_release_iocbq(struct lpfc_hba * phba, struct lpfc_iocbq * iocb);
-uint16_t lpfc_sli_next_iotag(struct lpfc_hba * phba, struct lpfc_iocbq * iocb);
+void lpfc_sli_release_iocbq(struct lpfc_hba *, struct lpfc_iocbq *);
+uint16_t lpfc_sli_next_iotag(struct lpfc_hba *, struct lpfc_iocbq *);
 
 void lpfc_reset_barrier(struct lpfc_hba * phba);
 int lpfc_sli_brdready(struct lpfc_hba *, uint32_t);
@@ -187,11 +190,13 @@ int lpfc_sli_brdkill(struct lpfc_hba *);
 int lpfc_sli_brdreset(struct lpfc_hba *);
 int lpfc_sli_brdrestart(struct lpfc_hba *);
 int lpfc_sli_hba_setup(struct lpfc_hba *);
+int lpfc_sli_config_port(struct lpfc_hba *, int);
 int lpfc_sli_host_down(struct lpfc_vport *);
 int lpfc_sli_hba_down(struct lpfc_hba *);
 int lpfc_sli_issue_mbox(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t);
 int lpfc_sli_handle_mb_event(struct lpfc_hba *);
 int lpfc_sli_flush_mbox_queue(struct lpfc_hba *);
+int lpfc_sli_check_eratt(struct lpfc_hba *);
 int lpfc_sli_handle_slow_ring_event(struct lpfc_hba *,
 				    struct lpfc_sli_ring *, uint32_t);
 void lpfc_sli_def_mbox_cmpl(struct lpfc_hba *, LPFC_MBOXQ_t *);
@@ -227,17 +232,13 @@ struct lpfc_nodelist *lpfc_findnode_did(
 struct lpfc_nodelist *lpfc_findnode_wwpn(struct lpfc_vport *,
 					 struct lpfc_name *);
 
-int lpfc_sli_issue_mbox_wait(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmboxq,
-			     uint32_t timeout);
+int lpfc_sli_issue_mbox_wait(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t);
 
-int lpfc_sli_issue_iocb_wait(struct lpfc_hba * phba,
-			     struct lpfc_sli_ring * pring,
-			     struct lpfc_iocbq * piocb,
-			     struct lpfc_iocbq * prspiocbq,
-			     uint32_t timeout);
-void lpfc_sli_abort_fcp_cmpl(struct lpfc_hba * phba,
-			     struct lpfc_iocbq * cmdiocb,
-			     struct lpfc_iocbq * rspiocb);
+int lpfc_sli_issue_iocb_wait(struct lpfc_hba *, struct lpfc_sli_ring *,
+			     struct lpfc_iocbq *, struct lpfc_iocbq *,
+			     uint32_t);
+void lpfc_sli_abort_fcp_cmpl(struct lpfc_hba *, struct lpfc_iocbq *,
+			     struct lpfc_iocbq *);
 
 void lpfc_sli_free_hbq(struct lpfc_hba *, struct hbq_dmabuf *);
 
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2008-08-24 20:49:55.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2008-08-24 20:50:26.000000000 -0400
@@ -54,6 +54,9 @@ struct lpfc_sli2_slim;
 #define LPFC_HB_MBOX_INTERVAL   5	/* Heart beat interval in seconds. */
 #define LPFC_HB_MBOX_TIMEOUT    30	/* Heart beat timeout  in seconds. */
 
+/* Error Attention event polling interval */
+#define LPFC_ERATT_POLL_INTERVAL	5 /* EATT poll interval in seconds */
+
 /* Define macros for 64 bit support */
 #define putPaddrLow(addr)    ((uint32_t) (0xffffffff & (u64)(addr)))
 #define putPaddrHigh(addr)   ((uint32_t) (0xffffffff & (((u64)(addr))>>32)))
@@ -65,6 +68,9 @@ struct lpfc_sli2_slim;
 
 #define MAX_HBAEVT	32
 
+/* Number of MSI-X vectors the driver uses */
+#define LPFC_MSIX_VECTORS	2
+
 /* lpfc wait event data ready flag */
 #define LPFC_DATA_READY		(1<<0)
 
@@ -429,12 +435,16 @@ struct lpfc_hba {
 #define LS_NPIV_FAB_SUPPORTED 0x2	/* Fabric supports NPIV */
 #define LS_IGNORE_ERATT       0x4	/* intr handler should ignore ERATT */
 
+	uint32_t hba_flag;	/* hba generic flags */
+#define HBA_ERATT_HANDLED	0x1 /* This flag is set when eratt handled */
+
 	struct lpfc_dmabuf slim2p;
 
 	MAILBOX_t *mbox;
 	uint32_t *inb_ha_copy;
 	uint32_t *inb_counter;
 	uint32_t inb_last_counter;
+	uint32_t ha_copy;
 	struct _PCB *pcb;
 	struct _IOCB *IOCBs;
 
@@ -550,6 +560,7 @@ struct lpfc_hba {
 	uint8_t soft_wwn_enable;
 
 	struct timer_list fcp_poll_timer;
+	struct timer_list eratt_poll;
 
 	/*
 	 * stat  counters
@@ -579,7 +590,7 @@ struct lpfc_hba {
 
 	struct fc_host_statistics link_stats;
 	enum intr_type_t intr_type;
-	struct msix_entry msix_entries[1];
+	struct msix_entry msix_entries[LPFC_MSIX_VECTORS];
 
 	struct list_head port_list;
 	struct lpfc_vport *pport;	/* physical lpfc_vport pointer */
@@ -666,6 +677,28 @@ lpfc_worker_wake_up(struct lpfc_hba *phb
 	return;
 }
 
+static inline void
+lpfc_sli_read_hs(struct lpfc_hba *phba)
+{
+	/*
+	 * There was a link/board error. Read the status register to retrieve
+	 * the error event and process it.
+	 */
+	phba->sli.slistat.err_attn_event++;
+
+	/* Save status info */
+	phba->work_hs = readl(phba->HSregaddr);
+	phba->work_status[0] = readl(phba->MBslimaddr + 0xa8);
+	phba->work_status[1] = readl(phba->MBslimaddr + 0xac);
+
+	/* Clear chip Host Attention error bit */
+	writel(HA_ERATT, phba->HAregaddr);
+	readl(phba->HAregaddr); /* flush */
+	phba->pport->stopped = 1;
+
+	return;
+}
+
 #define FC_REG_DUMP_EVENT		0x10	/* Register for Dump events */
 #define FC_REG_TEMPERATURE_EVENT	0x20    /* Register for temperature
 						   event */
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-08-24 20:49:55.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-08-24 20:50:26.000000000 -0400
@@ -377,6 +377,7 @@ lpfc_work_done(struct lpfc_hba *phba)
 	spin_unlock_irq(&phba->hbalock);
 
 	if (ha_copy & HA_ERATT)
+		/* Handle the error attention event */
 		lpfc_handle_eratt(phba);
 
 	if (ha_copy & HA_MBATT)
@@ -384,6 +385,7 @@ lpfc_work_done(struct lpfc_hba *phba)
 
 	if (ha_copy & HA_LATT)
 		lpfc_handle_latt(phba);
+
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
 		for(i = 0; i <= phba->max_vpi; i++) {
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2008-08-24 20:45:48.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2008-08-24 20:50:26.000000000 -0400
@@ -1203,6 +1203,18 @@ typedef struct {		/* FireFly BIU registe
 #define HA_RXATT       0x00000008	/* Bit  3 */
 #define HA_RXMASK      0x0000000f
 
+#define HA_R0_CLR_MSK	(HA_R0RE_REQ | HA_R0CE_RSP | HA_R0ATT)
+#define HA_R1_CLR_MSK	(HA_R1RE_REQ | HA_R1CE_RSP | HA_R1ATT)
+#define HA_R2_CLR_MSK	(HA_R2RE_REQ | HA_R2CE_RSP | HA_R2ATT)
+#define HA_R3_CLR_MSK	(HA_R3RE_REQ | HA_R3CE_RSP | HA_R3ATT)
+
+#define HA_R0_POS	3
+#define HA_R1_POS	7
+#define HA_R2_POS	11
+#define HA_R3_POS	15
+#define HA_LE_POS	29
+#define HA_MB_POS	30
+#define HA_ER_POS	31
 /* Chip Attention Register */
 
 #define CA_REG_OFFSET  4	/* Byte offset from register base address */
@@ -1240,7 +1252,7 @@ typedef struct {		/* FireFly BIU registe
 
 /* Host Control Register */
 
-#define HC_REG_OFFSET  12	/* Word offset from register base address */
+#define HC_REG_OFFSET  12	/* Byte offset from register base address */
 
 #define HC_MBINT_ENA   0x00000001	/* Bit  0 */
 #define HC_R0INT_ENA   0x00000002	/* Bit  1 */
@@ -1253,6 +1265,19 @@ typedef struct {		/* FireFly BIU registe
 #define HC_LAINT_ENA   0x20000000	/* Bit 29 */
 #define HC_ERINT_ENA   0x80000000	/* Bit 31 */
 
+/* Message Signaled Interrupt eXtension (MSI-X) message identifiers */
+#define MSIX_DFLT_ID	0
+#define MSIX_RNG0_ID	0
+#define MSIX_RNG1_ID	1
+#define MSIX_RNG2_ID	2
+#define MSIX_RNG3_ID	3
+
+#define MSIX_LINK_ID	4
+#define MSIX_MBOX_ID	5
+
+#define MSIX_SPARE0_ID	6
+#define MSIX_SPARE1_ID	7
+
 /* Mailbox Commands */
 #define MBX_SHUTDOWN        0x00	/* terminate testing */
 #define MBX_LOAD_SM         0x01
@@ -1290,6 +1315,7 @@ typedef struct {		/* FireFly BIU registe
 #define MBX_KILL_BOARD      0x24
 #define MBX_CONFIG_FARP     0x25
 #define MBX_BEACON          0x2A
+#define MBX_CONFIG_MSI      0x30
 #define MBX_HEARTBEAT       0x31
 #define MBX_WRITE_VPARMS    0x32
 #define MBX_ASYNCEVT_ENABLE 0x33
@@ -2599,6 +2625,40 @@ typedef struct {
 
 } CONFIG_PORT_VAR;
 
+/* Structure for MB Command CONFIG_MSI (0x30) */
+struct config_msi_var {
+#ifdef __BIG_ENDIAN_BITFIELD
+	uint32_t dfltMsgNum:8;	/* Default message number            */
+	uint32_t rsvd1:11;	/* Reserved                          */
+	uint32_t NID:5;		/* Number of secondary attention IDs */
+	uint32_t rsvd2:5;	/* Reserved                          */
+	uint32_t dfltPresent:1;	/* Default message number present    */
+	uint32_t addFlag:1;	/* Add association flag              */
+	uint32_t reportFlag:1;	/* Report association flag           */
+#else	/*  __LITTLE_ENDIAN_BITFIELD */
+	uint32_t reportFlag:1;	/* Report association flag           */
+	uint32_t addFlag:1;	/* Add association flag              */
+	uint32_t dfltPresent:1;	/* Default message number present    */
+	uint32_t rsvd2:5;	/* Reserved                          */
+	uint32_t NID:5;		/* Number of secondary attention IDs */
+	uint32_t rsvd1:11;	/* Reserved                          */
+	uint32_t dfltMsgNum:8;	/* Default message number            */
+#endif
+	uint32_t attentionConditions[2];
+	uint8_t  attentionId[16];
+	uint8_t  messageNumberByHA[64];
+	uint8_t  messageNumberByID[16];
+	uint32_t autoClearHA[2];
+#ifdef __BIG_ENDIAN_BITFIELD
+	uint32_t rsvd3:16;
+	uint32_t autoClearID:16;
+#else	/*  __LITTLE_ENDIAN_BITFIELD */
+	uint32_t autoClearID:16;
+	uint32_t rsvd3:16;
+#endif
+	uint32_t rsvd4;
+};
+
 /* SLI-2 Port Control Block */
 
 /* SLIM POINTER */
@@ -2722,6 +2782,7 @@ typedef union {
 	REG_VPI_VAR varRegVpi;		/* cmd = 0x96 (REG_VPI) */
 	UNREG_VPI_VAR varUnregVpi;	/* cmd = 0x97 (UNREG_VPI) */
 	ASYNCEVT_ENABLE_VAR varCfgAsyncEvent; /*cmd = x33 (CONFIG_ASYNC) */
+	struct config_msi_var varCfgMSI;/* cmd = x30 (CONFIG_MSI)     */
 } MAILVARIANTS;
 
 /*
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2008-08-24 20:47:07.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2008-08-24 20:50:26.000000000 -0400
@@ -389,6 +389,29 @@ lpfc_config_port_post(struct lpfc_hba *p
 	if (phba->sli_rev != 3)
 		lpfc_post_rcv_buf(phba);
 
+	/*
+	 * Configure HBA MSI-X attention conditions to messages if MSI-X mode
+	 */
+	if (phba->intr_type == MSIX) {
+		rc = lpfc_config_msi(phba, pmb);
+		if (rc) {
+			mempool_free(pmb, phba->mbox_mem_pool);
+			return -EIO;
+		}
+		rc = lpfc_sli_issue_mbox(phba, pmb, MBX_POLL);
+		if (rc != MBX_SUCCESS) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
+					"0352 Config MSI mailbox command "
+					"failed, mbxCmd x%x, mbxStatus x%x\n",
+					pmb->mb.mbxCommand, pmb->mb.mbxStatus);
+			mempool_free(pmb, phba->mbox_mem_pool);
+			return -EIO;
+		}
+	}
+
+	/* Initialize ERATT handling flag */
+	phba->hba_flag &= ~HBA_ERATT_HANDLED;
+
 	/* Enable appropriate host interrupts */
 	spin_lock_irq(&phba->hbalock);
 	status = readl(phba->HCregaddr);
@@ -404,20 +427,21 @@ lpfc_config_port_post(struct lpfc_hba *p
 
 	if ((phba->cfg_poll & ENABLE_FCP_RING_POLLING) &&
 	    (phba->cfg_poll & DISABLE_FCP_RING_INT))
-		status &= ~(HC_R0INT_ENA << LPFC_FCP_RING);
+		status &= ~(HC_R0INT_ENA);
 
 	writel(status, phba->HCregaddr);
 	readl(phba->HCregaddr); /* flush */
 	spin_unlock_irq(&phba->hbalock);
 
-	/*
-	 * Setup the ring 0 (els)  timeout handler
-	 */
-	timeout = phba->fc_ratov << 1;
+	/* Set up ring-0 (ELS) timer */
+	timeout = phba->fc_ratov * 2;
 	mod_timer(&vport->els_tmofunc, jiffies + HZ * timeout);
+	/* Set up heart beat (HB) timer */
 	mod_timer(&phba->hb_tmofunc, jiffies + HZ * LPFC_HB_MBOX_INTERVAL);
 	phba->hb_outstanding = 0;
 	phba->last_completion_time = jiffies;
+	/* Set up error attention (ERATT) polling timer */
+	mod_timer(&phba->eratt_poll, jiffies + HZ * LPFC_ERATT_POLL_INTERVAL);
 
 	lpfc_init_link(phba, pmb, phba->cfg_topology, phba->cfg_link_speed);
 	pmb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
@@ -581,12 +605,15 @@ lpfc_hb_timeout(unsigned long ptr)
 	unsigned long iflag;
 
 	phba = (struct lpfc_hba *)ptr;
+
+	/* Check for heart beat timeout conditions */
 	spin_lock_irqsave(&phba->pport->work_port_lock, iflag);
 	tmo_posted = phba->pport->work_port_events & WORKER_HB_TMO;
 	if (!tmo_posted)
 		phba->pport->work_port_events |= WORKER_HB_TMO;
 	spin_unlock_irqrestore(&phba->pport->work_port_lock, iflag);
 
+	/* Tell the worker thread there is work to do */
 	if (!tmo_posted)
 		lpfc_worker_wake_up(phba);
 	return;
@@ -617,6 +644,7 @@ lpfc_hb_mbox_cmpl(struct lpfc_hba * phba
 	phba->hb_outstanding = 0;
 	spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
 
+	/* Check and reset heart-beat timer is necessary */
 	mempool_free(pmboxq, phba->mbox_mem_pool);
 	if (!(phba->pport->fc_flag & FC_OFFLINE_MODE) &&
 		!(phba->link_state == LPFC_HBA_ERROR) &&
@@ -856,8 +884,8 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
 
 	} else {
 		/* The if clause above forces this code path when the status
-		 * failure is a value other than FFER6.  Do not call the offline
-		 *  twice. This is the adapter hardware error path.
+		 * failure is a value other than FFER6. Do not call the offline
+		 * twice. This is the adapter hardware error path.
 		 */
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0457 Adapter Hardware Error "
@@ -873,6 +901,7 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
 
 		lpfc_offline_eratt(phba);
 	}
+	return;
 }
 
 /**
@@ -1656,6 +1685,7 @@ lpfc_stop_phba_timers(struct lpfc_hba *p
 	del_timer_sync(&phba->fabric_block_timer);
 	phba->hb_outstanding = 0;
 	del_timer_sync(&phba->hb_tmofunc);
+	del_timer_sync(&phba->eratt_poll);
 	return;
 }
 
@@ -2172,30 +2202,97 @@ void lpfc_host_attrib_init(struct Scsi_H
 static int
 lpfc_enable_msix(struct lpfc_hba *phba)
 {
-	int error;
+	int rc, i;
+	LPFC_MBOXQ_t *pmb;
 
-	phba->msix_entries[0].entry = 0;
-	phba->msix_entries[0].vector = 0;
+	/* Set up MSI-X multi-message vectors */
+	for (i = 0; i < LPFC_MSIX_VECTORS; i++)
+		phba->msix_entries[i].entry = i;
 
-	error = pci_enable_msix(phba->pcidev, phba->msix_entries,
+	/* Configure MSI-X capability structure */
+	rc = pci_enable_msix(phba->pcidev, phba->msix_entries,
 				ARRAY_SIZE(phba->msix_entries));
-	if (error) {
+	if (rc) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0420 Enable MSI-X failed (%d), continuing "
-				"with MSI\n", error);
-		pci_disable_msix(phba->pcidev);
-		return error;
+				"with MSI\n", rc);
+		goto msi_fail_out;
+	} else
+		for (i = 0; i < LPFC_MSIX_VECTORS; i++)
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+					"0477 MSI-X entry[%d]: vector=x%x "
+					"message=%d\n", i,
+					phba->msix_entries[i].vector,
+					phba->msix_entries[i].entry);
+	/*
+	 * Assign MSI-X vectors to interrupt handlers
+	 */
+
+	/* vector-0 is associated to slow-path handler */
+	rc = request_irq(phba->msix_entries[0].vector, &lpfc_sp_intr_handler,
+			 IRQF_SHARED, LPFC_SP_DRIVER_HANDLER_NAME, phba);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0421 MSI-X slow-path request_irq failed "
+				"(%d), continuing with MSI\n", rc);
+		goto msi_fail_out;
 	}
 
-	error =	request_irq(phba->msix_entries[0].vector, lpfc_intr_handler, 0,
-			    LPFC_DRIVER_NAME, phba);
-	if (error) {
+	/* vector-1 is associated to fast-path handler */
+	rc = request_irq(phba->msix_entries[1].vector, &lpfc_fp_intr_handler,
+			 IRQF_SHARED, LPFC_FP_DRIVER_HANDLER_NAME, phba);
+
+	if (rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0421 MSI-X request_irq failed (%d), "
-				"continuing with MSI\n", error);
-		pci_disable_msix(phba->pcidev);
+				"0429 MSI-X fast-path request_irq failed "
+				"(%d), continuing with MSI\n", rc);
+		goto irq_fail_out;
 	}
-	return error;
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
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
+				"0351 Config MSI mailbox command failed, "
+				"mbxCmd x%x, mbxStatus x%x\n",
+				pmb->mb.mbxCommand, pmb->mb.mbxStatus);
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
 }
 
 /**
@@ -2208,7 +2305,12 @@ lpfc_enable_msix(struct lpfc_hba *phba)
 static void
 lpfc_disable_msix(struct lpfc_hba *phba)
 {
-	free_irq(phba->msix_entries[0].vector, phba);
+	int i;
+
+	/* Free up MSI-X multi-message vectors */
+	for (i = 0; i < LPFC_MSIX_VECTORS; i++)
+		free_irq(phba->msix_entries[i].vector, phba);
+	/* Disable MSI-X */
 	pci_disable_msix(phba->pcidev);
 }
 
@@ -2288,6 +2390,9 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	init_timer(&phba->fabric_block_timer);
 	phba->fabric_block_timer.function = lpfc_fabric_block_timeout;
 	phba->fabric_block_timer.data = (unsigned long) phba;
+	init_timer(&phba->eratt_poll);
+	phba->eratt_poll.function = lpfc_poll_eratt;
+	phba->eratt_poll.data = (unsigned long) phba;
 
 	pci_set_master(pdev);
 	pci_try_set_mwi(pdev);
@@ -2307,7 +2412,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	bar2map_len        = pci_resource_len(phba->pcidev, 2);
 
 	/* Map HBA SLIM to a kernel virtual address. */
-	phba->slim_memmap_p      = ioremap(phba->pci_bar0_map, bar0map_len);
+	phba->slim_memmap_p = ioremap(phba->pci_bar0_map, bar0map_len);
 	if (!phba->slim_memmap_p) {
 		error = -ENODEV;
 		dev_printk(KERN_ERR, &pdev->dev,
@@ -2405,7 +2510,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	phba->fc_arbtov = FF_DEF_ARBTOV;
 
 	INIT_LIST_HEAD(&phba->work_list);
-	phba->work_ha_mask = (HA_ERATT|HA_MBATT|HA_LATT);
+	phba->work_ha_mask = (HA_ERATT | HA_MBATT | HA_LATT);
 	phba->work_ha_mask |= (HA_RXMASK << (LPFC_ELS_RING * 4));
 
 	/* Initialize the wait queue head for the kernel thread */
@@ -2440,21 +2545,42 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	pci_set_drvdata(pdev, shost);
 	phba->intr_type = NONE;
 
+	phba->MBslimaddr = phba->slim_memmap_p;
+	phba->HAregaddr = phba->ctrl_regs_memmap_p + HA_REG_OFFSET;
+	phba->CAregaddr = phba->ctrl_regs_memmap_p + CA_REG_OFFSET;
+	phba->HSregaddr = phba->ctrl_regs_memmap_p + HS_REG_OFFSET;
+	phba->HCregaddr = phba->ctrl_regs_memmap_p + HC_REG_OFFSET;
+
+	/* Configure and enable interrupt */
 	if (phba->cfg_use_msi == 2) {
-		error = lpfc_enable_msix(phba);
-		if (!error)
-			phba->intr_type = MSIX;
+		/* Need to issue conf_port mbox cmd before conf_msi mbox cmd */
+		error = lpfc_sli_config_port(phba, 3);
+		if (error)
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"0427 Firmware not capable of SLI 3 mode.\n");
+		else {
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"0426 Firmware capable of SLI 3 mode.\n");
+			/* Now, try to enable MSI-X interrupt mode */
+			error = lpfc_enable_msix(phba);
+			if (!error) {
+				phba->intr_type = MSIX;
+				lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+						"0430 enable MSI-X mode.\n");
+			}
+		}
 	}
 
 	/* Fallback to MSI if MSI-X initialization failed */
 	if (phba->cfg_use_msi >= 1 && phba->intr_type == NONE) {
 		retval = pci_enable_msi(phba->pcidev);
-		if (!retval)
+		if (!retval) {
 			phba->intr_type = MSI;
-		else
 			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-					"0452 Enable MSI failed, continuing "
-					"with IRQ\n");
+					"0473 enable MSI mode.\n");
+		} else
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+					"0452 enable IRQ mode.\n");
 	}
 
 	/* MSI-X is the only case the doesn't need to call request_irq */
@@ -2470,18 +2596,16 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 			phba->intr_type = INTx;
 	}
 
-	phba->MBslimaddr = phba->slim_memmap_p;
-	phba->HAregaddr = phba->ctrl_regs_memmap_p + HA_REG_OFFSET;
-	phba->CAregaddr = phba->ctrl_regs_memmap_p + CA_REG_OFFSET;
-	phba->HSregaddr = phba->ctrl_regs_memmap_p + HS_REG_OFFSET;
-	phba->HCregaddr = phba->ctrl_regs_memmap_p + HC_REG_OFFSET;
-
 	if (lpfc_alloc_sysfs_attr(vport)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1476 Failed to allocate sysfs attr\n");
 		error = -ENOMEM;
 		goto out_free_irq;
 	}
 
 	if (lpfc_sli_hba_setup(phba)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1477 Failed to set up hba\n");
 		error = -ENODEV;
 		goto out_remove_device;
 	}
@@ -2500,6 +2624,8 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 		spin_unlock_irq(shost->host_lock);
 	}
 
+	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"0428 Perform SCSI scan\n");
 	scsi_scan_host(shost);
 
 	return 0;
@@ -2732,20 +2858,34 @@ static pci_ers_result_t lpfc_io_slot_res
 	/* Enable configured interrupt method */
 	phba->intr_type = NONE;
 	if (phba->cfg_use_msi == 2) {
-		error = lpfc_enable_msix(phba);
-		if (!error)
-			phba->intr_type = MSIX;
+		/* Need to issue conf_port mbox cmd before conf_msi mbox cmd */
+		error = lpfc_sli_config_port(phba, 3);
+		if (error)
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"0478 Firmware not capable of SLI 3 mode.\n");
+		else {
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"0479 Firmware capable of SLI 3 mode.\n");
+			/* Now, try to enable MSI-X interrupt mode */
+			error = lpfc_enable_msix(phba);
+			if (!error) {
+				phba->intr_type = MSIX;
+				lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+						"0480 enable MSI-X mode.\n");
+			}
+		}
 	}
 
 	/* Fallback to MSI if MSI-X initialization failed */
 	if (phba->cfg_use_msi >= 1 && phba->intr_type == NONE) {
 		retval = pci_enable_msi(phba->pcidev);
-		if (!retval)
+		if (!retval) {
 			phba->intr_type = MSI;
-		else
 			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-					"0470 Enable MSI failed, continuing "
-					"with IRQ\n");
+					"0481 enable MSI mode.\n");
+		} else
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+					"0470 enable IRQ mode.\n");
 	}
 
 	/* MSI-X is the only case the doesn't need to call request_irq */
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2008-08-24 20:41:07.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2008-08-24 20:50:26.000000000 -0400
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2007 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2008 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -272,6 +272,84 @@ lpfc_config_link(struct lpfc_hba * phba,
 }
 
 /**
+ * lpfc_config_msi: Prepare a mailbox command for configuring msi-x.
+ * @phba: pointer to lpfc hba data structure.
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ *
+ * The configure MSI-X mailbox command is used to configure the HBA's SLI-3
+ * MSI-X multi-message interrupt vector association to interrupt attention
+ * conditions.
+ *
+ * Return codes
+ *    0 - Success
+ *    -EINVAL - Failure
+ **/
+int
+lpfc_config_msi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
+{
+	MAILBOX_t *mb = &pmb->mb;
+	uint32_t attentionConditions[2];
+
+	/* Sanity check */
+	if (phba->cfg_use_msi != 2) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0475 Not configured for supporting MSI-X "
+				"cfg_use_msi: 0x%x\n", phba->cfg_use_msi);
+		return -EINVAL;
+	}
+
+	if (phba->sli_rev < 3) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0476 HBA not supporting SLI-3 or later "
+				"SLI Revision: 0x%x\n", phba->sli_rev);
+		return -EINVAL;
+	}
+
+	/* Clear mailbox command fields */
+	memset(pmb, 0, sizeof(LPFC_MBOXQ_t));
+
+	/*
+	 * SLI-3, Message Signaled Interrupt Fearure.
+	 */
+
+	/* Multi-message attention configuration */
+	attentionConditions[0] = (HA_R0ATT | HA_R1ATT | HA_R2ATT | HA_ERATT |
+				  HA_LATT | HA_MBATT);
+	attentionConditions[1] = 0;
+
+	mb->un.varCfgMSI.attentionConditions[0] = attentionConditions[0];
+	mb->un.varCfgMSI.attentionConditions[1] = attentionConditions[1];
+
+	/*
+	 * Set up message number to HA bit association
+	 */
+#ifdef __BIG_ENDIAN_BITFIELD
+	/* RA0 (FCP Ring) */
+	mb->un.varCfgMSI.messageNumberByHA[HA_R0_POS] = 1;
+	/* RA1 (Other Protocol Extra Ring) */
+	mb->un.varCfgMSI.messageNumberByHA[HA_R1_POS] = 1;
+#else   /*  __LITTLE_ENDIAN_BITFIELD */
+	/* RA0 (FCP Ring) */
+	mb->un.varCfgMSI.messageNumberByHA[HA_R0_POS^3] = 1;
+	/* RA1 (Other Protocol Extra Ring) */
+	mb->un.varCfgMSI.messageNumberByHA[HA_R1_POS^3] = 1;
+#endif
+	/* Multi-message interrupt autoclear configuration*/
+	mb->un.varCfgMSI.autoClearHA[0] = attentionConditions[0];
+	mb->un.varCfgMSI.autoClearHA[1] = attentionConditions[1];
+
+	/* For now, HBA autoclear does not work reliably, disable it */
+	mb->un.varCfgMSI.autoClearHA[0] = 0;
+	mb->un.varCfgMSI.autoClearHA[1] = 0;
+
+	/* Set command and owner bit */
+	mb->mbxCommand = MBX_CONFIG_MSI;
+	mb->mbxOwner = OWN_HOST;
+
+	return 0;
+}
+
+/**
  * lpfc_init_link: Prepare a mailbox command for initialize link on a HBA.
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2008-08-24 20:47:07.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2008-08-24 20:50:26.000000000 -0400
@@ -1699,6 +1699,36 @@ lpfc_sli_rsp_pointers_error(struct lpfc_
 }
 
 /**
+ * lpfc_poll_eratt: Error attention polling timer timeout handler.
+ * @ptr: Pointer to address of HBA context object.
+ *
+ * This function is invoked by the Error Attention polling timer when the
+ * timer times out. It will check the SLI Error Attention register for
+ * possible attention events. If so, it will post an Error Attention event
+ * and wake up worker thread to process it. Otherwise, it will set up the
+ * Error Attention polling timer for the next poll.
+ **/
+void lpfc_poll_eratt(unsigned long ptr)
+{
+	struct lpfc_hba *phba;
+	uint32_t eratt = 0;
+
+	phba = (struct lpfc_hba *)ptr;
+
+	/* Check chip HA register for error event */
+	eratt = lpfc_sli_check_eratt(phba);
+
+	if (eratt)
+		/* Tell the worker thread there is work to do */
+		lpfc_worker_wake_up(phba);
+	else
+		/* Restart the timer for next eratt poll */
+		mod_timer(&phba->eratt_poll, jiffies +
+					HZ * LPFC_ERATT_POLL_INTERVAL);
+	return;
+}
+
+/**
  * lpfc_sli_poll_fcp_ring: Handle FCP ring completion in polling mode.
  * @phba: Pointer to HBA context object.
  *
@@ -3011,7 +3041,7 @@ lpfc_sli_hbq_setup(struct lpfc_hba *phba
 }
 
 /**
- * lpfc_do_config_port: Issue config port mailbox command.
+ * lpfc_sli_config_port: Issue config port mailbox command.
  * @phba: Pointer to HBA context object.
  * @sli_mode: sli mode - 2/3
  *
@@ -3023,8 +3053,8 @@ lpfc_sli_hbq_setup(struct lpfc_hba *phba
  * The function returns 0 if successful, else returns negative error
  * code.
  **/
-static int
-lpfc_do_config_port(struct lpfc_hba *phba, int sli_mode)
+int
+lpfc_sli_config_port(struct lpfc_hba *phba, int sli_mode)
 {
 	LPFC_MBOXQ_t *pmb;
 	uint32_t resetcount = 0, rc = 0, done = 0;
@@ -3165,13 +3195,14 @@ lpfc_sli_hba_setup(struct lpfc_hba *phba
 		break;
 	}
 
-	rc = lpfc_do_config_port(phba, mode);
+	rc = lpfc_sli_config_port(phba, mode);
+
 	if (rc && lpfc_sli_mode == 3)
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT | LOG_VPORT,
 				"1820 Unable to select SLI-3.  "
 				"Not supported by adapter.\n");
 	if (rc && mode != 2)
-		rc = lpfc_do_config_port(phba, 2);
+		rc = lpfc_sli_config_port(phba, 2);
 	if (rc)
 		goto lpfc_sli_hba_setup_error;
 
@@ -3192,8 +3223,7 @@ lpfc_sli_hba_setup(struct lpfc_hba *phba
 	if (rc)
 		goto lpfc_sli_hba_setup_error;
 
-				/* Init HBQs */
-
+	/* Init HBQs */
 	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
 		rc = lpfc_sli_hbq_setup(phba);
 		if (rc)
@@ -5128,28 +5158,73 @@ lpfc_sli_flush_mbox_queue(struct lpfc_hb
 }
 
 /**
- * lpfc_intr_handler: The interrupt handler of lpfc driver.
+ * lpfc_sli_check_eratt: check error attention events
+ * @phba: Pointer to HBA context.
+ *
+ * This function is called form timer soft interrupt context to check HBA's
+ * error attention register bit for error attention events.
+ *
+ * This fucntion returns 1 when there is Error Attention in the Host Attention
+ * Register and returns 0 otherwise.
+ **/
+int
+lpfc_sli_check_eratt(struct lpfc_hba *phba)
+{
+	uint32_t ha_copy;
+
+	/* If somebody is waiting to handle an eratt, don't process it
+	 * here. The brdkill function will do this.
+	 */
+	if (phba->link_flag & LS_IGNORE_ERATT)
+		return 0;
+
+	/* Check if interrupt handler handles this ERATT */
+	spin_lock_irq(&phba->hbalock);
+	if (phba->hba_flag & HBA_ERATT_HANDLED) {
+		/* Interrupt handler has handled ERATT */
+		spin_unlock_irq(&phba->hbalock);
+		return 0;
+	}
+
+	/* Read chip Host Attention (HA) register */
+	ha_copy = readl(phba->HAregaddr);
+	if (ha_copy & HA_ERATT) {
+		/* Read host status register to retrieve error event */
+		lpfc_sli_read_hs(phba);
+		/* Set the driver HA work bitmap */
+		phba->work_ha |= HA_ERATT;
+		/* Indicate polling handles this ERATT */
+		phba->hba_flag |= HBA_ERATT_HANDLED;
+		spin_unlock_irq(&phba->hbalock);
+		return 1;
+	}
+	spin_unlock_irq(&phba->hbalock);
+	return 0;
+}
+
+/**
+ * lpfc_sp_intr_handler: The slow-path interrupt handler of lpfc driver.
  * @irq: Interrupt number.
  * @dev_id: The device context pointer.
  *
- * This function is called from the PCI layer when there is
- * an event in the HBA which requires driver attention. When
- * the PCI slot is in error recovery or the HBA is undergoing
- * initialization the interrupt handler will not process the
- * interrupt.
- * The error attention, link attention and els ring attention
- * events are handled by the worker thread. The interrupt
- * handler signals the worker thread and returns for these
- * events.
- * The SCSI ring event and mailbox events are handled in the
- * interrupt context.
- * This function is called without any lock held. It gets the
- * hbalock to access and update SLI data structures.
- * This function returns IRQ_HANDLED when interrupt is handled
- * else it returns IRQ_NONE.
+ * This function is directly called from the PCI layer as an interrupt
+ * service routine when the device is enabled with MSI-X multi-message
+ * interrupt mode and there are slow-path events in the HBA. However,
+ * when the device is enabled with either MSI or Pin-IRQ interrupt mode,
+ * this function is called as part of the device-level interrupt handler.
+ * When the PCI slot is in error recovery or the HBA is undergoing
+ * initialization, the interrupt handler will not process the interrupt.
+ * The link attention and ELS ring attention events are handled by the
+ * worker thread. The interrupt handler signals the worker thread and
+ * and returns for these events. This function is called without any
+ * lock held. It gets the hbalock to access and update SLI data
+ * structures.
+ *
+ * This function returns IRQ_HANDLED when interrupt is handled else it
+ * returns IRQ_NONE.
  **/
 irqreturn_t
-lpfc_intr_handler(int irq, void *dev_id)
+lpfc_sp_intr_handler(int irq, void *dev_id)
 {
 	struct lpfc_hba  *phba;
 	uint32_t ha_copy;
@@ -5168,54 +5243,52 @@ lpfc_intr_handler(int irq, void *dev_id)
 	 * Get the driver's phba structure from the dev_id and
 	 * assume the HBA is not interrupting.
 	 */
-	phba = (struct lpfc_hba *) dev_id;
+	phba = (struct lpfc_hba *)dev_id;
 
 	if (unlikely(!phba))
 		return IRQ_NONE;
 
-	/* If the pci channel is offline, ignore all the interrupts. */
-	if (unlikely(pci_channel_offline(phba->pcidev)))
-		return IRQ_NONE;
-
-	phba->sli.slistat.sli_intr++;
-
 	/*
-	 * Call the HBA to see if it is interrupting.  If not, don't claim
-	 * the interrupt
+	 * Stuff needs to be attented to when this function is invoked as an
+	 * individual interrupt handler in MSI-X multi-message interrupt mode
 	 */
-
-	/* Ignore all interrupts during initialization. */
-	if (unlikely(phba->link_state < LPFC_LINK_DOWN))
-		return IRQ_NONE;
-
-	/*
-	 * Read host attention register to determine interrupt source
-	 * Clear Attention Sources, except Error Attention (to
-	 * preserve status) and Link Attention
-	 */
-	spin_lock(&phba->hbalock);
-	if (phba->sli3_options & LPFC_SLI3_INB_ENABLED &&
-	    (phba->inb_last_counter != *phba->inb_counter)) {
-		phba->inb_last_counter = *phba->inb_counter;
-		ha_copy = le32_to_cpu(*phba->inb_ha_copy);
-	} else
+	if (phba->intr_type == MSIX) {
+		/* If the pci channel is offline, ignore all the interrupts */
+		if (unlikely(pci_channel_offline(phba->pcidev)))
+			return IRQ_NONE;
+		/* Update device-level interrupt statistics */
+		phba->sli.slistat.sli_intr++;
+		/* Ignore all interrupts during initialization. */
+		if (unlikely(phba->link_state < LPFC_LINK_DOWN))
+			return IRQ_NONE;
+		/* Need to read HA REG for slow-path events */
+		spin_lock(&phba->hbalock);
 		ha_copy = readl(phba->HAregaddr);
-	if (unlikely(!ha_copy)) {
+		/* If somebody is waiting to handle an eratt don't process it
+		 * here. The brdkill function will do this.
+		 */
+		if (phba->link_flag & LS_IGNORE_ERATT)
+			ha_copy &= ~HA_ERATT;
+		/* Check the need for handling ERATT in interrupt handler */
+		if (ha_copy & HA_ERATT) {
+			if (phba->hba_flag & HBA_ERATT_HANDLED)
+				/* ERATT polling has handled ERATT */
+				ha_copy &= ~HA_ERATT;
+			else
+				/* Indicate interrupt handler handles ERATT */
+				phba->hba_flag |= HBA_ERATT_HANDLED;
+		}
+		/* Clear up only attention source related to slow-path */
+		writel((ha_copy & (HA_MBATT | HA_R2_CLR_MSK)),
+			phba->HAregaddr);
+		readl(phba->HAregaddr); /* flush */
 		spin_unlock(&phba->hbalock);
-		return IRQ_NONE;
-	}
-	/* If somebody is waiting to handle an eratt don't process it
-	 * here.  The brdkill function will do this.
-	 */
-	if (phba->link_flag & LS_IGNORE_ERATT)
-		ha_copy &= ~HA_ERATT;
-	writel((ha_copy & ~(HA_LATT | HA_ERATT)), phba->HAregaddr);
-	readl(phba->HAregaddr); /* flush */
-	spin_unlock(&phba->hbalock);
+	} else
+		ha_copy = phba->ha_copy;
 
 	work_ha_copy = ha_copy & phba->work_ha_mask;
 
-	if (unlikely(work_ha_copy)) {
+	if (work_ha_copy) {
 		if (work_ha_copy & HA_LATT) {
 			if (phba->sli.sli_flag & LPFC_PROCESS_LA) {
 				/*
@@ -5234,7 +5307,7 @@ lpfc_intr_handler(int irq, void *dev_id)
 				work_ha_copy &= ~HA_LATT;
 		}
 
-		if (work_ha_copy & ~(HA_ERATT|HA_MBATT|HA_LATT)) {
+		if (work_ha_copy & ~(HA_ERATT | HA_MBATT | HA_LATT)) {
 			/*
 			 * Turn off Slow Rings interrupts, LPFC_ELS_RING is
 			 * the only slow ring.
@@ -5275,28 +5348,10 @@ lpfc_intr_handler(int irq, void *dev_id)
 				spin_unlock(&phba->hbalock);
 			}
 		}
-
-		if (work_ha_copy & HA_ERATT) {
-			/*
-			 * There was a link/board error.  Read the
-			 * status register to retrieve the error event
-			 * and process it.
-			 */
-			phba->sli.slistat.err_attn_event++;
-			/* Save status info */
-			phba->work_hs = readl(phba->HSregaddr);
-			phba->work_status[0] = readl(phba->MBslimaddr + 0xa8);
-			phba->work_status[1] = readl(phba->MBslimaddr + 0xac);
-
-			/* Clear Chip error bit */
-			writel(HA_ERATT, phba->HAregaddr);
-			readl(phba->HAregaddr); /* flush */
-			phba->pport->stopped = 1;
-		}
-
 		spin_lock(&phba->hbalock);
-		if ((work_ha_copy & HA_MBATT) &&
-		    (phba->sli.mbox_active)) {
+		if (work_ha_copy & HA_ERATT)
+			lpfc_sli_read_hs(phba);
+		if ((work_ha_copy & HA_MBATT) && (phba->sli.mbox_active)) {
 			pmb = phba->sli.mbox_active;
 			pmbox = &pmb->mb;
 			mbox = phba->mbox;
@@ -5379,6 +5434,7 @@ lpfc_intr_handler(int irq, void *dev_id)
 			}
 		} else
 			spin_unlock(&phba->hbalock);
+
 		if ((work_ha_copy & HA_MBATT) &&
 		    (phba->sli.mbox_active == NULL)) {
 send_current_mbox:
@@ -5398,15 +5454,74 @@ send_current_mbox:
 		spin_unlock(&phba->hbalock);
 		lpfc_worker_wake_up(phba);
 	}
+	return IRQ_HANDLED;
 
-	ha_copy &= ~(phba->work_ha_mask);
+} /* lpfc_sp_intr_handler */
+
+/**
+ * lpfc_fp_intr_handler: The fast-path interrupt handler of lpfc driver.
+ * @irq: Interrupt number.
+ * @dev_id: The device context pointer.
+ *
+ * This function is directly called from the PCI layer as an interrupt
+ * service routine when the device is enabled with MSI-X multi-message
+ * interrupt mode and there is a fast-path FCP IOCB ring event in the
+ * HBA. However, when the device is enabled with either MSI or Pin-IRQ
+ * interrupt mode, this function is called as part of the device-level
+ * interrupt handler. When the PCI slot is in error recovery or the HBA
+ * is undergoing initialization, the interrupt handler will not process
+ * the interrupt. The SCSI FCP fast-path ring event are handled in the
+ * intrrupt context. This function is called without any lock held. It
+ * gets the hbalock to access and update SLI data structures.
+ *
+ * This function returns IRQ_HANDLED when interrupt is handled else it
+ * returns IRQ_NONE.
+ **/
+irqreturn_t
+lpfc_fp_intr_handler(int irq, void *dev_id)
+{
+	struct lpfc_hba  *phba;
+	uint32_t ha_copy;
+	unsigned long status;
+
+	/* Get the driver's phba structure from the dev_id and
+	 * assume the HBA is not interrupting.
+	 */
+	phba = (struct lpfc_hba *) dev_id;
+
+	if (unlikely(!phba))
+		return IRQ_NONE;
+
+	/*
+	 * Stuff needs to be attented to when this function is invoked as an
+	 * individual interrupt handler in MSI-X multi-message interrupt mode
+	 */
+	if (phba->intr_type == MSIX) {
+		/* If pci channel is offline, ignore all the interrupts */
+		if (unlikely(pci_channel_offline(phba->pcidev)))
+			return IRQ_NONE;
+		/* Update device-level interrupt statistics */
+		phba->sli.slistat.sli_intr++;
+		/* Ignore all interrupts during initialization. */
+		if (unlikely(phba->link_state < LPFC_LINK_DOWN))
+			return IRQ_NONE;
+		/* Need to read HA REG for FCP ring and other ring events */
+		ha_copy = readl(phba->HAregaddr);
+		/* Clear up only attention source related to fast-path */
+		spin_lock(&phba->hbalock);
+		writel((ha_copy & (HA_R0_CLR_MSK | HA_R1_CLR_MSK)),
+			phba->HAregaddr);
+		readl(phba->HAregaddr); /* flush */
+		spin_unlock(&phba->hbalock);
+	} else
+		ha_copy = phba->ha_copy;
 
 	/*
-	 * Process all events on FCP ring.  Take the optimized path for
-	 * FCP IO.  Any other IO is slow path and is handled by
-	 * the worker thread.
+	 * Process all events on FCP ring. Take the optimized path for FCP IO.
 	 */
-	status = (ha_copy & (HA_RXMASK  << (4*LPFC_FCP_RING)));
+	ha_copy &= ~(phba->work_ha_mask);
+
+	status = (ha_copy & (HA_RXMASK << (4*LPFC_FCP_RING)));
 	status >>= (4*LPFC_FCP_RING);
 	if (status & HA_RXMASK)
 		lpfc_sli_handle_fast_ring_event(phba,
@@ -5415,11 +5530,10 @@ send_current_mbox:
 
 	if (phba->cfg_multi_ring_support == 2) {
 		/*
-		 * Process all events on extra ring.  Take the optimized path
-		 * for extra ring IO.  Any other IO is slow path and is handled
-		 * by the worker thread.
+		 * Process all events on extra ring. Take the optimized path
+		 * for extra ring IO.
 		 */
-		status = (ha_copy & (HA_RXMASK  << (4*LPFC_EXTRA_RING)));
+		status = (ha_copy & (HA_RXMASK << (4*LPFC_EXTRA_RING)));
 		status >>= (4*LPFC_EXTRA_RING);
 		if (status & HA_RXMASK) {
 			lpfc_sli_handle_fast_ring_event(phba,
@@ -5428,5 +5542,106 @@ send_current_mbox:
 		}
 	}
 	return IRQ_HANDLED;
+}  /* lpfc_fp_intr_handler */
+
+/**
+ * lpfc_intr_handler: The device-level interrupt handler of lpfc driver.
+ * @irq: Interrupt number.
+ * @dev_id: The device context pointer.
+ *
+ * This function is the device-level interrupt handler called from the PCI
+ * layer when either MSI or Pin-IRQ interrupt mode is enabled and there is
+ * an event in the HBA which requires driver attention. This function
+ * invokes the slow-path interrupt attention handling function and fast-path
+ * interrupt attention handling function in turn to process the relevant
+ * HBA attention events. This function is called without any lock held. It
+ * gets the hbalock to access and update SLI data structures.
+ *
+ * This function returns IRQ_HANDLED when interrupt is handled, else it
+ * returns IRQ_NONE.
+ **/
+irqreturn_t
+lpfc_intr_handler(int irq, void *dev_id)
+{
+	struct lpfc_hba  *phba;
+	irqreturn_t sp_irq_rc, fp_irq_rc;
+	unsigned long status1, status2;
+
+	/*
+	 * Get the driver's phba structure from the dev_id and
+	 * assume the HBA is not interrupting.
+	 */
+	phba = (struct lpfc_hba *) dev_id;
+
+	if (unlikely(!phba))
+		return IRQ_NONE;
+
+	/* If the pci channel is offline, ignore all the interrupts. */
+	if (unlikely(pci_channel_offline(phba->pcidev)))
+		return IRQ_NONE;
+
+	/* Update device level interrupt statistics */
+	phba->sli.slistat.sli_intr++;
+
+	/* Ignore all interrupts during initialization. */
+	if (unlikely(phba->link_state < LPFC_LINK_DOWN))
+		return IRQ_NONE;
+
+	spin_lock(&phba->hbalock);
+	phba->ha_copy = readl(phba->HAregaddr);
+	if (unlikely(!phba->ha_copy)) {
+		spin_unlock(&phba->hbalock);
+		return IRQ_NONE;
+	} else if (phba->ha_copy & HA_ERATT) {
+		if (phba->hba_flag & HBA_ERATT_HANDLED)
+			/* ERATT polling has handled ERATT */
+			phba->ha_copy &= ~HA_ERATT;
+		else
+			/* Indicate interrupt handler handles ERATT */
+			phba->hba_flag |= HBA_ERATT_HANDLED;
+	}
+
+	/* Clear attention sources except link and error attentions */
+	writel((phba->ha_copy & ~(HA_LATT | HA_ERATT)), phba->HAregaddr);
+	readl(phba->HAregaddr); /* flush */
+	spin_unlock(&phba->hbalock);
+
+	/*
+	 * Invokes slow-path host attention interrupt handling as appropriate.
+	 */
+
+	/* status of events with mailbox and link attention */
+	status1 = phba->ha_copy & (HA_MBATT | HA_LATT | HA_ERATT);
+
+	/* status of events with ELS ring */
+	status2 = (phba->ha_copy & (HA_RXMASK  << (4*LPFC_ELS_RING)));
+	status2 >>= (4*LPFC_ELS_RING);
+
+	if (status1 || (status2 & HA_RXMASK))
+		sp_irq_rc = lpfc_sp_intr_handler(irq, dev_id);
+	else
+		sp_irq_rc = IRQ_NONE;
+
+	/*
+	 * Invoke fast-path host attention interrupt handling as appropriate.
+	 */
+
+	/* status of events with FCP ring */
+	status1 = (phba->ha_copy & (HA_RXMASK << (4*LPFC_FCP_RING)));
+	status1 >>= (4*LPFC_FCP_RING);
+
+	/* status of events with extra ring */
+	if (phba->cfg_multi_ring_support == 2) {
+		status2 = (phba->ha_copy & (HA_RXMASK << (4*LPFC_EXTRA_RING)));
+		status2 >>= (4*LPFC_EXTRA_RING);
+	} else
+		status2 = 0;
+
+	if ((status1 & HA_RXMASK) || (status2 & HA_RXMASK))
+		fp_irq_rc = lpfc_fp_intr_handler(irq, dev_id);
+	else
+		fp_irq_rc = IRQ_NONE;
 
-} /* lpfc_intr_handler */
+	/* Return device-level interrupt handling status */
+	return (sp_irq_rc == IRQ_HANDLED) ? sp_irq_rc : fp_irq_rc;
+}  /* lpfc_intr_handler */
diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2008-06-30 09:31:58.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_version.h	2008-08-24 20:50:26.000000000 -0400
@@ -20,7 +20,9 @@
 
 #define LPFC_DRIVER_VERSION "8.2.7"
 
-#define LPFC_DRIVER_NAME "lpfc"
+#define LPFC_DRIVER_NAME		"lpfc"
+#define LPFC_SP_DRIVER_HANDLER_NAME	"lpfc:sp"
+#define LPFC_FP_DRIVER_HANDLER_NAME	"lpfc:fp"
 
 #define LPFC_MODULE_DESC "Emulex LightPulse Fibre Channel SCSI driver " \
 		LPFC_DRIVER_VERSION


