From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 2/9] lpfc 8.1.11 :  Fix lpfc_multi_ring_support
Date: Sat, 02 Dec 2006 13:34:16 -0500
Message-ID: <1165084456.27443.23.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:55255 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1759467AbWLBQHE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Dec 2006 11:07:04 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id kB2G71af009324
	for <linux-scsi@vger.kernel.org>; Sat, 2 Dec 2006 08:07:03 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix lpfc_multi_ring_support.
  It was not accounted for in the fast/slow rings.
  Genericize the implementation and control it via sysfs

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2006-12-01 12:13:54.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2006-12-02 11:54:22.000000000 -0500
@@ -802,7 +802,6 @@ static CLASS_DEVICE_ATTR(lpfc_devloss_tm
 # LOG_MBOX                      0x4        Mailbox events
 # LOG_INIT                      0x8        Initialization events
 # LOG_LINK_EVENT                0x10       Link events
-# LOG_IP                        0x20       IP traffic history
 # LOG_FCP                       0x40       FCP traffic history
 # LOG_NODE                      0x80       Node table events
 # LOG_MISC                      0x400      Miscellaneous events
@@ -916,6 +915,22 @@ LPFC_ATTR_R(multi_ring_support, 1, 1, 2,
 		"SLI rings to spread IOCB entries across");
 
 /*
+# lpfc_multi_ring_rctl:  If lpfc_multi_ring_support is enabled, this
+# identifies what rctl value to configure the additional ring for.
+# Value range is [1,0xff]. Default value is 4 (Unsolicated Data).
+*/
+LPFC_ATTR_R(multi_ring_rctl, FC_UNSOL_DATA, 1,
+	     255, "Identifies RCTL for additional ring configuration");
+
+/*
+# lpfc_multi_ring_type:  If lpfc_multi_ring_support is enabled, this
+# identifies what type value to configure the additional ring for.
+# Value range is [1,0xff]. Default value is 5 (LLC/SNAP).
+*/
+LPFC_ATTR_R(multi_ring_type, FC_LLC_SNAP, 1,
+	     255, "Identifies TYPE for additional ring configuration");
+
+/*
 # lpfc_fdmi_on: controls FDMI support.
 #       0 = no FDMI support
 #       1 = support FDMI without attribute of hostname
@@ -974,6 +989,8 @@ struct class_device_attribute *lpfc_host
 	&class_device_attr_lpfc_cr_delay,
 	&class_device_attr_lpfc_cr_count,
 	&class_device_attr_lpfc_multi_ring_support,
+	&class_device_attr_lpfc_multi_ring_rctl,
+	&class_device_attr_lpfc_multi_ring_type,
 	&class_device_attr_lpfc_fdmi_on,
 	&class_device_attr_lpfc_max_luns,
 	&class_device_attr_nport_evt_cnt,
@@ -1771,6 +1788,8 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_cr_delay_init(phba, lpfc_cr_delay);
 	lpfc_cr_count_init(phba, lpfc_cr_count);
 	lpfc_multi_ring_support_init(phba, lpfc_multi_ring_support);
+	lpfc_multi_ring_rctl_init(phba, lpfc_multi_ring_rctl);
+	lpfc_multi_ring_type_init(phba, lpfc_multi_ring_type);
 	lpfc_lun_queue_depth_init(phba, lpfc_lun_queue_depth);
 	lpfc_fcp_class_init(phba, lpfc_fcp_class);
 	lpfc_use_adisc_init(phba, lpfc_use_adisc);
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2006-12-02 11:53:07.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2006-12-02 11:54:22.000000000 -0500
@@ -1128,7 +1128,7 @@ lpfc_cmpl_els_adisc(struct lpfc_hba * ph
 						mempool_free(mbox,
 						     phba->mbox_mem_pool);
 						lpfc_disc_flush_list(phba);
-						psli->ring[(psli->ip_ring)].
+						psli->ring[(psli->extra_ring)].
 						    flag &=
 						    ~LPFC_STOP_IOCB_EVENT;
 						psli->ring[(psli->fcp_ring)].
@@ -3046,7 +3046,7 @@ lpfc_els_rcv_farp(struct lpfc_hba * phba
 	/* FARP-REQ received from DID <did> */
 	lpfc_printf_log(phba,
 			 KERN_INFO,
-			 LOG_IP,
+			 LOG_ELS,
 			 "%d:0601 FARP-REQ received from DID x%x\n",
 			 phba->brd_no, did);
 
@@ -3108,7 +3108,7 @@ lpfc_els_rcv_farpr(struct lpfc_hba * phb
 	/* FARP-RSP received from DID <did> */
 	lpfc_printf_log(phba,
 			 KERN_INFO,
-			 LOG_IP,
+			 LOG_ELS,
 			 "%d:0600 FARP-RSP received from DID x%x\n",
 			 phba->brd_no, did);
 
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2006-12-01 12:13:54.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2006-12-02 11:54:22.000000000 -0500
@@ -296,6 +296,8 @@ struct lpfc_hba {
 	uint32_t cfg_cr_delay;
 	uint32_t cfg_cr_count;
 	uint32_t cfg_multi_ring_support;
+	uint32_t cfg_multi_ring_rctl;
+	uint32_t cfg_multi_ring_type;
 	uint32_t cfg_fdmi_on;
 	uint32_t cfg_discovery_threads;
 	uint32_t cfg_max_luns;
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2006-12-02 11:53:07.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2006-12-02 11:54:22.000000000 -0500
@@ -525,7 +525,7 @@ lpfc_mbx_cmpl_clear_la(struct lpfc_hba *
 	psli = &phba->sli;
 	mb = &pmb->mb;
 	/* Since we don't do discovery right now, turn these off here */
-	psli->ring[psli->ip_ring].flag &= ~LPFC_STOP_IOCB_EVENT;
+	psli->ring[psli->extra_ring].flag &= ~LPFC_STOP_IOCB_EVENT;
 	psli->ring[psli->fcp_ring].flag &= ~LPFC_STOP_IOCB_EVENT;
 	psli->ring[psli->next_ring].flag &= ~LPFC_STOP_IOCB_EVENT;
 
@@ -641,7 +641,7 @@ out:
 	if (rc == MBX_NOT_FINISHED) {
 		mempool_free(pmb, phba->mbox_mem_pool);
 		lpfc_disc_flush_list(phba);
-		psli->ring[(psli->ip_ring)].flag &= ~LPFC_STOP_IOCB_EVENT;
+		psli->ring[(psli->extra_ring)].flag &= ~LPFC_STOP_IOCB_EVENT;
 		psli->ring[(psli->fcp_ring)].flag &= ~LPFC_STOP_IOCB_EVENT;
 		psli->ring[(psli->next_ring)].flag &= ~LPFC_STOP_IOCB_EVENT;
 		phba->hba_state = LPFC_HBA_READY;
@@ -696,7 +696,7 @@ out:
 		    == MBX_NOT_FINISHED) {
 			mempool_free( pmb, phba->mbox_mem_pool);
 			lpfc_disc_flush_list(phba);
-			psli->ring[(psli->ip_ring)].flag &=
+			psli->ring[(psli->extra_ring)].flag &=
 			    ~LPFC_STOP_IOCB_EVENT;
 			psli->ring[(psli->fcp_ring)].flag &=
 			    ~LPFC_STOP_IOCB_EVENT;
@@ -1424,7 +1424,7 @@ lpfc_check_sli_ndlp(struct lpfc_hba * ph
 			if (iocb->context1 == (uint8_t *) ndlp)
 				return 1;
 		}
-	} else if (pring->ringno == psli->ip_ring) {
+	} else if (pring->ringno == psli->extra_ring) {
 
 	} else if (pring->ringno == psli->fcp_ring) {
 		/* Skip match check if waiting to relogin to FCP target */
@@ -1889,7 +1889,7 @@ lpfc_disc_start(struct lpfc_hba * phba)
 			if (rc == MBX_NOT_FINISHED) {
 				mempool_free( mbox, phba->mbox_mem_pool);
 				lpfc_disc_flush_list(phba);
-				psli->ring[(psli->ip_ring)].flag &=
+				psli->ring[(psli->extra_ring)].flag &=
 					~LPFC_STOP_IOCB_EVENT;
 				psli->ring[(psli->fcp_ring)].flag &=
 					~LPFC_STOP_IOCB_EVENT;
@@ -2268,7 +2268,7 @@ lpfc_disc_timeout_handler(struct lpfc_hb
 
 	if (clrlaerr) {
 		lpfc_disc_flush_list(phba);
-		psli->ring[(psli->ip_ring)].flag &= ~LPFC_STOP_IOCB_EVENT;
+		psli->ring[(psli->extra_ring)].flag &= ~LPFC_STOP_IOCB_EVENT;
 		psli->ring[(psli->fcp_ring)].flag &= ~LPFC_STOP_IOCB_EVENT;
 		psli->ring[(psli->next_ring)].flag &= ~LPFC_STOP_IOCB_EVENT;
 		phba->hba_state = LPFC_HBA_READY;
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2006-12-02 11:53:07.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2006-12-02 11:54:22.000000000 -0500
@@ -42,14 +42,14 @@
 #define FCELSSIZE             1024	/* maximum ELS transfer size */
 
 #define LPFC_FCP_RING            0	/* ring 0 for FCP initiator commands */
-#define LPFC_IP_RING             1	/* ring 1 for IP commands */
+#define LPFC_EXTRA_RING          1	/* ring 1 for other protocols */
 #define LPFC_ELS_RING            2	/* ring 2 for ELS commands */
 #define LPFC_FCP_NEXT_RING       3
 
 #define SLI2_IOCB_CMD_R0_ENTRIES    172	/* SLI-2 FCP command ring entries */
 #define SLI2_IOCB_RSP_R0_ENTRIES    134	/* SLI-2 FCP response ring entries */
-#define SLI2_IOCB_CMD_R1_ENTRIES      4	/* SLI-2 IP command ring entries */
-#define SLI2_IOCB_RSP_R1_ENTRIES      4	/* SLI-2 IP response ring entries */
+#define SLI2_IOCB_CMD_R1_ENTRIES      4	/* SLI-2 extra command ring entries */
+#define SLI2_IOCB_RSP_R1_ENTRIES      4	/* SLI-2 extra response ring entries */
 #define SLI2_IOCB_CMD_R1XTRA_ENTRIES 36	/* SLI-2 extra FCP cmd ring entries */
 #define SLI2_IOCB_RSP_R1XTRA_ENTRIES 52	/* SLI-2 extra FCP rsp ring entries */
 #define SLI2_IOCB_CMD_R2_ENTRIES     20	/* SLI-2 ELS command ring entries */
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2006-12-01 12:13:54.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2006-12-02 11:54:22.000000000 -0500
@@ -349,8 +349,8 @@ lpfc_config_port_post(struct lpfc_hba * 
 	phba->hba_state = LPFC_LINK_DOWN;
 
 	/* Only process IOCBs on ring 0 till hba_state is READY */
-	if (psli->ring[psli->ip_ring].cmdringaddr)
-		psli->ring[psli->ip_ring].flag |= LPFC_STOP_IOCB_EVENT;
+	if (psli->ring[psli->extra_ring].cmdringaddr)
+		psli->ring[psli->extra_ring].flag |= LPFC_STOP_IOCB_EVENT;
 	if (psli->ring[psli->fcp_ring].cmdringaddr)
 		psli->ring[psli->fcp_ring].flag |= LPFC_STOP_IOCB_EVENT;
 	if (psli->ring[psli->next_ring].cmdringaddr)
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2006-12-01 12:13:54.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2006-12-02 11:54:22.000000000 -0500
@@ -1098,6 +1098,7 @@ lpfc_sli_handle_fast_ring_event(struct l
 		lpfc_sli_pcimem_bcopy((uint32_t *) entry,
 				      (uint32_t *) &rspiocbq.iocb,
 				      sizeof (IOCB_t));
+		INIT_LIST_HEAD(&(rspiocbq.list));
 		irsp = &rspiocbq.iocb;
 
 		type = lpfc_sli_iocb_cmd_type(irsp->ulpCommand & CMD_IOCB_MASK);
@@ -1149,6 +1150,11 @@ lpfc_sli_handle_fast_ring_event(struct l
 				}
 			}
 			break;
+		case LPFC_UNSOL_IOCB:
+			spin_unlock_irqrestore(phba->host->host_lock, iflag);
+			lpfc_sli_process_unsol_iocb(phba, pring, &rspiocbq);
+			spin_lock_irqsave(phba->host->host_lock, iflag);
+			break;
 		default:
 			if (irsp->ulpCommand == CMD_ADAPTER_MSG) {
 				char adaptermsg[LPFC_MAX_ADPTMSG];
@@ -2472,13 +2478,17 @@ lpfc_extra_ring_setup( struct lpfc_hba *
 	psli = &phba->sli;
 
 	/* Adjust cmd/rsp ring iocb entries more evenly */
+
+	/* Take some away from the FCP ring */
 	pring = &psli->ring[psli->fcp_ring];
 	pring->numCiocb -= SLI2_IOCB_CMD_R1XTRA_ENTRIES;
 	pring->numRiocb -= SLI2_IOCB_RSP_R1XTRA_ENTRIES;
 	pring->numCiocb -= SLI2_IOCB_CMD_R3XTRA_ENTRIES;
 	pring->numRiocb -= SLI2_IOCB_RSP_R3XTRA_ENTRIES;
 
-	pring = &psli->ring[1];
+	/* and give them to the extra ring */
+	pring = &psli->ring[psli->extra_ring];
+
 	pring->numCiocb += SLI2_IOCB_CMD_R1XTRA_ENTRIES;
 	pring->numRiocb += SLI2_IOCB_RSP_R1XTRA_ENTRIES;
 	pring->numCiocb += SLI2_IOCB_CMD_R3XTRA_ENTRIES;
@@ -2488,8 +2498,8 @@ lpfc_extra_ring_setup( struct lpfc_hba *
 	pring->iotag_max = 4096;
 	pring->num_mask = 1;
 	pring->prt[0].profile = 0;      /* Mask 0 */
-	pring->prt[0].rctl = FC_UNSOL_DATA;
-	pring->prt[0].type = 5;
+	pring->prt[0].rctl = phba->cfg_multi_ring_rctl;
+	pring->prt[0].type = phba->cfg_multi_ring_type;
 	pring->prt[0].lpfc_sli_rcv_unsol_event = NULL;
 	return 0;
 }
@@ -2505,7 +2515,7 @@ lpfc_sli_setup(struct lpfc_hba *phba)
 	psli->sli_flag = 0;
 	psli->fcp_ring = LPFC_FCP_RING;
 	psli->next_ring = LPFC_FCP_NEXT_RING;
-	psli->ip_ring = LPFC_IP_RING;
+	psli->extra_ring = LPFC_EXTRA_RING;
 
 	psli->iocbq_lookup = NULL;
 	psli->iocbq_lookup_len = 0;
@@ -2528,7 +2538,7 @@ lpfc_sli_setup(struct lpfc_hba *phba)
 			pring->fast_iotag = pring->iotag_max;
 			pring->num_mask = 0;
 			break;
-		case LPFC_IP_RING:	/* ring 1 - IP */
+		case LPFC_EXTRA_RING:	/* ring 1 - EXTRA */
 			/* numCiocb and numRiocb are used in config_port */
 			pring->numCiocb = SLI2_IOCB_CMD_R1_ENTRIES;
 			pring->numRiocb = SLI2_IOCB_RSP_R1_ENTRIES;
@@ -3238,6 +3248,21 @@ lpfc_intr_handler(int irq, void *dev_id)
 		lpfc_sli_handle_fast_ring_event(phba,
 						&phba->sli.ring[LPFC_FCP_RING],
 						status);
+
+	if (phba->cfg_multi_ring_support == 2) {
+		/*
+		 * Process all events on extra ring.  Take the optimized path
+		 * for extra ring IO.  Any other IO is slow path and is handled
+		 * by the worker thread.
+		 */
+		status = (ha_copy & (HA_RXMASK  << (4*LPFC_EXTRA_RING)));
+		status >>= (4*LPFC_EXTRA_RING);
+		if (status & HA_RXATT) {
+			lpfc_sli_handle_fast_ring_event(phba,
+					&phba->sli.ring[LPFC_EXTRA_RING],
+					status);
+		}
+	}
 	return IRQ_HANDLED;
 
 } /* lpfc_intr_handler */
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2006-12-01 12:13:54.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2006-12-02 11:54:22.000000000 -0500
@@ -198,7 +198,7 @@ struct lpfc_sli {
 	int fcp_ring;		/* ring used for FCP initiator commands */
 	int next_ring;
 
-	int ip_ring;		/* ring used for IP network drv cmds */
+	int extra_ring;		/* extra ring used for other protocols */
 
 	struct lpfc_sli_stat slistat;	/* SLI statistical info */
 	struct list_head mboxq;


