From: "Bhanu Prakash Gollapudi" <bprakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 01/12] bnx2fc: Replace printks with KERN_ALERT
 to KERN_ERR/KERN_INFO
Date: Mon, 27 Jun 2011 23:30:53 -0700
Message-ID: <1309242664-27252-2-git-send-email-bprakash@broadcom.com>
References: <1309242664-27252-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1309242664-27252-1-git-send-email-bprakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.open-fcoe.org/mailman/options/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


Signed-off-by: Bhanu Prakash Gollapudi <bprakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/scsi/bnx2fc/bnx2fc_debug.h |   16 ++++++++--------
 drivers/scsi/bnx2fc/bnx2fc_els.c   |    8 ++++----
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c  |    8 ++++----
 drivers/scsi/bnx2fc/bnx2fc_hwi.c   |   23 ++++++++++++-----------
 drivers/scsi/bnx2fc/bnx2fc_io.c    |   24 ++++++++++++------------
 drivers/scsi/bnx2fc/bnx2fc_tgt.c   |   24 ++++++++++++------------
 6 files changed, 52 insertions(+), 51 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_debug.h b/drivers/scsi/bnx2fc/bnx2fc_debug.h
index 7f6aff6..3416d9a 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_debug.h
+++ b/drivers/scsi/bnx2fc/bnx2fc_debug.h
@@ -21,21 +21,21 @@ extern unsigned int bnx2fc_debug_level;
 
 #define BNX2FC_ELS_DBG(fmt, arg...)					\
 	BNX2FC_CHK_LOGGING(LOG_ELS,					\
-			   printk(KERN_ALERT PFX fmt, ##arg))
+			   printk(KERN_INFO PFX fmt, ##arg))
 
 #define BNX2FC_MISC_DBG(fmt, arg...)					\
 	BNX2FC_CHK_LOGGING(LOG_MISC,					\
-			   printk(KERN_ALERT PFX fmt, ##arg))
+			   printk(KERN_INFO PFX fmt, ##arg))
 
 #define BNX2FC_IO_DBG(io_req, fmt, arg...)				\
 	do {								\
 		if (!io_req || !io_req->port || !io_req->port->lport ||	\
 		    !io_req->port->lport->host)				\
 			BNX2FC_CHK_LOGGING(LOG_IO,			\
-			   printk(KERN_ALERT PFX "NULL " fmt, ##arg));	\
+			   printk(KERN_INFO PFX "NULL " fmt, ##arg));	\
 		else							\
 			BNX2FC_CHK_LOGGING(LOG_IO,			\
-			   shost_printk(KERN_ALERT,			\
+			   shost_printk(KERN_INFO,			\
 				   (io_req)->port->lport->host,		\
 				   PFX "xid:0x%x " fmt,			\
 				   (io_req)->xid, ##arg));		\
@@ -46,10 +46,10 @@ extern unsigned int bnx2fc_debug_level;
 		if (!tgt || !tgt->port || !tgt->port->lport ||		\
 		    !tgt->port->lport->host || !tgt->rport)		\
 			BNX2FC_CHK_LOGGING(LOG_TGT,			\
-			   printk(KERN_ALERT PFX "NULL " fmt, ##arg));	\
+			   printk(KERN_INFO PFX "NULL " fmt, ##arg));	\
 		else							\
 			BNX2FC_CHK_LOGGING(LOG_TGT,			\
-			   shost_printk(KERN_ALERT,			\
+			   shost_printk(KERN_INFO,			\
 				   (tgt)->port->lport->host,		\
 				   PFX "port:%x " fmt,			\
 				   (tgt)->rport->port_id, ##arg));	\
@@ -60,10 +60,10 @@ extern unsigned int bnx2fc_debug_level;
 	do {								\
 		if (!lport || !lport->host)				\
 			BNX2FC_CHK_LOGGING(LOG_HBA,			\
-			   printk(KERN_ALERT PFX "NULL " fmt, ##arg));	\
+			   printk(KERN_INFO PFX "NULL " fmt, ##arg));	\
 		else							\
 			BNX2FC_CHK_LOGGING(LOG_HBA,			\
-			   shost_printk(KERN_ALERT, lport->host,	\
+			   shost_printk(KERN_INFO, lport->host,	\
 				   PFX fmt, ##arg));			\
 	} while (0)
 
diff --git a/drivers/scsi/bnx2fc/bnx2fc_els.c b/drivers/scsi/bnx2fc/bnx2fc_els.c
index 7e89143..e3f1873 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_els.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_els.c
@@ -274,12 +274,12 @@ static int bnx2fc_initiate_els(struct bnx2fc_rport *tgt, unsigned int op,
 
 	rc = fc_remote_port_chkready(rport);
 	if (rc) {
-		printk(KERN_ALERT PFX "els 0x%x: rport not ready\n", op);
+		printk(KERN_ERR PFX "els 0x%x: rport not ready\n", op);
 		rc = -EINVAL;
 		goto els_err;
 	}
 	if (lport->state != LPORT_ST_READY || !(lport->link_up)) {
-		printk(KERN_ALERT PFX "els 0x%x: link is not ready\n", op);
+		printk(KERN_ERR PFX "els 0x%x: link is not ready\n", op);
 		rc = -EINVAL;
 		goto els_err;
 	}
@@ -305,7 +305,7 @@ static int bnx2fc_initiate_els(struct bnx2fc_rport *tgt, unsigned int op,
 	mp_req = (struct bnx2fc_mp_req *)&(els_req->mp_req);
 	rc = bnx2fc_init_mp_req(els_req);
 	if (rc == FAILED) {
-		printk(KERN_ALERT PFX "ELS MP request init failed\n");
+		printk(KERN_ERR PFX "ELS MP request init failed\n");
 		spin_lock_bh(&tgt->tgt_lock);
 		kref_put(&els_req->refcount, bnx2fc_cmd_release);
 		spin_unlock_bh(&tgt->tgt_lock);
@@ -324,7 +324,7 @@ static int bnx2fc_initiate_els(struct bnx2fc_rport *tgt, unsigned int op,
 	if ((op >= ELS_LS_RJT) && (op <= ELS_AUTH_ELS)) {
 		memcpy(mp_req->req_buf, data, data_len);
 	} else {
-		printk(KERN_ALERT PFX "Invalid ELS op 0x%x\n", op);
+		printk(KERN_ERR PFX "Invalid ELS op 0x%x\n", op);
 		els_req->cb_func = NULL;
 		els_req->cb_arg = NULL;
 		spin_lock_bh(&tgt->tgt_lock);
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 5110652..bc3d591 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -387,12 +387,12 @@ static int bnx2fc_rcv(struct sk_buff *skb, struct net_device *dev,
 	lport = hba->ctlr.lp;
 
 	if (unlikely(lport == NULL)) {
-		printk(KERN_ALERT PFX "bnx2fc_rcv: lport is NULL\n");
+		printk(KERN_ERR PFX "bnx2fc_rcv: lport is NULL\n");
 		goto err;
 	}
 
 	if (unlikely(eth_hdr(skb)->h_proto != htons(ETH_P_FCOE))) {
-		printk(KERN_ALERT PFX "bnx2fc_rcv: Wrong FC type frame\n");
+		printk(KERN_ERR PFX "bnx2fc_rcv: Wrong FC type frame\n");
 		goto err;
 	}
 
@@ -469,7 +469,7 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
 	fr = fcoe_dev_from_skb(skb);
 	lport = fr->fr_dev;
 	if (unlikely(lport == NULL)) {
-		printk(KERN_ALERT PFX "Invalid lport struct\n");
+		printk(KERN_ERR PFX "Invalid lport struct\n");
 		kfree_skb(skb);
 		return;
 	}
@@ -1776,7 +1776,7 @@ static void bnx2fc_ulp_init(struct cnic_dev *dev)
 	rc = dev->register_device(dev, CNIC_ULP_FCOE,
 						(void *) hba);
 	if (rc)
-		printk(KERN_ALERT PFX "register_device failed, rc = %d\n", rc);
+		printk(KERN_ERR PFX "register_device failed, rc = %d\n", rc);
 	else
 		set_bit(BNX2FC_CNIC_REGISTERED, &hba->reg_with_cnic);
 }
diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 09bdd9b..b41deb6 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -781,7 +781,7 @@ void bnx2fc_process_cq_compl(struct bnx2fc_rport *tgt, u16 wqe)
 	spin_lock_bh(&tgt->tgt_lock);
 	xid = wqe & FCOE_PEND_WQ_CQE_TASK_ID;
 	if (xid >= BNX2FC_MAX_TASKS) {
-		printk(KERN_ALERT PFX "ERROR:xid out of range\n");
+		printk(KERN_ERR PFX "ERROR:xid out of range\n");
 		spin_unlock_bh(&tgt->tgt_lock);
 		return;
 	}
@@ -983,7 +983,7 @@ static void bnx2fc_fastpath_notification(struct bnx2fc_hba *hba,
 	struct bnx2fc_rport *tgt = hba->tgt_ofld_list[conn_id];
 
 	if (!tgt) {
-		printk(KERN_ALERT PFX "conn_id 0x%x not valid\n", conn_id);
+		printk(KERN_ERR PFX "conn_id 0x%x not valid\n", conn_id);
 		return;
 	}
 
@@ -1012,7 +1012,7 @@ static void bnx2fc_process_ofld_cmpl(struct bnx2fc_hba *hba,
 	context_id = ofld_kcqe->fcoe_conn_context_id;
 	tgt = hba->tgt_ofld_list[conn_id];
 	if (!tgt) {
-		printk(KERN_ALERT PFX "ERROR:ofld_cmpl: No pending ofld req\n");
+		printk(KERN_ERR PFX "ERROR:ofld_cmpl: No pending ofld req\n");
 		return;
 	}
 	BNX2FC_TGT_DBG(tgt, "Entered ofld compl - context_id = 0x%x\n",
@@ -1040,7 +1040,7 @@ static void bnx2fc_process_ofld_cmpl(struct bnx2fc_hba *hba,
 		/* now enable the session */
 		rc = bnx2fc_send_session_enable_req(port, tgt);
 		if (rc) {
-			printk(KERN_ALERT PFX "enable session failed\n");
+			printk(KERN_ERR PFX "enable session failed\n");
 			goto ofld_cmpl_err;
 		}
 	}
@@ -1070,7 +1070,7 @@ static void bnx2fc_process_enable_conn_cmpl(struct bnx2fc_hba *hba,
 	conn_id = ofld_kcqe->fcoe_conn_id;
 	tgt = hba->tgt_ofld_list[conn_id];
 	if (!tgt) {
-		printk(KERN_ALERT PFX "ERROR:enbl_cmpl: No pending ofld req\n");
+		printk(KERN_ERR PFX "ERROR:enbl_cmpl: No pending ofld req\n");
 		return;
 	}
 
@@ -1082,7 +1082,7 @@ static void bnx2fc_process_enable_conn_cmpl(struct bnx2fc_hba *hba,
 	 * and enable
 	 */
 	if (tgt->context_id != context_id) {
-		printk(KERN_ALERT PFX "context id mis-match\n");
+		printk(KERN_ERR PFX "context id mis-match\n");
 		return;
 	}
 	if (hba != tgt->port->priv) {
@@ -1114,14 +1114,14 @@ static void bnx2fc_process_conn_disable_cmpl(struct bnx2fc_hba *hba,
 	conn_id = disable_kcqe->fcoe_conn_id;
 	tgt = hba->tgt_ofld_list[conn_id];
 	if (!tgt) {
-		printk(KERN_ALERT PFX "ERROR: disable_cmpl: No disable req\n");
+		printk(KERN_ERR PFX "ERROR: disable_cmpl: No disable req\n");
 		return;
 	}
 
 	BNX2FC_TGT_DBG(tgt, PFX "disable_cmpl: conn_id %d\n", conn_id);
 
 	if (disable_kcqe->completion_status) {
-		printk(KERN_ALERT PFX "ERROR: Disable failed with cmpl status %d\n",
+		printk(KERN_ERR PFX "Disable failed with cmpl status %d\n",
 			disable_kcqe->completion_status);
 		return;
 	} else {
@@ -1143,14 +1143,14 @@ static void bnx2fc_process_conn_destroy_cmpl(struct bnx2fc_hba *hba,
 	conn_id = destroy_kcqe->fcoe_conn_id;
 	tgt = hba->tgt_ofld_list[conn_id];
 	if (!tgt) {
-		printk(KERN_ALERT PFX "destroy_cmpl: No destroy req\n");
+		printk(KERN_ERR PFX "destroy_cmpl: No destroy req\n");
 		return;
 	}
 
 	BNX2FC_TGT_DBG(tgt, "destroy_cmpl: conn_id %d\n", conn_id);
 
 	if (destroy_kcqe->completion_status) {
-		printk(KERN_ALERT PFX "Destroy conn failed, cmpl status %d\n",
+		printk(KERN_ERR PFX "Destroy conn failed, cmpl status %d\n",
 			destroy_kcqe->completion_status);
 		return;
 	} else {
@@ -1182,6 +1182,7 @@ static void bnx2fc_init_failure(struct bnx2fc_hba *hba, u32 err_code)
 		break;
 	case FCOE_KCQE_COMPLETION_STATUS_WRONG_HSI_VERSION:
 		printk(KERN_ERR PFX "init failure due to HSI mismatch\n");
+		break;
 	default:
 		printk(KERN_ERR PFX "Unknown Error code %d\n", err_code);
 	}
@@ -1262,7 +1263,7 @@ void bnx2fc_indicate_kcqe(void *context, struct kcqe *kcq[],
 		case FCOE_KCQE_OPCODE_FCOE_ERROR:
 			/* fall thru */
 		default:
-			printk(KERN_ALERT PFX "unknown opcode 0x%x\n",
+			printk(KERN_ERR PFX "unknown opcode 0x%x\n",
 								kcqe->op_code);
 		}
 	}
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 45eba6d..8f988c2 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -702,7 +702,7 @@ static int bnx2fc_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
 	hba = port->priv;
 
 	if (rport == NULL) {
-		printk(KERN_ALERT PFX "device_reset: rport is NULL\n");
+		printk(KERN_ERR PFX "device_reset: rport is NULL\n");
 		rc = FAILED;
 		goto tmf_err;
 	}
@@ -806,10 +806,10 @@ retry_tmf:
 	spin_unlock_bh(&tgt->tgt_lock);
 
 	if (!rc) {
-		printk(KERN_ERR PFX "task mgmt command failed...\n");
+		BNX2FC_TGT_DBG(tgt, "task mgmt command failed...\n");
 		rc = FAILED;
 	} else {
-		printk(KERN_ERR PFX "task mgmt command success...\n");
+		BNX2FC_TGT_DBG(tgt, "task mgmt command success...\n");
 		rc = SUCCESS;
 	}
 tmf_err:
@@ -849,7 +849,7 @@ int bnx2fc_initiate_abts(struct bnx2fc_cmd *io_req)
 	}
 
 	if (rport == NULL) {
-		printk(KERN_ALERT PFX "initiate_abts: rport is NULL\n");
+		printk(KERN_ERR PFX "initiate_abts: rport is NULL\n");
 		rc = FAILED;
 		goto abts_err;
 	}
@@ -1031,7 +1031,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 
 	lport = shost_priv(sc_cmd->device->host);
 	if ((lport->state != LPORT_ST_READY) || !(lport->link_up)) {
-		printk(KERN_ALERT PFX "eh_abort: link not ready\n");
+		printk(KERN_ERR PFX "eh_abort: link not ready\n");
 		return rc;
 	}
 
@@ -1062,7 +1062,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 	 * io_req is no longer in the active_q.
 	 */
 	if (tgt->flush_in_prog) {
-		printk(KERN_ALERT PFX "eh_abort: io_req (xid = 0x%x) "
+		printk(KERN_ERR PFX "eh_abort: io_req (xid = 0x%x) "
 			"flush in progress\n", io_req->xid);
 		kref_put(&io_req->refcount, bnx2fc_cmd_release);
 		spin_unlock_bh(&tgt->tgt_lock);
@@ -1070,7 +1070,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 	}
 
 	if (io_req->on_active_queue == 0) {
-		printk(KERN_ALERT PFX "eh_abort: io_req (xid = 0x%x) "
+		printk(KERN_ERR PFX "eh_abort: io_req (xid = 0x%x) "
 				"not on active_q\n", io_req->xid);
 		/*
 		 * This condition can happen only due to the FW bug,
@@ -1108,7 +1108,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 		set_bit(BNX2FC_FLAG_EH_ABORT, &io_req->req_flags);
 		rc = bnx2fc_initiate_abts(io_req);
 	} else {
-		printk(KERN_ALERT PFX "eh_abort: io_req (xid = 0x%x) "
+		printk(KERN_ERR PFX "eh_abort: io_req (xid = 0x%x) "
 				"already in abts processing\n", io_req->xid);
 		kref_put(&io_req->refcount, bnx2fc_cmd_release);
 		spin_unlock_bh(&tgt->tgt_lock);
@@ -1378,7 +1378,7 @@ void bnx2fc_process_tm_compl(struct bnx2fc_cmd *io_req,
 			fc_hdr->fh_r_ctl);
 	}
 	if (!sc_cmd->SCp.ptr) {
-		printk(KERN_ALERT PFX "tm_compl: SCp.ptr is NULL\n");
+		printk(KERN_ERR PFX "tm_compl: SCp.ptr is NULL\n");
 		return;
 	}
 	switch (io_req->fcp_status) {
@@ -1410,7 +1410,7 @@ void bnx2fc_process_tm_compl(struct bnx2fc_cmd *io_req,
 		io_req->on_tmf_queue = 0;
 	} else {
 
-		printk(KERN_ALERT PFX "Command not on active_cmd_queue!\n");
+		printk(KERN_ERR PFX "Command not on active_cmd_queue!\n");
 		return;
 	}
 
@@ -1597,7 +1597,7 @@ static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd *io_req,
 
 		if (rq_buff_len > num_rq * BNX2FC_RQ_BUF_SZ) {
 			/* Invalid sense sense length. */
-			printk(KERN_ALERT PFX "invalid sns length %d\n",
+			printk(KERN_ERR PFX "invalid sns length %d\n",
 				rq_buff_len);
 			/* reset rq_buff_len */
 			rq_buff_len =  num_rq * BNX2FC_RQ_BUF_SZ;
@@ -1780,7 +1780,7 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
 			scsi_set_resid(sc_cmd, io_req->fcp_resid);
 		break;
 	default:
-		printk(KERN_ALERT PFX "scsi_cmd_compl: fcp_status = %d\n",
+		printk(KERN_ERR PFX "scsi_cmd_compl: fcp_status = %d\n",
 			io_req->fcp_status);
 		break;
 	}
diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
index 3e892bd..4be391e 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -403,7 +403,7 @@ void bnx2fc_rport_event_handler(struct fc_lport *lport,
 	switch (event) {
 	case RPORT_EV_READY:
 		if (!rport) {
-			printk(KERN_ALERT PFX "rport is NULL: ERROR!\n");
+			printk(KERN_ERR PFX "rport is NULL: ERROR!\n");
 			break;
 		}
 
@@ -415,7 +415,7 @@ void bnx2fc_rport_event_handler(struct fc_lport *lport,
 			 * We should not come here, as lport will
 			 * take care of fabric login
 			 */
-			printk(KERN_ALERT PFX "%x - rport_event_handler ERROR\n",
+			printk(KERN_ERR PFX "%x - rport_event_handler ERROR\n",
 				rdata->ids.port_id);
 			break;
 		}
@@ -483,7 +483,7 @@ void bnx2fc_rport_event_handler(struct fc_lport *lport,
 			break;
 
 		if (!rport) {
-			printk(KERN_ALERT PFX "%x - rport not created Yet!!\n",
+			printk(KERN_INFO PFX "%x - rport not created Yet!!\n",
 				port_id);
 			break;
 		}
@@ -633,7 +633,7 @@ static int bnx2fc_alloc_session_resc(struct bnx2fc_hba *hba,
 	tgt->sq = dma_alloc_coherent(&hba->pcidev->dev, tgt->sq_mem_size,
 				     &tgt->sq_dma, GFP_KERNEL);
 	if (!tgt->sq) {
-		printk(KERN_ALERT PFX "unable to allocate SQ memory %d\n",
+		printk(KERN_ERR PFX "unable to allocate SQ memory %d\n",
 			tgt->sq_mem_size);
 		goto mem_alloc_failure;
 	}
@@ -646,7 +646,7 @@ static int bnx2fc_alloc_session_resc(struct bnx2fc_hba *hba,
 	tgt->cq = dma_alloc_coherent(&hba->pcidev->dev, tgt->cq_mem_size,
 				     &tgt->cq_dma, GFP_KERNEL);
 	if (!tgt->cq) {
-		printk(KERN_ALERT PFX "unable to allocate CQ memory %d\n",
+		printk(KERN_ERR PFX "unable to allocate CQ memory %d\n",
 			tgt->cq_mem_size);
 		goto mem_alloc_failure;
 	}
@@ -659,7 +659,7 @@ static int bnx2fc_alloc_session_resc(struct bnx2fc_hba *hba,
 	tgt->rq = dma_alloc_coherent(&hba->pcidev->dev, tgt->rq_mem_size,
 					&tgt->rq_dma, GFP_KERNEL);
 	if (!tgt->rq) {
-		printk(KERN_ALERT PFX "unable to allocate RQ memory %d\n",
+		printk(KERN_ERR PFX "unable to allocate RQ memory %d\n",
 			tgt->rq_mem_size);
 		goto mem_alloc_failure;
 	}
@@ -671,7 +671,7 @@ static int bnx2fc_alloc_session_resc(struct bnx2fc_hba *hba,
 	tgt->rq_pbl = dma_alloc_coherent(&hba->pcidev->dev, tgt->rq_pbl_size,
 					 &tgt->rq_pbl_dma, GFP_KERNEL);
 	if (!tgt->rq_pbl) {
-		printk(KERN_ALERT PFX "unable to allocate RQ PBL %d\n",
+		printk(KERN_ERR PFX "unable to allocate RQ PBL %d\n",
 			tgt->rq_pbl_size);
 		goto mem_alloc_failure;
 	}
@@ -697,7 +697,7 @@ static int bnx2fc_alloc_session_resc(struct bnx2fc_hba *hba,
 	tgt->xferq = dma_alloc_coherent(&hba->pcidev->dev, tgt->xferq_mem_size,
 					&tgt->xferq_dma, GFP_KERNEL);
 	if (!tgt->xferq) {
-		printk(KERN_ALERT PFX "unable to allocate XFERQ %d\n",
+		printk(KERN_ERR PFX "unable to allocate XFERQ %d\n",
 			tgt->xferq_mem_size);
 		goto mem_alloc_failure;
 	}
@@ -711,7 +711,7 @@ static int bnx2fc_alloc_session_resc(struct bnx2fc_hba *hba,
 	tgt->confq = dma_alloc_coherent(&hba->pcidev->dev, tgt->confq_mem_size,
 					&tgt->confq_dma, GFP_KERNEL);
 	if (!tgt->confq) {
-		printk(KERN_ALERT PFX "unable to allocate CONFQ %d\n",
+		printk(KERN_ERR PFX "unable to allocate CONFQ %d\n",
 			tgt->confq_mem_size);
 		goto mem_alloc_failure;
 	}
@@ -726,7 +726,7 @@ static int bnx2fc_alloc_session_resc(struct bnx2fc_hba *hba,
 					    tgt->confq_pbl_size,
 					    &tgt->confq_pbl_dma, GFP_KERNEL);
 	if (!tgt->confq_pbl) {
-		printk(KERN_ALERT PFX "unable to allocate CONFQ PBL %d\n",
+		printk(KERN_ERR PFX "unable to allocate CONFQ PBL %d\n",
 			tgt->confq_pbl_size);
 		goto mem_alloc_failure;
 	}
@@ -751,7 +751,7 @@ static int bnx2fc_alloc_session_resc(struct bnx2fc_hba *hba,
 					  tgt->conn_db_mem_size,
 					  &tgt->conn_db_dma, GFP_KERNEL);
 	if (!tgt->conn_db) {
-		printk(KERN_ALERT PFX "unable to allocate conn_db %d\n",
+		printk(KERN_ERR PFX "unable to allocate conn_db %d\n",
 						tgt->conn_db_mem_size);
 		goto mem_alloc_failure;
 	}
@@ -767,7 +767,7 @@ static int bnx2fc_alloc_session_resc(struct bnx2fc_hba *hba,
 				      &tgt->lcq_dma, GFP_KERNEL);
 
 	if (!tgt->lcq) {
-		printk(KERN_ALERT PFX "unable to allocate lcq %d\n",
+		printk(KERN_ERR PFX "unable to allocate lcq %d\n",
 		       tgt->lcq_mem_size);
 		goto mem_alloc_failure;
 	}
-- 
1.7.0.6
