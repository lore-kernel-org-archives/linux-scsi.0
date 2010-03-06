From: <kgudipat@brocade.com>
Subject: [PATCH 01/23] bfa: IOC changes: Support faster recovery and split bfa_ioc.c into ASIC specific code.
Date: Fri, 5 Mar 2010 19:34:20 -0800
Message-ID: <1267846460-21600-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:18072 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab0CFDep (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2010 22:34:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:

	- Add support for faster IOC recovery after failure.

	- Split bfa_ioc.c into three files:
		- bfa_ioc.c:    Common code shared between crossbow and catapult ASIC's.
		- bfa_ioc_cb.c: Code specific to the crossbow, reg mapping and interrupt related routines.
		- bfa_ioc_ct.c: Code specific to the catapult, reg mapping and interrupt related routines.

	- Fix to make sure IOC reinitialize's properly on enable request - update the ioc_fwstate reg
	  with BFI_IOC_FAIL on ioc disable mbox cmd timeout.

	- Makefile changes to support the 2 newly added files bfa_ioc_cb.c and bfa_ioc_ct.c.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/Makefile                     |    6 +-
 drivers/scsi/bfa/bfa_core.c                   |   10 +
 drivers/scsi/bfa/bfa_ioc.c                    |  546 +++++--------------------
 drivers/scsi/bfa/bfa_ioc.h                    |   45 ++-
 drivers/scsi/bfa/bfa_ioc_cb.c                 |  273 ++++++++++++
 drivers/scsi/bfa/bfa_ioc_ct.c                 |  422 +++++++++++++++++++
 drivers/scsi/bfa/include/bfa.h                |    1 +
 drivers/scsi/bfa/include/bfa_timer.h          |    2 +-
 drivers/scsi/bfa/include/bfi/bfi_cbreg.h      |    3 +-
 drivers/scsi/bfa/include/bfi/bfi_ctreg.h      |    2 +
 drivers/scsi/bfa/include/bfi/bfi_ioc.h        |    2 +-
 drivers/scsi/bfa/include/cna/bfa_cna_trcmod.h |    4 +
 12 files changed, 858 insertions(+), 458 deletions(-)
 create mode 100644 drivers/scsi/bfa/bfa_ioc_cb.c
 create mode 100644 drivers/scsi/bfa/bfa_ioc_ct.c

diff --git a/drivers/scsi/bfa/Makefile b/drivers/scsi/bfa/Makefile
index 1d60094..619e62a 100644
--- a/drivers/scsi/bfa/Makefile
+++ b/drivers/scsi/bfa/Makefile
@@ -2,8 +2,8 @@ obj-$(CONFIG_SCSI_BFA_FC) := bfa.o
 
 bfa-y := bfad.o bfad_intr.o bfad_os.o bfad_im.o bfad_attr.o bfad_fwimg.o
 
-bfa-y += bfa_core.o bfa_ioc.o bfa_iocfc.o bfa_fcxp.o bfa_lps.o
-bfa-y += bfa_hw_cb.o bfa_hw_ct.o bfa_intr.o bfa_timer.o bfa_rport.o 
+bfa-y += bfa_core.o bfa_ioc.o bfa_ioc_ct.o bfa_ioc_cb.o bfa_iocfc.o bfa_fcxp.o
+bfa-y += bfa_lps.o bfa_hw_cb.o bfa_hw_ct.o bfa_intr.o bfa_timer.o bfa_rport.o 
 bfa-y += bfa_fcport.o bfa_port.o bfa_uf.o bfa_sgpg.o bfa_module.o bfa_ioim.o
 bfa-y += bfa_itnim.o bfa_fcpim.o bfa_tskim.o bfa_log.o bfa_log_module.o
 bfa-y += bfa_csdebug.o bfa_sm.o plog.o
@@ -12,4 +12,4 @@ bfa-y += fcbuild.o fabric.o fcpim.o vfapi.o fcptm.o bfa_fcs.o bfa_fcs_port.o
 bfa-y += bfa_fcs_uf.o bfa_fcs_lport.o fab.o fdmi.o ms.o ns.o scn.o loop.o
 bfa-y += lport_api.o n2n.o rport.o rport_api.o rport_ftrs.o vport.o
 
-ccflags-y := -I$(obj) -I$(obj)/include -I$(obj)/include/cna
+ccflags-y := -I$(obj) -I$(obj)/include -I$(obj)/include/cna -DBFA_PERF_BUILD
diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 44e2d11..72e3f2f 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -399,4 +399,14 @@ bfa_debug_fwtrc(struct bfa_s *bfa, void *trcdata, int *trclen)
 {
 	return bfa_ioc_debug_fwtrc(&bfa->ioc, trcdata, trclen);
 }
+
+/**
+ * Reset hw semaphore & usage cnt regs and initialize.
+ */
+void
+bfa_chip_reset(struct bfa_s *bfa)
+{
+	bfa_ioc_ownership_reset(&bfa->ioc);
+	bfa_ioc_pll_init(&bfa->ioc);
+}
 #endif
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 569b35d..a5f9745 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -33,12 +33,11 @@ BFA_TRC_FILE(HAL, IOC);
  * IOC local definitions
  */
 #define BFA_IOC_TOV		2000	/* msecs */
-#define BFA_IOC_HB_TOV		1000	/* msecs */
-#define BFA_IOC_HB_FAIL_MAX	4
-#define BFA_IOC_HWINIT_MAX	2
+#define BFA_IOC_HWSEM_TOV       500     /* msecs */
+#define BFA_IOC_HB_TOV          500     /* msecs */
+#define BFA_IOC_HWINIT_MAX      2
 #define BFA_IOC_FWIMG_MINSZ     (16 * 1024)
-#define BFA_IOC_TOV_RECOVER	(BFA_IOC_HB_FAIL_MAX * BFA_IOC_HB_TOV \
-				+ BFA_IOC_TOV)
+#define BFA_IOC_TOV_RECOVER      BFA_IOC_HB_TOV
 
 #define bfa_ioc_timer_start(__ioc)					\
 	bfa_timer_begin((__ioc)->timer_mod, &(__ioc)->ioc_timer,	\
@@ -51,11 +50,24 @@ BFA_TRC_FILE(HAL, IOC);
 	 (sizeof(struct bfa_trc_mod_s) -			\
 	  BFA_TRC_MAX * sizeof(struct bfa_trc_s)))
 #define BFA_DBG_FWTRC_OFF(_fn)	(BFI_IOC_TRC_OFF + BFA_DBG_FWTRC_LEN * (_fn))
-#define bfa_ioc_stats(_ioc, _stats)	((_ioc)->stats._stats++)
 
-#define BFA_FLASH_CHUNK_NO(off)         (off / BFI_FLASH_CHUNK_SZ_WORDS)
-#define BFA_FLASH_OFFSET_IN_CHUNK(off)  (off % BFI_FLASH_CHUNK_SZ_WORDS)
-#define BFA_FLASH_CHUNK_ADDR(chunkno)   (chunkno * BFI_FLASH_CHUNK_SZ_WORDS)
+/**
+ * Asic specific macros : see bfa_hw_cb.c and bfa_hw_ct.c for details.
+ */
+
+#define bfa_ioc_firmware_lock(__ioc)                    \
+			((__ioc)->ioc_hwif->ioc_firmware_lock(__ioc))
+#define bfa_ioc_firmware_unlock(__ioc)                  \
+			((__ioc)->ioc_hwif->ioc_firmware_unlock(__ioc))
+#define bfa_ioc_fwimg_get_chunk(__ioc, __off)           \
+			((__ioc)->ioc_hwif->ioc_fwimg_get_chunk(__ioc, __off))
+#define bfa_ioc_fwimg_get_size(__ioc)                   \
+			((__ioc)->ioc_hwif->ioc_fwimg_get_size(__ioc))
+#define bfa_ioc_reg_init(__ioc) ((__ioc)->ioc_hwif->ioc_reg_init(__ioc))
+#define bfa_ioc_map_port(__ioc) ((__ioc)->ioc_hwif->ioc_map_port(__ioc))
+#define bfa_ioc_notify_hbfail(__ioc)                    \
+			((__ioc)->ioc_hwif->ioc_notify_hbfail(__ioc))
+
 bfa_boolean_t   bfa_auto_recover = BFA_TRUE;
 
 /*
@@ -64,7 +76,6 @@ bfa_boolean_t   bfa_auto_recover = BFA_TRUE;
 static void     bfa_ioc_aen_post(struct bfa_ioc_s *bfa,
 				 enum bfa_ioc_aen_event event);
 static void     bfa_ioc_hw_sem_get(struct bfa_ioc_s *ioc);
-static void     bfa_ioc_hw_sem_release(struct bfa_ioc_s *ioc);
 static void     bfa_ioc_hw_sem_get_cancel(struct bfa_ioc_s *ioc);
 static void     bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force);
 static void     bfa_ioc_timeout(void *ioc);
@@ -77,8 +88,6 @@ static void     bfa_ioc_reset(struct bfa_ioc_s *ioc, bfa_boolean_t force);
 static void     bfa_ioc_mbox_poll(struct bfa_ioc_s *ioc);
 static void     bfa_ioc_mbox_hbfail(struct bfa_ioc_s *ioc);
 static void     bfa_ioc_recover(struct bfa_ioc_s *ioc);
-static bfa_boolean_t bfa_ioc_firmware_lock(struct bfa_ioc_s *ioc);
-static void     bfa_ioc_firmware_unlock(struct bfa_ioc_s *ioc);
 static void     bfa_ioc_disable_comp(struct bfa_ioc_s *ioc);
 static void     bfa_ioc_lpu_stop(struct bfa_ioc_s *ioc);
 
@@ -508,14 +517,19 @@ bfa_ioc_sm_disabling(struct bfa_ioc_s *ioc, enum ioc_event event)
 	bfa_trc(ioc, event);
 
 	switch (event) {
-	case IOC_E_HWERROR:
 	case IOC_E_FWRSP_DISABLE:
 		bfa_ioc_timer_stop(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabled);
+		break;
+
+	case IOC_E_HWERROR:
+		bfa_ioc_timer_stop(ioc);
 		/*
 		 * !!! fall through !!!
 		 */
 
 	case IOC_E_TIMEOUT:
+		bfa_reg_write(ioc->ioc_regs.ioc_fwstate, BFI_IOC_FAIL);
 		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabled);
 		break;
 
@@ -608,15 +622,12 @@ bfa_ioc_sm_hbfail_entry(struct bfa_ioc_s *ioc)
 	 * Mark IOC as failed in hardware and stop firmware.
 	 */
 	bfa_ioc_lpu_stop(ioc);
-	bfa_reg_write(ioc->ioc_regs.ioc_fwstate, BFI_IOC_HBFAIL);
+	bfa_reg_write(ioc->ioc_regs.ioc_fwstate, BFI_IOC_FAIL);
 
-	if (ioc->pcidev.device_id == BFA_PCI_DEVICE_ID_CT) {
-		bfa_reg_write(ioc->ioc_regs.ll_halt, __FW_INIT_HALT_P);
-		/*
-		 * Wait for halt to take effect
-		 */
-		bfa_reg_read(ioc->ioc_regs.ll_halt);
-	}
+	/**
+	 * Notify other functions on HB failure.
+	 */
+	bfa_ioc_notify_hbfail(ioc);
 
 	/**
 	 * Notify driver and common modules registered for notification.
@@ -672,6 +683,12 @@ bfa_ioc_sm_hbfail(struct bfa_ioc_s *ioc, enum ioc_event event)
 		 */
 		break;
 
+	case IOC_E_HWERROR:
+		/*
+		 * HB failure notification, ignore.
+		 */
+		break;
+
 	default:
 		bfa_sm_fault(ioc, event);
 	}
@@ -700,7 +717,7 @@ bfa_ioc_disable_comp(struct bfa_ioc_s *ioc)
 	}
 }
 
-static void
+void
 bfa_ioc_sem_timeout(void *ioc_arg)
 {
 	struct bfa_ioc_s *ioc = (struct bfa_ioc_s *)ioc_arg;
@@ -708,26 +725,32 @@ bfa_ioc_sem_timeout(void *ioc_arg)
 	bfa_ioc_hw_sem_get(ioc);
 }
 
-static void
-bfa_ioc_usage_sem_get(struct bfa_ioc_s *ioc)
+bfa_boolean_t
+bfa_ioc_sem_get(bfa_os_addr_t sem_reg)
 {
-	u32        r32;
-	int             cnt = 0;
-#define BFA_SEM_SPINCNT	1000
+	u32 r32;
+	int cnt = 0;
+#define BFA_SEM_SPINCNT 3000
 
-	do {
-		r32 = bfa_reg_read(ioc->ioc_regs.ioc_usage_sem_reg);
+	r32 = bfa_reg_read(sem_reg);
+
+	while (r32 && (cnt < BFA_SEM_SPINCNT)) {
 		cnt++;
-		if (cnt > BFA_SEM_SPINCNT)
-			break;
-	} while (r32 != 0);
+		bfa_os_udelay(2);
+		r32 = bfa_reg_read(sem_reg);
+	}
+
+	if (r32 == 0)
+		return BFA_TRUE;
+
 	bfa_assert(cnt < BFA_SEM_SPINCNT);
+	return BFA_FALSE;
 }
 
-static void
-bfa_ioc_usage_sem_release(struct bfa_ioc_s *ioc)
+void
+bfa_ioc_sem_release(bfa_os_addr_t sem_reg)
 {
-	bfa_reg_write(ioc->ioc_regs.ioc_usage_sem_reg, 1);
+	bfa_reg_write(sem_reg, 1);
 }
 
 static void
@@ -737,7 +760,7 @@ bfa_ioc_hw_sem_get(struct bfa_ioc_s *ioc)
 
 	/**
 	 * First read to the semaphore register will return 0, subsequent reads
-	 * will return 1. Semaphore is released by writing 0 to the register
+	 * will return 1. Semaphore is released by writing 1 to the register
 	 */
 	r32 = bfa_reg_read(ioc->ioc_regs.ioc_sem_reg);
 	if (r32 == 0) {
@@ -746,10 +769,10 @@ bfa_ioc_hw_sem_get(struct bfa_ioc_s *ioc)
 	}
 
 	bfa_timer_begin(ioc->timer_mod, &ioc->sem_timer, bfa_ioc_sem_timeout,
-			ioc, BFA_IOC_TOV);
+			ioc, BFA_IOC_HWSEM_TOV);
 }
 
-static void
+void
 bfa_ioc_hw_sem_release(struct bfa_ioc_s *ioc)
 {
 	bfa_reg_write(ioc->ioc_regs.ioc_sem_reg, 1);
@@ -828,7 +851,7 @@ bfa_ioc_lpu_stop(struct bfa_ioc_s *ioc)
 /**
  * Get driver and firmware versions.
  */
-static void
+void
 bfa_ioc_fwver_get(struct bfa_ioc_s *ioc, struct bfi_ioc_image_hdr_s *fwhdr)
 {
 	u32        pgnum, pgoff;
@@ -847,24 +870,10 @@ bfa_ioc_fwver_get(struct bfa_ioc_s *ioc, struct bfi_ioc_image_hdr_s *fwhdr)
 	}
 }
 
-static u32 *
-bfa_ioc_fwimg_get_chunk(struct bfa_ioc_s *ioc, u32 off)
-{
-	if (ioc->ctdev)
-		return bfi_image_ct_get_chunk(off);
-	return bfi_image_cb_get_chunk(off);
-}
-
-static          u32
-bfa_ioc_fwimg_get_size(struct bfa_ioc_s *ioc)
-{
-return (ioc->ctdev) ? bfi_image_ct_size : bfi_image_cb_size;
-}
-
 /**
  * Returns TRUE if same.
  */
-static          bfa_boolean_t
+bfa_boolean_t
 bfa_ioc_fwver_cmp(struct bfa_ioc_s *ioc, struct bfi_ioc_image_hdr_s *fwhdr)
 {
 	struct bfi_ioc_image_hdr_s *drv_fwhdr;
@@ -921,95 +930,6 @@ bfa_ioc_fwver_valid(struct bfa_ioc_s *ioc)
 }
 
 /**
- * Return true if firmware of current driver matches the running firmware.
- */
-static          bfa_boolean_t
-bfa_ioc_firmware_lock(struct bfa_ioc_s *ioc)
-{
-	enum bfi_ioc_state ioc_fwstate;
-	u32        usecnt;
-	struct bfi_ioc_image_hdr_s fwhdr;
-
-	/**
-	 * Firmware match check is relevant only for CNA.
-	 */
-	if (!ioc->cna)
-		return BFA_TRUE;
-
-	/**
-	 * If bios boot (flash based) -- do not increment usage count
-	 */
-	if (bfa_ioc_fwimg_get_size(ioc) < BFA_IOC_FWIMG_MINSZ)
-		return BFA_TRUE;
-
-	bfa_ioc_usage_sem_get(ioc);
-	usecnt = bfa_reg_read(ioc->ioc_regs.ioc_usage_reg);
-
-	/**
-	 * If usage count is 0, always return TRUE.
-	 */
-	if (usecnt == 0) {
-		bfa_reg_write(ioc->ioc_regs.ioc_usage_reg, 1);
-		bfa_ioc_usage_sem_release(ioc);
-		bfa_trc(ioc, usecnt);
-		return BFA_TRUE;
-	}
-
-	ioc_fwstate = bfa_reg_read(ioc->ioc_regs.ioc_fwstate);
-	bfa_trc(ioc, ioc_fwstate);
-
-	/**
-	 * Use count cannot be non-zero and chip in uninitialized state.
-	 */
-	bfa_assert(ioc_fwstate != BFI_IOC_UNINIT);
-
-	/**
-	 * Check if another driver with a different firmware is active
-	 */
-	bfa_ioc_fwver_get(ioc, &fwhdr);
-	if (!bfa_ioc_fwver_cmp(ioc, &fwhdr)) {
-		bfa_ioc_usage_sem_release(ioc);
-		bfa_trc(ioc, usecnt);
-		return BFA_FALSE;
-	}
-
-	/**
-	 * Same firmware version. Increment the reference count.
-	 */
-	usecnt++;
-	bfa_reg_write(ioc->ioc_regs.ioc_usage_reg, usecnt);
-	bfa_ioc_usage_sem_release(ioc);
-	bfa_trc(ioc, usecnt);
-	return BFA_TRUE;
-}
-
-static void
-bfa_ioc_firmware_unlock(struct bfa_ioc_s *ioc)
-{
-	u32        usecnt;
-
-	/**
-	 * Firmware lock is relevant only for CNA.
-	 * If bios boot (flash based) -- do not decrement usage count
-	 */
-	if (!ioc->cna || (bfa_ioc_fwimg_get_size(ioc) < BFA_IOC_FWIMG_MINSZ))
-		return;
-
-	/**
-	 * decrement usage count
-	 */
-	bfa_ioc_usage_sem_get(ioc);
-	usecnt = bfa_reg_read(ioc->ioc_regs.ioc_usage_reg);
-	bfa_assert(usecnt > 0);
-
-	usecnt--;
-	bfa_reg_write(ioc->ioc_regs.ioc_usage_reg, usecnt);
-	bfa_trc(ioc, usecnt);
-
-	bfa_ioc_usage_sem_release(ioc);
-}
-
-/**
  * Conditionally flush any pending message from firmware at start.
  */
 static void
@@ -1152,33 +1072,27 @@ bfa_ioc_send_getattr(struct bfa_ioc_s *ioc)
 static void
 bfa_ioc_hb_check(void *cbarg)
 {
-	struct bfa_ioc_s *ioc = cbarg;
-	u32        hb_count;
+	struct bfa_ioc_s  *ioc = cbarg;
+	u32     hb_count;
 
 	hb_count = bfa_reg_read(ioc->ioc_regs.heartbeat);
 	if (ioc->hb_count == hb_count) {
-		ioc->hb_fail++;
-	} else {
-		ioc->hb_count = hb_count;
-		ioc->hb_fail = 0;
-	}
-
-	if (ioc->hb_fail >= BFA_IOC_HB_FAIL_MAX) {
-		bfa_log(ioc->logm, BFA_LOG_HAL_HEARTBEAT_FAILURE, hb_count);
-		ioc->hb_fail = 0;
+		bfa_log(ioc->logm, BFA_LOG_HAL_HEARTBEAT_FAILURE,
+			hb_count);
 		bfa_ioc_recover(ioc);
 		return;
+	} else {
+		ioc->hb_count = hb_count;
 	}
 
 	bfa_ioc_mbox_poll(ioc);
-	bfa_timer_begin(ioc->timer_mod, &ioc->ioc_timer, bfa_ioc_hb_check, ioc,
-			BFA_IOC_HB_TOV);
+	bfa_timer_begin(ioc->timer_mod, &ioc->ioc_timer, bfa_ioc_hb_check,
+			ioc, BFA_IOC_HB_TOV);
 }
 
 static void
 bfa_ioc_hb_monitor(struct bfa_ioc_s *ioc)
 {
-	ioc->hb_fail = 0;
 	ioc->hb_count = bfa_reg_read(ioc->ioc_regs.heartbeat);
 	bfa_timer_begin(ioc->timer_mod, &ioc->ioc_timer, bfa_ioc_hb_check, ioc,
 			BFA_IOC_HB_TOV);
@@ -1191,112 +1105,6 @@ bfa_ioc_hb_stop(struct bfa_ioc_s *ioc)
 }
 
 /**
- * Host to LPU mailbox message addresses
- */
-static struct {
-	u32        hfn_mbox, lpu_mbox, hfn_pgn;
-} iocreg_fnreg[] = {
-	{
-	HOSTFN0_LPU_MBOX0_0, LPU_HOSTFN0_MBOX0_0, HOST_PAGE_NUM_FN0}, {
-	HOSTFN1_LPU_MBOX0_8, LPU_HOSTFN1_MBOX0_8, HOST_PAGE_NUM_FN1}, {
-	HOSTFN2_LPU_MBOX0_0, LPU_HOSTFN2_MBOX0_0, HOST_PAGE_NUM_FN2}, {
-	HOSTFN3_LPU_MBOX0_8, LPU_HOSTFN3_MBOX0_8, HOST_PAGE_NUM_FN3}
-};
-
-/**
- * Host <-> LPU mailbox command/status registers - port 0
- */
-static struct {
-	u32        hfn, lpu;
-} iocreg_mbcmd_p0[] = {
-	{
-	HOSTFN0_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN0_MBOX0_CMD_STAT}, {
-	HOSTFN1_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN1_MBOX0_CMD_STAT}, {
-	HOSTFN2_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN2_MBOX0_CMD_STAT}, {
-	HOSTFN3_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN3_MBOX0_CMD_STAT}
-};
-
-/**
- * Host <-> LPU mailbox command/status registers - port 1
- */
-static struct {
-	u32        hfn, lpu;
-} iocreg_mbcmd_p1[] = {
-	{
-	HOSTFN0_LPU1_MBOX0_CMD_STAT, LPU1_HOSTFN0_MBOX0_CMD_STAT}, {
-	HOSTFN1_LPU1_MBOX0_CMD_STAT, LPU1_HOSTFN1_MBOX0_CMD_STAT}, {
-	HOSTFN2_LPU1_MBOX0_CMD_STAT, LPU1_HOSTFN2_MBOX0_CMD_STAT}, {
-	HOSTFN3_LPU1_MBOX0_CMD_STAT, LPU1_HOSTFN3_MBOX0_CMD_STAT}
-};
-
-/**
- * Shared IRQ handling in INTX mode
- */
-static struct {
-	u32        isr, msk;
-} iocreg_shirq_next[] = {
-	{
-	HOSTFN1_INT_STATUS, HOSTFN1_INT_MSK}, {
-	HOSTFN2_INT_STATUS, HOSTFN2_INT_MSK}, {
-	HOSTFN3_INT_STATUS, HOSTFN3_INT_MSK}, {
-HOSTFN0_INT_STATUS, HOSTFN0_INT_MSK},};
-
-static void
-bfa_ioc_reg_init(struct bfa_ioc_s *ioc)
-{
-	bfa_os_addr_t   rb;
-	int             pcifn = bfa_ioc_pcifn(ioc);
-
-	rb = bfa_ioc_bar0(ioc);
-
-	ioc->ioc_regs.hfn_mbox = rb + iocreg_fnreg[pcifn].hfn_mbox;
-	ioc->ioc_regs.lpu_mbox = rb + iocreg_fnreg[pcifn].lpu_mbox;
-	ioc->ioc_regs.host_page_num_fn = rb + iocreg_fnreg[pcifn].hfn_pgn;
-
-	if (ioc->port_id == 0) {
-		ioc->ioc_regs.heartbeat = rb + BFA_IOC0_HBEAT_REG;
-		ioc->ioc_regs.ioc_fwstate = rb + BFA_IOC0_STATE_REG;
-		ioc->ioc_regs.hfn_mbox_cmd = rb + iocreg_mbcmd_p0[pcifn].hfn;
-		ioc->ioc_regs.lpu_mbox_cmd = rb + iocreg_mbcmd_p0[pcifn].lpu;
-		ioc->ioc_regs.ll_halt = rb + FW_INIT_HALT_P0;
-	} else {
-		ioc->ioc_regs.heartbeat = (rb + BFA_IOC1_HBEAT_REG);
-		ioc->ioc_regs.ioc_fwstate = (rb + BFA_IOC1_STATE_REG);
-		ioc->ioc_regs.hfn_mbox_cmd = rb + iocreg_mbcmd_p1[pcifn].hfn;
-		ioc->ioc_regs.lpu_mbox_cmd = rb + iocreg_mbcmd_p1[pcifn].lpu;
-		ioc->ioc_regs.ll_halt = rb + FW_INIT_HALT_P1;
-	}
-
-	/**
-	 * Shared IRQ handling in INTX mode
-	 */
-	ioc->ioc_regs.shirq_isr_next = rb + iocreg_shirq_next[pcifn].isr;
-	ioc->ioc_regs.shirq_msk_next = rb + iocreg_shirq_next[pcifn].msk;
-
-	/*
-	 * PSS control registers
-	 */
-	ioc->ioc_regs.pss_ctl_reg = (rb + PSS_CTL_REG);
-	ioc->ioc_regs.app_pll_fast_ctl_reg = (rb + APP_PLL_425_CTL_REG);
-	ioc->ioc_regs.app_pll_slow_ctl_reg = (rb + APP_PLL_312_CTL_REG);
-
-	/*
-	 * IOC semaphore registers and serialization
-	 */
-	ioc->ioc_regs.ioc_sem_reg = (rb + HOST_SEM0_REG);
-	ioc->ioc_regs.ioc_usage_sem_reg = (rb + HOST_SEM1_REG);
-	ioc->ioc_regs.ioc_usage_reg = (rb + BFA_FW_USE_COUNT);
-
-	/**
-	 * sram memory access
-	 */
-	ioc->ioc_regs.smem_page_start = (rb + PSS_SMEM_PAGE_START);
-	ioc->ioc_regs.smem_pg0 = BFI_IOC_SMEM_PG0_CB;
-	if (ioc->pcidev.device_id == BFA_PCI_DEVICE_ID_CT)
-		ioc->ioc_regs.smem_pg0 = BFI_IOC_SMEM_PG0_CT;
-}
-
-/**
  *      Initiate a full firmware download.
  */
 static void
@@ -1332,17 +1140,17 @@ bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,
 
 	for (i = 0; i < bfa_ioc_fwimg_get_size(ioc); i++) {
 
-		if (BFA_FLASH_CHUNK_NO(i) != chunkno) {
-			chunkno = BFA_FLASH_CHUNK_NO(i);
+		if (BFA_IOC_FLASH_CHUNK_NO(i) != chunkno) {
+			chunkno = BFA_IOC_FLASH_CHUNK_NO(i);
 			fwimg = bfa_ioc_fwimg_get_chunk(ioc,
-					BFA_FLASH_CHUNK_ADDR(chunkno));
+					BFA_IOC_FLASH_CHUNK_ADDR(chunkno));
 		}
 
 		/**
 		 * write smem
 		 */
 		bfa_mem_write(ioc->ioc_regs.smem_page_start, loff,
-			      fwimg[BFA_FLASH_OFFSET_IN_CHUNK(i)]);
+			      fwimg[BFA_IOC_FLASH_OFFSET_IN_CHUNK(i)]);
 
 		loff += sizeof(u32);
 
@@ -1440,168 +1248,10 @@ bfa_ioc_mbox_hbfail(struct bfa_ioc_s *ioc)
 }
 
 /**
- * Initialize IOC to port mapping.
- */
-
-#define FNC_PERS_FN_SHIFT(__fn)	((__fn) * 8)
-static void
-bfa_ioc_map_port(struct bfa_ioc_s *ioc)
-{
-	bfa_os_addr_t   rb = ioc->pcidev.pci_bar_kva;
-	u32        r32;
-
-	/**
-	 * For crossbow, port id is same as pci function.
-	 */
-	if (ioc->pcidev.device_id != BFA_PCI_DEVICE_ID_CT) {
-		ioc->port_id = bfa_ioc_pcifn(ioc);
-		return;
-	}
-
-	/**
-	 * For catapult, base port id on personality register and IOC type
-	 */
-	r32 = bfa_reg_read(rb + FNC_PERS_REG);
-	r32 >>= FNC_PERS_FN_SHIFT(bfa_ioc_pcifn(ioc));
-	ioc->port_id = (r32 & __F0_PORT_MAP_MK) >> __F0_PORT_MAP_SH;
-
-	bfa_trc(ioc, bfa_ioc_pcifn(ioc));
-	bfa_trc(ioc, ioc->port_id);
-}
-
-
-
-/**
  *  bfa_ioc_public
  */
 
 /**
-* Set interrupt mode for a function: INTX or MSIX
- */
-void
-bfa_ioc_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix)
-{
-	bfa_os_addr_t   rb = ioc->pcidev.pci_bar_kva;
-	u32        r32, mode;
-
-	r32 = bfa_reg_read(rb + FNC_PERS_REG);
-	bfa_trc(ioc, r32);
-
-	mode = (r32 >> FNC_PERS_FN_SHIFT(bfa_ioc_pcifn(ioc))) &
-		__F0_INTX_STATUS;
-
-	/**
-	 * If already in desired mode, do not change anything
-	 */
-	if (!msix && mode)
-		return;
-
-	if (msix)
-		mode = __F0_INTX_STATUS_MSIX;
-	else
-		mode = __F0_INTX_STATUS_INTA;
-
-	r32 &= ~(__F0_INTX_STATUS << FNC_PERS_FN_SHIFT(bfa_ioc_pcifn(ioc)));
-	r32 |= (mode << FNC_PERS_FN_SHIFT(bfa_ioc_pcifn(ioc)));
-	bfa_trc(ioc, r32);
-
-	bfa_reg_write(rb + FNC_PERS_REG, r32);
-}
-
-bfa_status_t
-bfa_ioc_pll_init(struct bfa_ioc_s *ioc)
-{
-	bfa_os_addr_t   rb = ioc->pcidev.pci_bar_kva;
-	u32        pll_sclk, pll_fclk, r32;
-
-	if (ioc->pcidev.device_id == BFA_PCI_DEVICE_ID_CT) {
-		pll_sclk =
-			__APP_PLL_312_ENABLE | __APP_PLL_312_LRESETN |
-			__APP_PLL_312_RSEL200500 | __APP_PLL_312_P0_1(0U) |
-			__APP_PLL_312_JITLMT0_1(3U) |
-			__APP_PLL_312_CNTLMT0_1(1U);
-		pll_fclk =
-			__APP_PLL_425_ENABLE | __APP_PLL_425_LRESETN |
-			__APP_PLL_425_RSEL200500 | __APP_PLL_425_P0_1(0U) |
-			__APP_PLL_425_JITLMT0_1(3U) |
-			__APP_PLL_425_CNTLMT0_1(1U);
-
-		/**
-		 * 	For catapult, choose operational mode FC/FCoE
-		 */
-		if (ioc->fcmode) {
-			bfa_reg_write((rb + OP_MODE), 0);
-			bfa_reg_write((rb + ETH_MAC_SER_REG),
-				      __APP_EMS_CMLCKSEL | __APP_EMS_REFCKBUFEN2
-				      | __APP_EMS_CHANNEL_SEL);
-		} else {
-			ioc->pllinit = BFA_TRUE;
-			bfa_reg_write((rb + OP_MODE), __GLOBAL_FCOE_MODE);
-			bfa_reg_write((rb + ETH_MAC_SER_REG),
-				      __APP_EMS_REFCKBUFEN1);
-		}
-	} else {
-		pll_sclk =
-			__APP_PLL_312_ENABLE | __APP_PLL_312_LRESETN |
-			__APP_PLL_312_P0_1(3U) | __APP_PLL_312_JITLMT0_1(3U) |
-			__APP_PLL_312_CNTLMT0_1(3U);
-		pll_fclk =
-			__APP_PLL_425_ENABLE | __APP_PLL_425_LRESETN |
-			__APP_PLL_425_RSEL200500 | __APP_PLL_425_P0_1(3U) |
-			__APP_PLL_425_JITLMT0_1(3U) |
-			__APP_PLL_425_CNTLMT0_1(3U);
-	}
-
-	bfa_reg_write((rb + BFA_IOC0_STATE_REG), BFI_IOC_UNINIT);
-	bfa_reg_write((rb + BFA_IOC1_STATE_REG), BFI_IOC_UNINIT);
-
-	bfa_reg_write((rb + HOSTFN0_INT_MSK), 0xffffffffU);
-	bfa_reg_write((rb + HOSTFN1_INT_MSK), 0xffffffffU);
-	bfa_reg_write((rb + HOSTFN0_INT_STATUS), 0xffffffffU);
-	bfa_reg_write((rb + HOSTFN1_INT_STATUS), 0xffffffffU);
-	bfa_reg_write((rb + HOSTFN0_INT_MSK), 0xffffffffU);
-	bfa_reg_write((rb + HOSTFN1_INT_MSK), 0xffffffffU);
-
-	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
-		      __APP_PLL_312_LOGIC_SOFT_RESET);
-	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
-		      __APP_PLL_312_BYPASS | __APP_PLL_312_LOGIC_SOFT_RESET);
-	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
-		      __APP_PLL_425_LOGIC_SOFT_RESET);
-	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
-		      __APP_PLL_425_BYPASS | __APP_PLL_425_LOGIC_SOFT_RESET);
-	bfa_os_udelay(2);
-	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
-		      __APP_PLL_312_LOGIC_SOFT_RESET);
-	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
-		      __APP_PLL_425_LOGIC_SOFT_RESET);
-
-	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
-		      pll_sclk | __APP_PLL_312_LOGIC_SOFT_RESET);
-	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
-		      pll_fclk | __APP_PLL_425_LOGIC_SOFT_RESET);
-
-	/**
-	 * Wait for PLLs to lock.
-	 */
-	bfa_os_udelay(2000);
-	bfa_reg_write((rb + HOSTFN0_INT_STATUS), 0xffffffffU);
-	bfa_reg_write((rb + HOSTFN1_INT_STATUS), 0xffffffffU);
-
-	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg, pll_sclk);
-	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg, pll_fclk);
-
-	if (ioc->pcidev.device_id == BFA_PCI_DEVICE_ID_CT) {
-		bfa_reg_write((rb + MBIST_CTL_REG), __EDRAM_BISTR_START);
-		bfa_os_udelay(1000);
-		r32 = bfa_reg_read((rb + MBIST_STAT_REG));
-		bfa_trc(ioc, r32);
-	}
-
-	return BFA_STATUS_OK;
-}
-
-/**
  * Interface used by diag module to do firmware boot with memory test
  * as the entry vector.
  */
@@ -1764,6 +1414,14 @@ bfa_ioc_pci_init(struct bfa_ioc_s *ioc, struct bfa_pcidev_s *pcidev,
 	ioc->ctdev = (ioc->pcidev.device_id == BFA_PCI_DEVICE_ID_CT);
 	ioc->cna = ioc->ctdev && !ioc->fcmode;
 
+	/**
+	 * Set asic specific interfaces. See bfa_ioc_cb.c and bfa_ioc_ct.c
+	 */
+	if (ioc->ctdev)
+		bfa_ioc_set_ct_hwif(ioc);
+	else
+		bfa_ioc_set_cb_hwif(ioc);
+
 	bfa_ioc_map_port(ioc);
 	bfa_ioc_reg_init(ioc);
 }
@@ -1973,7 +1631,7 @@ bfa_ioc_fw_mismatch(struct bfa_ioc_s *ioc)
 	 ((__sm) == BFI_IOC_INITING) ||		\
 	 ((__sm) == BFI_IOC_HWINIT) ||		\
 	 ((__sm) == BFI_IOC_DISABLED) ||	\
-	 ((__sm) == BFI_IOC_HBFAIL) ||		\
+	 ((__sm) == BFI_IOC_FAIL) ||		\
 	 ((__sm) == BFI_IOC_CFG_DISABLED))
 
 /**
@@ -2195,29 +1853,6 @@ bfa_ioc_get_fcmode(struct bfa_ioc_s *ioc)
 }
 
 /**
- * Return true if interrupt should be claimed.
- */
-bfa_boolean_t
-bfa_ioc_intx_claim(struct bfa_ioc_s *ioc)
-{
-	u32        isr, msk;
-
-	/**
-	 * Always claim if not catapult.
-	 */
-	if (!ioc->ctdev)
-		return BFA_TRUE;
-
-	/**
-	 * FALSE if next device is claiming interrupt.
-	 * TRUE if next device is not interrupting or not present.
-	 */
-	msk = bfa_reg_read(ioc->ioc_regs.shirq_msk_next);
-	isr = bfa_reg_read(ioc->ioc_regs.shirq_isr_next);
-	return !(isr & ~msk);
-}
-
-/**
  * Send AEN notification
  */
 static void
@@ -2304,6 +1939,13 @@ bfa_ioc_debug_fwtrc(struct bfa_ioc_s *ioc, void *trcdata, int *trclen)
 
 	pgnum = bfa_ioc_smem_pgnum(ioc, loff);
 	loff = bfa_ioc_smem_pgoff(ioc, loff);
+
+	/*
+	 *  Hold semaphore to serialize pll init and fwtrc.
+	 */
+	if (BFA_FALSE == bfa_ioc_sem_get(ioc->ioc_regs.ioc_init_sem_reg))
+		return BFA_STATUS_FAILED;
+
 	bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
 
 	tlen = *trclen;
@@ -2329,6 +1971,12 @@ bfa_ioc_debug_fwtrc(struct bfa_ioc_s *ioc, void *trcdata, int *trclen)
 	}
 	bfa_reg_write(ioc->ioc_regs.host_page_num_fn,
 		      bfa_ioc_smem_pgnum(ioc, 0));
+
+	/*
+	 *  release semaphore.
+	 */
+	bfa_ioc_sem_release(ioc->ioc_regs.ioc_init_sem_reg);
+
 	bfa_trc(ioc, pgnum);
 
 	*trclen = tlen * sizeof(u32);
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index 7c30f05..1633a50 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -78,11 +78,13 @@ struct bfa_ioc_regs_s {
 	bfa_os_addr_t   app_pll_slow_ctl_reg;
 	bfa_os_addr_t   ioc_sem_reg;
 	bfa_os_addr_t   ioc_usage_sem_reg;
+	bfa_os_addr_t   ioc_init_sem_reg;
 	bfa_os_addr_t   ioc_usage_reg;
 	bfa_os_addr_t   host_page_num_fn;
 	bfa_os_addr_t   heartbeat;
 	bfa_os_addr_t   ioc_fwstate;
 	bfa_os_addr_t   ll_halt;
+	bfa_os_addr_t   err_set;
 	bfa_os_addr_t   shirq_isr_next;
 	bfa_os_addr_t   shirq_msk_next;
 	bfa_os_addr_t   smem_page_start;
@@ -154,7 +156,6 @@ struct bfa_ioc_s {
 	struct bfa_timer_s 	ioc_timer;
 	struct bfa_timer_s 	sem_timer;
 	u32		hb_count;
-	u32		hb_fail;
 	u32		retry_count;
 	struct list_head		hb_notify_q;
 	void			*dbg_fwsave;
@@ -177,6 +178,22 @@ struct bfa_ioc_s {
 	struct bfi_ioc_attr_s	*attr;
 	struct bfa_ioc_cbfn_s	*cbfn;
 	struct bfa_ioc_mbox_mod_s mbox_mod;
+	struct bfa_ioc_hwif_s   *ioc_hwif;
+};
+
+struct bfa_ioc_hwif_s {
+	bfa_status_t    (*ioc_pll_init) (struct bfa_ioc_s *ioc);
+	bfa_boolean_t   (*ioc_firmware_lock)    (struct bfa_ioc_s *ioc);
+	void            (*ioc_firmware_unlock)  (struct bfa_ioc_s *ioc);
+	u32 *   	(*ioc_fwimg_get_chunk)  (struct bfa_ioc_s *ioc,
+						u32 off);
+	u32		(*ioc_fwimg_get_size)   (struct bfa_ioc_s *ioc);
+	void		(*ioc_reg_init) (struct bfa_ioc_s *ioc);
+	void		(*ioc_map_port) (struct bfa_ioc_s *ioc);
+	void		(*ioc_isr_mode_set)     (struct bfa_ioc_s *ioc,
+						bfa_boolean_t msix);
+	void            (*ioc_notify_hbfail)    (struct bfa_ioc_s *ioc);
+	void            (*ioc_ownership_reset)  (struct bfa_ioc_s *ioc);
 };
 
 #define bfa_ioc_pcifn(__ioc)		((__ioc)->pcidev.pci_func)
@@ -191,6 +208,15 @@ struct bfa_ioc_s {
 #define bfa_ioc_rx_bbcredit(__ioc)	((__ioc)->attr->rx_bbcredit)
 #define bfa_ioc_speed_sup(__ioc)	\
 	BFI_ADAPTER_GETP(SPEED, (__ioc)->attr->adapter_prop)
+#define bfa_ioc_get_nports(__ioc)       \
+	BFI_ADAPTER_GETP(NPORTS, (__ioc)->attr->adapter_prop)
+
+#define bfa_ioc_stats(_ioc, _stats)     ((_ioc)->stats._stats++)
+#define BFA_IOC_FWIMG_MINSZ     (16 * 1024)
+
+#define BFA_IOC_FLASH_CHUNK_NO(off)             (off / BFI_FLASH_CHUNK_SZ_WORDS)
+#define BFA_IOC_FLASH_OFFSET_IN_CHUNK(off)      (off % BFI_FLASH_CHUNK_SZ_WORDS)
+#define BFA_IOC_FLASH_CHUNK_ADDR(chunkno)  (chunkno * BFI_FLASH_CHUNK_SZ_WORDS)
 
 /**
  * IOC mailbox interface
@@ -207,6 +233,14 @@ void bfa_ioc_mbox_regisr(struct bfa_ioc_s *ioc, enum bfi_mclass mc,
 /**
  * IOC interfaces
  */
+#define bfa_ioc_pll_init(__ioc) ((__ioc)->ioc_hwif->ioc_pll_init(__ioc))
+#define bfa_ioc_isr_mode_set(__ioc, __msix)                     \
+			((__ioc)->ioc_hwif->ioc_isr_mode_set(__ioc, __msix))
+#define bfa_ioc_ownership_reset(__ioc)                          \
+			((__ioc)->ioc_hwif->ioc_ownership_reset(__ioc))
+
+void bfa_ioc_set_ct_hwif(struct bfa_ioc_s *ioc);
+void bfa_ioc_set_cb_hwif(struct bfa_ioc_s *ioc);
 void bfa_ioc_attach(struct bfa_ioc_s *ioc, void *bfa,
 		struct bfa_ioc_cbfn_s *cbfn, struct bfa_timer_mod_s *timer_mod,
 		struct bfa_trc_mod_s *trcmod,
@@ -223,8 +257,6 @@ bfa_boolean_t bfa_ioc_intx_claim(struct bfa_ioc_s *ioc);
 void bfa_ioc_boot(struct bfa_ioc_s *ioc, u32 boot_type, u32 boot_param);
 void bfa_ioc_isr(struct bfa_ioc_s *ioc, struct bfi_mbmsg_s *msg);
 void bfa_ioc_error_isr(struct bfa_ioc_s *ioc);
-void bfa_ioc_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t intx);
-bfa_status_t bfa_ioc_pll_init(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_is_operational(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_is_disabled(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_fw_mismatch(struct bfa_ioc_s *ioc);
@@ -245,6 +277,13 @@ void bfa_ioc_set_fcmode(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_get_fcmode(struct bfa_ioc_s *ioc);
 void bfa_ioc_hbfail_register(struct bfa_ioc_s *ioc,
 	struct bfa_ioc_hbfail_notify_s *notify);
+bfa_boolean_t bfa_ioc_sem_get(bfa_os_addr_t sem_reg);
+void bfa_ioc_sem_release(bfa_os_addr_t sem_reg);
+void bfa_ioc_hw_sem_release(struct bfa_ioc_s *ioc);
+void bfa_ioc_fwver_get(struct bfa_ioc_s *ioc,
+			struct bfi_ioc_image_hdr_s *fwhdr);
+bfa_boolean_t bfa_ioc_fwver_cmp(struct bfa_ioc_s *ioc,
+			struct bfi_ioc_image_hdr_s *fwhdr);
 
 /*
  * bfa mfg wwn API functions
diff --git a/drivers/scsi/bfa/bfa_ioc_cb.c b/drivers/scsi/bfa/bfa_ioc_cb.c
new file mode 100644
index 0000000..d1d625b
--- /dev/null
+++ b/drivers/scsi/bfa/bfa_ioc_cb.c
@@ -0,0 +1,273 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <bfa.h>
+#include <bfa_ioc.h>
+#include <bfa_fwimg_priv.h>
+#include <cna/bfa_cna_trcmod.h>
+#include <cs/bfa_debug.h>
+#include <bfi/bfi_ioc.h>
+#include <bfi/bfi_cbreg.h>
+#include <log/bfa_log_hal.h>
+#include <defs/bfa_defs_pci.h>
+
+BFA_TRC_FILE(CNA, IOC_CB);
+
+/*
+ * forward declarations
+ */
+static bfa_status_t bfa_ioc_cb_pll_init(struct bfa_ioc_s *ioc);
+static bfa_boolean_t bfa_ioc_cb_firmware_lock(struct bfa_ioc_s *ioc);
+static void bfa_ioc_cb_firmware_unlock(struct bfa_ioc_s *ioc);
+static u32  *bfa_ioc_cb_fwimg_get_chunk(struct bfa_ioc_s *ioc, u32 off);
+static u32 bfa_ioc_cb_fwimg_get_size(struct bfa_ioc_s *ioc);
+static void bfa_ioc_cb_reg_init(struct bfa_ioc_s *ioc);
+static void bfa_ioc_cb_map_port(struct bfa_ioc_s *ioc);
+static void bfa_ioc_cb_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix);
+static void bfa_ioc_cb_notify_hbfail(struct bfa_ioc_s *ioc);
+static void bfa_ioc_cb_ownership_reset(struct bfa_ioc_s *ioc);
+
+struct bfa_ioc_hwif_s hwif_cb = {
+	bfa_ioc_cb_pll_init,
+	bfa_ioc_cb_firmware_lock,
+	bfa_ioc_cb_firmware_unlock,
+	bfa_ioc_cb_fwimg_get_chunk,
+	bfa_ioc_cb_fwimg_get_size,
+	bfa_ioc_cb_reg_init,
+	bfa_ioc_cb_map_port,
+	bfa_ioc_cb_isr_mode_set,
+	bfa_ioc_cb_notify_hbfail,
+	bfa_ioc_cb_ownership_reset,
+};
+
+/**
+ * Called from bfa_ioc_attach() to map asic specific calls.
+ */
+void
+bfa_ioc_set_cb_hwif(struct bfa_ioc_s *ioc)
+{
+	ioc->ioc_hwif = &hwif_cb;
+}
+
+static uint32_t *
+bfa_ioc_cb_fwimg_get_chunk(struct bfa_ioc_s *ioc, uint32_t off)
+{
+	return bfi_image_cb_get_chunk(off);
+}
+
+static uint32_t
+bfa_ioc_cb_fwimg_get_size(struct bfa_ioc_s *ioc)
+{
+	return bfi_image_cb_size;
+}
+
+/**
+ * Return true if firmware of current driver matches the running firmware.
+ */
+static bfa_boolean_t
+bfa_ioc_cb_firmware_lock(struct bfa_ioc_s *ioc)
+{
+	return BFA_TRUE;
+}
+
+static void
+bfa_ioc_cb_firmware_unlock(struct bfa_ioc_s *ioc)
+{
+}
+
+/**
+ * Notify other functions on HB failure.
+ */
+static void
+bfa_ioc_cb_notify_hbfail(struct bfa_ioc_s *ioc)
+{
+	bfa_reg_write(ioc->ioc_regs.err_set, __PSS_ERR_STATUS_SET);
+	bfa_reg_read(ioc->ioc_regs.err_set);
+}
+
+/**
+ * Host to LPU mailbox message addresses
+ */
+static struct { uint32_t hfn_mbox, lpu_mbox, hfn_pgn; } iocreg_fnreg[] = {
+	{ HOSTFN0_LPU_MBOX0_0, LPU_HOSTFN0_MBOX0_0, HOST_PAGE_NUM_FN0 },
+	{ HOSTFN1_LPU_MBOX0_8, LPU_HOSTFN1_MBOX0_8, HOST_PAGE_NUM_FN1 }
+};
+
+/**
+ * Host <-> LPU mailbox command/status registers
+ */
+static struct { uint32_t hfn, lpu; } iocreg_mbcmd[] = {
+	{ HOSTFN0_LPU0_CMD_STAT, LPU0_HOSTFN0_CMD_STAT },
+	{ HOSTFN1_LPU1_CMD_STAT, LPU1_HOSTFN1_CMD_STAT }
+};
+
+static void
+bfa_ioc_cb_reg_init(struct bfa_ioc_s *ioc)
+{
+	bfa_os_addr_t	rb;
+	int		pcifn = bfa_ioc_pcifn(ioc);
+
+	rb = bfa_ioc_bar0(ioc);
+
+	ioc->ioc_regs.hfn_mbox = rb + iocreg_fnreg[pcifn].hfn_mbox;
+	ioc->ioc_regs.lpu_mbox = rb + iocreg_fnreg[pcifn].lpu_mbox;
+	ioc->ioc_regs.host_page_num_fn = rb + iocreg_fnreg[pcifn].hfn_pgn;
+
+	if (ioc->port_id == 0) {
+		ioc->ioc_regs.heartbeat = rb + BFA_IOC0_HBEAT_REG;
+		ioc->ioc_regs.ioc_fwstate = rb + BFA_IOC0_STATE_REG;
+	} else {
+		ioc->ioc_regs.heartbeat = (rb + BFA_IOC1_HBEAT_REG);
+		ioc->ioc_regs.ioc_fwstate = (rb + BFA_IOC1_STATE_REG);
+	}
+
+	/**
+	 * Host <-> LPU mailbox command/status registers
+	 */
+	ioc->ioc_regs.hfn_mbox_cmd = rb + iocreg_mbcmd[pcifn].hfn;
+	ioc->ioc_regs.lpu_mbox_cmd = rb + iocreg_mbcmd[pcifn].lpu;
+
+	/*
+	 * PSS control registers
+	 */
+	ioc->ioc_regs.pss_ctl_reg = (rb + PSS_CTL_REG);
+	ioc->ioc_regs.app_pll_fast_ctl_reg = (rb + APP_PLL_400_CTL_REG);
+	ioc->ioc_regs.app_pll_slow_ctl_reg = (rb + APP_PLL_212_CTL_REG);
+
+	/*
+	 * IOC semaphore registers and serialization
+	 */
+	ioc->ioc_regs.ioc_sem_reg = (rb + HOST_SEM0_REG);
+	ioc->ioc_regs.ioc_init_sem_reg = (rb + HOST_SEM2_REG);
+
+	/**
+	 * sram memory access
+	 */
+	ioc->ioc_regs.smem_page_start = (rb + PSS_SMEM_PAGE_START);
+	ioc->ioc_regs.smem_pg0 = BFI_IOC_SMEM_PG0_CB;
+
+	/*
+	 * err set reg : for notification of hb failure
+	 */
+	ioc->ioc_regs.err_set = (rb + ERR_SET_REG);
+}
+
+/**
+ * Initialize IOC to port mapping.
+ */
+static void
+bfa_ioc_cb_map_port(struct bfa_ioc_s *ioc)
+{
+	/**
+	 * For crossbow, port id is same as pci function.
+	 */
+	ioc->port_id = bfa_ioc_pcifn(ioc);
+	bfa_trc(ioc, ioc->port_id);
+}
+
+/**
+ * Set interrupt mode for a function: INTX or MSIX
+ */
+static void
+bfa_ioc_cb_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix)
+{
+}
+
+static bfa_status_t
+bfa_ioc_cb_pll_init(struct bfa_ioc_s *ioc)
+{
+	bfa_os_addr_t	rb = ioc->pcidev.pci_bar_kva;
+	uint32_t	pll_sclk, pll_fclk;
+
+	/*
+	 *  Hold semaphore so that nobody can access the chip during init.
+	 */
+	bfa_ioc_sem_get(ioc->ioc_regs.ioc_init_sem_reg);
+
+	pll_sclk = __APP_PLL_212_ENABLE | __APP_PLL_212_LRESETN |
+			__APP_PLL_212_P0_1(3U) |
+			__APP_PLL_212_JITLMT0_1(3U) |
+			__APP_PLL_212_CNTLMT0_1(3U);
+	pll_fclk = __APP_PLL_400_ENABLE | __APP_PLL_400_LRESETN |
+			__APP_PLL_400_RSEL200500 | __APP_PLL_400_P0_1(3U) |
+			__APP_PLL_400_JITLMT0_1(3U) |
+			__APP_PLL_400_CNTLMT0_1(3U);
+
+	bfa_reg_write((rb + BFA_IOC0_STATE_REG), BFI_IOC_UNINIT);
+	bfa_reg_write((rb + BFA_IOC1_STATE_REG), BFI_IOC_UNINIT);
+
+	bfa_reg_write((rb + HOSTFN0_INT_MSK), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN1_INT_MSK), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN0_INT_STATUS), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN1_INT_STATUS), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN0_INT_MSK), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN1_INT_MSK), 0xffffffffU);
+
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
+			__APP_PLL_212_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
+			__APP_PLL_212_BYPASS |
+			__APP_PLL_212_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
+			__APP_PLL_400_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
+			__APP_PLL_400_BYPASS |
+			__APP_PLL_400_LOGIC_SOFT_RESET);
+	bfa_os_udelay(2);
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
+			__APP_PLL_212_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
+			__APP_PLL_400_LOGIC_SOFT_RESET);
+
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
+			pll_sclk | __APP_PLL_212_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
+			pll_fclk | __APP_PLL_400_LOGIC_SOFT_RESET);
+
+	/**
+	 * Wait for PLLs to lock.
+	 */
+	bfa_os_udelay(2000);
+	bfa_reg_write((rb + HOSTFN0_INT_STATUS), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN1_INT_STATUS), 0xffffffffU);
+
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg, pll_sclk);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg, pll_fclk);
+
+	/*
+	 *  release semaphore.
+	 */
+	bfa_ioc_sem_release(ioc->ioc_regs.ioc_init_sem_reg);
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ * Cleanup hw semaphore and usecnt registers
+ */
+static void
+bfa_ioc_cb_ownership_reset(struct bfa_ioc_s *ioc)
+{
+
+	/*
+	 * Read the hw sem reg to make sure that it is locked
+	 * before we clear it. If it is not locked, writing 1
+	 * will lock it instead of clearing it.
+	 */
+	bfa_reg_read(ioc->ioc_regs.ioc_sem_reg);
+	bfa_ioc_hw_sem_release(ioc);
+}
diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
new file mode 100644
index 0000000..5de9c24
--- /dev/null
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -0,0 +1,422 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <bfa.h>
+#include <bfa_ioc.h>
+#include <bfa_fwimg_priv.h>
+#include <cna/bfa_cna_trcmod.h>
+#include <cs/bfa_debug.h>
+#include <bfi/bfi_ioc.h>
+#include <bfi/bfi_ctreg.h>
+#include <log/bfa_log_hal.h>
+#include <defs/bfa_defs_pci.h>
+
+BFA_TRC_FILE(CNA, IOC_CT);
+
+/*
+ * forward declarations
+ */
+static bfa_status_t bfa_ioc_ct_pll_init(struct bfa_ioc_s *ioc);
+static bfa_boolean_t bfa_ioc_ct_firmware_lock(struct bfa_ioc_s *ioc);
+static void bfa_ioc_ct_firmware_unlock(struct bfa_ioc_s *ioc);
+static uint32_t* bfa_ioc_ct_fwimg_get_chunk(struct bfa_ioc_s *ioc,
+					uint32_t off);
+static uint32_t bfa_ioc_ct_fwimg_get_size(struct bfa_ioc_s *ioc);
+static void bfa_ioc_ct_reg_init(struct bfa_ioc_s *ioc);
+static void bfa_ioc_ct_map_port(struct bfa_ioc_s *ioc);
+static void bfa_ioc_ct_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix);
+static void bfa_ioc_ct_notify_hbfail(struct bfa_ioc_s *ioc);
+static void bfa_ioc_ct_ownership_reset(struct bfa_ioc_s *ioc);
+
+struct bfa_ioc_hwif_s hwif_ct = {
+	bfa_ioc_ct_pll_init,
+	bfa_ioc_ct_firmware_lock,
+	bfa_ioc_ct_firmware_unlock,
+	bfa_ioc_ct_fwimg_get_chunk,
+	bfa_ioc_ct_fwimg_get_size,
+	bfa_ioc_ct_reg_init,
+	bfa_ioc_ct_map_port,
+	bfa_ioc_ct_isr_mode_set,
+	bfa_ioc_ct_notify_hbfail,
+	bfa_ioc_ct_ownership_reset,
+};
+
+/**
+ * Called from bfa_ioc_attach() to map asic specific calls.
+ */
+void
+bfa_ioc_set_ct_hwif(struct bfa_ioc_s *ioc)
+{
+	ioc->ioc_hwif = &hwif_ct;
+}
+
+static uint32_t*
+bfa_ioc_ct_fwimg_get_chunk(struct bfa_ioc_s *ioc, uint32_t off)
+{
+	return bfi_image_ct_get_chunk(off);
+}
+
+static uint32_t
+bfa_ioc_ct_fwimg_get_size(struct bfa_ioc_s *ioc)
+{
+	return bfi_image_ct_size;
+}
+
+/**
+ * Return true if firmware of current driver matches the running firmware.
+ */
+static bfa_boolean_t
+bfa_ioc_ct_firmware_lock(struct bfa_ioc_s *ioc)
+{
+	enum bfi_ioc_state ioc_fwstate;
+	uint32_t usecnt;
+	struct bfi_ioc_image_hdr_s fwhdr;
+
+	/**
+	 * Firmware match check is relevant only for CNA.
+	 */
+	if (!ioc->cna)
+		return BFA_TRUE;
+
+	/**
+	 * If bios boot (flash based) -- do not increment usage count
+	 */
+	if (bfa_ioc_ct_fwimg_get_size(ioc) < BFA_IOC_FWIMG_MINSZ)
+		return BFA_TRUE;
+
+	bfa_ioc_sem_get(ioc->ioc_regs.ioc_usage_sem_reg);
+	usecnt = bfa_reg_read(ioc->ioc_regs.ioc_usage_reg);
+
+	/**
+	 * If usage count is 0, always return TRUE.
+	 */
+	if (usecnt == 0) {
+		bfa_reg_write(ioc->ioc_regs.ioc_usage_reg, 1);
+		bfa_ioc_sem_release(ioc->ioc_regs.ioc_usage_sem_reg);
+		bfa_trc(ioc, usecnt);
+		return BFA_TRUE;
+	}
+
+	ioc_fwstate = bfa_reg_read(ioc->ioc_regs.ioc_fwstate);
+	bfa_trc(ioc, ioc_fwstate);
+
+	/**
+	 * Use count cannot be non-zero and chip in uninitialized state.
+	 */
+	bfa_assert(ioc_fwstate != BFI_IOC_UNINIT);
+
+	/**
+	 * Check if another driver with a different firmware is active
+	 */
+	bfa_ioc_fwver_get(ioc, &fwhdr);
+	if (!bfa_ioc_fwver_cmp(ioc, &fwhdr)) {
+		bfa_ioc_sem_release(ioc->ioc_regs.ioc_usage_sem_reg);
+		bfa_trc(ioc, usecnt);
+		return BFA_FALSE;
+	}
+
+	/**
+	 * Same firmware version. Increment the reference count.
+	 */
+	usecnt++;
+	bfa_reg_write(ioc->ioc_regs.ioc_usage_reg, usecnt);
+	bfa_ioc_sem_release(ioc->ioc_regs.ioc_usage_sem_reg);
+	bfa_trc(ioc, usecnt);
+	return BFA_TRUE;
+}
+
+static void
+bfa_ioc_ct_firmware_unlock(struct bfa_ioc_s *ioc)
+{
+	uint32_t usecnt;
+
+	/**
+	 * Firmware lock is relevant only for CNA.
+	 * If bios boot (flash based) -- do not decrement usage count
+	 */
+	if (!ioc->cna || bfa_ioc_ct_fwimg_get_size(ioc) < BFA_IOC_FWIMG_MINSZ)
+		return;
+
+	/**
+	 * decrement usage count
+	 */
+	bfa_ioc_sem_get(ioc->ioc_regs.ioc_usage_sem_reg);
+	usecnt = bfa_reg_read(ioc->ioc_regs.ioc_usage_reg);
+	bfa_assert(usecnt > 0);
+
+	usecnt--;
+	bfa_reg_write(ioc->ioc_regs.ioc_usage_reg, usecnt);
+	bfa_trc(ioc, usecnt);
+
+	bfa_ioc_sem_release(ioc->ioc_regs.ioc_usage_sem_reg);
+}
+
+/**
+ * Notify other functions on HB failure.
+ */
+static void
+bfa_ioc_ct_notify_hbfail(struct bfa_ioc_s *ioc)
+{
+
+	bfa_reg_write(ioc->ioc_regs.ll_halt, __FW_INIT_HALT_P);
+	/* Wait for halt to take effect */
+	bfa_reg_read(ioc->ioc_regs.ll_halt);
+}
+
+/**
+ * Host to LPU mailbox message addresses
+ */
+static struct { uint32_t hfn_mbox, lpu_mbox, hfn_pgn; } iocreg_fnreg[] = {
+	{ HOSTFN0_LPU_MBOX0_0, LPU_HOSTFN0_MBOX0_0, HOST_PAGE_NUM_FN0 },
+	{ HOSTFN1_LPU_MBOX0_8, LPU_HOSTFN1_MBOX0_8, HOST_PAGE_NUM_FN1 },
+	{ HOSTFN2_LPU_MBOX0_0, LPU_HOSTFN2_MBOX0_0, HOST_PAGE_NUM_FN2 },
+	{ HOSTFN3_LPU_MBOX0_8, LPU_HOSTFN3_MBOX0_8, HOST_PAGE_NUM_FN3 }
+};
+
+/**
+ * Host <-> LPU mailbox command/status registers - port 0
+ */
+static struct { uint32_t hfn, lpu; } iocreg_mbcmd_p0[] = {
+	{ HOSTFN0_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN0_MBOX0_CMD_STAT },
+	{ HOSTFN1_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN1_MBOX0_CMD_STAT },
+	{ HOSTFN2_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN2_MBOX0_CMD_STAT },
+	{ HOSTFN3_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN3_MBOX0_CMD_STAT }
+};
+
+/**
+ * Host <-> LPU mailbox command/status registers - port 1
+ */
+static struct { uint32_t hfn, lpu; } iocreg_mbcmd_p1[] = {
+	{ HOSTFN0_LPU1_MBOX0_CMD_STAT, LPU1_HOSTFN0_MBOX0_CMD_STAT },
+	{ HOSTFN1_LPU1_MBOX0_CMD_STAT, LPU1_HOSTFN1_MBOX0_CMD_STAT },
+	{ HOSTFN2_LPU1_MBOX0_CMD_STAT, LPU1_HOSTFN2_MBOX0_CMD_STAT },
+	{ HOSTFN3_LPU1_MBOX0_CMD_STAT, LPU1_HOSTFN3_MBOX0_CMD_STAT }
+};
+
+static void
+bfa_ioc_ct_reg_init(struct bfa_ioc_s *ioc)
+{
+	bfa_os_addr_t	rb;
+	int		pcifn = bfa_ioc_pcifn(ioc);
+
+	rb = bfa_ioc_bar0(ioc);
+
+	ioc->ioc_regs.hfn_mbox = rb + iocreg_fnreg[pcifn].hfn_mbox;
+	ioc->ioc_regs.lpu_mbox = rb + iocreg_fnreg[pcifn].lpu_mbox;
+	ioc->ioc_regs.host_page_num_fn = rb + iocreg_fnreg[pcifn].hfn_pgn;
+
+	if (ioc->port_id == 0) {
+		ioc->ioc_regs.heartbeat = rb + BFA_IOC0_HBEAT_REG;
+		ioc->ioc_regs.ioc_fwstate = rb + BFA_IOC0_STATE_REG;
+		ioc->ioc_regs.hfn_mbox_cmd = rb + iocreg_mbcmd_p0[pcifn].hfn;
+		ioc->ioc_regs.lpu_mbox_cmd = rb + iocreg_mbcmd_p0[pcifn].lpu;
+		ioc->ioc_regs.ll_halt = rb + FW_INIT_HALT_P0;
+	} else {
+		ioc->ioc_regs.heartbeat = (rb + BFA_IOC1_HBEAT_REG);
+		ioc->ioc_regs.ioc_fwstate = (rb + BFA_IOC1_STATE_REG);
+		ioc->ioc_regs.hfn_mbox_cmd = rb + iocreg_mbcmd_p1[pcifn].hfn;
+		ioc->ioc_regs.lpu_mbox_cmd = rb + iocreg_mbcmd_p1[pcifn].lpu;
+		ioc->ioc_regs.ll_halt = rb + FW_INIT_HALT_P1;
+	}
+
+	/*
+	 * PSS control registers
+	 */
+	ioc->ioc_regs.pss_ctl_reg = (rb + PSS_CTL_REG);
+	ioc->ioc_regs.app_pll_fast_ctl_reg = (rb + APP_PLL_425_CTL_REG);
+	ioc->ioc_regs.app_pll_slow_ctl_reg = (rb + APP_PLL_312_CTL_REG);
+
+	/*
+	 * IOC semaphore registers and serialization
+	 */
+	ioc->ioc_regs.ioc_sem_reg = (rb + HOST_SEM0_REG);
+	ioc->ioc_regs.ioc_usage_sem_reg = (rb + HOST_SEM1_REG);
+	ioc->ioc_regs.ioc_init_sem_reg = (rb + HOST_SEM2_REG);
+	ioc->ioc_regs.ioc_usage_reg = (rb + BFA_FW_USE_COUNT);
+
+	/**
+	 * sram memory access
+	 */
+	ioc->ioc_regs.smem_page_start = (rb + PSS_SMEM_PAGE_START);
+	ioc->ioc_regs.smem_pg0 = BFI_IOC_SMEM_PG0_CT;
+}
+
+/**
+ * Initialize IOC to port mapping.
+ */
+
+#define FNC_PERS_FN_SHIFT(__fn)	((__fn) * 8)
+static void
+bfa_ioc_ct_map_port(struct bfa_ioc_s *ioc)
+{
+	bfa_os_addr_t	rb = ioc->pcidev.pci_bar_kva;
+	uint32_t	r32;
+
+	/**
+	 * For catapult, base port id on personality register and IOC type
+	 */
+	r32 = bfa_reg_read(rb + FNC_PERS_REG);
+	r32 >>= FNC_PERS_FN_SHIFT(bfa_ioc_pcifn(ioc));
+	ioc->port_id = (r32 & __F0_PORT_MAP_MK) >> __F0_PORT_MAP_SH;
+
+	bfa_trc(ioc, bfa_ioc_pcifn(ioc));
+	bfa_trc(ioc, ioc->port_id);
+}
+
+/**
+ * Set interrupt mode for a function: INTX or MSIX
+ */
+static void
+bfa_ioc_ct_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix)
+{
+	bfa_os_addr_t	rb = ioc->pcidev.pci_bar_kva;
+	uint32_t	r32, mode;
+
+	r32 = bfa_reg_read(rb + FNC_PERS_REG);
+	bfa_trc(ioc, r32);
+
+	mode = (r32 >> FNC_PERS_FN_SHIFT(bfa_ioc_pcifn(ioc))) &
+		__F0_INTX_STATUS;
+
+	/**
+	 * If already in desired mode, do not change anything
+	 */
+	if (!msix && mode)
+		return;
+
+	if (msix)
+		mode = __F0_INTX_STATUS_MSIX;
+	else
+		mode = __F0_INTX_STATUS_INTA;
+
+	r32 &= ~(__F0_INTX_STATUS << FNC_PERS_FN_SHIFT(bfa_ioc_pcifn(ioc)));
+	r32 |= (mode << FNC_PERS_FN_SHIFT(bfa_ioc_pcifn(ioc)));
+	bfa_trc(ioc, r32);
+
+	bfa_reg_write(rb + FNC_PERS_REG, r32);
+}
+
+static bfa_status_t
+bfa_ioc_ct_pll_init(struct bfa_ioc_s *ioc)
+{
+	bfa_os_addr_t	rb = ioc->pcidev.pci_bar_kva;
+	uint32_t	pll_sclk, pll_fclk, r32;
+
+	/*
+	 *  Hold semaphore so that nobody can access the chip during init.
+	 */
+	bfa_ioc_sem_get(ioc->ioc_regs.ioc_init_sem_reg);
+
+	pll_sclk = __APP_PLL_312_ENABLE | __APP_PLL_312_LRESETN |
+		__APP_PLL_312_RSEL200500 | __APP_PLL_312_P0_1(0U) |
+		__APP_PLL_312_JITLMT0_1(3U) |
+		__APP_PLL_312_CNTLMT0_1(1U);
+	pll_fclk = __APP_PLL_425_ENABLE | __APP_PLL_425_LRESETN |
+		__APP_PLL_425_RSEL200500 | __APP_PLL_425_P0_1(0U) |
+		__APP_PLL_425_JITLMT0_1(3U) |
+		__APP_PLL_425_CNTLMT0_1(1U);
+
+	/**
+	 *	For catapult, choose operational mode FC/FCoE
+	 */
+	if (ioc->fcmode) {
+		bfa_reg_write((rb + OP_MODE), 0);
+		bfa_reg_write((rb + ETH_MAC_SER_REG),
+				__APP_EMS_CMLCKSEL |
+				__APP_EMS_REFCKBUFEN2 |
+				__APP_EMS_CHANNEL_SEL);
+	} else {
+		ioc->pllinit = BFA_TRUE;
+		bfa_reg_write((rb + OP_MODE), __GLOBAL_FCOE_MODE);
+		bfa_reg_write((rb + ETH_MAC_SER_REG),
+				 __APP_EMS_REFCKBUFEN1);
+	}
+
+	bfa_reg_write((rb + BFA_IOC0_STATE_REG), BFI_IOC_UNINIT);
+	bfa_reg_write((rb + BFA_IOC1_STATE_REG), BFI_IOC_UNINIT);
+
+	bfa_reg_write((rb + HOSTFN0_INT_MSK), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN1_INT_MSK), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN0_INT_STATUS), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN1_INT_STATUS), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN0_INT_MSK), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN1_INT_MSK), 0xffffffffU);
+
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
+				__APP_PLL_312_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
+				__APP_PLL_312_BYPASS |
+				__APP_PLL_312_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
+				__APP_PLL_425_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
+				__APP_PLL_425_BYPASS |
+				__APP_PLL_425_LOGIC_SOFT_RESET);
+	bfa_os_udelay(2);
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
+				__APP_PLL_312_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
+				__APP_PLL_425_LOGIC_SOFT_RESET);
+
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
+				pll_sclk | __APP_PLL_312_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
+				pll_fclk | __APP_PLL_425_LOGIC_SOFT_RESET);
+
+	/**
+	 * Wait for PLLs to lock.
+	 */
+	bfa_os_udelay(2000);
+	bfa_reg_write((rb + HOSTFN0_INT_STATUS), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN1_INT_STATUS), 0xffffffffU);
+
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg, pll_sclk);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg, pll_fclk);
+
+	bfa_reg_write((rb + MBIST_CTL_REG), __EDRAM_BISTR_START);
+	bfa_os_udelay(1000);
+	r32 = bfa_reg_read((rb + MBIST_STAT_REG));
+	bfa_trc(ioc, r32);
+	/*
+	 *  release semaphore.
+	 */
+	bfa_ioc_sem_release(ioc->ioc_regs.ioc_init_sem_reg);
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ * Cleanup hw semaphore and usecnt registers
+ */
+static void
+bfa_ioc_ct_ownership_reset(struct bfa_ioc_s *ioc)
+{
+
+	if (ioc->cna) {
+		bfa_ioc_sem_get(ioc->ioc_regs.ioc_usage_sem_reg);
+		bfa_reg_write(ioc->ioc_regs.ioc_usage_reg, 0);
+		bfa_ioc_sem_release(ioc->ioc_regs.ioc_usage_sem_reg);
+	}
+
+	/*
+	 * Read the hw sem reg to make sure that it is locked
+	 * before we clear it. If it is not locked, writing 1
+	 * will lock it instead of clearing it.
+	 */
+	bfa_reg_read(ioc->ioc_regs.ioc_sem_reg);
+	bfa_ioc_hw_sem_release(ioc);
+}
diff --git a/drivers/scsi/bfa/include/bfa.h b/drivers/scsi/bfa/include/bfa.h
index d4bc0d9..942ae64 100644
--- a/drivers/scsi/bfa/include/bfa.h
+++ b/drivers/scsi/bfa/include/bfa.h
@@ -161,6 +161,7 @@ bfa_status_t bfa_iocfc_israttr_set(struct bfa_s *bfa,
 void bfa_iocfc_enable(struct bfa_s *bfa);
 void bfa_iocfc_disable(struct bfa_s *bfa);
 void bfa_ioc_auto_recover(bfa_boolean_t auto_recover);
+void bfa_chip_reset(struct bfa_s *bfa);
 void bfa_cb_ioc_disable(void *bfad);
 void bfa_timer_tick(struct bfa_s *bfa);
 #define bfa_timer_start(_bfa, _timer, _timercb, _arg, _timeout)	\
diff --git a/drivers/scsi/bfa/include/bfa_timer.h b/drivers/scsi/bfa/include/bfa_timer.h
index e407103..f710874 100644
--- a/drivers/scsi/bfa/include/bfa_timer.h
+++ b/drivers/scsi/bfa/include/bfa_timer.h
@@ -41,7 +41,7 @@ struct bfa_timer_mod_s {
 	struct list_head timer_q;
 };
 
-#define BFA_TIMER_FREQ 500 /**< specified in millisecs */
+#define BFA_TIMER_FREQ 200 /**< specified in millisecs */
 
 void bfa_timer_beat(struct bfa_timer_mod_s *mod);
 void bfa_timer_init(struct bfa_timer_mod_s *mod);
diff --git a/drivers/scsi/bfa/include/bfi/bfi_cbreg.h b/drivers/scsi/bfa/include/bfi/bfi_cbreg.h
index b3bb52b..781cefa 100644
--- a/drivers/scsi/bfa/include/bfi/bfi_cbreg.h
+++ b/drivers/scsi/bfa/include/bfi/bfi_cbreg.h
@@ -177,7 +177,8 @@
 #define __PSS_LMEM_INIT_EN               0x00000100
 #define __PSS_LPU1_RESET                 0x00000002
 #define __PSS_LPU0_RESET                 0x00000001
-
+#define ERR_SET_REG			 0x00018818
+#define __PSS_ERR_STATUS_SET		 0x00000fff
 
 /*
  * These definitions are either in error/missing in spec. Its auto-generated
diff --git a/drivers/scsi/bfa/include/bfi/bfi_ctreg.h b/drivers/scsi/bfa/include/bfi/bfi_ctreg.h
index dd2992c..d84ebae 100644
--- a/drivers/scsi/bfa/include/bfi/bfi_ctreg.h
+++ b/drivers/scsi/bfa/include/bfi/bfi_ctreg.h
@@ -430,6 +430,8 @@ enum {
 #define __PSS_LMEM_INIT_EN               0x00000100
 #define __PSS_LPU1_RESET                 0x00000002
 #define __PSS_LPU0_RESET                 0x00000001
+#define ERR_SET_REG			 0x00018818
+#define __PSS_ERR_STATUS_SET		 0x003fffff
 #define HQM_QSET0_RXQ_DRBL_P0            0x00038000
 #define __RXQ0_ADD_VECTORS_P             0x80000000
 #define __RXQ0_STOP_P                    0x40000000
diff --git a/drivers/scsi/bfa/include/bfi/bfi_ioc.h b/drivers/scsi/bfa/include/bfi/bfi_ioc.h
index 96ef056..a0158aa 100644
--- a/drivers/scsi/bfa/include/bfi/bfi_ioc.h
+++ b/drivers/scsi/bfa/include/bfi/bfi_ioc.h
@@ -123,7 +123,7 @@ enum bfi_ioc_state {
 	BFI_IOC_DISABLING 	 = 5,	/*  IOC is being disabled           */
 	BFI_IOC_DISABLED 	 = 6,	/*  IOC is disabled                 */
 	BFI_IOC_CFG_DISABLED = 7,	/*  IOC is being disabled;transient */
-	BFI_IOC_HBFAIL       = 8,	/*  IOC heart-beat failure          */
+	BFI_IOC_FAIL       = 8,		/*  IOC heart-beat failure          */
 	BFI_IOC_MEMTEST      = 9,	/*  IOC is doing memtest            */
 };
 
diff --git a/drivers/scsi/bfa/include/cna/bfa_cna_trcmod.h b/drivers/scsi/bfa/include/cna/bfa_cna_trcmod.h
index 43ba706..a75a1f3 100644
--- a/drivers/scsi/bfa/include/cna/bfa_cna_trcmod.h
+++ b/drivers/scsi/bfa/include/cna/bfa_cna_trcmod.h
@@ -31,6 +31,10 @@
 enum {
 	BFA_TRC_CNA_CEE		= 1,
 	BFA_TRC_CNA_PORT	= 2,
+	BFA_TRC_CNA_IOC     = 3,
+	BFA_TRC_CNA_DIAG    = 4,
+	BFA_TRC_CNA_IOC_CB  = 5,
+	BFA_TRC_CNA_IOC_CT  = 6,
 };
 
 #endif /* __BFA_CNA_TRCMOD_H__ */
-- 
1.6.5.3

