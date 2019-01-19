From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.0-rc2
Date: Fri, 18 Jan 2019 17:25:17 -0800
Message-ID: <1547861117.32514.3.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

A set of 17 fixes.  Most of these are minor or trivial.  The one fix
that may be serious is the isci one: the bug can cause hba parameters
to be set from uninitialized memory.  I don't think it's exploitable,
but you never know.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Avri Altman (1):
      scsi: ufs: Fix geometry descriptor size

Gustavo A. R. Silva (2):
      scsi: lpfc: lpfc_sli: Mark expected switch fall-throughs
      scsi: smartpqi_init: fix boolean expression in pqi_device_remove_start

Ivan Mironov (1):
      scsi: sd: Fix cache_type_store()

John Garry (1):
      scsi: hisi_sas: Set protection parameters prior to adding SCSI host

Julia Lawall (1):
      scsi: pm80xx: reduce indentation

Leo Zhang (1):
      scsi: target/iscsi: fix error msg typo when create lio_qr_cache failed

Logan Gunthorpe (1):
      scsi: isci: initialize shost fully before calling scsi_add_host()

Manish Rangankar (1):
      scsi: qedi: Add ep_state for login completion on un-reachable targets

Ming Lei (1):
      scsi: qla2xxx: Use correct number of vectors for online CPUs

Shivasharan S (1):
      scsi: megaraid_sas: Retry reads of outbound_intr_status reg

Stanley Chu (2):
      scsi: ufs: Fix system suspend status
      scsi: core: Synchronize request queue PM status only on successful resume

Thomas Bogendoerfer (1):
      scsi: qla1280: set 64bit coherent mask

Tomas Henzl (1):
      scsi: megaraid_sas: correct an info message

Varun Prakash (1):
      scsi: cxgb4i: add wait_for_completion()

Xiubo Li (1):
      scsi: tcmu: avoid cmd/qfull timers updated whenever a new cmd comes

YueHaibing (1):
      scsi: qla4xxx: check return code of qla4xxx_copy_from_fwddb_param

And the diffstat:

 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c          |  9 ++-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c          | 28 ++++++---
 drivers/scsi/cxgbi/libcxgbi.c               |  7 ++-
 drivers/scsi/cxgbi/libcxgbi.h               |  5 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c      | 12 ++--
 drivers/scsi/isci/init.c                    | 14 ++---
 drivers/scsi/lpfc/lpfc_sli.c                | 20 ++++---
 drivers/scsi/megaraid/megaraid_sas_base.c   |  2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  3 +-
 drivers/scsi/pm8001/pm8001_sas.c            |  2 +-
 drivers/scsi/qedi/qedi_iscsi.c              |  3 +
 drivers/scsi/qedi/qedi_iscsi.h              |  1 +
 drivers/scsi/qla1280.c                      |  2 +-
 drivers/scsi/qla2xxx/qla_def.h              |  2 +
 drivers/scsi/qla2xxx/qla_isr.c              |  1 +
 drivers/scsi/qla2xxx/qla_os.c               |  2 +-
 drivers/scsi/qla4xxx/ql4_os.c               |  2 +
 drivers/scsi/scsi_pm.c                      | 26 +++++----
 drivers/scsi/sd.c                           |  6 ++
 drivers/scsi/smartpqi/smartpqi_init.c       |  2 +-
 drivers/scsi/ufs/ufs.h                      |  2 +-
 drivers/scsi/ufs/ufshcd.c                   |  2 +
 drivers/target/iscsi/iscsi_target.c         |  2 +-
 drivers/target/target_core_user.c           | 88 ++++++++++++++++++++---------
 24 files changed, 157 insertions(+), 86 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 8a20411699d9..75e1273a44b3 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -1144,7 +1144,7 @@ static void ddp_clear_map(struct cxgbi_device *cdev, struct cxgbi_ppm *ppm,
 }
 
 static int ddp_setup_conn_pgidx(struct cxgbi_sock *csk,
-				       unsigned int tid, int pg_idx, bool reply)
+				unsigned int tid, int pg_idx)
 {
 	struct sk_buff *skb = alloc_wr(sizeof(struct cpl_set_tcb_field), 0,
 					GFP_KERNEL);
@@ -1160,7 +1160,7 @@ static int ddp_setup_conn_pgidx(struct cxgbi_sock *csk,
 	req = (struct cpl_set_tcb_field *)skb->head;
 	req->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_FORWARD));
 	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_SET_TCB_FIELD, tid));
-	req->reply = V_NO_REPLY(reply ? 0 : 1);
+	req->reply = V_NO_REPLY(1);
 	req->cpu_idx = 0;
 	req->word = htons(31);
 	req->mask = cpu_to_be64(0xF0000000);
@@ -1177,11 +1177,10 @@ static int ddp_setup_conn_pgidx(struct cxgbi_sock *csk,
  * @tid: connection id
  * @hcrc: header digest enabled
  * @dcrc: data digest enabled
- * @reply: request reply from h/w
  * set up the iscsi digest settings for a connection identified by tid
  */
 static int ddp_setup_conn_digest(struct cxgbi_sock *csk, unsigned int tid,
-			     int hcrc, int dcrc, int reply)
+				 int hcrc, int dcrc)
 {
 	struct sk_buff *skb = alloc_wr(sizeof(struct cpl_set_tcb_field), 0,
 					GFP_KERNEL);
@@ -1197,7 +1196,7 @@ static int ddp_setup_conn_digest(struct cxgbi_sock *csk, unsigned int tid,
 	req = (struct cpl_set_tcb_field *)skb->head;
 	req->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_FORWARD));
 	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_SET_TCB_FIELD, tid));
-	req->reply = V_NO_REPLY(reply ? 0 : 1);
+	req->reply = V_NO_REPLY(1);
 	req->cpu_idx = 0;
 	req->word = htons(31);
 	req->mask = cpu_to_be64(0x0F000000);
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 49f8028ac524..d26f50af00ea 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -1548,16 +1548,22 @@ static void do_set_tcb_rpl(struct cxgbi_device *cdev, struct sk_buff *skb)
 	struct cxgbi_sock *csk;
 
 	csk = lookup_tid(t, tid);
-	if (!csk)
+	if (!csk) {
 		pr_err("can't find conn. for tid %u.\n", tid);
+		return;
+	}
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
 		"csk 0x%p,%u,%lx,%u, status 0x%x.\n",
 		csk, csk->state, csk->flags, csk->tid, rpl->status);
 
-	if (rpl->status != CPL_ERR_NONE)
+	if (rpl->status != CPL_ERR_NONE) {
 		pr_err("csk 0x%p,%u, SET_TCB_RPL status %u.\n",
 			csk, tid, rpl->status);
+		csk->err = -EINVAL;
+	}
+
+	complete(&csk->cmpl);
 
 	__kfree_skb(skb);
 }
@@ -1983,7 +1989,7 @@ static int ddp_set_map(struct cxgbi_ppm *ppm, struct cxgbi_sock *csk,
 }
 
 static int ddp_setup_conn_pgidx(struct cxgbi_sock *csk, unsigned int tid,
-				int pg_idx, bool reply)
+				int pg_idx)
 {
 	struct sk_buff *skb;
 	struct cpl_set_tcb_field *req;
@@ -1999,7 +2005,7 @@ static int ddp_setup_conn_pgidx(struct cxgbi_sock *csk, unsigned int tid,
 	req = (struct cpl_set_tcb_field *)skb->head;
 	INIT_TP_WR(req, csk->tid);
 	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_SET_TCB_FIELD, csk->tid));
-	req->reply_ctrl = htons(NO_REPLY_V(reply) | QUEUENO_V(csk->rss_qid));
+	req->reply_ctrl = htons(NO_REPLY_V(0) | QUEUENO_V(csk->rss_qid));
 	req->word_cookie = htons(0);
 	req->mask = cpu_to_be64(0x3 << 8);
 	req->val = cpu_to_be64(pg_idx << 8);
@@ -2008,12 +2014,15 @@ static int ddp_setup_conn_pgidx(struct cxgbi_sock *csk, unsigned int tid,
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
 		"csk 0x%p, tid 0x%x, pg_idx %u.\n", csk, csk->tid, pg_idx);
 
+	reinit_completion(&csk->cmpl);
 	cxgb4_ofld_send(csk->cdev->ports[csk->port_id], skb);
-	return 0;
+	wait_for_completion(&csk->cmpl);
+
+	return csk->err;
 }
 
 static int ddp_setup_conn_digest(struct cxgbi_sock *csk, unsigned int tid,
-				 int hcrc, int dcrc, int reply)
+				 int hcrc, int dcrc)
 {
 	struct sk_buff *skb;
 	struct cpl_set_tcb_field *req;
@@ -2031,7 +2040,7 @@ static int ddp_setup_conn_digest(struct cxgbi_sock *csk, unsigned int tid,
 	req = (struct cpl_set_tcb_field *)skb->head;
 	INIT_TP_WR(req, tid);
 	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_SET_TCB_FIELD, tid));
-	req->reply_ctrl = htons(NO_REPLY_V(reply) | QUEUENO_V(csk->rss_qid));
+	req->reply_ctrl = htons(NO_REPLY_V(0) | QUEUENO_V(csk->rss_qid));
 	req->word_cookie = htons(0);
 	req->mask = cpu_to_be64(0x3 << 4);
 	req->val = cpu_to_be64(((hcrc ? ULP_CRC_HEADER : 0) |
@@ -2041,8 +2050,11 @@ static int ddp_setup_conn_digest(struct cxgbi_sock *csk, unsigned int tid,
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
 		"csk 0x%p, tid 0x%x, crc %d,%d.\n", csk, csk->tid, hcrc, dcrc);
 
+	reinit_completion(&csk->cmpl);
 	cxgb4_ofld_send(csk->cdev->ports[csk->port_id], skb);
-	return 0;
+	wait_for_completion(&csk->cmpl);
+
+	return csk->err;
 }
 
 static struct cxgbi_ppm *cdev2ppm(struct cxgbi_device *cdev)
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 75f876409fb9..245742557c03 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -573,6 +573,7 @@ static struct cxgbi_sock *cxgbi_sock_create(struct cxgbi_device *cdev)
 	skb_queue_head_init(&csk->receive_queue);
 	skb_queue_head_init(&csk->write_queue);
 	timer_setup(&csk->retry_timer, NULL, 0);
+	init_completion(&csk->cmpl);
 	rwlock_init(&csk->callback_lock);
 	csk->cdev = cdev;
 	csk->flags = 0;
@@ -2251,14 +2252,14 @@ int cxgbi_set_conn_param(struct iscsi_cls_conn *cls_conn,
 		if (!err && conn->hdrdgst_en)
 			err = csk->cdev->csk_ddp_setup_digest(csk, csk->tid,
 							conn->hdrdgst_en,
-							conn->datadgst_en, 0);
+							conn->datadgst_en);
 		break;
 	case ISCSI_PARAM_DATADGST_EN:
 		err = iscsi_set_param(cls_conn, param, buf, buflen);
 		if (!err && conn->datadgst_en)
 			err = csk->cdev->csk_ddp_setup_digest(csk, csk->tid,
 							conn->hdrdgst_en,
-							conn->datadgst_en, 0);
+							conn->datadgst_en);
 		break;
 	case ISCSI_PARAM_MAX_R2T:
 		return iscsi_tcp_set_max_r2t(conn, buf);
@@ -2384,7 +2385,7 @@ int cxgbi_bind_conn(struct iscsi_cls_session *cls_session,
 
 	ppm = csk->cdev->cdev2ppm(csk->cdev);
 	err = csk->cdev->csk_ddp_setup_pgidx(csk, csk->tid,
-					     ppm->tformat.pgsz_idx_dflt, 0);
+					     ppm->tformat.pgsz_idx_dflt);
 	if (err < 0)
 		return err;
 
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index 5d5d8b50d842..1917ff57651d 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -149,6 +149,7 @@ struct cxgbi_sock {
 	struct sk_buff_head receive_queue;
 	struct sk_buff_head write_queue;
 	struct timer_list retry_timer;
+	struct completion cmpl;
 	int err;
 	rwlock_t callback_lock;
 	void *user_data;
@@ -490,9 +491,9 @@ struct cxgbi_device {
 				  struct cxgbi_ppm *,
 				  struct cxgbi_task_tag_info *);
 	int (*csk_ddp_setup_digest)(struct cxgbi_sock *,
-				unsigned int, int, int, int);
+				    unsigned int, int, int);
 	int (*csk_ddp_setup_pgidx)(struct cxgbi_sock *,
-				unsigned int, int, bool);
+				   unsigned int, int);
 
 	void (*csk_release_offload_resources)(struct cxgbi_sock *);
 	int (*csk_rx_pdu_ready)(struct cxgbi_sock *, struct sk_buff *);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index e2420a810e99..c92b3822c408 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2507,6 +2507,12 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		sha->sas_port[i] = &hisi_hba->port[i].sas_port;
 	}
 
+	if (hisi_hba->prot_mask) {
+		dev_info(dev, "Registering for DIF/DIX prot_mask=0x%x\n",
+			 prot_mask);
+		scsi_host_set_prot(hisi_hba->shost, prot_mask);
+	}
+
 	rc = scsi_add_host(shost, dev);
 	if (rc)
 		goto err_out_ha;
@@ -2519,12 +2525,6 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (rc)
 		goto err_out_register_ha;
 
-	if (hisi_hba->prot_mask) {
-		dev_info(dev, "Registering for DIF/DIX prot_mask=0x%x\n",
-			 prot_mask);
-		scsi_host_set_prot(hisi_hba->shost, prot_mask);
-	}
-
 	scsi_scan_host(shost);
 
 	return 0;
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 68b90c4f79a3..1727d0c71b12 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -576,6 +576,13 @@ static struct isci_host *isci_host_alloc(struct pci_dev *pdev, int id)
 	shost->max_lun = ~0;
 	shost->max_cmd_len = MAX_COMMAND_SIZE;
 
+	/* turn on DIF support */
+	scsi_host_set_prot(shost,
+			   SHOST_DIF_TYPE1_PROTECTION |
+			   SHOST_DIF_TYPE2_PROTECTION |
+			   SHOST_DIF_TYPE3_PROTECTION);
+	scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
+
 	err = scsi_add_host(shost, &pdev->dev);
 	if (err)
 		goto err_shost;
@@ -663,13 +670,6 @@ static int isci_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			goto err_host_alloc;
 		}
 		pci_info->hosts[i] = h;
-
-		/* turn on DIF support */
-		scsi_host_set_prot(to_shost(h),
-				   SHOST_DIF_TYPE1_PROTECTION |
-				   SHOST_DIF_TYPE2_PROTECTION |
-				   SHOST_DIF_TYPE3_PROTECTION);
-		scsi_host_set_guard(to_shost(h), SHOST_DIX_GUARD_CRC);
 	}
 
 	err = isci_setup_interrupts(pdev);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 30734caf77e1..3ac5cc1a0cd9 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -9408,6 +9408,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		cmnd = CMD_XMIT_SEQUENCE64_CR;
 		if (phba->link_flag & LS_LOOPBACK_MODE)
 			bf_set(wqe_xo, &wqe->xmit_sequence.wge_ctl, 1);
+		/* fall through */
 	case CMD_XMIT_SEQUENCE64_CR:
 		/* word3 iocb=io_tag32 wqe=reserved */
 		wqe->xmit_sequence.rsvd3 = 0;
@@ -13529,6 +13530,7 @@ lpfc_sli4_sp_handle_rcqe(struct lpfc_hba *phba, struct lpfc_rcqe *rcqe)
 	case FC_STATUS_RQ_BUF_LEN_EXCEEDED:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"2537 Receive Frame Truncated!!\n");
+		/* fall through */
 	case FC_STATUS_RQ_SUCCESS:
 		spin_lock_irqsave(&phba->hbalock, iflags);
 		lpfc_sli4_rq_release(hrq, drq);
@@ -13938,7 +13940,7 @@ lpfc_sli4_nvmet_handle_rcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	case FC_STATUS_RQ_BUF_LEN_EXCEEDED:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"6126 Receive Frame Truncated!!\n");
-		/* Drop thru */
+		/* fall through */
 	case FC_STATUS_RQ_SUCCESS:
 		spin_lock_irqsave(&phba->hbalock, iflags);
 		lpfc_sli4_rq_release(hrq, drq);
@@ -14850,7 +14852,7 @@ lpfc_eq_create(struct lpfc_hba *phba, struct lpfc_queue *eq, uint32_t imax)
 				eq->entry_count);
 		if (eq->entry_count < 256)
 			return -EINVAL;
-		/* otherwise default to smallest count (drop through) */
+		/* fall through - otherwise default to smallest count */
 	case 256:
 		bf_set(lpfc_eq_context_count, &eq_create->u.request.context,
 		       LPFC_EQ_CNT_256);
@@ -14981,7 +14983,7 @@ lpfc_cq_create(struct lpfc_hba *phba, struct lpfc_queue *cq,
 			       LPFC_CQ_CNT_WORD7);
 			break;
 		}
-		/* Fall Thru */
+		/* fall through */
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"0361 Unsupported CQ count: "
@@ -14992,7 +14994,7 @@ lpfc_cq_create(struct lpfc_hba *phba, struct lpfc_queue *cq,
 			status = -EINVAL;
 			goto out;
 		}
-		/* otherwise default to smallest count (drop through) */
+		/* fall through - otherwise default to smallest count */
 	case 256:
 		bf_set(lpfc_cq_context_count, &cq_create->u.request.context,
 		       LPFC_CQ_CNT_256);
@@ -15152,7 +15154,7 @@ lpfc_cq_create_set(struct lpfc_hba *phba, struct lpfc_queue **cqp,
 					       LPFC_CQ_CNT_WORD7);
 					break;
 				}
-				/* Fall Thru */
+				/* fall through */
 			default:
 				lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 						"3118 Bad CQ count. (%d)\n",
@@ -15161,7 +15163,7 @@ lpfc_cq_create_set(struct lpfc_hba *phba, struct lpfc_queue **cqp,
 					status = -EINVAL;
 					goto out;
 				}
-				/* otherwise default to smallest (drop thru) */
+				/* fall through - otherwise default to smallest */
 			case 256:
 				bf_set(lpfc_mbx_cq_create_set_cqe_cnt,
 				       &cq_set->u.request, LPFC_CQ_CNT_256);
@@ -15433,7 +15435,7 @@ lpfc_mq_create(struct lpfc_hba *phba, struct lpfc_queue *mq,
 			status = -EINVAL;
 			goto out;
 		}
-		/* otherwise default to smallest count (drop through) */
+		/* fall through - otherwise default to smallest count */
 	case 16:
 		bf_set(lpfc_mq_context_ring_size,
 		       &mq_create_ext->u.request.context,
@@ -15852,7 +15854,7 @@ lpfc_rq_create(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 				status = -EINVAL;
 				goto out;
 			}
-			/* otherwise default to smallest count (drop through) */
+			/* fall through - otherwise default to smallest count */
 		case 512:
 			bf_set(lpfc_rq_context_rqe_count,
 			       &rq_create->u.request.context,
@@ -15989,7 +15991,7 @@ lpfc_rq_create(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 				status = -EINVAL;
 				goto out;
 			}
-			/* otherwise default to smallest count (drop through) */
+			/* fall through - otherwise default to smallest count */
 		case 512:
 			bf_set(lpfc_rq_context_rqe_count,
 			       &rq_create->u.request.context,
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index f7bdd783360a..a6b1824cc08a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6236,7 +6236,7 @@ megasas_set_dma_mask(struct megasas_instance *instance)
 		instance->consistent_mask_64bit = true;
 
 	dev_info(&pdev->dev, "%s bit DMA mask and %s bit consistent mask\n",
-		 ((*pdev->dev.dma_mask == DMA_BIT_MASK(64)) ? "63" : "32"),
+		 ((*pdev->dev.dma_mask == DMA_BIT_MASK(63)) ? "63" : "32"),
 		 (instance->consistent_mask_64bit ? "63" : "32"));
 
 	return 0;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 211c17c33aa0..2665dbdcf2f8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -175,7 +175,8 @@ megasas_clear_intr_fusion(struct megasas_instance *instance)
 	/*
 	 * Check if it is our interrupt
 	 */
-	status = readl(&regs->outbound_intr_status);
+	status = megasas_readl(instance,
+			       &regs->outbound_intr_status);
 
 	if (status & 1) {
 		writel(status, &regs->outbound_intr_status);
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index b3be49d41375..1343bd89c25c 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -657,7 +657,7 @@ static int pm8001_dev_found_notify(struct domain_device *dev)
 		if (dev->dev_type == SAS_SATA_DEV) {
 			pm8001_device->attached_phy =
 				dev->rphy->identify.phy_identifier;
-				flag = 1; /* directly sata*/
+			flag = 1; /* directly sata */
 		}
 	} /*register this device to HBA*/
 	PM8001_DISC_DBG(pm8001_ha, pm8001_printk("Found device\n"));
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 4da660c1c431..6d6d6013e35b 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -953,6 +953,7 @@ static int qedi_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
 
 	qedi_ep = ep->dd_data;
 	if (qedi_ep->state == EP_STATE_IDLE ||
+	    qedi_ep->state == EP_STATE_OFLDCONN_NONE ||
 	    qedi_ep->state == EP_STATE_OFLDCONN_FAILED)
 		return -1;
 
@@ -1035,6 +1036,7 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 
 	switch (qedi_ep->state) {
 	case EP_STATE_OFLDCONN_START:
+	case EP_STATE_OFLDCONN_NONE:
 		goto ep_release_conn;
 	case EP_STATE_OFLDCONN_FAILED:
 			break;
@@ -1225,6 +1227,7 @@ static int qedi_set_path(struct Scsi_Host *shost, struct iscsi_path *path_data)
 
 	if (!is_valid_ether_addr(&path_data->mac_addr[0])) {
 		QEDI_NOTICE(&qedi->dbg_ctx, "dst mac NOT VALID\n");
+		qedi_ep->state = EP_STATE_OFLDCONN_NONE;
 		ret = -EIO;
 		goto set_path_exit;
 	}
diff --git a/drivers/scsi/qedi/qedi_iscsi.h b/drivers/scsi/qedi/qedi_iscsi.h
index 11260776212f..892d70d54553 100644
--- a/drivers/scsi/qedi/qedi_iscsi.h
+++ b/drivers/scsi/qedi/qedi_iscsi.h
@@ -59,6 +59,7 @@ enum {
 	EP_STATE_OFLDCONN_FAILED        = 0x2000,
 	EP_STATE_CONNECT_FAILED         = 0x4000,
 	EP_STATE_DISCONN_TIMEDOUT       = 0x8000,
+	EP_STATE_OFLDCONN_NONE          = 0x10000,
 };
 
 struct qedi_conn;
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index a414f51302b7..6856dfdfa473 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -4248,7 +4248,7 @@ qla1280_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	ha->devnum = devnum;	/* specifies microcode load address */
 
 #ifdef QLA_64BIT_PTR
-	if (dma_set_mask(&ha->pdev->dev, DMA_BIT_MASK(64))) {
+	if (dma_set_mask_and_coherent(&ha->pdev->dev, DMA_BIT_MASK(64))) {
 		if (dma_set_mask(&ha->pdev->dev, DMA_BIT_MASK(32))) {
 			printk(KERN_WARNING "scsi(%li): Unable to set a "
 			       "suitable DMA mask - aborting\n", ha->host_no);
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 26b93c563f92..d1fc4958222a 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4394,6 +4394,8 @@ typedef struct scsi_qla_host {
 	uint16_t	n2n_id;
 	struct list_head gpnid_list;
 	struct fab_scan scan;
+
+	unsigned int irq_offset;
 } scsi_qla_host_t;
 
 struct qla27xx_image_status {
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 30d3090842f8..8507c43b918c 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3446,6 +3446,7 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 			    "Adjusted Max no of queues pairs: %d.\n", ha->max_qpairs);
 		}
 	}
+	vha->irq_offset = desc.pre_vectors;
 	ha->msix_entries = kcalloc(ha->msix_count,
 				   sizeof(struct qla_msix_entry),
 				   GFP_KERNEL);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ea69dafc9774..c6ef83d0d99b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6939,7 +6939,7 @@ static int qla2xxx_map_queues(struct Scsi_Host *shost)
 	if (USER_CTRL_IRQ(vha->hw))
 		rc = blk_mq_map_queues(qmap);
 	else
-		rc = blk_mq_pci_map_queues(qmap, vha->hw->pdev, 0);
+		rc = blk_mq_pci_map_queues(qmap, vha->hw->pdev, vha->irq_offset);
 	return rc;
 }
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 949e186cc5d7..1bc4db6e6d16 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -7232,6 +7232,8 @@ static int qla4xxx_sysfs_ddb_tgt_create(struct scsi_qla_host *ha,
 
 	rc = qla4xxx_copy_from_fwddb_param(fnode_sess, fnode_conn,
 					   fw_ddb_entry);
+	if (rc)
+		goto free_sess;
 
 	ql4_printk(KERN_INFO, ha, "%s: sysfs entry %s created\n",
 		   __func__, fnode_sess->dev.kobj.name);
diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index a2b4179bfdf7..7639df91b110 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -80,8 +80,22 @@ static int scsi_dev_type_resume(struct device *dev,
 
 	if (err == 0) {
 		pm_runtime_disable(dev);
-		pm_runtime_set_active(dev);
+		err = pm_runtime_set_active(dev);
 		pm_runtime_enable(dev);
+
+		/*
+		 * Forcibly set runtime PM status of request queue to "active"
+		 * to make sure we can again get requests from the queue
+		 * (see also blk_pm_peek_request()).
+		 *
+		 * The resume hook will correct runtime PM status of the disk.
+		 */
+		if (!err && scsi_is_sdev_device(dev)) {
+			struct scsi_device *sdev = to_scsi_device(dev);
+
+			if (sdev->request_queue->dev)
+				blk_set_runtime_active(sdev->request_queue);
+		}
 	}
 
 	return err;
@@ -140,16 +154,6 @@ static int scsi_bus_resume_common(struct device *dev,
 	else
 		fn = NULL;
 
-	/*
-	 * Forcibly set runtime PM status of request queue to "active" to
-	 * make sure we can again get requests from the queue (see also
-	 * blk_pm_peek_request()).
-	 *
-	 * The resume hook will correct runtime PM status of the disk.
-	 */
-	if (scsi_is_sdev_device(dev) && pm_runtime_suspended(dev))
-		blk_set_runtime_active(to_scsi_device(dev)->request_queue);
-
 	if (fn) {
 		async_schedule_domain(fn, dev, &scsi_sd_pm_domain);
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a1a44f52e0e8..b2da8a00ec33 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -206,6 +206,12 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	sp = buffer_data[0] & 0x80 ? 1 : 0;
 	buffer_data[0] &= ~0x80;
 
+	/*
+	 * Ensure WP, DPOFUA, and RESERVED fields are cleared in
+	 * received mode parameter buffer before doing MODE SELECT.
+	 */
+	data.device_specific = 0;
+
 	if (scsi_mode_select(sdp, 1, sp, 8, buffer_data, len, SD_TIMEOUT,
 			     SD_MAX_RETRIES, &data, &sshdr)) {
 		if (scsi_sense_valid(&sshdr))
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index e2fa3f476227..40f58238ce4a 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -323,7 +323,7 @@ static inline void pqi_device_remove_start(struct pqi_scsi_dev *device)
 static inline bool pqi_device_in_remove(struct pqi_ctrl_info *ctrl_info,
 					struct pqi_scsi_dev *device)
 {
-	return device->in_remove & !ctrl_info->in_shutdown;
+	return device->in_remove && !ctrl_info->in_shutdown;
 }
 
 static inline void pqi_schedule_rescan_worker_with_delay(
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index dd65fea07687..6d176815e6ce 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -195,7 +195,7 @@ enum ufs_desc_def_size {
 	QUERY_DESC_CONFIGURATION_DEF_SIZE	= 0x90,
 	QUERY_DESC_UNIT_DEF_SIZE		= 0x23,
 	QUERY_DESC_INTERCONNECT_DEF_SIZE	= 0x06,
-	QUERY_DESC_GEOMETRY_DEF_SIZE		= 0x44,
+	QUERY_DESC_GEOMETRY_DEF_SIZE		= 0x48,
 	QUERY_DESC_POWER_DEF_SIZE		= 0x62,
 	QUERY_DESC_HEALTH_DEF_SIZE		= 0x25,
 };
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9ba7671b84f8..71334aaf1447 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8001,6 +8001,8 @@ int ufshcd_system_resume(struct ufs_hba *hba)
 	trace_ufshcd_system_resume(dev_name(hba->dev), ret,
 		ktime_to_us(ktime_sub(ktime_get(), start)),
 		hba->curr_dev_pwr_mode, hba->uic_link_state);
+	if (!ret)
+		hba->is_sys_suspended = false;
 	return ret;
 }
 EXPORT_SYMBOL(ufshcd_system_resume);
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 984941e036c8..bd15a564fe24 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -714,7 +714,7 @@ static int __init iscsi_target_init_module(void)
 			sizeof(struct iscsi_queue_req),
 			__alignof__(struct iscsi_queue_req), 0, NULL);
 	if (!lio_qr_cache) {
-		pr_err("nable to kmem_cache_create() for"
+		pr_err("Unable to kmem_cache_create() for"
 				" lio_qr_cache\n");
 		goto bitmap_out;
 	}
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 1e6d24943565..c34c88ef3319 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -148,7 +148,7 @@ struct tcmu_dev {
 	size_t ring_size;
 
 	struct mutex cmdr_lock;
-	struct list_head cmdr_queue;
+	struct list_head qfull_queue;
 
 	uint32_t dbi_max;
 	uint32_t dbi_thresh;
@@ -159,6 +159,7 @@ struct tcmu_dev {
 
 	struct timer_list cmd_timer;
 	unsigned int cmd_time_out;
+	struct list_head inflight_queue;
 
 	struct timer_list qfull_timer;
 	int qfull_time_out;
@@ -179,7 +180,7 @@ struct tcmu_dev {
 struct tcmu_cmd {
 	struct se_cmd *se_cmd;
 	struct tcmu_dev *tcmu_dev;
-	struct list_head cmdr_queue_entry;
+	struct list_head queue_entry;
 
 	uint16_t cmd_id;
 
@@ -192,6 +193,7 @@ struct tcmu_cmd {
 	unsigned long deadline;
 
 #define TCMU_CMD_BIT_EXPIRED 0
+#define TCMU_CMD_BIT_INFLIGHT 1
 	unsigned long flags;
 };
 /*
@@ -586,7 +588,7 @@ static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
 	if (!tcmu_cmd)
 		return NULL;
 
-	INIT_LIST_HEAD(&tcmu_cmd->cmdr_queue_entry);
+	INIT_LIST_HEAD(&tcmu_cmd->queue_entry);
 	tcmu_cmd->se_cmd = se_cmd;
 	tcmu_cmd->tcmu_dev = udev;
 
@@ -915,11 +917,13 @@ static int tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd, unsigned int tmo,
 		return 0;
 
 	tcmu_cmd->deadline = round_jiffies_up(jiffies + msecs_to_jiffies(tmo));
-	mod_timer(timer, tcmu_cmd->deadline);
+	if (!timer_pending(timer))
+		mod_timer(timer, tcmu_cmd->deadline);
+
 	return 0;
 }
 
-static int add_to_cmdr_queue(struct tcmu_cmd *tcmu_cmd)
+static int add_to_qfull_queue(struct tcmu_cmd *tcmu_cmd)
 {
 	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
 	unsigned int tmo;
@@ -942,7 +946,7 @@ static int add_to_cmdr_queue(struct tcmu_cmd *tcmu_cmd)
 	if (ret)
 		return ret;
 
-	list_add_tail(&tcmu_cmd->cmdr_queue_entry, &udev->cmdr_queue);
+	list_add_tail(&tcmu_cmd->queue_entry, &udev->qfull_queue);
 	pr_debug("adding cmd %u on dev %s to ring space wait queue\n",
 		 tcmu_cmd->cmd_id, udev->name);
 	return 0;
@@ -999,7 +1003,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	base_command_size = tcmu_cmd_get_base_cmd_size(tcmu_cmd->dbi_cnt);
 	command_size = tcmu_cmd_get_cmd_size(tcmu_cmd, base_command_size);
 
-	if (!list_empty(&udev->cmdr_queue))
+	if (!list_empty(&udev->qfull_queue))
 		goto queue;
 
 	mb = udev->mb_addr;
@@ -1096,13 +1100,16 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	UPDATE_HEAD(mb->cmd_head, command_size, udev->cmdr_size);
 	tcmu_flush_dcache_range(mb, sizeof(*mb));
 
+	list_add_tail(&tcmu_cmd->queue_entry, &udev->inflight_queue);
+	set_bit(TCMU_CMD_BIT_INFLIGHT, &tcmu_cmd->flags);
+
 	/* TODO: only if FLUSH and FUA? */
 	uio_event_notify(&udev->uio_info);
 
 	return 0;
 
 queue:
-	if (add_to_cmdr_queue(tcmu_cmd)) {
+	if (add_to_qfull_queue(tcmu_cmd)) {
 		*scsi_err = TCM_OUT_OF_RESOURCES;
 		return -1;
 	}
@@ -1145,6 +1152,8 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags))
 		goto out;
 
+	list_del_init(&cmd->queue_entry);
+
 	tcmu_cmd_reset_dbi_cur(cmd);
 
 	if (entry->hdr.uflags & TCMU_UFLAG_UNKNOWN_OP) {
@@ -1194,9 +1203,29 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 	tcmu_free_cmd(cmd);
 }
 
+static void tcmu_set_next_deadline(struct list_head *queue,
+				   struct timer_list *timer)
+{
+	struct tcmu_cmd *tcmu_cmd, *tmp_cmd;
+	unsigned long deadline = 0;
+
+	list_for_each_entry_safe(tcmu_cmd, tmp_cmd, queue, queue_entry) {
+		if (!time_after(jiffies, tcmu_cmd->deadline)) {
+			deadline = tcmu_cmd->deadline;
+			break;
+		}
+	}
+
+	if (deadline)
+		mod_timer(timer, deadline);
+	else
+		del_timer(timer);
+}
+
 static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 {
 	struct tcmu_mailbox *mb;
+	struct tcmu_cmd *cmd;
 	int handled = 0;
 
 	if (test_bit(TCMU_DEV_BIT_BROKEN, &udev->flags)) {
@@ -1210,7 +1239,6 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 	while (udev->cmdr_last_cleaned != READ_ONCE(mb->cmd_tail)) {
 
 		struct tcmu_cmd_entry *entry = (void *) mb + CMDR_OFF + udev->cmdr_last_cleaned;
-		struct tcmu_cmd *cmd;
 
 		tcmu_flush_dcache_range(entry, sizeof(*entry));
 
@@ -1243,7 +1271,7 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 		/* no more pending commands */
 		del_timer(&udev->cmd_timer);
 
-		if (list_empty(&udev->cmdr_queue)) {
+		if (list_empty(&udev->qfull_queue)) {
 			/*
 			 * no more pending or waiting commands so try to
 			 * reclaim blocks if needed.
@@ -1252,6 +1280,8 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 			    tcmu_global_max_blocks)
 				schedule_delayed_work(&tcmu_unmap_work, 0);
 		}
+	} else if (udev->cmd_time_out) {
+		tcmu_set_next_deadline(&udev->inflight_queue, &udev->cmd_timer);
 	}
 
 	return handled;
@@ -1271,7 +1301,7 @@ static int tcmu_check_expired_cmd(int id, void *p, void *data)
 	if (!time_after(jiffies, cmd->deadline))
 		return 0;
 
-	is_running = list_empty(&cmd->cmdr_queue_entry);
+	is_running = test_bit(TCMU_CMD_BIT_INFLIGHT, &cmd->flags);
 	se_cmd = cmd->se_cmd;
 
 	if (is_running) {
@@ -1288,12 +1318,11 @@ static int tcmu_check_expired_cmd(int id, void *p, void *data)
 		 */
 		scsi_status = SAM_STAT_CHECK_CONDITION;
 	} else {
-		list_del_init(&cmd->cmdr_queue_entry);
-
 		idr_remove(&udev->commands, id);
 		tcmu_free_cmd(cmd);
 		scsi_status = SAM_STAT_TASK_SET_FULL;
 	}
+	list_del_init(&cmd->queue_entry);
 
 	pr_debug("Timing out cmd %u on dev %s that is %s.\n",
 		 id, udev->name, is_running ? "inflight" : "queued");
@@ -1372,7 +1401,8 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 
 	INIT_LIST_HEAD(&udev->node);
 	INIT_LIST_HEAD(&udev->timedout_entry);
-	INIT_LIST_HEAD(&udev->cmdr_queue);
+	INIT_LIST_HEAD(&udev->qfull_queue);
+	INIT_LIST_HEAD(&udev->inflight_queue);
 	idr_init(&udev->commands);
 
 	timer_setup(&udev->qfull_timer, tcmu_qfull_timedout, 0);
@@ -1383,7 +1413,7 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 	return &udev->se_dev;
 }
 
-static bool run_cmdr_queue(struct tcmu_dev *udev, bool fail)
+static bool run_qfull_queue(struct tcmu_dev *udev, bool fail)
 {
 	struct tcmu_cmd *tcmu_cmd, *tmp_cmd;
 	LIST_HEAD(cmds);
@@ -1391,15 +1421,15 @@ static bool run_cmdr_queue(struct tcmu_dev *udev, bool fail)
 	sense_reason_t scsi_ret;
 	int ret;
 
-	if (list_empty(&udev->cmdr_queue))
+	if (list_empty(&udev->qfull_queue))
 		return true;
 
 	pr_debug("running %s's cmdr queue forcefail %d\n", udev->name, fail);
 
-	list_splice_init(&udev->cmdr_queue, &cmds);
+	list_splice_init(&udev->qfull_queue, &cmds);
 
-	list_for_each_entry_safe(tcmu_cmd, tmp_cmd, &cmds, cmdr_queue_entry) {
-		list_del_init(&tcmu_cmd->cmdr_queue_entry);
+	list_for_each_entry_safe(tcmu_cmd, tmp_cmd, &cmds, queue_entry) {
+		list_del_init(&tcmu_cmd->queue_entry);
 
 	        pr_debug("removing cmd %u on dev %s from queue\n",
 		         tcmu_cmd->cmd_id, udev->name);
@@ -1437,14 +1467,13 @@ static bool run_cmdr_queue(struct tcmu_dev *udev, bool fail)
 			 * cmd was requeued, so just put all cmds back in
 			 * the queue
 			 */
-			list_splice_tail(&cmds, &udev->cmdr_queue);
+			list_splice_tail(&cmds, &udev->qfull_queue);
 			drained = false;
-			goto done;
+			break;
 		}
 	}
-	if (list_empty(&udev->cmdr_queue))
-		del_timer(&udev->qfull_timer);
-done:
+
+	tcmu_set_next_deadline(&udev->qfull_queue, &udev->qfull_timer);
 	return drained;
 }
 
@@ -1454,7 +1483,7 @@ static int tcmu_irqcontrol(struct uio_info *info, s32 irq_on)
 
 	mutex_lock(&udev->cmdr_lock);
 	tcmu_handle_completions(udev);
-	run_cmdr_queue(udev, false);
+	run_qfull_queue(udev, false);
 	mutex_unlock(&udev->cmdr_lock);
 
 	return 0;
@@ -1982,7 +2011,7 @@ static void tcmu_block_dev(struct tcmu_dev *udev)
 	/* complete IO that has executed successfully */
 	tcmu_handle_completions(udev);
 	/* fail IO waiting to be queued */
-	run_cmdr_queue(udev, true);
+	run_qfull_queue(udev, true);
 
 unlock:
 	mutex_unlock(&udev->cmdr_lock);
@@ -1997,7 +2026,7 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 	mutex_lock(&udev->cmdr_lock);
 
 	idr_for_each_entry(&udev->commands, cmd, i) {
-		if (!list_empty(&cmd->cmdr_queue_entry))
+		if (!test_bit(TCMU_CMD_BIT_INFLIGHT, &cmd->flags))
 			continue;
 
 		pr_debug("removing cmd %u on dev %s from ring (is expired %d)\n",
@@ -2006,6 +2035,7 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 
 		idr_remove(&udev->commands, i);
 		if (!test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
+			list_del_init(&cmd->queue_entry);
 			if (err_level == 1) {
 				/*
 				 * Userspace was not able to start the
@@ -2666,6 +2696,10 @@ static void check_timedout_devices(void)
 
 		mutex_lock(&udev->cmdr_lock);
 		idr_for_each(&udev->commands, tcmu_check_expired_cmd, NULL);
+
+		tcmu_set_next_deadline(&udev->inflight_queue, &udev->cmd_timer);
+		tcmu_set_next_deadline(&udev->qfull_queue, &udev->qfull_timer);
+
 		mutex_unlock(&udev->cmdr_lock);
 
 		spin_lock_bh(&timed_out_udevs_lock);
