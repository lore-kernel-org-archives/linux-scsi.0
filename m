From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 8/14] lpfc 8.3.0 :  Fix minor issues
Date: Thu, 4 Dec 2008 22:39:29 -0500
Message-ID: <1228448369.19053.49.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:45936 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbYLEOnk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2008 09:43:40 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id mB5Ehecn004246
	for <linux-scsi@vger.kernel.org>; Fri, 5 Dec 2008 06:43:40 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

lpfc 8.3.0 : Fix several minor issues

- Avoid polling HBA Error Attention when HBA's PCI channel is offline
  due to PCI EEH

- Fix handling of RSCN with non-zero event qualifiers

- Remove unnecessary sleeps during HBA initialization which slow down
  driver load

- Fix internal and external loopback on FCoE HBAs

- Fix incorrect decrement of cmd_pending count in lpfc_queuecomand
  error path

- Fix reporting of port busy events to management application

- Rename lpfc_adjust_queue_depth() to lpfc_rampdown_queue_depth() for
  consistency with its partner lpfc_rampup_queue_depth()

- Delete redundant lpfc_cmd->start_time = jiffies assignment in
  lpfc_queuecommand()

- Fix handling for ELS, mailbox and heartbeat time outs in the worker
  thread by removing unnecessary checking of the work_port_events
  flags.

- Fix NULL pointer dereference in lpfc_prep_els_iocb

- In lpfc_device_recov_npr_node(), move clearing of NLP_NPR_2B_DISC
  flag after call to lpfc_cancel_retry_delay_tmo() to keep
  targets-in-discovery count correct

- Remove lpfc_probe_one()'s call to scsi_scan_host() which could cause
  concurrent SCSI scans to step on each other


Signed-off-by: James Smart <James.Smart@emulex.com>


---

 drivers/scsi/lpfc/lpfc_crtn.h      |    2 +-
 drivers/scsi/lpfc/lpfc_els.c       |   32 ++++++++++++++++----------------
 drivers/scsi/lpfc/lpfc_hbadisc.c   |    2 +-
 drivers/scsi/lpfc/lpfc_hw.h        |    6 ++++++
 drivers/scsi/lpfc/lpfc_init.c      |    7 -------
 drivers/scsi/lpfc/lpfc_nportdisc.c |    2 +-
 drivers/scsi/lpfc/lpfc_scsi.c      |   13 ++++++-------
 drivers/scsi/lpfc/lpfc_sli.c       |   27 ++++++++++-----------------
 8 files changed, 41 insertions(+), 50 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -290,7 +290,7 @@ void lpfc_fabric_abort_nport(struct lpfc_nodelist *);
 void lpfc_fabric_abort_hba(struct lpfc_hba *);
 void lpfc_fabric_block_timeout(unsigned long);
 void lpfc_unblock_fabric_iocbs(struct lpfc_hba *);
-void lpfc_adjust_queue_depth(struct lpfc_hba *);
+void lpfc_rampdown_queue_depth(struct lpfc_hba *);
 void lpfc_ramp_down_queue_handler(struct lpfc_hba *);
 void lpfc_ramp_up_queue_handler(struct lpfc_hba *);
 void lpfc_scsi_dev_block(struct lpfc_hba *);
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -275,7 +275,8 @@ lpfc_prep_els_iocb(struct lpfc_vport *vport, uint8_t expectRsp,
 	return elsiocb;
 
 els_iocb_free_pbuf_exit:
-	lpfc_mbuf_free(phba, prsp->virt, prsp->phys);
+	if (expectRsp)
+		lpfc_mbuf_free(phba, prsp->virt, prsp->phys);
 	kfree(pbuflist);
 
 els_iocb_free_prsp_exit:
@@ -2472,6 +2473,15 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	case IOSTAT_LOCAL_REJECT:
 		switch ((irsp->un.ulpWord[4] & 0xff)) {
 		case IOERR_LOOP_OPEN_FAILURE:
+			if (cmd == ELS_CMD_FLOGI) {
+				if (PCI_DEVICE_ID_HORNET ==
+					phba->pcidev->device) {
+					phba->fc_topology = TOPOLOGY_LOOP;
+					phba->pport->fc_myDID = 0;
+					phba->alpa_map[0] = 0;
+					phba->alpa_map[1] = 0;
+				}
+			}
 			if (cmd == ELS_CMD_PLOGI && cmdiocb->retry == 0)
 				delay = 1000;
 			retry = 1;
@@ -3827,27 +3837,21 @@ lpfc_rscn_payload_check(struct lpfc_vport *vport, uint32_t did)
 		while (payload_len) {
 			rscn_did.un.word = be32_to_cpu(*lp++);
 			payload_len -= sizeof(uint32_t);
-			switch (rscn_did.un.b.resv) {
-			case 0:	/* Single N_Port ID effected */
+			switch (rscn_did.un.b.resv & RSCN_ADDRESS_FORMAT_MASK) {
+			case RSCN_ADDRESS_FORMAT_PORT:
 				if (ns_did.un.word == rscn_did.un.word)
 					goto return_did_out;
 				break;
-			case 1:	/* Whole N_Port Area effected */
+			case RSCN_ADDRESS_FORMAT_AREA:
 				if ((ns_did.un.b.domain == rscn_did.un.b.domain)
 				    && (ns_did.un.b.area == rscn_did.un.b.area))
 					goto return_did_out;
 				break;
-			case 2:	/* Whole N_Port Domain effected */
+			case RSCN_ADDRESS_FORMAT_DOMAIN:
 				if (ns_did.un.b.domain == rscn_did.un.b.domain)
 					goto return_did_out;
 				break;
-			default:
-				/* Unknown Identifier in RSCN node */
-				lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
-						 "0217 Unknown Identifier in "
-						 "RSCN payload Data: x%x\n",
-						 rscn_did.un.word);
-			case 3:	/* Whole Fabric effected */
+			case RSCN_ADDRESS_FORMAT_FABRIC:
 				goto return_did_out;
 			}
 		}
@@ -4935,10 +4939,6 @@ lpfc_els_timeout_handler(struct lpfc_vport *vport)
 	uint32_t timeout;
 	uint32_t remote_ID = 0xffffffff;
 
-	/* If the timer is already canceled do nothing */
-	if ((vport->work_port_events & WORKER_ELS_TMO) == 0) {
-		return;
-	}
 	spin_lock_irq(&phba->hbalock);
 	timeout = (uint32_t)(phba->fc_ratov << 1);
 
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -350,7 +350,7 @@ lpfc_send_fastpath_evt(struct lpfc_hba *phba,
 			evt_data_size = sizeof(fast_evt_data->un.
 				read_check_error);
 		} else if ((evt_sub_category == LPFC_EVENT_FABRIC_BUSY) ||
-			(evt_sub_category == IOSTAT_NPORT_BSY)) {
+			(evt_sub_category == LPFC_EVENT_PORT_BUSY)) {
 			evt_data = (char *) &fast_evt_data->un.fabric_evt;
 			evt_data_size = sizeof(fast_evt_data->un.fabric_evt);
 		} else {
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -869,6 +869,12 @@ typedef struct _D_ID {		/* Structure is in Big Endian format */
 	} un;
 } D_ID;
 
+#define RSCN_ADDRESS_FORMAT_PORT	0x0
+#define RSCN_ADDRESS_FORMAT_AREA	0x1
+#define RSCN_ADDRESS_FORMAT_DOMAIN	0x2
+#define RSCN_ADDRESS_FORMAT_FABRIC	0x3
+#define RSCN_ADDRESS_FORMAT_MASK	0x3
+
 /*
  *  Structure to define all ELS Payload types
  */
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -742,11 +742,6 @@ lpfc_hb_timeout_handler(struct lpfc_hba *phba)
 		return;
 
 	spin_lock_irq(&phba->pport->work_port_lock);
-	/* If the timer is already canceled do nothing */
-	if (!(phba->pport->work_port_events & WORKER_HB_TMO)) {
-		spin_unlock_irq(&phba->pport->work_port_lock);
-		return;
-	}
 
 	if (time_after(phba->last_completion_time + LPFC_HB_MBOX_INTERVAL * HZ,
 		jiffies)) {
@@ -2702,8 +2697,6 @@ lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
 		(char *) &adapter_event,
 		LPFC_NL_VENDOR_ID);
 
-	scsi_scan_host(shost);
-
 	return 0;
 
 out_remove_device:
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1929,10 +1929,10 @@ lpfc_device_recov_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	if (vport->fc_flag & FC_RSCN_DEFERRED)
 		return ndlp->nlp_state;
 
+	lpfc_cancel_retry_delay_tmo(vport, ndlp);
 	spin_lock_irq(shost->host_lock);
 	ndlp->nlp_flag &= ~(NLP_NODEV_REMOVE | NLP_NPR_2B_DISC);
 	spin_unlock_irq(shost->host_lock);
-	lpfc_cancel_retry_delay_tmo(vport, ndlp);
 	return ndlp->nlp_state;
 }
 
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -148,7 +148,7 @@ lpfc_send_sdev_queuedepth_change_event(struct lpfc_hba *phba,
 }
 
 /**
- * lpfc_adjust_queue_depth: Post RAMP_DOWN_QUEUE event for worker thread.
+ * lpfc_rampdown_queue_depth: Post RAMP_DOWN_QUEUE event to worker thread.
  * @phba: The Hba for which this call is being executed.
  *
  * This routine is called when there is resource error in driver or firmware.
@@ -159,7 +159,7 @@ lpfc_send_sdev_queuedepth_change_event(struct lpfc_hba *phba,
  * This routine should be called with no lock held.
  **/
 void
-lpfc_adjust_queue_depth(struct lpfc_hba *phba)
+lpfc_rampdown_queue_depth(struct lpfc_hba *phba)
 {
 	unsigned long flags;
 	uint32_t evt_posted;
@@ -1551,7 +1551,7 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 
 	lpfc_cmd = lpfc_get_scsi_buf(phba);
 	if (lpfc_cmd == NULL) {
-		lpfc_adjust_queue_depth(phba);
+		lpfc_rampdown_queue_depth(phba);
 
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
 				 "0707 driver's buffer pool is empty, "
@@ -1559,7 +1559,6 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 		goto out_host_busy;
 	}
 
-	lpfc_cmd->start_time = jiffies;
 	/*
 	 * Store the midlayer's command structure for the completion phase
 	 * and complete the command initialization.
@@ -1580,9 +1579,10 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 	atomic_inc(&ndlp->cmd_pending);
 	err = lpfc_sli_issue_iocb(phba, &phba->sli.ring[psli->fcp_ring],
 				  &lpfc_cmd->cur_iocbq, SLI_IOCB_RET_IOCB);
-	if (err)
+	if (err) {
+		atomic_dec(&ndlp->cmd_pending);
 		goto out_host_busy_free_buf;
-
+	}
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
 		lpfc_sli_poll_fcp_ring(phba);
 		if (phba->cfg_poll & DISABLE_FCP_RING_INT)
@@ -1592,7 +1592,6 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 	return 0;
 
  out_host_busy_free_buf:
-	atomic_dec(&ndlp->cmd_pending);
 	lpfc_scsi_unprep_dma_buf(phba, lpfc_cmd);
 	lpfc_release_scsi_buf(phba, lpfc_cmd);
  out_host_busy:
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1982,7 +1982,7 @@ lpfc_sli_handle_fast_ring_event(struct lpfc_hba *phba,
 			if ((irsp->ulpStatus == IOSTAT_LOCAL_REJECT) &&
 				(irsp->un.ulpWord[4] == IOERR_NO_RESOURCES)) {
 				spin_unlock_irqrestore(&phba->hbalock, iflag);
-				lpfc_adjust_queue_depth(phba);
+				lpfc_rampdown_queue_depth(phba);
 				spin_lock_irqsave(&phba->hbalock, iflag);
 			}
 
@@ -2225,7 +2225,7 @@ lpfc_sli_handle_slow_ring_event(struct lpfc_hba *phba,
 			if ((irsp->ulpStatus == IOSTAT_LOCAL_REJECT) &&
 			     (irsp->un.ulpWord[4] == IOERR_NO_RESOURCES)) {
 				spin_unlock_irqrestore(&phba->hbalock, iflag);
-				lpfc_adjust_queue_depth(phba);
+				lpfc_rampdown_queue_depth(phba);
 				spin_lock_irqsave(&phba->hbalock, iflag);
 			}
 
@@ -2790,7 +2790,6 @@ lpfc_sli_brdrestart(struct lpfc_hba *phba)
 {
 	MAILBOX_t *mb;
 	struct lpfc_sli *psli;
-	uint16_t skip_post;
 	volatile uint32_t word0;
 	void __iomem *to_slim;
 
@@ -2815,13 +2814,10 @@ lpfc_sli_brdrestart(struct lpfc_hba *phba)
 	readl(to_slim); /* flush */
 
 	/* Only skip post after fc_ffinit is completed */
-	if (phba->pport->port_state) {
-		skip_post = 1;
+	if (phba->pport->port_state)
 		word0 = 1;	/* This is really setting up word1 */
-	} else {
-		skip_post = 0;
+	else
 		word0 = 0;	/* This is really setting up word1 */
-	}
 	to_slim = phba->MBslimaddr + sizeof (uint32_t);
 	writel(*(uint32_t *) mb, to_slim);
 	readl(to_slim); /* flush */
@@ -2835,10 +2831,8 @@ lpfc_sli_brdrestart(struct lpfc_hba *phba)
 	memset(&psli->lnk_stat_offsets, 0, sizeof(psli->lnk_stat_offsets));
 	psli->stats_start = get_seconds();
 
-	if (skip_post)
-		mdelay(100);
-	else
-		mdelay(2000);
+	/* Give the INITFF and Post time to settle. */
+	mdelay(100);
 
 	lpfc_hba_down_post(phba);
 
@@ -3084,7 +3078,6 @@ lpfc_sli_config_port(struct lpfc_hba *phba, int sli_mode)
 		spin_unlock_irq(&phba->hbalock);
 		phba->pport->port_state = LPFC_VPORT_UNKNOWN;
 		lpfc_sli_brdrestart(phba);
-		msleep(2500);
 		rc = lpfc_sli_chipset_init(phba);
 		if (rc)
 			break;
@@ -3308,10 +3301,6 @@ lpfc_mbox_timeout_handler(struct lpfc_hba *phba)
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring *pring;
 
-	if (!(phba->pport->work_port_events & WORKER_MBOX_TMO)) {
-		return;
-	}
-
 	/* Mbox cmd <mbxCommand> timeout */
 	lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
 			"0310 Mailbox command x%x timeout Data: x%x x%x x%p\n",
@@ -5187,6 +5176,10 @@ lpfc_sli_check_eratt(struct lpfc_hba *phba)
 {
 	uint32_t ha_copy;
 
+	/* If PCI channel is offline, don't process it */
+	if (unlikely(pci_channel_offline(phba->pcidev)))
+		return 0;
+
 	/* If somebody is waiting to handle an eratt, don't process it
 	 * here. The brdkill function will do this.
 	 */


