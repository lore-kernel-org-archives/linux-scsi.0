Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF58C433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:30:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE65F610A4
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbhDJRbL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 13:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234947AbhDJRbH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 13:31:07 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8CDC06138A
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:53 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id m18so2030912plc.13
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XR1HC+zYLOeAD8O+1lAM5t1k2D1EZBtg/XDeWdVECCw=;
        b=bs6ErTcFE4QcJ/WpFKUlqJ8sLvQ3InDCyYb4MiFtLuAteDw1ArZEkfOJJ3G9BLiW/c
         d92fRQpORnI9og/amzP8n5XGBU5eZdMwSeXN23E09ezBuF9RsNsZhOtLtUcTxd74q3il
         SSOUqxjN5GZaIm4ff8K7uunl7veeb0TjbePvQExsq6pnr51A2QJRtUZF1ij/JfqVv6xj
         ArA7q4kISN8LKjsg7VURj7EG601cR0FwZEAX3x1s3Hea8l59MMWAUauaKfNVRrxFftK/
         WZiAfo6uKG4c+Hug3HtnyZ8+wtmaqUBbaymQZQDeMYzDIb1iSnwiOAJaGk2Bun7IbJ9C
         NMPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XR1HC+zYLOeAD8O+1lAM5t1k2D1EZBtg/XDeWdVECCw=;
        b=nTff8n7ZWAbCbQdmsSOl9t92yMEPUIA82j7ZoU1n4PrFnLqwKDEK0zy9OeFxAVMurw
         pSqlNJkMk9mzKgUGsIcNJHrkJqyAtqjQwG86ktPnKibd6aOCTzMNVpmAfDQhJRYTanBP
         aKeFcuMlIvgtVn2i3Mb7txn3DjLZSYXK5fxICpKP7+iFipuQzsigArjHN95exnNp3Vfq
         Nwb1oHWXQKXyenSmyBFHN4l2ulvzoD4z27pyW6K4Dp15tnNAFoayuR/ZfL6GzWrBw1/d
         1p3GOCWedPOHZ5vkSTe4Jrd75oD6ajck2Jn7KqSwDxcg0c4/2MZtmBXnUFs5+/kZz+xg
         U6Xw==
X-Gm-Message-State: AOAM531FaTHNGcTyBCipKDcNUDT6eDg6Qn282NfIUpbNAO8JMdS3IMzX
        fcExkRS/wIt2l1cT9d5ydF/xlsDhjaA=
X-Google-Smtp-Source: ABdhPJwtCRFaS3Yda/zQGZq1fppCgf0Sc9FxLRHtNo6neIUjEC97J2LkmOBiis5zOJs20wRn8l9xmw==
X-Received: by 2002:a17:902:a9c2:b029:e7:147f:76a1 with SMTP id b2-20020a170902a9c2b02900e7147f76a1mr18858920plr.5.1618075852276;
        Sat, 10 Apr 2021 10:30:52 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x25sm5578861pfu.189.2021.04.10.10.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 10:30:52 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 13/16] lpfc: Standardize discovery object logging format
Date:   Sat, 10 Apr 2021 10:30:31 -0700
Message-Id: <20210410173034.67618-14-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210410173034.67618-1-jsmart2021@gmail.com>
References: <20210410173034.67618-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Note: %px use is limited to discovery objects in order to aid core
analysis.

Code inspection showed lpfc was using three different pointer formats
when logging discovery object pointers.

Standardize the pointer format to x%px.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c      |  2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c | 10 +++++-----
 drivers/scsi/lpfc/lpfc_init.c    |  2 +-
 drivers/scsi/lpfc/lpfc_nvme.c    | 16 ++++++++--------
 drivers/scsi/lpfc/lpfc_scsi.c    |  2 +-
 drivers/scsi/lpfc/lpfc_sli.c     |  6 +++---
 6 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 8da9e18a1fde..b9bccd8fc355 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -777,7 +777,7 @@ lpfc_prep_node_fc4type(struct lpfc_vport *vport, uint32_t Did, uint8_t fc4_type)
 
 			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 					 "0239 Skip x%06x NameServer Rsp "
-					 "Data: x%x x%x %p\n",
+					 "Data: x%x x%x x%px\n",
 					 Did, vport->fc_flag,
 					 vport->fc_rscn_id_cnt, ndlp);
 		}
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 03977a2268fe..f5a898c2c904 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -102,20 +102,20 @@ lpfc_rport_invalid(struct fc_rport *rport)
 
 	rdata = rport->dd_data;
 	if (!rdata) {
-		pr_err("**** %s: NULL dd_data on rport %p SID x%x\n",
+		pr_err("**** %s: NULL dd_data on rport x%px SID x%x\n",
 		       __func__, rport, rport->scsi_target_id);
 		return -EINVAL;
 	}
 
 	ndlp = rdata->pnode;
 	if (!rdata->pnode) {
-		pr_err("**** %s: NULL ndlp on rport %p SID x%x\n",
+		pr_err("**** %s: NULL ndlp on rport x%px SID x%x\n",
 		       __func__, rport, rport->scsi_target_id);
 		return -EINVAL;
 	}
 
 	if (!ndlp->vport) {
-		pr_err("**** %s: Null vport on ndlp %p, DID x%x rport %p "
+		pr_err("**** %s: Null vport on ndlp x%px, DID x%x rport x%px "
 		       "SID x%x\n", __func__, ndlp, ndlp->nlp_DID, rport,
 		       rport->scsi_target_id);
 		return -EINVAL;
@@ -168,7 +168,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 		ndlp->nlp_sid, ndlp->nlp_DID, ndlp->nlp_flag);
 
 	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NODE,
-			 "3181 dev_loss_callbk x%06x, rport %p flg x%x "
+			 "3181 dev_loss_callbk x%06x, rport x%px flg x%x "
 			 "load_flag x%x refcnt %d\n",
 			 ndlp->nlp_DID, ndlp->rport, ndlp->nlp_flag,
 			 vport->load_flag, kref_read(&ndlp->kref));
@@ -6168,7 +6168,7 @@ lpfc_nlp_release(struct kref *kref)
 		ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_type);
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
-			"0279 %s: ndlp:%p did %x refcnt:%d rpi:%x\n",
+			 "0279 %s: ndlp: x%px did %x refcnt:%d rpi:%x\n",
 			 __func__, ndlp, ndlp->nlp_DID,
 			 kref_read(&ndlp->kref), ndlp->nlp_rpi);
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index c80fd7d49f6e..1e4c792bb660 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3552,7 +3552,7 @@ lpfc_offline_prep(struct lpfc_hba *phba, int mbx_action)
 					lpfc_printf_vlog(vports[i], KERN_INFO,
 						 LOG_NODE | LOG_DISCOVERY,
 						 "0011 Free RPI x%x on "
-						 "ndlp: %p did x%x\n",
+						 "ndlp: x%px did x%x\n",
 						 ndlp->nlp_rpi, ndlp,
 						 ndlp->nlp_DID);
 					lpfc_sli4_free_rpi(phba, ndlp->nlp_rpi);
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 4d78eadb65c0..41e49f61fac2 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -190,14 +190,14 @@ lpfc_nvme_remoteport_delete(struct nvme_fc_remote_port *remoteport)
 
 	ndlp = rport->ndlp;
 	if (!ndlp) {
-		pr_err("**** %s: NULL ndlp on rport %p remoteport %p\n",
+		pr_err("**** %s: NULL ndlp on rport x%px remoteport x%px\n",
 		       __func__, rport, remoteport);
 		goto rport_err;
 	}
 
 	vport = ndlp->vport;
 	if (!vport) {
-		pr_err("**** %s: Null vport on ndlp %p, ste x%x rport %p\n",
+		pr_err("**** %s: Null vport on ndlp x%px, ste x%x rport x%px\n",
 		       __func__, ndlp, ndlp->nlp_state, rport);
 		goto rport_err;
 	}
@@ -209,7 +209,7 @@ lpfc_nvme_remoteport_delete(struct nvme_fc_remote_port *remoteport)
 	 * calling state machine to remove the node.
 	 */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_DISC,
-			"6146 remoteport delete of remoteport %p\n",
+			"6146 remoteport delete of remoteport x%px\n",
 			remoteport);
 	spin_lock_irq(&ndlp->lock);
 
@@ -317,7 +317,7 @@ __lpfc_nvme_ls_req_cmp(struct lpfc_hba *phba,  struct lpfc_vport *vport,
 	status = bf_get(lpfc_wcqe_c_status, wcqe) & LPFC_IOCB_STATUS_MASK;
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_DISC,
-			 "6047 NVMEx LS REQ %px cmpl DID %x Xri: %x "
+			 "6047 NVMEx LS REQ x%px cmpl DID %x Xri: %x "
 			 "status %x reason x%x cmd:x%px lsreg:x%px bmp:x%px "
 			 "ndlp:x%px\n",
 			 pnvme_lsreq, ndlp ? ndlp->nlp_DID : 0,
@@ -339,7 +339,7 @@ __lpfc_nvme_ls_req_cmp(struct lpfc_hba *phba,  struct lpfc_vport *vport,
 	else
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "6046 NVMEx cmpl without done call back? "
-				 "Data %px DID %x Xri: %x status %x\n",
+				 "Data x%px DID %x Xri: %x status %x\n",
 				pnvme_lsreq, ndlp ? ndlp->nlp_DID : 0,
 				cmdwqe->sli4_xritag, status);
 	if (ndlp) {
@@ -707,7 +707,7 @@ __lpfc_nvme_ls_abort(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_DISC | LOG_NVME_ABTS,
 			 "6040 NVMEx LS REQ Abort: Issue LS_ABORT for lsreq "
-			 "x%p rqstlen:%d rsplen:%d %pad %pad\n",
+			 "x%px rqstlen:%d rsplen:%d %pad %pad\n",
 			 pnvme_lsreq, pnvme_lsreq->rqstlen,
 			 pnvme_lsreq->rsplen, &pnvme_lsreq->rqstdma,
 			 &pnvme_lsreq->rspdma);
@@ -736,7 +736,7 @@ __lpfc_nvme_ls_abort(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		return 0;
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_DISC | LOG_NVME_ABTS,
-			 "6213 NVMEx LS REQ Abort: Unable to locate req x%p\n",
+			 "6213 NVMEx LS REQ Abort: Unable to locate req x%px\n",
 			 pnvme_lsreq);
 	return -EINVAL;
 }
@@ -1839,7 +1839,7 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "6144 Outstanding NVME I/O Abort Request "
 				 "still pending on nvme_fcreq x%px, "
-				 "lpfc_ncmd %px xri x%x\n",
+				 "lpfc_ncmd x%px xri x%x\n",
 				 pnvme_fcreq, lpfc_nbuf,
 				 nvmereq_wqe->sli4_xritag);
 		goto out_unlock;
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 85f6a066de5a..eefbb9b22798 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4292,7 +4292,7 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 		u32 *lp = (u32 *)cmd->sense_buffer;
 
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
-				 "9039 Iodone <%d/%llu> cmd x%p, error "
+				 "9039 Iodone <%d/%llu> cmd x%px, error "
 				 "x%x SNS x%x x%x Data: x%x x%x\n",
 				 cmd->device->id, cmd->device->lun, cmd,
 				 cmd->result, *lp, *(lp + 3), cmd->retries,
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 11145a78dbe9..06ccc0157bd8 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2656,7 +2656,7 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 				vport,
 				KERN_INFO, LOG_MBOX | LOG_DISCOVERY,
 				"1438 UNREG cmpl deferred mbox x%x "
-				"on NPort x%x Data: x%x x%x %px x%x x%x\n",
+				"on NPort x%x Data: x%x x%x x%px x%x x%x\n",
 				ndlp->nlp_rpi, ndlp->nlp_DID,
 				ndlp->nlp_flag, ndlp->nlp_defer_did,
 				ndlp, vport->load_flag, kref_read(&ndlp->kref));
@@ -2721,7 +2721,7 @@ lpfc_sli4_unreg_rpi_cmpl_clr(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 					 vport, KERN_INFO, LOG_MBOX | LOG_SLI,
 					 "0010 UNREG_LOGIN vpi:%x "
 					 "rpi:%x DID:%x defer x%x flg x%x "
-					 "%px\n",
+					 "x%px\n",
 					 vport->vpi, ndlp->nlp_rpi,
 					 ndlp->nlp_DID, ndlp->nlp_defer_did,
 					 ndlp->nlp_flag,
@@ -3023,7 +3023,7 @@ lpfc_nvme_unsol_ls_handler(struct lpfc_hba *phba, struct lpfc_iocbq *piocb)
 				goto out_fail;
 
 			lpfc_printf_log(phba, KERN_ERR, LOG_NODE,
-					"6206 NVMET unsol ls_req ndlp %p "
+					"6206 NVMET unsol ls_req ndlp x%px "
 					"DID x%x xflags x%x refcnt %d\n",
 					ndlp, ndlp->nlp_DID,
 					ndlp->fc4_xpt_flags,
-- 
2.26.2

