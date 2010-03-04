From: <kgudipat@brocade.com>
Subject: [PATCH 21/32] bfa: Fix Command Queue (CPE) full condition check and ack CPE interrupt.
Date: Wed, 3 Mar 2010 17:46:23 -0800
Message-ID: <1267667183-27291-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:33973 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360Ab0CDBqc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2010 20:46:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:

	- Fixed the issue of not acknowledging the command queue full-to-non-full interrupt.
	  Implemented separate acknowledging functions for different ASIC and interrupt mode.

	- Fixed the case of missing CPE interrupt by always processing the pending requests
	  in the completion path.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_hw_cb.c |   13 ++++++++
 drivers/scsi/bfa/bfa_hw_ct.c |    9 +++++
 drivers/scsi/bfa/bfa_intr.c  |   71 +++++++++++++++++++++++++++--------------
 drivers/scsi/bfa/bfa_iocfc.c |    2 +
 drivers/scsi/bfa/bfa_iocfc.h |    3 ++
 5 files changed, 74 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_hw_cb.c b/drivers/scsi/bfa/bfa_hw_cb.c
index ede1438..871a4e2 100644
--- a/drivers/scsi/bfa/bfa_hw_cb.c
+++ b/drivers/scsi/bfa/bfa_hw_cb.c
@@ -53,6 +53,18 @@ bfa_hwcb_reginit(struct bfa_s *bfa)
 }
 
 void
+bfa_hwcb_reqq_ack(struct bfa_s *bfa, int reqq)
+{
+}
+
+static void
+bfa_hwcb_reqq_ack_msix(struct bfa_s *bfa, int reqq)
+{
+	bfa_reg_write(bfa->iocfc.bfa_regs.intr_status,
+		__HFN_INT_CPE_Q0 << CPE_Q_NUM(bfa_ioc_pcifn(&bfa->ioc), reqq));
+}
+
+void
 bfa_hwcb_rspq_ack(struct bfa_s *bfa, int rspq)
 {
 }
@@ -136,6 +148,7 @@ bfa_hwcb_msix_uninstall(struct bfa_s *bfa)
 void
 bfa_hwcb_isr_mode_set(struct bfa_s *bfa, bfa_boolean_t msix)
 {
+	bfa->iocfc.hwif.hw_reqq_ack = bfa_hwcb_reqq_ack_msix;
 	bfa->iocfc.hwif.hw_rspq_ack = bfa_hwcb_rspq_ack_msix;
 }
 
diff --git a/drivers/scsi/bfa/bfa_hw_ct.c b/drivers/scsi/bfa/bfa_hw_ct.c
index 51ae574..76ceb9a 100644
--- a/drivers/scsi/bfa/bfa_hw_ct.c
+++ b/drivers/scsi/bfa/bfa_hw_ct.c
@@ -85,6 +85,15 @@ bfa_hwct_reginit(struct bfa_s *bfa)
 }
 
 void
+bfa_hwct_reqq_ack(struct bfa_s *bfa, int reqq)
+{
+	u32 r32;
+
+	r32 = bfa_reg_read(bfa->iocfc.bfa_regs.cpe_q_ctrl[reqq]);
+	bfa_reg_write(bfa->iocfc.bfa_regs.cpe_q_ctrl[reqq], r32);
+}
+
+void
 bfa_hwct_rspq_ack(struct bfa_s *bfa, int rspq)
 {
 	u32	r32;
diff --git a/drivers/scsi/bfa/bfa_intr.c b/drivers/scsi/bfa/bfa_intr.c
index c422546..0eba3f9 100644
--- a/drivers/scsi/bfa/bfa_intr.c
+++ b/drivers/scsi/bfa/bfa_intr.c
@@ -34,6 +34,26 @@ bfa_msix_lpu(struct bfa_s *bfa)
 	bfa_ioc_mbox_isr(&bfa->ioc);
 }
 
+static void
+bfa_reqq_resume(struct bfa_s *bfa, int qid)
+{
+	struct list_head *waitq, *qe, *qen;
+	struct bfa_reqq_wait_s *wqe;
+
+	waitq = bfa_reqq(bfa, qid);
+	list_for_each_safe(qe, qen, waitq) {
+		/**
+		 * Callback only as long as there is room in request queue
+		 */
+		if (bfa_reqq_full(bfa, qid))
+			break;
+
+		list_del(qe);
+		wqe = (struct bfa_reqq_wait_s *) qe;
+		wqe->qresume(wqe->cbarg);
+	}
+}
+
 void
 bfa_msix_all(struct bfa_s *bfa, int vec)
 {
@@ -128,23 +148,18 @@ bfa_isr_disable(struct bfa_s *bfa)
 void
 bfa_msix_reqq(struct bfa_s *bfa, int qid)
 {
-	struct list_head 		*waitq, *qe, *qen;
-	struct bfa_reqq_wait_s	*wqe;
+	struct list_head *waitq;
 
 	qid &= (BFI_IOC_MAX_CQS - 1);
 
-	waitq = bfa_reqq(bfa, qid);
-	list_for_each_safe(qe, qen, waitq) {
-		/**
-		 * Callback only as long as there is room in request queue
-		 */
-		if (bfa_reqq_full(bfa, qid))
-			break;
+	bfa->iocfc.hwif.hw_reqq_ack(bfa, qid);
 
-		list_del(qe);
-		wqe = (struct bfa_reqq_wait_s *) qe;
-		wqe->qresume(wqe->cbarg);
-	}
+	/**
+	 * Resume any pending requests in the corresponding reqq.
+	 */
+	waitq = bfa_reqq(bfa, qid);
+	if (!list_empty(waitq))
+		bfa_reqq_resume(bfa, qid);
 }
 
 void
@@ -158,26 +173,27 @@ bfa_isr_unhandled(struct bfa_s *bfa, struct bfi_msg_s *m)
 }
 
 void
-bfa_msix_rspq(struct bfa_s *bfa, int rsp_qid)
+bfa_msix_rspq(struct bfa_s *bfa, int qid)
 {
-	struct bfi_msg_s      *m;
-	u32        pi, ci;
+	struct bfi_msg_s *m;
+	u32 pi, ci;
+	struct list_head *waitq;
 
-	bfa_trc_fp(bfa, rsp_qid);
+	bfa_trc_fp(bfa, qid);
 
-	rsp_qid &= (BFI_IOC_MAX_CQS - 1);
+	qid &= (BFI_IOC_MAX_CQS - 1);
 
-	bfa->iocfc.hwif.hw_rspq_ack(bfa, rsp_qid);
+	bfa->iocfc.hwif.hw_rspq_ack(bfa, qid);
 
-	ci = bfa_rspq_ci(bfa, rsp_qid);
-	pi = bfa_rspq_pi(bfa, rsp_qid);
+	ci = bfa_rspq_ci(bfa, qid);
+	pi = bfa_rspq_pi(bfa, qid);
 
 	bfa_trc_fp(bfa, ci);
 	bfa_trc_fp(bfa, pi);
 
 	if (bfa->rme_process) {
 		while (ci != pi) {
-			m = bfa_rspq_elem(bfa, rsp_qid, ci);
+			m = bfa_rspq_elem(bfa, qid, ci);
 			bfa_assert_fp(m->mhdr.msg_class < BFI_MC_MAX);
 
 			bfa_isrs[m->mhdr.msg_class] (bfa, m);
@@ -189,9 +205,16 @@ bfa_msix_rspq(struct bfa_s *bfa, int rsp_qid)
 	/**
 	 * update CI
 	 */
-	bfa_rspq_ci(bfa, rsp_qid) = pi;
-	bfa_reg_write(bfa->iocfc.bfa_regs.rme_q_ci[rsp_qid], pi);
+	bfa_rspq_ci(bfa, qid) = pi;
+	bfa_reg_write(bfa->iocfc.bfa_regs.rme_q_ci[qid], pi);
 	bfa_os_mmiowb();
+
+	/**
+	 * Resume any pending requests in the corresponding reqq.
+	 */
+	waitq = bfa_reqq(bfa, qid);
+	if (!list_empty(waitq))
+		bfa_reqq_resume(bfa, qid);
 }
 
 void
diff --git a/drivers/scsi/bfa/bfa_iocfc.c b/drivers/scsi/bfa/bfa_iocfc.c
index 137591c..a5551db 100644
--- a/drivers/scsi/bfa/bfa_iocfc.c
+++ b/drivers/scsi/bfa/bfa_iocfc.c
@@ -172,6 +172,7 @@ bfa_iocfc_init_mem(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	 */
 	if (bfa_ioc_devid(&bfa->ioc) == BFA_PCI_DEVICE_ID_CT) {
 		iocfc->hwif.hw_reginit = bfa_hwct_reginit;
+		iocfc->hwif.hw_reqq_ack = bfa_hwct_reqq_ack;
 		iocfc->hwif.hw_rspq_ack = bfa_hwct_rspq_ack;
 		iocfc->hwif.hw_msix_init = bfa_hwct_msix_init;
 		iocfc->hwif.hw_msix_install = bfa_hwct_msix_install;
@@ -180,6 +181,7 @@ bfa_iocfc_init_mem(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 		iocfc->hwif.hw_msix_getvecs = bfa_hwct_msix_getvecs;
 	} else {
 		iocfc->hwif.hw_reginit = bfa_hwcb_reginit;
+		iocfc->hwif.hw_reqq_ack = bfa_hwcb_reqq_ack;
 		iocfc->hwif.hw_rspq_ack = bfa_hwcb_rspq_ack;
 		iocfc->hwif.hw_msix_init = bfa_hwcb_msix_init;
 		iocfc->hwif.hw_msix_install = bfa_hwcb_msix_install;
diff --git a/drivers/scsi/bfa/bfa_iocfc.h b/drivers/scsi/bfa/bfa_iocfc.h
index ce9a830..fbb4bdc 100644
--- a/drivers/scsi/bfa/bfa_iocfc.h
+++ b/drivers/scsi/bfa/bfa_iocfc.h
@@ -54,6 +54,7 @@ struct bfa_msix_s {
  */
 struct bfa_hwif_s {
 	void (*hw_reginit)(struct bfa_s *bfa);
+	void (*hw_reqq_ack)(struct bfa_s *bfa, int reqq);
 	void (*hw_rspq_ack)(struct bfa_s *bfa, int rspq);
 	void (*hw_msix_init)(struct bfa_s *bfa, int nvecs);
 	void (*hw_msix_install)(struct bfa_s *bfa);
@@ -143,6 +144,7 @@ void bfa_msix_rspq(struct bfa_s *bfa, int vec);
 void bfa_msix_lpu_err(struct bfa_s *bfa, int vec);
 
 void bfa_hwcb_reginit(struct bfa_s *bfa);
+void bfa_hwcb_reqq_ack(struct bfa_s *bfa, int rspq);
 void bfa_hwcb_rspq_ack(struct bfa_s *bfa, int rspq);
 void bfa_hwcb_msix_init(struct bfa_s *bfa, int nvecs);
 void bfa_hwcb_msix_install(struct bfa_s *bfa);
@@ -151,6 +153,7 @@ void bfa_hwcb_isr_mode_set(struct bfa_s *bfa, bfa_boolean_t msix);
 void bfa_hwcb_msix_getvecs(struct bfa_s *bfa, u32 *vecmap,
 			u32 *nvecs, u32 *maxvec);
 void bfa_hwct_reginit(struct bfa_s *bfa);
+void bfa_hwct_reqq_ack(struct bfa_s *bfa, int rspq);
 void bfa_hwct_rspq_ack(struct bfa_s *bfa, int rspq);
 void bfa_hwct_msix_init(struct bfa_s *bfa, int nvecs);
 void bfa_hwct_msix_install(struct bfa_s *bfa);
-- 
1.6.5.3

