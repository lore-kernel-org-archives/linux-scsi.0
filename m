From: Krishna Gudipati <kgudipat@brocade.com>
Subject: [PATCH 22/32] bfa: In MSIX mode, ignore spurious RME interrupts when FCoE ports are in FW mismatch state.
Date: Thu, 25 Feb 2010 17:49:20 -0800
Message-ID: <1267148960-23077-1-git-send-email-kgudipat@blc-10-2.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:59502 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934903Ab0BZBvd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 20:51:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.comKrishna Gudipati <kgudipat@brocade.com>

Change details:

Root Cause:

	- Currently in MSIX mode, when FCoE ports are in FW  mismatch state, upgrading (or reloading)
	  Ethernet drivers can generate spurious RME interrupts. The system can crash (Hardware Malfunction)
	  or reboot if FCoE driver processes this RME interrupt as the queues are not yet initialized.

	- Fix is to not install MSIX handlers as part of bfa_init. MSIX handlers will be installed
	  when bfa_isr_enable is called later (when chip reset completes). This will ensure
	  that the spurious interrupts will be ignored by the dummy handlers.

	- Also removed msix installation code in bfa_iocfc_init().
---
 drivers/scsi/bfa/bfa_ioc_ct.c |   43 ++++++++++++++++------------------------
 drivers/scsi/bfa/bfa_iocfc.c  |    1 -
 2 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
index 45d82d6..639aa5e 100644
--- a/drivers/scsi/bfa/bfa_ioc_ct.c
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -332,12 +332,12 @@ bfa_ioc_ct_pll_init(struct bfa_ioc_s *ioc)
 	 */
 	bfa_ioc_sem_get(ioc->ioc_regs.ioc_init_sem_reg);
 
-	pll_sclk = __APP_PLL_312_ENABLE | __APP_PLL_312_LRESETN |
-		__APP_PLL_312_RSEL200500 | __APP_PLL_312_P0_1(0U) |
+	pll_sclk = __APP_PLL_312_LRESETN | __APP_PLL_312_ENARST |
+		__APP_PLL_312_RSEL200500 | __APP_PLL_312_P0_1(3U) |
 		__APP_PLL_312_JITLMT0_1(3U) |
 		__APP_PLL_312_CNTLMT0_1(1U);
-	pll_fclk = __APP_PLL_425_ENABLE | __APP_PLL_425_LRESETN |
-		__APP_PLL_425_RSEL200500 | __APP_PLL_425_P0_1(0U) |
+	pll_fclk = __APP_PLL_425_LRESETN | __APP_PLL_425_ENARST |
+		__APP_PLL_425_RSEL200500 | __APP_PLL_425_P0_1(3U) |
 		__APP_PLL_425_JITLMT0_1(3U) |
 		__APP_PLL_425_CNTLMT0_1(1U);
 
@@ -367,36 +367,27 @@ bfa_ioc_ct_pll_init(struct bfa_ioc_s *ioc)
 	bfa_reg_write((rb + HOSTFN0_INT_MSK), 0xffffffffU);
 	bfa_reg_write((rb + HOSTFN1_INT_MSK), 0xffffffffU);
 
-	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
-				__APP_PLL_312_LOGIC_SOFT_RESET);
-	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
-				__APP_PLL_312_BYPASS |
-				__APP_PLL_312_LOGIC_SOFT_RESET);
-	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
-				__APP_PLL_425_LOGIC_SOFT_RESET);
-	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
-				__APP_PLL_425_BYPASS |
-				__APP_PLL_425_LOGIC_SOFT_RESET);
-	bfa_os_udelay(2);
-	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
-				__APP_PLL_312_LOGIC_SOFT_RESET);
-	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
-				__APP_PLL_425_LOGIC_SOFT_RESET);
-
-	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
-				pll_sclk | __APP_PLL_312_LOGIC_SOFT_RESET);
-	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
-				pll_fclk | __APP_PLL_425_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg, pll_sclk |
+		__APP_PLL_312_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg, pll_fclk |
+		__APP_PLL_425_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg, pll_sclk |
+		__APP_PLL_312_LOGIC_SOFT_RESET | __APP_PLL_312_ENABLE);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg, pll_fclk |
+		__APP_PLL_425_LOGIC_SOFT_RESET | __APP_PLL_425_ENABLE);
 
 	/**
 	 * Wait for PLLs to lock.
 	 */
+	bfa_reg_read(rb + HOSTFN0_INT_MSK);
 	bfa_os_udelay(2000);
 	bfa_reg_write((rb + HOSTFN0_INT_STATUS), 0xffffffffU);
 	bfa_reg_write((rb + HOSTFN1_INT_STATUS), 0xffffffffU);
 
-	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg, pll_sclk);
-	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg, pll_fclk);
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg, pll_sclk |
+		__APP_PLL_312_ENABLE);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg, pll_fclk |
+		__APP_PLL_425_ENABLE);
 
 	bfa_reg_write((rb + MBIST_CTL_REG), __EDRAM_BISTR_START);
 	bfa_os_udelay(1000);
diff --git a/drivers/scsi/bfa/bfa_iocfc.c b/drivers/scsi/bfa/bfa_iocfc.c
index a5551db..6677f83 100644
--- a/drivers/scsi/bfa/bfa_iocfc.c
+++ b/drivers/scsi/bfa/bfa_iocfc.c
@@ -659,7 +659,6 @@ bfa_iocfc_init(struct bfa_s *bfa)
 {
 	bfa->iocfc.action = BFA_IOCFC_ACT_INIT;
 	bfa_ioc_enable(&bfa->ioc);
-	bfa_msix_install(bfa);
 }
 
 /**
-- 
1.6.5.3

