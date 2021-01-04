Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56E1BC433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:04:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A46F207BC
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbhADSEQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 13:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbhADSEQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 13:04:16 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFEDC0617A0
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jan 2021 10:03:14 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id e2so19552144pgi.5
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jan 2021 10:03:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ChNI7Nh7LdTn+Mg7J4ELQadAqoqOXgUCYbQxrsAyz4Y=;
        b=FPISaJGhfaWhaDwzj1ZAvJhsZDnjnrqnFpK/YfzT98tvSRM8CfxvB9Set3846Tx8um
         U2sm+zqZjoVOXg548s1hVmsBUiVOh6ZygnPfb6dJUHas6SzfjhxSG7uTcNRMGDcB9qSa
         gIYjCupIHcOr3dXSv+RRvmqc/eFrO6nQddzG5F0/asLo1colBNoLZEneAgs2mH68ZXYw
         tii8FXbocOAim3HXOJwCEDknHZlrOWMwb01IPZPtsk1e1BZ91v4enQEXKqIJQBv6c8oX
         qXb8gmObnMy08N1dKf+c/6xGPpCIS0vTHofxe3QyiJLD5eri09tHrQ9yZggrSWKCTe+n
         kueg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ChNI7Nh7LdTn+Mg7J4ELQadAqoqOXgUCYbQxrsAyz4Y=;
        b=JJGad+Us0OAiokPyO3Kr5cGlYokEpfs5FAlHaaeMz2Q3ZAW5oR2di+gGBFS0/BTsK0
         ICm3/w/YiNuQ7EXZKcMHYnXV02WLLTdyc+H6e8j20y1UHyIPwlmnW1ZsZvaM4JcCQe2x
         80cfj6CkW9htfeX0ySZnYurQo8Z5Av++T/R7m5KaY1Auro5QMHb9ELx61bKPneJVL9ln
         UOjeLkCPqAKPR+ECZFe9bdT9vcemEqCtGRoqW4QTHk9w2JEvExtjleU7tBUx1aXGpy85
         eaShfTt+W9uX+nnczIltyxUeigmrT+FGvsc4Kgih0nnhRdeU4X1ydTH5cgjIvrQ3C+x0
         31JA==
X-Gm-Message-State: AOAM531eqCiDkgO/eenX+Tn95tOvLgvjTREq7JpJoH0xP7OY7UIXAiog
        PT1k2LJAYc64MJUhRcT50ykvn3sRay0=
X-Google-Smtp-Source: ABdhPJw/utxtOrB4pFrD9xbIqSkzKPam55/zw6Y6RVcILnHJNYZknWKd9Hw0FuKCrxjgMR5ViSsMEw==
X-Received: by 2002:a63:eb0c:: with SMTP id t12mr17558107pgh.7.1609783394083;
        Mon, 04 Jan 2021 10:03:14 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q23sm57570885pfg.18.2021.01.04.10.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 10:03:13 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 09/15] lpfc: Fix target reset failing
Date:   Mon,  4 Jan 2021 10:02:34 -0800
Message-Id: <20210104180240.46824-10-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210104180240.46824-1-jsmart2021@gmail.com>
References: <20210104180240.46824-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Target reset is failed by the target as an invalid command.

The Target Reset TMF has been obsoleted in T10 for a while, but continues
to be used. On (newer) devices, the TMF is rejected causing the reset
handler to escalate to adapter resets.

Fix by having Target Reset TMF rejections be translated into a LOGO and
re-PLOGI with the target device. This provides the same semantic action
(although, if the device also supports nvme traffic, it will terminate
nvme traffic as well - but it's still recoverable).

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_disc.h |  3 +++
 drivers/scsi/lpfc/lpfc_els.c  |  7 +++++++
 drivers/scsi/lpfc/lpfc_scsi.c | 38 +++++++++++++++++++++++++++++++++--
 3 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index ea07afcb750a..4cea61b63fdf 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -135,14 +135,17 @@ struct lpfc_nodelist {
 	struct lpfc_scsicmd_bkt *lat_data;	/* Latency data */
 	uint32_t fc4_prli_sent;
 	uint32_t fc4_xpt_flags;
+	uint32_t upcall_flags;
 #define NLP_WAIT_FOR_UNREG    0x1
 #define SCSI_XPT_REGD         0x2
 #define NVME_XPT_REGD         0x4
+#define NLP_WAIT_FOR_LOGO     0x2
 
 
 	uint32_t nvme_fb_size; /* NVME target's supported byte cnt */
 #define NVME_FB_BIT_SHIFT 9    /* PRLI Rsp first burst in 512B units. */
 	uint32_t nlp_defer_did;
+	wait_queue_head_t *logo_waitq;
 };
 
 struct lpfc_node_rrq {
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index e099caa04535..c944f220406e 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2817,6 +2817,7 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	IOCB_t *irsp;
 	unsigned long flags;
 	uint32_t skip_recovery = 0;
+	int wake_up_waiter = 0;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
@@ -2824,6 +2825,10 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	irsp = &(rspiocb->iocb);
 	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~NLP_LOGO_SND;
+	if (ndlp->upcall_flags & NLP_WAIT_FOR_LOGO) {
+		wake_up_waiter = 1;
+		ndlp->upcall_flags &= ~NLP_WAIT_FOR_LOGO;
+	}
 	spin_unlock_irq(&ndlp->lock);
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
@@ -2889,6 +2894,8 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	 * Initiator, we are assuming the NPortID is not going to change.
 	 */
 
+	if (wake_up_waiter && ndlp->logo_waitq)
+		wake_up(ndlp->logo_waitq);
 	/*
 	 * If the node is a target, the handling attempts to recover the port.
 	 * For any other port type, the rpi is unregistered as an implicit
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 78f34b1af980..4ee890de556b 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5924,6 +5924,8 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 	struct lpfc_scsi_event_header scsi_event;
 	int status;
 	u32 logit = LOG_FCP;
+	unsigned long flags;
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
 
 	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
 	if (!rdata || !rdata->pnode) {
@@ -5942,10 +5944,10 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 			"0722 Target Reset rport failure: rdata x%px\n", rdata);
 		if (pnode) {
-			spin_lock_irq(&pnode->lock);
+			spin_lock_irqsave(&pnode->lock, flags);
 			pnode->nlp_flag &= ~NLP_NPR_ADISC;
 			pnode->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
-			spin_unlock_irq(&pnode->lock);
+			spin_unlock_irqrestore(&pnode->lock, flags);
 		}
 		lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
 					  LPFC_CTX_TGT);
@@ -5965,6 +5967,38 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 					FCP_TARGET_RESET);
 	if (status != SUCCESS)
 		logit =  LOG_TRACE_EVENT;
+	spin_lock_irqsave(&pnode->lock, flags);
+	if (status != SUCCESS &&
+	    (!(pnode->upcall_flags & NLP_WAIT_FOR_LOGO)) &&
+	     !pnode->logo_waitq) {
+		pnode->logo_waitq = &waitq;
+		pnode->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
+		pnode->nlp_flag |= NLP_ISSUE_LOGO;
+		pnode->upcall_flags |= NLP_WAIT_FOR_LOGO;
+		spin_unlock_irqrestore(&pnode->lock, flags);
+		lpfc_unreg_rpi(vport, pnode);
+		wait_event_timeout(waitq,
+				   (!(pnode->upcall_flags & NLP_WAIT_FOR_LOGO)),
+				    msecs_to_jiffies(vport->cfg_devloss_tmo *
+				    1000));
+
+		if (pnode->upcall_flags & NLP_WAIT_FOR_LOGO) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
+				"0725 SCSI layer TGTRST failed & LOGO TMO "
+				" (%d, %llu) return x%x\n", tgt_id,
+				 lun_id, status);
+			spin_lock_irqsave(&pnode->lock, flags);
+			pnode->upcall_flags &= ~NLP_WAIT_FOR_LOGO;
+		} else {
+			spin_lock_irqsave(&pnode->lock, flags);
+		}
+		pnode->logo_waitq = NULL;
+		spin_unlock_irqrestore(&pnode->lock, flags);
+		status = SUCCESS;
+	} else {
+		status = FAILED;
+		spin_unlock_irqrestore(&pnode->lock, flags);
+	}
 
 	lpfc_printf_vlog(vport, KERN_ERR, logit,
 			 "0723 SCSI layer issued Target Reset (%d, %llu) "
-- 
2.26.2

