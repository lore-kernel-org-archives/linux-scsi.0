From: Maggie Zhang <xmzhang@brocade.com>
Subject: [PATCH 7/7] bfa: remove unused functions and misc cleanups
Date: Thu, 9 Dec 2010 19:13:20 -0800
Message-ID: <1291950800-17288-1-git-send-email-xmzhang@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:44771 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753810Ab0LJDN2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Dec 2010 22:13:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@blc-10-10.brocade.com, Maggie Zhang <xmzhang@brocade.com>, Jing Huang <huangj@brocade.com>

Remove unused functions and fix checkpatch errors. Misc cleanups in comment and formatting.

Signed-off-by: Maggie Zhang <xmzhang@brocade.com>
Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_core.c      |    2 +-
 drivers/scsi/bfa/bfa_fc.h        |    2 +-
 drivers/scsi/bfa/bfa_fcbuild.c   |    7 +-
 drivers/scsi/bfa/bfa_fcpim.c     |  362 ++++++--------------------------------
 drivers/scsi/bfa/bfa_fcpim.h     |  158 ++++++-----------
 drivers/scsi/bfa/bfa_fcs_lport.c |    3 +-
 drivers/scsi/bfa/bfa_fcs_rport.c |    3 +-
 drivers/scsi/bfa/bfa_ioc.c       |   18 +--
 drivers/scsi/bfa/bfa_svc.c       |   42 +----
 drivers/scsi/bfa/bfad_debugfs.c  |    8 +-
 10 files changed, 129 insertions(+), 476 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 02a5e04..3f7f374 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -342,7 +342,7 @@ bfa_msix_lpu_err(struct bfa_s *bfa, int vec)
 	intr = readl(bfa->iocfc.bfa_regs.intr_status);
 
 	if (intr & (__HFN_INT_MBOX_LPU0 | __HFN_INT_MBOX_LPU1))
-		 bfa_ioc_mbox_isr(&bfa->ioc);
+		bfa_ioc_mbox_isr(&bfa->ioc);
 
 	intr &= (__HFN_INT_ERR_EMC | __HFN_INT_ERR_LPU0 |
 		__HFN_INT_ERR_LPU1 | __HFN_INT_ERR_PSS | __HFN_INT_LL_HALT);
diff --git a/drivers/scsi/bfa/bfa_fc.h b/drivers/scsi/bfa/bfa_fc.h
index 580ab03..afe55ef 100644
--- a/drivers/scsi/bfa/bfa_fc.h
+++ b/drivers/scsi/bfa/bfa_fc.h
@@ -1089,7 +1089,7 @@ struct fc_rpsc2_port_info_s {
 struct fc_rpsc2_acc_s {
 	u8        els_cmd;
 	u8        resvd;
-    	__be16    num_pids;  /* Number of pids in the request */
+	__be16    num_pids;  /* Number of pids in the request */
     struct fc_rpsc2_port_info_s port_info[1];    /* port information */
 };
 
diff --git a/drivers/scsi/bfa/bfa_fcbuild.c b/drivers/scsi/bfa/bfa_fcbuild.c
index 1ca5af7..b7e2534 100644
--- a/drivers/scsi/bfa/bfa_fcbuild.c
+++ b/drivers/scsi/bfa/bfa_fcbuild.c
@@ -456,7 +456,7 @@ fc_logo_build(struct fchs_s *fchs, struct fc_logo_s *logo, u32 d_id, u32 s_id,
 	return sizeof(struct fc_logo_s);
 }
 
-static          u16
+static u16
 fc_adisc_x_build(struct fchs_s *fchs, struct fc_adisc_s *adisc, u32 d_id,
 		 u32 s_id, __be16 ox_id, wwn_t port_name,
 		 wwn_t node_name, u8 els_code)
@@ -807,11 +807,6 @@ fc_rpsc_acc_build(struct fchs_s *fchs, struct fc_rpsc_acc_s *rpsc_acc,
 	return sizeof(struct fc_rpsc_acc_s);
 }
 
-/*
- * TBD -
- * . get rid of unnecessary memsets
- */
-
 u16
 fc_logo_rsp_parse(struct fchs_s *fchs, int len)
 {
diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 5977adb..314c931 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -21,11 +21,6 @@
 BFA_TRC_FILE(HAL, FCPIM);
 BFA_MODULE(fcpim);
 
-
-#define bfa_fcpim_add_iostats(__l, __r, __stats)	\
-	(__l->__stats += __r->__stats)
-
-
 /*
  *  BFA ITNIM Related definitions
  */
@@ -73,10 +68,8 @@ static void bfa_itnim_update_del_itn_stats(struct bfa_itnim_s *itnim);
 } while (0)
 
 /*
- *  bfa_itnim_sm BFA itnim state machine
+ *  itnim state machine event
  */
-
-
 enum bfa_itnim_event {
 	BFA_ITNIM_SM_CREATE = 1,	/*  itnim is created */
 	BFA_ITNIM_SM_ONLINE = 2,	/*  itnim is online */
@@ -228,7 +221,6 @@ static void __bfa_cb_ioim_failed(void *cbarg, bfa_boolean_t complete);
 static void __bfa_cb_ioim_pathtov(void *cbarg, bfa_boolean_t complete);
 static bfa_boolean_t    bfa_ioim_is_abortable(struct bfa_ioim_s *ioim);
 
-
 /*
  * forward declaration of BFA IO state machine
  */
@@ -256,7 +248,6 @@ static void     bfa_ioim_sm_resfree(struct bfa_ioim_s *ioim,
 					enum bfa_ioim_event event);
 static void	bfa_ioim_sm_cmnd_retry(struct bfa_ioim_s *ioim,
 					enum bfa_ioim_event event);
-
 /*
  * forward declaration for BFA TSKIM functions
  */
@@ -271,7 +262,6 @@ static bfa_boolean_t bfa_tskim_send(struct bfa_tskim_s *tskim);
 static bfa_boolean_t bfa_tskim_send_abort(struct bfa_tskim_s *tskim);
 static void     bfa_tskim_iocdisable_ios(struct bfa_tskim_s *tskim);
 
-
 /*
  * forward declaration of BFA TSKIM state machine
  */
@@ -289,13 +279,12 @@ static void     bfa_tskim_sm_cleanup_qfull(struct bfa_tskim_s *tskim,
 					enum bfa_tskim_event event);
 static void     bfa_tskim_sm_hcb(struct bfa_tskim_s *tskim,
 					enum bfa_tskim_event event);
-
 /*
  *  BFA FCP Initiator Mode module
  */
 
 /*
- *	Compute and return memory needed by FCP(im) module.
+ * Compute and return memory needed by FCP(im) module.
  */
 static void
 bfa_fcpim_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
@@ -379,56 +368,6 @@ bfa_fcpim_iocdisable(struct bfa_s *bfa)
 }
 
 void
-bfa_fcpim_add_stats(struct bfa_itnim_iostats_s *lstats,
-		struct bfa_itnim_iostats_s *rstats)
-{
-	bfa_fcpim_add_iostats(lstats, rstats, total_ios);
-	bfa_fcpim_add_iostats(lstats, rstats, qresumes);
-	bfa_fcpim_add_iostats(lstats, rstats, no_iotags);
-	bfa_fcpim_add_iostats(lstats, rstats, io_aborts);
-	bfa_fcpim_add_iostats(lstats, rstats, no_tskims);
-	bfa_fcpim_add_iostats(lstats, rstats, iocomp_ok);
-	bfa_fcpim_add_iostats(lstats, rstats, iocomp_underrun);
-	bfa_fcpim_add_iostats(lstats, rstats, iocomp_overrun);
-	bfa_fcpim_add_iostats(lstats, rstats, iocomp_aborted);
-	bfa_fcpim_add_iostats(lstats, rstats, iocomp_timedout);
-	bfa_fcpim_add_iostats(lstats, rstats, iocom_nexus_abort);
-	bfa_fcpim_add_iostats(lstats, rstats, iocom_proto_err);
-	bfa_fcpim_add_iostats(lstats, rstats, iocom_dif_err);
-	bfa_fcpim_add_iostats(lstats, rstats, iocom_sqer_needed);
-	bfa_fcpim_add_iostats(lstats, rstats, iocom_res_free);
-	bfa_fcpim_add_iostats(lstats, rstats, iocom_hostabrts);
-	bfa_fcpim_add_iostats(lstats, rstats, iocom_utags);
-	bfa_fcpim_add_iostats(lstats, rstats, io_cleanups);
-	bfa_fcpim_add_iostats(lstats, rstats, io_tmaborts);
-	bfa_fcpim_add_iostats(lstats, rstats, onlines);
-	bfa_fcpim_add_iostats(lstats, rstats, offlines);
-	bfa_fcpim_add_iostats(lstats, rstats, creates);
-	bfa_fcpim_add_iostats(lstats, rstats, deletes);
-	bfa_fcpim_add_iostats(lstats, rstats, create_comps);
-	bfa_fcpim_add_iostats(lstats, rstats, delete_comps);
-	bfa_fcpim_add_iostats(lstats, rstats, sler_events);
-	bfa_fcpim_add_iostats(lstats, rstats, fw_create);
-	bfa_fcpim_add_iostats(lstats, rstats, fw_delete);
-	bfa_fcpim_add_iostats(lstats, rstats, ioc_disabled);
-	bfa_fcpim_add_iostats(lstats, rstats, cleanup_comps);
-	bfa_fcpim_add_iostats(lstats, rstats, tm_cmnds);
-	bfa_fcpim_add_iostats(lstats, rstats, tm_fw_rsps);
-	bfa_fcpim_add_iostats(lstats, rstats, tm_success);
-	bfa_fcpim_add_iostats(lstats, rstats, tm_failures);
-	bfa_fcpim_add_iostats(lstats, rstats, tm_io_comps);
-	bfa_fcpim_add_iostats(lstats, rstats, tm_qresumes);
-	bfa_fcpim_add_iostats(lstats, rstats, tm_iocdowns);
-	bfa_fcpim_add_iostats(lstats, rstats, tm_cleanups);
-	bfa_fcpim_add_iostats(lstats, rstats, tm_cleanup_comps);
-	bfa_fcpim_add_iostats(lstats, rstats, io_comps);
-	bfa_fcpim_add_iostats(lstats, rstats, input_reqs);
-	bfa_fcpim_add_iostats(lstats, rstats, output_reqs);
-	bfa_fcpim_add_iostats(lstats, rstats, rd_throughput);
-	bfa_fcpim_add_iostats(lstats, rstats, wr_throughput);
-}
-
-void
 bfa_fcpim_path_tov_set(struct bfa_s *bfa, u16 path_tov)
 {
 	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
@@ -446,128 +385,6 @@ bfa_fcpim_path_tov_get(struct bfa_s *bfa)
 	return fcpim->path_tov / 1000;
 }
 
-bfa_status_t
-bfa_fcpim_port_iostats(struct bfa_s *bfa, struct bfa_itnim_iostats_s *stats,
-	u8 lp_tag)
-{
-	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
-	struct list_head *qe, *qen;
-	struct bfa_itnim_s *itnim;
-
-	/* accumulate IO stats from itnim */
-	memset(stats, 0, sizeof(struct bfa_itnim_iostats_s));
-	list_for_each_safe(qe, qen, &fcpim->itnim_q) {
-		itnim = (struct bfa_itnim_s *) qe;
-		if (itnim->rport->rport_info.lp_tag != lp_tag)
-			continue;
-		bfa_fcpim_add_stats(stats, &(itnim->stats));
-	}
-	return BFA_STATUS_OK;
-}
-bfa_status_t
-bfa_fcpim_get_modstats(struct bfa_s *bfa, struct bfa_itnim_iostats_s *modstats)
-{
-	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
-	struct list_head *qe, *qen;
-	struct bfa_itnim_s *itnim;
-
-	/* accumulate IO stats from itnim */
-	memset(modstats, 0, sizeof(struct bfa_itnim_iostats_s));
-	list_for_each_safe(qe, qen, &fcpim->itnim_q) {
-		itnim = (struct bfa_itnim_s *) qe;
-		bfa_fcpim_add_stats(modstats, &(itnim->stats));
-	}
-	return BFA_STATUS_OK;
-}
-
-bfa_status_t
-bfa_fcpim_get_del_itn_stats(struct bfa_s *bfa,
-	 struct bfa_fcpim_del_itn_stats_s *modstats)
-{
-	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
-
-	*modstats = fcpim->del_itn_stats;
-
-	return BFA_STATUS_OK;
-}
-
-
-bfa_status_t
-bfa_fcpim_profile_on(struct bfa_s *bfa, u32 time)
-{
-	struct bfa_itnim_s *itnim;
-	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
-	struct list_head *qe, *qen;
-
-	/* accumulate IO stats from itnim */
-	list_for_each_safe(qe, qen, &fcpim->itnim_q) {
-		itnim = (struct bfa_itnim_s *) qe;
-		bfa_itnim_clear_stats(itnim);
-	}
-	fcpim->io_profile = BFA_TRUE;
-	fcpim->io_profile_start_time = time;
-	fcpim->profile_comp = bfa_ioim_profile_comp;
-	fcpim->profile_start = bfa_ioim_profile_start;
-
-	return BFA_STATUS_OK;
-}
-bfa_status_t
-bfa_fcpim_profile_off(struct bfa_s *bfa)
-{
-	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
-	fcpim->io_profile = BFA_FALSE;
-	fcpim->io_profile_start_time = 0;
-	fcpim->profile_comp = NULL;
-	fcpim->profile_start = NULL;
-	return BFA_STATUS_OK;
-}
-
-bfa_status_t
-bfa_fcpim_port_clear_iostats(struct bfa_s *bfa, u8 lp_tag)
-{
-	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
-	struct list_head *qe, *qen;
-	struct bfa_itnim_s *itnim;
-
-	/* clear IO stats from all active itnims */
-	list_for_each_safe(qe, qen, &fcpim->itnim_q) {
-		itnim = (struct bfa_itnim_s *) qe;
-		if (itnim->rport->rport_info.lp_tag != lp_tag)
-			continue;
-		bfa_itnim_clear_stats(itnim);
-	}
-	return BFA_STATUS_OK;
-
-}
-
-bfa_status_t
-bfa_fcpim_clr_modstats(struct bfa_s *bfa)
-{
-	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
-	struct list_head *qe, *qen;
-	struct bfa_itnim_s *itnim;
-
-	/* clear IO stats from all active itnims */
-	list_for_each_safe(qe, qen, &fcpim->itnim_q) {
-		itnim = (struct bfa_itnim_s *) qe;
-		bfa_itnim_clear_stats(itnim);
-	}
-	memset(&fcpim->del_itn_stats, 0,
-		sizeof(struct bfa_fcpim_del_itn_stats_s));
-
-	return BFA_STATUS_OK;
-}
-
-void
-bfa_fcpim_qdepth_set(struct bfa_s *bfa, u16 q_depth)
-{
-	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
-
-	bfa_assert(q_depth <= BFA_IOCFC_QDEPTH_MAX);
-
-	fcpim->q_depth = q_depth;
-}
-
 u16
 bfa_fcpim_qdepth_get(struct bfa_s *bfa)
 {
@@ -576,32 +393,12 @@ bfa_fcpim_qdepth_get(struct bfa_s *bfa)
 	return fcpim->q_depth;
 }
 
-void
-bfa_fcpim_update_ioredirect(struct bfa_s *bfa)
-{
-	bfa_boolean_t ioredirect;
-
-	/*
-	 * IO redirection is turned off when QoS is enabled and vice versa
-	 */
-	ioredirect = bfa_fcport_is_qos_enabled(bfa) ? BFA_FALSE : BFA_TRUE;
-}
-
-void
-bfa_fcpim_set_ioredirect(struct bfa_s *bfa, bfa_boolean_t state)
-{
-	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
-	fcpim->ioredirect = state;
-}
-
-
-
 /*
  *  BFA ITNIM module state machine functions
  */
 
 /*
- *	Beginning/unallocated state - no events expected.
+ * Beginning/unallocated state - no events expected.
  */
 static void
 bfa_itnim_sm_uninit(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
@@ -622,7 +419,7 @@ bfa_itnim_sm_uninit(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
 }
 
 /*
- *	Beginning state, only online event expected.
+ * Beginning state, only online event expected.
  */
 static void
 bfa_itnim_sm_created(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
@@ -725,7 +522,7 @@ bfa_itnim_sm_fwcreate_qfull(struct bfa_itnim_s *itnim,
 }
 
 /*
- *	Waiting for itnim create response from firmware, a delete is pending.
+ * Waiting for itnim create response from firmware, a delete is pending.
  */
 static void
 bfa_itnim_sm_delete_pending(struct bfa_itnim_s *itnim,
@@ -753,7 +550,7 @@ bfa_itnim_sm_delete_pending(struct bfa_itnim_s *itnim,
 }
 
 /*
- *	Online state - normal parking state.
+ * Online state - normal parking state.
  */
 static void
 bfa_itnim_sm_online(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
@@ -795,7 +592,7 @@ bfa_itnim_sm_online(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
 }
 
 /*
- *	Second level error recovery need.
+ * Second level error recovery need.
  */
 static void
 bfa_itnim_sm_sler(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
@@ -826,7 +623,7 @@ bfa_itnim_sm_sler(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
 }
 
 /*
- *	Going offline. Waiting for active IO cleanup.
+ * Going offline. Waiting for active IO cleanup.
  */
 static void
 bfa_itnim_sm_cleanup_offline(struct bfa_itnim_s *itnim,
@@ -863,7 +660,7 @@ bfa_itnim_sm_cleanup_offline(struct bfa_itnim_s *itnim,
 }
 
 /*
- *	Deleting itnim. Waiting for active IO cleanup.
+ * Deleting itnim. Waiting for active IO cleanup.
  */
 static void
 bfa_itnim_sm_cleanup_delete(struct bfa_itnim_s *itnim,
@@ -948,7 +745,7 @@ bfa_itnim_sm_fwdelete_qfull(struct bfa_itnim_s *itnim,
 }
 
 /*
- *	Offline state.
+ * Offline state.
  */
 static void
 bfa_itnim_sm_offline(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
@@ -979,9 +776,6 @@ bfa_itnim_sm_offline(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
 	}
 }
 
-/*
- *	IOC h/w failed state.
- */
 static void
 bfa_itnim_sm_iocdisable(struct bfa_itnim_s *itnim,
 				enum bfa_itnim_event event)
@@ -1016,7 +810,7 @@ bfa_itnim_sm_iocdisable(struct bfa_itnim_s *itnim,
 }
 
 /*
- *	Itnim is deleted, waiting for firmware response to delete.
+ * Itnim is deleted, waiting for firmware response to delete.
  */
 static void
 bfa_itnim_sm_deleting(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
@@ -1061,7 +855,7 @@ bfa_itnim_sm_deleting_qfull(struct bfa_itnim_s *itnim,
 }
 
 /*
- *	Initiate cleanup of all IOs on an IOC failure.
+ * Initiate cleanup of all IOs on an IOC failure.
  */
 static void
 bfa_itnim_iocdisable_cleanup(struct bfa_itnim_s *itnim)
@@ -1095,7 +889,7 @@ bfa_itnim_iocdisable_cleanup(struct bfa_itnim_s *itnim)
 }
 
 /*
- *	IO cleanup completion
+ * IO cleanup completion
  */
 static void
 bfa_itnim_cleanp_comp(void *itnim_cbarg)
@@ -1107,7 +901,7 @@ bfa_itnim_cleanp_comp(void *itnim_cbarg)
 }
 
 /*
- *	Initiate cleanup of all IOs.
+ * Initiate cleanup of all IOs.
  */
 static void
 bfa_itnim_cleanup(struct bfa_itnim_s *itnim)
@@ -1179,9 +973,6 @@ bfa_itnim_qresume(void *cbarg)
 	bfa_sm_send_event(itnim, BFA_ITNIM_SM_QRESUME);
 }
 
-
-
-
 /*
  *  bfa_itnim_public
  */
@@ -1449,14 +1240,12 @@ bfa_itnim_update_del_itn_stats(struct bfa_itnim_s *itnim)
 	fcpim->del_itn_stats.del_tm_iocdowns += itnim->stats.tm_iocdowns;
 }
 
-
-
 /*
- *  bfa_itnim_public
+ * bfa_itnim_public
  */
 
 /*
- *	Itnim interrupt processing.
+ * Itnim interrupt processing.
  */
 void
 bfa_itnim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
@@ -1499,10 +1288,8 @@ bfa_itnim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 	}
 }
 
-
-
 /*
- *  bfa_itnim_api
+ * bfa_itnim_api
  */
 
 struct bfa_itnim_s *
@@ -1575,7 +1362,7 @@ bfa_itnim_clear_stats(struct bfa_itnim_s *itnim)
  */
 
 /*
- *	IO is not started (unallocated).
+ * IO is not started (unallocated).
  */
 static void
 bfa_ioim_sm_uninit(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
@@ -1640,7 +1427,7 @@ bfa_ioim_sm_uninit(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 }
 
 /*
- *	IO is waiting for SG pages.
+ * IO is waiting for SG pages.
  */
 static void
 bfa_ioim_sm_sgalloc(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
@@ -1687,7 +1474,7 @@ bfa_ioim_sm_sgalloc(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 }
 
 /*
- *	IO is active.
+ * IO is active.
  */
 static void
 bfa_ioim_sm_active(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
@@ -1771,8 +1558,8 @@ bfa_ioim_sm_active(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 }
 
 /*
-*	IO is retried with new tag.
-*/
+ * IO is retried with new tag.
+ */
 static void
 bfa_ioim_sm_cmnd_retry(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 {
@@ -1825,7 +1612,7 @@ bfa_ioim_sm_cmnd_retry(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 }
 
 /*
- *	IO is being aborted, waiting for completion from firmware.
+ * IO is being aborted, waiting for completion from firmware.
  */
 static void
 bfa_ioim_sm_abort(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
@@ -1948,7 +1735,7 @@ bfa_ioim_sm_cleanup(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 }
 
 /*
- *	IO is waiting for room in request CQ
+ * IO is waiting for room in request CQ
  */
 static void
 bfa_ioim_sm_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
@@ -1992,7 +1779,7 @@ bfa_ioim_sm_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 }
 
 /*
- *	Active IO is being aborted, waiting for room in request CQ.
+ * Active IO is being aborted, waiting for room in request CQ.
  */
 static void
 bfa_ioim_sm_abort_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
@@ -2043,7 +1830,7 @@ bfa_ioim_sm_abort_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 }
 
 /*
- *	Active IO is being cleaned up, waiting for room in request CQ.
+ * Active IO is being cleaned up, waiting for room in request CQ.
  */
 static void
 bfa_ioim_sm_cleanup_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
@@ -2297,7 +2084,7 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 {
 	struct bfa_itnim_s *itnim = ioim->itnim;
 	struct bfi_ioim_req_s *m;
-	static struct fcp_cmnd_s cmnd_z0 = {{{0}}};
+	static struct fcp_cmnd_s cmnd_z0 = { { { 0 } } };
 	struct bfi_sge_s *sge, *sgpge;
 	u32	pgdlen = 0;
 	u32	fcp_dl;
@@ -2364,20 +2151,20 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 
 			sgpge++;
 			if (i == (ioim->nsges - 1)) {
-                        	sgpge->flags = BFI_SGE_PGDLEN;
-                        	sgpge->sga.a32.addr_lo = 0;
-                        	sgpge->sga.a32.addr_hi = 0;
-                		sgpge->sg_len = pgcumsz;
-                		bfa_sge_to_le(sgpge);
-                	} else if (++sge_id == BFI_SGPG_DATA_SGES) {
+				sgpge->flags = BFI_SGE_PGDLEN;
+				sgpge->sga.a32.addr_lo = 0;
+				sgpge->sga.a32.addr_hi = 0;
+				sgpge->sg_len = pgcumsz;
+				bfa_sge_to_le(sgpge);
+			} else if (++sge_id == BFI_SGPG_DATA_SGES) {
 				sgpg = (struct bfa_sgpg_s *) bfa_q_next(sgpg);
-                        	sgpge->flags = BFI_SGE_LINK;
-                        	sgpge->sga = sgpg->sgpg_pa;
-                		sgpge->sg_len = pgcumsz;
-                		bfa_sge_to_le(sgpge);
+				sgpge->flags = BFI_SGE_LINK;
+				sgpge->sga = sgpg->sgpg_pa;
+				sgpge->sg_len = pgcumsz;
+				bfa_sge_to_le(sgpge);
 				sge_id = 0;
 				pgcumsz = 0;
-                	}
+			}
 		}
 	}
 
@@ -2553,9 +2340,6 @@ bfa_ioim_is_abortable(struct bfa_ioim_s *ioim)
 	return BFA_TRUE;
 }
 
-/*
- *	or after the link comes back.
- */
 void
 bfa_ioim_delayed_comp(struct bfa_ioim_s *ioim, bfa_boolean_t iotov)
 {
@@ -2750,32 +2534,6 @@ bfa_ioim_good_comp_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 	bfa_sm_send_event(ioim, BFA_IOIM_SM_COMP_GOOD);
 }
 
-void
-bfa_ioim_profile_start(struct bfa_ioim_s *ioim)
-{
-	ioim->start_time = jiffies;
-}
-
-void
-bfa_ioim_profile_comp(struct bfa_ioim_s *ioim)
-{
-	struct scsi_cmnd *cmnd = (struct scsi_cmnd *) ioim->dio;
-	u32 fcp_dl = scsi_bufflen(cmnd);
-	u32 index = bfa_ioim_get_index(fcp_dl);
-	u64 end_time = jiffies;
-	struct bfa_itnim_latency_s *io_lat =
-			&(ioim->itnim->ioprofile.io_latency);
-	u32 val = (u32)(end_time - ioim->start_time);
-
-	bfa_itnim_ioprofile_update(ioim->itnim, index);
-
-	io_lat->count[index]++;
-	io_lat->min[index] = (io_lat->min[index] < val) ?
-		io_lat->min[index] : val;
-	io_lat->max[index] = (io_lat->max[index] > val) ?
-		io_lat->max[index] : val;
-	io_lat->avg[index] += val;
-}
 /*
  * Called by itnim to clean up IO while going offline.
  */
@@ -2909,13 +2667,12 @@ bfa_ioim_abort(struct bfa_ioim_s *ioim)
 	return BFA_STATUS_OK;
 }
 
-
 /*
  *  BFA TSKIM state machine functions
  */
 
 /*
- *	Task management command beginning state.
+ * Task management command beginning state.
  */
 static void
 bfa_tskim_sm_uninit(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
@@ -2952,9 +2709,8 @@ bfa_tskim_sm_uninit(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
 }
 
 /*
- * brief
- *	TM command is active, awaiting completion from firmware to
- *	cleanup IO requests in TM scope.
+ * TM command is active, awaiting completion from firmware to
+ * cleanup IO requests in TM scope.
  */
 static void
 bfa_tskim_sm_active(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
@@ -2989,8 +2745,8 @@ bfa_tskim_sm_active(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
 }
 
 /*
- *	An active TM is being cleaned up since ITN is offline. Awaiting cleanup
- *	completion event from firmware.
+ * An active TM is being cleaned up since ITN is offline. Awaiting cleanup
+ * completion event from firmware.
  */
 static void
 bfa_tskim_sm_cleanup(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
@@ -3050,7 +2806,7 @@ bfa_tskim_sm_iocleanup(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
 }
 
 /*
- *	Task management command is waiting for room in request CQ
+ * Task management command is waiting for room in request CQ
  */
 static void
 bfa_tskim_sm_qfull(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
@@ -3085,8 +2841,8 @@ bfa_tskim_sm_qfull(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
 }
 
 /*
- *	Task management command is active, awaiting for room in request CQ
- *	to send clean up request.
+ * Task management command is active, awaiting for room in request CQ
+ * to send clean up request.
  */
 static void
 bfa_tskim_sm_cleanup_qfull(struct bfa_tskim_s *tskim,
@@ -3098,10 +2854,8 @@ bfa_tskim_sm_cleanup_qfull(struct bfa_tskim_s *tskim,
 	case BFA_TSKIM_SM_DONE:
 		bfa_reqq_wcancel(&tskim->reqq_wait);
 		/*
-		 *
 		 * Fall through !!!
 		 */
-
 	case BFA_TSKIM_SM_QRESUME:
 		bfa_sm_set_state(tskim, bfa_tskim_sm_cleanup);
 		bfa_tskim_send_abort(tskim);
@@ -3120,7 +2874,7 @@ bfa_tskim_sm_cleanup_qfull(struct bfa_tskim_s *tskim,
 }
 
 /*
- *	BFA callback is pending
+ * BFA callback is pending
  */
 static void
 bfa_tskim_sm_hcb(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
@@ -3145,7 +2899,6 @@ bfa_tskim_sm_hcb(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
 	}
 }
 
-
 static void
 __bfa_cb_tskim_done(void *cbarg, bfa_boolean_t complete)
 {
@@ -3175,7 +2928,7 @@ __bfa_cb_tskim_failed(void *cbarg, bfa_boolean_t complete)
 				BFI_TSKIM_STS_FAILED);
 }
 
-static	bfa_boolean_t
+static bfa_boolean_t
 bfa_tskim_match_scope(struct bfa_tskim_s *tskim, struct scsi_lun lun)
 {
 	switch (tskim->tm_cmnd) {
@@ -3186,7 +2939,7 @@ bfa_tskim_match_scope(struct bfa_tskim_s *tskim, struct scsi_lun lun)
 	case FCP_TM_CLEAR_TASK_SET:
 	case FCP_TM_LUN_RESET:
 	case FCP_TM_CLEAR_ACA:
-		return (!memcmp(&tskim->lun, &lun, sizeof(lun)));
+		return !memcmp(&tskim->lun, &lun, sizeof(lun));
 
 	default:
 		bfa_assert(0);
@@ -3196,7 +2949,7 @@ bfa_tskim_match_scope(struct bfa_tskim_s *tskim, struct scsi_lun lun)
 }
 
 /*
- *	Gather affected IO requests and task management commands.
+ * Gather affected IO requests and task management commands.
  */
 static void
 bfa_tskim_gather_ios(struct bfa_tskim_s *tskim)
@@ -3238,7 +2991,7 @@ bfa_tskim_gather_ios(struct bfa_tskim_s *tskim)
 }
 
 /*
- *	IO cleanup completion
+ * IO cleanup completion
  */
 static void
 bfa_tskim_cleanp_comp(void *tskim_cbarg)
@@ -3250,7 +3003,7 @@ bfa_tskim_cleanp_comp(void *tskim_cbarg)
 }
 
 /*
- *	Gather affected IO requests and task management commands.
+ * Gather affected IO requests and task management commands.
  */
 static void
 bfa_tskim_cleanup_ios(struct bfa_tskim_s *tskim)
@@ -3270,7 +3023,7 @@ bfa_tskim_cleanup_ios(struct bfa_tskim_s *tskim)
 }
 
 /*
- *	Send task management request to firmware.
+ * Send task management request to firmware.
  */
 static bfa_boolean_t
 bfa_tskim_send(struct bfa_tskim_s *tskim)
@@ -3305,7 +3058,7 @@ bfa_tskim_send(struct bfa_tskim_s *tskim)
 }
 
 /*
- *	Send abort request to cleanup an active TM to firmware.
+ * Send abort request to cleanup an active TM to firmware.
  */
 static bfa_boolean_t
 bfa_tskim_send_abort(struct bfa_tskim_s *tskim)
@@ -3336,7 +3089,7 @@ bfa_tskim_send_abort(struct bfa_tskim_s *tskim)
 }
 
 /*
- *	Call to resume task management cmnd waiting for room in request queue.
+ * Call to resume task management cmnd waiting for room in request queue.
  */
 static void
 bfa_tskim_qresume(void *cbarg)
@@ -3362,7 +3115,6 @@ bfa_tskim_iocdisable_ios(struct bfa_tskim_s *tskim)
 	}
 }
 
-
 /*
  * Notification on completions from related ioim.
  */
@@ -3395,7 +3147,7 @@ bfa_tskim_cleanup(struct bfa_tskim_s *tskim)
 }
 
 /*
- *	Memory allocation and initialization.
+ * Memory allocation and initialization.
  */
 void
 bfa_tskim_attach(struct bfa_fcpim_mod_s *fcpim, struct bfa_meminfo_s *minfo)
@@ -3477,7 +3229,7 @@ bfa_tskim_free(struct bfa_tskim_s *tskim)
 }
 
 /*
- *	Start a task management command.
+ * Start a task management command.
  *
  * @param[in]	tskim	BFA task management command instance
  * @param[in]	itnim	i-t nexus for the task management command
diff --git a/drivers/scsi/bfa/bfa_fcpim.h b/drivers/scsi/bfa/bfa_fcpim.h
index 7d0eaba..f933458 100644
--- a/drivers/scsi/bfa/bfa_fcpim.h
+++ b/drivers/scsi/bfa/bfa_fcpim.h
@@ -94,12 +94,12 @@ struct bfa_fcpim_mod_s {
 	struct list_head	ioim_resfree_q; /*  IOs waiting for f/w */
 	struct list_head	ioim_comp_q;	/*  IO global comp Q	*/
 	struct list_head	tskim_free_q;
-	u32		ios_active;	/*  current active IOs	*/
-	u32		delay_comp;
+	u32			ios_active;	/*  current active IOs	*/
+	u32			delay_comp;
 	struct bfa_fcpim_del_itn_stats_s del_itn_stats;
 	bfa_boolean_t		ioredirect;
 	bfa_boolean_t		io_profile;
-	u32		io_profile_start_time;
+	u32			io_profile_start_time;
 	bfa_fcpim_profile_t     profile_comp;
 	bfa_fcpim_profile_t     profile_start;
 };
@@ -114,25 +114,24 @@ struct bfa_ioim_s {
 	struct bfa_fcpim_mod_s	*fcpim;		/*  parent fcpim module */
 	struct bfa_itnim_s	*itnim;		/*  i-t-n nexus for this IO  */
 	struct bfad_ioim_s	*dio;		/*  driver IO handle	*/
-	u16		iotag;		/*  FWI IO tag	*/
-	u16		abort_tag;	/*  unqiue abort request tag */
-	u16		nsges;		/*  number of SG elements */
-	u16		nsgpgs;		/*  number of SG pages	*/
+	u16			iotag;		/*  FWI IO tag	*/
+	u16			abort_tag;	/*  unqiue abort request tag */
+	u16			nsges;		/*  number of SG elements */
+	u16			nsgpgs;		/*  number of SG pages	*/
 	struct bfa_sgpg_s	*sgpg;		/*  first SG page	*/
 	struct list_head	sgpg_q;		/*  allocated SG pages	*/
 	struct bfa_cb_qe_s	hcb_qe;		/*  bfa callback qelem	*/
 	bfa_cb_cbfn_t		io_cbfn;	/*  IO completion handler */
-	struct bfa_ioim_sp_s *iosp;		/*  slow-path IO handling */
-	u8		reqq;		/*  Request queue for I/O */
-	u64 start_time;			/*  IO's Profile start val */
+	struct bfa_ioim_sp_s	*iosp;		/*  slow-path IO handling */
+	u8			reqq;		/*  Request queue for I/O */
+	u64			start_time;	/*  IO's Profile start val */
 };
 
-
 struct bfa_ioim_sp_s {
 	struct bfi_msg_s	comp_rspmsg;	/*  IO comp f/w response */
 	u8			*snsinfo;	/*  sense info for this IO   */
-	struct bfa_sgpg_wqe_s sgpg_wqe;	/*  waitq elem for sgpg	*/
-	struct bfa_reqq_wait_s reqq_wait;	/*  to wait for room in reqq */
+	struct bfa_sgpg_wqe_s	sgpg_wqe;	/*  waitq elem for sgpg	*/
+	struct bfa_reqq_wait_s	reqq_wait;	/*  to wait for room in reqq */
 	bfa_boolean_t		abort_explicit;	/*  aborted by OS	*/
 	struct bfa_tskim_s	*tskim;		/*  Relevant TM cmd	*/
 };
@@ -143,35 +142,34 @@ struct bfa_ioim_sp_s {
 struct bfa_tskim_s {
 	struct list_head	qe;
 	bfa_sm_t		sm;
-	struct bfa_s	*bfa;	/*  BFA module  */
+	struct bfa_s		*bfa;	/*  BFA module  */
 	struct bfa_fcpim_mod_s  *fcpim;	/*  parent fcpim module	*/
 	struct bfa_itnim_s	*itnim;	/*  i-t-n nexus for this IO  */
 	struct bfad_tskim_s	*dtsk;  /*  driver task mgmt cmnd	*/
-	bfa_boolean_t	notify;		/*  notify itnim on TM comp  */
+	bfa_boolean_t		notify;	/*  notify itnim on TM comp  */
 	struct scsi_lun		lun;	/*  lun if applicable	*/
-	enum fcp_tm_cmnd	tm_cmnd;	/*  task management command  */
-	u16	tsk_tag;	/*  FWI IO tag	*/
-	u8	tsecs;	/*  timeout in seconds	*/
+	enum fcp_tm_cmnd	tm_cmnd; /*  task management command  */
+	u16			tsk_tag; /*  FWI IO tag	*/
+	u8			tsecs;	/*  timeout in seconds	*/
 	struct bfa_reqq_wait_s  reqq_wait;   /*  to wait for room in reqq */
 	struct list_head	io_q;	/*  queue of affected IOs	*/
-	struct bfa_wc_s	wc;	/*  waiting counter	*/
+	struct bfa_wc_s		wc;	/*  waiting counter	*/
 	struct bfa_cb_qe_s	hcb_qe;	/*  bfa callback qelem	*/
 	enum bfi_tskim_status   tsk_status;  /*  TM status	*/
 };
 
-
 /*
  * BFA i-t-n (initiator mode)
  */
 struct bfa_itnim_s {
-	struct list_head	qe;		/*  queue element	*/
-	bfa_sm_t	  sm;		/*  i-t-n im BFA state machine  */
-	struct bfa_s	*bfa;		/*  bfa instance	*/
-	struct bfa_rport_s *rport;	/*  bfa rport	*/
-	void	*ditn;		/*  driver i-t-n structure	*/
+	struct list_head	qe;	/*  queue element	*/
+	bfa_sm_t		sm;	/*  i-t-n im BFA state machine  */
+	struct bfa_s		*bfa;	/*  bfa instance	*/
+	struct bfa_rport_s	*rport;	/*  bfa rport	*/
+	void			*ditn;	/*  driver i-t-n structure	*/
 	struct bfi_mhdr_s	mhdr;	/*  pre-built mhdr	*/
-	u8	msg_no;		/*  itnim/rport firmware handle */
-	u8	reqq;		/*  CQ for requests	*/
+	u8			msg_no;	/*  itnim/rport firmware handle */
+	u8			reqq;	/*  CQ for requests	*/
 	struct bfa_cb_qe_s	hcb_qe;	/*  bfa callback qelem	*/
 	struct list_head pending_q;	/*  queue of pending IO requests */
 	struct list_head io_q;		/*  queue of active IO requests */
@@ -181,15 +179,14 @@ struct bfa_itnim_s {
 	bfa_boolean_t   seq_rec;	/*  SQER supported	*/
 	bfa_boolean_t   is_online;	/*  itnim is ONLINE for IO	*/
 	bfa_boolean_t   iotov_active;	/*  IO TOV timer is active	 */
-	struct bfa_wc_s	wc;	/*  waiting counter	*/
-	struct bfa_timer_s timer;	/*  pending IO TOV		 */
+	struct bfa_wc_s	wc;		/*  waiting counter	*/
+	struct bfa_timer_s timer;	/*  pending IO TOV	 */
 	struct bfa_reqq_wait_s reqq_wait; /*  to wait for room in reqq */
 	struct bfa_fcpim_mod_s *fcpim;	/*  fcpim module	*/
 	struct bfa_itnim_iostats_s	stats;
 	struct bfa_itnim_ioprofile_s  ioprofile;
 };
 
-
 #define bfa_itnim_is_online(_itnim) ((_itnim)->is_online)
 #define BFA_FCPIM_MOD(_hal) (&(_hal)->modules.fcpim_mod)
 #define BFA_IOIM_FROM_TAG(_fcpim, _iotag)	\
@@ -246,32 +243,14 @@ void	bfa_itnim_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
 void	bfa_itnim_iodone(struct bfa_itnim_s *itnim);
 void	bfa_itnim_tskdone(struct bfa_itnim_s *itnim);
 bfa_boolean_t   bfa_itnim_hold_io(struct bfa_itnim_s *itnim);
-void bfa_ioim_profile_comp(struct bfa_ioim_s *ioim);
-void bfa_ioim_profile_start(struct bfa_ioim_s *ioim);
-
 
 /*
  * bfa fcpim module API functions
  */
-void		bfa_fcpim_path_tov_set(struct bfa_s *bfa, u16 path_tov);
+void	bfa_fcpim_path_tov_set(struct bfa_s *bfa, u16 path_tov);
 u16	bfa_fcpim_path_tov_get(struct bfa_s *bfa);
-void		bfa_fcpim_qdepth_set(struct bfa_s *bfa, u16 q_depth);
 u16	bfa_fcpim_qdepth_get(struct bfa_s *bfa);
-bfa_status_t bfa_fcpim_get_modstats(struct bfa_s *bfa,
-	 struct bfa_itnim_iostats_s *modstats);
-bfa_status_t bfa_fcpim_port_iostats(struct bfa_s *bfa,
-		struct bfa_itnim_iostats_s *stats, u8 lp_tag);
-bfa_status_t bfa_fcpim_get_del_itn_stats(struct bfa_s *bfa,
-	 struct bfa_fcpim_del_itn_stats_s *modstats);
-bfa_status_t bfa_fcpim_port_clear_iostats(struct bfa_s *bfa, u8 lp_tag);
-void bfa_fcpim_add_stats(struct bfa_itnim_iostats_s *fcpim_stats,
-		struct bfa_itnim_iostats_s *itnim_stats);
-bfa_status_t bfa_fcpim_clr_modstats(struct bfa_s *bfa);
-void		bfa_fcpim_set_ioredirect(struct bfa_s *bfa,
-				bfa_boolean_t state);
-void		bfa_fcpim_update_ioredirect(struct bfa_s *bfa);
-bfa_status_t bfa_fcpim_profile_on(struct bfa_s *bfa, u32 time);
-bfa_status_t bfa_fcpim_profile_off(struct bfa_s *bfa);
+
 #define bfa_fcpim_ioredirect_enabled(__bfa)				\
 	(((struct bfa_fcpim_mod_s *)(BFA_FCPIM_MOD(__bfa)))->ioredirect)
 
@@ -289,46 +268,33 @@ bfa_status_t bfa_fcpim_profile_off(struct bfa_s *bfa);
  * bfa itnim API functions
  */
 struct bfa_itnim_s *bfa_itnim_create(struct bfa_s *bfa,
-					struct bfa_rport_s *rport, void *itnim);
-void		bfa_itnim_delete(struct bfa_itnim_s *itnim);
-void		bfa_itnim_online(struct bfa_itnim_s *itnim,
-				 bfa_boolean_t seq_rec);
-void		bfa_itnim_offline(struct bfa_itnim_s *itnim);
-void		bfa_itnim_clear_stats(struct bfa_itnim_s *itnim);
-bfa_status_t	bfa_itnim_get_ioprofile(struct bfa_itnim_s *itnim,
-		struct bfa_itnim_ioprofile_s *ioprofile);
+		struct bfa_rport_s *rport, void *itnim);
+void bfa_itnim_delete(struct bfa_itnim_s *itnim);
+void bfa_itnim_online(struct bfa_itnim_s *itnim, bfa_boolean_t seq_rec);
+void bfa_itnim_offline(struct bfa_itnim_s *itnim);
+void bfa_itnim_clear_stats(struct bfa_itnim_s *itnim);
+bfa_status_t bfa_itnim_get_ioprofile(struct bfa_itnim_s *itnim,
+			struct bfa_itnim_ioprofile_s *ioprofile);
+
 #define bfa_itnim_get_reqq(__ioim) (((struct bfa_ioim_s *)__ioim)->itnim->reqq)
 
 /*
- *	BFA completion callback for bfa_itnim_online().
- *
- * @param[in]		itnim		FCS or driver itnim instance
- *
- * return None
+ * BFA completion callback for bfa_itnim_online().
  */
 void	bfa_cb_itnim_online(void *itnim);
 
 /*
- *	BFA completion callback for bfa_itnim_offline().
- *
- * @param[in]		itnim		FCS or driver itnim instance
- *
- * return None
+ * BFA completion callback for bfa_itnim_offline().
  */
 void	bfa_cb_itnim_offline(void *itnim);
 void	bfa_cb_itnim_tov_begin(void *itnim);
 void	bfa_cb_itnim_tov(void *itnim);
 
 /*
- *	BFA notification to FCS/driver for second level error recovery.
- *
+ * BFA notification to FCS/driver for second level error recovery.
  * Atleast one I/O request has timedout and target is unresponsive to
  * repeated abort requests. Second level error recovery should be initiated
  * by starting implicit logout and recovery procedures.
- *
- * @param[in]		itnim		FCS or driver itnim instance
- *
- * return None
  */
 void	bfa_cb_itnim_sler(void *itnim);
 
@@ -345,10 +311,8 @@ void		bfa_ioim_start(struct bfa_ioim_s *ioim);
 bfa_status_t	bfa_ioim_abort(struct bfa_ioim_s *ioim);
 void		bfa_ioim_delayed_comp(struct bfa_ioim_s *ioim,
 				      bfa_boolean_t iotov);
-
-
 /*
- *	I/O completion notification.
+ * I/O completion notification.
  *
  * @param[in]		dio			driver IO structure
  * @param[in]		io_status		IO completion status
@@ -359,39 +323,31 @@ void		bfa_ioim_delayed_comp(struct bfa_ioim_s *ioim,
  *
  * @return None
  */
-void	bfa_cb_ioim_done(void *bfad, struct bfad_ioim_s *dio,
-				  enum bfi_ioim_status io_status,
-				  u8 scsi_status, int sns_len,
-				  u8 *sns_info, s32 residue);
+void bfa_cb_ioim_done(void *bfad, struct bfad_ioim_s *dio,
+			enum bfi_ioim_status io_status,
+			u8 scsi_status, int sns_len,
+			u8 *sns_info, s32 residue);
 
 /*
- *	I/O good completion notification.
- *
- * @param[in]		dio			driver IO structure
- *
- * @return None
+ * I/O good completion notification.
  */
-void	bfa_cb_ioim_good_comp(void *bfad, struct bfad_ioim_s *dio);
+void bfa_cb_ioim_good_comp(void *bfad, struct bfad_ioim_s *dio);
 
 /*
- *	I/O abort completion notification
- *
- * @param[in]		dio			driver IO that was aborted
- *
- * @return None
+ * I/O abort completion notification
  */
-void	bfa_cb_ioim_abort(void *bfad, struct bfad_ioim_s *dio);
+void bfa_cb_ioim_abort(void *bfad, struct bfad_ioim_s *dio);
 
 /*
  * bfa tskim API functions
  */
-struct bfa_tskim_s	*bfa_tskim_alloc(struct bfa_s *bfa,
-					struct bfad_tskim_s *dtsk);
-void		bfa_tskim_free(struct bfa_tskim_s *tskim);
-void		bfa_tskim_start(struct bfa_tskim_s *tskim,
-				struct bfa_itnim_s *itnim, struct scsi_lun lun,
-				enum fcp_tm_cmnd tm, u8 t_secs);
-void		bfa_cb_tskim_done(void *bfad, struct bfad_tskim_s *dtsk,
-				  enum bfi_tskim_status tsk_status);
+struct bfa_tskim_s *bfa_tskim_alloc(struct bfa_s *bfa,
+			struct bfad_tskim_s *dtsk);
+void bfa_tskim_free(struct bfa_tskim_s *tskim);
+void bfa_tskim_start(struct bfa_tskim_s *tskim,
+			struct bfa_itnim_s *itnim, struct scsi_lun lun,
+			enum fcp_tm_cmnd tm, u8 t_secs);
+void bfa_cb_tskim_done(void *bfad, struct bfad_tskim_s *dtsk,
+			enum bfi_tskim_status tsk_status);
 
 #endif /* __BFA_FCPIM_H__ */
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 9eb47b8..bf96626 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -883,7 +883,8 @@ bfa_fcs_lport_get_attr(
 
 	if (port->fabric) {
 		port_attr->port_type = port->fabric->oper_type;
-		port_attr->loopback = bfa_sm_cmp_state(port->fabric, bfa_fcs_fabric_sm_loopback);
+		port_attr->loopback = bfa_sm_cmp_state(port->fabric,
+				bfa_fcs_fabric_sm_loopback);
 		port_attr->authfail =
 			bfa_sm_cmp_state(port->fabric,
 				bfa_fcs_fabric_sm_auth_failed);
diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index 110940c..e98f233 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -1974,7 +1974,8 @@ bfa_fcs_rport_alloc(struct bfa_fcs_lport_s *port, wwn_t pwwn, u32 rpid)
 		rport->itnim = bfa_fcs_itnim_create(rport);
 		if (!rport->itnim) {
 			bfa_trc(fcs, rpid);
-			bfa_sm_send_event(rport->bfa_rport, BFA_RPORT_SM_DELETE);
+			bfa_sm_send_event(rport->bfa_rport,
+						BFA_RPORT_SM_DELETE);
 			kfree(rport_drv);
 			return NULL;
 		}
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 97b36018..58b3391 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -586,13 +586,10 @@ bfa_ioc_sm_fail(struct bfa_ioc_s *ioc, enum ioc_event event)
 	}
 }
 
-
-
 /*
  * IOCPF State Machine
  */
 
-
 /*
  * Reset entry actions -- initialize state machine
  */
@@ -754,7 +751,6 @@ bfa_iocpf_sm_semwait(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 	}
 }
 
-
 static void
 bfa_iocpf_sm_hwinit_entry(struct bfa_iocpf_s *iocpf)
 {
@@ -811,7 +807,6 @@ bfa_iocpf_sm_hwinit(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 	}
 }
 
-
 static void
 bfa_iocpf_sm_enabling_entry(struct bfa_iocpf_s *iocpf)
 {
@@ -873,8 +868,6 @@ bfa_iocpf_sm_enabling(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 	}
 }
 
-
-
 static void
 bfa_iocpf_sm_ready_entry(struct bfa_iocpf_s *iocpf)
 {
@@ -915,7 +908,6 @@ bfa_iocpf_sm_ready(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 	}
 }
 
-
 static void
 bfa_iocpf_sm_disabling_entry(struct bfa_iocpf_s *iocpf)
 {
@@ -965,7 +957,7 @@ bfa_iocpf_sm_disabling(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 static void
 bfa_iocpf_sm_disabled_entry(struct bfa_iocpf_s *iocpf)
 {
-	bfa_fsm_send_event(iocpf->ioc, IOC_E_DISABLED);	
+	bfa_fsm_send_event(iocpf->ioc, IOC_E_DISABLED);
 }
 
 static void
@@ -990,7 +982,6 @@ bfa_iocpf_sm_disabled(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 	}
 }
 
-
 static void
 bfa_iocpf_sm_initfail_entry(struct bfa_iocpf_s *iocpf)
 {
@@ -1028,7 +1019,6 @@ bfa_iocpf_sm_initfail(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 	}
 }
 
-
 static void
 bfa_iocpf_sm_fail_entry(struct bfa_iocpf_s *iocpf)
 {
@@ -1078,8 +1068,6 @@ bfa_iocpf_sm_fail(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 	}
 }
 
-
-
 /*
  *  BFA IOC private functions
  */
@@ -1123,7 +1111,6 @@ bfa_ioc_sem_get(void __iomem *sem_reg)
 	return BFA_FALSE;
 }
 
-
 static void
 bfa_ioc_hw_sem_get(struct bfa_ioc_s *ioc)
 {
@@ -1305,7 +1292,6 @@ bfa_ioc_msgflush(struct bfa_ioc_s *ioc)
 		writel(1, ioc->ioc_regs.lpu_mbox_cmd);
 }
 
-
 static void
 bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force)
 {
@@ -1738,7 +1724,6 @@ bfa_ioc_smem_clr(struct bfa_ioc_s *ioc, u32 soff, u32 sz)
 	return BFA_STATUS_OK;
 }
 
-
 static void
 bfa_ioc_pf_fwmismatch(struct bfa_ioc_s *ioc)
 {
@@ -1752,7 +1737,6 @@ bfa_ioc_pf_fwmismatch(struct bfa_ioc_s *ioc)
 		"with the driver version\n");
 }
 
-
 bfa_status_t
 bfa_ioc_pll_init(struct bfa_ioc_s *ioc)
 {
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 5dfe6d4..d5e5bfd 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -52,7 +52,6 @@ BFA_MODULE(uf);
 	((bfa_fcport_is_disabled(bfa) == BFA_TRUE) || \
 	(bfa_ioc_is_disabled(&bfa->ioc) == BFA_TRUE))
 
-
 /*
  * BFA port state machine events
  */
@@ -285,7 +284,7 @@ plkd_validate_logrec(struct bfa_plog_rec_s *pl_rec)
 	return 0;
 }
 
-static u64 
+static u64
 bfa_get_log_time(void)
 {
 	u64 system_time = 0;
@@ -917,10 +916,6 @@ bfa_fcxp_queue(struct bfa_fcxp_s *fcxp, struct bfi_fcxp_send_req_s *send_req)
 }
 
 /*
- *  hal_fcxp_api BFA FCXP API
- */
-
-/*
  * Allocate an FCXP instance to send a response or to send a request
  * that has a response. Request/response buffers are allocated by caller.
  *
@@ -1014,7 +1009,7 @@ bfa_fcxp_get_rspbuf(struct bfa_fcxp_s *fcxp)
 }
 
 /*
- *		Free the BFA FCXP
+ * Free the BFA FCXP
  *
  * @param[in]	fcxp			BFA fcxp pointer
  *
@@ -1161,12 +1156,6 @@ bfa_fcxp_discard(struct bfa_fcxp_s *fcxp)
 	fcxp->send_cbfn = bfa_fcxp_null_comp;
 }
 
-
-
-/*
- *  hal_fcxp_public BFA FCXP public functions
- */
-
 void
 bfa_fcxp_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
 {
@@ -2636,12 +2625,6 @@ bfa_fcport_ln_sm_up_dn_up_nf(struct bfa_fcport_ln_s *ln,
 	}
 }
 
-
-
-/*
- *  hal_port_private
- */
-
 static void
 __bfa_cb_fcport_event(void *cbarg, bfa_boolean_t complete)
 {
@@ -3229,12 +3212,6 @@ bfa_trunk_iocdisable(struct bfa_s *bfa)
 	}
 }
 
-
-
-/*
- *  hal_port_public
- */
-
 /*
  * Called to initialize port attributes
  */
@@ -3336,12 +3313,6 @@ bfa_fcport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
 	}
 }
 
-
-
-/*
- *  hal_port_api
- */
-
 /*
  * Registered callback for port events.
  */
@@ -3674,7 +3645,6 @@ bfa_fcport_is_ratelim(struct bfa_s *bfa)
 
 }
 
-
 /*
  * Get default minimum ratelim speed
  */
@@ -4573,12 +4543,6 @@ bfa_sgpg_iocdisable(struct bfa_s *bfa)
 {
 }
 
-
-
-/*
- *  hal_sgpg_public BFA SGPG public functions
- */
-
 bfa_status_t
 bfa_sgpg_malloc(struct bfa_s *bfa, struct list_head *sgpg_q, int nsgpgs)
 {
@@ -4940,7 +4904,7 @@ bfa_uf_start(struct bfa_s *bfa)
 {
 	bfa_uf_post_all(BFA_UF_MOD(bfa));
 }
- 
+
 /*
  * Register handler for all unsolicted recieve frames.
  *
diff --git a/drivers/scsi/bfa/bfad_debugfs.c b/drivers/scsi/bfa/bfad_debugfs.c
index c76eec0..c66e32e 100644
--- a/drivers/scsi/bfa/bfad_debugfs.c
+++ b/drivers/scsi/bfa/bfad_debugfs.c
@@ -290,9 +290,9 @@ bfad_debugfs_write_regrd(struct file *file, const char __user *buf,
 	}
 
 	if (copy_from_user(kern_buf, (void  __user *)buf, nbytes)) {
-                kfree(kern_buf);
+		kfree(kern_buf);
 		return -ENOMEM;
-        }
+	}
 
 	rc = sscanf(kern_buf, "%x:%x", &addr, &len);
 	if (rc < 2) {
@@ -366,9 +366,9 @@ bfad_debugfs_write_regwr(struct file *file, const char __user *buf,
 	}
 
 	if (copy_from_user(kern_buf, (void  __user *)buf, nbytes)) {
-                kfree(kern_buf);
+		kfree(kern_buf);
 		return -ENOMEM;
-        }
+	}
 
 	rc = sscanf(kern_buf, "%x:%x", &addr, &val);
 	if (rc < 2) {
-- 
1.7.2.1

