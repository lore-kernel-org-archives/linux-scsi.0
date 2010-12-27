From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 2/3] bfa: remove inactive functions
Date: Sun, 26 Dec 2010 21:48:53 -0800
Message-ID: <1293428933-19743-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:45557 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750859Ab0L0Fs7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Dec 2010 00:48:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Jing Huang <huangj@brocade.com>

This patch removes some inactive functions and macros.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/Makefile    |    2 --
 drivers/scsi/bfa/bfa_core.c  |    8 --------
 drivers/scsi/bfa/bfa_cs.h    |   35 -----------------------------------
 drivers/scsi/bfa/bfa_fcpim.c |   23 -----------------------
 drivers/scsi/bfa/bfa_svc.c   |    4 ----
 drivers/scsi/bfa/bfad.c      |    1 -
 drivers/scsi/bfa/bfad_im.c   |    1 -
 7 files changed, 0 insertions(+), 74 deletions(-)

diff --git a/drivers/scsi/bfa/Makefile b/drivers/scsi/bfa/Makefile
index ed26a6a..4ce6f49 100644
--- a/drivers/scsi/bfa/Makefile
+++ b/drivers/scsi/bfa/Makefile
@@ -4,5 +4,3 @@ bfa-y := bfad.o bfad_im.o bfad_attr.o bfad_debugfs.o
 bfa-y += bfa_ioc.o bfa_ioc_cb.o bfa_ioc_ct.o bfa_hw_cb.o bfa_hw_ct.o
 bfa-y += bfa_fcs.o bfa_fcs_lport.o bfa_fcs_rport.o bfa_fcs_fcpim.o bfa_fcbuild.o
 bfa-y += bfa_port.o bfa_fcpim.o bfa_core.o bfa_svc.o
-
-ccflags-y := -DBFA_PERF_BUILD
diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 6e13ba2..d6c7e05 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -296,8 +296,6 @@ bfa_msix_rspq(struct bfa_s *bfa, int qid)
 	u32 pi, ci;
 	struct list_head *waitq;
 
-	bfa_trc_fp(bfa, qid);
-
 	qid &= (BFI_IOC_MAX_CQS - 1);
 
 	bfa->iocfc.hwif.hw_rspq_ack(bfa, qid);
@@ -305,16 +303,10 @@ bfa_msix_rspq(struct bfa_s *bfa, int qid)
 	ci = bfa_rspq_ci(bfa, qid);
 	pi = bfa_rspq_pi(bfa, qid);
 
-	bfa_trc_fp(bfa, ci);
-	bfa_trc_fp(bfa, pi);
-
 	if (bfa->rme_process) {
 		while (ci != pi) {
 			m = bfa_rspq_elem(bfa, qid, ci);
-			bfa_assert_fp(m->mhdr.msg_class < BFI_MC_MAX);
-
 			bfa_isrs[m->mhdr.msg_class] (bfa, m);
-
 			CQ_INCR(ci, bfa->iocfc.cfg.drvcfg.num_rspq_elems);
 		}
 	}
diff --git a/drivers/scsi/bfa/bfa_cs.h b/drivers/scsi/bfa/bfa_cs.h
index 913057d..12bfeed 100644
--- a/drivers/scsi/bfa/bfa_cs.h
+++ b/drivers/scsi/bfa/bfa_cs.h
@@ -107,13 +107,6 @@ bfa_trc_stop(struct bfa_trc_mod_s *trcm)
 	trcm->stopped = 1;
 }
 
-#ifdef FWTRC
-extern void dc_flush(void *data);
-#else
-#define dc_flush(data)
-#endif
-
-
 static inline void
 __bfa_trc(struct bfa_trc_mod_s *trcm, int fileno, int line, u64 data)
 {
@@ -127,12 +120,10 @@ __bfa_trc(struct bfa_trc_mod_s *trcm, int fileno, int line, u64 data)
 	trc->line = (u16) line;
 	trc->data.u64 = data;
 	trc->timestamp = BFA_TRC_TS(trcm);
-	dc_flush(trc);
 
 	trcm->tail = (trcm->tail + 1) & (BFA_TRC_MAX - 1);
 	if (trcm->tail == trcm->head)
 		trcm->head = (trcm->head + 1) & (BFA_TRC_MAX - 1);
-	dc_flush(trcm);
 }
 
 
@@ -149,32 +140,18 @@ __bfa_trc32(struct bfa_trc_mod_s *trcm, int fileno, int line, u32 data)
 	trc->line = (u16) line;
 	trc->data.u32.u32 = data;
 	trc->timestamp = BFA_TRC_TS(trcm);
-	dc_flush(trc);
 
 	trcm->tail = (trcm->tail + 1) & (BFA_TRC_MAX - 1);
 	if (trcm->tail == trcm->head)
 		trcm->head = (trcm->head + 1) & (BFA_TRC_MAX - 1);
-	dc_flush(trcm);
 }
 
-#ifndef BFA_PERF_BUILD
-#define bfa_trc_fp(_trcp, _data)	bfa_trc(_trcp, _data)
-#else
-#define bfa_trc_fp(_trcp, _data)
-#endif
-
 #define bfa_sm_fault(__mod, __event)	do {				\
 	bfa_trc(__mod, (((u32)0xDEAD << 16) | __event));		\
 	printk(KERN_ERR	"Assertion failure: %s:%d: %d",			\
 		__FILE__, __LINE__, (__event));				\
 } while (0)
 
-#ifndef BFA_PERF_BUILD
-#define bfa_assert_fp(__cond)	bfa_assert(__cond)
-#else
-#define bfa_assert_fp(__cond)
-#endif
-
 /* BFA queue definitions */
 #define bfa_q_first(_q) ((void *)(((struct list_head *) (_q))->next))
 #define bfa_q_next(_qe) (((struct list_head *) (_qe))->next)
@@ -197,7 +174,6 @@ __bfa_trc32(struct bfa_trc_mod_s *trcm, int fileno, int line, u32 data)
 		bfa_q_prev(bfa_q_next(*((struct list_head **) _qe))) =	\
 				(struct list_head *) (_q);		\
 		bfa_q_next(_q) = bfa_q_next(*((struct list_head **) _qe));\
-		BFA_Q_DBG_INIT(*((struct list_head **) _qe));		\
 	} else {							\
 		*((struct list_head **) (_qe)) = (struct list_head *) NULL;\
 	}								\
@@ -212,7 +188,6 @@ __bfa_trc32(struct bfa_trc_mod_s *trcm, int fileno, int line, u32 data)
 		bfa_q_next(bfa_q_prev(*((struct list_head **) _qe))) =	\
 			(struct list_head *) (_q);			\
 		bfa_q_prev(_q) = bfa_q_prev(*(struct list_head **) _qe);\
-		BFA_Q_DBG_INIT(*((struct list_head **) _qe));		\
 	} else {							\
 		*((struct list_head **) (_qe)) = (struct list_head *) NULL;\
 	}								\
@@ -234,16 +209,6 @@ bfa_q_is_on_q_func(struct list_head *q, struct list_head *qe)
 	return 0;
 }
 
-/*
- * #ifdef BFA_DEBUG (Using bfa_assert to check for debug_build is not
- * consistent across modules)
- */
-#ifndef BFA_PERF_BUILD
-#define BFA_Q_DBG_INIT(_qe) bfa_q_qe_init(_qe)
-#else
-#define BFA_Q_DBG_INIT(_qe)
-#endif
-
 #define bfa_q_is_on_q(_q, _qe)      \
 	bfa_q_is_on_q_func(_q, (struct list_head *)(_qe))
 
diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index f57c066..a4989a0 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -1367,9 +1367,6 @@ bfa_itnim_clear_stats(struct bfa_itnim_s *itnim)
 static void
 bfa_ioim_sm_uninit(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 {
-	bfa_trc_fp(ioim->bfa, ioim->iotag);
-	bfa_trc_fp(ioim->bfa, event);
-
 	switch (event) {
 	case BFA_IOIM_SM_START:
 		if (!bfa_itnim_is_online(ioim->itnim)) {
@@ -1479,9 +1476,6 @@ bfa_ioim_sm_sgalloc(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 static void
 bfa_ioim_sm_active(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 {
-	bfa_trc_fp(ioim->bfa, ioim->iotag);
-	bfa_trc_fp(ioim->bfa, event);
-
 	switch (event) {
 	case BFA_IOIM_SM_COMP_GOOD:
 		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
@@ -1563,9 +1557,6 @@ bfa_ioim_sm_active(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 static void
 bfa_ioim_sm_cmnd_retry(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 {
-	bfa_trc_fp(ioim->bfa, ioim->iotag);
-	bfa_trc_fp(ioim->bfa, event);
-
 	switch (event) {
 	case BFA_IOIM_SM_FREE:
 		/* abts and rrq done. Now retry the IO with new tag */
@@ -1886,9 +1877,6 @@ bfa_ioim_sm_cleanup_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 static void
 bfa_ioim_sm_hcb(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 {
-	bfa_trc_fp(ioim->bfa, ioim->iotag);
-	bfa_trc_fp(ioim->bfa, event);
-
 	switch (event) {
 	case BFA_IOIM_SM_HCB:
 		bfa_sm_set_state(ioim, bfa_ioim_sm_uninit);
@@ -2529,9 +2517,7 @@ bfa_ioim_good_comp_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 	ioim = BFA_IOIM_FROM_TAG(fcpim, iotag);
 	WARN_ON(BFA_IOIM_TAG_2_ID(ioim->iotag) != iotag);
 
-	bfa_trc_fp(ioim->bfa, ioim->iotag);
 	bfa_ioim_cb_profile_comp(fcpim, ioim);
-
 	bfa_sm_send_event(ioim, BFA_IOIM_SM_COMP_GOOD);
 }
 
@@ -2608,7 +2594,6 @@ bfa_ioim_alloc(struct bfa_s *bfa, struct bfad_ioim_s *dio,
 	fcpim->ios_active++;
 
 	list_add_tail(&ioim->qe, &itnim->io_q);
-	bfa_trc_fp(ioim->bfa, ioim->iotag);
 
 	return ioim;
 }
@@ -2618,12 +2603,6 @@ bfa_ioim_free(struct bfa_ioim_s *ioim)
 {
 	struct bfa_fcpim_mod_s *fcpim = ioim->fcpim;
 
-	bfa_trc_fp(ioim->bfa, ioim->iotag);
-	bfa_assert_fp(bfa_sm_cmp_state(ioim, bfa_ioim_sm_uninit));
-
-	bfa_assert_fp(list_empty(&ioim->sgpg_q) ||
-			(ioim->nsges > BFI_SGE_INLINE));
-
 	if (ioim->nsgpgs > 0)
 		bfa_sgpg_mfree(ioim->bfa, &ioim->sgpg_q, ioim->nsgpgs);
 
@@ -2638,8 +2617,6 @@ bfa_ioim_free(struct bfa_ioim_s *ioim)
 void
 bfa_ioim_start(struct bfa_ioim_s *ioim)
 {
-	bfa_trc_fp(ioim->bfa, ioim->iotag);
-
 	bfa_ioim_cb_profile_start(ioim->fcpim, ioim);
 
 	/*
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index d33e93a..6577d0d 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -4670,8 +4670,6 @@ bfa_sgpg_malloc(struct bfa_s *bfa, struct list_head *sgpg_q, int nsgpgs)
 	struct bfa_sgpg_s *hsgpg;
 	int i;
 
-	bfa_trc_fp(bfa, nsgpgs);
-
 	if (mod->free_sgpgs < nsgpgs)
 		return BFA_STATUS_ENOMEM;
 
@@ -4691,8 +4689,6 @@ bfa_sgpg_mfree(struct bfa_s *bfa, struct list_head *sgpg_q, int nsgpg)
 	struct bfa_sgpg_mod_s *mod = BFA_SGPG_MOD(bfa);
 	struct bfa_sgpg_wqe_s *wqe;
 
-	bfa_trc_fp(bfa, nsgpg);
-
 	mod->free_sgpgs += nsgpg;
 	WARN_ON(mod->free_sgpgs > mod->num_sgpgs);
 
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 4e94d28..44524cf 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1166,7 +1166,6 @@ bfad_intx(int irq, void *dev_id)
 		spin_lock_irqsave(&bfad->bfad_lock, flags);
 		bfa_comp_free(&bfad->bfa, &doneq);
 		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
-		bfa_trc_fp(bfad, irq);
 	}
 
 	return IRQ_HANDLED;
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index f0bcda8..c2b3617 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -1174,7 +1174,6 @@ bfad_im_queuecommand_lck(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd
 	}
 
 	cmnd->host_scribble = (char *)hal_io;
-	bfa_trc_fp(bfad, hal_io->iotag);
 	bfa_ioim_start(hal_io);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 
-- 
1.6.5.2

