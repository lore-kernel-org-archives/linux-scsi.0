From: <kgudipat@brocade.com>
Subject: [PATCH 1/6] bfa: IOC fwtrace save logic & state machine fixes.
Date: Mon, 13 Dec 2010 16:16:09 -0800
Message-ID: <1292285769-6611-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:35621 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757398Ab0LNAQw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Dec 2010 19:16:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, adapter_linux_open_src_team@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Move fw trace save logic to bfa_ioc_sm_fail_entry(),
	  so that fw trace is saved irrespective of the cause of the failure.
	- Make bfa_ioc_sm_fail() a failure parking state.
	- Rename bfa_ioc_sm_initfail() to a more appropriate bfa_ioc_sm_fail_retry()
	  as it is no longer a parking state.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_ioc.c |  143 +++++++++++++++++++++++---------------------
 1 files changed, 75 insertions(+), 68 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 58b3391..47eea41 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -88,6 +88,8 @@ static void bfa_ioc_recover(struct bfa_ioc_s *ioc);
 static void bfa_ioc_check_attr_wwns(struct bfa_ioc_s *ioc);
 static void bfa_ioc_disable_comp(struct bfa_ioc_s *ioc);
 static void bfa_ioc_lpu_stop(struct bfa_ioc_s *ioc);
+static void bfa_ioc_debug_save_ftrc(struct bfa_ioc_s *ioc);
+static void bfa_ioc_fail_notify(struct bfa_ioc_s *ioc);
 static void bfa_ioc_pf_fwmismatch(struct bfa_ioc_s *ioc);
 
 
@@ -102,7 +104,7 @@ enum ioc_event {
 	IOC_E_ENABLED		= 5,	/*  f/w enabled		*/
 	IOC_E_FWRSP_GETATTR	= 6,	/*  IOC get attribute response	*/
 	IOC_E_DISABLED		= 7,	/*  f/w disabled		*/
-	IOC_E_FAILED		= 8,	/*  failure notice by iocpf sm	*/
+	IOC_E_PFFAILED		= 8,	/*  failure notice by iocpf sm	*/
 	IOC_E_HBFAIL		= 9,	/*  heartbeat failure		*/
 	IOC_E_HWERROR		= 10,	/*  hardware error interrupt	*/
 	IOC_E_TIMEOUT		= 11,	/*  timeout			*/
@@ -113,7 +115,7 @@ bfa_fsm_state_decl(bfa_ioc, reset, struct bfa_ioc_s, enum ioc_event);
 bfa_fsm_state_decl(bfa_ioc, enabling, struct bfa_ioc_s, enum ioc_event);
 bfa_fsm_state_decl(bfa_ioc, getattr, struct bfa_ioc_s, enum ioc_event);
 bfa_fsm_state_decl(bfa_ioc, op, struct bfa_ioc_s, enum ioc_event);
-bfa_fsm_state_decl(bfa_ioc, initfail, struct bfa_ioc_s, enum ioc_event);
+bfa_fsm_state_decl(bfa_ioc, fail_retry, struct bfa_ioc_s, enum ioc_event);
 bfa_fsm_state_decl(bfa_ioc, fail, struct bfa_ioc_s, enum ioc_event);
 bfa_fsm_state_decl(bfa_ioc, disabling, struct bfa_ioc_s, enum ioc_event);
 bfa_fsm_state_decl(bfa_ioc, disabled, struct bfa_ioc_s, enum ioc_event);
@@ -124,7 +126,7 @@ static struct bfa_sm_table_s ioc_sm_table[] = {
 	{BFA_SM(bfa_ioc_sm_enabling), BFA_IOC_ENABLING},
 	{BFA_SM(bfa_ioc_sm_getattr), BFA_IOC_GETATTR},
 	{BFA_SM(bfa_ioc_sm_op), BFA_IOC_OPERATIONAL},
-	{BFA_SM(bfa_ioc_sm_initfail), BFA_IOC_INITFAIL},
+	{BFA_SM(bfa_ioc_sm_fail_retry), BFA_IOC_INITFAIL},
 	{BFA_SM(bfa_ioc_sm_fail), BFA_IOC_FAIL},
 	{BFA_SM(bfa_ioc_sm_disabling), BFA_IOC_DISABLING},
 	{BFA_SM(bfa_ioc_sm_disabled), BFA_IOC_DISABLED},
@@ -298,13 +300,13 @@ bfa_ioc_sm_enabling(struct bfa_ioc_s *ioc, enum ioc_event event)
 		bfa_fsm_set_state(ioc, bfa_ioc_sm_getattr);
 		break;
 
-	case IOC_E_FAILED:
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_initfail);
-		break;
-
+	case IOC_E_PFFAILED:
+		/* !!! fall through !!! */
 	case IOC_E_HWERROR:
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_initfail);
-		bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_INITFAIL);
+		ioc->cbfn->enable_cbfn(ioc->bfa, BFA_STATUS_IOC_FAILURE);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_fail_retry);
+		if (event != IOC_E_PFFAILED)
+			bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_INITFAIL);
 		break;
 
 	case IOC_E_DISABLE:
@@ -347,18 +349,16 @@ bfa_ioc_sm_getattr(struct bfa_ioc_s *ioc, enum ioc_event event)
 		bfa_fsm_set_state(ioc, bfa_ioc_sm_op);
 		break;
 
-	case IOC_E_FAILED:
-		bfa_ioc_timer_stop(ioc);
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_initfail);
 		break;
-
+	case IOC_E_PFFAILED:
 	case IOC_E_HWERROR:
 		bfa_ioc_timer_stop(ioc);
-		/* fall through */
-
+		/* !!! fall through !!! */
 	case IOC_E_TIMEOUT:
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_initfail);
-		bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_GETATTRFAIL);
+		ioc->cbfn->enable_cbfn(ioc->bfa, BFA_STATUS_IOC_FAILURE);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_fail_retry);
+		if (event != IOC_E_PFFAILED)
+			bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_GETATTRFAIL);
 		break;
 
 	case IOC_E_DISABLE:
@@ -399,18 +399,20 @@ bfa_ioc_sm_op(struct bfa_ioc_s *ioc, enum ioc_event event)
 		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabling);
 		break;
 
-	case IOC_E_FAILED:
-		bfa_hb_timer_stop(ioc);
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_fail);
-		break;
-
+	case IOC_E_PFFAILED:
 	case IOC_E_HWERROR:
 		bfa_hb_timer_stop(ioc);
 		/* !!! fall through !!! */
-
 	case IOC_E_HBFAIL:
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_fail);
-		bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_FAIL);
+		bfa_ioc_fail_notify(ioc);
+
+		if (ioc->iocpf.auto_recover)
+			bfa_fsm_set_state(ioc, bfa_ioc_sm_fail_retry);
+		else
+			bfa_fsm_set_state(ioc, bfa_ioc_sm_fail);
+
+		if (event != IOC_E_PFFAILED)
+			bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_FAIL);
 		break;
 
 	default:
@@ -489,16 +491,16 @@ bfa_ioc_sm_disabled(struct bfa_ioc_s *ioc, enum ioc_event event)
 
 
 static void
-bfa_ioc_sm_initfail_entry(struct bfa_ioc_s *ioc)
+bfa_ioc_sm_fail_retry_entry(struct bfa_ioc_s *ioc)
 {
-	ioc->cbfn->enable_cbfn(ioc->bfa, BFA_STATUS_IOC_FAILURE);
+	bfa_trc(ioc, 0);
 }
 
 /*
  * Hardware initialization failed.
  */
 static void
-bfa_ioc_sm_initfail(struct bfa_ioc_s *ioc, enum ioc_event event)
+bfa_ioc_sm_fail_retry(struct bfa_ioc_s *ioc, enum ioc_event event)
 {
 	bfa_trc(ioc, event);
 
@@ -507,11 +509,17 @@ bfa_ioc_sm_initfail(struct bfa_ioc_s *ioc, enum ioc_event event)
 		bfa_fsm_set_state(ioc, bfa_ioc_sm_getattr);
 		break;
 
-	case IOC_E_FAILED:
+	case IOC_E_PFFAILED:
+	case IOC_E_HWERROR:
 		/*
-		 * Initialization failure during iocpf init retry.
+		 * Initialization retry failed.
 		 */
 		ioc->cbfn->enable_cbfn(ioc->bfa, BFA_STATUS_IOC_FAILURE);
+		if (event != IOC_E_PFFAILED)
+			bfa_fsm_send_event(&ioc->iocpf, IOCPF_E_INITFAIL);
+		break;
+
+	case IOC_E_ENABLE:
 		break;
 
 	case IOC_E_DISABLE:
@@ -532,21 +540,7 @@ bfa_ioc_sm_initfail(struct bfa_ioc_s *ioc, enum ioc_event event)
 static void
 bfa_ioc_sm_fail_entry(struct bfa_ioc_s *ioc)
 {
-	struct list_head			*qe;
-	struct bfa_ioc_hbfail_notify_s	*notify;
-	struct bfad_s *bfad = (struct bfad_s *)ioc->bfa->bfad;
-
-	/*
-	 * Notify driver and common modules registered for notification.
-	 */
-	ioc->cbfn->hbfail_cbfn(ioc->bfa);
-	list_for_each(qe, &ioc->hb_notify_q) {
-		notify = (struct bfa_ioc_hbfail_notify_s *) qe;
-		notify->cbfn(notify->cbarg);
-	}
-
-	BFA_LOG(KERN_CRIT, bfad, log_level,
-		"Heart Beat of IOC has failed\n");
+	bfa_trc(ioc, 0);
 }
 
 /*
@@ -559,19 +553,10 @@ bfa_ioc_sm_fail(struct bfa_ioc_s *ioc, enum ioc_event event)
 
 	switch (event) {
 
-	case IOC_E_FAILED:
-		/*
-		 * Initialization failure during iocpf recovery.
-		 * !!! Fall through !!!
-		 */
 	case IOC_E_ENABLE:
 		ioc->cbfn->enable_cbfn(ioc->bfa, BFA_STATUS_IOC_FAILURE);
 		break;
 
-	case IOC_E_ENABLED:
-		bfa_fsm_set_state(ioc, bfa_ioc_sm_getattr);
-		break;
-
 	case IOC_E_DISABLE:
 		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabling);
 		break;
@@ -793,7 +778,7 @@ bfa_iocpf_sm_hwinit(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_initfail);
 
 		if (event == IOCPF_E_TIMEOUT)
-			bfa_fsm_send_event(ioc, IOC_E_FAILED);
+			bfa_fsm_send_event(ioc, IOC_E_PFFAILED);
 		break;
 
 	case IOCPF_E_DISABLE:
@@ -850,7 +835,7 @@ bfa_iocpf_sm_enabling(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 		bfa_fsm_set_state(iocpf, bfa_iocpf_sm_initfail);
 
 		if (event == IOCPF_E_TIMEOUT)
-			bfa_fsm_send_event(ioc, IOC_E_FAILED);
+			bfa_fsm_send_event(ioc, IOC_E_PFFAILED);
 		break;
 
 	case IOCPF_E_DISABLE:
@@ -900,7 +885,7 @@ bfa_iocpf_sm_ready(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 		else
 			bfa_fsm_set_state(iocpf, bfa_iocpf_sm_initfail);
 
-		bfa_fsm_send_event(ioc, IOC_E_FAILED);
+		bfa_fsm_send_event(ioc, IOC_E_PFFAILED);
 		break;
 
 	default:
@@ -957,7 +942,7 @@ bfa_iocpf_sm_disabling(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 static void
 bfa_iocpf_sm_disabled_entry(struct bfa_iocpf_s *iocpf)
 {
-	bfa_fsm_send_event(iocpf->ioc, IOC_E_DISABLED);
+	bfa_fsm_send_event(iocpf->ioc, IOC_E_DISABLED);	
 }
 
 static void
@@ -1725,6 +1710,29 @@ bfa_ioc_smem_clr(struct bfa_ioc_s *ioc, u32 soff, u32 sz)
 }
 
 static void
+bfa_ioc_fail_notify(struct bfa_ioc_s *ioc)
+{
+	struct list_head		*qe;
+	struct bfa_ioc_hbfail_notify_s	*notify;
+	struct bfad_s *bfad = (struct bfad_s *)ioc->bfa->bfad;
+
+	/**
+	 * Notify driver and common modules registered for notification.
+	 */
+	ioc->cbfn->hbfail_cbfn(ioc->bfa);
+	list_for_each(qe, &ioc->hb_notify_q) {
+		notify = (struct bfa_ioc_hbfail_notify_s *) qe;
+		notify->cbfn(notify->cbarg);
+	}
+
+	bfa_ioc_debug_save_ftrc(ioc);
+
+	BFA_LOG(KERN_CRIT, bfad, log_level,
+                "Heart Beat of IOC has failed\n");
+
+}
+
+static void
 bfa_ioc_pf_fwmismatch(struct bfa_ioc_s *ioc)
 {
 	struct bfad_s *bfad = (struct bfad_s *)ioc->bfa->bfad;
@@ -2187,7 +2195,8 @@ bfa_ioc_get_adapter_attr(struct bfa_ioc_s *ioc,
 	bfa_ioc_get_pci_chip_rev(ioc, ad_attr->hw_ver);
 
 	ad_attr->cna_capable = ioc->cna;
-	ad_attr->trunk_capable = (ad_attr->nports > 1) && !ioc->cna;
+	ad_attr->trunk_capable = (ad_attr->nports > 1) && !ioc->cna &&
+				!ad_attr->is_mezz;
 }
 
 enum bfa_ioc_type_e
@@ -2530,13 +2539,16 @@ bfa_ioc_fw_stats_clear(struct bfa_ioc_s *ioc)
  * Save firmware trace if configured.
  */
 static void
-bfa_ioc_debug_save(struct bfa_ioc_s *ioc)
+bfa_ioc_debug_save_ftrc(struct bfa_ioc_s *ioc)
 {
 	int		tlen;
 
-	if (ioc->dbg_fwsave_len) {
-		tlen = ioc->dbg_fwsave_len;
-		bfa_ioc_debug_fwtrc(ioc, ioc->dbg_fwsave, &tlen);
+	if (ioc->dbg_fwsave_once) {
+		ioc->dbg_fwsave_once = BFA_FALSE;
+		if (ioc->dbg_fwsave_len) {
+			tlen = ioc->dbg_fwsave_len;
+			bfa_ioc_debug_fwtrc(ioc, ioc->dbg_fwsave, &tlen);
+		}
 	}
 }
 
@@ -2546,11 +2558,6 @@ bfa_ioc_debug_save(struct bfa_ioc_s *ioc)
 static void
 bfa_ioc_recover(struct bfa_ioc_s *ioc)
 {
-	if (ioc->dbg_fwsave_once) {
-		ioc->dbg_fwsave_once = BFA_FALSE;
-		bfa_ioc_debug_save(ioc);
-	}
-
 	bfa_ioc_stats(ioc, ioc_hbfails);
 	bfa_fsm_send_event(ioc, IOC_E_HBFAIL);
 }
-- 
1.7.3.rc1

