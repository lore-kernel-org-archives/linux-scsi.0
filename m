From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.12-rc4
Date: Sat, 10 Jun 2017 14:23:50 -0700
Message-ID: <1497129830.3598.11.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a set of user visible fixes (excepting one format string
change).  Four of the qla2xxx fixes only affect the firmware dump path,
but it's still important to the enterprise.  The rest are various NULL
pointer crash conditions or outright driver hangs.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Arnd Bergmann (1):
      scsi: lpfc: nvmet_fc: fix format string

Bill Kuzeja (1):
      scsi: qla2xxx: Fix extraneous ref on sp's after adapter break

Guilherme G. Piccoli (1):
      scsi: lpfc: Avoid NULL pointer dereference in lpfc_els_abort()

Gustavo A. R. Silva (1):
      scsi: lpfc: prevent potential null pointer dereference

Joe Carnuccio (4):
      scsi: qla2xxx: Fix crash due to NULL pointer dereference of ctx
      scsi: qla2xxx: Fix mailbox pointer error in fwdump capture
      scsi: qla2xxx: Set bit 15 for DIAG_ECHO_TEST MBC
      scsi: qla2xxx: Modify T262 FW dump template to specify same start/end to debug customer issues

Johannes Thumshirn (1):
      scsi: qla2xxx: don't disable a not previously enabled PCI device

Martin K. Petersen (1):
      scsi: scsi_debug: Avoid PI being disabled when TPGS is enabled

Maurizio Lombardi (1):
      scsi: bnx2fc: fix race condition in bnx2fc_get_host_stats()

Quinn Tran (1):
      scsi: qla2xxx: Fix NULL pointer access due to redundant fc_host_port_name call

Sawan Chandak (1):
      scsi: qla2xxx: Fix crash due to mismatch mumber of Q-pair creation for Multi queue

Varun Prakash (1):
      scsi: cxgb4i: libcxgbi: in error case RST tcp conn

himanshu.madhani@cavium.com (1):
      scsi: qla2xxx: Fix recursive loop during target mode configuration for ISP25XX leaving system unresponsive

And diffstat:

 drivers/scsi/bnx2fc/bnx2fc.h       |  1 +
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c  | 10 +++++++--
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |  1 -
 drivers/scsi/cxgbi/libcxgbi.c      | 29 ++++++++++++++++++------
 drivers/scsi/cxgbi/libcxgbi.h      |  1 +
 drivers/scsi/lpfc/lpfc_crtn.h      |  2 +-
 drivers/scsi/lpfc/lpfc_ct.c        |  5 +++--
 drivers/scsi/lpfc/lpfc_nportdisc.c |  7 ++++--
 drivers/scsi/lpfc/lpfc_nvmet.c     |  4 ++--
 drivers/scsi/qla2xxx/qla_bsg.c     |  9 ++++----
 drivers/scsi/qla2xxx/qla_dbg.c     |  4 ++--
 drivers/scsi/qla2xxx/qla_def.h     |  1 +
 drivers/scsi/qla2xxx/qla_init.c    |  5 ++++-
 drivers/scsi/qla2xxx/qla_inline.h  | 26 ++++++---------------
 drivers/scsi/qla2xxx/qla_isr.c     |  2 +-
 drivers/scsi/qla2xxx/qla_mbx.c     | 13 ++---------
 drivers/scsi/qla2xxx/qla_os.c      | 46 ++++++++++++++++++++++++--------------
 drivers/scsi/qla2xxx/qla_target.c  |  8 ++++---
 drivers/scsi/qla2xxx/qla_tmpl.c    |  2 +-
 drivers/scsi/scsi_debug.c          |  2 +-
 20 files changed, 101 insertions(+), 77 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 4fc8ed5fe067..1f424e40afdf 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -191,6 +191,7 @@ struct bnx2fc_hba {
 	struct bnx2fc_cmd_mgr *cmd_mgr;
 	spinlock_t hba_lock;
 	struct mutex hba_mutex;
+	struct mutex hba_stats_mutex;
 	unsigned long adapter_state;
 		#define ADAPTER_STATE_UP		0
 		#define ADAPTER_STATE_GOING_DOWN	1
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 93b5a0012417..902722dc4ce3 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -663,15 +663,17 @@ static struct fc_host_statistics *bnx2fc_get_host_stats(struct Scsi_Host *shost)
 	if (!fw_stats)
 		return NULL;
 
+	mutex_lock(&hba->hba_stats_mutex);
+
 	bnx2fc_stats = fc_get_host_stats(shost);
 
 	init_completion(&hba->stat_req_done);
 	if (bnx2fc_send_stat_req(hba))
-		return bnx2fc_stats;
+		goto unlock_stats_mutex;
 	rc = wait_for_completion_timeout(&hba->stat_req_done, (2 * HZ));
 	if (!rc) {
 		BNX2FC_HBA_DBG(lport, "FW stat req timed out\n");
-		return bnx2fc_stats;
+		goto unlock_stats_mutex;
 	}
 	BNX2FC_STATS(hba, rx_stat2, fc_crc_cnt);
 	bnx2fc_stats->invalid_crc_count += hba->bfw_stats.fc_crc_cnt;
@@ -693,6 +695,9 @@ static struct fc_host_statistics *bnx2fc_get_host_stats(struct Scsi_Host *shost)
 
 	memcpy(&hba->prev_stats, hba->stats_buffer,
 	       sizeof(struct fcoe_statistics_params));
+
+unlock_stats_mutex:
+	mutex_unlock(&hba->hba_stats_mutex);
 	return bnx2fc_stats;
 }
 
@@ -1340,6 +1345,7 @@ static struct bnx2fc_hba *bnx2fc_hba_create(struct cnic_dev *cnic)
 	}
 	spin_lock_init(&hba->hba_lock);
 	mutex_init(&hba->hba_mutex);
+	mutex_init(&hba->hba_stats_mutex);
 
 	hba->cnic = cnic;
 
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 1076c1578322..0aae094ab91c 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -1595,7 +1595,6 @@ static void release_offload_resources(struct cxgbi_sock *csk)
 		cxgbi_sock_put(csk);
 	}
 	csk->dst = NULL;
-	csk->cdev = NULL;
 }
 
 static int init_act_open(struct cxgbi_sock *csk)
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index fb06974c88c1..e4c83b7c96a8 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -867,7 +867,8 @@ static void need_active_close(struct cxgbi_sock *csk)
 	log_debug(1 << CXGBI_DBG_SOCK, "csk 0x%p,%u,0x%lx,%u.\n",
 		csk, (csk)->state, (csk)->flags, (csk)->tid);
 	spin_lock_bh(&csk->lock);
-	dst_confirm(csk->dst);
+	if (csk->dst)
+		dst_confirm(csk->dst);
 	data_lost = skb_queue_len(&csk->receive_queue);
 	__skb_queue_purge(&csk->receive_queue);
 
@@ -882,7 +883,8 @@ static void need_active_close(struct cxgbi_sock *csk)
 	}
 
 	if (close_req) {
-		if (data_lost)
+		if (!cxgbi_sock_flag(csk, CTPF_LOGOUT_RSP_RCVD) ||
+		    data_lost)
 			csk->cdev->csk_send_abort_req(csk);
 		else
 			csk->cdev->csk_send_close_req(csk);
@@ -1186,9 +1188,10 @@ static int cxgbi_sock_send_pdus(struct cxgbi_sock *csk, struct sk_buff *skb)
 				cxgbi_ulp_extra_len(cxgbi_skcb_ulp_mode(skb));
 		skb = next;
 	}
-done:
+
 	if (likely(skb_queue_len(&csk->write_queue)))
 		cdev->csk_push_tx_frames(csk, 1);
+done:
 	spin_unlock_bh(&csk->lock);
 	return copied;
 
@@ -1568,9 +1571,12 @@ static inline int read_pdu_skb(struct iscsi_conn *conn,
 	}
 }
 
-static int skb_read_pdu_bhs(struct iscsi_conn *conn, struct sk_buff *skb)
+static int
+skb_read_pdu_bhs(struct cxgbi_sock *csk, struct iscsi_conn *conn,
+		 struct sk_buff *skb)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+	int err;
 
 	log_debug(1 << CXGBI_DBG_PDU_RX,
 		"conn 0x%p, skb 0x%p, len %u, flag 0x%lx.\n",
@@ -1608,7 +1614,16 @@ static int skb_read_pdu_bhs(struct iscsi_conn *conn, struct sk_buff *skb)
 		}
 	}
 
-	return read_pdu_skb(conn, skb, 0, 0);
+	err = read_pdu_skb(conn, skb, 0, 0);
+	if (likely(err >= 0)) {
+		struct iscsi_hdr *hdr = (struct iscsi_hdr *)skb->data;
+		u8 opcode = hdr->opcode & ISCSI_OPCODE_MASK;
+
+		if (unlikely(opcode == ISCSI_OP_LOGOUT_RSP))
+			cxgbi_sock_set_flag(csk, CTPF_LOGOUT_RSP_RCVD);
+	}
+
+	return err;
 }
 
 static int skb_read_pdu_data(struct iscsi_conn *conn, struct sk_buff *lskb,
@@ -1713,7 +1728,7 @@ void cxgbi_conn_pdu_ready(struct cxgbi_sock *csk)
 			cxgbi_skcb_rx_pdulen(skb));
 
 		if (cxgbi_skcb_test_flag(skb, SKCBF_RX_COALESCED)) {
-			err = skb_read_pdu_bhs(conn, skb);
+			err = skb_read_pdu_bhs(csk, conn, skb);
 			if (err < 0) {
 				pr_err("coalesced bhs, csk 0x%p, skb 0x%p,%u, "
 					"f 0x%lx, plen %u.\n",
@@ -1731,7 +1746,7 @@ void cxgbi_conn_pdu_ready(struct cxgbi_sock *csk)
 					cxgbi_skcb_flags(skb),
 					cxgbi_skcb_rx_pdulen(skb));
 		} else {
-			err = skb_read_pdu_bhs(conn, skb);
+			err = skb_read_pdu_bhs(csk, conn, skb);
 			if (err < 0) {
 				pr_err("bhs, csk 0x%p, skb 0x%p,%u, "
 					"f 0x%lx, plen %u.\n",
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index 239462a75760..37f07aaab1e4 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -187,6 +187,7 @@ enum cxgbi_sock_flags {
 	CTPF_HAS_ATID,		/* reserved atid */
 	CTPF_HAS_TID,		/* reserved hw tid */
 	CTPF_OFFLOAD_DOWN,	/* offload function off */
+	CTPF_LOGOUT_RSP_RCVD,   /* received logout response */
 };
 
 struct cxgbi_skb_rx_cb {
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 8912767e7bc8..da669dce12fe 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -127,7 +127,7 @@ int lpfc_disc_state_machine(struct lpfc_vport *, struct lpfc_nodelist *, void *,
 void lpfc_do_scr_ns_plogi(struct lpfc_hba *, struct lpfc_vport *);
 int lpfc_check_sparm(struct lpfc_vport *, struct lpfc_nodelist *,
 		     struct serv_parm *, uint32_t, int);
-int lpfc_els_abort(struct lpfc_hba *, struct lpfc_nodelist *);
+void lpfc_els_abort(struct lpfc_hba *, struct lpfc_nodelist *);
 void lpfc_more_plogi(struct lpfc_vport *);
 void lpfc_more_adisc(struct lpfc_vport *);
 void lpfc_end_rscn(struct lpfc_vport *);
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index f2cd19c6c2df..24ce96dcc94d 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -978,9 +978,10 @@ lpfc_cmpl_ct_cmd_gft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 					 ndlp, did, ndlp->nlp_fc4_type,
 					 FC_TYPE_FCP, FC_TYPE_NVME);
 			ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
+
+			lpfc_nlp_set_state(vport, ndlp, NLP_STE_PRLI_ISSUE);
+			lpfc_issue_els_prli(vport, ndlp, 0);
 		}
-		lpfc_nlp_set_state(vport, ndlp, NLP_STE_PRLI_ISSUE);
-		lpfc_issue_els_prli(vport, ndlp, 0);
 	} else
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
 				 "3065 GFT_ID failed x%08x\n", irsp->ulpStatus);
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index bff3de053df4..f74cb0142fd4 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -206,7 +206,7 @@ lpfc_check_elscmpl_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  * associated with a LPFC_NODELIST entry. This
  * routine effectively results in a "software abort".
  */
-int
+void
 lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 {
 	LIST_HEAD(abort_list);
@@ -215,6 +215,10 @@ lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 
 	pring = lpfc_phba_elsring(phba);
 
+	/* In case of error recovery path, we might have a NULL pring here */
+	if (!pring)
+		return;
+
 	/* Abort outstanding I/O on NPort <nlp_DID> */
 	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_DISCOVERY,
 			 "2819 Abort outstanding I/O on NPort x%x "
@@ -273,7 +277,6 @@ lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 			      IOSTAT_LOCAL_REJECT, IOERR_SLI_ABORTED);
 
 	lpfc_cancel_retry_delay_tmo(phba->pport, ndlp);
-	return 0;
 }
 
 static int
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index f94294b77b7b..24d54dd016d4 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -799,8 +799,8 @@ lpfc_nvmet_xmt_fcp_release(struct nvmet_fc_target_port *tgtport,
 	}
 	spin_unlock_irqrestore(&ctxp->ctxlock, flags);
 
-	lpfc_nvmeio_data(phba, "NVMET FCP FREE: xri x%x ste %d\n", ctxp->oxid,
-			 ctxp->state, 0);
+	lpfc_nvmeio_data(phba, "NVMET FCP FREE: xri x%x ste %d abt %d\n", ctxp->oxid,
+			 ctxp->state, aborting);
 
 	atomic_inc(&lpfc_nvmep->xmt_fcp_release);
 
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 16d1cd50feed..ca3420de5a01 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -730,6 +730,8 @@ qla2x00_process_loopback(struct bsg_job *bsg_job)
 		return -EIO;
 	}
 
+	memset(&elreq, 0, sizeof(elreq));
+
 	elreq.req_sg_cnt = dma_map_sg(&ha->pdev->dev,
 		bsg_job->request_payload.sg_list, bsg_job->request_payload.sg_cnt,
 		DMA_TO_DEVICE);
@@ -795,10 +797,9 @@ qla2x00_process_loopback(struct bsg_job *bsg_job)
 
 	if (atomic_read(&vha->loop_state) == LOOP_READY &&
 	    (ha->current_topology == ISP_CFG_F ||
-	    ((IS_QLA81XX(ha) || IS_QLA8031(ha) || IS_QLA8044(ha)) &&
-	    le32_to_cpu(*(uint32_t *)req_data) == ELS_OPCODE_BYTE
-	    && req_data_len == MAX_ELS_FRAME_PAYLOAD)) &&
-		elreq.options == EXTERNAL_LOOPBACK) {
+	    (le32_to_cpu(*(uint32_t *)req_data) == ELS_OPCODE_BYTE &&
+	     req_data_len == MAX_ELS_FRAME_PAYLOAD)) &&
+	    elreq.options == EXTERNAL_LOOPBACK) {
 		type = "FC_BSG_HST_VENDOR_ECHO_DIAG";
 		ql_dbg(ql_dbg_user, vha, 0x701e,
 		    "BSG request type: %s.\n", type);
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 51b4179469d1..88748a6ab73f 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1131,7 +1131,7 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	/* Mailbox registers. */
 	mbx_reg = &reg->mailbox0;
-	for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++, dmp_reg++)
+	for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++, mbx_reg++)
 		fw->mailbox_reg[cnt] = htons(RD_REG_WORD(mbx_reg));
 
 	/* Transfer sequence registers. */
@@ -2090,7 +2090,7 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	/* Mailbox registers. */
 	mbx_reg = &reg->mailbox0;
-	for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++, dmp_reg++)
+	for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++, mbx_reg++)
 		fw->mailbox_reg[cnt] = htons(RD_REG_WORD(mbx_reg));
 
 	/* Transfer sequence registers. */
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index ae119018dfaa..eddbc1218a39 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3425,6 +3425,7 @@ struct qla_hw_data {
 	uint8_t 	max_req_queues;
 	uint8_t 	max_rsp_queues;
 	uint8_t		max_qpairs;
+	uint8_t		num_qpairs;
 	struct qla_qpair *base_qpair;
 	struct qla_npiv_entry *npiv_info;
 	uint16_t	nvram_npiv_size;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 034743309ada..0391fc317003 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -7543,12 +7543,13 @@ struct qla_qpair *qla2xxx_create_qpair(struct scsi_qla_host *vha, int qos, int v
 		/* Assign available que pair id */
 		mutex_lock(&ha->mq_lock);
 		qpair_id = find_first_zero_bit(ha->qpair_qid_map, ha->max_qpairs);
-		if (qpair_id >= ha->max_qpairs) {
+		if (ha->num_qpairs >= ha->max_qpairs) {
 			mutex_unlock(&ha->mq_lock);
 			ql_log(ql_log_warn, vha, 0x0183,
 			    "No resources to create additional q pair.\n");
 			goto fail_qid_map;
 		}
+		ha->num_qpairs++;
 		set_bit(qpair_id, ha->qpair_qid_map);
 		ha->queue_pair_map[qpair_id] = qpair;
 		qpair->id = qpair_id;
@@ -7635,6 +7636,7 @@ struct qla_qpair *qla2xxx_create_qpair(struct scsi_qla_host *vha, int qos, int v
 fail_msix:
 	ha->queue_pair_map[qpair_id] = NULL;
 	clear_bit(qpair_id, ha->qpair_qid_map);
+	ha->num_qpairs--;
 	mutex_unlock(&ha->mq_lock);
 fail_qid_map:
 	kfree(qpair);
@@ -7660,6 +7662,7 @@ int qla2xxx_delete_qpair(struct scsi_qla_host *vha, struct qla_qpair *qpair)
 	mutex_lock(&ha->mq_lock);
 	ha->queue_pair_map[qpair->id] = NULL;
 	clear_bit(qpair->id, ha->qpair_qid_map);
+	ha->num_qpairs--;
 	list_del(&qpair->qp_list_elem);
 	if (list_empty(&vha->qp_list))
 		vha->flags.qpairs_available = 0;
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 66df6cec59da..c61a6a871c8e 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -129,28 +129,16 @@ qla2x00_clear_loop_id(fc_port_t *fcport) {
 }
 
 static inline void
-qla2x00_clean_dsd_pool(struct qla_hw_data *ha, srb_t *sp,
-	struct qla_tgt_cmd *tc)
+qla2x00_clean_dsd_pool(struct qla_hw_data *ha, struct crc_context *ctx)
 {
-	struct dsd_dma *dsd_ptr, *tdsd_ptr;
-	struct crc_context *ctx;
-
-	if (sp)
-		ctx = (struct crc_context *)GET_CMD_CTX_SP(sp);
-	else if (tc)
-		ctx = (struct crc_context *)tc->ctx;
-	else {
-		BUG();
-		return;
-	}
+	struct dsd_dma *dsd, *tdsd;
 
 	/* clean up allocated prev pool */
-	list_for_each_entry_safe(dsd_ptr, tdsd_ptr,
-	    &ctx->dsd_list, list) {
-		dma_pool_free(ha->dl_dma_pool, dsd_ptr->dsd_addr,
-		    dsd_ptr->dsd_list_dma);
-		list_del(&dsd_ptr->list);
-		kfree(dsd_ptr);
+	list_for_each_entry_safe(dsd, tdsd, &ctx->dsd_list, list) {
+		dma_pool_free(ha->dl_dma_pool, dsd->dsd_addr,
+		    dsd->dsd_list_dma);
+		list_del(&dsd->list);
+		kfree(dsd);
 	}
 	INIT_LIST_HEAD(&ctx->dsd_list);
 }
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index aac03504d9a3..2572121b765b 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3282,7 +3282,7 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 	}
 
 	/* Enable MSI-X vector for response queue update for queue 0 */
-	if (IS_QLA83XX(ha) || IS_QLA27XX(ha)) {
+	if (IS_QLA25XX(ha) || IS_QLA83XX(ha) || IS_QLA27XX(ha)) {
 		if (ha->msixbase && ha->mqiobase &&
 		    (ha->max_rsp_queues > 1 || ha->max_req_queues > 1 ||
 		     ql2xmqsupport))
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index a113ab3592a7..cba1fc5e8be9 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3676,15 +3676,6 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 				qlt_update_host_map(vha, id);
 			}
 
-			fc_host_port_name(vha->host) =
-			    wwn_to_u64(vha->port_name);
-
-			if (qla_ini_mode_enabled(vha))
-				ql_dbg(ql_dbg_mbx, vha, 0x1018,
-				    "FA-WWN portname %016llx (%x)\n",
-				    fc_host_port_name(vha->host),
-				    rptid_entry->vp_status);
-
 			set_bit(REGISTER_FC4_NEEDED, &vha->dpc_flags);
 			set_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags);
 		} else {
@@ -4821,9 +4812,9 @@ qla2x00_echo_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq,
 
 	memset(mcp->mb, 0 , sizeof(mcp->mb));
 	mcp->mb[0] = MBC_DIAGNOSTIC_ECHO;
-	mcp->mb[1] = mreq->options | BIT_6;	/* BIT_6 specifies 64bit address */
+	/* BIT_6 specifies 64bit address */
+	mcp->mb[1] = mreq->options | BIT_15 | BIT_6;
 	if (IS_CNA_CAPABLE(ha)) {
-		mcp->mb[1] |= BIT_15;
 		mcp->mb[2] = vha->fcoe_fcf_idx;
 	}
 	mcp->mb[16] = LSW(mreq->rcv_dma);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1c7957903283..79f050256c55 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -630,29 +630,34 @@ qla2x00_sp_free_dma(void *ptr)
 		sp->flags &= ~SRB_CRC_PROT_DMA_VALID;
 	}
 
+	if (!ctx)
+		goto end;
+
 	if (sp->flags & SRB_CRC_CTX_DSD_VALID) {
 		/* List assured to be having elements */
-		qla2x00_clean_dsd_pool(ha, sp, NULL);
+		qla2x00_clean_dsd_pool(ha, ctx);
 		sp->flags &= ~SRB_CRC_CTX_DSD_VALID;
 	}
 
 	if (sp->flags & SRB_CRC_CTX_DMA_VALID) {
-		dma_pool_free(ha->dl_dma_pool, ctx,
-		    ((struct crc_context *)ctx)->crc_ctx_dma);
+		struct crc_context *ctx0 = ctx;
+
+		dma_pool_free(ha->dl_dma_pool, ctx0, ctx0->crc_ctx_dma);
 		sp->flags &= ~SRB_CRC_CTX_DMA_VALID;
 	}
 
 	if (sp->flags & SRB_FCP_CMND_DMA_VALID) {
-		struct ct6_dsd *ctx1 = (struct ct6_dsd *)ctx;
+		struct ct6_dsd *ctx1 = ctx;
 
 		dma_pool_free(ha->fcp_cmnd_dma_pool, ctx1->fcp_cmnd,
-			ctx1->fcp_cmnd_dma);
+		    ctx1->fcp_cmnd_dma);
 		list_splice(&ctx1->dsd_list, &ha->gbl_dsd_list);
 		ha->gbl_dsd_inuse -= ctx1->dsd_use_cnt;
 		ha->gbl_dsd_avail += ctx1->dsd_use_cnt;
 		mempool_free(ctx1, ha->ctx_mempool);
 	}
 
+end:
 	CMD_SP(cmd) = NULL;
 	qla2x00_rel_sp(sp);
 }
@@ -699,21 +704,24 @@ qla2xxx_qpair_sp_free_dma(void *ptr)
 		sp->flags &= ~SRB_CRC_PROT_DMA_VALID;
 	}
 
+	if (!ctx)
+		goto end;
+
 	if (sp->flags & SRB_CRC_CTX_DSD_VALID) {
 		/* List assured to be having elements */
-		qla2x00_clean_dsd_pool(ha, sp, NULL);
+		qla2x00_clean_dsd_pool(ha, ctx);
 		sp->flags &= ~SRB_CRC_CTX_DSD_VALID;
 	}
 
 	if (sp->flags & SRB_CRC_CTX_DMA_VALID) {
-		dma_pool_free(ha->dl_dma_pool, ctx,
-		    ((struct crc_context *)ctx)->crc_ctx_dma);
+		struct crc_context *ctx0 = ctx;
+
+		dma_pool_free(ha->dl_dma_pool, ctx, ctx0->crc_ctx_dma);
 		sp->flags &= ~SRB_CRC_CTX_DMA_VALID;
 	}
 
 	if (sp->flags & SRB_FCP_CMND_DMA_VALID) {
-		struct ct6_dsd *ctx1 = (struct ct6_dsd *)ctx;
-
+		struct ct6_dsd *ctx1 = ctx;
 		dma_pool_free(ha->fcp_cmnd_dma_pool, ctx1->fcp_cmnd,
 		    ctx1->fcp_cmnd_dma);
 		list_splice(&ctx1->dsd_list, &ha->gbl_dsd_list);
@@ -721,7 +729,7 @@ qla2xxx_qpair_sp_free_dma(void *ptr)
 		ha->gbl_dsd_avail += ctx1->dsd_use_cnt;
 		mempool_free(ctx1, ha->ctx_mempool);
 	}
-
+end:
 	CMD_SP(cmd) = NULL;
 	qla2xxx_rel_qpair_sp(sp->qpair, sp);
 }
@@ -1632,7 +1640,7 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 void
 qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 {
-	int que, cnt;
+	int que, cnt, status;
 	unsigned long flags;
 	srb_t *sp;
 	struct qla_hw_data *ha = vha->hw;
@@ -1662,8 +1670,12 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 					 */
 					sp_get(sp);
 					spin_unlock_irqrestore(&ha->hardware_lock, flags);
-					qla2xxx_eh_abort(GET_CMD_SP(sp));
+					status = qla2xxx_eh_abort(GET_CMD_SP(sp));
 					spin_lock_irqsave(&ha->hardware_lock, flags);
+					/* Get rid of extra reference if immediate exit
+					 * from ql2xxx_eh_abort */
+					if (status == FAILED && (qla2x00_isp_reg_stat(ha)))
+						atomic_dec(&sp->ref_count);
 				}
 				req->outstanding_cmds[cnt] = NULL;
 				sp->done(sp, res);
@@ -2623,10 +2635,10 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	if (mem_only) {
 		if (pci_enable_device_mem(pdev))
-			goto probe_out;
+			return ret;
 	} else {
 		if (pci_enable_device(pdev))
-			goto probe_out;
+			return ret;
 	}
 
 	/* This may fail but that's ok */
@@ -2636,7 +2648,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!ha) {
 		ql_log_pci(ql_log_fatal, pdev, 0x0009,
 		    "Unable to allocate memory for ha.\n");
-		goto probe_out;
+		goto disable_device;
 	}
 	ql_dbg_pci(ql_dbg_init, pdev, 0x000a,
 	    "Memory allocated for ha=%p.\n", ha);
@@ -3254,7 +3266,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_release_selected_regions(ha->pdev, ha->bars);
 	kfree(ha);
 
-probe_out:
+disable_device:
 	pci_disable_device(pdev);
 	return ret;
 }
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 0e03ca2ab3e5..e766d8412384 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2245,11 +2245,13 @@ static void qlt_unmap_sg(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd)
 		pci_unmap_sg(ha->pdev, cmd->prot_sg, cmd->prot_sg_cnt,
 			cmd->dma_data_direction);
 
+	if (!cmd->ctx)
+		return;
+
 	if (cmd->ctx_dsd_alloced)
-		qla2x00_clean_dsd_pool(ha, NULL, cmd);
+		qla2x00_clean_dsd_pool(ha, cmd->ctx);
 
-	if (cmd->ctx)
-		dma_pool_free(ha->dl_dma_pool, cmd->ctx, cmd->ctx->crc_ctx_dma);
+	dma_pool_free(ha->dl_dma_pool, cmd->ctx, cmd->ctx->crc_ctx_dma);
 }
 
 static int qlt_check_reserve_free_req(struct scsi_qla_host *vha,
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 8a58ef3adab4..c197972a3e2d 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -371,7 +371,7 @@ qla27xx_fwdt_entry_t262(struct scsi_qla_host *vha,
 		goto done;
 	}
 
-	if (end <= start || start == 0 || end == 0) {
+	if (end < start || start == 0 || end == 0) {
 		ql_dbg(ql_dbg_misc, vha, 0xd023,
 		    "%s: unusable range (start=%x end=%x)\n", __func__,
 		    ent->t262.end_addr, ent->t262.start_addr);
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 17249c3650fe..dc095a292c61 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1404,7 +1404,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	arr[4] = SDEBUG_LONG_INQ_SZ - 5;
 	arr[5] = (int)have_dif_prot;	/* PROTECT bit */
 	if (sdebug_vpd_use_hostno == 0)
-		arr[5] = 0x10; /* claim: implicit TGPS */
+		arr[5] |= 0x10; /* claim: implicit TPGS */
 	arr[6] = 0x10; /* claim: MultiP */
 	/* arr[6] |= 0x40; ... claim: EncServ (enclosure services) */
 	arr[7] = 0xa; /* claim: LINKED + CMDQUE */
