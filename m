From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 08/18] lpfc: NVME Initiator: Base modifications Part F
Date: Mon, 06 Feb 2017 15:08:57 -0800
Message-ID: <58990209.Wybga5ORVGDNgVW8%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34909 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751524AbdBFXJF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 18:09:05 -0500
Received: by mail-wr0-f196.google.com with SMTP id o16so3998494wra.2
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 15:09:04 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org


NVME Initiator: Base modifications

This is part F of parts A..F.

Part F is limited to lpfc_debugfs.[ch]. It contains the modifications in
the existing debugfs snippets to work with the base modifications.

This patch by itself will not result in a compilable driver. All parts
A..F must be applied to create a compilable driver.

*********

Refer to Part A for a description of base modifications

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
Modifications in V2:
Note: this was patch 7 in the V1 patches
 Address review items:
  Reverted lpfc_sli_hbq_count() spurious change.
  Refactoring of queue print functions
 Sync with max_hw_queues/io_channel/io_channel_irqs change
 Some printk(KERN_ERR) flips to pr_err()
 Enlarge protective space for buffer overrun checks
 Couple more checkpatch cleanups

 drivers/scsi/lpfc/lpfc_debugfs.c | 778 ++++++++++++++++++---------------------
 drivers/scsi/lpfc/lpfc_debugfs.h | 266 ++++++-------
 2 files changed, 504 insertions(+), 540 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index a63542b..e19a3fa 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -484,20 +484,23 @@ lpfc_debugfs_dumpHostSlim_data(struct lpfc_hba *phba, char *buf, int size)
 		off += (8 * sizeof(uint32_t));
 	}
 
-	for (i = 0; i < 4; i++) {
-		pgpp = &phba->port_gp[i];
-		pring = &psli->ring[i];
-		len +=  snprintf(buf+len, size-len,
-				 "Ring %d: CMD GetInx:%d (Max:%d Next:%d "
-				 "Local:%d flg:x%x)  RSP PutInx:%d Max:%d\n",
-				 i, pgpp->cmdGetInx, pring->sli.sli3.numCiocb,
-				 pring->sli.sli3.next_cmdidx,
-				 pring->sli.sli3.local_getidx,
-				 pring->flag, pgpp->rspPutInx,
-				 pring->sli.sli3.numRiocb);
-	}
-
 	if (phba->sli_rev <= LPFC_SLI_REV3) {
+		for (i = 0; i < 4; i++) {
+			pgpp = &phba->port_gp[i];
+			pring = &psli->sli3_ring[i];
+			len +=  snprintf(buf+len, size-len,
+					 "Ring %d: CMD GetInx:%d "
+					 "(Max:%d Next:%d "
+					 "Local:%d flg:x%x)  "
+					 "RSP PutInx:%d Max:%d\n",
+					 i, pgpp->cmdGetInx,
+					 pring->sli.sli3.numCiocb,
+					 pring->sli.sli3.next_cmdidx,
+					 pring->sli.sli3.local_getidx,
+					 pring->flag, pgpp->rspPutInx,
+					 pring->sli.sli3.numRiocb);
+		}
+
 		word0 = readl(phba->HAregaddr);
 		word1 = readl(phba->CAregaddr);
 		word2 = readl(phba->HSregaddr);
@@ -531,10 +534,11 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 	int cnt;
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_nodelist *ndlp;
-	unsigned char *statep, *name;
+	unsigned char *statep;
 
 	cnt = (LPFC_NODELIST_SIZE / LPFC_NODELIST_ENTRY_SIZE);
 
+	len += snprintf(buf+len, size-len, "\nFCP Nodelist Entries ...\n");
 	spin_lock_irq(shost->host_lock);
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
 		if (!cnt) {
@@ -574,36 +578,32 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 		default:
 			statep = "UNKNOWN";
 		}
-		len +=  snprintf(buf+len, size-len, "%s DID:x%06x ",
-			statep, ndlp->nlp_DID);
-		name = (unsigned char *)&ndlp->nlp_portname;
-		len +=  snprintf(buf+len, size-len,
-			"WWPN %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x ",
-			*name, *(name+1), *(name+2), *(name+3),
-			*(name+4), *(name+5), *(name+6), *(name+7));
-		name = (unsigned char *)&ndlp->nlp_nodename;
-		len +=  snprintf(buf+len, size-len,
-			"WWNN %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x ",
-			*name, *(name+1), *(name+2), *(name+3),
-			*(name+4), *(name+5), *(name+6), *(name+7));
+		len += snprintf(buf+len, size-len, "%s DID:x%06x ",
+				statep, ndlp->nlp_DID);
+		len += snprintf(buf+len, size-len,
+				"WWPN x%llx ",
+				wwn_to_u64(ndlp->nlp_portname.u.wwn));
+		len += snprintf(buf+len, size-len,
+				"WWNN x%llx ",
+				wwn_to_u64(ndlp->nlp_nodename.u.wwn));
 		if (ndlp->nlp_flag & NLP_RPI_REGISTERED)
-			len +=  snprintf(buf+len, size-len, "RPI:%03d ",
-				ndlp->nlp_rpi);
+			len += snprintf(buf+len, size-len, "RPI:%03d ",
+					ndlp->nlp_rpi);
 		else
-			len +=  snprintf(buf+len, size-len, "RPI:none ");
+			len += snprintf(buf+len, size-len, "RPI:none ");
 		len +=  snprintf(buf+len, size-len, "flag:x%08x ",
 			ndlp->nlp_flag);
 		if (!ndlp->nlp_type)
-			len +=  snprintf(buf+len, size-len, "UNKNOWN_TYPE ");
+			len += snprintf(buf+len, size-len, "UNKNOWN_TYPE ");
 		if (ndlp->nlp_type & NLP_FC_NODE)
-			len +=  snprintf(buf+len, size-len, "FC_NODE ");
+			len += snprintf(buf+len, size-len, "FC_NODE ");
 		if (ndlp->nlp_type & NLP_FABRIC)
-			len +=  snprintf(buf+len, size-len, "FABRIC ");
+			len += snprintf(buf+len, size-len, "FABRIC ");
 		if (ndlp->nlp_type & NLP_FCP_TARGET)
-			len +=  snprintf(buf+len, size-len, "FCP_TGT sid:%d ",
+			len += snprintf(buf+len, size-len, "FCP_TGT sid:%d ",
 				ndlp->nlp_sid);
 		if (ndlp->nlp_type & NLP_FCP_INITIATOR)
-			len +=  snprintf(buf+len, size-len, "FCP_INITIATOR ");
+			len += snprintf(buf+len, size-len, "FCP_INITIATOR ");
 		len += snprintf(buf+len, size-len, "usgmap:%x ",
 			ndlp->nlp_usg_map);
 		len += snprintf(buf+len, size-len, "refcnt:%x",
@@ -611,8 +611,10 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 		len +=  snprintf(buf+len, size-len, "\n");
 	}
 	spin_unlock_irq(shost->host_lock);
+
 	return len;
 }
+
 #endif
 
 /**
@@ -938,7 +940,7 @@ lpfc_debugfs_dumpData_open(struct inode *inode, struct file *file)
 		goto out;
 
 	/* Round to page boundary */
-	printk(KERN_ERR "9059 BLKGRD:  %s: _dump_buf_data=0x%p\n",
+	pr_err("9059 BLKGRD:  %s: _dump_buf_data=0x%p\n",
 			__func__, _dump_buf_data);
 	debug->buffer = _dump_buf_data;
 	if (!debug->buffer) {
@@ -968,8 +970,8 @@ lpfc_debugfs_dumpDif_open(struct inode *inode, struct file *file)
 		goto out;
 
 	/* Round to page boundary */
-	printk(KERN_ERR	"9060 BLKGRD: %s: _dump_buf_dif=0x%p file=%pD\n",
-		__func__, _dump_buf_dif, file);
+	pr_err("9060 BLKGRD: %s: _dump_buf_dif=0x%p file=%pD\n",
+			__func__, _dump_buf_dif, file);
 	debug->buffer = _dump_buf_dif;
 	if (!debug->buffer) {
 		kfree(debug);
@@ -1974,6 +1976,181 @@ lpfc_idiag_baracc_write(struct file *file, const char __user *buf,
 	return -EINVAL;
 }
 
+static int
+__lpfc_idiag_print_wq(struct lpfc_queue *qp, char *wqtype,
+			char *pbuffer, int len)
+{
+	if (!qp)
+		return len;
+
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"\t\t%s WQ info: ", wqtype);
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"AssocCQID[%04d]: WQ-STAT[oflow:x%x posted:x%llx]\n",
+			qp->assoc_qid, qp->q_cnt_1,
+			(unsigned long long)qp->q_cnt_4);
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"\t\tWQID[%02d], QE-CNT[%04d], QE-SIZE[%04d], "
+			"HOST-IDX[%04d], PORT-IDX[%04d]",
+			qp->queue_id, qp->entry_count,
+			qp->entry_size, qp->host_index,
+			qp->hba_index);
+	len +=  snprintf(pbuffer+len,
+			LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
+	return len;
+}
+
+static int
+lpfc_idiag_wqs_for_cq(struct lpfc_hba *phba, char *wqtype, char *pbuffer,
+		int *len, int max_cnt, int cq_id)
+{
+	struct lpfc_queue *qp;
+	int qidx;
+
+	for (qidx = 0; qidx < phba->cfg_fcp_io_channel; qidx++) {
+		qp = phba->sli4_hba.fcp_wq[qidx];
+		if (qp->assoc_qid != cq_id)
+			continue;
+		*len = __lpfc_idiag_print_wq(qp, wqtype, pbuffer, *len);
+		if (*len >= max_cnt)
+			return 1;
+	}
+	for (qidx = 0; qidx < phba->cfg_nvme_io_channel; qidx++) {
+		qp = phba->sli4_hba.nvme_wq[qidx];
+		if (qp->assoc_qid != cq_id)
+			continue;
+		*len = __lpfc_idiag_print_wq(qp, wqtype, pbuffer, *len);
+		if (*len >= max_cnt)
+			return 1;
+	}
+	return 0;
+}
+
+static int
+__lpfc_idiag_print_cq(struct lpfc_queue *qp, char *cqtype,
+			char *pbuffer, int len)
+{
+	if (!qp)
+		return len;
+
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"\t%s CQ info: ", cqtype);
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"AssocEQID[%02d]: CQ STAT[max:x%x relw:x%x "
+			"xabt:x%x wq:x%llx]\n",
+			qp->assoc_qid, qp->q_cnt_1, qp->q_cnt_2,
+			qp->q_cnt_3, (unsigned long long)qp->q_cnt_4);
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"\tCQID[%02d], QE-CNT[%04d], QE-SIZE[%04d], "
+			"HOST-IDX[%04d], PORT-IDX[%04d]",
+			qp->queue_id, qp->entry_count,
+			qp->entry_size, qp->host_index,
+			qp->hba_index);
+
+	len +=  snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
+
+	return len;
+}
+
+static int
+lpfc_idiag_cqs_for_eq(struct lpfc_hba *phba, char *pbuffer,
+		int *len, int max_cnt, int eq_id)
+{
+	struct lpfc_queue *qp;
+	int qidx, rc;
+
+	for (qidx = 0; qidx < phba->cfg_fcp_io_channel; qidx++) {
+		qp = phba->sli4_hba.fcp_cq[qidx];
+		if (qp->assoc_qid != eq_id)
+			continue;
+
+		*len = __lpfc_idiag_print_cq(qp, "FCP", pbuffer, *len);
+
+		/* Reset max counter */
+		qp->CQ_max_cqe = 0;
+
+		if (*len >= max_cnt)
+			return 1;
+
+		rc = lpfc_idiag_wqs_for_cq(phba, "FCP", pbuffer, len,
+				max_cnt, qp->queue_id);
+		if (rc)
+			return 1;
+	}
+
+	for (qidx = 0; qidx < phba->cfg_nvme_io_channel; qidx++) {
+		qp = phba->sli4_hba.nvme_cq[qidx];
+		if (qp->assoc_qid != eq_id)
+			continue;
+
+		*len = __lpfc_idiag_print_cq(qp, "NVME", pbuffer, *len);
+
+		/* Reset max counter */
+		qp->CQ_max_cqe = 0;
+
+		if (*len >= max_cnt)
+			return 1;
+
+		rc = lpfc_idiag_wqs_for_cq(phba, "NVME", pbuffer, len,
+				max_cnt, qp->queue_id);
+		if (rc)
+			return 1;
+	}
+	return 0;
+}
+
+static int
+__lpfc_idiag_print_eq(struct lpfc_queue *qp, char *eqtype,
+			char *pbuffer, int len)
+{
+	if (!qp)
+		return len;
+
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"\n%s EQ info: EQ-STAT[max:x%x noE:x%x "
+			"bs:x%x proc:x%llx]\n",
+			eqtype, qp->q_cnt_1, qp->q_cnt_2, qp->q_cnt_3,
+			(unsigned long long)qp->q_cnt_4);
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"EQID[%02d], QE-CNT[%04d], QE-SIZE[%04d], "
+			"HOST-IDX[%04d], PORT-IDX[%04d]",
+			qp->queue_id, qp->entry_count, qp->entry_size,
+			qp->host_index, qp->hba_index);
+	len +=  snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
+
+	return len;
+}
+
+static int
+__lpfc_idiag_print_rqpair(struct lpfc_queue *qp, struct lpfc_queue *datqp,
+			char *pbuffer, int len)
+{
+	if (!qp || !datqp)
+		return len;
+
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"\t\tRQ info: ");
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"AssocCQID[%02d]: RQ-STAT[nopost:x%x nobuf:x%x "
+			"trunc:x%x rcv:x%llx]\n",
+			qp->assoc_qid, qp->q_cnt_1, qp->q_cnt_2,
+			qp->q_cnt_3, (unsigned long long)qp->q_cnt_4);
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"\t\tHQID[%02d], QE-CNT[%04d], QE-SIZE[%04d], "
+			"HOST-IDX[%04d], PORT-IDX[%04d]\n",
+			qp->queue_id, qp->entry_count, qp->entry_size,
+			qp->host_index, qp->hba_index);
+	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"\t\tDQID[%02d], QE-CNT[%04d], QE-SIZE[%04d], "
+			"HOST-IDX[%04d], PORT-IDX[%04d]\n",
+			datqp->queue_id, datqp->entry_count,
+			datqp->entry_size, datqp->host_index,
+			datqp->hba_index);
+	len +=  snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
+
+	return len;
+}
+
 /**
  * lpfc_idiag_queinfo_read - idiag debugfs read queue information
  * @file: The file pointer to read from.
@@ -1984,6 +2161,9 @@ lpfc_idiag_baracc_write(struct file *file, const char __user *buf,
  * Description:
  * This routine reads data from the @phba SLI4 PCI function queue information,
  * and copies to user @buf.
+ * This routine only returns 1 EQs worth of information. It remembers the last
+ * EQ read and jumps to the next EQ. Thus subsequent calls to queInfo will
+ * retrieve all EQs allocated for the phba.
  *
  * Returns:
  * This function returns the amount of data that was read (this could be less
@@ -1995,19 +2175,16 @@ lpfc_idiag_queinfo_read(struct file *file, char __user *buf, size_t nbytes,
 {
 	struct lpfc_debug *debug = file->private_data;
 	struct lpfc_hba *phba = (struct lpfc_hba *)debug->i_private;
-	int len = 0;
 	char *pbuffer;
-	int x, cnt;
-	int max_cnt;
+	int max_cnt, rc, x, len = 0;
 	struct lpfc_queue *qp = NULL;
 
-
 	if (!debug->buffer)
 		debug->buffer = kmalloc(LPFC_QUE_INFO_GET_BUF_SIZE, GFP_KERNEL);
 	if (!debug->buffer)
 		return 0;
 	pbuffer = debug->buffer;
-	max_cnt = LPFC_QUE_INFO_GET_BUF_SIZE - 128;
+	max_cnt = LPFC_QUE_INFO_GET_BUF_SIZE - 256;
 
 	if (*ppos)
 		return 0;
@@ -2015,369 +2192,112 @@ lpfc_idiag_queinfo_read(struct file *file, char __user *buf, size_t nbytes,
 	spin_lock_irq(&phba->hbalock);
 
 	/* Fast-path event queue */
-	if (phba->sli4_hba.hba_eq && phba->cfg_fcp_io_channel) {
-		cnt = phba->cfg_fcp_io_channel;
+	if (phba->sli4_hba.hba_eq && phba->io_channel_irqs) {
 
-		for (x = 0; x < cnt; x++) {
+		for (x = 0; x < phba->io_channel_irqs; x++) {
 
 			/* Fast-path EQ */
 			qp = phba->sli4_hba.hba_eq[x];
 			if (!qp)
-				goto proc_cq;
-
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\nHBA EQ info: "
-				"EQ-STAT[max:x%x noE:x%x "
-				"bs:x%x proc:x%llx]\n",
-				qp->q_cnt_1, qp->q_cnt_2,
-				qp->q_cnt_3, (unsigned long long)qp->q_cnt_4);
-
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"EQID[%02d], "
-				"QE-CNT[%04d], QE-SIZE[%04d], "
-				"HOST-IDX[%04d], PORT-IDX[%04d]",
-				qp->queue_id,
-				qp->entry_count,
-				qp->entry_size,
-				qp->host_index,
-				qp->hba_index);
+				continue;
 
+			len = __lpfc_idiag_print_eq(qp, "HBA", pbuffer, len);
 
 			/* Reset max counter */
 			qp->EQ_max_eqe = 0;
 
-			len +=  snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
 			if (len >= max_cnt)
 				goto too_big;
-proc_cq:
-			/* Fast-path FCP CQ */
-			qp = phba->sli4_hba.fcp_cq[x];
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\tFCP CQ info: ");
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"AssocEQID[%02d]: "
-				"CQ STAT[max:x%x relw:x%x "
-				"xabt:x%x wq:x%llx]\n",
-				qp->assoc_qid,
-				qp->q_cnt_1, qp->q_cnt_2,
-				qp->q_cnt_3, (unsigned long long)qp->q_cnt_4);
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\tCQID[%02d], "
-				"QE-CNT[%04d], QE-SIZE[%04d], "
-				"HOST-IDX[%04d], PORT-IDX[%04d]",
-				qp->queue_id, qp->entry_count,
-				qp->entry_size, qp->host_index,
-				qp->hba_index);
-
-
-			/* Reset max counter */
-			qp->CQ_max_cqe = 0;
 
-			len +=  snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
-			if (len >= max_cnt)
-				goto too_big;
-
-			/* Fast-path FCP WQ */
-			qp = phba->sli4_hba.fcp_wq[x];
-
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\t\tFCP WQ info: ");
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"AssocCQID[%02d]: "
-				"WQ-STAT[oflow:x%x posted:x%llx]\n",
-				qp->assoc_qid,
-				qp->q_cnt_1, (unsigned long long)qp->q_cnt_4);
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\t\tWQID[%02d], "
-				"QE-CNT[%04d], QE-SIZE[%04d], "
-				"HOST-IDX[%04d], PORT-IDX[%04d]",
-				qp->queue_id,
-				qp->entry_count,
-				qp->entry_size,
-				qp->host_index,
-				qp->hba_index);
-
-			len +=  snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
-			if (len >= max_cnt)
+			rc = lpfc_idiag_cqs_for_eq(phba, pbuffer, &len,
+				max_cnt, qp->queue_id);
+			if (rc)
 				goto too_big;
 
+			/* Only EQ 0 has slow path CQs configured */
 			if (x)
 				continue;
 
-			/* Only EQ 0 has slow path CQs configured */
-
 			/* Slow-path mailbox CQ */
 			qp = phba->sli4_hba.mbx_cq;
-			if (qp) {
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"\tMBX CQ info: ");
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"AssocEQID[%02d]: "
-					"CQ-STAT[mbox:x%x relw:x%x "
-					"xabt:x%x wq:x%llx]\n",
-					qp->assoc_qid,
-					qp->q_cnt_1, qp->q_cnt_2,
-					qp->q_cnt_3,
-					(unsigned long long)qp->q_cnt_4);
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"\tCQID[%02d], "
-					"QE-CNT[%04d], QE-SIZE[%04d], "
-					"HOST-IDX[%04d], PORT-IDX[%04d]",
-					qp->queue_id, qp->entry_count,
-					qp->entry_size, qp->host_index,
-					qp->hba_index);
-
-				len +=  snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
-				if (len >= max_cnt)
-					goto too_big;
-			}
+			len = __lpfc_idiag_print_cq(qp, "MBX", pbuffer, len);
+			if (len >= max_cnt)
+				goto too_big;
 
 			/* Slow-path MBOX MQ */
 			qp = phba->sli4_hba.mbx_wq;
-			if (qp) {
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"\t\tMBX MQ info: ");
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"AssocCQID[%02d]:\n",
-					phba->sli4_hba.mbx_wq->assoc_qid);
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"\t\tWQID[%02d], "
-					"QE-CNT[%04d], QE-SIZE[%04d], "
-					"HOST-IDX[%04d], PORT-IDX[%04d]",
-					qp->queue_id, qp->entry_count,
-					qp->entry_size, qp->host_index,
-					qp->hba_index);
-
-				len +=  snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
-				if (len >= max_cnt)
-					goto too_big;
-			}
+			len = __lpfc_idiag_print_wq(qp, "MBX", pbuffer, len);
+			if (len >= max_cnt)
+				goto too_big;
 
 			/* Slow-path ELS response CQ */
 			qp = phba->sli4_hba.els_cq;
-			if (qp) {
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"\tELS CQ info: ");
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"AssocEQID[%02d]: "
-					"CQ-STAT[max:x%x relw:x%x "
-					"xabt:x%x wq:x%llx]\n",
-					qp->assoc_qid,
-					qp->q_cnt_1, qp->q_cnt_2,
-					qp->q_cnt_3,
-					(unsigned long long)qp->q_cnt_4);
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"\tCQID [%02d], "
-					"QE-CNT[%04d], QE-SIZE[%04d], "
-					"HOST-IDX[%04d], PORT-IDX[%04d]",
-					qp->queue_id, qp->entry_count,
-					qp->entry_size, qp->host_index,
-					qp->hba_index);
-
-				/* Reset max counter */
+			len = __lpfc_idiag_print_cq(qp, "ELS", pbuffer, len);
+			/* Reset max counter */
+			if (qp)
 				qp->CQ_max_cqe = 0;
-
-				len +=  snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
-				if (len >= max_cnt)
-					goto too_big;
-			}
+			if (len >= max_cnt)
+				goto too_big;
 
 			/* Slow-path ELS WQ */
 			qp = phba->sli4_hba.els_wq;
-			if (qp) {
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"\t\tELS WQ info: ");
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"AssocCQID[%02d]: "
-					" WQ-STAT[oflow:x%x "
-					"posted:x%llx]\n",
-					qp->assoc_qid,
-					qp->q_cnt_1,
-					(unsigned long long)qp->q_cnt_4);
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"\t\tWQID[%02d], "
-					"QE-CNT[%04d], QE-SIZE[%04d], "
-					"HOST-IDX[%04d], PORT-IDX[%04d]",
-					qp->queue_id, qp->entry_count,
-					qp->entry_size, qp->host_index,
-					qp->hba_index);
-
-				len +=  snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
-				if (len >= max_cnt)
-					goto too_big;
-			}
+			len = __lpfc_idiag_print_wq(qp, "ELS", pbuffer, len);
+			if (len >= max_cnt)
+				goto too_big;
 
-			if (phba->sli4_hba.hdr_rq && phba->sli4_hba.dat_rq) {
-				/* Slow-path RQ header */
-				qp = phba->sli4_hba.hdr_rq;
+			/* Slow-path NVME LS response CQ */
+			qp = phba->sli4_hba.nvmels_cq;
+			len = __lpfc_idiag_print_cq(qp, "NVME LS",
+							pbuffer, len);
+			/* Reset max counter */
+			if (qp)
+				qp->CQ_max_cqe = 0;
+			if (len >= max_cnt)
+				goto too_big;
 
-				len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"\t\tRQ info: ");
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"AssocCQID[%02d]: "
-					"RQ-STAT[nopost:x%x nobuf:x%x "
-					"trunc:x%x rcv:x%llx]\n",
-					qp->assoc_qid,
-					qp->q_cnt_1, qp->q_cnt_2,
-					qp->q_cnt_3,
-					(unsigned long long)qp->q_cnt_4);
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"\t\tHQID[%02d], "
-					"QE-CNT[%04d], QE-SIZE[%04d], "
-					"HOST-IDX[%04d], PORT-IDX[%04d]\n",
-					qp->queue_id,
-					qp->entry_count,
-					qp->entry_size,
-					qp->host_index,
-					qp->hba_index);
-
-				/* Slow-path RQ data */
-				qp = phba->sli4_hba.dat_rq;
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"\t\tDQID[%02d], "
-					"QE-CNT[%04d], QE-SIZE[%04d], "
-					"HOST-IDX[%04d], PORT-IDX[%04d]\n",
-					qp->queue_id,
-					qp->entry_count,
-					qp->entry_size,
-					qp->host_index,
-					qp->hba_index);
-
-				len +=  snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
-			}
+			/* Slow-path NVME LS WQ */
+			qp = phba->sli4_hba.nvmels_wq;
+			len = __lpfc_idiag_print_wq(qp, "NVME LS",
+							pbuffer, len);
+			if (len >= max_cnt)
+				goto too_big;
+
+			qp = phba->sli4_hba.hdr_rq;
+			len = __lpfc_idiag_print_rqpair(qp,
+					phba->sli4_hba.dat_rq, pbuffer, len);
+			if (len >= max_cnt)
+				goto too_big;
 		}
 	}
 
 	if (phba->cfg_fof) {
 		/* FOF EQ */
 		qp = phba->sli4_hba.fof_eq;
-		if (!qp)
-			goto out;
-
-		len += snprintf(pbuffer+len,
-			LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"\nFOF EQ info: "
-			"EQ-STAT[max:x%x noE:x%x "
-			"bs:x%x proc:x%llx]\n",
-			qp->q_cnt_1, qp->q_cnt_2,
-			qp->q_cnt_3, (unsigned long long)qp->q_cnt_4);
-
-		len += snprintf(pbuffer+len,
-			LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"EQID[%02d], "
-			"QE-CNT[%04d], QE-SIZE[%04d], "
-			"HOST-IDX[%04d], PORT-IDX[%04d]",
-			qp->queue_id,
-			qp->entry_count,
-			qp->entry_size,
-			qp->host_index,
-			qp->hba_index);
+		len = __lpfc_idiag_print_eq(qp, "FOF", pbuffer, len);
 
 		/* Reset max counter */
-		qp->EQ_max_eqe = 0;
+		if (qp)
+			qp->EQ_max_eqe = 0;
 
-		len +=  snprintf(pbuffer+len,
-			LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
 		if (len >= max_cnt)
 			goto too_big;
-	}
-
-	if (phba->cfg_fof) {
 
 		/* OAS CQ */
 		qp = phba->sli4_hba.oas_cq;
-		if (qp) {
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\tOAS CQ info: ");
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"AssocEQID[%02d]: "
-				"CQ STAT[max:x%x relw:x%x "
-				"xabt:x%x wq:x%llx]\n",
-				qp->assoc_qid,
-				qp->q_cnt_1, qp->q_cnt_2,
-				qp->q_cnt_3, (unsigned long long)qp->q_cnt_4);
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\tCQID[%02d], "
-				"QE-CNT[%04d], QE-SIZE[%04d], "
-				"HOST-IDX[%04d], PORT-IDX[%04d]",
-				qp->queue_id, qp->entry_count,
-				qp->entry_size, qp->host_index,
-				qp->hba_index);
-
-			/* Reset max counter */
+		len = __lpfc_idiag_print_cq(qp, "OAS", pbuffer, len);
+		/* Reset max counter */
+		if (qp)
 			qp->CQ_max_cqe = 0;
-
-			len +=  snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
-			if (len >= max_cnt)
-				goto too_big;
-		}
+		if (len >= max_cnt)
+			goto too_big;
 
 		/* OAS WQ */
 		qp = phba->sli4_hba.oas_wq;
-		if (qp) {
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\t\tOAS WQ info: ");
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"AssocCQID[%02d]: "
-				"WQ-STAT[oflow:x%x posted:x%llx]\n",
-				qp->assoc_qid,
-				qp->q_cnt_1, (unsigned long long)qp->q_cnt_4);
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\t\tWQID[%02d], "
-				"QE-CNT[%04d], QE-SIZE[%04d], "
-				"HOST-IDX[%04d], PORT-IDX[%04d]",
-				qp->queue_id,
-				qp->entry_count,
-				qp->entry_size,
-				qp->host_index,
-				qp->hba_index);
-
-			len +=  snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
-			if (len >= max_cnt)
-				goto too_big;
-		}
+		len = __lpfc_idiag_print_wq(qp, "OAS", pbuffer, len);
+		if (len >= max_cnt)
+			goto too_big;
 	}
-out:
+
 	spin_unlock_irq(&phba->hbalock);
 	return simple_read_from_buffer(buf, nbytes, ppos, pbuffer, len);
 
@@ -2559,7 +2479,7 @@ lpfc_idiag_queacc_write(struct file *file, const char __user *buf,
 	struct lpfc_hba *phba = (struct lpfc_hba *)debug->i_private;
 	uint32_t qidx, quetp, queid, index, count, offset, value;
 	uint32_t *pentry;
-	struct lpfc_queue *pque;
+	struct lpfc_queue *pque, *qp;
 	int rc;
 
 	/* This is a user write operation */
@@ -2595,19 +2515,15 @@ lpfc_idiag_queacc_write(struct file *file, const char __user *buf,
 	case LPFC_IDIAG_EQ:
 		/* HBA event queue */
 		if (phba->sli4_hba.hba_eq) {
-			for (qidx = 0; qidx < phba->cfg_fcp_io_channel;
-				qidx++) {
-				if (phba->sli4_hba.hba_eq[qidx] &&
-				    phba->sli4_hba.hba_eq[qidx]->queue_id ==
-				    queid) {
+			for (qidx = 0; qidx < phba->io_channel_irqs; qidx++) {
+				qp = phba->sli4_hba.hba_eq[qidx];
+				if (qp && qp->queue_id == queid) {
 					/* Sanity check */
-					rc = lpfc_idiag_que_param_check(
-						phba->sli4_hba.hba_eq[qidx],
+					rc = lpfc_idiag_que_param_check(qp,
 						index, count);
 					if (rc)
 						goto error_out;
-					idiag.ptr_private =
-						phba->sli4_hba.hba_eq[qidx];
+					idiag.ptr_private = qp;
 					goto pass_check;
 				}
 			}
@@ -2637,24 +2553,32 @@ lpfc_idiag_queacc_write(struct file *file, const char __user *buf,
 			idiag.ptr_private = phba->sli4_hba.els_cq;
 			goto pass_check;
 		}
+		/* NVME LS complete queue */
+		if (phba->sli4_hba.nvmels_cq &&
+		    phba->sli4_hba.nvmels_cq->queue_id == queid) {
+			/* Sanity check */
+			rc = lpfc_idiag_que_param_check(
+					phba->sli4_hba.nvmels_cq, index, count);
+			if (rc)
+				goto error_out;
+			idiag.ptr_private = phba->sli4_hba.nvmels_cq;
+			goto pass_check;
+		}
 		/* FCP complete queue */
 		if (phba->sli4_hba.fcp_cq) {
-			qidx = 0;
-			do {
-				if (phba->sli4_hba.fcp_cq[qidx] &&
-				    phba->sli4_hba.fcp_cq[qidx]->queue_id ==
-				    queid) {
+			for (qidx = 0; qidx < phba->cfg_fcp_io_channel;
+								qidx++) {
+				qp = phba->sli4_hba.fcp_cq[qidx];
+				if (qp && qp->queue_id == queid) {
 					/* Sanity check */
 					rc = lpfc_idiag_que_param_check(
-						phba->sli4_hba.fcp_cq[qidx],
-						index, count);
+						qp, index, count);
 					if (rc)
 						goto error_out;
-					idiag.ptr_private =
-						phba->sli4_hba.fcp_cq[qidx];
+					idiag.ptr_private = qp;
 					goto pass_check;
 				}
-			} while (++qidx < phba->cfg_fcp_io_channel);
+			}
 		}
 		goto error_out;
 		break;
@@ -2684,22 +2608,45 @@ lpfc_idiag_queacc_write(struct file *file, const char __user *buf,
 			idiag.ptr_private = phba->sli4_hba.els_wq;
 			goto pass_check;
 		}
+		/* NVME LS work queue */
+		if (phba->sli4_hba.nvmels_wq &&
+		    phba->sli4_hba.nvmels_wq->queue_id == queid) {
+			/* Sanity check */
+			rc = lpfc_idiag_que_param_check(
+					phba->sli4_hba.nvmels_wq, index, count);
+			if (rc)
+				goto error_out;
+			idiag.ptr_private = phba->sli4_hba.nvmels_wq;
+			goto pass_check;
+		}
 		/* FCP work queue */
 		if (phba->sli4_hba.fcp_wq) {
 			for (qidx = 0; qidx < phba->cfg_fcp_io_channel;
-				qidx++) {
-				if (!phba->sli4_hba.fcp_wq[qidx])
-					continue;
-				if (phba->sli4_hba.fcp_wq[qidx]->queue_id ==
-				    queid) {
+								qidx++) {
+				qp = phba->sli4_hba.fcp_wq[qidx];
+				if (qp && qp->queue_id == queid) {
 					/* Sanity check */
 					rc = lpfc_idiag_que_param_check(
-						phba->sli4_hba.fcp_wq[qidx],
-						index, count);
+						qp, index, count);
+					if (rc)
+						goto error_out;
+					idiag.ptr_private = qp;
+					goto pass_check;
+				}
+			}
+		}
+		/* NVME work queue */
+		if (phba->sli4_hba.nvme_wq) {
+			for (qidx = 0; qidx < phba->cfg_nvme_io_channel;
+								qidx++) {
+				qp = phba->sli4_hba.nvme_wq[qidx];
+				if (qp && qp->queue_id == queid) {
+					/* Sanity check */
+					rc = lpfc_idiag_que_param_check(
+						qp, index, count);
 					if (rc)
 						goto error_out;
-					idiag.ptr_private =
-						phba->sli4_hba.fcp_wq[qidx];
+					idiag.ptr_private = qp;
 					goto pass_check;
 				}
 			}
@@ -3853,7 +3800,7 @@ lpfc_idiag_mbxacc_dump_bsg_mbox(struct lpfc_hba *phba, enum nemb_type nemb_tp,
 	if ((mbox_tp == mbox_rd) && (dma_tp == dma_mbox)) {
 		if (*mbx_dump_map & LPFC_BSG_DMP_MBX_RD_MBX) {
 			do_dump |= LPFC_BSG_DMP_MBX_RD_MBX;
-			printk(KERN_ERR "\nRead mbox command (x%x), "
+			pr_err("\nRead mbox command (x%x), "
 			       "nemb:0x%x, extbuf_cnt:%d:\n",
 			       sta_tp, nemb_tp, ext_buf);
 		}
@@ -3861,7 +3808,7 @@ lpfc_idiag_mbxacc_dump_bsg_mbox(struct lpfc_hba *phba, enum nemb_type nemb_tp,
 	if ((mbox_tp == mbox_rd) && (dma_tp == dma_ebuf)) {
 		if (*mbx_dump_map & LPFC_BSG_DMP_MBX_RD_BUF) {
 			do_dump |= LPFC_BSG_DMP_MBX_RD_BUF;
-			printk(KERN_ERR "\nRead mbox buffer (x%x), "
+			pr_err("\nRead mbox buffer (x%x), "
 			       "nemb:0x%x, extbuf_seq:%d:\n",
 			       sta_tp, nemb_tp, ext_buf);
 		}
@@ -3869,7 +3816,7 @@ lpfc_idiag_mbxacc_dump_bsg_mbox(struct lpfc_hba *phba, enum nemb_type nemb_tp,
 	if ((mbox_tp == mbox_wr) && (dma_tp == dma_mbox)) {
 		if (*mbx_dump_map & LPFC_BSG_DMP_MBX_WR_MBX) {
 			do_dump |= LPFC_BSG_DMP_MBX_WR_MBX;
-			printk(KERN_ERR "\nWrite mbox command (x%x), "
+			pr_err("\nWrite mbox command (x%x), "
 			       "nemb:0x%x, extbuf_cnt:%d:\n",
 			       sta_tp, nemb_tp, ext_buf);
 		}
@@ -3877,7 +3824,7 @@ lpfc_idiag_mbxacc_dump_bsg_mbox(struct lpfc_hba *phba, enum nemb_type nemb_tp,
 	if ((mbox_tp == mbox_wr) && (dma_tp == dma_ebuf)) {
 		if (*mbx_dump_map & LPFC_BSG_DMP_MBX_WR_BUF) {
 			do_dump |= LPFC_BSG_DMP_MBX_WR_BUF;
-			printk(KERN_ERR "\nWrite mbox buffer (x%x), "
+			pr_err("\nWrite mbox buffer (x%x), "
 			       "nemb:0x%x, extbuf_seq:%d:\n",
 			       sta_tp, nemb_tp, ext_buf);
 		}
@@ -3889,7 +3836,7 @@ lpfc_idiag_mbxacc_dump_bsg_mbox(struct lpfc_hba *phba, enum nemb_type nemb_tp,
 		for (i = 0; i < *mbx_word_cnt; i++) {
 			if (!(i % 8)) {
 				if (i != 0)
-					printk(KERN_ERR "%s\n", line_buf);
+					pr_err("%s\n", line_buf);
 				len = 0;
 				len += snprintf(line_buf+len,
 						LPFC_MBX_ACC_LBUF_SZ-len,
@@ -3900,7 +3847,7 @@ lpfc_idiag_mbxacc_dump_bsg_mbox(struct lpfc_hba *phba, enum nemb_type nemb_tp,
 			pword++;
 		}
 		if ((i - 1) % 8)
-			printk(KERN_ERR "%s\n", line_buf);
+			pr_err("%s\n", line_buf);
 		(*mbx_dump_cnt)--;
 	}
 
@@ -3949,13 +3896,13 @@ lpfc_idiag_mbxacc_dump_issue_mbox(struct lpfc_hba *phba, MAILBOX_t *pmbox)
 
 	/* dump buffer content */
 	if (*mbx_dump_map & LPFC_MBX_DMP_MBX_WORD) {
-		printk(KERN_ERR "Mailbox command:0x%x dump by word:\n",
+		pr_err("Mailbox command:0x%x dump by word:\n",
 		       pmbox->mbxCommand);
 		pword = (uint32_t *)pmbox;
 		for (i = 0; i < *mbx_word_cnt; i++) {
 			if (!(i % 8)) {
 				if (i != 0)
-					printk(KERN_ERR "%s\n", line_buf);
+					pr_err("%s\n", line_buf);
 				len = 0;
 				memset(line_buf, 0, LPFC_MBX_ACC_LBUF_SZ);
 				len += snprintf(line_buf+len,
@@ -3968,17 +3915,17 @@ lpfc_idiag_mbxacc_dump_issue_mbox(struct lpfc_hba *phba, MAILBOX_t *pmbox)
 			pword++;
 		}
 		if ((i - 1) % 8)
-			printk(KERN_ERR "%s\n", line_buf);
-		printk(KERN_ERR "\n");
+			pr_err("%s\n", line_buf);
+		pr_err("\n");
 	}
 	if (*mbx_dump_map & LPFC_MBX_DMP_MBX_BYTE) {
-		printk(KERN_ERR "Mailbox command:0x%x dump by byte:\n",
+		pr_err("Mailbox command:0x%x dump by byte:\n",
 		       pmbox->mbxCommand);
 		pbyte = (uint8_t *)pmbox;
 		for (i = 0; i < *mbx_word_cnt; i++) {
 			if (!(i % 8)) {
 				if (i != 0)
-					printk(KERN_ERR "%s\n", line_buf);
+					pr_err("%s\n", line_buf);
 				len = 0;
 				memset(line_buf, 0, LPFC_MBX_ACC_LBUF_SZ);
 				len += snprintf(line_buf+len,
@@ -3996,8 +3943,8 @@ lpfc_idiag_mbxacc_dump_issue_mbox(struct lpfc_hba *phba, MAILBOX_t *pmbox)
 					LPFC_MBX_ACC_LBUF_SZ-len, " ");
 		}
 		if ((i - 1) % 8)
-			printk(KERN_ERR "%s\n", line_buf);
-		printk(KERN_ERR "\n");
+			pr_err("%s\n", line_buf);
+		pr_err("\n");
 	}
 	(*mbx_dump_cnt)--;
 
@@ -4240,8 +4187,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 					i++;
 				}
 				lpfc_debugfs_max_slow_ring_trc = (1 << i);
-				printk(KERN_ERR
-				       "lpfc_debugfs_max_disc_trc changed to "
+				pr_err("lpfc_debugfs_max_disc_trc changed to "
 				       "%d\n", lpfc_debugfs_max_disc_trc);
 			}
 		}
@@ -4273,6 +4219,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 				(sizeof(struct lpfc_debugfs_trc) *
 				lpfc_debugfs_max_slow_ring_trc));
 		}
+
 	}
 
 	snprintf(name, sizeof(name), "vport%d", vport->vpi);
@@ -4298,8 +4245,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 				i++;
 			}
 			lpfc_debugfs_max_disc_trc = (1 << i);
-			printk(KERN_ERR
-			       "lpfc_debugfs_max_disc_trc changed to %d\n",
+			pr_err("lpfc_debugfs_max_disc_trc changed to %d\n",
 			       lpfc_debugfs_max_disc_trc);
 		}
 	}
@@ -4668,31 +4614,39 @@ lpfc_debugfs_terminate(struct lpfc_vport *vport)
 void
 lpfc_debug_dump_all_queues(struct lpfc_hba *phba)
 {
-	int fcp_wqidx;
+	int idx;
 
 	/*
 	 * Dump Work Queues (WQs)
 	 */
-	lpfc_debug_dump_mbx_wq(phba);
-	lpfc_debug_dump_els_wq(phba);
+	lpfc_debug_dump_wq(phba, DUMP_MBX, 0);
+	lpfc_debug_dump_wq(phba, DUMP_ELS, 0);
+	lpfc_debug_dump_wq(phba, DUMP_NVMELS, 0);
+
+	for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++)
+		lpfc_debug_dump_wq(phba, DUMP_FCP, idx);
 
-	for (fcp_wqidx = 0; fcp_wqidx < phba->cfg_fcp_io_channel; fcp_wqidx++)
-		lpfc_debug_dump_fcp_wq(phba, fcp_wqidx);
+	for (idx = 0; idx < phba->cfg_nvme_io_channel; idx++)
+		lpfc_debug_dump_wq(phba, DUMP_NVME, idx);
 
 	lpfc_debug_dump_hdr_rq(phba);
 	lpfc_debug_dump_dat_rq(phba);
 	/*
 	 * Dump Complete Queues (CQs)
 	 */
-	lpfc_debug_dump_mbx_cq(phba);
-	lpfc_debug_dump_els_cq(phba);
+	lpfc_debug_dump_cq(phba, DUMP_MBX, 0);
+	lpfc_debug_dump_cq(phba, DUMP_ELS, 0);
+	lpfc_debug_dump_cq(phba, DUMP_NVMELS, 0);
+
+	for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++)
+		lpfc_debug_dump_cq(phba, DUMP_FCP, idx);
 
-	for (fcp_wqidx = 0; fcp_wqidx < phba->cfg_fcp_io_channel; fcp_wqidx++)
-		lpfc_debug_dump_fcp_cq(phba, fcp_wqidx);
+	for (idx = 0; idx < phba->cfg_nvme_io_channel; idx++)
+		lpfc_debug_dump_cq(phba, DUMP_NVME, idx);
 
 	/*
 	 * Dump Event Queues (EQs)
 	 */
-	for (fcp_wqidx = 0; fcp_wqidx < phba->cfg_fcp_io_channel; fcp_wqidx++)
-		lpfc_debug_dump_hba_eq(phba, fcp_wqidx);
+	for (idx = 0; idx < phba->io_channel_irqs; idx++)
+		lpfc_debug_dump_hba_eq(phba, idx);
 }
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
index 8b2b6a3..98814d6 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -42,6 +42,14 @@
 /* hbqinfo output buffer size */
 #define LPFC_HBQINFO_SIZE 8192
 
+enum {
+	DUMP_FCP,
+	DUMP_NVME,
+	DUMP_MBX,
+	DUMP_ELS,
+	DUMP_NVMELS,
+};
+
 /*
  * For SLI4 iDiag debugfs diagnostics tool
  */
@@ -358,58 +366,111 @@ lpfc_debug_dump_q(struct lpfc_queue *q)
 }
 
 /**
- * lpfc_debug_dump_fcp_wq - dump all entries from a fcp work queue
+ * lpfc_debug_dump_wq - dump all entries from the fcp or nvme work queue
  * @phba: Pointer to HBA context object.
- * @fcp_wqidx: Index to a FCP work queue.
+ * @wqidx: Index to a FCP or NVME work queue.
  *
- * This function dumps all entries from a FCP work queue specified by the
- * @fcp_wqidx.
+ * This function dumps all entries from a FCP or NVME work queue specified
+ * by the wqidx.
  **/
 static inline void
-lpfc_debug_dump_fcp_wq(struct lpfc_hba *phba, int fcp_wqidx)
+lpfc_debug_dump_wq(struct lpfc_hba *phba, int qtype, int wqidx)
 {
-	/* sanity check */
-	if (fcp_wqidx >= phba->cfg_fcp_io_channel)
+	struct lpfc_queue *wq;
+	char *qtypestr;
+
+	if (qtype == DUMP_FCP) {
+		wq = phba->sli4_hba.fcp_wq[wqidx];
+		qtypestr = "FCP";
+	} else if (qtype == DUMP_NVME) {
+		wq = phba->sli4_hba.nvme_wq[wqidx];
+		qtypestr = "NVME";
+	} else if (qtype == DUMP_MBX) {
+		wq = phba->sli4_hba.mbx_wq;
+		qtypestr = "MBX";
+	} else if (qtype == DUMP_ELS) {
+		wq = phba->sli4_hba.els_wq;
+		qtypestr = "ELS";
+	} else if (qtype == DUMP_NVMELS) {
+		wq = phba->sli4_hba.nvmels_wq;
+		qtypestr = "NVMELS";
+	} else
 		return;
 
-	printk(KERN_ERR "FCP WQ: WQ[Idx:%d|Qid:%d]\n",
-		fcp_wqidx, phba->sli4_hba.fcp_wq[fcp_wqidx]->queue_id);
-	lpfc_debug_dump_q(phba->sli4_hba.fcp_wq[fcp_wqidx]);
+	if (qtype == DUMP_FCP || qtype == DUMP_NVME)
+		pr_err("%s WQ: WQ[Idx:%d|Qid:%d]\n",
+			qtypestr, wqidx, wq->queue_id);
+	else
+		pr_err("%s WQ: WQ[Qid:%d]\n",
+			qtypestr, wq->queue_id);
+
+	lpfc_debug_dump_q(wq);
 }
 
 /**
- * lpfc_debug_dump_fcp_cq - dump all entries from a fcp work queue's cmpl queue
+ * lpfc_debug_dump_cq - dump all entries from a fcp or nvme work queue's
+ * cmpl queue
  * @phba: Pointer to HBA context object.
- * @fcp_wqidx: Index to a FCP work queue.
+ * @wqidx: Index to a FCP work queue.
  *
- * This function dumps all entries from a FCP complete queue which is
- * associated to the FCP work queue specified by the @fcp_wqidx.
+ * This function dumps all entries from a FCP or NVME completion queue
+ * which is associated to the work queue specified by the @wqidx.
  **/
 static inline void
-lpfc_debug_dump_fcp_cq(struct lpfc_hba *phba, int fcp_wqidx)
+lpfc_debug_dump_cq(struct lpfc_hba *phba, int qtype, int wqidx)
 {
-	int fcp_cqidx, fcp_cqid;
-
-	/* sanity check */
-	if (fcp_wqidx >= phba->cfg_fcp_io_channel)
+	struct lpfc_queue *wq, *cq, *eq;
+	char *qtypestr;
+	int eqidx;
+
+	/* fcp/nvme wq and cq are 1:1, thus same indexes */
+
+	if (qtype == DUMP_FCP) {
+		wq = phba->sli4_hba.fcp_wq[wqidx];
+		cq = phba->sli4_hba.fcp_cq[wqidx];
+		qtypestr = "FCP";
+	} else if (qtype == DUMP_NVME) {
+		wq = phba->sli4_hba.nvme_wq[wqidx];
+		cq = phba->sli4_hba.nvme_cq[wqidx];
+		qtypestr = "NVME";
+	} else if (qtype == DUMP_MBX) {
+		wq = phba->sli4_hba.mbx_wq;
+		cq = phba->sli4_hba.mbx_cq;
+		qtypestr = "MBX";
+	} else if (qtype == DUMP_ELS) {
+		wq = phba->sli4_hba.els_wq;
+		cq = phba->sli4_hba.els_cq;
+		qtypestr = "ELS";
+	} else if (qtype == DUMP_NVMELS) {
+		wq = phba->sli4_hba.nvmels_wq;
+		cq = phba->sli4_hba.nvmels_cq;
+		qtypestr = "NVMELS";
+	} else
 		return;
 
-	fcp_cqid = phba->sli4_hba.fcp_wq[fcp_wqidx]->assoc_qid;
-	for (fcp_cqidx = 0; fcp_cqidx < phba->cfg_fcp_io_channel; fcp_cqidx++)
-		if (phba->sli4_hba.fcp_cq[fcp_cqidx]->queue_id == fcp_cqid)
+	for (eqidx = 0; eqidx < phba->io_channel_irqs; eqidx++) {
+		eq = phba->sli4_hba.hba_eq[eqidx];
+		if (cq->assoc_qid == eq->queue_id)
 			break;
-	if (phba->intr_type == MSIX) {
-		if (fcp_cqidx >= phba->cfg_fcp_io_channel)
-			return;
-	} else {
-		if (fcp_cqidx > 0)
-			return;
+	}
+	if (eqidx == phba->io_channel_irqs) {
+		pr_err("Couldn't find EQ for CQ. Using EQ[0]\n");
+		eqidx = 0;
+		eq = phba->sli4_hba.hba_eq[0];
 	}
 
-	printk(KERN_ERR "FCP CQ: WQ[Idx:%d|Qid%d]->CQ[Idx%d|Qid%d]:\n",
-		fcp_wqidx, phba->sli4_hba.fcp_wq[fcp_wqidx]->queue_id,
-		fcp_cqidx, fcp_cqid);
-	lpfc_debug_dump_q(phba->sli4_hba.fcp_cq[fcp_cqidx]);
+	if (qtype == DUMP_FCP || qtype == DUMP_NVME)
+		pr_err("%s CQ: WQ[Idx:%d|Qid%d]->CQ[Idx%d|Qid%d]"
+			"->EQ[Idx:%d|Qid:%d]:\n",
+			qtypestr, wqidx, wq->queue_id, wqidx, cq->queue_id,
+			eqidx, eq->queue_id);
+	else
+		pr_err("%s CQ: WQ[Qid:%d]->CQ[Qid:%d]"
+			"->EQ[Idx:%d|Qid:%d]:\n",
+			qtypestr, wq->queue_id, cq->queue_id,
+			eqidx, eq->queue_id);
+
+	lpfc_debug_dump_q(cq);
 }
 
 /**
@@ -421,64 +482,15 @@ lpfc_debug_dump_fcp_cq(struct lpfc_hba *phba, int fcp_wqidx)
  * associated to the FCP work queue specified by the @fcp_wqidx.
  **/
 static inline void
-lpfc_debug_dump_hba_eq(struct lpfc_hba *phba, int fcp_wqidx)
+lpfc_debug_dump_hba_eq(struct lpfc_hba *phba, int qidx)
 {
-	struct lpfc_queue *qdesc;
-	int fcp_eqidx, fcp_eqid;
-	int fcp_cqidx, fcp_cqid;
-
-	/* sanity check */
-	if (fcp_wqidx >= phba->cfg_fcp_io_channel)
-		return;
-	fcp_cqid = phba->sli4_hba.fcp_wq[fcp_wqidx]->assoc_qid;
-	for (fcp_cqidx = 0; fcp_cqidx < phba->cfg_fcp_io_channel; fcp_cqidx++)
-		if (phba->sli4_hba.fcp_cq[fcp_cqidx]->queue_id == fcp_cqid)
-			break;
-	if (phba->intr_type == MSIX) {
-		if (fcp_cqidx >= phba->cfg_fcp_io_channel)
-			return;
-	} else {
-		if (fcp_cqidx > 0)
-			return;
-	}
-
-	fcp_eqidx = fcp_cqidx;
-	fcp_eqid = phba->sli4_hba.hba_eq[fcp_eqidx]->queue_id;
-	qdesc = phba->sli4_hba.hba_eq[fcp_eqidx];
+	struct lpfc_queue *qp;
 
-	printk(KERN_ERR "FCP EQ: WQ[Idx:%d|Qid:%d]->CQ[Idx:%d|Qid:%d]->"
-		"EQ[Idx:%d|Qid:%d]\n",
-		fcp_wqidx, phba->sli4_hba.fcp_wq[fcp_wqidx]->queue_id,
-		fcp_cqidx, fcp_cqid, fcp_eqidx, fcp_eqid);
-	lpfc_debug_dump_q(qdesc);
-}
+	qp = phba->sli4_hba.hba_eq[qidx];
 
-/**
- * lpfc_debug_dump_els_wq - dump all entries from the els work queue
- * @phba: Pointer to HBA context object.
- *
- * This function dumps all entries from the ELS work queue.
- **/
-static inline void
-lpfc_debug_dump_els_wq(struct lpfc_hba *phba)
-{
-	printk(KERN_ERR "ELS WQ: WQ[Qid:%d]:\n",
-		phba->sli4_hba.els_wq->queue_id);
-	lpfc_debug_dump_q(phba->sli4_hba.els_wq);
-}
+	pr_err("EQ[Idx:%d|Qid:%d]\n", qidx, qp->queue_id);
 
-/**
- * lpfc_debug_dump_mbx_wq - dump all entries from the mbox work queue
- * @phba: Pointer to HBA context object.
- *
- * This function dumps all entries from the MBOX work queue.
- **/
-static inline void
-lpfc_debug_dump_mbx_wq(struct lpfc_hba *phba)
-{
-	printk(KERN_ERR "MBX WQ: WQ[Qid:%d]\n",
-		phba->sli4_hba.mbx_wq->queue_id);
-	lpfc_debug_dump_q(phba->sli4_hba.mbx_wq);
+	lpfc_debug_dump_q(qp);
 }
 
 /**
@@ -510,36 +522,6 @@ lpfc_debug_dump_hdr_rq(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_debug_dump_els_cq - dump all entries from the els complete queue
- * @phba: Pointer to HBA context object.
- *
- * This function dumps all entries from the els complete queue.
- **/
-static inline void
-lpfc_debug_dump_els_cq(struct lpfc_hba *phba)
-{
-	printk(KERN_ERR "ELS CQ: WQ[Qid:%d]->CQ[Qid:%d]\n",
-		phba->sli4_hba.els_wq->queue_id,
-		phba->sli4_hba.els_cq->queue_id);
-	lpfc_debug_dump_q(phba->sli4_hba.els_cq);
-}
-
-/**
- * lpfc_debug_dump_mbx_cq - dump all entries from the mbox complete queue
- * @phba: Pointer to HBA context object.
- *
- * This function dumps all entries from the mbox complete queue.
- **/
-static inline void
-lpfc_debug_dump_mbx_cq(struct lpfc_hba *phba)
-{
-	printk(KERN_ERR "MBX CQ: WQ[Qid:%d]->CQ[Qid:%d]\n",
-		phba->sli4_hba.mbx_wq->queue_id,
-		phba->sli4_hba.mbx_cq->queue_id);
-	lpfc_debug_dump_q(phba->sli4_hba.mbx_cq);
-}
-
-/**
  * lpfc_debug_dump_wq_by_id - dump all entries from a work queue by queue id
  * @phba: Pointer to HBA context object.
  * @qid: Work queue identifier.
@@ -556,14 +538,29 @@ lpfc_debug_dump_wq_by_id(struct lpfc_hba *phba, int qid)
 		if (phba->sli4_hba.fcp_wq[wq_idx]->queue_id == qid)
 			break;
 	if (wq_idx < phba->cfg_fcp_io_channel) {
-		printk(KERN_ERR "FCP WQ[Idx:%d|Qid:%d]\n", wq_idx, qid);
+		pr_err("FCP WQ[Idx:%d|Qid:%d]\n", wq_idx, qid);
 		lpfc_debug_dump_q(phba->sli4_hba.fcp_wq[wq_idx]);
 		return;
 	}
 
+	for (wq_idx = 0; wq_idx < phba->cfg_nvme_io_channel; wq_idx++)
+		if (phba->sli4_hba.nvme_wq[wq_idx]->queue_id == qid)
+			break;
+	if (wq_idx < phba->cfg_nvme_io_channel) {
+		pr_err("NVME WQ[Idx:%d|Qid:%d]\n", wq_idx, qid);
+		lpfc_debug_dump_q(phba->sli4_hba.nvme_wq[wq_idx]);
+		return;
+	}
+
 	if (phba->sli4_hba.els_wq->queue_id == qid) {
-		printk(KERN_ERR "ELS WQ[Qid:%d]\n", qid);
+		pr_err("ELS WQ[Qid:%d]\n", qid);
 		lpfc_debug_dump_q(phba->sli4_hba.els_wq);
+		return;
+	}
+
+	if (phba->sli4_hba.nvmels_wq->queue_id == qid) {
+		pr_err("NVME LS WQ[Qid:%d]\n", qid);
+		lpfc_debug_dump_q(phba->sli4_hba.nvmels_wq);
 	}
 }
 
@@ -617,27 +614,42 @@ lpfc_debug_dump_rq_by_id(struct lpfc_hba *phba, int qid)
 static inline void
 lpfc_debug_dump_cq_by_id(struct lpfc_hba *phba, int qid)
 {
-	int cq_idx = 0;
+	int cq_idx;
 
-	do {
+	for (cq_idx = 0; cq_idx < phba->cfg_fcp_io_channel; cq_idx++)
 		if (phba->sli4_hba.fcp_cq[cq_idx]->queue_id == qid)
 			break;
-	} while (++cq_idx < phba->cfg_fcp_io_channel);
 
 	if (cq_idx < phba->cfg_fcp_io_channel) {
-		printk(KERN_ERR "FCP CQ[Idx:%d|Qid:%d]\n", cq_idx, qid);
+		pr_err("FCP CQ[Idx:%d|Qid:%d]\n", cq_idx, qid);
 		lpfc_debug_dump_q(phba->sli4_hba.fcp_cq[cq_idx]);
 		return;
 	}
 
+	for (cq_idx = 0; cq_idx < phba->cfg_nvme_io_channel; cq_idx++)
+		if (phba->sli4_hba.nvme_cq[cq_idx]->queue_id == qid)
+			break;
+
+	if (cq_idx < phba->cfg_nvme_io_channel) {
+		pr_err("NVME CQ[Idx:%d|Qid:%d]\n", cq_idx, qid);
+		lpfc_debug_dump_q(phba->sli4_hba.nvme_cq[cq_idx]);
+		return;
+	}
+
 	if (phba->sli4_hba.els_cq->queue_id == qid) {
-		printk(KERN_ERR "ELS CQ[Qid:%d]\n", qid);
+		pr_err("ELS CQ[Qid:%d]\n", qid);
 		lpfc_debug_dump_q(phba->sli4_hba.els_cq);
 		return;
 	}
 
+	if (phba->sli4_hba.nvmels_cq->queue_id == qid) {
+		pr_err("NVME LS CQ[Qid:%d]\n", qid);
+		lpfc_debug_dump_q(phba->sli4_hba.nvmels_cq);
+		return;
+	}
+
 	if (phba->sli4_hba.mbx_cq->queue_id == qid) {
-		printk(KERN_ERR "MBX CQ[Qid:%d]\n", qid);
+		pr_err("MBX CQ[Qid:%d]\n", qid);
 		lpfc_debug_dump_q(phba->sli4_hba.mbx_cq);
 	}
 }
@@ -655,17 +667,15 @@ lpfc_debug_dump_eq_by_id(struct lpfc_hba *phba, int qid)
 {
 	int eq_idx;
 
-	for (eq_idx = 0; eq_idx < phba->cfg_fcp_io_channel; eq_idx++) {
+	for (eq_idx = 0; eq_idx < phba->io_channel_irqs; eq_idx++)
 		if (phba->sli4_hba.hba_eq[eq_idx]->queue_id == qid)
 			break;
-	}
 
-	if (eq_idx < phba->cfg_fcp_io_channel) {
+	if (eq_idx < phba->io_channel_irqs) {
 		printk(KERN_ERR "FCP EQ[Idx:%d|Qid:%d]\n", eq_idx, qid);
 		lpfc_debug_dump_q(phba->sli4_hba.hba_eq[eq_idx]);
 		return;
 	}
-
 }
 
 void lpfc_debug_dump_all_queues(struct lpfc_hba *);
-- 
2.5.0
