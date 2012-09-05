From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH v2] [SCSI] bfa: use list_move_tail instead of list_del/list_add_tail
Date: Wed, 5 Sep 2012 14:59:32 +0800
Message-ID: <CAPgLHd-SV4g0vi838-yDVWUEQzPPU9KAej3parV=wckYXEUAaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49465 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab2IEG7d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Sep 2012 02:59:33 -0400
Received: by qaas11 with SMTP id s11so4211426qaa.19
        for <linux-scsi@vger.kernel.org>; Tue, 04 Sep 2012 23:59:32 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: huangj@brocade.com, kgudipat@brocade.com, JBottomley@parallels.com
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_move_tail() instead of list_del() + list_add_tail().

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
v1 -> v2: add cleanup for drivers/scsi/bfa/bfa_svc.c
---
 drivers/scsi/bfa/bfa_svc.c   | 18 ++++++------------
 drivers/scsi/bfa/bfa_ioc.c   | 3 +--
 drivers/scsi/bfa/bfa_fcpim.c | 37 +++++++++++++------------------------
 3 files changed, 20 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 2e856e6..dd97cb3 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -656,8 +656,7 @@ bfa_fcxp_put(struct bfa_fcxp_s *fcxp)
 	}
 
 	WARN_ON(!bfa_q_is_on_q(&mod->fcxp_active_q, fcxp));
-	list_del(&fcxp->qe);
-	list_add_tail(&fcxp->qe, &mod->fcxp_free_q);
+	list_move_tail(&fcxp->qe, &mod->fcxp_free_q);
 }
 
 static void
@@ -1588,8 +1587,7 @@ bfa_lps_login_rsp(struct bfa_s *bfa, struct bfi_lps_login_rsp_s *rsp)
 		break;
 	}
 
-	list_del(&lps->qe);
-	list_add_tail(&lps->qe, &mod->lps_active_q);
+	list_move_tail(&lps->qe, &mod->lps_active_q);
 	bfa_sm_send_event(lps, BFA_LPS_SM_FWRSP);
 }
 
@@ -1610,8 +1608,7 @@ bfa_lps_no_res(struct bfa_lps_s *first_lps, u8 count)
 		lps = (struct bfa_lps_s *)qe;
 		bfa_trc(bfa, lps->bfa_tag);
 		lps->status = first_lps->status;
-		list_del(&lps->qe);
-		list_add_tail(&lps->qe, &mod->lps_active_q);
+		list_move_tail(&lps->qe, &mod->lps_active_q);
 		bfa_sm_send_event(lps, BFA_LPS_SM_FWRSP);
 		qe = qe_next;
 		count--;
@@ -1667,8 +1664,7 @@ bfa_lps_free(struct bfa_lps_s *lps)
 	struct bfa_lps_mod_s	*mod = BFA_LPS_MOD(lps->bfa);
 
 	lps->lp_pid = 0;
-	list_del(&lps->qe);
-	list_add_tail(&lps->qe, &mod->lps_free_q);
+	list_move_tail(&lps->qe, &mod->lps_free_q);
 }
 
 /*
@@ -1696,8 +1692,7 @@ bfa_lps_send_login(struct bfa_lps_s *lps)
 	m->bb_scn	= lps->bb_scn;
 
 	bfa_reqq_produce(lps->bfa, lps->reqq, m->mh);
-	list_del(&lps->qe);
-	list_add_tail(&lps->qe, &mod->lps_login_q);
+	list_move_tail(&lps->qe, &mod->lps_login_q);
 }
 
 /*
@@ -4534,8 +4529,7 @@ bfa_rport_free(struct bfa_rport_s *rport)
 	struct bfa_rport_mod_s *mod = BFA_RPORT_MOD(rport->bfa);
 
 	WARN_ON(!bfa_q_is_on_q(&mod->rp_active_q, rport));
-	list_del(&rport->qe);
-	list_add_tail(&rport->qe, &mod->rp_free_q);
+	list_move_tail(&rport->qe, &mod->rp_free_q);
 }
 
 static bfa_boolean_t

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 8cdb79c..339e731 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -2950,8 +2950,7 @@ bfa_timer_beat(struct bfa_timer_mod_s *mod)
 		elem = (struct bfa_timer_s *) qe;
 		if (elem->timeout <= BFA_TIMER_FREQ) {
 			elem->timeout = 0;
-			list_del(&elem->qe);
-			list_add_tail(&elem->qe, &timedout_q);
+			list_move_tail(&elem->qe, &timedout_q);
 		} else {
 			elem->timeout -= BFA_TIMER_FREQ;
 		}

diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index f0f80e2..02a1552 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -91,8 +91,7 @@ enum bfa_itnim_event {
  *  BFA IOIM related definitions
  */
 #define bfa_ioim_move_to_comp_q(__ioim) do {				\
-	list_del(&(__ioim)->qe);					\
-	list_add_tail(&(__ioim)->qe, &(__ioim)->fcpim->ioim_comp_q);	\
+	list_move_tail(&(__ioim)->qe, &(__ioim)->fcpim->ioim_comp_q);	\
 } while (0)
 
 
@@ -1030,8 +1029,7 @@ bfa_itnim_cleanup(struct bfa_itnim_s *itnim)
 		 * Move IO to a cleanup queue from active queue so that a later
 		 * TM will not pickup this IO.
 		 */
-		list_del(&ioim->qe);
-		list_add_tail(&ioim->qe, &itnim->io_cleanup_q);
+		list_move_tail(&ioim->qe, &itnim->io_cleanup_q);
 
 		bfa_wc_up(&itnim->wc);
 		bfa_ioim_cleanup(ioim);
@@ -1505,15 +1503,13 @@ bfa_ioim_sm_uninit(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		if (!bfa_itnim_is_online(ioim->itnim)) {
 			if (!bfa_itnim_hold_io(ioim->itnim)) {
 				bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
-				list_del(&ioim->qe);
-				list_add_tail(&ioim->qe,
-					&ioim->fcpim->ioim_comp_q);
+				list_move_tail(&ioim->qe,
+					       &ioim->fcpim->ioim_comp_q);
 				bfa_cb_queue(ioim->bfa, &ioim->hcb_qe,
 						__bfa_cb_ioim_pathtov, ioim);
 			} else {
-				list_del(&ioim->qe);
-				list_add_tail(&ioim->qe,
-					&ioim->itnim->pending_q);
+				list_move_tail(&ioim->qe,
+					       &ioim->itnim->pending_q);
 			}
 			break;
 		}
@@ -2040,8 +2036,7 @@ bfa_ioim_sm_hcb_free(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 	switch (event) {
 	case BFA_IOIM_SM_HCB:
 		bfa_sm_set_state(ioim, bfa_ioim_sm_resfree);
-		list_del(&ioim->qe);
-		list_add_tail(&ioim->qe, &ioim->fcpim->ioim_resfree_q);
+		list_move_tail(&ioim->qe, &ioim->fcpim->ioim_resfree_q);
 		break;
 
 	case BFA_IOIM_SM_FREE:
@@ -2673,14 +2668,12 @@ bfa_ioim_notify_cleanup(struct bfa_ioim_s *ioim)
 	 * Move IO from itnim queue to fcpim global queue since itnim will be
 	 * freed.
 	 */
-	list_del(&ioim->qe);
-	list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
+	list_move_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
 
 	if (!ioim->iosp->tskim) {
 		if (ioim->fcpim->delay_comp && ioim->itnim->iotov_active) {
 			bfa_cb_dequeue(&ioim->hcb_qe);
-			list_del(&ioim->qe);
-			list_add_tail(&ioim->qe, &ioim->itnim->delay_comp_q);
+			list_move_tail(&ioim->qe, &ioim->itnim->delay_comp_q);
 		}
 		bfa_itnim_iodone(ioim->itnim);
 	} else
@@ -2724,8 +2717,7 @@ bfa_ioim_delayed_comp(struct bfa_ioim_s *ioim, bfa_boolean_t iotov)
 	 * Move IO to fcpim global queue since itnim will be
 	 * freed.
 	 */
-	list_del(&ioim->qe);
-	list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
+	list_move_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
 }
 
 
@@ -3319,8 +3311,7 @@ bfa_tskim_gather_ios(struct bfa_tskim_s *tskim)
 		cmnd = (struct scsi_cmnd *) ioim->dio;
 		int_to_scsilun(cmnd->device->lun, &scsilun);
 		if (bfa_tskim_match_scope(tskim, scsilun)) {
-			list_del(&ioim->qe);
-			list_add_tail(&ioim->qe, &tskim->io_q);
+			list_move_tail(&ioim->qe, &tskim->io_q);
 		}
 	}
 
@@ -3332,8 +3323,7 @@ bfa_tskim_gather_ios(struct bfa_tskim_s *tskim)
 		cmnd = (struct scsi_cmnd *) ioim->dio;
 		int_to_scsilun(cmnd->device->lun, &scsilun);
 		if (bfa_tskim_match_scope(tskim, scsilun)) {
-			list_del(&ioim->qe);
-			list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
+			list_move_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
 			bfa_ioim_tov(ioim);
 		}
 	}
@@ -3575,8 +3565,7 @@ void
 bfa_tskim_free(struct bfa_tskim_s *tskim)
 {
 	WARN_ON(!bfa_q_is_on_q_func(&tskim->itnim->tsk_q, &tskim->qe));
-	list_del(&tskim->qe);
-	list_add_tail(&tskim->qe, &tskim->fcpim->tskim_free_q);
+	list_move_tail(&tskim->qe, &tskim->fcpim->tskim_free_q);
 }
 
 /*


