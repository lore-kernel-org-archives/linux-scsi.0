From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: lpfc: Mark expected switch fall-throughs
Date: Wed, 17 Oct 2018 06:20:57 +0200
Message-ID: <20181017042057.GA17636@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Addresses-Coverity-ID: 1357351 ("Missing break in switch")
Addresses-Coverity-ID: 1357392 ("Missing break in switch")
Addresses-Coverity-ID: 114976 ("Missing break in switch")
Addresses-Coverity-ID: 114977 ("Missing break in switch")
Addresses-Coverity-ID: 114978 ("Missing break in switch")
Addresses-Coverity-ID: 114979 ("Missing break in switch")
Addresses-Coverity-ID: 114980 ("Missing break in switch")
Addresses-Coverity-ID: 1446506 ("Missing break in switch")
Addresses-Coverity-ID: 1446507 ("Missing break in switch")
Addresses-Coverity-ID: 201378 ("Missing break in switch")
Addresses-Coverity-ID: 1324069 ("Missing break in switch")
Addresses-Coverity-ID: 1324066 ("Missing break in switch")
Addresses-Coverity-ID: 1357419 ("Missing break in switch")
Addresses-Coverity-ID: 703385 ("Missing break in switch")
Addresses-Coverity-ID: 1129236 ("Missing break in switch")
Addresses-Coverity-ID: 1375910 ("Missing break in switch")
Addresses-Coverity-ID: 1271175 ("Missing break in switch")
Addresses-Coverity-ID: 1129237 ("Missing break in switch")
Addresses-Coverity-ID: 1357437 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/lpfc/lpfc_ct.c        |  2 ++
 drivers/scsi/lpfc/lpfc_els.c       |  1 +
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  4 +++-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  1 +
 drivers/scsi/lpfc/lpfc_nvme.c      |  1 +
 drivers/scsi/lpfc/lpfc_scsi.c      |  8 ++++----
 drivers/scsi/lpfc/lpfc_sli.c       | 18 ++++++++++--------
 7 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 789ad15..9ac4551 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -2839,6 +2839,7 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	case SLI_MGMT_GHAT:
 	case SLI_MGMT_GRPL:
 		rsp_size = FC_MAX_NS_RSP;
+		/* Fall through */
 	case SLI_MGMT_DHBA:
 	case SLI_MGMT_DHAT:
 		pe = (struct lpfc_fdmi_port_entry *)&CtReq->un.PortID;
@@ -2851,6 +2852,7 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	case SLI_MGMT_GPAT:
 	case SLI_MGMT_GPAS:
 		rsp_size = FC_MAX_NS_RSP;
+		/* Fall through */
 	case SLI_MGMT_DPRT:
 	case SLI_MGMT_DPA:
 		pe = (struct lpfc_fdmi_port_entry *)&CtReq->un.PortID;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index f1c1faa..325d3ca 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -8500,6 +8500,7 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 				lpfc_nlp_put(ndlp);
 				return;
 			}
+			/* fall through */
 
 		default:
 			/* Try to recover from this error */
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index f9a038ec..6d497aa 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4586,9 +4586,11 @@ lpfc_check_sli_ndlp(struct lpfc_hba *phba,
 		case CMD_GEN_REQUEST64_CR:
 			if (iocb->context_un.ndlp == ndlp)
 				return 1;
+			/* fall through */
 		case CMD_ELS_REQUEST64_CR:
 			if (icmd->un.elsreq64.remoteID == ndlp->nlp_DID)
 				return 1;
+			/* fall through */
 		case CMD_XMIT_ELS_RSP64_CX:
 			if (iocb->context1 == (uint8_t *) ndlp)
 				return 1;
@@ -5734,7 +5736,7 @@ lpfc_disc_timeout_handler(struct lpfc_vport *vport)
 
 	case LPFC_LINK_UP:
 		lpfc_issue_clear_la(phba, vport);
-		/* Drop thru */
+		/* Fall through */
 	case LPFC_LINK_UNKNOWN:
 	case LPFC_WARM_START:
 	case LPFC_INIT_START:
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 269808e..d001931 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -360,6 +360,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	case  NLP_STE_NPR_NODE:
 		if (!(ndlp->nlp_flag & NLP_NPR_ADISC))
 			break;
+		/* fall through */
 	case  NLP_STE_REG_LOGIN_ISSUE:
 	case  NLP_STE_PRLI_ISSUE:
 	case  NLP_STE_UNMAPPED_NODE:
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index ba831de..942fe58 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1115,6 +1115,7 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 					 lpfc_ncmd, nCmd,
 					 lpfc_ncmd->cur_iocbq.sli4_xritag,
 					 bf_get(lpfc_wcqe_c_xb, wcqe));
+			/* fall through */
 		default:
 out_err:
 			lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_IOERR,
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 4fa6703..94b9931 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1427,7 +1427,7 @@ lpfc_bg_err_inject(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 
 					break;
 				}
-				/* Drop thru */
+				/* Fall through */
 			case SCSI_PROT_WRITE_INSERT:
 				/*
 				 * For WRITE_INSERT, force the error
@@ -1546,7 +1546,7 @@ lpfc_bg_err_inject(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 					rc = BG_ERR_TGT | BG_ERR_CHECK;
 					break;
 				}
-				/* Drop thru */
+				/* Fall through */
 			case SCSI_PROT_WRITE_INSERT:
 				/*
 				 * For WRITE_INSERT, force the
@@ -1628,7 +1628,7 @@ lpfc_bg_err_inject(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 			switch (op) {
 			case SCSI_PROT_WRITE_PASS:
 				rc = BG_ERR_CHECK;
-				/* Drop thru */
+				/* Fall through */
 
 			case SCSI_PROT_WRITE_INSERT:
 				/*
@@ -4115,7 +4115,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 					lpfc_cmd->cur_iocbq.sli4_lxritag,
 					0, 0);
 			}
-		/* else: fall through */
+			/* fall through */
 		default:
 			cmd->result = DID_ERROR << 16;
 			break;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c378230..56f88a8 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -9324,6 +9324,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		cmnd = CMD_XMIT_SEQUENCE64_CR;
 		if (phba->link_flag & LS_LOOPBACK_MODE)
 			bf_set(wqe_xo, &wqe->xmit_sequence.wge_ctl, 1);
+		/* fall through */
 	case CMD_XMIT_SEQUENCE64_CR:
 		/* word3 iocb=io_tag32 wqe=reserved */
 		wqe->xmit_sequence.rsvd3 = 0;
@@ -13451,6 +13452,7 @@ lpfc_sli4_sp_handle_rcqe(struct lpfc_hba *phba, struct lpfc_rcqe *rcqe)
 	case FC_STATUS_RQ_BUF_LEN_EXCEEDED:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"2537 Receive Frame Truncated!!\n");
+		/* fall through */
 	case FC_STATUS_RQ_SUCCESS:
 		spin_lock_irqsave(&phba->hbalock, iflags);
 		lpfc_sli4_rq_release(hrq, drq);
@@ -13487,7 +13489,7 @@ lpfc_sli4_sp_handle_rcqe(struct lpfc_hba *phba, struct lpfc_rcqe *rcqe)
 					atomic_read(&tgtp->rcv_fcp_cmd_out),
 					atomic_read(&tgtp->xmt_fcp_release));
 		}
-		/* fallthrough */
+		/* fall through */
 
 	case FC_STATUS_INSUFF_BUF_NEED_BUF:
 		hrq->RQ_no_posted_buf++;
@@ -13853,7 +13855,7 @@ lpfc_sli4_nvmet_handle_rcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	case FC_STATUS_RQ_BUF_LEN_EXCEEDED:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"6126 Receive Frame Truncated!!\n");
-		/* Drop thru */
+		/* Fall through */
 	case FC_STATUS_RQ_SUCCESS:
 		spin_lock_irqsave(&phba->hbalock, iflags);
 		lpfc_sli4_rq_release(hrq, drq);
@@ -14763,7 +14765,7 @@ lpfc_eq_create(struct lpfc_hba *phba, struct lpfc_queue *eq, uint32_t imax)
 				eq->entry_count);
 		if (eq->entry_count < 256)
 			return -EINVAL;
-		/* otherwise default to smallest count (drop through) */
+		/* fall through - otherwise default to smallest count */
 	case 256:
 		bf_set(lpfc_eq_context_count, &eq_create->u.request.context,
 		       LPFC_EQ_CNT_256);
@@ -14907,7 +14909,7 @@ lpfc_cq_create(struct lpfc_hba *phba, struct lpfc_queue *cq,
 			status = -EINVAL;
 			goto out;
 		}
-		/* otherwise default to smallest count (drop through) */
+		/* fall through - otherwise default to smallest count */
 	case 256:
 		bf_set(lpfc_cq_context_count, &cq_create->u.request.context,
 		       LPFC_CQ_CNT_256);
@@ -15076,7 +15078,7 @@ lpfc_cq_create_set(struct lpfc_hba *phba, struct lpfc_queue **cqp,
 					status = -EINVAL;
 					goto out;
 				}
-				/* otherwise default to smallest (drop thru) */
+				/* fall through - otherwise default to smallest */
 			case 256:
 				bf_set(lpfc_mbx_cq_create_set_cqe_cnt,
 				       &cq_set->u.request, LPFC_CQ_CNT_256);
@@ -15348,7 +15350,7 @@ lpfc_mq_create(struct lpfc_hba *phba, struct lpfc_queue *mq,
 			status = -EINVAL;
 			goto out;
 		}
-		/* otherwise default to smallest count (drop through) */
+		/* fall through - otherwise default to smallest count */
 	case 16:
 		bf_set(lpfc_mq_context_ring_size,
 		       &mq_create_ext->u.request.context,
@@ -15767,7 +15769,7 @@ lpfc_rq_create(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 				status = -EINVAL;
 				goto out;
 			}
-			/* otherwise default to smallest count (drop through) */
+			/* fall through - otherwise default to smallest count */
 		case 512:
 			bf_set(lpfc_rq_context_rqe_count,
 			       &rq_create->u.request.context,
@@ -15904,7 +15906,7 @@ lpfc_rq_create(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 				status = -EINVAL;
 				goto out;
 			}
-			/* otherwise default to smallest count (drop through) */
+			/* fall through - otherwise default to smallest count */
 		case 512:
 			bf_set(lpfc_rq_context_rqe_count,
 			       &rq_create->u.request.context,
-- 
2.7.4
