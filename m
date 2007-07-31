From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 7/8] lpfc 8.2.2 : Style cleanups
Date: Tue, 31 Jul 2007 21:27:58 +0000 (UTC)
Message-ID: <1186067437.14374.26.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:50155 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763049AbXGaV1A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 17:27:00 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l6VLQniq028958
	for <linux-scsi@vger.kernel.org>; Tue, 31 Jul 2007 14:26:59 -0700 (PDT)
Date: Thu, 02 Aug 2007 11:10:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Style cleanups:
- Clean up all instances of mixed tab-space indentation
- Clean up sparse build errors
- Add appropriate static's

Signed-off-by: James Smart <James.Smart@emulex.com>



diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2007-08-02 07:47:05.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2007-08-02 09:07:36.000000000 -0400
@@ -430,7 +430,7 @@ lpfc_board_mode_store(struct class_devic
 		return -EIO;
 }
 
-int
+static int
 lpfc_get_hba_info(struct lpfc_hba *phba,
 		  uint32_t *mxri, uint32_t *axri,
 		  uint32_t *mrpi, uint32_t *arpi,
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2007-08-02 09:05:59.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2007-08-02 09:07:36.000000000 -0400
@@ -278,6 +278,7 @@ extern void lpfc_debugfs_disc_trc(struct
 	uint32_t, uint32_t);
 extern void lpfc_debugfs_slow_ring_trc(struct lpfc_hba *, char *, uint32_t,
 	uint32_t, uint32_t);
+extern struct lpfc_hbq_init *lpfc_hbq_defs[];
 
 /* Interface exported by fabric iocb scheduler */
 int lpfc_issue_fabric_iocb(struct lpfc_hba *, struct lpfc_iocbq *);
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2007-08-02 07:54:07.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2007-08-02 09:07:36.000000000 -0400
@@ -688,7 +688,7 @@ out:
 	return;
 }
 
-void
+static void
 lpfc_cmpl_ct_cmd_gff_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			struct lpfc_iocbq *rspiocb)
 {
@@ -885,7 +885,7 @@ lpfc_cmpl_ct_cmd_rff_id(struct lpfc_hba 
 	return;
 }
 
-int
+static int
 lpfc_vport_symbolic_port_name(struct lpfc_vport *vport, char *symbol,
 	size_t size)
 {
diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c	2007-08-02 07:55:03.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2007-08-02 09:07:36.000000000 -0400
@@ -112,10 +112,8 @@ struct lpfc_debug {
 	int  len;
 };
 
-extern struct lpfc_hbq_init *lpfc_hbq_defs[];
-
-atomic_t lpfc_debugfs_seq_trc_cnt = ATOMIC_INIT(0);
-unsigned long lpfc_debugfs_start_time = 0L;
+static atomic_t lpfc_debugfs_seq_trc_cnt = ATOMIC_INIT(0);
+static unsigned long lpfc_debugfs_start_time = 0L;
 
 static int
 lpfc_debugfs_disc_trc_data(struct lpfc_vport *vport, char *buf, int size)
@@ -201,7 +199,7 @@ lpfc_debugfs_slow_ring_trc_data(struct l
 	return len;
 }
 
-int lpfc_debugfs_last_hbq = -1;
+static int lpfc_debugfs_last_hbq = -1;
 
 static int
 lpfc_debugfs_hbqinfo_data(struct lpfc_hba *phba, char *buf, int size)
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2007-08-02 09:05:49.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2007-08-02 09:07:10.000000000 -0400
@@ -45,7 +45,7 @@ struct lpfc_sli2_slim;
 #define LPFC_DISC_IOCB_BUFF_COUNT 20
 
 #define LPFC_HB_MBOX_INTERVAL   5	/* Heart beat interval in seconds. */
-#define LPFC_HB_MBOX_TIMEOUT    30 	/* Heart beat timeout  in seconds. */
+#define LPFC_HB_MBOX_TIMEOUT    30	/* Heart beat timeout  in seconds. */
 
 /* Define macros for 64 bit support */
 #define putPaddrLow(addr)    ((uint32_t) (0xffffffff & (u64)(addr)))
@@ -381,7 +381,7 @@ struct lpfc_hba {
 	struct lpfc_sli sli;
 	uint32_t sli_rev;		/* SLI2 or SLI3 */
 	uint32_t sli3_options;		/* Mask of enabled SLI3 options */
-#define LPFC_SLI3_ENABLED 	 0x01
+#define LPFC_SLI3_ENABLED	 0x01
 #define LPFC_SLI3_HBQ_ENABLED	 0x02
 #define LPFC_SLI3_NPIV_ENABLED	 0x04
 #define LPFC_SLI3_VPORT_TEARDOWN 0x08
@@ -390,7 +390,7 @@ struct lpfc_hba {
 
 	enum hba_state link_state;
 	uint32_t link_flag;	/* link state flags */
-#define LS_LOOPBACK_MODE      0x1 	/* NPort is in Loopback mode */
+#define LS_LOOPBACK_MODE      0x1	/* NPort is in Loopback mode */
 					/* This flag is set while issuing */
 					/* INIT_LINK mailbox command */
 #define LS_NPIV_FAB_SUPPORTED 0x2	/* Fabric supports NPIV */
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-08-02 09:05:59.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-08-02 09:07:36.000000000 -0400
@@ -349,7 +349,7 @@ lpfc_work_list_done(struct lpfc_hba *phb
 
 }
 
-void
+static void
 lpfc_work_done(struct lpfc_hba *phba)
 {
 	struct lpfc_sli_ring *pring;
@@ -1591,7 +1591,7 @@ lpfc_nlp_state_name(char *buffer, size_t
 		[NLP_STE_NPR_NODE] = "NPR",
 	};
 
-	if (state < ARRAY_SIZE(states) && states[state])
+	if (state < NLP_STE_MAX_STATE && states[state])
 		strlcpy(buffer, states[state], size);
 	else
 		snprintf(buffer, size, "unknown (%d)", state);
@@ -2815,32 +2815,6 @@ lpfc_findnode_wwpn(struct lpfc_vport *vp
 }
 
 void
-lpfc_dev_loss_delay(unsigned long ptr)
-{
-	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) ptr;
-	struct lpfc_vport *vport = ndlp->vport;
-	struct lpfc_hba   *phba = vport->phba;
-	struct lpfc_work_evt  *evtp = &ndlp->dev_loss_evt;
-	unsigned long flags;
-
-	evtp = &ndlp->dev_loss_evt;
-
-	spin_lock_irqsave(&phba->hbalock, flags);
-	if (!list_empty(&evtp->evt_listp)) {
-		spin_unlock_irqrestore(&phba->hbalock, flags);
-		return;
-	}
-
-	evtp->evt_arg1  = ndlp;
-	evtp->evt       = LPFC_EVT_DEV_LOSS_DELAY;
-	list_add_tail(&evtp->evt_listp, &phba->work_list);
-	if (phba->work_wait)
-		lpfc_worker_wake_up(phba);
-	spin_unlock_irqrestore(&phba->hbalock, flags);
-	return;
-}
-
-void
 lpfc_nlp_init(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	      uint32_t did)
 {
@@ -2863,7 +2837,7 @@ lpfc_nlp_init(struct lpfc_vport *vport, 
 	return;
 }
 
-void
+static void
 lpfc_nlp_release(struct kref *kref)
 {
 	struct lpfc_nodelist *ndlp = container_of(kref, struct lpfc_nodelist,
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2007-08-02 07:46:06.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2007-08-02 09:07:10.000000000 -0400
@@ -809,7 +809,7 @@ typedef struct _RNID {		/* Structure is 
 	} un;
 } RNID;
 
-typedef struct  _RPS {  	/* Structure is in Big Endian format */
+typedef struct  _RPS {		/* Structure is in Big Endian format */
 	union {
 		uint32_t portNum;
 		struct lpfc_name portName;
@@ -827,7 +827,7 @@ typedef struct  _RPS_RSP {	/* Structure 
 	uint32_t crcCnt;
 } RPS_RSP;
 
-typedef struct  _RPL {  	/* Structure is in Big Endian format */
+typedef struct  _RPL {		/* Structure is in Big Endian format */
 	uint32_t maxsize;
 	uint32_t index;
 } RPL;
@@ -838,7 +838,7 @@ typedef struct  _PORT_NUM_BLK {
 	struct lpfc_name portName;
 } PORT_NUM_BLK;
 
-typedef struct  _RPL_RSP { 	/* Structure is in Big Endian format */
+typedef struct  _RPL_RSP {	/* Structure is in Big Endian format */
 	uint32_t listLen;
 	uint32_t index;
 	PORT_NUM_BLK port_num_blk;
@@ -2617,8 +2617,8 @@ typedef union {
 	LOAD_SM_VAR varLdSM;		/* cmd =  1 (LOAD_SM)        */
 	READ_NV_VAR varRDnvp;		/* cmd =  2 (READ_NVPARMS)   */
 	WRITE_NV_VAR varWTnvp;		/* cmd =  3 (WRITE_NVPARMS)  */
-	BIU_DIAG_VAR varBIUdiag; 	/* cmd =  4 (RUN_BIU_DIAG)   */
-	INIT_LINK_VAR varInitLnk; 	/* cmd =  5 (INIT_LINK)      */
+	BIU_DIAG_VAR varBIUdiag;	/* cmd =  4 (RUN_BIU_DIAG)   */
+	INIT_LINK_VAR varInitLnk;	/* cmd =  5 (INIT_LINK)      */
 	DOWN_LINK_VAR varDwnLnk;	/* cmd =  6 (DOWN_LINK)      */
 	CONFIG_LINK varCfgLnk;		/* cmd =  7 (CONFIG_LINK)    */
 	PART_SLIM_VAR varSlim;		/* cmd =  8 (PART_SLIM)      */
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2007-08-02 07:55:04.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2007-08-02 09:07:36.000000000 -0400
@@ -53,10 +53,6 @@ static struct scsi_transport_template *l
 static struct scsi_transport_template *lpfc_vport_transport_template = NULL;
 static DEFINE_IDR(lpfc_hba_index);
 
-
-
-extern struct lpfc_hbq_init *lpfc_hbq_defs[];
-
 /************************************************************************/
 /*                                                                      */
 /*    lpfc_config_port_prep                                             */
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2007-08-02 09:06:07.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2007-08-02 09:07:36.000000000 -0400
@@ -363,7 +363,7 @@ lpfc_sli_next_iotag(struct lpfc_hba *phb
 			if (psli->iocbq_lookup)
 				memcpy(new_arr, old_arr,
 				       ((psli->last_iotag  + 1) *
-	 				sizeof (struct lpfc_iocbq *)));
+					sizeof (struct lpfc_iocbq *)));
 			psli->iocbq_lookup = new_arr;
 			psli->iocbq_lookup_len = new_len;
 			psli->last_iotag = iotag;
@@ -623,7 +623,7 @@ struct lpfc_hbq_init *lpfc_hbq_defs[] = 
 	&lpfc_extra_hbq,
 };
 
-int
+static int
 lpfc_sli_hbqbuf_fill_hbqs(struct lpfc_hba *phba, uint32_t hbqno, uint32_t count)
 {
 	uint32_t i, start, end;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2007-08-02 09:05:59.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2007-08-02 09:07:10.000000000 -0400
@@ -143,7 +143,7 @@ struct lpfc_sli_ring {
 	uint16_t numCiocb;	/* number of command iocb's per ring */
 	uint16_t numRiocb;	/* number of rsp iocb's per ring */
 	uint16_t sizeCiocb;	/* Size of command iocb's in this ring */
-	uint16_t sizeRiocb; 	/* Size of response iocb's in this ring */
+	uint16_t sizeRiocb;	/* Size of response iocb's in this ring */
 
 	uint32_t fast_iotag;	/* max fastlookup based iotag           */
 	uint32_t iotag_ctr;	/* keeps track of the next iotag to use */
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2007-08-02 07:53:23.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2007-08-02 09:07:36.000000000 -0400
@@ -331,7 +331,7 @@ error_out:
 	return rc;
 }
 
-int
+static int
 disable_vport(struct fc_vport *fc_vport)
 {
 	struct lpfc_vport *vport = *(struct lpfc_vport **)fc_vport->dd_data;
@@ -376,7 +376,7 @@ disable_vport(struct fc_vport *fc_vport)
 	return VPORT_OK;
 }
 
-int
+static int
 enable_vport(struct fc_vport *fc_vport)
 {
 	struct lpfc_vport *vport = *(struct lpfc_vport **)fc_vport->dd_data;


