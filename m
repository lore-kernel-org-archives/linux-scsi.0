From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 07/17] lpfc: NVME Initiator: Base modifications Part F
Date: Tue, 17 Jan 2017 17:20:50 -0800
Message-ID: <587ec2f2.fmE2wQTjIBsi69sa%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33391 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbdARBU4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2017 20:20:56 -0500
Received: by mail-wm0-f65.google.com with SMTP id r144so282756wme.0
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2017 17:20:55 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org


NVME Initiator: Base modifications

This is part F of parts A..F.

Part F is limited to lpfc_debugfs.[ch]. It contains the modifications in
the existing debugfs snippets to work with the base modifications.

*********

Refer to Part A for a description of base modifications

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 535 +++++++++++++++++++++------------------
 drivers/scsi/lpfc/lpfc_debugfs.h |  69 ++---
 2 files changed, 324 insertions(+), 280 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index a63542b..a94ba2d 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -283,7 +283,7 @@ lpfc_debugfs_hbqinfo_data(struct lpfc_hba *phba, char *buf, int size)
 	spin_lock_irq(&phba->hbalock);
 
 	/* toggle between multiple hbqs, if any */
-	i = lpfc_sli_hbq_count();
+	i = lpfc_sli_hbq_count(phba);
 	if (i > 1) {
 		 lpfc_debugfs_last_hbq++;
 		 if (lpfc_debugfs_last_hbq >= i)
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
@@ -968,8 +970,8 @@ lpfc_debugfs_dumpDif_open(struct inode *inode, struct file *file)
 		goto out;
 
 	/* Round to page boundary */
-	printk(KERN_ERR	"9060 BLKGRD: %s: _dump_buf_dif=0x%p file=%pD\n",
-		__func__, _dump_buf_dif, file);
+	pr_err("9060 BLKGRD: %s: _dump_buf_dif=0x%p file=%pD\n",
+	       __func__, _dump_buf_dif, file);
 	debug->buffer = _dump_buf_dif;
 	if (!debug->buffer) {
 		kfree(debug);
@@ -1165,8 +1167,22 @@ lpfc_debugfs_nodelist_open(struct inode *inode, struct file *file)
 static loff_t
 lpfc_debugfs_lseek(struct file *file, loff_t off, int whence)
 {
-	struct lpfc_debug *debug = file->private_data;
-	return fixed_size_llseek(file, off, whence, debug->len);
+	struct lpfc_debug *debug;
+	loff_t pos = -1;
+
+	debug = file->private_data;
+
+	switch (whence) {
+	case 0:
+		pos = off;
+		break;
+	case 1:
+		pos = file->f_pos + off;
+		break;
+	case 2:
+		pos = debug->len + off;
+	}
+	return (pos < 0 || pos > debug->len) ? -EINVAL : (file->f_pos = pos);
 }
 
 /**
@@ -1984,6 +2000,9 @@ lpfc_idiag_baracc_write(struct file *file, const char __user *buf,
  * Description:
  * This routine reads data from the @phba SLI4 PCI function queue information,
  * and copies to user @buf.
+ * This routine only returns 1 EQs worth of information. It remembers the last
+ * EQ read and jumps to the next EQ. Thus subsequent calls to queInfo will
+ * retrieve all EQs allocated for the phba.
  *
  * Returns:
  * This function returns the amount of data that was read (this could be less
@@ -1998,7 +2017,8 @@ lpfc_idiag_queinfo_read(struct file *file, char __user *buf, size_t nbytes,
 	int len = 0;
 	char *pbuffer;
 	int x, cnt;
-	int max_cnt;
+	int fcpx;
+	int max_cnt, io_channel;
 	struct lpfc_queue *qp = NULL;
 
 
@@ -2012,47 +2032,59 @@ lpfc_idiag_queinfo_read(struct file *file, char __user *buf, size_t nbytes,
 	if (*ppos)
 		return 0;
 
+	io_channel = phba->io_channel;
 	spin_lock_irq(&phba->hbalock);
 
 	/* Fast-path event queue */
-	if (phba->sli4_hba.hba_eq && phba->cfg_fcp_io_channel) {
-		cnt = phba->cfg_fcp_io_channel;
+	if (phba->sli4_hba.hba_eq && io_channel) {
+		cnt = io_channel;
 
-		for (x = 0; x < cnt; x++) {
+		x = phba->lpfc_idiag_last_eq;
+		if (phba->cfg_fof && (x >= io_channel)) {
+			phba->lpfc_idiag_last_eq = 0;
+			goto fof;
+		}
+		phba->lpfc_idiag_last_eq++;
+		if (phba->lpfc_idiag_last_eq >= io_channel)
+			if (phba->cfg_fof == 0)
+				phba->lpfc_idiag_last_eq = 0;
 
-			/* Fast-path EQ */
-			qp = phba->sli4_hba.hba_eq[x];
-			if (!qp)
-				goto proc_cq;
 
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\nHBA EQ info: "
-				"EQ-STAT[max:x%x noE:x%x "
-				"bs:x%x proc:x%llx]\n",
-				qp->q_cnt_1, qp->q_cnt_2,
-				qp->q_cnt_3, (unsigned long long)qp->q_cnt_4);
+		len += snprintf(pbuffer+len,
+			LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"EQ %d out of %d HBA EQs\n", x, io_channel);
 
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
+		/* Fast-path EQ */
+		qp = phba->sli4_hba.hba_eq[x];
+		if (!qp)
+			goto proc_cq;
 
+		len += snprintf(pbuffer+len,
+			LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"\nHBA EQ info: EQ-STAT[max:x%x noE:x%x "
+			"bs:x%x proc:x%llx]\n",
+			qp->q_cnt_1, qp->q_cnt_2,
+			qp->q_cnt_3, (unsigned long long)qp->q_cnt_4);
 
-			/* Reset max counter */
-			qp->EQ_max_eqe = 0;
+		len += snprintf(pbuffer+len,
+			LPFC_QUE_INFO_GET_BUF_SIZE-len,
+			"EQID[%02d], QE-CNT[%04d], QE-SIZE[%04d], "
+			"HOST-IDX[%04d], PORT-IDX[%04d]",
+			qp->queue_id,
+			qp->entry_count,
+			qp->entry_size,
+			qp->host_index,
+			qp->hba_index);
 
-			len +=  snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
-			if (len >= max_cnt)
-				goto too_big;
+		/* Reset max counter */
+		qp->EQ_max_eqe = 0;
+
+		len +=  snprintf(pbuffer+len,
+			LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
+		if (len >= max_cnt)
+			goto too_big;
 proc_cq:
+		if (x < phba->cfg_fcp_io_channel) {
 			/* Fast-path FCP CQ */
 			qp = phba->sli4_hba.fcp_cq[x];
 			len += snprintf(pbuffer+len,
@@ -2065,7 +2097,8 @@ lpfc_idiag_queinfo_read(struct file *file, char __user *buf, size_t nbytes,
 				"xabt:x%x wq:x%llx]\n",
 				qp->assoc_qid,
 				qp->q_cnt_1, qp->q_cnt_2,
-				qp->q_cnt_3, (unsigned long long)qp->q_cnt_4);
+				qp->q_cnt_3,
+				(unsigned long long)qp->q_cnt_4);
 			len += snprintf(pbuffer+len,
 				LPFC_QUE_INFO_GET_BUF_SIZE-len,
 				"\tCQID[%02d], "
@@ -2075,7 +2108,6 @@ lpfc_idiag_queinfo_read(struct file *file, char __user *buf, size_t nbytes,
 				qp->entry_size, qp->host_index,
 				qp->hba_index);
 
-
 			/* Reset max counter */
 			qp->CQ_max_cqe = 0;
 
@@ -2083,203 +2115,212 @@ lpfc_idiag_queinfo_read(struct file *file, char __user *buf, size_t nbytes,
 				LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
 			if (len >= max_cnt)
 				goto too_big;
+		}
 
-			/* Fast-path FCP WQ */
-			qp = phba->sli4_hba.fcp_wq[x];
+		/* Fast-path FCP WQ */
+		if (x < phba->cfg_fcp_io_channel) {
+			fcpx = x;
+fcp_wq:
+			qp = phba->sli4_hba.fcp_wq[fcpx];
+			len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"\t\tFCP WQ info: ");
+			len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"AssocCQID[%02d]: "
+					"WQ-STAT[oflow:x%x posted:x%llx]\n",
+					qp->assoc_qid,
+					qp->q_cnt_1,
+					(unsigned long long)
+					qp->q_cnt_4);
+			len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"\t\tWQID[%02d], "
+					"QE-CNT[%04d], QE-SIZE[%04d], "
+					"HOST-IDX[%04d], PORT-IDX[%04d]",
+					qp->queue_id,
+					qp->entry_count,
+					qp->entry_size,
+					qp->host_index,
+					qp->hba_index);
+
+			len +=  snprintf(pbuffer+len,
+					 LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					 "\n");
+			if (len >= max_cnt)
+				goto too_big;
 
+			fcpx += phba->cfg_fcp_io_channel;
+			if (fcpx < phba->cfg_fcp_max_hw_queue)
+				goto fcp_wq;
+		}
+
+		/* Only EQ 0 has slow path CQs configured */
+		if (x)
+			goto out;
+
+		/* Slow-path mailbox CQ */
+		qp = phba->sli4_hba.mbx_cq;
+		if (qp) {
 			len += snprintf(pbuffer+len,
 				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\t\tFCP WQ info: ");
+				"\tMBX CQ info: ");
 			len += snprintf(pbuffer+len,
 				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"AssocCQID[%02d]: "
-				"WQ-STAT[oflow:x%x posted:x%llx]\n",
+				"AssocEQID[%02d]: "
+				"CQ-STAT[mbox:x%x relw:x%x "
+				"xabt:x%x wq:x%llx]\n",
 				qp->assoc_qid,
-				qp->q_cnt_1, (unsigned long long)qp->q_cnt_4);
+				qp->q_cnt_1, qp->q_cnt_2,
+				qp->q_cnt_3,
+				(unsigned long long)qp->q_cnt_4);
 			len += snprintf(pbuffer+len,
 				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\t\tWQID[%02d], "
+				"\tCQID[%02d], "
 				"QE-CNT[%04d], QE-SIZE[%04d], "
 				"HOST-IDX[%04d], PORT-IDX[%04d]",
-				qp->queue_id,
-				qp->entry_count,
-				qp->entry_size,
-				qp->host_index,
+				qp->queue_id, qp->entry_count,
+				qp->entry_size, qp->host_index,
 				qp->hba_index);
 
 			len +=  snprintf(pbuffer+len,
 				LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
 			if (len >= max_cnt)
 				goto too_big;
+		}
 
-			if (x)
-				continue;
-
-			/* Only EQ 0 has slow path CQs configured */
-
-			/* Slow-path mailbox CQ */
-			qp = phba->sli4_hba.mbx_cq;
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
-
-			/* Slow-path MBOX MQ */
-			qp = phba->sli4_hba.mbx_wq;
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
+		/* Slow-path MBOX MQ */
+		qp = phba->sli4_hba.mbx_wq;
+		if (qp) {
+			len += snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len,
+				"\t\tMBX MQ info: ");
+			len += snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len,
+				"AssocCQID[%02d]:\n",
+				phba->sli4_hba.mbx_wq->assoc_qid);
+			len += snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len,
+				"\t\tWQID[%02d], "
+				"QE-CNT[%04d], QE-SIZE[%04d], "
+				"HOST-IDX[%04d], PORT-IDX[%04d]",
+				qp->queue_id, qp->entry_count,
+				qp->entry_size, qp->host_index,
+				qp->hba_index);
 
-				len +=  snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
-				if (len >= max_cnt)
-					goto too_big;
-			}
+			len +=  snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
+			if (len >= max_cnt)
+				goto too_big;
+		}
 
-			/* Slow-path ELS response CQ */
-			qp = phba->sli4_hba.els_cq;
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
+		/* Slow-path ELS response CQ */
+		qp = phba->sli4_hba.els_cq;
+		if (qp) {
+			len += snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len,
+				"\tELS CQ info: ");
+			len += snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len,
+				"AssocEQID[%02d]: "
+				"CQ-STAT[max:x%x relw:x%x "
+				"xabt:x%x wq:x%llx]\n",
+				qp->assoc_qid,
+				qp->q_cnt_1, qp->q_cnt_2,
+				qp->q_cnt_3,
+				(unsigned long long)qp->q_cnt_4);
+			len += snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len,
+				"\tCQID [%02d], "
+				"QE-CNT[%04d], QE-SIZE[%04d], "
+				"HOST-IDX[%04d], PORT-IDX[%04d]",
+				qp->queue_id, qp->entry_count,
+				qp->entry_size, qp->host_index,
+				qp->hba_index);
 
-				/* Reset max counter */
-				qp->CQ_max_cqe = 0;
+			/* Reset max counter */
+			qp->CQ_max_cqe = 0;
 
-				len +=  snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
-				if (len >= max_cnt)
-					goto too_big;
-			}
+			len +=  snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
+			if (len >= max_cnt)
+				goto too_big;
+		}
 
-			/* Slow-path ELS WQ */
-			qp = phba->sli4_hba.els_wq;
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
+		/* Slow-path ELS WQ */
+		qp = phba->sli4_hba.els_wq;
+		if (qp) {
+			len += snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len,
+				"\t\tELS WQ info: ");
+			len += snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len,
+				"AssocCQID[%02d]:  WQ-STAT[oflow:x%x "
+				"posted:x%llx]\n",
+				qp->assoc_qid,
+				qp->q_cnt_1,
+				(unsigned long long)qp->q_cnt_4);
+			len += snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len,
+				"\t\tWQID[%02d], "
+				"QE-CNT[%04d], QE-SIZE[%04d], "
+				"HOST-IDX[%04d], PORT-IDX[%04d]",
+				qp->queue_id, qp->entry_count,
+				qp->entry_size, qp->host_index,
+				qp->hba_index);
 
-				len +=  snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
-				if (len >= max_cnt)
-					goto too_big;
-			}
+			len +=  snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
+			if (len >= max_cnt)
+				goto too_big;
+		}
 
-			if (phba->sli4_hba.hdr_rq && phba->sli4_hba.dat_rq) {
-				/* Slow-path RQ header */
-				qp = phba->sli4_hba.hdr_rq;
+		if (phba->sli4_hba.hdr_rq && phba->sli4_hba.dat_rq) {
+			/* Slow-path RQ header */
+			qp = phba->sli4_hba.hdr_rq;
 
-				len += snprintf(pbuffer+len,
+			len += snprintf(pbuffer+len,
+			LPFC_QUE_INFO_GET_BUF_SIZE-len,
+				"\t\tRQ info: ");
+			len += snprintf(pbuffer+len,
 				LPFC_QUE_INFO_GET_BUF_SIZE-len,
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
+				"AssocCQID[%02d]: "
+				"RQ-STAT[nopost:x%x nobuf:x%x "
+				"trunc:x%x rcv:x%llx]\n",
+				qp->assoc_qid,
+				qp->q_cnt_1, qp->q_cnt_2,
+				qp->q_cnt_3,
+				(unsigned long long)qp->q_cnt_4);
+			len += snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len,
+				"\t\tHQID[%02d], "
+				"QE-CNT[%04d], QE-SIZE[%04d], "
+				"HOST-IDX[%04d], PORT-IDX[%04d]\n",
+				qp->queue_id,
+				qp->entry_count,
+				qp->entry_size,
+				qp->host_index,
+				qp->hba_index);
 
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
+			/* Slow-path RQ data */
+			qp = phba->sli4_hba.dat_rq;
+			len += snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len,
+				"\t\tDQID[%02d], "
+				"QE-CNT[%04d], QE-SIZE[%04d], "
+				"HOST-IDX[%04d], PORT-IDX[%04d]",
+				qp->queue_id,
+				qp->entry_count,
+				qp->entry_size,
+				qp->host_index,
+				qp->hba_index);
 
-				len +=  snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
-			}
+			len +=  snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
 		}
 	}
 
+fof:
 	if (phba->cfg_fof) {
 		/* FOF EQ */
 		qp = phba->sli4_hba.fof_eq;
@@ -2312,9 +2353,6 @@ lpfc_idiag_queinfo_read(struct file *file, char __user *buf, size_t nbytes,
 			LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
 		if (len >= max_cnt)
 			goto too_big;
-	}
-
-	if (phba->cfg_fof) {
 
 		/* OAS CQ */
 		qp = phba->sli4_hba.oas_cq;
@@ -2595,7 +2633,7 @@ lpfc_idiag_queacc_write(struct file *file, const char __user *buf,
 	case LPFC_IDIAG_EQ:
 		/* HBA event queue */
 		if (phba->sli4_hba.hba_eq) {
-			for (qidx = 0; qidx < phba->cfg_fcp_io_channel;
+			for (qidx = 0; qidx < phba->io_channel;
 				qidx++) {
 				if (phba->sli4_hba.hba_eq[qidx] &&
 				    phba->sli4_hba.hba_eq[qidx]->queue_id ==
@@ -4273,6 +4311,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 				(sizeof(struct lpfc_debugfs_trc) *
 				lpfc_debugfs_max_slow_ring_trc));
 		}
+
 	}
 
 	snprintf(name, sizeof(name), "vport%d", vport->vpi);
@@ -4668,7 +4707,7 @@ lpfc_debugfs_terminate(struct lpfc_vport *vport)
 void
 lpfc_debug_dump_all_queues(struct lpfc_hba *phba)
 {
-	int fcp_wqidx;
+	int idx;
 
 	/*
 	 * Dump Work Queues (WQs)
@@ -4676,8 +4715,8 @@ lpfc_debug_dump_all_queues(struct lpfc_hba *phba)
 	lpfc_debug_dump_mbx_wq(phba);
 	lpfc_debug_dump_els_wq(phba);
 
-	for (fcp_wqidx = 0; fcp_wqidx < phba->cfg_fcp_io_channel; fcp_wqidx++)
-		lpfc_debug_dump_fcp_wq(phba, fcp_wqidx);
+	for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++)
+		lpfc_debug_dump_wq(phba, idx);
 
 	lpfc_debug_dump_hdr_rq(phba);
 	lpfc_debug_dump_dat_rq(phba);
@@ -4687,12 +4726,12 @@ lpfc_debug_dump_all_queues(struct lpfc_hba *phba)
 	lpfc_debug_dump_mbx_cq(phba);
 	lpfc_debug_dump_els_cq(phba);
 
-	for (fcp_wqidx = 0; fcp_wqidx < phba->cfg_fcp_io_channel; fcp_wqidx++)
-		lpfc_debug_dump_fcp_cq(phba, fcp_wqidx);
+	for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++)
+		lpfc_debug_dump_fcp_cq(phba, idx);
 
 	/*
 	 * Dump Event Queues (EQs)
 	 */
-	for (fcp_wqidx = 0; fcp_wqidx < phba->cfg_fcp_io_channel; fcp_wqidx++)
-		lpfc_debug_dump_hba_eq(phba, fcp_wqidx);
+	for (idx = 0; idx < phba->io_channel; idx++)
+		lpfc_debug_dump_hba_eq(phba, idx);
 }
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
index 8b2b6a3..33e733d 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -358,23 +358,26 @@ lpfc_debug_dump_q(struct lpfc_queue *q)
 }
 
 /**
- * lpfc_debug_dump_fcp_wq - dump all entries from a fcp work queue
+ * lpfc_debug_dump_wq - dump all entries from the fcp work queue
  * @phba: Pointer to HBA context object.
- * @fcp_wqidx: Index to a FCP work queue.
+ * @wqidx: Index to a FCP work queue.
  *
  * This function dumps all entries from a FCP work queue specified by the
- * @fcp_wqidx.
+ * @wqidx.
  **/
 static inline void
-lpfc_debug_dump_fcp_wq(struct lpfc_hba *phba, int fcp_wqidx)
+lpfc_debug_dump_wq(struct lpfc_hba *phba, int wqidx)
 {
 	/* sanity check */
-	if (fcp_wqidx >= phba->cfg_fcp_io_channel)
+	if (wqidx >= phba->cfg_fcp_io_channel) {
+		pr_err("WQIDX %d too large for FCP WQ max %d\n",
+		       wqidx, phba->cfg_fcp_io_channel);
 		return;
+	}
 
-	printk(KERN_ERR "FCP WQ: WQ[Idx:%d|Qid:%d]\n",
-		fcp_wqidx, phba->sli4_hba.fcp_wq[fcp_wqidx]->queue_id);
-	lpfc_debug_dump_q(phba->sli4_hba.fcp_wq[fcp_wqidx]);
+	pr_err("FCP WQ: WQ[Idx:%d|Qid:%d]\n",
+	       wqidx, phba->sli4_hba.fcp_wq[wqidx]->queue_id);
+	lpfc_debug_dump_q(phba->sli4_hba.fcp_wq[wqidx]);
 }
 
 /**
@@ -421,35 +424,37 @@ lpfc_debug_dump_fcp_cq(struct lpfc_hba *phba, int fcp_wqidx)
  * associated to the FCP work queue specified by the @fcp_wqidx.
  **/
 static inline void
-lpfc_debug_dump_hba_eq(struct lpfc_hba *phba, int fcp_wqidx)
+lpfc_debug_dump_hba_eq(struct lpfc_hba *phba, int wqidx)
 {
 	struct lpfc_queue *qdesc;
-	int fcp_eqidx, fcp_eqid;
-	int fcp_cqidx, fcp_cqid;
+	int eqidx, eqid;
+	int cqidx, cqid;
 
-	/* sanity check */
-	if (fcp_wqidx >= phba->cfg_fcp_io_channel)
+	/* Start with FCP Queues.  Sanity check the index */
+	if (wqidx >= phba->cfg_fcp_io_channel)
 		return;
-	fcp_cqid = phba->sli4_hba.fcp_wq[fcp_wqidx]->assoc_qid;
-	for (fcp_cqidx = 0; fcp_cqidx < phba->cfg_fcp_io_channel; fcp_cqidx++)
-		if (phba->sli4_hba.fcp_cq[fcp_cqidx]->queue_id == fcp_cqid)
+
+	cqid = phba->sli4_hba.fcp_wq[wqidx]->assoc_qid;
+	for (cqidx = 0; cqidx < phba->cfg_fcp_io_channel; cqidx++)
+		if (phba->sli4_hba.fcp_cq[cqidx]->queue_id == cqid)
 			break;
 	if (phba->intr_type == MSIX) {
-		if (fcp_cqidx >= phba->cfg_fcp_io_channel)
+		if (cqidx >= phba->io_channel)
 			return;
 	} else {
-		if (fcp_cqidx > 0)
+		if (cqidx > 0)
 			return;
 	}
 
-	fcp_eqidx = fcp_cqidx;
-	fcp_eqid = phba->sli4_hba.hba_eq[fcp_eqidx]->queue_id;
-	qdesc = phba->sli4_hba.hba_eq[fcp_eqidx];
+	eqidx = cqidx;
+	eqid = phba->sli4_hba.hba_eq[eqidx]->queue_id;
+	qdesc = phba->sli4_hba.hba_eq[eqidx];
 
-	printk(KERN_ERR "FCP EQ: WQ[Idx:%d|Qid:%d]->CQ[Idx:%d|Qid:%d]->"
-		"EQ[Idx:%d|Qid:%d]\n",
-		fcp_wqidx, phba->sli4_hba.fcp_wq[fcp_wqidx]->queue_id,
-		fcp_cqidx, fcp_cqid, fcp_eqidx, fcp_eqid);
+	pr_err(
+	       "FCP EQ: WQ[Idx:%d|Qid:%d]->CQ[Idx:%d|Qid:%d]->"
+	       "EQ[Idx:%d|Qid:%d]\n",
+	       wqidx, phba->sli4_hba.fcp_wq[wqidx]->queue_id,
+	       cqidx, cqid, eqidx, eqid);
 	lpfc_debug_dump_q(qdesc);
 }
 
@@ -556,13 +561,13 @@ lpfc_debug_dump_wq_by_id(struct lpfc_hba *phba, int qid)
 		if (phba->sli4_hba.fcp_wq[wq_idx]->queue_id == qid)
 			break;
 	if (wq_idx < phba->cfg_fcp_io_channel) {
-		printk(KERN_ERR "FCP WQ[Idx:%d|Qid:%d]\n", wq_idx, qid);
+		pr_err("FCP WQ[Idx:%d|Qid:%d]\n", wq_idx, qid);
 		lpfc_debug_dump_q(phba->sli4_hba.fcp_wq[wq_idx]);
 		return;
 	}
 
 	if (phba->sli4_hba.els_wq->queue_id == qid) {
-		printk(KERN_ERR "ELS WQ[Qid:%d]\n", qid);
+		pr_err("ELS WQ[Qid:%d]\n", qid);
 		lpfc_debug_dump_q(phba->sli4_hba.els_wq);
 	}
 }
@@ -625,19 +630,19 @@ lpfc_debug_dump_cq_by_id(struct lpfc_hba *phba, int qid)
 	} while (++cq_idx < phba->cfg_fcp_io_channel);
 
 	if (cq_idx < phba->cfg_fcp_io_channel) {
-		printk(KERN_ERR "FCP CQ[Idx:%d|Qid:%d]\n", cq_idx, qid);
+		pr_err("FCP CQ[Idx:%d|Qid:%d]\n", cq_idx, qid);
 		lpfc_debug_dump_q(phba->sli4_hba.fcp_cq[cq_idx]);
 		return;
 	}
 
 	if (phba->sli4_hba.els_cq->queue_id == qid) {
-		printk(KERN_ERR "ELS CQ[Qid:%d]\n", qid);
+		pr_err("ELS CQ[Qid:%d]\n", qid);
 		lpfc_debug_dump_q(phba->sli4_hba.els_cq);
 		return;
 	}
 
 	if (phba->sli4_hba.mbx_cq->queue_id == qid) {
-		printk(KERN_ERR "MBX CQ[Qid:%d]\n", qid);
+		pr_err("MBX CQ[Qid:%d]\n", qid);
 		lpfc_debug_dump_q(phba->sli4_hba.mbx_cq);
 	}
 }
@@ -655,12 +660,12 @@ lpfc_debug_dump_eq_by_id(struct lpfc_hba *phba, int qid)
 {
 	int eq_idx;
 
-	for (eq_idx = 0; eq_idx < phba->cfg_fcp_io_channel; eq_idx++) {
+	for (eq_idx = 0; eq_idx < phba->io_channel; eq_idx++) {
 		if (phba->sli4_hba.hba_eq[eq_idx]->queue_id == qid)
 			break;
 	}
 
-	if (eq_idx < phba->cfg_fcp_io_channel) {
+	if (eq_idx < phba->io_channel) {
 		printk(KERN_ERR "FCP EQ[Idx:%d|Qid:%d]\n", eq_idx, qid);
 		lpfc_debug_dump_q(phba->sli4_hba.hba_eq[eq_idx]);
 		return;
-- 
2.5.0

