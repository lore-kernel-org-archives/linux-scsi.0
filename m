From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 4/4] be2iscsi: code reorganizing and minor changes
Date: Wed, 18 Nov 2009 06:13:55 +0530
Message-ID: <20091118004345.GA10344@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:17097 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752278AbZKRAns (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2009 19:43:48 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

             This patch does a couple of very small, mostly
    single line changes which I feel will be an overkill to put in
    individual patches

 1) moved pci_set_drvdata to inside beiscsi_hba_alloc
 2) Enabled handling of  TEXT Response
 3) Added opcode for ISCSI_OP_LOGOUT_RSP, ISCSI_OP_SCSI_TMFUNC_RSP,
 4) Ask for ack based completion for NOOPOUT and TTT != RESERVERD

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.c |   23 +++++++++++++++++------
 drivers/scsi/be2iscsi/be_main.h |    4 ++--
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index ac76b14..109482f 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -112,6 +112,7 @@ static struct beiscsi_hba *beiscsi_hba_alloc(struct pci_dev *pcidev)
 	memset(phba, 0, sizeof(*phba));
 	phba->shost = shost;
 	phba->pcidev = pci_dev_get(pcidev);
+	pci_set_drvdata(pcidev, phba);
 
 	if (iscsi_host_add(shost, &phba->pcidev->dev))
 		goto free_devices;
@@ -564,6 +565,8 @@ beiscsi_process_async_pdu(struct beiscsi_conn *beiscsi_conn,
 		login_hdr = (struct iscsi_hdr *)ppdu;
 		login_hdr->itt = io_task->libiscsi_itt;
 		break;
+	case ISCSI_OP_TEXT_RSP:
+		break;
 	default:
 		shost_printk(KERN_WARNING, phba->shost,
 			     "Unrecognized opcode 0x%x in async msg \n",
@@ -789,6 +792,7 @@ be_complete_io(struct beiscsi_conn *beiscsi_conn,
 		memcpy(task->sc->sense_buffer, sense,
 		       min_t(u16, sense_len, SCSI_SENSE_BUFFERSIZE));
 	}
+
 	if (io_task->cmd_bhs->iscsi_hdr.flags & ISCSI_FLAG_CMD_READ) {
 		if (psol->dw[offsetof(struct amap_sol_cqe, i_res_cnt) / 32]
 							& SOL_RES_CNT_MASK)
@@ -810,6 +814,7 @@ be_complete_logout(struct beiscsi_conn *beiscsi_conn,
 	struct iscsi_conn *conn = beiscsi_conn->conn;
 
 	hdr = (struct iscsi_logout_rsp *)task->hdr;
+	hdr->opcode = ISCSI_OP_LOGOUT_RSP;
 	hdr->t2wait = 5;
 	hdr->t2retain = 0;
 	hdr->flags = ((psol->dw[offsetof(struct amap_sol_cqe, i_flags) / 32]
@@ -824,6 +829,9 @@ be_complete_logout(struct beiscsi_conn *beiscsi_conn,
 					& SOL_EXP_CMD_SN_MASK) +
 			((psol->dw[offsetof(struct amap_sol_cqe, i_cmd_wnd)
 					/ 32] & SOL_CMD_WND_MASK) >> 24) - 1);
+	hdr->dlength[0] = 0;
+	hdr->dlength[1] = 0;
+	hdr->dlength[2] = 0;
 	hdr->hlength = 0;
 	hdr->itt = io_task->libiscsi_itt;
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
@@ -838,6 +846,7 @@ be_complete_tmf(struct beiscsi_conn *beiscsi_conn,
 	struct beiscsi_io_task *io_task = task->dd_data;
 
 	hdr = (struct iscsi_tm_rsp *)task->hdr;
+	hdr->opcode = ISCSI_OP_SCSI_TMFUNC_RSP;
 	hdr->flags = ((psol->dw[offsetof(struct amap_sol_cqe, i_flags) / 32]
 					& SOL_FLAGS_MASK) >> 24) | 0x80;
 	hdr->response = (psol->dw[offsetof(struct amap_sol_cqe, i_resp) /
@@ -1461,6 +1470,7 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 		}
 		beiscsi_ep = ep->dd_data;
 		beiscsi_conn = beiscsi_ep->conn;
+
 		if (num_processed >= 32) {
 			hwi_ring_cq_db(phba, cq->id,
 					num_processed, 0, 0);
@@ -3332,7 +3342,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 			goto free_hndls;
 	} else {
 		io_task->scsi_cmnd = NULL;
-		if ((task->hdr->opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGIN) {
+		if ((opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGIN) {
 			if (!beiscsi_conn->login_in_progress) {
 				spin_lock(&phba->mgmt_sgl_lock);
 				io_task->psgl_handle = (struct sgl_handle *)
@@ -3539,6 +3549,10 @@ static int beiscsi_mtask(struct iscsi_task *task)
 		else
 			AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
 				      INI_RD_CMD);
+		if (task->hdr->ttt == ISCSI_RESERVED_TAG)
+			AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
+		else
+			AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 1);
 		hwi_write_buffer(pwrb, task);
 		break;
 	case ISCSI_OP_TEXT:
@@ -3547,6 +3561,7 @@ static int beiscsi_mtask(struct iscsi_task *task)
 		else
 			AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
 				      INI_WR_CMD);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 1);
 		hwi_write_buffer(pwrb, task);
 		break;
@@ -3594,7 +3609,7 @@ static int beiscsi_mtask(struct iscsi_task *task)
 	}
 
 	AMAP_SET_BITS(struct amap_iscsi_wrb, r2t_exp_dtl, pwrb,
-		      be32_to_cpu(task->data_count));
+		      task->data_count);
 	AMAP_SET_BITS(struct amap_iscsi_wrb, ptr2nextwrb, pwrb,
 		      io_task->pwrb_handle->nxt_wrb_index);
 	be_dws_le_to_cpu(pwrb, sizeof(struct iscsi_wrb));
@@ -3630,8 +3645,6 @@ static int beiscsi_task_xmit(struct iscsi_task *task)
 		SE_DEBUG(DBG_LVL_1, " scsi_dma_map Failed\n")
 		return num_sg;
 	}
-	SE_DEBUG(DBG_LVL_4, "xferlen=0x%08x scmd=%p num_sg=%d sernum=%lu\n",
-		  (scsi_bufflen(sc)), sc, num_sg, sc->serial_number);
 	xferlen = scsi_bufflen(sc);
 	sg = scsi_sglist(sc);
 	if (sc->sc_data_direction == DMA_TO_DEVICE) {
@@ -3726,9 +3739,7 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 			" Failed in beiscsi_hba_alloc \n");
 		goto disable_pci;
 	}
-	SE_DEBUG(DBG_LVL_8, " phba = %p \n", phba);
 
-	pci_set_drvdata(pcidev, phba);
 	if (enable_msix)
 		num_cpus = find_num_cpus();
 	else
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 0e2eac6..388bd58 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -651,8 +651,8 @@ struct amap_iscsi_wrb {
 
 } __packed;
 
-struct wrb_handle *alloc_wrb_handle(struct beiscsi_hba *phba, unsigned int cid,
-				    int index);
+struct wrb_handle *alloc_wrb_handle(struct beiscsi_hba *phba, unsigned int cid);
+
 void
 free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle);
 
-- 
1.6.4

