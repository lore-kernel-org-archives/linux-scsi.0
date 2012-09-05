From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] [SCSI] bfa: use list_move_tail instead of list_del/list_add_tail
Date: Wed, 5 Sep 2012 14:29:02 +0800
Message-ID: <CAPgLHd85aCzYFvK=ZsB+9o7EmNwE2TvQvjoB+kyVSUpyCbhnow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:35150 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab2IEG3D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Sep 2012 02:29:03 -0400
Received: by qaas11 with SMTP id s11so4186232qaa.19
        for <linux-scsi@vger.kernel.org>; Tue, 04 Sep 2012 23:29:02 -0700 (PDT)
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
 drivers/scsi/bfa/bfa_ioc.c   | 3 +--
 drivers/scsi/bfa/bfa_fcpim.c | 37 +++++++++++++------------------------
 2 files changed, 14 insertions(+), 26 deletions(-)

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

