From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 4/14] lpfc 8.3.0 :  Fix system crash due to uninitialized
	node access
Date: Thu, 4 Dec 2008 22:39:08 -0500
Message-ID: <1228448348.19053.41.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:45898 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbYLEOnZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2008 09:43:25 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id mB5EhP4Z004208
	for <linux-scsi@vger.kernel.org>; Fri, 5 Dec 2008 06:43:25 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

lpfc 8.3.0 : Fix system crash due to uninitialized node access

In the IOCB completion handler, always check if the node is valid
before accessing the node object.  Added lpfc_initialize_node() to
initialize nodes.


Signed-off-by: James Smart <James.Smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc_hbadisc.c |   52 +++++++++++++++++++++-----------------
 drivers/scsi/lpfc/lpfc_scsi.c    |   44 ++++++++++++++++++++------------
 2 files changed, 56 insertions(+), 40 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1857,6 +1857,32 @@ lpfc_disable_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	lpfc_nlp_state_cleanup(vport, ndlp, ndlp->nlp_state,
 				NLP_STE_UNUSED_NODE);
 }
+/**
+ * lpfc_initialize_node: Initialize all fields of node object.
+ * @vport: Pointer to Virtual Port object.
+ * @ndlp: Pointer to FC node object.
+ * @did: FC_ID of the node.
+ *	This function is always called when node object need to
+ * be initialized. It initializes all the fields of the node
+ * object.
+ **/
+static inline void
+lpfc_initialize_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
+	uint32_t did)
+{
+	INIT_LIST_HEAD(&ndlp->els_retry_evt.evt_listp);
+	INIT_LIST_HEAD(&ndlp->dev_loss_evt.evt_listp);
+	init_timer(&ndlp->nlp_delayfunc);
+	ndlp->nlp_delayfunc.function = lpfc_els_retry_delay;
+	ndlp->nlp_delayfunc.data = (unsigned long)ndlp;
+	ndlp->nlp_DID = did;
+	ndlp->vport = vport;
+	ndlp->nlp_sid = NLP_NO_SID;
+	kref_init(&ndlp->kref);
+	NLP_INT_NODE_ACT(ndlp);
+	atomic_set(&ndlp->cmd_pending, 0);
+	ndlp->cmd_qdepth = LPFC_MAX_TGT_QDEPTH;
+}
 
 struct lpfc_nodelist *
 lpfc_enable_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
@@ -1897,17 +1923,7 @@ lpfc_enable_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	/* re-initialize ndlp except of ndlp linked list pointer */
 	memset((((char *)ndlp) + sizeof (struct list_head)), 0,
 		sizeof (struct lpfc_nodelist) - sizeof (struct list_head));
-	INIT_LIST_HEAD(&ndlp->els_retry_evt.evt_listp);
-	INIT_LIST_HEAD(&ndlp->dev_loss_evt.evt_listp);
-	init_timer(&ndlp->nlp_delayfunc);
-	ndlp->nlp_delayfunc.function = lpfc_els_retry_delay;
-	ndlp->nlp_delayfunc.data = (unsigned long)ndlp;
-	ndlp->nlp_DID = did;
-	ndlp->vport = vport;
-	ndlp->nlp_sid = NLP_NO_SID;
-	/* ndlp management re-initialize */
-	kref_init(&ndlp->kref);
-	NLP_INT_NODE_ACT(ndlp);
+	lpfc_initialize_node(vport, ndlp, did);
 
 	spin_unlock_irqrestore(&phba->ndlp_lock, flags);
 
@@ -3121,19 +3137,9 @@ lpfc_nlp_init(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	      uint32_t did)
 {
 	memset(ndlp, 0, sizeof (struct lpfc_nodelist));
-	INIT_LIST_HEAD(&ndlp->els_retry_evt.evt_listp);
-	INIT_LIST_HEAD(&ndlp->dev_loss_evt.evt_listp);
-	init_timer(&ndlp->nlp_delayfunc);
-	ndlp->nlp_delayfunc.function = lpfc_els_retry_delay;
-	ndlp->nlp_delayfunc.data = (unsigned long)ndlp;
-	ndlp->nlp_DID = did;
-	ndlp->vport = vport;
-	ndlp->nlp_sid = NLP_NO_SID;
+
+	lpfc_initialize_node(vport, ndlp, did);
 	INIT_LIST_HEAD(&ndlp->nlp_listp);
-	kref_init(&ndlp->kref);
-	NLP_INT_NODE_ACT(ndlp);
-	atomic_set(&ndlp->cmd_pending, 0);
-	ndlp->cmd_qdepth = LPFC_MAX_TGT_QDEPTH;
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_NODE,
 		"node init:       did:x%x",
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -945,7 +945,8 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 
 	lpfc_cmd->result = pIocbOut->iocb.un.ulpWord[4];
 	lpfc_cmd->status = pIocbOut->iocb.ulpStatus;
-	atomic_dec(&pnode->cmd_pending);
+	if (pnode && NLP_CHK_NODE_ACT(pnode))
+		atomic_dec(&pnode->cmd_pending);
 
 	if (lpfc_cmd->status) {
 		if (lpfc_cmd->status == IOSTAT_LOCAL_REJECT &&
@@ -1035,23 +1036,31 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	   time_after(jiffies, lpfc_cmd->start_time +
 		msecs_to_jiffies(vport->cfg_max_scsicmpl_time))) {
 		spin_lock_irqsave(sdev->host->host_lock, flags);
-		if ((pnode->cmd_qdepth > atomic_read(&pnode->cmd_pending) &&
-		    (atomic_read(&pnode->cmd_pending) > LPFC_MIN_TGT_QDEPTH) &&
-		    ((cmd->cmnd[0] == READ_10) || (cmd->cmnd[0] == WRITE_10))))
-			pnode->cmd_qdepth = atomic_read(&pnode->cmd_pending);
-
-		pnode->last_change_time = jiffies;
+		if (pnode && NLP_CHK_NODE_ACT(pnode)) {
+			if (pnode->cmd_qdepth >
+				atomic_read(&pnode->cmd_pending) &&
+				(atomic_read(&pnode->cmd_pending) >
+				LPFC_MIN_TGT_QDEPTH) &&
+				((cmd->cmnd[0] == READ_10) ||
+				(cmd->cmnd[0] == WRITE_10)))
+				pnode->cmd_qdepth =
+					atomic_read(&pnode->cmd_pending);
+
+			pnode->last_change_time = jiffies;
+		}
 		spin_unlock_irqrestore(sdev->host->host_lock, flags);
-	} else if ((pnode->cmd_qdepth < LPFC_MAX_TGT_QDEPTH) &&
+	} else if (pnode && NLP_CHK_NODE_ACT(pnode)) {
+		if ((pnode->cmd_qdepth < LPFC_MAX_TGT_QDEPTH) &&
 		   time_after(jiffies, pnode->last_change_time +
-			msecs_to_jiffies(LPFC_TGTQ_INTERVAL))) {
-		spin_lock_irqsave(sdev->host->host_lock, flags);
-		pnode->cmd_qdepth += pnode->cmd_qdepth *
-			LPFC_TGTQ_RAMPUP_PCENT / 100;
-		if (pnode->cmd_qdepth > LPFC_MAX_TGT_QDEPTH)
-			pnode->cmd_qdepth = LPFC_MAX_TGT_QDEPTH;
-		pnode->last_change_time = jiffies;
-		spin_unlock_irqrestore(sdev->host->host_lock, flags);
+			      msecs_to_jiffies(LPFC_TGTQ_INTERVAL))) {
+			spin_lock_irqsave(sdev->host->host_lock, flags);
+			pnode->cmd_qdepth += pnode->cmd_qdepth *
+				LPFC_TGTQ_RAMPUP_PCENT / 100;
+			if (pnode->cmd_qdepth > LPFC_MAX_TGT_QDEPTH)
+				pnode->cmd_qdepth = LPFC_MAX_TGT_QDEPTH;
+			pnode->last_change_time = jiffies;
+			spin_unlock_irqrestore(sdev->host->host_lock, flags);
+		}
 	}
 
 	lpfc_scsi_unprep_dma_buf(phba, lpfc_cmd);
@@ -1536,7 +1545,8 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 		cmnd->result = ScsiResult(DID_TRANSPORT_DISRUPTED, 0);
 		goto out_fail_command;
 	}
-	if (atomic_read(&ndlp->cmd_pending) >= ndlp->cmd_qdepth)
+	if (vport->cfg_max_scsicmpl_time &&
+		(atomic_read(&ndlp->cmd_pending) >= ndlp->cmd_qdepth))
 		goto out_host_busy;
 
 	lpfc_cmd = lpfc_get_scsi_buf(phba);


