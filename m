From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 13/24] bfa: fix chip and memory initialization
Date: Thu, 8 Jul 2010 19:54:39 -0700
Message-ID: <1278644079-32562-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:55728 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753876Ab0GICyo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2010 22:54:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: kgudipat@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, Jing Huang <huangj@brocade.com>

Clear PSS memory reset that is set as part of power-on-reset (pci reset).
Complete PMM memory reset before BISTR start. Clear EDRAM BISTR start bit
after fixed delay. BISTR DONE bit status is not getting set. Use a fixed
1ms delay for BISTR now. Expose PMM IT memory definitions to host.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_ioc_ct.c            |   25 +++++++++++++++++++++++++
 drivers/scsi/bfa/include/bfi/bfi_ctreg.h |    3 +++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
index 17bd151..68f027d 100644
--- a/drivers/scsi/bfa/bfa_ioc_ct.c
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -376,10 +376,35 @@ bfa_ioc_ct_pll_init(struct bfa_ioc_s *ioc)
 	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg, pll_fclk |
 		__APP_PLL_425_ENABLE);
 
+	/**
+	 * PSS memory reset is asserted at power-on-reset. Need to clear
+	 * this before running EDRAM BISTR
+	 */
+	if (ioc->cna) {
+		bfa_reg_write((rb + PMM_1T_RESET_REG_P0), __PMM_1T_RESET_P);
+		bfa_reg_write((rb + PMM_1T_RESET_REG_P1), __PMM_1T_RESET_P);
+	}
+
+	r32 = bfa_reg_read((rb + PSS_CTL_REG));
+	r32 &= ~__PSS_LMEM_RESET;
+	bfa_reg_write((rb + PSS_CTL_REG), r32);
+	bfa_os_udelay(1000);
+
+	if (ioc->cna) {
+		bfa_reg_write((rb + PMM_1T_RESET_REG_P0), 0);
+		bfa_reg_write((rb + PMM_1T_RESET_REG_P1), 0);
+	}
+
 	bfa_reg_write((rb + MBIST_CTL_REG), __EDRAM_BISTR_START);
 	bfa_os_udelay(1000);
 	r32 = bfa_reg_read((rb + MBIST_STAT_REG));
 	bfa_trc(ioc, r32);
+
+	/**
+	 * Clear BISTR
+	 */
+	bfa_reg_write((rb + MBIST_CTL_REG), 0);
+
 	/*
 	 *  release semaphore.
 	 */
diff --git a/drivers/scsi/bfa/include/bfi/bfi_ctreg.h b/drivers/scsi/bfa/include/bfi/bfi_ctreg.h
index 57a8497..c0ef5a9 100644
--- a/drivers/scsi/bfa/include/bfi/bfi_ctreg.h
+++ b/drivers/scsi/bfa/include/bfi/bfi_ctreg.h
@@ -455,6 +455,9 @@ enum {
 #define __PSS_LPU0_RAM_ERR               0x00000001
 #define ERR_SET_REG			 0x00018818
 #define __PSS_ERR_STATUS_SET		 0x003fffff
+#define PMM_1T_RESET_REG_P0              0x0002381c
+#define __PMM_1T_RESET_P                 0x00000001
+#define PMM_1T_RESET_REG_P1              0x00023c1c
 #define HQM_QSET0_RXQ_DRBL_P0            0x00038000
 #define __RXQ0_ADD_VECTORS_P             0x80000000
 #define __RXQ0_STOP_P                    0x40000000
-- 
1.6.5.2

