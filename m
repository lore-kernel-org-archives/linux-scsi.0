From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 03/17] lpfc: Added throttle logging support.
Date: Wed, 16 Dec 2015 18:11:54 -0500
Message-ID: <5671efba.8C/kxNA2eqfImskd%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:36542 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbbLPXMN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2015 18:12:13 -0500
Received: by mail-pf0-f177.google.com with SMTP id o64so19589200pfb.3
        for <linux-scsi@vger.kernel.org>; Wed, 16 Dec 2015 15:12:13 -0800 (PST)
Received: from myfc17 (cm-wififw.emulex.com. [138.239.220.50])
        by smtp.gmail.com with ESMTPSA id r72sm7014463pfa.93.2015.12.16.15.12.11
        for <linux-scsi@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 16 Dec 2015 15:12:12 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Implemented a throttle on error logging.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc.h         |  5 +++
 drivers/scsi/lpfc/lpfc_attr.c    | 18 +++++++++++
 drivers/scsi/lpfc/lpfc_crtn.h    |  1 +
 drivers/scsi/lpfc/lpfc_disc.h    | 11 +++++++
 drivers/scsi/lpfc/lpfc_hbadisc.c | 23 +++++++++++++
 drivers/scsi/lpfc/lpfc_init.c    | 70 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_logmsg.h  | 40 +++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_scsi.c    | 41 ++++++++++++++++-------
 drivers/scsi/lpfc/lpfc_sli.c     |  7 ++++
 9 files changed, 205 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index ceee9a3..df32b0c 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -347,6 +347,7 @@ struct lpfc_vport {
 #define FC_CT_RFT_ID		0x10	 /* RFT_ID accepted by switch */
 
 	struct list_head fc_nodes;
+	uint32_t throttle_cnt;
 
 	/* Keep counters for the number of entries in each list. */
 	uint16_t fc_plogi_cnt;
@@ -443,6 +444,7 @@ struct lpfc_vport {
 	unsigned long rcv_buffer_time_stamp;
 	uint32_t vport_flag;
 #define STATIC_VPORT	1
+	struct throttle_history log;    /* Throttle log history for phba */
 };
 
 struct hbq_s {
@@ -750,6 +752,9 @@ struct lpfc_hba {
 	uint32_t cfg_request_firmware_upgrade;
 	uint32_t cfg_iocb_cnt;
 	uint32_t cfg_suppress_link_up;
+	uint32_t cfg_throttle_log_cnt;
+	uint32_t cfg_throttle_log_time;
+	struct throttle_history log;	/* Throttle log history for phba */
 	uint32_t cfg_rrq_xri_bitmap_sz;
 #define LPFC_INITIALIZE_LINK              0	/* do normal init_link mbox */
 #define LPFC_DELAY_INIT_LINK              1	/* layered driver hold off */
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index f6446d7..6061e5d 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -4773,6 +4773,20 @@ LPFC_ATTR_R(prot_sg_seg_cnt, LPFC_DEFAULT_SG_SEG_CNT,
 	    LPFC_DEFAULT_SG_SEG_CNT, LPFC_MAX_SG_SEG_CNT,
 	    "Max Protection Scatter Gather Segment Count");
 
+#define THROTTLE_CNT_MIN	1
+#define	THROTTLE_CNT_MAX	1000
+#define THROTTLE_CNT_DEF	10
+LPFC_ATTR_RW(throttle_log_cnt, THROTTLE_CNT_DEF, THROTTLE_CNT_MIN,
+	     THROTTLE_CNT_MAX, "Do not exceed this number of messages "
+	     "logged within throttle_log_time");
+
+#define THROTTLE_TIME_MIN        1
+#define THROTTLE_TIME_MAX        60
+#define THROTTLE_TIME_DEF        1
+LPFC_ATTR_RW(throttle_log_time, THROTTLE_TIME_DEF, THROTTLE_TIME_MIN,
+	     THROTTLE_TIME_MAX, "Do not exceed throttle_log_cnt within "
+	     "this limit (seconds)");
+
 struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_bg_info,
 	&dev_attr_bg_guard_err,
@@ -4868,6 +4882,8 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_sriov_hw_max_virtfn,
 	&dev_attr_protocol,
 	&dev_attr_lpfc_xlane_supported,
+	&dev_attr_lpfc_throttle_log_cnt,
+	&dev_attr_lpfc_throttle_log_time,
 	NULL,
 };
 
@@ -5858,6 +5874,8 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_suppress_link_up_init(phba, lpfc_suppress_link_up);
 	lpfc_iocb_cnt_init(phba, lpfc_iocb_cnt);
 	phba->cfg_enable_dss = 1;
+	lpfc_throttle_log_cnt_init(phba, lpfc_throttle_log_cnt);
+	lpfc_throttle_log_time_init(phba, lpfc_throttle_log_time);
 	return;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 80d3c74..a2c2040 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -21,6 +21,7 @@
 typedef int (*node_filter)(struct lpfc_nodelist *, void *);
 
 struct fc_rport;
+bool lpfc_throttler(struct lpfc_vport *, struct throttle_history *);
 void lpfc_down_link(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_sli_read_link_ste(struct lpfc_hba *);
 void lpfc_dump_mem(struct lpfc_hba *, LPFC_MBOXQ_t *, uint16_t, uint16_t);
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 361f5b3..5f7ada1 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -74,8 +74,19 @@ struct lpfc_node_rrqs {
 	unsigned long xri_bitmap[XRI_BITMAP_ULONGS];
 };
 
+struct throttle_history {
+	/* Throttle log defaults if more than 10 messages per second */
+	#define ONE_SEC  1000000 /* one second */
+	bool logit;                 /* True means throttle logging on     */
+	uint32_t log_messages_lost;   /* Messages discarded due to throttle */
+	uint32_t log_messages;        /* Log messages count within second   */
+	uint64_t log_start;           /* start of message burst in usec     */
+	char announcement[16];		/* announcement string */
+};
+
 struct lpfc_nodelist {
 	struct list_head nlp_listp;
+	struct throttle_history log;		/* used to record throttle */
 	struct lpfc_name nlp_portname;
 	struct lpfc_name nlp_nodename;
 	uint32_t         nlp_flag;		/* entry flags */
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index c96532c..f0777f2 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -3959,6 +3959,29 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	    (rport->scsi_target_id < LPFC_MAX_TARGET)) {
 		ndlp->nlp_sid = rport->scsi_target_id;
 	}
+
+	lpfc_throttle_vlog(ndlp->vport, &ndlp->log, LOG_NODE,
+			"3237 SCSI ID %d "
+			" WWNN:%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x, "
+			" WWPN:%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x",
+			ndlp->nlp_sid,
+			ndlp->nlp_nodename.u.wwn[0],
+			ndlp->nlp_nodename.u.wwn[1],
+			ndlp->nlp_nodename.u.wwn[2],
+			ndlp->nlp_nodename.u.wwn[3],
+			ndlp->nlp_nodename.u.wwn[4],
+			ndlp->nlp_nodename.u.wwn[5],
+			ndlp->nlp_nodename.u.wwn[6],
+			ndlp->nlp_nodename.u.wwn[7],
+			ndlp->nlp_portname.u.wwn[0],
+			ndlp->nlp_portname.u.wwn[1],
+			ndlp->nlp_portname.u.wwn[2],
+			ndlp->nlp_portname.u.wwn[3],
+			ndlp->nlp_portname.u.wwn[4],
+			ndlp->nlp_portname.u.wwn[5],
+			ndlp->nlp_portname.u.wwn[6],
+			ndlp->nlp_portname.u.wwn[7]);
+
 	return;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index db9446c..ab27d81 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -9543,6 +9543,9 @@ lpfc_pci_probe_one_s3(struct pci_dev *pdev, const struct pci_device_id *pid)
 	if (error)
 		goto out_disable_pci_dev;
 
+	phba->log.logit = true; /* Turn on throttle logs for Adapter */
+	sprintf(phba->log.announcement, "adapter");
+
 	/* Set up SLI-3 specific device PCI memory space */
 	error = lpfc_sli_pci_mem_setup(phba);
 	if (error) {
@@ -10313,6 +10316,9 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 	if (error)
 		goto out_disable_pci_dev;
 
+	phba->log.logit = true; /* Turn on throttle logs for Adapter */
+	sprintf(phba->log.announcement, "adapter");
+
 	/* Set up SLI-4 specific device PCI memory space */
 	error = lpfc_sli4_pci_mem_setup(phba);
 	if (error) {
@@ -11270,6 +11276,70 @@ lpfc_fof_queue_destroy(struct lpfc_hba *phba)
 	return 0;
 }
 
+/**
+ * lpfc_throttler - lpfc log throttling function
+ * @phba : the adapter instance.
+ *
+ * This routine is to be invoked by lpfc_throttle_log and lpfc_throttle_vlog.
+ * It is controlled using two module parameters.
+ * lpfc_throttle_log_time:  The number of seconds to monitor the log count
+ * lpfc_throttle_log_cnt:   The number of logs that cannot be exceeded within
+ *                          the throttle log time.
+ *
+ * This function acts as a gate to the logger.  It monitors the the lpfc log
+ * load.  If the log load exceeds the threshold, it return false which is a
+ * hint to the caller not to send the log.
+ *
+ * Return codes
+ *   true - Okay to log
+ *   false - Do not log
+ */
+bool
+lpfc_throttler(struct lpfc_vport *vport, struct throttle_history *tlog)
+{
+	/* All times in microseconds */
+	uint64_t now = (jiffies * ONE_SEC) / HZ;
+	struct lpfc_hba *phba = vport->phba;
+
+	if (tlog->logit) {
+		/* Currently Logging */
+		if (now > (tlog->log_start +
+		    (phba->cfg_throttle_log_time * ONE_SEC))) {
+			/* Last Log more than one second ago */
+			tlog->log_messages_lost = 0;
+			tlog->log_messages = 1;
+			tlog->log_start = now;
+		} else if (++tlog->log_messages > phba->cfg_throttle_log_cnt) {
+			/* Transition to throttling */
+			lpfc_printf_log(phba, KERN_INFO, LOG_EVENT,
+					"0040 Log compression on %s starting."
+					"\n", tlog->announcement);
+			tlog->log_messages_lost++;
+			tlog->log_messages = 0;
+			tlog->log_start = now;
+			tlog->logit = false;
+		}
+
+	} else if (now > (tlog->log_start +
+		  (300 * ONE_SEC))) {
+		/* Transition to logging if quiesced for five minutes */
+		lpfc_printf_log(phba, KERN_INFO, LOG_EVENT,
+				"0041 Log compression %s ending, messages "
+				"have been quiesced with %d compressed.\n",
+				tlog->announcement, tlog->log_messages_lost);
+
+
+		tlog->log_start = now;
+		tlog->log_messages_lost = 0;
+		tlog->log_messages = 0;
+		tlog->logit = true;
+	} else {
+		/* Currently throttling */
+		tlog->log_messages_lost++;
+	}
+	return tlog->logit;
+}
+
 static struct pci_device_id lpfc_id_table[] = {
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_VIPER,
 		PCI_ANY_ID, PCI_ANY_ID, },
diff --git a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
index 2a4e5d2..f82b79f 100644
--- a/drivers/scsi/lpfc/lpfc_logmsg.h
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h
@@ -57,3 +57,43 @@ do { \
 			   fmt, phba->brd_no, ##arg); \
 	} \
 } while (0)
+
+#define lpfc_throttle_vlog(vport, hist, log, fmt, arg...) \
+do { \
+	{ if (!lpfc_throttler(vport, (hist))) \
+		break; \
+	lpfc_printf_vlog(vport, KERN_INFO, log, \
+		   fmt, arg); \
+	} \
+} while (0)
+
+#define lpfc_throttle_log(phba, hist, log, fmt, arg...) \
+do { \
+	{ if (!lpfc_throttler((phba->pport), (hist))) \
+		break; \
+	lpfc_printf_log(phba, KERN_INFO, log, \
+		   fmt, arg); \
+	} \
+} while (0)
+
+#define lpfc_optioned_vlog(vport, hist, level, mask, fmt, arg...) \
+do { \
+	{ if (!lpfc_throttler(vport, (hist))) \
+	  { lpfc_printf_vlog(vport, level, mask, fmt, ##arg); \
+		break; \
+	  } \
+	dev_printk(level, &((vport)->phba->pcidev)->dev, "%d:(%d):" \
+		   fmt, (vport)->phba->brd_no, vport->vpi, ##arg); \
+	} \
+} while (0)
+
+#define lpfc_optioned_log(phba, hist, level, mask, fmt, arg...) \
+do { \
+	{ if (!lpfc_throttler((phba->pport), (hist))) \
+	  { lpfc_printf_log(phba, level, mask, fmt, ##arg); \
+		break; \
+	  } \
+	dev_printk(level, &((phba)->pcidev)->dev, "%d:" \
+		   fmt, phba->brd_no, ##arg); \
+	} \
+} while (0)
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 4679ed4..d51f751 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4621,14 +4621,34 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 				  &lpfc_cmd->cur_iocbq, SLI_IOCB_RET_IOCB);
 	if (err) {
 		atomic_dec(&ndlp->cmd_pending);
-		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
-				 "3376 FCP could not issue IOCB err %x"
+		lpfc_throttle_vlog(vport, &vport->log, LOG_FCP,
+				   "3376 FCP could not issue IOCB err %x "
+				   "FCP cmd x%x <%d/%llu> "
+				   "sid: x%x did: x%x oxid: x%x "
+				   "Data: x%x x%x x%x x%x\n",
+				   err, cmnd->cmnd[0],
+				   cmnd->device ? cmnd->device->id : 0xffff,
+				   cmnd->device ? cmnd->device->lun : (u64) -1,
+				   vport->fc_myDID, ndlp->nlp_DID,
+				   phba->sli_rev == LPFC_SLI_REV4 ?
+				   lpfc_cmd->cur_iocbq.sli4_xritag : 0xffff,
+				   lpfc_cmd->cur_iocbq.iocb.ulpContext,
+				   lpfc_cmd->cur_iocbq.iocb.ulpIoTag,
+				   lpfc_cmd->cur_iocbq.iocb.ulpTimeout,
+				   (uint32_t)
+				   (cmnd->request->timeout / 1000));
+
+
+		goto out_host_busy_free_buf;
+	} else
+		lpfc_throttle_vlog(vport, &vport->log, LOG_FCP,
+				 "0019 FCP IOCB issued"
 				 "FCP cmd x%x <%d/%llu> "
 				 "sid: x%x did: x%x oxid: x%x "
 				 "Data: x%x x%x x%x x%x\n",
-				 err, cmnd->cmnd[0],
+				 cmnd->cmnd[0],
 				 cmnd->device ? cmnd->device->id : 0xffff,
-				 cmnd->device ? cmnd->device->lun : (u64) -1,
+				 cmnd->device ? cmnd->device->lun : 0xffff,
 				 vport->fc_myDID, ndlp->nlp_DID,
 				 phba->sli_rev == LPFC_SLI_REV4 ?
 				 lpfc_cmd->cur_iocbq.sli4_xritag : 0xffff,
@@ -4638,9 +4658,6 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 				 (uint32_t)
 				 (cmnd->request->timeout / 1000));
 
-
-		goto out_host_busy_free_buf;
-	}
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
 		lpfc_sli_handle_fast_ring_event(phba,
 			&phba->sli.ring[LPFC_FCP_RING], HA_R0RE_REQ);
@@ -4900,8 +4917,8 @@ lpfc_check_fcp_rsp(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd)
 		rsp_info_code = fcprsp->rspInfo3;
 
 
-		lpfc_printf_vlog(vport, KERN_INFO,
-				 LOG_FCP,
+		lpfc_optioned_vlog(vport, &vport->log,
+				KERN_INFO, LOG_FCP,
 				 "0706 fcp_rsp valid 0x%x,"
 				 " rsp len=%d code 0x%x\n",
 				 rsp_info,
@@ -4910,8 +4927,10 @@ lpfc_check_fcp_rsp(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd)
 		if ((fcprsp->rspStatus2&RSP_LEN_VALID) && (rsp_len == 8)) {
 			switch (rsp_info_code) {
 			case RSP_NO_FAILURE:
-				lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
-						 "0715 Task Mgmt No Failure\n");
+				lpfc_optioned_vlog(vport, &vport->log,
+						   KERN_INFO, LOG_FCP,
+						   "0715 Task Mgmt No "
+						   "Failure\n");
 				ret = SUCCESS;
 				break;
 			case RSP_TM_NOT_SUPPORTED: /* TM rejected */
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 6aae828..e504d51 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -108,9 +108,16 @@ lpfc_sli4_wq_put(struct lpfc_queue *q, union lpfc_wqe *wqe)
 	/* If the host has not yet processed the next entry then we are done */
 	idx = ((q->host_index + 1) % q->entry_count);
 	if (idx == q->hba_index) {
+		lpfc_throttle_log(q->phba, &q->phba->pport->log, LOG_SLI,
+				  "9998 WQ failure.  WQ Full. "
+				  "q_id x%x, host x%x, hba x%x\n",
+				  q->queue_id, idx, q->hba_index);
 		q->WQ_overflow++;
 		return -ENOMEM;
 	}
+	lpfc_throttle_log(q->phba, &q->phba->pport->log, LOG_SLI,
+			  "0039 WQ Posted. q_id x%x, host x%x, hba x%x\n",
+			  q->queue_id, idx, q->hba_index);
 	q->WQ_posted++;
 	/* set consumption flag every once in a while */
 	if (!((q->host_index + 1) % q->entry_repost))
-- 
1.7.11.7

