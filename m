From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 28/41] scsi: lpfc: lpfc_sli: Mark expected switch
 fall-throughs
Date: Tue, 27 Nov 2018 22:32:18 -0600
Message-ID: <cb80d182329a02971ff365446b0e04771fc77da8.1543374820.git.gustavo@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1543374820.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Notice that, in this particular case, I replaced "Drop thru" and
"Fall Thru" with "fall through" annotations, which is what GCC
is expecting to find.

Also, in some cases a dash is added as a token in order to separate
the "fall through" annotation from the rest of the comment on the
same line, which is what GCC is expecting to find.

Addresses-Coverity-ID: 114979 ("Missing break in switch")
Addresses-Coverity-ID: 114980 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 3912a2d0b95d..cbcda5a91068 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -9334,6 +9334,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		cmnd = CMD_XMIT_SEQUENCE64_CR;
 		if (phba->link_flag & LS_LOOPBACK_MODE)
 			bf_set(wqe_xo, &wqe->xmit_sequence.wge_ctl, 1);
+		/* fall through */
 	case CMD_XMIT_SEQUENCE64_CR:
 		/* word3 iocb=io_tag32 wqe=reserved */
 		wqe->xmit_sequence.rsvd3 = 0;
@@ -13460,6 +13461,7 @@ lpfc_sli4_sp_handle_rcqe(struct lpfc_hba *phba, struct lpfc_rcqe *rcqe)
 	case FC_STATUS_RQ_BUF_LEN_EXCEEDED:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"2537 Receive Frame Truncated!!\n");
+		/* fall through */
 	case FC_STATUS_RQ_SUCCESS:
 		spin_lock_irqsave(&phba->hbalock, iflags);
 		lpfc_sli4_rq_release(hrq, drq);
@@ -13859,7 +13861,7 @@ lpfc_sli4_nvmet_handle_rcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	case FC_STATUS_RQ_BUF_LEN_EXCEEDED:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"6126 Receive Frame Truncated!!\n");
-		/* Drop thru */
+		/* fall through */
 	case FC_STATUS_RQ_SUCCESS:
 		spin_lock_irqsave(&phba->hbalock, iflags);
 		lpfc_sli4_rq_release(hrq, drq);
@@ -14769,7 +14771,7 @@ lpfc_eq_create(struct lpfc_hba *phba, struct lpfc_queue *eq, uint32_t imax)
 				eq->entry_count);
 		if (eq->entry_count < 256)
 			return -EINVAL;
-		/* otherwise default to smallest count (drop through) */
+		/* fall through - otherwise default to smallest count */
 	case 256:
 		bf_set(lpfc_eq_context_count, &eq_create->u.request.context,
 		       LPFC_EQ_CNT_256);
@@ -14899,7 +14901,7 @@ lpfc_cq_create(struct lpfc_hba *phba, struct lpfc_queue *cq,
 			       LPFC_CQ_CNT_WORD7);
 			break;
 		}
-		/* Fall Thru */
+		/* fall through */
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"0361 Unsupported CQ count: "
@@ -14910,7 +14912,7 @@ lpfc_cq_create(struct lpfc_hba *phba, struct lpfc_queue *cq,
 			status = -EINVAL;
 			goto out;
 		}
-		/* otherwise default to smallest count (drop through) */
+		/* fall through - otherwise default to smallest count */
 	case 256:
 		bf_set(lpfc_cq_context_count, &cq_create->u.request.context,
 		       LPFC_CQ_CNT_256);
@@ -15070,7 +15072,7 @@ lpfc_cq_create_set(struct lpfc_hba *phba, struct lpfc_queue **cqp,
 					       LPFC_CQ_CNT_WORD7);
 					break;
 				}
-				/* Fall Thru */
+				/* fall through */
 			default:
 				lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 						"3118 Bad CQ count. (%d)\n",
@@ -15079,7 +15081,7 @@ lpfc_cq_create_set(struct lpfc_hba *phba, struct lpfc_queue **cqp,
 					status = -EINVAL;
 					goto out;
 				}
-				/* otherwise default to smallest (drop thru) */
+				/* fall through - otherwise default to smallest */
 			case 256:
 				bf_set(lpfc_mbx_cq_create_set_cqe_cnt,
 				       &cq_set->u.request, LPFC_CQ_CNT_256);
@@ -15351,7 +15353,7 @@ lpfc_mq_create(struct lpfc_hba *phba, struct lpfc_queue *mq,
 			status = -EINVAL;
 			goto out;
 		}
-		/* otherwise default to smallest count (drop through) */
+		/* fall through - otherwise default to smallest count */
 	case 16:
 		bf_set(lpfc_mq_context_ring_size,
 		       &mq_create_ext->u.request.context,
@@ -15770,7 +15772,7 @@ lpfc_rq_create(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 				status = -EINVAL;
 				goto out;
 			}
-			/* otherwise default to smallest count (drop through) */
+			/* fall through - otherwise default to smallest count */
 		case 512:
 			bf_set(lpfc_rq_context_rqe_count,
 			       &rq_create->u.request.context,
@@ -15907,7 +15909,7 @@ lpfc_rq_create(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 				status = -EINVAL;
 				goto out;
 			}
-			/* otherwise default to smallest count (drop through) */
+			/* fall through - otherwise default to smallest count */
 		case 512:
 			bf_set(lpfc_rq_context_rqe_count,
 			       &rq_create->u.request.context,
-- 
2.17.1
