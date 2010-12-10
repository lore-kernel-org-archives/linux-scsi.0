From: Maggie Zhang <xmzhang@brocade.com>
Subject: [PATCH 5/7] bfa: remove all SCSI IO callbacks
Date: Thu, 9 Dec 2010 19:11:39 -0800
Message-ID: <1291950699-15250-1-git-send-email-xmzhang@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:55112 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753198Ab0LJDLp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Dec 2010 22:11:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@blc-10-10.brocade.com, Maggie Zhang <xmzhang@brocade.com>, Jing Huang <huangj@brocade.com>

Remove SCSI IO callbacks, and as a result remove bfa_cb_ioim.h.

Signed-off-by: Maggie Zhang <xmzhang@brocade.com>
Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_cb_ioim.h |  169 ----------------------------------------
 drivers/scsi/bfa/bfa_defs.h    |    4 +-
 drivers/scsi/bfa/bfa_fc.h      |    5 +-
 drivers/scsi/bfa/bfa_fcpim.c   |   53 ++++++++-----
 drivers/scsi/bfa/bfa_fcpim.h   |    8 +-
 drivers/scsi/bfa/bfad_im.c     |   10 ++-
 drivers/scsi/bfa/bfi.h         |    2 +-
 drivers/scsi/bfa/bfi_ms.h      |    2 +-
 8 files changed, 49 insertions(+), 204 deletions(-)
 delete mode 100644 drivers/scsi/bfa/bfa_cb_ioim.h

diff --git a/drivers/scsi/bfa/bfa_cb_ioim.h b/drivers/scsi/bfa/bfa_cb_ioim.h
deleted file mode 100644
index afb5738..0000000
--- a/drivers/scsi/bfa/bfa_cb_ioim.h
+++ /dev/null
@@ -1,169 +0,0 @@
-/*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
- * All rights reserved
- * www.brocade.com
- *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License (GPL) Version 2 as
- * published by the Free Software Foundation
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- */
-
-#ifndef __BFA_HCB_IOIM_H__
-#define __BFA_HCB_IOIM_H__
-
-#include "bfa_os_inc.h"
-/*
- * task attribute values in FCP-2 FCP_CMND IU
- */
-#define SIMPLE_Q    0
-#define HEAD_OF_Q   1
-#define ORDERED_Q   2
-#define ACA_Q	    4
-#define UNTAGGED    5
-
-static inline lun_t
-bfad_int_to_lun(u32 luno)
-{
-	union {
-		__be16	scsi_lun[4];
-		lun_t		bfa_lun;
-	} lun;
-
-	lun.bfa_lun     = 0;
-	lun.scsi_lun[0] = cpu_to_be16(luno);
-
-	return lun.bfa_lun;
-}
-
-/*
- * Get LUN for the I/O request
- */
-#define bfa_cb_ioim_get_lun(__dio)	\
-	bfad_int_to_lun(((struct scsi_cmnd *)__dio)->device->lun)
-
-/*
- * Get CDB for the I/O request
- */
-static inline u8 *
-bfa_cb_ioim_get_cdb(struct bfad_ioim_s *dio)
-{
-	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
-
-	return (u8 *) cmnd->cmnd;
-}
-
-/*
- * Get I/O direction (read/write) for the I/O request
- */
-static inline enum fcp_iodir
-bfa_cb_ioim_get_iodir(struct bfad_ioim_s *dio)
-{
-	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
-	enum dma_data_direction dmadir;
-
-	dmadir = cmnd->sc_data_direction;
-	if (dmadir == DMA_TO_DEVICE)
-		return FCP_IODIR_WRITE;
-	else if (dmadir == DMA_FROM_DEVICE)
-		return FCP_IODIR_READ;
-	else
-		return FCP_IODIR_NONE;
-}
-
-/*
- * Get IO size in bytes for the I/O request
- */
-static inline u32
-bfa_cb_ioim_get_size(struct bfad_ioim_s *dio)
-{
-	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
-
-	return scsi_bufflen(cmnd);
-}
-
-/*
- * Get timeout for the I/O request
- */
-static inline u8
-bfa_cb_ioim_get_timeout(struct bfad_ioim_s *dio)
-{
-	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
-	/*
-	 * TBD: need a timeout for scsi passthru
-	 */
-	if (cmnd->device->host == NULL)
-		return 4;
-
-	return 0;
-}
-
-/*
- * Get Command Reference Number for the I/O request. 0 if none.
- */
-static inline u8
-bfa_cb_ioim_get_crn(struct bfad_ioim_s *dio)
-{
-	return 0;
-}
-
-/*
- * Get SAM-3 priority for the I/O request. 0 is default.
- */
-static inline u8
-bfa_cb_ioim_get_priority(struct bfad_ioim_s *dio)
-{
-	return 0;
-}
-
-/*
- * Get task attributes for the I/O request. Default is FCP_TASK_ATTR_SIMPLE(0).
- */
-static inline u8
-bfa_cb_ioim_get_taskattr(struct bfad_ioim_s *dio)
-{
-	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
-	u8	task_attr = UNTAGGED;
-
-	if (cmnd->device->tagged_supported) {
-		switch (cmnd->tag) {
-		case HEAD_OF_QUEUE_TAG:
-			task_attr = HEAD_OF_Q;
-			break;
-		case ORDERED_QUEUE_TAG:
-			task_attr = ORDERED_Q;
-			break;
-		default:
-			task_attr = SIMPLE_Q;
-			break;
-		}
-	}
-
-	return task_attr;
-}
-
-/*
- * Get CDB length in bytes for the I/O request. Default is FCP_CMND_CDB_LEN(16).
- */
-static inline u8
-bfa_cb_ioim_get_cdblen(struct bfad_ioim_s *dio)
-{
-	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
-
-	return cmnd->cmd_len;
-}
-
-/*
- * Assign queue to be used for the I/O request. This value depends on whether
- * the driver wants to use the queues via any specific algorithm. Currently,
- * this is not supported.
- */
-#define bfa_cb_ioim_get_reqq(__dio) BFA_FALSE
-
-#endif /* __BFA_HCB_IOIM_H__ */
diff --git a/drivers/scsi/bfa/bfa_defs.h b/drivers/scsi/bfa/bfa_defs.h
index 4b5b9e3..07b57c4 100644
--- a/drivers/scsi/bfa/bfa_defs.h
+++ b/drivers/scsi/bfa/bfa_defs.h
@@ -446,8 +446,8 @@ enum bfa_boot_bootopt {
  * Boot lun information.
  */
 struct bfa_boot_bootlun_s {
-	wwn_t   pwwn;   /*  port wwn of target */
-	lun_t   lun;    /*  64-bit lun */
+	wwn_t   pwwn;		/*  port wwn of target */
+	struct scsi_lun   lun;  /*  64-bit lun */
 };
 #pragma pack()
 
diff --git a/drivers/scsi/bfa/bfa_fc.h b/drivers/scsi/bfa/bfa_fc.h
index 7dd0caf..a478311 100644
--- a/drivers/scsi/bfa/bfa_fc.h
+++ b/drivers/scsi/bfa/bfa_fc.h
@@ -21,7 +21,6 @@
 #include "bfa_os_inc.h"
 
 typedef u64 wwn_t;
-typedef u64 lun_t;
 
 #define WWN_NULL	(0)
 #define FC_SYMNAME_MAX	256	/*  max name server symbolic name size */
@@ -1176,8 +1175,8 @@ struct fc_srr_s {
 #define FCP_CMND_LUN_LEN    8
 
 struct fcp_cmnd_s {
-	lun_t           lun;		/* 64-bit LU number */
-	u8         crn;		/* command reference number */
+	struct scsi_lun		lun;	/* 64-bit LU number */
+	u8			crn;	/* command reference number */
 #ifdef __BIGENDIAN
 	u8         resvd:1,
 			priority:4,	/* FCP-3: SAM-3 priority */
diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 898864a..01d86ef 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -16,7 +16,7 @@
  */
 
 #include "bfa_modules.h"
-#include "bfa_cb_ioim.h"
+#include "bfa_os_inc.h"
 
 BFA_TRC_FILE(HAL, FCPIM);
 BFA_MODULE(fcpim);
@@ -263,7 +263,7 @@ static void	bfa_ioim_sm_cmnd_retry(struct bfa_ioim_s *ioim,
 static void     __bfa_cb_tskim_done(void *cbarg, bfa_boolean_t complete);
 static void     __bfa_cb_tskim_failed(void *cbarg, bfa_boolean_t complete);
 static bfa_boolean_t bfa_tskim_match_scope(struct bfa_tskim_s *tskim,
-					lun_t lun);
+					struct scsi_lun lun);
 static void     bfa_tskim_gather_ios(struct bfa_tskim_s *tskim);
 static void     bfa_tskim_cleanp_comp(void *tskim_cbarg);
 static void     bfa_tskim_cleanup_ios(struct bfa_tskim_s *tskim);
@@ -2315,7 +2315,7 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 {
 	struct bfa_itnim_s *itnim = ioim->itnim;
 	struct bfi_ioim_req_s *m;
-	static struct fcp_cmnd_s cmnd_z0 = { 0 };
+	static struct fcp_cmnd_s cmnd_z0 = {{{0}}};
 	struct bfi_sge_s *sge, *sgpge;
 	u32	pgdlen = 0;
 	u32	fcp_dl;
@@ -2324,6 +2324,7 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 	struct bfa_sgpg_s *sgpg;
 	struct scsi_cmnd *cmnd = (struct scsi_cmnd *) ioim->dio;
 	u32 i, sge_id, pgcumsz;
+	enum dma_data_direction dmadir;
 
 	/*
 	 * check for room in queue to send request now
@@ -2341,7 +2342,7 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 	 */
 	m->io_tag = cpu_to_be16(ioim->iotag);
 	m->rport_hdl = ioim->itnim->rport->fw_handle;
-	m->io_timeout = bfa_cb_ioim_get_timeout(ioim->dio);
+	m->io_timeout = 0;
 
 	sge = &m->sges[0];
 	sgpg = ioim->sgpg;
@@ -2412,10 +2413,17 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 	 * set up I/O command parameters
 	 */
 	m->cmnd = cmnd_z0;
-	m->cmnd.lun = bfa_cb_ioim_get_lun(ioim->dio);
-	m->cmnd.iodir = bfa_cb_ioim_get_iodir(ioim->dio);
-	m->cmnd.cdb = *(scsi_cdb_t *)bfa_cb_ioim_get_cdb(ioim->dio);
-	fcp_dl = bfa_cb_ioim_get_size(ioim->dio);
+	int_to_scsilun(cmnd->device->lun, &m->cmnd.lun);
+	dmadir = cmnd->sc_data_direction;
+	if (dmadir == DMA_TO_DEVICE)
+		m->cmnd.iodir = FCP_IODIR_WRITE;
+	else if (dmadir == DMA_FROM_DEVICE)
+		m->cmnd.iodir = FCP_IODIR_READ;
+	else
+		m->cmnd.iodir = FCP_IODIR_NONE;
+
+	m->cmnd.cdb = *(scsi_cdb_t *) cmnd->cmnd;
+	fcp_dl = scsi_bufflen(cmnd);
 	m->cmnd.fcp_dl = cpu_to_be32(fcp_dl);
 
 	/*
@@ -2439,7 +2447,7 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 		bfi_h2i_set(m->mh, BFI_MC_IOIM_IO, 0, bfa_lpuid(ioim->bfa));
 	}
 	if (itnim->seq_rec ||
-	    (bfa_cb_ioim_get_size(ioim->dio) & (sizeof(u32) - 1)))
+	    (scsi_bufflen(cmnd) & (sizeof(u32) - 1)))
 		bfi_h2i_set(m->mh, BFI_MC_IOIM_IO, 0, bfa_lpuid(ioim->bfa));
 
 	/*
@@ -2769,7 +2777,8 @@ bfa_ioim_profile_start(struct bfa_ioim_s *ioim)
 void
 bfa_ioim_profile_comp(struct bfa_ioim_s *ioim)
 {
-	u32 fcp_dl = bfa_cb_ioim_get_size(ioim->dio);
+	struct scsi_cmnd *cmnd = (struct scsi_cmnd *) ioim->dio;
+	u32 fcp_dl = scsi_bufflen(cmnd);
 	u32 index = bfa_ioim_get_index(fcp_dl);
 	u64 end_time = jiffies;
 	struct bfa_itnim_latency_s *io_lat =
@@ -2895,8 +2904,7 @@ bfa_ioim_start(struct bfa_ioim_s *ioim)
 	 * Obtain the queue over which this request has to be issued
 	 */
 	ioim->reqq = bfa_fcpim_ioredirect_enabled(ioim->bfa) ?
-			bfa_cb_ioim_get_reqq(ioim->dio) :
-			bfa_itnim_get_reqq(ioim);
+			BFA_FALSE : bfa_itnim_get_reqq(ioim);
 
 	bfa_sm_send_event(ioim, BFA_IOIM_SM_START);
 }
@@ -3186,7 +3194,7 @@ __bfa_cb_tskim_failed(void *cbarg, bfa_boolean_t complete)
 }
 
 static	bfa_boolean_t
-bfa_tskim_match_scope(struct bfa_tskim_s *tskim, lun_t lun)
+bfa_tskim_match_scope(struct bfa_tskim_s *tskim, struct scsi_lun lun)
 {
 	switch (tskim->tm_cmnd) {
 	case FCP_TM_TARGET_RESET:
@@ -3196,7 +3204,7 @@ bfa_tskim_match_scope(struct bfa_tskim_s *tskim, lun_t lun)
 	case FCP_TM_CLEAR_TASK_SET:
 	case FCP_TM_LUN_RESET:
 	case FCP_TM_CLEAR_ACA:
-		return (tskim->lun == lun);
+		return (!memcmp(&tskim->lun, &lun, sizeof(lun)));
 
 	default:
 		bfa_assert(0);
@@ -3213,7 +3221,9 @@ bfa_tskim_gather_ios(struct bfa_tskim_s *tskim)
 {
 	struct bfa_itnim_s *itnim = tskim->itnim;
 	struct bfa_ioim_s *ioim;
-	struct list_head	*qe, *qen;
+	struct list_head *qe, *qen;
+	struct scsi_cmnd *cmnd;
+	struct scsi_lun scsilun;
 
 	INIT_LIST_HEAD(&tskim->io_q);
 
@@ -3222,8 +3232,9 @@ bfa_tskim_gather_ios(struct bfa_tskim_s *tskim)
 	 */
 	list_for_each_safe(qe, qen, &itnim->io_q) {
 		ioim = (struct bfa_ioim_s *) qe;
-		if (bfa_tskim_match_scope
-			(tskim, bfa_cb_ioim_get_lun(ioim->dio))) {
+		cmnd = (struct scsi_cmnd *) ioim->dio;
+		int_to_scsilun(cmnd->device->lun, &scsilun);
+		if (bfa_tskim_match_scope(tskim, scsilun)) {
 			list_del(&ioim->qe);
 			list_add_tail(&ioim->qe, &tskim->io_q);
 		}
@@ -3234,8 +3245,9 @@ bfa_tskim_gather_ios(struct bfa_tskim_s *tskim)
 	 */
 	list_for_each_safe(qe, qen, &itnim->pending_q) {
 		ioim = (struct bfa_ioim_s *) qe;
-		if (bfa_tskim_match_scope
-			(tskim, bfa_cb_ioim_get_lun(ioim->dio))) {
+		cmnd = (struct scsi_cmnd *) ioim->dio;
+		int_to_scsilun(cmnd->device->lun, &scsilun);
+		if (bfa_tskim_match_scope(tskim, scsilun)) {
 			list_del(&ioim->qe);
 			list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
 			bfa_ioim_tov(ioim);
@@ -3494,7 +3506,8 @@ bfa_tskim_free(struct bfa_tskim_s *tskim)
  * @return None.
  */
 void
-bfa_tskim_start(struct bfa_tskim_s *tskim, struct bfa_itnim_s *itnim, lun_t lun,
+bfa_tskim_start(struct bfa_tskim_s *tskim, struct bfa_itnim_s *itnim,
+			struct scsi_lun lun,
 			enum fcp_tm_cmnd tm_cmnd, u8 tsecs)
 {
 	tskim->itnim	= itnim;
diff --git a/drivers/scsi/bfa/bfa_fcpim.h b/drivers/scsi/bfa/bfa_fcpim.h
index 18bdc44..7d0eaba 100644
--- a/drivers/scsi/bfa/bfa_fcpim.h
+++ b/drivers/scsi/bfa/bfa_fcpim.h
@@ -146,9 +146,9 @@ struct bfa_tskim_s {
 	struct bfa_s	*bfa;	/*  BFA module  */
 	struct bfa_fcpim_mod_s  *fcpim;	/*  parent fcpim module	*/
 	struct bfa_itnim_s	*itnim;	/*  i-t-n nexus for this IO  */
-	struct bfad_tskim_s	*dtsk;   /*  driver task mgmt cmnd	*/
-	bfa_boolean_t	notify;	/*  notify itnim on TM comp  */
-	lun_t	lun;	/*  lun if applicable	*/
+	struct bfad_tskim_s	*dtsk;  /*  driver task mgmt cmnd	*/
+	bfa_boolean_t	notify;		/*  notify itnim on TM comp  */
+	struct scsi_lun		lun;	/*  lun if applicable	*/
 	enum fcp_tm_cmnd	tm_cmnd;	/*  task management command  */
 	u16	tsk_tag;	/*  FWI IO tag	*/
 	u8	tsecs;	/*  timeout in seconds	*/
@@ -389,7 +389,7 @@ struct bfa_tskim_s	*bfa_tskim_alloc(struct bfa_s *bfa,
 					struct bfad_tskim_s *dtsk);
 void		bfa_tskim_free(struct bfa_tskim_s *tskim);
 void		bfa_tskim_start(struct bfa_tskim_s *tskim,
-				struct bfa_itnim_s *itnim, lun_t lun,
+				struct bfa_itnim_s *itnim, struct scsi_lun lun,
 				enum fcp_tm_cmnd tm, u8 t_secs);
 void		bfa_cb_tskim_done(void *bfad, struct bfad_tskim_s *dtsk,
 				  enum bfi_tskim_status tsk_status);
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index d24b7e4..8cc4451 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -21,7 +21,6 @@
 
 #include "bfad_drv.h"
 #include "bfad_im.h"
-#include "bfa_cb_ioim.h"
 #include "bfa_fcs.h"
 
 BFA_TRC_FILE(LDRV, IM);
@@ -257,6 +256,7 @@ bfad_im_target_reset_send(struct bfad_s *bfad, struct scsi_cmnd *cmnd,
 	struct bfa_tskim_s *tskim;
 	struct bfa_itnim_s *bfa_itnim;
 	bfa_status_t    rc = BFA_STATUS_OK;
+	struct scsi_lun scsilun;
 
 	tskim = bfa_tskim_alloc(&bfad->bfa, (struct bfad_tskim_s *) cmnd);
 	if (!tskim) {
@@ -273,7 +273,8 @@ bfad_im_target_reset_send(struct bfad_s *bfad, struct scsi_cmnd *cmnd,
 	cmnd->host_scribble = NULL;
 	cmnd->SCp.Status = 0;
 	bfa_itnim = bfa_fcs_itnim_get_halitn(&itnim->fcs_itnim);
-	bfa_tskim_start(tskim, bfa_itnim, (lun_t)0,
+	memset(&scsilun, 0, sizeof(scsilun));
+	bfa_tskim_start(tskim, bfa_itnim, scsilun,
 			    FCP_TM_TARGET_RESET, BFAD_TARGET_RESET_TMO);
 out:
 	return rc;
@@ -300,6 +301,7 @@ bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd)
 	int             rc = SUCCESS;
 	unsigned long   flags;
 	enum bfi_tskim_status task_status;
+	struct scsi_lun scsilun;
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	itnim = itnim_data->itnim;
@@ -326,8 +328,8 @@ bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd)
 	cmnd->SCp.ptr = (char *)&wq;
 	cmnd->SCp.Status = 0;
 	bfa_itnim = bfa_fcs_itnim_get_halitn(&itnim->fcs_itnim);
-	bfa_tskim_start(tskim, bfa_itnim,
-			    bfad_int_to_lun(cmnd->device->lun),
+	int_to_scsilun(cmnd->device->lun, &scsilun);
+	bfa_tskim_start(tskim, bfa_itnim, scsilun,
 			    FCP_TM_LUN_RESET, BFAD_LUN_RESET_TMO);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 
diff --git a/drivers/scsi/bfa/bfi.h b/drivers/scsi/bfa/bfi.h
index 27b33c7..e194484 100644
--- a/drivers/scsi/bfa/bfi.h
+++ b/drivers/scsi/bfa/bfi.h
@@ -399,7 +399,7 @@ union bfi_ioc_i2h_msg_u {
  */
 struct bfi_pbc_blun_s {
 	wwn_t		tgt_pwwn;
-	lun_t		tgt_lun;
+	struct scsi_lun	tgt_lun;
 };
 
 /*
diff --git a/drivers/scsi/bfa/bfi_ms.h b/drivers/scsi/bfa/bfi_ms.h
index 1028876..e0e5318 100644
--- a/drivers/scsi/bfa/bfi_ms.h
+++ b/drivers/scsi/bfa/bfi_ms.h
@@ -725,7 +725,7 @@ struct bfi_tskim_req_s {
 	struct bfi_mhdr_s  mh;	/*  Common msg header	*/
 	__be16	tsk_tag;	/*  task management tag	*/
 	u16	itn_fhdl;	/*  itn firmware handle	*/
-	lun_t	lun;	/*  LU number	*/
+	struct 	scsi_lun lun;	/*  LU number	*/
 	u8	tm_flags;	/*  see enum fcp_tm_cmnd	*/
 	u8	t_secs;	/*  Timeout value in seconds	*/
 	u8	rsvd[2];
-- 
1.7.2.1

