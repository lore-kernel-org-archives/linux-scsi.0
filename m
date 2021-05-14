Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33BE5C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 19:56:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1694361574
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 19:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbhENT5j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 15:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233039AbhENT5X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 15:57:23 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B795EC061760
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 12:56:11 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id t193so103606pgb.4
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 12:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UkDFp+qpXr8e/IPH+q/GA6xWp1P5OWM8HM7pN5Go3M4=;
        b=TCqi0Kw2ss084LFoQ2kakcgpaK+GfX8YTvinq9YkxEHMM4B3ZV+4VRSmLxTABWcdzP
         S8YmdYusvErElU7rrluoMOJkZHcPLRaw/UHD3R3SSHiT02UvC57jzZZ3KnKwRPT5uP8K
         mTvcVYA+mtcLQv20z2TdrA0xSeqf52WAU1GKdxKE02xxou+C66LPi05HhsGpGiUY5kk6
         FKKkI/BtS3n4pytiF6MxnNAnTLWpCSD8EtQ34KT1lMpRU2qMnS6boKyLaNTDf2OAlrj8
         NX3EMymn8JQnajo3gQ7r9uPbMLra8gyEBKzLyHEU/OQBCP4XHwSVDTx7VO5D9AklSXUD
         /Q6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UkDFp+qpXr8e/IPH+q/GA6xWp1P5OWM8HM7pN5Go3M4=;
        b=F3EfAWdujI8gfUYuCI5MLtUfD+ZTiyVdUM+tD86CcGPJkJg+Vzk80nzuRcn78qEOCF
         n9mp0t9umN1Rhpz8Oc/XgxNj/lziAHhsQhyyEUngoG54kddruch1iJXP+cyJOIeb584U
         ZetaFJe0NEhQEpbsPAKgSIt3KTZHIZBDmcOQCQ3pq17WgkLyxQYcRAKK+glBYQzQHuWt
         H+InnSDTXT3wfrmwFFfoiXYoa5FrG2eyR6sU2YMAxqNDg3dnGzOGcQxZtow5im0Yv4Uu
         t/GeTDikqONJP2ATrKRaYRJZ/pAnFHP6MGNPo5gWDmgIBh9QdQ48z1gyKjx3uh3uhIua
         HLUw==
X-Gm-Message-State: AOAM5304oceSCwcg2x5qUUXUpj33479+tes0MYXvOtT6sxKtRUdL4+P+
        B/XtzbVEMCuTeoUPa6g3FTJdos4Nb+Q=
X-Google-Smtp-Source: ABdhPJzAfasuJDyjwd0VHJveNE51tBxcq/AqLIi3A2I7K6ppoEw+Qsp2oVIcSk5UNtpt4Ns6zb4kWg==
X-Received: by 2002:aa7:9885:0:b029:28e:9f7f:f23 with SMTP id r5-20020aa798850000b029028e9f7f0f23mr48473687pfl.75.1621022170969;
        Fri, 14 May 2021 12:56:10 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id v15sm4961850pgc.57.2021.05.14.12.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 12:56:10 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 09/11] lpfc: Add a option to enable interlocked ABTS before job completion
Date:   Fri, 14 May 2021 12:55:57 -0700
Message-Id: <20210514195559.119853-10-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210514195559.119853-1-jsmart2021@gmail.com>
References: <20210514195559.119853-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Default behavior for the driver, when aborting an io, is to terminate
the io with the adapter. The adapter will initiate an ABTS to
terminate the exchange on the link and mark the exchange is terminated
so that no further use of the sgl or any traffic for the exchange is
worked on. Completion on the Abort is then posted to the driver, which
as the io is terminated can complete the I/O to the OS. This completion
may occur prior to the ABTS handshake completing on the wire. The ABTS
handshake can take a long time to complete with timeouts and retries
reaching 60+ seconds. Note: if retries fail, LOGO occurs.

Some devices want to ensure that the ABTS handshake fully completes
(this device has fully ack'd it) before the I/O completion is posted
back to the OS, where a failed i/o may be retried via a different path.

To support this behavior, an option was added to the driver to change
I/O completion from the Abort cmd completion to the Exchange termination
(aka ABTS) completion.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h      |  1 +
 drivers/scsi/lpfc/lpfc_attr.c | 11 +++++++++
 drivers/scsi/lpfc/lpfc_mbox.c |  3 ++-
 drivers/scsi/lpfc/lpfc_scsi.c | 45 ++++++++++++++++++++++++++++++-----
 4 files changed, 53 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index f8de0d10620b..487780ede17e 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -915,6 +915,7 @@ struct lpfc_hba {
 	uint32_t cfg_request_firmware_upgrade;
 	uint32_t cfg_suppress_link_up;
 	uint32_t cfg_rrq_xri_bitmap_sz;
+	u32      cfg_fcp_wait_abts_rsp;
 	uint32_t cfg_delay_discovery;
 	uint32_t cfg_sli_mode;
 #define LPFC_INITIALIZE_LINK              0	/* do normal init_link mbox */
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 0975a8b252a0..c5e96cb904c8 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3448,6 +3448,15 @@ LPFC_ATTR_R(enable_npiv, 1, 0, 1,
 LPFC_ATTR_R(fcf_failover_policy, 1, 1, 2,
 	"FCF Fast failover=1 Priority failover=2");
 
+/*
+ * lpfc_fcp_wait_abts_rsp: Modifies criteria for reporting completion of
+ * aborted IO.
+ * The range is [0,1]. Default value is 0
+ *      0, IO completes after ABTS issued (default).
+ *      1, IO completes after receipt of ABTS response or timeout.
+ */
+LPFC_ATTR_R(fcp_wait_abts_rsp, 0, 0, 1, "Wait for FCP ABTS completion");
+
 /*
 # lpfc_enable_rrq: Track XRI/OXID reuse after IO failures
 #	0x0 = disabled, XRI/OXID use not tracked.
@@ -6205,6 +6214,7 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_enable_npiv,
 	&dev_attr_lpfc_fcf_failover_policy,
 	&dev_attr_lpfc_enable_rrq,
+	&dev_attr_lpfc_fcp_wait_abts_rsp,
 	&dev_attr_nport_evt_cnt,
 	&dev_attr_board_mode,
 	&dev_attr_max_vpi,
@@ -7332,6 +7342,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_enable_npiv_init(phba, lpfc_enable_npiv);
 	lpfc_fcf_failover_policy_init(phba, lpfc_fcf_failover_policy);
 	lpfc_enable_rrq_init(phba, lpfc_enable_rrq);
+	lpfc_fcp_wait_abts_rsp_init(phba, lpfc_fcp_wait_abts_rsp);
 	lpfc_fdmi_on_init(phba, lpfc_fdmi_on);
 	lpfc_enable_SmartSAN_init(phba, lpfc_enable_SmartSAN);
 	lpfc_use_msi_init(phba, lpfc_use_msi);
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 1b40a3bbd1cd..eab991739e37 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -522,7 +522,8 @@ lpfc_init_link(struct lpfc_hba * phba,
 	}
 
 	/* Enable asynchronous ABTS responses from firmware */
-	mb->un.varInitLnk.link_flags |= FLAGS_IMED_ABORT;
+	if (phba->sli_rev == LPFC_SLI_REV3 && !phba->cfg_fcp_wait_abts_rsp)
+		mb->un.varInitLnk.link_flags |= FLAGS_IMED_ABORT;
 
 	/* NEW_FEATURE
 	 * Setting up the link speed
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index eefbb9b22798..b8bb012abb33 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -518,6 +518,7 @@ lpfc_sli4_io_xri_aborted(struct lpfc_hba *phba,
 	struct lpfc_nodelist *ndlp;
 	int rrq_empty = 0;
 	struct lpfc_sli_ring *pring = phba->sli4_hba.els_wq->pring;
+	struct scsi_cmnd *cmd;
 
 	if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP))
 		return;
@@ -553,6 +554,31 @@ lpfc_sli4_io_xri_aborted(struct lpfc_hba *phba,
 					psb->cur_iocbq.sli4_lxritag, rxid, 1);
 				lpfc_sli4_abts_err_handler(phba, ndlp, axri);
 			}
+
+			if (phba->cfg_fcp_wait_abts_rsp) {
+				spin_lock_irqsave(&psb->buf_lock, iflag);
+				cmd = psb->pCmd;
+				psb->pCmd = NULL;
+				spin_unlock_irqrestore(&psb->buf_lock, iflag);
+
+				/* The sdev is not guaranteed to be valid post
+				 * scsi_done upcall.
+				 */
+				if (cmd)
+					cmd->scsi_done(cmd);
+
+				/*
+				 * We expect there is an abort thread waiting
+				 * for command completion wake up the thread.
+				 */
+				spin_lock_irqsave(&psb->buf_lock, iflag);
+				psb->cur_iocbq.iocb_flag &=
+					~LPFC_DRIVER_ABORTED;
+				if (psb->waitq)
+					wake_up(psb->waitq);
+				spin_unlock_irqrestore(&psb->buf_lock, iflag);
+			}
+
 			lpfc_release_scsi_buf_s4(phba, psb);
 			if (rrq_empty)
 				lpfc_worker_wake_up(phba);
@@ -780,7 +806,8 @@ lpfc_release_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *psb)
 	qp = psb->hdwq;
 	if (psb->flags & LPFC_SBUF_XBUSY) {
 		spin_lock_irqsave(&qp->abts_io_buf_list_lock, iflag);
-		psb->pCmd = NULL;
+		if (!phba->cfg_fcp_wait_abts_rsp)
+			psb->pCmd = NULL;
 		list_add_tail(&psb->list, &qp->lpfc_abts_io_buf_list);
 		qp->abts_scsi_io_bufs++;
 		spin_unlock_irqrestore(&qp->abts_io_buf_list_lock, iflag);
@@ -4045,6 +4072,7 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	u32 logit = LOG_FCP;
 	u32 status, idx;
 	unsigned long iflags = 0;
+	u8 wait_xb_clr = 0;
 
 	/* Sanity check on return of outstanding command */
 	if (!lpfc_cmd) {
@@ -4096,8 +4124,11 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	lpfc_cmd->result = (wcqe->parameter & IOERR_PARAM_MASK);
 
 	lpfc_cmd->flags &= ~LPFC_SBUF_XBUSY;
-	if (bf_get(lpfc_wcqe_c_xb, wcqe))
+	if (bf_get(lpfc_wcqe_c_xb, wcqe)) {
 		lpfc_cmd->flags |= LPFC_SBUF_XBUSY;
+		if (phba->cfg_fcp_wait_abts_rsp)
+			wait_xb_clr = 1;
+	}
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	if (lpfc_cmd->prot_data_type) {
@@ -4329,6 +4360,8 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 		lpfc_io_ktime(phba, lpfc_cmd);
 	}
 #endif
+	if (wait_xb_clr)
+		goto out;
 	lpfc_cmd->pCmd = NULL;
 	spin_unlock(&lpfc_cmd->buf_lock);
 
@@ -4343,8 +4376,8 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	lpfc_cmd->cur_iocbq.iocb_flag &= ~LPFC_DRIVER_ABORTED;
 	if (lpfc_cmd->waitq)
 		wake_up(lpfc_cmd->waitq);
+out:
 	spin_unlock(&lpfc_cmd->buf_lock);
-
 	lpfc_release_scsi_buf(phba, lpfc_cmd);
 }
 
@@ -4398,11 +4431,10 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 
 	lpfc_cmd->result = (pIocbOut->iocb.un.ulpWord[4] & IOERR_PARAM_MASK);
 	lpfc_cmd->status = pIocbOut->iocb.ulpStatus;
-	/* pick up SLI4 exhange busy status from HBA */
+	/* pick up SLI4 exchange busy status from HBA */
+	lpfc_cmd->flags &= ~LPFC_SBUF_XBUSY;
 	if (pIocbOut->iocb_flag & LPFC_EXCHANGE_BUSY)
 		lpfc_cmd->flags |= LPFC_SBUF_XBUSY;
-	else
-		lpfc_cmd->flags &= ~LPFC_SBUF_XBUSY;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	if (lpfc_cmd->prot_data_type) {
@@ -4601,6 +4633,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 		lpfc_io_ktime(phba, lpfc_cmd);
 	}
 #endif
+
 	/* The sdev is not guaranteed to be valid post scsi_done upcall. */
 	cmd->scsi_done(cmd);
 
-- 
2.26.2

