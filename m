From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 2/3] lpfc 8.2.8 v2 : Add sysfs control of target queue
	depth handling
Date: Sun, 07 Sep 2008 11:52:04 -0400
Message-ID: <1220802724.6747.13.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:61721 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbYIGPxR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Sep 2008 11:53:17 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m87FrG9U026396
	for <linux-scsi@vger.kernel.org>; Sun, 7 Sep 2008 08:53:17 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

A recut of:
   http://marc.info/?l=linux-scsi&m=121962902831370&w=2

Added new sysfs attribute lpfc_max_scsicmpl_time. Attribute, when enabled,
will control target queue depth based on I/O completion time.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h         |    6 ++++++
 lpfc_attr.c    |   44 ++++++++++++++++++++++++++++++++++++++++++++
 lpfc_disc.h    |    3 +++
 lpfc_hbadisc.c |    2 ++
 lpfc_scsi.c    |   29 +++++++++++++++++++++++++++++
 lpfc_scsi.h    |    1 +
 6 files changed, 85 insertions(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2008-09-06 11:54:50.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2008-09-07 11:18:30.000000000 -0400
@@ -2297,6 +2297,48 @@ LPFC_VPORT_ATTR_RW(use_adisc, 0, 0, 1,
 		   "Use ADISC on rediscovery to authenticate FCP devices");
 
 /*
+# lpfc_max_scsicmpl_time: Use scsi command completion time to control I/O queue
+# depth. Default value is 0. When the value of this parameter is zero the
+# SCSI command completion time is not used for controlling I/O queue depth. When
+# the parameter is set to a non-zero value, the I/O queue depth is controlled
+# to limit the I/O completion time to the parameter value.
+# The value is set in milliseconds.
+*/
+static int lpfc_max_scsicmpl_time;
+module_param(lpfc_max_scsicmpl_time, int, 0);
+MODULE_PARM_DESC(lpfc_max_scsicmpl_time,
+	"Use command completion time to control queue depth");
+lpfc_vport_param_show(max_scsicmpl_time);
+lpfc_vport_param_init(max_scsicmpl_time, 0, 0, 60000);
+static int
+lpfc_max_scsicmpl_time_set(struct lpfc_vport *vport, int val)
+{
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+	struct lpfc_nodelist *ndlp, *next_ndlp;
+
+	if (val == vport->cfg_max_scsicmpl_time)
+		return 0;
+	if ((val < 0) || (val > 60000))
+		return -EINVAL;
+	vport->cfg_max_scsicmpl_time = val;
+
+	spin_lock_irq(shost->host_lock);
+	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
+		if (!NLP_CHK_NODE_ACT(ndlp))
+			continue;
+		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
+			continue;
+		ndlp->cmd_qdepth = LPFC_MAX_TGT_QDEPTH;
+	}
+	spin_unlock_irq(shost->host_lock);
+	return 0;
+}
+lpfc_vport_param_store(max_scsicmpl_time);
+static DEVICE_ATTR(lpfc_max_scsicmpl_time, S_IRUGO | S_IWUSR,
+		   lpfc_max_scsicmpl_time_show,
+		   lpfc_max_scsicmpl_time_store);
+
+/*
 # lpfc_ack0: Use ACK0, instead of ACK1 for class 2 acknowledgement. Value
 # range is [0,1]. Default value is 0.
 */
@@ -2459,6 +2501,7 @@ struct device_attribute *lpfc_hba_attrs[
 	&dev_attr_lpfc_enable_hba_reset,
 	&dev_attr_lpfc_enable_hba_heartbeat,
 	&dev_attr_lpfc_sg_seg_cnt,
+	&dev_attr_lpfc_max_scsicmpl_time,
 	NULL,
 };
 
@@ -3580,6 +3623,7 @@ lpfc_get_vport_cfgparam(struct lpfc_vpor
 	lpfc_restrict_login_init(vport, lpfc_restrict_login);
 	lpfc_fcp_class_init(vport, lpfc_fcp_class);
 	lpfc_use_adisc_init(vport, lpfc_use_adisc);
+	lpfc_max_scsicmpl_time_init(vport, lpfc_max_scsicmpl_time);
 	lpfc_fdmi_on_init(vport, lpfc_fdmi_on);
 	lpfc_discovery_threads_init(vport, lpfc_discovery_threads);
 	lpfc_max_luns_init(vport, lpfc_max_luns);
diff -upNr a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
--- a/drivers/scsi/lpfc/lpfc_disc.h	2008-09-06 11:54:50.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_disc.h	2008-09-07 11:18:30.000000000 -0400
@@ -88,6 +88,9 @@ struct lpfc_nodelist {
 	unsigned long last_ramp_up_time;        /* jiffy of last ramp up */
 	unsigned long last_q_full_time;		/* jiffy of last queue full */
 	struct kref     kref;
+	atomic_t cmd_pending;
+	uint32_t cmd_qdepth;
+	unsigned long last_change_time;
 };
 
 /* Defines for nlp_flag (uint32) */
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2008-09-06 11:54:50.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2008-09-07 11:18:30.000000000 -0400
@@ -34,6 +34,11 @@ struct lpfc_sli2_slim;
 #define LPFC_IOCB_LIST_CNT	2250	/* list of IOCBs for fast-path usage. */
 #define LPFC_Q_RAMP_UP_INTERVAL 120     /* lun q_depth ramp up interval */
 #define LPFC_VNAME_LEN		100	/* vport symbolic name length */
+#define LPFC_TGTQ_INTERVAL	40000	/* Min amount of time between tgt
+					   queue depth change in millisecs */
+#define LPFC_TGTQ_RAMPUP_PCENT	5	/* Target queue rampup in percentage */
+#define LPFC_MIN_TGT_QDEPTH	100
+#define LPFC_MAX_TGT_QDEPTH	0xFFFF
 
 /*
  * Following time intervals are used of adjusting SCSI device
@@ -363,6 +368,7 @@ struct lpfc_vport {
 	uint32_t cfg_log_verbose;
 	uint32_t cfg_max_luns;
 	uint32_t cfg_enable_da_id;
+	uint32_t cfg_max_scsicmpl_time;
 
 	uint32_t dev_loss_tmo_changed;
 
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-09-06 11:54:50.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-09-07 11:18:30.000000000 -0400
@@ -2988,6 +2988,8 @@ lpfc_nlp_init(struct lpfc_vport *vport, 
 	INIT_LIST_HEAD(&ndlp->nlp_listp);
 	kref_init(&ndlp->kref);
 	NLP_INT_NODE_ACT(ndlp);
+	atomic_set(&ndlp->cmd_pending, 0);
+	ndlp->cmd_qdepth = LPFC_MAX_TGT_QDEPTH;
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_NODE,
 		"node init:       did:x%x",
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2008-09-07 11:16:34.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2008-09-07 11:18:49.000000000 -0400
@@ -628,6 +628,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 
 	lpfc_cmd->result = pIocbOut->iocb.un.ulpWord[4];
 	lpfc_cmd->status = pIocbOut->iocb.ulpStatus;
+	atomic_dec(&pnode->cmd_pending);
 
 	if (lpfc_cmd->status) {
 		if (lpfc_cmd->status == IOSTAT_LOCAL_REJECT &&
@@ -688,6 +689,29 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 
 	result = cmd->result;
 	sdev = cmd->device;
+	if (vport->cfg_max_scsicmpl_time &&
+	   time_after(jiffies, lpfc_cmd->start_time +
+		msecs_to_jiffies(vport->cfg_max_scsicmpl_time))) {
+		spin_lock_irqsave(sdev->host->host_lock, flags);
+		if ((pnode->cmd_qdepth > atomic_read(&pnode->cmd_pending) &&
+		    (atomic_read(&pnode->cmd_pending) > LPFC_MIN_TGT_QDEPTH) &&
+		    ((cmd->cmnd[0] == READ_10) || (cmd->cmnd[0] == WRITE_10))))
+			pnode->cmd_qdepth = atomic_read(&pnode->cmd_pending);
+
+		pnode->last_change_time = jiffies;
+		spin_unlock_irqrestore(sdev->host->host_lock, flags);
+	} else if ((pnode->cmd_qdepth < LPFC_MAX_TGT_QDEPTH) &&
+		   time_after(jiffies, pnode->last_change_time +
+			msecs_to_jiffies(LPFC_TGTQ_INTERVAL))) {
+		spin_lock_irqsave(sdev->host->host_lock, flags);
+		pnode->cmd_qdepth += pnode->cmd_qdepth *
+			LPFC_TGTQ_RAMPUP_PCENT / 100;
+		if (pnode->cmd_qdepth > LPFC_MAX_TGT_QDEPTH)
+			pnode->cmd_qdepth = LPFC_MAX_TGT_QDEPTH;
+		pnode->last_change_time = jiffies;
+		spin_unlock_irqrestore(sdev->host->host_lock, flags);
+	}
+
 	lpfc_scsi_unprep_dma_buf(phba, lpfc_cmd);
 	cmd->scsi_done(cmd);
 
@@ -1075,6 +1099,8 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 		cmnd->result = ScsiResult(DID_TRANSPORT_DISRUPTED, 0);
 		goto out_fail_command;
 	}
+	if (atomic_read(&ndlp->cmd_pending) >= ndlp->cmd_qdepth)
+		goto out_host_busy;
 
 	lpfc_cmd = lpfc_get_scsi_buf(phba);
 	if (lpfc_cmd == NULL) {
@@ -1093,6 +1119,7 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 	lpfc_cmd->pCmd  = cmnd;
 	lpfc_cmd->rdata = rdata;
 	lpfc_cmd->timeout = 0;
+	lpfc_cmd->start_time = jiffies;
 	cmnd->host_scribble = (unsigned char *)lpfc_cmd;
 	cmnd->scsi_done = done;
 
@@ -1102,6 +1129,7 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 
 	lpfc_scsi_prep_cmnd(vport, lpfc_cmd, ndlp);
 
+	atomic_inc(&ndlp->cmd_pending);
 	err = lpfc_sli_issue_iocb(phba, &phba->sli.ring[psli->fcp_ring],
 				  &lpfc_cmd->cur_iocbq, SLI_IOCB_RET_IOCB);
 	if (err)
@@ -1116,6 +1144,7 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 	return 0;
 
  out_host_busy_free_buf:
+	atomic_dec(&ndlp->cmd_pending);
 	lpfc_scsi_unprep_dma_buf(phba, lpfc_cmd);
 	lpfc_release_scsi_buf(phba, lpfc_cmd);
  out_host_busy:
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
--- a/drivers/scsi/lpfc/lpfc_scsi.h	2008-09-06 11:54:50.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.h	2008-09-07 11:18:30.000000000 -0400
@@ -139,6 +139,7 @@ struct lpfc_scsi_buf {
 	 */
 	struct lpfc_iocbq cur_iocbq;
 	wait_queue_head_t *waitq;
+	unsigned long start_time;
 };
 
 #define LPFC_SCSI_DMA_EXT_SIZE 264


