From: <kgudipat@brocade.com>
Subject: [PATCH 25/33] bfa: IOC state machine restructuring / cleanup changes.
Date: Wed, 15 Sep 2010 12:13:50 -0700
Message-ID: <1284578030-20995-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:34550 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755026Ab0IOTOZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2010 15:14:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- This patch consists of the restructured IOC state machine / IOC cleanup:

	- IOC statemachine restructuring:
	    - Enabling/Disabling ASIC and its recovery from failure is moved
		  to a sub state machine (iocpf state machine) from main IOC state
		  machine, does not effect any functionality or existing interface
		  with the BFAD driver.

	- IOC cleanup changes:
		- Merged bfa timer releated code to bfa_ioc.c
		- Merged the bfa timer, BFI fw handling header files to bfa_ioc.h

	- bfa_hw_cb.c
	  bfa_hw_ct.c: Fix header file include changes due to flattening BFA directory.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_hw_cb.c  |    8 +-
 drivers/scsi/bfa/bfa_hw_ct.c  |   11 +-
 drivers/scsi/bfa/bfa_ioc.c    | 1984 +++++++++++++++++++++++++++++------------
 drivers/scsi/bfa/bfa_ioc.h    |  248 ++++--
 drivers/scsi/bfa/bfa_ioc_cb.c |  124 ++--
 drivers/scsi/bfa/bfa_ioc_ct.c |  137 ++--
 6 files changed, 1708 insertions(+), 804 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_hw_cb.c b/drivers/scsi/bfa/bfa_hw_cb.c
index edfd729..c787d3a 100644
--- a/drivers/scsi/bfa/bfa_hw_cb.c
+++ b/drivers/scsi/bfa/bfa_hw_cb.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
  * All rights reserved
  * www.brocade.com
  *
@@ -15,15 +15,15 @@
  * General Public License for more details.
  */
 
-#include <bfa_priv.h>
-#include <bfi/bfi_cbreg.h>
+#include "bfa_modules.h"
+#include "bfi_cbreg.h"
 
 void
 bfa_hwcb_reginit(struct bfa_s *bfa)
 {
 	struct bfa_iocfc_regs_s	*bfa_regs = &bfa->iocfc.bfa_regs;
 	bfa_os_addr_t		kva = bfa_ioc_bar0(&bfa->ioc);
-	int             	i, q, fn = bfa_ioc_pcifn(&bfa->ioc);
+	int			i, q, fn = bfa_ioc_pcifn(&bfa->ioc);
 
 	if (fn == 0) {
 		bfa_regs->intr_status = (kva + HOSTFN0_INT_STATUS);
diff --git a/drivers/scsi/bfa/bfa_hw_ct.c b/drivers/scsi/bfa/bfa_hw_ct.c
index a357fb3..c97ebaf 100644
--- a/drivers/scsi/bfa/bfa_hw_ct.c
+++ b/drivers/scsi/bfa/bfa_hw_ct.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
  * All rights reserved
  * www.brocade.com
  *
@@ -15,9 +15,8 @@
  * General Public License for more details.
  */
 
-#include <bfa_priv.h>
-#include <bfi/bfi_ctreg.h>
-#include <bfa_ioc.h>
+#include "bfa_modules.h"
+#include "bfi_ctreg.h"
 
 BFA_TRC_FILE(HAL, IOCFC_CT);
 
@@ -53,7 +52,7 @@ bfa_hwct_reginit(struct bfa_s *bfa)
 {
 	struct bfa_iocfc_regs_s	*bfa_regs = &bfa->iocfc.bfa_regs;
 	bfa_os_addr_t		kva = bfa_ioc_bar0(&bfa->ioc);
-	int             	i, q, fn = bfa_ioc_pcifn(&bfa->ioc);
+	int			i, q, fn = bfa_ioc_pcifn(&bfa->ioc);
 
 	if (fn == 0) {
 		bfa_regs->intr_status = (kva + HOSTFN0_INT_STATUS);
@@ -87,7 +86,7 @@ bfa_hwct_reginit(struct bfa_s *bfa)
 void
 bfa_hwct_reqq_ack(struct bfa_s *bfa, int reqq)
 {
-	u32 r32;
+	u32	r32;
 
 	r32 = bfa_reg_read(bfa->iocfc.bfa_regs.cpe_q_ctrl[reqq]);
 	bfa_reg_write(bfa->iocfc.bfa_regs.cpe_q_ctrl[reqq], r32);
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 8e78f20..6795b24 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
  * All rights reserved
  * www.brocade.com
  *
@@ -15,35 +15,33 @@
  * General Public License for more details.
  */
 
-#include <bfa.h>
-#include <bfa_ioc.h>
-#include <bfa_fwimg_priv.h>
-#include <cna/bfa_cna_trcmod.h>
-#include <cs/bfa_debug.h>
-#include <bfi/bfi_ioc.h>
-#include <bfi/bfi_ctreg.h>
-#include <aen/bfa_aen_ioc.h>
-#include <aen/bfa_aen.h>
-#include <log/bfa_log_hal.h>
-#include <defs/bfa_defs_pci.h>
+#include "bfa_ioc.h"
+#include "bfi_ctreg.h"
+#include "bfa_defs.h"
+#include "bfa_defs_svc.h"
+#include "bfad_drv.h"
 
 BFA_TRC_FILE(CNA, IOC);
 
 /**
  * IOC local definitions
  */
-#define BFA_IOC_TOV		2000	/* msecs */
-#define BFA_IOC_HWSEM_TOV       500     /* msecs */
-#define BFA_IOC_HB_TOV          500     /* msecs */
-#define BFA_IOC_HWINIT_MAX      2
-#define BFA_IOC_FWIMG_MINSZ     (16 * 1024)
-#define BFA_IOC_TOV_RECOVER      BFA_IOC_HB_TOV
+#define BFA_IOC_TOV		3000	/* msecs */
+#define BFA_IOC_HWSEM_TOV	500	/* msecs */
+#define BFA_IOC_HB_TOV		500	/* msecs */
+#define BFA_IOC_HWINIT_MAX	2
+#define BFA_IOC_TOV_RECOVER	 BFA_IOC_HB_TOV
 
 #define bfa_ioc_timer_start(__ioc)					\
 	bfa_timer_begin((__ioc)->timer_mod, &(__ioc)->ioc_timer,	\
 			bfa_ioc_timeout, (__ioc), BFA_IOC_TOV)
 #define bfa_ioc_timer_stop(__ioc)   bfa_timer_stop(&(__ioc)->ioc_timer)
 
+#define bfa_hb_timer_start(__ioc)					\
+	bfa_timer_begin((__ioc)->timer_mod, &(__ioc)->hb_timer,		\
+			bfa_ioc_hb_check, (__ioc), BFA_IOC_HB_TOV)
+#define bfa_hb_timer_stop(__ioc)	bfa_timer_stop(&(__ioc)->hb_timer)
+
 #define BFA_DBG_FWTRC_ENTS	(BFI_IOC_TRC_ENTS)
 #define BFA_DBG_FWTRC_LEN					\
 	(BFA_DBG_FWTRC_ENTS * sizeof(struct bfa_trc_s) +	\
@@ -55,100 +53,226 @@ BFA_TRC_FILE(CNA, IOC);
  * Asic specific macros : see bfa_hw_cb.c and bfa_hw_ct.c for details.
  */
 
-#define bfa_ioc_firmware_lock(__ioc)                    \
+#define bfa_ioc_firmware_lock(__ioc)			\
 			((__ioc)->ioc_hwif->ioc_firmware_lock(__ioc))
-#define bfa_ioc_firmware_unlock(__ioc)                  \
+#define bfa_ioc_firmware_unlock(__ioc)			\
 			((__ioc)->ioc_hwif->ioc_firmware_unlock(__ioc))
 #define bfa_ioc_reg_init(__ioc) ((__ioc)->ioc_hwif->ioc_reg_init(__ioc))
 #define bfa_ioc_map_port(__ioc) ((__ioc)->ioc_hwif->ioc_map_port(__ioc))
-#define bfa_ioc_notify_hbfail(__ioc)                    \
+#define bfa_ioc_notify_hbfail(__ioc)			\
 			((__ioc)->ioc_hwif->ioc_notify_hbfail(__ioc))
-#define bfa_ioc_is_optrom(__ioc)        \
-	(bfi_image_get_size(BFA_IOC_FWIMG_TYPE(__ioc)) < BFA_IOC_FWIMG_MINSZ)
 
-bfa_boolean_t   bfa_auto_recover = BFA_TRUE;
+#ifdef BFA_IOC_IS_UEFI
+#define bfa_ioc_is_bios_optrom(__ioc) (0)
+#define bfa_ioc_is_uefi(__ioc) BFA_IOC_IS_UEFI
+#else
+#define bfa_ioc_is_bios_optrom(__ioc)	\
+	(bfa_cb_image_get_size(BFA_IOC_FWIMG_TYPE(__ioc)) < BFA_IOC_FWIMG_MINSZ)
+#define bfa_ioc_is_uefi(__ioc) (0)
+#endif
+
+#define bfa_ioc_mbox_cmd_pending(__ioc)		\
+			(!list_empty(&((__ioc)->mbox_mod.cmd_q)) || \
+			bfa_reg_read((__ioc)->ioc_regs.hfn_mbox_cmd))
+
+bfa_boolean_t bfa_auto_recover = BFA_TRUE;
 
 /*
  * forward declarations
  */
-static void     bfa_ioc_hw_sem_get(struct bfa_ioc_s *ioc);
-static void     bfa_ioc_hw_sem_get_cancel(struct bfa_ioc_s *ioc);
-static void     bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force);
-static void     bfa_ioc_timeout(void *ioc);
-static void     bfa_ioc_send_enable(struct bfa_ioc_s *ioc);
-static void     bfa_ioc_send_disable(struct bfa_ioc_s *ioc);
-static void     bfa_ioc_send_getattr(struct bfa_ioc_s *ioc);
-static void     bfa_ioc_hb_monitor(struct bfa_ioc_s *ioc);
-static void     bfa_ioc_hb_stop(struct bfa_ioc_s *ioc);
-static void     bfa_ioc_reset(struct bfa_ioc_s *ioc, bfa_boolean_t force);
-static void     bfa_ioc_mbox_poll(struct bfa_ioc_s *ioc);
-static void     bfa_ioc_mbox_hbfail(struct bfa_ioc_s *ioc);
-static void     bfa_ioc_recover(struct bfa_ioc_s *ioc);
-static void	bfa_ioc_check_attr_wwns(struct bfa_ioc_s *ioc);
-static void     bfa_ioc_disable_comp(struct bfa_ioc_s *ioc);
-static void     bfa_ioc_lpu_stop(struct bfa_ioc_s *ioc);
+static void bfa_ioc_hw_sem_get(struct bfa_ioc_s *ioc);
+static void bfa_ioc_hw_sem_get_cancel(struct bfa_ioc_s *ioc);
+static void bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force);
+static void bfa_ioc_timeout(void *ioc);
+static void bfa_ioc_send_enable(struct bfa_ioc_s *ioc);
+static void bfa_ioc_send_disable(struct bfa_ioc_s *ioc);
+static void bfa_ioc_send_getattr(struct bfa_ioc_s *ioc);
+static void bfa_ioc_hb_monitor(struct bfa_ioc_s *ioc);
+static void bfa_ioc_hb_stop(struct bfa_ioc_s *ioc);
+static void bfa_ioc_reset(struct bfa_ioc_s *ioc, bfa_boolean_t force);
+static void bfa_ioc_mbox_poll(struct bfa_ioc_s *ioc);
+static void bfa_ioc_mbox_hbfail(struct bfa_ioc_s *ioc);
+static void bfa_ioc_recover(struct bfa_ioc_s *ioc);
+static void bfa_ioc_check_attr_wwns(struct bfa_ioc_s *ioc);
+static void bfa_ioc_disable_comp(struct bfa_ioc_s *ioc);
+static void bfa_ioc_lpu_stop(struct bfa_ioc_s *ioc);
+static void bfa_ioc_pf_enabled(struct bfa_ioc_s *ioc);
+static void bfa_ioc_pf_disabled(struct bfa_ioc_s *ioc);
+static void bfa_ioc_pf_failed(struct bfa_ioc_s *ioc);
+static void bfa_ioc_pf_fwmismatch(struct bfa_ioc_s *ioc);
 
 /**
- *  bfa_ioc_sm
+ *  hal_ioc_sm
  */
 
 /**
- * IOC state machine events
+ * IOC state machine definitions/declarations
  */
 enum ioc_event {
-	IOC_E_ENABLE = 1,	/*  IOC enable request */
-	IOC_E_DISABLE = 2,	/*  IOC disable request */
-	IOC_E_TIMEOUT = 3,	/*  f/w response timeout */
-	IOC_E_FWREADY = 4,	/*  f/w initialization done */
-	IOC_E_FWRSP_GETATTR = 5,	/*  IOC get attribute response */
-	IOC_E_FWRSP_ENABLE = 6,	/*  enable f/w response */
-	IOC_E_FWRSP_DISABLE = 7,	/*  disable f/w response */
-	IOC_E_HBFAIL = 8,	/*  heartbeat failure */
-	IOC_E_HWERROR = 9,	/*  hardware error interrupt */
-	IOC_E_SEMLOCKED = 10,	/*  h/w semaphore is locked */
-	IOC_E_DETACH = 11,	/*  driver detach cleanup */
+	IOC_E_RESET		= 1,	/*  IOC reset request		*/
+	IOC_E_ENABLE		= 2,	/*  IOC enable request		*/
+	IOC_E_DISABLE		= 3,	/*  IOC disable request	*/
+	IOC_E_DETACH		= 4,	/*  driver detach cleanup	*/
+	IOC_E_ENABLED		= 5,	/*  f/w enabled		*/
+	IOC_E_FWRSP_GETATTR	= 6,	/*  IOC get attribute response	*/
+	IOC_E_DISABLED		= 7,	/*  f/w disabled		*/
+	IOC_E_FAILED		= 8,	/*  failure notice by iocpf sm	*/
+	IOC_E_HBFAIL		= 9,	/*  heartbeat failure		*/
+	IOC_E_HWERROR		= 10,	/*  hardware error interrupt	*/
+	IOC_E_TIMEOUT		= 11,	/*  timeout			*/
 };
 
+bfa_fsm_state_decl(bfa_ioc, uninit, struct bfa_ioc_s, enum ioc_event);
 bfa_fsm_state_decl(bfa_ioc, reset, struct bfa_ioc_s, enum ioc_event);
-bfa_fsm_state_decl(bfa_ioc, fwcheck, struct bfa_ioc_s, enum ioc_event);
-bfa_fsm_state_decl(bfa_ioc, mismatch, struct bfa_ioc_s, enum ioc_event);
-bfa_fsm_state_decl(bfa_ioc, semwait, struct bfa_ioc_s, enum ioc_event);
-bfa_fsm_state_decl(bfa_ioc, hwinit, struct bfa_ioc_s, enum ioc_event);
 bfa_fsm_state_decl(bfa_ioc, enabling, struct bfa_ioc_s, enum ioc_event);
 bfa_fsm_state_decl(bfa_ioc, getattr, struct bfa_ioc_s, enum ioc_event);
 bfa_fsm_state_decl(bfa_ioc, op, struct bfa_ioc_s, enum ioc_event);
 bfa_fsm_state_decl(bfa_ioc, initfail, struct bfa_ioc_s, enum ioc_event);
-bfa_fsm_state_decl(bfa_ioc, hbfail, struct bfa_ioc_s, enum ioc_event);
+bfa_fsm_state_decl(bfa_ioc, fail, struct bfa_ioc_s, enum ioc_event);
 bfa_fsm_state_decl(bfa_ioc, disabling, struct bfa_ioc_s, enum ioc_event);
 bfa_fsm_state_decl(bfa_ioc, disabled, struct bfa_ioc_s, enum ioc_event);
 
 static struct bfa_sm_table_s ioc_sm_table[] = {
+	{BFA_SM(bfa_ioc_sm_uninit), BFA_IOC_UNINIT},
 	{BFA_SM(bfa_ioc_sm_reset), BFA_IOC_RESET},
-	{BFA_SM(bfa_ioc_sm_fwcheck), BFA_IOC_FWMISMATCH},
-	{BFA_SM(bfa_ioc_sm_mismatch), BFA_IOC_FWMISMATCH},
-	{BFA_SM(bfa_ioc_sm_semwait), BFA_IOC_SEMWAIT},
-	{BFA_SM(bfa_ioc_sm_hwinit), BFA_IOC_HWINIT},
-	{BFA_SM(bfa_ioc_sm_enabling), BFA_IOC_HWINIT},
+	{BFA_SM(bfa_ioc_sm_enabling), BFA_IOC_ENABLING},
 	{BFA_SM(bfa_ioc_sm_getattr), BFA_IOC_GETATTR},
 	{BFA_SM(bfa_ioc_sm_op), BFA_IOC_OPERATIONAL},
 	{BFA_SM(bfa_ioc_sm_initfail), BFA_IOC_INITFAIL},
-	{BFA_SM(bfa_ioc_sm_hbfail), BFA_IOC_HBFAIL},
+	{BFA_SM(bfa_ioc_sm_fail), BFA_IOC_FAIL},
 	{BFA_SM(bfa_ioc_sm_disabling), BFA_IOC_DISABLING},
 	{BFA_SM(bfa_ioc_sm_disabled), BFA_IOC_DISABLED},
 };
 
 /**
+ * IOCPF state machine definitions/declarations
+ */
+
+#define bfa_iocpf_timer_start(__ioc)					\
+	bfa_timer_begin((__ioc)->timer_mod, &(__ioc)->ioc_timer,	\
+			bfa_iocpf_timeout, (__ioc), BFA_IOC_TOV)
+#define bfa_iocpf_timer_stop(__ioc)	bfa_timer_stop(&(__ioc)->ioc_timer)
+
+#define bfa_iocpf_recovery_timer_start(__ioc)				\
+	bfa_timer_begin((__ioc)->timer_mod, &(__ioc)->ioc_timer,	\
+			bfa_iocpf_timeout, (__ioc), BFA_IOC_TOV_RECOVER)
+
+#define bfa_sem_timer_start(__ioc)					\
+	bfa_timer_begin((__ioc)->timer_mod, &(__ioc)->sem_timer,	\
+			bfa_iocpf_sem_timeout, (__ioc), BFA_IOC_HWSEM_TOV)
+#define bfa_sem_timer_stop(__ioc)	bfa_timer_stop(&(__ioc)->sem_timer)
+
+/*
+ * Forward declareations for iocpf state machine
+ */
+static void bfa_iocpf_enable(struct bfa_ioc_s *ioc);
+static void bfa_iocpf_disable(struct bfa_ioc_s *ioc);
+static void bfa_iocpf_fail(struct bfa_ioc_s *ioc);
+static void bfa_iocpf_initfail(struct bfa_ioc_s *ioc);
+static void bfa_iocpf_getattrfail(struct bfa_ioc_s *ioc);
+static void bfa_iocpf_stop(struct bfa_ioc_s *ioc);
+static void bfa_iocpf_timeout(void *ioc_arg);
+static void bfa_iocpf_sem_timeout(void *ioc_arg);
+
+/**
+ * IOCPF state machine events
+ */
+enum iocpf_event {
+	IOCPF_E_ENABLE		= 1,	/*  IOCPF enable request	*/
+	IOCPF_E_DISABLE		= 2,	/*  IOCPF disable request	*/
+	IOCPF_E_STOP		= 3,	/*  stop on driver detach	*/
+	IOCPF_E_FWREADY		= 4,	/*  f/w initialization done	*/
+	IOCPF_E_FWRSP_ENABLE	= 5,	/*  enable f/w response	*/
+	IOCPF_E_FWRSP_DISABLE	= 6,	/*  disable f/w response	*/
+	IOCPF_E_FAIL		= 7,	/*  failure notice by ioc sm	*/
+	IOCPF_E_INITFAIL	= 8,	/*  init fail notice by ioc sm	*/
+	IOCPF_E_GETATTRFAIL	= 9,	/*  init fail notice by ioc sm	*/
+	IOCPF_E_SEMLOCKED	= 10,	/*  h/w semaphore is locked	*/
+	IOCPF_E_TIMEOUT		= 11,	/*  f/w response timeout	*/
+};
+
+/**
+ * IOCPF states
+ */
+enum bfa_iocpf_state {
+	BFA_IOCPF_RESET		= 1,	/*  IOC is in reset state */
+	BFA_IOCPF_SEMWAIT	= 2,	/*  Waiting for IOC h/w semaphore */
+	BFA_IOCPF_HWINIT	= 3,	/*  IOC h/w is being initialized */
+	BFA_IOCPF_READY		= 4,	/*  IOCPF is initialized */
+	BFA_IOCPF_INITFAIL	= 5,	/*  IOCPF failed */
+	BFA_IOCPF_FAIL		= 6,	/*  IOCPF failed */
+	BFA_IOCPF_DISABLING	= 7,	/*  IOCPF is being disabled */
+	BFA_IOCPF_DISABLED	= 8,	/*  IOCPF is disabled */
+	BFA_IOCPF_FWMISMATCH	= 9,	/*  IOC f/w different from drivers */
+};
+
+bfa_fsm_state_decl(bfa_iocpf, reset, struct bfa_iocpf_s, enum iocpf_event);
+bfa_fsm_state_decl(bfa_iocpf, fwcheck, struct bfa_iocpf_s, enum iocpf_event);
+bfa_fsm_state_decl(bfa_iocpf, mismatch, struct bfa_iocpf_s, enum iocpf_event);
+bfa_fsm_state_decl(bfa_iocpf, semwait, struct bfa_iocpf_s, enum iocpf_event);
+bfa_fsm_state_decl(bfa_iocpf, hwinit, struct bfa_iocpf_s, enum iocpf_event);
+bfa_fsm_state_decl(bfa_iocpf, enabling, struct bfa_iocpf_s, enum iocpf_event);
+bfa_fsm_state_decl(bfa_iocpf, ready, struct bfa_iocpf_s, enum iocpf_event);
+bfa_fsm_state_decl(bfa_iocpf, initfail, struct bfa_iocpf_s, enum iocpf_event);
+bfa_fsm_state_decl(bfa_iocpf, fail, struct bfa_iocpf_s, enum iocpf_event);
+bfa_fsm_state_decl(bfa_iocpf, disabling, struct bfa_iocpf_s, enum iocpf_event);
+bfa_fsm_state_decl(bfa_iocpf, disabled, struct bfa_iocpf_s, enum iocpf_event);
+
+static struct bfa_sm_table_s iocpf_sm_table[] = {
+	{BFA_SM(bfa_iocpf_sm_reset), BFA_IOCPF_RESET},
+	{BFA_SM(bfa_iocpf_sm_fwcheck), BFA_IOCPF_FWMISMATCH},
+	{BFA_SM(bfa_iocpf_sm_mismatch), BFA_IOCPF_FWMISMATCH},
+	{BFA_SM(bfa_iocpf_sm_semwait), BFA_IOCPF_SEMWAIT},
+	{BFA_SM(bfa_iocpf_sm_hwinit), BFA_IOCPF_HWINIT},
+	{BFA_SM(bfa_iocpf_sm_enabling), BFA_IOCPF_HWINIT},
+	{BFA_SM(bfa_iocpf_sm_ready), BFA_IOCPF_READY},
+	{BFA_SM(bfa_iocpf_sm_initfail), BFA_IOCPF_INITFAIL},
+	{BFA_SM(bfa_iocpf_sm_fail), BFA_IOCPF_FAIL},
+	{BFA_SM(bfa_iocpf_sm_disabling), BFA_IOCPF_DISABLING},
+	{BFA_SM(bfa_iocpf_sm_disabled), BFA_IOCPF_DISABLED},
+};
+
+/**
+ * IOC State Machine
+ */
+
+/**
+ * Beginning state. IOC uninit state.
+ */
+
+static void
+bfa_ioc_sm_uninit_entry(struct bfa_ioc_s *ioc)
+{
+}
+
+/**
+ * IOC is in uninit state.
+ */
+static void
+bfa_ioc_sm_uninit(struct bfa_ioc_s *ioc, enum ioc_event event)
+{
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOC_E_RESET:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_reset);
+		break;
+
+	default:
+		bfa_sm_fault(ioc, event);
+	}
+}
+/**
  * Reset entry actions -- initialize state machine
  */
 static void
 bfa_ioc_sm_reset_entry(struct bfa_ioc_s *ioc)
 {
-	ioc->retry_count = 0;
-	ioc->auto_recover = bfa_auto_recover;
+	bfa_fsm_set_state(&ioc->iocpf, bfa_iocpf_sm_reset);
 }
 
 /**
- * Beginning state. IOC is in reset state.
+ * IOC is in reset state.
  */
 static void
 bfa_ioc_sm_reset(struct bfa_ioc_s *ioc, enum ioc_event event)
@@ -157,7 +281,7 @@ bfa_ioc_sm_reset(struct bfa_ioc_s *ioc, enum ioc_event event)
 
 	switch (event) {
 	case IOC_E_ENABLE:
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_fwcheck);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_enabling);
 		break;
 
 	case IOC_E_DISABLE:
@@ -165,6 +289,7 @@ bfa_ioc_sm_reset(struct bfa_ioc_s *ioc, enum ioc_event event)
 		break;
 
 	case IOC_E_DETACH:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_uninit);
 		break;
 
 	default:
@@ -172,46 +297,209 @@ bfa_ioc_sm_reset(struct bfa_ioc_s *ioc, enum ioc_event event)
 	}
 }
 
+
+static void
+bfa_ioc_sm_enabling_entry(struct bfa_ioc_s *ioc)
+{
+	bfa_iocpf_enable(ioc);
+}
+
 /**
- * Semaphore should be acquired for version check.
+ * Host IOC function is being enabled, awaiting response from firmware.
+ * Semaphore is acquired.
  */
 static void
-bfa_ioc_sm_fwcheck_entry(struct bfa_ioc_s *ioc)
+bfa_ioc_sm_enabling(struct bfa_ioc_s *ioc, enum ioc_event event)
 {
-	bfa_ioc_hw_sem_get(ioc);
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOC_E_ENABLED:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_getattr);
+		break;
+
+	case IOC_E_FAILED:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_initfail);
+		break;
+
+	case IOC_E_HWERROR:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_initfail);
+		bfa_iocpf_initfail(ioc);
+		break;
+
+	case IOC_E_DISABLE:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabling);
+		break;
+
+	case IOC_E_DETACH:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_uninit);
+		bfa_iocpf_stop(ioc);
+		break;
+
+	case IOC_E_ENABLE:
+		break;
+
+	default:
+		bfa_sm_fault(ioc, event);
+	}
+}
+
+
+static void
+bfa_ioc_sm_getattr_entry(struct bfa_ioc_s *ioc)
+{
+	bfa_ioc_timer_start(ioc);
+	bfa_ioc_send_getattr(ioc);
 }
 
 /**
- * Awaiting h/w semaphore to continue with version check.
+ * IOC configuration in progress. Timer is active.
  */
 static void
-bfa_ioc_sm_fwcheck(struct bfa_ioc_s *ioc, enum ioc_event event)
+bfa_ioc_sm_getattr(struct bfa_ioc_s *ioc, enum ioc_event event)
 {
 	bfa_trc(ioc, event);
 
 	switch (event) {
-	case IOC_E_SEMLOCKED:
-		if (bfa_ioc_firmware_lock(ioc)) {
-			ioc->retry_count = 0;
-			bfa_fsm_set_state(ioc, bfa_ioc_sm_hwinit);
-		} else {
-			bfa_ioc_hw_sem_release(ioc);
-			bfa_fsm_set_state(ioc, bfa_ioc_sm_mismatch);
-		}
+	case IOC_E_FWRSP_GETATTR:
+		bfa_ioc_timer_stop(ioc);
+		bfa_ioc_check_attr_wwns(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_op);
+		break;
+
+	case IOC_E_FAILED:
+		bfa_ioc_timer_stop(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_initfail);
+		break;
+
+	case IOC_E_HWERROR:
+		bfa_ioc_timer_stop(ioc);
+		/* fall through */
+
+	case IOC_E_TIMEOUT:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_initfail);
+		bfa_iocpf_getattrfail(ioc);
 		break;
 
 	case IOC_E_DISABLE:
-		bfa_ioc_disable_comp(ioc);
+		bfa_ioc_timer_stop(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabling);
+		break;
+
+	case IOC_E_ENABLE:
+		break;
+
+	default:
+		bfa_sm_fault(ioc, event);
+	}
+}
+
+
+static void
+bfa_ioc_sm_op_entry(struct bfa_ioc_s *ioc)
+{
+	struct bfad_s *bfad = (struct bfad_s *)ioc->bfa->bfad;
+
+	ioc->cbfn->enable_cbfn(ioc->bfa, BFA_STATUS_OK);
+	bfa_ioc_hb_monitor(ioc);
+	BFA_LOG(KERN_INFO, bfad, log_level, "IOC enabled\n");
+}
+
+static void
+bfa_ioc_sm_op(struct bfa_ioc_s *ioc, enum ioc_event event)
+{
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOC_E_ENABLE:
+		break;
+
+	case IOC_E_DISABLE:
+		bfa_ioc_hb_stop(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabling);
+		break;
+
+	case IOC_E_FAILED:
+		bfa_ioc_hb_stop(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_fail);
+		break;
+
+	case IOC_E_HWERROR:
+		bfa_ioc_hb_stop(ioc);
+		/* !!! fall through !!! */
+
+	case IOC_E_HBFAIL:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_fail);
+		bfa_iocpf_fail(ioc);
+		break;
+
+	default:
+		bfa_sm_fault(ioc, event);
+	}
+}
+
+
+static void
+bfa_ioc_sm_disabling_entry(struct bfa_ioc_s *ioc)
+{
+	struct bfad_s *bfad = (struct bfad_s *)ioc->bfa->bfad;
+	bfa_iocpf_disable(ioc);
+	BFA_LOG(KERN_INFO, bfad, log_level, "IOC disabled\n");
+}
+
+/**
+ * IOC is being disabled
+ */
+static void
+bfa_ioc_sm_disabling(struct bfa_ioc_s *ioc, enum ioc_event event)
+{
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOC_E_DISABLED:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabled);
+		break;
+
+	case IOC_E_HWERROR:
 		/*
-		 * fall through
+		 * No state change.  Will move to disabled state
+		 * after iocpf sm completes failure processing and
+		 * moves to disabled state.
 		 */
+		bfa_iocpf_fail(ioc);
+		break;
 
-	case IOC_E_DETACH:
-		bfa_ioc_hw_sem_get_cancel(ioc);
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_reset);
+	default:
+		bfa_sm_fault(ioc, event);
+	}
+}
+
+/**
+ * IOC disable completion entry.
+ */
+static void
+bfa_ioc_sm_disabled_entry(struct bfa_ioc_s *ioc)
+{
+	bfa_ioc_disable_comp(ioc);
+}
+
+static void
+bfa_ioc_sm_disabled(struct bfa_ioc_s *ioc, enum ioc_event event)
+{
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOC_E_ENABLE:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_enabling);
 		break;
 
-	case IOC_E_FWREADY:
+	case IOC_E_DISABLE:
+		ioc->cbfn->disable_cbfn(ioc->bfa);
+		break;
+
+	case IOC_E_DETACH:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_uninit);
+		bfa_iocpf_stop(ioc);
 		break;
 
 	default:
@@ -219,48 +507,138 @@ bfa_ioc_sm_fwcheck(struct bfa_ioc_s *ioc, enum ioc_event event)
 	}
 }
 
+
+static void
+bfa_ioc_sm_initfail_entry(struct bfa_ioc_s *ioc)
+{
+	ioc->cbfn->enable_cbfn(ioc->bfa, BFA_STATUS_IOC_FAILURE);
+}
+
 /**
- * Notify enable completion callback and generate mismatch AEN.
+ * Hardware initialization failed.
  */
 static void
-bfa_ioc_sm_mismatch_entry(struct bfa_ioc_s *ioc)
+bfa_ioc_sm_initfail(struct bfa_ioc_s *ioc, enum ioc_event event)
 {
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOC_E_ENABLED:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_getattr);
+		break;
+
+	case IOC_E_FAILED:
+		/**
+		 * Initialization failure during iocpf init retry.
+		 */
+		ioc->cbfn->enable_cbfn(ioc->bfa, BFA_STATUS_IOC_FAILURE);
+		break;
+
+	case IOC_E_DISABLE:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabling);
+		break;
+
+	case IOC_E_DETACH:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_uninit);
+		bfa_iocpf_stop(ioc);
+		break;
+
+	default:
+		bfa_sm_fault(ioc, event);
+	}
+}
+
+
+static void
+bfa_ioc_sm_fail_entry(struct bfa_ioc_s *ioc)
+{
+	struct list_head			*qe;
+	struct bfa_ioc_hbfail_notify_s	*notify;
+	struct bfad_s *bfad = (struct bfad_s *)ioc->bfa->bfad;
+
 	/**
-	 * Provide enable completion callback and AEN notification only once.
+	 * Notify driver and common modules registered for notification.
 	 */
-	if (ioc->retry_count == 0) {
-		ioc->cbfn->enable_cbfn(ioc->bfa, BFA_STATUS_IOC_FAILURE);
-		bfa_ioc_aen_post(ioc, BFA_IOC_AEN_FWMISMATCH);
+	ioc->cbfn->hbfail_cbfn(ioc->bfa);
+	list_for_each(qe, &ioc->hb_notify_q) {
+		notify = (struct bfa_ioc_hbfail_notify_s *) qe;
+		notify->cbfn(notify->cbarg);
 	}
-	ioc->retry_count++;
-	bfa_ioc_timer_start(ioc);
+
+	BFA_LOG(KERN_CRIT, bfad, log_level,
+		"Heart Beat of IOC has failed\n");
 }
 
 /**
- * Awaiting firmware version match.
+ * IOC failure.
  */
 static void
-bfa_ioc_sm_mismatch(struct bfa_ioc_s *ioc, enum ioc_event event)
+bfa_ioc_sm_fail(struct bfa_ioc_s *ioc, enum ioc_event event)
 {
 	bfa_trc(ioc, event);
 
 	switch (event) {
-	case IOC_E_TIMEOUT:
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_fwcheck);
+
+	case IOC_E_FAILED:
+		/**
+		 * Initialization failure during iocpf recovery.
+		 * !!! Fall through !!!
+		 */
+	case IOC_E_ENABLE:
+		ioc->cbfn->enable_cbfn(ioc->bfa, BFA_STATUS_IOC_FAILURE);
+		break;
+
+	case IOC_E_ENABLED:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_getattr);
 		break;
 
 	case IOC_E_DISABLE:
-		bfa_ioc_disable_comp(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabling);
+		break;
+
+	case IOC_E_HWERROR:
 		/*
-		 * fall through
+		 * HB failure notification, ignore.
 		 */
+		break;
+	default:
+		bfa_sm_fault(ioc, event);
+	}
+}
 
-	case IOC_E_DETACH:
-		bfa_ioc_timer_stop(ioc);
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_reset);
+
+
+/**
+ * IOCPF State Machine
+ */
+
+
+/**
+ * Reset entry actions -- initialize state machine
+ */
+static void
+bfa_iocpf_sm_reset_entry(struct bfa_iocpf_s *iocpf)
+{
+	iocpf->retry_count = 0;
+	iocpf->auto_recover = bfa_auto_recover;
+}
+
+/**
+ * Beginning state. IOC is in reset state.
+ */
+static void
+bfa_iocpf_sm_reset(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
+{
+	struct bfa_ioc_s *ioc = iocpf->ioc;
+
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOCPF_E_ENABLE:
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_fwcheck);
 		break;
 
-	case IOC_E_FWREADY:
+	case IOCPF_E_STOP:
 		break;
 
 	default:
@@ -269,31 +647,44 @@ bfa_ioc_sm_mismatch(struct bfa_ioc_s *ioc, enum ioc_event event)
 }
 
 /**
- * Request for semaphore.
+ * Semaphore should be acquired for version check.
  */
 static void
-bfa_ioc_sm_semwait_entry(struct bfa_ioc_s *ioc)
+bfa_iocpf_sm_fwcheck_entry(struct bfa_iocpf_s *iocpf)
 {
-	bfa_ioc_hw_sem_get(ioc);
+	bfa_ioc_hw_sem_get(iocpf->ioc);
 }
 
 /**
- * Awaiting semaphore for h/w initialzation.
+ * Awaiting h/w semaphore to continue with version check.
  */
 static void
-bfa_ioc_sm_semwait(struct bfa_ioc_s *ioc, enum ioc_event event)
+bfa_iocpf_sm_fwcheck(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 {
+	struct bfa_ioc_s *ioc = iocpf->ioc;
+
 	bfa_trc(ioc, event);
 
 	switch (event) {
-	case IOC_E_SEMLOCKED:
-		ioc->retry_count = 0;
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_hwinit);
+	case IOCPF_E_SEMLOCKED:
+		if (bfa_ioc_firmware_lock(ioc)) {
+			iocpf->retry_count = 0;
+			bfa_fsm_set_state(iocpf, bfa_iocpf_sm_hwinit);
+		} else {
+			bfa_ioc_hw_sem_release(ioc);
+			bfa_fsm_set_state(iocpf, bfa_iocpf_sm_mismatch);
+		}
 		break;
 
-	case IOC_E_DISABLE:
+	case IOCPF_E_DISABLE:
 		bfa_ioc_hw_sem_get_cancel(ioc);
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabled);
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_reset);
+		bfa_ioc_pf_disabled(ioc);
+		break;
+
+	case IOCPF_E_STOP:
+		bfa_ioc_hw_sem_get_cancel(ioc);
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_reset);
 		break;
 
 	default:
@@ -301,51 +692,81 @@ bfa_ioc_sm_semwait(struct bfa_ioc_s *ioc, enum ioc_event event)
 	}
 }
 
-
+/**
+ * Notify enable completion callback.
+ */
 static void
-bfa_ioc_sm_hwinit_entry(struct bfa_ioc_s *ioc)
+bfa_iocpf_sm_mismatch_entry(struct bfa_iocpf_s *iocpf)
 {
-	bfa_ioc_timer_start(ioc);
-	bfa_ioc_reset(ioc, BFA_FALSE);
+	/*
+	 * Call only the first time sm enters fwmismatch state.
+	 */
+	if (iocpf->retry_count == 0)
+		bfa_ioc_pf_fwmismatch(iocpf->ioc);
+
+	iocpf->retry_count++;
+	bfa_iocpf_timer_start(iocpf->ioc);
 }
 
 /**
- * Hardware is being initialized. Interrupts are enabled.
- * Holding hardware semaphore lock.
+ * Awaiting firmware version match.
  */
 static void
-bfa_ioc_sm_hwinit(struct bfa_ioc_s *ioc, enum ioc_event event)
+bfa_iocpf_sm_mismatch(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 {
+	struct bfa_ioc_s *ioc = iocpf->ioc;
+
 	bfa_trc(ioc, event);
 
 	switch (event) {
-	case IOC_E_FWREADY:
-		bfa_ioc_timer_stop(ioc);
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_enabling);
+	case IOCPF_E_TIMEOUT:
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_fwcheck);
 		break;
 
-	case IOC_E_HWERROR:
-		bfa_ioc_timer_stop(ioc);
-		/*
-		 * fall through
-		 */
+	case IOCPF_E_DISABLE:
+		bfa_iocpf_timer_stop(ioc);
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_reset);
+		bfa_ioc_pf_disabled(ioc);
+		break;
 
-	case IOC_E_TIMEOUT:
-		ioc->retry_count++;
-		if (ioc->retry_count < BFA_IOC_HWINIT_MAX) {
-			bfa_ioc_timer_start(ioc);
-			bfa_ioc_reset(ioc, BFA_TRUE);
-			break;
-		}
+	case IOCPF_E_STOP:
+		bfa_iocpf_timer_stop(ioc);
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_reset);
+		break;
 
-		bfa_ioc_hw_sem_release(ioc);
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_initfail);
+	default:
+		bfa_sm_fault(ioc, event);
+	}
+}
+
+/**
+ * Request for semaphore.
+ */
+static void
+bfa_iocpf_sm_semwait_entry(struct bfa_iocpf_s *iocpf)
+{
+	bfa_ioc_hw_sem_get(iocpf->ioc);
+}
+
+/**
+ * Awaiting semaphore for h/w initialzation.
+ */
+static void
+bfa_iocpf_sm_semwait(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
+{
+	struct bfa_ioc_s *ioc = iocpf->ioc;
+
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOCPF_E_SEMLOCKED:
+		iocpf->retry_count = 0;
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_hwinit);
 		break;
 
-	case IOC_E_DISABLE:
-		bfa_ioc_hw_sem_release(ioc);
-		bfa_ioc_timer_stop(ioc);
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabled);
+	case IOCPF_E_DISABLE:
+		bfa_ioc_hw_sem_get_cancel(ioc);
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_disabled);
 		break;
 
 	default:
@@ -355,55 +776,54 @@ bfa_ioc_sm_hwinit(struct bfa_ioc_s *ioc, enum ioc_event event)
 
 
 static void
-bfa_ioc_sm_enabling_entry(struct bfa_ioc_s *ioc)
+bfa_iocpf_sm_hwinit_entry(struct bfa_iocpf_s *iocpf)
 {
-	bfa_ioc_timer_start(ioc);
-	bfa_ioc_send_enable(ioc);
+	bfa_iocpf_timer_start(iocpf->ioc);
+	bfa_ioc_reset(iocpf->ioc, BFA_FALSE);
 }
 
 /**
- * Host IOC function is being enabled, awaiting response from firmware.
- * Semaphore is acquired.
+ * Hardware is being initialized. Interrupts are enabled.
+ * Holding hardware semaphore lock.
  */
 static void
-bfa_ioc_sm_enabling(struct bfa_ioc_s *ioc, enum ioc_event event)
+bfa_iocpf_sm_hwinit(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 {
+	struct bfa_ioc_s *ioc = iocpf->ioc;
+
 	bfa_trc(ioc, event);
 
 	switch (event) {
-	case IOC_E_FWRSP_ENABLE:
-		bfa_ioc_timer_stop(ioc);
-		bfa_ioc_hw_sem_release(ioc);
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_getattr);
+	case IOCPF_E_FWREADY:
+		bfa_iocpf_timer_stop(ioc);
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_enabling);
 		break;
 
-	case IOC_E_HWERROR:
-		bfa_ioc_timer_stop(ioc);
+	case IOCPF_E_INITFAIL:
+		bfa_iocpf_timer_stop(ioc);
 		/*
-		 * fall through
+		 * !!! fall through !!!
 		 */
 
-	case IOC_E_TIMEOUT:
-		ioc->retry_count++;
-		if (ioc->retry_count < BFA_IOC_HWINIT_MAX) {
-			bfa_reg_write(ioc->ioc_regs.ioc_fwstate,
-				      BFI_IOC_UNINIT);
-			bfa_fsm_set_state(ioc, bfa_ioc_sm_hwinit);
+	case IOCPF_E_TIMEOUT:
+		iocpf->retry_count++;
+		if (iocpf->retry_count < BFA_IOC_HWINIT_MAX) {
+			bfa_iocpf_timer_start(ioc);
+			bfa_ioc_reset(ioc, BFA_TRUE);
 			break;
 		}
 
 		bfa_ioc_hw_sem_release(ioc);
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_initfail);
-		break;
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_initfail);
 
-	case IOC_E_DISABLE:
-		bfa_ioc_timer_stop(ioc);
-		bfa_ioc_hw_sem_release(ioc);
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabled);
+		if (event == IOCPF_E_TIMEOUT)
+			bfa_ioc_pf_failed(ioc);
 		break;
 
-	case IOC_E_FWREADY:
-		bfa_ioc_send_enable(ioc);
+	case IOCPF_E_DISABLE:
+		bfa_ioc_hw_sem_release(ioc);
+		bfa_iocpf_timer_stop(ioc);
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_disabled);
 		break;
 
 	default:
@@ -413,40 +833,60 @@ bfa_ioc_sm_enabling(struct bfa_ioc_s *ioc, enum ioc_event event)
 
 
 static void
-bfa_ioc_sm_getattr_entry(struct bfa_ioc_s *ioc)
+bfa_iocpf_sm_enabling_entry(struct bfa_iocpf_s *iocpf)
 {
-	bfa_ioc_timer_start(ioc);
-	bfa_ioc_send_getattr(ioc);
+	bfa_iocpf_timer_start(iocpf->ioc);
+	bfa_ioc_send_enable(iocpf->ioc);
 }
 
 /**
- * IOC configuration in progress. Timer is active.
+ * Host IOC function is being enabled, awaiting response from firmware.
+ * Semaphore is acquired.
  */
 static void
-bfa_ioc_sm_getattr(struct bfa_ioc_s *ioc, enum ioc_event event)
+bfa_iocpf_sm_enabling(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 {
+	struct bfa_ioc_s *ioc = iocpf->ioc;
+
 	bfa_trc(ioc, event);
 
 	switch (event) {
-	case IOC_E_FWRSP_GETATTR:
-		bfa_ioc_timer_stop(ioc);
-		bfa_ioc_check_attr_wwns(ioc);
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_op);
+	case IOCPF_E_FWRSP_ENABLE:
+		bfa_iocpf_timer_stop(ioc);
+		bfa_ioc_hw_sem_release(ioc);
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_ready);
 		break;
 
-	case IOC_E_HWERROR:
-		bfa_ioc_timer_stop(ioc);
+	case IOCPF_E_INITFAIL:
+		bfa_iocpf_timer_stop(ioc);
 		/*
-		 * fall through
+		 * !!! fall through !!!
 		 */
 
-	case IOC_E_TIMEOUT:
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_initfail);
+	case IOCPF_E_TIMEOUT:
+		iocpf->retry_count++;
+		if (iocpf->retry_count < BFA_IOC_HWINIT_MAX) {
+			bfa_reg_write(ioc->ioc_regs.ioc_fwstate,
+				      BFI_IOC_UNINIT);
+			bfa_fsm_set_state(iocpf, bfa_iocpf_sm_hwinit);
+			break;
+		}
+
+		bfa_ioc_hw_sem_release(ioc);
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_initfail);
+
+		if (event == IOCPF_E_TIMEOUT)
+			bfa_ioc_pf_failed(ioc);
 		break;
 
-	case IOC_E_DISABLE:
-		bfa_ioc_timer_stop(ioc);
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabled);
+	case IOCPF_E_DISABLE:
+		bfa_iocpf_timer_stop(ioc);
+		bfa_ioc_hw_sem_release(ioc);
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_disabling);
+		break;
+
+	case IOCPF_E_FWREADY:
+		bfa_ioc_send_enable(ioc);
 		break;
 
 	default:
@@ -455,41 +895,40 @@ bfa_ioc_sm_getattr(struct bfa_ioc_s *ioc, enum ioc_event event)
 }
 
 
+
 static void
-bfa_ioc_sm_op_entry(struct bfa_ioc_s *ioc)
+bfa_iocpf_sm_ready_entry(struct bfa_iocpf_s *iocpf)
 {
-	ioc->cbfn->enable_cbfn(ioc->bfa, BFA_STATUS_OK);
-	bfa_ioc_hb_monitor(ioc);
-	bfa_ioc_aen_post(ioc, BFA_IOC_AEN_ENABLE);
+	bfa_ioc_pf_enabled(iocpf->ioc);
 }
 
 static void
-bfa_ioc_sm_op(struct bfa_ioc_s *ioc, enum ioc_event event)
+bfa_iocpf_sm_ready(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 {
+	struct bfa_ioc_s *ioc = iocpf->ioc;
+
 	bfa_trc(ioc, event);
 
 	switch (event) {
-	case IOC_E_ENABLE:
+	case IOCPF_E_DISABLE:
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_disabling);
+		break;
+
+	case IOCPF_E_GETATTRFAIL:
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_initfail);
 		break;
 
-	case IOC_E_DISABLE:
-		bfa_ioc_hb_stop(ioc);
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabling);
+	case IOCPF_E_FAIL:
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_fail);
 		break;
 
-	case IOC_E_HWERROR:
-	case IOC_E_FWREADY:
-		/**
-		 * Hard error or IOC recovery by other function.
-		 * Treat it same as heartbeat failure.
-		 */
-		bfa_ioc_hb_stop(ioc);
-		/*
-		 * !!! fall through !!!
-		 */
+	case IOCPF_E_FWREADY:
+		if (bfa_ioc_is_operational(ioc))
+			bfa_fsm_set_state(iocpf, bfa_iocpf_sm_fail);
+		else
+			bfa_fsm_set_state(iocpf, bfa_iocpf_sm_initfail);
 
-	case IOC_E_HBFAIL:
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_hbfail);
+		bfa_ioc_pf_failed(ioc);
 		break;
 
 	default:
@@ -499,36 +938,41 @@ bfa_ioc_sm_op(struct bfa_ioc_s *ioc, enum ioc_event event)
 
 
 static void
-bfa_ioc_sm_disabling_entry(struct bfa_ioc_s *ioc)
+bfa_iocpf_sm_disabling_entry(struct bfa_iocpf_s *iocpf)
 {
-	bfa_ioc_aen_post(ioc, BFA_IOC_AEN_DISABLE);
-	bfa_ioc_timer_start(ioc);
-	bfa_ioc_send_disable(ioc);
+	bfa_iocpf_timer_start(iocpf->ioc);
+	bfa_ioc_send_disable(iocpf->ioc);
 }
 
 /**
  * IOC is being disabled
  */
 static void
-bfa_ioc_sm_disabling(struct bfa_ioc_s *ioc, enum ioc_event event)
+bfa_iocpf_sm_disabling(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 {
+	struct bfa_ioc_s *ioc = iocpf->ioc;
+
 	bfa_trc(ioc, event);
 
 	switch (event) {
-	case IOC_E_FWRSP_DISABLE:
-		bfa_ioc_timer_stop(ioc);
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabled);
+	case IOCPF_E_FWRSP_DISABLE:
+	case IOCPF_E_FWREADY:
+		bfa_iocpf_timer_stop(ioc);
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_disabled);
 		break;
 
-	case IOC_E_HWERROR:
-		bfa_ioc_timer_stop(ioc);
+	case IOCPF_E_FAIL:
+		bfa_iocpf_timer_stop(ioc);
 		/*
 		 * !!! fall through !!!
 		 */
 
-	case IOC_E_TIMEOUT:
+	case IOCPF_E_TIMEOUT:
 		bfa_reg_write(ioc->ioc_regs.ioc_fwstate, BFI_IOC_FAIL);
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabled);
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_disabled);
+		break;
+
+	case IOCPF_E_FWRSP_ENABLE:
 		break;
 
 	default:
@@ -540,31 +984,26 @@ bfa_ioc_sm_disabling(struct bfa_ioc_s *ioc, enum ioc_event event)
  * IOC disable completion entry.
  */
 static void
-bfa_ioc_sm_disabled_entry(struct bfa_ioc_s *ioc)
+bfa_iocpf_sm_disabled_entry(struct bfa_iocpf_s *iocpf)
 {
-	bfa_ioc_disable_comp(ioc);
+	bfa_ioc_pf_disabled(iocpf->ioc);
 }
 
 static void
-bfa_ioc_sm_disabled(struct bfa_ioc_s *ioc, enum ioc_event event)
+bfa_iocpf_sm_disabled(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 {
+	struct bfa_ioc_s *ioc = iocpf->ioc;
+
 	bfa_trc(ioc, event);
 
 	switch (event) {
-	case IOC_E_ENABLE:
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_semwait);
-		break;
-
-	case IOC_E_DISABLE:
-		ioc->cbfn->disable_cbfn(ioc->bfa);
+	case IOCPF_E_ENABLE:
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_semwait);
 		break;
 
-	case IOC_E_FWREADY:
-		break;
-
-	case IOC_E_DETACH:
+	case IOCPF_E_STOP:
 		bfa_ioc_firmware_unlock(ioc);
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_reset);
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_reset);
 		break;
 
 	default:
@@ -574,34 +1013,35 @@ bfa_ioc_sm_disabled(struct bfa_ioc_s *ioc, enum ioc_event event)
 
 
 static void
-bfa_ioc_sm_initfail_entry(struct bfa_ioc_s *ioc)
+bfa_iocpf_sm_initfail_entry(struct bfa_iocpf_s *iocpf)
 {
-	ioc->cbfn->enable_cbfn(ioc->bfa, BFA_STATUS_IOC_FAILURE);
-	bfa_ioc_timer_start(ioc);
+	bfa_iocpf_timer_start(iocpf->ioc);
 }
 
 /**
  * Hardware initialization failed.
  */
 static void
-bfa_ioc_sm_initfail(struct bfa_ioc_s *ioc, enum ioc_event event)
+bfa_iocpf_sm_initfail(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 {
+	struct bfa_ioc_s *ioc = iocpf->ioc;
+
 	bfa_trc(ioc, event);
 
 	switch (event) {
-	case IOC_E_DISABLE:
-		bfa_ioc_timer_stop(ioc);
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabled);
+	case IOCPF_E_DISABLE:
+		bfa_iocpf_timer_stop(ioc);
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_disabled);
 		break;
 
-	case IOC_E_DETACH:
-		bfa_ioc_timer_stop(ioc);
+	case IOCPF_E_STOP:
+		bfa_iocpf_timer_stop(ioc);
 		bfa_ioc_firmware_unlock(ioc);
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_reset);
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_reset);
 		break;
 
-	case IOC_E_TIMEOUT:
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_semwait);
+	case IOCPF_E_TIMEOUT:
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_semwait);
 		break;
 
 	default:
@@ -611,80 +1051,47 @@ bfa_ioc_sm_initfail(struct bfa_ioc_s *ioc, enum ioc_event event)
 
 
 static void
-bfa_ioc_sm_hbfail_entry(struct bfa_ioc_s *ioc)
+bfa_iocpf_sm_fail_entry(struct bfa_iocpf_s *iocpf)
 {
-	struct list_head *qe;
-	struct bfa_ioc_hbfail_notify_s *notify;
-
 	/**
 	 * Mark IOC as failed in hardware and stop firmware.
 	 */
-	bfa_ioc_lpu_stop(ioc);
-	bfa_reg_write(ioc->ioc_regs.ioc_fwstate, BFI_IOC_FAIL);
+	bfa_ioc_lpu_stop(iocpf->ioc);
+	bfa_reg_write(iocpf->ioc->ioc_regs.ioc_fwstate, BFI_IOC_FAIL);
 
 	/**
 	 * Notify other functions on HB failure.
 	 */
-	bfa_ioc_notify_hbfail(ioc);
-
-	/**
-	 * Notify driver and common modules registered for notification.
-	 */
-	ioc->cbfn->hbfail_cbfn(ioc->bfa);
-	list_for_each(qe, &ioc->hb_notify_q) {
-		notify = (struct bfa_ioc_hbfail_notify_s *)qe;
-		notify->cbfn(notify->cbarg);
-	}
+	bfa_ioc_notify_hbfail(iocpf->ioc);
 
 	/**
 	 * Flush any queued up mailbox requests.
 	 */
-	bfa_ioc_mbox_hbfail(ioc);
-	bfa_ioc_aen_post(ioc, BFA_IOC_AEN_HBFAIL);
+	bfa_ioc_mbox_hbfail(iocpf->ioc);
 
-	/**
-	 * Trigger auto-recovery after a delay.
-	 */
-	if (ioc->auto_recover) {
-		bfa_timer_begin(ioc->timer_mod, &ioc->ioc_timer,
-				bfa_ioc_timeout, ioc, BFA_IOC_TOV_RECOVER);
-	}
+	if (iocpf->auto_recover)
+		bfa_iocpf_recovery_timer_start(iocpf->ioc);
 }
 
 /**
- * IOC heartbeat failure.
+ * IOC is in failed state.
  */
 static void
-bfa_ioc_sm_hbfail(struct bfa_ioc_s *ioc, enum ioc_event event)
+bfa_iocpf_sm_fail(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 {
+	struct bfa_ioc_s *ioc = iocpf->ioc;
+
 	bfa_trc(ioc, event);
 
 	switch (event) {
-
-	case IOC_E_ENABLE:
-		ioc->cbfn->enable_cbfn(ioc->bfa, BFA_STATUS_IOC_FAILURE);
+	case IOCPF_E_DISABLE:
+		if (iocpf->auto_recover)
+			bfa_iocpf_timer_stop(ioc);
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_disabled);
 		break;
 
-	case IOC_E_DISABLE:
-		if (ioc->auto_recover)
-			bfa_ioc_timer_stop(ioc);
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabled);
-		break;
-
-	case IOC_E_TIMEOUT:
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_semwait);
-		break;
-
-	case IOC_E_FWREADY:
-		/**
-		 * Recovery is already initiated by other function.
-		 */
-		break;
-
-	case IOC_E_HWERROR:
-		/*
-		 * HB failure notification, ignore.
-		 */
+	case IOCPF_E_TIMEOUT:
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_semwait);
 		break;
 
 	default:
@@ -695,14 +1102,14 @@ bfa_ioc_sm_hbfail(struct bfa_ioc_s *ioc, enum ioc_event event)
 
 
 /**
- *  bfa_ioc_pvt BFA IOC private functions
+ *  hal_ioc_pvt BFA IOC private functions
  */
 
 static void
 bfa_ioc_disable_comp(struct bfa_ioc_s *ioc)
 {
-	struct list_head *qe;
-	struct bfa_ioc_hbfail_notify_s *notify;
+	struct list_head			*qe;
+	struct bfa_ioc_hbfail_notify_s	*notify;
 
 	ioc->cbfn->disable_cbfn(ioc->bfa);
 
@@ -710,25 +1117,17 @@ bfa_ioc_disable_comp(struct bfa_ioc_s *ioc)
 	 * Notify common modules registered for notification.
 	 */
 	list_for_each(qe, &ioc->hb_notify_q) {
-		notify = (struct bfa_ioc_hbfail_notify_s *)qe;
+		notify = (struct bfa_ioc_hbfail_notify_s *) qe;
 		notify->cbfn(notify->cbarg);
 	}
 }
 
-void
-bfa_ioc_sem_timeout(void *ioc_arg)
-{
-	struct bfa_ioc_s *ioc = (struct bfa_ioc_s *)ioc_arg;
-
-	bfa_ioc_hw_sem_get(ioc);
-}
-
 bfa_boolean_t
 bfa_ioc_sem_get(bfa_os_addr_t sem_reg)
 {
 	u32 r32;
 	int cnt = 0;
-#define BFA_SEM_SPINCNT 3000
+#define BFA_SEM_SPINCNT	3000
 
 	r32 = bfa_reg_read(sem_reg);
 
@@ -754,7 +1153,7 @@ bfa_ioc_sem_release(bfa_os_addr_t sem_reg)
 static void
 bfa_ioc_hw_sem_get(struct bfa_ioc_s *ioc)
 {
-	u32        r32;
+	u32	r32;
 
 	/**
 	 * First read to the semaphore register will return 0, subsequent reads
@@ -762,12 +1161,11 @@ bfa_ioc_hw_sem_get(struct bfa_ioc_s *ioc)
 	 */
 	r32 = bfa_reg_read(ioc->ioc_regs.ioc_sem_reg);
 	if (r32 == 0) {
-		bfa_fsm_send_event(ioc, IOC_E_SEMLOCKED);
+		bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_SEMLOCKED);
 		return;
 	}
 
-	bfa_timer_begin(ioc->timer_mod, &ioc->sem_timer, bfa_ioc_sem_timeout,
-			ioc, BFA_IOC_HWSEM_TOV);
+	bfa_sem_timer_start(ioc);
 }
 
 void
@@ -779,7 +1177,7 @@ bfa_ioc_hw_sem_release(struct bfa_ioc_s *ioc)
 static void
 bfa_ioc_hw_sem_get_cancel(struct bfa_ioc_s *ioc)
 {
-	bfa_timer_stop(&ioc->sem_timer);
+	bfa_sem_timer_stop(ioc);
 }
 
 /**
@@ -788,14 +1186,18 @@ bfa_ioc_hw_sem_get_cancel(struct bfa_ioc_s *ioc)
 static void
 bfa_ioc_lmem_init(struct bfa_ioc_s *ioc)
 {
-	u32        pss_ctl;
-	int             i;
+	u32	pss_ctl;
+	int		i;
 #define PSS_LMEM_INIT_TIME  10000
 
 	pss_ctl = bfa_reg_read(ioc->ioc_regs.pss_ctl_reg);
 	pss_ctl &= ~__PSS_LMEM_RESET;
 	pss_ctl |= __PSS_LMEM_INIT_EN;
-	pss_ctl |= __PSS_I2C_CLK_DIV(3UL); /* i2c workaround 12.5khz clock */
+
+	/*
+	 * i2c workaround 12.5khz clock
+	 */
+	pss_ctl |= __PSS_I2C_CLK_DIV(3UL);
 	bfa_reg_write(ioc->ioc_regs.pss_ctl_reg, pss_ctl);
 
 	/**
@@ -821,7 +1223,7 @@ bfa_ioc_lmem_init(struct bfa_ioc_s *ioc)
 static void
 bfa_ioc_lpu_start(struct bfa_ioc_s *ioc)
 {
-	u32        pss_ctl;
+	u32	pss_ctl;
 
 	/**
 	 * Take processor out of reset.
@@ -835,7 +1237,7 @@ bfa_ioc_lpu_start(struct bfa_ioc_s *ioc)
 static void
 bfa_ioc_lpu_stop(struct bfa_ioc_s *ioc)
 {
-	u32        pss_ctl;
+	u32	pss_ctl;
 
 	/**
 	 * Put processors in reset.
@@ -852,10 +1254,10 @@ bfa_ioc_lpu_stop(struct bfa_ioc_s *ioc)
 void
 bfa_ioc_fwver_get(struct bfa_ioc_s *ioc, struct bfi_ioc_image_hdr_s *fwhdr)
 {
-	u32        pgnum, pgoff;
-	u32        loff = 0;
-	int             i;
-	u32       *fwsig = (u32 *) fwhdr;
+	u32	pgnum, pgoff;
+	u32	loff = 0;
+	int		i;
+	u32	*fwsig = (u32 *) fwhdr;
 
 	pgnum = bfa_ioc_smem_pgnum(ioc, loff);
 	pgoff = bfa_ioc_smem_pgoff(ioc, loff);
@@ -863,7 +1265,8 @@ bfa_ioc_fwver_get(struct bfa_ioc_s *ioc, struct bfi_ioc_image_hdr_s *fwhdr)
 
 	for (i = 0; i < (sizeof(struct bfi_ioc_image_hdr_s) / sizeof(u32));
 	     i++) {
-		fwsig[i] = bfa_mem_read(ioc->ioc_regs.smem_page_start, loff);
+		fwsig[i] =
+			bfa_mem_read(ioc->ioc_regs.smem_page_start, loff);
 		loff += sizeof(u32);
 	}
 }
@@ -875,10 +1278,10 @@ bfa_boolean_t
 bfa_ioc_fwver_cmp(struct bfa_ioc_s *ioc, struct bfi_ioc_image_hdr_s *fwhdr)
 {
 	struct bfi_ioc_image_hdr_s *drv_fwhdr;
-	int             i;
+	int i;
 
 	drv_fwhdr = (struct bfi_ioc_image_hdr_s *)
-			bfi_image_get_chunk(BFA_IOC_FWIMG_TYPE(ioc), 0);
+		bfa_cb_image_get_chunk(BFA_IOC_FWIMG_TYPE(ioc), 0);
 
 	for (i = 0; i < BFI_IOC_MD5SUM_SZ; i++) {
 		if (fwhdr->md5sum[i] != drv_fwhdr->md5sum[i]) {
@@ -897,21 +1300,20 @@ bfa_ioc_fwver_cmp(struct bfa_ioc_s *ioc, struct bfi_ioc_image_hdr_s *fwhdr)
  * Return true if current running version is valid. Firmware signature and
  * execution context (driver/bios) must match.
  */
-static          bfa_boolean_t
-bfa_ioc_fwver_valid(struct bfa_ioc_s *ioc)
+static bfa_boolean_t
+bfa_ioc_fwver_valid(struct bfa_ioc_s *ioc, u32 boot_env)
 {
 	struct bfi_ioc_image_hdr_s fwhdr, *drv_fwhdr;
 
 	/**
 	 * If bios/efi boot (flash based) -- return true
 	 */
-	if (bfa_ioc_is_optrom(ioc))
+	if (bfa_ioc_is_bios_optrom(ioc))
 		return BFA_TRUE;
 
 	bfa_ioc_fwver_get(ioc, &fwhdr);
 	drv_fwhdr = (struct bfi_ioc_image_hdr_s *)
-			bfi_image_get_chunk(BFA_IOC_FWIMG_TYPE(ioc), 0);
-
+		bfa_cb_image_get_chunk(BFA_IOC_FWIMG_TYPE(ioc), 0);
 
 	if (fwhdr.signature != drv_fwhdr->signature) {
 		bfa_trc(ioc, fwhdr.signature);
@@ -919,9 +1321,9 @@ bfa_ioc_fwver_valid(struct bfa_ioc_s *ioc)
 		return BFA_FALSE;
 	}
 
-	if (fwhdr.exec != drv_fwhdr->exec) {
-		bfa_trc(ioc, fwhdr.exec);
-		bfa_trc(ioc, drv_fwhdr->exec);
+	if (bfa_os_swap32(fwhdr.param) != boot_env) {
+		bfa_trc(ioc, fwhdr.param);
+		bfa_trc(ioc, boot_env);
 		return BFA_FALSE;
 	}
 
@@ -934,7 +1336,7 @@ bfa_ioc_fwver_valid(struct bfa_ioc_s *ioc)
 static void
 bfa_ioc_msgflush(struct bfa_ioc_s *ioc)
 {
-	u32        r32;
+	u32	r32;
 
 	r32 = bfa_reg_read(ioc->ioc_regs.lpu_mbox_cmd);
 	if (r32)
@@ -946,7 +1348,9 @@ static void
 bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force)
 {
 	enum bfi_ioc_state ioc_fwstate;
-	bfa_boolean_t   fwvalid;
+	bfa_boolean_t fwvalid;
+	u32 boot_type;
+	u32 boot_env;
 
 	ioc_fwstate = bfa_reg_read(ioc->ioc_regs.ioc_fwstate);
 
@@ -955,14 +1359,33 @@ bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force)
 
 	bfa_trc(ioc, ioc_fwstate);
 
+	boot_type = BFI_BOOT_TYPE_NORMAL;
+	boot_env = BFI_BOOT_LOADER_OS;
+
+	/**
+	 * Flash based firmware boot BIOS env.
+	 */
+	if (bfa_ioc_is_bios_optrom(ioc)) {
+		boot_type = BFI_BOOT_TYPE_FLASH;
+		boot_env = BFI_BOOT_LOADER_BIOS;
+	}
+
+	/**
+	 * Flash based firmware boot UEFI env.
+	 */
+	if (bfa_ioc_is_uefi(ioc)) {
+		boot_type = BFI_BOOT_TYPE_FLASH;
+		boot_env = BFI_BOOT_LOADER_UEFI;
+	}
+
 	/**
 	 * check if firmware is valid
 	 */
 	fwvalid = (ioc_fwstate == BFI_IOC_UNINIT) ?
-			BFA_FALSE : bfa_ioc_fwver_valid(ioc);
+		BFA_FALSE : bfa_ioc_fwver_valid(ioc, boot_env);
 
 	if (!fwvalid) {
-		bfa_ioc_boot(ioc, BFI_BOOT_TYPE_NORMAL, ioc->pcidev.device_id);
+		bfa_ioc_boot(ioc, boot_type, boot_env);
 		return;
 	}
 
@@ -971,7 +1394,6 @@ bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force)
 	 * just wait for an initialization completion interrupt.
 	 */
 	if (ioc_fwstate == BFI_IOC_INITING) {
-		bfa_trc(ioc, ioc_fwstate);
 		ioc->cbfn->reset_cbfn(ioc->bfa);
 		return;
 	}
@@ -985,8 +1407,7 @@ bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force)
 	 * is loaded.
 	 */
 	if (ioc_fwstate == BFI_IOC_DISABLED ||
-		(!bfa_ioc_is_optrom(ioc) && ioc_fwstate == BFI_IOC_OP)) {
-		bfa_trc(ioc, ioc_fwstate);
+	    (!bfa_ioc_is_bios_optrom(ioc) && ioc_fwstate == BFI_IOC_OP)) {
 
 		/**
 		 * When using MSI-X any pending firmware ready event should
@@ -994,20 +1415,20 @@ bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force)
 		 */
 		bfa_ioc_msgflush(ioc);
 		ioc->cbfn->reset_cbfn(ioc->bfa);
-		bfa_fsm_send_event(ioc, IOC_E_FWREADY);
+		bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_FWREADY);
 		return;
 	}
 
 	/**
 	 * Initialize the h/w for any other states.
 	 */
-	bfa_ioc_boot(ioc, BFI_BOOT_TYPE_NORMAL, ioc->pcidev.device_id);
+	bfa_ioc_boot(ioc, boot_type, boot_env);
 }
 
 static void
 bfa_ioc_timeout(void *ioc_arg)
 {
-	struct bfa_ioc_s *ioc = (struct bfa_ioc_s *)ioc_arg;
+	struct bfa_ioc_s  *ioc = (struct bfa_ioc_s *) ioc_arg;
 
 	bfa_trc(ioc, 0);
 	bfa_fsm_send_event(ioc, IOC_E_TIMEOUT);
@@ -1016,8 +1437,8 @@ bfa_ioc_timeout(void *ioc_arg)
 void
 bfa_ioc_mbox_send(struct bfa_ioc_s *ioc, void *ioc_msg, int len)
 {
-	u32       *msgp = (u32 *) ioc_msg;
-	u32        i;
+	u32 *msgp = (u32 *) ioc_msg;
+	u32 i;
 
 	bfa_trc(ioc, msgp[0]);
 	bfa_trc(ioc, len);
@@ -1038,17 +1459,20 @@ bfa_ioc_mbox_send(struct bfa_ioc_s *ioc, void *ioc_msg, int len)
 	 * write 1 to mailbox CMD to trigger LPU event
 	 */
 	bfa_reg_write(ioc->ioc_regs.hfn_mbox_cmd, 1);
-	(void)bfa_reg_read(ioc->ioc_regs.hfn_mbox_cmd);
+	(void) bfa_reg_read(ioc->ioc_regs.hfn_mbox_cmd);
 }
 
 static void
 bfa_ioc_send_enable(struct bfa_ioc_s *ioc)
 {
 	struct bfi_ioc_ctrl_req_s enable_req;
+	struct bfa_timeval_s tv;
 
 	bfi_h2i_set(enable_req.mh, BFI_MC_IOC, BFI_IOC_H2I_ENABLE_REQ,
 		    bfa_ioc_portid(ioc));
 	enable_req.ioc_class = ioc->ioc_mc;
+	bfa_os_gettimeofday(&tv);
+	enable_req.tv_sec = bfa_os_ntohl(tv.tv_sec);
 	bfa_ioc_mbox_send(ioc, &enable_req, sizeof(struct bfi_ioc_ctrl_req_s));
 }
 
@@ -1065,7 +1489,7 @@ bfa_ioc_send_disable(struct bfa_ioc_s *ioc)
 static void
 bfa_ioc_send_getattr(struct bfa_ioc_s *ioc)
 {
-	struct bfi_ioc_getattr_req_s attr_req;
+	struct bfi_ioc_getattr_req_s	attr_req;
 
 	bfi_h2i_set(attr_req.mh, BFI_MC_IOC, BFI_IOC_H2I_GETATTR_REQ,
 		    bfa_ioc_portid(ioc));
@@ -1077,12 +1501,11 @@ static void
 bfa_ioc_hb_check(void *cbarg)
 {
 	struct bfa_ioc_s  *ioc = cbarg;
-	u32     hb_count;
+	u32	hb_count;
 
 	hb_count = bfa_reg_read(ioc->ioc_regs.heartbeat);
 	if (ioc->hb_count == hb_count) {
-		bfa_log(ioc->logm, BFA_LOG_HAL_HEARTBEAT_FAILURE,
-			hb_count);
+		printk(KERN_CRIT "Firmware heartbeat failure at %d", hb_count);
 		bfa_ioc_recover(ioc);
 		return;
 	} else {
@@ -1090,61 +1513,54 @@ bfa_ioc_hb_check(void *cbarg)
 	}
 
 	bfa_ioc_mbox_poll(ioc);
-	bfa_timer_begin(ioc->timer_mod, &ioc->ioc_timer, bfa_ioc_hb_check,
-			ioc, BFA_IOC_HB_TOV);
+	bfa_hb_timer_start(ioc);
 }
 
 static void
 bfa_ioc_hb_monitor(struct bfa_ioc_s *ioc)
 {
 	ioc->hb_count = bfa_reg_read(ioc->ioc_regs.heartbeat);
-	bfa_timer_begin(ioc->timer_mod, &ioc->ioc_timer, bfa_ioc_hb_check, ioc,
-			BFA_IOC_HB_TOV);
+	bfa_hb_timer_start(ioc);
 }
 
 static void
 bfa_ioc_hb_stop(struct bfa_ioc_s *ioc)
 {
-	bfa_timer_stop(&ioc->ioc_timer);
+	bfa_hb_timer_stop(ioc);
 }
 
+
 /**
- *      Initiate a full firmware download.
+ *	Initiate a full firmware download.
  */
 static void
 bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,
-		    u32 boot_param)
+		    u32 boot_env)
 {
-	u32       *fwimg;
-	u32        pgnum, pgoff;
-	u32        loff = 0;
-	u32        chunkno = 0;
-	u32        i;
+	u32 *fwimg;
+	u32 pgnum, pgoff;
+	u32 loff = 0;
+	u32 chunkno = 0;
+	u32 i;
 
 	/**
 	 * Initialize LMEM first before code download
 	 */
 	bfa_ioc_lmem_init(ioc);
 
-	/**
-	 * Flash based firmware boot
-	 */
-	bfa_trc(ioc, bfi_image_get_size(BFA_IOC_FWIMG_TYPE(ioc)));
-	if (bfa_ioc_is_optrom(ioc))
-		boot_type = BFI_BOOT_TYPE_FLASH;
-	fwimg = bfi_image_get_chunk(BFA_IOC_FWIMG_TYPE(ioc), chunkno);
-
+	bfa_trc(ioc, bfa_cb_image_get_size(BFA_IOC_FWIMG_TYPE(ioc)));
+	fwimg = bfa_cb_image_get_chunk(BFA_IOC_FWIMG_TYPE(ioc), chunkno);
 
 	pgnum = bfa_ioc_smem_pgnum(ioc, loff);
 	pgoff = bfa_ioc_smem_pgoff(ioc, loff);
 
 	bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
 
-	for (i = 0; i < bfi_image_get_size(BFA_IOC_FWIMG_TYPE(ioc)); i++) {
+	for (i = 0; i < bfa_cb_image_get_size(BFA_IOC_FWIMG_TYPE(ioc)); i++) {
 
 		if (BFA_IOC_FLASH_CHUNK_NO(i) != chunkno) {
 			chunkno = BFA_IOC_FLASH_CHUNK_NO(i);
-			fwimg = bfi_image_get_chunk(BFA_IOC_FWIMG_TYPE(ioc),
+			fwimg = bfa_cb_image_get_chunk(BFA_IOC_FWIMG_TYPE(ioc),
 					BFA_IOC_FLASH_CHUNK_ADDR(chunkno));
 		}
 
@@ -1162,7 +1578,8 @@ bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,
 		loff = PSS_SMEM_PGOFF(loff);
 		if (loff == 0) {
 			pgnum++;
-			bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
+			bfa_reg_write(ioc->ioc_regs.host_page_num_fn,
+				      pgnum);
 		}
 	}
 
@@ -1171,105 +1588,274 @@ bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,
 
 	/*
 	 * Set boot type and boot param at the end.
-	 */
+	*/
 	bfa_mem_write(ioc->ioc_regs.smem_page_start, BFI_BOOT_TYPE_OFF,
 			bfa_os_swap32(boot_type));
-	bfa_mem_write(ioc->ioc_regs.smem_page_start, BFI_BOOT_PARAM_OFF,
-			bfa_os_swap32(boot_param));
+	bfa_mem_write(ioc->ioc_regs.smem_page_start, BFI_BOOT_LOADER_OFF,
+			bfa_os_swap32(boot_env));
+}
+
+static void
+bfa_ioc_reset(struct bfa_ioc_s *ioc, bfa_boolean_t force)
+{
+	bfa_ioc_hwinit(ioc, force);
+}
+
+/**
+ * Update BFA configuration from firmware configuration.
+ */
+static void
+bfa_ioc_getattr_reply(struct bfa_ioc_s *ioc)
+{
+	struct bfi_ioc_attr_s	*attr = ioc->attr;
+
+	attr->adapter_prop  = bfa_os_ntohl(attr->adapter_prop);
+	attr->card_type     = bfa_os_ntohl(attr->card_type);
+	attr->maxfrsize	    = bfa_os_ntohs(attr->maxfrsize);
+
+	bfa_fsm_send_event(ioc, IOC_E_FWRSP_GETATTR);
+}
+
+/**
+ * Attach time initialization of mbox logic.
+ */
+static void
+bfa_ioc_mbox_attach(struct bfa_ioc_s *ioc)
+{
+	struct bfa_ioc_mbox_mod_s	*mod = &ioc->mbox_mod;
+	int	mc;
+
+	INIT_LIST_HEAD(&mod->cmd_q);
+	for (mc = 0; mc < BFI_MC_MAX; mc++) {
+		mod->mbhdlr[mc].cbfn = NULL;
+		mod->mbhdlr[mc].cbarg = ioc->bfa;
+	}
+}
+
+/**
+ * Mbox poll timer -- restarts any pending mailbox requests.
+ */
+static void
+bfa_ioc_mbox_poll(struct bfa_ioc_s *ioc)
+{
+	struct bfa_ioc_mbox_mod_s	*mod = &ioc->mbox_mod;
+	struct bfa_mbox_cmd_s		*cmd;
+	u32			stat;
+
+	/**
+	 * If no command pending, do nothing
+	 */
+	if (list_empty(&mod->cmd_q))
+		return;
+
+	/**
+	 * If previous command is not yet fetched by firmware, do nothing
+	 */
+	stat = bfa_reg_read(ioc->ioc_regs.hfn_mbox_cmd);
+	if (stat)
+		return;
+
+	/**
+	 * Enqueue command to firmware.
+	 */
+	bfa_q_deq(&mod->cmd_q, &cmd);
+	bfa_ioc_mbox_send(ioc, cmd->msg, sizeof(cmd->msg));
+}
+
+/**
+ * Cleanup any pending requests.
+ */
+static void
+bfa_ioc_mbox_hbfail(struct bfa_ioc_s *ioc)
+{
+	struct bfa_ioc_mbox_mod_s	*mod = &ioc->mbox_mod;
+	struct bfa_mbox_cmd_s		*cmd;
+
+	while (!list_empty(&mod->cmd_q))
+		bfa_q_deq(&mod->cmd_q, &cmd);
+}
+
+/**
+ * Read data from SMEM to host through PCI memmap
+ *
+ * @param[in]	ioc	memory for IOC
+ * @param[in]	tbuf	app memory to store data from smem
+ * @param[in]	soff	smem offset
+ * @param[in]	sz	size of smem in bytes
+ */
+static bfa_status_t
+bfa_ioc_smem_read(struct bfa_ioc_s *ioc, void *tbuf, u32 soff, u32 sz)
+{
+	u32 pgnum, loff, r32;
+	int i, len;
+	u32 *buf = tbuf;
+
+	pgnum = bfa_ioc_smem_pgnum(ioc, soff);
+	loff = bfa_ioc_smem_pgoff(ioc, soff);
+	bfa_trc(ioc, pgnum);
+	bfa_trc(ioc, loff);
+	bfa_trc(ioc, sz);
+
+	/*
+	 *  Hold semaphore to serialize pll init and fwtrc.
+	 */
+	if (BFA_FALSE == bfa_ioc_sem_get(ioc->ioc_regs.ioc_init_sem_reg)) {
+		bfa_trc(ioc, 0);
+		return BFA_STATUS_FAILED;
+	}
+
+	bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
+
+	len = sz/sizeof(u32);
+	bfa_trc(ioc, len);
+	for (i = 0; i < len; i++) {
+		r32 = bfa_mem_read(ioc->ioc_regs.smem_page_start, loff);
+		buf[i] = bfa_os_ntohl(r32);
+		loff += sizeof(u32);
+
+		/**
+		 * handle page offset wrap around
+		 */
+		loff = PSS_SMEM_PGOFF(loff);
+		if (loff == 0) {
+			pgnum++;
+			bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
+		}
+	}
+	bfa_reg_write(ioc->ioc_regs.host_page_num_fn,
+		      bfa_ioc_smem_pgnum(ioc, 0));
+	/*
+	 *  release semaphore.
+	 */
+	bfa_ioc_sem_release(ioc->ioc_regs.ioc_init_sem_reg);
+
+	bfa_trc(ioc, pgnum);
+	return BFA_STATUS_OK;
+}
+
+/**
+ * Clear SMEM data from host through PCI memmap
+ *
+ * @param[in]	ioc	memory for IOC
+ * @param[in]	soff	smem offset
+ * @param[in]	sz	size of smem in bytes
+ */
+static bfa_status_t
+bfa_ioc_smem_clr(struct bfa_ioc_s *ioc, u32 soff, u32 sz)
+{
+	int i, len;
+	u32 pgnum, loff;
+
+	pgnum = bfa_ioc_smem_pgnum(ioc, soff);
+	loff = bfa_ioc_smem_pgoff(ioc, soff);
+	bfa_trc(ioc, pgnum);
+	bfa_trc(ioc, loff);
+	bfa_trc(ioc, sz);
+
+	/*
+	 *  Hold semaphore to serialize pll init and fwtrc.
+	 */
+	if (BFA_FALSE == bfa_ioc_sem_get(ioc->ioc_regs.ioc_init_sem_reg)) {
+		bfa_trc(ioc, 0);
+		return BFA_STATUS_FAILED;
+	}
+
+	bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
+
+	len = sz/sizeof(u32); /* len in words */
+	bfa_trc(ioc, len);
+	for (i = 0; i < len; i++) {
+		bfa_mem_write(ioc->ioc_regs.smem_page_start, loff, 0);
+		loff += sizeof(u32);
+
+		/**
+		 * handle page offset wrap around
+		 */
+		loff = PSS_SMEM_PGOFF(loff);
+		if (loff == 0) {
+			pgnum++;
+			bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
+		}
+	}
+	bfa_reg_write(ioc->ioc_regs.host_page_num_fn,
+		      bfa_ioc_smem_pgnum(ioc, 0));
+
+	/*
+	 *  release semaphore.
+	 */
+	bfa_ioc_sem_release(ioc->ioc_regs.ioc_init_sem_reg);
+	bfa_trc(ioc, pgnum);
+	return BFA_STATUS_OK;
 }
 
+/**
+ * hal iocpf to ioc interface
+ */
 static void
-bfa_ioc_reset(struct bfa_ioc_s *ioc, bfa_boolean_t force)
+bfa_ioc_pf_enabled(struct bfa_ioc_s *ioc)
 {
-	bfa_ioc_hwinit(ioc, force);
+	bfa_fsm_send_event(ioc, IOC_E_ENABLED);
 }
 
-/**
- * Update BFA configuration from firmware configuration.
- */
 static void
-bfa_ioc_getattr_reply(struct bfa_ioc_s *ioc)
+bfa_ioc_pf_disabled(struct bfa_ioc_s *ioc)
 {
-	struct bfi_ioc_attr_s *attr = ioc->attr;
-
-	attr->adapter_prop = bfa_os_ntohl(attr->adapter_prop);
-	attr->card_type     = bfa_os_ntohl(attr->card_type);
-	attr->maxfrsize = bfa_os_ntohs(attr->maxfrsize);
-
-	bfa_fsm_send_event(ioc, IOC_E_FWRSP_GETATTR);
+	bfa_fsm_send_event(ioc, IOC_E_DISABLED);
 }
 
-/**
- * Attach time initialization of mbox logic.
- */
 static void
-bfa_ioc_mbox_attach(struct bfa_ioc_s *ioc)
+bfa_ioc_pf_failed(struct bfa_ioc_s *ioc)
 {
-	struct bfa_ioc_mbox_mod_s *mod = &ioc->mbox_mod;
-	int             mc;
-
-	INIT_LIST_HEAD(&mod->cmd_q);
-	for (mc = 0; mc < BFI_MC_MAX; mc++) {
-		mod->mbhdlr[mc].cbfn = NULL;
-		mod->mbhdlr[mc].cbarg = ioc->bfa;
-	}
+	bfa_fsm_send_event(ioc, IOC_E_FAILED);
 }
 
-/**
- * Mbox poll timer -- restarts any pending mailbox requests.
- */
 static void
-bfa_ioc_mbox_poll(struct bfa_ioc_s *ioc)
+bfa_ioc_pf_fwmismatch(struct bfa_ioc_s *ioc)
 {
-	struct bfa_ioc_mbox_mod_s *mod = &ioc->mbox_mod;
-	struct bfa_mbox_cmd_s *cmd;
-	u32        stat;
-
+	struct bfad_s *bfad = (struct bfad_s *)ioc->bfa->bfad;
 	/**
-	 * If no command pending, do nothing
+	 * Provide enable completion callback.
 	 */
-	if (list_empty(&mod->cmd_q))
-		return;
+	ioc->cbfn->enable_cbfn(ioc->bfa, BFA_STATUS_IOC_FAILURE);
+	BFA_LOG(KERN_WARNING, bfad, log_level,
+		"Running firmware version is incompatible "
+		"with the driver version\n");
+}
 
-	/**
-	 * If previous command is not yet fetched by firmware, do nothing
-	 */
-	stat = bfa_reg_read(ioc->ioc_regs.hfn_mbox_cmd);
-	if (stat)
-		return;
 
-	/**
-	 * Enqueue command to firmware.
-	 */
-	bfa_q_deq(&mod->cmd_q, &cmd);
-	bfa_ioc_mbox_send(ioc, cmd->msg, sizeof(cmd->msg));
-}
 
 /**
- * Cleanup any pending requests.
+ *  hal_ioc_public
  */
-static void
-bfa_ioc_mbox_hbfail(struct bfa_ioc_s *ioc)
+
+bfa_status_t
+bfa_ioc_pll_init(struct bfa_ioc_s *ioc)
 {
-	struct bfa_ioc_mbox_mod_s *mod = &ioc->mbox_mod;
-	struct bfa_mbox_cmd_s *cmd;
 
-	while (!list_empty(&mod->cmd_q))
-		bfa_q_deq(&mod->cmd_q, &cmd);
-}
+	/*
+	 *  Hold semaphore so that nobody can access the chip during init.
+	 */
+	bfa_ioc_sem_get(ioc->ioc_regs.ioc_init_sem_reg);
 
-/**
- *  bfa_ioc_public
- */
+	bfa_ioc_pll_init_asic(ioc);
+
+	ioc->pllinit = BFA_TRUE;
+	/*
+	 *  release semaphore.
+	 */
+	bfa_ioc_sem_release(ioc->ioc_regs.ioc_init_sem_reg);
+
+	return BFA_STATUS_OK;
+}
 
 /**
  * Interface used by diag module to do firmware boot with memory test
  * as the entry vector.
  */
 void
-bfa_ioc_boot(struct bfa_ioc_s *ioc, u32 boot_type, u32 boot_param)
+bfa_ioc_boot(struct bfa_ioc_s *ioc, u32 boot_type, u32 boot_env)
 {
-	bfa_os_addr_t   rb;
+	bfa_os_addr_t	rb;
 
 	bfa_ioc_stats(ioc, ioc_boots);
 
@@ -1280,7 +1866,7 @@ bfa_ioc_boot(struct bfa_ioc_s *ioc, u32 boot_type, u32 boot_param)
 	 * Initialize IOC state of all functions on a chip reset.
 	 */
 	rb = ioc->pcidev.pci_bar_kva;
-	if (boot_param == BFI_BOOT_TYPE_MEMTEST) {
+	if (boot_type == BFI_BOOT_TYPE_MEMTEST) {
 		bfa_reg_write((rb + BFA_IOC0_STATE_REG), BFI_IOC_MEMTEST);
 		bfa_reg_write((rb + BFA_IOC1_STATE_REG), BFI_IOC_MEMTEST);
 	} else {
@@ -1289,7 +1875,7 @@ bfa_ioc_boot(struct bfa_ioc_s *ioc, u32 boot_type, u32 boot_param)
 	}
 
 	bfa_ioc_msgflush(ioc);
-	bfa_ioc_download_fw(ioc, boot_type, boot_param);
+	bfa_ioc_download_fw(ioc, boot_type, boot_env);
 
 	/**
 	 * Enable interrupts just before starting LPU
@@ -1308,18 +1894,29 @@ bfa_ioc_auto_recover(bfa_boolean_t auto_recover)
 }
 
 
+
 bfa_boolean_t
 bfa_ioc_is_operational(struct bfa_ioc_s *ioc)
 {
 	return bfa_fsm_cmp_state(ioc, bfa_ioc_sm_op);
 }
 
+bfa_boolean_t
+bfa_ioc_is_initialized(struct bfa_ioc_s *ioc)
+{
+	u32 r32 = bfa_reg_read(ioc->ioc_regs.ioc_fwstate);
+
+	return ((r32 != BFI_IOC_UNINIT) &&
+		(r32 != BFI_IOC_INITING) &&
+		(r32 != BFI_IOC_MEMTEST));
+}
+
 void
 bfa_ioc_msgget(struct bfa_ioc_s *ioc, void *mbmsg)
 {
-	u32       *msgp = mbmsg;
-	u32        r32;
-	int             i;
+	u32	*msgp = mbmsg;
+	u32	r32;
+	int		i;
 
 	/**
 	 * read the MBOX msg
@@ -1341,9 +1938,10 @@ bfa_ioc_msgget(struct bfa_ioc_s *ioc, void *mbmsg)
 void
 bfa_ioc_isr(struct bfa_ioc_s *ioc, struct bfi_mbmsg_s *m)
 {
-	union bfi_ioc_i2h_msg_u *msg;
+	union bfi_ioc_i2h_msg_u	*msg;
+	struct bfa_iocpf_s *iocpf = &ioc->iocpf;
 
-	msg = (union bfi_ioc_i2h_msg_u *)m;
+	msg = (union bfi_ioc_i2h_msg_u *) m;
 
 	bfa_ioc_stats(ioc, ioc_isrs);
 
@@ -1352,15 +1950,15 @@ bfa_ioc_isr(struct bfa_ioc_s *ioc, struct bfi_mbmsg_s *m)
 		break;
 
 	case BFI_IOC_I2H_READY_EVENT:
-		bfa_fsm_send_event(ioc, IOC_E_FWREADY);
+		bfa_fsm_send_event(iocpf, IOCPF_E_FWREADY);
 		break;
 
 	case BFI_IOC_I2H_ENABLE_REPLY:
-		bfa_fsm_send_event(ioc, IOC_E_FWRSP_ENABLE);
+		bfa_fsm_send_event(iocpf, IOCPF_E_FWRSP_ENABLE);
 		break;
 
 	case BFI_IOC_I2H_DISABLE_REPLY:
-		bfa_fsm_send_event(ioc, IOC_E_FWRSP_DISABLE);
+		bfa_fsm_send_event(iocpf, IOCPF_E_FWRSP_DISABLE);
 		break;
 
 	case BFI_IOC_I2H_GETATTR_REPLY:
@@ -1378,29 +1976,24 @@ bfa_ioc_isr(struct bfa_ioc_s *ioc, struct bfi_mbmsg_s *m)
  *
  * @param[in]	ioc	memory for IOC
  * @param[in]	bfa	driver instance structure
- * @param[in]	trcmod	kernel trace module
- * @param[in]	aen	kernel aen event module
- * @param[in]	logm	kernel logging module
  */
 void
 bfa_ioc_attach(struct bfa_ioc_s *ioc, void *bfa, struct bfa_ioc_cbfn_s *cbfn,
-	       struct bfa_timer_mod_s *timer_mod, struct bfa_trc_mod_s *trcmod,
-	       struct bfa_aen_s *aen, struct bfa_log_mod_s *logm)
-{
-	ioc->bfa = bfa;
-	ioc->cbfn = cbfn;
-	ioc->timer_mod = timer_mod;
-	ioc->trcmod = trcmod;
-	ioc->aen = aen;
-	ioc->logm = logm;
-	ioc->fcmode = BFA_FALSE;
-	ioc->pllinit = BFA_FALSE;
+	       struct bfa_timer_mod_s *timer_mod)
+{
+	ioc->bfa	= bfa;
+	ioc->cbfn	= cbfn;
+	ioc->timer_mod	= timer_mod;
+	ioc->fcmode	= BFA_FALSE;
+	ioc->pllinit	= BFA_FALSE;
 	ioc->dbg_fwsave_once = BFA_TRUE;
+	ioc->iocpf.ioc	= ioc;
 
 	bfa_ioc_mbox_attach(ioc);
 	INIT_LIST_HEAD(&ioc->hb_notify_q);
 
-	bfa_fsm_set_state(ioc, bfa_ioc_sm_reset);
+	bfa_fsm_set_state(ioc, bfa_ioc_sm_uninit);
+	bfa_fsm_send_event(ioc, IOC_E_RESET);
 }
 
 /**
@@ -1421,10 +2014,10 @@ void
 bfa_ioc_pci_init(struct bfa_ioc_s *ioc, struct bfa_pcidev_s *pcidev,
 		 enum bfi_mclass mc)
 {
-	ioc->ioc_mc = mc;
-	ioc->pcidev = *pcidev;
-	ioc->ctdev  = bfa_asic_id_ct(ioc->pcidev.device_id);
-	ioc->cna = ioc->ctdev && !ioc->fcmode;
+	ioc->ioc_mc	= mc;
+	ioc->pcidev	= *pcidev;
+	ioc->ctdev	= bfa_asic_id_ct(ioc->pcidev.device_id);
+	ioc->cna	= ioc->ctdev && !ioc->fcmode;
 
 	/**
 	 * Set asic specific interfaces. See bfa_ioc_cb.c and bfa_ioc_ct.c
@@ -1445,14 +2038,14 @@ bfa_ioc_pci_init(struct bfa_ioc_s *ioc, struct bfa_pcidev_s *pcidev,
  * @param[in]	dm_pa	physical address of IOC dma memory
  */
 void
-bfa_ioc_mem_claim(struct bfa_ioc_s *ioc, u8 *dm_kva, u64 dm_pa)
+bfa_ioc_mem_claim(struct bfa_ioc_s *ioc,  u8 *dm_kva, u64 dm_pa)
 {
 	/**
 	 * dma memory for firmware attribute
 	 */
 	ioc->attr_dma.kva = dm_kva;
 	ioc->attr_dma.pa = dm_pa;
-	ioc->attr = (struct bfi_ioc_attr_s *)dm_kva;
+	ioc->attr = (struct bfi_ioc_attr_s *) dm_kva;
 }
 
 /**
@@ -1490,7 +2083,7 @@ bfa_ioc_disable(struct bfa_ioc_s *ioc)
 int
 bfa_ioc_debug_trcsz(bfa_boolean_t auto_recover)
 {
-return (auto_recover) ? BFA_DBG_FWTRC_LEN : 0;
+	return (auto_recover) ? BFA_DBG_FWTRC_LEN : 0;
 }
 
 /**
@@ -1500,8 +2093,8 @@ return (auto_recover) ? BFA_DBG_FWTRC_LEN : 0;
 void
 bfa_ioc_debug_memclaim(struct bfa_ioc_s *ioc, void *dbg_fwsave)
 {
-	ioc->dbg_fwsave = dbg_fwsave;
-	ioc->dbg_fwsave_len = bfa_ioc_debug_trcsz(ioc->auto_recover);
+	ioc->dbg_fwsave	    = dbg_fwsave;
+	ioc->dbg_fwsave_len = bfa_ioc_debug_trcsz(ioc->iocpf.auto_recover);
 }
 
 u32
@@ -1525,8 +2118,8 @@ bfa_ioc_smem_pgoff(struct bfa_ioc_s *ioc, u32 fmaddr)
 void
 bfa_ioc_mbox_register(struct bfa_ioc_s *ioc, bfa_ioc_mbox_mcfunc_t *mcfuncs)
 {
-	struct bfa_ioc_mbox_mod_s *mod = &ioc->mbox_mod;
-	int             mc;
+	struct bfa_ioc_mbox_mod_s	*mod = &ioc->mbox_mod;
+	int				mc;
 
 	for (mc = 0; mc < BFI_MC_MAX; mc++)
 		mod->mbhdlr[mc].cbfn = mcfuncs[mc];
@@ -1539,10 +2132,10 @@ void
 bfa_ioc_mbox_regisr(struct bfa_ioc_s *ioc, enum bfi_mclass mc,
 		    bfa_ioc_mbox_mcfunc_t cbfn, void *cbarg)
 {
-	struct bfa_ioc_mbox_mod_s *mod = &ioc->mbox_mod;
+	struct bfa_ioc_mbox_mod_s	*mod = &ioc->mbox_mod;
 
-	mod->mbhdlr[mc].cbfn = cbfn;
-	mod->mbhdlr[mc].cbarg = cbarg;
+	mod->mbhdlr[mc].cbfn	= cbfn;
+	mod->mbhdlr[mc].cbarg	= cbarg;
 }
 
 /**
@@ -1555,8 +2148,8 @@ bfa_ioc_mbox_regisr(struct bfa_ioc_s *ioc, enum bfi_mclass mc,
 void
 bfa_ioc_mbox_queue(struct bfa_ioc_s *ioc, struct bfa_mbox_cmd_s *cmd)
 {
-	struct bfa_ioc_mbox_mod_s *mod = &ioc->mbox_mod;
-	u32        stat;
+	struct bfa_ioc_mbox_mod_s	*mod = &ioc->mbox_mod;
+	u32			stat;
 
 	/**
 	 * If a previous command is pending, queue new command
@@ -1587,9 +2180,9 @@ bfa_ioc_mbox_queue(struct bfa_ioc_s *ioc, struct bfa_mbox_cmd_s *cmd)
 void
 bfa_ioc_mbox_isr(struct bfa_ioc_s *ioc)
 {
-	struct bfa_ioc_mbox_mod_s *mod = &ioc->mbox_mod;
-	struct bfi_mbmsg_s m;
-	int             mc;
+	struct bfa_ioc_mbox_mod_s	*mod = &ioc->mbox_mod;
+	struct bfi_mbmsg_s		m;
+	int				mc;
 
 	bfa_ioc_msgget(ioc, &m);
 
@@ -1621,16 +2214,14 @@ bfa_ioc_set_fcmode(struct bfa_ioc_s *ioc)
 	ioc->port_id = bfa_ioc_pcifn(ioc);
 }
 
-#ifndef BFA_BIOS_BUILD
-
 /**
  * return true if IOC is disabled
  */
 bfa_boolean_t
 bfa_ioc_is_disabled(struct bfa_ioc_s *ioc)
 {
-	return bfa_fsm_cmp_state(ioc, bfa_ioc_sm_disabling)
-		|| bfa_fsm_cmp_state(ioc, bfa_ioc_sm_disabled);
+	return bfa_fsm_cmp_state(ioc, bfa_ioc_sm_disabling) ||
+		bfa_fsm_cmp_state(ioc, bfa_ioc_sm_disabled);
 }
 
 /**
@@ -1639,9 +2230,9 @@ bfa_ioc_is_disabled(struct bfa_ioc_s *ioc)
 bfa_boolean_t
 bfa_ioc_fw_mismatch(struct bfa_ioc_s *ioc)
 {
-	return bfa_fsm_cmp_state(ioc, bfa_ioc_sm_reset)
-		|| bfa_fsm_cmp_state(ioc, bfa_ioc_sm_fwcheck)
-		|| bfa_fsm_cmp_state(ioc, bfa_ioc_sm_mismatch);
+	return bfa_fsm_cmp_state(ioc, bfa_ioc_sm_reset) ||
+		bfa_fsm_cmp_state(&ioc->iocpf, bfa_iocpf_sm_fwcheck) ||
+		bfa_fsm_cmp_state(&ioc->iocpf, bfa_iocpf_sm_mismatch);
 }
 
 #define bfa_ioc_state_disabled(__sm)		\
@@ -1659,8 +2250,8 @@ bfa_ioc_fw_mismatch(struct bfa_ioc_s *ioc)
 bfa_boolean_t
 bfa_ioc_adapter_is_disabled(struct bfa_ioc_s *ioc)
 {
-	u32        ioc_state;
-	bfa_os_addr_t   rb = ioc->pcidev.pci_bar_kva;
+	u32	ioc_state;
+	bfa_os_addr_t	rb = ioc->pcidev.pci_bar_kva;
 
 	if (!bfa_fsm_cmp_state(ioc, bfa_ioc_sm_disabled))
 		return BFA_FALSE;
@@ -1669,16 +2260,18 @@ bfa_ioc_adapter_is_disabled(struct bfa_ioc_s *ioc)
 	if (!bfa_ioc_state_disabled(ioc_state))
 		return BFA_FALSE;
 
-	ioc_state = bfa_reg_read(rb + BFA_IOC1_STATE_REG);
-	if (!bfa_ioc_state_disabled(ioc_state))
-		return BFA_FALSE;
+	if (ioc->pcidev.device_id != BFA_PCI_DEVICE_ID_FC_8G1P) {
+		ioc_state = bfa_reg_read(rb + BFA_IOC1_STATE_REG);
+		if (!bfa_ioc_state_disabled(ioc_state))
+			return BFA_FALSE;
+	}
 
 	return BFA_TRUE;
 }
 
 /**
  * Add to IOC heartbeat failure notification queue. To be used by common
- * modules such as
+ * modules such as cee, port, diag.
  */
 void
 bfa_ioc_hbfail_register(struct bfa_ioc_s *ioc,
@@ -1692,7 +2285,7 @@ void
 bfa_ioc_get_adapter_attr(struct bfa_ioc_s *ioc,
 			 struct bfa_adapter_attr_s *ad_attr)
 {
-	struct bfi_ioc_attr_s *ioc_attr;
+	struct bfi_ioc_attr_s	*ioc_attr;
 
 	ioc_attr = ioc->attr;
 
@@ -1719,7 +2312,7 @@ bfa_ioc_get_adapter_attr(struct bfa_ioc_s *ioc,
 		ad_attr->prototype = 0;
 
 	ad_attr->pwwn = bfa_ioc_get_pwwn(ioc);
-	ad_attr->mac = bfa_ioc_get_mac(ioc);
+	ad_attr->mac  = bfa_ioc_get_mac(ioc);
 
 	ad_attr->pcie_gen = ioc_attr->pcie_gen;
 	ad_attr->pcie_lanes = ioc_attr->pcie_lanes;
@@ -1729,6 +2322,7 @@ bfa_ioc_get_adapter_attr(struct bfa_ioc_s *ioc,
 	bfa_ioc_get_pci_chip_rev(ioc, ad_attr->hw_ver);
 
 	ad_attr->cna_capable = ioc->cna;
+	ad_attr->trunk_capable = (ad_attr->nports > 1) && !ioc->cna;
 }
 
 enum bfa_ioc_type_e
@@ -1782,7 +2376,7 @@ bfa_ioc_get_adapter_optrom_ver(struct bfa_ioc_s *ioc, char *optrom_ver)
 {
 	bfa_os_memset((void *)optrom_ver, 0, BFA_VERSION_LEN);
 	bfa_os_memcpy(optrom_ver, ioc->attr->optrom_version,
-		BFA_VERSION_LEN);
+		      BFA_VERSION_LEN);
 }
 
 void
@@ -1795,7 +2389,7 @@ bfa_ioc_get_adapter_manufacturer(struct bfa_ioc_s *ioc, char *manufacturer)
 void
 bfa_ioc_get_adapter_model(struct bfa_ioc_s *ioc, char *model)
 {
-	struct bfi_ioc_attr_s   *ioc_attr;
+	struct bfi_ioc_attr_s	*ioc_attr;
 
 	bfa_assert(model);
 	bfa_os_memset((void *)model, 0, BFA_ADAPTER_MODEL_NAME_LEN);
@@ -1805,14 +2399,48 @@ bfa_ioc_get_adapter_model(struct bfa_ioc_s *ioc, char *model)
 	/**
 	 * model name
 	 */
-	snprintf(model, BFA_ADAPTER_MODEL_NAME_LEN, "%s-%u",
-			BFA_MFG_NAME, ioc_attr->card_type);
+	bfa_os_snprintf(model, BFA_ADAPTER_MODEL_NAME_LEN, "%s-%u",
+		BFA_MFG_NAME, ioc_attr->card_type);
 }
 
 enum bfa_ioc_state
 bfa_ioc_get_state(struct bfa_ioc_s *ioc)
 {
-	return bfa_sm_to_state(ioc_sm_table, ioc->fsm);
+	enum bfa_iocpf_state iocpf_st;
+	enum bfa_ioc_state ioc_st = bfa_sm_to_state(ioc_sm_table, ioc->fsm);
+
+	if (ioc_st == BFA_IOC_ENABLING ||
+		ioc_st == BFA_IOC_FAIL || ioc_st == BFA_IOC_INITFAIL) {
+
+		iocpf_st = bfa_sm_to_state(iocpf_sm_table, ioc->iocpf.fsm);
+
+		switch (iocpf_st) {
+		case BFA_IOCPF_SEMWAIT:
+			ioc_st = BFA_IOC_SEMWAIT;
+			break;
+
+		case BFA_IOCPF_HWINIT:
+			ioc_st = BFA_IOC_HWINIT;
+			break;
+
+		case BFA_IOCPF_FWMISMATCH:
+			ioc_st = BFA_IOC_FWMISMATCH;
+			break;
+
+		case BFA_IOCPF_FAIL:
+			ioc_st = BFA_IOC_FAIL;
+			break;
+
+		case BFA_IOCPF_INITFAIL:
+			ioc_st = BFA_IOC_INITFAIL;
+			break;
+
+		default:
+			break;
+		}
+	}
+
+	return ioc_st;
 }
 
 void
@@ -1833,7 +2461,7 @@ bfa_ioc_get_attr(struct bfa_ioc_s *ioc, struct bfa_ioc_attr_s *ioc_attr)
 }
 
 /**
- *  bfa_wwn_public
+ *  hal_wwn_public
  */
 wwn_t
 bfa_ioc_get_pwwn(struct bfa_ioc_s *ioc)
@@ -1857,10 +2485,10 @@ mac_t
 bfa_ioc_get_mac(struct bfa_ioc_s *ioc)
 {
 	/*
-	 * Currently mfg mac is used as FCoE enode mac (not configured by PBC)
+	 * Check the IOC type and return the appropriate MAC
 	 */
 	if (bfa_ioc_get_type(ioc) == BFA_IOC_TYPE_FCoE)
-		return bfa_ioc_get_mfg_mac(ioc);
+		return ioc->attr->fcoe_mac;
 	else
 		return ioc->attr->mac;
 }
@@ -1880,12 +2508,16 @@ bfa_ioc_get_mfg_nwwn(struct bfa_ioc_s *ioc)
 mac_t
 bfa_ioc_get_mfg_mac(struct bfa_ioc_s *ioc)
 {
-	mac_t   mac;
+	mac_t	m;
 
-	mac = ioc->attr->mfg_mac;
-	mac.mac[MAC_ADDRLEN - 1] += bfa_ioc_pcifn(ioc);
+	m = ioc->attr->mfg_mac;
+	if (bfa_mfg_is_old_wwn_mac_model(ioc->attr->card_type))
+		m.mac[MAC_ADDRLEN - 1] += bfa_ioc_pcifn(ioc);
+	else
+		bfa_mfg_increment_wwn_mac(&(m.mac[MAC_ADDRLEN-3]),
+			bfa_ioc_pcifn(ioc));
 
-	return mac;
+	return m;
 }
 
 bfa_boolean_t
@@ -1895,46 +2527,12 @@ bfa_ioc_get_fcmode(struct bfa_ioc_s *ioc)
 }
 
 /**
- * Send AEN notification
- */
-void
-bfa_ioc_aen_post(struct bfa_ioc_s *ioc, enum bfa_ioc_aen_event event)
-{
-	union bfa_aen_data_u aen_data;
-	struct bfa_log_mod_s *logmod = ioc->logm;
-	s32         inst_num = 0;
-	enum bfa_ioc_type_e ioc_type;
-
-	bfa_log(logmod, BFA_LOG_CREATE_ID(BFA_AEN_CAT_IOC, event), inst_num);
-
-	memset(&aen_data.ioc.pwwn, 0, sizeof(aen_data.ioc.pwwn));
-	memset(&aen_data.ioc.mac, 0, sizeof(aen_data.ioc.mac));
-	ioc_type = bfa_ioc_get_type(ioc);
-	switch (ioc_type) {
-	case BFA_IOC_TYPE_FC:
-		aen_data.ioc.pwwn = bfa_ioc_get_pwwn(ioc);
-		break;
-	case BFA_IOC_TYPE_FCoE:
-		aen_data.ioc.pwwn = bfa_ioc_get_pwwn(ioc);
-		aen_data.ioc.mac = bfa_ioc_get_mac(ioc);
-		break;
-	case BFA_IOC_TYPE_LL:
-		aen_data.ioc.mac = bfa_ioc_get_mac(ioc);
-		break;
-	default:
-		bfa_assert(ioc_type == BFA_IOC_TYPE_FC);
-		break;
-	}
-	aen_data.ioc.ioc_type = ioc_type;
-}
-
-/**
  * Retrieve saved firmware trace from a prior IOC failure.
  */
 bfa_status_t
 bfa_ioc_debug_fwsave(struct bfa_ioc_s *ioc, void *trcdata, int *trclen)
 {
-	int             tlen;
+	int	tlen;
 
 	if (ioc->dbg_fwsave_len == 0)
 		return BFA_STATUS_ENOFSAVE;
@@ -1963,57 +2561,145 @@ bfa_ioc_debug_fwsave_clear(struct bfa_ioc_s *ioc)
 bfa_status_t
 bfa_ioc_debug_fwtrc(struct bfa_ioc_s *ioc, void *trcdata, int *trclen)
 {
-	u32        pgnum;
-	u32        loff = BFA_DBG_FWTRC_OFF(bfa_ioc_portid(ioc));
-	int             i, tlen;
-	u32       *tbuf = trcdata, r32;
+	u32 loff = BFA_DBG_FWTRC_OFF(bfa_ioc_portid(ioc));
+	int tlen;
+	bfa_status_t status;
 
 	bfa_trc(ioc, *trclen);
 
-	pgnum = bfa_ioc_smem_pgnum(ioc, loff);
-	loff = bfa_ioc_smem_pgoff(ioc, loff);
-
-	/*
-	 *  Hold semaphore to serialize pll init and fwtrc.
-	 */
-	if (BFA_FALSE == bfa_ioc_sem_get(ioc->ioc_regs.ioc_init_sem_reg))
-		return BFA_STATUS_FAILED;
-
-	bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
-
 	tlen = *trclen;
 	if (tlen > BFA_DBG_FWTRC_LEN)
 		tlen = BFA_DBG_FWTRC_LEN;
-	tlen /= sizeof(u32);
 
-	bfa_trc(ioc, tlen);
+	status = bfa_ioc_smem_read(ioc, trcdata, loff, tlen);
+	*trclen = tlen;
+	return status;
+}
 
-	for (i = 0; i < tlen; i++) {
-		r32 = bfa_mem_read(ioc->ioc_regs.smem_page_start, loff);
-		tbuf[i] = bfa_os_ntohl(r32);
-		loff += sizeof(u32);
+static void
+bfa_ioc_send_fwsync(struct bfa_ioc_s *ioc)
+{
+	struct bfa_mbox_cmd_s cmd;
+	struct bfi_ioc_ctrl_req_s *req = (struct bfi_ioc_ctrl_req_s *) cmd.msg;
 
-		/**
-		 * handle page offset wrap around
-		 */
-		loff = PSS_SMEM_PGOFF(loff);
-		if (loff == 0) {
-			pgnum++;
-			bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
-		}
+	bfi_h2i_set(req->mh, BFI_MC_IOC, BFI_IOC_H2I_DBG_SYNC,
+		    bfa_ioc_portid(ioc));
+	req->ioc_class = ioc->ioc_mc;
+	bfa_ioc_mbox_queue(ioc, &cmd);
+}
+
+static void
+bfa_ioc_fwsync(struct bfa_ioc_s *ioc)
+{
+	u32 fwsync_iter = 1000;
+
+	bfa_ioc_send_fwsync(ioc);
+
+	/**
+	 * After sending a fw sync mbox command wait for it to
+	 * take effect.  We will not wait for a response because
+	 *    1. fw_sync mbox cmd doesn't have a response.
+	 *    2. Even if we implement that,  interrupts might not
+	 *	 be enabled when we call this function.
+	 * So, just keep checking if any mbox cmd is pending, and
+	 * after waiting for a reasonable amount of time, go ahead.
+	 * It is possible that fw has crashed and the mbox command
+	 * is never acknowledged.
+	 */
+	while (bfa_ioc_mbox_cmd_pending(ioc) && fwsync_iter > 0)
+		fwsync_iter--;
+}
+
+/**
+ * Dump firmware smem
+ */
+bfa_status_t
+bfa_ioc_debug_fwcore(struct bfa_ioc_s *ioc, void *buf,
+				u32 *offset, int *buflen)
+{
+	u32 loff;
+	int dlen;
+	bfa_status_t status;
+	u32 smem_len = BFA_IOC_FW_SMEM_SIZE(ioc);
+
+	if (*offset >= smem_len) {
+		*offset = *buflen = 0;
+		return BFA_STATUS_EINVAL;
 	}
-	bfa_reg_write(ioc->ioc_regs.host_page_num_fn,
-		      bfa_ioc_smem_pgnum(ioc, 0));
 
-	/*
-	 *  release semaphore.
+	loff = *offset;
+	dlen = *buflen;
+
+	/**
+	 * First smem read, sync smem before proceeding
+	 * No need to sync before reading every chunk.
 	 */
-	bfa_ioc_sem_release(ioc->ioc_regs.ioc_init_sem_reg);
+	if (loff == 0)
+		bfa_ioc_fwsync(ioc);
 
-	bfa_trc(ioc, pgnum);
+	if ((loff + dlen) >= smem_len)
+		dlen = smem_len - loff;
 
-	*trclen = tlen * sizeof(u32);
-	return BFA_STATUS_OK;
+	status = bfa_ioc_smem_read(ioc, buf, loff, dlen);
+
+	if (status != BFA_STATUS_OK) {
+		*offset = *buflen = 0;
+		return status;
+	}
+
+	*offset += dlen;
+
+	if (*offset >= smem_len)
+		*offset = 0;
+
+	*buflen = dlen;
+
+	return status;
+}
+
+/**
+ * Firmware statistics
+ */
+bfa_status_t
+bfa_ioc_fw_stats_get(struct bfa_ioc_s *ioc, void *stats)
+{
+	u32 loff = BFI_IOC_FWSTATS_OFF + \
+		BFI_IOC_FWSTATS_SZ * (bfa_ioc_portid(ioc));
+	int tlen;
+	bfa_status_t status;
+
+	if (ioc->stats_busy) {
+		bfa_trc(ioc, ioc->stats_busy);
+		return BFA_STATUS_DEVBUSY;
+	}
+	ioc->stats_busy = BFA_TRUE;
+
+	tlen = sizeof(struct bfa_fw_stats_s);
+	status = bfa_ioc_smem_read(ioc, stats, loff, tlen);
+
+	ioc->stats_busy = BFA_FALSE;
+	return status;
+}
+
+bfa_status_t
+bfa_ioc_fw_stats_clear(struct bfa_ioc_s *ioc)
+{
+	u32 loff = BFI_IOC_FWSTATS_OFF + \
+		BFI_IOC_FWSTATS_SZ * (bfa_ioc_portid(ioc));
+	int tlen;
+	bfa_status_t status;
+
+	if (ioc->stats_busy) {
+		bfa_trc(ioc, ioc->stats_busy);
+		return BFA_STATUS_DEVBUSY;
+	}
+	ioc->stats_busy = BFA_TRUE;
+
+	tlen = sizeof(struct bfa_fw_stats_s);
+	status = bfa_ioc_smem_clr(ioc, loff, tlen);
+
+	ioc->stats_busy = BFA_FALSE;
+	return status;
 }
 
 /**
@@ -2022,7 +2708,7 @@ bfa_ioc_debug_fwtrc(struct bfa_ioc_s *ioc, void *trcdata, int *trclen)
 static void
 bfa_ioc_debug_save(struct bfa_ioc_s *ioc)
 {
-	int             tlen;
+	int		tlen;
 
 	if (ioc->dbg_fwsave_len) {
 		tlen = ioc->dbg_fwsave_len;
@@ -2050,11 +2736,135 @@ bfa_ioc_check_attr_wwns(struct bfa_ioc_s *ioc)
 {
 	if (bfa_ioc_get_type(ioc) == BFA_IOC_TYPE_LL)
 		return;
+}
+
+/**
+ *  hal_iocpf_pvt BFA IOC PF private functions
+ */
 
-	if (ioc->attr->nwwn == 0)
-		bfa_ioc_aen_post(ioc, BFA_IOC_AEN_INVALID_NWWN);
-	if (ioc->attr->pwwn == 0)
-		bfa_ioc_aen_post(ioc, BFA_IOC_AEN_INVALID_PWWN);
+static void
+bfa_iocpf_enable(struct bfa_ioc_s *ioc)
+{
+	bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_ENABLE);
 }
 
-#endif
+static void
+bfa_iocpf_disable(struct bfa_ioc_s *ioc)
+{
+	bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_DISABLE);
+}
+
+static void
+bfa_iocpf_fail(struct bfa_ioc_s *ioc)
+{
+	bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_FAIL);
+}
+
+static void
+bfa_iocpf_initfail(struct bfa_ioc_s *ioc)
+{
+	bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_INITFAIL);
+}
+
+static void
+bfa_iocpf_getattrfail(struct bfa_ioc_s *ioc)
+{
+	bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_GETATTRFAIL);
+}
+
+static void
+bfa_iocpf_stop(struct bfa_ioc_s *ioc)
+{
+	bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_STOP);
+}
+
+static void
+bfa_iocpf_timeout(void *ioc_arg)
+{
+	struct bfa_ioc_s  *ioc = (struct bfa_ioc_s *) ioc_arg;
+
+	bfa_trc(ioc, 0);
+	bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_TIMEOUT);
+}
+
+static void
+bfa_iocpf_sem_timeout(void *ioc_arg)
+{
+	struct bfa_ioc_s  *ioc = (struct bfa_ioc_s *) ioc_arg;
+
+	bfa_ioc_hw_sem_get(ioc);
+}
+
+/**
+ *  bfa timer function
+ */
+void
+bfa_timer_init(struct bfa_timer_mod_s *mod)
+{
+	INIT_LIST_HEAD(&mod->timer_q);
+}
+
+void
+bfa_timer_beat(struct bfa_timer_mod_s *mod)
+{
+	struct list_head *qh = &mod->timer_q;
+	struct list_head *qe, *qe_next;
+	struct bfa_timer_s *elem;
+	struct list_head timedout_q;
+
+	INIT_LIST_HEAD(&timedout_q);
+
+	qe = bfa_q_next(qh);
+
+	while (qe != qh) {
+		qe_next = bfa_q_next(qe);
+
+		elem = (struct bfa_timer_s *) qe;
+		if (elem->timeout <= BFA_TIMER_FREQ) {
+			elem->timeout = 0;
+			list_del(&elem->qe);
+			list_add_tail(&elem->qe, &timedout_q);
+		} else {
+			elem->timeout -= BFA_TIMER_FREQ;
+		}
+
+		qe = qe_next;	/* go to next elem */
+	}
+
+	/*
+	 * Pop all the timeout entries
+	 */
+	while (!list_empty(&timedout_q)) {
+		bfa_q_deq(&timedout_q, &elem);
+		elem->timercb(elem->arg);
+	}
+}
+
+/**
+ * Should be called with lock protection
+ */
+void
+bfa_timer_begin(struct bfa_timer_mod_s *mod, struct bfa_timer_s *timer,
+		    void (*timercb) (void *), void *arg, unsigned int timeout)
+{
+
+	bfa_assert(timercb != NULL);
+	bfa_assert(!bfa_q_is_on_q(&mod->timer_q, timer));
+
+	timer->timeout = timeout;
+	timer->timercb = timercb;
+	timer->arg = arg;
+
+	list_add_tail(&timer->qe, &mod->timer_q);
+}
+
+/**
+ * Should be called with lock protection
+ */
+void
+bfa_timer_stop(struct bfa_timer_s *timer)
+{
+	bfa_assert(!list_empty(&timer->qe));
+
+	list_del(&timer->qe);
+}
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index cae05b2..288c580 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
  * All rights reserved
  * www.brocade.com
  *
@@ -18,18 +18,74 @@
 #ifndef __BFA_IOC_H__
 #define __BFA_IOC_H__
 
-#include <cs/bfa_sm.h>
-#include <bfi/bfi.h>
-#include <bfi/bfi_ioc.h>
-#include <bfi/bfi_boot.h>
-#include <bfa_timer.h>
+#include "bfa_os_inc.h"
+#include "bfa_cs.h"
+#include "bfi.h"
+
+/**
+ * BFA timer declarations
+ */
+typedef void (*bfa_timer_cbfn_t)(void *);
+
+/**
+ * BFA timer data structure
+ */
+struct bfa_timer_s {
+	struct list_head	qe;
+	bfa_timer_cbfn_t timercb;
+	void		*arg;
+	int		timeout;	/**< in millisecs. */
+};
+
+/**
+ * Timer module structure
+ */
+struct bfa_timer_mod_s {
+	struct list_head timer_q;
+};
+
+#define BFA_TIMER_FREQ 200 /**< specified in millisecs */
+
+void bfa_timer_beat(struct bfa_timer_mod_s *mod);
+void bfa_timer_init(struct bfa_timer_mod_s *mod);
+void bfa_timer_begin(struct bfa_timer_mod_s *mod, struct bfa_timer_s *timer,
+			bfa_timer_cbfn_t timercb, void *arg,
+			unsigned int timeout);
+void bfa_timer_stop(struct bfa_timer_s *timer);
+
+/**
+ * Generic Scatter Gather Element used by driver
+ */
+struct bfa_sge_s {
+	u32	sg_len;
+	void		*sg_addr;
+};
+
+#define bfa_sge_word_swap(__sge) do {					     \
+	((u32 *)(__sge))[0] = bfa_os_swap32(((u32 *)(__sge))[0]);      \
+	((u32 *)(__sge))[1] = bfa_os_swap32(((u32 *)(__sge))[1]);      \
+	((u32 *)(__sge))[2] = bfa_os_swap32(((u32 *)(__sge))[2]);      \
+} while (0)
+
+#define bfa_swap_words(_x)  (	\
+	((_x) << 32) | ((_x) >> 32))
+
+#ifdef __BIGENDIAN
+#define bfa_sge_to_be(_x)
+#define bfa_sge_to_le(_x)	bfa_sge_word_swap(_x)
+#define bfa_sgaddr_le(_x)	bfa_swap_words(_x)
+#else
+#define	bfa_sge_to_be(_x)	bfa_sge_word_swap(_x)
+#define bfa_sge_to_le(_x)
+#define bfa_sgaddr_le(_x)	(_x)
+#endif
 
 /**
  * PCI device information required by IOC
  */
 struct bfa_pcidev_s {
-	int             pci_slot;
-	u8         pci_func;
+	int		pci_slot;
+	u8		pci_func;
 	u16	device_id;
 	bfa_os_addr_t   pci_bar_kva;
 };
@@ -39,13 +95,18 @@ struct bfa_pcidev_s {
  * Address
  */
 struct bfa_dma_s {
-	void		*kva;	/*! Kernel virtual address	*/
-	u64	pa;	/*! Physical address		*/
+	void		*kva;	/* ! Kernel virtual address	*/
+	u64	pa;	/* ! Physical address		*/
 };
 
 #define BFA_DMA_ALIGN_SZ	256
 #define BFA_ROUNDUP(_l, _s)	(((_l) + ((_s) - 1)) & ~((_s) - 1))
 
+/**
+ * smem size for Crossbow and Catapult
+ */
+#define BFI_SMEM_CB_SIZE	0x200000U	/* ! 2MB for crossbow	*/
+#define BFI_SMEM_CT_SIZE	0x280000U	/* ! 2.5MB for catapult	*/
 
 
 #define bfa_dma_addr_set(dma_addr, pa)	\
@@ -101,7 +162,7 @@ struct bfa_ioc_regs_s {
  * IOC Mailbox structures
  */
 struct bfa_mbox_cmd_s {
-	struct list_head		qe;
+	struct list_head	qe;
 	u32	msg[BFI_IOC_MSGSZ];
 };
 
@@ -110,8 +171,8 @@ struct bfa_mbox_cmd_s {
  */
 typedef void (*bfa_ioc_mbox_mcfunc_t)(void *cbarg, struct bfi_mbmsg_s *m);
 struct bfa_ioc_mbox_mod_s {
-	struct list_head	cmd_q;		/*  pending mbox queue	*/
-	int		nmclass;	/*  number of handlers */
+	struct list_head		cmd_q;	/*  pending mbox queue	*/
+	int			nmclass;	/*  number of handlers */
 	struct {
 		bfa_ioc_mbox_mcfunc_t	cbfn;	/*  message handlers	*/
 		void			*cbarg;
@@ -149,49 +210,54 @@ struct bfa_ioc_hbfail_notify_s {
 	(__notify)->cbarg = (__cbarg);      \
 } while (0)
 
+struct bfa_iocpf_s {
+	bfa_fsm_t		fsm;
+	struct bfa_ioc_s	*ioc;
+	u32		retry_count;
+	bfa_boolean_t		auto_recover;
+};
+
 struct bfa_ioc_s {
 	bfa_fsm_t		fsm;
 	struct bfa_s		*bfa;
 	struct bfa_pcidev_s	pcidev;
-	struct bfa_timer_mod_s 	*timer_mod;
-	struct bfa_timer_s 	ioc_timer;
-	struct bfa_timer_s 	sem_timer;
+	struct bfa_timer_mod_s	*timer_mod;
+	struct bfa_timer_s	ioc_timer;
+	struct bfa_timer_s	sem_timer;
+	struct bfa_timer_s	hb_timer;
 	u32		hb_count;
-	u32		retry_count;
 	struct list_head		hb_notify_q;
 	void			*dbg_fwsave;
 	int			dbg_fwsave_len;
 	bfa_boolean_t		dbg_fwsave_once;
 	enum bfi_mclass		ioc_mc;
-	struct bfa_ioc_regs_s 	ioc_regs;
+	struct bfa_ioc_regs_s	ioc_regs;
 	struct bfa_trc_mod_s	*trcmod;
-	struct bfa_aen_s	*aen;
-	struct bfa_log_mod_s	*logm;
 	struct bfa_ioc_drv_stats_s	stats;
-	bfa_boolean_t		auto_recover;
 	bfa_boolean_t		fcmode;
 	bfa_boolean_t		ctdev;
 	bfa_boolean_t		cna;
 	bfa_boolean_t		pllinit;
+	bfa_boolean_t		stats_busy;	/*  outstanding stats */
 	u8			port_id;
-
 	struct bfa_dma_s	attr_dma;
 	struct bfi_ioc_attr_s	*attr;
 	struct bfa_ioc_cbfn_s	*cbfn;
 	struct bfa_ioc_mbox_mod_s mbox_mod;
-	struct bfa_ioc_hwif_s   *ioc_hwif;
+	struct bfa_ioc_hwif_s	*ioc_hwif;
+	struct bfa_iocpf_s	iocpf;
 };
 
 struct bfa_ioc_hwif_s {
-	bfa_status_t    (*ioc_pll_init) (struct bfa_ioc_s *ioc);
-	bfa_boolean_t   (*ioc_firmware_lock)    (struct bfa_ioc_s *ioc);
-	void            (*ioc_firmware_unlock)  (struct bfa_ioc_s *ioc);
-	void		(*ioc_reg_init) (struct bfa_ioc_s *ioc);
-	void		(*ioc_map_port) (struct bfa_ioc_s *ioc);
-	void		(*ioc_isr_mode_set)     (struct bfa_ioc_s *ioc,
-						bfa_boolean_t msix);
-	void            (*ioc_notify_hbfail)    (struct bfa_ioc_s *ioc);
-	void            (*ioc_ownership_reset)  (struct bfa_ioc_s *ioc);
+	bfa_status_t (*ioc_pll_init) (bfa_os_addr_t rb, bfa_boolean_t fcmode);
+	bfa_boolean_t	(*ioc_firmware_lock)	(struct bfa_ioc_s *ioc);
+	void		(*ioc_firmware_unlock)	(struct bfa_ioc_s *ioc);
+	void		(*ioc_reg_init)	(struct bfa_ioc_s *ioc);
+	void		(*ioc_map_port)	(struct bfa_ioc_s *ioc);
+	void		(*ioc_isr_mode_set)	(struct bfa_ioc_s *ioc,
+					bfa_boolean_t msix);
+	void		(*ioc_notify_hbfail)	(struct bfa_ioc_s *ioc);
+	void		(*ioc_ownership_reset)	(struct bfa_ioc_s *ioc);
 };
 
 #define bfa_ioc_pcifn(__ioc)		((__ioc)->pcidev.pci_func)
@@ -206,18 +272,19 @@ struct bfa_ioc_hwif_s {
 #define bfa_ioc_rx_bbcredit(__ioc)	((__ioc)->attr->rx_bbcredit)
 #define bfa_ioc_speed_sup(__ioc)	\
 	BFI_ADAPTER_GETP(SPEED, (__ioc)->attr->adapter_prop)
-#define bfa_ioc_get_nports(__ioc)       \
+#define bfa_ioc_get_nports(__ioc)	\
 	BFI_ADAPTER_GETP(NPORTS, (__ioc)->attr->adapter_prop)
 
-#define bfa_ioc_stats(_ioc, _stats)     ((_ioc)->stats._stats++)
-#define BFA_IOC_FWIMG_MINSZ     (16 * 1024)
-#define BFA_IOC_FWIMG_TYPE(__ioc)                                       \
-	(((__ioc)->ctdev) ?                                             \
-	 (((__ioc)->fcmode) ? BFI_IMAGE_CT_FC : BFI_IMAGE_CT_CNA) :     \
+#define bfa_ioc_stats(_ioc, _stats)	((_ioc)->stats._stats++)
+#define BFA_IOC_FWIMG_MINSZ	(16 * 1024)
+#define BFA_IOC_FWIMG_TYPE(__ioc)					\
+	(((__ioc)->ctdev) ?						\
+	 (((__ioc)->fcmode) ? BFI_IMAGE_CT_FC : BFI_IMAGE_CT_CNA) :	\
 	 BFI_IMAGE_CB_FC)
-
-#define BFA_IOC_FLASH_CHUNK_NO(off)             (off / BFI_FLASH_CHUNK_SZ_WORDS)
-#define BFA_IOC_FLASH_OFFSET_IN_CHUNK(off)      (off % BFI_FLASH_CHUNK_SZ_WORDS)
+#define BFA_IOC_FW_SMEM_SIZE(__ioc)					\
+	(((__ioc)->ctdev) ? BFI_SMEM_CT_SIZE : BFI_SMEM_CB_SIZE)
+#define BFA_IOC_FLASH_CHUNK_NO(off)		(off / BFI_FLASH_CHUNK_SZ_WORDS)
+#define BFA_IOC_FLASH_OFFSET_IN_CHUNK(off)	(off % BFI_FLASH_CHUNK_SZ_WORDS)
 #define BFA_IOC_FLASH_CHUNK_ADDR(chunkno)  (chunkno * BFI_FLASH_CHUNK_SZ_WORDS)
 
 /**
@@ -235,18 +302,28 @@ void bfa_ioc_mbox_regisr(struct bfa_ioc_s *ioc, enum bfi_mclass mc,
 /**
  * IOC interfaces
  */
-#define bfa_ioc_pll_init(__ioc) ((__ioc)->ioc_hwif->ioc_pll_init(__ioc))
-#define bfa_ioc_isr_mode_set(__ioc, __msix)                     \
+
+#define bfa_ioc_pll_init_asic(__ioc) \
+	((__ioc)->ioc_hwif->ioc_pll_init((__ioc)->pcidev.pci_bar_kva, \
+			   (__ioc)->fcmode))
+
+bfa_status_t bfa_ioc_pll_init(struct bfa_ioc_s *ioc);
+bfa_status_t bfa_ioc_cb_pll_init(bfa_os_addr_t rb, bfa_boolean_t fcmode);
+bfa_boolean_t bfa_ioc_ct_pll_init_complete(bfa_os_addr_t rb);
+bfa_status_t bfa_ioc_ct_pll_init(bfa_os_addr_t rb, bfa_boolean_t fcmode);
+
+#define	bfa_ioc_isr_mode_set(__ioc, __msix)			\
 			((__ioc)->ioc_hwif->ioc_isr_mode_set(__ioc, __msix))
-#define bfa_ioc_ownership_reset(__ioc)                          \
+#define	bfa_ioc_ownership_reset(__ioc)				\
 			((__ioc)->ioc_hwif->ioc_ownership_reset(__ioc))
 
+
 void bfa_ioc_set_ct_hwif(struct bfa_ioc_s *ioc);
 void bfa_ioc_set_cb_hwif(struct bfa_ioc_s *ioc);
+
 void bfa_ioc_attach(struct bfa_ioc_s *ioc, void *bfa,
-		struct bfa_ioc_cbfn_s *cbfn, struct bfa_timer_mod_s *timer_mod,
-		struct bfa_trc_mod_s *trcmod,
-		struct bfa_aen_s *aen, struct bfa_log_mod_s *logm);
+		struct bfa_ioc_cbfn_s *cbfn, struct bfa_timer_mod_s *timer_mod);
+void bfa_ioc_auto_recover(bfa_boolean_t auto_recover);
 void bfa_ioc_detach(struct bfa_ioc_s *ioc);
 void bfa_ioc_pci_init(struct bfa_ioc_s *ioc, struct bfa_pcidev_s *pcidev,
 		enum bfi_mclass mc);
@@ -256,21 +333,22 @@ void bfa_ioc_enable(struct bfa_ioc_s *ioc);
 void bfa_ioc_disable(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_intx_claim(struct bfa_ioc_s *ioc);
 
-void bfa_ioc_boot(struct bfa_ioc_s *ioc, u32 boot_type, u32 boot_param);
+void bfa_ioc_boot(struct bfa_ioc_s *ioc, u32 boot_type,
+		u32 boot_param);
 void bfa_ioc_isr(struct bfa_ioc_s *ioc, struct bfi_mbmsg_s *msg);
 void bfa_ioc_error_isr(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_is_operational(struct bfa_ioc_s *ioc);
+bfa_boolean_t bfa_ioc_is_initialized(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_is_disabled(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_fw_mismatch(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_adapter_is_disabled(struct bfa_ioc_s *ioc);
-void bfa_ioc_cfg_complete(struct bfa_ioc_s *ioc);
 enum bfa_ioc_type_e bfa_ioc_get_type(struct bfa_ioc_s *ioc);
 void bfa_ioc_get_adapter_serial_num(struct bfa_ioc_s *ioc, char *serial_num);
 void bfa_ioc_get_adapter_fw_ver(struct bfa_ioc_s *ioc, char *fw_ver);
 void bfa_ioc_get_adapter_optrom_ver(struct bfa_ioc_s *ioc, char *optrom_ver);
 void bfa_ioc_get_adapter_model(struct bfa_ioc_s *ioc, char *model);
 void bfa_ioc_get_adapter_manufacturer(struct bfa_ioc_s *ioc,
-	char *manufacturer);
+		char *manufacturer);
 void bfa_ioc_get_pci_chip_rev(struct bfa_ioc_s *ioc, char *chip_rev);
 enum bfa_ioc_state bfa_ioc_get_state(struct bfa_ioc_s *ioc);
 
@@ -284,6 +362,8 @@ bfa_status_t bfa_ioc_debug_fwsave(struct bfa_ioc_s *ioc, void *trcdata,
 void bfa_ioc_debug_fwsave_clear(struct bfa_ioc_s *ioc);
 bfa_status_t bfa_ioc_debug_fwtrc(struct bfa_ioc_s *ioc, void *trcdata,
 				 int *trclen);
+bfa_status_t bfa_ioc_debug_fwcore(struct bfa_ioc_s *ioc, void *buf,
+	u32 *offset, int *buflen);
 u32 bfa_ioc_smem_pgnum(struct bfa_ioc_s *ioc, u32 fmaddr);
 u32 bfa_ioc_smem_pgoff(struct bfa_ioc_s *ioc, u32 fmaddr);
 void bfa_ioc_set_fcmode(struct bfa_ioc_s *ioc);
@@ -297,7 +377,8 @@ void bfa_ioc_fwver_get(struct bfa_ioc_s *ioc,
 			struct bfi_ioc_image_hdr_s *fwhdr);
 bfa_boolean_t bfa_ioc_fwver_cmp(struct bfa_ioc_s *ioc,
 			struct bfi_ioc_image_hdr_s *fwhdr);
-void bfa_ioc_aen_post(struct bfa_ioc_s *ioc, enum bfa_ioc_aen_event event);
+bfa_status_t bfa_ioc_fw_stats_get(struct bfa_ioc_s *ioc, void *stats);
+bfa_status_t bfa_ioc_fw_stats_clear(struct bfa_ioc_s *ioc);
 
 /*
  * bfa mfg wwn API functions
@@ -310,5 +391,68 @@ wwn_t bfa_ioc_get_mfg_nwwn(struct bfa_ioc_s *ioc);
 mac_t bfa_ioc_get_mfg_mac(struct bfa_ioc_s *ioc);
 u64 bfa_ioc_get_adid(struct bfa_ioc_s *ioc);
 
-#endif /* __BFA_IOC_H__ */
+/*
+ * F/W Image Size & Chunk
+ */
+extern u32 bfi_image_ct_fc_size;
+extern u32 bfi_image_ct_cna_size;
+extern u32 bfi_image_cb_fc_size;
+extern u32 *bfi_image_ct_fc;
+extern u32 *bfi_image_ct_cna;
+extern u32 *bfi_image_cb_fc;
+
+static inline u32 *
+bfi_image_ct_fc_get_chunk(u32 off)
+{	return (u32 *)(bfi_image_ct_fc + off); }
+
+static inline u32 *
+bfi_image_ct_cna_get_chunk(u32 off)
+{	return (u32 *)(bfi_image_ct_cna + off); }
 
+static inline u32 *
+bfi_image_cb_fc_get_chunk(u32 off)
+{	return (u32 *)(bfi_image_cb_fc + off); }
+
+static inline u32*
+bfa_cb_image_get_chunk(int type, u32 off)
+{
+	switch (type) {
+	case BFI_IMAGE_CT_FC:
+		return bfi_image_ct_fc_get_chunk(off);	break;
+	case BFI_IMAGE_CT_CNA:
+		return bfi_image_ct_cna_get_chunk(off);	break;
+	case BFI_IMAGE_CB_FC:
+		return bfi_image_cb_fc_get_chunk(off);	break;
+	default: return 0;
+	}
+}
+
+static inline u32
+bfa_cb_image_get_size(int type)
+{
+	switch (type) {
+	case BFI_IMAGE_CT_FC:
+		return bfi_image_ct_fc_size;	break;
+	case BFI_IMAGE_CT_CNA:
+		return bfi_image_ct_cna_size;	break;
+	case BFI_IMAGE_CB_FC:
+		return bfi_image_cb_fc_size;	break;
+	default: return 0;
+	}
+}
+
+/**
+ * CNA TRCMOD declaration
+ */
+/*
+ * !!! Only append to the enums defined here to avoid any versioning
+ * !!! needed between trace utility and driver version
+ */
+enum {
+	BFA_TRC_CNA_PORT	= 1,
+	BFA_TRC_CNA_IOC		= 2,
+	BFA_TRC_CNA_IOC_CB	= 3,
+	BFA_TRC_CNA_IOC_CT	= 4,
+};
+
+#endif /* __BFA_IOC_H__ */
diff --git a/drivers/scsi/bfa/bfa_ioc_cb.c b/drivers/scsi/bfa/bfa_ioc_cb.c
index 324bdde..d7ac864 100644
--- a/drivers/scsi/bfa/bfa_ioc_cb.c
+++ b/drivers/scsi/bfa/bfa_ioc_cb.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
  * All rights reserved
  * www.brocade.com
  *
@@ -15,22 +15,15 @@
  * General Public License for more details.
  */
 
-#include <bfa.h>
-#include <bfa_ioc.h>
-#include <bfa_fwimg_priv.h>
-#include <cna/bfa_cna_trcmod.h>
-#include <cs/bfa_debug.h>
-#include <bfi/bfi_ioc.h>
-#include <bfi/bfi_cbreg.h>
-#include <log/bfa_log_hal.h>
-#include <defs/bfa_defs_pci.h>
+#include "bfa_ioc.h"
+#include "bfi_cbreg.h"
+#include "bfa_defs.h"
 
 BFA_TRC_FILE(CNA, IOC_CB);
 
 /*
  * forward declarations
  */
-static bfa_status_t bfa_ioc_cb_pll_init(struct bfa_ioc_s *ioc);
 static bfa_boolean_t bfa_ioc_cb_firmware_lock(struct bfa_ioc_s *ioc);
 static void bfa_ioc_cb_firmware_unlock(struct bfa_ioc_s *ioc);
 static void bfa_ioc_cb_reg_init(struct bfa_ioc_s *ioc);
@@ -95,6 +88,7 @@ static struct { u32 hfn_mbox, lpu_mbox, hfn_pgn; } iocreg_fnreg[] = {
  * Host <-> LPU mailbox command/status registers
  */
 static struct { u32 hfn, lpu; } iocreg_mbcmd[] = {
+
 	{ HOSTFN0_LPU0_CMD_STAT, LPU0_HOSTFN0_CMD_STAT },
 	{ HOSTFN1_LPU1_CMD_STAT, LPU1_HOSTFN1_CMD_STAT }
 };
@@ -154,6 +148,7 @@ bfa_ioc_cb_reg_init(struct bfa_ioc_s *ioc)
 /**
  * Initialize IOC to port mapping.
  */
+
 static void
 bfa_ioc_cb_map_port(struct bfa_ioc_s *ioc)
 {
@@ -161,6 +156,7 @@ bfa_ioc_cb_map_port(struct bfa_ioc_s *ioc)
 	 * For crossbow, port id is same as pci function.
 	 */
 	ioc->port_id = bfa_ioc_pcifn(ioc);
+
 	bfa_trc(ioc, ioc->port_id);
 }
 
@@ -172,87 +168,69 @@ bfa_ioc_cb_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix)
 {
 }
 
-static bfa_status_t
-bfa_ioc_cb_pll_init(struct bfa_ioc_s *ioc)
+/**
+ * Cleanup hw semaphore and usecnt registers
+ */
+static void
+bfa_ioc_cb_ownership_reset(struct bfa_ioc_s *ioc)
 {
-	bfa_os_addr_t	rb = ioc->pcidev.pci_bar_kva;
-	u32	pll_sclk, pll_fclk;
 
 	/*
-	 *  Hold semaphore so that nobody can access the chip during init.
+	 * Read the hw sem reg to make sure that it is locked
+	 * before we clear it. If it is not locked, writing 1
+	 * will lock it instead of clearing it.
 	 */
-	bfa_ioc_sem_get(ioc->ioc_regs.ioc_init_sem_reg);
+	bfa_reg_read(ioc->ioc_regs.ioc_sem_reg);
+	bfa_ioc_hw_sem_release(ioc);
+}
+
+
+
+bfa_status_t
+bfa_ioc_cb_pll_init(bfa_os_addr_t rb, bfa_boolean_t fcmode)
+{
+	u32	pll_sclk, pll_fclk;
 
 	pll_sclk = __APP_PLL_212_ENABLE | __APP_PLL_212_LRESETN |
-			__APP_PLL_212_P0_1(3U) |
-			__APP_PLL_212_JITLMT0_1(3U) |
-			__APP_PLL_212_CNTLMT0_1(3U);
+		__APP_PLL_212_P0_1(3U) |
+		__APP_PLL_212_JITLMT0_1(3U) |
+		__APP_PLL_212_CNTLMT0_1(3U);
 	pll_fclk = __APP_PLL_400_ENABLE | __APP_PLL_400_LRESETN |
-			__APP_PLL_400_RSEL200500 | __APP_PLL_400_P0_1(3U) |
-			__APP_PLL_400_JITLMT0_1(3U) |
-			__APP_PLL_400_CNTLMT0_1(3U);
-
+		__APP_PLL_400_RSEL200500 | __APP_PLL_400_P0_1(3U) |
+		__APP_PLL_400_JITLMT0_1(3U) |
+		__APP_PLL_400_CNTLMT0_1(3U);
 	bfa_reg_write((rb + BFA_IOC0_STATE_REG), BFI_IOC_UNINIT);
 	bfa_reg_write((rb + BFA_IOC1_STATE_REG), BFI_IOC_UNINIT);
-
 	bfa_reg_write((rb + HOSTFN0_INT_MSK), 0xffffffffU);
 	bfa_reg_write((rb + HOSTFN1_INT_MSK), 0xffffffffU);
 	bfa_reg_write((rb + HOSTFN0_INT_STATUS), 0xffffffffU);
 	bfa_reg_write((rb + HOSTFN1_INT_STATUS), 0xffffffffU);
 	bfa_reg_write((rb + HOSTFN0_INT_MSK), 0xffffffffU);
 	bfa_reg_write((rb + HOSTFN1_INT_MSK), 0xffffffffU);
-
-	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
-			__APP_PLL_212_LOGIC_SOFT_RESET);
-	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
-			__APP_PLL_212_BYPASS |
-			__APP_PLL_212_LOGIC_SOFT_RESET);
-	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
-			__APP_PLL_400_LOGIC_SOFT_RESET);
-	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
-			__APP_PLL_400_BYPASS |
-			__APP_PLL_400_LOGIC_SOFT_RESET);
+	bfa_reg_write(rb + APP_PLL_212_CTL_REG,
+			  __APP_PLL_212_LOGIC_SOFT_RESET);
+	bfa_reg_write(rb + APP_PLL_212_CTL_REG,
+			  __APP_PLL_212_BYPASS |
+			  __APP_PLL_212_LOGIC_SOFT_RESET);
+	bfa_reg_write(rb + APP_PLL_400_CTL_REG,
+			  __APP_PLL_400_LOGIC_SOFT_RESET);
+	bfa_reg_write(rb + APP_PLL_400_CTL_REG,
+			  __APP_PLL_400_BYPASS |
+			  __APP_PLL_400_LOGIC_SOFT_RESET);
 	bfa_os_udelay(2);
-	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
-			__APP_PLL_212_LOGIC_SOFT_RESET);
-	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
-			__APP_PLL_400_LOGIC_SOFT_RESET);
-
-	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
-			pll_sclk | __APP_PLL_212_LOGIC_SOFT_RESET);
-	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
-			pll_fclk | __APP_PLL_400_LOGIC_SOFT_RESET);
-
-	/**
-	 * Wait for PLLs to lock.
-	 */
+	bfa_reg_write(rb + APP_PLL_212_CTL_REG,
+			  __APP_PLL_212_LOGIC_SOFT_RESET);
+	bfa_reg_write(rb + APP_PLL_400_CTL_REG,
+			  __APP_PLL_400_LOGIC_SOFT_RESET);
+	bfa_reg_write(rb + APP_PLL_212_CTL_REG,
+			  pll_sclk | __APP_PLL_212_LOGIC_SOFT_RESET);
+	bfa_reg_write(rb + APP_PLL_400_CTL_REG,
+			  pll_fclk | __APP_PLL_400_LOGIC_SOFT_RESET);
 	bfa_os_udelay(2000);
 	bfa_reg_write((rb + HOSTFN0_INT_STATUS), 0xffffffffU);
 	bfa_reg_write((rb + HOSTFN1_INT_STATUS), 0xffffffffU);
-
-	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg, pll_sclk);
-	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg, pll_fclk);
-
-	/*
-	 *  release semaphore.
-	 */
-	bfa_ioc_sem_release(ioc->ioc_regs.ioc_init_sem_reg);
+	bfa_reg_write((rb + APP_PLL_212_CTL_REG), pll_sclk);
+	bfa_reg_write((rb + APP_PLL_400_CTL_REG), pll_fclk);
 
 	return BFA_STATUS_OK;
 }
-
-/**
- * Cleanup hw semaphore and usecnt registers
- */
-static void
-bfa_ioc_cb_ownership_reset(struct bfa_ioc_s *ioc)
-{
-
-	/*
-	 * Read the hw sem reg to make sure that it is locked
-	 * before we clear it. If it is not locked, writing 1
-	 * will lock it instead of clearing it.
-	 */
-	bfa_reg_read(ioc->ioc_regs.ioc_sem_reg);
-	bfa_ioc_hw_sem_release(ioc);
-}
diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
index 68f027d..f21b82c 100644
--- a/drivers/scsi/bfa/bfa_ioc_ct.c
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
  * All rights reserved
  * www.brocade.com
  *
@@ -15,22 +15,15 @@
  * General Public License for more details.
  */
 
-#include <bfa.h>
-#include <bfa_ioc.h>
-#include <bfa_fwimg_priv.h>
-#include <cna/bfa_cna_trcmod.h>
-#include <cs/bfa_debug.h>
-#include <bfi/bfi_ioc.h>
-#include <bfi/bfi_ctreg.h>
-#include <log/bfa_log_hal.h>
-#include <defs/bfa_defs_pci.h>
+#include "bfa_ioc.h"
+#include "bfi_ctreg.h"
+#include "bfa_defs.h"
 
 BFA_TRC_FILE(CNA, IOC_CT);
 
 /*
  * forward declarations
  */
-static bfa_status_t bfa_ioc_ct_pll_init(struct bfa_ioc_s *ioc);
 static bfa_boolean_t bfa_ioc_ct_firmware_lock(struct bfa_ioc_s *ioc);
 static void bfa_ioc_ct_firmware_unlock(struct bfa_ioc_s *ioc);
 static void bfa_ioc_ct_reg_init(struct bfa_ioc_s *ioc);
@@ -78,7 +71,8 @@ bfa_ioc_ct_firmware_lock(struct bfa_ioc_s *ioc)
 	/**
 	 * If bios boot (flash based) -- do not increment usage count
 	 */
-	if (bfi_image_get_size(BFA_IOC_FWIMG_TYPE(ioc)) < BFA_IOC_FWIMG_MINSZ)
+	if (bfa_cb_image_get_size(BFA_IOC_FWIMG_TYPE(ioc)) <
+						BFA_IOC_FWIMG_MINSZ)
 		return BFA_TRUE;
 
 	bfa_ioc_sem_get(ioc->ioc_regs.ioc_usage_sem_reg);
@@ -136,7 +130,8 @@ bfa_ioc_ct_firmware_unlock(struct bfa_ioc_s *ioc)
 	/**
 	 * If bios boot (flash based) -- do not decrement usage count
 	 */
-	if (bfi_image_get_size(BFA_IOC_FWIMG_TYPE(ioc)) < BFA_IOC_FWIMG_MINSZ)
+	if (bfa_cb_image_get_size(BFA_IOC_FWIMG_TYPE(ioc)) <
+						BFA_IOC_FWIMG_MINSZ)
 		return;
 
 	/**
@@ -308,16 +303,47 @@ bfa_ioc_ct_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix)
 	bfa_reg_write(rb + FNC_PERS_REG, r32);
 }
 
-static bfa_status_t
-bfa_ioc_ct_pll_init(struct bfa_ioc_s *ioc)
+/**
+ * Cleanup hw semaphore and usecnt registers
+ */
+static void
+bfa_ioc_ct_ownership_reset(struct bfa_ioc_s *ioc)
 {
-	bfa_os_addr_t	rb = ioc->pcidev.pci_bar_kva;
-	u32	pll_sclk, pll_fclk, r32;
+
+	if (ioc->cna) {
+		bfa_ioc_sem_get(ioc->ioc_regs.ioc_usage_sem_reg);
+		bfa_reg_write(ioc->ioc_regs.ioc_usage_reg, 0);
+		bfa_ioc_sem_release(ioc->ioc_regs.ioc_usage_sem_reg);
+	}
 
 	/*
-	 *  Hold semaphore so that nobody can access the chip during init.
+	 * Read the hw sem reg to make sure that it is locked
+	 * before we clear it. If it is not locked, writing 1
+	 * will lock it instead of clearing it.
 	 */
-	bfa_ioc_sem_get(ioc->ioc_regs.ioc_init_sem_reg);
+	bfa_reg_read(ioc->ioc_regs.ioc_sem_reg);
+	bfa_ioc_hw_sem_release(ioc);
+}
+
+
+
+/*
+ * Check the firmware state to know if pll_init has been completed already
+ */
+bfa_boolean_t
+bfa_ioc_ct_pll_init_complete(bfa_os_addr_t rb)
+{
+	if ((bfa_reg_read(rb + BFA_IOC0_STATE_REG) == BFI_IOC_OP) ||
+	  (bfa_reg_read(rb + BFA_IOC1_STATE_REG) == BFI_IOC_OP))
+		return BFA_TRUE;
+
+	return BFA_FALSE;
+}
+
+bfa_status_t
+bfa_ioc_ct_pll_init(bfa_os_addr_t rb, bfa_boolean_t fcmode)
+{
+	u32	pll_sclk, pll_fclk, r32;
 
 	pll_sclk = __APP_PLL_312_LRESETN | __APP_PLL_312_ENARST |
 		__APP_PLL_312_RSEL200500 | __APP_PLL_312_P0_1(3U) |
@@ -327,70 +353,50 @@ bfa_ioc_ct_pll_init(struct bfa_ioc_s *ioc)
 		__APP_PLL_425_RSEL200500 | __APP_PLL_425_P0_1(3U) |
 		__APP_PLL_425_JITLMT0_1(3U) |
 		__APP_PLL_425_CNTLMT0_1(1U);
-
-	/**
-	 *	For catapult, choose operational mode FC/FCoE
-	 */
-	if (ioc->fcmode) {
+	if (fcmode) {
 		bfa_reg_write((rb + OP_MODE), 0);
 		bfa_reg_write((rb + ETH_MAC_SER_REG),
 				__APP_EMS_CMLCKSEL |
 				__APP_EMS_REFCKBUFEN2 |
 				__APP_EMS_CHANNEL_SEL);
 	} else {
-		ioc->pllinit = BFA_TRUE;
 		bfa_reg_write((rb + OP_MODE), __GLOBAL_FCOE_MODE);
 		bfa_reg_write((rb + ETH_MAC_SER_REG),
-				 __APP_EMS_REFCKBUFEN1);
+				__APP_EMS_REFCKBUFEN1);
 	}
-
 	bfa_reg_write((rb + BFA_IOC0_STATE_REG), BFI_IOC_UNINIT);
 	bfa_reg_write((rb + BFA_IOC1_STATE_REG), BFI_IOC_UNINIT);
-
 	bfa_reg_write((rb + HOSTFN0_INT_MSK), 0xffffffffU);
 	bfa_reg_write((rb + HOSTFN1_INT_MSK), 0xffffffffU);
 	bfa_reg_write((rb + HOSTFN0_INT_STATUS), 0xffffffffU);
 	bfa_reg_write((rb + HOSTFN1_INT_STATUS), 0xffffffffU);
 	bfa_reg_write((rb + HOSTFN0_INT_MSK), 0xffffffffU);
 	bfa_reg_write((rb + HOSTFN1_INT_MSK), 0xffffffffU);
-
-	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg, pll_sclk |
+	bfa_reg_write(rb + APP_PLL_312_CTL_REG, pll_sclk |
 		__APP_PLL_312_LOGIC_SOFT_RESET);
-	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg, pll_fclk |
+	bfa_reg_write(rb + APP_PLL_425_CTL_REG, pll_fclk |
 		__APP_PLL_425_LOGIC_SOFT_RESET);
-	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg, pll_sclk |
+	bfa_reg_write(rb + APP_PLL_312_CTL_REG, pll_sclk |
 		__APP_PLL_312_LOGIC_SOFT_RESET | __APP_PLL_312_ENABLE);
-	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg, pll_fclk |
+	bfa_reg_write(rb + APP_PLL_425_CTL_REG, pll_fclk |
 		__APP_PLL_425_LOGIC_SOFT_RESET | __APP_PLL_425_ENABLE);
-
-	/**
-	 * Wait for PLLs to lock.
-	 */
 	bfa_reg_read(rb + HOSTFN0_INT_MSK);
 	bfa_os_udelay(2000);
 	bfa_reg_write((rb + HOSTFN0_INT_STATUS), 0xffffffffU);
 	bfa_reg_write((rb + HOSTFN1_INT_STATUS), 0xffffffffU);
-
-	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg, pll_sclk |
+	bfa_reg_write(rb + APP_PLL_312_CTL_REG, pll_sclk |
 		__APP_PLL_312_ENABLE);
-	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg, pll_fclk |
+	bfa_reg_write(rb + APP_PLL_425_CTL_REG, pll_fclk |
 		__APP_PLL_425_ENABLE);
-
-	/**
-	 * PSS memory reset is asserted at power-on-reset. Need to clear
-	 * this before running EDRAM BISTR
-	 */
-	if (ioc->cna) {
+	if (!fcmode) {
 		bfa_reg_write((rb + PMM_1T_RESET_REG_P0), __PMM_1T_RESET_P);
 		bfa_reg_write((rb + PMM_1T_RESET_REG_P1), __PMM_1T_RESET_P);
 	}
-
 	r32 = bfa_reg_read((rb + PSS_CTL_REG));
 	r32 &= ~__PSS_LMEM_RESET;
 	bfa_reg_write((rb + PSS_CTL_REG), r32);
 	bfa_os_udelay(1000);
-
-	if (ioc->cna) {
+	if (!fcmode) {
 		bfa_reg_write((rb + PMM_1T_RESET_REG_P0), 0);
 		bfa_reg_write((rb + PMM_1T_RESET_REG_P1), 0);
 	}
@@ -398,39 +404,6 @@ bfa_ioc_ct_pll_init(struct bfa_ioc_s *ioc)
 	bfa_reg_write((rb + MBIST_CTL_REG), __EDRAM_BISTR_START);
 	bfa_os_udelay(1000);
 	r32 = bfa_reg_read((rb + MBIST_STAT_REG));
-	bfa_trc(ioc, r32);
-
-	/**
-	 * Clear BISTR
-	 */
 	bfa_reg_write((rb + MBIST_CTL_REG), 0);
-
-	/*
-	 *  release semaphore.
-	 */
-	bfa_ioc_sem_release(ioc->ioc_regs.ioc_init_sem_reg);
-
 	return BFA_STATUS_OK;
 }
-
-/**
- * Cleanup hw semaphore and usecnt registers
- */
-static void
-bfa_ioc_ct_ownership_reset(struct bfa_ioc_s *ioc)
-{
-
-	if (ioc->cna) {
-		bfa_ioc_sem_get(ioc->ioc_regs.ioc_usage_sem_reg);
-		bfa_reg_write(ioc->ioc_regs.ioc_usage_reg, 0);
-		bfa_ioc_sem_release(ioc->ioc_regs.ioc_usage_sem_reg);
-	}
-
-	/*
-	 * Read the hw sem reg to make sure that it is locked
-	 * before we clear it. If it is not locked, writing 1
-	 * will lock it instead of clearing it.
-	 */
-	bfa_reg_read(ioc->ioc_regs.ioc_sem_reg);
-	bfa_ioc_hw_sem_release(ioc);
-}
-- 
1.7.3.rc1

