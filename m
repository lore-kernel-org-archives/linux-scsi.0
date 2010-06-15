From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 17/23] bfa: fix possible IO double completion
Date: Tue, 15 Jun 2010 11:49:08 -0700
Message-ID: <1276627748-3608-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:42453 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758590Ab0FOStO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2010 14:49:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: vravindr@brocade.com, rvadivel@brocade.com, kgudipat@brocade.com, amathur@brocade.com, Jing Huang <huangj@brocade.com>

While processing the ioim in callback functions, the ioim is still in io_q.
During this time, if the itnim goes offline, the ioim is requeued from
itnim->io_q into itnim->delay_comp_q although the request is already completed.
This results in requeing the ioim into the callback queue if the ioim is not
freed by the time the ioim is requeued. This results in double completion of
the ioim. To fix this, whenever a response is received from firmware for an
ioim, deque it from io_q and enque to fcpim->comp_q. This will eliminate any
possibility of itnim picking any ioim for which the response is already
received.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_ioim.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioim.c b/drivers/scsi/bfa/bfa_ioim.c
index 680b87d..4148ae0 100644
--- a/drivers/scsi/bfa/bfa_ioim.c
+++ b/drivers/scsi/bfa/bfa_ioim.c
@@ -133,6 +133,8 @@ bfa_ioim_sm_uninit(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 
 	case BFA_IOIM_SM_IOTOV:
 		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		list_del(&ioim->qe);
+		list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
 		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe,
 				__bfa_cb_ioim_pathtov, ioim);
 		break;
@@ -182,6 +184,8 @@ bfa_ioim_sm_sgalloc(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 	case BFA_IOIM_SM_ABORT:
 		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
 		bfa_sgpg_wcancel(ioim->bfa, &ioim->iosp->sgpg_wqe);
+		list_del(&ioim->qe);
+		list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
 		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_abort,
 			      ioim);
 		break;
@@ -189,6 +193,8 @@ bfa_ioim_sm_sgalloc(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 	case BFA_IOIM_SM_HWFAIL:
 		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
 		bfa_sgpg_wcancel(ioim->bfa, &ioim->iosp->sgpg_wqe);
+		list_del(&ioim->qe);
+		list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
 		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_failed,
 			      ioim);
 		break;
@@ -210,18 +216,24 @@ bfa_ioim_sm_active(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 	switch (event) {
 	case BFA_IOIM_SM_COMP_GOOD:
 		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		list_del(&ioim->qe);
+		list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
 		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe,
 			      __bfa_cb_ioim_good_comp, ioim);
 		break;
 
 	case BFA_IOIM_SM_COMP:
 		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		list_del(&ioim->qe);
+		list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
 		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_comp,
 			      ioim);
 		break;
 
 	case BFA_IOIM_SM_DONE:
 		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb_free);
+		list_del(&ioim->qe);
+		list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
 		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_comp,
 			      ioim);
 		break;
@@ -254,6 +266,8 @@ bfa_ioim_sm_active(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 
 	case BFA_IOIM_SM_HWFAIL:
 		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		list_del(&ioim->qe);
+		list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
 		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_failed,
 			      ioim);
 		break;
@@ -287,12 +301,16 @@ bfa_ioim_sm_abort(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 
 	case BFA_IOIM_SM_ABORT_COMP:
 		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		list_del(&ioim->qe);
+		list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
 		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_abort,
 			      ioim);
 		break;
 
 	case BFA_IOIM_SM_COMP_UTAG:
 		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		list_del(&ioim->qe);
+		list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
 		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_abort,
 			      ioim);
 		break;
@@ -312,6 +330,8 @@ bfa_ioim_sm_abort(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 
 	case BFA_IOIM_SM_HWFAIL:
 		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		list_del(&ioim->qe);
+		list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
 		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_failed,
 			      ioim);
 		break;
@@ -365,6 +385,8 @@ bfa_ioim_sm_cleanup(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 
 	case BFA_IOIM_SM_HWFAIL:
 		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		list_del(&ioim->qe);
+		list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
 		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_failed,
 			      ioim);
 		break;
@@ -399,6 +421,8 @@ bfa_ioim_sm_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 	case BFA_IOIM_SM_ABORT:
 		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
 		bfa_reqq_wcancel(&ioim->iosp->reqq_wait);
+		list_del(&ioim->qe);
+		list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
 		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_abort,
 			      ioim);
 		break;
@@ -414,6 +438,8 @@ bfa_ioim_sm_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 	case BFA_IOIM_SM_HWFAIL:
 		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
 		bfa_reqq_wcancel(&ioim->iosp->reqq_wait);
+		list_del(&ioim->qe);
+		list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
 		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_failed,
 			      ioim);
 		break;
@@ -448,6 +474,8 @@ bfa_ioim_sm_abort_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 	case BFA_IOIM_SM_COMP:
 		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
 		bfa_reqq_wcancel(&ioim->iosp->reqq_wait);
+		list_del(&ioim->qe);
+		list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
 		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_abort,
 			      ioim);
 		break;
@@ -455,6 +483,8 @@ bfa_ioim_sm_abort_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 	case BFA_IOIM_SM_DONE:
 		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb_free);
 		bfa_reqq_wcancel(&ioim->iosp->reqq_wait);
+		list_del(&ioim->qe);
+		list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
 		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_abort,
 			      ioim);
 		break;
@@ -462,6 +492,8 @@ bfa_ioim_sm_abort_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 	case BFA_IOIM_SM_HWFAIL:
 		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
 		bfa_reqq_wcancel(&ioim->iosp->reqq_wait);
+		list_del(&ioim->qe);
+		list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
 		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_failed,
 			      ioim);
 		break;
@@ -511,6 +543,8 @@ bfa_ioim_sm_cleanup_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 	case BFA_IOIM_SM_HWFAIL:
 		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
 		bfa_reqq_wcancel(&ioim->iosp->reqq_wait);
+		list_del(&ioim->qe);
+		list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
 		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_failed,
 			      ioim);
 		break;
-- 
1.6.5.2

