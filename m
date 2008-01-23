From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 03/10] [FCoE] Remove DEBUG_ASSERTS statements
Date: Tue, 22 Jan 2008 16:36:09 -0800
Message-ID: <20080123003609.8469.13363.stgit@fritz>
References: <20080123003523.8469.62236.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24474 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756530AbYAWAuB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jan 2008 19:50:01 -0500
In-Reply-To: <20080123003523.8469.62236.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


---

 drivers/scsi/ofc/include/fc_els.h |   17 -----------------
 drivers/scsi/ofc/include/fc_fs.h  |   13 -------------
 drivers/scsi/ofc/include/fc_gs.h  |   12 ------------
 drivers/scsi/ofc/libfc/fc_ils.h   |   33 ---------------------------------
 drivers/scsi/ofc/libfc/fc_sess.c  |   14 --------------
 5 files changed, 0 insertions(+), 89 deletions(-)


diff --git a/drivers/scsi/ofc/include/fc_els.h b/drivers/scsi/ofc/include/fc_els.h
index 8ef10c0..6bff73e 100644
--- a/drivers/scsi/ofc/include/fc_els.h
+++ b/drivers/scsi/ofc/include/fc_els.h
@@ -808,21 +808,4 @@ enum fc_els_clid_ic {
 	ELS_CLID_IC_LIP =	8,	/* receiving LIP */
 };
 
-#ifdef DEBUG_ASSERTS
-/*
- * Static checks for packet structure sizes.
- * These catch some obvious errors in structure definitions.
- * They should generate no code since they can be tested at compile time.
- */
-static inline void fc_els_size_checks(void)
-{
-	ASSERT_NOTIMPL(sizeof(struct fc_els_csp) == FC_ELS_CSP_LEN);
-	ASSERT_NOTIMPL(sizeof(struct fc_els_cssp) == FC_ELS_CSSP_LEN);
-	ASSERT_NOTIMPL(sizeof(struct fc_els_flogi) == FC_ELS_FLOGI_LEN);
-	ASSERT_NOTIMPL(sizeof(struct fc_els_spp) == FC_ELS_SPP_LEN);
-	ASSERT_NOTIMPL(sizeof(struct fc_els_prli) == FC_ELS_PRLI_LEN);
-	ASSERT_NOTIMPL(sizeof(struct fc_els_logo) == FC_ELS_LOGO_LEN);
-}
-#endif /* DEBUG_ASSERTS */
-
 #endif /* _FC_ELS_H_ */
diff --git a/drivers/scsi/ofc/include/fc_fs.h b/drivers/scsi/ofc/include/fc_fs.h
index 150a711..fdbed64 100644
--- a/drivers/scsi/ofc/include/fc_fs.h
+++ b/drivers/scsi/ofc/include/fc_fs.h
@@ -324,17 +324,4 @@ struct fc_data_desc {
 
 #define FC_DATA_DESC_LEN    12	/* expected length of structure */
 
-#ifdef DEBUG_ASSERTS
-/*
- * Static checks for packet structure sizes.
- * These catch some obvious errors in structure definitions.
- * This should generate no code.  The check should be true at compile time.
- */
-static inline void fc_fs_size_checks(void)
-{
-	ASSERT_NOTIMPL(sizeof(struct fc_frame_header) == FC_FRAME_HEADER_LEN);
-	ASSERT_NOTIMPL(sizeof(struct fc_data_desc) == FC_DATA_DESC_LEN);
-}
-#endif /* DEBUG_ASSERTS */
-
 #endif /* _FC_FS_H_ */
diff --git a/drivers/scsi/ofc/include/fc_gs.h b/drivers/scsi/ofc/include/fc_gs.h
index 2ac3d24..6738535 100644
--- a/drivers/scsi/ofc/include/fc_gs.h
+++ b/drivers/scsi/ofc/include/fc_gs.h
@@ -90,16 +90,4 @@ enum fc_ct_explan {
 	/* definitions not complete */
 };
 
-#ifdef DEBUG_ASSERTS
-/*
- * Static checks for packet structure sizes.
- * These catch some obvious errors in structure definitions.
- * These should generate no code since they can be tested at compile time.
- */
-static inline void fc_gs_size_checks(void)
-{
-	ASSERT_NOTIMPL(sizeof(struct fc_ct_hdr) == FC_CT_HDR_LEN);
-}
-#endif /* DEBUG_ASSERTS */
-
 #endif /* _FC_GS_H_ */
diff --git a/drivers/scsi/ofc/libfc/fc_ils.h b/drivers/scsi/ofc/libfc/fc_ils.h
index 7225ac5..c421df7 100644
--- a/drivers/scsi/ofc/libfc/fc_ils.h
+++ b/drivers/scsi/ofc/libfc/fc_ils.h
@@ -521,37 +521,4 @@ struct fc_ils_mrra_resp {
 #define	FC_MRRR_AVAIL	1		/* resources available */
 #define	FC_MRRR_UNAV	2		/* resources unavailable */
 
-#ifdef DEBUG_ASSERTS
-/*
- * Static checks for packet structure sizes.
- * These catch some obvious errors in structure definitions.
- * This should generate no code.  The check should be true at compile time.
- */
-static inline void fc_ils_size_checks(void)
-{
-	ASSERT_NOTIMPL(sizeof(struct fc_ils_sw_rjt) == FC_ILS_SW_RJT_LEN);
-	ASSERT_NOTIMPL(sizeof(struct fc_ils_gnf) == FC_ILS_GNF_LEN);
-	ASSERT_NOTIMPL(sizeof(struct fc_elp_f_params) ==
-		       FC_ILS_ELP_F_PARAMS_LEN);
-	ASSERT_NOTIMPL(sizeof(struct fc_ils_elp) == FC_ILS_ELP_LEN);
-	ASSERT_NOTIMPL(sizeof(struct fc_ils_elp_r_rdy) == FC_ILS_ELP_R_RDY_LEN);
-	ASSERT_NOTIMPL(sizeof(struct fc_ils_elp_vc_rdy) ==
-		       FC_ILS_ELP_VC_RDY_LEN);
-	ASSERT_NOTIMPL(sizeof(struct fc_ils_efp) == FC_ILS_EFP_LEN);
-	ASSERT_NOTIMPL(sizeof(struct fc_ils_efp_rec) == FC_ILS_EFP_REC_LEN);
-	ASSERT_NOTIMPL(sizeof(struct fc_ils_mcast_id_rec) ==
-		       FC_ILS_MCAST_ID_REC_LEN);
-	ASSERT_NOTIMPL(sizeof(struct fc_ils_dia) == FC_ILS_DIA_LEN);
-	ASSERT_NOTIMPL(sizeof(struct fc_ils_rdi) == FC_ILS_RDI_LEN);
-	ASSERT_NOTIMPL(sizeof(struct fc_ils_fspf) == FC_ILS_FSPF_LEN);
-	ASSERT_NOTIMPL(sizeof(struct fc_ils_hlo) == FC_ILS_HLO_LEN);
-	ASSERT_NOTIMPL(sizeof(struct fc_ils_lsu) == FC_ILS_LSU_LEN);
-	ASSERT_NOTIMPL(sizeof(struct fc_ils_lsr) == FC_ILS_LSR_LEN);
-	ASSERT_NOTIMPL(sizeof(struct fc_link_desc) == FC_LINK_DESC_LEN);
-	ASSERT_NOTIMPL(sizeof(struct fc_ils_esc) == FC_ILS_ESC_LEN);
-	ASSERT_NOTIMPL(sizeof(struct fc_ils_mrra) == FC_ILS_MRRA_LEN);
-	ASSERT_NOTIMPL(sizeof(struct fc_ils_mrra_resp) == FC_ILS_MRRA_RESP_LEN);
-}
-#endif /* DEBUG_ASSERTS */
-
 #endif /* _FC_ILS_H_ */
diff --git a/drivers/scsi/ofc/libfc/fc_sess.c b/drivers/scsi/ofc/libfc/fc_sess.c
index 65204ae..ee08c97 100644
--- a/drivers/scsi/ofc/libfc/fc_sess.c
+++ b/drivers/scsi/ofc/libfc/fc_sess.c
@@ -116,20 +116,6 @@ static inline void fc_sess_unlock(struct fc_sess *sess)
 	spin_unlock_bh(&sess->fs_lock);
 }
 
-#ifdef DEBUG_ASSERTS
-/*
- * Check whether session is locked.
- */
-static inline int fc_sess_locked(const struct fc_sess *sess)
-{
-#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
-	return spin_is_locked((spinlock_t *) &sess->fs_lock);
-#else
-	return 1;
-#endif /* CONFIG_SMP || CONFIG_DEBUG_SPINLOCK */
-}
-#endif /* DEBUG_ASSERTS */
-
 /*
  * Unlock session.
  * This must handle operations that defer because they can't be done

