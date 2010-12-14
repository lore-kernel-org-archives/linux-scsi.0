From: <kgudipat@brocade.com>
Subject: [PATCH 3/6] bfa: IOC auto recovery fix.
Date: Mon, 13 Dec 2010 16:17:11 -0800
Message-ID: <1292285831-7885-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:59512 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757210Ab0LNAkH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Dec 2010 19:40:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, adapter_linux_open_src_team@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Made IOC auto_recovery synchronized and not timer based.
	- Only one PCI function will attempt to recover and reinitialize
	  the ASIC on a failure, after all the active PCI fns
	  acknowledge the IOC failure.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_ioc.c    |  288 ++++++++++++++++++++++++++++++-----------
 drivers/scsi/bfa/bfa_ioc.h    |   19 +++-
 drivers/scsi/bfa/bfa_ioc_cb.c |   95 +++++++++++++-
 drivers/scsi/bfa/bfa_ioc_ct.c |  101 ++++++++++++++-
 drivers/scsi/bfa/bfi_cbreg.h  |    1 +
 drivers/scsi/bfa/bfi_ctreg.h  |   41 ++++---
 6 files changed, 445 insertions(+), 100 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 47eea41..e027471 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -29,7 +29,7 @@ BFA_TRC_FILE(CNA, IOC);
 #define BFA_IOC_TOV		3000	/* msecs */
 #define BFA_IOC_HWSEM_TOV	500	/* msecs */
 #define BFA_IOC_HB_TOV		500	/* msecs */
-#define BFA_IOC_HWINIT_MAX	2
+#define BFA_IOC_HWINIT_MAX	5
 #define BFA_IOC_TOV_RECOVER	 BFA_IOC_HB_TOV
 
 #define bfa_ioc_timer_start(__ioc)					\
@@ -54,17 +54,16 @@ BFA_TRC_FILE(CNA, IOC);
 			((__ioc)->ioc_hwif->ioc_firmware_unlock(__ioc))
 #define bfa_ioc_reg_init(__ioc) ((__ioc)->ioc_hwif->ioc_reg_init(__ioc))
 #define bfa_ioc_map_port(__ioc) ((__ioc)->ioc_hwif->ioc_map_port(__ioc))
-#define bfa_ioc_notify_hbfail(__ioc)			\
-			((__ioc)->ioc_hwif->ioc_notify_hbfail(__ioc))
-
-#ifdef BFA_IOC_IS_UEFI
-#define bfa_ioc_is_bios_optrom(__ioc) (0)
-#define bfa_ioc_is_uefi(__ioc) BFA_IOC_IS_UEFI
-#else
-#define bfa_ioc_is_bios_optrom(__ioc)	\
-	(bfa_cb_image_get_size(BFA_IOC_FWIMG_TYPE(__ioc)) < BFA_IOC_FWIMG_MINSZ)
-#define bfa_ioc_is_uefi(__ioc) (0)
-#endif
+#define bfa_ioc_notify_fail(__ioc)              \
+			((__ioc)->ioc_hwif->ioc_notify_fail(__ioc))
+#define bfa_ioc_sync_join(__ioc)                \
+			((__ioc)->ioc_hwif->ioc_sync_join(__ioc))
+#define bfa_ioc_sync_leave(__ioc)               \
+			((__ioc)->ioc_hwif->ioc_sync_leave(__ioc))
+#define bfa_ioc_sync_ack(__ioc)                 \
+			((__ioc)->ioc_hwif->ioc_sync_ack(__ioc))
+#define bfa_ioc_sync_complete(__ioc)            \
+			((__ioc)->ioc_hwif->ioc_sync_complete(__ioc))
 
 #define bfa_ioc_mbox_cmd_pending(__ioc)		\
 			(!list_empty(&((__ioc)->mbox_mod.cmd_q)) || \
@@ -104,10 +103,11 @@ enum ioc_event {
 	IOC_E_ENABLED		= 5,	/*  f/w enabled		*/
 	IOC_E_FWRSP_GETATTR	= 6,	/*  IOC get attribute response	*/
 	IOC_E_DISABLED		= 7,	/*  f/w disabled		*/
-	IOC_E_PFFAILED		= 8,	/*  failure notice by iocpf sm	*/
-	IOC_E_HBFAIL		= 9,	/*  heartbeat failure		*/
-	IOC_E_HWERROR		= 10,	/*  hardware error interrupt	*/
-	IOC_E_TIMEOUT		= 11,	/*  timeout			*/
+	IOC_E_INITFAILED	= 8,	/*  failure notice by iocpf sm	*/
+	IOC_E_PFFAILED		= 9,	/*  failure notice by iocpf sm	*/
+	IOC_E_HBFAIL		= 10,	/*  heartbeat failure		*/
+	IOC_E_HWERROR		= 11,	/*  hardware error interrupt	*/
+	IOC_E_TIMEOUT		= 12,	/*  timeout			*/
 };
 
 bfa_fsm_state_decl(bfa_ioc, uninit, struct bfa_ioc_s, enum ioc_event);
@@ -195,9 +195,14 @@ bfa_fsm_state_decl(bfa_iocpf, semwait, struct bfa_iocpf_s, enum iocpf_event);
 bfa_fsm_state_decl(bfa_iocpf, hwinit, struct bfa_iocpf_s, enum iocpf_event);
 bfa_fsm_state_decl(bfa_iocpf, enabling, struct bfa_iocpf_s, enum iocpf_event);
 bfa_fsm_state_decl(bfa_iocpf, ready, struct bfa_iocpf_s, enum iocpf_event);
+bfa_fsm_state_decl(bfa_iocpf, initfail_sync, struct bfa_iocpf_s,
+						enum iocpf_event);
 bfa_fsm_state_decl(bfa_iocpf, initfail, struct bfa_iocpf_s, enum iocpf_event);
+bfa_fsm_state_decl(bfa_iocpf, fail_sync, struct bfa_iocpf_s, enum iocpf_event);
 bfa_fsm_state_decl(bfa_iocpf, fail, struct bfa_iocpf_s, enum iocpf_event);
 bfa_fsm_state_decl(bfa_iocpf, disabling, struct bfa_iocpf_s, enum iocpf_event);
+bfa_fsm_state_decl(bfa_iocpf, disabling_sync, struct bfa_iocpf_s,
+						enum iocpf_event);
 bfa_fsm_state_decl(bfa_iocpf, disabled, struct bfa_iocpf_s, enum iocpf_event);
 
 static struct bfa_sm_table_s iocpf_sm_table[] = {
@@ -208,9 +213,12 @@ static struct bfa_sm_table_s iocpf_sm_table[] = {
 	{BFA_SM(bfa_iocpf_sm_hwinit), BFA_IOCPF_HWINIT},
 	{BFA_SM(bfa_iocpf_sm_enabling), BFA_IOCPF_HWINIT},
 	{BFA_SM(bfa_iocpf_sm_ready), BFA_IOCPF_READY},
+	{BFA_SM(bfa_iocpf_sm_initfail_sync), BFA_IOCPF_INITFAIL},
 	{BFA_SM(bfa_iocpf_sm_initfail), BFA_IOCPF_INITFAIL},
+	{BFA_SM(bfa_iocpf_sm_fail_sync), BFA_IOCPF_FAIL},
 	{BFA_SM(bfa_iocpf_sm_fail), BFA_IOCPF_FAIL},
 	{BFA_SM(bfa_iocpf_sm_disabling), BFA_IOCPF_DISABLING},
+	{BFA_SM(bfa_iocpf_sm_disabling_sync), BFA_IOCPF_DISABLING},
 	{BFA_SM(bfa_iocpf_sm_disabled), BFA_IOCPF_DISABLED},
 };
 
@@ -497,7 +505,7 @@ bfa_ioc_sm_fail_retry_entry(struct bfa_ioc_s *ioc)
 }
 
 /*
- * Hardware initialization failed.
+ * Hardware initialization retry.
  */
 static void
 bfa_ioc_sm_fail_retry(struct bfa_ioc_s *ioc, enum ioc_event event)
@@ -519,6 +527,10 @@ bfa_ioc_sm_fail_retry(struct bfa_ioc_s *ioc, enum ioc_event event)
 			bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_INITFAIL);
 		break;
 
+	case IOC_E_INITFAILED:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_fail);
+		break;
+
 	case IOC_E_ENABLE:
 		break;
 
@@ -561,6 +573,11 @@ bfa_ioc_sm_fail(struct bfa_ioc_s *ioc, enum ioc_event event)
 		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabling);
 		break;
 
+	case IOC_E_DETACH:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_uninit);
+		bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_STOP);
+		break;
+
 	case IOC_E_HWERROR:
 		/*
 		 * HB failure notification, ignore.
@@ -630,8 +647,15 @@ bfa_iocpf_sm_fwcheck(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 	switch (event) {
 	case IOCPF_E_SEMLOCKED:
 		if (bfa_ioc_firmware_lock(ioc)) {
-			iocpf->retry_count = 0;
-			bfa_fsm_set_state(iocpf, bfa_iocpf_sm_hwinit);
+			if (bfa_ioc_sync_complete(ioc)) {
+				iocpf->retry_count = 0;
+				bfa_ioc_sync_join(ioc);
+				bfa_fsm_set_state(iocpf, bfa_iocpf_sm_hwinit);
+			} else {
+				bfa_ioc_firmware_unlock(ioc);
+                                writel(1, ioc->ioc_regs.ioc_sem_reg);
+				bfa_sem_timer_start(ioc);
+			}
 		} else {
 			writel(1, ioc->ioc_regs.ioc_sem_reg);
 			bfa_fsm_set_state(iocpf, bfa_iocpf_sm_mismatch);
@@ -722,13 +746,18 @@ bfa_iocpf_sm_semwait(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 
 	switch (event) {
 	case IOCPF_E_SEMLOCKED:
-		iocpf->retry_count = 0;
-		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_hwinit);
+		if (bfa_ioc_sync_complete(ioc)) {
+			bfa_ioc_sync_join(ioc);
+			bfa_fsm_set_state(iocpf, bfa_iocpf_sm_hwinit);
+		} else {
+			writel(1, ioc->ioc_regs.ioc_sem_reg);
+			bfa_sem_timer_start(ioc);
+		}
 		break;
 
 	case IOCPF_E_DISABLE:
 		bfa_sem_timer_stop(ioc);
-		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_disabled);
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_disabling_sync);
 		break;
 
 	default:
@@ -767,23 +796,16 @@ bfa_iocpf_sm_hwinit(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 		 */
 
 	case IOCPF_E_TIMEOUT:
-		iocpf->retry_count++;
-		if (iocpf->retry_count < BFA_IOC_HWINIT_MAX) {
-			bfa_iocpf_timer_start(ioc);
-			bfa_ioc_hwinit(ioc, BFA_TRUE);
-			break;
-		}
-
 		writel(1, ioc->ioc_regs.ioc_sem_reg);
-		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_initfail);
-
 		if (event == IOCPF_E_TIMEOUT)
 			bfa_fsm_send_event(ioc, IOC_E_PFFAILED);
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_initfail_sync);
 		break;
 
 	case IOCPF_E_DISABLE:
-		writel(1, ioc->ioc_regs.ioc_sem_reg);
 		bfa_iocpf_timer_stop(ioc);
+		bfa_ioc_sync_leave(ioc);
+		writel(1, ioc->ioc_regs.ioc_sem_reg);
 		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_disabled);
 		break;
 
@@ -824,18 +846,10 @@ bfa_iocpf_sm_enabling(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 		 */
 
 	case IOCPF_E_TIMEOUT:
-		iocpf->retry_count++;
-		if (iocpf->retry_count < BFA_IOC_HWINIT_MAX) {
-			writel(BFI_IOC_UNINIT, ioc->ioc_regs.ioc_fwstate);
-			bfa_fsm_set_state(iocpf, bfa_iocpf_sm_hwinit);
-			break;
-		}
-
 		writel(1, ioc->ioc_regs.ioc_sem_reg);
-		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_initfail);
-
 		if (event == IOCPF_E_TIMEOUT)
 			bfa_fsm_send_event(ioc, IOC_E_PFFAILED);
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_initfail_sync);
 		break;
 
 	case IOCPF_E_DISABLE:
@@ -872,20 +886,21 @@ bfa_iocpf_sm_ready(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 		break;
 
 	case IOCPF_E_GETATTRFAIL:
-		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_initfail);
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_initfail_sync);
 		break;
 
 	case IOCPF_E_FAIL:
-		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_fail);
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_fail_sync);
 		break;
 
 	case IOCPF_E_FWREADY:
-		if (bfa_fsm_cmp_state(ioc, bfa_ioc_sm_op))
-			bfa_fsm_set_state(iocpf, bfa_iocpf_sm_fail);
-		else
-			bfa_fsm_set_state(iocpf, bfa_iocpf_sm_initfail);
-
-		bfa_fsm_send_event(ioc, IOC_E_PFFAILED);
+		if (bfa_ioc_is_operational(ioc)) {
+			bfa_fsm_send_event(ioc, IOC_E_PFFAILED);
+			bfa_fsm_set_state(iocpf, bfa_iocpf_sm_fail_sync);
+		} else {
+			bfa_fsm_send_event(ioc, IOC_E_PFFAILED);
+			bfa_fsm_set_state(iocpf, bfa_iocpf_sm_initfail_sync);
+		}
 		break;
 
 	default:
@@ -914,7 +929,7 @@ bfa_iocpf_sm_disabling(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 	case IOCPF_E_FWRSP_DISABLE:
 	case IOCPF_E_FWREADY:
 		bfa_iocpf_timer_stop(ioc);
-		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_disabled);
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_disabling_sync);
 		break;
 
 	case IOCPF_E_FAIL:
@@ -925,7 +940,7 @@ bfa_iocpf_sm_disabling(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 
 	case IOCPF_E_TIMEOUT:
 		writel(BFI_IOC_FAIL, ioc->ioc_regs.ioc_fwstate);
-		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_disabled);
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_disabling_sync);
 		break;
 
 	case IOCPF_E_FWRSP_ENABLE:
@@ -936,6 +951,37 @@ bfa_iocpf_sm_disabling(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 	}
 }
 
+static void
+bfa_iocpf_sm_disabling_sync_entry(struct bfa_iocpf_s *iocpf)
+{
+	bfa_ioc_hw_sem_get(iocpf->ioc);
+}
+
+/**
+ * IOC hb ack request is being removed.
+ */
+static void
+bfa_iocpf_sm_disabling_sync(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
+{
+	struct bfa_ioc_s *ioc = iocpf->ioc;
+
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOCPF_E_SEMLOCKED:
+		bfa_ioc_sync_leave(ioc);
+		writel(1, ioc->ioc_regs.ioc_sem_reg);
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_disabled);
+		break;
+
+	case IOCPF_E_FAIL:
+		break;
+
+	default:
+		bfa_sm_fault(ioc, event);
+	}
+}
+
 /*
  * IOC disable completion entry.
  */
@@ -954,6 +1000,7 @@ bfa_iocpf_sm_disabled(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 
 	switch (event) {
 	case IOCPF_E_ENABLE:
+		iocpf->retry_count = 0;
 		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_semwait);
 		break;
 
@@ -968,9 +1015,64 @@ bfa_iocpf_sm_disabled(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 }
 
 static void
+bfa_iocpf_sm_initfail_sync_entry(struct bfa_iocpf_s *iocpf)
+{
+	bfa_ioc_hw_sem_get(iocpf->ioc);
+}
+
+/**
+ * @brief
+ * Hardware initialization failed.
+ */
+static void
+bfa_iocpf_sm_initfail_sync(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
+{
+	struct bfa_ioc_s *ioc = iocpf->ioc;
+
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOCPF_E_SEMLOCKED:
+		bfa_ioc_notify_fail(ioc);
+		bfa_ioc_sync_ack(ioc);
+		iocpf->retry_count++;
+		if (iocpf->retry_count >= BFA_IOC_HWINIT_MAX) {
+			bfa_ioc_sync_leave(ioc);
+			writel(1, ioc->ioc_regs.ioc_sem_reg);
+			bfa_fsm_set_state(iocpf, bfa_iocpf_sm_initfail);
+		} else {
+			if (bfa_ioc_sync_complete(ioc))
+				bfa_fsm_set_state(iocpf, bfa_iocpf_sm_hwinit);
+			else {
+				writel(1, ioc->ioc_regs.ioc_sem_reg);
+				bfa_fsm_set_state(iocpf, bfa_iocpf_sm_semwait);
+			}
+		}
+		break;
+
+	case IOCPF_E_DISABLE:
+		bfa_sem_timer_stop(ioc);
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_disabling_sync);
+		break;
+
+	case IOCPF_E_STOP:
+		bfa_sem_timer_stop(ioc);
+		bfa_ioc_firmware_unlock(ioc);
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_reset);
+		break;
+
+	case IOCPF_E_FAIL:
+		break;
+
+	default:
+		bfa_sm_fault(ioc, event);
+	}
+}
+
+static void
 bfa_iocpf_sm_initfail_entry(struct bfa_iocpf_s *iocpf)
 {
-	bfa_iocpf_timer_start(iocpf->ioc);
+	bfa_fsm_send_event(iocpf->ioc, IOC_E_INITFAILED);
 }
 
 /*
@@ -985,46 +1087,77 @@ bfa_iocpf_sm_initfail(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 
 	switch (event) {
 	case IOCPF_E_DISABLE:
-		bfa_iocpf_timer_stop(ioc);
 		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_disabled);
 		break;
 
 	case IOCPF_E_STOP:
-		bfa_iocpf_timer_stop(ioc);
 		bfa_ioc_firmware_unlock(ioc);
 		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_reset);
 		break;
 
-	case IOCPF_E_TIMEOUT:
-		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_semwait);
-		break;
-
 	default:
 		bfa_sm_fault(ioc, event);
 	}
 }
 
 static void
-bfa_iocpf_sm_fail_entry(struct bfa_iocpf_s *iocpf)
+bfa_iocpf_sm_fail_sync_entry(struct bfa_iocpf_s *iocpf)
 {
-	/*
+	/**
 	 * Mark IOC as failed in hardware and stop firmware.
 	 */
 	bfa_ioc_lpu_stop(iocpf->ioc);
-	writel(BFI_IOC_FAIL, iocpf->ioc->ioc_regs.ioc_fwstate);
-
-	/*
-	 * Notify other functions on HB failure.
-	 */
-	bfa_ioc_notify_hbfail(iocpf->ioc);
 
-	/*
+	/**
 	 * Flush any queued up mailbox requests.
 	 */
 	bfa_ioc_mbox_hbfail(iocpf->ioc);
 
-	if (iocpf->auto_recover)
-		bfa_iocpf_recovery_timer_start(iocpf->ioc);
+	bfa_ioc_hw_sem_get(iocpf->ioc);
+}
+
+static void
+bfa_iocpf_sm_fail_sync(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
+{
+	struct bfa_ioc_s *ioc = iocpf->ioc;
+
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOCPF_E_SEMLOCKED:
+		iocpf->retry_count = 0;
+		bfa_ioc_sync_ack(ioc);
+		bfa_ioc_notify_fail(ioc);
+		if (!iocpf->auto_recover) {
+			bfa_ioc_sync_leave(ioc);
+			writel(1, ioc->ioc_regs.ioc_sem_reg);
+			bfa_fsm_set_state(iocpf, bfa_iocpf_sm_fail);
+		} else {
+			if (bfa_ioc_sync_complete(ioc))
+				bfa_fsm_set_state(iocpf, bfa_iocpf_sm_hwinit);
+			else {
+				writel(1, ioc->ioc_regs.ioc_sem_reg);
+				bfa_fsm_set_state(iocpf, bfa_iocpf_sm_semwait);
+			}
+		}
+		break;
+
+	case IOCPF_E_DISABLE:
+		bfa_sem_timer_stop(ioc);
+		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_disabling_sync);
+		break;
+
+	case IOCPF_E_FAIL:
+		break;
+
+	default:
+		bfa_sm_fault(ioc, event);
+	}
+}
+
+static void
+bfa_iocpf_sm_fail_entry(struct bfa_iocpf_s *iocpf)
+{
 }
 
 /*
@@ -1039,15 +1172,9 @@ bfa_iocpf_sm_fail(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 
 	switch (event) {
 	case IOCPF_E_DISABLE:
-		if (iocpf->auto_recover)
-			bfa_iocpf_timer_stop(ioc);
 		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_disabled);
 		break;
 
-	case IOCPF_E_TIMEOUT:
-		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_semwait);
-		break;
-
 	default:
 		bfa_sm_fault(ioc, event);
 	}
@@ -1438,7 +1565,6 @@ bfa_ioc_hb_check(void *cbarg)
 
 	hb_count = readl(ioc->ioc_regs.heartbeat);
 	if (ioc->hb_count == hb_count) {
-		printk(KERN_CRIT "Firmware heartbeat failure at %d", hb_count);
 		bfa_ioc_recover(ioc);
 		return;
 	} else {
@@ -2153,6 +2279,16 @@ bfa_ioc_adapter_is_disabled(struct bfa_ioc_s *ioc)
 	return BFA_TRUE;
 }
 
+/**
+ * Reset IOC fwstate registers.
+ */
+void
+bfa_ioc_reset_fwstate(struct bfa_ioc_s *ioc)
+{
+	writel(BFI_IOC_UNINIT, ioc->ioc_regs.ioc_fwstate);
+	writel(BFI_IOC_UNINIT, ioc->ioc_regs.alt_ioc_fwstate);
+}
+
 #define BFA_MFG_NAME "Brocade"
 void
 bfa_ioc_get_adapter_attr(struct bfa_ioc_s *ioc,
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index 62153f2..5d2f342 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -149,8 +149,11 @@ struct bfa_ioc_regs_s {
 	void __iomem *host_page_num_fn;
 	void __iomem *heartbeat;
 	void __iomem *ioc_fwstate;
+	void __iomem *alt_ioc_fwstate;
 	void __iomem *ll_halt;
+	void __iomem *alt_ll_halt;
 	void __iomem *err_set;
+	void __iomem *ioc_fail_sync;
 	void __iomem *shirq_isr_next;
 	void __iomem *shirq_msk_next;
 	void __iomem *smem_page_start;
@@ -258,8 +261,12 @@ struct bfa_ioc_hwif_s {
 	void		(*ioc_map_port)	(struct bfa_ioc_s *ioc);
 	void		(*ioc_isr_mode_set)	(struct bfa_ioc_s *ioc,
 					bfa_boolean_t msix);
-	void		(*ioc_notify_hbfail)	(struct bfa_ioc_s *ioc);
+	void		(*ioc_notify_fail)	(struct bfa_ioc_s *ioc);
 	void		(*ioc_ownership_reset)	(struct bfa_ioc_s *ioc);
+	void		(*ioc_sync_join)	(struct bfa_ioc_s *ioc);
+	void		(*ioc_sync_leave)	(struct bfa_ioc_s *ioc);
+	void		(*ioc_sync_ack)		(struct bfa_ioc_s *ioc);
+	bfa_boolean_t	(*ioc_sync_complete)	(struct bfa_ioc_s *ioc);
 };
 
 #define bfa_ioc_pcifn(__ioc)		((__ioc)->pcidev.pci_func)
@@ -289,6 +296,15 @@ struct bfa_ioc_hwif_s {
 #define BFA_IOC_FLASH_OFFSET_IN_CHUNK(off)	(off % BFI_FLASH_CHUNK_SZ_WORDS)
 #define BFA_IOC_FLASH_CHUNK_ADDR(chunkno)  (chunkno * BFI_FLASH_CHUNK_SZ_WORDS)
 
+#ifdef BFA_IOC_IS_UEFI
+#define bfa_ioc_is_bios_optrom(__ioc) (0)
+#define bfa_ioc_is_uefi(__ioc) BFA_IOC_IS_UEFI
+#else
+#define bfa_ioc_is_bios_optrom(__ioc)   \
+	(bfa_cb_image_get_size(BFA_IOC_FWIMG_TYPE(__ioc)) < BFA_IOC_FWIMG_MINSZ)
+#define bfa_ioc_is_uefi(__ioc) (0)
+#endif
+
 /*
  * IOC mailbox interface
  */
@@ -343,6 +359,7 @@ bfa_boolean_t bfa_ioc_is_initialized(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_is_disabled(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_fw_mismatch(struct bfa_ioc_s *ioc);
 bfa_boolean_t bfa_ioc_adapter_is_disabled(struct bfa_ioc_s *ioc);
+void bfa_ioc_reset_fwstate(struct bfa_ioc_s *ioc);
 enum bfa_ioc_type_e bfa_ioc_get_type(struct bfa_ioc_s *ioc);
 void bfa_ioc_get_adapter_serial_num(struct bfa_ioc_s *ioc, char *serial_num);
 void bfa_ioc_get_adapter_fw_ver(struct bfa_ioc_s *ioc, char *fw_ver);
diff --git a/drivers/scsi/bfa/bfa_ioc_cb.c b/drivers/scsi/bfa/bfa_ioc_cb.c
index a0e05da..788ecca 100644
--- a/drivers/scsi/bfa/bfa_ioc_cb.c
+++ b/drivers/scsi/bfa/bfa_ioc_cb.c
@@ -30,8 +30,12 @@ static void bfa_ioc_cb_firmware_unlock(struct bfa_ioc_s *ioc);
 static void bfa_ioc_cb_reg_init(struct bfa_ioc_s *ioc);
 static void bfa_ioc_cb_map_port(struct bfa_ioc_s *ioc);
 static void bfa_ioc_cb_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix);
-static void bfa_ioc_cb_notify_hbfail(struct bfa_ioc_s *ioc);
+static void bfa_ioc_cb_notify_fail(struct bfa_ioc_s *ioc);
 static void bfa_ioc_cb_ownership_reset(struct bfa_ioc_s *ioc);
+static void bfa_ioc_cb_sync_join(struct bfa_ioc_s *ioc);
+static void bfa_ioc_cb_sync_leave(struct bfa_ioc_s *ioc);
+static void bfa_ioc_cb_sync_ack(struct bfa_ioc_s *ioc);
+static bfa_boolean_t bfa_ioc_cb_sync_complete(struct bfa_ioc_s *ioc);
 
 static struct bfa_ioc_hwif_s hwif_cb;
 
@@ -47,18 +51,38 @@ bfa_ioc_set_cb_hwif(struct bfa_ioc_s *ioc)
 	hwif_cb.ioc_reg_init = bfa_ioc_cb_reg_init;
 	hwif_cb.ioc_map_port = bfa_ioc_cb_map_port;
 	hwif_cb.ioc_isr_mode_set = bfa_ioc_cb_isr_mode_set;
-	hwif_cb.ioc_notify_hbfail = bfa_ioc_cb_notify_hbfail;
+	hwif_cb.ioc_notify_fail = bfa_ioc_cb_notify_fail;
 	hwif_cb.ioc_ownership_reset = bfa_ioc_cb_ownership_reset;
+	hwif_cb.ioc_sync_join = bfa_ioc_cb_sync_join;
+	hwif_cb.ioc_sync_leave = bfa_ioc_cb_sync_leave;
+	hwif_cb.ioc_sync_ack = bfa_ioc_cb_sync_ack;
+	hwif_cb.ioc_sync_complete = bfa_ioc_cb_sync_complete;
 
 	ioc->ioc_hwif = &hwif_cb;
 }
 
-/*
+/**
  * Return true if firmware of current driver matches the running firmware.
  */
 static bfa_boolean_t
 bfa_ioc_cb_firmware_lock(struct bfa_ioc_s *ioc)
 {
+	struct bfi_ioc_image_hdr_s fwhdr;
+	uint32_t fwstate = readl(ioc->ioc_regs.ioc_fwstate);
+
+	if ((fwstate == BFI_IOC_UNINIT) || bfa_ioc_is_uefi(ioc) ||
+				bfa_ioc_is_bios_optrom(ioc))
+		return BFA_TRUE;
+
+	bfa_ioc_fwver_get(ioc, &fwhdr);
+
+	if (swab32(fwhdr.exec) == BFI_BOOT_TYPE_NORMAL)
+		return BFA_TRUE;
+
+	bfa_trc(ioc, fwstate);
+	bfa_trc(ioc, fwhdr.exec);
+	writel(BFI_IOC_UNINIT, ioc->ioc_regs.ioc_fwstate);
+
 	return BFA_TRUE;
 }
 
@@ -71,7 +95,7 @@ bfa_ioc_cb_firmware_unlock(struct bfa_ioc_s *ioc)
  * Notify other functions on HB failure.
  */
 static void
-bfa_ioc_cb_notify_hbfail(struct bfa_ioc_s *ioc)
+bfa_ioc_cb_notify_fail(struct bfa_ioc_s *ioc)
 {
 	writel(__PSS_ERR_STATUS_SET, ioc->ioc_regs.err_set);
 	readl(ioc->ioc_regs.err_set);
@@ -109,9 +133,11 @@ bfa_ioc_cb_reg_init(struct bfa_ioc_s *ioc)
 	if (ioc->port_id == 0) {
 		ioc->ioc_regs.heartbeat = rb + BFA_IOC0_HBEAT_REG;
 		ioc->ioc_regs.ioc_fwstate = rb + BFA_IOC0_STATE_REG;
+		ioc->ioc_regs.alt_ioc_fwstate = rb + BFA_IOC1_STATE_REG;
 	} else {
 		ioc->ioc_regs.heartbeat = (rb + BFA_IOC1_HBEAT_REG);
 		ioc->ioc_regs.ioc_fwstate = (rb + BFA_IOC1_STATE_REG);
+		ioc->ioc_regs.alt_ioc_fwstate = (rb + BFA_IOC0_STATE_REG);
 	}
 
 	/*
@@ -185,7 +211,68 @@ bfa_ioc_cb_ownership_reset(struct bfa_ioc_s *ioc)
 	writel(1, ioc->ioc_regs.ioc_sem_reg);
 }
 
+/**
+ * Synchronized IOC failure processing routines
+ */
+static void
+bfa_ioc_cb_sync_join(struct bfa_ioc_s *ioc)
+{
+}
 
+static void
+bfa_ioc_cb_sync_leave(struct bfa_ioc_s *ioc)
+{
+}
+
+static void
+bfa_ioc_cb_sync_ack(struct bfa_ioc_s *ioc)
+{
+	writel(BFI_IOC_FAIL, ioc->ioc_regs.ioc_fwstate);
+}
+
+static bfa_boolean_t
+bfa_ioc_cb_sync_complete(struct bfa_ioc_s *ioc)
+{
+	uint32_t fwstate, alt_fwstate;
+	fwstate = readl(ioc->ioc_regs.ioc_fwstate);
+
+	/**
+	 * At this point, this IOC is hoding the hw sem in the
+	 * start path (fwcheck) OR in the disable/enable path
+	 * OR to check if the other IOC has acknowledged failure.
+	 *
+	 * So, this IOC can be in UNINIT, INITING, DISABLED, FAIL
+	 * or in MEMTEST states. In a normal scenario, this IOC
+	 * can not be in OP state when this function is called.
+	 *
+	 * However, this IOC could still be in OP state when
+	 * the OS driver is starting up, if the OptROM code has
+	 * left it in that state.
+	 *
+	 * If we had marked this IOC's fwstate as BFI_IOC_FAIL
+	 * in the failure case and now, if the fwstate is not
+	 * BFI_IOC_FAIL it implies that the other PCI fn have
+	 * reinitialized the ASIC or this IOC got disabled, so
+	 * return TRUE.
+	 */
+	if (fwstate == BFI_IOC_UNINIT ||
+		fwstate == BFI_IOC_INITING ||
+		fwstate == BFI_IOC_DISABLED ||
+		fwstate == BFI_IOC_MEMTEST ||
+		fwstate == BFI_IOC_OP)
+		return BFA_TRUE;
+	else {
+		alt_fwstate = readl(ioc->ioc_regs.alt_ioc_fwstate);
+		if (alt_fwstate == BFI_IOC_FAIL ||
+			alt_fwstate == BFI_IOC_DISABLED ||
+			alt_fwstate == BFI_IOC_UNINIT ||
+			alt_fwstate == BFI_IOC_INITING ||
+			alt_fwstate == BFI_IOC_MEMTEST)
+			return BFA_TRUE;
+		else
+			return BFA_FALSE;
+	}
+}
 
 bfa_status_t
 bfa_ioc_cb_pll_init(void __iomem *rb, bfa_boolean_t fcmode)
diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
index 25a5d3c..9da55a8 100644
--- a/drivers/scsi/bfa/bfa_ioc_ct.c
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -22,6 +22,15 @@
 
 BFA_TRC_FILE(CNA, IOC_CT);
 
+#define bfa_ioc_ct_sync_pos(__ioc)      \
+		((uint32_t) (1 << bfa_ioc_pcifn(__ioc)))
+#define BFA_IOC_SYNC_REQD_SH    16
+#define bfa_ioc_ct_get_sync_ackd(__val) (__val & 0x0000ffff)
+#define bfa_ioc_ct_clear_sync_ackd(__val)       (__val & 0xffff0000)
+#define bfa_ioc_ct_get_sync_reqd(__val) (__val >> BFA_IOC_SYNC_REQD_SH)
+#define bfa_ioc_ct_sync_reqd_pos(__ioc) \
+			(bfa_ioc_ct_sync_pos(__ioc) << BFA_IOC_SYNC_REQD_SH)
+
 /*
  * forward declarations
  */
@@ -30,8 +39,12 @@ static void bfa_ioc_ct_firmware_unlock(struct bfa_ioc_s *ioc);
 static void bfa_ioc_ct_reg_init(struct bfa_ioc_s *ioc);
 static void bfa_ioc_ct_map_port(struct bfa_ioc_s *ioc);
 static void bfa_ioc_ct_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix);
-static void bfa_ioc_ct_notify_hbfail(struct bfa_ioc_s *ioc);
+static void bfa_ioc_ct_notify_fail(struct bfa_ioc_s *ioc);
 static void bfa_ioc_ct_ownership_reset(struct bfa_ioc_s *ioc);
+static void bfa_ioc_ct_sync_join(struct bfa_ioc_s *ioc);
+static void bfa_ioc_ct_sync_leave(struct bfa_ioc_s *ioc);
+static void bfa_ioc_ct_sync_ack(struct bfa_ioc_s *ioc);
+static bfa_boolean_t bfa_ioc_ct_sync_complete(struct bfa_ioc_s *ioc);
 
 static struct bfa_ioc_hwif_s hwif_ct;
 
@@ -47,8 +60,12 @@ bfa_ioc_set_ct_hwif(struct bfa_ioc_s *ioc)
 	hwif_ct.ioc_reg_init = bfa_ioc_ct_reg_init;
 	hwif_ct.ioc_map_port = bfa_ioc_ct_map_port;
 	hwif_ct.ioc_isr_mode_set = bfa_ioc_ct_isr_mode_set;
-	hwif_ct.ioc_notify_hbfail = bfa_ioc_ct_notify_hbfail;
+	hwif_ct.ioc_notify_fail = bfa_ioc_ct_notify_fail;
 	hwif_ct.ioc_ownership_reset = bfa_ioc_ct_ownership_reset;
+	hwif_ct.ioc_sync_join = bfa_ioc_ct_sync_join;
+	hwif_ct.ioc_sync_leave = bfa_ioc_ct_sync_leave;
+	hwif_ct.ioc_sync_ack = bfa_ioc_ct_sync_ack;
+	hwif_ct.ioc_sync_complete = bfa_ioc_ct_sync_complete;
 
 	ioc->ioc_hwif = &hwif_ct;
 }
@@ -85,6 +102,7 @@ bfa_ioc_ct_firmware_lock(struct bfa_ioc_s *ioc)
 	if (usecnt == 0) {
 		writel(1, ioc->ioc_regs.ioc_usage_reg);
 		writel(1, ioc->ioc_regs.ioc_usage_sem_reg);
+		writel(0, ioc->ioc_regs.ioc_fail_sync);
 		bfa_trc(ioc, usecnt);
 		return BFA_TRUE;
 	}
@@ -153,12 +171,14 @@ bfa_ioc_ct_firmware_unlock(struct bfa_ioc_s *ioc)
  * Notify other functions on HB failure.
  */
 static void
-bfa_ioc_ct_notify_hbfail(struct bfa_ioc_s *ioc)
+bfa_ioc_ct_notify_fail(struct bfa_ioc_s *ioc)
 {
 	if (ioc->cna) {
 		writel(__FW_INIT_HALT_P, ioc->ioc_regs.ll_halt);
+		writel(__FW_INIT_HALT_P, ioc->ioc_regs.alt_ll_halt);
 		/* Wait for halt to take effect */
 		readl(ioc->ioc_regs.ll_halt);
+		readl(ioc->ioc_regs.alt_ll_halt);
 	} else {
 		writel(__PSS_ERR_STATUS_SET, ioc->ioc_regs.err_set);
 		readl(ioc->ioc_regs.err_set);
@@ -210,15 +230,19 @@ bfa_ioc_ct_reg_init(struct bfa_ioc_s *ioc)
 	if (ioc->port_id == 0) {
 		ioc->ioc_regs.heartbeat = rb + BFA_IOC0_HBEAT_REG;
 		ioc->ioc_regs.ioc_fwstate = rb + BFA_IOC0_STATE_REG;
+		ioc->ioc_regs.alt_ioc_fwstate = rb + BFA_IOC1_STATE_REG;
 		ioc->ioc_regs.hfn_mbox_cmd = rb + iocreg_mbcmd_p0[pcifn].hfn;
 		ioc->ioc_regs.lpu_mbox_cmd = rb + iocreg_mbcmd_p0[pcifn].lpu;
 		ioc->ioc_regs.ll_halt = rb + FW_INIT_HALT_P0;
+		ioc->ioc_regs.alt_ll_halt = rb + FW_INIT_HALT_P1;
 	} else {
 		ioc->ioc_regs.heartbeat = (rb + BFA_IOC1_HBEAT_REG);
 		ioc->ioc_regs.ioc_fwstate = (rb + BFA_IOC1_STATE_REG);
+		ioc->ioc_regs.alt_ioc_fwstate = rb + BFA_IOC0_STATE_REG;
 		ioc->ioc_regs.hfn_mbox_cmd = rb + iocreg_mbcmd_p1[pcifn].hfn;
 		ioc->ioc_regs.lpu_mbox_cmd = rb + iocreg_mbcmd_p1[pcifn].lpu;
 		ioc->ioc_regs.ll_halt = rb + FW_INIT_HALT_P1;
+		ioc->ioc_regs.alt_ll_halt = rb + FW_INIT_HALT_P0;
 	}
 
 	/*
@@ -236,6 +260,7 @@ bfa_ioc_ct_reg_init(struct bfa_ioc_s *ioc)
 	ioc->ioc_regs.ioc_usage_sem_reg = (rb + HOST_SEM1_REG);
 	ioc->ioc_regs.ioc_init_sem_reg = (rb + HOST_SEM2_REG);
 	ioc->ioc_regs.ioc_usage_reg = (rb + BFA_FW_USE_COUNT);
+	ioc->ioc_regs.ioc_fail_sync = (rb + BFA_IOC_FAIL_SYNC);
 
 	/*
 	 * sram memory access
@@ -326,7 +351,77 @@ bfa_ioc_ct_ownership_reset(struct bfa_ioc_s *ioc)
 	writel(1, ioc->ioc_regs.ioc_sem_reg);
 }
 
+/**
+ * Synchronized IOC failure processing routines
+ */
+static void
+bfa_ioc_ct_sync_join(struct bfa_ioc_s *ioc)
+{
+	uint32_t r32 = readl(ioc->ioc_regs.ioc_fail_sync);
+	uint32_t sync_pos = bfa_ioc_ct_sync_reqd_pos(ioc);
+
+	writel((r32 | sync_pos), ioc->ioc_regs.ioc_fail_sync);
+}
 
+static void
+bfa_ioc_ct_sync_leave(struct bfa_ioc_s *ioc)
+{
+	uint32_t r32 = readl(ioc->ioc_regs.ioc_fail_sync);
+	uint32_t sync_msk = bfa_ioc_ct_sync_reqd_pos(ioc) |
+					bfa_ioc_ct_sync_pos(ioc);
+
+	writel((r32 & ~sync_msk), ioc->ioc_regs.ioc_fail_sync);
+}
+
+static void
+bfa_ioc_ct_sync_ack(struct bfa_ioc_s *ioc)
+{
+	uint32_t r32 = readl(ioc->ioc_regs.ioc_fail_sync);
+
+	writel((r32 | bfa_ioc_ct_sync_pos(ioc)),
+		ioc->ioc_regs.ioc_fail_sync);
+}
+
+static bfa_boolean_t
+bfa_ioc_ct_sync_complete(struct bfa_ioc_s *ioc)
+{
+	uint32_t r32 = readl(ioc->ioc_regs.ioc_fail_sync);
+	uint32_t sync_reqd = bfa_ioc_ct_get_sync_reqd(r32);
+	uint32_t sync_ackd = bfa_ioc_ct_get_sync_ackd(r32);
+	uint32_t tmp_ackd;
+
+	if (sync_ackd == 0)
+		return BFA_TRUE;
+
+	/**
+	 * The check below is to see whether any other PCI fn
+	 * has reinitialized the ASIC (reset sync_ackd bits)
+	 * and failed again while this IOC was waiting for hw
+	 * semaphore (in bfa_iocpf_sm_semwait()).
+	 */
+	tmp_ackd = sync_ackd;
+	if ((sync_reqd &  bfa_ioc_ct_sync_pos(ioc)) &&
+		!(sync_ackd & bfa_ioc_ct_sync_pos(ioc)))
+		sync_ackd |= bfa_ioc_ct_sync_pos(ioc);
+
+	if (sync_reqd == sync_ackd) {
+		writel(bfa_ioc_ct_clear_sync_ackd(r32),
+			ioc->ioc_regs.ioc_fail_sync);
+		writel(BFI_IOC_FAIL, ioc->ioc_regs.ioc_fwstate);
+		writel(BFI_IOC_FAIL, ioc->ioc_regs.alt_ioc_fwstate);
+		return BFA_TRUE;
+	}
+
+	/**
+	 * If another PCI fn reinitialized and failed again while
+	 * this IOC was waiting for hw sem, the sync_ackd bit for
+	 * this IOC need to be set again to allow reinitialization.
+	 */
+	if (tmp_ackd != sync_ackd)
+		writel((r32 | sync_ackd), ioc->ioc_regs.ioc_fail_sync);
+
+	return BFA_FALSE;
+}
 
 /*
  * Check the firmware state to know if pll_init has been completed already
diff --git a/drivers/scsi/bfa/bfi_cbreg.h b/drivers/scsi/bfa/bfi_cbreg.h
index 6f03ed3..39ad42b 100644
--- a/drivers/scsi/bfa/bfi_cbreg.h
+++ b/drivers/scsi/bfa/bfi_cbreg.h
@@ -208,6 +208,7 @@
 #define BFA_IOC1_HBEAT_REG               HOST_SEM2_INFO_REG
 #define BFA_IOC1_STATE_REG               HOST_SEM3_INFO_REG
 #define BFA_FW_USE_COUNT                 HOST_SEM4_INFO_REG
+#define BFA_IOC_FAIL_SYNC		 HOST_SEM5_INFO_REG
 
 #define CPE_Q_DEPTH(__n) \
 	(CPE_Q0_DEPTH + (__n) * (CPE_Q1_DEPTH - CPE_Q0_DEPTH))
diff --git a/drivers/scsi/bfa/bfi_ctreg.h b/drivers/scsi/bfa/bfi_ctreg.h
index 62b86a4..fc4ce4a 100644
--- a/drivers/scsi/bfa/bfi_ctreg.h
+++ b/drivers/scsi/bfa/bfi_ctreg.h
@@ -522,6 +522,7 @@ enum {
 #define BFA_IOC1_HBEAT_REG		HOST_SEM2_INFO_REG
 #define BFA_IOC1_STATE_REG		HOST_SEM3_INFO_REG
 #define BFA_FW_USE_COUNT		 HOST_SEM4_INFO_REG
+#define BFA_IOC_FAIL_SYNC		HOST_SEM5_INFO_REG
 
 #define CPE_DEPTH_Q(__n) \
 	(CPE_DEPTH_Q0 + (__n) * (CPE_DEPTH_Q1 - CPE_DEPTH_Q0))
@@ -539,22 +540,30 @@ enum {
 	(RME_PI_PTR_Q0 + (__n) * (RME_PI_PTR_Q1 - RME_PI_PTR_Q0))
 #define RME_CI_PTR_Q(__n) \
 	(RME_CI_PTR_Q0 + (__n) * (RME_CI_PTR_Q1 - RME_CI_PTR_Q0))
-#define HQM_QSET_RXQ_DRBL_P0(__n) (HQM_QSET0_RXQ_DRBL_P0 + (__n) \
-	* (HQM_QSET1_RXQ_DRBL_P0 - HQM_QSET0_RXQ_DRBL_P0))
-#define HQM_QSET_TXQ_DRBL_P0(__n) (HQM_QSET0_TXQ_DRBL_P0 + (__n) \
-	* (HQM_QSET1_TXQ_DRBL_P0 - HQM_QSET0_TXQ_DRBL_P0))
-#define HQM_QSET_IB_DRBL_1_P0(__n) (HQM_QSET0_IB_DRBL_1_P0 + (__n) \
-	* (HQM_QSET1_IB_DRBL_1_P0 - HQM_QSET0_IB_DRBL_1_P0))
-#define HQM_QSET_IB_DRBL_2_P0(__n) (HQM_QSET0_IB_DRBL_2_P0 + (__n) \
-	* (HQM_QSET1_IB_DRBL_2_P0 - HQM_QSET0_IB_DRBL_2_P0))
-#define HQM_QSET_RXQ_DRBL_P1(__n) (HQM_QSET0_RXQ_DRBL_P1 + (__n) \
-	* (HQM_QSET1_RXQ_DRBL_P1 - HQM_QSET0_RXQ_DRBL_P1))
-#define HQM_QSET_TXQ_DRBL_P1(__n) (HQM_QSET0_TXQ_DRBL_P1 + (__n) \
-	* (HQM_QSET1_TXQ_DRBL_P1 - HQM_QSET0_TXQ_DRBL_P1))
-#define HQM_QSET_IB_DRBL_1_P1(__n) (HQM_QSET0_IB_DRBL_1_P1 + (__n) \
-	* (HQM_QSET1_IB_DRBL_1_P1 - HQM_QSET0_IB_DRBL_1_P1))
-#define HQM_QSET_IB_DRBL_2_P1(__n) (HQM_QSET0_IB_DRBL_2_P1 + (__n) \
-	* (HQM_QSET1_IB_DRBL_2_P1 - HQM_QSET0_IB_DRBL_2_P1))
+#define HQM_QSET_RXQ_DRBL_P0(__n) \
+	(HQM_QSET0_RXQ_DRBL_P0 + (__n) *	\
+	(HQM_QSET1_RXQ_DRBL_P0 - HQM_QSET0_RXQ_DRBL_P0))
+#define HQM_QSET_TXQ_DRBL_P0(__n) \
+	(HQM_QSET0_TXQ_DRBL_P0 + (__n) *	\
+	(HQM_QSET1_TXQ_DRBL_P0 - HQM_QSET0_TXQ_DRBL_P0))
+#define HQM_QSET_IB_DRBL_1_P0(__n) \
+	(HQM_QSET0_IB_DRBL_1_P0 + (__n) *	\
+	(HQM_QSET1_IB_DRBL_1_P0 - HQM_QSET0_IB_DRBL_1_P0))
+#define HQM_QSET_IB_DRBL_2_P0(__n) \
+	(HQM_QSET0_IB_DRBL_2_P0 + (__n) *	\
+	(HQM_QSET1_IB_DRBL_2_P0 - HQM_QSET0_IB_DRBL_2_P0))
+#define HQM_QSET_RXQ_DRBL_P1(__n) \
+	(HQM_QSET0_RXQ_DRBL_P1 + (__n) *	\
+	(HQM_QSET1_RXQ_DRBL_P1 - HQM_QSET0_RXQ_DRBL_P1))
+#define HQM_QSET_TXQ_DRBL_P1(__n) \
+	(HQM_QSET0_TXQ_DRBL_P1 + (__n) *	\
+	(HQM_QSET1_TXQ_DRBL_P1 - HQM_QSET0_TXQ_DRBL_P1))
+#define HQM_QSET_IB_DRBL_1_P1(__n) \
+	(HQM_QSET0_IB_DRBL_1_P1 + (__n) *	\
+	(HQM_QSET1_IB_DRBL_1_P1 - HQM_QSET0_IB_DRBL_1_P1))
+#define HQM_QSET_IB_DRBL_2_P1(__n) \
+	(HQM_QSET0_IB_DRBL_2_P1 + (__n) *	\
+	(HQM_QSET1_IB_DRBL_2_P1 - HQM_QSET0_IB_DRBL_2_P1))
 
 #define CPE_Q_NUM(__fn, __q) (((__fn) << 2) + (__q))
 #define RME_Q_NUM(__fn, __q) (((__fn) << 2) + (__q))
-- 
1.7.3.rc1

