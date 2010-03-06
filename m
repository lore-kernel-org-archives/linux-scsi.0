From: <kgudipat@brocade.com>
Subject: [PATCH 02/23] bfa: Clear LL_HALT and PSS_ERR bit when IOC crashes.
Date: Fri, 5 Mar 2010 19:34:44 -0800
Message-ID: <1267846484-21665-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:55929 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab0CFDfD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2010 22:35:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:

	- Clear LL_HALT and PSS_ERR bit in the interrupt status register on an IOC crash.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_intr.c              |   35 ++++++++++++++++++++++++++---
 drivers/scsi/bfa/bfa_ioc.h               |    1 +
 drivers/scsi/bfa/bfa_ioc_cb.c            |    1 +
 drivers/scsi/bfa/bfa_ioc_ct.c            |    1 +
 drivers/scsi/bfa/include/bfi/bfi_cbreg.h |   13 +++++++++++
 drivers/scsi/bfa/include/bfi/bfi_ctreg.h |   23 +++++++++++++++++++
 6 files changed, 70 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_intr.c b/drivers/scsi/bfa/bfa_intr.c
index ab463db..c422546 100644
--- a/drivers/scsi/bfa/bfa_intr.c
+++ b/drivers/scsi/bfa/bfa_intr.c
@@ -197,17 +197,44 @@ bfa_msix_rspq(struct bfa_s *bfa, int rsp_qid)
 void
 bfa_msix_lpu_err(struct bfa_s *bfa, int vec)
 {
-	u32 intr;
+	u32 intr, curr_value;
 
 	intr = bfa_reg_read(bfa->iocfc.bfa_regs.intr_status);
 
 	if (intr & (__HFN_INT_MBOX_LPU0 | __HFN_INT_MBOX_LPU1))
 		bfa_msix_lpu(bfa);
 
-	if (intr & (__HFN_INT_ERR_EMC |
-		    __HFN_INT_ERR_LPU0 | __HFN_INT_ERR_LPU1 |
-		    __HFN_INT_ERR_PSS | __HFN_INT_LL_HALT))
+	intr &= (__HFN_INT_ERR_EMC | __HFN_INT_ERR_LPU0 |
+		__HFN_INT_ERR_LPU1 | __HFN_INT_ERR_PSS | __HFN_INT_LL_HALT);
+
+	if (intr) {
+		if (intr & __HFN_INT_LL_HALT) {
+			/**
+			 * If LL_HALT bit is set then FW Init Halt LL Port
+			 * Register needs to be cleared as well so Interrupt
+			 * Status Register will be cleared.
+			 */
+			curr_value = bfa_reg_read(bfa->ioc.ioc_regs.ll_halt);
+			curr_value &= ~__FW_INIT_HALT_P;
+			bfa_reg_write(bfa->ioc.ioc_regs.ll_halt, curr_value);
+		}
+
+		if (intr & __HFN_INT_ERR_PSS) {
+			/**
+			 * ERR_PSS bit needs to be cleared as well in case
+			 * interrups are shared so driver's interrupt handler is
+			 * still called eventhough it is already masked out.
+			 */
+			curr_value = bfa_reg_read(
+				bfa->ioc.ioc_regs.pss_err_status_reg);
+			curr_value &= __PSS_ERR_STATUS_SET;
+			bfa_reg_write(bfa->ioc.ioc_regs.pss_err_status_reg,
+				curr_value);
+		}
+
+		bfa_reg_write(bfa->iocfc.bfa_regs.intr_status, intr);
 		bfa_msix_errint(bfa, intr);
+	}
 }
 
 void
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index 1633a50..853cc31 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -74,6 +74,7 @@ struct bfa_ioc_regs_s {
 	bfa_os_addr_t   lpu_mbox_cmd;
 	bfa_os_addr_t   lpu_mbox;
 	bfa_os_addr_t   pss_ctl_reg;
+	bfa_os_addr_t   pss_err_status_reg;
 	bfa_os_addr_t   app_pll_fast_ctl_reg;
 	bfa_os_addr_t   app_pll_slow_ctl_reg;
 	bfa_os_addr_t   ioc_sem_reg;
diff --git a/drivers/scsi/bfa/bfa_ioc_cb.c b/drivers/scsi/bfa/bfa_ioc_cb.c
index d1d625b..1fa052e 100644
--- a/drivers/scsi/bfa/bfa_ioc_cb.c
+++ b/drivers/scsi/bfa/bfa_ioc_cb.c
@@ -145,6 +145,7 @@ bfa_ioc_cb_reg_init(struct bfa_ioc_s *ioc)
 	 * PSS control registers
 	 */
 	ioc->ioc_regs.pss_ctl_reg = (rb + PSS_CTL_REG);
+	ioc->ioc_regs.pss_err_status_reg = (rb + PSS_ERR_STATUS_REG);
 	ioc->ioc_regs.app_pll_fast_ctl_reg = (rb + APP_PLL_400_CTL_REG);
 	ioc->ioc_regs.app_pll_slow_ctl_reg = (rb + APP_PLL_212_CTL_REG);
 
diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
index 5de9c24..0430edd 100644
--- a/drivers/scsi/bfa/bfa_ioc_ct.c
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -237,6 +237,7 @@ bfa_ioc_ct_reg_init(struct bfa_ioc_s *ioc)
 	 * PSS control registers
 	 */
 	ioc->ioc_regs.pss_ctl_reg = (rb + PSS_CTL_REG);
+	ioc->ioc_regs.pss_err_status_reg = (rb + PSS_ERR_STATUS_REG);
 	ioc->ioc_regs.app_pll_fast_ctl_reg = (rb + APP_PLL_425_CTL_REG);
 	ioc->ioc_regs.app_pll_slow_ctl_reg = (rb + APP_PLL_312_CTL_REG);
 
diff --git a/drivers/scsi/bfa/include/bfi/bfi_cbreg.h b/drivers/scsi/bfa/include/bfi/bfi_cbreg.h
index 781cefa..a51ee61 100644
--- a/drivers/scsi/bfa/include/bfi/bfi_cbreg.h
+++ b/drivers/scsi/bfa/include/bfi/bfi_cbreg.h
@@ -177,6 +177,19 @@
 #define __PSS_LMEM_INIT_EN               0x00000100
 #define __PSS_LPU1_RESET                 0x00000002
 #define __PSS_LPU0_RESET                 0x00000001
+#define PSS_ERR_STATUS_REG		 0x00018810
+#define __PSS_LMEM1_CORR_ERR		 0x00000800
+#define __PSS_LMEM0_CORR_ERR             0x00000400
+#define __PSS_LMEM1_UNCORR_ERR           0x00000200
+#define __PSS_LMEM0_UNCORR_ERR           0x00000100
+#define __PSS_BAL_PERR                   0x00000080
+#define __PSS_DIP_IF_ERR                 0x00000040
+#define __PSS_IOH_IF_ERR                 0x00000020
+#define __PSS_TDS_IF_ERR                 0x00000010
+#define __PSS_RDS_IF_ERR                 0x00000008
+#define __PSS_SGM_IF_ERR                 0x00000004
+#define __PSS_LPU1_RAM_ERR               0x00000002
+#define __PSS_LPU0_RAM_ERR               0x00000001
 #define ERR_SET_REG			 0x00018818
 #define __PSS_ERR_STATUS_SET		 0x00000fff
 
diff --git a/drivers/scsi/bfa/include/bfi/bfi_ctreg.h b/drivers/scsi/bfa/include/bfi/bfi_ctreg.h
index d84ebae..57a8497 100644
--- a/drivers/scsi/bfa/include/bfi/bfi_ctreg.h
+++ b/drivers/scsi/bfa/include/bfi/bfi_ctreg.h
@@ -430,6 +430,29 @@ enum {
 #define __PSS_LMEM_INIT_EN               0x00000100
 #define __PSS_LPU1_RESET                 0x00000002
 #define __PSS_LPU0_RESET                 0x00000001
+#define PSS_ERR_STATUS_REG               0x00018810
+#define __PSS_LPU1_TCM_READ_ERR          0x00200000
+#define __PSS_LPU0_TCM_READ_ERR          0x00100000
+#define __PSS_LMEM5_CORR_ERR             0x00080000
+#define __PSS_LMEM4_CORR_ERR             0x00040000
+#define __PSS_LMEM3_CORR_ERR             0x00020000
+#define __PSS_LMEM2_CORR_ERR             0x00010000
+#define __PSS_LMEM1_CORR_ERR             0x00008000
+#define __PSS_LMEM0_CORR_ERR             0x00004000
+#define __PSS_LMEM5_UNCORR_ERR           0x00002000
+#define __PSS_LMEM4_UNCORR_ERR           0x00001000
+#define __PSS_LMEM3_UNCORR_ERR           0x00000800
+#define __PSS_LMEM2_UNCORR_ERR           0x00000400
+#define __PSS_LMEM1_UNCORR_ERR           0x00000200
+#define __PSS_LMEM0_UNCORR_ERR           0x00000100
+#define __PSS_BAL_PERR                   0x00000080
+#define __PSS_DIP_IF_ERR                 0x00000040
+#define __PSS_IOH_IF_ERR                 0x00000020
+#define __PSS_TDS_IF_ERR                 0x00000010
+#define __PSS_RDS_IF_ERR                 0x00000008
+#define __PSS_SGM_IF_ERR                 0x00000004
+#define __PSS_LPU1_RAM_ERR               0x00000002
+#define __PSS_LPU0_RAM_ERR               0x00000001
 #define ERR_SET_REG			 0x00018818
 #define __PSS_ERR_STATUS_SET		 0x003fffff
 #define HQM_QSET0_RXQ_DRBL_P0            0x00038000
-- 
1.6.5.3

