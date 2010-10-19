From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 3/6] bfa: remove os wrapper functions and macros
Date: Mon, 18 Oct 2010 17:12:29 -0700
Message-ID: <1287447149-28678-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:43695 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755798Ab0JSAMf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Oct 2010 20:12:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Jing Huang <huangj@brocade.com>

This patch replaces register access functions and macros with the the ones
provided by linux. 

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa.h          |   24 ++++----
 drivers/scsi/bfa/bfa_core.c     |   32 +++++-----
 drivers/scsi/bfa/bfa_hw_cb.c    |   10 ++--
 drivers/scsi/bfa/bfa_hw_ct.c    |   16 +++---
 drivers/scsi/bfa/bfa_ioc.c      |  117 ++++++++++++++++++--------------------
 drivers/scsi/bfa/bfa_ioc.h      |   66 ++++++++++-----------
 drivers/scsi/bfa/bfa_ioc_cb.c   |   64 ++++++++++-----------
 drivers/scsi/bfa/bfa_ioc_ct.c   |  119 +++++++++++++++++++--------------------
 drivers/scsi/bfa/bfa_os_inc.h   |   32 +++--------
 drivers/scsi/bfa/bfad_debugfs.c |    4 +-
 10 files changed, 226 insertions(+), 258 deletions(-)

diff --git a/drivers/scsi/bfa/bfa.h b/drivers/scsi/bfa/bfa.h
index ceaac65..c3981df 100644
--- a/drivers/scsi/bfa/bfa.h
+++ b/drivers/scsi/bfa/bfa.h
@@ -59,8 +59,8 @@ void bfa_isr_bind(enum bfi_mclass mc, bfa_isr_func_t isr_func);
 		(__bfa)->iocfc.req_cq_pi[__reqq]++;			\
 		(__bfa)->iocfc.req_cq_pi[__reqq] &=			\
 			((__bfa)->iocfc.cfg.drvcfg.num_reqq_elems - 1);      \
-		bfa_reg_write((__bfa)->iocfc.bfa_regs.cpe_q_pi[__reqq],	\
-			      (__bfa)->iocfc.req_cq_pi[__reqq]);      \
+		writel((__bfa)->iocfc.req_cq_pi[__reqq], 		\
+			(__bfa)->iocfc.bfa_regs.cpe_q_pi[__reqq]);	\
 		mmiowb();      \
 	} while (0)
 
@@ -202,16 +202,16 @@ struct bfa_meminfo_s {
 	((_m)->meminfo[BFA_MEM_TYPE_DMA - 1].dma_curp)
 
 struct bfa_iocfc_regs_s {
-	bfa_os_addr_t   intr_status;
-	bfa_os_addr_t   intr_mask;
-	bfa_os_addr_t   cpe_q_pi[BFI_IOC_MAX_CQS];
-	bfa_os_addr_t   cpe_q_ci[BFI_IOC_MAX_CQS];
-	bfa_os_addr_t   cpe_q_depth[BFI_IOC_MAX_CQS];
-	bfa_os_addr_t   cpe_q_ctrl[BFI_IOC_MAX_CQS];
-	bfa_os_addr_t   rme_q_ci[BFI_IOC_MAX_CQS];
-	bfa_os_addr_t   rme_q_pi[BFI_IOC_MAX_CQS];
-	bfa_os_addr_t   rme_q_depth[BFI_IOC_MAX_CQS];
-	bfa_os_addr_t   rme_q_ctrl[BFI_IOC_MAX_CQS];
+	void __iomem	*intr_status;
+	void __iomem 	*intr_mask;
+	void __iomem	*cpe_q_pi[BFI_IOC_MAX_CQS];
+	void __iomem	*cpe_q_ci[BFI_IOC_MAX_CQS];
+	void __iomem	*cpe_q_depth[BFI_IOC_MAX_CQS];
+	void __iomem	*cpe_q_ctrl[BFI_IOC_MAX_CQS];
+	void __iomem	*rme_q_ci[BFI_IOC_MAX_CQS];
+	void __iomem	*rme_q_pi[BFI_IOC_MAX_CQS];
+	void __iomem	*rme_q_depth[BFI_IOC_MAX_CQS];
+	void __iomem	*rme_q_ctrl[BFI_IOC_MAX_CQS];
 };
 
 /**
diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 7366924..f75c6be 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -113,7 +113,7 @@ bfa_intx(struct bfa_s *bfa)
 	u32 intr, qintr;
 	int queue;
 
-	intr = bfa_reg_read(bfa->iocfc.bfa_regs.intr_status);
+	intr = readl(bfa->iocfc.bfa_regs.intr_status);
 	if (!intr)
 		return BFA_FALSE;
 
@@ -121,7 +121,7 @@ bfa_intx(struct bfa_s *bfa)
 	 * RME completion queue interrupt
 	 */
 	qintr = intr & __HFN_INT_RME_MASK;
-	bfa_reg_write(bfa->iocfc.bfa_regs.intr_status, qintr);
+	writel(qintr, bfa->iocfc.bfa_regs.intr_status);
 
 	for (queue = 0; queue < BFI_IOC_MAX_CQS_ASIC; queue++) {
 		if (intr & (__HFN_INT_RME_Q0 << queue))
@@ -135,7 +135,7 @@ bfa_intx(struct bfa_s *bfa)
 	 * CPE completion queue interrupt
 	 */
 	qintr = intr & __HFN_INT_CPE_MASK;
-	bfa_reg_write(bfa->iocfc.bfa_regs.intr_status, qintr);
+	writel(qintr, bfa->iocfc.bfa_regs.intr_status);
 
 	for (queue = 0; queue < BFI_IOC_MAX_CQS_ASIC; queue++) {
 		if (intr & (__HFN_INT_CPE_Q0 << queue))
@@ -153,13 +153,13 @@ bfa_intx(struct bfa_s *bfa)
 void
 bfa_intx_enable(struct bfa_s *bfa)
 {
-	bfa_reg_write(bfa->iocfc.bfa_regs.intr_mask, bfa->iocfc.intr_mask);
+	writel(bfa->iocfc.intr_mask, bfa->iocfc.bfa_regs.intr_mask);
 }
 
 void
 bfa_intx_disable(struct bfa_s *bfa)
 {
-	bfa_reg_write(bfa->iocfc.bfa_regs.intr_mask, -1L);
+	writel(-1L, bfa->iocfc.bfa_regs.intr_mask);
 }
 
 void
@@ -188,8 +188,8 @@ bfa_isr_enable(struct bfa_s *bfa)
 				__HFN_INT_RME_Q6 | __HFN_INT_RME_Q7 |
 				__HFN_INT_MBOX_LPU1);
 
-	bfa_reg_write(bfa->iocfc.bfa_regs.intr_status, intr_unmask);
-	bfa_reg_write(bfa->iocfc.bfa_regs.intr_mask, ~intr_unmask);
+	writel(intr_unmask, bfa->iocfc.bfa_regs.intr_status);
+	writel(~intr_unmask, bfa->iocfc.bfa_regs.intr_mask);
 	bfa->iocfc.intr_mask = ~intr_unmask;
 	bfa_isr_mode_set(bfa, bfa->msix.nvecs != 0);
 }
@@ -198,7 +198,7 @@ void
 bfa_isr_disable(struct bfa_s *bfa)
 {
 	bfa_isr_mode_set(bfa, BFA_FALSE);
-	bfa_reg_write(bfa->iocfc.bfa_regs.intr_mask, -1L);
+	writel(-1L, bfa->iocfc.bfa_regs.intr_mask);
 	bfa_msix_uninstall(bfa);
 }
 
@@ -263,7 +263,7 @@ bfa_msix_rspq(struct bfa_s *bfa, int qid)
 	 * update CI
 	 */
 	bfa_rspq_ci(bfa, qid) = pi;
-	bfa_reg_write(bfa->iocfc.bfa_regs.rme_q_ci[qid], pi);
+	writel(pi, bfa->iocfc.bfa_regs.rme_q_ci[qid]);
 	mmiowb();
 
 	/**
@@ -279,7 +279,7 @@ bfa_msix_lpu_err(struct bfa_s *bfa, int vec)
 {
 	u32 intr, curr_value;
 
-	intr = bfa_reg_read(bfa->iocfc.bfa_regs.intr_status);
+	intr = readl(bfa->iocfc.bfa_regs.intr_status);
 
 	if (intr & (__HFN_INT_MBOX_LPU0 | __HFN_INT_MBOX_LPU1))
 		bfa_msix_lpu(bfa);
@@ -294,9 +294,9 @@ bfa_msix_lpu_err(struct bfa_s *bfa, int vec)
 			 * Register needs to be cleared as well so Interrupt
 			 * Status Register will be cleared.
 			 */
-			curr_value = bfa_reg_read(bfa->ioc.ioc_regs.ll_halt);
+			curr_value = readl(bfa->ioc.ioc_regs.ll_halt);
 			curr_value &= ~__FW_INIT_HALT_P;
-			bfa_reg_write(bfa->ioc.ioc_regs.ll_halt, curr_value);
+			writel(curr_value, bfa->ioc.ioc_regs.ll_halt);
 		}
 
 		if (intr & __HFN_INT_ERR_PSS) {
@@ -305,14 +305,14 @@ bfa_msix_lpu_err(struct bfa_s *bfa, int vec)
 			 * interrups are shared so driver's interrupt handler is
 			 * still called eventhough it is already masked out.
 			 */
-			curr_value = bfa_reg_read(
+			curr_value = readl(
 					bfa->ioc.ioc_regs.pss_err_status_reg);
 			curr_value &= __PSS_ERR_STATUS_SET;
-			bfa_reg_write(bfa->ioc.ioc_regs.pss_err_status_reg,
-					curr_value);
+			writel(curr_value,
+				bfa->ioc.ioc_regs.pss_err_status_reg);
 		}
 
-		bfa_reg_write(bfa->iocfc.bfa_regs.intr_status, intr);
+		writel(intr, bfa->iocfc.bfa_regs.intr_status);
 		bfa_msix_errint(bfa, intr);
 	}
 }
diff --git a/drivers/scsi/bfa/bfa_hw_cb.c b/drivers/scsi/bfa/bfa_hw_cb.c
index c787d3a..422e44c 100644
--- a/drivers/scsi/bfa/bfa_hw_cb.c
+++ b/drivers/scsi/bfa/bfa_hw_cb.c
@@ -22,7 +22,7 @@ void
 bfa_hwcb_reginit(struct bfa_s *bfa)
 {
 	struct bfa_iocfc_regs_s	*bfa_regs = &bfa->iocfc.bfa_regs;
-	bfa_os_addr_t		kva = bfa_ioc_bar0(&bfa->ioc);
+	void __iomem *kva = bfa_ioc_bar0(&bfa->ioc);
 	int			i, q, fn = bfa_ioc_pcifn(&bfa->ioc);
 
 	if (fn == 0) {
@@ -60,8 +60,8 @@ bfa_hwcb_reqq_ack(struct bfa_s *bfa, int reqq)
 static void
 bfa_hwcb_reqq_ack_msix(struct bfa_s *bfa, int reqq)
 {
-	bfa_reg_write(bfa->iocfc.bfa_regs.intr_status,
-		__HFN_INT_CPE_Q0 << CPE_Q_NUM(bfa_ioc_pcifn(&bfa->ioc), reqq));
+	writel(__HFN_INT_CPE_Q0 << CPE_Q_NUM(bfa_ioc_pcifn(&bfa->ioc), reqq),
+			bfa->iocfc.bfa_regs.intr_status);
 }
 
 void
@@ -72,8 +72,8 @@ bfa_hwcb_rspq_ack(struct bfa_s *bfa, int rspq)
 static void
 bfa_hwcb_rspq_ack_msix(struct bfa_s *bfa, int rspq)
 {
-	bfa_reg_write(bfa->iocfc.bfa_regs.intr_status,
-		__HFN_INT_RME_Q0 << RME_Q_NUM(bfa_ioc_pcifn(&bfa->ioc), rspq));
+	writel(__HFN_INT_RME_Q0 << RME_Q_NUM(bfa_ioc_pcifn(&bfa->ioc), rspq),
+			bfa->iocfc.bfa_regs.intr_status);
 }
 
 void
diff --git a/drivers/scsi/bfa/bfa_hw_ct.c b/drivers/scsi/bfa/bfa_hw_ct.c
index c97ebaf..81e670e 100644
--- a/drivers/scsi/bfa/bfa_hw_ct.c
+++ b/drivers/scsi/bfa/bfa_hw_ct.c
@@ -31,12 +31,12 @@ static void
 bfa_hwct_msix_lpu_err_set(struct bfa_s *bfa, bfa_boolean_t msix, int vec)
 {
 	int fn = bfa_ioc_pcifn(&bfa->ioc);
-	bfa_os_addr_t kva = bfa_ioc_bar0(&bfa->ioc);
+	void __iomem *kva = bfa_ioc_bar0(&bfa->ioc);
 
 	if (msix)
-		bfa_reg_write(kva + __ct_msix_err_vec_reg[fn], vec);
+		writel(vec, kva + __ct_msix_err_vec_reg[fn]);
 	else
-		bfa_reg_write(kva + __ct_msix_err_vec_reg[fn], 0);
+		writel(0, kva + __ct_msix_err_vec_reg[fn]);
 }
 
 /**
@@ -51,7 +51,7 @@ void
 bfa_hwct_reginit(struct bfa_s *bfa)
 {
 	struct bfa_iocfc_regs_s	*bfa_regs = &bfa->iocfc.bfa_regs;
-	bfa_os_addr_t		kva = bfa_ioc_bar0(&bfa->ioc);
+	void __iomem *kva = bfa_ioc_bar0(&bfa->ioc);
 	int			i, q, fn = bfa_ioc_pcifn(&bfa->ioc);
 
 	if (fn == 0) {
@@ -88,8 +88,8 @@ bfa_hwct_reqq_ack(struct bfa_s *bfa, int reqq)
 {
 	u32	r32;
 
-	r32 = bfa_reg_read(bfa->iocfc.bfa_regs.cpe_q_ctrl[reqq]);
-	bfa_reg_write(bfa->iocfc.bfa_regs.cpe_q_ctrl[reqq], r32);
+	r32 = readl(bfa->iocfc.bfa_regs.cpe_q_ctrl[reqq]);
+	writel(r32, bfa->iocfc.bfa_regs.cpe_q_ctrl[reqq]);
 }
 
 void
@@ -97,8 +97,8 @@ bfa_hwct_rspq_ack(struct bfa_s *bfa, int rspq)
 {
 	u32	r32;
 
-	r32 = bfa_reg_read(bfa->iocfc.bfa_regs.rme_q_ctrl[rspq]);
-	bfa_reg_write(bfa->iocfc.bfa_regs.rme_q_ctrl[rspq], r32);
+	r32 = readl(bfa->iocfc.bfa_regs.rme_q_ctrl[rspq]);
+	writel(r32, bfa->iocfc.bfa_regs.rme_q_ctrl[rspq]);
 }
 
 void
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 8d3bf40..fddab88 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -73,7 +73,7 @@ BFA_TRC_FILE(CNA, IOC);
 
 #define bfa_ioc_mbox_cmd_pending(__ioc)		\
 			(!list_empty(&((__ioc)->mbox_mod.cmd_q)) || \
-			bfa_reg_read((__ioc)->ioc_regs.hfn_mbox_cmd))
+			readl((__ioc)->ioc_regs.hfn_mbox_cmd))
 
 bfa_boolean_t bfa_auto_recover = BFA_TRUE;
 
@@ -866,8 +866,7 @@ bfa_iocpf_sm_enabling(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 	case IOCPF_E_TIMEOUT:
 		iocpf->retry_count++;
 		if (iocpf->retry_count < BFA_IOC_HWINIT_MAX) {
-			bfa_reg_write(ioc->ioc_regs.ioc_fwstate,
-				      BFI_IOC_UNINIT);
+			writel(BFI_IOC_UNINIT, ioc->ioc_regs.ioc_fwstate);
 			bfa_fsm_set_state(iocpf, bfa_iocpf_sm_hwinit);
 			break;
 		}
@@ -968,7 +967,7 @@ bfa_iocpf_sm_disabling(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 		 */
 
 	case IOCPF_E_TIMEOUT:
-		bfa_reg_write(ioc->ioc_regs.ioc_fwstate, BFI_IOC_FAIL);
+		writel(BFI_IOC_FAIL, ioc->ioc_regs.ioc_fwstate);
 		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_disabled);
 		break;
 
@@ -1057,7 +1056,7 @@ bfa_iocpf_sm_fail_entry(struct bfa_iocpf_s *iocpf)
 	 * Mark IOC as failed in hardware and stop firmware.
 	 */
 	bfa_ioc_lpu_stop(iocpf->ioc);
-	bfa_reg_write(iocpf->ioc->ioc_regs.ioc_fwstate, BFI_IOC_FAIL);
+	writel(BFI_IOC_FAIL, iocpf->ioc->ioc_regs.ioc_fwstate);
 
 	/**
 	 * Notify other functions on HB failure.
@@ -1123,18 +1122,18 @@ bfa_ioc_disable_comp(struct bfa_ioc_s *ioc)
 }
 
 bfa_boolean_t
-bfa_ioc_sem_get(bfa_os_addr_t sem_reg)
+bfa_ioc_sem_get(void __iomem *sem_reg)
 {
 	u32 r32;
 	int cnt = 0;
 #define BFA_SEM_SPINCNT	3000
 
-	r32 = bfa_reg_read(sem_reg);
+	r32 = readl(sem_reg);
 
 	while (r32 && (cnt < BFA_SEM_SPINCNT)) {
 		cnt++;
 		udelay(2);
-		r32 = bfa_reg_read(sem_reg);
+		r32 = readl(sem_reg);
 	}
 
 	if (r32 == 0)
@@ -1145,9 +1144,9 @@ bfa_ioc_sem_get(bfa_os_addr_t sem_reg)
 }
 
 void
-bfa_ioc_sem_release(bfa_os_addr_t sem_reg)
+bfa_ioc_sem_release(void __iomem *sem_reg)
 {
-	bfa_reg_write(sem_reg, 1);
+	writel(1, sem_reg);
 }
 
 static void
@@ -1159,7 +1158,7 @@ bfa_ioc_hw_sem_get(struct bfa_ioc_s *ioc)
 	 * First read to the semaphore register will return 0, subsequent reads
 	 * will return 1. Semaphore is released by writing 1 to the register
 	 */
-	r32 = bfa_reg_read(ioc->ioc_regs.ioc_sem_reg);
+	r32 = readl(ioc->ioc_regs.ioc_sem_reg);
 	if (r32 == 0) {
 		bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_SEMLOCKED);
 		return;
@@ -1171,7 +1170,7 @@ bfa_ioc_hw_sem_get(struct bfa_ioc_s *ioc)
 void
 bfa_ioc_hw_sem_release(struct bfa_ioc_s *ioc)
 {
-	bfa_reg_write(ioc->ioc_regs.ioc_sem_reg, 1);
+	writel(1, ioc->ioc_regs.ioc_sem_reg);
 }
 
 static void
@@ -1190,7 +1189,7 @@ bfa_ioc_lmem_init(struct bfa_ioc_s *ioc)
 	int		i;
 #define PSS_LMEM_INIT_TIME  10000
 
-	pss_ctl = bfa_reg_read(ioc->ioc_regs.pss_ctl_reg);
+	pss_ctl = readl(ioc->ioc_regs.pss_ctl_reg);
 	pss_ctl &= ~__PSS_LMEM_RESET;
 	pss_ctl |= __PSS_LMEM_INIT_EN;
 
@@ -1198,14 +1197,14 @@ bfa_ioc_lmem_init(struct bfa_ioc_s *ioc)
 	 * i2c workaround 12.5khz clock
 	 */
 	pss_ctl |= __PSS_I2C_CLK_DIV(3UL);
-	bfa_reg_write(ioc->ioc_regs.pss_ctl_reg, pss_ctl);
+	writel(pss_ctl, ioc->ioc_regs.pss_ctl_reg);
 
 	/**
 	 * wait for memory initialization to be complete
 	 */
 	i = 0;
 	do {
-		pss_ctl = bfa_reg_read(ioc->ioc_regs.pss_ctl_reg);
+		pss_ctl = readl(ioc->ioc_regs.pss_ctl_reg);
 		i++;
 	} while (!(pss_ctl & __PSS_LMEM_INIT_DONE) && (i < PSS_LMEM_INIT_TIME));
 
@@ -1217,7 +1216,7 @@ bfa_ioc_lmem_init(struct bfa_ioc_s *ioc)
 	bfa_trc(ioc, pss_ctl);
 
 	pss_ctl &= ~(__PSS_LMEM_INIT_DONE | __PSS_LMEM_INIT_EN);
-	bfa_reg_write(ioc->ioc_regs.pss_ctl_reg, pss_ctl);
+	writel(pss_ctl, ioc->ioc_regs.pss_ctl_reg);
 }
 
 static void
@@ -1228,10 +1227,10 @@ bfa_ioc_lpu_start(struct bfa_ioc_s *ioc)
 	/**
 	 * Take processor out of reset.
 	 */
-	pss_ctl = bfa_reg_read(ioc->ioc_regs.pss_ctl_reg);
+	pss_ctl = readl(ioc->ioc_regs.pss_ctl_reg);
 	pss_ctl &= ~__PSS_LPU0_RESET;
 
-	bfa_reg_write(ioc->ioc_regs.pss_ctl_reg, pss_ctl);
+	writel(pss_ctl, ioc->ioc_regs.pss_ctl_reg);
 }
 
 static void
@@ -1242,10 +1241,10 @@ bfa_ioc_lpu_stop(struct bfa_ioc_s *ioc)
 	/**
 	 * Put processors in reset.
 	 */
-	pss_ctl = bfa_reg_read(ioc->ioc_regs.pss_ctl_reg);
+	pss_ctl = readl(ioc->ioc_regs.pss_ctl_reg);
 	pss_ctl |= (__PSS_LPU0_RESET | __PSS_LPU1_RESET);
 
-	bfa_reg_write(ioc->ioc_regs.pss_ctl_reg, pss_ctl);
+	writel(pss_ctl, ioc->ioc_regs.pss_ctl_reg);
 }
 
 /**
@@ -1261,7 +1260,7 @@ bfa_ioc_fwver_get(struct bfa_ioc_s *ioc, struct bfi_ioc_image_hdr_s *fwhdr)
 
 	pgnum = bfa_ioc_smem_pgnum(ioc, loff);
 	pgoff = bfa_ioc_smem_pgoff(ioc, loff);
-	bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
+	writel(pgnum, ioc->ioc_regs.host_page_num_fn);
 
 	for (i = 0; i < (sizeof(struct bfi_ioc_image_hdr_s) / sizeof(u32));
 	     i++) {
@@ -1321,7 +1320,7 @@ bfa_ioc_fwver_valid(struct bfa_ioc_s *ioc, u32 boot_env)
 		return BFA_FALSE;
 	}
 
-	if (bfa_os_swap32(fwhdr.param) != boot_env) {
+	if (swab32(fwhdr.param) != boot_env) {
 		bfa_trc(ioc, fwhdr.param);
 		bfa_trc(ioc, boot_env);
 		return BFA_FALSE;
@@ -1338,9 +1337,9 @@ bfa_ioc_msgflush(struct bfa_ioc_s *ioc)
 {
 	u32	r32;
 
-	r32 = bfa_reg_read(ioc->ioc_regs.lpu_mbox_cmd);
+	r32 = readl(ioc->ioc_regs.lpu_mbox_cmd);
 	if (r32)
-		bfa_reg_write(ioc->ioc_regs.lpu_mbox_cmd, 1);
+		writel(1, ioc->ioc_regs.lpu_mbox_cmd);
 }
 
 
@@ -1352,7 +1351,7 @@ bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force)
 	u32 boot_type;
 	u32 boot_env;
 
-	ioc_fwstate = bfa_reg_read(ioc->ioc_regs.ioc_fwstate);
+	ioc_fwstate = readl(ioc->ioc_regs.ioc_fwstate);
 
 	if (force)
 		ioc_fwstate = BFI_IOC_UNINIT;
@@ -1449,17 +1448,17 @@ bfa_ioc_mbox_send(struct bfa_ioc_s *ioc, void *ioc_msg, int len)
 	 * first write msg to mailbox registers
 	 */
 	for (i = 0; i < len / sizeof(u32); i++)
-		bfa_reg_write(ioc->ioc_regs.hfn_mbox + i * sizeof(u32),
-			      cpu_to_le32(msgp[i]));
+		writel(cpu_to_le32(msgp[i]),
+			ioc->ioc_regs.hfn_mbox + i * sizeof(u32));
 
 	for (; i < BFI_IOC_MSGLEN_MAX / sizeof(u32); i++)
-		bfa_reg_write(ioc->ioc_regs.hfn_mbox + i * sizeof(u32), 0);
+		writel(0, ioc->ioc_regs.hfn_mbox + i * sizeof(u32));
 
 	/*
 	 * write 1 to mailbox CMD to trigger LPU event
 	 */
-	bfa_reg_write(ioc->ioc_regs.hfn_mbox_cmd, 1);
-	(void) bfa_reg_read(ioc->ioc_regs.hfn_mbox_cmd);
+	writel(1, ioc->ioc_regs.hfn_mbox_cmd);
+	(void) readl(ioc->ioc_regs.hfn_mbox_cmd);
 }
 
 static void
@@ -1503,7 +1502,7 @@ bfa_ioc_hb_check(void *cbarg)
 	struct bfa_ioc_s  *ioc = cbarg;
 	u32	hb_count;
 
-	hb_count = bfa_reg_read(ioc->ioc_regs.heartbeat);
+	hb_count = readl(ioc->ioc_regs.heartbeat);
 	if (ioc->hb_count == hb_count) {
 		printk(KERN_CRIT "Firmware heartbeat failure at %d", hb_count);
 		bfa_ioc_recover(ioc);
@@ -1519,7 +1518,7 @@ bfa_ioc_hb_check(void *cbarg)
 static void
 bfa_ioc_hb_monitor(struct bfa_ioc_s *ioc)
 {
-	ioc->hb_count = bfa_reg_read(ioc->ioc_regs.heartbeat);
+	ioc->hb_count = readl(ioc->ioc_regs.heartbeat);
 	bfa_hb_timer_start(ioc);
 }
 
@@ -1554,7 +1553,7 @@ bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,
 	pgnum = bfa_ioc_smem_pgnum(ioc, loff);
 	pgoff = bfa_ioc_smem_pgoff(ioc, loff);
 
-	bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
+	writel(pgnum, ioc->ioc_regs.host_page_num_fn);
 
 	for (i = 0; i < bfa_cb_image_get_size(BFA_IOC_FWIMG_TYPE(ioc)); i++) {
 
@@ -1578,21 +1577,19 @@ bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,
 		loff = PSS_SMEM_PGOFF(loff);
 		if (loff == 0) {
 			pgnum++;
-			bfa_reg_write(ioc->ioc_regs.host_page_num_fn,
-				      pgnum);
+			writel(pgnum, ioc->ioc_regs.host_page_num_fn);
 		}
 	}
 
-	bfa_reg_write(ioc->ioc_regs.host_page_num_fn,
-		      bfa_ioc_smem_pgnum(ioc, 0));
+	writel(bfa_ioc_smem_pgnum(ioc, 0), ioc->ioc_regs.host_page_num_fn);
 
 	/*
 	 * Set boot type and boot param at the end.
 	*/
 	bfa_mem_write(ioc->ioc_regs.smem_page_start, BFI_BOOT_TYPE_OFF,
-			bfa_os_swap32(boot_type));
+			swab32(boot_type));
 	bfa_mem_write(ioc->ioc_regs.smem_page_start, BFI_BOOT_LOADER_OFF,
-			bfa_os_swap32(boot_env));
+			swab32(boot_env));
 }
 
 static void
@@ -1651,7 +1648,7 @@ bfa_ioc_mbox_poll(struct bfa_ioc_s *ioc)
 	/**
 	 * If previous command is not yet fetched by firmware, do nothing
 	 */
-	stat = bfa_reg_read(ioc->ioc_regs.hfn_mbox_cmd);
+	stat = readl(ioc->ioc_regs.hfn_mbox_cmd);
 	if (stat)
 		return;
 
@@ -1704,7 +1701,7 @@ bfa_ioc_smem_read(struct bfa_ioc_s *ioc, void *tbuf, u32 soff, u32 sz)
 		return BFA_STATUS_FAILED;
 	}
 
-	bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
+	writel(pgnum, ioc->ioc_regs.host_page_num_fn);
 
 	len = sz/sizeof(u32);
 	bfa_trc(ioc, len);
@@ -1719,11 +1716,10 @@ bfa_ioc_smem_read(struct bfa_ioc_s *ioc, void *tbuf, u32 soff, u32 sz)
 		loff = PSS_SMEM_PGOFF(loff);
 		if (loff == 0) {
 			pgnum++;
-			bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
+			writel(pgnum, ioc->ioc_regs.host_page_num_fn);
 		}
 	}
-	bfa_reg_write(ioc->ioc_regs.host_page_num_fn,
-		      bfa_ioc_smem_pgnum(ioc, 0));
+	writel(bfa_ioc_smem_pgnum(ioc, 0), ioc->ioc_regs.host_page_num_fn);
 	/*
 	 *  release semaphore.
 	 */
@@ -1760,7 +1756,7 @@ bfa_ioc_smem_clr(struct bfa_ioc_s *ioc, u32 soff, u32 sz)
 		return BFA_STATUS_FAILED;
 	}
 
-	bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
+	writel(pgnum, ioc->ioc_regs.host_page_num_fn);
 
 	len = sz/sizeof(u32); /* len in words */
 	bfa_trc(ioc, len);
@@ -1774,11 +1770,10 @@ bfa_ioc_smem_clr(struct bfa_ioc_s *ioc, u32 soff, u32 sz)
 		loff = PSS_SMEM_PGOFF(loff);
 		if (loff == 0) {
 			pgnum++;
-			bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
+			writel(pgnum, ioc->ioc_regs.host_page_num_fn);
 		}
 	}
-	bfa_reg_write(ioc->ioc_regs.host_page_num_fn,
-		      bfa_ioc_smem_pgnum(ioc, 0));
+	writel(bfa_ioc_smem_pgnum(ioc, 0), ioc->ioc_regs.host_page_num_fn);
 
 	/*
 	 *  release semaphore.
@@ -1855,7 +1850,7 @@ bfa_ioc_pll_init(struct bfa_ioc_s *ioc)
 void
 bfa_ioc_boot(struct bfa_ioc_s *ioc, u32 boot_type, u32 boot_env)
 {
-	bfa_os_addr_t	rb;
+	void __iomem *rb;
 
 	bfa_ioc_stats(ioc, ioc_boots);
 
@@ -1867,11 +1862,11 @@ bfa_ioc_boot(struct bfa_ioc_s *ioc, u32 boot_type, u32 boot_env)
 	 */
 	rb = ioc->pcidev.pci_bar_kva;
 	if (boot_type == BFI_BOOT_TYPE_MEMTEST) {
-		bfa_reg_write((rb + BFA_IOC0_STATE_REG), BFI_IOC_MEMTEST);
-		bfa_reg_write((rb + BFA_IOC1_STATE_REG), BFI_IOC_MEMTEST);
+		writel(BFI_IOC_MEMTEST, (rb + BFA_IOC0_STATE_REG));
+		writel(BFI_IOC_MEMTEST, (rb + BFA_IOC1_STATE_REG));
 	} else {
-		bfa_reg_write((rb + BFA_IOC0_STATE_REG), BFI_IOC_INITING);
-		bfa_reg_write((rb + BFA_IOC1_STATE_REG), BFI_IOC_INITING);
+		writel(BFI_IOC_INITING, (rb + BFA_IOC0_STATE_REG));
+		writel(BFI_IOC_INITING, (rb + BFA_IOC1_STATE_REG));
 	}
 
 	bfa_ioc_msgflush(ioc);
@@ -1904,7 +1899,7 @@ bfa_ioc_is_operational(struct bfa_ioc_s *ioc)
 bfa_boolean_t
 bfa_ioc_is_initialized(struct bfa_ioc_s *ioc)
 {
-	u32 r32 = bfa_reg_read(ioc->ioc_regs.ioc_fwstate);
+	u32 r32 = readl(ioc->ioc_regs.ioc_fwstate);
 
 	return ((r32 != BFI_IOC_UNINIT) &&
 		(r32 != BFI_IOC_INITING) &&
@@ -1923,7 +1918,7 @@ bfa_ioc_msgget(struct bfa_ioc_s *ioc, void *mbmsg)
 	 */
 	for (i = 0; i < (sizeof(union bfi_ioc_i2h_msg_u) / sizeof(u32));
 	     i++) {
-		r32 = bfa_reg_read(ioc->ioc_regs.lpu_mbox +
+		r32 = readl(ioc->ioc_regs.lpu_mbox +
 				   i * sizeof(u32));
 		msgp[i] = cpu_to_be32(r32);
 	}
@@ -1931,8 +1926,8 @@ bfa_ioc_msgget(struct bfa_ioc_s *ioc, void *mbmsg)
 	/**
 	 * turn off mailbox interrupt by clearing mailbox status
 	 */
-	bfa_reg_write(ioc->ioc_regs.lpu_mbox_cmd, 1);
-	bfa_reg_read(ioc->ioc_regs.lpu_mbox_cmd);
+	writel(1, ioc->ioc_regs.lpu_mbox_cmd);
+	readl(ioc->ioc_regs.lpu_mbox_cmd);
 }
 
 void
@@ -2162,7 +2157,7 @@ bfa_ioc_mbox_queue(struct bfa_ioc_s *ioc, struct bfa_mbox_cmd_s *cmd)
 	/**
 	 * If mailbox is busy, queue command for poll timer
 	 */
-	stat = bfa_reg_read(ioc->ioc_regs.hfn_mbox_cmd);
+	stat = readl(ioc->ioc_regs.hfn_mbox_cmd);
 	if (stat) {
 		list_add_tail(&cmd->qe, &mod->cmd_q);
 		return;
@@ -2251,17 +2246,17 @@ bfa_boolean_t
 bfa_ioc_adapter_is_disabled(struct bfa_ioc_s *ioc)
 {
 	u32	ioc_state;
-	bfa_os_addr_t	rb = ioc->pcidev.pci_bar_kva;
+	void __iomem *rb = ioc->pcidev.pci_bar_kva;
 
 	if (!bfa_fsm_cmp_state(ioc, bfa_ioc_sm_disabled))
 		return BFA_FALSE;
 
-	ioc_state = bfa_reg_read(rb + BFA_IOC0_STATE_REG);
+	ioc_state = readl(rb + BFA_IOC0_STATE_REG);
 	if (!bfa_ioc_state_disabled(ioc_state))
 		return BFA_FALSE;
 
 	if (ioc->pcidev.device_id != BFA_PCI_DEVICE_ID_FC_8G1P) {
-		ioc_state = bfa_reg_read(rb + BFA_IOC1_STATE_REG);
+		ioc_state = readl(rb + BFA_IOC1_STATE_REG);
 		if (!bfa_ioc_state_disabled(ioc_state))
 			return BFA_FALSE;
 	}
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index 71c0b5a..d60e472 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -62,9 +62,9 @@ struct bfa_sge_s {
 };
 
 #define bfa_sge_word_swap(__sge) do {					     \
-	((u32 *)(__sge))[0] = bfa_os_swap32(((u32 *)(__sge))[0]);      \
-	((u32 *)(__sge))[1] = bfa_os_swap32(((u32 *)(__sge))[1]);      \
-	((u32 *)(__sge))[2] = bfa_os_swap32(((u32 *)(__sge))[2]);      \
+	((u32 *)(__sge))[0] = swab32(((u32 *)(__sge))[0]);      \
+	((u32 *)(__sge))[1] = swab32(((u32 *)(__sge))[1]);      \
+	((u32 *)(__sge))[2] = swab32(((u32 *)(__sge))[2]);      \
 } while (0)
 
 #define bfa_swap_words(_x)  (	\
@@ -87,7 +87,7 @@ struct bfa_pcidev_s {
 	int		pci_slot;
 	u8		pci_func;
 	u16	device_id;
-	bfa_os_addr_t   pci_bar_kva;
+	void __iomem 	*pci_bar_kva;
 };
 
 /**
@@ -130,34 +130,32 @@ __bfa_dma_be_addr_set(union bfi_addr_u *dma_addr, u64 pa)
 }
 
 struct bfa_ioc_regs_s {
-	bfa_os_addr_t   hfn_mbox_cmd;
-	bfa_os_addr_t   hfn_mbox;
-	bfa_os_addr_t   lpu_mbox_cmd;
-	bfa_os_addr_t   lpu_mbox;
-	bfa_os_addr_t   pss_ctl_reg;
-	bfa_os_addr_t   pss_err_status_reg;
-	bfa_os_addr_t   app_pll_fast_ctl_reg;
-	bfa_os_addr_t   app_pll_slow_ctl_reg;
-	bfa_os_addr_t   ioc_sem_reg;
-	bfa_os_addr_t   ioc_usage_sem_reg;
-	bfa_os_addr_t   ioc_init_sem_reg;
-	bfa_os_addr_t   ioc_usage_reg;
-	bfa_os_addr_t   host_page_num_fn;
-	bfa_os_addr_t   heartbeat;
-	bfa_os_addr_t   ioc_fwstate;
-	bfa_os_addr_t   ll_halt;
-	bfa_os_addr_t   err_set;
-	bfa_os_addr_t   shirq_isr_next;
-	bfa_os_addr_t   shirq_msk_next;
-	bfa_os_addr_t   smem_page_start;
+	void __iomem *hfn_mbox_cmd;
+	void __iomem *hfn_mbox;
+	void __iomem *lpu_mbox_cmd;
+	void __iomem *lpu_mbox;
+	void __iomem *pss_ctl_reg;
+	void __iomem *pss_err_status_reg;
+	void __iomem *app_pll_fast_ctl_reg;
+	void __iomem *app_pll_slow_ctl_reg;
+	void __iomem *ioc_sem_reg;
+	void __iomem *ioc_usage_sem_reg;
+	void __iomem *ioc_init_sem_reg;
+	void __iomem *ioc_usage_reg;
+	void __iomem *host_page_num_fn;
+	void __iomem *heartbeat;
+	void __iomem *ioc_fwstate;
+	void __iomem *ll_halt;
+	void __iomem *err_set;
+	void __iomem *shirq_isr_next;
+	void __iomem *shirq_msk_next;
+	void __iomem *smem_page_start;
 	u32	smem_pg0;
 };
 
-#define bfa_reg_read(_raddr)	bfa_os_reg_read(_raddr)
-#define bfa_reg_write(_raddr, _val)	bfa_os_reg_write(_raddr, _val)
-#define bfa_mem_read(_raddr, _off)	bfa_os_mem_read(_raddr, _off)
+#define bfa_mem_read(_raddr, _off)	swab32(readl(((_raddr) + (_off))))
 #define bfa_mem_write(_raddr, _off, _val)	\
-					bfa_os_mem_write(_raddr, _off, _val)
+			writel(swab32((_val)), ((_raddr) + (_off)))
 /**
  * IOC Mailbox structures
  */
@@ -249,7 +247,7 @@ struct bfa_ioc_s {
 };
 
 struct bfa_ioc_hwif_s {
-	bfa_status_t (*ioc_pll_init) (bfa_os_addr_t rb, bfa_boolean_t fcmode);
+	bfa_status_t (*ioc_pll_init) (void __iomem *rb, bfa_boolean_t fcmode);
 	bfa_boolean_t	(*ioc_firmware_lock)	(struct bfa_ioc_s *ioc);
 	void		(*ioc_firmware_unlock)	(struct bfa_ioc_s *ioc);
 	void		(*ioc_reg_init)	(struct bfa_ioc_s *ioc);
@@ -308,9 +306,9 @@ void bfa_ioc_mbox_regisr(struct bfa_ioc_s *ioc, enum bfi_mclass mc,
 			   (__ioc)->fcmode))
 
 bfa_status_t bfa_ioc_pll_init(struct bfa_ioc_s *ioc);
-bfa_status_t bfa_ioc_cb_pll_init(bfa_os_addr_t rb, bfa_boolean_t fcmode);
-bfa_boolean_t bfa_ioc_ct_pll_init_complete(bfa_os_addr_t rb);
-bfa_status_t bfa_ioc_ct_pll_init(bfa_os_addr_t rb, bfa_boolean_t fcmode);
+bfa_status_t bfa_ioc_cb_pll_init(void __iomem *rb, bfa_boolean_t fcmode);
+bfa_boolean_t bfa_ioc_ct_pll_init_complete(void __iomem *rb);
+bfa_status_t bfa_ioc_ct_pll_init(void __iomem *rb, bfa_boolean_t fcmode);
 
 #define	bfa_ioc_isr_mode_set(__ioc, __msix)			\
 			((__ioc)->ioc_hwif->ioc_isr_mode_set(__ioc, __msix))
@@ -370,8 +368,8 @@ void bfa_ioc_set_fcmode(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_get_fcmode(struct bfa_ioc_s *ioc);
 void bfa_ioc_hbfail_register(struct bfa_ioc_s *ioc,
 	struct bfa_ioc_hbfail_notify_s *notify);
-bfa_boolean_t bfa_ioc_sem_get(bfa_os_addr_t sem_reg);
-void bfa_ioc_sem_release(bfa_os_addr_t sem_reg);
+bfa_boolean_t bfa_ioc_sem_get(void __iomem *sem_reg);
+void bfa_ioc_sem_release(void __iomem *sem_reg);
 void bfa_ioc_hw_sem_release(struct bfa_ioc_s *ioc);
 void bfa_ioc_fwver_get(struct bfa_ioc_s *ioc,
 			struct bfi_ioc_image_hdr_s *fwhdr);
diff --git a/drivers/scsi/bfa/bfa_ioc_cb.c b/drivers/scsi/bfa/bfa_ioc_cb.c
index a32c860..86210a5 100644
--- a/drivers/scsi/bfa/bfa_ioc_cb.c
+++ b/drivers/scsi/bfa/bfa_ioc_cb.c
@@ -72,8 +72,8 @@ bfa_ioc_cb_firmware_unlock(struct bfa_ioc_s *ioc)
 static void
 bfa_ioc_cb_notify_hbfail(struct bfa_ioc_s *ioc)
 {
-	bfa_reg_write(ioc->ioc_regs.err_set, __PSS_ERR_STATUS_SET);
-	bfa_reg_read(ioc->ioc_regs.err_set);
+	writel(__PSS_ERR_STATUS_SET, ioc->ioc_regs.err_set);
+	readl(ioc->ioc_regs.err_set);
 }
 
 /**
@@ -96,7 +96,7 @@ static struct { u32 hfn, lpu; } iocreg_mbcmd[] = {
 static void
 bfa_ioc_cb_reg_init(struct bfa_ioc_s *ioc)
 {
-	bfa_os_addr_t	rb;
+	void __iomem *rb;
 	int		pcifn = bfa_ioc_pcifn(ioc);
 
 	rb = bfa_ioc_bar0(ioc);
@@ -180,14 +180,14 @@ bfa_ioc_cb_ownership_reset(struct bfa_ioc_s *ioc)
 	 * before we clear it. If it is not locked, writing 1
 	 * will lock it instead of clearing it.
 	 */
-	bfa_reg_read(ioc->ioc_regs.ioc_sem_reg);
+	readl(ioc->ioc_regs.ioc_sem_reg);
 	bfa_ioc_hw_sem_release(ioc);
 }
 
 
 
 bfa_status_t
-bfa_ioc_cb_pll_init(bfa_os_addr_t rb, bfa_boolean_t fcmode)
+bfa_ioc_cb_pll_init(void __iomem *rb, bfa_boolean_t fcmode)
 {
 	u32	pll_sclk, pll_fclk;
 
@@ -199,38 +199,32 @@ bfa_ioc_cb_pll_init(bfa_os_addr_t rb, bfa_boolean_t fcmode)
 		__APP_PLL_400_RSEL200500 | __APP_PLL_400_P0_1(3U) |
 		__APP_PLL_400_JITLMT0_1(3U) |
 		__APP_PLL_400_CNTLMT0_1(3U);
-	bfa_reg_write((rb + BFA_IOC0_STATE_REG), BFI_IOC_UNINIT);
-	bfa_reg_write((rb + BFA_IOC1_STATE_REG), BFI_IOC_UNINIT);
-	bfa_reg_write((rb + HOSTFN0_INT_MSK), 0xffffffffU);
-	bfa_reg_write((rb + HOSTFN1_INT_MSK), 0xffffffffU);
-	bfa_reg_write((rb + HOSTFN0_INT_STATUS), 0xffffffffU);
-	bfa_reg_write((rb + HOSTFN1_INT_STATUS), 0xffffffffU);
-	bfa_reg_write((rb + HOSTFN0_INT_MSK), 0xffffffffU);
-	bfa_reg_write((rb + HOSTFN1_INT_MSK), 0xffffffffU);
-	bfa_reg_write(rb + APP_PLL_212_CTL_REG,
-			  __APP_PLL_212_LOGIC_SOFT_RESET);
-	bfa_reg_write(rb + APP_PLL_212_CTL_REG,
-			  __APP_PLL_212_BYPASS |
-			  __APP_PLL_212_LOGIC_SOFT_RESET);
-	bfa_reg_write(rb + APP_PLL_400_CTL_REG,
-			  __APP_PLL_400_LOGIC_SOFT_RESET);
-	bfa_reg_write(rb + APP_PLL_400_CTL_REG,
-			  __APP_PLL_400_BYPASS |
-			  __APP_PLL_400_LOGIC_SOFT_RESET);
+	writel(BFI_IOC_UNINIT, (rb + BFA_IOC0_STATE_REG));
+	writel(BFI_IOC_UNINIT, (rb + BFA_IOC1_STATE_REG));
+	writel(0xffffffffU, (rb + HOSTFN0_INT_MSK));
+	writel(0xffffffffU, (rb + HOSTFN1_INT_MSK));
+	writel(0xffffffffU, (rb + HOSTFN0_INT_STATUS));
+	writel(0xffffffffU, (rb + HOSTFN1_INT_STATUS));
+	writel(0xffffffffU, (rb + HOSTFN0_INT_MSK));
+	writel(0xffffffffU, (rb + HOSTFN1_INT_MSK));
+	writel(__APP_PLL_212_LOGIC_SOFT_RESET, rb + APP_PLL_212_CTL_REG);
+	writel(__APP_PLL_212_BYPASS | __APP_PLL_212_LOGIC_SOFT_RESET,
+			rb + APP_PLL_212_CTL_REG);
+	writel(__APP_PLL_400_LOGIC_SOFT_RESET, rb + APP_PLL_400_CTL_REG);
+	writel(__APP_PLL_400_BYPASS | __APP_PLL_400_LOGIC_SOFT_RESET,
+			rb + APP_PLL_400_CTL_REG);
 	udelay(2);
-	bfa_reg_write(rb + APP_PLL_212_CTL_REG,
-			  __APP_PLL_212_LOGIC_SOFT_RESET);
-	bfa_reg_write(rb + APP_PLL_400_CTL_REG,
-			  __APP_PLL_400_LOGIC_SOFT_RESET);
-	bfa_reg_write(rb + APP_PLL_212_CTL_REG,
-			  pll_sclk | __APP_PLL_212_LOGIC_SOFT_RESET);
-	bfa_reg_write(rb + APP_PLL_400_CTL_REG,
-			  pll_fclk | __APP_PLL_400_LOGIC_SOFT_RESET);
+	writel(__APP_PLL_212_LOGIC_SOFT_RESET, rb + APP_PLL_212_CTL_REG);
+	writel(__APP_PLL_400_LOGIC_SOFT_RESET, rb + APP_PLL_400_CTL_REG);
+	writel(pll_sclk | __APP_PLL_212_LOGIC_SOFT_RESET,
+			rb + APP_PLL_212_CTL_REG);
+	writel(pll_fclk | __APP_PLL_400_LOGIC_SOFT_RESET,
+			rb + APP_PLL_400_CTL_REG);
 	udelay(2000);
-	bfa_reg_write((rb + HOSTFN0_INT_STATUS), 0xffffffffU);
-	bfa_reg_write((rb + HOSTFN1_INT_STATUS), 0xffffffffU);
-	bfa_reg_write((rb + APP_PLL_212_CTL_REG), pll_sclk);
-	bfa_reg_write((rb + APP_PLL_400_CTL_REG), pll_fclk);
+	writel(0xffffffffU, (rb + HOSTFN0_INT_STATUS));
+	writel(0xffffffffU, (rb + HOSTFN1_INT_STATUS));
+	writel(pll_sclk, (rb + APP_PLL_212_CTL_REG));
+	writel(pll_fclk, (rb + APP_PLL_400_CTL_REG));
 
 	return BFA_STATUS_OK;
 }
diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
index 5008afe..c852d98 100644
--- a/drivers/scsi/bfa/bfa_ioc_ct.c
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -76,19 +76,19 @@ bfa_ioc_ct_firmware_lock(struct bfa_ioc_s *ioc)
 		return BFA_TRUE;
 
 	bfa_ioc_sem_get(ioc->ioc_regs.ioc_usage_sem_reg);
-	usecnt = bfa_reg_read(ioc->ioc_regs.ioc_usage_reg);
+	usecnt = readl(ioc->ioc_regs.ioc_usage_reg);
 
 	/**
 	 * If usage count is 0, always return TRUE.
 	 */
 	if (usecnt == 0) {
-		bfa_reg_write(ioc->ioc_regs.ioc_usage_reg, 1);
+		writel(1, ioc->ioc_regs.ioc_usage_reg);
 		bfa_ioc_sem_release(ioc->ioc_regs.ioc_usage_sem_reg);
 		bfa_trc(ioc, usecnt);
 		return BFA_TRUE;
 	}
 
-	ioc_fwstate = bfa_reg_read(ioc->ioc_regs.ioc_fwstate);
+	ioc_fwstate = readl(ioc->ioc_regs.ioc_fwstate);
 	bfa_trc(ioc, ioc_fwstate);
 
 	/**
@@ -110,7 +110,7 @@ bfa_ioc_ct_firmware_lock(struct bfa_ioc_s *ioc)
 	 * Same firmware version. Increment the reference count.
 	 */
 	usecnt++;
-	bfa_reg_write(ioc->ioc_regs.ioc_usage_reg, usecnt);
+	writel(usecnt, ioc->ioc_regs.ioc_usage_reg);
 	bfa_ioc_sem_release(ioc->ioc_regs.ioc_usage_sem_reg);
 	bfa_trc(ioc, usecnt);
 	return BFA_TRUE;
@@ -138,11 +138,11 @@ bfa_ioc_ct_firmware_unlock(struct bfa_ioc_s *ioc)
 	 * decrement usage count
 	 */
 	bfa_ioc_sem_get(ioc->ioc_regs.ioc_usage_sem_reg);
-	usecnt = bfa_reg_read(ioc->ioc_regs.ioc_usage_reg);
+	usecnt = readl(ioc->ioc_regs.ioc_usage_reg);
 	bfa_assert(usecnt > 0);
 
 	usecnt--;
-	bfa_reg_write(ioc->ioc_regs.ioc_usage_reg, usecnt);
+	writel(usecnt, ioc->ioc_regs.ioc_usage_reg);
 	bfa_trc(ioc, usecnt);
 
 	bfa_ioc_sem_release(ioc->ioc_regs.ioc_usage_sem_reg);
@@ -155,12 +155,12 @@ static void
 bfa_ioc_ct_notify_hbfail(struct bfa_ioc_s *ioc)
 {
 	if (ioc->cna) {
-		bfa_reg_write(ioc->ioc_regs.ll_halt, __FW_INIT_HALT_P);
+		writel(__FW_INIT_HALT_P, ioc->ioc_regs.ll_halt);
 		/* Wait for halt to take effect */
-		bfa_reg_read(ioc->ioc_regs.ll_halt);
+		readl(ioc->ioc_regs.ll_halt);
 	} else {
-		bfa_reg_write(ioc->ioc_regs.err_set, __PSS_ERR_STATUS_SET);
-		bfa_reg_read(ioc->ioc_regs.err_set);
+		writel(__PSS_ERR_STATUS_SET, ioc->ioc_regs.err_set);
+		readl(ioc->ioc_regs.err_set);
 	}
 }
 
@@ -197,7 +197,7 @@ static struct { u32 hfn, lpu; } iocreg_mbcmd_p1[] = {
 static void
 bfa_ioc_ct_reg_init(struct bfa_ioc_s *ioc)
 {
-	bfa_os_addr_t	rb;
+	void __iomem *rb;
 	int		pcifn = bfa_ioc_pcifn(ioc);
 
 	rb = bfa_ioc_bar0(ioc);
@@ -256,13 +256,13 @@ bfa_ioc_ct_reg_init(struct bfa_ioc_s *ioc)
 static void
 bfa_ioc_ct_map_port(struct bfa_ioc_s *ioc)
 {
-	bfa_os_addr_t	rb = ioc->pcidev.pci_bar_kva;
+	void __iomem *rb = ioc->pcidev.pci_bar_kva;
 	u32	r32;
 
 	/**
 	 * For catapult, base port id on personality register and IOC type
 	 */
-	r32 = bfa_reg_read(rb + FNC_PERS_REG);
+	r32 = readl(rb + FNC_PERS_REG);
 	r32 >>= FNC_PERS_FN_SHIFT(bfa_ioc_pcifn(ioc));
 	ioc->port_id = (r32 & __F0_PORT_MAP_MK) >> __F0_PORT_MAP_SH;
 
@@ -276,10 +276,10 @@ bfa_ioc_ct_map_port(struct bfa_ioc_s *ioc)
 static void
 bfa_ioc_ct_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix)
 {
-	bfa_os_addr_t	rb = ioc->pcidev.pci_bar_kva;
+	void __iomem *rb = ioc->pcidev.pci_bar_kva;
 	u32	r32, mode;
 
-	r32 = bfa_reg_read(rb + FNC_PERS_REG);
+	r32 = readl(rb + FNC_PERS_REG);
 	bfa_trc(ioc, r32);
 
 	mode = (r32 >> FNC_PERS_FN_SHIFT(bfa_ioc_pcifn(ioc))) &
@@ -300,7 +300,7 @@ bfa_ioc_ct_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix)
 	r32 |= (mode << FNC_PERS_FN_SHIFT(bfa_ioc_pcifn(ioc)));
 	bfa_trc(ioc, r32);
 
-	bfa_reg_write(rb + FNC_PERS_REG, r32);
+	writel(r32, rb + FNC_PERS_REG);
 }
 
 /**
@@ -312,7 +312,7 @@ bfa_ioc_ct_ownership_reset(struct bfa_ioc_s *ioc)
 
 	if (ioc->cna) {
 		bfa_ioc_sem_get(ioc->ioc_regs.ioc_usage_sem_reg);
-		bfa_reg_write(ioc->ioc_regs.ioc_usage_reg, 0);
+		writel(0, ioc->ioc_regs.ioc_usage_reg);
 		bfa_ioc_sem_release(ioc->ioc_regs.ioc_usage_sem_reg);
 	}
 
@@ -321,7 +321,7 @@ bfa_ioc_ct_ownership_reset(struct bfa_ioc_s *ioc)
 	 * before we clear it. If it is not locked, writing 1
 	 * will lock it instead of clearing it.
 	 */
-	bfa_reg_read(ioc->ioc_regs.ioc_sem_reg);
+	readl(ioc->ioc_regs.ioc_sem_reg);
 	bfa_ioc_hw_sem_release(ioc);
 }
 
@@ -331,17 +331,17 @@ bfa_ioc_ct_ownership_reset(struct bfa_ioc_s *ioc)
  * Check the firmware state to know if pll_init has been completed already
  */
 bfa_boolean_t
-bfa_ioc_ct_pll_init_complete(bfa_os_addr_t rb)
+bfa_ioc_ct_pll_init_complete(void __iomem *rb)
 {
-	if ((bfa_reg_read(rb + BFA_IOC0_STATE_REG) == BFI_IOC_OP) ||
-	  (bfa_reg_read(rb + BFA_IOC1_STATE_REG) == BFI_IOC_OP))
+	if ((readl(rb + BFA_IOC0_STATE_REG) == BFI_IOC_OP) ||
+	  (readl(rb + BFA_IOC1_STATE_REG) == BFI_IOC_OP))
 		return BFA_TRUE;
 
 	return BFA_FALSE;
 }
 
 bfa_status_t
-bfa_ioc_ct_pll_init(bfa_os_addr_t rb, bfa_boolean_t fcmode)
+bfa_ioc_ct_pll_init(void __iomem *rb, bfa_boolean_t fcmode)
 {
 	u32	pll_sclk, pll_fclk, r32;
 
@@ -354,56 +354,51 @@ bfa_ioc_ct_pll_init(bfa_os_addr_t rb, bfa_boolean_t fcmode)
 		__APP_PLL_425_JITLMT0_1(3U) |
 		__APP_PLL_425_CNTLMT0_1(1U);
 	if (fcmode) {
-		bfa_reg_write((rb + OP_MODE), 0);
-		bfa_reg_write((rb + ETH_MAC_SER_REG),
-				__APP_EMS_CMLCKSEL |
-				__APP_EMS_REFCKBUFEN2 |
-				__APP_EMS_CHANNEL_SEL);
+		writel(0, (rb + OP_MODE));
+		writel(__APP_EMS_CMLCKSEL | __APP_EMS_REFCKBUFEN2 |
+			 __APP_EMS_CHANNEL_SEL, (rb + ETH_MAC_SER_REG));
 	} else {
-		bfa_reg_write((rb + OP_MODE), __GLOBAL_FCOE_MODE);
-		bfa_reg_write((rb + ETH_MAC_SER_REG),
-				__APP_EMS_REFCKBUFEN1);
+		writel(__GLOBAL_FCOE_MODE, (rb + OP_MODE));
+		writel(__APP_EMS_REFCKBUFEN1, (rb + ETH_MAC_SER_REG));
 	}
-	bfa_reg_write((rb + BFA_IOC0_STATE_REG), BFI_IOC_UNINIT);
-	bfa_reg_write((rb + BFA_IOC1_STATE_REG), BFI_IOC_UNINIT);
-	bfa_reg_write((rb + HOSTFN0_INT_MSK), 0xffffffffU);
-	bfa_reg_write((rb + HOSTFN1_INT_MSK), 0xffffffffU);
-	bfa_reg_write((rb + HOSTFN0_INT_STATUS), 0xffffffffU);
-	bfa_reg_write((rb + HOSTFN1_INT_STATUS), 0xffffffffU);
-	bfa_reg_write((rb + HOSTFN0_INT_MSK), 0xffffffffU);
-	bfa_reg_write((rb + HOSTFN1_INT_MSK), 0xffffffffU);
-	bfa_reg_write(rb + APP_PLL_312_CTL_REG, pll_sclk |
-		__APP_PLL_312_LOGIC_SOFT_RESET);
-	bfa_reg_write(rb + APP_PLL_425_CTL_REG, pll_fclk |
-		__APP_PLL_425_LOGIC_SOFT_RESET);
-	bfa_reg_write(rb + APP_PLL_312_CTL_REG, pll_sclk |
-		__APP_PLL_312_LOGIC_SOFT_RESET | __APP_PLL_312_ENABLE);
-	bfa_reg_write(rb + APP_PLL_425_CTL_REG, pll_fclk |
-		__APP_PLL_425_LOGIC_SOFT_RESET | __APP_PLL_425_ENABLE);
-	bfa_reg_read(rb + HOSTFN0_INT_MSK);
+	writel(BFI_IOC_UNINIT, (rb + BFA_IOC0_STATE_REG));
+	writel(BFI_IOC_UNINIT, (rb + BFA_IOC1_STATE_REG));
+	writel(0xffffffffU, (rb + HOSTFN0_INT_MSK));
+	writel(0xffffffffU, (rb + HOSTFN1_INT_MSK));
+	writel(0xffffffffU, (rb + HOSTFN0_INT_STATUS));
+	writel(0xffffffffU, (rb + HOSTFN1_INT_STATUS));
+	writel(0xffffffffU, (rb + HOSTFN0_INT_MSK));
+	writel(0xffffffffU, (rb + HOSTFN1_INT_MSK));
+	writel(pll_sclk | __APP_PLL_312_LOGIC_SOFT_RESET,
+			rb + APP_PLL_312_CTL_REG);
+	writel(pll_fclk | __APP_PLL_425_LOGIC_SOFT_RESET,
+			rb + APP_PLL_425_CTL_REG);
+	writel(pll_sclk | __APP_PLL_312_LOGIC_SOFT_RESET | __APP_PLL_312_ENABLE,
+			rb + APP_PLL_312_CTL_REG);
+	writel(pll_fclk | __APP_PLL_425_LOGIC_SOFT_RESET | __APP_PLL_425_ENABLE,
+			rb + APP_PLL_425_CTL_REG);
+	readl(rb + HOSTFN0_INT_MSK);
 	udelay(2000);
-	bfa_reg_write((rb + HOSTFN0_INT_STATUS), 0xffffffffU);
-	bfa_reg_write((rb + HOSTFN1_INT_STATUS), 0xffffffffU);
-	bfa_reg_write(rb + APP_PLL_312_CTL_REG, pll_sclk |
-		__APP_PLL_312_ENABLE);
-	bfa_reg_write(rb + APP_PLL_425_CTL_REG, pll_fclk |
-		__APP_PLL_425_ENABLE);
+	writel(0xffffffffU, (rb + HOSTFN0_INT_STATUS));
+	writel(0xffffffffU, (rb + HOSTFN1_INT_STATUS));
+	writel(pll_sclk | __APP_PLL_312_ENABLE, rb + APP_PLL_312_CTL_REG);
+	writel(pll_fclk | __APP_PLL_425_ENABLE, rb + APP_PLL_425_CTL_REG);
 	if (!fcmode) {
-		bfa_reg_write((rb + PMM_1T_RESET_REG_P0), __PMM_1T_RESET_P);
-		bfa_reg_write((rb + PMM_1T_RESET_REG_P1), __PMM_1T_RESET_P);
+		writel(__PMM_1T_RESET_P, (rb + PMM_1T_RESET_REG_P0));
+		writel(__PMM_1T_RESET_P, (rb + PMM_1T_RESET_REG_P1));
 	}
-	r32 = bfa_reg_read((rb + PSS_CTL_REG));
+	r32 = readl((rb + PSS_CTL_REG));
 	r32 &= ~__PSS_LMEM_RESET;
-	bfa_reg_write((rb + PSS_CTL_REG), r32);
+	writel(r32, (rb + PSS_CTL_REG));
 	udelay(1000);
 	if (!fcmode) {
-		bfa_reg_write((rb + PMM_1T_RESET_REG_P0), 0);
-		bfa_reg_write((rb + PMM_1T_RESET_REG_P1), 0);
+		writel(0, (rb + PMM_1T_RESET_REG_P0));
+		writel(0, (rb + PMM_1T_RESET_REG_P1));
 	}
 
-	bfa_reg_write((rb + MBIST_CTL_REG), __EDRAM_BISTR_START);
+	writel(__EDRAM_BISTR_START, (rb + MBIST_CTL_REG));
 	udelay(1000);
-	r32 = bfa_reg_read((rb + MBIST_STAT_REG));
-	bfa_reg_write((rb + MBIST_CTL_REG), 0);
+	r32 = readl((rb + MBIST_STAT_REG));
+	writel(0, (rb + MBIST_CTL_REG));
 	return BFA_STATUS_OK;
 }
diff --git a/drivers/scsi/bfa/bfa_os_inc.h b/drivers/scsi/bfa/bfa_os_inc.h
index d928dca..f9edc75 100644
--- a/drivers/scsi/bfa/bfa_os_inc.h
+++ b/drivers/scsi/bfa/bfa_os_inc.h
@@ -65,12 +65,6 @@ do {									\
 	((_x) & 0x00ff00) |			\
 	(((_x) & 0xff0000) >> 16))
 
-#define bfa_os_swap32(_x)			\
-	((((_x) & 0xff) << 24)		|	\
-	(((_x) & 0x0000ff00) << 8)	|	\
-	(((_x) & 0x00ff0000) >> 8)	|	\
-	(((_x) & 0xff000000) >> 24))
-
 #define bfa_os_swap_sgaddr(_x)  ((u64)(                                 \
 	(((u64)(_x) & (u64)0x00000000000000ffull) << 32)        |       \
 	(((u64)(_x) & (u64)0x000000000000ff00ull) << 32)        |       \
@@ -82,7 +76,7 @@ do {									\
 	(((u64)(_x) & (u64)0xff00000000000000ull) >> 32)))
 
 #ifndef __BIGENDIAN
-#define bfa_os_hton3b(_x)	bfa_swap_3b(_x)
+#define bfa_os_hton3b(_x)  bfa_swap_3b(_x)
 #define bfa_os_sgaddr(_x)  (_x)
 #else
 #define bfa_os_hton3b(_x)  (_x)
@@ -91,22 +85,14 @@ do {									\
 
 #define bfa_os_ntoh3b(_x)  bfa_os_hton3b(_x)
 #define bfa_os_u32(__pa64) ((__pa64) >> 32)
-#define bfa_os_addr_t void __iomem *
-
-#define bfa_os_reg_read(_raddr) readl(_raddr)
-#define bfa_os_reg_write(_raddr, _val) writel((_val), (_raddr))
-#define bfa_os_mem_read(_raddr, _off)					\
-	bfa_os_swap32(readl(((_raddr) + (_off))))
-#define bfa_os_mem_write(_raddr, _off, _val)				\
-	writel(bfa_os_swap32((_val)), ((_raddr) + (_off)))
-
-#define BFA_TRC_TS(_trcm)						\
-			({						\
-				struct timeval tv;			\
-									\
-				do_gettimeofday(&tv);      \
-				(tv.tv_sec*1000000+tv.tv_usec);      \
-			 })
+
+#define BFA_TRC_TS(_trcm)				\
+	({						\
+		struct timeval tv;			\
+							\
+		do_gettimeofday(&tv);      		\
+		(tv.tv_sec*1000000+tv.tv_usec);		\
+	 })
 
 #define boolean_t int
 
diff --git a/drivers/scsi/bfa/bfad_debugfs.c b/drivers/scsi/bfa/bfad_debugfs.c
index 69ed1c4..1fedeeb 100644
--- a/drivers/scsi/bfa/bfad_debugfs.c
+++ b/drivers/scsi/bfa/bfad_debugfs.c
@@ -318,7 +318,7 @@ bfad_debugfs_write_regrd(struct file *file, const char __user *buf,
 	regbuf =  (u32 *)bfad->regdata;
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	for (i = 0; i < len; i++) {
-		*regbuf = bfa_reg_read(reg_addr);
+		*regbuf = readl(reg_addr);
 		regbuf++;
 		reg_addr += sizeof(u32);
 	}
@@ -361,7 +361,7 @@ bfad_debugfs_write_regwr(struct file *file, const char __user *buf,
 
 	reg_addr = (u32 *) ((u8 *) bfa_ioc_bar0(ioc) + addr);
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
-	bfa_reg_write(reg_addr, val);
+	writel(val, reg_addr);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 
 	return nbytes;
-- 
1.6.5.2

