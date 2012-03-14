From: <kgudipat@brocade.com>
Subject: [PATCH 3/9] bfa: Serialize the IOC hw semaphore unlock logic.
Date: Tue, 13 Mar 2012 17:38:56 -0700
Message-ID: <1331685536-21567-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:52654 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760180Ab2CNBUn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Mar 2012 21:20:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Made changes to ensure only the function that comes first will execute
	  the IOC hw semaphore unlock logic.
	- Used IOC init sem register to serialize execution of the unlock logic.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_ioc.c |   58 ++++++++++++++++++++++++++++++++++---------
 1 files changed, 46 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index eca7ab7..3164f7b 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -97,7 +97,6 @@ static void bfa_ioc_debug_save_ftrc(struct bfa_ioc_s *ioc);
 static void bfa_ioc_fail_notify(struct bfa_ioc_s *ioc);
 static void bfa_ioc_pf_fwmismatch(struct bfa_ioc_s *ioc);
 
-
 /*
  * IOC state machine definitions/declarations
  */
@@ -738,26 +737,60 @@ static void
 bfa_iocpf_sm_fwcheck_entry(struct bfa_iocpf_s *iocpf)
 {
 	struct bfi_ioc_image_hdr_s	fwhdr;
-	u32	fwstate = readl(iocpf->ioc->ioc_regs.ioc_fwstate);
+	u32	r32, fwstate, pgnum, pgoff, loff = 0;
+	int	i;
+
+	/*
+	 * Spin on init semaphore to serialize.
+	 */
+	r32 = readl(iocpf->ioc->ioc_regs.ioc_init_sem_reg);
+	while (r32 & 0x1) {
+		udelay(20);
+		r32 = readl(iocpf->ioc->ioc_regs.ioc_init_sem_reg);
+	}
 
 	/* h/w sem init */
-	if (fwstate == BFI_IOC_UNINIT)
+	fwstate = readl(iocpf->ioc->ioc_regs.ioc_fwstate);
+	if (fwstate == BFI_IOC_UNINIT) {
+		writel(1, iocpf->ioc->ioc_regs.ioc_init_sem_reg);
 		goto sem_get;
+	}
 
 	bfa_ioc_fwver_get(iocpf->ioc, &fwhdr);
 
-	if (swab32(fwhdr.exec) == BFI_FWBOOT_TYPE_NORMAL)
+	if (swab32(fwhdr.exec) == BFI_FWBOOT_TYPE_NORMAL) {
+		writel(1, iocpf->ioc->ioc_regs.ioc_init_sem_reg);
 		goto sem_get;
+	}
+
+	/*
+	 * Clear fwver hdr
+	 */
+	pgnum = PSS_SMEM_PGNUM(iocpf->ioc->ioc_regs.smem_pg0, loff);
+	pgoff = PSS_SMEM_PGOFF(loff);
+	writel(pgnum, iocpf->ioc->ioc_regs.host_page_num_fn);
+
+	for (i = 0; i < sizeof(struct bfi_ioc_image_hdr_s) / sizeof(u32); i++) {
+		bfa_mem_write(iocpf->ioc->ioc_regs.smem_page_start, loff, 0);
+		loff += sizeof(u32);
+	}
 
 	bfa_trc(iocpf->ioc, fwstate);
-	bfa_trc(iocpf->ioc, fwhdr.exec);
+	bfa_trc(iocpf->ioc, swab32(fwhdr.exec));
 	writel(BFI_IOC_UNINIT, iocpf->ioc->ioc_regs.ioc_fwstate);
+	writel(BFI_IOC_UNINIT, iocpf->ioc->ioc_regs.alt_ioc_fwstate);
 
 	/*
-	 * Try to lock and then unlock the semaphore.
+	 * Unlock the hw semaphore. Should be here only once per boot.
 	 */
 	readl(iocpf->ioc->ioc_regs.ioc_sem_reg);
 	writel(1, iocpf->ioc->ioc_regs.ioc_sem_reg);
+
+	/*
+	 * unlock init semaphore.
+	 */
+	writel(1, iocpf->ioc->ioc_regs.ioc_init_sem_reg);
+
 sem_get:
 	bfa_ioc_hw_sem_get(iocpf->ioc);
 }
@@ -1707,11 +1740,6 @@ bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,
 	u32 i;
 	u32 asicmode;
 
-	/*
-	 * Initialize LMEM first before code download
-	 */
-	bfa_ioc_lmem_init(ioc);
-
 	bfa_trc(ioc, bfa_cb_image_get_size(bfa_ioc_asic_gen(ioc)));
 	fwimg = bfa_cb_image_get_chunk(bfa_ioc_asic_gen(ioc), chunkno);
 
@@ -1999,6 +2027,12 @@ bfa_ioc_pll_init(struct bfa_ioc_s *ioc)
 	bfa_ioc_pll_init_asic(ioc);
 
 	ioc->pllinit = BFA_TRUE;
+
+	/*
+	 * Initialize LMEM
+	 */
+	bfa_ioc_lmem_init(ioc);
+
 	/*
 	 *  release semaphore.
 	 */
@@ -4772,7 +4806,7 @@ diag_ledtest_send(struct bfa_diag_s *diag, struct bfa_diag_ledtest_s *ledtest)
 }
 
 static void
-diag_ledtest_comp(struct bfa_diag_s *diag, struct bfi_diag_ledtest_rsp_s * msg)
+diag_ledtest_comp(struct bfa_diag_s *diag, struct bfi_diag_ledtest_rsp_s *msg)
 {
 	bfa_trc(diag, diag->ledtest.lock);
 	diag->ledtest.lock = BFA_FALSE;
-- 
1.7.3.rc1

